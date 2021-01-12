<?php
	echo date("Y-m-j"), "<br>";
	echo pi(), " ", round(M_PI), " ", ceil(M_PI), "<br>";
	echo str_replace("OLD", "NEW", "OLD 바뀝니다."), "<br>";
	
	$ary = explode(" ", "하나 둘 셋");
	print_r($ary); echo "<br>";

	echo implode($ary, " "), "<br>";

	$myHTML = "<A href='https://www.naver.com/'>네이버 </A> <br>";
	echo $myHTML;
	echo htmlspecialchars($myHTML), "<br>";
	echo "문자열"."이어서"."출력";
?>