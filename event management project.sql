CREATE DATABASE event;
USE event;
--

-- Stores venue details such as venue name and seating capacity.--
CREATE TABLE venues (
venue_id INT AUTO_INCREMENT PRIMARY KEY,    name VARCHAR(40) NOT NULL,
capacity INT NOT NULL
);
SHOW TABLES;

-- Stores event organizer details and Each organizer has a unique email.--
CREATE TABLE organizers
(org_id INT PRIMARY KEY AUTO_INCREMENT,name VARCHAR(100) NOT NULL,
Email VARCHAR(100) UNIQUE);


--
CREATE TABLE events 
( event_id INT PRIMARY KEY  AUTO_INCREMENT,
name VARCHAR(100) NOT NULL,event_date DATE NOT NULL,
venue_id INT NOT NULL, org_id INT NOT NULL,
price DECIMAL(8,2)NOT NULL,


CONSTRAINT fk_event_venue
FOREIGN KEY (venue_id) REFERENCES venues(venue_id),
    CONSTRAINT fk_event_org
        FOREIGN KEY (org_id) REFERENCES organizers(org_id));
        
--

CREATE TABLE Attendees (
    attendee_id INT PRIMARY KEY AUTO_INCREMENT, 
    Name       VARCHAR(100) NOT NULL,          
    Email      VARCHAR(100),                  
    event_id   INT NOT NULL,                   

    CONSTRAINT fk_attendee_event
        FOREIGN KEY (event_id) REFERENCES Events(event_id)
);

--
INSERT INTO venues (Name, capacity)
VALUES 
    ('City Hall',               500),
    ('Tech Park Auditorium',    300),
    ('Grand Convention Center', 1200),
    ('Riverside Open Arena',    800),
    ('Downtown Meeting Room',   80);
        
INSERT INTO organizers (Name, Email)
VALUES
    ('EventPros Inc.',            'contact@eventpros.com'),
    ('TechMeetup Org',            'info@techmeetup.org'),
    ('Startup Hub Kerala',        'hello@startuphub.in'),
    ('College Cultural Committee','culture@campus.edu'),
    ('MusicLive Events',          'support@musiclive.com'); 

INSERT INTO events (Name, event_date, venue_id, org_id, price)
VALUES
    ('Tech Meetup 2026',          '2026-02-20', 2, 2, 25.00 ),
    ('Startup Pitch Night',       '2026-03-15', 1, 3, 10.00),
    ('College Cultural Fest',     '2026-04-05', 3, 4,  0.00),
    ('Live Music Evening',        '2026-05-12', 4, 5, 15.00),
    ('Developer Workshop',   '2026-02-28', 5, 2,  5.00),
    ('Food Truck Carnival',       '2026-06-01', 4, 1,  2.00),
    ('Startup Networking Brunch', '2026-03-22', 5, 3, 12.00);
    
    select * from events;

INSERT INTO Attendees (Name, Email, event_id)
VALUES
    ('John Doe',      'john@example.com',           1),
    ('Jane Smith',    'jane@example.com',           1),
    ('Arjun Nair',    'arjun.nair@example.com',     1),
    ('Fatima Rahman', 'fatima.r@example.com',       2),
    ('Rahul Menon',   'rahul.menon@example.com',    2),
    ('Sneha Pillai',  'sneha.pillai@example.com',   3),
    ('David Thomas',  'david.t@example.com',        3),
    ('Ananya Iyer',   'ananya.iyer@example.com',    4),
    ('Mohammed Ali',  'mohammed.ali@example.com',   5),
    ('Lisa George',   'lisa.g@example.com',         5),
    ('Kiran Kumar',   'kiran.k@example.com',        6),
    ('Neha S',        'neha.s@example.com',         7);

SELECT 
    e.event_id,
    e.Name       AS EventName,
    e.event_date,
    v.Name       AS VenueName,
    o.Name       AS OrganizerName
FROM events e JOIN venues v     ON e.venue_id = v.venue_id
JOIN organizers o ON e.org_id   = o.org_id
ORDER BY e.event_id, e.event_date DESC;

--

SELECT 
    e.event_id,
    e.name AS EventName,
    COUNT(a.attendee_id) AS TotalAttendees
FROM events e
LEFT JOIN attendees a ON e.event_id = a.event_id
GROUP BY e.event_id, e.name;



SELECT 
    e.name AS EventName,
    v.name AS Venue,
    v.capacity
FROM events e
JOIN venues v ON e.venue_id = v.venue_id;


SELECT
e.name AS EventName,COUNT(a.attendee_id)AS Attendees,
e.price,
COUNT(a.attendee_id) * e.price AS TotalRevenue FROM events e 
LEFT JOIN attendees a ON e.event_id=a.event_id
GROUP BY e.event_id, e.name, e.price;


SELECT * FROM events WHERE event_date> CURDATE();

-- The view combines data from multiple tables to show complete event details in one place.--
CREATE VIEW event_details AS
SELECT
 e.event_id,
    e.name AS EventName,
    e.event_date,
    v.name AS VenueName,
    o.name AS OrganizerName,
    e.price
FROM events e 
JOIN venues v ON e.venue_id=v.venue_id
	JOIN organizers o ON e.org_id = o.org_id;
-- Displays all events in an organized manner.--
    
    SELECT * FROM event_details ORDER BY event_id;
    
    -- Returns all events organized by a specific organizer.--
    DELIMITER $$
    CREATE PROCEDURE gets_events_by_organizer(IN OrgName varchar(100))
    
    BEGIN
    SELECT * FROM event_details WHERE OrganizerName=OrgName;
    END $$
    
    DELIMITER ;
-- Fetches events handled by TechMeetup Org.--
    CALL gets_events_by_organizer('TechMeetup Org');
    
    
