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
<title>Search Bids</title>
</head>
<body>
	<%@ page import="java.io.*,java.util.*,java.sql.*"%>
	<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
	<%
		String username = request.getParameter("search_bid_user");
		String listing = request.getParameter("search_bid_listing");
		String query;
		if ((username == null || username.isEmpty()) && (listing == null || listing.isEmpty())) {
			query = "SELECT * FROM bid";
		} else if ((username == null || username.isEmpty()) && !listing.isEmpty()) {
			query = "SELECT * FROM bid WHERE listing_id='" + listing + "'";
		} else if (!username.isEmpty() && (listing == null || listing.isEmpty())) {
			query = "SELECT * FROM bid WHERE bidder='" + username + "'";
		} else {
			query = "SELECT * FROM bid WHERE bidder='" + username + "' AND listing_id='" + listing + "'";
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

	<input type=hidden name="search_bid" value=<%=username%>>

	<div align="center">
		<table style="width: 100% s">
			<tr>
				<th>Listing ID</th>
				<th>Bid Amount</th>
				<th>Bidder</th>
				<th></th>
				<th></th>
			<tr>
				<%
					while (rs.next()) {
							String lid = rs.getString(1);
							if (lid.isEmpty() || lid == null) {
								continue;
							}
							String bid = rs.getString(2);
							String bidder = rs.getString(3);
				%>

				<form action="update_bid.jsp">
					<tr>
						<input type=hidden name="lid" value=<%=lid%>>
						<input type=hidden name="bidd" value=<%=bid%>>
						<th><%=lid%><br /> <input type="text"
							placeholder="new listing" name="listing"></th>
						<th><%=bid%><br /> <input type="text"
							placeholder="new bid amount" name="bid"></th>
						<th><%=bidder%><br /> <input type="text"
							placeholder="new bidder" name="bidder"></th>
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