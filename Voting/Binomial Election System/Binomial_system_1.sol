pragma solidity >=0.7.0 <0.9.0;

// BINOMIAL ELECTION SYSTEM
// Assumptions -
// 1. Each party defines their candidate number 1 and candidate number 2 before the elcetion and
//    the voters are aware about it
// 2. Party names have been taken in the form of numbers

contract Ballot {
   
    struct Voter {
        uint weight;            // weight is accumulated by delegation
        bool voted;             // if true, that person already voted
        uint vote_party;        // index of the party voted 
        uint vote_candidate;    // index of the candidate voted 
    }

    struct Proposal {
        uint party_name;        // name of the party
        string candidate_name1; // name of candidate 1
        string candidate_name2; // name of candidate 2
        uint voteCount;         // number of accumulated votes
        uint voteCount1;        // number of accumulated votes candidate1
        uint voteCount2;        // number of accumulated votes candidate2
    }
    
    struct list {
        uint partyname;         // name of the party
        string candidatename1;  // name of candidate 1
        string candidatename2;  // name of candidate 2
        uint vc1;               // number of accumulated votes candidate1
        uint vc2;               // number of accumulated votes candidate2
    }

    address public chairperson;

    mapping(address => Voter) public voters;

    Proposal[] public proposals;
    
    uint public winners;        // Number of people to be elected from the winning party
    uint[] public unique_p;     // Number of unique parties
    uint public cnames_length;  // Number of candidates
    uint public pnames_length;  // Party index corresponding to candidate (length of array)
    
    constructor(list[] memory party) {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;
        pnames_length = party.length;
        
        // Putting all the candidates in a single array of type proposal
        
        for (uint i = 0; i < party.length; i++) {
            
            // 'Proposal({...})' creates a temporary
            // Proposal object and 'proposals.push(...)'
            // appends it to the end of 'proposals'.
            
            proposals.push(Proposal({
                party_name: party[i].partyname,
                candidate_name1: party[i].candidatename1,
                candidate_name2: party[i].candidatename2,
                voteCount: 0,
                voteCount1: 0,
                voteCount2: 0
            }));
        }
    }
    
    function giveRightToVote(address voter) public {
        require(
            msg.sender == chairperson,
            "Only chairperson can give right to vote."
        );
        require(
            !voters[voter].voted,
            "The voter already voted."
        );
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }

    function vote(uint party,uint candidate) public {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "Has no right to vote");
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote_party = party;
        sender.vote_candidate = candidate;
        
        // If 'proposal' is out of the range of the array,
        // this will throw automatically and revert all
        // changes.
        
        for(uint i = 0; i < proposals.length; i++){
            if(proposals[i].party_name == party){
                proposals[i].voteCount+=sender.weight;
                if(candidate == 1) proposals[i].voteCount1 += sender.weight;
                else proposals[i].voteCount2 += sender.weight;
            }
        }
    }
    
    list[2] public winningparty_;   // Index of the Winning Party
    uint public winningvotecount1;  // number of votes won by the winning party
    uint public winningvotecount2;  // number of votes won by the next winning party
    
    function winningParty() public 
                returns(list[2] memory winning_Party)
    {
        uint winningVoteCount  = 0;
        uint t;
        for(uint i = 0; i < 2; i++){
            winningVoteCount = 0;
            for (uint p = 0; p < proposals.length; p++) {
                if (proposals[p].voteCount > winningVoteCount) {
                    winningVoteCount = proposals[p].voteCount;
                    t=p;
                }
            }
            winningparty_[i].partyname = (proposals[t].party_name);
            if(i==0) winningvotecount1 = winningVoteCount;
            if(i==1) winningvotecount2 = winningVoteCount;
            proposals[t].voteCount = 0;
        }
        return winningparty_;
    }
    function wp() public {
        
        for(uint i=0;i<2;i++){
            for(uint j=0;j<proposals.length;j++){
                if(winningparty_[i].partyname==proposals[j].party_name){
                    winningparty_[i].candidatename1=proposals[j].candidate_name1;
                    winningparty_[i].candidatename2=proposals[j].candidate_name2;
                    winningparty_[i].vc1=proposals[j].voteCount1;
                    winningparty_[i].vc2=proposals[j].voteCount2;
                }
            }  
        } 
    }
    
    string[2] public winnerName_;    // Array containg names of the winning candidates
    
    function winnerName() public 
                returns(string[2] memory winner_Name )
    {
        if(winningvotecount1 >= 2*winningvotecount2){
            winnerName_[0]=(winningparty_[0].candidatename1);
            winnerName_[1]=(winningparty_[0].candidatename2);
        }
        else{
            if(winningparty_[0].vc1>winningparty_[0].vc2) winnerName_[0]=(winningparty_[0].candidatename1);
            else winnerName_[0]=(winningparty_[0].candidatename2);
            
            if(winningparty_[1].vc1>winningparty_[1].vc2) winnerName_[1]=(winningparty_[1].candidatename1);
            else winnerName_[1]=(winningparty_[1].candidatename2);
        }
        return winnerName_;
    }
}
