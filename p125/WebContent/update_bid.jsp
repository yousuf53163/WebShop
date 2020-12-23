<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Update Bid</title>
</head>
<body>
	<%@ page import="java.io.*,java.util.*,java.sql.*"%>
	<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

	<%
		String delete = request.getParameter("delete");
		String temp = request.getParameter("search_auction");
		String old_lid = request.getParameter("lid");
		String old_bid = request.getParameter("bidd");
		String listing = request.getParameter("listing");
		String bid = request.getParameter("bid");
		String bidder = request.getParameter("bidder");
		String queries[] = new String[3];
		boolean err = true;
		String check_lid = "", check_bidder = "";
	%>
	<input type=hidden name="search_bid" value=<%=temp%>>
	<%
		if (!listing.isEmpty() && !bid.isEmpty()) {
			queries[2] = "UPDATE bid SET listing_id='" + listing + "' WHERE listing_id='" + old_lid + "' AND bid = '" + bid + "'";
			check_lid = "SELECT listing_id FROM listing WHERE listing_id='" + listing + "'";
		}else if (!listing.isEmpty()) {
			queries[2] = "UPDATE bid SET listing_id='" + listing + "' WHERE listing_id='" + old_lid + "' AND bid = '" + old_bid + "'";
			check_lid = "SELECT listing_id FROM listing WHERE listing_id='" + listing + "'";
		}
		if (!bid.isEmpty()) {
			queries[1] = "UPDATE bid SET bid='" + bid + "' WHERE listing_id='" + old_lid + "' AND bid = '" + old_bid + "'";
		}
		if (!bidder.isEmpty()) {
			queries[0] = "UPDATE bid SET bidder='" + bidder + "' WHERE listing_id='" + old_lid + "' AND bid = '" + old_bid + "'";
			check_bidder = "SELECT username FROM end_user WHERE username='" + bidder + "'";
		}
		String url = "jdbc:mysql://cs336db.chiumncfblqk.us-east-2.rds.amazonaws.com:3306/cs336db";
		try {
			//Load JDBC driver - the interface standardizing the connection procedure. Look at WEB-INF\lib for a mysql connector jar file, otherwise it fails.
			Class.forName("com.mysql.jdbc.Driver");
			//Create connection to db
			Connection conn = DriverManager.getConnection(url, "cs336", "theProjectAccessPassword");
			//create statement
			Statement stmt = conn.createStatement();

			if (delete.equals("delete")) {
				stmt.executeUpdate("DELETE FROM bid where listing_id='" + old_lid + "' AND bid = '" + old_bid + "'");
				conn.close();
				stmt.close();
				response.sendRedirect("select_bids.jsp");
			} else {
				//create result set
				ResultSet rs = null;
				if (!check_lid.isEmpty()) {
					rs = stmt.executeQuery(check_lid);
					if (!rs.next()) {
						conn.close();
						stmt.close();
						rs.close();
						err = false;
						out.println("ERROR: LISTING DOES NOT EXIST");
					}
				}
				if (!check_bidder.isEmpty()) {
					rs = stmt.executeQuery(check_bidder);
					if (!rs.next()) {
						conn.close();
						stmt.close();
						rs.close();
						err = false;
						out.println("ERROR: LEADING BIDDER DOES NOT EXISTS");
					}
				}
				if (err) {
					for (int i = 0; i < 3; i++) {
						if (queries[i] != null) {
							stmt.addBatch(queries[i]);
						}
					}
					stmt.executeBatch();
					conn.close();
					stmt.close();
					if (!check_lid.isEmpty() || !check_bidder.isEmpty()) {
						rs.close();
					}
					response.sendRedirect("select_bids.jsp");
				}
			}
		} catch (Exception e) {
			out.println(e);
		}
	%>
	<form action="select_bids.jsp">
		<br /> <br />
		<div align="center">
			<button type="submit">Back</button>
		</div>
	</form>
</body>
</html>