// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title RiddlerToken
/// @notice Simple ERC20 token, initial mint, and owner-only mint function.
contract RiddlerToken is ERC20, Ownable {
    constructor(uint256 initialSupply) ERC20("RiddlerToken", "RDLR") Ownable(msg.sender) {
        _mint(msg.sender, initialSupply);
    }

    /// @notice Allows the owner to mine additional tokens
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }
}