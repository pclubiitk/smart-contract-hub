pragma solidity >=0.7.0 <0.9.0;

contract Ballot {
   
    struct Voter {
        uint weight;        // weight is accumulated by delegation
        bool voted;         // if true, that person already voted
        uint vote;          // index of the voted proposal
    }

    struct Proposal {
        string name;        // short name (up to 32 bytes)
        uint voteCount;     // number of accumulated votes
    }

    address public chairperson;

    mapping(address => Voter) public voters;

    Proposal[] public proposals;
    
    uint public winners;  // Number of people to be elected
    //uint total_voters //total number of voters

    constructor(string[] memory proposalNames, uint winners_) {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;

        for (uint i = 0; i < proposalNames.length; i++) {
            
            // 'Proposal({...})' creates a temporary
            // Proposal object and 'proposals.push(...)'
            // appends it to the end of 'proposals'.
            
            proposals.push(Proposal({
                name: proposalNames[i],
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

    function vote(uint proposal) public {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "Has no right to vote");
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote = proposal;
        
        // If 'proposal' is out of the range of the array,
        // this will throw automatically and revert all
        // changes.
        
        proposals[proposal].voteCount += sender.weight;
        //total_voters += 1;
    }
    
    uint[] public winningProposal_;
    
    function winningProposal() public 
                returns(uint[] memory winning_Proposal)
    {
        //uint[] winningProposal_;
        uint winningVoteCount = 0;
        for(uint i = 0; i < winners; i++){
            for (uint p = 0; p < proposals.length; p++) {
                if (proposals[p].voteCount > winningVoteCount) {
                    winningVoteCount = proposals[p].voteCount;
                    winningProposal_.push(p);
                }
            }
            proposals[winningProposal_[i]].voteCount = 0;
        }
        return winningProposal_;
    }
    string[] public winnerName_;
    function winnerName() public 
                returns(string[] memory winner_Name )
    {
        //string[] winnerName_;
        for(uint i = 0; i < winners; i++){
            winnerName_.push(proposals[winningProposal_[i]].name);
        }
        return winnerName_;
    }
}
