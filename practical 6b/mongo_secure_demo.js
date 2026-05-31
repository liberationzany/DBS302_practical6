const { MongoClient } = require("mongodb");

async function main() {
  const uri = "mongodb://appUser6b:appStrongPwd6b@127.0.0.1:27018/myapp6b?tls=true";
  const client = new MongoClient(uri, {
    tlsCAFile: "./certs/mongo/ca.crt",
  });

  try {
    await client.connect();
    console.log("Connected to MongoDB with TLS and auth");

    const db = client.db("myapp6b");
    const customers = db.collection("customers");

    await customers.insertOne({ name: "Node Client 6b", city: "Phuntsholing" });
    const docs = await customers.find({}, { projection: { _id: 0 } }).toArray();
    console.log("Customers:", docs);
  } finally {
    await client.close();
  }
}

main().catch(console.error);
