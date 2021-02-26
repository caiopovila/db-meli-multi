INSERT INTO users (password, user, email, date_register)
VALUES
  (
    'admin',
    'admin',
    'admin@mail.com',
    NOW()
  ),
  (
    'admin2',
    'admin2',
    'admin2@mail.com',
    NOW()
  );

  INSERT INTO privilege_user (privilege, user)
VALUES
  (
    'normal',
    1
  ),
  (
    'alto',
    2
  );
