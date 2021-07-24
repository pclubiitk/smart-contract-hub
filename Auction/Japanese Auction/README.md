# <p align = "center"> A solidity contract to implement the mechanism of a Japanese auction </p>

## Japanese Auction

A [Japanese auction](https://en.wikipedia.org/wiki/Japanese_auction) is a dynamic auction format. An initial, typically low price, decided by the seller is displayed. All buyers that are interested in buying the item at this displayed price enter the auction arena. The displayed price is then increased - either as a function of time or in small, discrete steps. Each buyer may exit the arena at any moment and once they do, they are not allowed to re-enter the arena. When a single buyer remains in the arena, the auction stops. The remaining buyer wins the item and pays the displayed price.

A Japanese auction is different from an [English Auction](https://en.wikipedia.org/wiki/English_auction) in that it is not an open-outcry type of auction, i.e. the buyers cannot raise the bids on their own, rather it is increased periodically according to a pre-determined method by the seller or the auction house, as described above.

## Mechanism

The solidity contract implements the japanese auction mechanism in the following way:
1. The Auctioneer deploys the contract and uses the <i>setBasePrice</i> function to set the <i>basePrice</i> and <i>incrementPerSecond</i> for the item.
2. Then the buyers can use the <i>getCurrentPrice</i> function to get the current price of item (which is the <i>basePrice</i> before the auction starts and increments with time when the auction is started)
3. The buyers can use <i>signUpAsBuyer</i> function to enter as bidders in the auction.
4. The auctioneer can use the function <i>authorise</i>, to authorise all the buyers.
5. The auctioneer then uses the <i>startAuction</i> function to start the auction, and the bidding price of item increases every second at the rate of <i>incrementPerSecond</i>.
6. The buyers can check the <i>currentPrice</i> of item by using <i>getCurrentPrice</i> function.
7. The buyers can withdraw their bid by using the <i>withdraw</i> function.
8. The Auction automatically ends when their is only one bidder left. The program then emits the winner address and the amount at which the item has been bought.

 
