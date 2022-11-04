const ethers = require("ethers");
const crypto = require("crypto");

module.exports = generateAddress = () => {
  return new ethers.Wallet("0x" + crypto.randomBytes(32).toString("hex"))
    .address;
};
