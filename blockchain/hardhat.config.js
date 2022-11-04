require("dotenv").config();
require("@nomicfoundation/hardhat-toolbox");
require("solidity-coverage");

module.exports = {
  solidity: {
    version: "0.8.17",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  istanbulFolder: "./coverage",
  matrixOutputPath: "./coverage",
  mochaJsonOutputPath: "./coverage",
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {},
    matic: {
      url: `https://rpc-mumbai.maticvigil.com`,
      accounts: [process.env.PRIVATE_KEY],
    },
  },
};
