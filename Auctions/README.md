# How it Works
* First the Owner deploys the contract and run the *StartAuction()* function with a input time.
* Then the bidders bid. If your bid is greater then the highest bid then then the previous higest bid goes into pendingReturns and HighestBid varible is modified.
* If any bidder except the wants to withdraw money then 
  1. If he is the highest bidder then he can withdraw **max(0,Total_bid-HighestBid)**
  2. else bidder can withdraw the amount.
* Once the set time by owner is over he can end the auction by calling *endAuction()*.
