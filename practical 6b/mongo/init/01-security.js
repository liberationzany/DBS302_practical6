db = db.getSiblingDB("myapp6b");

db.createRole({
  role: "myApp6bRole",
  privileges: [
    {
      resource: { db: "myapp6b", collection: "customers" },
      actions: ["find", "insert", "update", "remove"]
    }
  ],
  roles: []
});

db.createUser({
  user: "appUser6b",
  pwd: "appStrongPwd6b",
  roles: [
    { role: "myApp6bRole", db: "myapp6b" }
  ]
});

db.customers.insertOne({
  name: "Student One",
  city: "Phuntsholing",
  createdBy: "practical 6b init script"
});
