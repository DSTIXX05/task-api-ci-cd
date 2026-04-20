import type { Task } from "../types/task.js";

const tasks: Task[] = [];
let id = 1;

export const getAll = (): Task[] => tasks;

export const create = (data: Omit<Task, "id">): Task => {
  const newTask: Task = { id: id++, ...data };
  tasks.push(newTask);
  return newTask;
};

export const update = (taskId: number, data: Partial<Task>): Task | null => {
  const index = tasks.findIndex((t) => t.id === taskId);
  if (index === -1) return null;

  const existingTask = tasks[index];
  if (!existingTask) return null;

  const updatedTask: Task = { ...existingTask, ...data, id: existingTask.id };
  tasks[index] = updatedTask;
  return updatedTask;
};

export const remove = (taskId: number): boolean => {
  const index = tasks.findIndex((t) => t.id === taskId);
  if (index === -1) return false;

  tasks.splice(index, 1);
  return true;
};
