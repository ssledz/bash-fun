#! /bin/bash

testHeadFromList() {
  assertEquals 1 $(list {1..10} | head)
  assertEquals 5 $(list 5 6 7 | head)
}

testHeadFromOneElementList() {
  assertEquals 1 $(list 1 | head)
}

testHeadFromEmptyList() {
  assertEquals "" "$(list | head)"
}

. ./shunit2-init.sh