## First Past the Post Voting implementation using Solidity
In this assignment we implemented this voting system with funtionalities like **approving voters, approving candidates, viewing candidates**

### How the voting system runs-
1. The chairperson deploys the contract. He is made the owner of the contract.
2. Various voters and candidated registers through funtion *voter_registration()* and *NETA_registration*.
3. The chairperson approves the candidates and votes through function *approve_voter()* and *NETA_approve()*
4. The voters can see all the available candidates with help of *veiwAll_NETA()* function and can vote them through *voteYour_NETA()* function
5. Now the chairperson runs *find_winner()* function and the result is stored in **winner** variable which anyone can view.
6. Every voter can view the number of votes gained by each candidate. 

### Main variables

1. NETA_list- Stores address of all candidates.  
1. voter_list - Stores address of all voters.  
1. voters - Its a mapping from addresses of different voters to Voter. 
1. Voter - Its a map from address of an voter to keep a track of if he approved or not, if he already voted or not.  
1. Neta_approved - Its a boolean array that keep track if the candidate is approved by chairperson or not.  
1. vote_cnt - Its a map from address of candidates to the number of votes they get.  


Since it was not very clear to us about what to keep private and what to keep public (like should the voters be public or private etc) so I declared them according to my ease.
