const hre = require("hardhat");
const fse = require("fs-extra");
const path = require("path");

const main = async () => {
  const TodoFactory = await hre.ethers.getContractFactory("Todo");
  const todo = await TodoFactory.deploy();

  await todo.deployed();
  console.log(`Todo contract deployed at address ${todo.address}`);

  fse.outputFileSync(
    path.join(__dirname, "../", "deployment-logs/Todo.json"),
    JSON.stringify(todo)
  );
};

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
