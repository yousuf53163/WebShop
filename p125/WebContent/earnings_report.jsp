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
		String report = request.getParameter("report");
		String pid = request.getParameter("pid");
		String category = request.getParameter("category");
		String username = request.getParameter("username");
		String query = null, query2 = null;
		java.text.DateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd hh:mm:ss");
		if (report.equals("item")) {
			if (!pid.isEmpty()) {
				query = "SELECT TRUNCATE(sum(current_price),2) FROM listing where end_date < '2019-4-21' AND pid='"
						+ pid + "'";
				query2 = "SELECT pid FROM product WHERE pid='" + pid + "'";
			} else {
				out.println("ERROR: PRODUCT ID FIELD WAS LEFT EMPTY - MUST CONTAIN A PRODUCT ID");
			}
		} else if (report.equals("cata")) {
			if (!category.isEmpty()) {
				if (category.equals("tabletop_game") || category.equals("party_game")
						|| category.equals("video_game"))
					query = "select TRUNCATE(sum(A.current_price),2) from listing A where A.pid in (select B.pid from "
							+ category + " B)";
				else {
					out.println("ERROR: \"" + category + "\" IS NOT A CATEGORY");
				}
			} else {
				out.println("ERROR: CATEGORY FIELD WAS LEFT EMPTY - MUST CONTAIN A CATEGORY");
			}
		} else {
			if (!username.isEmpty()) {
				query = "select TRUNCATE(sum(current_price),2) from listing where seller='" + username + "'";
				query2 = "SELECT username FROM end_user WHERE username='" + username + "'";
			} else {
				out.println("ERROR: USERNAME FIELD WAS LEFT EMPTY - MUST CONTAIN A USERNAME");
			}
		}
		String url = "jdbc:mysql://cs336db.chiumncfblqk.us-east-2.rds.amazonaws.com:3306/cs336db";
		//try {
		//Load JDBC driver - the interface standardizing the connection procedure. Look at WEB-INF\lib for a mysql connector jar file, otherwise it fails.
		Class.forName("com.mysql.jdbc.Driver");
		//Create connection to db
		Connection conn = DriverManager.getConnection(url, "cs336", "theProjectAccessPassword");
		//create statement
		Statement stmt = conn.createStatement();
		//create result set
		ResultSet rs = null;
		if (query != null) {
	%>
	<div align="center">
		<br /> <br /> <br /> <br />
		<%
			if (report.equals("item")) {
					rs = stmt.executeQuery(query2);
					if (rs.next()) {
						rs = stmt.executeQuery(query);
						if (rs.next())
							out.println("TOTAL EARNINGS OF COMPLETED AUCTIONS FOR PRODUCT ID " + pid + ": $"
									+ rs.getDouble(1));
					} else {
						out.println("ERROR: PRODUCT ID DOES NOT EXIST");
					}
				} else if (report.equals("cata")) {
					rs = stmt.executeQuery(query);
					if (rs.next())
						out.println("TOTAL EARNINGS OF COMPLETED AUCTIONS FOR CATEGORY " + category + ": $"
								+ rs.getDouble(1));
				} else {
					rs = stmt.executeQuery(query2);
					if (rs.next()) {
						rs = stmt.executeQuery(query);
						if (rs.next())
							out.println("TOTAL EARNINGS OF COMPLETED AUCTIONS FOR USER " + username + ": $"
									+ rs.getDouble(1));
					} else {
						out.println("ERROR: USERNAME DOES NOT EXIST");
					}
				}
				rs.close();
		%>
	</div>
	<%
		}
		conn.close();
		stmt.close();
		//} catch (Exception e) {
		//	out.println("connection error");
		//}
	%>
	<form action="home.jsp">
		<br /> <br />
		<div align="center">
			<button type="submit">Back</button>
		</div>
	</form>
</body>
</html>