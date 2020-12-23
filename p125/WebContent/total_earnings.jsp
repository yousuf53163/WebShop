<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Total Earnings</title>
</head>
<body>
	<%@ page import="java.io.*,java.util.*,java.sql.*"%>
	<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
	<%
		String url = "jdbc:mysql://cs336db.chiumncfblqk.us-east-2.rds.amazonaws.com:3306/cs336db";
		try {
			//Load JDBC driver - the interface standardizing the connection procedure. Look at WEB-INF\lib for a mysql connector jar file, otherwise it fails.
			Class.forName("com.mysql.jdbc.Driver");
			//Create connection to db
			Connection conn = DriverManager.getConnection(url, "cs336", "theProjectAccessPassword");
			//create statement
			Statement stmt = conn.createStatement();
			//create result set
			ResultSet rs;
			java.text.DateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd hh:mm:ss");
			rs = stmt.executeQuery("SELECT TRUNCATE(sum(current_price),2) FROM listing WHERE end_date<'"
					+ df.format(new java.util.Date()) + "'");
			if (!rs.next()) {
			} else {
	%>
	<div align="center">
		<br /> <br /> <br /> <br />
		<%
			out.println("TOTAL EARNINGS OF COMPLETED AUCTIONS: $" + rs.getDouble(1));
		%>
	</div>
	<%
		}
			conn.close();
			stmt.close();
			rs.close();
		} catch (Exception e) {
			out.println("connection error");
		}
	%>
	<form action="home.jsp">
		<br /> <br />
		<div align="center">
			<button type="submit">Back</button>
		</div>
	</form>
</body>
</html>