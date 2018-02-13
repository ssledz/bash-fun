#! /bin/bash

testLambdaNoArguments_ifNoInput() {
    assertEquals 'Hi there' "$(echo | lambda . 'echo Hi there')"
}

testLambdaNoArguments_ifSomeInputArguments() {
    assertEquals 'Hi there' "$(echo 'xx\nyy\nzz' | lambda . 'echo Hi there')"
}

testLambdaOneArgument() {
  identity() {
    lambda x . '$x'
  }
  assertEquals "hi there !" "$(identity <<< 'echo hi there !')"
  assertEquals 3 $(lambda x . 'echo $(($x + 1))' <<< '2')
  assertEquals "hi there !" "$(λ x . 'echo $x' <<< 'hi there !')"
}

testLambdaSymbolTwoArguments() {
    assertEquals 3 $(echo -e '1\n2' | lambda x y . 'echo $(($x + $y))')
    assertEquals 5 $(echo -e '7\n2' | λ x y . 'echo $(($x - $y))')
}

testLambdaSymbolManyArguments() {
    assertEquals 5 $(echo -e '1\n2\n3\n4\n5' | lambda a b c d e . 'echo $(($a + $b + $c + $d - $e))')
}

testLambdaSymbolManyArguments_ifInsufficientNumberOfArgumentsInLambda() {
    assertEquals 6 $(echo -e '1\n2\n3\n4\n5' | lambda a b c . 'echo $(($a + $b + $c))')
}

testLambdaSymbolManyArguments_ifInsufficientNumberOfInputArguments() {
    echo -e '1\n2' | lambda a b c d e . 'echo $(($a + $b + $c + $d + $e))' 2> /dev/null \
        && fail "There should be syntax error"
}

. ./shunit2-init.sh