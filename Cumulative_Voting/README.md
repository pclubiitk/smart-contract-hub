# A Solidity contract to implement the mechanism of cumulative voting

## Cumulative Voting

Cumulative voting (also referred to as accumulation voting or multi-voting) is a multiple-winner cardinal voting method intended to promote more proportional representation than winner-take-all elections. A cumulative voting election permits voters in an election for more than one seat to put more than one vote on a preferred candidate. When voters in the minority concentrate their votes in this way, it increases their chances of obtaining representation in a legislative body.

## Mechanism

This smart contract implements a cumulative voting mechanism. The owner of the contract has the power to call for nominations for candidates and open the elections, following which citizens can register as candidates and/or voters and then cast their votes. Each registered voter begins with 3 votes which they can choose to distribute among the various candidates. The owner is also the only one with the option of stopping the registrations. Once the votes have been case, the owner is in-charge of calculating the total votes won by eahc candidate and displaying the results of the election. The various functions, structures and variables used to write the contract are as given below. 

### Contract - Cumulative_voting
- Struct - <i>candidate</i>
  - string variable <i>name</i> to store the candidate's name
  - address variable <i>unid</i> to store the candidates unique ID
  - uint256 variable <i>votecount</i> to store the candidate's vote count
  - boolean variable <i>ifAuthC</i> to check if the candidacy is authorised or not
- Struct - <i>voter</i>
  - string variable <i>name</i> to store the candidate's name
  - address variable <i>unid</i> to store the candidates unique ID
  - bool variable <i>ifVoted</i> to check if the voter has voted already or not
  - bool variable <i>ifAuthV</i> to check if the user is authorised to vote or not
- address variable <i>Owner</i> Owner of the contract
- Modifier - <i>isOwner</i>: Modifier to limit the use of certain functions to only the owner
- uint256 variable <i>numberOfSeats</i> to store the number of winners
- Function - <i>getnumberOfSeats</i>
- candidate[] <i>candidateList</i> - List of candidates
- voter[] <i>voterList</i> - List of voters
- <i>authVoters</i> - mapping of authorised voters
- bool variable <i>openToVote</i> 
- bool variable <i>nominationsBeingAccepted</i>
- bool variable <i>resultDeclared</i>
- <i>constructor</i> - To initialize variables 
- Function - <i>getCandidatelist</i>
- Function - <i>signUpVoter</i>
- Function - <i>signUpCandidate</i>
- Function - <i>authoriseVoters</i>
- Function - <i>authoriseCandidates</i>
- Function - <i>closeNominations</i>
- Function - <i>openVoting</i>
- Function - <i>closeVoting</i>
- Function - <i>castVote</i>
- string[] winners
- uint256 variable winnerVoteCount 
- Function - <i>compileResult</i>
- Function - <i>viewResult</i>

## Drawbacks
- In case the last two candidates get the same number of votes and there is only one seat vacant, then according to this smart contract, the person with the lower index number in the array, i.e, the candidate who has registered earlier will be declared as winner. So to fix such tie breakers we might have to use some external conditions.

- While Authorising candidates and voters, here we have assumed that the voters and candidates are authorised to begin with, but in a real-world scenario we would have to use some form of identification such as a Voter ID to authorise a person casting vote or competing in the election.

- In our code the owner of the contract has the power to close nominations, open voting, close voting and declare the result. The <b>Owner</b> can manually perform these functions at the moment when they wish to do so. This flaw of manually doing such things can be automated using block timestamp and providing with the time of registration, voting and result declaration in the code initially.
