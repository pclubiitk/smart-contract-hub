pragma solidity >=0.4.25 <0.7.0;

contract FPTP {
    event VeiwNETA(address[] NETA_list);
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
    
    function find_winner() public isChairperson{
        uint mini=0;
        for(uint i=0;i<NETA_list.length;i++){
            if(mini<vote_cnt[NETA_list[i]]){
                mini=vote_cnt[NETA_list[i]];
                winner=NETA_list[i];
            }
        }
    }
    function view_winner() public view returns(address){
        return winner;
    }
    function view_chairperson() public view returns(address){
        return chairperson;
    }
    
}
