const { MongoClient } = require("mongodb");

async function main() {
  const uri = "mongodb://appUser:appStrongPwd@127.0.0.1:27017/myapp?tls=true";
  const client = new MongoClient(uri, {
    tlsCAFile: "./certs/mongo/ca.crt",
  });

  try {
    await client.connect();
    console.log("Connected to MongoDB with TLS and auth");

    const db = client.db("myapp");
    const customers = db.collection("customers");

    await customers.insertOne({ name: "Node Client", city: "Phuntsholing" });
    const docs = await customers.find({}, { projection: { _id: 0 } }).toArray();
    console.log("Customers:", docs);
  } finally {
    await client.close();
  }
}

main().catch(console.error);
