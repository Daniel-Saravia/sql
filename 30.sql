db.customers.find(
  { accounts: { $elemMatch: { $regex: "^3" } } }
).sort(
  { name: 1 }
).limit(2);
