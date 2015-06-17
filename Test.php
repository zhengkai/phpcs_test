<?php

$f = TRUE;
$f = true;

$a = [];

$a = 1+2;
$b= 'c';
$b ='c';
$b = 'c' ;

$c = (int) $b;
$c = (int)$b;
$c = (int )$b;

for ($i=0;$i<10;$i++) {
	echo $i.'abc';
	echo $i,'abc';
}

function abc1($a=1, $b=2) {
	echo 'def';
}

function abc1($a = 1, $b = 2) {
	echo 'def';
}

function abc1( $a = 1) {
	echo 'def';
}

function abc1( ) {
	echo 'def';
}

function abc3(){
	echo 'def';
}

function abc4()
{
	echo 'def';
}

class TestClassA
{

}

class TestClassA {

}

$a = 'dfsadfasdf1111111111111111111111111111111111111111111111111111111111111';
