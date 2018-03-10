#! /bin/bash

testTupIfEmpty() {
  assertEquals '()' $(tup)
}

testTupIfOneElement() {
  assertEquals '(1)' $(tup 1)
  assertEquals '(")' $(tup '"')
  assertEquals "(')" $(tup "'")
  assertEquals "(u002c)" $(tup ",")
  assertEquals "(()" $(tup "(")
  assertEquals "())" $(tup ")")
}

testTupHappyPath() {
  assertEquals '(1,2,3,4,5)' $(tup 1 2 3 4 5)
  assertEquals '(a-1,b-2,c-3)' $(tup 'a-1' 'b-2' 'c-3')
  assertEquals '(a b,c d e,f)' "$(tup 'a b' 'c d e' 'f')"
}

testTupxHappyPath() {
  assertEquals '4' $(tup 4 5 1 4 | tupx 1)
  assertEquals '5' $(tup 4 5 1 4 | tupx 2)
  assertEquals '1' $(tup 4 5 1 4 | tupx 3)
  assertEquals '4' $(tup 4 5 1 4 | tupx 4)

}

testTupxIfEmpty() {
  assertEquals '' "$(tup | tupx 1)"
  assertEquals '' "$(tup | tupx 5)"
}

testTupxIfZeroIndex() {
  assertEquals '' "$(tup 1 3 | tupx 0 2>/dev/null)"
}

testTupxIfSpecialChars() {
  assertEquals ',' "$(tup ',' | tupx 1)"
  assertEquals '(' "$(tup '(' | tupx 1)"
  assertEquals ')' "$(tup ')' | tupx 1)"
  assertEquals '()' "$(tup '()' | tupx 1)"
  assertEquals '(' "$(tup '(' ')' | tupx 1)"
  assertEquals '(' "$(tup '(' '(' | tupx 1)"
  assertEquals ')' "$(tup ')' ')' | tupx 1)"
  assertEquals ',' "$(tup 'u002c' | tupx 1)"
}

testTupxRange() {
  assertEquals '4 5' "$(tup 4 5 1 4 | tupx 1-2 | unlist)"
  assertEquals '4 4' "$(tup 4 5 1 4 | tupx 1,4 | unlist)"
  assertEquals '4 5 4' "$(tup 4 5 1 4 | tupx 1,2,4 | unlist)"
}

testTupl() {
  assertEquals '4' "$(tup 4 5 | tupl)"
  assertEquals '4' "$(tup 4 5 6 | tupl)"
  assertEquals '6' "$(tup 6 | tupl)"
}

testTupr() {
  assertEquals '5' "$(tup 4 5 | tupr)"
  assertEquals '5' "$(tup 1 4 5 | tupr)"
  assertEquals '5' "$(tup 5 | tupr)"
}

. ./shunit2-init.sh