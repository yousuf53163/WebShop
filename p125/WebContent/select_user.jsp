<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<style>
table, th, td {
	border: 1px solid black;
	border-collapse: collapse;
}

th, td {
	padding: 8px;
}
</style>
<meta charset="ISO-8859-1">
<title>Update User Info</title>
</head>
<body>
	<%@ page import="java.io.*,java.util.*,java.sql.*"%>
	<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
	<%
		String username = request.getParameter("search_user");
		String query;
		if (username == null || username.isEmpty()) {
			query = "SELECT username, password, name, email, mailing_addr FROM end_user";
		} else {
			query = "SELECT username, password, name, email, mailing_addr FROM end_user WHERE username='" + username
					+ "'";
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
			ResultSet rs;
			rs = stmt.executeQuery(query);
	%>

	<input type=hidden name="search_user" value=<%=username%>>

	<div align="center">
		<table style="width: 100% s">
			<tr>
				<th>Username</th>
				<th>Password</th>
				<th>Name</th>
				<th>Email</th>
				<th>Mailing Address</th>
				<th></th>
			<tr>
				<%
					while (rs.next()) {
							String uname = rs.getString(1);
							if (uname.isEmpty() || uname == null) {
								continue;
							}
							String pword = rs.getString(2);
							String name = rs.getString(3);
							String email = rs.getString(4);
							String addr = rs.getString(5);
				%>

				<form action="update_user.jsp">
					<tr>
						<input type=hidden name="username" value=<%=uname%>>
						<th><%=uname%><br /> <input type="text"
							placeholder="new username" name="uname"></th>
						<th><%=pword%><br /> <input type="text"
							placeholder="new password" name="pword"></th>
						<th><%=name%><br /> <input type="text"
							placeholder="new name" name="name"></th>
						<th><%=email%><br /> <input type="text"
							placeholder="new email" name="email"></th>
						<th><%=addr%><br /> <input type="text"
							placeholder="new address" name="addr"></th>
						<th>
							<button type="submit">Update</button>
						</th>

					</tr>
				</form>

				<%
					}
				%>
			
		</table>
	</div>

	<%
		conn.close();
			stmt.close();
			rs.close();
		} catch (Exception e) {
			out.println(e);
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