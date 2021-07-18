pragma solidity ^0.8.2;
pragma abicoder v2;

contract Cumulative_voting{
    
    struct candidate{                                               //stores the details of a candidate
        
        string name;
        address unid;
        uint256 votecount;
        bool ifAuthC;                                               //stores if the candidate has been authorized/records if the candidature has been validated
        
    }
    
    struct voter{                                                   //stores the details of a voter         note:a candidate is NOT a voter by default and vice-versa and needs to register seperately
        
        string name;
        address unid;
        bool ifVoted;
        bool ifAuthV;
        
    }
    
     address private Owner;
    
     modifier isOwner() {                                            //validates if the calling address is same as that of the owner
        require(msg.sender==Owner);
        _;
    }
    
    uint256 public numberOfSeats;                                   //stores how many winners are to be declared
    
    function getnumberOfSeats(uint _numberOfSeats) isOwner public{  //by default it is 1 but the owner can change the value of the numberOfSeats by using this function
        numberOfSeats=_numberOfSeats;
    }      
    
    candidate[] candidateList;
    voter[] voterList;                                                      //list of all voters
    mapping(address=>voter) authVoters;                                     //mapping of authorised voters  note:we are using this even though it causes a bit of data redundancy because accessing elements in a map works faster than an array 
    bool openToVote;                                                        //the next 3 variables decide state of the system and it is controlled by the Owner
    bool nominationsBeingAccepted;
    bool resultDeclared;
    
    constructor() public{
        
        Owner=msg.sender;
        candidateList.push(candidate("NOTA",msg.sender,0,true));            //adds a NOTA as one of the choices for candidature (option zero)
        nominationsBeingAccepted=true;
        openToVote=false;
        resultDeclared=false;
        numberOfSeats=1;
        
    }
    
    function getCandidatelist(uint location) public view returns(string memory){            //prints the candidate with the index = location, (option number location)
        
        require(nominationsBeingAccepted==false,"List not finalized, try again later");     //works only if the final list of candidates have been decided
        
        require(location<=candidateList.length,"Invalid location");                         
        
        require(candidateList[location].ifAuthC,"Candidate not authenticated");
        
        return(candidateList[location].name);
        
    }
    
    function signUpVoter(string memory _name) public{
        
        voterList.push(voter(_name,msg.sender,false,false));
         
    }
    
    function signUpCandidate(string memory _name) public{
        
        require(nominationsBeingAccepted,"Nomination period closed");
        
        candidateList.push(candidate(_name,msg.sender,0,false));
        
    }
    
    function authoriseVoters() isOwner public{
        
        for(uint256 i=0; i<voterList.length;++i){
            
            if(!voterList[i].ifAuthV){
                
                voterList[i].ifAuthV=true;                              //if you want to add any condition before this the owner can
                authVoters[voterList[i].unid]=voterList[i];
            
            }
        }
        
    }
    
    function authoriseCandidates() isOwner public{
        
        for(uint256 i=0; i<candidateList.length;++i){
            
            if(!candidateList[i].ifAuthC){
                
                candidateList[i].ifAuthC=true;                              //if you want to add any condition before this the owner can
            
            }
        }
        
    }
    
    function closeNominations() isOwner public returns(string memory){
        
        nominationsBeingAccepted=false;
        return("Authorize candidates before opening voting");
        
    }
    
    function openVoting() isOwner public{
        
        openToVote=true;
        
    }
    
    function closeVoting isOwner public{
    
        openToVote=false;
        
    }
    function castVote(uint[] memory ballot) public{
        
        require(openToVote,"Voting not opened yet");
        
        require(ballot.length<=numberOfSeats,"Too many choices, try again");
        
        require(!(authVoters[msg.sender].unid==address(0)),"Not authorized to vote");
        
        require(!authVoters[msg.sender].ifVoted,"Already voted");
        
        
        for(uint256 i=0;i<ballot.length;++i){
            candidateList[ballot[i]].votecount++;
        }
        
        authVoters[msg.sender].ifVoted=true;
        
    }
    
    string[] winners;
    uint256[] winnerVoteCount;
    
    function compileResult() isOwner public{
        
        openToVote=false;
        uint256 max=0;
        uint256 pos=0;
        
        for(uint256 i=0;i<numberOfSeats;++i){
            
            for(uint256 j=0;j<candidateList.length;++j){
                
                if(max<candidateList[j].votecount){
                    pos=j;
                    max = candidateList[j].votecount;
                }
            
            }
            
            winners.push(candidateList[pos].name);
            winnerVoteCount.push(candidateList[pos].votecount);
            candidateList[pos].votecount=0;
            pos=0;
            max=0;
            
        }
        
        resultDeclared=true;
        
    }
    
    function viewResult() view public returns(string[] memory,uint256[] memory){
        
        require(resultDeclared,"Result yet to be declared, try again later");
        
        return(winners,winnerVoteCount);
        
    }
    
}


