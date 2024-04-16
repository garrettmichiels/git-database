import java.sql.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Properties;
import java.util.Scanner;

import javafx.application.Application;
import javafx.scene.Scene;
import javafx.scene.layout.VBox;
import javafx.scene.control.Button;
import javafx.scene.layout.StackPane;
import javafx.stage.Stage;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.apache.commons.cli.*;


public class Main {
    /** The name of the MySQL account to use */
    private String username;

    /** The password for the MySQL account */
    private String password;

    private final String serverName = "localhost";
    /** The port of the MySQL server (default is 3306) */
    private final int portNumber = 3306;

    /** The name of the database we are testing with */
    private final String dbName = "git";
    private Connection connection = null;
    private DataAccessObject dao = null;
    public Scanner scanner = null;
    private Boolean isProgramRunning = true;


    // Username and password for the inside databse
    private String serviceUsername;
    private String servicePassword;
    private String currentRepository;
    private String currentBranch;
    private String currentFile;



    public void getConnection() throws SQLException {
        Properties connectionProps = new Properties();
        connectionProps.put("user", this.username);
        connectionProps.put("password", this.password);

        System.out.println("Connecting to database...");
        System.out.println("Username: " + this.username);
        System.out.println("Password: " + this.password);

        //If this fails, connection is null and no DB connection exists.
        connection = DriverManager.getConnection("jdbc:mysql://"
                + this.serverName + ":" + this.portNumber
                + "/" + this.dbName
                + "?characterEncoding=UTF-8&useSSL=false", connectionProps);
    }

    public void getUserLogin() {
        //Get internal username and password
        scanner = new Scanner(System.in);
        System.out.print("Enter the username for the internal database: ");
        serviceUsername = scanner.next();
        System.out.print("Enter the password for the internal database: ");
        servicePassword = scanner.next();
    }

    public void getRepositorySelection() {
        ArrayList<String> repos = new ArrayList<String>();
        try {
            ResultSet rs = dao.getRepositoriesForUser(serviceUsername);
            int counter = 4;
            System.out.println("1 Create new repository");
            System.out.println("2: Sign out");
            System.out.println("3: Quit Program");
            System.out.println("---------------");
            System.out.println("Repositories:");
            

            while (rs.next()) {
                String currentRepo = rs.getString(1);
                repos.add(currentRepo);
                System.out.printf("%d: %s \n", counter, currentRepo);
            }
        }
        catch (SQLException e) {
            System.err.println("Error getting repositories: " + e.getMessage());
            System.exit(1);
        }

        // Prompt the user to select a repository
        System.out.print("Select a repository: ");
        int repositorySelection = scanner.nextInt();
        if (repositorySelection == 1) {
            System.out.print("Enter the name of the new repository: ");
            String newRepoName = scanner.next();
            try {
                dao.createRepository(newRepoName, serviceUsername);
                currentRepository = newRepoName;
            }
            catch (SQLException e) {
                System.err.println("Error creating repository: " + e.getMessage());
                System.exit(1);
            }
        }
        else {
            currentRepository = repos.get(repositorySelection - 4);
        }

        getBranchSelection();

    }

    public void getBranchSelection() {
        ArrayList<String> branches = new ArrayList<String>();
            try {
                ResultSet rs = dao.getBranchesForRepo(currentRepository);
                int counter = 4;
                System.out.println("1 Create new branch");
                System.out.println("2: Back To Repositories");
                System.out.println("3: Quit Program");
                System.out.println("---------------");
                System.out.println("Branches:");
                while (rs.next()) {
                    String currentBranch = rs.getString(1);
                    branches.add(currentBranch);
                    System.out.printf("%d: %s \n", counter, currentBranch);
                    counter++;
                }
            }
            catch (SQLException e) {
                System.err.println("Error getting branches: " + e.getMessage());
                System.exit(1);
            }
    }

