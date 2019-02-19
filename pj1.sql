CREATE SCHEMA project1;

SET search_path TO project1, public;

-- DROP TABLE project1.accounts CASCADE;
CREATE TABLE project1.accounts (
	id SERIAL NOT NULL,
	username VARCHAR(30) UNIQUE,
	password VARCHAR(30),
	account_created TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT(CURRENT_TIMESTAMP),
	CONSTRAINT pk_accounts_id PRIMARY KEY (id)
);

-- DROP TABLE project1.employees CASCADE;
CREATE TABLE project1.employees (
	id SERIAL NOT NULL,
	first_name VARCHAR(30) NOT NULL,
	last_name VARCHAR(30) NOT NULL,
	title VARCHAR(30) NOT NULL DEFAULT 'Employee',
	account_id INTEGER NOT NULL,
	last_updated TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (CURRENT_TIMESTAMP),
	CONSTRAINT pk_employees_id PRIMARY KEY (id),
	CONSTRAINT fk_accounts_employees_1to1 FOREIGN KEY (account_id) REFERENCES accounts (id),
	CONSTRAINT u_employee_account UNIQUE (id, account_id),
	CONSTRAINT chk_title_manager_or_employee CHECK (title = 'Employee' OR title = 'Manager')
);

-- DROP TABLE project1.requests CASCADE;
CREATE TABLE project1.requests (
	id SERIAL NOT NULL,
	employee_id INTEGER NOT NULL,
	image_link VARCHAR(200) NULL,
	status VARCHAR(20) NOT NULL DEFAULT 'Pending',
	approval VARCHAR(20) NULL DEFAULT NULL,
	manager_id INTEGER NULL,
	request_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (CURRENT_TIMESTAMP),
	approval_date TIMESTAMP WITH TIME ZONE NULL DEFAULT NULL,
	CONSTRAINT pk_requests_id PRIMARY KEY (id),
	CONSTRAINT fk_employees_requests_1toN FOREIGN KEY (employee_id) REFERENCES employees (id),
	CONSTRAINT fk_managers_requests_1toN FOREIGN KEY (manager_id) REFERENCES employees (id),
	CONSTRAINT chk_status_pending_or_resolved CHECK (status = 'Pending' OR status = 'Resolved'),
	CONSTRAINT chk_approval_approved_or_denied CHECK (approval = 'Approved' OR approval = 'Denied'),
	CONSTRAINT chk_employee_not_manager CHECK (employee_id != manager_id)
);

INSERT INTO accounts (username, password) VALUES
	('adking01', 'nerva'),
	('merahman01', 'hadrian'),
	('niescalona01', 'trajan'),
	('jaserrano01', 'marcus');

INSERT INTO employees (first_name, last_name, title, account_id) VALUES
	('Adam', 'King', 'Employee', 1),
	('Mehrab', 'Rahman', 'Manager', 2),
	('Nick', 'Escalona', 'Manager', 3),
	('Jacob', 'Serrano-Dean', 'Employee', 4);
	
INSERT INTO requests (employee_id, image_link, status, approval, manager_id) VALUES
	(1, '', 'Pending', NULL, NULL),
	(1, 'my_image.jpg', 'Pending', NULL, 3),
	(4, '', 'Pending', NULL, 3),
	(3, '', 'Resolved', 'Approved', 2);
	
SELECT *
FROM accounts
	FULL OUTER JOIN employees ON accounts.id = employees.account_id
	FULL OUTER JOIN requests ON employees.id = requests.employee_id