package com.payment.util;

public class DBConnet {

import com.payment.util.ClassNotFoundException;
import com.payment.util.Connection;
import com.payment.util.SQLException;

public class DBConnect {

	private static Connection connection;

	public static Connection getDBConnection() throws ClassNotFoundException, SQLException {

		// This creates new connection object when connection is closed or it is null
		if (connection == null || connection.isClosed()) {
			Class.forName("com.mysql.jdbc.Driver");
			connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/payment", "root", "");
		}

		return connection;
	}

}

}
