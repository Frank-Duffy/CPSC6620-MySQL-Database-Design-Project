
-- Authors: Noah Britt, Francis Duffy

-- Insert order #1 into pizzaorder with discount applied
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

    -- insert pizza from order #1 into the pizza table with discount applied
    INSERT INTO pizza (
        PizzaOrderNum, PizzaBaseNum, PizzaPrice, PizzaCost,
        PizzaIsComplete
    ) VALUES (
        @OrderId, 9, 18.75,3.68,True
    );

    -- get the PizzaOrderNum from the last pizzaorder insert
    SET @LastPizzaNum = LAST_INSERT_ID();

    -- update pizzadiscount with order #1 pizza
    INSERT INTO pizzadiscount (
        PizzaNum, DiscountNum
    ) VALUES (
        @LastPizzaNum, 3
    );

    -- update pizzatopping with order #1 pizza w/ extra cheese
    INSERT INTO pizzatopping (
        PizzaNum, ToppingNum, PizzaToppingHasDouble
    ) VALUES (
        @LastPizzaNum, 13, TRUE
    );

    -- update pizzatopping with order #1 pizza w/ pepperoni
    INSERT INTO pizzatopping (
        PizzaNum, ToppingNum
    ) VALUES (
        @LastPizzaNum, 1
    );

    -- update pizzatopping with order #1 pizza w/ sausage
    INSERT INTO pizzatopping (
        PizzaNum, ToppingNum
    ) VALUES (
        @LastPizzaNum, 2
    );

-- Insert order #2 into pizzaorder with discount applied
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

    -- insert 1st pizza from order #2 into the pizza table with discount applied
    INSERT INTO pizza (
        PizzaOrderNum, PizzaBaseNum, PizzaPrice, PizzaCost,
        PizzaIsComplete
    ) VALUES (
        @OrderId, 7, 10.35,3.23,True
    );

    -- get the PizzaOrderNum from the last pizzaorder insert
    SET @LastPizzaNum = LAST_INSERT_ID();

    -- update pizzadiscount with order #2 1st pizza discounts
    INSERT INTO pizzadiscount (
        PizzaNum, DiscountNum
    ) VALUES 
        (@LastPizzaNum, 2),
        (@LastPizzaNum, 4);

    -- update pizzatopping with order #2 1st pizza
    INSERT INTO pizzatopping (
        PizzaNum, ToppingNum, PizzaToppingHasDouble
    ) VALUES 
        (@LastPizzaNum, 15, FALSE),
        (@LastPizzaNum, 9, FALSE),
        (@LastPizzaNum, 7, FALSE),
        (@LastPizzaNum, 8, FALSE),
        (@LastPizzaNum, 12, FALSE);

-- insert 2nd pizza from order #2 into the pizza table. No discounts.
    INSERT INTO pizza (
        PizzaOrderNum, PizzaBaseNum, PizzaPrice, PizzaCost,
        PizzaIsComplete
    ) VALUES (
        @OrderId, 2, 6.93,1.40,True
    );

    -- get the PizzaOrderNum from the last pizzaorder insert
    SET @LastPizzaNum = LAST_INSERT_ID();

    -- update pizzatopping with order #2 1st pizza
    INSERT INTO pizzatopping (
        PizzaNum, ToppingNum, PizzaToppingHasDouble
    ) VALUES 
        (@LastPizzaNum, 13, FALSE),
        (@LastPizzaNum, 4, FALSE),
        (@LastPizzaNum, 12, FALSE);

