package cpsc4620;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Date;

/*
 * This file is where most of your code changes will occur You will write the code to retrieve
 * information from the database, or save information to the database
 * 
 * The class has several hard coded static variables used for the connection, you will need to
 * change those to your connection information
 * 
 * This class also has static string variables for pickup, delivery and dine-in. If your database
 * stores the strings differently (i.e "pick-up" vs "pickup") changing these static variables will
 * ensure that the comparison is checking for the right string in other places in the program. You
 * will also need to use these strings if you store this as boolean fields or an integer.
 * 
 * 
 */

/**
 * A utility class to help add and retrieve information from the database
 */

public final class DBNinja {
	private static Connection conn;

	// Change these variables to however you record dine-in, pick-up and delivery,
	// and sizes and crusts
	public final static String pickup = "PickUp";
	public final static String delivery = "Delivery";
	public final static String dine_in = "DineIn";

	public final static String size_s = "Small";
	public final static String size_m = "Medium";
	public final static String size_l = "Large";
	public final static String size_xl = "XLarge";

	public final static String crust_thin = "Thin";
	public final static String crust_orig = "Original";
	public final static String crust_pan = "Pan";
	public final static String crust_gf = "Gluten-Free";

	private static boolean connect_to_db() throws SQLException, IOException {

		try {
			conn = DBConnector.make_connection();
			return true;
		} catch (SQLException e) {
			return false;
		} catch (IOException e) {
			return false;
		}

	}

	public static void addOrder(Order o) throws SQLException, IOException {
		connect_to_db();

		// TODO Implement converted present time to date string
		String orderDateString = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());

		PreparedStatement os = conn
				.prepareStatement(String.format(
						"INSERT INTO pizzaorder VALUES (%d, %.2f, %.2f, ?, %d, ?);",
						0,
						0.0, 0.0, 0, o.getOrderType()), Statement.RETURN_GENERATED_KEYS);
		os.setString(1, orderDateString);
		os.setString(2, o.getOrderType());
		os.executeUpdate();

		os.executeUpdate();
		ResultSet generated_keys = os.getGeneratedKeys();
		if (generated_keys.next()) {
			int order_id = (int) generated_keys.getLong(1);
			PreparedStatement add_bridge;
			switch (o.getOrderType()) {
				case dine_in:
					add_bridge = conn.prepareStatement(
							String.format("INSERT INTO dinein VALUES (%d, %d);", order_id,
									((DineinOrder) o).getTableNum()));
					break;
				case pickup:
					add_bridge = conn.prepareStatement(
							String.format("INSERT INTO pickup VALUES (%d, %d);", order_id,
									o.getCustID()));
					break;
				default:
					add_bridge = conn.prepareStatement(
							String.format("INSERT INTO delivery VALUES (%d, %d);", order_id,
									o.getCustID()));
					break;
			}
			add_bridge.executeUpdate();
		}
		// Below commented code prints out the order dates, intended to check for
		// accuracy of insert
		// PreparedStatement check = conn.prepareStatement("SELECT * FROM
		// pizzaorder");
		// ResultSet rset2 = check.executeQuery();
		// while (rset2.next()) {
		// System.out.println(rset2.getString("PizzaOrderDate"));
		// }

		conn.close();
		/*
		 * add code to add the order to the DB. Remember that we're not just
		 * adding the order to the order DB table, but we're also recording
		 * the necessary data for the delivery, dinein, and pickup tables
		 * 
		 */

