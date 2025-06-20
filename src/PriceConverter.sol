// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

/**
 * @title PriceConverter library
 * @author Alexander Scherbatyuk
 * @notice This library is used for calculating ETH amounts in USD
 */
library PriceConverter {
    /**
     * @dev This function calls the Chainlink data feed aggregation contract to fetch the ETH/USD price.
     * https://docs.chain.link/data-feeds/price-feeds/addresses
     * @param priceFeed The PriceFeed AggregatorV3Interface contract
     */
    function getPrice(AggregatorV3Interface priceFeed) internal view returns (uint256) {
        (, int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer * 10000000000);
    }

    /**
     * @dev This function converts an ETH amount to its USD equivalent using the current ETH/USD price.
     * It first fetches the current ETH price from the Chainlink price feed, then calculates the USD value.
     * @param ethAmount The amount of ETH to convert (in wei)
     * @param priceFeed The PriceFeed AggregatorV3Interface contract
     * @return The USD equivalent of the ETH amount (with 8 decimal places)
     */
    function getConversionRate(uint256 ethAmount, AggregatorV3Interface priceFeed) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        return ethAmountInUsd;
    }
}
