#! /bin/bash

testTake9From10() {
  assertEquals "1 2 3 4 5 6 7 8 9" "$(list {1..10} | take 9 | unlist)"
}

testTake8From10() {
  assertEquals "1 2 3 4 5 6 7 8" "$(list {1..10} | take 8 | unlist)"
}

testTakeAll() {
  assertEquals "1 2 3 4 5 6 7 8 9 10" "$(list {1..10} | take 10 | unlist)"
}

testTakeMoreThanAvailable() {
  assertEquals "1 2 3 4 5 6 7 8 9 10" "$(list {1..10} | take 15 | unlist)"
}

testTakeZero() {
  assertEquals "" "$(list {1..10} | take 0 | unlist)"
}

. ./shunit2-init.sh