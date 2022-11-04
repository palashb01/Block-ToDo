const Web3 = require("web3");
const Provider = require("@truffle/hdwallet-provider");
require("dotenv").config();

const TODO_CONTRACT = require("../artifacts/Todo.json");

const privateKey = process.env.PRIVATE_KEY;
const URI = process.env.RPC_URI;

module.exports = initializeWeb3 = async () => {
  const web3 = new Web3(new Provider(privateKey, URI));
  const contract = await new web3.eth.Contract(
    TODO_CONTRACT.abi,
    TODO_CONTRACT.address
  );
  web3.eth.defaultAddress = "0x068Cea44Af30066b1f8dE4AbAc12a749d9ddaE26";

  return { contract, web3 };
};
