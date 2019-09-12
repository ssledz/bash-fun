#!/bin/bash

drop() {
  command tail -n +$(($1 + 1))
}

take() {
  command head -n ${1}
}

ltail() {
  drop 1
}

lhead() {
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
  if [[ $1 != "λ" ]] && [[ $1 != "lambda" ]]; then

    local has_dollar=$(list $@ | grep '\$' | wc -l)

    if [[ $has_dollar -ne 0 ]]; then
      args=$(echo $@ | sed -e 's/\$/\$a/g')
      map λ a . $args
    else
      map λ a . "$@"' $a'
    fi
  else
    local x
    while read x; do
      echo "$x" | "$@"
    done
  fi
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
  local zero
  read zero
  foldrr() {
    local elem

    if read elem; then
        acc=$(foldrr)
#        [[ -z $acc ]] && echo $elem && return
    else
        echo $zero && return
    fi

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

plus() {
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

catch() {
  local f="$@"
  local cmd=$(cat -)
  local val=$(2>&1 eval "$cmd"; echo $?)
  local cnt=$(list $val | wc -l)
  local status=$(list $val | last)
  $f < <(list "$cmd" $status $(list $val | take $((cnt - 1)) | unlist | tup))
}

try() {
  local f="$@"
  catch lambda cmd status val . '[[ $status -eq 0 ]] && tupx 1- $val | unlist || { '"$f"' < <(list $status); }'
}

ret() {
  echo $@
}

filter() {
  local x
  while read x; do
    ret=$(echo "$x" | "$@")
    $ret && echo $x
  done
}

pass() {
  echo > /dev/null
}

dropw() {
  local x
  while read x && $(echo "$x" | "$@"); do
    pass
  done
  [[ ! -z $x ]] && { echo $x; cat -; }
}

peek() {
  local x
  while read x; do
    ([ $# -eq 0 ] && 1>&2 echo $x || 1>&2 "$@" < <(echo $x))
    echo $x
  done
}

stripl() {
  local arg=$1
  cat - | map lambda l . 'ret ${l##'$arg'}'
}

stripr() {
  local arg=$1
  cat - | map lambda l . 'ret ${l%%'$arg'}'
}

strip() {
  local arg=$1
  cat - | stripl "$arg" | stripr "$arg"
}

buff() {
  local cnt=-1
  for x in $@; do
    [[ $x = '.' ]] && break
    cnt=$(plus $cnt 1)
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
  if [[ $# -eq 0 ]]; then
    local arg
    read arg
    tup $arg
  else
    list "$@" | map lambda x . 'echo ${x//,/u002c}' | join , '(' ')'
  fi
}

tupx() {
  if [[ $# -eq 1 ]]; then
    local arg
    read arg
    tupx "$1" "$arg"
  else
    local n=$1
    shift
    echo "$@" | stripl '(' | stripr ')' | cut -d',' -f${n} | tr ',' '\n' | map lambda x . 'echo ${x//u002c/,}'
  fi
}

tupl() {
  tupx 1 "$@"
}

tupr() {
  tupx 1- "$@" | last
}

ntup() {
  if [[ $# -eq 0 ]]; then
    local arg
    read arg
    ntup $arg
  else
    list "$@" | map lambda x . 'echo "$x" | base64 --wrap=0 ; echo' | join , '(' ')'
  fi
}

ntupx() {
  if [[ $# -eq 1 ]]; then
    local arg
    read arg
    ntupx "$1" "$arg"
  else
    local n=$1
    shift
    echo "$@" | stripl '(' | stripr ')' | cut -d',' -f${n} | tr , '\n' | map lambda x . 'echo "$x" | base64 -d'
  fi
}

ntupl() {
  ntupx 1 "$@"
}

ntupr() {
  ntupx 1- "$@" | last
}

lzip() {
  local list=$*
  cat - | while read x; do
    y=$(list $list | take 1)
    tup $x $y
    list=$(list $list | drop 1)
  done
}

curry() {
  exportfun=$1; shift
  fun=$1; shift
  params=$*
  cmd=$"function $exportfun() {
      more_params=\$*;
      $fun $params \$more_params;
  }"
  eval $cmd
}

with_trampoline() {
  local f=$1; shift
  local args=$@
  while [[ $f != 'None' ]]; do
    ret=$($f $args)
#    echo $ret
    f=$(tupl $ret)
    args=$(echo $ret | tupx 2- | tr ',' ' ')
  done
  echo $args
}

res() {
    local value=$1
    tup "None" $value
}

call() {
    local f=$1; shift
    local args=$@
    tup $f $args
}

maybe() {
  if [[ $# -eq 0 ]]; then
    local arg
    read arg
    maybe "$arg"
  else
    local x="$*"
    local value=$(echo $x | strip)
    if [[ ${#value} -eq 0 ]]; then
      tup Nothing
    else
      tup Just "$value"
    fi
  fi
}

maybemap() {
  local x
  read x
  if [[ $(tupl $x) = "Nothing" ]]; then
    echo $x
  else
    local y=$(tupr "$x")
    local r=$(echo "$y" | map "$@")
    maybe "$r"
  fi
}

maybevalue() {
  local default="$*"
  local x
  read x
  if [[ $(tupl $x) = "Nothing" ]]; then
      echo "$default"
  else
      echo $(tupr $x)
  fi
}


# commonly used predicates for filter
# e.g.  list 1 a 2 b 3 c | filter lambda x . 'isint $x'

# inverse another test, e.g. "not isint $x"
not() {
  local r=$("$@" 2>/dev/null)
  $r && ret false || ret true
}

isint() {
  [ "$1" -eq "$1" ] 2>/dev/null && ret true || ret false
}

isempty() {
  [ -z "$1" ] && ret true || ret false
}

isfile() {
  [ -f "$1" ] && ret true || ret false
}

isnonzerofile() {
  [ -s "$1" ] && ret true || ret false
}

isreadable() {
  [ -r "$1" ] && ret true || ret false
}

iswritable() {
  [ -w "$1" ] && ret true || ret false
}

isdir() {
  [ -d "$1" ] && ret true || ret false
}
