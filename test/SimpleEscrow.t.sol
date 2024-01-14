// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "ds-test/test.sol";
import "../src/SimpleEscrow.sol"; // Adjust the path according to your project structure

contract SimpleEscrowTest is DSTest {
    SimpleEscrow escrow;
    address payable testAddress;

    function setUp() public {
        escrow = new SimpleEscrow();
        testAddress = payable(address(0x123)); // Example test address
    }

    function testDeposit() public {
        // Arrange
        uint256 depositAmount = 1 ether;

        // Act
        payable(address(escrow)).transfer(depositAmount);

        // Assert
        assertEq(escrow.escrowBalances(address(this)), depositAmount, "Deposit amount does not match");
    }

    function testFailDepositZeroAmount() public {
        // Should fail
        payable(address(escrow)).transfer(0);
    }
}