		// DO NOT FORGET TO CLOSE YOUR CONNECTION
	}

	public static void addPizza(Pizza p) throws SQLException, IOException {

		connect_to_db();

		/*
		 * Add the code needed to insert the pizza into into the database.
		 * Keep in mind adding pizza discounts and toppings associated with the pizza,
		 * there are other methods below that may help with that process.
		 * 
		 */

		// TODO Implement converted present time to date string
		PreparedStatement getPizzaBase = conn.prepareStatement(
				"SELECT PizzaBaseNum FROM pizzabase WHERE PizzaBaseSize=? AND PizzaBaseCrust=?;");
		getPizzaBase.setString(1, p.getSize());
		getPizzaBase.setString(2, p.getCrustType());
		ResultSet rset2 = getPizzaBase.executeQuery();
		int pizzabase = -1;
		while (rset2.next()) {
			pizzabase = rset2.getInt("PizzaBaseNum");
		}
		int pizzaState = 0;
		if (p.getPizzaState() == "Completed") {
			pizzaState = 1;
		}
		PreparedStatement os = conn
				.prepareStatement(String.format(
						"INSERT INTO pizza VALUES (%d, %d, %d, %.2f, %.2f,%d);",
						0, getLastOrder().getOrderID(), pizzabase,
						p.getCustPrice(), p.getBusPrice(), pizzaState), Statement.RETURN_GENERATED_KEYS);

		os.executeUpdate();
		ResultSet generated_keys = os.getGeneratedKeys();
		if (generated_keys.next()) {
			long pizza_id = generated_keys.getLong(1);
			p.setPizzaID((int) pizza_id);
			for (Topping i : p.getToppings()) {
				useTopping(p, i, false);

			}
			for (Discount i : p.getDiscounts()) {
				usePizzaDiscount(p, i);

			}
		}
		conn.close();
		connect_to_db();
		PreparedStatement update_order_price = conn.prepareStatement(
				String.format("UPDATE pizzaorder SET PizzaOrderPrice=PizzaOrderPrice+%.2f WHERE PizzaOrderNum=%d;",
						p.getCustPrice(), p.getOrderID()));
		update_order_price.executeUpdate();
		PreparedStatement update_order_cost = conn.prepareStatement(
				String.format("UPDATE pizzaorder SET PizzaOrderCost=PizzaOrderCost+%.2f WHERE PizzaOrderNum=%d;",
						p.getBusPrice(), p.getOrderID()));
		update_order_cost.executeUpdate();

		// Below commented code prints out the pizza prices, intended to check for
		// accuracy of insert
		// PreparedStatement check = conn.prepareStatement("SELECT * FROM pizza");
		// ResultSet rset3 = check.executeQuery();
		// while (rset3.next()) {
		// System.out.println(rset3.getString("PizzaPrice"));
		// }

		conn.close();

		// DO NOT FORGET TO CLOSE YOUR CONNECTION
	}

	public static void useTopping(Pizza p, Topping t, boolean isDoubled) throws SQLException, IOException // this method
																											// using t
																											// //
																											// topping
	{
		connect_to_db();
		/*
		 * This method should do 2 two things.
		 * - update the topping inventory every time we use t topping (accounting for
		 * extra toppings as well)
		 * - connect the topping to the pizza
		 * What that means will be specific to your yimplementatinon.
		 * 
		 * Ideally, you should't let toppings go negative....but this should be dealt
		 * with BEFORE calling this method.
		 * 
		 */
		double amount_to_subtract = 0.0;

		switch (p.getSize()) {
			case size_s:
				amount_to_subtract = t.getPerAMT();
				break;
			case size_m:
				amount_to_subtract = t.getMedAMT();
				break;
			case size_l:
				amount_to_subtract = t.getLgAMT();
				break;
			case size_xl:
				amount_to_subtract = t.getXLAMT();
				break;
		}
		if (isDoubled) {
			amount_to_subtract *= 2;
		}
		PreparedStatement os = conn
				.prepareStatement(
						String.format("UPDATE topping SET ToppingQOH=ToppingQOH-%.2f WHERE ToppingNum=%d;",
								amount_to_subtract, t.getTopID()));
		os.executeUpdate();
		PreparedStatement add_bridge = conn.prepareStatement(String.format(
				"INSERT INTO pizzatopping VALUES (%d,%d,%d);", p.getPizzaID(), t.getTopID(), isDoubled ? 1 : 0));
		add_bridge.executeUpdate();
		// Below commented code prints out the pizza topping bridge, intended to check
		// for
		// accuracy of insert
		// PreparedStatement check = conn.prepareStatement("SELECT * FROM
		// pizzatopping");
		// ResultSet rset2 = check.executeQuery();
		// while (rset2.next()) {
		// System.out.println(rset2.getString("PizzaToppingToppingNum"));
		// System.out.println(rset2.getString("PizzaToppingPizzaNum"));
		// System.out.println("");
		// }
		conn.close();
		// DO NOT FORGET TO CLOSE YOUR CONNECTION
	}

	public static void usePizzaDiscount(Pizza p, Discount d) throws SQLException, IOException {
		connect_to_db();
		/*
		 * This method connects a discount with a Pizza in the database.
		 * 
		 * What that means will be specific to your implementatinon.
		 */

		PreparedStatement os = conn.prepareStatement(
				String.format("INSERT INTO pizzadiscount VALUES (%d,%d);", p.getPizzaID(), d.getDiscountID()));
		os.executeUpdate();
		// Code below to test the function

		// PreparedStatement test = conn.prepareStatement("SELECT * FROM
		// pizzadiscount;");
		// ResultSet testResult = test.executeQuery();
		// while (testResult.next()) {
		// System.out.println(testResult.getInt("PizzaDiscountPizzaNum"));
		// System.out.println(testResult.getInt("PizzaDiscountNum"));
		// System.out.println("");
		// }
		conn.close();
		// DO NOT FORGET TO CLOSE YOUR CONNECTION
	}

	public static void useOrderDiscount(Order o, Discount d) throws SQLException, IOException {
		connect_to_db();
		/*
		 * This method connects a discount with an order in the database
		 * 
		 * You might use this, you might not depending on where / how to want to update
		 * this information in the dabast
		 */
		PreparedStatement os = conn.prepareStatement(
				String.format("INSERT INTO orderdiscount VALUES (%d,%d);", o.getOrderID(), d.getDiscountID()));
		os.executeUpdate();

		o.addDiscount(d);
		PreparedStatement updatePrice = conn.prepareStatement(
				String.format("UPDATE pizzaorder SET PizzaOrderPrice=%.2f WHERE PizzaOrderNum=%d;",
						o.getCustPrice(), o.getOrderID()));

		updatePrice.executeUpdate();
		// Code below to test the function
		/*
		 * PreparedStatement test =
		 * conn.prepareStatement("SELECT * FROM orderdiscount;");
		 * ResultSet testResult = test.executeQuery();
		 * while (testResult.next()) {
		 * System.out.println(testResult.getInt("PizzaDiscountOrderNum"));
		 * System.out.println(testResult.getInt("PizzaDiscountDiscountNum"));
		 * System.out.println("");
		 * }
		 */
		conn.close();

		// DO NOT FORGET TO CLOSE YOUR CONNECTION
	}

	public static void addCustomer(Customer c) throws SQLException, IOException {
		connect_to_db();

		PreparedStatement os = conn
				.prepareStatement(String.format(
						"INSERT INTO customer VALUES (%d, ?, ?,?, ?, ?, %d, ?);",
						0,
						null));
		os.setString(1, c.getFName());
		os.setString(2, c.getLName());
		os.setString(3, c.getAddress());
		os.setString(4, null);
		os.setString(5, null);
		os.setString(6, c.getPhone());

		os.executeUpdate();
		// Below commented code prints out the order dates, intended to check for
		// accuracy of insert
		/*
		 * PreparedStatement check = conn.prepareStatement("SELECT * FROM
		 * customer");
		 * ResultSet rset2 = check.executeQuery();
		 * while (rset2.next()) {
		 * System.out.println(rset2.getString("CustomerFName"));
		 * }
		 */

		conn.close();
		/*
		 * This method adds a new customer to the database.
		 * 
		 */

		// DO NOT FORGET TO CLOSE YOUR CONNECTION
	}

	public static void completeOrder(Order o) throws SQLException, IOException {
		connect_to_db();
		/*
		 * Find the specifed order in the database and mark that order as complete in
		 * the database.
		 * 
		 */
		PreparedStatement os = conn.prepareStatement(String
				.format("UPDATE pizzaorder SET PizzaOrderComplete=True WHERE PizzaOrderNum=%d;", o.getOrderID()));
		os.executeUpdate();
		conn.close();
		// DO NOT FORGET TO CLOSE YOUR CONNECTION
	}

	public static ArrayList<Order> getOrders(boolean openOnly) throws SQLException, IOException {
		/*
		 * Return an arraylist of all of the orders.
		 * openOnly == true => only return a list of open (ie orders that have not been
		 * marked as completed)
		 * == false => return a list of all the orders in the database
		 * Remember that in Java, we account for supertypes and subtypes
		 * which means that when we create an arrayList of orders, that really
		 * means we have an arrayList of dineinOrders, deliveryOrders, and pickupOrders.
		 * 
		 * Don't forget to order the data coming from the database appropriately.
		 * 
		 */

		ArrayList<Order> orders = new ArrayList<>();
		connect_to_db();

		PreparedStatement stmt = null;
		ResultSet rs = null;

		try {
			String query = "SELECT o.*, d.DineInTableNum, p.PickupCustomerID, de.DeliveryCustomerID, " +
					"c.CustomerStreet, c.CustomerCity, c.CustomerState, c.CustomerZip " +
					"FROM pizzaorder o " +
					"LEFT JOIN dinein d ON o.PizzaOrderNum = d.DineInPizzaOrderNum " +
					"LEFT JOIN pickup p ON o.PizzaOrderNum = p.PickupPizzaOrderNum " +
					"LEFT JOIN delivery de ON o.PizzaOrderNum = de.DeliveryPizzaOrderNum " +
					"LEFT JOIN customer c ON p.PickupCustomerID = c.CustomerID OR de.DeliveryCustomerID = c.CustomerID "
					+
					(openOnly ? "WHERE o.PizzaOrderComplete = FALSE " : "") +
					"ORDER BY o.PizzaOrderDate DESC";

			stmt = conn.prepareStatement(query);
			rs = stmt.executeQuery();

			while (rs.next()) {
				int orderNum = rs.getInt("PizzaOrderNum");
				double price = rs.getDouble("PizzaOrderPrice");
				double cost = rs.getDouble("PizzaOrderCost");
				Timestamp orderTimestamp = rs.getTimestamp("PizzaOrderDate");
				int isComplete = rs.getInt("PizzaOrderComplete");
				String orderType = rs.getString("PizzaOrderType");

				// Convert Date to formatted string
				String orderDateString = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(orderTimestamp);

				// Map boolean isComplete to int (0 or 1)
				// int isCompleteInt = isComplete ? 1 : 0;

				Order order;
				switch (orderType) {
					case dine_in:
						int tableNum = rs.getInt("DineInTableNum");
						order = new DineinOrder(orderNum, 0, orderDateString, cost, price, isComplete, tableNum);
						break;
					case pickup:
						int pickupCustomerID = rs.getInt("PickupCustomerID");
						order = new PickupOrder(orderNum, pickupCustomerID, orderDateString, price, cost, isComplete,
								isComplete);
						break;
					case delivery:
						int deliveryCustomerID = rs.getInt("DeliveryCustomerID");
						String customerStreet = rs.getString("CustomerStreet");
						String customerCity = rs.getString("CustomerCity");
						String customerState = rs.getString("CustomerState");
						int customerZip = rs.getInt("CustomerZip");
						String customerAddress = customerStreet + ", " + customerCity + ", " + customerState + " "
								+ customerZip;
						order = new DeliveryOrder(orderNum, deliveryCustomerID, orderDateString, price, cost,
								isComplete, customerAddress);
						break;
					default:
						continue;
				}
				orders.add(order);
			}
		} catch (SQLException e) {
			System.out.println("SQL Exception: " + e.getMessage());
			throw e;
		} finally {
			if (rs != null)
				try {
					rs.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			if (stmt != null)
				try {
					stmt.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
		}
		return orders;
	}

	public static Order getLastOrder() throws SQLException, IOException {
		/*
		 * Query the database for the LAST order added
		 * then return an Order object for that order.
		 * NOTE...there should ALWAYS be a "last order"!
		 */
		int maxID = 0;
		Order lastOrder = null;
		ArrayList<Order> orderList = getOrders(false);

		for (Order i : orderList) {
			if (maxID < i.getOrderID()) {
				maxID = i.getOrderID();
				lastOrder = i;
			}
		}
		return lastOrder;

	}

	public static ArrayList<Order> getOrdersByDate(String date) throws SQLException, IOException {
		/*
		 * Query the database for ALL the orders placed on a specific date
		 * and return a list of those orders.
		 * 
		 * A large chunk of this code repeats in getOrders(), namely the
		 * while(rs.next()) block. Refactor later.
		 */

		ArrayList<Order> orders = new ArrayList<>();
		connect_to_db();

		PreparedStatement stmt = null;
		ResultSet rs = null;

		try {
			String query = "SELECT o.*, d.DineInTableNum, p.PickupCustomerID, de.DeliveryCustomerID, " +
					"c.CustomerStreet, c.CustomerCity, c.CustomerState, c.CustomerZip " +
					"FROM pizzaorder o " +
					"LEFT JOIN dinein d ON o.PizzaOrderNum = d.DineInPizzaOrderNum " +
					"LEFT JOIN pickup p ON o.PizzaOrderNum = p.PickupPizzaOrderNum " +
					"LEFT JOIN delivery de ON o.PizzaOrderNum = de.DeliveryPizzaOrderNum " +
					"LEFT JOIN customer c ON p.PickupCustomerID = c.CustomerID OR de.DeliveryCustomerID = c.CustomerID "
					+
					"WHERE DATE(o.PizzaOrderDate) = ? " + // Filter by specific date
					"ORDER BY o.PizzaOrderDate DESC";

			stmt = conn.prepareStatement(query);
			stmt.setString(1, date); // Set the parameter value
			rs = stmt.executeQuery();

			while (rs.next()) {
				int orderNum = rs.getInt("PizzaOrderNum");
				double price = rs.getDouble("PizzaOrderPrice");
				double cost = rs.getDouble("PizzaOrderCost");
				Timestamp orderTimestamp = rs.getTimestamp("PizzaOrderDate");
				boolean isComplete = rs.getBoolean("PizzaOrderComplete");
				String orderType = rs.getString("PizzaOrderType");

				// Convert Date to formatted string
				String orderDateString = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(orderTimestamp);

				// Map boolean isComplete to int (0 or 1)
				int isCompleteInt = isComplete ? 1 : 0;

				Order order;
				switch (orderType) {
					case "DineIn":
						int tableNum = rs.getInt("DineInTableNum");
						order = new DineinOrder(orderNum, 0, orderDateString, cost, price, isCompleteInt, tableNum);
						break;
					case "PickUp":
						int pickupCustomerID = rs.getInt("PickupCustomerID");
						int isPickedUp = 0;
						order = new PickupOrder(orderNum, pickupCustomerID, orderDateString, price, cost, isPickedUp,
								isCompleteInt);
						break;
					case "Delivery":
						int deliveryCustomerID = rs.getInt("DeliveryCustomerID");
						String customerStreet = rs.getString("CustomerStreet");
						String customerCity = rs.getString("CustomerCity");
						String customerState = rs.getString("CustomerState");
						int customerZip = rs.getInt("CustomerZip");
						String customerAddress = customerStreet + ", " + customerCity + ", " + customerState + " "
								+ customerZip;
						order = new DeliveryOrder(orderNum, deliveryCustomerID, orderDateString, price, cost,
								isCompleteInt, customerAddress);
						break;
					default:
						continue;
				}
				orders.add(order);
			}
		} catch (SQLException e) {
			System.out.println("SQL Exception: " + e.getMessage());
			throw e;
		} finally {
			if (rs != null)
				try {
					rs.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			if (stmt != null)
				try {
					stmt.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
		}
		return orders;
	}

	public static ArrayList<Discount> getDiscountList() throws SQLException, IOException {
		connect_to_db();
		/*
		 * Query the database for all the available discounts and
		 * return them in an arrayList of discounts.
		 * 
		 */
		PreparedStatement os = conn.prepareStatement("Select * from discount");
		ResultSet rs = os.executeQuery();
		ArrayList<Discount> discounts = new ArrayList<Discount>();
		while (rs.next()) {
			if (rs.getString("DiscountType") == "%") {
				discounts.add(new Discount(rs.getInt("DiscountNum"), rs.getString("DiscountName"),
						rs.getDouble("DiscountAmt"), true));
			} else {
				discounts.add(new Discount(rs.getInt("DiscountNum"), rs.getString("DiscountName"),
						rs.getDouble("DiscountAmt"), false));

			}
		}
		// DO NOT FORGET TO CLOSE YOUR CONNECTION
		conn.close();

		return discounts;
	}

	public static Discount findDiscountByName(String name) throws SQLException, IOException {
		/*
		 * Query the database for a discount using it's name.
		 * If found, then return an OrderDiscount object for the discount.
		 * If it's not found....then return null
		 * 
		 */
		ArrayList<Discount> discountList = getDiscountList();
		for (Discount i : discountList) {
			if (i.getDiscountName().equals(name)) {
				return i;
			}
		}
		return null;
	}

	public static ArrayList<Customer> getCustomerList() throws SQLException, IOException {
		connect_to_db();
		/*
		 * Query the data for all the customers and return an arrayList of all the
		 * customers.
		 * Don't forget to order the data coming from the database appropriately.
		 * 
		 */

		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		ArrayList<Customer> customerList = new ArrayList<>();

		try {
			conn = DBConnector.make_connection(); // Assuming DBConnector.make_connection() establishes the database
													// connection
			String query = "SELECT CustomerID, CustomerFName, CustomerLName, CustomerPhone FROM customer ORDER BY CustomerID";
			preparedStatement = conn.prepareStatement(query);
			resultSet = preparedStatement.executeQuery();

			// Process the result set and populate Customer objects
			while (resultSet.next()) {
				int customerId = resultSet.getInt("CustomerID");
				String customerFname = resultSet.getString("CustomerFname");
				String customerLname = resultSet.getString("CustomerLname");
				String customerPhone = resultSet.getString("CustomerPhone");

				Customer customer = new Customer(customerId, customerFname, customerLname, customerPhone);
				customerList.add(customer);
			}
		} finally {
			// Close resources in a finally block to ensure they are always closed
			if (resultSet != null) {
				resultSet.close();
			}
			if (preparedStatement != null) {
				preparedStatement.close();
			}
			if (conn != null) {
				conn.close();
			}
		}

		return customerList;
	}

	public static void printCustomerList(ArrayList<Customer> customerList) {
		for (Customer customer : customerList) {
			System.out.printf("CustID=%d | Name=%s %s, Phone=%s\n",
					customer.getCustID(),
					customer.getFName(),
					customer.getLName(),
					customer.getPhone());
		}
	}

	public static Customer findCustomerByPhone(String phoneNumber) throws SQLException, IOException {
		/*
		 * Query the database for a customer using a phone number.
		 * If found, then return a Customer object for the customer.
		 * If it's not found....then return null
		 * 
		 */
		ArrayList<Customer> customers = getCustomerList();
		for (Customer i : customers) {
			if (i.getPhone().equals(phoneNumber)) {
				return i;
			}
		}
		return null;
	}

	public static ArrayList<Topping> getToppingList() throws SQLException, IOException {
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		ArrayList<Topping> toppingList = new ArrayList<>();

		try {
			connect_to_db();

			// Prepare the SQL query to retrieve available toppings
			String query = "SELECT * FROM topping ORDER BY ToppingNum";
			preparedStatement = conn.prepareStatement(query);
			resultSet = preparedStatement.executeQuery();

			// Process the result set and populate Topping objects
			while (resultSet.next()) {
				int topID = resultSet.getInt("ToppingNum");
				String topName = resultSet.getString("ToppingName");
				double perAMT = resultSet.getDouble("ToppingPersonal");
				double medAMT = resultSet.getDouble("ToppingMedium");
				double lgAMT = resultSet.getDouble("ToppingLarge");
				double xLAMT = resultSet.getDouble("ToppingXLarge");
				double custPrice = resultSet.getDouble("ToppingPrice");
				double busPrice = resultSet.getDouble("ToppingCost");
				int minINVT = resultSet.getInt("ToppingMinQOH");
				int curINVT = resultSet.getInt("ToppingQOH");

				Topping topping = new Topping(topID, topName, perAMT, medAMT, lgAMT, xLAMT, custPrice, busPrice,
						minINVT, curINVT);
				toppingList.add(topping);
			}
		} finally {
			// Close resources in a finally block to ensure they are always closed
			if (resultSet != null) {
				resultSet.close();
			}
			if (preparedStatement != null) {
				preparedStatement.close();
			}
			if (conn != null) {
				conn.close();
			}
		}

		return toppingList;
	}

	public static Topping findToppingByName(String name) throws SQLException, IOException {
		/*
		 * Query the database for the topping using it's name.
		 * If found, then return a Topping object for the topping.
		 * If it's not found....then return null
		 * 
		 * Probably useful for building a pizza for an order. Normally given ToppingName
		 * but need ToppingNum
		 * to construct associated pizza entities.
		 */
		ArrayList<Topping> topping_list = getToppingList();
		for (Topping i : topping_list) {
			if (i.getTopName().equals(name)) {
				return i;
			}
		}
		return null;
	}

	public static void addToInventory(Topping t, double quantity) throws SQLException, IOException {
		/*
		 * Updates the quantity of the topping in the database by the amount specified.
		 * 
		 */

		connect_to_db(); // Establish database connection
		PreparedStatement preparedStatement = null;

		try {

			// Prepare the SQL update statement to increment the ToppingQOH by the specified
			// quantity
			String query = "UPDATE topping SET ToppingQOH = ToppingQOH + ? WHERE ToppingNum = ?";
			preparedStatement = conn.prepareStatement(query);

			// Set the parameters for the prepared statement
			preparedStatement.setDouble(1, quantity);
			preparedStatement.setInt(2, t.getTopID());

			// Execute the update statement
			int rowsAffected = preparedStatement.executeUpdate();
			if (rowsAffected > 0) {
				System.out.println("Inventory updated successfully for topping: " + t.getTopName());
			} else {
				System.out.println("No rows were updated. Topping may not exist in the database.");
			}
		} finally {
			// Close resources in a finally block to ensure they are always closed
			if (preparedStatement != null) {
				preparedStatement.close();
			}
			if (conn != null) {
				conn.close();
			}
		}
	}

	public static double getBaseCustPrice(String size, String crust) throws SQLException, IOException {
		connect_to_db();
		/*
		 * Query the database fro the base customer price for that size and crust pizza.
		 * 
		 */
		PreparedStatement os = conn.prepareStatement(
				"SELECT PizzaBasePrice FROM pizzabase WHERE PizzaBaseSize=? AND PizzaBaseCrust=?;");
		os.setString(1, size);
		os.setString(2, crust);
		ResultSet rs = os.executeQuery();
		while (rs.next()) {
			return rs.getDouble("PizzaBasePrice");
		}
		// DO NOT FORGET TO CLOSE YOUR CONNECTION
		conn.close();

		return 0.0;
	}

	public static double getBaseBusPrice(String size, String crust) throws SQLException, IOException {
		connect_to_db();
		/*
		 * Query the database fro the base business price for that size and crust pizza.
		 * 
		 */

		// DO NOT FORGET TO CLOSE YOUR CONNECTION
		PreparedStatement os = conn.prepareStatement(
				"SELECT PizzaBaseCost FROM pizzabase WHERE PizzaBaseSize=? AND PizzaBaseCrust=?;");
		os.setString(1, size);
		os.setString(2, crust);
		ResultSet rs = os.executeQuery();
		while (rs.next()) {
			return rs.getDouble("PizzaBaseCost");
		}
		// DO NOT FORGET TO CLOSE YOUR CONNECTION
		conn.close();

		return 0.0;
	}

	public static void printInventory() throws SQLException, IOException {
		/*
		 * Queries the database and prints the current topping list with quantities.
		 * 
		 * The result should be readable and sorted as indicated in the prompt.
		 * 
		 */

		connect_to_db(); // Establish connection to db.
		try (
				PreparedStatement preparedStatement = conn
						.prepareStatement("SELECT ToppingNum, ToppingName, ToppingQOH FROM topping");
				ResultSet resultSet = preparedStatement.executeQuery()) {
			printResultSet(resultSet);
		} catch (SQLException e) {
			e.printStackTrace();
		}

		// close connection
		conn.close();
	}

	public static void printToppingPopReport() throws SQLException, IOException {
		connect_to_db();
		/*
		 * Prints the ToppingPopularity view. Remember that this view
		 * needs to exist in your DB, so be sure you've run your createViews.sql
		 * files on your testing DB if you haven't already.
		 * 
		 * The result should be readable and sorted as indicated in the prompt.
		 * 
		 */

		try (
				PreparedStatement preparedStatement = conn.prepareStatement("SELECT * FROM ToppingPopularity");
				ResultSet resultSet = preparedStatement.executeQuery()) {
			printResultSet(resultSet);
		} catch (SQLException e) {
			e.printStackTrace();
		}

		// close connection
		conn.close();
	}

	public static void printProfitByPizzaReport() throws SQLException, IOException {
		connect_to_db();
		/*
		 * Prints the ProfitByPizza view. Remember that this view
		 * needs to exist in your DB, so be sure you've run your createViews.sql
		 * files on your testing DB if you haven't already.
		 * 
		 * The result should be readable and sorted as indicated in the prompt.
		 * 
		 */

		try (
				PreparedStatement preparedStatement = conn.prepareStatement("SELECT * FROM ProfitByPizza");
				ResultSet resultSet = preparedStatement.executeQuery()) {
			printResultSet(resultSet);
		} catch (SQLException e) {
			e.printStackTrace();
		}

		// close connection
		conn.close();
	}

	public static void printProfitByOrderType() throws SQLException, IOException {
		connect_to_db();
		/*
		 * Prints the ProfitByOrderType view. Remember that this view
		 * needs to exist in your DB, so be sure you've run your createViews.sql
		 * files on your testing DB if you haven't already.
		 * 
		 * The result should be readable and sorted as indicated in the prompt.
		 * 
		 */

		try (
				PreparedStatement preparedStatement = conn.prepareStatement("SELECT * FROM ProfitByOrderType");
				ResultSet resultSet = preparedStatement.executeQuery()) {
			printResultSet(resultSet);
		} catch (SQLException e) {
			e.printStackTrace();
		}

		// close connection
		conn.close();

		// DO NOT FORGET TO CLOSE YOUR CONNECTION
	}

	public static String getCustomerName(int CustID) throws SQLException, IOException {
		/*
		 * This is a helper method to fetch and format the name of a customer
		 * based on a customer ID. This is an example of how to interact with
		 * your database from Java. It's used in the model solution for this
		 * project...so the code works!
		 * 
		 * OF COURSE....this code would only work in your application if the table &
		 * field names match!
		 *
		 */

		connect_to_db();

		// /*
		// * an example query using a constructed string...
		// * remember, this style of query construction could be subject to sql
		// injection
		// * attacks!
		// *
		// */
		// String cname1 = "";
		// String query = "Select FName, LName From customer WHERE CustID=" + CustID +
		// ";";
		// Statement stmt = conn.createStatement();
		// ResultSet rset = stmt.executeQuery(query);

		// while (rset.next()) {
		// cname1 = rset.getString(1) + " " + rset.getString(2);
		// }

		/*
		 * an example of the same query using a prepared statement...
		 * 
		 */
		String cname2 = "";
		PreparedStatement os;
		ResultSet rset2;
		String query2;
		query2 = "Select CustomerFName, CustomerLName From customer WHERE CustomerID=?;";
		os = conn.prepareStatement(query2);
		os.setInt(1, CustID);
		rset2 = os.executeQuery();
		while (rset2.next()) {
			cname2 = rset2.getString("CustomerFName") + " " + rset2.getString("CustomerLName"); // note the use of field
																								// names in the
			// getSting methods
		}

		conn.close();
		return cname2; // OR cname1
	}

	public static void printResultSet(ResultSet resultSet) throws SQLException {
		ResultSetMetaData metaData = resultSet.getMetaData();
		int columnCount = metaData.getColumnCount();

		// Print column headers
		for (int i = 1; i <= columnCount; i++) {
			String columnName = metaData.getColumnName(i);
			System.out.printf("%-20s", columnName); // Adjust width as needed
		}
		System.out.println(); // New line after column headers

		// Print separator line
		for (int i = 1; i <= columnCount; i++) {
			System.out.print("".format("%-20s", "").replace(' ', '-')); // Adjust width as needed
		}
		System.out.println(); // New line after separator line

		// Print data rows
		while (resultSet.next()) {
			for (int i = 1; i <= columnCount; i++) {
				String columnValue = resultSet.getString(i);
				System.out.printf("%-20s", columnValue); // Adjust width as needed
			}
			System.out.println(); // New line after each row
		}
	}

	public static ArrayList<Pizza> getPizzas(int orderNum) throws SQLException, IOException {
		/*
		 *  This function is designed to build an array list of pizzas associated with a particular order number.
		 *  It facilitates printing the details of orders in the ViewOrders menu option.
		 */

		ArrayList<Pizza> pizzas = new ArrayList<>();
		connect_to_db();

		PreparedStatement stmt = null;
		ResultSet rs = null;
		try {
			// Define SQL query to select pizzas associated with a specific order number
			String sql = 	" SELECT p.PizzaNum, p.PizzaOrderNum, pb.PizzaBaseSize, " +
							" pb.PizzaBaseCrust, p.PizzaPrice, p.PizzaCost, " +
							" p.PizzaIsComplete, o.PizzaOrderDate " +
							" FROM pizza p " +
							" JOIN pizzabase pb ON p.PizzaBaseNum = pb.PizzaBaseNum " +
							" JOIN pizzaorder o ON p.PizzaOrderNum = o.PizzaOrderNum " +
							" WHERE p.PizzaOrderNum = ?"; //place holder for orderNum
			
			// Prepare the statement
			stmt = conn.prepareStatement(sql);

			// Set the value for the order number placeholder
			stmt.setInt(1, orderNum);

			// Execute the query
			rs = stmt.executeQuery();

			// Process the result set
			while (rs.next()) {
				int pizzaID = rs.getInt("PizzaNum");
				String size = rs.getString("PizzaBaseSize");
				String crustType = rs.getString("PizzaBaseCrust");
				int orderID = orderNum;
				String pizzaState = rs.getString("PizzaIsComplete");
				Timestamp pizzaTimestamp =  rs.getTimestamp("PizzaOrderDate");
				BigDecimal custPriceBD = rs.getBigDecimal("PizzaPrice").setScale(2, RoundingMode.HALF_UP);;
				double custPrice = custPriceBD.doubleValue();
				BigDecimal busPricBD = rs.getBigDecimal("PizzaCost").setScale(2, RoundingMode.HALF_UP);;
				double busPrice = busPricBD.doubleValue();

				// Convert Date to formatted string
				String pizzaDateString = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(pizzaTimestamp);
				
				// Assuming there is a Pizza class with a constructor that takes these parameters
				// Pizza pizza = new Pizza(pizzaID, pizzaType, pizzaSize);
				Pizza pizza = new Pizza(pizzaID, size, crustType, orderID, pizzaState, pizzaDateString,
				custPrice, busPrice);

				pizzas.add(pizza);
			}
		} catch (SQLException e) {
			System.err.println("SQL Exception: " + e.getMessage());
			throw e;
		} finally {
			// Clean up resources
			if (rs != null) try { rs.close(); } catch (SQLException ex) { ex.printStackTrace(); }
			if (stmt != null) try { stmt.close(); } catch (SQLException ex) { ex.printStackTrace(); }
			if (conn != null) try { conn.close(); } catch (SQLException ex) { ex.printStackTrace(); }
		}
		return pizzas;
	}

	public static ArrayList<Discount> getOrderDiscounts(int orderNum) throws SQLException, IOException {
		/*
		 * This function helps to display the discounts on an order in ViewOrders menu 
		 */

		ArrayList<Discount> orderDiscounts = new ArrayList<>();
		PreparedStatement stmt = null;
		ResultSet rs = null;
		connect_to_db(); 
	
		try {
			String sql = "SELECT d.DiscountNum, d.DiscountName, d.DiscountType, d.DiscountAmt " +
						 "FROM discount d " +
						 "JOIN orderdiscount od ON d.DiscountNum = od.OrderDiscountNum " +
						 "WHERE od.OrderDiscountPizzaOrderNum = ?";
			
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, orderNum);
			rs = stmt.executeQuery();
	
			while (rs.next()) {
				int discountID = rs.getInt("DiscountNum");
				String discountName = rs.getString("DiscountName");
				String discountType = rs.getString("DiscountType");
				double discountAmount = rs.getDouble("DiscountAmt");
				boolean isPercent = discountType.equals("%"); 
	
				Discount discount = new Discount(discountID, discountName, discountAmount, isPercent);
				orderDiscounts.add(discount);
			}
		} catch (SQLException e) {
			System.err.println("SQL Exception: " + e.getMessage());
			throw e;
		} finally {
			if (rs != null) try { rs.close(); } catch (SQLException ex) { }
			if (stmt != null) try { stmt.close(); } catch (SQLException ex) { }
			if (conn != null) try { conn.close(); } catch (SQLException ex) { }
		}
	
		return orderDiscounts;
	}

	public static ArrayList<Discount> getPizzaDiscounts(int pizzaNum) throws SQLException, IOException {
		/*
		 * This function helps to display the discounts on a pizza in the ViewOrders menu 
		 */

		ArrayList<Discount> pizzaDiscounts = new ArrayList<>();
		PreparedStatement stmt = null;
		ResultSet rs = null;
		connect_to_db(); 
	
		try {
			String sql = "SELECT d.DiscountNum, d.DiscountName, d.DiscountType, d.DiscountAmt " +
						 "FROM discount d " +
						 "JOIN pizzadiscount pd ON d.DiscountNum = pd.PizzaDiscountNum " +
						 "WHERE pd.PizzaDiscountPizzaNum = ?";
			
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, pizzaNum);
			rs = stmt.executeQuery();
	
			while (rs.next()) {
				int discountID = rs.getInt("DiscountNum");
				String discountName = rs.getString("DiscountName");
				String discountType = rs.getString("DiscountType");
				double discountAmount = rs.getDouble("DiscountAmt");
				boolean isPercent = discountType.equals("%"); 
	
				Discount discount = new Discount(discountID, discountName, discountAmount, isPercent);
				pizzaDiscounts.add(discount);
			}
		} catch (SQLException e) {
			System.err.println("SQL Exception: " + e.getMessage());
			throw e;
		} finally {
			if (rs != null) try { rs.close(); } catch (SQLException ex) { }
			if (stmt != null) try { stmt.close(); } catch (SQLException ex) { }
			if (conn != null) try { conn.close(); } catch (SQLException ex) { }
		}
	
		return pizzaDiscounts;
	}

	/*
	 * The next 3 private methods help get the individual components of a SQL
	 * datetime object.
	 * You're welcome to keep them or remove them.
	 */
	private static int getYear(String date)// assumes date format 'YYYY-MM-DD HH:mm:ss'
	{
		return Integer.parseInt(date.substring(0, 4));
	}

	private static int getMonth(String date)// assumes date format 'YYYY-MM-DD HH:mm:ss'
	{
		return Integer.parseInt(date.substring(5, 7));
	}

	private static int getDay(String date)// assumes date format 'YYYY-MM-DD HH:mm:ss'
	{
		return Integer.parseInt(date.substring(8, 10));
	}

	public static boolean checkDate(int year, int month, int day, String dateOfOrder) {
		if (getYear(dateOfOrder) > year)
			return true;
		else if (getYear(dateOfOrder) < year)
			return false;
		else {
			if (getMonth(dateOfOrder) > month)
				return true;
			else if (getMonth(dateOfOrder) < month)
				return false;
			else {
				if (getDay(dateOfOrder) >= day)
					return true;
				else
					return false;
			}
		}
	}

}