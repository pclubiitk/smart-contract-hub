

Top Trading Cycles Mechanism for School Choice

a competing mechanismwhich is Pareto efficient but which does notcompletely eliminate justified envy. Loosely speaking, the intuition for this mechanism is that it starts with students who have the highest priorities, and allows them to trade the schoolsf or which they have the highest priorities in case a Pareto improvement is possible. Once these students are removed, it proceeds in a similar way starting with the students who have the highest priorities among those who remain. The top trading cycles mechanism is a direct mechanism and for any priorities and reported preferences it finds a matching via the following top trading cycles algorithm

Contract school_select

It mainly contains of students and schools. There exists a chairperson and he's the only one who can allot the schools to the students. We have used the following functions :

    school_registration: Every school has to register first by using this function by providing the capacity of students that school can teach.
    student_registration: Every student has to register first by using this function by providing the preferences of all the schools at once in an uint array.
    school_allotted: Every student can check the school allotted to them by running this function after the chairperson has allotted the schools. If it returns '-1' then it means that the school has not been allotted yet.
    school_allotment: Chairperson uses this function to allot schools to all the students.

HOW TO USE

• Open the Top_Trading-Cycle.sol, copy the code, then run it on REMIX • Compile the code • From the left side bar, choose any one of the 10 addresses already given in REMIX and deploy the smart contract. • Now, using it is fairly simple. When we deploy the contract, the address used is assigned to the chairperson. • Then keep changing the addresses and registering the users as schools (and then as students if you want). • Remember that all the students and schools are numbered with 0-indexing. • The school_allotment function is used by the chairperson to allot the schools to all the students.

Team Members

• Dhwanit Balwani   https://github.com/dhwanit75
• Suket Raj    https://github.com/raj-suket
• Anubha Tripathi   https://github.com/AnubhaT-code
