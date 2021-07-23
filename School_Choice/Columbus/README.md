# COLUMBUS STUDENT ASSIGNMENT MECHANISM

This is a smart contract which is based on a school choice mechanism. A central issue in school choice is the design of a student assignment mechanism. Education literature provides guidance for the design of such mechanisms but does not offer specific mechanisms. The flaws in the existing school choice plans result in appeals by unsatisfied parents.
<hr>

### How does this mechanism work?
1. Each student may apply to **up to three** different schools.
2. For some schools, seats are guaranteed for students who live in the school’s regular assignment area and the priority among remaining applicants is determined by a random lottery. For the remaining schools, the priority among all applicants is determined by **a random lottery**.
3. For each school, available seats are offered to students with the highest priority by a lottery office and the remaining applications are put on a waiting list. After receiving an offer a student has three days to accept or decline an offer. If she accepts an offer, she is assigned a seat; she then must decline offers from other schools and she is removed from the waiting list of other schools to which she has applied. As soon as seats become available at schools because of declined offers, the lottery office makes offers to students on the waiting lists.

<hr>

### Contract Columbus_School_Assignment
It mainly contains of students and schools. There exists a chairperson and he's the **only** one who can register the schools, call the lottery function and subsequently make offers to students.<br>
We have used the following functions :<br>
1. ` show_my_offers `: For a student to see which schools he's accepted to
2. ` Apply `: for students to apply to schools (<=3)
3. ` shuffle `: shuffle the applicants for a particular school 
4. ` lottery `: shuffle the applicants for all schools
5. ` make_offers `: making the initial offers to students
6. ` accept `: for a student to accept an offer from the schools he's accepted to
7. ` reject_school `: To reject a particular school the schools he's accepted to
8. ` reject_time `: If a student doesn't accept/reject the offer in 3 days, it automatically gets rejected

### HOW TO USE
* Open the columbus.sol, copy the code, then run it on [REMIX](https://remix.ethereum.org)
* Compile the code
* From the left side bar, choose any one of the 10 test cases already given in REMIX and deploy the smart contract.
* Now, using it is fairly simple. When we deploy the contract, the address used is assigned to the chairperson.
* Then keep changing the addresses and registering the users as students.
* The **chairperson** also needs to register the schools using the ` RegSchool ` function.
* Each registered student then needs to apply to his/her preferred list of schools (not exceeding 3).
* After this, the chairperson will call the ` lottery ` function and then the ` make_offers ` function to make offers to the students.
* Each student will then accept/ reject the offers from various schools. To view his/her list of offers, one can use the ` show_my_offers ` function.
* This can go on until all seats are filled/all students either accept or reject an offer.

### Team Members

- [Somya Gupta](https://github.com/SG-is-me)
- [Girik Maskara](https://github.com/girik5502)
- [Aryan Sharma](https://github.com/Aryans-20)