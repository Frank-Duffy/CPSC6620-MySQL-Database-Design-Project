Use Part2;

CREATE OR REPLACE VIEW ToppingPopularity AS
SELECT t.ToppingName, COUNT(pt.PizzaToppingToppingNum) + SUM(CASE WHEN pt.PizzaToppingHasDouble THEN 1 ELSE 0 END) AS ToppingCount
FROM topping t
JOIN  pizzatopping pt ON t.ToppingNum = pt.PizzaToppingToppingNum
JOIN pizza p ON pt.PizzaToppingPizzaNum = p.PizzaNum
GROUP BY t.ToppingName ORDER BY ToppingCount DESC;
SELECT * FROM ToppingPopularity;

CREATE OR REPLACE VIEW ProfitByPizza AS
SELECT pb.PizzaBaseSize, pb.PizzaBaseCrust, SUM(p.PizzaPrice - p.PizzaCost) AS Profit,
    DATE_FORMAT(PizzaOrderDate, '%m/%Y') AS "Order Month"
FROM pizza p
JOIN pizzabase pb ON p.PizzaBaseNum = pb.PizzaBaseNum
JOIN pizzaorder o ON p.PizzaOrderNum=o.PizzaOrderNum
WHERE o.PizzaOrderDate BETWEEN '2024-03-01' AND '2024-05-01'
GROUP BY pb.PizzaBaseSize, pb.PizzaBaseCrust, "Order Month"
ORDER BY Profit;
SELECT * FROM ProfitByPizza;

CREATE OR REPLACE VIEW ProfitByOrderType AS 
SELECT PizzaOrderType AS customerType, DATE_FORMAT(PizzaOrderDate, '%m/%Y') AS "Order Month",
	SUM(PizzaOrderPrice) AS TotalOrderPrice,
    SUM(PizzaOrderCost) AS TotalOrderCost,
    SUM(PizzaOrderPrice - PizzaOrderCost) AS Profit
FROM pizzaorder GROUP BY customerType
UNION ALL 
SELECT NULL AS customerType, "Grand Total" AS "Order Month", SUM(PizzaOrderPrice) AS TotalOrderPrice, SUM(PizzaOrderCost) AS TotalOrderCost, SUM(PizzaOrderPrice-PizzaOrderCost) AS Profit FROM pizzaorder
ORDER BY customerType DESC;
SELECT * FROM ProfitByOrderType;