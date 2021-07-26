# Boston Student Assignment Mechanism
Contributors: [Nikhesh](https://github.com/nikheshd/) and [Aadeesh](https://github.com/Aadeesh74)<br><br>

In a <b>School Choice Problem</b>, there are a number of students, each of whom should be assigned a seat at one of a number of schools.
Each school has a maximum capacity but there
is no shortage of the total seats. Each student
has strict preferences over all schools, and each
school has a strict priority ordering of all students.<br>

The Boston student assignment mechanism works as follows:<br>
1. Each student submits a preference ranking of
the schools.
2. For each school a priority ordering is determined according to the following hierarchy:<br>
• First priority: sibling and walk zone.<br>
• Second priority: sibling.<br>
• Third priority: walk zone.<br>
• Fourth priority: other students.<br>
Students in the same priority group are ordered based on a previously announced
lottery. Here, we have given advantage to ones who have registered first - to win the lottery.<br>
3. The final phase is the student assignment
based on preferences and priorities:<br>
<b>Round 0:</b> In Round 0 only the first choices of
the students are considered. For each school,
consider the students who have listed it as
their first choice and assign seats of the
school to these students one at a time following their priority order until either there
are no seats left or there is no student left
who has listed it as her first choice.<br>
<b>Round 1:</b> Consider the remaining students.
In Round 1 only the second choices of these
students are considered. For each school
with still available seats, consider the students who have listed it as their second
choice and assign the remaining seats to
these students one at a time following their
priority order until either there are no seats
left or there is no student left who has listed
it as her second choice.<br>
In general at<br>
<b>Round k:</b> Consider the remaining students.
In Round k only the kth choices of these
students are considered. For each school
with still available seats, consider the students who have listed it as their kth choice
and assign the remaining seats to these students one at a time following their priority
order until either there are no seats left or
there is no student left who has listed it as
her kth choice.

## Instructions to run:
1. Deploy the contract using <b>Owner's or Authority's address</b>.
2. Authority can only register schools. <b>RegisterSchools</b> is called by passing school's name and vacancy:<br>
RegisterSchools (Schoolname0, vacancy=1)<br>
RegisterSchools (Schoolname1, vacancy=1)<br>
RegisterSchools (Schoolname2, vacancy=1)<br>
Each time RegisterSchools is called, they are pushed into <b>SchoolList</b>. <b>SchoolCode or code</b> is the index of the School in the SchoolList.
3. <b>RegisterStudent</b> is called by passing student's name and sibling's SchoolCode (=-1 If there is no sibling's SchoolCode).<br>
RegisterStudent (Studentname0,  1) ; from Student0's address<br>
RegisterStudent (Studentname1, -1) ; from Student1's address<br>
RegisterStudent (Studentname2, -1) ; from Student2's address<br>
Each time RegisterStudent is called, they are pushed into <b>StudentList</b>. <b>Rolln0</b> is the index of the Student in the StudentList. By default each student's <b>schoolAssigned</b> is -1.<br>
4. After registering, each student must submit preference ranking of all schools. <br>
Each time <b>SetPriority(SchoolCode, schooldistance or walkzone)</b> is called, it is added to respective Students's Priority array at the end, which is intern in <b>Priority</b> array. The order in Students's Priority array represents the preference of the student and each index can be called as <b>preference_index</b>. Preference for a school cannot be changed.<br>
From Student0's address:<br>
  &nbsp;  &nbsp;  &nbsp;  SetPriority(0, false)<br>
  &nbsp;  &nbsp;  &nbsp;  SetPriority(1, false)<br>
  &nbsp;  &nbsp;  &nbsp;  SetPriority(2, true)<br>
From Student1's address:<br>
  &nbsp;  &nbsp;  &nbsp;  SetPriority(1, false)<br>
  &nbsp;  &nbsp;  &nbsp;  SetPriority(0, true)<br>
  &nbsp;  &nbsp;  &nbsp;  SetPriority(2, true)<br>
From Student2's address:<br>
  &nbsp;  &nbsp;  &nbsp;  SetPriority(0, true)<br>
  &nbsp;  &nbsp;  &nbsp;  SetPriority(1, false)<br>
  &nbsp;  &nbsp;  &nbsp;  SetPriority(2, true)<br>
The bool value represents whether the Student is in School's walkzone or not.
5. <b>show_priority_index</b> can be run by Students to check their priority would be by passing Student's Rolln0 and a preference_index.<br>
• First priority: sibling and walk zone : <b>4</b><br>
• Second priority: sibling : <b>3</b><br>
• Third priority: walk zone : <b>2</b><br>
• Fourth priority: other students : <b>1</b><br>
6. <b>StartAssigningSchools</b> can only be called by Authority to assign schools to the students. So, this is called only when all students have filled their prefernces for all the schools. 
Each time a student is assigned a school, he get's added to <b>ResultList</b> at the end. <br>
<b>Round 0:</b> Student2 is assigned Schoolname0 with priority_index=2, Student1 is assigned Studentname1 with priority_index=1<br>
<b>Round 1:</b> no one assigned <br>
<b>Round 2:</b> Student0 is assigned Schoolname2 with priority_index=2
7. Each student can access their results by calling <b>ShowResults</b> using their address to get their assigned school's name.<br>
ShowResults from Student0's address gives: Schoolname2<br>
ShowResults from Student1's address gives: Schoolname1<br>
ShowResults from Student2's address gives: Schoolname0<br>
Authority can access results using <b>ResultsList</b> by passing an index to see who has been assigned which school at that point.
