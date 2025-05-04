-include .env

build:; forge build

test:; forge test

anvil:; anvil

clean:; forge clean

install :; forge install cyfrin/foundry-devops@0.2.2 --no-commit && forge install smartcontractkit/chainlink-brownie-contracts@1.1.1 --no-commit && forge install foundry-rs/forge-std@v1.8.2 --no-commit

deploy:
	@forge script script/DeployFundMe.s.sol:DeployFundMe $(NETWORK_ARGS)
NETWORK_ARGS := --rpc-url http://localhost:8545 --account defaultKey --sender $(ANVIL_WALLET_ADDRESS) --password-file .password --broadcast -vvvv --slow

ifneq (,$(findstring sepolia,$(MAKECMDGOALS)))
	NETWORK_ARGS := --rpc-url $(SEPOLIA_RPC_URL) --account devKey --sender $(ETN_WALLET_ADDRESS) --password-file .password --broadcast -vvvv --slow
endif

deploy-sepolia:
	@forge script script/DeployFundMe.s.sol:DeployFundMe $(NETWORK_ARGS) --verify --etherscan-api-key $(ETHERSCAN_API_KEY)

fund:
	@forge script script/Interactions.s.sol:FundFundMe $(NETWORK_ARGS)

withdraw:
	@forge script script/Interactions.s.sol:WithdrawFundMe $(NETWORK_ARGS)

sepolia:
	NETWORK=sepolia
