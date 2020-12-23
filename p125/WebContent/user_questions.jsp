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
<title>View/Ask Questions</title>
</head>
<body>
	<%@ page import="java.io.*,java.util.*,java.sql.*"%>
	<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

	<br />
	<form action="submit_question.jsp">
		<textarea maxlength="512" placeholder="ask question here..." name="question" rows="4"
			cols="154"></textarea>
		<br />
		<button type="submit">Submit</button>
		<br /> <br /> <br />

	</form>

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
			rs = stmt.executeQuery("SELECT * FROM questions");
	%>
	<div align="center">
		<table style="width: 100% s">
			<tr>
				<th>Question ID</th>
				<th>Question</th>
				<th>Answer</th>
			<tr>
				<%
					while (rs.next()) {
							String temp = rs.getString(3);
				%>
			
			<tr>
				<th><%=rs.getString(1)%></th>
				<th><%=rs.getString(2)%></th>
				<%
					if (temp == null) {
				%>
				<th>--NO ANSWER--</th>
				<!-- TEXT BOX TO ANSWER QUESTION -->
				<%
					} else {
				%>
				<th><%=temp%></th>
				<%
					}
				%>
			</tr>

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