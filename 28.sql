# MongoDB Queries for `accounts` Collection

## 1. Display All Documents in the Collection
```javascript
db.accounts.find({});
```

This query retrieves every document (including all fields) in the `accounts` collection.

---

## 2. Display Specific Fields: `account_id`, `limit`, and `products`
```javascript
db.accounts.find(
  {},
  {
    account_id: 1,
    limit: 1,
    products: 1,
    _id: 0 // optional, to hide the _id field
  }
);
```

- The first argument `{}` matches all documents.
- The second argument specifies the **projection** to include `account_id`, `limit`, and `products`, while excluding `_id`.

---

## 3. Display `account_id` and `products` Where One of the Products is `Derivatives`
```javascript
db.accounts.find(
  { products: "Derivatives" },
  {
    account_id: 1,
    products: 1,
    _id: 0
  }
);
```

- `{ products: "Derivatives" }` matches documents where the `products` array contains the string `"Derivatives"`.
- The projection includes only `account_id` and `products` while excluding `_id`.
