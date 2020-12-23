<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Home</title>
</head>
<body>
	<%@ page import="java.io.*,java.util.*,java.sql.*"%>
	<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
	<%
		String user = (String)session.getAttribute("username");
		String url = "jdbc:mysql://cs336db.chiumncfblqk.us-east-2.rds.amazonaws.com:3306/cs336db";
		byte rep, admin;
		try {
			//Load JDBC driver - the interface standardizing the connection procedure. Look at WEB-INF\lib for a mysql connector jar file, otherwise it fails.
			Class.forName("com.mysql.jdbc.Driver");
			//Create connection to db
			Connection conn = DriverManager.getConnection(url, "cs336", "theProjectAccessPassword");
			//create statement
			Statement stmt = conn.createStatement();
			//create result set
			ResultSet rs; 
			rs = stmt.executeQuery(
					"SELECT admin FROM end_user WHERE username='" + user + "'");
			if (rs.next() && rs.getObject(1, Boolean.class)) {
				conn.close();
				stmt.close();
				rs.close();
				response.sendRedirect("home_admin.html");
			}
			rs = stmt.executeQuery(
					"SELECT customer_rep FROM end_user WHERE username='" + user + "'");
			if (rs.next() && rs.getObject(1, Boolean.class)) {
				conn.close();
				stmt.close();
				rs.close();
				response.sendRedirect("home_rep.html");
			} 
			conn.close();
			stmt.close();
			rs.close();
			response.sendRedirect("home_user.html");
		} catch (Exception e) {
			out.println("connection error");
			out.println(e);
		}
	%>

</body>
</html>