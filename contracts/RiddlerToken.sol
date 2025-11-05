// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

/// @title RiddlerToken
/// @notice Simple ERC20 token, initial mint, and owner-only mint function.
contract RiddlerToken is ERC20, ERC20Burnable, Ownable {
    uint256 public constant MAX_SUPPLY = 1_000_000 * 10**18;
    
    constructor(uint256 initialSupply) ERC20("RiddlerToken", "RDLR") Ownable(msg.sender) {
        require(initialSupply <= MAX_SUPPLY, "Exceeds max supply");
        _mint(msg.sender, initialSupply);
    }

    /// @notice Allows the owner to mine additional tokens
    function mint(address to, uint256 amount) external onlyOwner {
        require(totalSupply() + amount <= MAX_SUPPLY, "Would exceed max supply");
        _mint(to, amount);
    }
}