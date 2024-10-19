CREATE DATABASE  IF NOT EXISTS `employee_directory_thymeleaf`;
USE `employee_directory_thymeleaf`;

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;

CREATE TABLE `employee` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(45) DEFAULT NULL,
  `last_name` varchar(45) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

--
-- Data for table `employee`
--

INSERT INTO `employee` VALUES
                           (1,'Piyush','Kumar','piyush@luv2code.com'),
                           (2,'Ashish','Ranjan','ashish@luv2code.com'),
                           (3,'Shivi','Sharma','shivi@luv2code.com'),
                           (4,'Vishal','Saxena','vishal@luv2code.com'),
                           (5,'Akash','Kumar','akash@luv2code.com');

