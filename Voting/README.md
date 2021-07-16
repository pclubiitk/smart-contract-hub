# First-past-the-post voting

In a first-past-the-post (FPTP or FPP; sometimes formally called single-member plurality voting or SMP; sometimes called choose-one voting for single-member districts,
voters cast their vote for a candidate of their choice, and the candidate who receives the most votes wins (even if the top candidate gets less than 50%, which typically happens
when there are more than two popular candidates).

## Mechanism:

1. Owner of the contract <b>Ballot</b>) is called <b>Chairperson</b>. Chairperson deploys the contract by passing: <br>
<b>regduration</b> - how long does the registration continues in hours. Registration time begins as soon as the contract is deployed.<br> 
<b>voteduration</b> - how long does the voting continues in hours. Voting time begins as soon as <b>StartVoting</b> function is called. <br>
Only chairperson can give rights to voters - <b>rightToVote</b>, and only after that they can vote. <br>
Only chairperson can give rights to contestants - <b>rightToContest</b>, and only after that they can stand in election.<br>
When these functions are used, all voters and contestants registered till then get verified by Chairperson.
2. Voters can <b>register</b> themselves just passing their name and a true/false in <b>ascontestant</b> if they want to stand in election as contestant. If the time to register is over, register function doesn't work. <br>
3. Once a voter or contestant registers, they get added to the arrays - voters or contestants. (Note: Every contestant is also a voter so they exist in both the arrays)
4. <b>ShowContestantIndex</b> function gives the index of contestant by passing their name.
5. <b>vote</b> function does the main process - to vote by entering contestant's name and their respective index. <br>
Requirements: Voter and contestant must be verified. Voter hasn't voted yet. proposalIndex must match with contestant's name. Voting time hasn't crossed voteduration.
6. <b>WinnerName</b> function compares the total votes to each contestant to give the winner name.<br>
This can only be run by the Chairperson.

## Instructions to run:

1. Deploy the contract by passing regduration=1 and voteduration=2 with Owner's or Chairperson's address.
2. Register by passing name0, false with voter0's address.
3. Register by passing name1, true with voter1's or contestant0's address.
6. StartVoting with Chairperson's address.
7. Vote name1,0 using voter0's address. Nothing happens because no one is verified.
8. Run rightToVote with Chairperson's address.
9. Vote name1,0 using voter0's address. Still nothing happens because contestants are not verified.
10. Run rightToContest with Chairperson's address.
11. Vote name1,0 using voter0's address.
12. Register by passing name2, false with voter2's and contestant1's address.
16. Run rightToVote and rightToContest with Chairperson's address.
17. Vote name1,0 using voter1's address.
18. Vote name2,0 using voter2's address.
19. Run WinnerName using  Chairperson's address to get the winner's name i.e. name1.
