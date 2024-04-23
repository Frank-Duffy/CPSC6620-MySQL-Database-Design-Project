-- Authors: Noah Britt, Francis Duffy

CREATE SCHEMA IF NOT EXISTS Pizzeria;
USE Pizzeria;

INSERT INTO topping (
    ToppingNum, ToppingName, ToppingPrice, ToppingCost, 
    ToppingQOH, ToppingMinQOH, ToppingPersonal, ToppingMedium, 
    ToppingLarge, ToppingXLarge
) VALUES
    (1,"Pepperoni",1.25,0.2,100,50,2,2.75,3.5,4.5),
    (2,"Sausage",1.25,0.15,100,50,2.5,3,3.5,4.25),
    (3,"Ham",1.5,0.15,78,25,2,2.5,3.25,4),
    (4,"Chicken",1.75,0.25,56,25,1.5,2,2.25,3),
    (5,"Green Pepper",0.5,0.02,79,25,1,1.5,2,2.5),
    (6,"Onion",0.5,0.02,85,25,1,1.5,2,2.75),
    (7,"Roma Tomato",0.75,0.03,86,10,2,3,3.5,4.5),
    (8,"Mushrooms",0.75,0.1,52,50,1.5,2,2.5,3),
    (9,"Black Olives",0.6,0.1,39,25,0.75,1,1.5,2),
    (10,"Pineapple",1,0.25,15,0,1,1.25,1.75,2),
    (11,"Jalapenos",0.5,0.05,64,0,0.5,0.75,1.25,1.75),
    (12,"Banana Peppers",0.5,0.05,36,0,0.6,1,1.3,1.75),
    (13,"Regular Cheese",0.5,0.12,250,50,2,3.5,5,7),
    (14,"Four Cheese Blend",1,0.15,150,25,2,3.5,5,7),
    (15,"Feta Cheese",1.5,0.18,75,0,1.75,3,4,5.5),
    (16,"Goat Cheese",1.5,0.2,54,0,1.6,2.75,4,5.5),
    (17,"Bacon",1.5,0.25,89,0,1,1.5,2,3);

INSERT INTO discount (
    DiscountNum, DiscountName, DiscountType, DiscountAmt
) VALUES
    (1, "Employee", '%',15),
    (2, "Lunch Special Medium", '$',1.00),
    (3, "Lunch Special Large", '$',2.00),
    (4, "Specialty Pizza", '$',1.50),
    (5, "Happy Hour", '%',10),
    (6, "Gameday Special", '%',20);

INSERT INTO pizzabase (
    PizzaBaseNum, PizzaBaseSize, PizzaBaseCrust, 
    PizzaBasePrice, PizzaBaseCost
)
VALUES
    (1,"Small","Thin",3,0.5),
    (2,"Small","Original",3,0.75),
    (3,"Small","Pan",3.5,1),
    (4,"Small","Gluten-Free",4,2),
    (5,"Medium","Thin",5,1),
    (6,"Medium","Original",5,1.5),
    (7,"Medium","Pan",6,2.25),
    (8,"Medium","Gluten-Free",6.25,3),
    (9,"Large","Thin",8,1.25),
    (10,"Large","Original",8,2),
    (11,"Large","Pan",9,3),
    (12,"Large","Gluten-Free",9.5,4),
    (13,"XLarge","Thin",10,2),
    (14,"XLarge","Original",10,3),
    (15,"XLarge","Pan",11.5,4.5),
    (16,"XLarge","Gluten-Free",12.5,6);


-- Add the 7 orders outlined in the project requirements.

-- Start Order #1: Pick up for Matt Engers
-- Insert order #1 into pizzaorder with discount applied
INSERT INTO pizzaorder (
    PizzaOrderPrice, PizzaOrderCost, PizzaOrderDate,
    PizzaOrderComplete, PizzaOrderType
) VALUES (
    25.95,7.88,'2024-03-02 17:30:00',True,'PickUp'
);

-- get the PizzaOrderNum from the last pizzaorder
SET @OrderId = LAST_INSERT_ID();

INSERT INTO customer (
    CustomerFName, CustomerLName, CustomerPhone
) VALUES (
    "Matt", "Engers", "8644749953"
);

-- get the CustomerID from the last pizzaorder
SET @CustId = LAST_INSERT_ID();

-- use it to create the pickup record
INSERT INTO pickup VALUES (@OrderId, @CustId);

-- update pizza table
INSERT INTO pizza (
    PizzaOrderNum, PizzaBaseNum, PizzaPrice, PizzaCost,
    PizzaIsComplete
) VALUES (
    @OrderId, 16, 25.95, 7.88, True
);

