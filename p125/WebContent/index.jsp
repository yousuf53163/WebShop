<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Index</title>
</head>
<body>
	<%@ page import="java.io.*,java.util.*,java.sql.*"%>
	<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
	<% if (session.getAttribute("username") != null){
		response.sendRedirect("home.jsp");
	}
	%>
	<form action="Login.html" name="login" method="post">
		<br /> <br /> <br /> <br />
		<div align="center">
			<button type="submit">Login</button>
		</div>
	</form>
	<form action="Create.html" method="post">
		<br /> <br />
		<div align="center">
			<button type="submit">Create New Account</button>
		</div>
	</form>

</body>
</html>