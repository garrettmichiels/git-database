CREATE DATABASE IF NOT EXISTS git;

use git;

CREATE TABLE programmer(
	username VARCHAR(32) PRIMARY KEY,
	password VARCHAR(32),
    isManager BOOL
);


CREATE TABLE repository(
	name VARCHAR(32) PRIMARY KEY,
    dateCreated DATE,
    lastMergeDate DATE,
    creator VARCHAR(32),
    FOREIGN KEY (creator) REFERENCES programmer(username)
);

CREATE TABLE collaboration (
	programmer VARCHAR(32),
    repository VARCHAR(32),
    PRIMARY KEY (programmer, repository),
    FOREIGN KEY (programmer) REFERENCES programmer(username),
    FOREIGN KEY (repository) REFERENCES repository(name)
);

CREATE TABLE branch(
	name VARCHAR(32),
    repository VARCHAR(32),
    lastPushDate DATE,
    isMain BOOL,
    PRIMARY KEY (name, repository),
    FOREIGN KEY (repository) REFERENCES repository(name)
);

CREATE TABLE branch_off(
	new_branch VARCHAR(32),
    old_branch VARCHAR(32),
    repository VARCHAR(32),
    PRIMARY KEY (new_branch, old_branch, repository),
    FOREIGN KEY (new_branch) REFERENCES branch(name),
    FOREIGN KEY (old_branch) REFERENCES branch(name),
    FOREIGN KEY (repository) REFERENCES repository(name)
);
    

CREATE TABLE commit(
	id INT PRIMARY KEY AUTO_INCREMENT,
    branch VARCHAR(32),
    repository VARCHAR(32),
    message VARCHAR(128),
    time TIME,
    FOREIGN KEY (branch) REFERENCES branch(name),
    FOREIGN KEY (repository) REFERENCES repository(name)
);

CREATE TABLE file(
	name VARCHAR(32),
    commit INT,
    language VARCHAR(32),
    text VARCHAR(256),
    PRIMARY KEY (name, commit),
    FOREIGN KEY (commit) REFERENCES commit(id)
);

