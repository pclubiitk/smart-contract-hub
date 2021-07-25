pragma solidity >=0.7.0 <0.9.0;

// GENERAL TICKET ELECTION SYSTEM
// Assumptions -
// 1. Each party fields more candidates than the winners required
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
        string candidate_name;  // name of the candidate
        uint voteCount;         // number of accumulated votes
    }

    address public chairperson;

    mapping(address => Voter) public voters;

    Proposal[] public proposals;
    
    uint public winners;        // Number of people to be elected from the winning party
    uint[] public unique_p;     // Number of unique parties
    uint public cnames_length;  // Number of candidates
    uint public pnames_length;  // Party index corresponding to candidate (length of array)
    
    constructor(uint[] memory partyNames, string[] memory candidateNames, uint winners_) {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;
        unique_p.push(partyNames[0]);
        cnames_length = candidateNames.length;
        pnames_length = partyNames.length;
        
        // Find the unique parties
         
        for (uint i = 1; i < partyNames.length; i++){
            for (uint j = 0; j < partyNames.length; j++){
                if(partyNames[i] != partyNames[j]){
                    unique_p.push(partyNames[i]);
                    break;
                }
            }
        }

        // Putting all the candidates in a single array of type proposal
        
        for (uint i = 0; i < candidateNames.length; i++) {
            
            // 'Proposal({...})' creates a temporary
            // Proposal object and 'proposals.push(...)'
            // appends it to the end of 'proposals'.
            
            proposals.push(Proposal({
                party_name: partyNames[i],
                candidate_name: candidateNames[i],
                voteCount: 0
            }));
        }
        winners = winners_;
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

    function vote(uint candidate) public {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "Has no right to vote");
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote_party = proposals[candidate].party_name;
        sender.vote_candidate = candidate;
        
        // If 'proposal' is out of the range of the array,
        // this will throw automatically and revert all
        // changes.
        
        proposals[candidate].voteCount += sender.weight;
    }
    
    uint public winningParty_;  //Index of the Winning Party
    
    function winningParty() public 
                returns(uint winning_Party)
    {
        uint winningVoteCount = 0;
        uint[] memory total_party;  // Total votes obtained by each party
        for (uint p = 0; p < unique_p.length; p++) {
            total_party[p]=0;
        }
        
        // Finding total votes obtained by each party
        
        for (uint p = 0; p < cnames_length; p++) {
            for(uint i = 0; i<unique_p.length; i++){
                if(proposals[p].party_name == unique_p[i]){
                    total_party[i]+=proposals[p].voteCount;
                    break;
                }
            }
        }
        
        //Finding the winning party_name
        
        for(uint i = 0; i < unique_p.length; i++){
            if(total_party[i] > winningVoteCount){
                winningVoteCount=total_party[i];
                winningParty_=i;
            }
        }
        return winningParty_;
    }
    
    uint[] public winningcandidates_;   // Array containg the indices of the winning candidates

    //Finding the indices of the winning candidates
    
    function winningcandidates() public 
                returns(uint[] memory winning_Proposal)
    {
        //uint[] winningProposal_;
        uint winningVoteCount = 0;
        for(uint i = 0; i < winners; i++){
            winningVoteCount=0;
            for (uint p = 0; p < cnames_length; p++) {
                if(proposals[p].party_name!=unique_p[winningParty_]) continue;
                
                if (proposals[p].voteCount > winningVoteCount) {
                    winningVoteCount = proposals[p].voteCount;
                    winningcandidates_.push(p);
                }
            }
            proposals[winningcandidates_[i]].voteCount = 0;
        }
        return winningcandidates_;
    }
    string[] public winnerName_;    // Array containg names of the winning candidates
    
    // Finding the names of the winning candidates
    
    function winnerName() public 
                returns(string[] memory winner_Name )
    {
        for(uint i = 0; i < winners; i++){
            winnerName_.push(proposals[winningcandidates_[i]].candidate_name);
        }
        return winnerName_;
    }
}
