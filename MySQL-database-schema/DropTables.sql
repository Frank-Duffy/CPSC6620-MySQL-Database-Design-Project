-- Authors: Noah Britt, Francis Duffy

CREATE SCHEMA IF NOT EXISTS Pizzeria;
USE Pizzeria;

DROP TABLE IF EXISTS 
    pickup, 
    dinein, 
    delivery, 
    customer, 
    discount,
    pizzadiscount,
    orderdiscount,
    pizzatopping, 
    pizza, 
    pizzaorder, 
    pizzabase, 
    topping;
