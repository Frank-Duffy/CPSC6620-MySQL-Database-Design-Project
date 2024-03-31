-- CREATE schema Part2;
USE Part2;


CREATE TABLE pizzabase(
	PizzaBaseNum	INT	PRIMARY KEY AUTO_INCREMENT,
	PizzaBaseSize	VARCHAR(20)	NOT NULL,
	PizzaBaseCrust	VARCHAR(20)	NOT NULL,
	PizzaBasePrice	DECIMAL(10,2)	NOT NULL,
	PizzaBaseCost	DECIMAL(10,2)	NOT NULL
);

CREATE TABLE pizzaorder(
	PizzaOrderNum	INT	PRIMARY KEY NOT NULL,
    PizzaOrderPrice	DECIMAL(10,2)	NOT NULL,
    PizzaOrderCost	DECIMAL(10,2)	NOT NULL,
    PizzaOrderDate	DATE	NOT NULL,
    PizzaOrderComplete	BOOL	NOT NULL,
    PizzaOrderType VARCHAR(10)	NOT NULL
);
CREATE TABLE dinein(
	DineInOrderNum	INT PRIMARY KEY NOT NULL,
    FOREIGN KEY (DineInOrderNum) REFERENCES pizzaorder(PizzaOrderNum),
    DineInTableNum	INT	NOT NULL
);
CREATE TABLE customer(
	CustomerNum	INT	PRIMARY KEY AUTO_INCREMENT,
    CustomerFName	VARCHAR(255)	NOT NULL,
    CustomerLName	VARCHAR(255)	NOT NULL,
    CustomerStreet	VARCHAR(255),
    CustomerCity	VARCHAR(255),
    CustomerState	VARCHAR(255),
    CustomerZip	INT
);
CREATE TABLE pickup(
	PickUpOrderNum	INT PRIMARY KEY NOT NULL,
    FOREIGN KEY (PickUpOrderNum) REFERENCES pizzaorder(PizzaOrderNum),
    PickUpCustomerNum	INT	NOT NULL,
    FOREIGN KEY (PickUpCustomerNum) REFERENCES customer(CustomerNum)
);
CREATE TABLE delivery(
	DeliveryOrderNum	INT PRIMARY KEY NOT NULL,
    FOREIGN KEY (DeliveryOrderNum) REFERENCES pizzaorder(PizzaOrderNum),
	DeliveryCustomerNum	INT	NOT NULL,
    FOREIGN KEY (DeliveryCustomerNum) REFERENCES customer(CustomerNum)
);

CREATE TABLE pizza(
	PizzaNum	INT	PRIMARY KEY AUTO_INCREMENT,
	PizzaOrderNum	INT	NOT NULL,
	FOREIGN KEY (PizzaOrderNum) REFERENCES pizzaorder(PizzaOrderNum),
	PizzaPrice	DECIMAL(10,2)	NOT NULL,
	PizzaCost	DECIMAL(10,2)	NOT NULL,
	PizzaIsComplete BOOL NOT NULL
);

CREATE TABLE discountbase(
	DiscountBaseNum	INT	PRIMARY KEY AUTO_INCREMENT,
    DiscountBaseName	VARCHAR(255)	NOT NULL	UNIQUE,
    DiscountBasePercent	INT,
    DiscountBaseAmt	DECIMAL(10,2)
);

CREATE TABLE discount(
	DiscountOrderNum INT NOT NULL,
    FOREIGN KEY (DiscountOrderNum) REFERENCES pizzaorder(PizzaOrderNum),
    DiscountDiscountNum INT,
    FOREIGN KEY (DiscountDiscountNum) REFERENCES discountbase(DiscountBaseNum),
    PRIMARY KEY (DiscountOrderNum, DiscountDiscountNum)
);

CREATE TABLE topping(
	ToppingNum INT PRIMARY KEY AUTO_INCREMENT,
    ToppingName VARCHAR(255)	NOT NULL	UNIQUE,
    ToppingPrice DECIMAL(10,2)	NOT NULL,
    ToppingCost	DECIMAL(10,2)	NOT NULL,
    ToppingAmt	INT	NOT NULL,
    ToppingMinQty	INT	NOT NULL,
    ToppingSmall	DECIMAL(10,2)	NOT NULL,
    ToppingMedium	DECIMAL(10,2)	NOT NULL,
    ToppingLarge	DECIMAL(10,2)	NOT NULL,
    ToppingXLarge	DECIMAL(10,2)	NOT NULL
);
CREATE TABLE pizzatopping(
	PizzaToppingPizzaNum	INT	NOT NULL,
    FOREIGN KEY (PizzaToppingPizzaNum) REFERENCES	pizza(PizzaNum),
    PizzaToppingToppingNum	INT	NOT NULL,
    FOREIGN KEY (PizzaToppingToppingNum) REFERENCES topping(ToppingNum),
    PizzaToppingHasDouble	BOOL	NOT NULL,
    PRIMARY KEY (PizzaToppingPizzaNum, PizzaToppingToppingNum)
);

COMMIT;