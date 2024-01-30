// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title IDNZCreditWallet
/// @dev Interface for DNZ DeFi Credit Card System, outlining essential functionalities.
interface IDNZCreditWallet {
    /// @notice Issue credit to a specified user.
    /// @param user The address of the user to whom the credit is issued.
    /// @param amount The amount of credit issued.
    function issueCredit(address user, uint256 amount) external;

    /// @notice Allows users to make payments towards their utilized credit.
    /// @param user The address of the user making the payment.
    /// @param amount The amount being paid.
    function makePayment(address user, uint256 amount) external;

    /// @notice Sets the interest rate.
    /// @param _interestRate The new interest rate in basis points.
    function setInterestRate(uint256 _interestRate) external;

    /// @notice Sets the late payment fee.
    /// @param _latePaymentFee The new late payment fee in basis points.
    function setLatePaymentFee(uint256 _latePaymentFee) external;

    /// @notice Sets the grace period.
    /// @param _gracePeriod The new grace period in seconds.
    function setGracePeriod(uint256 _gracePeriod) external;

    /// @notice Sets the freeze period.
    /// @param _freezePeriod The new freeze period in seconds.
    function setFreezePeriod(uint256 _freezePeriod) external;
}
