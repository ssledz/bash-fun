#!/bin/bash

drop() {
  command tail -n +$(($1 + 1))
}

take() {
  command head -n ${1}
}

tail() {
  drop 1
}

head() {
  take 1
}

last() {
  command tail -n 1
}

list() {
  for i in "$@"; do
    echo "$i"
  done
}

unlist() {
  cat - | xargs
}

append() {
  cat -
  list "$@"
}

prepend() {
  list "$@"
  cat -
}


lambda() {

  lam() {
    local arg
    while [[ $# -gt 0 ]]; do
      arg="$1"
      shift
      if [[ $arg = '.' ]]; then
        echo "$@"
        return
      else
        echo "read $arg;"
      fi
    done
  }

  eval $(lam "$@")

}

λ() {
  lambda "$@"
}

map() {
  local x
  while read x; do
    echo "$x" | "$@"
  done
}

foldl() {
  local f="$@"
  local acc
  read acc
  while read elem; do
    acc="$({ echo $acc; echo $elem; } | $f )"
  done
  echo "$acc"
}

foldr() {
  local f="$@"
  local acc
  read acc

  foldrr() {
    local elem
    read elem && acc=$(foldrr)
    acc="$({ echo $acc; echo $elem; } | $f )"
    echo "$acc"
  }

  foldrr
}

scanl() {
  local f="$@"
  local acc
  read acc
  echo $acc
  while read elem; do
    acc="$({ echo $acc; echo $elem; } | $f )"
    echo "$acc"
  done
}

mul() {
  ( set -f; echo $(($1 * $2)) )
}

add() {
  echo $(($1 + $2))
}

sub() {
  echo $(($1 - $2))
}

div() {
  echo $(($1 / $2))
}

mod() {
  echo $(($1 % $2))
}


sum() {
  foldl lambda a b . 'echo $(($a + $b))'
}

product() {
  foldl lambda a b . 'echo $(mul $a $b)'
}

factorial() {
  seq 1 $1 | product
}

splitc() {
  cat - | sed 's/./&\n/g'
}

join() {
  local delim=$1
  local pref=$2
  local suff=$3
  echo $pref$(cat - | foldl lambda a b . 'echo $a$delim$b')$suff
}

revers() {
  foldl lambda a b . 'append $b $a'
}

revers_str() {
  cat - | splitc | revers | join
}

try() {
  local f="$@"
  local cmd=$(cat -)
  ret="$(2>&1 $cmd)"
  local status=$?
  list "$cmd" $status $(list $ret | join \#) | $f
}

ret() {
  echo $1
}

filter() {
  local x
  while read x; do
    ret=$(echo "$x" | "$@")
    $ret && echo $x
  done
}

strip() {
  local arg=$1
  cat - | map lambda l . 'ret ${l##'$arg'}' | map lambda l . 'ret ${l%%'$arg'}'
}

buff() {
  local cnt=-1
  for x in $@; do
    [[ $x = '.' ]] && break
    cnt=$(add $cnt 1)
  done
  local args=''
  local i=$cnt
  while read arg; do
    [[ $i -eq 0 ]] && list $args | "$@" && i=$cnt && args=''
    args="$args $arg"
    i=$(sub $i 1)
  done
  [[ ! -z $args ]] && list $args | "$@"
}

tup() {
  list "$@" | join , '(' ')'
}

tupx() {
  if [[ $# -eq 1 ]]; then
    local arg
    read arg
    tupx "$1" "$arg"
  else
    local n=$1
    shift
    list "$@" | strip '\(' | strip '\)' | unlist | cut -d',' -f${n}
  fi
}

tupl() {
  tupx 1 "$@"
}

tupr() {
  tupx 2 "$@"
}

zip() {
  local list=$*
  cat - | while read x; do
    y=$(list $list | take 1)
    tup $x $y
    list=$(list $list | drop 1)
  done
}

function curry() {
  exportfun=$1; shift
  fun=$1; shift
  params=$*
  cmd=$"function $exportfun() {
      more_params=\$*;
      $fun $params \$more_params;
  }"
  eval $cmd
}

