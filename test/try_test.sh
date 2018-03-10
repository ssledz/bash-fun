#! /bin/bash

testTry() {
  assertEquals 1 "$(echo 'expr 2 / 2' | try lambda _ . 'ret 0')"
  assertEquals 0 "$(echo 'expr 2 / 0' | try lambda _ . 'ret 0')"
  assertEquals 2 "$(echo 'expr 2 / 0' | try lambda status . 'ret $status')"
  assertEquals 'already up to date' "$(echo 'echo already up to date' | try lambda _ . 'ret error')"
  assertEquals 'error exit 1' "$(try λ  _ . 'echo "error"; echo exit 1' < <(echo fgit pull) | unlist)"
}

. ./shunit2-init.sh