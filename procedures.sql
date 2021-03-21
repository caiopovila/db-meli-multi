DELIMITER $$

CREATE PROCEDURE post_client(
  IN v_access_token VARCHAR(500),
  IN v_expires_in DATETIME,
  IN v_refresh_token VARCHAR(500),
  IN v_user_id INT,
  IN v_user INT
  )
BEGIN
  DECLARE x INT DEFAULT 0;
  
  IF ((v_access_token != '') && (v_refresh_token != '') && (v_expires_in != '') && (v_user != '') && (v_user_id != '')) THEN
  
    SELECT COUNT(*) INTO x FROM clients WHERE user_id = v_user_id AND user = v_user;
    IF x > 0 THEN
        UPDATE clients SET
        access_token = v_access_token,
        expires_in = v_expires_in,
        refresh_token = v_refresh_token,
        user_id = v_user_id,
        date_updated = NOW()
        WHERE user_id = v_user_id AND user = v_user;
    ELSE
        INSERT INTO clients (
        access_token,
        expires_in,
        refresh_token,
        user_id,
        user,
        date_register
        ) VALUES (v_access_token, v_expires_in, v_refresh_token, v_user_id, v_user, NOW());
    END IF;
    
   ELSE
    
    SELECT 'Valores não podem ser nulos' AS 'E';
    
   END IF;
END

$$

DELIMITER ;;

CREATE PROCEDURE post_user(
  IN v_privilege VARCHAR(20),
  IN v_email VARCHAR(200),
  IN v_user VARCHAR(200),
  IN v_password VARCHAR(200)
  )
BEGIN
  DECLARE x INT DEFAULT 0;
  DECLARE u INT;
  
  IF ((v_privilege != '') && (v_user != '') && (v_email != '') && (v_password != '')) THEN
  
    SELECT COUNT(*) INTO x FROM users WHERE user = v_user OR email = v_email;
  
    IF x > 0 THEN
        SELECT 'Cadastro existente' AS 'E';
    ELSE
        START TRANSACTION;
            INSERT INTO users (user, email, password, date_register) VALUES (v_user, v_email, v_password, NOW());
            SELECT id_user INTO u FROM users WHERE user = v_user AND password = v_password; 
            INSERT INTO privilege_user (user, privilege) VALUES (u, v_privilege);
        COMMIT;
    END IF;
    
  ELSE
  
    SELECT 'Valores não podem ser nulos' AS 'E';    
  
  END IF;
END

;;

DELIMITER $$

CREATE PROCEDURE put_user(
  IN v_privilege VARCHAR(20),
  IN v_user VARCHAR(200),
  IN v_email VARCHAR(200),
  IN v_password VARCHAR(200),
  IN v_id INT
  )
BEGIN
  DECLARE x INT DEFAULT 0;
  DECLARE y INT DEFAULT 0;

    IF ((v_user != '') && (v_email != '') && (v_id != '')) THEN
            
        SELECT COUNT(*) INTO y FROM users WHERE user = v_user OR email = v_email AND id_user <> v_id;
            
        IF y > 0 THEN
        
            SELECT 'Usuario existente' AS 'E';
            
        ELSE
        
            SELECT COUNT(*) INTO x FROM users WHERE id_user = v_id;
        
            IF x > 0 THEN
                START TRANSACTION;
                
                IF (v_password != '') THEN
                    UPDATE users SET
                    user = v_user,
                    email = v_email,
                    password = v_password,
                    date_updated = NOW()
                    WHERE id_user = v_id;
                ELSE
                    UPDATE users SET
                    user = v_user,
                    email = v_email,
                    date_updated = NOW()
                    WHERE id_user = v_id;
                END IF;
                
                IF (v_privilege != '') THEN
                    UPDATE privilege_user SET 
                    user = v_id,
                    date_updated = NOW(),
                    privilege = v_privilege 
                    WHERE user = v_id;
                END IF;
                
                COMMIT;
            ELSE
                SELECT 'Usuario não encontrado' AS 'E';
            END IF;
            
        END IF;
        
    ELSE
  
        SELECT 'Valores não podem ser nulos' AS 'E';    
  
    END IF;
