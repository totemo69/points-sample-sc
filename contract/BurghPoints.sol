// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.8.0;

import "./SafeMath.sol";

contract Points {
  using SafeMath for uint256;
  
  enum PointsTypes { Cash, Loyal }
  
  // An `address` is comparable to an email address - it's used to identify an account on Ethereum.
  // Addresses can represent a smart contract or an external (user) accounts.
  // Learn more: https://solidity.readthedocs.io/en/v0.5.10/types.html#address
  address public owner;

  // A `mapping` is essentially a hash table data structure.
  // This `mapping` assigns an unsigned integer (the token balance) to an address (the token holder).
  // Learn more: https://solidity.readthedocs.io/en/v0.5.10/types.html#mapping-types
  mapping (address => uint) public CashBalances;
  mapping (address => uint) public LoyalBalances;

  uint256 private _totalSupply;
  // Events allow for logging of activity on the blockchain.
  // Ethereum clients can listen for events in order to react to contract state changes.
  // Learn more: https://solidity.readthedocs.io/en/v0.5.10/contracts.html#events
  event Transfer(address from, address to, uint amount);

  // Initializes the contract's data, setting the `owner`
  // to the address of the contract creator.
  constructor() {
    // All smart contracts rely on external transactions to trigger its functions.
    // `msg` is a global variable that includes relevant data on the given transaction,
    // such as the address of the sender and the ETH value included in the transaction.
    // Learn more: https://solidity.readthedocs.io/en/v0.5.10/units-and-global-variables.html#block-and-transaction-properties
    owner = msg.sender;
  }

  // Burn an amount of new tokens and sends them to an address.
  function burn(address account, uint amount, PointsTypes pointstype) public {
    // `require` is a control structure used to enforce certain conditions.
    // If a `require` statement evaluates to `false`, an exception is triggered,
    // which reverts all changes made to the state during the current call.
    // Learn more: https://solidity.readthedocs.io/en/v0.5.10/control-structures.html#error-handling-assert-require-revert-and-exceptions

    // Only the contract owner can call this function
    require(msg.sender == owner, "You are not the owner.");

    // Ensures a maximum amount of tokens
    require(amount < 1e60, "Maximum issuance succeeded");

    // Decrease the balance of `account` by `amount`
    if (pointstype == PointsTypes.Cash) {
      require(amount <= CashBalances[account], "Insufficient Cash Points balance.");
      CashBalances[account] = CashBalances[account].sub(amount);
    } else if (pointstype == PointsTypes.Loyal) {
      require(amount <= LoyalBalances[account], "Insufficient Loyal Points balance.");
      LoyalBalances[account] = LoyalBalances[account].sub(amount);
    }
    
    _totalSupply = _totalSupply.sub(amount);
    emit Transfer(account, address(0), amount);
  }
  
  // Creates an amount of new tokens and sends them to an address.
  function mint(address account, uint amount, PointsTypes pointstype) public {
    // `require` is a control structure used to enforce certain conditions.
    // If a `require` statement evaluates to `false`, an exception is triggered,
    // which reverts all changes made to the state during the current call.
    // Learn more: https://solidity.readthedocs.io/en/v0.5.10/control-structures.html#error-handling-assert-require-revert-and-exceptions

    // Only the contract owner can call this function
    require(msg.sender == owner, "You are not the owner.");

    // Ensures a maximum amount of tokens
    require(amount < 1e60, "Maximum issuance succeeded");
    
    if (pointstype == PointsTypes.Cash) {
      CashBalances[account] = CashBalances[account].add(amount);
    } else if (pointstype == PointsTypes.Loyal) {
      LoyalBalances[account] = LoyalBalances[account].add(amount);
    }
    // Increases the total supply
    _totalSupply = _totalSupply.add(amount);
    // Emits the event defined earlier
    emit Transfer(address(0), account, amount);
  }

  // Sends an amount of existing tokens from any caller to an address.
  function transfer(address receiver, address sender, uint amount, PointsTypes pointstype) public {

    if (pointstype == PointsTypes.Cash) {

      // The sender must have enough tokens to send
      require(amount <= CashBalances[sender], "Insufficient balance.");

      // Adjusts token balances of the two addresses
      CashBalances[receiver] = CashBalances[receiver].add(amount);
      CashBalances[sender] = CashBalances[sender].sub(amount);
    } else if (pointstype == PointsTypes.Loyal) {

      // The sender must have enough tokens to send
      require(amount <= LoyalBalances[sender], "Insufficient balance.");

      // Adjusts token balances of the two addresses
      LoyalBalances[receiver] = LoyalBalances[receiver].add(amount);
      LoyalBalances[sender] = LoyalBalances[sender].sub(amount);
    }

    // Emits the event defined earlier
    emit Transfer(msg.sender, receiver, amount);
  }
  
  function totalSupply() public view returns (uint256) {
    return _totalSupply;
  }
}