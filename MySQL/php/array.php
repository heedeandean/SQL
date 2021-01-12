<?php
	$myArray = range(1, 10);
	
	shuffle($myArray);
	foreach($myArray as $data)
		echo $data, " ";
	
	echo "<br>오름차순 정렬 > ";
	sort($myArray);
	foreach($myArray as $data)
		echo $data, " ";

	echo "<br>내림차순 정렬 > ";
	rsort($myArray);
	foreach($myArray as $data)
		echo $data, " ";

	echo "<br>";
	$revArray = array_reverse($myArray);
	foreach($revArray as $data)
		echo $data, " ";
?>