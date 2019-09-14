#! /bin/bash

testIsint() {
  assertEquals 'true' $(isint 1)
  assertEquals 'true' $(isint -1)
  assertEquals 'false' $(isint a)
  assertEquals 'false' $(isint "")
  assertEquals '1 2 3 4 5' "$(list 1 a 2 b 3 c 4 d 5 e | filter lambda x . 'isint $x' | unlist )"
  assertEquals '1 2'       "$(list 1 a 2 b 3 c 4 d 5 e | filter lambda x . '($(isint $x) &&  [[ $x -le 2 ]] && ret true) || ret false ' | unlist )"

  assertEquals 'false' $(not isint 1)
  assertEquals 'true' $(not isint a)
}

testIsempty() {
  assertEquals 'true' $(isempty "")
  assertEquals 'false' $(isempty a)

  assertEquals 'true' $(not isempty a)
  assertEquals 'false' $(not isempty "")
}

testIsfile() {
  f=$(mktemp)

  assertEquals 'true' $(isfile $f)
  assertEquals 'false' $(isfile $f.xxx)
  assertEquals 'false' $(isfile "")
  assertEquals 'true' $(not isfile $f.xxx)

  assertEquals 'false' $(isnonzerofile $f)
  echo hello world >$f
  assertEquals 'true' $(isnonzerofile $f)

  assertEquals 'true' $(iswritable $f)
  chmod 400 $f
  assertEquals 'false' $(iswritable $f)

  assertEquals 'true' $(isreadable $f)
  chmod 200 $f
  assertEquals 'false' $(isreadable $f)

  chmod 600 $f
  rm $f
}

testIsdir() {
  assertEquals 'true' $(isdir .)
  assertEquals 'false' $(isdir sir_not_appearing_in_this_film)
}

. ./shunit2-init.sh
