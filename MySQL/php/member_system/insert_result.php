<?php
	$con = mysqli_connect("localhost", "root", "1234", "sqlDB") or die("MySQL 접속 실패");

	$userID = $_POST["userID"];
	$name = $_POST["name"];
	$birthYear = $_POST["birthYear"];
	$addr = $_POST["addr"];
	$mobile1 = $_POST["mobile1"];
	$mobile2 = $_POST["mobile2"];
	$height = $_POST["height"];
	$mDate = date("Y-m-j");

	$sql = "INSERT INTO userTbl VALUES('".$userID."','".$name."',".$birthYear.",'".$addr."','".$mobile1."','".$mobile2."',".$height.",'".$mDate."')";

	$ret = mysqli_query($con, $sql);

	echo "<h1> 신규 회원 입력 결과 </h1>";
	if ($ret) {
		echo "성공";
	}
	else {
		echo "실패"."<br>".mysqli_error($con);
	}

	mysqli_close($con);
	echo "<br> <a href='main.html'> <- 초기화면</a>";
?>
