-- UC1: Ability to create an Address Book Service DB
CREATE DATABASE AddressBookDB;

-- UC2: Ability to create a Contact Table with first and last names, address, city, state, zip, phone number, email, book name, and book type as its attributes
USE AddressBookDB;
CREATE TABLE Contact (
    Contact_ID INT AUTO_INCREMENT PRIMARY KEY,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
	Address VARCHAR(255),
    City VARCHAR(100),
    State VARCHAR(100),
    Zip VARCHAR(20),
    Phone_Number VARCHAR(20),
    Email VARCHAR(100)
);

DESCRIBE table Contact;

-- UC3: Ability to insert new Contacts to Address Book
INSERT INTO Contact (First_Name, Last_Name, Address, City, State, Zip, Phone_Number, Email)
VALUES ('Nikita', 'Mali', '123 Main St', 'Kolhapur', 'MH', '12345', '555-432-4567', 'nikita@gmail.com'), 
       ('Riya', 'Patil', '100 ft road', 'Sangli', 'Maharashtra', '123325', '555-3232-4567', 'riya@gmail.com'),
       ('Siya', 'Shinde', '123 sector 2', 'vizag', 'AP', '21324', '234-123-1234', 'siya@gmail.com'),
       ('Raj', 'Modi', 'Main road', 'Surat', 'Gujrat', '124334', '214-123-4567', 'raj@gmail.com'),
       ('Shiv', 'Gurav', 'near Gp sport', 'Kolhapur', 'Maharashtra', '34223', '555-312-4567', 'shiv@gmail.com');

SELECT * FROM Contact;

-- UC4: Ability to edit existing contact person using their name
UPDATE Contact SET State = 'Maharashtra'
WHERE First_Name = 'Nikita' AND Last_Name = 'Mali';

-- UC5: Ability to delete a person using person's name
DELETE FROM Contact
WHERE First_Name = 'Raj' AND Last_Name = 'Modi';

-- UC6: Retrieve Person belonging to a City or State from the Address Book
SELECT * FROM Contact
WHERE City = 'Kolhapur';

SELECT * FROM Contact
WHERE State = 'AP';

-- UC7: Understand the size of the address book by City and State
SELECT City, State, COUNT(*) AS size 
FROM Contact
GROUP BY City, State;

-- UC8: Retrieve entries sorted alphabetically by Person’s name for a given city
SELECT * FROM Contact
WHERE City = 'Kolhapur'
ORDER BY First_Name, Last_Name;

-- UC9: Ability to identify each Address Book with name and Type. (Here the type could Family, Friends, Profession, etc) Alter Address Book to add name and type
ALTER TABLE Contact
ADD COLUMN Book_Name VARCHAR(100),
ADD COLUMN Book_Type VARCHAR(50);

UPDATE Contact
SET Book_Name = 'FamilyBook', Book_Type = 'Family'
WHERE first_name = 'Nikita' or first_name = 'Siya' or first_name = 'Shiv';

UPDATE Contact
SET Book_Name = 'FriendBook', Book_Type = 'Friend'
WHERE first_name = 'Riya';

SELECT * FROM Contact;

CREATE TABLE AddressBook (
    Book_Name VARCHAR(100) PRIMARY KEY,
    Book_Type VARCHAR(50)
);

INSERT INTO AddressBook (Book_Name, Book_Type)
SELECT DISTINCT Book_Name, Book_Type
FROM Contact;

SELECT * FROM Contact;
SELECT * FROM AddressBook;

-- UC10: Ability to get number of contact persons i.e. count by type
-- UC10: Adding Foreign Key Constraints

SELECT Book_Type, COUNT(*) AS contact_count 
FROM Contact GROUP BY Book_Type;

ALTER TABLE Contact
ADD CONSTRAINT fk_book_name FOREIGN KEY (Book_Name) REFERENCES AddressBook(Book_Name);

-- UC11: Ability to add a person to both Friend and Family
INSERT INTO Contact (First_Name, Last_Name, Address, City, State, Zip, Phone_Number, Email, Book_Name, Book_Type)
VALUES ('Aditi', 'Gurav', 'shivaji peth', 'Pune', 'Maharashtra', '57821', '555-999-8888', 'aditi@gmail.com', 'FamilyBook', 'Family'),
       ('Aditi', 'Gurav', 'shivaji peth', 'Pune', 'Maharashtra', '57821', '555-999-8888', 'aditi@gmail.com', 'FriendBook', 'Friend');


-- UC13: Ensure all retrieve queries are working with the new table structure
-- Retrieve Person belonging to a City or State 
SELECT c.* FROM Contact c
JOIN AddressBook ab ON c.Book_Name = ab.Book_Name
WHERE c.City = 'Kolhapur';

SELECT c.* FROM Contact c
JOIN AddressBook ab ON c.Book_Name = ab.Book_Name
WHERE c.State = 'AP';

-- Understand the size of the address book by City and State 
SELECT c.City, c.State, COUNT(*) AS size 
FROM Contact c
JOIN AddressBook ab ON c.Book_Name = ab.Book_Name
GROUP BY c.City, c.State;

-- Retrieve entries sorted alphabetically by Person’s name for given city
SELECT * FROM Contact c
JOIN AddressBook ab ON c.Book_Name = ab.Book_Name
WHERE c.City = 'Kolhapur'
ORDER BY c.First_Name, c.Last_Name;

-- Get the number of contact persons
SELECT ab.Book_Type, COUNT(*) AS contact_count 
FROM Contact c
JOIN AddressBook ab ON c.Book_Name = ab.Book_Name
GROUP BY ab.Book_Type;