    public void getFileSelection() {
        ArrayList<String> files = new ArrayList<String>();
        try {
            ResultSet rs = dao.getFilesForBranch(currentBranch);
            int counter = 3;
            System.out.println("1: Create new file");
            System.out.println("2: Back To Branches");
            System.out.println("---------------");
            System.out.println("Files:");
            while (rs.next()) {
                currentFile = rs.getString(1);
                files.add(currentFile);
                System.out.printf("%d: %s \n", counter, currentFile);
                counter++;
            }
            System.out.println();
            System.out.println();
        }
        catch (SQLException e) {
            System.err.println("Error getting files: " + e.getMessage());
            System.exit(1);
        }
    }



    public void run() {
        try {
            this.getConnection();
        }
        catch (SQLException e) {
            System.err.println("Error connecting to the database: " + e.getMessage());
            System.exit(1);
        }

        // Create a new instance of the DataAccessObject
        dao = new DataAccessObject(connection);


        //Get internal username and password
        scanner = new Scanner(System.in);
        System.out.print("Enter the username for the internal database: ");
        serviceUsername = scanner.next();
        System.out.print("Enter the password for the internal database: ");
        servicePassword = scanner.next();
        
        try {
           while (!dao.validateLogin(serviceUsername, servicePassword)) {
                System.out.println("Login failed");
                getUserLogin();
            }
            System.out.println("Login successful!");
        }
        catch (SQLException e) {
            System.err.println("Error validating login: " + e.getMessage());
            System.exit(1);
        }

        // Create a loop to prompt the user for input
        while(isProgramRunning) {
            //At each option provide opportunity to edit, delete, or create object, or go back one, or signout
            getRepositorySelection();
        }

    }

public static void main(String[] args) {
    System.out.println("Hello world!");
    Main app = new Main();

    // Create a new command line parser
    CommandLineParser parser = new DefaultParser();
    Options options = new Options();
    options.addOption("u", "username", true, "The username to use for the database connection");
    options.addOption("p", "password", true, "The password to use for the database connection");

    try {
        CommandLine cmd = parser.parse(options, args);
        app.username = cmd.getOptionValue("u");
        app.password = cmd.getOptionValue("p");

        if (app.username == null || app.password == null) {
            System.err.println("You must provide a username and password to connect to the database");
            System.exit(1);
        }
        
        app.run();

    } catch (ParseException e) {
        System.err.println("Error parsing command line arguments: " + e.getMessage());
        System.exit(1);
    }
    
}

// public static void main(String[] args) {
//     System.out.println("Hello world!");
//     this.getConnection();
//     // Create a new command line parser
//     CommandLineParser parser = new DefaultParser();
//     Options options = new Options();
//     options.addOption("u", "username", true, "The username to use for the database connection");
//     options.addOption("p", "password", true, "The password to use for the database connection");
//     options.addOption("h", "help", false, "Print this message");
//     try {
//         CommandLine cmd = parser.parse(options, args);
//         if (cmd.hasOption("h")) {
//             HelpFormatter formatter = new HelpFormatter();
//             formatter.printHelp("Main", options);
//             System.exit(0);
//         }
//         if (cmd.hasOption("u")) {
//             this.userName = cmd.getOptionValue("u");
//         }
//         if (cmd.hasOption("p")) {
//             this.password = cmd.getOptionValue("p");
//         }
//     } catch (ParseException e) {
//         System.err.println("Error parsing command line arguments: " + e.getMessage());
//         System.exit(1);
//     }
//     Main main = new Main();
//     try {
//         main.getConnection();
//     } catch (SQLException e) {
//         System.err.println("Error connecting to the database: " + e.getMessage());
//         System.exit(1);
//     }
//     main.run();
//     try {
//         main.connection.close();
//     } catch (SQLException e) {
//         System.err.println("Error closing the database connection: " + e.getMessage());
//         System.exit(1);
//     }
//     System.exit(0);
// }
}