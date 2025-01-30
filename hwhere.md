# MongoDB Hotel Data Collection Assignment

## 1. Create a new collection of hotel documents

In your Mongo shell (or MongoDB Compass, or another Mongo client), create (or switch to) a database and then insert three documents into a new `hotels` collection.

```js
use HotelDB; 
// Switch to or create the database called "HotelDB" (you can name it anything)

db.hotels.insertMany([
  {
    name: "Hotel Sunrise",
    address: "123 Beach Road, Oceanview",
    roomRates: 150,
    roomTypes: ["Single", "Double", "Suite"]
  },
  {
    name: "Cityscape Inn",
    address: "456 Main Street, Downtown",
    roomRates: 200,
    roomTypes: ["Standard", "Deluxe"]
  },
  {
    name: "Mountain Retreat",
    address: "789 Alpine Way, Hilltown",
    roomRates: 120,
    roomTypes: ["Single", "Double"]
  }
]);
```

---

## 2. Screenshot of Initial Hotel Entry

**Description:** The following screenshot shows the initial hotel entries before any updates.

![Screenshot 1: Initial hotel entry](screenshot1.png)

Run this command to display the inserted data:

```js
db.hotels.find().pretty();
```

---

## 3. Update the documents to add an array with three amenities

Add an `amenities` array to each hotel, ensuring each has a unique combination.

```js
db.hotels.updateOne(
  { name: "Hotel Sunrise" },
  { $set: { amenities: ["Free Wi-Fi", "Breakfast", "Ocean View"] } }
);

db.hotels.updateOne(
  { name: "Cityscape Inn" },
  { $set: { amenities: ["Free Wi-Fi", "Rooftop Bar", "Conference Room"] } }
);

db.hotels.updateOne(
  { name: "Mountain Retreat" },
  { $set: { amenities: ["Free Parking", "Breakfast", "Hiking Trails"] } }
);
```

---

## 4. Screenshot of Hotel Entries with Amenities Added

**Description:** The following screenshot shows the hotel entries with amenities added.

![Screenshot 2: Hotel entries with amenities](screenshot2.png)

Run this command to verify:

```js
db.hotels.find().pretty();
```

---

## 5. Delete all the amenities from one hotel

Choose one hotel (e.g., `Mountain Retreat`) to remove its amenities using `$unset`:

```js
db.hotels.updateOne(
  { name: "Mountain Retreat" },
  { $unset: { amenities: 1 } }
);
```

---

## 6. Screenshot of Hotel Entries with Amenities Removed from One Hotel

**Description:** The following screenshot shows one hotel with its amenities removed while others still have them.

![Screenshot 3: Hotel with amenities removed](screenshot3.png)

Run this command to confirm:

```js
db.hotels.find().pretty();
```

---

## 7. Submission Instructions

Ensure you submit a document containing the following:

- **Screenshot 1**: Initial hotel entry (before adding amenities)
- **Screenshot 2**: Hotel entries with amenities added
- **Screenshot 3**: Hotel entries with amenities removed from one hotel

Submit the file in a format compatible with the digital classroom (e.g., Microsoft Word or PDF).
