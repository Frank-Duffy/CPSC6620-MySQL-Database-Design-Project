-- CREATE schema Pizzeria;
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
    PizzaOrderDate	DATE	NOT NULL,
    PizzaOrderComplete	BOOLEAN	NOT NULL DEFAULT 0,
    PizzaOrderType VARCHAR(7)	NOT NULL
);
CREATE TABLE dinein(
	PizzaOrderNum	INT PRIMARY KEY,
    FOREIGN KEY (PizzaOrderNum) REFERENCES pizzaorder(PizzaOrderNum),
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
	PizzaOrderNum	INT PRIMARY KEY,
    CustomerID	INT	NOT NULL,
    FOREIGN KEY (PizzaOrderNum) REFERENCES pizzaorder(PizzaOrderNum),
    FOREIGN KEY (CustomerID) REFERENCES customer(CustomerID)
);
CREATE TABLE delivery(
	PizzaOrderNum	INT PRIMARY KEY,
    CustomerID	INT	NOT NULL,
    FOREIGN KEY (PizzaOrderNum) REFERENCES pizzaorder(PizzaOrderNum),
    FOREIGN KEY (CustomerID) REFERENCES customer(CustomerID)
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
    PizzaToppingHasDouble	BOOLEAN	NOT NULL,
    PRIMARY KEY (PizzaToppingPizzaNum, PizzaToppingToppingNum)
);

COMMIT;