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
    uint256 public constant MINIMUM_USD = 5 * 10 ** 18;
    address private immutable i_owner;
    AggregatorV3Interface private immutable i_priceFeed;
    mapping(address => uint256) private s_addressToAmountFunded;
    address[] private s_funders;

    /* Events */
    event Funded(address indexed funder, uint256 amount);
    event FundsWithdrawn(uint256 amount);

    /* Modifiers*/
    modifier onlyOwner() {
        if (msg.sender != i_owner) revert FundMe__NotOwner();
        _;
    }

    constructor(address priceFeed) {
        i_owner = msg.sender;
        i_priceFeed = AggregatorV3Interface(priceFeed);
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    /* External functions */
    function withdraw() external onlyOwner {
        //Effect
        // It would be cheaper than calling storage function in the loop
        uint256 fundersLength = s_funders.length;
        for (
            uint256 funderIndex = 0;
            funderIndex < fundersLength;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
        emit FundsWithdrawn(address(this).balance);

        //Interaction
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");

        if (!callSuccess) {
            revert FundMe__CallFailed();
        }
    }

    /* Public functions */
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
    function getVersion() external view returns (uint256) {
        return i_priceFeed.version();
    }

    function getAddressToAmountFunded(
        address fundingAddress
    ) external view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    function getFunder(uint256 index) external view returns (address) {
        return s_funders[index];
    }

    function getOwner() external view returns (address) {
        return i_owner;
    }
}
