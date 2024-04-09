CREATE DATABASE  IF NOT EXISTS `git` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `git`;
-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: git
-- ------------------------------------------------------
-- Server version	8.0.36

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
-- Table structure for table `branch`
--

DROP TABLE IF EXISTS `branch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `branch` (
  `name` varchar(32) NOT NULL,
  `repository` varchar(32) NOT NULL,
  `lastPushDate` date DEFAULT NULL,
  `isMain` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`name`,`repository`),
  KEY `repository` (`repository`),
  CONSTRAINT `branch_ibfk_1` FOREIGN KEY (`repository`) REFERENCES `repository` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `branch`
--

LOCK TABLES `branch` WRITE;
/*!40000 ALTER TABLE `branch` DISABLE KEYS */;
/*!40000 ALTER TABLE `branch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `branch_off`
--

DROP TABLE IF EXISTS `branch_off`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `branch_off` (
  `new_branch` varchar(32) NOT NULL,
  `old_branch` varchar(32) NOT NULL,
  `repository` varchar(32) NOT NULL,
  PRIMARY KEY (`new_branch`,`old_branch`,`repository`),
  KEY `old_branch` (`old_branch`),
  KEY `repository` (`repository`),
  CONSTRAINT `branch_off_ibfk_1` FOREIGN KEY (`new_branch`) REFERENCES `branch` (`name`),
  CONSTRAINT `branch_off_ibfk_2` FOREIGN KEY (`old_branch`) REFERENCES `branch` (`name`),
  CONSTRAINT `branch_off_ibfk_3` FOREIGN KEY (`repository`) REFERENCES `repository` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `branch_off`
--

LOCK TABLES `branch_off` WRITE;
/*!40000 ALTER TABLE `branch_off` DISABLE KEYS */;
/*!40000 ALTER TABLE `branch_off` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collaboration`
--

DROP TABLE IF EXISTS `collaboration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `collaboration` (
  `programmer` varchar(32) NOT NULL,
  `repository` varchar(32) NOT NULL,
  PRIMARY KEY (`programmer`,`repository`),
  KEY `repository` (`repository`),
  CONSTRAINT `collaboration_ibfk_1` FOREIGN KEY (`programmer`) REFERENCES `programmer` (`username`),
  CONSTRAINT `collaboration_ibfk_2` FOREIGN KEY (`repository`) REFERENCES `repository` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collaboration`
--

LOCK TABLES `collaboration` WRITE;
/*!40000 ALTER TABLE `collaboration` DISABLE KEYS */;
/*!40000 ALTER TABLE `collaboration` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `commit`
--

DROP TABLE IF EXISTS `commit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `commit` (
  `id` int NOT NULL AUTO_INCREMENT,
  `branch` varchar(32) DEFAULT NULL,
  `repository` varchar(32) DEFAULT NULL,
  `message` varchar(128) DEFAULT NULL,
  `time` time DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `branch` (`branch`),
  KEY `repository` (`repository`),
  CONSTRAINT `commit_ibfk_1` FOREIGN KEY (`branch`) REFERENCES `branch` (`name`),
  CONSTRAINT `commit_ibfk_2` FOREIGN KEY (`repository`) REFERENCES `repository` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `commit`
--

LOCK TABLES `commit` WRITE;
/*!40000 ALTER TABLE `commit` DISABLE KEYS */;
/*!40000 ALTER TABLE `commit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `file`
--

DROP TABLE IF EXISTS `file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `file` (
  `name` varchar(32) NOT NULL,
  `commit` int NOT NULL,
  `language` varchar(32) DEFAULT NULL,
  `text` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`name`,`commit`),
  KEY `commit` (`commit`),
  CONSTRAINT `file_ibfk_1` FOREIGN KEY (`commit`) REFERENCES `commit` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `file`
--

LOCK TABLES `file` WRITE;
/*!40000 ALTER TABLE `file` DISABLE KEYS */;
/*!40000 ALTER TABLE `file` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `programmer`
--

DROP TABLE IF EXISTS `programmer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `programmer` (
  `username` varchar(32) NOT NULL,
  `password` varchar(32) DEFAULT NULL,
  `isManager` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `programmer`
--

LOCK TABLES `programmer` WRITE;
/*!40000 ALTER TABLE `programmer` DISABLE KEYS */;
/*!40000 ALTER TABLE `programmer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `repository`
--

DROP TABLE IF EXISTS `repository`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `repository` (
  `name` varchar(32) NOT NULL,
  `dateCreated` date DEFAULT NULL,
  `lastMergeDate` date DEFAULT NULL,
  `creator` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `creator` (`creator`),
  CONSTRAINT `repository_ibfk_1` FOREIGN KEY (`creator`) REFERENCES `programmer` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `repository`
--

LOCK TABLES `repository` WRITE;
/*!40000 ALTER TABLE `repository` DISABLE KEYS */;
/*!40000 ALTER TABLE `repository` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-04-09 12:05:57
