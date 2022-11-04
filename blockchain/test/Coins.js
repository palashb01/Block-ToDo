const { expect, assert } = require("chai");

describe("Coins Contract Testing \n--------------------------------------------", () => {
  let owner, test1, test2;
  let contract;

  beforeEach(async () => {
    const CoinsFactory = await ethers.getContractFactory("Coins");
    [owner, test1, test2] = await ethers.getSigners();

    contract = await CoinsFactory.deploy();

    await contract.deployed();
  });

  it("checks the initial setup", async () => {
    assert((await contract.totalMinted()) == 0);
    assert((await contract.getBalance(owner.address.toString())) == 0);
    assert((await contract.getBalance(test1.address.toString())) == 0);
    assert((await contract.getBalance(test2.address.toString())) == 0);
  });

  it("checks transfer functionality", async () => {
    await contract.transfer(owner.address.toString(), 1000);
    assert((await contract.getBalance(owner.address.toString())) == 1000);

    await contract.transfer(test1.address.toString(), 200);
    assert((await contract.getBalance(test1.address.toString())) == 200);
  });

  it("checks spent functionality", async () => {
    await expect(contract.spendCoins(owner.address, 200))
      .to.be.revertedWithCustomError(contract, "Coins__InsufficientBalance")
      .withArgs(owner.address, 0);

    await contract.transfer(owner.address.toString(), 1000);
    assert((await contract.getBalance(owner.address.toString())) == 1000);

    await contract.spendCoins(owner.address.toString(), 200);
    assert((await contract.getBalance(owner.address.toString())) == 800);
  });

  it("checks the users balance", async () => {
    await contract.transfer(test1.address.toString(), 100);
    assert((await contract.getBalance(test1.address.toString())) == 100);
  });

  it("checks if events are emitted", async () => {
    await expect(contract.transfer(owner.address, 100))
      .to.be.emit(contract, "TransferCoin")
      .withArgs(owner.address, 100);

    await expect(contract.spendCoins(owner.address, 5))
      .to.be.emit(contract, "SpentCoin")
      .withArgs(owner.address, 5);
  });
});
