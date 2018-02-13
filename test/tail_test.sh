#! /bin/bash

testTailFrom10() {
  assertEquals "2 3 4 5 6 7 8 9 10" "$(list {1..10} | tail | unlist)"
}

testTailFromOneElementList() {
  assertEquals "" "$(list 1 | tail)"
}

testTailFromEmptyList() {
  assertEquals "" "$(list | tail)"
}

. ./shunit2-init.sh