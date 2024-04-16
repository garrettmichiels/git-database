use git;

DROP PROCEDURE IF EXISTS create_file;
DELIMITER $$
CREATE PROCEDURE create_file(IN file_text TEXT, file_name VARCHAR(32), commit_id INT, file_language VARCHAR(32))
BEGIN
INSERT INTO file (name, commit, language, text)
VALUES (file_name, commit_id, file_language, file_text);
END; $$

DELIMITER ;


DROP PROCEDURE IF EXISTS create_commit;
DELIMITER $$
CREATE PROCEDURE create_commit(IN branch_name VARCHAR(32), repo_name VARCHAR(32), message VARCHAR(128))
BEGIN
INSERT INTO commit (branch, repository, message, time)
VALUES (branch_name, repo_name, message, CURRENT_TIMESTAMP);
END; $$

DELIMITER ;

DROP PROCEDURE IF EXISTS create_branch;
DELIMITER $$
CREATE PROCEDURE create_branch(IN branch_name VARCHAR(32), repo_name VARCHAR(32), lastPushDate DATE, isMain BOOL, old_branch VARCHAR(32))
BEGIN
INSERT INTO branch (branch, repository, lastPushDate, isMain)
VALUES (branch_name, repo_name, lastPushDate, isMain);

INSERT INTO branch_off (new_branch, old_branch, repository)
VALUES (branch_name, old_branch, repo_name);
END; $$

DROP PROCEDURE IF EXISTS create_repository;
DELIMITER $$
CREATE PROCEDURE create_repository(IN repoName VARCHAR(32), username VARCHAR(32))
BEGIN
INSERT INTO repository (name, creator) VALUES (repoName, username);
END; $$

DROP PROCEDURE IF EXISTS create_programmer;
DELIMITER $$
CREATE PROCEDURE create_programmer(IN username VARCHAR(32), password VARCHAR(32), isManager BOOL)
BEGIN
INSERT INTO programmer (username, password, isManager)
VALUES (username, password, isManager);
END; $$


DROP PROCEDURE IF EXISTS delete_branch;
DELIMITER $$
CREATE PROCEDURE delete_branch(
    IN branch_name VARCHAR(32),
    IN repository_name VARCHAR(32)
)
BEGIN
  DELETE FROM branch
  WHERE name = branch_name AND repository = repository_name;
END; $$

DELIMITER ;

DROP PROCEDURE IF EXISTS delete_repository;
DELIMITER $$
CREATE PROCEDURE delete_branch(IN repository_name VARCHAR(32))
BEGIN
  DELETE FROM repository WHERE name = repository_name;
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
SELECT COUNT(repository) FROM collaboration WHERE programmer = username;
END; $$
DELIMITER ;


-- DROP PROCEDURE IF EXISTS delete_file;
-- DELIMITER $$
-- CREATE PROCEDURE delete_file(
--     IN file_name VARCHAR(32))
-- BEGIN
--   SELECT file
-- END; $$

-- DELIMITER ;




DROP FUNCTION IF EXISTS validate_login;
DELIMITER $$
CREATE FUNCTION validate_login(username VARCHAR(32), password VARCHAR(32))
	RETURNS BOOL DETERMINISTIC
	CONTAINS SQL
    BEGIN

	DECLARE correct_password VARCHAR(32);
    SELECT password FROM programmer WHERE programmer.username = username
    INTO correct_password;
    
    IF correct_password = password THEN
		RETURN TRUE;
	ELSE
		RETURN FALSE;
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