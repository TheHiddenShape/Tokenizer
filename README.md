# Tokenizer - RiddlerToken ERC20

## An Overview of the Smart Contract
This project implements the RiddlerToken, an ERC20 token built using the OpenZeppelin standard contracts library. The project is developed with the latest version of Hardhat framework and utilizes Ignition with Viem for smart contract deployment. The project is configurated to be deployed on the Sepolia test network through [Alchemy](https://www.alchemy.com/) infrastructure.

It includes standard ERC20 functionality (token transfers, allowance management, balance queries), supply management with a 1M token hard cap, owner-controlled minting, and token burning capabilities. Access control is enforced through the Ownable pattern, ensuring only the contract owner can mint new tokens while respecting the maximum supply limit.

```ts
// SPDX-License-Identifier: MIT
pragma  solidity ^0.8.20;

import  "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import  "@openzeppelin/contracts/access/Ownable.sol";
import  "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

/// @title RiddlerToken
/// @notice Simple ERC20 token, initial mint, and owner-only mint function.
contract  RiddlerToken is ERC20, ERC20Burnable, Ownable {
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
```

## Prerequisites

-   Node.js (v22.10.0 or a later LTS version)
-   npm package manager
-   Alchemy API key for Sepolia testnet
-   Private key for deployment wallet with Sepolia ETH
- Metamask Extension / App

### Faucets
You must have at least **0.001 ETH** in your MetaMask wallet on the Ethereum mainnet in order to use faucets.

https://cloud.google.com/application/web3/faucet/ethereum/sepolia
https://www.alchemy.com/faucets/ethereum-sepolia

## Installation & Configuration

The project includes the following key packages:
-   Hardhat 3
-   OpenZeppelin Contracts
-   Hardhat Ignition
-   Viem
-   Additional Hardhat plugins for testing and verification

```bash
npm install
```

The project is configured to work with the Sepolia testnet through Alchemy. Ensure your environment variables are properly set:

```bash
SEPOLIA_RPC_URL=[RPC URL]
SEPOLIA_PRIVATE_KEY=[PRIVATE KEY]
```

## Testing



```bash
# run all tests
npx hardhat test

# run tests with gas reporting
npx hardhat test --gas-reporter

# run tests with coverage analysis
npx hardhat test --coverage
```

https://hardhat.org/docs/guides/gas-statistics

## Deployment

```bash
# compilation & cleaning
npx hardhat compile
npx hardhat clean

# deploy to sepolia testnet
npx hardhat ignition deploy ignition/modules/RiddlerTokenModule.ts --network sepolia

# verify deployment status
npx hardhat ignition status --network sepolia

# interact with sepolia network
npx hardhat console --network sepolia
```

https://hardhat.org/docs/guides/smart-contract-verification
