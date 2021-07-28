pragma solidity >=0.4.25 <0.7.0;

contract Two_round_voting {
    string private s="Time for round 2";
    event VeiwNETA(address[] NETA_list);
    event round2(string s);
    //event debug(address NETA_li,uint max_vote,bool flag,uint next_NETA_cnt);
    
    
    address private chairperson;
    constructor() public {
        chairperson = msg.sender;
    }
    
    modifier isChairperson() {
        require(msg.sender == chairperson, "Caller is not owner");
        _;
    }
    
    address[] private voter_list;
    address[] public NETA_list;
    mapping(address => bool) public NETA_approved;
    address[] public best_NETA;
    address public winner;
    mapping(address => uint256) public vote_cnt;
    struct Voter {
        bool approved;
        bool voted;
        address neta;
    }
    
    mapping(address => Voter) public voters;
    
    function voter_registration() public{
        voters[msg.sender].voted = false;
        voters[msg.sender].approved = false;
        voter_list.push(msg.sender);
    }
    
    function approve_voter() public isChairperson{
        for(uint i=0;i<voter_list.length;i++){
            if(voters[voter_list[i]].voted == false){
                voters[voter_list[i]].approved=true;
            }
        }
    }
    
    function NETA_registration() public{
        NETA_list.push(msg.sender);
    }
    function NETA_approve() public isChairperson{
        for(uint i=0;i<NETA_list.length;i++){
            NETA_approved[NETA_list[i]] = true;
            vote_cnt[NETA_list[i]] = 0;
        }
    }
    function veiwAll_NETA() public{
        emit VeiwNETA(NETA_list);
    }
    
    function voteYour_NETA(address NETA) public{
        if(voters[msg.sender].voted == false && NETA_approved[NETA] == true ){vote_cnt[NETA]+=1;voters[msg.sender].voted = true;}
    }
    
    bool public ifMajority = false;
    address public best_candidate;
    address public next_NETA;
    uint total_count=0;
    function find_winner_1st_round() public isChairperson{
        
        uint max_vote=0;
        
        for(uint i=0;i<NETA_list.length;i++){
            total_count+=vote_cnt[NETA_list[i]];
        }
        
        ifMajority = false;
        for(uint i=0;i<NETA_list.length;i++){
            if(vote_cnt[NETA_list[i]]>max_vote){max_vote=vote_cnt[NETA_list[i]]; best_candidate=NETA_list[i];}
            
            if(vote_cnt[NETA_list[i]]*2 > (total_count)){
                ifMajority = true;
                winner=NETA_list[i];
            }
        }
        best_NETA.push(best_candidate);
        if(ifMajority == false){
            emit round2(s);
            
            uint next_NETA_cnt=0;
            bool flag = false;
            for(uint i=0;i<NETA_list.length;i++){
                //emit debug(NETA_list[i],max_vote,flag,next_NETA_cnt);
                if(vote_cnt[NETA_list[i]] == max_vote && flag == false){flag = true;}
                else if(vote_cnt[NETA_list[i]] == max_vote){next_NETA=NETA_list[i];next_NETA_cnt=max_vote;}
                else if(vote_cnt[NETA_list[i]] > next_NETA_cnt){next_NETA=NETA_list[i];next_NETA_cnt=vote_cnt[NETA_list[i]];}
            }
            best_NETA.push(next_NETA);
            vote_cnt[next_NETA]=0;
            vote_cnt[best_candidate]=0;
            for(uint i=0;i<NETA_list.length;i++){NETA_approved[NETA_list[i]]=false;}
            NETA_approved[next_NETA]=true;
            NETA_approved[best_candidate]=true;
        }
    }
    function view_best_NETA(uint i) public returns(address ){
        if(i<2)return best_NETA[i];
    }
    
    
    function round2_preparation() public isChairperson{
        for(uint i=0;i<voter_list.length;i++){
            voters[voter_list[i]].voted =false;
        }
    }
    
    function round2_voting(address NETA) public{
        if(voters[msg.sender].voted == false && NETA_approved[NETA] == true ){vote_cnt[NETA]+=1;voters[msg.sender].voted=true;}
    }
    
    function find_winner_2nd_round() public isChairperson{
        if(vote_cnt[best_candidate]>vote_cnt[next_NETA]){winner=best_candidate;}
        else{winner=next_NETA;}
    }
    
    function view_winner() public view returns(address){
        return winner;
    }
    function view_chairperson() public view returns(address){
        return chairperson;
    }
    
}
