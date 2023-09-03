-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: contacts
-- ------------------------------------------------------
-- Server version	5.7.43-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `countries`
--

DROP TABLE IF EXISTS `countries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `countries` (
  `country_id` int(11) NOT NULL AUTO_INCREMENT,
  `country_name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`country_id`)
) ENGINE=InnoDB AUTO_INCREMENT=196 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `countries`
--

LOCK TABLES `countries` WRITE;
/*!40000 ALTER TABLE `countries` DISABLE KEYS */;
INSERT INTO `countries` VALUES (1,'AFGHANISTAN'),(2,'Albania'),(3,'Algeria'),(4,'Andorra'),(5,'Angola'),(6,'Antigua & Barbuda'),(7,'ARGENTINA'),(8,'Armenia'),(9,'Australia'),(10,'Austria'),(11,'Azerbaijan'),(12,'Bahamas'),(13,'Bahrain'),(14,'Bangladesh'),(15,'Barbados'),(16,'Belarus'),(17,'Belgium'),(18,'Belize'),(19,'Benin'),(20,'Bhutan'),(21,'Bolivia'),(22,'Bosnia & Herzegovina'),(23,'Botswana'),(24,'Brazil'),(25,'Brunei'),(26,'Bulgaria'),(27,'Burkina Faso'),(28,'Burundi'),(29,'Cabo Verde'),(30,'Cambodia'),(31,'Cameroon'),(32,'Canada'),(33,'Central African Republic'),(34,'Chad'),(35,'Chile'),(36,'China'),(37,'Colombia'),(38,'Comoros'),(39,'Congo'),(40,'Costa Rica'),(41,'Côte d’Ivoire'),(42,'Croatia'),(43,'Cuba'),(44,'Cyprus'),(45,'Czech Republic'),(46,'Denmark'),(47,'Djibouti'),(48,'Dominica'),(49,'Dominican Republic'),(50,'DR Congo'),(51,'Ecuador'),(52,'Egypt'),(53,'El Salvador'),(54,'Equatorial Guinea'),(55,'Eritrea'),(56,'Estonia'),(57,'Eswatini'),(58,'Ethiopia'),(59,'Fiji'),(60,'Finland'),(61,'France'),(62,'Gabon'),(63,'Gambia'),(64,'Georgia'),(65,'Germany'),(66,'Ghana'),(67,'Greece'),(68,'Grenada'),(69,'Guatemala'),(70,'Guinea'),(71,'Guinea-Bissau'),(72,'Guyana'),(73,'Haiti'),(74,'Holy See'),(75,'Honduras'),(76,'Hungary'),(77,'Iceland'),(78,'India'),(79,'Indonesia'),(80,'Iran'),(81,'Iraq'),(82,'Ireland'),(83,'Israel'),(84,'Italy'),(85,'Jamaica'),(86,'Japan'),(87,'Jordan'),(88,'Kazakhstan'),(89,'Kenya'),(90,'Kiribati'),(91,'Kuwait'),(92,'Kyrgyzstan'),(93,'Laos'),(94,'Latvia'),(95,'Lebanon'),(96,'Lesotho'),(97,'Liberia'),(98,'Libya'),(99,'Liechtenstein'),(100,'Lithuania'),(101,'Luxembourg'),(102,'Madagascar'),(103,'Malawi'),(104,'Malaysia'),(105,'Maldives'),(106,'Mali'),(107,'Malta'),(108,'Marshall Islands'),(109,'Mauritania'),(110,'Mauritius'),(111,'Mexico'),(112,'Micronesia'),(113,'Moldova'),(114,'Monaco'),(115,'Mongolia'),(116,'Montenegro'),(117,'Morocco'),(118,'Mozambique'),(119,'Myanmar'),(120,'Namibia'),(121,'Nauru'),(122,'Nepal'),(123,'Netherlands'),(124,'New Zealand'),(125,'Nicaragua'),(126,'Niger'),(127,'Nigeria'),(128,'North Korea'),(129,'North Macedonia'),(130,'Norway'),(131,'Oman'),(132,'Pakistan'),(133,'Palau'),(134,'Panama'),(135,'Papua New Guinea'),(136,'Paraguay'),(137,'Peru'),(138,'Philippines'),(139,'Poland'),(140,'Portugal'),(141,'Qatar'),(142,'Romania'),(143,'Russia'),(144,'Rwanda'),(145,'Saint Kitts & Nevis'),(146,'Saint Lucia'),(147,'Samoa'),(148,'San Marino'),(149,'Sao Tome & Principe'),(150,'Saudi Arabia'),(151,'Senegal'),(152,'Serbia'),(153,'Seychelles'),(154,'Sierra Leone'),(155,'Singapore'),(156,'Slovakia'),(157,'Slovenia'),(158,'Solomon Islands'),(159,'Somalia'),(160,'South Africa'),(161,'South Korea'),(162,'South Sudan'),(163,'Spain'),(164,'Sri Lanka'),(165,'St. Vincent & Grenadines'),(166,'State of Palestine'),(167,'Sudan'),(168,'Suriname'),(169,'Sweden'),(170,'Switzerland'),(171,'Syria'),(172,'Tajikistan'),(173,'Tanzania'),(174,'Thailand'),(175,'Timor-Leste'),(176,'Togo'),(177,'Tonga'),(178,'Trinidad & Tobago'),(179,'Tunisia'),(180,'Turkey'),(181,'Turkmenistan'),(182,'Tuvalu'),(183,'Uganda'),(184,'Ukraine'),(185,'United Arab Emirates'),(186,'United Kingdom'),(187,'United States'),(188,'Uruguay'),(189,'Uzbekistan'),(190,'Vanuatu'),(191,'Venezuela'),(192,'Vietnam'),(193,'Yemen'),(194,'Zambia'),(195,'Zimbabwe');
/*!40000 ALTER TABLE `countries` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-09-03 19:25:24
