<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Update Auctions</title>
</head>
<body>
	<%@ page import="java.io.*,java.util.*,java.sql.*"%>
	<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

	<%
		String delete = request.getParameter("delete");
		String temp = request.getParameter("search_auction");
		String old_lid = request.getParameter("lid");
		String listing = request.getParameter("listing");
		String seller = request.getParameter("seller");
		String pid = request.getParameter("pid");
		String descr = request.getParameter("descr");
		String price = request.getParameter("price");
		String leader = request.getParameter("leader");
		String end = request.getParameter("end");
		String queries[] = new String[7];
		boolean err = true;
		String check_lid = "", check_seller = "", check_leader = "";
	%>
	<input type=hidden name="search_user" value=<%=temp%>>
	<%
		if (!listing.isEmpty()) {
			queries[6] = "UPDATE listing SET listing_id='" + listing + "' WHERE listing_id='" + old_lid + "'";
			check_lid = "SELECT listing_id FROM listing WHERE listing_id='" + listing + "'";
		}
		if (!seller.isEmpty()) {
			queries[0] = "UPDATE listing SET seller='" + seller + "' WHERE listing_id='" + old_lid + "'";
			check_seller = "SELECT username FROM end_user WHERE username='" + seller + "'";
		}
		if (!pid.isEmpty()) {
			queries[1] = "UPDATE listing SET pid='" + pid + "' WHERE listing_id='" + old_lid + "'";
		}
		if (!descr.isEmpty()) {
			queries[2] = "UPDATE listing SET description='" + descr + "' WHERE listing_id='" + old_lid + "'";
		}
		if (!price.isEmpty()) {
			queries[3] = "UPDATE listing SET current_price='" + price + "' WHERE listing_id='" + old_lid + "'";
		}
		if (!leader.isEmpty()) {
			queries[4] = "UPDATE listing SET leader='" + leader + "' WHERE listing_id='" + old_lid + "'";
			check_leader = "SELECT username FROM end_user WHERE username='" + leader + "'";
		}
		if (!end.isEmpty()) {
			queries[5] = "UPDATE listing SET end_date='" + end + "' WHERE listing_id='" + old_lid + "'";
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
				stmt.executeUpdate("DELETE FROM listing where listing_id='" + old_lid + "'");
				conn.close();
				stmt.close();
				response.sendRedirect("select_auction.jsp");
			} else {
				//create result set
				ResultSet rs = null;
				if (!check_lid.isEmpty()) {
					rs = stmt.executeQuery(check_lid);
					if (rs.next()) {
						conn.close();
						stmt.close();
						rs.close();
						err = false;
						out.println("ERROR: LISTING_ID ALREADY EXISTS");
					}
				}
				if (!check_seller.isEmpty()) {
					rs = stmt.executeQuery(check_seller);
					if (!rs.next()) {
						conn.close();
						stmt.close();
						rs.close();
						err = false;
						out.println("ERROR: SELLER DOES NOT EXISTS");
					}
				}
				if (!check_leader.isEmpty() && !leader.equals("null")) {
					rs = stmt.executeQuery(check_leader);
					if (!rs.next()) {
						conn.close();
						stmt.close();
						rs.close();
						err = false;
						out.println("ERROR: LEADING BIDDER DOES NOT EXISTS");
					}
				}
				if (err) {
					for (int i = 0; i < 7; i++) {
						if (queries[i] != null) {
							stmt.addBatch(queries[i]);
						}
					}
					stmt.executeBatch();
					conn.close();
					stmt.close();
					if (!check_lid.isEmpty() || !check_seller.isEmpty() || (!check_leader.isEmpty() && !leader.equals("null"))) {
						rs.close();
					}
					response.sendRedirect("select_auction.jsp");
				}
			}
		} catch (Exception e) {
			out.println(e);
		}
	%>
	<form action="select_auction.jsp">
		<br /> <br />
		<div align="center">
			<button type="submit">Back</button>
		</div>
	</form>
</body>
</html>