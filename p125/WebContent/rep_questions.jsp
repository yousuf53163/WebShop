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
<title>Answer User Questions</title>
</head>
<body>
	<%@ page import="java.io.*,java.util.*,java.sql.*"%>
	<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
	<%
		String user = request.getParameter("userid");
		String pword = request.getParameter("pword");
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
			rs = stmt.executeQuery("SELECT * FROM questions WHERE answer IS NULL");
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
							String temp = rs.getString(1);
				%>
			
			<tr>
				<th><%=temp%></th>
				<th><%=rs.getString(2)%></th>
				<th>
					<form action="answer_question.jsp">
						<textarea maxlength="1024" placeholder="ask question here..." name="answer"
							rows="6" cols="50"></textarea>
						<br /> <input type="hidden" name="qid" value=<%=temp%>>
						<button type="submit">Answer</button>
					</form>
				</th>
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