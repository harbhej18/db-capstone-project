CREATE PROCEDURE UpdateBooking(IN UpdateID INT, IN TableNo INT)
UPDATE Bookings
SET TableNumber = TableNo
WHERE BookingID = UpdateID;

CALL UpdateBooking(6, 1);

SELECT * FROM Bookings;
DROP PROCEDURE AddBooking;
-- a procedure to add a booking
DELIMITER $$
CREATE PROCEDURE AddBooking (IN AddBookingID INT, IN AddBookingDate DATE, IN AddTableNo INT, IN AddCustomerID INT, IN AddEmployeeNum INT)
BEGIN
INSERT INTO Bookings (BookingID, BookingDate, TableNumber, CustomerID, EmployeeID)
VALUES (AddBookingID, AddBookingDate, AddTableNo, AddCustomerID, AddEmployeeNum);
SELECT CONCAT("New Booking ID ", AddBookingID, " Added.") AS Confirmation;
END$$
DELIMITER ;

-- call the procedure 
CALL AddBooking(5, "2022-12-30", 4, 3, 1);

DELIMITER $$
CREATE PROCEDURE AddValidBooking (booking_id INT, customer_id INT, table_no int, booking_date date)
BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    ROLLBACK;
END;
START TRANSACTION;
INSERT INTO Bookings (BookingID, BookingDate, TableNumber, CustomerID) 
VALUES (booking_id, booking_date, table_no, customer_id);
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'An error occurred';
SELECT "New booking added" AS "Confirmation";
COMMIT;
END$$
DELIMITER ;

CALL AddValidBooking(5, "2022-12-30", 4, 3, 1);

-- check the bookings table
SELECT * FROM Bookings;

-- a procedure to check whether a table in the restaurant is already booked
DROP PROCEDURE IF EXISTS CheckBooking;

-- a stored procedure to check if a table is booked on a given date
DELIMITER $$
CREATE PROCEDURE CheckBooking (booking_date DATE, table_number INT)
BEGIN
DECLARE bookedTable INT DEFAULT 0;
 SELECT COUNT(bookedTable)
    INTO bookedTable
    FROM Bookings WHERE BookingDate = booking_date and TableNumber = table_number;
    IF bookedTable > 0 THEN
      SELECT CONCAT( "Table ", table_number, " is already booked.") AS "Booking status";
      ELSE 
      SELECT CONCAT( "Table ", table_number, " is not booked.") AS "Booking status";
    END IF;
END$$
DELIMITER ;

CALL CheckBooking("2022-12-30", 5);

-- check Bookings table
SELECT * FROM Bookings;


DELIMITER $$
CREATE PROCEDURE CancelBooking(IN CancelID INT)
BEGIN
DELETE FROM Bookings WHERE BookingID = CancelID;
SELECT CONCAT("Order ",CancelID, " is cancelled.") AS Confirmation FROM Bookings;
END$$
DELIMITER ;