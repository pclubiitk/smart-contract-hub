# A Solidity contract to implement the mechanism of cumulative voting

## Cumulative Voting

Cumulative voting (also referred to as accumulation voting or multi-voting) is a multiple-winner cardinal voting method intended to promote more proportional representation than winner-take-all elections. A cumulative voting election permits voters in an election for more than one seat to put more than one vote on a preferred candidate. When voters in the minority concentrate their votes in this way, it increases their chances of obtaining representation in a legislative body.

## Mechanism

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

## Instructions to run

## Drawbacks
