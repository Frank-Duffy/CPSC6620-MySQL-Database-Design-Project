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
    PizzaOrderDate	DATETIME	NOT NULL,
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
CREATE TABLE discount(
	DiscountNum	    INT	PRIMARY KEY AUTO_INCREMENT,
    DiscountName	VARCHAR(255) NOT NULL UNIQUE,
    DiscountType	CHAR(1),
    DiscountAmt	    DECIMAL(4,2)
);
CREATE TABLE orderdiscount(
	PizzaOrderNum INT NOT NULL,
    DiscountNum INT NOT NULL,
    FOREIGN KEY (PizzaOrderNum) REFERENCES pizzaorder(PizzaOrderNum),
    FOREIGN KEY (DiscountNum) REFERENCES discount(DiscountNum),
    PRIMARY KEY (PizzaOrderNum, DiscountNum)
);
CREATE TABLE pizzadiscount(
	PizzaNum INT NOT NULL,
    DiscountNum INT NOT NULL,
    FOREIGN KEY (PizzaNum) REFERENCES pizza(PizzaNum),
    FOREIGN KEY (DiscountNum) REFERENCES discount(DiscountNum),
    PRIMARY KEY (PizzaNum, DiscountNum)
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
	PizzaNum	INT	NOT NULL,
    ToppingNum	INT	NOT NULL,
    PizzaToppingHasDouble BOOLEAN NOT NULL DEFAULT 0,
    FOREIGN KEY (PizzaNum) REFERENCES	pizza(PizzaNum),
    FOREIGN KEY (ToppingNum) REFERENCES topping(ToppingNum),
    PRIMARY KEY (PizzaNum, ToppingNum)
);
COMMIT;