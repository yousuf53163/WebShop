<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Submit Question</title>
</head>
<body>
	<%@ page import="java.io.*,java.util.*,java.sql.*"%>
	<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
	<%
		String question = request.getParameter("question");
		String qid = "";
		Integer id = (Integer)application.getAttribute("question_id");
		if(id == null || id == 0){
			id = 4;
		}else{
			id++;
		}
		application.setAttribute("question_id", id);
		qid += id;
		String url = "jdbc:mysql://cs336db.chiumncfblqk.us-east-2.rds.amazonaws.com:3306/cs336db";
		try {
			//Load JDBC driver - the interface standardizing the connection procedure. Look at WEB-INF\lib for a mysql connector jar file, otherwise it fails.
			Class.forName("com.mysql.jdbc.Driver");
			//Create connection to db
			Connection conn = DriverManager.getConnection(url, "cs336", "theProjectAccessPassword");
			//create statement
			Statement stmt = conn.createStatement();
			int i = stmt.executeUpdate("INSERT INTO questions(question_id, question) VALUES ('" + qid + "', '" + question + "')");
			conn.close();
			stmt.close();
			response.sendRedirect("user_questions.jsp");
		} catch (Exception e) {
			out.println(e);
		}
	%>

</body>
</html>