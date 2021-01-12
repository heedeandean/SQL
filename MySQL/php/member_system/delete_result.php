<?php
	$con = mysqli_connect("localhost", "root", "1234", "sqlDB") or die("MySQL 접속 실패");

	$userID = $_POST["userID"];

	$sql = "DELETE FROM userTbl WHERE userID='".$userID."'";

	$ret = mysqli_query($con, $sql);

	echo "<h1> 회원 삭제 결과 </h1>";
	if ($ret) {
		echo "성공";
	}
	else {
		echo "실패"."<br>".mysqli_error($con);
	}

	mysqli_close($con);
	echo "<br> <a href='main.html'> <- 초기화면</a>";
?>
