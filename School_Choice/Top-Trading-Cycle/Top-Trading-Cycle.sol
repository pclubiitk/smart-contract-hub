// SPDX-License-Identifier:  GPL-3.0 License 
pragma solidity >=0.4.25 <0.7.0;

contract school_select{
    //The smart contract for the problem of selecting schools
    struct school{
        uint  capacity;     //the capacity i.e. number of seats available in school
        bool round;         //if the school participated in a round
    }
    
    struct student{
        uint[] choices;     //the array of choices of the student
        bool got;           //the boolean telling if the student has got a seat or not
        uint admitted;      //the school no. the student got, check only if the boolean value "got" is true
    }
    school[] public schools;    //the array of schools, it is public for everyone to see them
    student[] public students;  //the array of students, it is also public to see which student got which school
    
    uint public stud_count;     //the number of students
    uint public school_count;   //the number of schools
    address chairperson;        //the authority 
    
    constructor() public{
        //the constructor functions assign the initial default values to the contract variables
        chairperson = tx.origin;
        stud_count=0;       
        school_count=0;
    }
    
    modifier ischairperson(){
        //some functions need to be called only by the chairperson, this modifier will help making such functions
        require(msg.sender==chairperson,"Only chairperson can call this function");
        _;
    }
    
    function school_registration(uint count1)public{
        //each school will send in the number of seats available to this function and register
        schools.push(school({capacity:count1,
                            round:false }));
        school_count++;
    }
    function student_registration(uint[] memory pref)public{
        //each student have to register through this functiom to register
        //the student must provide the array of school choices of his
        students.push(student({choices:pref,
                               got:false,
                               admitted:0
        }));
        stud_count++;
    }
    function school_allotted(uint i)public view returns(int){

        // This function is can be used by student anytime to see if he has got a school
        // If the allotment process has not been done yet, the output will be "-1" which means the process has not yet been done

        if(students[i].got)
        return int(students[i].admitted);
        else
        return -1;
    }
    function school_allotment()public ischairperson returns(bool){

        // The function of alloting the schools to the students
        // The modifier "ischairperson" ensures that only chairperson the authority can call this function

        uint stud_remain=stud_count;
        // Initially the remaining students are equal to the total students registered

        while(stud_remain>0){   //we will run through and repeat the process till all students get the schools

            for(uint i=0;i<school_count;i++){
            //looping through all the schools

                if(schools[i].capacity > 0){
                //first check if the school has any capacity left
                //otherwise don't include the school

                    uint best_pref=100000;
                    uint best_student=100000;
                    //setting the values to a default large value

                    for(uint j=0;j<stud_count;j++){
                    //loop through the students

                        if(students[j].got==false){
                        //first check if the student has already got any schools or not
                        //if they haven't got any schools then only make a step forward

                            uint[] memory temp=students[j].choices;

                            for(uint k=0;k<school_count;k++){
                            //run through the choices given by the student to detect the cycle

                                if(temp[k]==i){
                                // here we will select the best preference for the school and update it at each iteration if possible
                                    if(k<best_pref){
                                        best_pref=k;
                                        best_student=j;
                                    }
                                }
                            }
                        }
                    }
                    //now as the student with best preference has been found we shall easily complete the cycle by simple steps below
                    
                    students[best_student].got=true;
                    students[best_student].admitted=i;
                    stud_remain--;
                    schools[i].capacity--;

                    // Now if the remaining students has been limited to zero, just return the function with a true statement
                    // we won't go any further if this happens

                    if(stud_remain==0)
                    return true;
                }
            }
        }
        //at last return the function with a true statement as all the students has been assigned schools
        
        return true;
    }
}