import java.io.IOException;
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
    int BACK_MENU = 2;
    int QUIT = 3;
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

    public void printMenu(List<String> lines) {
        for (String s: lines) {
            System.out.println(s);
        }
    }

    public List<String> getListFromResultSet(ResultSet rs) throws SQLException {
        List<String> list = new ArrayList<>();
        int counter = 1;
        while (rs.next()) {
            String currentObject = rs.getString(1);
            list.add(currentObject);
            System.out.printf("%d: %s \n", counter, currentObject);
        }
        return list;
    }

    public int getRepositorySelection() {
        while (true) {
            ArrayList<String> repos = new ArrayList<String>();
            try {
                ResultSet rs = dao.getRepositoriesForUser(serviceUsername);
                printMenu(Arrays.asList("create: create new repository","back: sign out as programmer","quit: quit Program","---------------", "Repositories:"));    
                getListFromResultSet(rs);
            }
            catch (SQLException e) {
                System.err.println("Error getting repositories: " + e.getMessage());
                System.exit(1);
            }

            // Prompt the user to select a repository
            System.out.print("Select a repository: ");
            String repositorySelection = scanner.next();
            switch(repositorySelection) {
                case "create":
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
                    break;
                case "back":
                    return BACK_MENU;
                case "quit":
                    return QUIT;
                default:
                    currentRepository = repos.get(Integer.valueOf(repositorySelection) - 1);
                    int branch_return = getBranchSelection();
                    if (branch_return == QUIT) {
                        return QUIT;
                    }
                    break;
            }
        }
    }

    public int getBranchSelection() {
        while(true) {
            System.out.println("You're in repository " + currentRepository);
            ArrayList<String> branches = new ArrayList<String>();
            try {
                ResultSet rs = dao.getBranchesForRepo(currentRepository);
                printMenu(Arrays.asList("create: create new branch", "rename: rename this repository", "delete: delete this repository", "todo: add a todo item to this repository", "back: back to repository selection","quit: quit Program","---------------", "Branches:"));              
                getListFromResultSet(rs);
            }
            catch (SQLException e) {
                System.err.println("Error getting branches: " + e.getMessage());
                System.exit(1);
            }
            // Prompt the user to select a Branch
            System.out.print("Select a branch: ");
            String branchSelection = scanner.next();
            switch(branchSelection) {
                case "create":
                    System.out.print("Enter the name of the new branch: ");
                    String newBranchName = scanner.next();
                    try {
                        dao.createBranch(newBranchName, currentRepository, false, currentBranch);
                        //currentBranch = newBranchName;
                    }
                    catch (SQLException e) {
                        System.err.println("Error creating branch: " + e.getMessage());
                        System.exit(1);
                    }
                    break;
                case "rename":
                    System.out.println("Enter the new name for this repository: ");
                    String newRepoName = scanner.next();
                    try {
                        dao.renameRepository(currentRepository, newRepoName);
                        currentRepository = newRepoName; 
                    }
                    catch (SQLException e) {
                        System.err.println("Error renaming repository: " + e.getMessage());
                        System.exit(1);
                    }

                case "delete":
                    try {
                        dao.deleteRepository(currentRepository);
                    }
                    catch (SQLException e) {
                        System.err.println("Error deleting repository: " + e.getMessage());
                        System.exit(1);
                    }
                    return BACK_MENU;
                case "todo":
                    System.out.println("Enter a message for the todo item: ");
                    String msg = scanner.nextLine();
                    try {
                        dao.createTodo(msg, currentRepository);
                    }
                    catch(SQLException e) {
                        System.err.println("Error creating todo: " + e.getMessage());
                        System.exit(1);
                    }
                case "back":
                    return BACK_MENU;
                case "quit":
                    return QUIT;
                default:
                    currentRepository = branches.get(Integer.valueOf(branchSelection) - 1);
                    int file_return = getFileSelection();
                    if (file_return == QUIT) {
                        return QUIT;
                    }
                    break;
            }
        }
    }

    public int getFileSelection() {
        while(true) {
            System.out.println("You're in branch: " + currentBranch);
            ArrayList<String> files = new ArrayList<String>();
            try {
                ResultSet rs = dao.getFilesForBranch(currentBranch);
                printMenu(Arrays.asList("create: create new file", "rename: rename this branch", "delete: delete this branch", "back: back to branches","quit: quit Program","---------------", "Files:"));    
                getListFromResultSet(rs);
            }
            catch (SQLException e) {
                System.err.println("Error getting files: " + e.getMessage());
                System.exit(1);
            }
            System.out.print("Select a file: ");
            String fileSelection = scanner.next();
            switch(fileSelection) {
                case "create":
                    System.out.print("Enter the name of the new file: ");
                    String newFileName = scanner.next();
                    try {
                        dao.createRepository(newFileName, serviceUsername);
                        currentFile = newFileName;
                    }
                    catch (SQLException e) {
                        System.err.println("Error creating file: " + e.getMessage());
                        System.exit(1);
                    }
                    break;
                case "rename":
                    System.out.println("Enter the new name for this branch: ");
                    String newBranchName = scanner.next();
                    try {
                        dao.renameBranch(currentBranch, newBranchName, currentRepository);
                        currentBranch = newBranchName; 
                    }
                    catch (SQLException e) {
                        System.err.println("Error renaming branch: " + e.getMessage());
                        System.exit(1);
                    }
                case "delete":
                    try {
                        dao.deleteBranch(currentBranch, currentRepository);
                    }
                    catch (SQLException e) {
                        System.err.println("Error deleting branch: " + e.getMessage());
                        System.exit(1);
                    }
                    return BACK_MENU;
                case "back":
                    return BACK_MENU;
                case "quit":
                    return QUIT;
                default:
                    currentRepository = files.get(Integer.valueOf(fileSelection) - 1);
                    // TODO edit file
                    break;
            }
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
        boolean logging_in = true;
        while (logging_in) {
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
                int repo_return = getRepositorySelection();
                if (repo_return == QUIT) {
                    isProgramRunning = false;
                    logging_in = false;
                }
                if (repo_return == BACK_MENU) {
                    isProgramRunning = false;
                }
            }
        }
        try {
            connection.close();
            scanner.close();
        }
        catch(Exception e) {
            System.err.println(e.getMessage());
        }
    }

public static void main(String[] args) {
    System.out.println("Hello world!");
    String editor = "notepad"; // For Windows, change this to your preferred text editor
    String osName = System.getProperty("os.name").toLowerCase();
    if (osName.contains("mac")) {

        editor = "TextEdit";
    }
    String fileToEdit = "example.txt"; // Change this to the file you want to open

            // Start the process
    ProcessBuilder processBuilder = new ProcessBuilder(editor, fileToEdit);
    try {
    processBuilder.start();
    }
    catch(IOException e) {
        System.out.println(e.getMessage());
    }
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
}