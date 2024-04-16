import java.sql.*;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DataAccessObject {
    
    public Connection connection = null;

    public DataAccessObject(Connection connection) {
            this.connection = connection;
    }


    // CREATE

    public void createRepository(String repoName, String username) throws SQLException {
        CallableStatement stmt = connection.prepareCall("{CALL create_repository(?, ?)}");
        stmt.setString(1, repoName);
        stmt.setString(2, username);
        ResultSet rs = stmt.executeQuery();
    }

    public void createBranch(String branchName, String repository, boolean isMain, String branchedOff) throws SQLException {
        CallableStatement stmt = connection.prepareCall("{CALL create_branch(?, ?, ?, ?)}");
        stmt.setString(1, branchName);
        stmt.setString(2, repository);
        stmt.setBoolean(3, isMain);
        stmt.setString(4, branchedOff);
        ResultSet rs = stmt.executeQuery();
    }

    public void createProgrammer(String username, String password, boolean isManager) throws SQLException {
        CallableStatement stmt = connection.prepareCall("{CALL create_programmer(?, ?, ?)}");
        stmt.setString(1, username);
        stmt.setString(2, password);
        stmt.setBoolean(3, isManager);
        ResultSet rs = stmt.executeQuery();
    }

    public int createCommit(String branchName, String repoName, String message) throws SQLException {
        CallableStatement stmt = connection.prepareCall("{CALL create_commit(?, ?, ?)}");
        stmt.setString(1, branchName);
        stmt.setString(2, repoName);
        stmt.setString(3, message);
        ResultSet rs = stmt.executeQuery();
        rs.next();
        return rs.getInt(1);
    }

    public void createFile(String fileName, String commitId, String fileLanguage, String content) throws SQLException {
        CallableStatement stmt = connection.prepareCall("{CALL create_file(?, ?, ?, ?)}");
        stmt.setString(1, fileName);
        stmt.setString(2, commitId);
        stmt.setString(3, fileLanguage);
        stmt.setString(4, content);
        ResultSet rs = stmt.executeQuery();
    }




    // READ


    public ResultSet getBranchesForRepo(String repoName) throws SQLException{
        CallableStatement stmt = connection.prepareCall("{CALL get_branches_in_repo(?)}");
        stmt.setString(1, repoName);
        return stmt.executeQuery();
    }

    public ResultSet getRepositoriesForUser(String username) throws SQLException {
        CallableStatement stmt = connection.prepareCall("{CALL get_repositories_for_programmer(?)}");
        stmt.setString(1, username);
        return stmt.executeQuery();
    }

    public int getRepositoryCountForUser(String username) throws SQLException {
        CallableStatement stmt = connection.prepareCall("{CALL get_repository_count_for_programmer(?)}");
        stmt.setString(1, username);
        ResultSet rs = stmt.executeQuery();
        rs.next();
        return rs.getInt(1);
    }

    // UPDATE



    // DELETE

}
