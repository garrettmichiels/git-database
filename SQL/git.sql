CREATE DATABASE  IF NOT EXISTS `git` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `git`;
-- MySQL dump 10.13  Distrib 8.0.36, for macos14 (arm64)
--
-- Host: localhost    Database: git
-- ------------------------------------------------------
-- Server version	8.3.0

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
  `branchedoff` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`name`,`repository`),
  KEY `branchedoff_idx` (`branchedoff`),
  KEY `branch_ibfk_1` (`repository`),
  CONSTRAINT `branch_ibfk_1` FOREIGN KEY (`repository`) REFERENCES `repository` (`name`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `branch_ibfk_2` FOREIGN KEY (`branchedoff`) REFERENCES `branch` (`name`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `branch`
--

LOCK TABLES `branch` WRITE;
/*!40000 ALTER TABLE `branch` DISABLE KEYS */;
INSERT INTO `branch` VALUES ('feature-branch','Database Repo',NULL,0,'Main'),('Main','Database Repo',NULL,1,NULL),('Main','Hello Pim',NULL,1,NULL),('Main','Mungus',NULL,1,NULL),('Main','newRepoName',NULL,1,NULL),('Main','Repo5',NULL,1,NULL),('Main','Test Repo',NULL,1,NULL),('Main','The Hello Project',NULL,1,NULL),('testingbranch','testingrepo',NULL,1,NULL);
/*!40000 ALTER TABLE `branch` ENABLE KEYS */;
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
  KEY `collaboration_ibfk_2` (`repository`),
  CONSTRAINT `collaboration_ibfk_1` FOREIGN KEY (`programmer`) REFERENCES `programmer` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `collaboration_ibfk_2` FOREIGN KEY (`repository`) REFERENCES `repository` (`name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collaboration`
--

LOCK TABLES `collaboration` WRITE;
/*!40000 ALTER TABLE `collaboration` DISABLE KEYS */;
INSERT INTO `collaboration` VALUES ('test','Database Repo'),('test','Hello Jimmy Fallon'),('MrFrog','Hello Pim'),('test','Hello Pim'),('Jawn','Mungus'),('test','Mungus'),('test','newRepoName'),('test','repo2'),('test','Repo5'),('test','Test Repo'),('test','testingrepo'),('MrFrog','The Hello Project'),('test','The Return Of MrFrog');
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
  KEY `commit_ibfk_1` (`branch`),
  KEY `commit_ibfk_2` (`repository`),
  CONSTRAINT `commit_ibfk_1` FOREIGN KEY (`branch`) REFERENCES `branch` (`name`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `commit_ibfk_2` FOREIGN KEY (`repository`) REFERENCES `repository` (`name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `commit`
--

LOCK TABLES `commit` WRITE;
/*!40000 ALTER TABLE `commit` DISABLE KEYS */;
INSERT INTO `commit` VALUES (19,'testingbranch','testingrepo','edit','00:00:00'),(20,'feature-branch','Database Repo','message','13:59:22');
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
  KEY `file_ibfk_1` (`commit`),
  CONSTRAINT `file_ibfk_1` FOREIGN KEY (`commit`) REFERENCES `commit` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `file`
--

LOCK TABLES `file` WRITE;
/*!40000 ALTER TABLE `file` DISABLE KEYS */;
INSERT INTO `file` VALUES ('aFile',19,'fileLanguage','fileText add some text change\n\nadd more details'),('testfile',20,'java','fileText');
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
INSERT INTO `programmer` VALUES ('Charlie','uhh',0),('Jawn','delco',0),('MrBoss','hi',1),('MrFrog','hello',1),('Pim','smile',0),('rcurcio','pword',0),('Shrimpi','Shrimpina',0),('Shrimpina','Shrimpi',0),('test','test',1);
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
  KEY `repository_ibfk_1` (`creator`),
  CONSTRAINT `repository_ibfk_1` FOREIGN KEY (`creator`) REFERENCES `programmer` (`username`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `repository`
--

LOCK TABLES `repository` WRITE;
/*!40000 ALTER TABLE `repository` DISABLE KEYS */;
INSERT INTO `repository` VALUES ('Database Repo','2024-04-16',NULL,'test'),('Hello Jimmy Fallon','2024-04-10','2024-04-10','MrFrog'),('Hello Pim','2024-04-10','2024-04-10','MrFrog'),('Mungus','2024-04-10','2024-04-10','Jawn'),('newRepoName','2024-04-10','2024-04-10','test'),('repo2','2024-04-10','2024-04-10','test'),('Repo5','2024-04-17','2024-04-10','test'),('Test Repo','2024-04-10','2024-04-10','test'),('testingrepo','2024-04-17',NULL,'test'),('The Hello Project','2024-04-10',NULL,'MrFrog'),('The Return Of MrFrog','2024-04-10',NULL,'MrFrog');
/*!40000 ALTER TABLE `repository` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `todo_item`
--

DROP TABLE IF EXISTS `todo_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `todo_item` (
  `id` int NOT NULL AUTO_INCREMENT,
  `message` text,
  `repository` varchar(32) DEFAULT NULL,
  `completed` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `repository` (`repository`),
  CONSTRAINT `todo_item_ibfk_1` FOREIGN KEY (`repository`) REFERENCES `repository` (`name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `todo_item`
--

LOCK TABLES `todo_item` WRITE;
/*!40000 ALTER TABLE `todo_item` DISABLE KEYS */;
INSERT INTO `todo_item` VALUES (2,'Add scripts for next season','The Hello Project',0),(3,'Add scripts for next season','The Return of MrFrog',0),(6,'new todo','newRepoName',0),(9,'something somewhere','repo2',0);
/*!40000 ALTER TABLE `todo_item` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-04-17 14:24:50
