<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<%@ page import="java.io.*,java.util.*,java.sql.*"%>
	<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
	<%
		String url = "jdbc:mysql://cs336db.chiumncfblqk.us-east-2.rds.amazonaws.com:3306/cs336db";
		String bid = request.getParameter("bidid");
		String listing_id = request.getParameter("listing"); //need to get listing_id set properly
		String bidder = session.getAttribute("username").toString();
		//try {
			//Load JDBC driver - the interface standardizing the connection procedure. Look at WEB-INF\lib for a mysql connector jar file, otherwise it fails.
			Class.forName("com.mysql.jdbc.Driver");
			//Create connection to db
			Connection conn = DriverManager.getConnection(url, "cs336", "theProjectAccessPassword");
			//create statement
			Statement stmt = conn.createStatement();
			//create result set
			ResultSet rs = null;
			ResultSet prs = null;
			//Query db
			rs = stmt.executeQuery(
					"SELECT listing_id, pid, seller, description, current_price, leader, end_date FROM listing WHERE listing_id='"
							+ listing_id + "'");
			if (!rs.next()) {
				out.println("ERROR: NO AUCTION WITH ID \"" + listing_id + "\"");
			} else {
				String pid = rs.getString("pid");

				String seller = rs.getString("seller");
				String desc = rs.getString("description");
				double originalprice = rs.getDouble("current_price");
				double price = rs.getDouble("current_price");
				java.sql.Timestamp end_date = rs.getTimestamp("end_date");

				out.println("Seller: " + seller);
				out.println("<br> Description: " + desc);
				String cat;
				prs = stmt.executeQuery("SELECT * from party_game where pid = '" + pid + "';");
				cat = "party";
				if (!prs.next()) {
					prs = stmt.executeQuery("SELECT * from video_game where pid = '" + pid + "';");
					cat = "video";
					if (!prs.next()) {
						prs = stmt.executeQuery("SELECT * from tabletop_game where pid = '" + pid + "';");
						cat = "tabletop";
						prs.next();
					}
				}
				String name = prs.getString("name");
				out.println("<br>Product Name: " + name);
				if (cat.equals("party")) {
					out.println("<br>Minimum age: " + prs.getString("min_age"));
					out.println("<br>Maker: " + prs.getString("maker"));
				}
				if (cat.equals("video")) {
					out.println("<br>Publisher: " + prs.getString("publisher"));
					out.println("<br>Developer: " + prs.getString("developer"));
					out.println("<br>Genre: " + prs.getString("genre"));
					out.println("<br>Rating: " + prs.getString("rating"));
				}
				if (cat.equals("tabletop")) {
					out.println("<br>Genre: " + prs.getString("genre"));
					out.println("<br>Minimum age: " + prs.getString("min_age"));
					out.println("<br>Maker: " + prs.getString("maker"));
				}
				java.util.Date today = new java.util.Date();
				java.sql.Timestamp now = new java.sql.Timestamp(today.getTime());
				boolean expired;
				if (now.after(end_date)) { //Check if bid has ended. If expired, place bid option not shown.
					out.println("<br> Auction has expired.");

				} else {
					out.println("<br> Ends: " + end_date + "<br><br>");
				}
				out.println("<br><br>");

				rs.close();%>
		<%if (!now.after(end_date)) {%>
		<div align="left">
		Place bid:
		<form action="listing.jsp" method=post>
			<input type=hidden name="listing" value=<%=listing_id%>>
			<input type="number" step=.01 min=.01 pattern="[+]?[0-9]*[.,]?[0-9]+"
				name="bidid" required /> <input type="submit" value=submit>
			<%}%>
		</form>
	</div>
	<%if (bid != null) {
					try {
						Float fbid = Float.parseFloat(bid);
						if (fbid <= price) {
							out.println("<br>Too low of a bid entered.");
							out.println("<br>Bid must be higher than " + price + ".");
						} else {
							price = fbid;
							out.println("Bid submitted");
							stmt.execute("INSERT into bid(listing_id, bid, bidder) values('" + listing_id + "','" + bid
									+ "','" + bidder + " ');");
							//stmt.execute("UPDATE listing set leader = "+ bidder+" where listing_id =" +listing_id + ";");
							stmt.execute("UPDATE listing set current_price = " + fbid + " where listing_id = "
									+ listing_id + ";");
							out.println("<br> Current bid: " + price);
						}
					} catch (Exception e) {
						out.println("Invalid bid entered.");
					}

				} else {
					out.println("<br> Current bid = " + price);
				}
			}
			conn.close();
			stmt.close();
			/*} catch (Exception e) {
					out.println("connection error");
			}*/%>
	<form action="home.jsp" name="home" method="post">
		<br /> <br /> <br /> <br />
		<div align="center">
			<button type="submit">Home</button>
		</div>
	</form>
</body>
</html>