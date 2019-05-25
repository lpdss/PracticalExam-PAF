package com.payment.service;

public class paymentService {
	package com.payment.service;

	import java.sql.Connection;
	import java.sql.PreparedStatement;
	import java.sql.ResultSet;
	import java.sql.SQLException;
	import java.util.ArrayList;
	import java.util.Base64;

	import com.payment.model.*;
	import com.payment.util.*;



	public class cardService {

		private int success;
		
		public void addCard(Card card) {
			Connection connection;
			PreparedStatement preparedStatement;
			String cardNumber=null;
			
			try {
				connection = DBConnect.getDBConnection();
				
				//check card
				preparedStatement = connection.prepareStatement("select * from cards where cardNumber=? and ccv=? and month=? and year=?");
				preparedStatement.setString(1, card.getCardNumber());
				preparedStatement.setInt(2, card.getCcvCode());
				preparedStatement.setInt(3, card.getMonth());
				preparedStatement.setInt(4, card.getYear());
				ResultSet rs = preparedStatement.executeQuery();
				
				while(rs.next())
				{
					cardNumber = rs.getString(2);
				}
				
				if(cardNumber == null) {
					
					//insert value
					preparedStatement = connection.prepareStatement("insert into cards (cardNumber,ccv,month,year,userEmail) values (?,?,?,?,?)");
					preparedStatement.setString(1, card.getCardNumber());
					preparedStatement.setInt(2, card.getCcvCode());
					preparedStatement.setInt(3, card.getMonth());
					preparedStatement.setInt(4, card.getYear());
					preparedStatement.setString(5, card.getUser());
					preparedStatement.execute();
					preparedStatement.close();
					connection.close();
					setSuccess(1);
					
				}else {
					setSuccess(0);
				}
				rs.close();
				
			}catch (ClassNotFoundException | SQLException  e) {
				System.out.println(e.getMessage());
			}
		}

		public int getSuccess() {
			return success;
		}

		public void setSuccess(int success) {
			this.success = success;
		}
		
		public ArrayList<Card> getCards(String user) {
			
			ArrayList<Card> cardList = new ArrayList<Card>();
			Connection connection;
			PreparedStatement preparedStatement;
			try {
				
				connection = DBConnect.getDBConnection();
				preparedStatement = connection.prepareStatement("select * from cards where userEmail=?");
				preparedStatement.setString(1, user);
				ResultSet resultSet = preparedStatement.executeQuery();
				
				while (resultSet.next()) {
					
					Card card = new Card();
					
					card.setId(Integer.parseInt(resultSet.getString(1)));
					card.setCardNumber(resultSet.getString(2));
					card.setCcvCode(Integer.parseInt(resultSet.getString(3)));
					card.setMonth(Integer.parseInt(resultSet.getString(4)));
					card.setYear(Integer.parseInt(resultSet.getString(5)));
					card.setUser(resultSet.getString(6));
					
					cardList.add(card);
					
				}
				
				preparedStatement.close();
				connection.close();
				
			}catch (ClassNotFoundException | SQLException  e) {
		
				System.out.println(e.getMessage());
			}
		
			return cardList;
		}

		public void deleteCard(Card card) {
			Connection connection;
			PreparedStatement preparedStatement;
			
			try {
				connection = DBConnect.getDBConnection();
				
				//delete card
				preparedStatement = connection.prepareStatement("DELETE FROM cards WHERE id=?");
				preparedStatement.setInt(1, card.getId());
				preparedStatement.execute();
				
				setSuccess(1);
			
			}catch (ClassNotFoundException | SQLException  e) {
				setSuccess(0);
			}
		}

		public ArrayList<Payment> getOrders(String user) {
			
			ArrayList<Payment> paymentList = new ArrayList<Payment>();
			Connection connection;
			PreparedStatement preparedStatement;
			try {
				
				connection = DBConnect.getDBConnection();
				preparedStatement = connection.prepareStatement("select * from payment where user=?");
				preparedStatement.setString(1, user);
				ResultSet resultSet = preparedStatement.executeQuery();
				
				while (resultSet.next()) {
					
					Payment payment = new Payment();
					
					payment.setId(Integer.parseInt(resultSet.getString(1)));
					payment.setName(resultSet.getString(3));
					payment.setAmount(Double.parseDouble(resultSet.getString(4)));
					payment.setQuantity(Integer.parseInt(resultSet.getString(5)));
					payment.setCardNumber(resultSet.getString(6));
					payment.setCancel(Integer.parseInt(resultSet.getString(8)));
					payment.setRefund(Integer.parseInt(resultSet.getString(9)));
					
					paymentList.add(payment);
					
				}
				
				preparedStatement.close();
				connection.close();
				
			}catch (ClassNotFoundException | SQLException  e) {
		
				System.out.println(e.getMessage());
			}
		
			return paymentList;
		}

		public void cancel(Payment payment) {
			
			Connection connection;
			PreparedStatement preparedStatement;
			
			try {
				
				connection = DBConnect.getDBConnection();
				preparedStatement = connection.prepareStatement("UPDATE payment SET cancel=?,refund=? where id=?");
				preparedStatement.setInt(1, 1);
				preparedStatement.setInt(2, 1);
				preparedStatement.setInt(3, payment.getId());
				preparedStatement.execute();
				setSuccess(1);
				preparedStatement.close();
				connection.close();
				
			}catch (ClassNotFoundException | SQLException  e) {
				setSuccess(0);
			}
			
		}
		
	}
