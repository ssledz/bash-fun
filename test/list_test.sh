#! /bin/bash

testListFromOneElement() {
  assertEquals 1 $(list 1)
}

testListFromEmpty() {
  assertEquals "" "$(list)"
}

testListUnlist() {
  assertEquals "1 3 6" "$(list 1 3 6 | unlist)"
}

testList() {
  list=$(cat <<EOF
1
3
6
EOF
)
  assertEquals "$list" "$(list 1 3 6)"
}

. ./shunit2-init.sh