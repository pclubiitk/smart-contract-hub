SMART CONTRACT - SINGLE NON - TRANSFERABLE VOTING SYSTEM (SNTV)

SNTV is a generalization of first-past-the-post system (FPTP).

In this the posts are filled with the candidates with the most votes.

For example-
in a three seat constituency, the top three candidates with the most votes will be elceted.

The code has been tested in REMIX.

It takes in the number of candidates to be elected in the variable 'winners'
It returns the names of the winners in an array names 'winnerName_'

Project by-
Muditt Khurana   200602


This is a soidity contract to implement Single non transferable vote.
It includes the chairman of election which will also be the owner of the contract.
The max limit for number of participating candidates will be 500.
The voters, will be given a Unique ID number, which can be used if they choose to participate in elections. The chairperson will decide whether a particular voter can vote or not.
Similarly it will be on discretion of Chairperson to allow a voter to become a candidate or not.

Finally, the chairperson can close voting after 50% is done, and the results will be declared. If there is a tie than Chairman's vote will serve as the tiebreaker, otherwise no winner will be declared.

Project by-
Aryaman Singhal  200196