-- get the PizzaOrderNum from the last pizzaorder insert
SET @LastPizzaNum = LAST_INSERT_ID();

-- update pizzatopping with order #3 pizza 1
INSERT INTO pizzatopping (
    PizzaToppingPizzaNum, PizzaToppingToppingNum, PizzaToppingHasDouble
) VALUES 
    (@LastPizzaNum, 5, FALSE),
    (@LastPizzaNum, 6, FALSE),
    (@LastPizzaNum, 7, FALSE),
    (@LastPizzaNum, 8, FALSE),
    (@LastPizzaNum, 9, FALSE),
    (@LastPizzaNum, 16, FALSE);

-- update pizzadiscount
INSERT INTO pizzadiscount (
    PizzaDiscountPizzaNum, PizzaDiscountNum
) VALUES (@LastPizzaNum, 4);

-- End Order #1

-- Start Order #2: Pick up for Matt Engers
-- Insert order #2 into pizzaorder with discount applied
INSERT INTO pizzaorder (
    PizzaOrderPrice, PizzaOrderCost, PizzaOrderDate,
    PizzaOrderComplete, PizzaOrderType
) VALUES (
    20.81,3.19,'2024-03-02 18:17:00',True,'Delivery'
);

-- get the PizzaOrderNum from the last pizzaorder
SET @OrderId = LAST_INSERT_ID();

INSERT INTO customer (
    CustomerFName, CustomerLName, CustomerPhone,
    CustomerStreet, CustomerCity, CustomerState, CustomerZip
) VALUES (
    "Frank", "Turner", "8644749953",
    "6745 Wessex St.", "Anderson", "SC", 29621
);

-- get the last inserted CustomerID
SET @CustId = LAST_INSERT_ID();

-- use it to create the pickup record
INSERT INTO delivery VALUES (@OrderId, @CustId);

-- update pizza table with pizza ordered
INSERT INTO pizza (
    PizzaOrderNum, PizzaBaseNum, PizzaPrice, PizzaCost,
    PizzaIsComplete
) VALUES (
    @OrderId, 9, 20.81, 3.19, True
);

-- get the PizzaOrderNum from the last pizzaorder insert
SET @LastPizzaNum = LAST_INSERT_ID();

-- update pizzatopping with order #3 pizza 1
INSERT INTO pizzatopping (
    PizzaToppingPizzaNum, PizzaToppingToppingNum, PizzaToppingHasDouble
) VALUES 
    (@LastPizzaNum, 4, FALSE),
    (@LastPizzaNum, 5, FALSE),
    (@LastPizzaNum, 6, FALSE),
    (@LastPizzaNum, 8, FALSE),
    (@LastPizzaNum, 14, TRUE);

-- End Order #2

-- Start Order #3: Pick up for Andrew Wilkes-Krier
-- Insert order #3 into pizzaorder with discount applied
INSERT INTO pizzaorder (
    PizzaOrderPrice, PizzaOrderCost, PizzaOrderDate,
    PizzaOrderComplete, PizzaOrderType
) VALUES (
    89.28,19.8,'2024-03-03 21:30:00',True,'PickUp'
);

-- get the PizzaOrderNum from the last pizzaorder
SET @OrderId = LAST_INSERT_ID();

INSERT INTO customer (
    CustomerFName, CustomerLName, CustomerPhone
) VALUES (
    "Andrew", "Wilkes-Krier", "8642545861"
);

-- get the CustomerID from the last pizzaorder
SET @CustId = LAST_INSERT_ID();

-- use it to create the pick up record
INSERT INTO pickup VALUES (@OrderId, @CustId);

-- insert 6 identical large original regular cheese and 
-- pepperoni pizzas into the pizza table and pizzatopping
-- table

-- update pizza with order #3 pizza 1
INSERT INTO pizza (
    PizzaOrderNum, PizzaBaseNum, PizzaPrice, PizzaCost,
    PizzaIsComplete
) VALUES (
    @OrderId, 10, 14.88, 3.30, True
);

-- get the PizzaOrderNum from the last pizzaorder insert
SET @LastPizzaNum = LAST_INSERT_ID();

-- update pizzatopping with order #3 pizza 1
INSERT INTO pizzatopping (
    PizzaToppingPizzaNum, PizzaToppingToppingNum, PizzaToppingHasDouble
) VALUES 
    (@LastPizzaNum, 13, FALSE),
    (@LastPizzaNum, 1, FALSE);

-- update pizza with order #3 pizza 2
INSERT INTO pizza (
    PizzaOrderNum, PizzaBaseNum, PizzaPrice, PizzaCost,
    PizzaIsComplete
) VALUES (
    @OrderId, 10, 14.88, 3.30, True
);

