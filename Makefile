-include .env

build:; forge build

deploy-sepolia:
	@forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(SEPOLIA_RPC_URL) --account devKey --sender $(ETN_WALLET_ADDRESS) --password-file .password --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv --slow

deploy:
	@forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url localhost:8545 --account defaultKey --sender $(ANVIL_WALLET_ADDRESS) --password-file .password --broadcast -vvvv --slow

