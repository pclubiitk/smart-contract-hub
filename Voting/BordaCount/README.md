# Voting Smart Contract - Borda Count

**Introduction**: This contract is a decentralised implementation of the Borda Count Voting mechanism. In this mechanism, a voter assigns ranks to the candidates, and accordingly the candidates gain some points. In our implementation, the candidate at rank 1 receives 5 point, 3 points for rank 2 and 1 point for rank 3. These points are then added up to calculate the total points gained by the candidate. Finally, the candidate with highest points is declared winner.

- ## Constructor:
  When the contract is deployed from an address, the `Chairperson` is set as the address of the creator:   
    ```chairperson=msg.sender;```
- ## register:  
  ### Visibility-*Public* 
  This function can be called from any address only once. It pushes the address into the `provisional_voters` array and sets the `isUnregisteredVoter` mapping of this address as false.
  ```
  provisional_voters.push(msg.sender);
  isUnregisteredVoter[msg.sender]=true;
  ```
  Calling this function from the same address again would throw an error. 
 - ## giveRightToVote:  
    ### Visibility-*Public* 
    This function can only be called from the `Chairperson` address. In other cases, it will raise an error.
    It maps the addresses stored in the `provisional_voters` array to struct `voter` and sets the isPresent of that addres to true. During the time of voting,
    only the addresses with isPresent as true, would be able to cast their votes.
   ```
   voters[provisional_voters[i]] = voter;
   isPresent[provisional_voters[i]]= true; 
   ```
- ## register_for_candidate:  
  ### Visibility-*Public* 
  This function can be called from an address which has been registeres as voter, that too, only once. It pushes the address into the `provisional_candidates` array and sets the isUnregisteredCandiate mapping of this address as false.
  ```
  provisional_candidates.push(msg.sender);           
  isUnregisteredCandiate[msg.sender] = true; 
  ```
  Calling this function from the same address again would throw an error.
  
 - ## approve_candidates:  
    ### Visibility-*Public* 
    This function can only be called from the `Chairperson` address. In other cases, it will raise an error.
    It first creates a variable struct `candidate` which stores the address of the candidate and initialises its vote count to 0. Then it pushes those candidates from the `provisional_candidates` array into the `candidates` array, which have not been visited earlier. This is accomplished by using a `pointing_to_tip` variable.
    
   ```
   for(uint i=pointing_to_tip;i< provisional_candidates.length;i++){
            temp.index = num_of_candidates++;
            
            temp.name= provisional_candidates[i];
            candidates.push(temp);
        }
   ```    
    The `pointing_to_tip` variable is then set to 1 more than the last visited index.
    >```pointing_to_tip=provisional_candidates.length;```

- ## vote:
    ### Visibility-*Public*
    Any registered voter can call this function once, and give the index of his/her preffered candidates(from the `candidates` array) as the arguments.
    The respective voteCounts (three- one for each rank) of the candidates are increased accordingly.
    ```
    candidates[candidate1].voteCount1 ++ ;
    candidates[candidate2].voteCount2 ++ ;
    candidates[candidate3].voteCount3 ++ ;
    ```
    It throws an error if a voter tries to assign 2 or more ranks to a single candidate.
- ## winningcandidate:
    ### Visibility-*Public*
    This function can be called by any address any number of times. It calculates the total score of a candidate by adding up his/her points according to the algorithm described in the introduction, and keeps a note of the candidate with the current maximum score. 
    > `uint voteCount = (candidates[p].voteCount1)*5 + (candidates[p].voteCount2)*3 + (candidates[p].voteCount3);` 
    
    It finally returns the index of the candidate who achieves a maximum score.
    
    
- ## winningname:
    ### Visibility-*Public*
    This function can be called by any address any number of times. This would simply return the address of the `winningcandidate_`
    > `winnerName_ = candidates[winningcandidate()].name;`


## Contributers:
- [Shorya Kumar](https://github.com/shoryak)
- [Pranab Pandey](https://github.com/pranabp-bit)
- [Piyush Agarwal](https://github.com/piyuagr)



