-- Authors: Noah Britt, Francis Duffy

CREATE SCHEMA IF NOT EXISTS Pizzeria;
USE Pizzeria;


CREATE TABLE pizzabase(
	PizzaBaseNum	INT	PRIMARY KEY AUTO_INCREMENT,
	PizzaBaseSize	VARCHAR(8)	NOT NULL,
	PizzaBaseCrust	VARCHAR(11)	NOT NULL,
	PizzaBasePrice	DECIMAL(4,2)	NOT NULL,
	PizzaBaseCost	DECIMAL(4,2)	NOT NULL
);

CREATE TABLE pizzaorder(
	PizzaOrderNum	INT	PRIMARY KEY AUTO_INCREMENT,
    PizzaOrderPrice	DECIMAL(4,2)	NOT NULL,
    PizzaOrderCost	DECIMAL(4,2)	NOT NULL,
    PizzaOrderDate	DATETIME	NOT NULL,
    PizzaOrderComplete	BOOLEAN	NOT NULL DEFAULT 0,
    PizzaOrderType VARCHAR(8)	NOT NULL
);
CREATE TABLE dinein(
	DineInPizzaOrderNum	INT PRIMARY KEY,
    FOREIGN KEY (DineInPizzaOrderNum) REFERENCES pizzaorder(PizzaOrderNum),
    DineInTableNum	INT	NOT NULL
);
CREATE TABLE customer(
	CustomerID	INT	PRIMARY KEY AUTO_INCREMENT,
    CustomerFName	VARCHAR(255)	NOT NULL,
    CustomerLName	VARCHAR(255)	NOT NULL,
    CustomerStreet	VARCHAR(255),
    CustomerCity	VARCHAR(255),
    CustomerState	VARCHAR(255),
    CustomerZip		INT,
    CustomerPhone 	VARCHAR(12)
);
CREATE TABLE pickup(
	PickupPizzaOrderNum	INT PRIMARY KEY,
    PickupCustomerID	INT	NOT NULL,
    FOREIGN KEY (PickupPizzaOrderNum) REFERENCES pizzaorder(PizzaOrderNum),
    FOREIGN KEY (PickupCustomerID) REFERENCES customer(CustomerID)
);
CREATE TABLE delivery(
	DeliveryPizzaOrderNum	INT PRIMARY KEY,
    DeliveryCustomerID	INT	NOT NULL,
    FOREIGN KEY (DeliveryPizzaOrderNum) REFERENCES pizzaorder(PizzaOrderNum),
    FOREIGN KEY (DeliveryCustomerID) REFERENCES customer(CustomerID)
);

CREATE TABLE pizza(
	PizzaNum	    INT	PRIMARY KEY AUTO_INCREMENT,
	PizzaOrderNum	INT	NOT NULL,
    PizzaBaseNum    INT NOT NULL,
	PizzaPrice	    DECIMAL(4,2) NOT NULL,
	PizzaCost	    DECIMAL(4,2) NOT NULL,
	PizzaIsComplete BOOLEAN NOT NULL DEFAULT 0,
    FOREIGN KEY (PizzaOrderNum) REFERENCES pizzaorder(PizzaOrderNum),
    FOREIGN KEY (PizzaBaseNum) REFERENCES pizzabase(PizzaBaseNum)
);
CREATE TABLE discount(
	DiscountNum	    INT	PRIMARY KEY AUTO_INCREMENT,
    DiscountName	VARCHAR(255) NOT NULL UNIQUE,
    DiscountType	CHAR(1),
    DiscountAmt	    DECIMAL(4,2)
);
CREATE TABLE orderdiscount(
	OrderDiscountPizzaOrderNum INT NOT NULL,
    OrderDiscountNum INT NOT NULL,
    FOREIGN KEY (OrderDiscountPizzaOrderNum) REFERENCES pizzaorder(PizzaOrderNum),
    FOREIGN KEY (OrderDiscountNum) REFERENCES discount(DiscountNum),
    PRIMARY KEY (OrderDiscountPizzaOrderNum, OrderDiscountNum)
);
CREATE TABLE pizzadiscount(
	PizzaDiscountPizzaNum INT NOT NULL,
    PizzaDiscountNum INT NOT NULL,
    FOREIGN KEY (PizzaDiscountPizzaNum) REFERENCES pizza(PizzaNum),
    FOREIGN KEY (PizzaDiscountNum) REFERENCES discount(DiscountNum),
    PRIMARY KEY (PizzaDiscountPizzaNum, PizzaDiscountNum)
);
CREATE TABLE topping(
	ToppingNum      INT PRIMARY KEY AUTO_INCREMENT,
    ToppingName     VARCHAR(255)    NOT NULL	UNIQUE,
    ToppingPrice    DECIMAL(4,2)	NOT NULL,
    ToppingCost	    DECIMAL(4,2)	NOT NULL,
    ToppingPersonal	DECIMAL(3,2)	NOT NULL,
    ToppingMedium	DECIMAL(3,2)	NOT NULL,
    ToppingLarge	DECIMAL(3,2)	NOT NULL,
    ToppingXLarge	DECIMAL(3,2)	NOT NULL,
    ToppingMinQOH   DECIMAL(5,2)    NOT NULL,
    ToppingQOH      DECIMAL(5,2)    NOT NULL
);
CREATE TABLE pizzatopping(
	PizzaToppingPizzaNum	INT	NOT NULL,
    PizzaToppingToppingNum	INT	NOT NULL,
    PizzaToppingHasDouble BOOLEAN NOT NULL DEFAULT 0,
    FOREIGN KEY (PizzaToppingPizzaNum) REFERENCES	pizza(PizzaNum),
    FOREIGN KEY (PizzaToppingToppingNum) REFERENCES topping(ToppingNum),
    PRIMARY KEY (PizzaToppingPizzaNum, PizzaToppingToppingNum)
);
COMMIT;