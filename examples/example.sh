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

list a b c d | foldl lambda acc el . 'echo -n $acc-$el'
list '' a b c d | foldr lambda acc el . 'if [[ ! -z $acc ]]; then echo -n $acc-$el; else echo -n $el; fi'

seq 1 4 | foldl lambda acc el . 'echo $(($acc + $el))'

#1 - 2 - 3 - 4
seq 1 4 | foldl lambda acc el . 'echo $(($acc - $el))'
#1 - 4 - 3 - 2
seq 1 4 | foldr lambda acc el . 'echo $(($acc - $el))'

#1 + (1 + 1) * 2 + (4 + 1) * 3 + (15 + 1) * 4 = 64

seq 1 4 | foldl lambda acc el . 'echo $(mul $(($acc + 1)) $el)'

#1 + (1 + 1) * 4 + (8 + 1) * 3 + (27 + 1) * 2 = 56
seq 1 4 | foldr lambda acc el . 'echo $(mul $(($acc + 1)) $el)'

tup a 1
tupl $(tup a 1)
tupr $(tup a 1)
tup a 1 | tupl
tup a 1 | tupr

seq 1 10 | buff lambda a b . 'echo $(($a + $b))'
echo 'XX'
seq 1 10 | buff lambda a b c d e . 'echo $(($a + $b + $c + $d + $e))'

list a b c d e f | zip $(seq 1 10)

echo
list a b c d e f | zip $(seq 1 10) | last | tupr

arg='[key1=value1,key2=value2,key3=value3]'
get() {
  local pidx=$1
  local idx=$2
  local arg=$3
  echo $arg | tr -d '[]' | cut -d',' -f$idx | cut -d'=' -f$pidx
}

curry get_key get 1
curry get_value get 2

get_key 1 $arg
get_value 1 $arg

seq 1 3 | map lambda a . 'tup $(get_key $a $arg) $(get_value $a $arg)'

echo 'ls /home' | try λ cmd status ret . 'echo $cmd [$status]; echo $ret'
echo '/home' | try λ cmd status ret . 'echo $cmd [$status]; echo $ret'

seq 1 5 | scanl lambda a b . 'echo $(($a + $b))'
seq 1 5 | scanl lambda a b . 'echo $(($a + $b))' | last

seq 2 3 | map lambda a . 'seq 1 $a' | join , [ ]
list a b c | map lambda a . 'echo $a; echo $a | tr a-z A-z' | join , [ ]

echo 0 | cat - <(curl -s https://raw.githubusercontent.com/ssledz/bash-fun/v1.1.1/src/fun.sh) | \
    map lambda a . 'list $a' | foldl lambda acc el . 'echo $(($acc + 1))'

echo 0 | cat - <(curl -s curl -s https://raw.githubusercontent.com/ssledz/bash-fun/v1.1.1/src/fun.sh) \
            | foldl lambda acc el . 'echo $(($acc + 1))'


factorial() {
    fact_iter() {
        local product=$1
        local counter=$2
        local max_count=$3
        if [[ $counter -gt $max_count ]]; then
            echo $product
        else
            fact_iter $(echo $counter\*$product | bc) $(($counter + 1)) $max_count
        fi
    }

    fact_iter 1 1 $1
}

factorial_trampoline() {
    fact_iter() {
        local product=$1
        local counter=$2
        local max_count=$3
        if [[ $counter -gt $max_count ]]; then
            res $product
        else
            call fact_iter $(echo $counter\*$product | bc) $(($counter + 1)) $max_count
        fi
    }

    with_trampoline fact_iter 1 1 $1
}

echo Factorial test

time factorial 30
time factorial_trampoline 30

time factorial 60
time factorial_trampoline 60