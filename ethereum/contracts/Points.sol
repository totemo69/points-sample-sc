// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.8.0;

import "./Context.sol";
import "./SafeMath.sol";
import "./IPoints.sol";

contract Points is Context, IPoints {
  using SafeMath for uint256;
  
  uint256 private _totalSupply;
  string private _name;
  string private _symbol;
  address payable private _owner;
  mapping (address => uint256) private _balances;


  /**
  * @dev Sets the values for {name} and {symbol},
  * Initializes the contract's data, setting the `owner`
  * to the address of the contract creator.
  */
  constructor (string memory name, string memory symbol) public {
    _owner = _msgSender();
    _name = name;
    _symbol = symbol;
  }

  /**
   * @dev Returns the name of the token.
   */
  function name() public view returns (string memory) {
    return _name;
  }

  /**
   * @dev Returns the owner of the contract.
   */
  function owner() public view returns (address payable) {
    return _owner;
  }

  /**
   * @dev Returns the symbol of the token, usually a shorter version of the
   * name.
   */
  function symbol() public view returns (string memory) {
    return _symbol;
  }

  /**
  * @dev See {IPoints-totalSupply}.
  */
  function totalSupply() public view override returns (uint256) {
    return _totalSupply;
  }

  /**
  * @dev See {IPoints-balanceOf}.
  */
  function balanceOf(address account) public view override returns (uint256) {
    return _balances[account];
  }

  /**
  * @dev See {IPoints-transfer}.
  *
  * Requirements:
  *
  * - `recipient` cannot be the zero address.
  * - the caller must have a balance of at least `amount`.
  */
  function transfer(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
      _transfer(sender, recipient, amount);
      return true;
  }

  /**
  * @dev See {IPoints-mint}.
  *
  * Requirements:
  *
  * - `recipient` cannot be the zero address.
  * - the caller must have a balance of at least `amount`.
  */
  function mint(address recipient, uint256 amount) public virtual override returns (bool) {
      _mint(recipient, amount);
      return true;
  }

  /**
  * @dev See {IPoints-burn}.
  *
  * Requirements:
  *
  * - `recipient` cannot be the zero address.
  * - the caller must have a balance of at least `amount`.
  */
  function burn(address recipient, uint256 amount) public virtual override returns (bool) {
      _burn(recipient, amount);
      return true;
  }

  /**
    * @dev Destroys `amount` tokens from `account`, reducing the
    * total supply.
    *
    * Emits a {Transfer} event with `to` set to the zero address.
    *
    * Requirements:
    *
    * - `account` cannot be the zero address.
    * - `account` must have at least `amount` tokens.
    */
  function _burn(address account, uint amount) internal virtual {

    // Only the contract owner can call this function
    require(_msgSender() == owner(), "You are not the owner.");

    require(account != address(0), "ERC20: burn from the zero address");

    _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
    _totalSupply = _totalSupply.sub(amount);

    emit Transfer(account, address(0), amount);
  }
  
  /** @dev Creates `amount` tokens and assigns them to `account`, increasing
   * the total supply.
   *
   * Emits a {Transfer} event with `from` set to the zero address.
   *
   * Requirements:
   *
   * - `to` cannot be the zero address.
   */
  function _mint(address account, uint256 amount) internal virtual {

    // Only the contract owner can call this function
    require(_msgSender() == owner(), "You are not the owner.");

    require(account != address(0), "ERC20: mint to the zero address");

    _totalSupply = _totalSupply.add(amount);
    _balances[account] = _balances[account].add(amount);
    emit Transfer(address(0), account, amount);
  }


  /**
    * @dev Moves tokens `amount` from `sender` to `recipient`.
    *
    * This is internal function is equivalent to {transfer}, and can be used to
    * e.g. implement automatic token fees, slashing mechanisms, etc.
    *
    * Emits a {Transfer} event.
    *
    * Requirements:
    *
    * - `sender` cannot be the zero address.
    * - `recipient` cannot be the zero address.
    * - `sender` must have a balance of at least `amount`.
    */
  function _transfer(address sender, address recipient, uint256 amount) internal virtual {
    require(sender != address(0), "ERC20: transfer from the zero address");
    require(recipient != address(0), "ERC20: transfer to the zero address");

    _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
    _balances[recipient] = _balances[recipient].add(amount);
    emit Transfer(sender, recipient, amount);
  }

}