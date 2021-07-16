
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
    
   
}
