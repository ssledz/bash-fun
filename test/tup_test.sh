#! /bin/bash

testTupIfEmpty() {
  assertEquals '()' $(tup '')
}

testTupIfOneElement() {
  assertEquals '(1)' $(tup 1)
  assertEquals '(")' $(tup '"')
  assertEquals "(')" $(tup "'")
  assertEquals "(u002c)" $(tup ",")
  assertEquals "(u002cu002c)" $(tup ",,")
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
  assertEquals '' "$(tup '' | tupx 1)"
  assertEquals '' "$(tup '' | tupx 5)"
}

testTupxIfZeroIndex() {
  assertEquals '' "$(tup 1 3 | tupx 0 2>/dev/null)"
}

testTupxIfSpecialChars() {
  assertEquals ',' "$(tup ',' | tupx 1)"
  assertEquals ',,' "$(tup ',,' | tupx 1)"
  assertEquals '(' "$(tup '(' | tupx 1)"
  assertEquals ')' "$(tup ')' | tupx 1)"
  assertEquals '()' "$(tup '()' | tupx 1)"
  assertEquals '(' "$(tup '(' ')' | tupx 1)"
  assertEquals '(' "$(tup '(' '(' | tupx 1)"
  assertEquals ')' "$(tup ')' ')' | tupx 1)"
  assertEquals ',' "$(tup 'u002c' | tupx 1)"
  assertEquals ',,' "$(tup 'u002cu002c' | tupx 1)"
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
  assertEquals 'foo bar' "$(tup 'foo bar' 1 'one' 2 | tupl)"
}

testTupr() {
  assertEquals '5' "$(tup 4 5 | tupr)"
  assertEquals '5' "$(tup 1 4 5 | tupr)"
  assertEquals '5' "$(tup 5 | tupr)"
}

testNTup() {
  assertEquals '(KFlRbz0sWWdvPSkK,Ywo=)' "$(ntup $(ntup a b) c)"
  assertEquals '(YQo=,Ygo=)' "$(ntupl '(KFlRbz0sWWdvPSkK,Ywo=)')"
  assertEquals 'a' "$(ntupl '(YQo=,Ygo=)')"
  assertEquals 'b' "$(ntupr '(YQo=,Ygo=)')"
  assertEquals 'c' "$(ntupr '(KFlRbz0sWWdvPSkK,Ywo=)')"
  assertEquals 'a' "$(ntup $(ntup a b) c | ntupx 1 | ntupx 1)"
  assertEquals 'b' "$(ntup $(ntup a b) c | ntupx 1 | ntupx 2)"
  assertEquals 'c' "$(ntup $(ntup a b) c | ntupx 2)"
  assertEquals 'a b' "$(ntup $(ntup a b) c | ntupx 1 | ntupx 1,2 | unlist)"
}

. ./shunit2-init.sh
