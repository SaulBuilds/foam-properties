// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleEscrow {
    mapping(address => uint256) public escrowBalances;
    event Deposit(address indexed sender, uint256 amount);

    // Function to deposit funds into escrow
    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        escrowBalances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    // Fallback function for non-empty data transactions
    fallback() external payable {
        deposit();
    }

    // Receive function for plain Ether transfers
    receive() external payable {
        deposit();
    }
}