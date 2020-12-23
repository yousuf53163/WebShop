<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Create Listing</title>
</head>
<body>
	<%@ page import="java.io.*,java.util.*,java.sql.*"%>
	<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
	<%
	String username = session.getAttribute("username").toString();
	String pname, cat, pid;
	if(request.getParameter("pname") != null){
	pname = request.getParameter("pname").toString();
	} else { pname = "";}
	if(request.getParameter("cat") != null){
		cat = request.getParameter("cat").toString();
	} else { cat = "";}
	
	String url = "jdbc:mysql://cs336db.chiumncfblqk.us-east-2.rds.amazonaws.com:3306/cs336db";
	Class.forName("com.mysql.jdbc.Driver");
	//Create connection to db
	Connection conn = DriverManager.getConnection(url, "cs336", "theProjectAccessPassword");
	//create statement
	Statement stmt = conn.createStatement();
	if(!pname.equals("")){
		ResultSet prs = null;	
		prs = stmt.executeQuery(
			"SELECT pid FROM " + cat+ " WHERE name ='" + pname + "';");	
		if(!prs.next()) {
			Integer i_pid = (Integer)application.getAttribute("product_id");
			if(i_pid == null || i_pid == 0){
				i_pid = 2;
			}else{
				i_pid++;
			}
			application.setAttribute("question_id", i_pid);
			ResultSet pidcheck;
			do {
				pidcheck = stmt.executeQuery("SELECT pid FROM product WHERE pid = '" + i_pid + "';");
			} while(pidcheck.next());
			pid = i_pid + "";
			
			stmt.execute("INSERT INTO product(pid) values('" + pid + "');");
			if(!cat.equals("video_game"))
			stmt.execute("INSERT INTO " + cat + "(pid, name) values('" + pid + "','" + pname + "');");
			else
				stmt.execute("INSERT INTO " + cat + "_game (pid, name) values('" + pid + "','" + pname + "');");
		} else {
		 	pid = prs.getString("pid");
		}
		
		
		String desc = request.getParameter("desc");
		String name = request.getParameter("pname");
		String sminprice = request.getParameter("price");
		double minprice = Float.parseFloat(sminprice);
		String end_date = request.getParameter("end_dt");
		
		int i_lid = 0;
		ResultSet lidcheck;
		do {
			i_lid++;
			lidcheck = stmt.executeQuery("SELECT listing_id FROM listing WHERE listing_id = '" + i_lid + "';");
		} while(lidcheck.next());
		String listing_id = i_lid + "";
		
		
		
		String listing = "INSERT into listing(listing_id, seller, pid, description, reserve, end_date) values('" + 
		listing_id + "','" + username + "','" + pid + "','" + desc + "','" + minprice + "','" + end_date + "');";
		stmt.execute(listing);
		
		if(cat.equals("party_game")) {
			String smin_age = "";
			String maker = "";
			int min_age = 0;
			if(!request.getParameter("party_minage").equals("")) {
				smin_age = request.getParameter("party_minage");
				min_age = Integer.parseInt(smin_age);
				stmt.execute("UPDATE party_game SET min_age = " + min_age + " where pid ='" + pid+ "';");
			}
			if(!request.getParameter("party_maker").equals("")) {
				maker = request.getParameter("party_maker");
				stmt.execute("UPDATE party_game set maker = '" + maker + "' where pid ='" + pid+ "';");
			}
		}
		
		if(cat.equals("video_game")) {
			String developer = "";
			String rating = "";
			String publisher = "";
			String genre = "";
			if(!request.getParameter("video_genre").equals("")) {
				genre = request.getParameter("video_genre");
				stmt.execute("UPDATE video_game SET genre = '" + genre + "' where pid ='" + pid+ "';");
			}
			if(!request.getParameter("video_dev").equals("")) {
				developer = request.getParameter("video_dev");
				stmt.execute("UPDATE video_game set developer = '" + developer + "' where pid ='" + pid+ "';");
			}
			if(!request.getParameter("video_pub").equals("")) {
				publisher = request.getParameter("video_pub");
				stmt.execute("UPDATE video_game set publisher = '" + publisher + "' where pid ='" + pid+ "';");
			}
			if(!request.getParameter("video_rat").equals("")) {
				rating = request.getParameter("video_rat");
				stmt.execute("UPDATE video_game set rating = '" + rating + "' where pid ='" + pid+ "';");
			}
		}
		
		if(cat.equals("tabletop_game")) {
			String smin_age = "";
			String maker = "";
			String genre = "";
			int min_age = 0;
			if(!request.getParameter("tabletop_minage").equals("")) {
				smin_age = request.getParameter("tabletop_minage");
				min_age = Integer.parseInt(smin_age);
				stmt.execute("UPDATE tabletop_game SET min_age = " + min_age + " where pid ='" + pid+ "';");
			}
			if(!request.getParameter("tabletop_maker").equals("")) {
				maker = request.getParameter("tabletop_maker");
				stmt.execute("UPDATE tabletop_game SET maker = '" + maker + "' where pid ='" + pid+ "';");
			}
			if(!request.getParameter("tabletop_genre").equals("")) {
				genre = request.getParameter("tabletop_maker");
				stmt.execute("UPDATE tabletop_game SET genre = '" + genre + "' where pid ='" + pid+ "';");
			}
		}
		
		out.println("Your listing has been successfully added");
		
	
	}
	%>
	
	
	<form action="createlisting.jsp" method="post">
		<br /> <br /> <br /> <br />
		<div align="center">
			Product Name:<input type="text" name="pname"
				required />
		</div>
		<div align="center">
 	 	<input type="radio" id = 'party' name="cat" value="party_game" onclick="javascript:catCheck();" required> Party<br>
 		 <input type="radio" id = 'video' name="cat" value="video_game" onclick="javascript:catCheck();" > Video Game<br>
  		<input type="radio" id = 'tabletop' name="cat" value="tabletop_game" onclick="javascript:catCheck();" > Tabletop
  		</div>
  		
  		<script type="text/javascript">

		function catCheck() {
		    if (document.getElementById('party').checked) {
		    	document.getElementById('video_game').style.visibility = 'hidden';
		    	document.getElementById('tabletop_game').style.visibility = 'hidden';
		        document.getElementById('party_game').style.visibility = 'visible';
		        
		    } else if(document.getElementById('video').checked) {
		    	document.getElementById('party_game').style.visibility = 'hidden';
		    	document.getElementById('tabletop_game').style.visibility = 'hidden';
		        document.getElementById('video_game').style.visibility = 'visible';
		        
		    } else if(document.getElementById('tabletop').checked) {
		    	document.getElementById('party_game').style.visibility = 'hidden';
		    	document.getElementById('video_game').style.visibility = 'hidden';
		    	document.getElementById('tabletop_game').style.visibility = 'visible';
		    }
		}

