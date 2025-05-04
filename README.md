## Overview

**FundMe is a simple fundraising contract that utilizes Chainlink price data feed in order to fetch ETH/USD price**

## Quickstart
```shell
$ git clone https://github.com/Cyfrin/foundry-fund-me-cu
$ cd foundry-fund-me-cu
$ make install
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

### Deploy

#### Sepolia

```shell
$ make deploy-sepolia
```

#### Anvil

```shell
$ make deploy
```

### Interact with the deployed contract

#### Fund
##### anvil  
```shell
$ make fund
```
##### sepolia
```shell
$ make sepolia fund
```

#### Withdraw
##### anvil 
```shell
$ make withdraw
```

##### sepolia
```shell
$ make sepolia fund
```