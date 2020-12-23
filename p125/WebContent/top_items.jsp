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
<title>Top Items</title>
</head>
<body>
	<%@ page import="java.io.*,java.util.*,java.sql.*"%>
	<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
	<%
		Integer limit;
		String temp = request.getParameter("limit");
		String sort = request.getParameter("sort");
		String url = "jdbc:mysql://cs336db.chiumncfblqk.us-east-2.rds.amazonaws.com:3306/cs336db";
		try {
			if (temp == null || temp.isEmpty()) {
				limit = 10;
			} else {
				limit = Integer.parseInt(temp);
			}
			//Load JDBC driver - the interface standardizing the connection procedure. Look at WEB-INF\lib for a mysql connector jar file, otherwise it fails.
			Class.forName("com.mysql.jdbc.Driver");
			//Create connection to db
			Connection conn = DriverManager.getConnection(url, "cs336", "theProjectAccessPassword");
			//create statement
			Statement stmt = conn.createStatement();
			//create result set
			ResultSet rs;
			java.text.DateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd hh:mm:ss");
			if (sort.equals("quantity")) {
			rs = stmt.executeQuery("SELECT pid, COUNT(pid), TRUNCATE(sum(current_price),2) FROM listing WHERE end_date<'"
					+ df.format(new java.util.Date()) + "' GROUP BY pid ORDER BY COUNT(*) DESC, sum(current_price) DESC LIMIT " + limit);
			}else{
				rs = stmt.executeQuery("SELECT pid, COUNT(pid), TRUNCATE(sum(current_price),2) FROM listing WHERE end_date<'"
						+ df.format(new java.util.Date()) + "' GROUP BY pid ORDER BY sum(current_price) DESC, COUNT(*) DESC LIMIT " + limit);
			}
	%>
	
	<br /><br /><br />
	<div align="center">
		TOP SELLING ITEMS
		<table style="width: 100% s">
			<tr>
				<th>Product ID</th>
				<th>Number Sold</th>
				<th>Sales Income of Item</th>
			<tr>
				<%
					while (rs.next()) {
							String pid = rs.getString(1);
							String count = rs.getString(2);
							String income = rs.getString(3);
				%>
			
			<tr>
				<th><%=pid%><br /></th>
				<th><%=count%><br /></th>
				<th>$<%=income%><br /></th>

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

		} catch (NumberFormatException e) {
			out.println("ERROR: INPPUT NOT AN INTEGER");
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