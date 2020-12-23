<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Create New Account</title>
</head>
<body>
	<%@ page import="java.io.*,java.util.*,java.sql.*"%>
	<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
	<%
		String user = request.getParameter("userid");
		String pword = request.getParameter("pword");
		String name = request.getParameter("name");
		String email = request.getParameter("email");
		String mailing_addr = request.getParameter("mailing_addr");
		String url = "jdbc:mysql://cs336db.chiumncfblqk.us-east-2.rds.amazonaws.com:3306/cs336db";
		String insert = "insert into end_user(username,password,name,email,mailing_addr) values ('" + user + "','" + pword + "','" + name + "','" + email + "','"
				+ mailing_addr + "')";
		try {
			//Load JDBC driver - the interface standardizing the connection procedure. Look at WEB-INF\lib for a mysql connector jar file, otherwise it fails.
			Class.forName("com.mysql.jdbc.Driver");
			//Create connection to db
			Connection conn = DriverManager.getConnection(url, "cs336", "theProjectAccessPassword");
			//create statement
			Statement stmt = conn.createStatement();
			//create result set
			ResultSet rs;
			//Query db
			rs = stmt.executeQuery("SELECT username FROM end_user WHERE username='" + user + "'");
			if (rs.next()) {
				out.println("ERROR: ACCOUNT ALREADY EXISTS");
			} else {
				stmt.executeUpdate(insert);
				out.println("Account Created");
			}
			conn.close();
			stmt.close();
			rs.close();
		} catch (Exception e) {
			out.println("connection error");
		}
	%>

	<form action="Login.html" method="post">
		<br /> <br />
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