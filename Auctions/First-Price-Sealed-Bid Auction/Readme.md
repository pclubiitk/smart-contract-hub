**First-Price-Sealed-Bid Auction**

At a closed price auction for the first price, each buyer sends a closed bid to the seller (that is hidden from other bidders). The top buyer wins and pays his bid well. In general, a closed bid format has two distinct components - the bidding period in which participants submit their bids, and the settlement phase in which bids are opened and the winner is determined.

When multiple units are sold, a closed price auction called the first price is considered a “discriminatory” auction because not all bidders pay the same price. It works as follows. At a discriminatory auction (more than one unit for sale), closed bids are arranged from top to bottom, with items offered at the highest bid price until the end of the term. The most important point to keep in mind is that winning bidders (and they usually do) can pay different prices.

**Implementation –**

- \_bid ()

It takes blinded bit array as the argument. The job of this functions is to place a blinded bid as a hash

- Reveal ()

This fuction is used to reveal the bids. The ether corresponding to all the invalid bids and all the bids, except the winning bid is retured back then. 

- Withdraw()

This function is used to back off the bid which was overbid already.

- AuctionEnd()

This function marks the end of the auction and sends the highest bid to the benefiiary.





