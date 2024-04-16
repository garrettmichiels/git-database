package org.example;

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

public class Main {
    /** The name of the MySQL account to use */
    private String userName;

    /** The password for the MySQL account */
    private String password;
    private final String serverName = "localhost";
    /** The port of the MySQL server (default is 3306) */
    private final int portNumber = 3306;

    /** The name of the database we are testing with */
    private final String dbName = "";
    private Connection connection = null;


    public void getConnection() throws SQLException {
        Properties connectionProps = new Properties();
        connectionProps.put("user", this.userName);
        connectionProps.put("password", this.password);

        //If this fails, connection is null and no DB connection exists.
        connection = DriverManager.getConnection("jdbc:mysql://"
                + this.serverName + ":" + this.portNumber
                + "/" + this.dbName
                + "?characterEncoding=UTF-8&useSSL=false", connectionProps);
    }

    public void run() {

    }

    public void getBranches() throws SQLException{

    }
    public ResultSet getRepositoriesForUser(String username) throws SQLException {
//        PreparedStatement ps = connection.prepareStatement("SELECT tid, town, state from township");
//        ResultSet rs = ps.executeQuery();
//        rs.close();
//        ps.close();
        return null;
    }

    public void createRepository(String repoName) throws SQLException {
        CallableStatement stmt = connection.prepareCall("{CALL create_repository(?)}");
        stmt.setString(1, repoName);
        ResultSet rs = stmt.executeQuery();
    }

    public void createBranch(String branchName) {
        
    }

public static void main(String[] args) {
    System.out.println("Hello world!");
}
}