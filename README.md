## Overview

**FundMe is a simple fundraising contract that utilizes Chainlink price data feed in order to fetch ETH/USD price**

## Quickstart
```shell
$ git clone https://github.com/alexscherbatyuk/foundry-fund-me.git
$ cd foundry-fund-me
$ make install
```

## Prerequisites

- [Foundry](https://getfoundry.sh/) installed
- Node.js and npm/yarn (for dependencies)
- An Ethereum wallet with some testnet ETH (for Sepolia deployment)

## Environment Setup

Create a `.env` file in the root directory with the following variables:

```env
SEPOLIA_RPC_URL=your_sepolia_rpc_url
ETN_WALLET_ADDRESS=your_wallet_address
ETHERSCAN_API_KEY=your_etherscan_api_key
ANVIL_WALLET_ADDRESS=your_anvil_wallet_address
```

## Project Structure

```
foundry-fund-me/
├── src/
│   ├── FundMe.sol          # Main fundraising contract
│   └── PriceConverter.sol  # Price conversion utilities
├── script/
│   ├── DeployFundMe.s.sol  # Deployment script
│   ├── Interactions.s.sol  # Interaction scripts
│   └── HelperConfig.s.sol  # Configuration helper
├── test/
│   ├── unit/               # Unit tests
│   ├── integration/        # Integration tests
│   └── mocks/              # Mock contracts for testing
└── lib/                    # Dependencies
```

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

Run specific test files:
```shell
$ forge test --match-contract FundMeTest
```

Run with gas reporting:
```shell
$ forge test --gas-report
```

### Deploy

#### Sepolia

```shell
$ make deploy-sepolia
```

#### Anvil (Local Development)

```shell
$ make deploy
```

### Interact with the deployed contract

#### Fund
##### Anvil (Local)  
```shell
$ make fund
```
##### Sepolia
```shell
$ make sepolia fund
```

#### Withdraw
##### Anvil (Local)
```shell
$ make withdraw
```

##### Sepolia
```shell
$ make sepolia withdraw
```

### Development

Start a local Anvil instance:
```shell
$ make anvil
```

Clean build artifacts:
```shell
$ make clean
```

## Features

- **Chainlink Price Feeds**: Real-time ETH/USD price data
- **Minimum Funding Amount**: Configurable minimum funding threshold
- **Owner Withdrawal**: Only contract owner can withdraw funds
- **Gas Optimization**: Efficient storage and function design
- **Comprehensive Testing**: Unit and integration tests

## Testing

The project includes comprehensive tests covering:
- Unit tests for individual functions
- Integration tests for contract interactions
- Mock contracts for external dependencies

Run the full test suite:
```shell
$ forge test
```

## License

This project is licensed under the MIT License.