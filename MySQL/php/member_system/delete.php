<?php
	$con = mysqli_connect("localhost", "root", "1234", "sqlDB") or die("MySQL 접속 실패");
	
	$sql = "SELECT * FROM userTbl WHERE userID='".$_GET['userID']."'";
	$ret = mysqli_query($con, $sql);
	if ($ret) {
		$count = mysqli_num_rows($ret);
		if ($count==0) {
			echo $_GET['userID']." 아이디의 회원이 없음!"."<br>";
			echo "<br> <a href='main.html'> <- 초기화면</a>";
			exit();
		}
	}
	else {
		echo "실패"."<br>".mysqli_error($con);
		echo "<br> <a href='main.html'> <- 초기화면</a>";
		exit();
	}

	$row = mysqli_fetch_array($ret);
	$userID = $row["userID"];
	$name = $row["name"];
?>

<HTML>
<HEAD>
    <META http-equiv="content-type" content="text/html" charset="utf-8">
</HEAD>
<BODY>
    <h1> 회원 삭제 </h1>

    <FORM METHOD="post" ACTION="delete_result.php">
		아이디 : <INPUT TYPE="text" NAME="userID" VALUE=<?php echo $userID ?> READONLY> <br>
		이름 : <INPUT TYPE="text" NAME="name" VALUE=<?php echo $name ?> READONLY> <br><br><br>
		위 회원을 삭제하겠습니까?
        	<INPUT TYPE="submit" VALUE="회원 삭제">       
    </FORM>
</BODY>
</HTML>
