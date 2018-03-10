#! /bin/bash

testCatchIfSuccess() {
  assertEquals 1 "$(echo 'expr 2 / 2' | catch lambda cmd status val . '[[ $status -eq 0 ]] && tupl $val || echo 0')"
}

testCatchIfError() {
  assertEquals 0 $(echo 'expr 2 / 0' | catch lambda cmd status val . '[[ $status -eq 0 ]] && tupl $val || echo 0')
  assertEquals 'cmd=expr 2 / 0,status=2,val=(expr:,division,by,zero)' "$(echo 'expr 2 / 0' | echo 'expr 2 / 0' | LANG=en catch lambda cmd status val . 'echo cmd=$cmd,status=$status,val=$val')"
}

testCatchEdgeCases() {
  assertEquals 1 "$(echo 'expr 2 / 2' | catch lambda _ _ val . 'tupl $val')"
  assertEquals 'expr 2 / 2' "$(echo 'expr 2 / 2' | catch lambda cmd . 'ret $cmd')"
  assertEquals 'expr 2 / 2,0' "$(echo 'expr 2 / 2' | catch lambda cmd status . 'ret $cmd,$status')"
  assertEquals 'expr 2 / 0,2' "$(echo 'expr 2 / 0' | catch lambda cmd status . 'ret $cmd,$status')"
}

. ./shunit2-init.sh