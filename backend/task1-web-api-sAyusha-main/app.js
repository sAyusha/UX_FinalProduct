require("dotenv").config();
const express = require("express");
const mongoose = require("mongoose");
const path = require("path");
const morgan = require("morgan");
const cookieParser = require("cookie-parser");
const mongoSanitize = require("express-mongo-sanitize"); // for sql injection
const helmet = require("helmet");
const xss = require("xss-clean");
const bodyParser = require("body-parser");
// const cors = require("cors");

// Route files
const userRoutes = require("./routes/user_routes");
const artRoutes = require("./routes/art_routes");
const orderRoutes = require("./routes/order_routes");
const bidRoutes = require("./routes/bid_routes");
const { verifyUser } = require("./middlewares/auth");
const cors = require("cors");

const MONGODB_URI =
  process.env.NODE_ENV === "test"
    ? process.env.TEST_DB_URI
    : process.env.DB_URI;

mongoose
  .connect(MONGODB_URI)
  .then(() => {
    console.log(`connected to ${MONGODB_URI}`);
  })
  .catch((err) => console.log(err));

const app = express();

app.use(cors());

app.use(express.static("public"));

app.disable("etag");

// Dev logging middleware
if (process.env.NODE_ENV === "development") {
  app.use(morgan("dev"));
}

app.use(express.json());

app.get("/", (req, res) => {
  res.send("Hello Node");
});

app.use("/api/users", userRoutes);
app.use("/api/arts", verifyUser, artRoutes);
app.use("/api/bids", verifyUser, bidRoutes);
app.use("/api/orders", verifyUser, orderRoutes);
// app.use(verifyUser);

//error handling middlewares
app.use((err, req, res, next) => {
  console.error(err);
  if (err.name === "ValidationError") res.status(400);
  else if (err.name === "CastError") res.status(400);
  res.json({ error: err.message });
});

//unknown path
app.use((req, res) => {
  res.status(404).json({ error: "path not found" });
});

module.exports = app;