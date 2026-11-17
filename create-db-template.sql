CREATE DATABASE airline_db
    DEFAULT CHARACTER SET = 'utf8mb4';

use airline_db;
CREATE TABLE passengers(
    passenger_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    current_location VARCHAR(100),
    destination VARCHAR(100),
    travel_date VARCHAR(20)
);

CREATE TABLE bookings (
    booking_id INT PRIMARY KEY,
    passenger_id INT,
    class_tier VARCHAR(20) CHECK (class_tier IN ('Economy', 'Business', 'First')),
    seat_preference VARCHAR(20),
    lounge_pass_code VARCHAR(50),
    suite_number VARCHAR(20),
    chauffeur_service BOOLEAN, -- Bool data type
    FOREIGN KEY (passenger_id) REFERENCES passengers(passenger_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

INSERT INTO passengers (passenger_id, name, current_location, destination, travel_date) VALUES
(1, 'Alice Smith', 'Kigali', 'Nairobi', '2026-06-10'),
(2, 'Bob Jones', 'Lagos', 'London', '2026-06-12'),
(3, 'Charlie Brown', 'New York', 'Tokyo', '2026-06-15');

INSERT INTO bookings (booking_id, passenger_id, class_tier, seat_preference, lounge_pass_code, suite_number, chauffeur_service) VALUES
(101, 1, 'Economy', 'Window', NULL, NULL, FALSE),
(102, 2, 'Business', 'Aisle', 'LP-9876', NULL, TRUE),
(103, 3, 'First', 'Middle', 'LP-1122', 'Suite A', TRUE);

SELECT p.*, b.class_tier 
FROM passengers p
JOIN bookings b ON p.passenger_id = b.passenger_id
WHERE b.class_tier IN ('Business', 'First');

SELECT 
    p.name AS Name, 
    p.destination AS Destination, 
    b.class_tier AS Tier,
    CONCAT(
        'Seat: ', b.seat_preference, 
        IF(b.lounge_pass_code IS NULL, '', CONCAT(', Lounge Pass: ', b.lounge_pass_code)),
        IF(b.suite_number IS NULL, '', CONCAT(', Suite: ', b.suite_number)),
        ', Chauffeur: ', IF(b.chauffeur_service, 'Yes', 'No')
    ) AS Class_Perks
FROM passengers p
INNER JOIN bookings b ON p.passenger_id = b.passenger_id;

-- Updating destination for passenger with ID 1
UPDATE passengers 
SET destination = 'Dubai' 
WHERE passenger_id = 1;

-- Updating seat preference for booking associated with passenger ID 1
UPDATE bookings 
SET seat_preference = 'Aisle' 
WHERE passenger_id = 1;

-- Deleting the booking record first 
DELETE FROM bookings 
WHERE passenger_id = 1;
