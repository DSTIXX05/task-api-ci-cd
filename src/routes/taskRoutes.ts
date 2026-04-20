import { Router } from "express";
import * as controller from "../controllers/taskController.js";

const router = Router();

router.get("/", controller.getTasks);
router.post("/", controller.createTask);
router.put("/:id", controller.updateTask);
router.delete("/:id", controller.deleteTask);

export default router;
