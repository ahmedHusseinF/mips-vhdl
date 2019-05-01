const readline = require("readline");
const fs = require("fs");

function hex2bin(num) {
  const x = parseInt(num, 16);
  if (x === NaN) throw new TypeError(`${x} isn't a number`);
  return x.toString(2).padStart(16, "0");
}

const filename = process.argv[2] || "test.asm";

const rl = readline.createInterface(fs.createReadStream(filename));

/** @type {Map<string, string>} */
const cmdMap = new Map();

const commands = {};

rl.on("line", line => {
  const parts = line.split("#");

  const cmd = parts[0];
  if (cmd.length == 0) {
    return;
  }
  console.log(cmd);
});

let str = "";

/* for (let i = 0; i < 2 ** 32 - 1; i++) {
  str += "1000100010001000\n";
} */

fs.writeFileSync("ram.txt", str);
