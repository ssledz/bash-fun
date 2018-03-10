#! /bin/bash

testTry() {
  assertEquals 1 "$(echo 'expr 2 / 2' | try lambda _ . 'ret 0')"
  assertEquals 0 "$(echo 'expr 2 / 0' | try lambda _ . 'ret 0')"
  assertEquals 2 "$(echo 'expr 2 / 0' | try lambda status . 'ret $status')"
}

. ./shunit2-init.sh