-- INSERT INTO pizzaorder VALUES (NULL, 0.0,0.0,'2024-03-02 05:30:00',True,'Pick Up');
-- SET @OrderId = LAST_INSERT_ID();
-- INSERT INTO customer VALUES (NULL, "Matt", "Engers", NULL, NULL, NULL, NULL, '864-474-9953 ');
-- INSERT INTO pickup VALUES (@OrderId, LAST_INSERT_ID());
-- INSERT INTO pizza SELECT NULL, @OrderId, PizzaBaseNum, 27.45,7.88,True FROM pizzabase WHERE PizzaBaseSize="Large" AND PizzaBaseCrust="Gluten Free";
-- SET @PizzaId=LAST_INSERT_ID();
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Mushrooms";
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Green Pepper";
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Onion";
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Roma Tomatoes";
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Black Olives";
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Goat Cheese";
-- INSERT INTO discount SELECT @PizzaId, DiscountBaseNum FROM discountbase WHERE DiscountBaseName="Specialty Pizza";
-- UPDATE pizzaorder SET PizzaOrderPrice=(SELECT SUM(PizzaPrice) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;
-- UPDATE pizzaorder SET PizzaOrderCost=(SELECT SUM(PizzaCost) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;

-- INSERT INTO pizzaorder VALUES (NULL, 0.0,0.0,'2024-04-03 12:05:00',True,'Dine In');
-- SET @OrderId = LAST_INSERT_ID();
-- INSERT INTO dinein VALUES (@OrderId, 4);
-- INSERT INTO pizza SELECT NULL, @OrderId, PizzaBaseNum, 12.85,3.23,True FROM pizzabase WHERE PizzaBaseSize="Medium" AND PizzaBaseCrust="Pan";
-- SET @PizzaId=LAST_INSERT_ID();
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Feta Cheese";
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Black Olives";
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Roma Tomatoes";
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Mushrooms";
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Banana Peppers";
-- INSERT INTO discount SELECT @PizzaId, DiscountBaseNum FROM discountbase WHERE DiscountBaseName="Lunch Special Medium";
-- INSERT INTO discount SELECT @PizzaId, DiscountBaseNum FROM discountbase WHERE DiscountBaseName="Specialty Pizza";
-- INSERT INTO pizza SELECT NULL, @OrderId, PizzaBaseNum, 6.93,1.40,True FROM pizzabase WHERE PizzaBaseSize="Small" AND PizzaBaseCrust="Original";
-- SET @PizzaId=LAST_INSERT_ID();
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Regular Cheese";
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Chicken";
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Banana Peppers";
-- UPDATE pizzaorder SET PizzaOrderPrice=(SELECT SUM(PizzaPrice) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;
-- UPDATE pizzaorder SET PizzaOrderCost=(SELECT SUM(PizzaCost) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;

-- INSERT INTO pizzaorder VALUES (NULL, 0.0,0.0,'2024-03-03 09:30:00',True,'Pick Up');
-- SET @OrderId = LAST_INSERT_ID();
-- INSERT INTO customer VALUES (NULL, "Andrew", "Wilkes-Krier", NULL, NULL, NULL, NULL, '864-254=5861');
-- INSERT INTO pickup VALUES (@OrderId, LAST_INSERT_ID());
-- INSERT INTO pizza SELECT NULL, @OrderId, PizzaBaseNum, 14.88,3.30,True FROM pizzabase WHERE PizzaBaseSize="Large" AND PizzaBaseCrust="Original";
-- SET @PizzaId=LAST_INSERT_ID();
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Regular Cheese";
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Pepperoni";
-- UPDATE pizzaorder SET PizzaOrderPrice=(SELECT SUM(PizzaPrice) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;
-- UPDATE pizzaorder SET PizzaOrderCost=(SELECT SUM(PizzaCost) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;
-- INSERT INTO pizza SELECT NULL, @OrderId, PizzaBaseNum, 14.88,3.30,True FROM pizzabase WHERE PizzaBaseSize="Large" AND PizzaBaseCrust="Original";
-- SET @PizzaId=LAST_INSERT_ID();
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Regular Cheese";
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Pepperoni";
-- UPDATE pizzaorder SET PizzaOrderPrice=(SELECT SUM(PizzaPrice) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;
-- UPDATE pizzaorder SET PizzaOrderCost=(SELECT SUM(PizzaCost) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;
-- INSERT INTO pizza SELECT NULL, @OrderId, PizzaBaseNum, 14.88,3.30,True FROM pizzabase WHERE PizzaBaseSize="Large" AND PizzaBaseCrust="Original";
-- SET @PizzaId=LAST_INSERT_ID();
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Regular Cheese";
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Pepperoni";
-- UPDATE pizzaorder SET PizzaOrderPrice=(SELECT SUM(PizzaPrice) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;
-- UPDATE pizzaorder SET PizzaOrderCost=(SELECT SUM(PizzaCost) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;
-- INSERT INTO pizza SELECT NULL, @OrderId, PizzaBaseNum, 14.88,3.30,True FROM pizzabase WHERE PizzaBaseSize="Large" AND PizzaBaseCrust="Original";
-- SET @PizzaId=LAST_INSERT_ID();
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Regular Cheese";
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Pepperoni";
-- UPDATE pizzaorder SET PizzaOrderPrice=(SELECT SUM(PizzaPrice) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;
-- UPDATE pizzaorder SET PizzaOrderCost=(SELECT SUM(PizzaCost) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;
-- INSERT INTO pizza SELECT NULL, @OrderId, PizzaBaseNum, 14.88,3.30,True FROM pizzabase WHERE PizzaBaseSize="Large" AND PizzaBaseCrust="Original";
-- SET @PizzaId=LAST_INSERT_ID();
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Regular Cheese";
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Pepperoni";
-- UPDATE pizzaorder SET PizzaOrderPrice=(SELECT SUM(PizzaPrice) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;
-- UPDATE pizzaorder SET PizzaOrderCost=(SELECT SUM(PizzaCost) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;
-- INSERT INTO pizza SELECT NULL, @OrderId, PizzaBaseNum, 14.88,3.30,True FROM pizzabase WHERE PizzaBaseSize="Large" AND PizzaBaseCrust="Original";
-- SET @PizzaId=LAST_INSERT_ID();
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Regular Cheese";
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Pepperoni";
-- UPDATE pizzaorder SET PizzaOrderPrice=(SELECT SUM(PizzaPrice) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;
-- UPDATE pizzaorder SET PizzaOrderCost=(SELECT SUM(PizzaCost) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;



-- INSERT INTO pizzaorder VALUES (NULL, 0.0,0.0,'2024-04-20 07:11:00',True,'Delivery');
-- SET @OrderId = LAST_INSERT_ID();
-- SET SQL_SAFE_UPDATES=0;
-- UPDATE customer SET CustomerStreet="115 Party Blvd", CustomerCity="Anderson", CustomerState="SC", CustomerZip=29621 WHERE CustomerFName="Andrew" AND CustomerLName="Wilkes-Krier";
-- SET SQL_SAFE_UPDATES=1;
-- SET @CustomerId=(SELECT CustomerNum FROM customer WHERE CustomerFName="Andrew" AND CustomerLName="Wilkes-Krier");
-- INSERT INTO delivery VALUES (@OrderId, @CustomerId);
-- INSERT INTO pizza SELECT NULL, @OrderId, PizzaBaseNum, 27.94,9.19,True FROM pizzabase WHERE PizzaBaseSize="XLarge" AND PizzaBaseCrust="Original";
-- SET @PizzaId=LAST_INSERT_ID();
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Sausage";
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Pepperoni";
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Four Cheese Blend";
-- INSERT INTO discount SELECT @PizzaId, DiscountBaseNum FROM discountbase WHERE DiscountBaseName="Gameday Special";
-- INSERT INTO pizza SELECT NULL, @OrderId, PizzaBaseNum, 31.50,6.25,True FROM pizzabase WHERE PizzaBaseSize="XLarge" AND PizzaBaseCrust="Original";
-- SET @PizzaId=LAST_INSERT_ID();
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Ham";
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Pineapple";
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Four Cheese Blend";
-- INSERT INTO discount SELECT @PizzaId, DiscountBaseNum FROM discountbase WHERE DiscountBaseName="Gameday Special";
-- INSERT INTO discount SELECT @PizzaId, DiscountBaseNum FROM discountbase WHERE DiscountBaseName="Specialty Pizza";
-- INSERT INTO pizza SELECT NULL, @OrderId, PizzaBaseNum, 26.75,8.18,True FROM pizzabase WHERE PizzaBaseSize="XLarge" AND PizzaBaseCrust="Original";
-- SET @PizzaId=LAST_INSERT_ID();
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Chicken";
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Bacon";
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Four Cheese Blend";
-- INSERT INTO discount SELECT @PizzaId, DiscountBaseNum FROM discountbase WHERE DiscountBaseName="Gameday Special";
-- UPDATE pizzaorder SET PizzaOrderPrice=(SELECT SUM(PizzaPrice) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;
-- UPDATE pizzaorder SET PizzaOrderCost=(SELECT SUM(PizzaCost) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;




-- INSERT INTO pizzaorder VALUES (NULL, 0.0,0.0,'2024-03-02 06:17:00',True,'Delivery');
-- SET @OrderId = LAST_INSERT_ID();
-- INSERT INTO customer VALUES (NULL, "Frank", "Turner", "6745 Wessex St", "Anderson", "SC", 29621, '864-232-2944');
-- INSERT INTO delivery VALUES (@OrderId, LAST_INSERT_ID());
-- INSERT INTO pizza SELECT NULL, @OrderId, PizzaBaseNum, 20.81,3.19,True FROM pizzabase WHERE PizzaBaseSize="Large" AND PizzaBaseCrust="Thin";
-- SET @PizzaId=LAST_INSERT_ID();
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Green Pepper";
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Onion";
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Chicken";
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Mushrooms";
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Four Cheese Blend";
-- UPDATE pizzaorder SET PizzaOrderPrice=(SELECT SUM(PizzaPrice) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;
-- UPDATE pizzaorder SET PizzaOrderCost=(SELECT SUM(PizzaCost) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;

-- INSERT INTO pizzaorder VALUES (NULL, 0.0,0.0,'2024-04-13 08:32:00',True,'Delivery');
-- SET @OrderId = LAST_INSERT_ID();
-- INSERT INTO customer VALUES (NULL, "Milo", "Aukerman", "8879 Suburban Home", "Anderson", "SC", 29621, '864-878-5679');
-- INSERT INTO delivery VALUES (@OrderId, LAST_INSERT_ID());
-- INSERT INTO pizza SELECT NULL, @OrderId, PizzaBaseNum, 13.00,2.00,True FROM pizzabase WHERE PizzaBaseSize="Large" AND PizzaBaseCrust="Thin";
-- SET @PizzaId=LAST_INSERT_ID();
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Four Cheese Blend";
-- INSERT INTO discount SELECT @PizzaId, DiscountBaseNum FROM discountbase WHERE DiscountBaseName="Employee";
-- INSERT INTO pizza SELECT NULL, @OrderId, PizzaBaseNum, 19.25,3.25,True FROM pizzabase WHERE PizzaBaseSize="Large" AND PizzaBaseCrust="Thin";
-- SET @PizzaId=LAST_INSERT_ID();
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Regular Cheese";
-- INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Pepperoni";
-- INSERT INTO discount SELECT @PizzaId, DiscountBaseNum FROM discountbase WHERE DiscountBaseName="Employee";
-- UPDATE pizzaorder SET PizzaOrderPrice=(SELECT SUM(PizzaPrice) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;
-- UPDATE pizzaorder SET PizzaOrderCost=(SELECT SUM(PizzaCost) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;
