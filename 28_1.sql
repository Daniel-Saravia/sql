```markdown
# MongoDB Queries for `accounts` Collection (MongoDB Compass Top Bar)

## 1. Display All Documents in the Collection
In the MongoDB Compass **Filter** box (top bar), enter:
```json
{}
```

This retrieves every document (including all fields) in the `accounts` collection.

---

## 2. Display Specific Fields: `account_id`, `limit`, and `products`
In the MongoDB Compass **Filter** box (top bar), enter:
```json
{}
```

Then, in the **Project** box, enter:
```json
{
  "account_id": 1,
  "limit": 1,
  "products": 1,
  "_id": 0
}
```

This displays only the specified fields (`account_id`, `limit`, and `products`) and hides the `_id` field.

---

## 3. Display `account_id` and `products` Where One of the Products is `Derivatives`
In the MongoDB Compass **Filter** box (top bar), enter:
```json
{
  "products": "Derivatives"
}
```

Then, in the **Project** box, enter:
```json
{
  "account_id": 1,
  "products": 1,
  "_id": 0
}
```

This retrieves documents where the `products` array contains `"Derivatives"` and displays only `account_id` and `products` while hiding `_id`.
```
