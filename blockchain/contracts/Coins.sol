// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

error Coins__InsufficientBalance(address account, uint256 balance);

contract Coins {
    /* State Variables */
    uint256 private coins;

    mapping(address => uint256) private coinsPerAccount;

    /* Events */
    event TransferCoin(address indexed to, uint256 indexed amount);
    event SpentCoin(address indexed from, uint256 indexed amount);

    /* Functions */
    constructor() {
        coins = 0;
    }

    function transfer(address to, uint256 amount) public {
        coinsPerAccount[to] += amount;
        coins += amount;

        emit TransferCoin(to, amount);
    }

    function spendCoins(address from, uint256 amount) public {
        if(coinsPerAccount[from] < amount) {
            revert Coins__InsufficientBalance(from, coinsPerAccount[from]);
        }

        coinsPerAccount[from] -= amount;

        emit SpentCoin(from, amount);
    }

    /* Getter */
    function getBalance(address _account) public view returns (uint256) {
        return coinsPerAccount[_account];
    }

    function totalMinted() public view returns (uint256) {
        return coins;
    }
}
