#! /bin/bash

testPrependToEmptyList() {
  assertEquals 4 "$(list | prepend 4)"
}

testPrependToOneElementList() {
  assertEquals "4 1" "$(list 1 | prepend 4 | unlist)"
}

testPrependToList() {
  assertEquals "4 1 2 3 4 5" "$(list 1 2 3 4 5 | prepend 4 | unlist)"
}

. ./shunit2-init.sh