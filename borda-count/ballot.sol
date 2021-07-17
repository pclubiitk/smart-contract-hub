pragma solidity ^0.4.21;

contract Election{
   
	// struct to store information about candidate
    struct Candidate{
        string name;
        uint voteCount;
    }
    
	// struct to store voters information
    struct Voter{
        bool autherized;
        bool voted;
        uint[] vote;
    }
    
    address public chairPerson;
    string public electionName;
    
    mapping(address => Voter) public voters;
    
    Candidate[] public candidates;
    uint public totalVotes;
    
    modifier ownerOnly(){
        require(msg.sender==chairPerson);
        _;
    }
    
    constructor(string _name) public {
        chairPerson = msg.sender;
        electionName = _name;
    }
    
	// adding candidates
    function addCandidate(string _name) public ownerOnly {
        candidates.push(Candidate(_name, 0));
    }
    
    function getNumCandidates() public view returns(uint) {
        return candidates.length;
    }
    
	// autherizing voters
    function autherize(address _person) ownerOnly public {
        voters[_person].autherized = true;
    }
    
	// displays result of the election
    function result() ownerOnly public view returns(string) {
        require(totalVotes>0);
        uint maxVotes = 0;
        uint winner = 0;
        for (uint i=0; i<candidates.length; i++){
            if(candidates[i].voteCount > maxVotes) {
                maxVotes = candidates[i].voteCount;
                winner = 0;
            }
        }
        return candidates[winner].name;
    }
    
	// voter provides his preference list
	// cadidates are given weights n-1, n-2, ..., 0 
    function vote(uint[] _voteIndex) public {
        require(!voters[msg.sender].voted);
        require(voters[msg.sender].autherized);
        
        voters[msg.sender].voted = true;
        voters[msg.sender].vote = _voteIndex;
        
        uint weight = candidates.length-1;
        for(uint i=0; i<_voteIndex.length; i++){
            candidates[_voteIndex[i]].voteCount += weight;
            weight -= 1;
            if(weight==0)   break;
        }
        totalVotes += 1;
    }
    
	// destructs the contract
    function end() ownerOnly public {
        selfdestruct(owner);
    }
}
