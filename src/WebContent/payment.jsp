<%@page import="com.ebuy.service.*"%>
<%@page import="com.ebuy.model.*"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Ebuy</title>
	<link href='https://fonts.googleapis.com/css?family=Roboto' rel='stylesheet'>

    <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
    <script src="assets/js/jquery.okayNav.js"></script>

    <link rel="stylesheet" type="text/css" href="assets/css/siteStyle.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	<script src="assets/js/sweetalert.min.js"></script>
</head>
<body style="background-image: url('image/buyWall.jpg');width: 100%">
	
	<div class="site_navBar">
        <img src="image/buy.png" class="logo" onclick="window.location.href='profileServlet'">
        <p onclick="window.location.href='logoutServlet'" >Logout</p>
        <p onclick="window.location.href='profileServlet'" >Account</p>
        <table>
            <tr>
                <form id="searchForm">
                    <td><input type="text" id="sreachProducts" placeholder="Search for anythig"></td>
                    <td><input type="submit" value="Search"></td>
                </form>
            </tr>
        </table>
    </div>
	
	<div class="registerBox">
	    <h2>Payment</h2>
	    <form id="productForm" >
	        <p>Product Name</p>
	        <input type="text" id="name" value="${sessionScope.productName }" readonly>
	        <p>Payment Amount</p>
	        <input type="number" id="price" min="0" step="0.01" value="${sessionScope.productAmount }" readonly>
	        <p>Quantity</p>
	        <input type="number" id="quantity" min="0" step="1" value="${sessionScope.productQuantity }" readonly>
	        <p>My Cards </p>
	    	<select id="cardId" onchange="setCardDetail()">
	    		<option value="">Select Card Number</option>
	    		<%
	    			cardService cards = new cardService();
					ArrayList<Card> arrayList = cards.getCards((String)session.getAttribute("email"));
		
					for (Card card : arrayList) {
				%>
				<option value="<%=card.getId() %>" ><%=card.getCardNumber() %></option>
				<%
					}
				%>
	    	</select>
	    	<p>Card Number</p>
	        <input type="Number" id="cardNumber" placeholder="Enter Card Number" maxlength="16" required>
	        <p>CCV Code</p>
	        <input type="Number" id="ccvCode" placeholder="Enter CCV Code" min="0" max="999" required>
	        <p>Expiry Date (Month)</p>
	        <select id="myCardMonth" required>
	        	<option value="">Select Month</option>
	        	<option value="1">01</option>
	        	<option value="2">02</option>
	        	<option value="3">03</option>
	        	<option value="4">04</option>
	        	<option value="5">05</option>
	        	<option value="6">06</option>
	        	<option value="7">07</option>
	        	<option value="8">08</option>
	        	<option value="9">09</option>
	        	<option value="10">10</option>
	        	<option value="11">11</option>
	        	<option value="12">12</option>
	        </select>
	        <p>Expiry Date (Year)</p>
	        <select id="myCardYear" required>
	        	<option value="">Select Year</option>
	        	<option value="19">19</option>
	        	<option value="20">20</option>
	        	<option value="21">21</option>
	        	<option value="22">22</option>
	        	<option value="23">23</option>
	        	<option value="24">24</option>
	        	<option value="25">25</option>
	        	<option value="26">26</option>
	        	<option value="27">27</option>
	        	<option value="28">28</option>
	        	<option value="29">29</option>
	        	<option value="30">30</option>
	        </select>
	        <input type="hidden" id="productId" value="${sessionScope.productID }" required>
	        <input type="hidden" id="user" value="${sessionScope.email }" required>
	        <br><br>
	        <input type="submit" value="Checkout">
	    </form>
	</div>
	
	<div style="display: none;" >
    		<%
				for (Card card : arrayList) {
			%>
			<input id="userCardNumber<%=card.getId() %>"  value="<%=card.getCardNumber() %>">
			<input id="cardCcvCode<%=card.getId() %>"  value="<%=card.getCcvCode() %>">
			<input id="cardMonth<%=card.getId() %>"  value="<%=card.getMonth() %>">
			<input id="cardYear<%=card.getId() %>"  value="<%=card.getYear() %>">
			<%
				}
			%>
    </div>
	
</body>
</html>

<script>

	$(document).ready(function(){
		
		$("#productForm").submit(function(e){
			
        	var jsonfile = JSON.stringify({
        		"id" :  $('#productId').val(),
				"name" : $('#name').val(),
				"amount" : $('#price').val(),
				"quantity" : $('#quantity').val(),
				"cardNumber" : $('#cardNumber').val(),
				"ccvCode" : $('#ccvCode').val(),
				"month" : $('#myCardMonth').val(),
				"year" : $('#myCardYear').val(),
				"user" : $('#user').val()
			});
			
			var ans = $.ajax({
				type : 'POST',
				url : 'http://localhost:8081/Ebuy/rest/payment/payment',
				dataType : 'json',
				contentType : 'application/json',
				data : jsonfile
			});
			
			ans.done(function(data){
				if(data['success']=="1"){
					$.ajax({
			             url:'http://localhost:8080/Ebuy/userServlet',
			             type:'POST',
			             data:{
			            	 "success" : "1"
			             },
			             success : function(data){
			            	 window.location.href = "http://localhost:8080/Ebuy/userServlet";
			             }
			         });
				}else if(data['success']=="0"){
					swal({
			            title: "Error",
			            text: "Payment Unsuccessfull!",
			            icon: "warning",
			            dangerMode: true,
			        });
					$('#name').val("");
					$('#category').val("");
				}
			});
			ans.fail(function(data){
				swal({
	                title: "Error",
	                text: "Connection Error !",
	                icon: "warning",
	                dangerMode: true,
	            });
			});
			
			e.preventDefault();
		});
		
	});
	
	function setCardDetail() {
		
	    var id = document.getElementById("cardId").value;
	
	    var cardNumber = 'userCardNumber'+id;
	    var ccv = 'cardCcvCode'+id;
	    var month = 'cardMonth'+id;
	    var year = 'cardYear'+id;
	
	    document.getElementById("cardNumber").value = document.getElementById(cardNumber).value;
	    document.getElementById("ccvCode").value = document.getElementById(ccv).value;
	    document.getElementById("myCardMonth").value = document.getElementById(month).value;
	    document.getElementById("myCardYear").value = document.getElementById(year).value;
	
	}
	

	$("#searchForm").submit(function(e){
    	
		$.ajax({
             url:'http://localhost:8080/Ebuy/serachServlet',
             type:'POST',
             data:{
            	 "search" : $('#sreachProducts').val()
             },
             success : function(data){
            	 window.location.href = "http://localhost:8080/Ebuy/serachServlet";
             }
         });
		
		e.preventDefault();
	});
	
</script>