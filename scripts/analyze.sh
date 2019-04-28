#! /bin/bash


for FILE in src/*.vhd
do
  ghdl -a $FILE
  echo "Analyzed $FILE successfully"
done

echo 'Analyzed all src files successfully'