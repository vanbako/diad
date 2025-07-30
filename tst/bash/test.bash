#!/bin/bash
tests=(
  "MOVu 15"
  "ADDu 15"
  "SUBu 13"
  "LDu 15"
)
param="$1"
shift
if [ "$#" -eq 0 ]; then
  debug_opts=("OPC" "GP" "FLAGS")
else
  debug_opts=("$@")
fi
skip_lines=$(( ${#debug_opts[@]} * 4 + 1 ))
if [ -z "$param" ]; then
  echo "No test parameter provided."
else
  for test in "${tests[@]}"; do
    read OPCO TICKS <<< "$test"
    if [ -n "$param" ] && [ "$OPCO" != "$param" ]; then
      continue
    fi
    debug_flags=""
    for flag in "${debug_opts[@]}"; do
      debug_flags="$debug_flags -DDEBUG${flag}"
    done
    iverilog $debug_flags -DTICKS=${TICKS} -DMEM_HEX_FILE="\"tst/hex/${OPCO}.hex\"" -g2012 -o test.vvp src/*.v
    vvp test.vvp | grep -v -e "WARNING" -e '\$finish' | tail -n +$skip_lines
  done
fi