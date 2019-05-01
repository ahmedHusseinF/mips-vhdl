#! /bin/bash


for FILE in src/*.vhd
do
  ghdl -a --std=08 --ieee=synopsys $FILE
  echo "Analyzed $FILE successfully"
done

for FILE in tests/*.vhd
do
  ghdl -a --std=08 --ieee=synopsys $FILE
  echo "Analyzed $FILE successfully"
done

echo 'Analyzed all src/ and tests/ files successfully\n'