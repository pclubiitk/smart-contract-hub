// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.6;

/// @title Dutch Auction Mechanism
/// @author S., Piyush, B.
/// @notice This is a contract implementing the Dutch Auction mechanism.

contract DutchElections {
    event currentPrice(uint256 price, uint256 sharesLeft);
    event bidderWhoWon(address bidder, uint256 numberOfShares);
    event AuctionEnded(uint256 shares_left);

    error notEnoughShares(uint256 shares_left);

    struct Bidder {
        address bidder;
        uint256 sharesBought;
        uint256 buyingPrice;
        uint256 buyingTime;
    }

    bool auctionEnded;
    uint256 start_time;
    uint256 value_stored_in_contract;
    uint256 current_price;
    uint256 base_price;
    uint256 shares_left;
    address[] bidders_addr; // store winning addresses
    mapping(address => Bidder) bidders; // store details of a particular address
    address auctioneer;
    mapping(address => uint256) pendingRequests; // Backup if extra Money fails to revert back.

    modifier isAuctioneer {
        require(
            auctioneer == msg.sender,
            "Only Auctioneer can perform this action"
        );
        _;
    }

    modifier auctionGoingOn {
        require(auctionEnded == false, "Auction has ended");
        _;
    }

    constructor(
        uint256 max_initial_price,
        uint256 min_base_price,
        uint256 number_of_shares
    ) {
        /*
        Initiate all variables.
        */
        auctioneer = msg.sender;
        current_price = max_initial_price;
        base_price = min_base_price;
        shares_left = number_of_shares;
        value_stored_in_contract = 0;
        auctionEnded = false;
        start_time = block.timestamp;
    }

    function currStatus()
        public
        view
        returns (uint256 Current_Price_, uint256 Shares_Left_)
    {
        return (current_price, shares_left);
    }

    function decreasePrice(uint256 decreasePriceBy)
        public
        isAuctioneer
        auctionGoingOn
    {
        /*
        This function is accessible only to Auctioneer to decrease Price on his will,
        by providing the amt by which he wants that to go down.
        if the Auctioneer calls for decreasing the Price beyond the min_base_price,
        the auction will end even if all shares haven't been sold.
        */
        if (current_price == base_price) {
            endAuction();
        } else if (current_price - decreasePriceBy <= base_price) {
            current_price = base_price;
            emit currentPrice(current_price, shares_left);
        } else {
            current_price -= decreasePriceBy;
            emit currentPrice(current_price, shares_left);
        }
    }

    function showBidderDetailsAtIndex(uint256 index)
        public
        view
        returns (
            address Address_,
            uint256 Shares_Bought_,
            uint256 Total_Cost_,
            uint256 Last_Bid_Time_
        )
    {
        /*
            Returns the Details of a Winning Bid.
        */
        return (
            bidders[bidders_addr[index]].bidder,
            bidders[bidders_addr[index]].sharesBought,
            bidders[bidders_addr[index]].buyingPrice,
            bidders[bidders_addr[index]].buyingTime
        );
    }

    function showMyShares()
        public
        view
        returns (
            uint256 Shares_Bought_,
            uint256 Last_Bid_Time_,
            uint256 Total_Cost_
        )
    {
        return (
            bidders[msg.sender].sharesBought,
            bidders[msg.sender].buyingTime,
            bidders[msg.sender].buyingPrice
        );
    }

    function Bid(uint256 asked_shares)
        public
        payable
        auctionGoingOn
        returns (string memory Warning_)
    {
        /*
        function to accept and manage bids for the current price.
        */
        if (asked_shares > shares_left) revert notEnoughShares(shares_left);
        require(
            msg.value >= current_price * asked_shares,
            "Money sent insufficient"
        );
        uint256 extraMoney = msg.value - current_price * asked_shares;

        bidders_addr.push(msg.sender);
        bidders[msg.sender].bidder = msg.sender;
        bidders[msg.sender].sharesBought += asked_shares;
        bidders[msg.sender].buyingPrice += msg.value - extraMoney;
        bidders[msg.sender].buyingTime = block.timestamp - start_time;

        value_stored_in_contract += msg.value - extraMoney;
        shares_left -= asked_shares;

        emit bidderWhoWon(msg.sender, asked_shares);
        if (shares_left == 0) endAuction();

        if (extraMoney == 0) return "Bid Successful.";

        // Trying to payback extra money recieved.
        if (payable(msg.sender).send(extraMoney)) {
            return "Bid Successful. Extra Money returned";
        } else {
            pendingRequests[msg.sender] = extraMoney;
            return "Bid Successful. Extra Money PENDING to be returned";
        }
    }

    function withdraw() public returns (string memory Warning_) {
        /*
          Backup Function.
        */
        address user = msg.sender;
        if (pendingRequests[user] == 0) return "No pending amount";
        if (payable(user).send(pendingRequests[user]))
            return "Withdraw Successful.";
        else return "Withdraw Unsuccessful. Try again.";
    }

    function endAuction() private {
        auctionEnded = true;
        payable(auctioneer).transfer(value_stored_in_contract);
        emit AuctionEnded(shares_left);
    }
}
