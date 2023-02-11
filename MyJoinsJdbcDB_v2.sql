/*
Создайте базу данных с именем “MyJoinsJdbcDB”.

В данной базе данных создайте 3 таблицы, 
В 1-й таблице содержатся имена и номера телефонов сотрудников компании. 
Во 2-й таблице содержатся ведомости о зарплате и должностях сотрудников: главный директор, менеджер, рабочий. 
В 3-й таблице содержится информация о семейном положении, дате рождения, и месте проживания. 
*/
-- DROP DATABASE MyJoinsJdbcDB;
CREATE DATABASE MyJoinsJdbcDBv2;
USE MyJoinsJdbcDBv2;

CREATE TABLE staff(
id INT AUTO_INCREMENT NOT NULL,
name VARCHAR(20),
phone VARCHAR(15),
PRIMARY KEY(id)
);

INSERT INTO staff
(name, phone)
VALUES
('Андрей','+380971112233'),
('Евгений','+380952226661'),
('Алекс','+380975556644'),
('Василий','+380509994466'),
('Татьяна','+380961326459'),
('Олег','+380995461245');

CREATE TABLE serviceInfo(
staff_id INT,
salary DOUBLE,
position VARCHAR(20),
PRIMARY KEY(staff_id)/*,
FOREIGN KEY (staff_id) REFERENCES staff(id) */
);

INSERT INTO serviceInfo
(staff_id, position, salary)
VALUES
(1, 'Главный директор', 30000),
(2, 'Менеджер', 20000),
(3, 'Менеджер', 22000),
(4, 'Рабочий', 10000),
(5, 'Менеджер', 20000),
(6, 'Рабочий', 12000);

CREATE TABLE personalInfo(
staff_id INT,
maritalStatus VARCHAR(10),
birth_day DATE,
adress VARCHAR(50),
PRIMARY KEY(staff_id)/*,
FOREIGN KEY (staff_id) REFERENCES staff(id) */
);

INSERT INTO personalInfo
(staff_id, maritalStatus, birth_day, adress)
VALUES
(1, 'женат', '1990-01-02','г. Харьков, ул. Радостная, 23'),
(2, 'женат', '2000-12-22','г. Харьков, ул. Счастливая, 25'),
(3, 'не женат', '1995-04-16','г. Харьков, ул. Цветочная, 564'),
(4, 'женат', '1991-06-12','г. Харьков, ул. Умников, 16, кв. 55'),
(5, 'не замужем', '1987-01-14','г. Харьков, ул. Лентяев, 231'),
(6, 'не женат', '1990-01-02','г. Харьков, ул. Обнимашек, 123');

-- Проверка созданных таблиц
SELECT * FROM staff;
SELECT * FROM serviceInfo;
SELECT * FROM personalInfo;

/* Получите контактные данные сотрудников (номера телефонов, место жительства) */
SELECT staff.name, staff.phone, personalInfo.adress
FROM staff
JOIN personalInfo
ON staff.id = personalInfo.staff_id;

/* Получите информацию о дате рождения всех холостых сотрудников и их номера
В данной бд холостых 3 человека */
SELECT staff.name, personalInfo.birth_day, staff.phone
FROM staff
JOIN personalInfo
ON staff.id = personalInfo.staff_id
WHERE personalInfo.maritalStatus IN ('не женат', 'не замужем');

/* Получите информацию обо всех менеджерах компании: дату рождения и номер телефона
В данной бд менеджеров также 3 человека */
SELECT staff.name, personalInfo.birth_day, staff.phone
FROM staff
JOIN personalInfo
ON staff.id = personalInfo.staff_id
JOIN serviceInfo
ON staff.id = serviceInfo.staff_id
WHERE serviceInfo.position = 'Менеджер';


