#!/bin/bash

testMapEmptyList() {
  assertEquals "" "$(list | map lambda x . 'echo $(($x + 1))')"
}

testMapEmptyList_ifNoArgumentsInLambda() {
  assertEquals "" "$(list | map lambda . 'echo 3')"
}

testMapOneElementList() {
  assertEquals "3" "$(list 2 | map lambda x . 'echo $(($x + 1))')"
}

testMapList() {
  assertEquals "2 3 4 5 6" "$(list {1..5} | map lambda x . 'echo $(($x + 1))' | unlist)"
}

testMapList_ifNoArgumentsInLambda() {
  assertEquals "9 9 9 9 9" "$(list {1..5} | map lambda . 'echo 9' | unlist)"
}

testMapList_ifManyArgumentsInLambda() {
  list {1..5} | map lambda x y . 'echo $(($x + $y))' 2> /dev/null \
    && fail "There should be syntax error, because map is an one argument operation"
}

testFlatMap() {
    assertEquals "1 2 3 2 3 3" "$(list {1..3} | map lambda x . 'seq $x 3' | unlist)"
    assertEquals "d e h l l l o o r w" "$(list hello world | map lambda x . 'command fold -w 1 <<< $x' | sort | unlist)"
}

. ./shunit2-init.sh