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
<title>Search Auctions</title>
</head>
<body>
	<%@ page import="java.io.*,java.util.*,java.sql.*"%>
	<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
	<%
		String lid = request.getParameter("search_auction");
		String query;
		if (lid == null || lid.isEmpty()) {
			query = "SELECT * FROM listing";
		} else {
			query = "SELECT * FROM listing WHERE listing_id='" + lid + "'";
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

	<input type=hidden name="search_auction" value=<%=lid%>>
	<div align="center">
		<table style="width: 100% s">
			<tr>
				<th>Listing ID</th>
				<th>Seller</th>
				<th>Product ID</th>
				<th>Description</th>
				<th>Current Price</th>
				<th>Leading Bidder</th>
				<th>End Time</th>
				<th></th>
				<th></th>
			<tr>
				<%
					while (rs.next()) {
							String listing = rs.getString(1);
							if (listing.isEmpty() || listing == null) {
								continue;
							}
							String seller = rs.getString(2);
							String pid = rs.getString(3);
							String descr = rs.getString(4);
							String price = rs.getString(5);
							String leader = rs.getString(6);
							String end = rs.getString(7);
				%>
				<form action="update_auction.jsp">
			<tr>
				<input type=hidden name="lid" value=<%=listing%>>
				<th><%=listing%><br /> <input type="text"
					placeholder="new listing" name="listing"></th>
				<th><%=seller%><br /> <input type="text"
					placeholder="new seller" name="seller"></th>
				<th><%=pid%><br /> <input type="text" placeholder="new pid"
					name="pid"></th>
				<th><%=descr%><br /> <input type="text"
					placeholder="new description" name="descr"></th>
				<th><%=price%><br /> <input type="text"
					placeholder="new current price" name="price"></th>
				<th><%=leader%><br /> <input type="text"
					placeholder="new leading bidder" name="leader"></th>
				<th><%=end%><br /> <input type="time"
					placeholder="yyyy-mm-dd hh:mm:ss" name="end"></th>
				<th>
					<button type="submit" name="delete" value="update">Update</button>
				</th>
				<th>
					<button type="submit" name="delete" value="delete">Delete</button>
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