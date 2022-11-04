const { expect, assert } = require("chai");

describe("Todo Contract Testing \n--------------------------------------------", () => {
  describe("Testing individually", () => {
    let owner, test1, test2;
    let contract;

    const testTask = "This is a test task";
    const testTaskSecondary = "This is a test task";

    beforeEach(async () => {
      const TodoFactory = await ethers.getContractFactory("Todo");
      [owner, test1, test2] = await ethers.getSigners();

      contract = await TodoFactory.deploy();

      await contract.deployed();
    });

    it("checks the initial setup", async () => {
      assert((await contract.getAllTasks()).length === 0);
      expect(await contract.getTask).to.be.reverted;
    });

    it("creates a task as the owner", async () => {
      const task = await contract.createTask(owner.address.toString(), testTask);
      assert((await contract.getTaskName(0)) == testTask);
      assert(
        (await contract.getTaskOwner(0)).toString() == owner.address.toString()
      );
    });

    it("creates the task as a second account", async () => {
      const task = await contract.connect(test1).createTask(test1.address.toString(), testTaskSecondary);
      assert((await contract.getTaskName(0)) == testTaskSecondary);
      assert(
        (await contract.getTaskOwner(0)).toString() == test1.address.toString()
      );
    });

    it("checks the tasks initial status", async () => {
      const task = await contract.createTask(owner.address.toString(), testTask);
      assert((await contract.getTaskStatus(0)) == false);
    });

    it("checks the toggle task functionality", async () => {
      const task = await contract.createTask(owner.address.toString(), testTask);

      assert((await contract.getTaskStatus(0)) == false);

      await contract.toggleTask(0);
      assert((await contract.getTaskStatus(0)) == true);

      await contract.toggleTask(0);
      assert((await contract.getTaskStatus(0)) == false);
    });

    it("checks the setTask functionality", async () => {
      const task = await contract.createTask(owner.address.toString(), testTask);

      await contract.setTaskStatus(0, true);
      assert((await contract.getTaskStatus(0)) == true);

      await contract.setTaskStatus(0, false);
      assert((await contract.getTaskStatus(0)) == false);
    });

    it("checks the completeTask functionality", async () => {
      const task = await contract.createTask(owner.address.toString(), testTask);

      await contract.completeTask(0);
      assert((await contract.getTaskStatus(0)) == true);
    });

    it("cross verify task with children", async () => {
      const task = await contract.createTask(owner.address.toString(), testTask);

      await contract.completeTask(0);
      assert(
        (await contract.getTaskStatus(0)) ==
          (await contract.getTask(0)).completed
      );
      assert(
        (await contract.getTaskName(0)) == (await contract.getTask(0)).message
      );
    });
  });

  describe("Testing compound", () => {
    let owner, test1, test2;
    let contract;

    const testTask1 = "This is a test task 1";
    const testTask2 = "This is a test task 2";
    const testTask3 = "This is a test task 3";

    before(async () => {
      const TodoFactory = await ethers.getContractFactory("Todo");
      [owner, test1, test2] = await ethers.getSigners();

      contract = await TodoFactory.deploy();

      await contract.deployed();

      const task1 = await contract.createTask(owner.address.toString(), testTask1);
      const task2 = await contract.createTask(owner.address.toString(), testTask2);
    });

    it("create multiple tasks", async () => {
      assert((await contract.getTaskName(0)) == testTask1);
      assert((await contract.getTaskName(1)) == testTask2);
    });

    it("try retreiving all the tasks", async () => {
      const tasks = await contract.getAllTasks();
      
      assert(tasks[0].message == testTask1);
      assert(tasks[1].message == testTask2);
    });
    
    it("tries to retrieve all tasks of a user", async () => {
        const ownerTasks = await contract.getUserTasks(owner.address.toString());
        assert(ownerTasks.length == 2);
        
        await contract.connect(test1).createTask(test1.address.toString(), testTask1);
        const secTasks = await contract.getUserTasks(test1.address.toString());
        assert(secTasks.length == 1);

    });
  });
});
