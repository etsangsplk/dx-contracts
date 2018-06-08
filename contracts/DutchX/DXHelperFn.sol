pragma solidity ^0.4.19;

import "./DXAuctionsStorage.sol";
import "./DXMath.sol";
import "./DXEvents.sol";
import "./DXConstants.sol";

contract DXHelperFn is DXAuctionsStorage, DXMath, DXEvents, DXConstants {
	// > Helper fns
    function getTokenOrder(
        address token1,
        address token2
    )
        public
        pure
        returns (address, address)
    {
        if (token2 < token1) {
            (token1, token2) = (token2, token1);
        }

        return (token1, token2);
    }

    function setAuctionStart(
        address token1,
        address token2,
        uint value
    )
        internal
    {
        (token1, token2) = getTokenOrder(token1, token2);        
        uint auctionStart = now + value;
        uint auctionIndex = latestAuctionIndices[token1][token2];
        auctionStarts[token1][token2] = auctionStart;
        AuctionStartScheduled(token1, token2, auctionIndex, auctionStart);
    }

    function resetAuctionStart(
        address token1,
        address token2
    )
        internal
    {
        (token1, token2) = getTokenOrder(token1, token2);
        if (auctionStarts[token1][token2] != AUCTION_START_WAITING_FOR_FUNDING) {
            auctionStarts[token1][token2] = AUCTION_START_WAITING_FOR_FUNDING;
        }
    }

    function getAuctionStart(
        address token1,
        address token2
    )
        public
        view
        returns (uint auctionStart)
    {
        (token1, token2) = getTokenOrder(token1, token2);
        auctionStart = auctionStarts[token1][token2];
    }

    function setAuctionIndex(
        address token1,
        address token2
    )
        internal
    {
        (token1, token2) = getTokenOrder(token1, token2);
        latestAuctionIndices[token1][token2] += 1;
    }


    function getAuctionIndex(
        address token1,
        address token2
    )
        public
        view
        returns (uint auctionIndex) 
    {
        (token1, token2) = getTokenOrder(token1, token2);
        auctionIndex = latestAuctionIndices[token1][token2];
    }
}