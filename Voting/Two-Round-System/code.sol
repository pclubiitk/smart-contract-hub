pragma solidity >=0.4.25 <0.7.0;

contract ballot{
    
    struct voter{
        uint  choice;
        bool voted;
        address id;
    }
    
    struct contestant{
        uint symbol;
        uint count;
        address id;
    }
    
    address private chairperson;
    uint candcount;
    
    mapping (address => voter)private voters;
    
    mapping (uint => contestant)private candidates;
    
    constructor() public {
        
        chairperson=tx.origin;
        candcount=1;
    }
    
    modifier ischairperson(){
        require(msg.sender==chairperson,"Only chairperson can call this function");
        _;
    }
    
    voter[] private votereg;
    
    function voter_registration(address vote)public{
        
        votereg.push(voter({choice:0,
                            voted:false,
                            id:vote
        }));
    }
    
    contestant[] private candreg;
    
    
     function candidate_registration(address cand)public{
        
        candreg.push(contestant({symbol:candcount,
                            count:0,
                            id:cand
        }));
        candcount++;
    }
    
    function candidate_registration_check() public ischairperson returns(bool){
        candcount--;
        for(uint i=0;i<candcount;i++){
            candidates[candreg[i].symbol]=candreg[i];
        }
        return true;
    }
    
    function voter_registration_check() public ischairperson returns(bool){
        uint votercount=votereg.length;
        for(uint i=0;i<votercount;i++){
            voters[votereg[i].id]=votereg[i];
        }
        return true;
    }
     function vote_candidates( address person_voting,uint symbol_voting )public {
    
        require(
            !voters[person_voting].voted,
            "The voter already voted."
        );
    
        for ( uint i=0 ; i < candcount ; i++ ){
            
        if(candidates[candreg[i].symbol].symbol==symbol_voting){
            voters[person_voting].choice=symbol_voting;
        candidates[candreg[i].symbol].count=candidates[candreg[i].symbol].count + 1 ;
        voters[person_voting].voted=true;
        }
        }

    }
    
     function result_declaration()public  ischairperson  returns (uint,uint ){
         
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
        //RE-ELECTION
        }
     }
        function re_election_voting() public  ischairperson returns (bool){
            for(uint i=0;i<votereg.length;i++)
            voters[votereg[i].id].voted=false;
              return true;    
        }
   

}
