CREATE VIEW list_users AS
    SELECT u.*, p.privilege FROM users u
    INNER JOIN privilege_user p ON u.id_user = p.user;
