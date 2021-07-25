pragma solidity >=0.7.0 <0.9.0;

contract japaneseAuction
{
    
    struct buyer             // structure buyer contains thhe buyer's address, bool variables to check if they are authenticated and currently in the arena, and their index
    {
        address add;
        bool isAuth;
        bool exists;
        uint index;
    
    }
    
    address auctioner;     
    uint256 basePrice;
    bool isEnded;
    bool isStarted;
    uint public numberOfbuyers;
    uint256 initialTime;
    uint256 public incrementPerSec;
    
    buyer [] buyerList;
    mapping(address => buyer )buyerListMap;
    
    
    event AuctionEnded(address winner, uint amount);
    
    modifier isAuctioner{                  // modifier to ensure certain functions can only called by the auctioneer
        require( auctioner == msg.sender, "Only Auctioner can call this");
        _;
    }
    
    
    constructor( )
    {
        auctioner = msg.sender;
        isStarted = false;
        isEnded = false;
        numberOfbuyers = 0;
        
    }
    
    function setBasePrice(uint256 _basePrice , uint256 _incrementPerSec) isAuctioner public{    // function used by the auctioneer to set a base price
        basePrice = _basePrice;
        incrementPerSec = _incrementPerSec;
        
    }
    
    
    
    function signUpAsBuyer() public      // function that can be accessed publicly to sign up as a buyer
    {
        require( !buyerListMap[msg.sender].exists , " Already Exists " );
        buyerList.push(buyer(msg.sender , false , true , buyerList.length));
        buyerListMap[msg.sender].exists = true;
        
    }
    
    function authorise() isAuctioner public{     // used by the auctioneer to authorise buyers
        
        for(uint256 i=0; i<buyerList.length;++i){
            
            if(!buyerList[i].isAuth){
                
                buyerList[i].isAuth=true;    
                buyerListMap[buyerList[i].add] = buyerList[i] ;
                numberOfbuyers ++ ;
                
            
            }
        }
        
    }
    
    function startAuction() isAuctioner public{       // auctioneer uses this function to start the auction
        require( !isEnded , " The Auction has ended, again deploy the contract to start new Auction");
        require( !isStarted , "Auction Already Started");
        isStarted = true;
        initialTime = block.timestamp;
        
    }
    
    
    function getCurrentPrice() public view returns (uint256 ) {       // returns the current price of the item
    
        uint256 currPrice = basePrice;
        
        if(isStarted)
        {
        uint256 timeGap =  block.timestamp - initialTime ;
        currPrice = basePrice + incrementPerSec*timeGap ;
        }
        
        
        return currPrice;
        
        
        
    }
    
    function endAuction() private      //  used to end the auction
    {
        require ( !isEnded , "Auction Already ended");
        require ( isStarted , "Auction not Started Yet");
        require ( numberOfbuyers == 1 , " More than 1 buyer Remaining ");
        isEnded = true;
        
        emit AuctionEnded(buyerList[0].add , getCurrentPrice());
    }
    
    function withdraw () public        // a bidder may use this function to withdraw themselves from the auction, i.e. stop bidding
    {
        require( buyerListMap[msg.sender].exists , " Already withdrawn " );
        require ( !isEnded , " Auction Already Ended");
        
        uint256 ind = buyerListMap[msg.sender].index ;
        buyerList[numberOfbuyers - 1].index = ind ;
        buyerList [ind] = buyerList[numberOfbuyers - 1];
        buyerListMap[msg.sender].exists = false ;
        numberOfbuyers --;
        if(numberOfbuyers == 1){
            
         endAuction();
         
             
         }
        
        
    }
    
}
