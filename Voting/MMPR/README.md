# Mixed Member Proportional Representation(MMPR)

In MMPR each voter casts two votes.

1. *First Vote* : This is used to decide winner of each constituency by First Past The Post system
2. *Second Vote* : This is used to decide representation of each political party in Parliament.  Here will allot extra seats to each party till it is over-represented and then move on to next political party.

## Implementation

1. `constructor` 
   - creates the contract with required number of `seats` and initialises `size` of the Parliament as `2*seats`
   - sets the `chairperson` of the contract.

2. `requestRightToVote` 
   - seat of voter as argument
   - caller of this method are stored in `provisionalVoters` array if they haven't voted or autherized already.
3. `giveRightToVote`
   - `chairperson` can call this method to autherize all users in `provisionalList` to vote
4. `castVote`
   - each autherized voter can cast 2 votes
5. `result`
   - FIrst gives `seats` to party by FPTP in each seat.
   - Remaining 50% seats are filled by allocating candidates to each party until it is over-represented.

#### Contributors

1. [Patil Aditya Bharat](https://github.com/adip1343)
2. [Rohit Kumar](https://github.com/rohitk87)
3. [Abhay Yadav]() 
