// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.6;



contract Vickrey {

    struct Buyer {
        uint bid;          //bid of buyer
        bool done;   //already made the bid
    }
    struct Winner {
        uint bid;//bid of buyer
        address Winner_add;   //already made the bid
        uint toPay;
    }
    

    mapping(address => Buyer) buyers; //Buyers map
    address[] private BuyerAddr; // buyers address array
    address[] private BuyerRequests;  // Buyers who have requested rights


    address private Chairperson;
    modifier isChairperson {
        require(
            msg.sender == Chairperson,
            "Only the Chairperson is allowed to perform this operation."
        );
        _;
    }

    uint256 private period; //voting period 1:Registration 2:Auction 3: Results

    constructor() {
        Chairperson = msg.sender;   //Chairperson Initializes number of seats
        period = 1;
    }


    function RequestBiddingRights() public {
        require(period == 1, "Buyer Registration period is over");
        uint256 t = 0;
        address curr = msg.sender;
        for (uint256 i = 0; i < BuyerRequests.length; i++) {
            if (BuyerRequests[i] == curr) {
                t = 1;
                break;
            }
        }
        require(
            t == 0,
            "Already Requested."
        );
        BuyerRequests.push(msg.sender);
    }

    function ApproveBuyers() public isChairperson {
        require(period == 2, "Buyer Registration period must be over");
        for (uint256 i = 0; i < BuyerRequests.length; i++) {
            BuyerAddr.push(BuyerRequests[i]);
            buyers[BuyerRequests[i]].bid=0;
            buyers[BuyerRequests[i]].done=false;
        }
    }


    function closeRegistrationPeriod() public isChairperson {
        period = 2;
    }
    

    function CheckNumberOfBuyers() public view returns (uint256) {
        return BuyerAddr.length;
    }

//Period 2 : Bidding 

    function bid(uint256 amount) public {
        require(period == 2, "Can't bid currently");
        address curr = msg.sender;
        require(buyers[curr].done==false,"Already made the Bid");
        
        buyers[curr].done=true;
        buyers[curr].bid=amount;
    }

    // SECTION: Results Period.
    
    function closeBiddingPeriod() public isChairperson {
        period = 3;
    }

    function Results() public view isChairperson returns (Winner memory) {
        require(period == 3, "Bidding not ended");
        Winner memory winner = Winner(0,Chairperson,0);
        
        for (uint256 i=0;i<BuyerAddr.length;i++){
            
            if(buyers[BuyerAddr[i]].bid>winner.bid){
                winner.bid=buyers[BuyerAddr[i]].bid;
                winner.Winner_add=BuyerAddr[i];
            }
            
        }
        uint pay=0;
        for (uint256 i=0;i<BuyerAddr.length;i++){
            
            if(buyers[BuyerAddr[i]].bid>pay && BuyerAddr[i]!=winner.Winner_add){
                winner.toPay=buyers[BuyerAddr[i]].bid;
            }
            
        }
        
        
        return winner;
    }
    

}
