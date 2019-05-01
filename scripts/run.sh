#! /bin/bash


./scripts/analyze.sh

./scripts/elaborate.sh $1

ghdl -r --std=08 --ieee=synopsys $1 --vcd=$1_graph.vcd

gtkwave $1_graph.vcd

echo "Attempted to run $1"