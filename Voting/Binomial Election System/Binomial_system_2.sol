pragma solidity >=0.7.0 <0.9.0;

contract Ballot
{
   
    struct Voter 
    {
        uint V_ID;
        bool perm;
        bool voted; 
        uint Candidate1;
        uint Candidate2;
    }

    struct List 
    {
        uint List_Id;
        uint C_ID1;  
        uint C_ID2;
        uint voteCount;
    }
    
    struct Rep
    {
        uint L_ID1;
        uint L_ID2;
    }

    address public chairperson;

    mapping(address => Voter) public voters;

    List[500] public candidates;
    
    Rep public winner;
    
    uint count=0;
    uint voter_count =0;
    uint net_vote=0;
    //at most 500 cadidates can participate
    
    constructor() 
    {
        chairperson = msg.sender;
        voters[chairperson].perm = false;
        for(uint i =0; i<500; i++)
        {
            candidates[i].List_Id = 0;
            candidates[i].C_ID1 = 0;
            candidates[i].C_ID2 = 0;
            candidates[i].voteCount = 0;
        }
        for(uint i =0; i<2; i++)
        {
            winner.L_ID1 = 0;
            winner.L_ID2 = 0;
        }
    }
    function sort_array() private
    {
       require(msg.sender== chairperson, "Unauthorized");
       List storage temp;
       for(uint i =0;i<500;i++)
       {
        for(uint j =i+1;j<500;j++)
        {
            if(candidates[i].voteCount<candidates[j].voteCount)
            {
                temp= candidates[j];
                candidates[j]=candidates[i];
                candidates[i] = temp;
            }

        }
       }
    }
    
    function giveC_ID(address voter1, address voter2, uint LID) public 
    {
        require(msg.sender == chairperson,"Unauthorized");
        candidates[count].C_ID1 = voters[voter1].V_ID;
        candidates[count].C_ID2 = voters[voter2].V_ID;
        candidates[count].voteCount = 0;
        candidates[count].List_Id = LID;
        count = count +1;
    }
    
    function takeC_ID(uint LID) public
    {
        require(msg.sender == chairperson,"Unauthorized");
        uint N =0;
        for(uint i = 0; i<count; i++)
        {
            if(candidates[i].List_Id==LID)
            {
                N= i;
                break;
            }
        }
        for(uint i = N; i<count-1; i++)
        {
            candidates[i].C_ID1 = candidates[i+1].C_ID1;
            candidates[i].C_ID2 = candidates[i+1].C_ID2;
            candidates[i].voteCount = candidates[i+1].voteCount;
            candidates[i].List_Id = candidates[i+1].List_Id;
        }
        count = count-1;
        candidates[count].C_ID1 =0;
        candidates[count].C_ID2 =0;
        candidates[count].List_Id=0;
        candidates[count].voteCount=0;
    }
    
    function mod_Cand(uint LID, uint c, uint RID) public
    {
        require(msg.sender == chairperson,"Unauthorized");
        for(uint i = 0; i<count; i++)
        {
            if(candidates[i].List_Id==LID)
            {
                if(c==1)
                {
                    candidates[i].C_ID1 = RID;
                }
                else if(c==2)
                {
                    candidates[i].C_ID2 = RID;
                }
                break;
            }
        }
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


    function vote(uint LID) public 
    {
        Voter storage sender = voters[msg.sender];
        require(sender.perm != false, "Has no right to vote");
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        
        for(uint i =0; i<count; i++)
        {
            if(candidates[i].List_Id==LID)
            {
                sender.Candidate1 = candidates[i].C_ID1;
                sender.Candidate2 = candidates[i].C_ID2;
                candidates[i].voteCount += 1;
            }
        }
    }

    function cl_elec() public returns (Rep memory win)
    {
        require(msg.sender == chairperson,"Unauthorized");
        for (uint i = 0; i < count; i++) 
        {
            net_vote  = net_vote + candidates[i].voteCount;
        }
        require (net_vote>(voter_count/2), "Incomplete Voting");
        sort_array();
        if(count ==1)
        {
            winner.L_ID2 = candidates[0].List_Id;
            winner.L_ID1 = candidates[0].List_Id;
        }
        if(count==2)
        {
            if(candidates[0].voteCount> 2*candidates[1].voteCount)
            {
              winner.L_ID2 = candidates[0].List_Id;
              winner.L_ID1 = candidates[0].List_Id;  
              return winner;
            }
            else
            {
                winner.L_ID2 = candidates[1].List_Id;
                winner.L_ID1 = candidates[0].List_Id;
                return winner;
            }
        }
        else
        {
            if(candidates[0].voteCount >= candidates[1].voteCount && candidates[1].voteCount > candidates[2].voteCount)
             {
                   winner.L_ID1 = candidates[0].List_Id;
                   if (candidates[0].voteCount >= 2*candidates[1].voteCount)
                       winner.L_ID2 = candidates[0].List_Id;
                   else
                       winner.L_ID2 = candidates[1].List_Id;
                
                   return winner;
             }
        }
    }

}