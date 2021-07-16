pragma solidity >=0.4.25 <0.7.0;
pragma experimental ABIEncoderV2;

contract Ballot {
    
    struct Voter {
        string name; //name of the Voter
        bool voted ;  // if true, that person already voted
        string contestantName; // the contestant name whom voter voted
        bool verified; // if verified then only voter can vote
    }

    struct Contestant {
     
        string name;  
        uint voteCount; // total no. of votes contestant got
        bool verified; // if verified then only contestant can stand for election
    }

    event Registered(string voter);
    event Voted(string votername);
    address private chairperson;
    uint256 private startVoteTime; // 
    uint256 private startRegistering; // 
    uint256 private votingDuration; // how long does the voting continues in hours
    uint256 private registeringDuration; // how long does the registration continues in hours
    mapping(address => Voter) public voters;
    mapping(string => uint) public contestantIndex;
    address[] public votersAddress;
    Contestant[] public contestants;
    
    constructor(uint256 regduration,uint256 voteduration) public {
        chairperson = msg.sender;
        startRegistering = block.timestamp;
        registeringDuration = regduration;
        votingDuration = voteduration;
        }
        
    modifier ischairperson() {
        require(msg.sender == chairperson,"You are not allowed.");
        _;
        
    }
    
    
    //voters can register themself just passing their name and a true/false if they want to stand in election as contestant
    
    function register(string memory votername,bool ascontestant) public {
        require(block.timestamp<= startRegistering + 3600*registeringDuration,"Sorry the time to register is over");
        if (ascontestant) { 
            contestants.push(Contestant({
            name: votername,
            voteCount: 0,
            verified: false
        })); 
        }
        Voter memory voter;
        voter.name=votername;
        voter.voted=false;
        voter.verified=false;
        voter.contestantName="";
        voters[msg.sender]=voter;
        votersAddress.push(msg.sender);
        emit Registered(votername);
    }
        
    //only chairperson can give rights to voters and only after that they can vote    
    function rightToVote() ischairperson public {
        for (uint i=0;i<votersAddress.length;i++){
            voters[votersAddress[i]].verified=true;
        }
    }
    
    
    // only chairperson can give rights to contestants and only after that they can stand in election
    function rightToContest() public ischairperson{
        for (uint i=0;i<contestants.length;i++){
            contestants[i].verified=true;
            contestantIndex[contestants[i].name]=i;
        }
    }
    
    
    //this function gives the index of contestant by passing their name
    function ShowContestantIndex(string memory name) public view returns(uint){
        return contestantIndex[name];
    }
    
    function StartVoting() public ischairperson {
        startVoteTime=block.timestamp;
    }
    
    //main process to vote by entering contestant's name and their respective index
    function Vote(string memory NameToVote,uint proposalIndex) public {
        Voter memory sender = voters[msg.sender];
        require(block.timestamp<=startVoteTime + 3600*votingDuration,"sorry you're late voting time has ended");
        require(!sender.voted ,"The voter has already voted");
        require(sender.verified, "The Voter is not verified");
        require(contestants[proposalIndex].verified,"The Contestant is not verified");
        require(proposalIndex<contestants.length,"Invalid index of contestant");
        //require(contestants[proposalIndex].name==NameToVote,"Index and Name don't match for the contestant you are voting");
        sender.contestantName = NameToVote;
        sender.voted = true;
        contestants[proposalIndex].voteCount+=1;
        emit Voted(sender.name);
    } 
    
    
    //this function compares the total votes to each contestant to give the winner name 
    function WinnerName() public ischairperson view returns(string memory){
        uint maxVotes=0;
        string memory winner;
        for (uint i=0;i<contestants.length;i++){
            if (contestants[i].voteCount>maxVotes){
                maxVotes=contestants[i].voteCount;
                winner=contestants[i].name;
            } 
        }
        return winner;
    }
    

}
