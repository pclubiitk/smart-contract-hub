pragma solidity >=0.7.0 <0.9.0;

contract MMPR{
    
    address public chairperson;     // chairperson of the election
    uint parties = 3;               // number of parties in the election
    uint seats;                     // number of seats in the election
    uint size;                      // size of parliment
    
    address[] provisionalVoters;    // provisional voters
    uint ptr = 0;                   // pointer in provisionalVoters array
    
    uint totalVotes = 0;            // totalVotes casted
    uint[3][] public firstVotes;    // first votes of voters
    uint[3] public secondVotes;     // secondVotes of voters
    
    uint[3] public memberRepresentation;	// representation of parties in parliment from fist votes
    uint[3] public listRepresentation;		// representation of parties in parliment from second votes
    uint[3] public finalRepresentation;		// representation of parties in parliment
    
    struct Voter {
        bool voted;         // if true, that person already voted
        bool autherized;    // if true, person is autherized to vote
        uint seat;          // number of constituency
        
        uint firstVote;     // index of first vote
        uint secondVote;    // index of second vote
    }
    
    
    mapping(address => Voter) public voters;    // mapping between address and voter
    
    // constructs smart contract with size = 2*seats
    constructor (uint _seats) {
        chairperson = msg.sender;
        seats = _seats;
        size = 2*seats;
        for(uint i=0; i<seats; i++) {
            firstVotes.push([0, 0, 0]);
        }
    }
    
    // these are added to provisionalVoters and then periodically autherized by chairperson
    function requestRightToVote(uint seat) public {
        address voter = msg.sender;
        require(
            !voters[voter].autherized,
            "The voter already autherized."
        );
        require(
            seat < seats,
            "No such constituency exists."
        );
        voters[voter].seat = seat;
        provisionalVoters.push(voter);
    }
    
    // autherizing votes
    function giveRightToVote() public {
        require(
            msg.sender == chairperson,
            "Only chairperson can give right to vote."
        );
        
        for(; ptr<provisionalVoters.length; ptr++){
            if(!voters[provisionalVoters[ptr]].voted) {
                voters[provisionalVoters[ptr]].autherized = true;
            }
        }
    }

    // casting votes
    function castVote(uint first, uint second) public {
        address voter = msg.sender;
        
        require(
            voters[voter].autherized,
            "Voter is not autherized"
        );
        
        require(
            !voters[voter].voted,
            "Voter has already voted"
        );
        
        require(
            (first<parties) && (second<parties),
            "Invalid Vote"
        );
        voters[voter].voted = true;
        firstVotes[voters[voter].seat][first] += 1;
        secondVotes[second] += 1;
        totalVotes += 1;
    }
    
    // finding final representation of candidates
    function result() public {
        for(uint i=0; i<seats; i++){
            uint winner = 0;
            uint max = 0;
            
            // from first votes
            for(uint j=0; j<parties; j++){
                if(firstVotes[i][j]>max){
                    winner = j;
                    max = firstVotes[i][j];
                }
            }
            memberRepresentation[winner] += 1;
        }
        
        // from second voter
        // giving representation to a party till it is overepresented in the parliment
        uint occupied = 0;
        for(uint i=0; i<parties; i++){
            while(listRepresentation[i]*totalVotes <= secondVotes[i]*size  && occupied <= size){
                listRepresentation[i] += 1;
                occupied += 1;
            }
			finalRepresentation[i] = listRepresentation[i] + memberRepresentation[i];
        }
    }
}
