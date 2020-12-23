<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Promote To Rep</title>
</head>
<body>
	<%@ page import="java.io.*,java.util.*,java.sql.*"%>
	<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
	<%
		String user = request.getParameter("new_rep");
		String promote = request.getParameter("promote");
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
			rs = stmt.executeQuery("SELECT * FROM end_user WHERE username='" + user + "'");
			if (!rs.next()) {
				out.println("ERROR: USERNAME DOES NOT EXIST");
			} else {
				int rep = rs.getByte(7);
				if (promote.equals("promote")) {
					if (rep == 1) {
						out.println("ERROR: USER IS ALREADY A CUSTOMER REPRESENTATIVE");
					} else {
						stmt.executeUpdate("UPDATE end_user SET customer_rep=1 WHERE username='" + user + "'");
						response.sendRedirect("home.jsp");
					}
				} else {
					if (rep == 0) {
						out.println("ERROR: USER IS NOT CUSTOMER REPRESENTATIVE");
					}else{
						stmt.executeUpdate("UPDATE end_user SET customer_rep=null WHERE username='" + user + "'");
						response.sendRedirect("home.jsp");
					}
					}
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