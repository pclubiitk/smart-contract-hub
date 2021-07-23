pragma solidity >=0.4.25 <0.7.0;
pragma experimental ABIEncoderV2;

contract BostonSM{

    struct School{          //represents each school
        string name;
        uint256 vacancy;
        bool verified;
        //uint256 code;     //schoolcode is the index of the school in the schoollist
    }

    struct Student{         //represents each student
        string name;
        uint256 Rolln0;         //index of the Student in the Studentlist
        int256 siblingSchoolCode;  //-1 if no sibling
        bool registered;
        int schoolAssigned;        //-1 if no school assigned
        uint priority_index;       //default value is 0
    }

    struct SchoolDistance{
        uint256 code;           //school code
        bool walkzone;
    }

    address  private authority;
    School[] public SchoolList;
    Student[] public StudentList;
    //bool start_submit_pref;
    Student[] public ResultsList;

    mapping(string => uint256) SchoolwithCode;
    mapping(address => Student) Students;
    mapping (string => SchoolDistance[]) Priority;
    //mapping (address => string) Results;

    constructor() public{
        authority=msg.sender;
        //start_submit_pref = false;
    }

    modifier isauthority(){
        require(msg.sender==authority,"You are not allowed to access this");
        _;
    }

    function RegisterSchools(string memory _name,uint256 _vacancy) public isauthority {
        SchoolList.push(School({
            name: _name,
            vacancy: _vacancy,
            verified: true
            //code: _code     //the code is the school's index in SchoolList
        }));
        //SchoolwithCode[_name]=_code;
    }

    //function start_setting_priority() public isauthority{      //students can submit preferences starting from this function call
    //    start_submit_pref = true;
    //}

    function RegisterStudents(string memory _name,int256 _siblings) public{
        Student memory newstudent = Student({name: _name, Rolln0: StudentList.length, siblingSchoolCode: _siblings, registered: true, schoolAssigned: -1, priority_index: 0});
        Students[msg.sender]= newstudent;
        StudentList.push(newstudent);
    }

    //function ShowSchoolCode(string memory _name) public  view returns(uint256){
    //   return SchoolwithCode[_name];
    //}

    function SetPriority(uint256 _schoolcode,bool _schooldistance) public {  //setting preferences one at a time
        //require(start_submit_pref, "Students cannot submit preferences now");
        require(_schoolcode>=0 && _schoolcode<SchoolList.length, "SchoolCode out of bounds");
        for(uint i=0; i<Priority[Students[msg.sender].name].length; i++){
            require(Priority[Students[msg.sender].name][i].code != _schoolcode, "Preference for a school cannot be changed");
        }
        Priority[Students[msg.sender].name].push(SchoolDistance({
            code: _schoolcode,
            walkzone: _schooldistance
        }));
    }

    function show_priority_index(uint student_index, uint pref_index) public view returns (uint){
        if(StudentList[student_index].siblingSchoolCode == int256(Priority[StudentList[student_index].name][pref_index].code)){
            if(Priority[StudentList[student_index].name][pref_index].walkzone){
                return 4;
            }
            else {
                return 3;
            }
        }
        else if (Priority[StudentList[student_index].name][pref_index].walkzone){
            return 2;
        } else {
            return 1;
        }
    }

    function StartAssigningSchools() public isauthority {
        //uint256 _NumberofSchools=SchoolList.length;
        uint256 _NumberofStudents=StudentList.length;
        uint start=0;
        for(uint i=0; i<SchoolList.length; i++){                    //total a maximum of SchoolList.length preferences possible
            start=ResultsList.length;
            for(uint k=0; k<StudentList.length; k++){               //k represents roll no
                uint j = Priority[StudentList[k].name][i].code;     //j is schoolcode that the student opted in current preference
                if(StudentList[k].schoolAssigned==-1){
                    StudentList[k].priority_index = show_priority_index(k,i);
                    if(SchoolList[j].vacancy==0){
                        for(int l=int(ResultsList.length)-1; l>=int(start); l--){
                            if(ResultsList[uint(l)].schoolAssigned==int(j) && ResultsList[uint(l)].priority_index<show_priority_index(k,i)){
                                uint temp = ResultsList[uint(l)].Rolln0;              //checking if lesser priority student is in list, if yes, he is replaced and
                                StudentList[k].schoolAssigned = int256(j);          //the same is done with him (checking if lesser priority student is in list..).....
                                ResultsList[uint(l)] = StudentList[k];
                                l = int(ResultsList.length);                       //giving advantage to ones who registered first
                                k = temp;
                                StudentList[k].schoolAssigned = -1;
                            }
                        }
                        StudentList[k].priority_index = 0;
                    } else {
                        StudentList[k].schoolAssigned = int256(j);
                        ResultsList.push(StudentList[k]);
                        SchoolList[j].vacancy--;
                        _NumberofStudents--;
                    }
                }
                if(_NumberofStudents==0){
                    break;
                }
            }
            if(_NumberofStudents==0){
                break;
            }
        }
    }

    function ShowResults() view public returns(string memory) {
        for(uint i=0; i<ResultsList.length; i++){
            if(keccak256(abi.encodePacked(ResultsList[i].name))==keccak256(abi.encodePacked(Students[msg.sender].name))){
                return SchoolList[uint256(ResultsList[i].schoolAssigned)].name;
            }
        }
    }
}
