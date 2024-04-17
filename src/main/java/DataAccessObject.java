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

    public void createTodo(String msg, String repoName) throws SQLException {
        CallableStatement stmt = connection.prepareCall("{CALL create_todo(?, ?)}");
        stmt.setString(1, msg);
        stmt.setString(2, repoName);
        stmt.executeQuery();
    }




    // READ


    public ResultSet getFilesForBranch(String branchName) throws SQLException {
        CallableStatement stmt = connection.prepareCall("{CALL get_files_in_branch(?)}");
        stmt.setString(1, branchName);
        return stmt.executeQuery();
    }

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


    public boolean validateLogin(String username, String password) throws SQLException {
        CallableStatement stmt = connection.prepareCall("{CALL validate_login(?, ?, ?)}");
        stmt.setString(1, username);
        stmt.setString(2, password);
        stmt.registerOutParameter(3, Types.TINYINT);
        stmt.execute();
        boolean result = stmt.getBoolean(3);
        System.out.println(result);
        return result;
    }


    // UPDATE

    public void renameRepository(String oldRepoName, String newRepoName) throws SQLException {
        CallableStatement stmt = connection.prepareCall("{CALL rename_repository(?, ?)}");
        stmt.setString(1, oldRepoName);
        stmt.setString(2, newRepoName);
        stmt.executeQuery();
    }

    public void renameBranch(String oldBranchName, String newBranchName, String repoName) throws SQLException {
        CallableStatement stmt = connection.prepareCall("{CALL rename_branch(?, ?, ?)}");
        stmt.setString(1, oldBranchName);
        stmt.setString(2, newBranchName);
        stmt.setString(3, repoName);
        stmt.executeQuery();
    }

    public void renameFile(String oldFileName, String newFileName, String branchName, String repoName) throws SQLException {
        CallableStatement stmt = connection.prepareCall("{CALL rename_file(?, ?, ?, ?)}");
        stmt.setString(1, oldFileName);
        stmt.setString(2, newFileName);
        stmt.setString(3, branchName);
        stmt.setString(4, repoName);
        stmt.executeQuery();
    }

    // DELETE

    public void deleteRepository(String repoName) throws SQLException {
        CallableStatement stmt = connection.prepareCall("{CALL delete_repository(?)}");
        stmt.setString(1, repoName);
        stmt.executeQuery();
    }

    public void deleteBranch(String branchName, String repoName) throws SQLException {
        CallableStatement stmt = connection.prepareCall("{CALL delete_branch(?, ?)}");
        stmt.setString(1, branchName);
        stmt.setString(2, repoName);
        stmt.executeQuery();
    }

    public void deleteFile(String fileName, String branchName, String repoName) throws SQLException {
        CallableStatement stmt = connection.prepareCall("{CALL delete_file(?, ?, ?)}");
        stmt.setString(1, fileName);
        stmt.setString(2, branchName);
        stmt.setString(3, repoName);
        stmt.executeQuery();
    }

}
