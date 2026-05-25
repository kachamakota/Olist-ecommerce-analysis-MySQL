
-- Creating Primary and Foregin Keys


-- Adding PK

ALTER TABLE `customers`
ADD PRIMARY KEY (`customer_id`);

ALTER TABLE `orders`
ADD PRIMARY KEY (`order_id`);

ALTER TABLE `order_items`
ADD PRIMARY KEY (`order_id`, `order_item_id`);

ALTER TABLE `order_payments`
ADD PRIMARY KEY (`order_id`, `payment_sequential`);

ALTER TABLE `order_reviews`
ADD PRIMARY KEY (`review_id`);

ALTER TABLE `products`
ADD PRIMARY KEY (`product_id`);

ALTER TABLE `sellers`
ADD PRIMARY KEY (`seller_id`);

ALTER TABLE `product_category_name_translation`
ADD PRIMARY KEY (`product_category_name`);



-- Adding FK

ALTER TABLE `orders`
ADD CONSTRAINT `fk_orders_customers`
FOREIGN KEY (`customer_id`)
REFERENCES `customers` (`customer_id`);


ALTER TABLE `order_items`
ADD CONSTRAINT `fk_order_items_order`
FOREIGN KEY (`order_id`)
REFERENCES `orders` (`order_id`);


ALTER TABLE `order_items`
ADD CONSTRAINT `fk_order_items_products`
FOREIGN KEY (`product_id`)
REFERENCES `products` (`product_id`);


ALTER TABLE `order_items`
ADD CONSTRAINT `fk_order_items_sellers`
FOREIGN KEY (`seller_id`)
REFERENCES `sellers` (`seller_id`);


ALTER TABLE `order_payments`
ADD CONSTRAINT `fk_order_payments_orders`
FOREIGN KEY (`order_id`)
REFERENCES `orders` (`order_id`);


ALTER TABLE `order_reviews`
ADD CONSTRAINT `fk_order_reviews_orders`
FOREIGN KEY (`order_id`)
REFERENCES `orders` (`order_id`);