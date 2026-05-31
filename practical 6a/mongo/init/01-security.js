db = db.getSiblingDB("myapp");

db.createRole({
  role: "myAppRole",
  privileges: [
    {
      resource: { db: "myapp", collection: "customers" },
      actions: ["find", "insert", "update", "remove"]
    }
  ],
  roles: []
});

db.createUser({
  user: "appUser",
  pwd: "appStrongPwd",
  roles: [
    { role: "myAppRole", db: "myapp" }
  ]
});

db.customers.insertOne({
  name: "Student One",
  city: "Phuntsholing",
  createdBy: "init script"
});