-- get the PizzaOrderNum from the last pizzaorder insert
SET @LastPizzaNum = LAST_INSERT_ID();

-- update pizzatopping with order #3 pizza 2
INSERT INTO pizzatopping (
    PizzaToppingPizzaNum, PizzaToppingToppingNum, PizzaToppingHasDouble
) VALUES 
    (@LastPizzaNum, 13, FALSE),
    (@LastPizzaNum, 1, FALSE);

-- update pizza with order #3 pizza 3
INSERT INTO pizza (
    PizzaOrderNum, PizzaBaseNum, PizzaPrice, PizzaCost,
    PizzaIsComplete
) VALUES (
    @OrderId, 10, 14.88, 3.30, True
);

-- get the PizzaOrderNum from the last pizzaorder insert
SET @LastPizzaNum = LAST_INSERT_ID();

-- update pizzatopping with order #3 pizza 3
INSERT INTO pizzatopping (
    PizzaToppingPizzaNum, PizzaToppingToppingNum, PizzaToppingHasDouble
) VALUES 
    (@LastPizzaNum, 13, FALSE),
    (@LastPizzaNum, 1, FALSE);

-- update pizza with order #3 pizza 4
INSERT INTO pizza (
    PizzaOrderNum, PizzaBaseNum, PizzaPrice, PizzaCost,
    PizzaIsComplete
) VALUES (
    @OrderId, 10, 14.88, 3.30, True
);

-- get the PizzaOrderNum from the last pizzaorder insert
SET @LastPizzaNum = LAST_INSERT_ID();

-- update pizzatopping with order #3 pizza 4
INSERT INTO pizzatopping (
    PizzaToppingPizzaNum, PizzaToppingToppingNum, PizzaToppingHasDouble
) VALUES 
    (@LastPizzaNum, 13, FALSE),
    (@LastPizzaNum, 1, FALSE);

-- update pizza with order #3 pizza 5
INSERT INTO pizza (
    PizzaOrderNum, PizzaBaseNum, PizzaPrice, PizzaCost,
    PizzaIsComplete
) VALUES (
    @OrderId, 10, 14.88, 3.30, True
);

-- get the PizzaOrderNum from the last pizzaorder insert
SET @LastPizzaNum = LAST_INSERT_ID();

-- update pizzatopping with order #3 pizza 5
INSERT INTO pizzatopping (
    PizzaToppingPizzaNum, PizzaToppingToppingNum, PizzaToppingHasDouble
) VALUES 
    (@LastPizzaNum, 13, FALSE),
    (@LastPizzaNum, 1, FALSE);

-- update pizza with order #3 pizza 6
INSERT INTO pizza (
    PizzaOrderNum, PizzaBaseNum, PizzaPrice, PizzaCost,
    PizzaIsComplete
) VALUES (
    @OrderId, 10, 14.88, 3.30, True
);

-- get the PizzaOrderNum from the last pizzaorder insert
SET @LastPizzaNum = LAST_INSERT_ID();

-- update pizzatopping with order #3 pizza 6
INSERT INTO pizzatopping (
    PizzaToppingPizzaNum, PizzaToppingToppingNum, PizzaToppingHasDouble
) VALUES 
    (@LastPizzaNum, 13, FALSE),
    (@LastPizzaNum, 1, FALSE);

-- End Order #3

-- Start Order #4: 
-- Insert order #4 into pizzaorder with discount applied
INSERT INTO pizzaorder (
    PizzaOrderPrice, PizzaOrderCost, PizzaOrderDate,
    PizzaOrderComplete, PizzaOrderType
) VALUES (
    18.75,3.68,'2024-03-05 12:03:00',True,'DineIn'
);

-- get the PizzaOrderNum from the last pizzaorder
SET @OrderId = LAST_INSERT_ID();

-- use it to create the dine in record
INSERT INTO dinein VALUES (@OrderId, 21);

-- insert pizza from order #4 into the pizza table with discount applied
INSERT INTO pizza (
    PizzaOrderNum, PizzaBaseNum, PizzaPrice, PizzaCost,
    PizzaIsComplete
) VALUES (
    @OrderId, 9, 18.75,3.68,True
);

-- get the PizzaOrderNum from the last pizzaorder insert
SET @LastPizzaNum = LAST_INSERT_ID();

-- update pizzadiscount with order #4 pizza
INSERT INTO pizzadiscount (
    PizzaDiscountPizzaNum, PizzaDiscountNum
) VALUES (
    @LastPizzaNum, 3
);

