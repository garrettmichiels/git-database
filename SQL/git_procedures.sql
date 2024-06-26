use git;

-- CREATE ------------------------------------------------------------------

DROP PROCEDURE IF EXISTS create_commit_file;
DELIMITER $$
CREATE PROCEDURE create_commit_file(IN branch_name VARCHAR(32), repo_name VARCHAR(32), message VARCHAR(128), file_name VARCHAR(32), file_language VARCHAR(32), file_text VARCHAR(256))
BEGIN
INSERT INTO commit (branch, repository, message, time)
VALUES (branch_name, repo_name, message, CURRENT_TIMESTAMP);

INSERT INTO file (name, commit, language, text)
VALUES (file_name, LAST_INSERT_ID(), file_language, file_text);
END $$

DELIMITER ;

DROP PROCEDURE IF EXISTS create_branch;
DELIMITER $$
CREATE PROCEDURE create_branch(IN branch_name VARCHAR(32), repo_name VARCHAR(32), isMain BOOL, branchedoff VARCHAR(32))
BEGIN
IF
  branchedoff IS NULL THEN
  SELECT name INTO branchedoff FROM branch WHERE repository = repo_name AND isMain = TRUE;
END IF;
INSERT INTO branch (name, repository, isMain, branchedoff)
VALUES (branch_name, repo_name, isMain, branchedoff);

END $$

DELIMITER ;


DROP PROCEDURE IF EXISTS create_collaboration;
DELIMITER $$
CREATE PROCEDURE create_collaboration(IN username VARCHAR(32), repoName VARCHAR(32))
BEGIN
INSERT INTO collaboration (programmer, repository) VALUES (username, repoName);
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS create_repository;
DELIMITER $$
CREATE PROCEDURE create_repository(IN repoName VARCHAR(32), username VARCHAR(32))
BEGIN
INSERT INTO repository (name, creator, dateCreated) VALUES (repoName, username, CURRENT_DATE);
END $$

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
END $$

DELIMITER ;

DROP PROCEDURE IF EXISTS create_todo;
DELIMITER $$
CREATE PROCEDURE create_todo(IN message TEXT, repository VARCHAR(32))
BEGIN
INSERT INTO todo_item (message, repository, completed)
VALUES (message, repository, FALSE);
END $$

DELIMITER ;

-- READ ------------------------------------------------------------------
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
		SELECT name FROM branch WHERE repository = repo;
	END $$

DELIMITER ;

DROP PROCEDURE IF EXISTS get_file_content;
DELIMITER $$
CREATE PROCEDURE get_file_content(IN file_name VARCHAR(32), branch_name VARCHAR(32), repo_name VARCHAR(32), OUT file_text VARCHAR(256))
    BEGIN
      SELECT text INTO file_text FROM file JOIN commit ON file.commit = commit.id 
      WHERE commit.branch = branch_name AND commit.repository = repo_name AND file.name = file_name;
	END $$

DELIMITER ;

DROP PROCEDURE IF EXISTS get_file_language;
DELIMITER $$
CREATE PROCEDURE get_file_language(IN file_name VARCHAR(32), branch_name VARCHAR(32), repo_name VARCHAR(32), OUT file_language VARCHAR(32))
  BEGIN
    SELECT language INTO file_language FROM file JOIN commit ON file.commit = commit.id 
	  WHERE commit.branch = branch_name AND commit.repository = repo_name AND file.name = file_name;
  END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS get_files_in_branch;
DELIMITER $$
CREATE PROCEDURE get_files_in_branch(branch_name VARCHAR(32), repository_name VARCHAR(32))
    BEGIN
      SELECT name, commit FROM file WHERE file.commit IN 
      (SELECT id FROM commit WHERE commit.branch = branch_name AND commit.repository = repository_name);
	END $$

DELIMITER ;


-- Returns the repostiories associated with a programmer
DROP PROCEDURE IF EXISTS get_repositories_for_programmer;
DELIMITER $$
CREATE PROCEDURE get_repositories_for_programmer(IN user_name VARCHAR(32))
	BEGIN
		DECLARE is_manager BOOL;
        SELECT isManager into is_manager FROM programmer WHERE username = user_name;
        IF is_Manager THEN
		SELECT name FROM repository;
        ELSE
        SELECT repository FROM collaboration WHERE programmer = user_name;
        END IF;
	END $$

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
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS get_todos_for_repository;
DELIMITER $$
CREATE PROCEDURE get_todos_for_repository(repo_name VARCHAR(32))
BEGIN
SELECT id, message FROM todo_item WHERE repository = repo_name AND completed = FALSE;
END $$

DELIMITER ;

-- UPDATES ------------------------------------------------------------------

DROP PROCEDURE IF EXISTS rename_repository;
DELIMITER $$
CREATE PROCEDURE rename_repository(IN oldRepoName VARCHAR(32), newRepoName VARCHAR(32))
BEGIN
UPDATE repository SET name = newRepoName WHERE name = oldRepoName;
END $$

