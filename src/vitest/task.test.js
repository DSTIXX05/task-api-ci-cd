import request from "supertest";
import { describe, it, expect } from "vitest";
import app from "../../src/app.js";
describe("Task API", () => {
  it("should return health status", async () => {
    const res = await request(app).get("/health");
    expect(res.status).toBe(200);
    expect(res.body.status).toBe("OK");
  });
  it("should create a task", async () => {
    const res = await request(app).post("/tasks").send({ title: "Test task" });
    expect(res.status).toBe(201);
    expect(res.body.title).toBe("Test task");
  });
  it("should fetch tasks", async () => {
    const res = await request(app).get("/tasks");
    expect(res.status).toBe(200);
    expect(Array.isArray(res.body)).toBe(true);
  });
  it("should delete a task", async () => {
    const res = await request(app).delete("/tasks/1");
    expect(res.status).toBe(204);
    expect(res.body).toEqual({});
  });
});
//# sourceMappingURL=task.test.js.map
