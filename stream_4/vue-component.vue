<script setup lang="ts">
import { useAuth } from "vue-clerk";
import { getDb } from "./database";

const { getToken } = useAuth();

const surrealLogin = async () => {
  let db = await getDb(await getToken.value());
  try {
    let result = await db.query("SELECT * FROM $auth.id");
    console.log(result[0]);
  } catch (error) {
    console.error(JSON.stringify(error));
  }
};
</script>

<template>
  <button @click="surrealLogin">Login to DB</button>
</template>
