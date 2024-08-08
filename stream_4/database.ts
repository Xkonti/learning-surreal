import { Surreal } from "surrealdb.js";
let db: Surreal | undefined;

export async function getDb(token: string): Promise<Surreal | undefined> {
  if (db) return db;
  let database = new Surreal();
  try {
    await database.connect('http://localhost:8000/rpc', {
      prepare: async (connection) => {
        await connection.use({ namespace: "dev", database: "xkontitech" });
        await connection.authenticate(token);
      },
    });
    db = database;
    return db;
  } catch (err) {
    console.error("Failed to connect to SurrealDB:", err.message);
    throw err;
  }
}

export async function closeDb(): Promise<void> {
  if (!db) return;
  await db.close();
  db = undefined;
}
