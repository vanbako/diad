#!/bin/bash
tests=(
  "MOVu 15"
  "ADDu 15"
  "SUBu 13"
)
for test in "${tests[@]}"; do
  read OPCO TICKS <<< "$test"
  iverilog -DDEBUGOPC -DDEBUGGP -DDEBUGFLAGS -DTICKS=${TICKS} -DMEM_HEX_FILE="\"tst/hex/${OPCO}.hex\"" -g2012 -o test.vvp src/*.v
  vvp test.vvp | grep -v -e "WARNING" -e '\$finish' | tail -n +13 >tst/out/${OPCO}.out
  sdiff tst/out/${OPCO}.out tst/dif/${OPCO}.out >/dev/null && echo "${OPCO} Ok" || echo "${OPCO} Bad"
done