-- update pizzatopping with order #4 pizza w/ extra cheese
INSERT INTO pizzatopping (
    PizzaToppingPizzaNum, PizzaToppingToppingNum, PizzaToppingHasDouble
) VALUES 
    (@LastPizzaNum, 13, TRUE),
    (@LastPizzaNum, 1, FALSE),
    (@LastPizzaNum, 2, FALSE);
-- End Order #4

-- Start Order #5
-- Insert order #5 into pizzaorder with discount applied
INSERT INTO pizzaorder (
    PizzaOrderPrice, PizzaOrderCost, PizzaOrderDate,
    PizzaOrderComplete, PizzaOrderType
) VALUES (
17.28,4.63,'2024-04-03 12:05:00',True,'DineIn'
);

-- get the PizzaOrderNum from the last pizzaorder
SET @OrderId = LAST_INSERT_ID();

-- use it to create the dine in record
INSERT INTO dinein VALUES (@OrderId, 4);

-- insert 1st pizza from order #5 into the pizza table with discount applied
INSERT INTO pizza (
    PizzaOrderNum, PizzaBaseNum, PizzaPrice, PizzaCost,
    PizzaIsComplete
) VALUES (
    @OrderId, 7, 10.35,3.23,True
);

-- get the PizzaOrderNum from the last pizzaorder insert
SET @LastPizzaNum = LAST_INSERT_ID();

-- update pizzadiscount with order #5 1st pizza discounts
INSERT INTO pizzadiscount (
    PizzaDiscountPizzaNum, PizzaDiscountNum
) VALUES 
    (@LastPizzaNum, 2),
    (@LastPizzaNum, 4);

-- update pizzatopping with order #5 1st pizza
INSERT INTO pizzatopping (
    PizzaToppingPizzaNum, PizzaToppingToppingNum, PizzaToppingHasDouble
) VALUES 
    (@LastPizzaNum, 15, FALSE),
    (@LastPizzaNum, 9, FALSE),
    (@LastPizzaNum, 7, FALSE),
    (@LastPizzaNum, 8, FALSE),
    (@LastPizzaNum, 12, FALSE);

-- insert 2nd pizza from order #5 into the pizza table. No discounts.
INSERT INTO pizza (
    PizzaOrderNum, PizzaBaseNum, PizzaPrice, PizzaCost,
    PizzaIsComplete
) VALUES (
    @OrderId, 2, 6.93,1.40,True
);

-- get the PizzaOrderNum from the last pizzaorder insert
SET @LastPizzaNum = LAST_INSERT_ID();

-- update pizzatopping with order #5 2nd pizza
INSERT INTO pizzatopping (
    PizzaToppingPizzaNum, PizzaToppingToppingNum, PizzaToppingHasDouble
) VALUES 
    (@LastPizzaNum, 13, FALSE),
    (@LastPizzaNum, 4, FALSE),
    (@LastPizzaNum, 12, FALSE);

-- End Order #5

-- Start Order #6
-- Insert order into pizzaorder with discount applied
INSERT INTO pizzaorder (
    PizzaOrderPrice, PizzaOrderCost, PizzaOrderDate,
    PizzaOrderComplete, PizzaOrderType
) VALUES (
    27.4125, 5.25,'2024-04-13 20:32:00',True,'Delivery'
);

-- get the PizzaOrderNum from the last pizzaorder
SET @OrderId = LAST_INSERT_ID();

INSERT INTO customer (
    CustomerFName, CustomerLName, CustomerPhone,
    CustomerStreet, CustomerCity, CustomerState, CustomerZip
) VALUES (
    "Milo", "Auckerman", "8648785679",
    "8879 Suburban Home", "Anderson", "SC", 29621
);

-- get the last inserted CustomerID
SET @CustId = LAST_INSERT_ID();

-- use it to create the pickup record
INSERT INTO delivery VALUES (@OrderId, @CustId);

-- update pizza table with pizza ordered
INSERT INTO pizza (
    PizzaOrderNum, PizzaBaseNum, PizzaPrice, PizzaCost,
    PizzaIsComplete
) VALUES (
    @OrderId, 9, 11.05, 2.00, True
);

-- get the PizzaOrderNum from the last pizzaorder insert
SET @LastPizzaNum = LAST_INSERT_ID();

-- update pizzatopping 
INSERT INTO pizzatopping (
    PizzaToppingPizzaNum, PizzaToppingToppingNum, PizzaToppingHasDouble
) VALUES (@LastPizzaNum, 14, TRUE);

-- update pizza table with pizza ordered
INSERT INTO pizza (
    PizzaOrderNum, PizzaBaseNum, PizzaPrice, PizzaCost,
    PizzaIsComplete
) VALUES (
    @OrderId, 9, 16.3625, 3.25, True
);

