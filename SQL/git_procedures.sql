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