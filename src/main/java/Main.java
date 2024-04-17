import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Properties;
import java.util.Scanner;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.apache.commons.cli.*;

public class Main { //extends JFrame implements ActionListener {
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


    // Username and password for the inside database
    private String serviceUsername;
    private String servicePassword;

    // Current repository, branch, and file of the user
    private String currentRepository;
    private String currentBranch;
    private String currentFile;




    public List<String> getListFromResultSet(ResultSet rs) throws SQLException {
        List<String> list = new ArrayList<>();
        int counter = 1;
        while (rs.next()) {
            String currentObject = rs.getString(1);
            list.add(currentObject);
            System.out.printf("%d: %s \n", counter, currentObject);
            counter++;
        }
        return list;
    }

    public int getRepositorySelection() {
        while (true) {
            List<String> repos = new ArrayList<>();
            try {
                ResultSet rs = dao.getRepositoriesForUser(serviceUsername);
                printMenu(Arrays.asList("create: create new repository","back: sign out as programmer","quit: quit Program","---------------", "Repositories:"));    
                repos = getListFromResultSet(rs);
            }
            catch (SQLException e) {
                System.err.println("Error getting repositories: " + e.getMessage());
                System.exit(1);
            }

            // Prompt the user to select a repository
            System.out.print("Select a repository or use a command: ");
            String repositorySelection = scanner.nextLine();
            switch(repositorySelection) {
                case "create":
                    System.out.print("Enter the name of the new repository: ");
                    String newRepoName = scanner.nextLine();
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
                    if (!validateInput(repositorySelection, 1, repos.size())) {
                        System.out.println("Invalid input. Please try again.");
                        continue;
                    }
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
            List<String> branches = new ArrayList<>();
            try {
                ResultSet rs = dao.getBranchesForRepo(currentRepository);
                printMenu(Arrays.asList("create: create new branch", "rename: rename this repository", "delete: delete this repository", "todo: view todo items for this repository", "back: back to repository selection","quit: quit Program","---------------", "Branches:"));              
                branches = getListFromResultSet(rs);
            }
            catch (SQLException e) {
                System.err.println("Error getting branches: " + e.getMessage());
                System.exit(1);
            }
            // Prompt the user to select a Branch
            System.out.print(currentRepository + " | Select a branch or use a command: ");
            String branchSelection = scanner.nextLine();
            switch(branchSelection) {
                case "create":
                    System.out.print("Enter the name of the new branch: ");
                    String newBranchName = scanner.nextLine();

                    try {
                        dao.createBranch(newBranchName, currentRepository, false, currentBranch);
                        //currentBranch = newBranchName; TODO check back on this
                    }
                    catch (SQLException e) {
                        System.err.println("Error creating branch: " + e.getMessage());
                        System.exit(1);
                    }
                    break;
                case "rename":
                    System.out.println("Enter the new name for this repository: ");
                    String newRepoName = scanner.nextLine();
                    try {
                        dao.renameRepository(currentRepository, newRepoName);
                        currentRepository = newRepoName; 
                    }
                    catch (SQLException e) {
                        System.err.println("Error renaming repository: " + e.getMessage());
                        System.exit(1);
                    }
                    break;
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
                    int todo_return = useTodos();
                    if (todo_return == QUIT) {
                        return QUIT;
                    }
                    break;
                case "back":
                    return BACK_MENU;
                case "quit":
                    return QUIT;
                default:
                    if(!validateInput(branchSelection, 1, branches.size())) {
                        System.out.println("Invalid input. Please try again.");
                        continue;
                    }
                    currentBranch = branches.get(Integer.valueOf(branchSelection) - 1);
                    int file_return = getFileSelection();
                    if (file_return == QUIT) {
                        return QUIT;
                    }
                    break;
            }
        }
    }

    public void showTodoFromResultSet(ResultSet rs) throws SQLException {
        while (rs.next()) {
            int id = rs.getInt(1);
            String msg = rs.getString(2);
            System.out.printf("%d: %s \n", id, msg);
        }
    }

    public int useTodos() {
        while(true) {
            System.out.println("You are looking at todo items in repository: "+currentRepository);
            try {
                ResultSet rs = dao.getTodosForRepo(currentRepository);
                printMenu(Arrays.asList("complete: mark todo as completed", "create: create new todo", "back: back to repository selection","quit: quit Program","---------------", "Todo items:"));              
                showTodoFromResultSet(rs);
            }
            catch (SQLException e) {
                System.err.println("Error getting branches: " + e.getMessage());
                System.exit(1);
            }
            
            System.out.print(currentRepository + " | Enter one of the above commands: ");
            String todoSelection = scanner.nextLine();
            switch(todoSelection) {
                case "complete":
                    System.out.print("Enter the number of the todo to mark as completed: ");

                    try {
                        int id = Integer.valueOf(scanner.nextLine());
                        dao.completeTodo(id);
                    }
                    catch (NumberFormatException e) {
                        System.out.println("Sorry that wasn't a valid integer");
                        continue;
                    }
                    catch (SQLException e) {
                        System.err.println("Error completing todo: " + e.getMessage());
                        System.exit(1);
                    }
                    break;
                case "create":
                    System.out.println("Enter a message for the todo item: ");
                    String msg = scanner.nextLine();
                    try {
                        dao.createTodo(msg, currentRepository);
                    }
                    catch(SQLException e) {
                        System.err.println("Error creating todo: " + e.getMessage());
                        System.exit(1);
                    }
                    break;
                case "back":
                    return BACK_MENU;
                case "quit":
                    return QUIT;
                default:
                    System.out.println("Invalid input. Please try again.");
                    continue;
            }
        }
    }

    public int getFileSelection() {
        while(true) {
            System.out.println("You're in branch: " + currentBranch);
            List<String> files =  new ArrayList<>();
            try {
                ResultSet rs = dao.getFilesForBranch(currentBranch, currentRepository);
                printMenu(Arrays.asList("create: create new file", "rename: rename this branch", "delete: delete this branch", "back: back to branches","quit: quit Program","---------------", "Files:"));    
                files = getListFromResultSet(rs);
            }
            catch (SQLException e) {
                System.err.println("Error getting files: " + e.getMessage());
                System.exit(1);
            }
            System.out.print(currentRepository + "-" + currentBranch + " | Select a file or use a command: ");
            String fileSelection = scanner.nextLine();
            switch(fileSelection) {
                case "create":
                    System.out.println("Enter the name of the new file: ");
                    String newFileName = scanner.nextLine();
                    System.out.println("Enter the programming language used in the file: ");
                    String language = scanner.nextLine();
                    try {
                        dao.createFile(currentBranch, currentRepository, newFileName, "message", language, "");
                        currentFile = newFileName;
                    }
                    catch (SQLException e) {
                        System.err.println("Error creating file: " + e.getMessage());
                        System.exit(1);
                    }
                    break;
                case "rename":
                    System.out.println("Enter the new name for this branch: ");
                    String newBranchName = scanner.nextLine();
                    try {
                        dao.renameBranch(currentBranch, newBranchName, currentRepository);
                        currentBranch = newBranchName; 
                    }
                    catch (SQLException e) {
                        System.err.println("Error renaming branch: " + e.getMessage());
                        System.exit(1);
                    }
                    break;
                case "delete":
                    try {
                        dao.deleteBranch(currentBranch, currentRepository);
                        currentBranch = "";
                    }
                    catch (SQLException e) {
                        if ("45000".equals(e.getSQLState())) {
                            System.out.println("Cannot delete the main branch");
                        }
                        else {
                            System.err.println("Error deleting branch: " + e.getMessage());
                            System.exit(1);
                        }
                    }
                    return BACK_MENU;
                case "back":
                    return BACK_MENU;
                case "quit":
                    return QUIT;
                default:
                    if(!validateInput(fileSelection, 1, files.size())) {
                        System.out.println("Invalid input. Please try again.");
                        continue;
                    }
                    currentFile = files.get(Integer.valueOf(fileSelection) - 1);
                    // TODO edit file
                    int menu_option = selectedFileMenu();
                    if (menu_option == QUIT) {
                        return QUIT;
                    }
                    break;
            }
        }
    }

    public int selectedFileMenu() {
        while(true) {
            printMenu(Arrays.asList("edit: edit/view this file", "rename: rename this file", "delete: delete this file", "back: back to files","quit: quit Program","---------------"));    
            System.out.print(currentRepository + "-" + currentBranch + "-" + currentFile + " | Select a command: ");
            String fileSelection = scanner.nextLine();
            switch(fileSelection) {
                case "edit":
                    String originalFileContents = "";
                    String language = "";
                    try {
                        originalFileContents = dao.getFileContents(currentFile, currentBranch, currentRepository);
                        language = dao.getFileLanguage(currentFile, currentBranch, currentRepository);
                    }
                    catch (SQLException e) {
                        System.err.println("Error getting file contents: " + e.getMessage());
                        System.exit(1);
                    }
                    TextEditor fileEditor = new TextEditor();
                    fileEditor.setTitle(currentFile);
                    fileEditor.setText(originalFileContents);
                    fileEditor.setLanguageFile(language, currentFile);
                    fileEditor.setVisible(true);
                    fileEditor.toFront();
                    while (!fileEditor.isSaved() ) {
                        // Wait for the user to save the file
                    }
                    String fileContents = fileEditor.getText();
                    fileEditor.dispose();

                    System.out.println("Enter a commit message: ");
                    String commitMessage = scanner.nextLine();
                    try {
                        dao.editFile(currentFile, fileContents, commitMessage, currentBranch, currentRepository);
                    }
                    catch (SQLException e) {
                        System.err.println("Error editing file: " + e.getMessage());
                        System.exit(1);
                    }
                    break;
                case "rename":
                    System.out.println("Enter the new name for this file: ");
                    String newFileName = scanner.nextLine();
                    try {
                        dao.renameFile(currentFile, newFileName, currentBranch, currentRepository);
                        currentFile = newFileName;
                    }
                    catch (SQLException e) {
                        System.err.println("Error renaming file: " + e.getMessage());
                        System.exit(1);
                    }
                    break;
                case "delete":
                    try {
                        dao.deleteFile(currentFile, currentBranch, currentRepository);
                    }
                    catch (SQLException e) {
                        System.err.println("Error deleting file: " + e.getMessage());
                        System.exit(1);
                    }
                    return BACK_MENU;
                case "back":
                    return BACK_MENU;
                case "quit":
                    return QUIT;
                default:
                    System.out.println("Invalid input. Please try again.");
                    continue;
            }
        }
    }

    public void printMenu(List<String> lines) {
        System.out.println();
        for (String s: lines) {
            System.out.println(s);
        }
    }

    public boolean validateInput(String input, int min, int max) {
        try {
            int selection = Integer.parseInt(input);
            if (selection < min || selection > max) {
                return false;
            }
            return true;
        }
        catch (Exception e) {
            return false;
        }
    }

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
        serviceUsername = scanner.nextLine();
        System.out.print("Enter the password for the internal database: ");
        servicePassword = scanner.nextLine();
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
            serviceUsername = scanner.nextLine();
            System.out.print("Enter the password for the internal database: ");
            servicePassword = scanner.nextLine();
            try {
            while (!dao.validateLogin(serviceUsername, servicePassword)) {
                    System.out.println("Login failed");
                    getUserLogin();
                }
                System.out.println("Login successful!");
                isProgramRunning = true;
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
