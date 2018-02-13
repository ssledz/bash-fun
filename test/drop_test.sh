#! /bin/bash

testDrop9From10() {
  assertEquals 10 $(list {1..10} | drop 9)
}

testDrop8From10() {
  assertEquals "9 10" "$(list {1..10} | drop 8 | unlist)"
}

testDropAll() {
  assertEquals "" "$(list {1..10} | drop 10)"
}

testDropMoreThanAvailable() {
  assertEquals "" "$(list {1..10} | drop 15)"
}

testDropZero() {
  assertEquals "1 2 3 4 5 6 7 8 9 10" "$(list {1..10} | drop 0 | unlist)"
}

. ./shunit2-init.sh