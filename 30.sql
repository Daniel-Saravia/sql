db.customers.find(
  { accounts: { $elemMatch: { $gte: 300000, $lt: 400000 } } }
).sort(
  { name: 1 }
).limit(2);
