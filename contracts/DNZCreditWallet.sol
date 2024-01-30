// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC777/ERC777Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "../abstracts/DNZCreditWalletBase.sol";

/// @title DNZCreditWallet
/// @dev Implements a DeFi credit card system using DNZ tokens with upgradeable functionality.
contract DNZCreditWallet is Initializable, ERC777Upgradeable, OwnableUpgradeable, ReentrancyGuardUpgradeable, UUPSUpgradeable, DNZCreditWalletBase {
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

    /// @notice Initializes the contract with DNZ tokens, default operators, and system parameters.
    /// @param initialSupply Initial supply of DNZ tokens.
    /// @param defaultOperators Addresses that are allowed to operate on behalf of any token holder.
    function initialize(uint256 initialSupply, address[] memory defaultOperators) public initializer {
        __ERC777_init("DNZToken", "DNZ", defaultOperators);
        __Ownable_init();
        __ReentrancyGuard_init();
        __UUPSUpgradeable_init();

        _mint(_msgSender(), initialSupply, "", "");
        interestRate = 200; // Default to 2%
        latePaymentFee = 200; // Default to 2%
        gracePeriod = 15 days;
        freezePeriod = 30 days;
    }

    /// @notice Ensures only the owner can upgrade the contract.
    /// @param newImplementation The address of the new contract implementation.
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    /// @notice Issue credit to the specified user.
    /// @dev Only callable by the owner.
    /// @param user The address of the user to whom the credit is issued.
    /// @param amount The amount of credit issued.
    function issueCredit(address user, uint256 amount) public override onlyOwner {
        require(!isFrozen[user], "Account is frozen");
        require(creditLine[user] - utilizedCredit[user] >= amount, "Amount exceeds credit line");

        utilizedCredit[user] += amount;
        _mint(user, amount, "", "");
        emit CreditIssued(user, amount);
    }

    /// @notice Allows users to make payments towards their utilized credit.
    /// @dev Implements reentrancy guard for security.
    /// @param user The address of the user making the payment.
    /// @param amount The amount being paid.
    function makePayment(address user, uint256 amount) public override nonReentrant {
        require(balanceOf(user) >= amount, "Insufficient balance to make payment");
        require(utilizedCredit[user] >= amount, "Payment exceeds utilized credit");

        _burn(user, amount, "", "");
        utilizedCredit[user] -= amount;
        lastPaymentDate[user] = block.timestamp;
        emit PaymentMade(user, amount);
    }

    /// @notice Sets the interest rate for the credit card system.
    /// @dev Only callable by the owner.
    /// @param _interestRate The new interest rate in basis points.
    function setInterestRate(uint256 _interestRate) public override onlyOwner {
        interestRate = _interestRate;
    }

    /// @notice Sets the late payment fee.
    /// @dev Only callable by the owner.
    /// @param _latePaymentFee The new late payment fee in basis points.
    function setLatePaymentFee(uint256 _latePaymentFee) public override onlyOwner {
        latePaymentFee = _latePaymentFee;
    }

    /// @notice Sets the grace period before late fees apply.
    /// @dev Only callable by the owner.
    /// @param _gracePeriod The new grace period in seconds.
    function setGracePeriod(uint256 _gracePeriod) public override onlyOwner {
        gracePeriod = _gracePeriod;
    }

    /// @notice Sets the period after which accounts are frozen for non-payment.
    /// @dev Only callable by the owner.
    /// @param _freezePeriod The new freeze period in seconds.
    function setFreezePeriod(uint256 _freezePeriod) public override onlyOwner {
        freezePeriod = _freezePeriod;
    }

    // I will add additional functions and implementation details as needed... TBC
}
