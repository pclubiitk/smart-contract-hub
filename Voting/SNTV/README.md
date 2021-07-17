# SMART CONTRACT BASED VOTING

This is a smart contract based on one of the many voting mechanisms that exist. In order to conduct free and fair elections, it is important to remove the involvement and control of any central authority over the voting process. Through this contract, we have ensured that the process is decentralized.

### Single Non-Transferable Vote (SNTV)
In this type of voting, each voter casts **one** vote for **one** candidate in a **multi-candidate race** for multiple offices. Posts are filled by the candidates with **the most votes**. Thus, in a three-seat constituency, the three candidates receiving the largest numbers of votes would win office.

### Contract Ballot
It mainly contains of voters and candidates. There exists a chairperson and he's the **only** one who can allow the people to become voters. Other than that, **only** he can also allow the registered voters to contest the elections as candidates. <br>
We have used the following functions :<br>
1. ` toggle_can_vote `: After every person votes, chairperson toggles this (to prevent multiple time voting)
2. ` toggle_can_register_voter `: After registering a voter, chairperson toggles this (to prevent repetition)
3. ` toggle_can_register_candidate `: After registering a candidate, chairperson toggles this(to prevent repetition)
4. ` set_num_seat `: Chairperson sets the number of seats that can be filled using this
5. ` Register_Voter `: For voters to register
6. ` Register_Candidate `: For candidates to register
7. ` vote `: For voters to vote to their specific candidate of choice
8. ` winningProposal `: Calculates the votes recieved by each candidate and declares the winners

### HOW TO USE
* Open the sntv.sol, copy the code, then run it on [REMIX](https://remix.ethereum.org)
* Compile the code
* From the left side bar, choose any one of the 10 test cases already given in REMIX and deploy the smart contract.
* Now, using it is fairly simple. When we deploy the contract, the address used is assigned to the chairperson.
* Then keep changing the addresses and registering the users as voters (and then as candidates if you want).
* Remember that the chairperson toggles the functions whenever needed.
* The voters can then vote to their candidates of choice using the `vote` function.
* Also the chairperson has to mention the no. of candidates that have to be elected.
* The `winningProposal` function gives the name of the winning candidates.

### Team Members

- [Somya Gupta](https://github.com/SG-is-me)
- [Girik Maskara](https://github.com/girik5502)
- [Aryan Sharma](https://github.com/Aryans-20)