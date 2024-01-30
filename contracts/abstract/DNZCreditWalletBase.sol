// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interface/IDNZCreditWallet.sol";

/// @title DNZCreditWalletBase
/// @dev Abstract contract for DNZ DeFi Credit Card System providing base functionalities.
abstract contract DNZCreditWalletBase is IDNZCreditWallet {
    mapping(address => uint256) public creditLine;
    mapping(address => uint256) public utilizedCredit;
    mapping(address => uint256) public lastPaymentDate;
    mapping(address => bool) public isFrozen;

    uint256 public interestRate;
    uint256 public latePaymentFee;
    uint256 public gracePeriod;
    uint256 public freezePeriod;

    event CreditIssued(address indexed user, uint256 amount);
    event PaymentMade(address indexed user, uint256 amount);
    event InterestApplied(address indexed user, uint256 interestAmount);
    event AccountFrozen(address indexed user);
    event AccountUnfrozen(address indexed user);
}
