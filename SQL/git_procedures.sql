use git;

DROP PROCEDURE IF EXISTS create_file;
DELIMITER $$
CREATE PROCEDURE create_file(IN file_text TEXT, file_name VARCHAR(32), commit_id INT, file_language VARCHAR(32))
BEGIN
INSERT INTO file (name, commit, language, text)
VALUES (file_name, commit_id, file_language, file_text);
END; $$

DELIMITER ;


-- DROP PROCEDURE IF EXISTS create_commit;
-- DELIMITER $$
-- CREATE PROCEDURE create_commit(IN branch_name VARCHAR(32), repo_name VARCHAR(32), message VARCHAR(128))
-- BEGIN
-- INSERT INTO commit (branch, repository, message, time)
-- VALUES (branch_name, repo_name, message, CURRENT_TIMESTAMP);
-- RETURN LAST_INSERTED_ID();
-- END; $$

-- DELIMITER ;

DROP PROCEDURE IF EXISTS create_branch;
DELIMITER $$
CREATE PROCEDURE create_branch(IN branch_name VARCHAR(32), repo_name VARCHAR(32), isMain BOOL, branchedoff VARCHAR(32))
BEGIN
INSERT INTO branch (name, repository, isMain, branchedoff)
VALUES (branch_name, repo_name, isMain, branchedoff);

END; $$

DELIMITER ;


DROP PROCEDURE IF EXISTS create_collaboration;
DELIMITER $$
CREATE PROCEDURE create_collaboration(IN username VARCHAR(32), repoName VARCHAR(32))
BEGIN
INSERT INTO collaboration (programmer, repository) VALUES (username, repoName);
END; $$
DELIMITER ;

DROP PROCEDURE IF EXISTS create_repository;
DELIMITER $$
CREATE PROCEDURE create_repository(IN repoName VARCHAR(32), username VARCHAR(32))
BEGIN
INSERT INTO repository (name, creator) VALUES (repoName, username);
END; $$

DELIMITER ;

DELIMITER $$
DROP TRIGGER IF EXISTS insert_branch_trigger;
CREATE TRIGGER insert_branch_trigger AFTER INSERT ON repository
FOR EACH ROW
BEGIN
  INSERT INTO collaboration VALUES (NEW.creator, NEW.name);
  INSERT INTO branch (name, repository, isMain, branchedoff) VALUES ("Main", NEW.name, TRUE, NULL);
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS create_programmer;
DELIMITER $$
CREATE PROCEDURE create_programmer(IN username VARCHAR(32), password VARCHAR(32), isManager BOOL)
BEGIN
INSERT INTO programmer (username, password, isManager)
VALUES (username, password, isManager);
END; $$

DELIMITER ;

DROP PROCEDURE IF EXISTS create_todo;
DELIMITER $$
CREATE PROCEDURE create_todo(IN message TEXT, repository VARCHAR(32), completed BOOL)
BEGIN
INSERT INTO todo_item (message, repository, completed)
VALUES (message, repository, completed);
END; $$

DELIMITER ;

DROP PROCEDURE IF EXISTS delete_branch;
DELIMITER $$
CREATE PROCEDURE delete_branch(IN branch_name VARCHAR(32), IN repository_name VARCHAR(32))
BEGIN
  DELETE FROM branch WHERE name = branch_name AND repository = repository_name;
END; $$

DELIMITER ;

DROP PROCEDURE IF EXISTS delete_repository;
DELIMITER $$
CREATE PROCEDURE delete_repository(IN repository_name VARCHAR(32))
BEGIN
  DELETE FROM repository WHERE name = repository_name;
END; $$

DELIMITER ;


DROP PROCEDURE IF EXISTS delete_todo;
DELIMITER $$
CREATE PROCEDURE delete_todo(IN todoId INT)
BEGIN
  DELETE FROM todo_item WHERE id = todoId;
END; $$

DELIMITER ;


DROP PROCEDURE IF EXISTS delete_programmer;
DELIMITER $$
CREATE PROCEDURE delete_programmer(IN username VARCHAR(32))
BEGIN
  DELETE FROM programmer WHERE username = username;
END; $$
DELIMITER ;

DROP PROCEDURE IF EXISTS delete_commit;
DELIMITER $$
CREATE PROCEDURE delete_commit(IN commit_id INT)
BEGIN
  DELETE FROM commit WHERE id = commit_id;
END; $$
DELIMITER ;

-- Returns the repostiories associated with a programmer
DROP PROCEDURE IF EXISTS get_repositories_for_programmer;
DELIMITER $$
CREATE PROCEDURE get_repositories_for_programmer(IN username VARCHAR(32))
BEGIN
SELECT repository FROM collaboration WHERE programmer = username;
END; $$
DELIMITER ;

-- Returns the number of repostiories associated with a programmer
DROP FUNCTION IF EXISTS get_repository_count_for_programmer;
DELIMITER $$
CREATE FUNCTION get_repository_count_for_programmer(username VARCHAR(32))
   RETURNS INT DETERMINISTIC
   CONTAINS SQL
BEGIN
DECLARE repoCount INT;
SELECT COUNT(repository) INTO repoCount FROM collaboration WHERE programmer = username;
RETURN repoCount;
END; $$
DELIMITER ;


DROP PROCEDURE IF EXISTS delete_file;
DELIMITER $$
CREATE PROCEDURE delete_file(
    IN file_name VARCHAR(32), branch_name VARCHAR(32), repo_name VARCHAR(32))
BEGIN
  DECLARE commit_id INT;
  SELECT commit.id INTO commit_id FROM file JOIN commit ON file.commit = commit.id
  WHERE file.name = file_name AND commit.branch = branch_name AND commit.repository = repo_name;
END; $$

DELIMITER ;


DROP PROCEDURE IF EXISTS validate_login;
DELIMITER $$
CREATE PROCEDURE validate_login(username VARCHAR(32), password VARCHAR(32), OUT returnValue BOOLEAN)
    BEGIN

	DECLARE correct_password VARCHAR(32);
    SELECT password FROM programmer WHERE programmer.username = username
    INTO correct_password;
    
    IF correct_password = password THEN
		SELECT TRUE INTO returnValue;
	ELSE
		SELECT FALSE INTO returnValue;
	END IF;
    END $$

DELIMITER ;


DROP PROCEDURE IF EXISTS get_user_repos;
DELIMITER $$
CREATE PROCEDURE get_user_repos(username VARCHAR(32))
    BEGIN
		SELECT repository FROM collaboration WHERE collaboration.programmer = username;
	END $$

DELIMITER ;

DROP PROCEDURE IF EXISTS get_branches_in_repo;
DELIMITER $$
CREATE PROCEDURE get_branches_in_repo(repo VARCHAR(32))
    BEGIN
		SELECT name FROM branch WHERE branch.repository = repo;
	END $$

DELIMITER ;

DROP PROCEDURE IF EXISTS get_files_in_branch;
DELIMITER $$
CREATE PROCEDURE get_files_in_branch(branch VARCHAR(32))
    BEGIN
		SELECT name FROM file WHERE branch.repository = repo;
	END $$

DELIMITER ;



-- last_inserted_id()