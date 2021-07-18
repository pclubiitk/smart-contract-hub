// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.6;



contract BlockVoting {

    struct Voter {
        bool[] voted;    //array of size number of Candidate to indicate whether a candidate is given vote or not
        uint vote;          //count of total votes given
    }
    
    struct Candidate {
        uint256 voteCount;          //number of votes recieved by candidate
        bool won;                   // whether the candidate has won or not
    }

    mapping(address => Voter) voters; //Voters map
    address[] private voterAddr; // Voters address array
    address[] private VoterRequests;  // voters who have requested rights

    mapping(address => Candidate) candidates; // Candidates map
    address[] private candidateAddr; // Candidates address array
    address[] private CandidateRequests;  // candidates who have requested candidature

    address private Chairperson;
    modifier isChairperson {
        require(
            msg.sender == Chairperson,
            "Only the Chairperson is allowed to perform this operation."
        );
        _;
    }

    uint256 private period; //voting period 1:Registration 2:Voting 3: Counting
    uint256 private seats;  
    uint256 private candidates_count;

    constructor(uint256 seat) {
        Chairperson = msg.sender;   //Chairperson Initializes number of seats
        period = 1;
        seats=seat;
    }


    function RequestVotingRights() public {
        require(period == 1, "Voter Registration period is over");
        uint256 t = 0;
        address curr = msg.sender;
        for (uint256 i = 0; i < VoterRequests.length; i++) {
            if (VoterRequests[i] == curr) {
                t = 1;
                break;
            }
        }
        require(
            t == 0,
            "Already Requested."
        );
        VoterRequests.push(msg.sender);
    }
    function ApproveVoters() public isChairperson {
        require(period == 2, "Candidate Registration period must be over");
        for (uint256 i = 0; i < VoterRequests.length; i++) {
            voterAddr.push(VoterRequests[i]);
            voters[voterAddr[i]].vote = 0;
            
            for ( uint256 j=0;j<candidates_count;j++ ){
                voters[voterAddr[i]].voted.push(false);
            }
        }
    }

    function RequestCandidature() public {
        require(period == 1, "Voter Registration period is over");

        uint256 t = 0;
        address curr = msg.sender;
        for (uint256 i = 0; i < CandidateRequests.length; i++) {
            if (CandidateRequests[i] == curr) {
                t = 1;
                break;
            }
        }
        require(
            t == 0,
            "Alreaady Requested Candidature"
        );
        CandidateRequests.push(msg.sender);
        
    }

    function ApproveCandidature() public isChairperson {
        require(period == 1, "Voter Registration period is over");
        for (uint256 i = 0; i < CandidateRequests.length; i++) {
           
            candidateAddr.push(CandidateRequests[i]);
            candidates[candidateAddr[i]].voteCount = 0;
            candidates[candidateAddr[i]].won = false;
        }
    }


    function closeRegistrationPeriod() public isChairperson {
        candidates_count = candidateAddr.length;
        period = 2;
    }
    
    
    
    function CheckNumberOfCandidates() public view returns (uint256) {
        return candidates_count;
    }
    function CheckNumberOfSeats() public view returns (uint256) {
        return seats;
    }
    function viewAllCandidates() public view returns (address[] memory) {
        address[] memory FinalList= new address[](candidates_count);
        for (uint256 i = 0; i < candidateAddr.length; i++)
            FinalList[i]=candidateAddr[i];
        return FinalList;
    }

    function vote(address CandidateVoted) public {
        require(period == 2, "Can't vote currently");
        uint256 t = 0;
        address curr = msg.sender;
        for (uint256 i = 0; i < voterAddr.length; i++) {
            if (voterAddr[i] == curr) {
                t = 1;
                break;
            }
        }
        require(t == 1, "Only a registered voter can perform this operation.");
        require(voters[curr].vote < seats, "Can't Cast any more votes");
        uint256 CandidateVotedIndex = candidates_count+1;
        for(uint256 i = 0; i < candidateAddr.length; i++) {
            if(candidateAddr[i] == CandidateVoted){
                CandidateVotedIndex = i;
                break;
            }
        }
        require(CandidateVotedIndex !=candidates_count+1, "Only a registered Candidate can be voted");
        require(voters[curr].voted[CandidateVotedIndex] == false, "Cannot cast more than one vote for the same candidate");
        voters[curr].vote += 1;
        voters[curr].voted[CandidateVotedIndex] = true;

        
    }

    // SECTION: Counting Period.
    
    function closeVotingPeriod() public isChairperson {
        period = 3;
    }

    function Count() public isChairperson returns (address[] memory) {
        require(period == 3, "Voting not ended");
        address[] memory winnerList=new address[](seats);
        for (uint256 i=0;i<voterAddr.length;i++){
            
            for(uint256 j=0;j<candidates_count;j++){
                if(voters[voterAddr[i]].voted[j]==true){
                    candidates[candidateAddr[j]].voteCount++;
                }
            }
            
        }
        
        for(uint256 i=0;i<seats;i++){
            
            uint256 maxi=0;
            uint256 maxv=0;
            
            for(uint256 j=0;j<candidates_count;j++){
                
                if(maxv<=candidates[candidateAddr[j]].voteCount && candidates[candidateAddr[j]].won==false){
                    maxi=j;
                    maxv=candidates[candidateAddr[j]].voteCount;
                }
                
            }
            candidates[candidateAddr[maxi]].won=true;
            winnerList[i]=candidateAddr[maxi];
            
        }
        
        return winnerList;
    }
    

}
