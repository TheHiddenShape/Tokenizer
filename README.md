# Tokenizer - RiddlerToken ERC20

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## An Overview of the Smart Contract
RiddlerToken is an ERC20 token built using the OpenZeppelin standard contracts library. Development leverages the latest Hardhat framework version and utilizes Ignition with Viem for smart contract deployment. Configuration targets the Sepolia test network through [Alchemy](https://www.alchemy.com/) infrastructure.

ERC-20 is a technical standard for creating fungible token smart contracts on the Ethereum blockchain. The EVM (Ethereum Virtual Machine) executes these contracts identically across all network nodes, ensuring that each transaction modifies the global state in a deterministic and permanent way.

It includes standard functionality (token transfers, allowance management, balance queries), supply management with a 1M token hard cap, owner-controlled minting, and token burning capabilities. Access control is enforced through the Ownable pattern, ensuring only the contract owner can mint new tokens while respecting the maximum supply limit.

> The maximum size for a deployed smart contract on Ethereum is 24 KB (24,576 bytes), introduced with EIP-170.

```ts
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
npx hardhat test --gas-stats

# run tests with coverage analysis
npx hardhat test --coverage
```

For the --gas-stats output, you can calculate the fees (Deployment Cost) using the following formula:

$$
\text{Cost (EUR)} = \frac{\text{Gas Used} \times \text{Gas Price (Gwei)} \times \text{ETH Price (EUR)}}{1\,000\,000\,000}
$$

## Deployment

```bash
# compilation & cleaning
npx hardhat compile
npx hardhat clean

# deploy to sepolia testnet
npx hardhat ignition deploy ignition/modules/RiddlerTokenModule.ts --network sepolia

# verify deployment status
npx hardhat ignition status chain-11155111 --network sepolia

# interact with sepolia network
npx hardhat console --network sepolia
```

## Solidity contract source validation

```bash
# flatten contract for verification & validation on sepolia testnet
npx hardhat flatten > flatten/flattened.sol
```

We use the following in order to verify the smart contract: https://sepolia.etherscan.io/verifyContract
  
Compiler Version: v0.8.28+commit.7893614a  
Optimization Enabled: 1  
Runs: 200

## License

Copyright © 2025 Ammon Netom-El Schiffer
This project is [MIT](LICENSE.md) licensed.
