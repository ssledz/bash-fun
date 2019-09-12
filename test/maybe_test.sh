#! /bin/bash

testMaybe() {
  assertEquals '(Just,1)' "$(maybe 1)"
  assertEquals '(Just,1)' "$(echo 1 | maybe)"
  assertEquals '(Nothing)' "$(maybe '')"
  assertEquals '(Nothing)' "$(maybe '    ')"
  assertEquals '(Nothing)' "$(maybe '    ' '  ' '   ')"
  assertEquals '(Nothing)' "$(echo | maybe)"
  assertEquals '(Just,1 2 3)' "$(maybe 1 2 3)"
  assertEquals '(Just,1 2 3)' "$(echo 1 2 3 | maybe)"
}

testMaybemap() {
  assertEquals '(Just,3)'  "$(echo 1 | maybe | maybemap lambda a . 'echo $(( a + 1 ))' | maybemap lambda a . 'echo $(( a + 1 ))')"
  assertEquals '(Nothing)' "$(echo   | maybe | maybemap lambda a . 'echo $(( a + 1 ))' | maybemap lambda a . 'echo $(( a + 1 ))')"

  assertEquals '(Nothing)'  "$(echo 1 | maybe | maybemap lambda a . 'echo $(( a + 1 ))' | maybemap lambda a . 'echo')"
  assertEquals '(Nothing)'  "$(echo 1 | maybe | maybemap lambda a . 'echo $(( a + 1 ))' | maybemap lambda a . 'echo' | maybemap lambda a . 'echo $(( a + 1 ))')"
}

testMaybevalue() {
  assertEquals 3 "$(echo 1 | maybe | maybemap lambda a . 'echo $(( a + 1 ))' | maybemap lambda a . 'echo $(( a + 1 ))' | maybevalue 0)"
  assertEquals 0 "$(echo   | maybe | maybemap lambda a . 'echo $(( a + 1 ))' | maybemap lambda a . 'echo $(( a + 1 ))' | maybevalue 0)"
  assertEquals 'a b c' "$(echo   | maybe | maybemap lambda a . 'echo $(( a + 1 ))' | maybemap lambda a . 'echo $(( a + 1 ))' | maybevalue a b c)"
}


. ./shunit2-init.sh
