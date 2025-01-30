db.customers.find(
  { accounts: { $elemMatch: { $regex: "^3" } } } // Find docs with an account that starts with "3"
).sort(
  { name: 1 } // Sort by first name in ascending order
).limit(2); // Select only two documents
