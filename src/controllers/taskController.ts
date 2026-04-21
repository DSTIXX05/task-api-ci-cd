import { type Request, type Response } from "express";
import * as service from "../services/taskServices.js";

export const getTasks = (req: Request, res: Response) => {
  res.json(service.getAll());
};

export const createTask = (req: Request, res: Response) => {
  const task = service.create(req.body);
  res.status(201).json(task);
};

export const updateTask = (req: Request, res: Response) => {
  const updated = service.update(Number(req.params.id), req.body);
  if (!updated) return res.status(404).json({ error: "Task not found" });
  res.json(updated);
};

export const deleteTask = (req: Request, res: Response) => {
  const deleted = service.remove(Number(req.params.id));
  if (!deleted) return res.status(404).json({ error: "Task is not found" });
  res.status(204).send();
};
