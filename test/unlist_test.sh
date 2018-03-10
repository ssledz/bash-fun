#! /bin/bash

testUnlistFromList() {
  list=$(cat <<EOF
1
2
6
EOF
)
  assertEquals "1 2 6" "$(echo $list | unlist)"
}

testUnlistFromEmptyList() {
  assertEquals "" "$(echo | unlist)"
}

testUnlistFromOneElementList() {
  assertEquals "1" "$(echo 1 | unlist)"
}

. ./shunit2-init.sh