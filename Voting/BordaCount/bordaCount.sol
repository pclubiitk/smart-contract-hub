
// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/** 
 * @title Ballot
 * @dev Implements voting process along with vote delegation
 */
contract BordaCount {
   
      struct Voter {
        bool voted ;  // if true, that person already voted
        uint voteindex1 ;// index of the voted candidate
        uint voteindex2;
        uint voteindex3;
        bool isCandidate;
        
    }

    struct Candidate {
        // If you can limit the length to a certain number of bytes, 
        // always use one of bytes1 to bytes32 because they are much cheaper
        address name;   // short name (up to 32 bytes)
        uint index;
        uint voteCount1;
        uint voteCount2;
        uint voteCount3;
        
    }

    address public chairperson;

    mapping(address => Voter) public voters;
    mapping(address => bool) public isPresent;
    mapping(address => bool) public isUnregisteredVoter;
    mapping(address => bool) public isUnregisteredCandiate;
    Candidate[] public candidates;

  
    constructor() {
        chairperson = msg.sender;
    }
    
    address[] private provisional_voters;
    
    function register() public{
        require(isUnregisteredVoter[msg.sender]==false , "already registered");
       
        provisional_voters.push(msg.sender);
        isUnregisteredVoter[msg.sender]=true;
        
    }
    
    
    
    function giveRightToVote() public {
        require(
            msg.sender == chairperson,
            "Only chairperson can give right to vote."
        );
        Voter memory voter;
        voter.voted = false;
        voter.isCandidate = false;
        
        for(uint i=0;i< provisional_voters.length;i++){
            
            voters[provisional_voters[i]] = voter;
            isPresent[provisional_voters[i]]= true;
        }
        
    }
    
    

    address[] private provisional_candidates;
    
    function register_for_candidate() public{
        require((isUnregisteredCandiate[msg.sender]== false) && (isPresent[msg.sender]==true) , 'Not available');
        provisional_candidates.push(msg.sender);           
        isUnregisteredCandiate[msg.sender] = true;             /// helps keep provisional candidates array unique 
    } 
    
        uint256 private num_of_candidates=0;
        
            
    uint pointing_to_tip = 0;
    function approve_candidates() public {
        require(
            msg.sender == chairperson,
            "Only chairperson can give right to vote."
        );
        Candidate memory temp;

        temp.voteCount1 = 0;
        temp.voteCount2 = 0;
        temp.voteCount3 = 0;
          
        
        for(uint i=pointing_to_tip;i< provisional_candidates.length;i++){
            temp.index = num_of_candidates++;
            
            temp.name= provisional_candidates[i];
            candidates.push(temp);
        }
        pointing_to_tip=provisional_candidates.length;
        
    }
    
    


    
    function vote(uint candidate1, uint candidate2, uint candidate3) public {
        require(isPresent[msg.sender]==true, "Not Registered.");
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.voteindex1 = candidate1;
        sender.voteindex2 = candidate2;
        sender.voteindex3 = candidate3;
    
        // If 'Candidate' is out of the range of the array,
        // this will throw automatically and revert all
        // changes.
        require((candidate1!=candidate2)&&(candidate2!=candidate3)&&(candidate3!=candidate1), "ERROR:REPEATED CANDIDATE BY SAME VOTER.");
        candidates[candidate1].voteCount1 ++ ;
        candidates[candidate2].voteCount2 ++ ;
        candidates[candidate3].voteCount3 ++ ;
    }

    /** 
     * @dev Computes the winning candidate taking all previous votes into account.
     * @return winningcandidate_ index of winning candidate in the candid ates array
     */
     
    function winningcandidate() public view
            returns (uint winningcandidate_)
    {
        uint winningVoteCount = 0; 
        for (uint p = 0; p < candidates.length; p++) {
        		uint voteCount = (candidates[p].voteCount1)*5 + (candidates[p].voteCount2)*3 + (candidates[p].voteCount3);
            if ( voteCount > winningVoteCount) {
                winningVoteCount = voteCount;
                winningcandidate_ = p;
            }
        }
    }

    /** 
     * @dev Calls winningcandidate() function to get the index of the winner contained in the candidates array and then
     * @return winnerName_ the name of the winner
     */
    function winnerName() public view
            returns (address winnerName_)
    {
        winnerName_ = candidates[winningcandidate()].name;
    }
   
}
