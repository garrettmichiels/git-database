# git-database

This is the final project for Database Design CS3200. This is a simplified version of git where the user interacts with their repositories, branches, and files via the command line. The application is created in Java and uses MySQL for the database. The program starts by asking the user to sign in 


## Building The Project
Run the Schema in your MySQL server. The schema dump file is called git.sql
If the procedures are not populated, run git_procedure.sql

### Design

Our original schema design
![Original schema](/images/originalUML.png)


Our current schema design
![Current schema](/images/currentSchema.png)


Our user interaction diagram
<!-- ![User Flow Diagram](image_url) -->

## Running The Project
To run the program, navigate to the file with the project jar and type the following into the terminal:
Username and password are the passwords for your local MySQL server.
`java -jar project.jar -u <username> -p <password>`

Next you will be prompted to enter a username and password for our git server. To test our program you can use 
any of the usernames and passwords listed in the database under the programmers table.

There are several users including:

Username    |    Password
--------------------------
test        |    test
rcurcio     |    pword
gm          |    pass
db          |    design

# IMPORTANT
If there are permissions issues running the jar file, run:
`chmod 775 project.jar`

### Libraries and Softwares
This project uses a Java JDK version [Insert Version Here]+ and utilizes Swing, java.sql.connection as our JDBC, 

Most of these should be built into Java. They should be built into the JAR file:

```
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Properties;
import java.util.Scanner;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import org.apache.commons.cli.*;

import java.sql.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.awt.*;
import java.awt.BorderLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.JTextField;
```
