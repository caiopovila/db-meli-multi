CREATE DATABASE IF NOT EXISTS ml;
USE ml;

CREATE TABLE IF NOT EXISTS users (
  id_user INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
  email VARCHAR(200) NOT NULL,
  user VARCHAR(200) NOT NULL,
  date_register DATETIME,
  date_updated DATETIME,
  password VARCHAR(200) NOT NULL
);

CREATE TABLE IF NOT EXISTS privilege_user (
  user INT NOT NULL,
  date_updated DATETIME,
  privilege ENUM ('bloqueado', 'normal', 'alto') NOT NULL,

      CONSTRAINT usufk
      FOREIGN KEY (user) REFERENCES users(id_user)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS clients (
  id_client INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
  nickname VARCHAR(100),
  site_id VARCHAR(20),
  user_id INT NOT NULL,
  access_token VARCHAR(500) NOT NULL,
  refresh_token VARCHAR(500) NOT NULL,
  expires_in DATETIME NOT NULL,
  date_register DATETIME,
  date_updated DATETIME,
  user INT,

      CONSTRAINT userfk
      FOREIGN KEY (user) REFERENCES users(id_user)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS monitor (
  id_monitor INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
  seller_id INT NOT NULL,
  date_register DATETIME,
  user INT,

      CONSTRAINT userfkMonitor
      FOREIGN KEY (user) REFERENCES users(id_user)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
