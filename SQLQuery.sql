CREATE database HotelReservations;
USE HotelReservations;
CREATE TABLE dbo.HotelReservations (
    Hotel NVARCHAR(255),
    is_canceled INT,
    lead_time INT,
    arrival_date_year INT,
    arrival_date_month NVARCHAR(255),
    arrival_date_week_number INT,
    arrival_date_day_of_month INT,
    stays_in_weekend_nights INT,
    stays_in_week_nights INT,
    adults INT,
    children FLOAT,
    babies INT,
    meal NVARCHAR(255),
    country NVARCHAR(255),
    market_segment NVARCHAR(255),
    distribution_channel NVARCHAR(255),
    is_repeated_guest INT,
    previous_cancellations INT,
    previous_bookings_not_canceled INT,
    reserved_room_type NVARCHAR(255),
    assigned_room_type NVARCHAR(255),
    booking_changes INT,
    deposit_type NVARCHAR(255),
    agent FLOAT,
    company FLOAT,
    days_in_waiting_list INT,
    customer_type NVARCHAR(255),
    adr FLOAT,
    required_car_parking_spaces INT,
    total_of_special_requests INT,
    reservation_status NVARCHAR(255),
    reservation_status_date DATETIME
);


SELECT * FROM dbo.hotel_reservations;

/* EDA Steps for Hotel Reservation Analysis
1. Summary Statistics for the two hotel types*/

-- Summary statistics for numerical columns for Resort Hotels (H1)
SELECT
  'Resort Hotel' AS hotel_type,
  COUNT(*) AS total_rows,
  AVG(lead_time) AS avg_lead_time,
  MIN(lead_time) AS min_lead_time,
  MAX(lead_time) AS max_lead_time,
  AVG(stays_in_weekend_nights) AS avg_weekend_nights,
  AVG(stays_in_week_nights) AS avg_week_nights
FROM dbo.hotel_reservations
WHERE hotel = 'Resort Hotel';

--Summary statistics for numerical columns for City Hotels (H2)
SELECT
  'City Hotel' AS hotel_type,
  COUNT(*) AS total_rows,
  AVG(lead_time) AS avg_lead_time,
  MIN(lead_time) AS min_lead_time,
  MAX(lead_time) AS max_lead_time,
  AVG(stays_in_weekend_nights) AS avg_weekend_nights,
  AVG(stays_in_week_nights) AS avg_week_nights
FROM dbo.hotel_reservations
WHERE hotel = 'City Hotel';

-- Checking columns for missing values
SELECT
  COUNT(*) - COUNT(column_name) AS missing_count,
  column_name
FROM information_schema.columns
WHERE table_name = 'hotel_reservations'
GROUP BY column_name;

-- Analyzing lead time, booking changes, and cancellation patterns for both hotels

SELECT
  'Resort Hotel' as hotel,
  AVG(lead_time) AS avg_lead_time,
  AVG(booking_changes) AS avg_booking_changes,
  AVG(CAST(is_canceled AS INT)) AS cancellation_rate
FROM dbo.hotel_reservations
WHERE hotel = 'Resort Hotel'
GROUP BY hotel;

SELECT
  'City Hotel' as hotel,
  AVG(lead_time) AS avg_lead_time,
  AVG(booking_changes) AS avg_booking_changes,
  AVG(CAST(is_canceled AS INT)) AS cancellation_rate
FROM dbo.hotel_reservations
WHERE hotel = 'City Hotel'
GROUP BY hotel;

-- Exploring the distribution of reservations based on the 'country' column for both hotels
SELECT
  hotel,
  country,
  COUNT(*) AS reservation_count
FROM dbo.hotel_reservations
GROUP BY hotel, country;

-- For Resort Hotel
SELECT
  'Resort Hotel' as hotel,
  country,
  COUNT(*) AS reservation_count
FROM dbo.hotel_reservations
WHERE hotel = 'Resort Hotel'
GROUP BY hotel, country;

-- For City Hotel
SELECT
  'City Hotel' as hotel,
  country,
  COUNT(*) AS reservation_count
FROM dbo.hotel_reservations
WHERE hotel = 'City Hotel'
GROUP BY hotel, country;


-- Explore the distribution of numerical features
SELECT
  AVG(lead_time) AS avg_lead_time,
  STDEV(lead_time) AS std_dev_lead_time
FROM dbo.hotel_reservations;

-- Explore the distribution of categorical features
SELECT
  meal,
  COUNT(*) AS count
FROM dbo.hotel_reservations
GROUP BY meal;


-- Calculating correlations between numerical features
SELECT
  DISTINCT
  'Resort Hotel' as hotel,
  AVG(lead_time) OVER (PARTITION BY hotel) AS avg_lead_time,
  AVG(booking_changes) OVER (PARTITION BY hotel) AS avg_booking_changes,
  AVG(CAST(is_canceled AS FLOAT)) OVER (PARTITION BY hotel) AS cancellation_rate
FROM dbo.hotel_reservations;

-- Market Segment Analysis for both hotels

SELECT
  hotel,
  market_segment,
  COUNT(*) AS reservation_count
FROM hotel_reservations
GROUP BY hotel, market_segment;

-- Distribution Channel Analysis for both hotels
SELECT
  hotel,
  distribution_channel,
  COUNT(*) AS reservation_count
FROM hotel_reservations
GROUP BY hotel, distribution_channel;

-- Special Requests and Customer Type Analysis for both hotels
SELECT
  hotel,
  customer_type,
  total_of_special_requests,
  COUNT(*) AS reservation_count
FROM hotel_reservations
GROUP BY hotel, customer_type, total_of_special_requests;

-- Time-Based Analysis for both hotels
SELECT
  hotel,
  arrival_date_month,
  COUNT(*) AS reservation_count
FROM hotel_reservations
GROUP BY hotel, arrival_date_month;

-- Reservation Status Trends Over Time for both hotels
SELECT
  hotel,
  reservation_status_date,
  COUNT(*) AS reservation_count
FROM hotel_reservations
GROUP BY hotel, reservation_status_date;

-- Deposit Type Analysis for both hotels
SELECT
  hotel,
  deposit_type,
  COUNT(*) AS reservation_count
FROM hotel_reservations
GROUP BY hotel, deposit_type;

-- Room Type Analysis for both hotels
SELECT
  hotel,
  reserved_room_type,
  assigned_room_type,
  COUNT(*) AS reservation_count
FROM hotel_reservations
GROUP BY hotel, reserved_room_type, assigned_room_type;





