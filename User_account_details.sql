CREATE TABLE app_users (
  id        NUMBER(10)    NOT NULL,
  username  VARCHAR2(30)  NOT NULL,
  password  VARCHAR2(40)  NOT NULL
  first_name varchar2(200),
  last_name varchar2(200),
  start_date date,
  end_date   date,  
  user_role_id number
  PRIMARY KEY (id),
    FOREIGN KEY (role_id_fk) REFERENCES user_roles(role_id)
)
/
ALTER TABLE app_users ADD (
  CONSTRAINT app_users_pk PRIMARY KEY (id)
)
/
ALTER TABLE app_users ADD (
  CONSTRAINT app_users_uk UNIQUE (username)
)
/
create user_roles (role_id number primary key,
role_desc varchar2(2000)) 
/
CREATE SEQUENCE app_users_seq
/
CREATE OR REPLACE PACKAGE app_user_security_pkg AS

  FUNCTION get_hash (p_username  IN  VARCHAR2,
                     p_password  IN  VARCHAR2)
    RETURN VARCHAR2;

  PROCEDURE add_user (p_username  IN  VARCHAR2,
                      p_password  IN  VARCHAR2,
					  p_first_name IN  VARCHAR2,
					  p_last_name  IN  VARCHAR2,
					  p_end_date in date,
					  p_role_id	   IN  VARCHAR2,
						p_status out varchar2,
						p_err_msg out varchar);

  PROCEDURE change_password (p_username      IN  VARCHAR2,
                             p_old_password  IN  VARCHAR2,
                             p_new_password  IN  VARCHAR2,
							 p_status out varchar2,
							 p_err_msg out varchar);

  PROCEDURE valid_user (p_username  IN  VARCHAR2,
                        p_password  IN  VARCHAR2,
						p_status out varchar2,
						p_err_msg out varchar);

  FUNCTION valid_user (p_username  IN  VARCHAR2,
                       p_password  IN  VARCHAR2)
    RETURN BOOLEAN;

END;
/
CREATE OR REPLACE PACKAGE BODY app_user_security_pkg AS

  FUNCTION get_hash (p_username  IN  VARCHAR2,
                     p_password  IN  VARCHAR2)
    RETURN VARCHAR2 AS
    l_salt VARCHAR2(30) := 'PutYourSaltHere';
  BEGIN
    -- Pre Oracle 10g
    RETURN DBMS_OBFUSCATION_TOOLKIT.MD5(
      input_string => UPPER(p_username) || l_salt || UPPER(p_password));

    -- Oracle 10g+ : Requires EXECUTE on DBMS_CRYPTO
    --RETURN DBMS_CRYPTO.HASH(UTL_RAW.CAST_TO_RAW(UPPER(p_username) || l_salt || UPPER(p_password)),DBMS_CRYPTO.HASH_SH1);
  END;

  PROCEDURE add_user (p_username  IN  VARCHAR2,
                      p_password  IN  VARCHAR2,
					  p_first_name IN  VARCHAR2,
					  p_last_name  IN  VARCHAR2,
					  p_end_date in date,
					  p_role_id	   IN  VARCHAR2,
						p_status out varchar2,
						p_err_msg out varchar) AS
  BEGIN
    INSERT INTO app_users (
					  id        ,
					  username  ,
					  password  ,
					  first_name ,
					  last_name ,
					  start_date ,
					  user_role_id
					)
				VALUES (
				  app_users_seq.NEXTVAL,
					UPPER(p_username),
					get_hash(p_username, p_password),
					p_first_name,
					p_last_name,
					sysdate,
					p_role_id
			  );

    COMMIT;
	p_status:='S';
	p_err_msg:='User Created Succesfuly..';
	exception when others then
	p_status:='E';
	p_err_msg:='Exception in app_user_security_pkg.add_user : '||sqlerrm;
	END;

  PROCEDURE change_password (p_username      IN  VARCHAR2,
                             p_old_password  IN  VARCHAR2,
                             p_new_password  IN  VARCHAR2,
							 p_status out varchar2,
						p_err_msg out varchar) AS
    v_rowid  ROWID;
  BEGIN
    SELECT rowid
    INTO   v_rowid
    FROM   app_users
    WHERE  username = UPPER(p_username)
    AND    password = get_hash(p_username, p_old_password)
    FOR UPDATE;

    UPDATE app_users
    SET    password = get_hash(p_username, p_new_password)
    WHERE  rowid    = v_rowid;

    COMMIT;
 p_status:='S';
	p_err_msg:='Password Changed Successfully..';
 EXCEPTION
    WHEN NO_DATA_FOUND THEN
	p_status:='E';
	p_err_msg:='Invalid username/password.';
      RAISE_APPLICATION_ERROR(-20000, 'Invalid username/password.');
  END;

  PROCEDURE valid_user (p_username  IN  VARCHAR2,
                        p_password  IN  VARCHAR2,
						p_status out varchar2,
						p_err_msg out varchar) AS
    v_dummy  VARCHAR2(1);
  BEGIN
    SELECT '1'
    INTO   v_dummy
    FROM   app_users
    WHERE  username = UPPER(p_username)
    AND    password = get_hash(p_username, p_password);
	p_status:='S';
	p_err_msg:='Valid User..';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
	p_status:='E';
	p_err_msg:='Invalid username/password.';
      RAISE_APPLICATION_ERROR(-20000, 'Invalid username/password.');
  END;

  FUNCTION valid_user (p_username  IN  VARCHAR2,
                       p_password  IN  VARCHAR2)
    RETURN BOOLEAN AS
	lv_status varchar2(20);
	l_err_msg varchar2(200);
  BEGIN
    valid_user(p_username, p_password,lv_status,l_err_msg);
    RETURN TRUE;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN FALSE;
  END;
  END;
/