Single Transferable Vote –

STV is a proportional representation electoral system in which a person's vote can be transferred to another or more competing candidate (depending on voter preference) if the first person's candidate is removed from the list or has more votes than needed to win the elections and cross the threshold.

Implementation –

Assumptions:

- The number of finally elected candidates in the councel will be equal to the number of regions.
- The Chairperson will have the list of candidates and has the power of giving voting right to the elligible voters.

Code: 

- Structure of a voter consists of variables right given (if he is allowed to vote), region, preference list of voting the candidates in desired order.
- Structure of a candidate consists of variables is valid, is eleminated and if already won and votecount array which will store the identity of the voter who gave the candidate a first preference.
- There is also a constructor in which create a array which stores the information of candidates.
- Give Right to Vote function: It will be called by the chairperson to allow the voter to get a voting right by making the boolean variable true.
- Vote function: This is called by the voter in which we pass the prefrence list of this voter and then we pass the the address of this voter into the votecount list of that candidate who is the voter’s first preference.

Main Computations :

We will be focussing on the two major things we implemented. We will keep on doing either of these two things till we get the required amount of representatives in the counsel-

- ` `We define the threshold as total number of votes divided by the required amount of representatives. If any party is above the threshold, we directly declare the party as on of the winners and keep it out of the race. We divide its excess votes among other parties with lesser prefernces If this condition is not satisfied, we jump to next stop.
- We look for the party with the minimum votes, eliminate it, and divide its votes to the parties which were second or less priority of the voters involved in voting for this party.

After the complete computation, we return the array of the final elected candidates!
