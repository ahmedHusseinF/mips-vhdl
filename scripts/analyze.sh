#! /bin/bash


for FILE in src/*.vhd
do
  ghdl -a $FILE
done

echo 'Analyzed all src files successfully'