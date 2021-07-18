# Block Voting 

## What is Block Voting 

* In a block voting election, all candidates run against each other for *m* number of positions (m is called *seats* in our code). Each voter selects up to m candidates (voters are sometimes said to have m votes; however, they are unable to vote for the same candidate more than once). Voters are most commonly permitted to cast their votes across more than one party list. The m candidates with the most votes (who may or may not obtain a majority of available votes) are the winners and will fill the positions.

## Instructions to test the contract

* Open the [Remix IDE](https://remix.ethereum.org/) and create a new .*sol file. For steps ahead, we will refer this file by vote.sol. 

* Copy and Paste the code present inside a3.sol in vote.sol and compile the code. 

* On the left sidebar in Remix IDE, choose the option to Deploy the Smart Contract. 

* Choose the environment as Javascript VM , Account as the top account, let's call it account 1 (we'll be continuing with this naming convention) in drop down menu (will be our chairperson) , select number of seats as 2 and then click on Deploy.

* Now the voting system is deployed by the chairperson, to select 2 candidates. 

### Applying for candidature

* Now let's make the account 2, 3, and 4 apply for candidature. 

* For that select those accounts one by one from the drop down menu above, after selecting an account click on *RequestCandidature* button. 

* Note this will trigger the *RequestVotingRights* function too, so the candidate need not apply for voting rights seperately.  
 
 
### Applying for Voting rights

* Select accounts 5 and 6, anad click on *RequestVotingRights* function to make them apply for voting rights. 

* By clicking on this button twice for the same account, you will see system will tell you that you've already applied for the voting rights before. 

### Approve candidatures and close registration period

* Chairperson will now approve all the candidatures by clicking on *ApproveCandidature* button and close the registration period by clicking on *closeRegistrationPeriod* button. 

* You can check now that 3 candidates are there by clicking on *CheckNumberOfCandidates* button and get the full list by clicking on *viewAllCandidates* button. 

### Approve voters

* Once the registration period is over and number of candidates is finalized, the chairperson can approve the voters by clicking on *ApproveVoters* button.


### Voting starts! 

* Select account 5 and make him give his vote to account 3 and 4 by clicking on *vote* button twice, giving account 3 address as the parameter for the first time and account 4 address as the parameter for the second time. 

* Select account 5 and make him give his vote to account 2, 3 and 4 by clicking on *vote* button thrice, rest is similar as above. You will see you won't be able to cast the third vote to account 4 since the chairperson deployed the voting system for 2 seats only. Hence each person can cast his vote to only 2 people. 

* Lastly, make all the candidates give themselves one vote each by following the steps same as above. 

* So up till now, 2 votes have been cast to account 2, 3 votes have been cast to account 3 and 2 votes have been cast to account 4. 

* Now, let's make the account 2 and 3 give each other a vote too. (Reason : They've colluded to make 4 lose (Real Reason: Our system doesn't handle tie cases yet.))

* Click on transact and the loan amount would be transferred to the requestor's account only if there is sufficient balance in the account.

* Now, 3 votes have been cast to account 2, 4 votes have been cast to account 3 and 2 votes have been cast to account 4.

### Counting starts! 

* Now, chairperson will close the voting period by clicking on *closeVotingPeriod* button 
 
* And he will start the counting by clicking on the *Count* button, which will count the votes and return the list of the selected candidates.
