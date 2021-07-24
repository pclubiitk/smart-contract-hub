pragma solidity >=0.7.0 <0.9.0;

contract auction
{
    
    struct buyer
    {
        address add;
        bool isAuth;
        bool exists;
        uint index;
    
    }
    
    address auctioner;
    uint256 highestBid;
    uint256 basePrice;
    bool isEnded;
    bool isStarted;
    buyer [] buyerList;
    uint public numberOfbuyers;
    event currentBid(uint amount);
    event AuctionEnded(address winner, uint amount);
    uint256 initialTime;
    uint256 public incrementPerSec;
    mapping(address => buyer )buyerListMap;
    
    modifier isAuctioner{
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
    
    function setBasePrice(uint256 _basePrice , uint256 _incrementPerSec) isAuctioner public{
        basePrice = _basePrice;
        incrementPerSec = _incrementPerSec;
        
    }
    
    
    
    function signUpAsBuyer() public
    {
        require( !buyerListMap[msg.sender].exists , " Already Exists " );
        buyerList.push(buyer(msg.sender , false , true , buyerList.length));
        buyerListMap[msg.sender].exists = true;
        
    }
    
    function authorise() isAuctioner public{
        
        for(uint256 i=0; i<buyerList.length;++i){
            
            if(!buyerList[i].isAuth){
                
                buyerList[i].isAuth=true;    
                buyerListMap[buyerList[i].add] = buyerList[i] ;
                numberOfbuyers ++ ;
                
            
            }
        }
        
    }
    
    function startAuction() isAuctioner public{
        
        require( !isStarted , "Auction Already Started");
        isStarted = true;
        initialTime = block.timestamp;
        
    }
    
    
    function getCurrentPrice() public view returns (uint256 ) {
        uint256 currPrice = basePrice;
        
        if(isStarted)
        {
        uint256 timeGap =  block.timestamp - initialTime ;
        currPrice = basePrice + incrementPerSec*timeGap ;
        }
        
        
        return currPrice;
        
        
        
    }
    
    function endAuction() private
    {
        require ( !isEnded , "Auction Already ended");
        require ( isStarted , "Auction not Started Yet");
        require ( numberOfbuyers == 1 , " More than 1 buyer Remaining ");
        isEnded = true;
        
        emit AuctionEnded(buyerList[0].add , getCurrentPrice());
    }
    
    function withdraw () public 
    {
        require( buyerListMap[msg.sender].exists , " Already withdrawn " );
        
        require ( !isEnded , " Auction Already Ended");
        
        uint256 ind = buyerListMap[msg.sender].index ;
        buyerList [ind] = buyerList[buyerList.length - 1];
        buyerListMap[msg.sender].exists = false ;
        numberOfbuyers --;
        if(numberOfbuyers == 1){
            
         endAuction();
         
             
         }
        
        
    }
    
}
