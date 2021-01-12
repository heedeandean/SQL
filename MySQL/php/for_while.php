<?php
	$total = 0;
	for($i=123; $i<=456; $i+=2) {
		$total += $i;		
	}
	echo $total, "<br>";

	$total = 0;
	$i=123;
	while($i<=456) {
		$total += $i;	
		$i+=2;
	}
	echo $total;
?>