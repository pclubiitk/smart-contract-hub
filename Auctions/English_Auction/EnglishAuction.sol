pragma solidity ^0.4.22;

// The Owner/Creater of contract gets the bidding money
contract Enlish_Auction {
    
    
    address public Owner;
    address public HighestBidder;
    uint public HighestBid;
    uint public end_time;
    string private s="withdraw failure";

    mapping(address => uint) pendingReturns;

    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);
    event withdrawFailure(string s);

    constructor(){
        Owner=msg.sender;
    }
    modifier isOwner() {
        require(msg.sender == Owner, "Caller is not Owner");
        _;
    }
    //Owner can call this function only once
    bool flag=false;
    function StartAcution(uint bidding_time) public isOwner{
        require(flag == false,"Auction already started");
        flag=true;
        end_time = bidding_time + now;
    }
    
    function get_current_time() public view returns(uint){
        uint current_time = now;
        return current_time;
    }
    
    function bid() public payable {
        
        require(now <= end_time,"Auction already ended.");
        require(msg.value > HighestBid,"Bid higher then current value");
        
        if (HighestBid!=0) {
            pendingReturns[HighestBidder] += HighestBid;
            HighestBidder = msg.sender;
            HighestBid = msg.value;
        }
        else{
            HighestBidder = msg.sender;
            HighestBid = msg.value;
        }
        emit HighestBidIncreased(msg.sender, msg.value);
    }

    function withdraw() public payable{
        uint amount = pendingReturns[msg.sender];
        require(amount > 0, "Either the highest bidder or you haven't bidded yet");
        pendingReturns[msg.sender]=0;
        if (!msg.sender.send(amount)){
            emit withdrawFailure(s);
        }
        else{
            pendingReturns[msg.sender]=amount;
        }
    }
    
    //Auction can be ended only once
    bool flag2=false;
    function auctionEnd() public isOwner{
        
        require(now >= end_time, "Auction not yet ended.");
        require(flag2 == false, "auctionEnd has already been called.");
        flag2 = true;
        emit AuctionEnded(HighestBidder, HighestBid);
    }
}
