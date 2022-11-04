const hre = require("hardhat");
const fse = require("fs-extra");
const path = require("path");

const main = async () => {
  const CoinsFactory = await hre.ethers.getContractFactory("Coins");
  const coin = await CoinsFactory.deploy();

  await coin.deployed();
  console.log(`Coins contract deployed at address ${coin.address}`);

  fse.outputFileSync(
    path.join(__dirname, "../", "deployment-logs/Coins.json"),
    JSON.stringify(coin)
  );
};

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
