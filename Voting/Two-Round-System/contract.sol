// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25 <0.7.0;

/*Implementation of the main contract ballot*/
contract ballot{
    
    struct voter{
        uint  choice;       //The coice of canditate by voter
        bool voted;         //Tells if the voter has already voted or not
        address id;         //the id of voter (unique for every voter)
    }
    
    struct contestant{
        uint symbol;        //symbol of the contestant on which a voter will vote
        uint count;         //count of votes the contestant has got
        address id;         //the id of contestant (unique for every contestant)
    }
    
    address private chairperson;        //chairperson is the authority of the voting procedure
    
    uint candcount;         //count of candidates
    
    mapping (address => voter)private voters;   
    
    mapping (uint => contestant)private candidates;
    
    constructor() public {
        
        chairperson=tx.origin;
        candcount=1;        // we shall use candcount as symbol for the contestants, i.e. the first candidate will have symbol = 1
    }
    
    modifier ischairperson(){
        require(msg.sender==chairperson,"Only chairperson can call this function");
        _;                  // the modifier makes only the chairperson to use some desired functions
    }
    
    voter[] private votereg;    //the list of voters
    
    function voter_registration(address vote)public{
        //every voter will have to register himself through this function 
        votereg.push(voter({choice:0,
                            voted:false,
                            id:vote
        }));
    }
    
    contestant[] private candreg;   //the list of contestants
    
    
     function candidate_registration(address cand)public{
        //every contestant will have to register himself through this function 
        candreg.push(contestant({symbol:candcount,
                            count:0,
                            id:cand
        }));
        candcount++;
    }
    
    function candidate_registration_check() public ischairperson returns(bool){
        //only chairperson can use this function once the registration is over
        //this is for approval of candidates
        candcount--;
        for(uint i=0;i<candcount;i++){
            candidates[candreg[i].symbol]=candreg[i];
        }
        return true;
    }
    
    function voter_registration_check() public ischairperson returns(bool){
        //only chairperson can use this function once the registration is over
        uint votercount=votereg.length;
        for(uint i=0;i<votercount;i++){
            voters[votereg[i].id]=votereg[i];
        }
        return true;
    }
     function vote_candidates( address person_voting,uint symbol_voting )public {
         //the function of voting
        require(
            !voters[person_voting].voted,   //the voter must not have voted already to use this function
            "The voter already voted."
        );
    
        for ( uint i=0 ; i < candcount ; i++ ){
        //every voter votes for the contestant of his desired symbol
        if(candidates[candreg[i].symbol].symbol==symbol_voting){
            voters[person_voting].choice=symbol_voting;
        candidates[candreg[i].symbol].count=candidates[candreg[i].symbol].count + 1 ;
        voters[person_voting].voted=true;
        }
        }

    }
    
     function result_declaration()public  ischairperson  returns (uint,uint ){
         //the function counts the vote for each contestant, if the highest voted candidate is 
         //getting more than half of the votes, he wins
        uint winning_vote_count = 0;
        uint total_votes=0;
        uint pos1;
        uint pos2;
        for (uint p = 0; p < candcount ; p++) {
            if (candreg[p].count > winning_vote_count) {
                winning_vote_count = candreg[p].count;
                pos1=p;
            }
             total_votes+=candreg[p].count;
        }
        bool check_winner= ( winning_vote_count > (total_votes-winning_vote_count) ) ?true:false;  
        if(check_winner)
        {
           return (pos1,0);
        }
        
        else
        {
            winning_vote_count = 0;
            candreg[pos1].count=0;
             for (uint q = 0; q < candcount ; q++) {
            if (candreg[q].count > winning_vote_count) {
                winning_vote_count = candreg[q].count;
                pos2=q;
            }
        }
        candreg[pos2].count=0;
        return (pos1,pos2);
        // in this situation, the chairperson will call for a re-election between top two candidates
        }
     }
        function re_election_voting() public  ischairperson returns (bool){
            //the function can only be called by the chairperson
            //chairperson can call for the re-election between top two candidates by using this function
            for(uint i=0;i<votereg.length;i++)
            voters[votereg[i].id].voted=false;  //all the voters should vote again now ("voted" is now false)
              return true;    
        }
   

}
