-- create the databases
CREATE DATABASE IF NOT EXISTS projet_m2ssi;

-- -- create the users for each database
-- CREATE USER admintp1 IDENTIFIED BY 'admin';
-- GRANT CREATE, ALTER, INDEX, LOCK TABLES, REFERENCES, UPDATE, DELETE, DROP, SELECT, INSERT ON tp1.* TO admintp1 IDENTIFIED BY 'admin';

use projet_m2ssi;

-- drop table if exists users;

CREATE TABLE IF NOT EXISTS users (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `age` int(3) NOT NULL,
  `email` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
);