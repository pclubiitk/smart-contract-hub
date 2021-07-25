# <p align = "center"> A solidity contract to implement the mechanism of a Japanese auction </p>

## Japanese Auction

A [Japanese auction](https://en.wikipedia.org/wiki/Japanese_auction) is a dynamic auction format. An initial, typically low price, decided by the seller is displayed. All buyers that are interested in buying the item at this displayed price enter the auction arena. The displayed price is then increased - either as a function of time or in small, discrete steps. Each buyer may exit the arena at any moment and once they do, they are not allowed to re-enter the arena. When a single buyer remains in the arena, the auction stops. The remaining buyer wins the item and pays the displayed price.

A Japanese auction is different from an [English Auction](https://en.wikipedia.org/wiki/English_auction) in that it is not an open-outcry type of auction, i.e. the buyers cannot raise the bids on their own, rather it is increased periodically according to a pre-determined method by the seller or the auction house, as described above. It is a [truthful mechanism](https://en.wikipedia.org/wiki/Strategyproofness), meaning each buyer is best off bidding exactly what they believe the item is worth.

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

## Salient features of the code

- It allows the auctioneer to set the base price and increment amount before the auction begins.
- It ensures that a buyer must be authorised in order to bid on an item, and once they withdraw they are not allowed back in.
- As soon as there is only one bidder left, the auction ends automatically and the item is sold.

## Opportunities for improvement

- In real-life situations, the auctioneer/auction house is a separate entity from the seller. This may be included in the contract by allowing uses to register as sellers and sell their items via a japanese auction mechanism. In this case, the seller may set the base price and/or the increment amount.
- An option to actually transfer currency may be implemented in the contract, as had been done in the [first assignment](https://github.com/yushananda/Game-of-Blocks/tree/main/Assignment2).

## Contributors
 
- [Aditya Subramanian](https://github.com/pingy711)
- [Ayush Anand](https://github.com/yushananda)
- [Yash Goel](https://github.com/yashgoel72) 
