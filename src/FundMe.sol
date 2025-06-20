// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

/**
 * @title A simple FundMe contract
 * @author Alexander Scherbatyuk
 * @notice This is a simple crowd fundraising contract
 * @dev This contract utilizes Chainlink price data feed,
 * Price Feed Contract Addresses are available by url below
 * https://docs.chain.link/data-feeds/price-feeds/addresses
 */
contract FundMe {
    /* Errors */
    error FundMe__NotOwner();
    error FundMe__NotEnoughETH();
    error FundMe__CallFailed();

    /* Library */
    using PriceConverter for uint256;

    /* State variables */
    /**
     * @notice Minimum amount of USD required to fund (in wei)
     */
    uint256 public constant MINIMUM_USD = 5 * 10 ** 18;
    /**
     * @notice The owner of the contract who can withdraw funds
     */
    address private immutable i_owner;
    /**
     * @notice The Chainlink price feed contract for ETH/USD conversion
     */
    AggregatorV3Interface private immutable i_priceFeed;
    /**
     * @notice Mapping of funder addresses to their funded amounts
     */
    mapping(address => uint256) private s_addressToAmountFunded;
    /**
     * @notice Array of all funder addresses
     */
    address[] private s_funders;

    /* Events */
    /**
     * @notice Emitted when someone funds the contract
     * @param funder The address that funded the contract
     * @param amount The amount funded in wei
     */
    event Funded(address indexed funder, uint256 amount);
    /**
     * @notice Emitted when funds are withdrawn by the owner
     * @param amount The amount withdrawn in wei
     */
    event FundsWithdrawn(uint256 amount);

    /* Modifiers*/
    /**
     * @notice Modifier to restrict function access to the contract owner
     */
    modifier onlyOwner() {
        if (msg.sender != i_owner) revert FundMe__NotOwner();
        _;
    }

    /**
     * @notice Constructor to initialize the contract with a price feed
     * @param priceFeed The address of the Chainlink price feed contract
     */
    constructor(address priceFeed) {
        i_owner = msg.sender;
        i_priceFeed = AggregatorV3Interface(priceFeed);
    }

    /**
     * @notice Receive function that automatically calls fund() when ETH is sent
     */
    receive() external payable {
        fund();
    }

    /**
     * @notice Fallback function that automatically calls fund() when ETH is sent
     */
    fallback() external payable {
        fund();
    }

    /* External functions */
    /**
     * @notice Allows the owner to withdraw all funds from the contract
     * @dev Resets all funder amounts to 0 and clears the funders array
     * @dev Emits FundsWithdrawn event with the total balance
     */
    function withdraw() external onlyOwner {
        //Effect
        // It would be cheaper than calling storage function in the loop
        uint256 fundersLength = s_funders.length;
        for (uint256 funderIndex = 0; funderIndex < fundersLength; funderIndex++) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
        emit FundsWithdrawn(address(this).balance);

        //Interaction
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");

        if (!callSuccess) {
            revert FundMe__CallFailed();
        }
    }

    /* Public functions */
    /**
     * @notice Allows anyone to fund the contract with ETH
     * @dev Requires the sent amount to be at least MINIMUM_USD when converted
     * @dev Adds the sender to funders array and updates their funded amount
     * @dev Emits Funded event with sender address and amount
     */
    function fund() public payable {
        //Check
        if (msg.value.getConversionRate(i_priceFeed) < MINIMUM_USD) {
            revert FundMe__NotEnoughETH();
        }

        //Effect
        s_addressToAmountFunded[msg.sender] += msg.value;
        s_funders.push(msg.sender);

        emit Funded(msg.sender, msg.value);
    }

    /* External & public view & pure functions */
    /**
     * @notice Gets the version of the Chainlink price feed
     * @return The version number of the price feed contract
     */
    function getVersion() external view returns (uint256) {
        return i_priceFeed.version();
    }

    /**
     * @notice Gets the total amount funded by a specific address
     * @param fundingAddress The address to check funding amount for
     * @return The total amount funded by the address in wei
     */
    function getAddressToAmountFunded(address fundingAddress) external view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    /**
     * @notice Gets the funder address at a specific index
     * @param index The index of the funder in the funders array
     * @return The address of the funder at the specified index
     */
    function getFunder(uint256 index) external view returns (address) {
        return s_funders[index];
    }

    /**
     * @notice Gets the owner address of the contract
     * @return The address of the contract owner
     */
    function getOwner() external view returns (address) {
        return i_owner;
    }
}
