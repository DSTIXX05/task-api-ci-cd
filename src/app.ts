import express from "express";
import cors from "cors";
import taskRoutes from "./routes/taskRoutes.js";

const app = express();

app.use(cors());
app.use(express.json());

app.get("/health", (_req, res) => {
  res.status(200).json({ status: "OK" });
});

app.get("/version", (_req, res) => {
  res.json({ version: "1.0.0" });
});

app.use("/tasks", taskRoutes);

export default app;
