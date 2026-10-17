const express = require("express");
const cors = require("cors");
const helmet = require("helmet");
const morgan = require("morgan");
const rateLimit = require("express-rate-limit");

const errorHandler = require("./middleware/errorHandler");

const app = express();

app.use(helmet());
app.use(cors({
  origin: process.env.CLIENT_ORIGIN
    ? process.env.CLIENT_ORIGIN.split(",")
    : true,
}));
app.use(express.json({ limit: "20kb" }));
app.use(morgan("dev"));

app.use(
  "/api/auth",
  rateLimit({
    windowMs: 15 * 60 * 1000,
    limit: 30,
  })
);

app.get("/api/health", (req, res) => {
  res.json({ status: "ok" });
});

app.use("/api/auth", require("./routes/authRoutes"));
app.use("/api/drivers", require("./routes/driverRoutes"));
app.use("/api/rides", require("./routes/rideRoutes"));
app.use("/api/admin", require("./routes/adminRoutes"));
app.use("/api/complaints", require("./routes/complaintRoutes"));

app.use((req, res) => {
  res.status(404).json({ message: "Endpoint not found" });
});

app.use(errorHandler);

module.exports = app;
