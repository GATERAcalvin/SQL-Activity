# Airline Database SQL Activity

A small MySQL exercise that creates an airline passenger and booking database, inserts sample records, runs two reports, and demonstrates `UPDATE` and `DELETE` statements. The complete script is [`create-db-template.sql`](./create-db-template.sql).

## Requirements

- A MySQL-compatible database and a SQL client (for example, MySQL Workbench or the `mysql` command-line client).
- Permission to create the `airline_db` database and its tables.
- A MySQL version that enforces `CHECK` constraints (MySQL 8.0.16 or later is recommended).

The script uses MySQL features such as `USE`, `IF()`, `CONCAT()`, and `BOOLEAN` (a MySQL alias for `TINYINT(1)`).

## Run the script

Open `create-db-template.sql` in your SQL client and execute it from the top. It creates and selects `airline_db` before creating tables and inserting data.

The script is intended as a one-time setup. It does not use `IF NOT EXISTS`, and its inserts use fixed primary keys. Running it again against the same database will fail when the database, tables, or records already exist. Use a fresh database for another clean run; do not drop existing data unless you intend to erase it.

## Database structure

### `passengers`

One row per passenger:

| Column | Meaning |
| --- | --- |
| `passenger_id` | Manually supplied primary key. |
| `name` | Passenger name; required and up to 100 characters. |
| `current_location` | Starting location. |
| `destination` | Planned destination. |
| `travel_date` | Travel date stored as text (`VARCHAR(20)`); sample values use `YYYY-MM-DD`. |

### `bookings`

One row per booking:

| Column | Meaning |
| --- | --- |
| `booking_id` | Manually supplied primary key. |
| `passenger_id` | References `passengers.passenger_id`. It is not declared `NOT NULL`, so SQL permits a booking without an associated passenger. |
| `class_tier` | Cabin tier: `Economy`, `Business`, or `First` (checked when the database enforces the `CHECK` constraint). |
| `seat_preference` | Requested seat, such as `Window` or `Aisle`. |
| `lounge_pass_code` | Optional lounge pass code. |
| `suite_number` | Optional suite number. |
| `chauffeur_service` | Boolean-style chauffeur indicator (`TRUE` or `FALSE`). |

The foreign key uses `ON DELETE CASCADE` and `ON UPDATE CASCADE`: deleting a passenger also deletes that passenger's bookings, and changing a passenger ID updates the related bookings. Deleting a booking does not delete its passenger.

## Sample data

The script inserts three passengers and one booking for each:

- Alice Smith: Kigali to Nairobi; Economy; Window seat; no lounge pass or suite; no chauffeur.
- Bob Jones: Lagos to London; Business; Aisle seat; lounge pass `LP-9876`; chauffeur.
- Charlie Brown: New York to Tokyo; First; Middle seat; lounge pass `LP-1122`; Suite A; chauffeur.

IDs are supplied explicitly: passenger IDs `1`-`3` and booking IDs `101`-`103`.

## Queries and changes

1. **Business/First passenger report** - joins passengers to bookings and returns passenger columns plus the cabin tier, limited to Business and First bookings. With the initial sample data, it returns Bob and Charlie.
2. **Class perks report** - returns each passenger's name and destination, booking tier, and a formatted `Class_Perks` value. Optional lounge and suite details are included only when present; chauffeur status is shown as Yes or No.
3. **Update passenger 1** - changes Alice's destination to Dubai.
4. **Update passenger 1's booking** - changes the seat preference to Aisle.
5. **Delete passenger 1's booking** - removes the booking row(s) associated with passenger ID 1. This is the last statement, so Alice remains in `passengers` but no longer has a booking after the full script completes. The reports run before these changes.

## Notes

- `travel_date` is text rather than a SQL `DATE`, so database date validation and date arithmetic are not available for that column without conversion.
- The table definitions do not use `AUTO_INCREMENT`; new IDs must be chosen by the person adding records.
- The script contains sample personal names and locations only. Replace them with data appropriate for your own use before adapting it.
