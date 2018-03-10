#! /bin/bash

testLastFromList() {
  assertEquals 10 $(list {1..10} | last)
  assertEquals 7 $(list 5 6 7 | last)
}

testLastFromOneElementList() {
  assertEquals 1 $(list 1 | last)
}

testLastFromEmptyList() {
  assertEquals "" "$(list | last)"
}

. ./shunit2-init.sh