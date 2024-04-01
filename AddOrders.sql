INSERT INTO pizzaorder VALUES (NULL, 0.0,0.0,'2024-03-05 12:03:00',True,'Dine In');
SET @OrderId = LAST_INSERT_ID();
INSERT INTO dinein VALUES (@OrderId, 21);
INSERT INTO pizza SELECT NULL, @OrderId, PizzaBaseNum, 20.75,3.68,True FROM pizzabase WHERE PizzaBaseSize="Large" AND PizzaBaseCrust="Thin";
SET @PizzaId=LAST_INSERT_ID();
INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Regular Cheese";
INSERT INTO discount SELECT @PizzaId, DiscountBaseNum FROM discountbase WHERE DiscountBaseName="Lunch Special Large";
UPDATE pizzaorder SET PizzaOrderPrice=(SELECT SUM(PizzaPrice) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;
UPDATE pizzaorder SET PizzaOrderCost=(SELECT SUM(PizzaCost) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;

INSERT INTO pizzaorder VALUES (NULL, 0.0,0.0,'2024-04-03 12:05:00',True,'Dine In');
SET @OrderId = LAST_INSERT_ID();
INSERT INTO dinein VALUES (@OrderId, 4);
INSERT INTO pizza SELECT NULL, @OrderId, PizzaBaseNum, 12.85,3.23,True FROM pizzabase WHERE PizzaBaseSize="Medium" AND PizzaBaseCrust="Pan";
SET @PizzaId=LAST_INSERT_ID();
INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Feta Cheese";
INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Black Olives";
INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Roma Tomatoes";
INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Mushrooms";
INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Banana Peppers";
INSERT INTO discount SELECT @PizzaId, DiscountBaseNum FROM discountbase WHERE DiscountBaseName="Lunch Special Medium";
INSERT INTO discount SELECT @PizzaId, DiscountBaseNum FROM discountbase WHERE DiscountBaseName="Specialty Pizza";
INSERT INTO pizza SELECT NULL, @OrderId, PizzaBaseNum, 6.93,1.40,True FROM pizzabase WHERE PizzaBaseSize="Small" AND PizzaBaseCrust="Original";
SET @PizzaId=LAST_INSERT_ID();
INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Regular Cheese";
INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Chicken";
INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Banana Peppers";
UPDATE pizzaorder SET PizzaOrderPrice=(SELECT SUM(PizzaPrice) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;
UPDATE pizzaorder SET PizzaOrderCost=(SELECT SUM(PizzaCost) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;

INSERT INTO pizzaorder VALUES (NULL, 0.0,0.0,'2024-03-03 09:30:00',True,'Pick Up');
SET @OrderId = LAST_INSERT_ID();
INSERT INTO customer VALUES (NULL, "Andrew", "Wilkes-Krier", NULL, NULL, NULL, NULL, '864-254=5861');
INSERT INTO pickup VALUES (@OrderId, LAST_INSERT_ID());
INSERT INTO pizza SELECT NULL, @OrderId, PizzaBaseNum, 14.88,3.30,True FROM pizzabase WHERE PizzaBaseSize="Large" AND PizzaBaseCrust="Original";
SET @PizzaId=LAST_INSERT_ID();
INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Regular Cheese";
INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Pepperoni";
UPDATE pizzaorder SET PizzaOrderPrice=(SELECT SUM(PizzaPrice) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;
UPDATE pizzaorder SET PizzaOrderCost=(SELECT SUM(PizzaCost) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;
INSERT INTO pizza SELECT NULL, @OrderId, PizzaBaseNum, 14.88,3.30,True FROM pizzabase WHERE PizzaBaseSize="Large" AND PizzaBaseCrust="Original";
SET @PizzaId=LAST_INSERT_ID();
INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Regular Cheese";
INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Pepperoni";
UPDATE pizzaorder SET PizzaOrderPrice=(SELECT SUM(PizzaPrice) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;
UPDATE pizzaorder SET PizzaOrderCost=(SELECT SUM(PizzaCost) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;
INSERT INTO pizza SELECT NULL, @OrderId, PizzaBaseNum, 14.88,3.30,True FROM pizzabase WHERE PizzaBaseSize="Large" AND PizzaBaseCrust="Original";
SET @PizzaId=LAST_INSERT_ID();
INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Regular Cheese";
INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Pepperoni";
UPDATE pizzaorder SET PizzaOrderPrice=(SELECT SUM(PizzaPrice) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;
UPDATE pizzaorder SET PizzaOrderCost=(SELECT SUM(PizzaCost) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;
INSERT INTO pizza SELECT NULL, @OrderId, PizzaBaseNum, 14.88,3.30,True FROM pizzabase WHERE PizzaBaseSize="Large" AND PizzaBaseCrust="Original";
SET @PizzaId=LAST_INSERT_ID();
INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Regular Cheese";
INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Pepperoni";
UPDATE pizzaorder SET PizzaOrderPrice=(SELECT SUM(PizzaPrice) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;
UPDATE pizzaorder SET PizzaOrderCost=(SELECT SUM(PizzaCost) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;
INSERT INTO pizza SELECT NULL, @OrderId, PizzaBaseNum, 14.88,3.30,True FROM pizzabase WHERE PizzaBaseSize="Large" AND PizzaBaseCrust="Original";
SET @PizzaId=LAST_INSERT_ID();
INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Regular Cheese";
INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Pepperoni";
UPDATE pizzaorder SET PizzaOrderPrice=(SELECT SUM(PizzaPrice) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;
UPDATE pizzaorder SET PizzaOrderCost=(SELECT SUM(PizzaCost) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;
INSERT INTO pizza SELECT NULL, @OrderId, PizzaBaseNum, 14.88,3.30,True FROM pizzabase WHERE PizzaBaseSize="Large" AND PizzaBaseCrust="Original";
SET @PizzaId=LAST_INSERT_ID();
INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Regular Cheese";
INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Pepperoni";
UPDATE pizzaorder SET PizzaOrderPrice=(SELECT SUM(PizzaPrice) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;
UPDATE pizzaorder SET PizzaOrderCost=(SELECT SUM(PizzaCost) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;



INSERT INTO pizzaorder VALUES (NULL, 0.0,0.0,'2024-04-20 07:11:00',True,'Delivery');
SET @OrderId = LAST_INSERT_ID();
SET SQL_SAFE_UPDATES=0;
UPDATE customer SET CustomerStreet="115 Party Blvd", CustomerCity="Anderson", CustomerState="SC", CustomerZip=29621 WHERE CustomerFName="Andrew" AND CustomerLName="Wilkes-Krier";
SET SQL_SAFE_UPDATES=1;
SET @CustomerId=(SELECT CustomerNum FROM customer WHERE CustomerFName="Andrew" AND CustomerLName="Wilkes-Krier");
INSERT INTO delivery VALUES (@OrderId, @CustomerId);
INSERT INTO pizza SELECT NULL, @OrderId, PizzaBaseNum, 27.94,9.19,True FROM pizzabase WHERE PizzaBaseSize="XLarge" AND PizzaBaseCrust="Original";
SET @PizzaId=LAST_INSERT_ID();
INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Sausage";
INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Pepperoni";
INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Four Cheese Blend";
INSERT INTO discount SELECT @PizzaId, DiscountBaseNum FROM discountbase WHERE DiscountBaseName="Gameday Special";
INSERT INTO pizza SELECT NULL, @OrderId, PizzaBaseNum, 31.50,6.25,True FROM pizzabase WHERE PizzaBaseSize="XLarge" AND PizzaBaseCrust="Original";
SET @PizzaId=LAST_INSERT_ID();
INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Ham";
INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Pineapple";
INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Four Cheese Blend";
INSERT INTO discount SELECT @PizzaId, DiscountBaseNum FROM discountbase WHERE DiscountBaseName="Gameday Special";
INSERT INTO discount SELECT @PizzaId, DiscountBaseNum FROM discountbase WHERE DiscountBaseName="Specialty Pizza";
INSERT INTO pizza SELECT NULL, @OrderId, PizzaBaseNum, 26.75,8.18,True FROM pizzabase WHERE PizzaBaseSize="XLarge" AND PizzaBaseCrust="Original";
SET @PizzaId=LAST_INSERT_ID();
INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Chicken";
INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Bacon";
INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Four Cheese Blend";
INSERT INTO discount SELECT @PizzaId, DiscountBaseNum FROM discountbase WHERE DiscountBaseName="Gameday Special";



INSERT INTO pizza SELECT NULL, @OrderId, PizzaBaseNum, 6.93,1.40,True FROM pizzabase WHERE PizzaBaseSize="Small" AND PizzaBaseCrust="Original";
SET @PizzaId=LAST_INSERT_ID();
INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Regular Cheese";
INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Chicken";
INSERT INTO pizzatopping SELECT @PizzaId, ToppingNum, TRUE FROM topping WHERE ToppingName="Banana Peppers";
UPDATE pizzaorder SET PizzaOrderPrice=(SELECT SUM(PizzaPrice) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;
UPDATE pizzaorder SET PizzaOrderCost=(SELECT SUM(PizzaCost) FROM pizza WHERE PizzaOrderNum=@OrderId) WHERE PizzaOrderNum=@OrderId;

-- SET @PizzaPrice=SELECT PizzaBasePrice FROM pizzabase WHERE PizzaBaseSize="Large" AND PizzaBaseCrust="Thin";
-- UPDATE pizza SET PizzaPrice=(SELECT ToppingPrice*(CASE WHEN pizzabase.PizzaSize="Small" THEN topping.ToppingSmall ELSE 1) FROM pizzabase JOIN WHERE PizzaBaseSize="Large" AND PizzaBaseCrust="Thin");
-- INSERT INTO pizzatopping SELECT (PizzaId, ToppingNum) FROM topping WHERE ToppingName="Regular Cheese" AND 
-- SELECT LAST_INSERT_ID() AS DiscountId;
-- INSERT INTO 



-- large thin crust pizza with Regular
-- Cheese (extra), Pepperoni, and Sausage (Price: $20.75, Cost: $3.68). They used the “Lunch Special Large”
-- discount for the pizza.