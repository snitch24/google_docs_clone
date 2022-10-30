const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const authRouter = require( "./routes/auth" );
const documentRouter = require( "./routes/document" );

//When hosted it returns process.env.port else it returns 3001
const PORT = process.env.PORT | 3001;

//Initialise
const app = express();
app.use(cors());
app.use(express.json());
app.use(authRouter);
app.use(documentRouter);
const DB =
  "mongodb+srv://snitch:snitch24@cluster0.ocehsbj.mongodb.net/?retryWrites=true&w=majority";

//Establish Connection
mongoose
  .connect(DB)
  .then(() => {
    console.log("Connection Succcesful");
  })
  .catch((err) => {
    console.log(err);
  });

//Helps listen conitnously to server
app.listen(PORT, "0.0.0.0", () => {
  console.log(`Connected at port ${PORT}`);
});
