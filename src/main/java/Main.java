import java.sql.*;
import java.util.Properties;
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


    // Username and password for the inside databse
    private String serviceUsername;
    private String servicePassword;
    private String currentRepository;
    private String currentBranch;



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

    public void run() {
        try {
            this.getConnection();
        }
        catch (SQLException e) {
            System.err.println("Error connecting to the database: " + e.getMessage());
            System.exit(1);
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