# MongoDB Queries for JSON Data

## JSON Data Example
```json
{
    "name": "Reuben Dudley",
    "phone": "(180) 878-6426",
    "email": "magna.praesent@icloud.com"
}
```

---

## 1. Create a New Document (Clone)
This creates a new document with the same fields but different data.

```javascript
db.users.insertOne({
    name: "Reuben Dudley",
    phone: "(180) 878-6426",
    email: "magna.praesent@icloud.com"
});
```

---

## 2. Create a New Document (Copy)
If you want to copy an existing document (find it first, then insert it with changes):

```javascript
const user = db.users.findOne({ email: "magna.praesent@icloud.com" });
if (user) {
    db.users.insertOne({
        name: user.name,
        phone: user.phone,
        email: user.email + ".copy" // Example: adding ".copy" to differentiate
    });
}
```

---

## 3. Filter on One Condition
Find a user with a specific email:

```javascript
db.users.find({ email: "magna.praesent@icloud.com" });
```

---

## 4. Filter on Two Conditions Using AND
Find a user with a specific name **and** phone number:

```javascript
db.users.find({
    name: "Reuben Dudley",
    phone: "(180) 878-6426"
});
```

---

## 5. Filter on Two Conditions Using OR
Find users with a specific name **or** email:

```javascript
db.users.find({
    $or: [
        { name: "Reuben Dudley" },
        { email: "magna.praesent@icloud.com" }
    ]
});
```

---

## 6. Filter Using a Relational Operator
Find users whose names are alphabetically less than "Reuben Dudley":

```javascript
db.users.find({
    name: { $lt: "Reuben Dudley" }
});
```

Find users with phone numbers greater than "(180) 878-6426":

```javascript
db.users.find({
    phone: { $gt: "(180) 878-6426" }
});
```

---

## 7. Update a Document
Update the phone number of the user with a specific email:

```javascript
db.users.updateOne(
    { email: "magna.praesent@icloud.com" },
    { $set: { phone: "(999) 999-9999" } }
);
```

---

## 8. Delete a Document
Delete the user with a specific email:

```javascript
db.users.deleteOne({ email: "magna.praesent@icloud.com" });
```