DELIMITER ;

DROP PROCEDURE IF EXISTS update_todo;
DELIMITER $$
CREATE PROCEDURE update_todo(IN todoId INT, IN message TEXT, IN completed BOOL)
BEGIN
UPDATE todo_item SET message = message, completed = completed WHERE id = todoId;
END $$

DELIMITER ;

DROP PROCEDURE IF EXISTS complete_todo;
DELIMITER $$
CREATE PROCEDURE complete_todo(IN todoId INT)
BEGIN
UPDATE todo_item SET completed = TRUE WHERE id = todoId;
END $$

DELIMITER ;


DROP PROCEDURE IF EXISTS rename_branch;
DELIMITER $$
CREATE PROCEDURE rename_branch(IN old_branch_name VARCHAR(32), new_branch_name VARCHAR(32), repoName VARCHAR(32))
BEGIN
UPDATE branch SET name = new_branch_name WHERE name = old_branch_name AND repository = repoName;
END $$

DELIMITER ;

DROP PROCEDURE IF EXISTS rename_file;
DELIMITER $$
CREATE PROCEDURE rename_file(IN old_file_name VARCHAR(32), new_file_name VARCHAR(32), branch_name VARCHAR(32), repo_name VARCHAR(32))
BEGIN
UPDATE file SET name = new_file_name WHERE name = old_file_name 
AND commit IN (SELECT id FROM commit WHERE branch = branch_name AND repository = repo_name);
END $$

DELIMITER ;

DROP PROCEDURE IF EXISTS update_file_contents;
DELIMITER $$
CREATE PROCEDURE update_file_contents(file_name VARCHAR(32), branch_name VARCHAR(32), repo_name VARCHAR(32), commit_message VARCHAR(32), file_text VARCHAR(256))
BEGIN

-- Get current commit id
DECLARE current_commit_id INT;
SELECT commit.id INTO current_commit_id FROM file JOIN commit ON file.commit = commit.id
  WHERE file.name = file_name AND commit.branch = branch_name AND commit.repository = repo_name;
  
-- Create new commit
INSERT INTO commit (branch, repository, message, time) VALUES (branch_name, repo_name, commit_message, CURRENT_DATE);

-- update file content
UPDATE file SET text = file_text, commit = LAST_INSERT_ID() WHERE commit = current_commit_id;

-- delete commit
DELETE FROM commit WHERE id = current_commit_id;

END $$

DELIMITER ;



-- DELETE ------------------------------------------------------------------

DROP PROCEDURE IF EXISTS delete_branch;
DELIMITER $$
CREATE PROCEDURE delete_branch(IN branch_name VARCHAR(32), IN repository_name VARCHAR(32))
BEGIN
  DECLARE isMainBranch BOOL;
  SELECT isMain INTO isMainBranch FROM branch WHERE name = branch_name AND repository = repository_name;
  IF
    isMainBranch THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Cannot delete main branch';
  ELSE
    DELETE FROM branch WHERE name = branch_name AND repository = repository_name;
  END IF;

  DELETE FROM branch WHERE name = branch_name AND repository = repository_name;
END $$

DELIMITER ;


DROP PROCEDURE IF EXISTS delete_repository;
DELIMITER $$
CREATE PROCEDURE delete_repository(IN repository_name VARCHAR(32))
BEGIN
  DELETE FROM repository WHERE name = repository_name;
END $$

DELIMITER ;


DROP PROCEDURE IF EXISTS delete_todo;
DELIMITER $$
CREATE PROCEDURE delete_todo(IN todoId INT)
BEGIN
  DELETE FROM todo_item WHERE id = todoId;
END $$

DELIMITER ;


DROP PROCEDURE IF EXISTS delete_programmer;
DELIMITER $$
CREATE PROCEDURE delete_programmer(IN username VARCHAR(32))
BEGIN
  DELETE FROM programmer WHERE username = username;
END $$

DELIMITER ;


DROP PROCEDURE IF EXISTS delete_commit;
DELIMITER $$
CREATE PROCEDURE delete_commit(IN commit_id INT)
BEGIN
  DELETE FROM commit WHERE id = commit_id;
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS delete_file;
DELIMITER $$
CREATE PROCEDURE delete_file(
    IN file_name VARCHAR(32), branch_name VARCHAR(32), repo_name VARCHAR(32))
BEGIN
  DECLARE commit_id INT;
  SELECT commit.id INTO commit_id FROM file JOIN commit ON file.commit = commit.id
  WHERE file.name = file_name AND commit.branch = branch_name AND commit.repository = repo_name;
  
  DELETE FROM file WHERE name = file_name AND commit = commit_id;
  
  DELETE FROM commit WHERE id = commit_id;
END $$

DELIMITER ;


DROP PROCEDURE IF EXISTS delete_todo;
DELIMITER $$
CREATE PROCEDURE delete_todo(todo_id INT)
BEGIN
	DELETE FROM todo_item WHERE id = todo_id;
END $$

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
