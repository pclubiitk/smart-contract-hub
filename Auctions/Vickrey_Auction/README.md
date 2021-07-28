# Vickrey Auction 

## What is Vickrey Auction 

* A Vickrey auction is a type of sealed-bid auction. Bidders submit written bids without knowing the bid of the other people in the auction. The highest bidder wins but the price paid is the second-highest bid. 

## Instructions to test the contract

* Open the [Remix IDE](https://remix.ethereum.org/) and create a new .*sol file. For steps ahead, we will refer this file by auction.sol. 

* Copy and Paste the code present inside Auction.sol in auction.sol and compile the code. 

* On the left sidebar in Remix IDE, choose the option to Deploy the Smart Contract. 

* Choose the environment as Javascript VM , Account as the top account, let's call it account 1 (we'll be continuing with this naming convention) in drop down menu (will be our chairperson) , select number of seats as 2 and then click on Deploy.

* Now the Auction system is deployed by the chairperson.

 
### Applying for Biding rights

* Select accounts 1, 2, 3 and 4, anad click on *RequestBiddingRights* function to make them apply for Biding rights.

* By clicking on this button twice for the same account, you will see system will tell you that you've already applied for the Biding rights before. 

### Approve buyers

* Once the registration period is over, the chairperson can approve the buyers by clicking on *ApproveBuyers* button.

### Biding starts!

* Select account 3 and make him Bid say $10000. Do the same for other accounts with different bids. 

* Try bidding again from account 3, you will see that system won't allow you.

### Results! 

* Now, chairperson will close the auction period by clicking on *closeBiddingPeriod* button. 
 
* And he will get the results by clicking on the *Results* button, which will return the address of the winner along with the amount he has to pay.
