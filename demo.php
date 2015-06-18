<?php

$l = array_Map(function ($s) {
	return 'b';
}, [1,2,3]);

print_r ($l );

$f = TRUE;
$f = true;

$a = [];

$foo -> $bar = 1;

$a = 1+2;

$b= 'c';

$b ='c';

$b = 'c' ;

$c = (int) $b;

$c = (int)$b ;

$c = (int )$b;

for ($i=0;$i<10;$i++) {
	echo $i.'abc';
	echo $i,'abc';
}

function abc1($a=1, $b=2) { echo 'def',$a,$b; }

function abc2($a = 1, $b = 2) {
	echo 'def'.$a;
}

function abc3( $a = 1) {
	$a = 'abc';
	echo 'def';
}

function abc4( ) {
	echo 'def';
}

function abc5(){
	echo 'def';
}

function abc6()
{
	echo 'def';
}

class TestClassA {

}

class TestClassB
{

	public function abc() {
		if ($a > 1) {
			echo 'yes';
		}
		if($a>1) {
			echo 'yes';
		}
		if($a   >   1) {
			echo 'yes';
		}

		$s=new     StdClass();
	}
}

$a = 'dfsadfasdf1111111111111111111111111111111111111111111111111111111111111  123';
?>
