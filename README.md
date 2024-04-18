# Git Database

This is the final project for Database Design CS3200. This is a simplified version of git where the user interacts with their repositories, branches, and files via the command line. The application is created in Java and uses MySQL for the database. The program starts by asking the user to sign in 


## Building The Project
Run the Schema in your MySQL server. The schema dump file is called `git.sql`
If the procedures are not populated, run `git_procedure.sql`

## Running The Project
To run the program, navigate to the file with the project jar and type the following into the terminal:
Username and password are the passwords for your local MySQL server.

`java -jar gitDB.jar -u <username> -p <password>`

Next you will be prompted to enter a username and password for our git server. To test our program you can use 
any of the usernames and passwords listed in the database under the programmers table.

There are several users that will be good for testing the functionality including:

Username    |   Password 
------------|-------------
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
import java.awt.event.*;
import java.awt.BorderLayout;
import javax.swing.*;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;

import java.sql.*;

import java.util.*;
import java.sql.*;
import org.apache.commons.cli.*;
```


## Design
<h3 style="text-align: center">Our original schema design</h3>

![Original schema](/images/originalUML.png)


<h3 style="text-align: center">Our current schema design</h3>

![Current schema](/images/currentSchema.png)


Our user interaction diagram
![User Flow Diagram](/images/userFlowDiagram.jpg)


**Note**: in order to create, rename or delete an object, you must be within that object to do so. For example, in order to delete a repository, you must enter that repository and then type the delete command.