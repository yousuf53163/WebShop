<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Update User</title>
</head>
<body>
	<%@ page import="java.io.*,java.util.*,java.sql.*"%>
	<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

	<%
		String temp = request.getParameter("search_user");
		String old_uname = request.getParameter("username");
		String username = request.getParameter("uname");
		String pword = request.getParameter("pword");
		String name = request.getParameter("name");
		String email = request.getParameter("email");
		String addr = request.getParameter("addr");
		String queries[] = new String[5];
		String check = "";
	%>
	<input type=hidden name="search_user" value=<%=temp%>>
	<%
		if (!username.isEmpty()) {
			queries[4] = "UPDATE end_user SET username='" + username + "' WHERE username='" + old_uname + "'";
			check = "SELECT username FROM end_user WHERE username='" + username + "'";
		}
		if (!pword.isEmpty()) {
			queries[0] = "UPDATE end_user SET password='" + pword + "' WHERE username='" + old_uname + "'";
		}
		if (!name.isEmpty()) {
			queries[1] = "UPDATE end_user SET name='" + name + "' WHERE username='" + old_uname + "'";
		}
		if (!email.isEmpty()) {
			queries[2] = "UPDATE end_user SET email='" + email + "' WHERE username='" + old_uname + "'";
		}
		if (!addr.isEmpty()) {
			queries[3] = "UPDATE end_user SET mailing_addr='" + addr + "' WHERE username='" + old_uname + "'";
		}
		String url = "jdbc:mysql://cs336db.chiumncfblqk.us-east-2.rds.amazonaws.com:3306/cs336db";
		try {
			//Load JDBC driver - the interface standardizing the connection procedure. Look at WEB-INF\lib for a mysql connector jar file, otherwise it fails.
			Class.forName("com.mysql.jdbc.Driver");
			//Create connection to db
			Connection conn = DriverManager.getConnection(url, "cs336", "theProjectAccessPassword");
			//create statement
			Statement stmt = conn.createStatement();
			//create result set
			ResultSet rs = null;
			if (!check.isEmpty()) {
				rs = stmt.executeQuery(check);
			}
			if (!check.isEmpty() && rs.next()) {
				conn.close();
				stmt.close();
				rs.close();
			} else {
				for (int i = 0; i < 5; i++) {
					if (queries[i] != null) {
						stmt.addBatch(queries[i]);
					}
				}
				stmt.executeBatch();
				conn.close();
				stmt.close();
				if (!check.isEmpty()) {
					rs.close();
				}
				response.sendRedirect("select_user.jsp");
			}
		} catch (Exception e) {
			out.println(e);
		}
	%>
	ERROR: USERNAME ALREADY EXISTS
	<form action="select_user.jsp">
		<br /> <br />
		<div align="center">
			<button type="submit">Back</button>
		</div>
	</form>
</body>
</html>