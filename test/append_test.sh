#! /bin/bash

testAppendToEmptyList() {
  assertEquals 4 "$(list | append 4)"
}

testAppendToOneElementList() {
  assertEquals "1 4" "$(list 1 | append 4 | unlist)"
}

testAppendToList() {
  assertEquals "1 2 3 4 5 4" "$(list 1 2 3 4 5 | append 4 | unlist)"
}

. ./shunit2-init.sh