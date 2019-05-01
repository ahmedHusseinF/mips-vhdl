const { createInterface } = require("readline");
const { createReadStream, writeFileSync } = require("fs");

function hex2bin(num) {
  const x = parseInt(num, 16);
  if (x === NaN) throw new TypeError(`${x} isn't a number`);
  return x.toString(2).padStart(16, "0");
}

const filename = process.argv[2] || "test.asm";

const rl = createInterface(createReadStream(filename));

/** @type {Map<string, string>} */
const cmdMap = new Map();

/** @type {string[]} */
const commands = [];

rl.on("line", line => {
  const parts = line.split("#");

  const cmd = parts[0];
  if (cmd.length == 0) {
    return;
  }
  console.log(cmd);
  commands.push(cmd);
});

let str = "";

rl.on("close", () => {
  for (let i = 0; i < commands.length; i++) {
    const parts = commands[i].split(" ");
    const cmd = parts[0].toLowerCase();
  }
});

/* for (let i = 0; i < 2 ** 20 - 1; i++) {
  str += "1000100010001000\n";
} */

// writeFileSync("ram.txt", str);
