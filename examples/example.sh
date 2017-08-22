#!/bin/bash

source ../src/fun.sh

seq 1 4 | sum
seq 1 4 | product
factorial 4
seq 1 4 | scanl lambda a b . 'echo $(add $a $b)'
echo map mul
seq 1 4 | map lambda a . 'echo $(mul $a 2)'
echo map sub
seq 1 4 | map lambda a . 'echo $(sub $a 2)'
echo map add
seq 1 4 | map lambda a . 'echo $(add $a 2)'
echo map div
seq 1 4 | map lambda a . 'echo $(div $a 2)'
echo map mod
seq 1 4 | map lambda a . 'echo $(mod $a 2)'
echo 'list & head'
list 1 2 3 4 5 | head
list {1..2} | append {3..4} | prepend {99..102}
list {1..2} | unlist
list {1..10} | head
list {1..10} | drop 7
list {1..10} | take 3
list {1..10} | last
list {1..10} | map λ a . 'echo $(mul $a 2)'

id() { 
  λ x . '$x' 
}

id <<< 'echo :)'

foobar() { 
  product | λ l . 'list {1..$l}' | sum | md5sum 
}

list {1,2,3} | foobar

echo -n abcdefg | revers_str                         # gfedcba
echo -n abcdefg | splitc | join , '[' ']'            # [a,b,c,d,e,f,g]
echo -n abcdefg | splitc | revers | join , '[' ']'   # [g,f,e,d,c,b,a]

echo -n ' abcdefg' | splitc | foldr lambda a b . 'echo $a$b'  # gfedcba

echo 'ls' | try λ cmd status ret . 'echo $cmd [$status]; echo $ret'

list {1..10} | filter lambda a . '[[ $(mod $a 2) -eq 0 ]] && ret true || ret false' | join , '[' ']'  # [2,4,6,8,10]

function add() {
    expr $1 + $2
}


curry add3 add 3
add3 9