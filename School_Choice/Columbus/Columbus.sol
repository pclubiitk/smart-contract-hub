
// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Columbus_School_Assignment{
    
    struct Student{
        string name;
        string schoolname;
        bool accepted ;
        bool registered;
        uint[] offer;
        uint[] offer_time;
        uint [] sch_app;
        uint[] dis;
    }
    
    struct School{
        string name;
        uint seats;
        address[] applicants_dist;
        address[] applicants_non_dist;
        address[] applicants;
        address[] selected;
        uint dist;
    }
    
    uint num_std;
    mapping(address=>Student) public students;
    address[] std_address;
    uint[] empt;
    School[] public schools;
    address chairperson;
    constructor(){
        chairperson=msg.sender;
    }
    modifier isChairPerson(){
        require(msg.sender==chairperson,"Only Chair Person can call this function");
        _;
    }
    uint[] public my_offers;
    function show_my_offers() public{
        uint i;
        for(i=0;i<students[msg.sender].offer.length;i++){
            my_offers.push(students[msg.sender].offer[i]);
        }
    }
    function RegStudent(string memory Name) public{
        require(!students[msg.sender].registered,"Already Registered");
        students[msg.sender].name = Name;
        std_address.push(msg.sender);
        students[msg.sender].registered=true;
        num_std++;
    }
    
    function RegSchool(string memory Name, uint Seats,uint distance) public isChairPerson{
        School memory temp;
        temp.name = Name;
        temp.seats = Seats;
        temp.dist=distance;
        schools.push(temp);
    }
    
    function Apply(uint256[] memory choice , uint256[] memory dista ) public{
        require(choice.length==dista.length,"choice and distances vectors must be of equal length");
        require(choice.length<=3,"You can only apply to atmost 3 schools");
        students[msg.sender].sch_app = choice;
        students[msg.sender].dis=dista;
        uint i; 
        for(i=0;i<choice.length;i++){
            if(schools[choice[i]].dist<dista[i])
            schools[choice[i]].applicants_non_dist.push(msg.sender);
            else
            schools[choice[i]].applicants_dist.push(msg.sender);
        }
    }       //for students to apply to schools (<=3)
    
    function shuffle(uint p) private{
        uint i;
    for (i = 0;i<schools[p].applicants_dist.length ; i++) {
        uint256 n = i + uint256(keccak256(abi.encodePacked(block.timestamp))) % (schools[p].applicants_dist.length - i);
        address temp = schools[p].applicants_dist[n];
        schools[p].applicants_dist[n] = schools[p].applicants_dist[i];
        schools[p].applicants_dist[i] = temp;
    }
     for (i = 0;i<schools[p].applicants_non_dist.length ; i++) {
        uint256 n = i + uint256(keccak256(abi.encodePacked(block.timestamp))) % (schools[p].applicants_non_dist.length - i);
        address temp = schools[p].applicants_non_dist[n];
        schools[p].applicants_non_dist[n] = schools[p].applicants_non_dist[i];
        schools[p].applicants_non_dist[i] = temp;
    }
    for (i = 0;i<schools[p].applicants_non_dist.length ; i++)
    schools[p].applicants.push(schools[p].applicants_non_dist[i]);
    for (i = 0;i<schools[p].applicants_dist.length ; i++)
    schools[p].applicants.push(schools[p].applicants_dist[i]);
}                   //shuffle the applicants for schools[p] 
    
    function lottery() public isChairPerson{
        uint i;
        for(i=0;i<schools.length;i++)
        shuffle(i);
        }            //shuffle the applicants for all schools
    
    function make_offers() public isChairPerson{
        uint i;
        uint j;
        uint min;
        for(i=0;i<schools.length;i++){
            if(schools[i].applicants.length<schools[i].seats)
            min=schools[i].applicants.length;
            else
            min=schools[i].seats;
            for(j=0;j<min;j++)
            {students[schools[i].applicants[schools[i].applicants.length-1]].offer.push(i);
            students[schools[i].applicants[schools[i].applicants.length-1]].offer_time.push(block.timestamp);
            schools[i].applicants.pop();}
        }
    }        //making the initial offers to students
    
    function accept(uint x) public{
        require(((x<students[msg.sender].offer.length)&&(!students[msg.sender].accepted)),"Choice must be less than number of offered schools");
        students[msg.sender].schoolname=schools[students[msg.sender].offer[x]].name;
        students[msg.sender].accepted=true;
        uint i;
        schools[students[msg.sender].offer[x]].selected.push(msg.sender);
        for(i=0;i<students[msg.sender].sch_app.length;i++){
            if((students[msg.sender].sch_app[i]!=students[msg.sender].offer[x])&&(schools[students[msg.sender].sch_app[i]].applicants.length!=0)){
                while((schools[students[msg.sender].sch_app[i]].applicants.length!=0)&&(students[schools[students[msg.sender].sch_app[i]].applicants[schools[students[msg.sender].sch_app[i]].applicants.length-1]].accepted))
                schools[students[msg.sender].sch_app[i]].applicants.pop();
                if(schools[students[msg.sender].sch_app[i]].applicants.length!=0){
                    students[schools[students[msg.sender].sch_app[i]].applicants[schools[students[msg.sender].sch_app[i]].applicants.length-1]].offer.push(students[msg.sender].sch_app[i]);
                    students[schools[students[msg.sender].sch_app[i]].applicants[schools[students[msg.sender].sch_app[i]].applicants.length-1]].offer_time.push(block.timestamp);
                    schools[students[msg.sender].sch_app[i]].applicants.pop();
                }
        }
    }
        students[msg.sender].offer=empt;
        students[msg.sender].offer_time=empt;
    }                     //for a student to accept an offer from his offer vector
    
    uint[] tempora1;
    uint[] tempora2;
            
    function reject_school(uint x) public{
         require(((x<students[msg.sender].offer.length)&&(!students[msg.sender].accepted)),"Choice must be less than number of offered schools");
         uint i;
         while((schools[students[msg.sender].offer[x]].applicants.length!=0)&&(students[schools[students[msg.sender].offer[x]].applicants[schools[students[msg.sender].offer[x]].applicants.length-1]].accepted))
         schools[students[msg.sender].offer[x]].applicants.pop();
         if(schools[students[msg.sender].offer[x]].applicants.length!=0){
         students[schools[students[msg.sender].offer[x]].applicants[schools[students[msg.sender].offer[x]].applicants.length-1]].offer.push(students[msg.sender].offer[x]);
         students[schools[students[msg.sender].offer[x]].applicants[schools[students[msg.sender].offer[x]].applicants.length-1]].offer_time.push(block.timestamp);
         schools[students[msg.sender].offer[x]].applicants.pop();
         }
         for(i=x;i<(students[msg.sender].offer.length-1);i++)
         {
             students[msg.sender].offer[i]=students[msg.sender].offer[i+1];
             students[msg.sender].offer_time[i]=students[msg.sender].offer_time[i+1];
         }
         students[msg.sender].offer.pop();
         students[msg.sender].offer_time.pop();
    }              //To reject a particular school from his offer vector
    
    function reject_time() public isChairPerson{
        uint i;
        uint j;
        uint k;
        for(i=0;i<std_address.length;i++){
            for(j=0;((j<students[std_address[i]].offer.length)&&((block.timestamp-students[std_address[i]].offer_time[j])>259200));j++){}

            for(k=0;k<students[std_address[i]].offer.length;k++){
                tempora1.push(students[std_address[i]].offer[students[std_address[i]].offer.length-k-1]);
                tempora2.push(students[std_address[i]].offer_time[students[std_address[i]].offer.length-k-1]);
            }
            for(k=0;k<j;k++){
                while((schools[tempora1[tempora1.length-1]].applicants.length!=0)&&(students[schools[tempora1[tempora1.length-1]].applicants[schools[tempora1[tempora1.length-1]].applicants.length-1]].accepted))
                schools[tempora1[tempora1.length-1]].applicants.pop();
                if(schools[tempora1[tempora1.length-1]].applicants.length!=0){
                    students[ schools[tempora1[tempora1.length-1]].applicants[schools[tempora1[tempora1.length-1]].applicants.length-1]].offer.push(tempora1[tempora1.length-1]);
                     students[ schools[tempora1[tempora1.length-1]].applicants[schools[tempora1[tempora1.length-1]].applicants.length-1]].offer_time.push(block.timestamp);
                     schools[tempora1[tempora1.length-1]].applicants.pop();
                }
                tempora1.pop();
                
                tempora2.pop();
            }
            students[std_address[i]].offer=empt;
            students[std_address[i]].offer_time=empt;
            for(k=0;k<tempora1.length;k++){
                 students[std_address[i]].offer.push(tempora1[tempora1.length-k-1]);
                 students[std_address[i]].offer_time.push(tempora2[tempora1.length-k-1]);
            }
            tempora1=empt;
            tempora2=empt;
        }      
    }            // If a student doesn't accept/reject the offer in 3 days, it automatically gets rejected
    }

