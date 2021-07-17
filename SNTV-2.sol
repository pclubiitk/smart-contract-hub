pragma solidity >=0.7.0 <0.9.0;
//CODE BY Aryaman Singhal
contract Ballot
{
   
    struct Voter 
    {
        uint V_ID;
        bool perm;
        bool voted; 
        uint Candidate; 
    }

    struct Candidate 
    {
        uint C_ID;  
        uint voteCount;
    }

    address public chairperson;

    mapping(address => Voter) public voters;

    Candidate[500] public candidates;
    
    uint count=0;
    uint voter_count =0;
    uint net_vote=0;
    //at most 500 cadidates can participate
    
    constructor(bytes32[] memory C_Names) 
    {
        chairperson = msg.sender;
        voters[chairperson].perm = false;
    }
    
    function giveC_ID(address voter) public 
    {
        require(msg.sender == chairperson,"Unauthorized");
        candidates[count].C_ID = voters[voter].V_ID;
        candidates[count].voteCount = 0;
        count = count +1;
    }
    
    function takeC_ID(uint CID) public
    {
        require(msg.sender == chairperson,"Unauthorized");
        candidates[count].C_ID = 0;
        uint N =0;
        for(uint i = 0; i<count; i++)
        {
            if(candidates[i].C_ID==CID)
            {
                N= i;
                break;
            }
        }
        for(uint i = N; i<count-1; i++)
        {
            candidates[i].C_ID = candidates[i+1].C_ID;
            candidates[i].voteCount = candidates[i+1].voteCount;
        }
        count = count-1;
        candidates[count].C_ID =0;
        candidates[count].voteCount=0;
    }
    
    function giveVote(address voter) public
    {
        require(msg.sender == chairperson,"Unauthorized");
        voters[voter].perm = true;
        voter_count++;
    }
    
    function takeVote(address voter) public 
    {
        require(msg.sender == chairperson,"Unauthorized");
        voters[voter].perm = false;
        voter_count--;
    }


    function vote(uint VID, uint CID) public 
    {
        Voter storage sender = voters[msg.sender];
        require(sender.perm != false, "Has no right to vote");
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.Candidate = CID;
        for(uint i =0; i<count; i++)
        {
            if(candidates[i].C_ID==CID)
            {
                candidates[i].voteCount += 1;
            }
        }
    }

    function cl_elec(uint CID) public returns (uint win)
    {
        require(msg.sender == chairperson,"Unauthorized");
        uint winningCount = 0;
        uint winner=0;
        bool tie = false;
        uint tivot=0;
        for (uint i = 0; i < count; i++) 
        {
            net_vote  = net_vote + candidates[i].voteCount;
            if (candidates[i].C_ID !=0 && candidates[i].voteCount > winningCount) 
            {
                tie=false;
                winningCount = candidates[i].voteCount;
                winner = candidates[i].C_ID;
            }
            else if(candidates[i].C_ID !=0 && candidates[i].voteCount == winningCount)
            {
                tie= true;
                tivot = winningCount;
            }
        }
        require(net_vote>(voter_count/2), "Incomplete");
        if(tie==false)
        {
            return winner;
        }
        else
        {
            for(uint i=0; i<count; i++)
            {
                if((candidates[i].C_ID ==CID) && candidates[i].voteCount == tivot)
                {
                    return CID;
                }
            }
            return 0;
        }
    }

}