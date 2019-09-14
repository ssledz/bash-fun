#! /bin/bash

testLTailFrom10() {
  assertEquals "2 3 4 5 6 7 8 9 10" "$(list {1..10} | ltail | unlist)"
}

testLTailFromOneElementList() {
  assertEquals "" "$(list 1 | ltail)"
}

testLTailFromEmptyList() {
  assertEquals "" "$(list | ltail)"
}

. ./shunit2-init.sh