</script>
  		<br>   	
		<br/><br/>
		<div align="center">
			Description:<input type="text" name="desc"
				required />
		</div>
		<br /> <br />
		<div align="center">
			Min Price:<input type="number" name="price" required />
		</div>
		<br /> <br />
		<div align="center">
			End Date and Time:<input type="datetime-local" placeholder = "yyyy-MM-dd hh:mm:ss" name="end_dt"
				required />
		</div>
		<br /> <br /> <br />
		
		<div align="center" id="party_game" style="visibility:hidden">
  		Minimum Age
  	   	<input type='number' id='party_minage' name='party_minage'/>
  	   	<br>
  	   	Maker
  	   	<input type='text' id='party_maker' name='party_maker'/>
		</div>
		<div align="center" id="video_game" style="visibility:hidden">
  		Genre
  	   	<input type='text' id='video_genre' name='video_genre'/>
  	   	<br>
  	   	Publisher
  	   	<input type='text' id='video_pub' name='video_pub'/>
  	   	<br>
  	   	Developer
  	   	<input type='text' id='video_dev' name='video_dev'/>
  	   	<br>
  	   	Rating
  	   	<input type='text' id='video_rat' name='video_rat'/>
  	   	<br>
  	   	</div>
  	   	<div align="center" id="tabletop_game" style="visibility:hidden">
  		Genre
  	   	<input type='text' id='tabletop_genre' name='tabletop_genre'/>
  	   	<br>
  	   	Maker
  	   	<input type='text' id='tabletop_maker' name='tabletop_maker'/>
  	   	<br>
  	   	Min_age
  	   	<input type='number' id='tabletop_minage' name='tabletop_minage'/>
  	   	<br>
  	   	</div>
		<br>
		<div align="center">
			<button type="submit">Create Listing</button>
		</div>
	</form>   
	<form action="home.jsp" name="home" method="post">
		<br /> <br /> <br /> <br />
		<div align="center">
			<button type="submit">Home</button>
		</div>
	</form>
</body>
</html>