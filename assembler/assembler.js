const { createInterface } = require("readline");
const { createReadStream, writeFileSync } = require("fs");

/**
 * @param {string} str
 */
function hex2bin(str, padding = 16) {
  const num = parseInt(str, 16);
  if (Number.isNaN(num)) throw new TypeError(`${num} isn't a number`);
  return num.toString(2).padStart(padding, "0");
}

/** @param {string} reg */
function reg2bin(reg) {
  const match = reg.match(/[0-7]/g);
  return hex2bin(match[0], 3);
}

const filename = process.argv[2] || "test.asm";
/** @type {string[]} */
const commands = [
  "nop",
  "setc",
  "clrc",
  "not",
  "inc",
  "dec",
  "out",
  "in",
  "mov",
  "add",
  "mul",
  "sub",
  "and",
  "or",
  "shl",
  "shr",
  "push",
  "pop",
  "ldm",
  "ldd",
  "std",
  "jz",
  "jn",
  "jc",
  "jmp",
  "call",
  "ret",
  "rti",
  "reset",
  "int"
];

/** @type {string[]} */
const cmds = [];

const oneOp = ["nop", "setc", "clrc", "not", "inc", "dec", "out", "in"];
const twoOp = ["mov", "add", "mul", "sub", "and", "or", "shl", "shr"];
const memOp = ["push", "pop", "ldm", "ldd", "std"];
const branchOp = ["jz", "jn", "jc", "jmp", "call", "ret", "rti"];
// const ioSignal = ["reset", "int"];

const rl = createInterface(createReadStream(filename));

rl.on("line", line => {
  const parts = line.split("#");

  const cmd = parts[0];
  if (cmd.length == 0) {
    return;
  }
  console.log(cmd);
  cmds.push(cmd.trim());
});

let mem = "";
let memPointer = 0;
/** @type {Map<number, string>} */
const memoryMap = new Map();

rl.on("close", () => {
  main().catch(console.error);
});

async function main() {
  for (let i = 0; i < cmds.length; ++i) {
    const parts = cmds[i].split(" ");
    const cmd = parts[0].toLowerCase();

    if (cmd === ".org") {
      const place = parseInt(parts[1], 16);

      if (!Number.isNaN(parseInt(cmds[i + 1], 16))) {
        // mem location follows
        memoryMap.set(place, hex2bin(cmds[++i]));
      } else {
        // code follows
        memPointer = place;
      }
      continue; // already processed the .org
    }

    const cmdOpCode = commands.indexOf(cmd);
    if (cmdOpCode === -1) {
      throw new Error(`${cmd} doesn't exist in the predefined commands`);
    }

    let commandBinary = hex2bin(cmdOpCode, 5);

    if (oneOp.indexOf(cmd) > -1) {
      const firstOp = parts[1];
      if (["nop", "setc", "clrc"].indexOf(cmd) == -1)
        commandBinary += reg2bin(firstOp);
    } else if (twoOp.indexOf(cmd) > -1) {
      const rSrc = parts[1].replace(",", "");
      const rDst = parts[2];

      if (["shl", "shr"].indexOf(cmd) > -1) {
        // TODO: put the Immediate value
        rDst = hex2bin(rDst);
      }

      // TODO: insert those
    } else if (memOp.indexOf(cmd) > -1) {
      const rDst = parts[1];
      // TODO: get the rest of operands conditonally
    } else if (branchOp.indexOf(cmd) > -1) {
    } else {
      // reset && int
    }

    memoryMap.set(memPointer, commandBinary.padStart(16, "0"));
    memPointer++;
  }

  const maxMemPointer = Math.max(...[...memoryMap.keys()]);

  for (let i = 0; i < maxMemPointer; i++) {
    if (memoryMap.has(i)) {
      mem += memoryMap.get(i) + "\n";
    } else {
      mem += "0000000000000000\n";
    }
  }

  console.log(mem);

  // writeFileSync("ram.txt", str);
}