-- get the PizzaOrderNum from the last pizzaorder insert
SET @LastPizzaNum = LAST_INSERT_ID();

-- update pizzatopping 
INSERT INTO pizzatopping (
    PizzaToppingPizzaNum, PizzaToppingToppingNum, PizzaToppingHasDouble
) VALUES 
    (@LastPizzaNum, 13, FALSE),
    (@LastPizzaNum, 1, TRUE);

-- update orderdiscount 
INSERT INTO orderdiscount (
    OrderDiscountPizzaOrderNum, OrderDiscountNum
) VALUES (@OrderId, 1);

-- End Order #6

-- Start Order #7

-- Insert order into pizzaorder with discount applied
INSERT INTO pizzaorder (
    PizzaOrderPrice, PizzaOrderCost, PizzaOrderDate,
    PizzaOrderComplete, PizzaOrderType
) VALUES (
    67.452, 23.62,'2024-04-20 19:11:00',True,'Delivery'
);

-- get the PizzaOrderNum from the last pizzaorder
SET @OrderId = LAST_INSERT_ID();

-- Turn off safe mode for UPDATES with WHERE not including PK.
SET sql_safe_updates = 0;

-- Update previous customer record to contain delivery address.
UPDATE customer
SET 
    CustomerStreet = "115 Party Blvd",
    CustomerCity = "Anderson",
    CustomerState = "SC",
    CustomerZip = 29621
WHERE
    CustomerFName = "Andrew" AND
    CustomerLName = "Wilkes-Krier";

--  get the customer ID for this customer.
SET @CustId := (
    SELECT CustomerID
    FROM customer
    WHERE CustomerFName = 'Andrew' AND CustomerLName = 'Wilkes-Krier'
);

-- Turn back on :)
SET sql_safe_updates = 1;

-- use them to create the pickup record
INSERT INTO delivery VALUES (@OrderId, @CustId);

-- Pizza #1
-- update pizza table with pizza ordered
INSERT INTO pizza (
    PizzaOrderNum, PizzaBaseNum, PizzaPrice, PizzaCost,
    PizzaIsComplete
) VALUES (
    @OrderId, 14, 22.352, 9.19, True
);

-- get the PizzaOrderNum from the last pizzaorder insert
SET @LastPizzaNum = LAST_INSERT_ID();

-- update pizzatopping 
INSERT INTO pizzatopping (
    PizzaToppingPizzaNum, PizzaToppingToppingNum, PizzaToppingHasDouble
) VALUES 
    (@LastPizzaNum, 14, FALSE),
    (@LastPizzaNum, 1, FALSE),
    (@LastPizzaNum, 2, FALSE);

-- Pizza #2
-- update pizza table with pizza ordered
INSERT INTO pizza (
    PizzaOrderNum, PizzaBaseNum, PizzaPrice, PizzaCost,
    PizzaIsComplete
) VALUES (
    @OrderId, 14, 23.70, 6.25, True
);

-- get the PizzaOrderNum from the last pizzaorder insert
SET @LastPizzaNum = LAST_INSERT_ID();

-- update pizzatopping 
INSERT INTO pizzatopping (
    PizzaToppingPizzaNum, PizzaToppingToppingNum, PizzaToppingHasDouble
) VALUES 
    (@LastPizzaNum, 14, FALSE),
    (@LastPizzaNum, 3, TRUE),
    (@LastPizzaNum, 10, TRUE);

-- update pizzadiscount with pizza #2 discount
INSERT INTO pizzadiscount (
    PizzaDiscountPizzaNum, PizzaDiscountNum
) VALUES (@LastPizzaNum, 4);

-- Pizza #3
-- update pizza table with pizza ordered
INSERT INTO pizza (
    PizzaOrderNum, PizzaBaseNum, PizzaPrice, PizzaCost,
    PizzaIsComplete
) VALUES (
    @OrderId, 14, 21.40, 8.18, True
);

-- get the PizzaOrderNum from the last pizzaorder insert
SET @LastPizzaNum = LAST_INSERT_ID();

-- update pizzatopping 
INSERT INTO pizzatopping (
    PizzaToppingPizzaNum, PizzaToppingToppingNum, PizzaToppingHasDouble
) VALUES 
    (@LastPizzaNum, 14, FALSE),
    (@LastPizzaNum, 4, FALSE),
    (@LastPizzaNum, 17, FALSE);

-- update orderdiscount 
INSERT INTO orderdiscount (
    OrderDiscountPizzaOrderNum, OrderDiscountNum
) VALUES (@OrderId, 6);

-- End Order #7