END

$$

DELIMITER ;;

CREATE PROCEDURE del_user(
  IN v_id INT
  )
BEGIN
  DECLARE x INT DEFAULT 0;

  SELECT COUNT(*) INTO x FROM users WHERE id_user = v_id;
  
  IF x > 0 THEN
    DELETE FROM users 
    WHERE id_user = v_id;
  ELSE
    SELECT 'Usuario não encontrado' AS 'E';
  END IF;
END

;;

DELIMITER ;;

CREATE PROCEDURE del_client(
  IN v_id_client INT,
  IN v_id_user INT
  )
BEGIN
  DECLARE x INT DEFAULT 0;

  SELECT COUNT(*) INTO x FROM clients WHERE id_client = v_id_client AND user = v_id_user;
  
  IF x > 0 THEN
    DELETE FROM clients WHERE id_client = v_id_client AND user = v_id_user;
  ELSE
    SELECT 'Cliente não encontrado' AS 'E';
  END IF;
END

;;

DELIMITER ;;

CREATE PROCEDURE list_users()
BEGIN

    SELECT * FROM list_users;
    
END

;;

DELIMITER ;;

CREATE PROCEDURE list_clients(
  IN v_id INT
  )
BEGIN

    SELECT * FROM clients WHERE user = v_id;
    
END

;;


DELIMITER ;;

CREATE PROCEDURE get_client(
  IN v_id_user INT,
  IN v_id_client INT
  )
BEGIN

  IF ((v_id_user != '') && (v_id_client != '')) THEN
    SELECT * FROM clients WHERE user = v_id_user AND user_id = v_id_client;
  ELSE
    SELECT 'Valores não podem ser nulos' AS 'E';    
  END IF;
  
END

;;


DELIMITER ;;

CREATE PROCEDURE get_user(
  IN v_id_user INT
  )
BEGIN

  IF ((v_id_user != '')) THEN
    SELECT id_user, user, email, privilege FROM list_users WHERE id_user = v_id_user;
  ELSE
    SELECT 'Valores não podem ser nulos' AS 'E';    
  END IF;
  
END

;;


DELIMITER ;;

CREATE PROCEDURE post_nick_in_client(
  IN v_nick VARCHAR(200),
  IN v_site_id VARCHAR(20),
  IN v_id_user INT,
  IN v_id_client INT
  )
BEGIN
  DECLARE x INT DEFAULT 0;

  IF ((v_nick != '') && (v_id_user != '') && (v_id_client != '')) THEN
  
    SELECT COUNT(*) INTO x FROM clients WHERE user = v_id_user AND user_id = v_id_client;
    
    IF x > 0 THEN
    
        UPDATE clients SET nickname = v_nick, site_id = v_site_id, date_updated = NOW() WHERE user_id = v_id_client AND user = v_id_user;
        
    ELSE
    
        SELECT 'Cliente não encontrado' AS 'E';
        
    END IF;
    
  ELSE
  
    SELECT 'Valores não podem ser nulos' AS 'E';    
  
  END IF;
END

;;

DELIMITER ;;

CREATE PROCEDURE auth_user(
  IN v_user VARCHAR(200),
  IN v_password VARCHAR(200)
  )
BEGIN
  DECLARE x INT DEFAULT 0;

  IF ((v_user != '') && (v_password != '')) THEN
  
        SELECT COUNT(*) INTO x FROM list_users WHERE user = v_user AND password = v_password;
        
        IF x > 0 THEN
        
            SELECT * FROM list_users WHERE user = v_user AND password = v_password;
            
        ELSE
        
            SELECT 'Usuario não existe' AS 'E';
            
        END IF;
        
    ELSE
  
    SELECT 'Valores não podem ser nulos' AS 'E';    
  
  END IF;
  
END

;;
