package cpsc4620;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/*
 * This file is where the front end magic happens.
 * 
 * You will have to write the methods for each of the menu options.
 * 
 * This file should not need to access your DB at all, it should make calls to the DBNinja that will do all the connections.
 * 
 * You can add and remove methods as you see necessary. But you MUST have all of the menu methods (including exit!)
 * 
 * Simply removing menu methods because you don't know how to implement it will result in a major error penalty (akin to your program crashing)
 * 
 * Speaking of crashing. Your program shouldn't do it. Use exceptions, or if statements, or whatever it is you need to do to keep your program from breaking.
 * 
 */

public class Menu {

	public static BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));

	public static void main(String[] args) throws SQLException, IOException {

		System.out.println("Welcome to Pizzas-R-Us!");

		int menu_option = 0;

		// present a menu of options and take their selection

		PrintMenu();
		String option = reader.readLine();
		menu_option = Integer.parseInt(option);

		while (menu_option != 9) {
			switch (menu_option) {
				case 1:// enter order
					EnterOrder();
					break;
				case 2:// view customers
					viewCustomers();
					break;
				case 3:// enter customer
					EnterCustomer();
					break;
				case 4:// view order
						// open/closed/date
					ViewOrders();
					break;
				case 5:// mark order as complete
					MarkOrderAsComplete();
					break;
				case 6:// view inventory levels
					ViewInventoryLevels();
					break;
				case 7:// add to inventory
					AddInventory();
					break;
				case 8:// view reports
					PrintReports();
					break;
			}
			PrintMenu();
			option = reader.readLine();
			menu_option = Integer.parseInt(option);
		}

	}

	// allow for a new order to be placed
	public static void EnterOrder() throws SQLException, IOException {

		/*
		 * EnterOrder should do the following:
		 * 
		 * Ask if the order is delivery, pickup, or dinein
		 * if dine in....ask for table number
		 * if pickup...
		 * if delivery...
		 * 
		 * Then, build the pizza(s) for the order (there's a method for this)
		 * until there are no more pizzas for the order
		 * add the pizzas to the order
		 *
		 * Apply order discounts as needed (including to the DB)
		 * 
		 * return to menu
		 * 
		 * make sure you use the prompts below in the correct order!
		 */

		// User Input Prompts...
		// DBNinja.addOrder(new Order(0, -1, "dinein", "df", 0.0, 0.0, 0));

		System.out.println(
				"Is this order for: \n1.) Dine-in\n2.) Pick-up\n3.) Delivery\nEnter the number of your choice:");
		String option = reader.readLine();
		int order_option = Integer.parseInt(option);
		String existing_customer = "";
		Order order = new Order(0, 0, "", "", 0.0, 0.0, 0);
		int customer = -1;
		switch (order_option) {
			case 1:
				order.setOrderType("dine-in");
				System.out.println("What is the table number for this order?");
				String table_num_string = reader.readLine();
				int table_num = Integer.parseInt(table_num_string);
				order.setCustID(-1);
				break;
			case 2:
				order.setOrderType("pick-up");
				System.out.println("Is this order for an existing customer? Answer y/n: ");
				existing_customer = reader.readLine();
				while (existing_customer.toLowerCase() != "y" && existing_customer.toLowerCase() != "n") {
					System.out.println("ERROR: I don't understand your input for: Is this order an existing customer?");
					System.out.println("Is this order for an existing customer? Answer y/n: ");
					existing_customer = reader.readLine();
				}
				if (existing_customer.toLowerCase() == "y") {
					System.out.println("Here's a list of the current customers: ");
					DBNinja.getCustomerList();
					System.out.println("Which customer is this order for? Enter ID Number:");
					String customer_string = reader.readLine();
					int customer_int = Integer.parseInt(option);
					order.setCustID(customer_int);
				} else {
					System.out.println("What is this customer's name (first <space> last");
					String name = reader.readLine();
					System.out.println("What is this customer's phone number (##########) (No dash/space)");
					String phone_string = reader.readLine();
					// int phone = Integer.parseInt(phone_string);
					Customer new_customer = new Customer(0, null, null, null);
					new_customer.setFName(name.split(" ")[0]);
					new_customer.setLName(name.split(" ")[1]);
					new_customer.setPhone(phone_string);
					DBNinja.addCustomer(new_customer);
					order.setCustID(DBNinja.findCustomerByPhone(phone_string).getCustID());
				}
				break;
			case 3:
				order.setOrderType("delivery");
				System.out.println("Is this order for an existing customer? Answer y/n: ");
				existing_customer = reader.readLine();
				while (existing_customer.toLowerCase() != "y" && existing_customer.toLowerCase() != "n") {
					System.out.println("ERROR: I don't understand your input for: Is this order an existing customer?");
					System.out.println("Is this order for an existing customer? Answer y/n: ");
					existing_customer = reader.readLine();
				}
				if (existing_customer.toLowerCase() == "y") {
					System.out.println("Here's a list of the current customers: ");
					viewCustomers();
					System.out.println("Which customer is this order for? Enter ID Number:");
					String customer_string = reader.readLine();
					customer = Integer.parseInt(option);

				} else {
					System.out.println("What is this customer's name (first <space> last");
					String name = reader.readLine();
					System.out.println("What is this customer's phone number (##########) (No dash/space)");
					String phone_string = reader.readLine();
					// int phone = Integer.parseInt(phone_string);
					Customer new_customer = new Customer(0, null, null, null);
					new_customer.setFName(name.split(" ")[0]);
					new_customer.setLName(name.split(" ")[1]);
					new_customer.setPhone(phone_string);

					System.out.println("What is the House/Apt Number for this order? (e.g., 111)");
					String house_string = reader.readLine();
					int house = Integer.parseInt(house_string);

					System.out.println("What is the Street for this order? (e.g., Smile Street)");
					String street = reader.readLine();
					System.out.println("What is the City for this order? (e.g., Greenville)");
					String city = reader.readLine();
					System.out.println("What is the State for this order? (e.g., SC)");
					String state = reader.readLine();
					System.out.println("What is the Zip Code for this order? (e.g., 20605)");
					String zip_string = reader.readLine();
					int zip = Integer.parseInt(zip_string);
					new_customer.setAddress(house_string, city, state, zip_string);
					DBNinja.addCustomer(new_customer);
					order.setCustID(DBNinja.findCustomerByPhone(phone_string).getCustID());

				}
				break;
		}
		System.out.println("Let's build a pizza!");
		DBNinja.addOrder(order);
		buildPizza(1);

		System.out.println(
				"Enter -1 to stop adding pizzas...Enter anything else to continue adding pizzas to the order.");
		String add_pizza_string = reader.readLine();
		int add_pizza = Integer.parseInt(add_pizza_string);
		while (add_pizza != -1) {
			buildPizza(1);

			System.out.println(
					"Enter -1 to stop adding pizzas...Enter anything else to continue adding pizzas to the order.");
			add_pizza_string = reader.readLine();
			add_pizza = Integer.parseInt(add_pizza_string);
		}

		System.out.println("Do you want to add discounts to this order? Enter y/n?");
		String add_order_discounts = reader.readLine();
		if (add_order_discounts.toLowerCase() == "y") {
			System.out.println(
					"Which Order Discount do you want to add? Enter the DiscountID. Enter -1 to stop adding Discounts: ");
			String order_discount_string = reader.readLine();
			int order_discount = Integer.parseInt(order_discount_string);
			DBNinja.useOrderDiscount(order, DBNinja.getDiscountList().get(order_discount - 1));

			while (order_discount != -1) {
				System.out.println(
						"Which Order Discount do you want to add? Enter the DiscountID. Enter -1 to stop adding Discounts: ");
				order_discount_string = reader.readLine();
				order_discount = Integer.parseInt(order_discount_string);

				DBNinja.useOrderDiscount(order, DBNinja.getDiscountList().get(order_discount - 1));

			}
		}

		// System.out.println("Is this order for an existing customer? Answer y/n: ");
		// System.out.println("Here's a list of the current customers: ");
		// System.out.println("ERROR: I don't understand your input for: Is this order
		// an existing customer?");
		// System.out.println("What is the table number for this order?");

		// System.out.println("Do you want to add discounts to this order? Enter y/n?");

		System.out.println("Finished adding order...Returning to menu...");

	}

	public static void viewCustomers() throws SQLException, IOException {
		/*
		 * Simply print out all of the customers from the database.
		 */

		try {
			ArrayList<Customer> customerList = DBNinja.getCustomerList();
			DBNinja.printCustomerList(customerList);
		} catch (SQLException | IOException e) {
			e.printStackTrace();
		}
	}

	// Enter a new customer in the database
	public static void EnterCustomer() throws SQLException, IOException {
		/*
		 * Ask for the name of the customer:
		 * First Name <space> Last Name
		 * 
		 * Ask for the phone number.
		 * (##########) (No dash/space)
		 * 
		 * Once you get the name and phone number, add it to the DB
		 */

		// User Input Prompts...
		System.out.println("What is this customer's name (first <space> last");
		String name = reader.readLine();
		System.out.println("What is this customer's phone number (##########) (No dash/space)");
		String phone_string = reader.readLine();
		// int phone = Integer.parseInt(phone_string);
		Customer new_customer = new Customer(0, null, null, null);
		new_customer.setFName(name.split(" ")[0]);
		new_customer.setLName(name.split(" ")[1]);
		new_customer.setPhone(phone_string);
		DBNinja.addCustomer(new_customer);
	}

	// View any orders that are not marked as completed
	public static void ViewOrders() throws SQLException, IOException {
		/*
		 * This method allows the user to select between three different views of the
		 * Order history:
		 * The program must display:
		 * a. all open orders
		 * b. all completed orders
		 * c. all the orders (open and completed) since a specific date (inclusive)
		 * 
		 * After displaying the list of orders (in a condensed format) must allow the
		 * user to select a specific order for viewing its details.
		 * The details include the full order type information, the pizza information
		 * (including pizza discounts), and the order discounts.
		 * 
		 */

		// User Input Prompts...
		System.out.println(
				"Would you like to:\n(a) display all orders [open or closed]\n(b) display all open orders\n(c) display all completed [closed] orders\n(d) display orders since a specific date");
		String order_display_option = reader.readLine();
		ArrayList<Order> order_list = null;
		switch (order_display_option.toLowerCase()) {
			case "a":
				order_list = DBNinja.getOrders(false);
				break;
			case "b":
				order_list = DBNinja.getOrders(true);
				break;
			case "c":
				order_list = DBNinja.getOrders(false);

				// filter using lamba expression
				order_list.removeIf(order -> order.getIsComplete() != 1);
				break;
			case "d":
				System.out.println("What is the date you want to restrict by? (FORMAT= YYYY-MM-DD)");
				String date = reader.readLine();
				order_list = DBNinja.getOrdersByDate(date);
				break;
			default:
				System.out.println("I don't understand that input, returning to menu");
				return;

		}
		if (order_list == null) {
			System.out.println("No orders to display, returning to menu.");
			return;
		}
		for (Order order : order_list) {
			System.out.println(order); 
		}
		System.out.println("Which order would you like to see in detail? Enter the number (-1 to exit): ");
		String specific_order_string = reader.readLine();
		int specific_order = Integer.parseInt(specific_order_string);
		if (specific_order == -1) {
			return;
		}
		for (Order i : order_list) {
			if (i.getOrderID() == specific_order) {
				System.out.println(i.toString());
				break;
			}
		}
		// Else:
		System.out.println("Incorrect entry, returning to menu.");
		return;
		// System.out.println("What is the date you want to restrict by? (FORMAT=
		// YYYY-MM-DD)");
		// System.out.println("I don't understand that input, returning to menu");
		// System.out.println("Which order would you like to see in detail? Enter the
		// number (-1 to exit): ");
		// System.out.println("Incorrect entry, returning to menu.");
		// System.out.println("No orders to display, returning to menu.");

	}

	// When an order is completed, we need to make sure it is marked as complete
	public static void MarkOrderAsComplete() throws SQLException, IOException {
		/*
		 * All orders that are created through java (part 3, not the orders from part 2)
		 * should start as incomplete
		 * 
		 * When this method is called, you should print all of the "opoen" orders marked
		 * and allow the user to choose which of the incomplete orders they wish to mark
		 * as complete
		 * 
		 */

		// User Input Prompts...

		ArrayList<Order> openOrders = DBNinja.getOrders(true);
		if (openOrders.size() == 0) {
			System.out.println("There are no open orders currently... returning to menu...");
			return;
		}
		for (Order i : openOrders) {
			System.out.println(i.toSimplePrint());

		}

		System.out.println("Which order would you like mark as complete? Enter the OrderID: ");
		String order_complete_string = reader.readLine();
		int order_complete = Integer.parseInt(order_complete_string);
		for (Order i : openOrders) {
			if (i.getOrderID() == order_complete) {
				DBNinja.completeOrder(i);
				return;
			}
		}
		System.out.println("Incorrect entry, not an option");
		return;

	}

	public static void ViewInventoryLevels() throws SQLException, IOException {
		/*
		 * Print the inventory. Display the topping ID, name, and current inventory
		 */

		DBNinja.printInventory();
	}

	public static void AddInventory() throws SQLException, IOException {
		/*
		 * This should print the current inventory and then ask the user which topping
		 * (by ID) they want to add more to and how much to add
		 */
	
		 try {
			// Step 1: Fetch topping list and print inventory
			ArrayList<Topping> toppingList = DBNinja.getToppingList();
			DBNinja.printInventory();
	
			int toppingId;
			Topping selectedTopping = null;
	
			// Step 2: Prompt the user to enter the topping ID (with retry on invalid ID)
			while (true) {
				toppingId = promptForPositiveInteger("Which topping do you want to add inventory to? Enter the topping ID: ");
				selectedTopping = getToppingById(toppingList, toppingId);
				if (selectedTopping != null) {
					System.out.println("Selected Topping: " + selectedTopping.getTopName());
					break; // Exit the loop if a valid topping ID is entered
				} else {
					System.out.println("Topping with ID " + toppingId + " not found. Please try again.");
				}
			}
	
			// Step 3: Prompt the user to enter the number of units to add
			int units = promptForPositiveInteger("How many units would you like to add? ");
	
			// Step 4: Update the database inventory
			DBNinja.addToInventory(selectedTopping, units);
		} catch (SQLException | IOException e) {
			e.printStackTrace();
		}
	}

	// A method that builds a pizza. Used in our add new order method
	public static Pizza buildPizza(int orderID) throws SQLException, IOException {

		/*
		 * This is a helper method for first menu option.
		 * 
		 * It should ask which size pizza the user wants and the crustType.
		 * 
		 * Once the pizza is created, it should be added to the DB.
		 * 
		 * We also need to add toppings to the pizza. (Which means we not only need to
		 * add toppings here, but also our bridge table)
		 * 
		 * We then need to add pizza discounts (again, to here and to the database)
		 * 
		 * Once the discounts are added, we can return the pizza
		 */
		Pizza ret = null;
		// User Input Prompts...
		System.out.println("What size is the pizza?");
		System.out.println("1." + DBNinja.size_s);
		System.out.println("2." + DBNinja.size_m);
		System.out.println("3." + DBNinja.size_l);
		System.out.println("4." + DBNinja.size_xl);
		System.out.println("Enter the corresponding number: ");
		String size_string = reader.readLine();
		int size = Integer.parseInt(size_string);
		switch (size) {
			case 1:
				ret.setSize(DBNinja.size_s);
			case 2:
				ret.setSize(DBNinja.size_m);
			case 3:
				ret.setSize(DBNinja.size_l);
			case 4:
				ret.setSize(DBNinja.size_xl);
		}
		System.out.println("What crust for this pizza?");
		System.out.println("1." + DBNinja.crust_thin);
		System.out.println("2." + DBNinja.crust_orig);
		System.out.println("3." + DBNinja.crust_pan);
		System.out.println("4." + DBNinja.crust_gf);
		System.out.println("Enter the corresponding number: ");
		String crust_string = reader.readLine();
		int crust = Integer.parseInt(crust_string);
		switch (crust) {
			case 1:
				ret.setCrustType(DBNinja.crust_thin);
			case 2:
				ret.setCrustType(DBNinja.crust_orig);
			case 3:
				ret.setCrustType(DBNinja.crust_pan);
			case 4:
				ret.setCrustType(DBNinja.crust_gf);
		}
		DBNinja.addPizza(ret);
		DBNinja.printInventory();
		String topping_string = reader.readLine();
		int topping = Integer.parseInt(topping_string);

		System.out.println("Which topping do you want to add? Enter the TopID. Enter -1 to stop adding toppings: ");
		while (topping != -1) {
			topping_string = reader.readLine();
			topping = Integer.parseInt(topping_string);

			for (Topping i : DBNinja.getToppingList()) {

				if (i.getTopID() == topping) {
					double sizeMax = 0.0;

					switch (size) {
						case 1:
							sizeMax = i.getPerAMT();
							break;
						case 2:
							sizeMax = i.getMedAMT();
							break;
						case 3:
							sizeMax = i.getLgAMT();
							break;
						case 4:
							sizeMax = i.getXLAMT();
							break;
					}
					if (i.getCurINVT() < sizeMax) {
						System.out.println("We don't have enough of that topping to add it...");
						break;
					}
					System.out.println("Do you want to add extra topping? Enter y/n");
					String extra_string = reader.readLine();
					if (extra_string.toLowerCase() == "y") {

						DBNinja.useTopping(ret, DBNinja.getToppingList().get(topping - 1), true);
					} else {
						DBNinja.useTopping(ret, DBNinja.getToppingList().get(topping - 1), false);
					}

				}
			}

			System.out.println("Which topping do you want to add? Enter the TopID. Enter -1 to stop adding toppings: ");
			topping_string = reader.readLine();
			topping = Integer.parseInt(topping_string);
			// System.out.println("We don't have enough of that topping to add it...");

		}
		System.out.println("Do you want to add discounts to this Pizza? Enter y/n?");
		String continue_adding = reader.readLine();
		if (continue_adding.toLowerCase() == "y") {

			System.out.println(
					"Which Pizza Discount do you want to add? Enter the DiscountID. Enter -1 to stop adding Discounts: ");
			String discount_string = reader.readLine();
			int discount = Integer.parseInt(discount_string);

			while (discount != -1) {
				System.out.println(
						"Which Pizza Discount do you want to add? Enter the DiscountID. Enter -1 to stop adding Discounts: ");
				discount_string = reader.readLine();
				discount = Integer.parseInt(discount_string);
				DBNinja.usePizzaDiscount(ret, DBNinja.getDiscountList().get(discount - 1));
			}
		}

		// TODO compute pizza price
		// double pizza_price = 0.0;
		// ret.setCustPrice(pizza_price);
		// // TODO compute pizza cost
		// double pizza_cost = 0.0;
		// ret.setBusPrice(pizza_cost);

		return ret;
	}

	public static void PrintReports() throws SQLException, NumberFormatException, IOException {
		/*
		 * This method asks the use which report they want to see and calls the DBNinja
		 * method to print the appropriate report.
		 * 
		 */

		// User Input Prompts...
		System.out.println(
				"Which report do you wish to print? Enter\n(a) ToppingPopularity\n(b) ProfitByPizza\n(c) ProfitByOrderType:");
		String report_type = reader.readLine();
		switch (report_type) {
			case "a":
				DBNinja.printToppingPopReport();
				break;
			case "b":
				DBNinja.printProfitByPizzaReport();
				break;
			case "c":
				DBNinja.printProfitByOrderType();
				break;
			default:
				System.out.println("I don't understand that input... returning to menu...");

		}

	}

	//helps with validating common positive integer input input
	private static int promptForPositiveInteger(String message) throws IOException {
        while (true) {
            System.out.println(message);
            String input = reader.readLine();
            try {
                int value = Integer.parseInt(input);
                if (value <= 0) {
                    throw new NumberFormatException();
                }
                return value;
            } catch (NumberFormatException e) {
                System.out.println("Invalid entry: Please enter a positive integer.");
            }
        }
    }

	// Prompt - NO CODE SHOULD TAKE PLACE BELOW THIS LINE
	// DO NOT EDIT ANYTHING BELOW HERE, THIS IS NEEDED TESTING.
	// IF YOU EDIT SOMETHING BELOW, IT BREAKS THE AUTOGRADER WHICH MEANS YOUR GRADE
	// WILL BE A 0 (zero)!!

	//helps with extracting Topping objects for Topping ArrayLists
	public static Topping getToppingById(ArrayList<Topping> toppingList, int topId) {
		for (Topping topping : toppingList) {
			if (topping.getTopID() == topId) {
				return topping;
			}
		}
		return null; // Return null if no topping with the specified ID is found
	}

	public static void PrintMenu() {
		System.out.println("\n\nPlease enter a menu option:");
		System.out.println("1. Enter a new order");
		System.out.println("2. View Customers ");
		System.out.println("3. Enter a new Customer ");
		System.out.println("4. View orders");
		System.out.println("5. Mark an order as completed");
		System.out.println("6. View Inventory Levels");
		System.out.println("7. Add Inventory");
		System.out.println("8. View Reports");
		System.out.println("9. Exit\n\n");
		System.out.println("Enter your option: ");
	}

	/*
	 * autograder controls....do not modiify!
	 */

	public final static String autograder_seed = "6f1b7ea9aac470402d48f7916ea6a010";

	private static void autograder_compilation_check() {

		try {
			Order o = null;
			Pizza p = null;
			Topping t = null;
			Discount d = null;
			Customer c = null;
			ArrayList<Order> alo = null;
			ArrayList<Discount> ald = null;
			ArrayList<Customer> alc = null;
			ArrayList<Topping> alt = null;
			double v = 0.0;
			String s = "";

			DBNinja.addOrder(o);
			DBNinja.addPizza(p);
			DBNinja.useTopping(p, t, false);
			DBNinja.usePizzaDiscount(p, d);
			DBNinja.useOrderDiscount(o, d);
			DBNinja.addCustomer(c);
			DBNinja.completeOrder(o);
			alo = DBNinja.getOrders(false);
			o = DBNinja.getLastOrder();
			alo = DBNinja.getOrdersByDate("01/01/1999");
			ald = DBNinja.getDiscountList();
			d = DBNinja.findDiscountByName("Discount");
			alc = DBNinja.getCustomerList();
			c = DBNinja.findCustomerByPhone("0000000000");
			alt = DBNinja.getToppingList();
			t = DBNinja.findToppingByName("Topping");
			DBNinja.addToInventory(t, 1000.0);
			v = DBNinja.getBaseCustPrice("size", "crust");
			v = DBNinja.getBaseBusPrice("size", "crust");
			DBNinja.printInventory();
			DBNinja.printToppingPopReport();
			DBNinja.printProfitByPizzaReport();
			DBNinja.printProfitByOrderType();
			s = DBNinja.getCustomerName(0);
		} catch (SQLException | IOException e) {
			e.printStackTrace();
		}
	}

}
