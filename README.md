# Introduction

[Introduction to fun.sh library](http://ssledz.github.io/presentations/bash-fun.html#/)

# Quick start

```bash
#!/bin/bash
. <(test -e fun.sh || curl -Ls https://raw.githubusercontent.com/ssledz/bash-fun/master/src/fun.sh > fun.sh; cat fun.sh)

seq 1 4 | sum
```

# Functions overview
|||||||
|------|------|------|------|------|------|
|**append**|**buff**|**call**|**catch**|**curry**|**div**|
|**drop**|**dropw**|**factorial**|**filter**|**foldl**|**foldr**|
|**isint**|**isempty**|**isfile**|**isnonzerofile**|**isreadable**|**iswritable**|
|**isdir**|**join**|**lambda**|**last**|**lhead**|**list**|
|**ltail**|**lzip**|**map**|**maybe**|**maybemap**|**maybevalue**|
|**mod**|**mul**|**not**|**ntup**|**ntupl**|**ntupr**|
|**ntupx**|**peek**|**plus**|**prepend**|**product**|**ret**|
|**res**|**revers**|**revers_str**|**scanl**|**splitc**|**strip**|
|**stripl**|**stripr**|**sub**|**sum**|**take**|**try**|
|**tup**|**tupl**|**tupr**|**tupx**|**unlist**|**λ**|
|**with_trampoline**|

## *list/unlist*

```bash
$ list 1 2 3
1
2
3

$ list 1 2 3 4 5 | unlist
1 2 3 4 5
```

## *take/drop/ltail/lhead/last*

```bash
$ list 1 2 3 4 | drop 2
3
4

$ list 1 2 3 4 5 | lhead
1

$ list 1 2 3 4 | ltail
2
3
4

$ list 1 2 3 4 5 | last
5

$ list 1 2 3 4 5 | take 2
1
2
```

## *join*

```bash
$ list 1 2 3 4 5 | join ,
1,2,3,4,5

$ list 1 2 3 4 5 | join , [ ]
[1,2,3,4,5]
```

## *map*

```bash
$ seq 1 5 | map λ a . 'echo $((a + 5))'
6
7
8
9
10

$ list a b s d e | map λ a . 'echo $a$(echo $a | tr a-z A-Z)'
aA
bB
sS
dD
eE

$ list 1 2 3 | map echo
1
2
3

$ list 1 2 3 | map 'echo $ is a number'
1 is a number
2 is a number
3 is a number

$ list 1 2 3 4 | map 'echo \($,$\) is a point'
(1,1) is a point
(2,2) is a point
(3,3) is a point
(4,4) is a point
```

## *flat map*

```bash
$ seq 2 3 | map λ a . 'seq 1 $a' | join , [ ]
[1,2,1,2,3]

$ list a b c | map λ a . 'echo $a; echo $a | tr a-z A-z' | join , [ ]
[a,A,b,B,c,C]
```

## *filter*

```bash
$ seq 1 10 | filter λ a . '[[ $(mod $a 2) -eq 0 ]] && ret true || ret false'
2
4
6
8
10
```

## *foldl/foldr*

```bash
$ list a b c d | foldl λ acc el . 'echo -n $acc-$el'
a-b-c-d

$ list '' a b c d | foldr λ acc el .\
    'if [[ ! -z $acc ]]; then echo -n $acc-$el; else echo -n $el; fi'
d-c-b-a
```

```bash
$ seq 1 4 | foldl λ acc el . 'echo $(($acc + $el))'
10
```

```bash
$ seq 1 4 | foldl λ acc el . 'echo $(mul $(($acc + 1)) $el)'
64 # 1 + (1 + 1) * 2 + (4 + 1) * 3 + (15 + 1) * 4 = 64

$ seq 1 4 | foldr λ acc el . 'echo $(mul $(($acc + 1)) $el)'
56 # 1 + (1 + 1) * 4 + (8 + 1) * 3 + (27 + 1) * 2 = 56
```

## *tup/tupx/tupl/tupr*

```bash
$ tup a 1
(a,1)

$ tup 'foo bar' 1 'one' 2
(foo bar,1,one,2)

$ tup , 1 3
(u002c,1,3)
```

```bash
$ tupl $(tup a 1)
a

$ tupr $(tup a 1)
1

$ tup , 1 3 | tupl
,

$ tup 'foo bar' 1 'one' 2 | tupl
foo bar

$ tup 'foo bar' 1 'one' 2 | tupr
2
```

```bash
$ tup 'foo bar' 1 'one' 2 | tupx 2
1

$ tup 'foo bar' 1 'one' 2 | tupx 1,3
foo bar
one

$ tup 'foo bar' 1 'one' 2 | tupx 2-4
1
one
2
```

## *ntup/ntupx/ntupl/ntupr*

```bash
$ ntup tuples that $(ntup safely nest)
(dHVwbGVzCg==,dGhhdAo=,KGMyRm1aV3g1Q2c9PSxibVZ6ZEFvPSkK)

echo '(dHVwbGVzCg==,dGhhdAo=,KGMyRm1aV3g1Q2c9PSxibVZ6ZEFvPSkK)' | ntupx 3 | ntupr
nest

$ ntup 'foo,bar' 1 one 1
(Zm9vLGJhcgo=,MQo=,b25lCg==,MQo=)

$ echo '(Zm9vLGJhcgo=,MQo=,b25lCg==,MQo=)' | ntupx 1
foo,bar
```

```bash
$ ntupl $(ntup 'foo bar' 1 one 2)
foo bar

$ ntupr $(ntup 'foo bar' 1 one 2)
2
```

## *buff*

```bash
$ seq 1 10 | buff λ a b . 'echo $(($a + $b))'
3
7
11
15
19

$ seq 1 10 | buff λ a b c d e . 'echo $(($a + $b + $c + $d + $e))'
15
40
```

## *lzip*

```bash
$ list a b c d e f | lzip $(seq 1 10)
(a,1)
(b,2)
(c,3)
(d,4)
(e,5)
(f,6)
```

```bash
$ list a b c d e f | lzip $(seq 1 10) | last | tupr
6
```

## *curry*

```bash
add2() {
    echo $(($1 + $2))
}
```

```bash
$ curry inc add2 1
```

```bash
$ inc 2
3

$ seq 1 3 | map λ a . 'inc $a'
2
3
4
```

## *peek*

```bash
$ list 1 2 3 \
    | peek lambda a . echo 'dbg a : $a' \
    | map lambda a . 'mul $a 2' \
    | peek lambda a . echo 'dbg b : $a' \
    | sum

dbg a : 1
dbg a : 2
dbg a : 3
dbg b : 2
dbg b : 4
dbg b : 6
12
```

```bash
$ a=$(seq 1 4 | peek lambda a . echo 'dbg: $a' | sum)

dbg: 1
dbg: 2
dbg: 3
dbg: 4

$ echo $a

10
```

## *maybe/maybemap/maybevalue*

```bash
$ list Hello | maybe
(Just,Hello)

$ list "   " | maybe
(Nothing)

$ list Hello | maybe | maybemap λ a . 'tr oH Oh <<<$a'
(Just,hellO)

$ list "   " | maybe | maybemap λ a . 'tr oH Oh <<<$a'
(Nothing)

$ echo bash-fun rocks | maybe | maybevalue DEFAULT
bash-fun rocks

$ echo | maybe | maybevalue DEFAULT
DEFAULT

```

## *not/isint/isempty*

```bash
$ isint 42
true

$ list blah | isint
false

$ not true
false

$ not isint 777
false

$ list 1 2 "" c d 6 | filter λ a . 'isint $a'
1
2
6

$ list 1 2 "" c d 6 | filter λ a . 'not isempty $a'
1
2
c
d
6
```

## *isfile/isnonzerofile/isreadable/iswritable/isdir*

```bash
$ touch /tmp/foo

$ isfile /tmp/foo
true

$ not iswritable /
true

$ files="/etc/passwd /etc/sudoers /tmp /tmp/foo /no_such_file"

$ list $files | filter λ a . 'isfile $a'
/etc/passwd
/etc/sudoers
/tmp/foo

$ list $files | filter λ a . 'isdir $a'
/tmp

$ list $files | filter λ a . 'isreadable $a'
/etc/passwd
/tmp
/tmp/foo

$ list $files | filter λ a . 'iswritable $a'
/tmp
/tmp/foo

$ list $files | filter λ a . 'isnonzerofile $a'
/etc/passwd
/etc/sudoers
/tmp

$ list $files | filter λ a . 'not isfile $a'
/tmp
/no_such_file
```

## *try/catch*

```bash
$ echo 'expr 2 / 0' | try λ _ . 'echo 0'
0

$ echo 'expr 2 / 0' | try λ status . 'echo $status'
2

$ echo 'expr 2 / 2' | try λ _ . 'echo 0'
1
```

```bash
try λ  _ . 'echo some errors during pull; exit 1' < <(echo git pull)
```

```bash
$ echo 'expr 2 / 0' \
    | LANG=en catch λ cmd status val . 'echo cmd=$cmd,status=$status,val=$val'
cmd=expr 2 / 0,status=2,val=(expr:,division,by,zero)
```

```bash
$ echo 'expr 2 / 2' | catch λ _ _ val . 'tupl $val'
1
```

## *scanl*

```bash
$ seq 1 5 | scanl lambda acc el . 'echo $(($acc + $el))'
1
3
6
10
15
```

```bash
$ seq 1 5 | scanl lambda a b . 'echo $(($a + $b))' | last
15
```

## *with_trampoline/res/call*

```bash
factorial() {
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
```

```bash
$ time factorial 30 | fold -w 70
265252859812191058636308480000000

real    0m1.854s
user    0m0.072s
sys     0m0.368s
```

```bash
time factorial 60 | fold -w 70
8320987112741390144276341183223364380754172606361245952449277696409600
000000000000

real    0m3.635s
user    0m0.148s
sys     0m0.692s
```

```bash
$ time factorial 90 | fold -w 70
1485715964481761497309522733620825737885569961284688766942216863704985
393094065876545992131370884059645617234469978112000000000000000000000

real    0m4.371s
user    0m0.108s
sys     0m0.436s
```

# Examples

```bash
processNames() {

  uppercase() {
     local str=$1
     echo $(tr 'a-z' 'A-Z' <<< ${str:0:1})${str:1}
  }

  list $@ \
    | filter λ name . '[[ ${#name} -gt 1 ]] && ret true || ret false' \
    | map λ name . 'uppercase $name' \
    | foldl λ acc el . 'echo $acc,$el'

}

processNames adam monika s slawek d daniel Bartek j k
```

```bash
Adam,Monika,Slawek,Daniel,Bartek
```

# Running tests

```bash
cd test
./test_runner
```

# Contribution guidelines

Feel free to ask questions in chat, open issues, or contribute by creating pull requests.

In order to create a pull request
* checkout master branch
* introduce your changes & bump version
* submit pull request

# Resources
* [Inspiration](https://quasimal.com/posts/2012-05-21-funsh.html)
* [Functional Programming in Bash](https://medium.com/@joydeepubuntu/functional-programming-in-bash-145b6db336b7)
