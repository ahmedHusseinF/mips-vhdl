#! /bin/bash



ghdl -e --std=08 --ieee=synopsys $1

echo "Elaborated $1 successfully"

