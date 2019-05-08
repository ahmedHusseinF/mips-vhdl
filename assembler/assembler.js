const { createInterface } = require("readline");
const { createReadStream, writeFileSync } = require("fs");

/*
-- 15-----0
-- 31-----16
-- op code 15 - 11
-- 1st operand 10 - 8
-- 2nd operand 7 - 5
-- Imm 31 - 16
-- EA 4 - 0 + 31 - 21
*/

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
  // split the comment
  const parts = line.split("#");

  const cmd = parts[0];
  if (cmd.length == 0) {
    // only a comment line
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

      const isNextCommand = commands.some(command => {
        return cmds[i + 1].toLowerCase().includes(command);
      });

      if (isNextCommand) {
        // code follows
        memPointer = place;
      } else {
        // mem location follows
        memoryMap.set(place, hex2bin(cmds[++i]));
      }
      continue; // already processed the .org
    }

    const cmdOpCode = commands.indexOf(cmd);
    if (cmdOpCode === -1) {
      throw new Error(`${cmd} doesn't exist in the predefined commands`);
    }

    let commandBinary = hex2bin(cmdOpCode, 5);
    let using32bit = false;

    if (oneOp.indexOf(cmd) > -1) {
      const firstOp = parts[1];
      // if cmd isn't in any of those
      if (["nop", "setc", "clrc"].indexOf(cmd) == -1)
        commandBinary += reg2bin(firstOp, 3);
    } else if (twoOp.indexOf(cmd) > -1) {
      const rSrc = parts[1].replace(",", "");
      const rDst = parts[2];
      // if cmd is one of those
      if (["shl", "shr"].indexOf(cmd) > -1) {
        commandBinary += reg2bin(rSrc);
        memoryMap.set(memPointer + 1, hex2bin(rDst, 16).padStart(16, "0"));
        using32bit = true;
      } else {
        commandBinary += reg2bin(rSrc) + reg2bin(rDst);
      }
    } else if (memOp.indexOf(cmd) > -1) {
      const rDst = parts[1].replace(",", "");
      commandBinary += reg2bin(rDst);

      if (["push", "pop"].indexOf(cmd) > -1) {
        // already put rDst
      } else if (cmd == "ldm") {
        const imm = parts[2];
        memoryMap.set(memPointer + 1, hex2bin(imm, 16).padStart(16, "0"));
        using32bit = true;
      } else if (["ldd", "std"].indexOf(cmd) > -1) {
        const ea = parts[2];
        const eaBinary = hex2bin(ea, 20);
        commandBinary += eaBinary.substr(0, 4);
        memoryMap.set(memPointer + 1, eaBinary.substr(4, 20).padStart(16, "0"));
        using32bit = true;
      }
    } else if (branchOp.indexOf(cmd) > -1) {
      const rDst = parts[1];

      // if cmd isn't ret or rti
      if (["ret", "rti"].indexOf(cmd) == -1) {
        commandBinary += reg2bin(rDst);
      }
    } else {
      // reset && int
      console.error(`I don't know what to do with ${cmd}`);
    }

    memoryMap.set(memPointer, commandBinary.padEnd(16, "0"));
    memPointer = using32bit ? memPointer + 2 : memPointer + 1;
    using32bit = false; // always reset to default mode, 16 bit
  }

  const maxMemPointer = Math.max(...[...memoryMap.keys()]);

  for (let i = 0; i <= maxMemPointer; i++) {
    if (memoryMap.has(i)) {
      mem += memoryMap.get(i);
    } else {
      mem += "0000000000000000";
    }
    if (i != maxMemPointer) mem += "\n";
  }

  let i = 0;
  for (let x of mem.split("\n")) {
    console.log(i++, x);
  }

  writeFileSync(`${process.argv[2].split("/")[1].split(".")[0]}_ram.txt`, mem);
}
