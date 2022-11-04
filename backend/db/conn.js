const mongoose = require("mongoose");
require('dotenv').config();

const DB =
  process.env.MONGO_URI;
mongoose
  .connect(DB)
  .then(() => {
    console.log("connection successful");
  })
  .catch((err) => console.error(err));
