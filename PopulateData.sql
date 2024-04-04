USE Part2;

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