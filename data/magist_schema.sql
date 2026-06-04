-- Magist database schema
-- GitHub-friendly schema file extracted from the original MySQL dump.
-- Full data dump is not included because of file size.

CREATE DATABASE IF NOT EXISTS `magist`;
USE `magist`;

-- -----------------------------------------------------
-- Table structure for `customers`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `customer_id` varchar(255) NOT NULL,
  `customer_unique_id` varchar(255) NOT NULL,
  `customer_zip_code_prefix` int NOT NULL,
  PRIMARY KEY (`customer_id`),
  KEY `customer_zip_code_prefix` (`customer_zip_code_prefix`),
  CONSTRAINT `customers_ibfk_1` FOREIGN KEY (`customer_zip_code_prefix`) REFERENCES `geo` (`zip_code_prefix`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table structure for `geo`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `geo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `geo` (
  `zip_code_prefix` int NOT NULL,
  `city` mediumtext,
  `state` mediumtext,
  `lat` decimal(7,4) DEFAULT NULL,
  `lng` decimal(8,4) DEFAULT NULL,
  PRIMARY KEY (`zip_code_prefix`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table structure for `order_items`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `order_id` varchar(255) NOT NULL,
  `order_item_id` int DEFAULT NULL,
  `product_id` varchar(255) NOT NULL,
  `seller_id` varchar(255) NOT NULL,
  `shipping_limit_date` timestamp NULL DEFAULT NULL,
  `price` float DEFAULT NULL,
  `freight_value` float DEFAULT NULL,
  KEY `order_items_order_id` (`order_id`(26)),
  KEY `order_items_product_id` (`product_id`(26)),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  KEY `seller_id` (`seller_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`),
  CONSTRAINT `order_items_ibfk_3` FOREIGN KEY (`seller_id`) REFERENCES `sellers` (`seller_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table structure for `order_payments`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `order_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_payments` (
  `order_id` varchar(255) NOT NULL,
  `payment_sequential` int DEFAULT NULL,
  `payment_type` text,
  `payment_installments` int DEFAULT NULL,
  `payment_value` float DEFAULT NULL,
  KEY `order_payments_order_id` (`order_id`(26)),
  KEY `order_id` (`order_id`),
  CONSTRAINT `order_payments_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table structure for `order_reviews`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `order_reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_reviews` (
  `review_id` varchar(255) NOT NULL,
  `order_id` varchar(255) NOT NULL,
  `review_score` int DEFAULT NULL,
  `review_comment_title` text,
  `review_comment_message` text,
  `review_creation_date` timestamp NULL DEFAULT NULL,
  `review_answer_timestamp` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`review_id`),
  KEY `order_id` (`order_id`),
  CONSTRAINT `order_reviews_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table structure for `orders`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `order_id` varchar(255) NOT NULL,
  `customer_id` varchar(255) NOT NULL,
  `order_status` text,
  `order_purchase_timestamp` timestamp NULL DEFAULT NULL,
  `order_approved_at` timestamp NULL DEFAULT NULL,
  `order_delivered_carrier_date` timestamp NULL DEFAULT NULL,
  `order_delivered_customer_date` timestamp NULL DEFAULT NULL,
  `order_estimated_delivery_date` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  KEY `orders_order_id` (`order_id`(26)),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table structure for `product_category_name_translation`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `product_category_name_translation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_category_name_translation` (
  `product_category_name` varchar(255) NOT NULL,
  `product_category_name_english` text,
  PRIMARY KEY (`product_category_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table structure for `products`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `product_id` varchar(255) NOT NULL,
  `product_category_name` varchar(255) NOT NULL,
  `product_name_length` int DEFAULT NULL,
  `product_description_length` int DEFAULT NULL,
  `product_photos_qty` int DEFAULT NULL,
  `product_weight_g` int DEFAULT NULL,
  `product_length_cm` int DEFAULT NULL,
  `product_height_cm` int DEFAULT NULL,
  `product_width_cm` int DEFAULT NULL,
  PRIMARY KEY (`product_id`),
  KEY `products_product_id` (`product_id`(26)),
  KEY `product_category_name` (`product_category_name`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`product_category_name`) REFERENCES `product_category_name_translation` (`product_category_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table structure for `sellers`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `sellers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sellers` (
  `seller_id` varchar(255) NOT NULL,
  `seller_zip_code_prefix` int NOT NULL,
  PRIMARY KEY (`seller_id`),
  KEY `seller_zip_code_prefix` (`seller_zip_code_prefix`),
  CONSTRAINT `sellers_ibfk_2` FOREIGN KEY (`seller_zip_code_prefix`) REFERENCES `geo` (`zip_code_prefix`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

