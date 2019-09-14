#! /bin/bash

testLHeadFromList() {
  assertEquals 1 $(list {1..10} | lhead)
  assertEquals 5 $(list 5 6 7 | lhead)
}

testLHeadFromOneElementList() {
  assertEquals 1 $(list 1 | lhead)
}

testLHeadFromEmptyList() {
  assertEquals "" "$(list | lhead)"
}

. ./shunit2-init.sh
