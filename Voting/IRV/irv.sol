// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.6;

/// @title Instant Run-off Election implementation
/// @author S., Piyush, B.
/// @notice SnT Assignment

/*
INFO
Instant_Run-off Election:
Majoritarian voting can take place in a single round using instant-runoff voting (IRV), whereby voters rank candidates in order of preference; this system is used for parliamentary elections in Australia and Papua New Guinea. If no candidate receives a majority of the vote in the first round, the second preferences of the lowest-ranked candidate are then added to the totals. This is repeated until a candidate achieves over 50% of the number of valid votes. If not all voters use all their preference votes, then the count may continue until two candidates remain, at which point the winner is the one with the most votes.
*/

/*
NOTE: arrays store the request addresses, mappings relate them to structs.
*/

contract IRV {
    event ChairSet(address indexed oldChair, address indexed newChair);
    event Draw();
    event Winning(address indexed candidate);
    event CandidateDeclared(
        address indexed newcandidateAddress,
        string newCandidateName
    );

    struct Voter {
        bool isCandidate;
        bool hasVoted;
        bool hasRequested;
        uint256[] Pref;
    }
    struct Candidate {
        string name;
        uint256 voteCount;
        bool hasBeenEliminated;
    }

    mapping(address => Voter) voters; //Voters dictionary
    address[] private voterAddr; // Voters list
    address[] private VoterRequests;

    mapping(address => Candidate) candidates; // Candidates dictionary
    mapping(address => string) PossibleCandidateNames; // Candidate Name list
    address[] private candidateAddr; // Candidates list
    address[] private CandidateRequests;

    address private Chairperson;
    modifier isChairperson {
        require(
            msg.sender == Chairperson,
            "Only the Chairperson is allowed to perform this operation."
        );
        _;
    }

    uint256 private period;

    constructor() {
        Chairperson = msg.sender;
        period = 1;
        emit ChairSet(address(0), Chairperson);
    }

    // SECTION: Voting Registration Period.

    function RequestVotingRights() public {
        require(period == 1, "Voter Registration period is over");
        uint256 t = 0;
        address curr = msg.sender;
        for (uint256 i = 0; i < voterAddr.length; i++) {
            if (voterAddr[i] == curr) {
                t = 1;
                break;
            }
        }
        require(
            t == 0,
            "Only a non-registred voter can perform this operation."
        );
        VoterRequests.push(msg.sender);
    }

    function ApproveVoters() public isChairperson {
        require(period == 1, "Voter Registration period is over");
        for (uint256 i = 0; i < VoterRequests.length; i++) {
            voterAddr.push(VoterRequests[i]);
            voters[voterAddr[i]].hasVoted = false;
            voters[voterAddr[i]].isCandidate = false;
            voters[voterAddr[i]].hasRequested = false;
        }
    }

    function RequestCandidature(string memory name) public {
        require(period == 1, "Voter Registration period is over");
        // require msg.sender to be a voter.
        uint256 t = 0;
        for (uint256 i = 0; i < voterAddr.length; i++) {
            if (voterAddr[i] == msg.sender) {
                t = 1;
                break;
            }
        }
        require(t == 1, "Only a registered voter can perform this operation.");
        require(
            !voters[msg.sender].isCandidate,
            "Already a registered candidate"
        );
        require(
            voters[msg.sender].hasRequested == false,
            "You have already requested candidature."
        );
        CandidateRequests.push(msg.sender);
        PossibleCandidateNames[msg.sender] = name;
        voters[msg.sender].hasRequested = true;
    }

    function ApproveCandidature() public isChairperson {
        require(period == 1, "Voter Registration period is over");
        for (uint256 i = 0; i < CandidateRequests.length; i++) {
            if (voters[CandidateRequests[i]].isCandidate) continue;
            candidateAddr.push(CandidateRequests[i]);
            candidates[candidateAddr[i]].voteCount = 0;
            candidates[candidateAddr[i]].name = PossibleCandidateNames[
                CandidateRequests[i]
            ];
            voters[candidateAddr[i]].isCandidate = true;
            candidates[candidateAddr[i]].hasBeenEliminated = false;
            emit CandidateDeclared(
                candidateAddr[i],
                PossibleCandidateNames[CandidateRequests[i]]
            );
        }
    }

    uint256 private numberOfCandidates;

    function closeRegistrationPeriod() public isChairperson {
        delete CandidateRequests;
        delete VoterRequests;
        numberOfCandidates = candidateAddr.length;
        period = 2;
    }

    // SECTION: Voting Period.

    function vote(uint256[] memory preferenceList) public {
        require(period == 2, "Can't vote currently");
        uint256 t = 0;
        address curr = msg.sender;
        for (uint256 i = 0; i < voterAddr.length; i++) {
            if (voterAddr[i] == curr) {
                t = 1;
                break;
            }
        }
        require(t == 1, "Only a registered voter can perform this operation.");
        require(voters[curr].hasVoted == false, "Already Voted.");
        require(
            preferenceList.length == candidateAddr.length,
            "Preference order should include all candidates."
        );

        for (uint256 i = 0; i < preferenceList.length; i++) {
            if (
                preferenceList[i] >= numberOfCandidates || preferenceList[i] < 0
            ) t = 0;
        }
        require(t == 1, "Invalid Candidate provided.");

        voters[curr].hasVoted = true;
        // BUG: Not sure if array gets completely copied or only pointer is copied, else memory attribute will lead to its deletion.

        // FIXME: Longer route
        for (uint256 i = 0; i < numberOfCandidates; i++) {
            voters[curr].Pref.push(preferenceList[i]);
        }
        candidates[candidateAddr[preferenceList[0]]].voteCount++;
    }

    /*
    function viewAllCandidates() public view returns (string memory) {
        // BUG - memory or storage or calldata
        string memory FinalCandidateNameList;
        for (uint256 i = 0; i < candidateAddr.length; i++)
            FinalCandidateNameList.push(candidates[candidateAddr[i]].name);
        return FinalCandidateNameList;
    }
    */
    function CheckNumberOfCandidates() public view returns (uint256) {
        return numberOfCandidates;
    }

    function CheckCandidateName(uint256 k) public view returns (string memory) {
        return candidates[candidateAddr[k]].name;
    }

    // SECTION: Calculation Period.

    bool private majorityFound = false;
    bool private draw = false;
    uint256[] private tmp;

    function MakeZero() private {
        uint256 i = 0;
        for (i = 0; i < numberOfCandidates; i++) {
            tmp.push(0);
        }
    }

    function mainCalculation() public isChairperson returns (uint256 winner) {
        period = 3;
        MakeZero();
        uint256 winningCandidate; // candidateAddr
        while ((!majorityFound) && (!draw)) {
            winningCandidate = majorityOrEliminatedCandidate();
            if (majorityFound || draw) {
                if (!draw) {
                    emit Winning(candidateAddr[winningCandidate]);
                }
                return winningCandidate;
            }

            uint256 losingCandidate = winningCandidate;
            candidates[candidateAddr[losingCandidate]].hasBeenEliminated = true;
            eliminateCandidate(losingCandidate);
            numberOfCandidates--;
        }
    }

    // NOTE: numberOfCandidates is tracking how many candidates are still in the contest.

    function majorityOrEliminatedCandidate()
        private
        returns (uint256 winLoser)
    {
        if (numberOfCandidates > 0) {
            uint256 maxIndex = 0;
            uint256 maxVotes = 0;
            uint256 minIndex = 0;
            uint256 minVotes = voterAddr.length;
            for (uint256 i = 0; i < candidateAddr.length; i++) {
                if (candidates[candidateAddr[i]].hasBeenEliminated) continue;
                if (candidates[candidateAddr[i]].voteCount >= maxVotes) {
                    maxIndex = i;
                    maxVotes = candidates[candidateAddr[i]].voteCount;
                }
                if (candidates[candidateAddr[i]].voteCount <= minVotes) {
                    minIndex = i;
                    minVotes = candidates[candidateAddr[i]].voteCount;
                }
            }
            if (
                (2 * maxVotes == voterAddr.length) && (numberOfCandidates == 2)
            ) {
                draw = true;
                emit Draw();
                return maxIndex;
            }
            if (2 * maxVotes > voterAddr.length) {
                majorityFound = true;
                return maxIndex;
            } else return minIndex;
        }
    }

    // [1,2,3,4,5] -x->2
    // tmp = [1,-,3,4,5]
    // [1,3,4,5,5-junk]
    function eliminateCandidate(uint256 indexOfLosingCandidate) private {
        //uint256[] memory tmp;
        for (uint256 i = 0; i < voterAddr.length; i++) {
            uint256 k = 0;
            for (uint256 j = 0; j < numberOfCandidates; j++) {
                if (voters[voterAddr[i]].Pref[j] != indexOfLosingCandidate)
                    tmp[k++] = voters[voterAddr[i]].Pref[j];
            }
            // copy back tmp to voters[voterAddr[i]].Pref
            for (uint256 j = 0; j < numberOfCandidates - 1; j++) {
                voters[voterAddr[i]].Pref[j] = tmp[j];
            }
        }

        for (uint256 i = 0; i < candidateAddr.length; i++) {
            candidates[candidateAddr[i]].voteCount = 0;
        }

        // update candidates' votes
        for (uint256 j = 0; j < voterAddr.length; j++) {
            candidates[candidateAddr[voters[voterAddr[j]].Pref[0]]].voteCount++;
        }
    }
}

// SECTION: debugging functions

/*
function checkVoterAddr(uint256 k) public view returns (address) {
    return voterAddr[k];
}

function checkVoterCandidature(uint256 k) public view returns (bool) {
    return voters[voterAddr[k]].isCandidate;
}

function checkCandidateAddr(uint256 k) public view returns (address) {
    return candidateAddr[k];
}

function ChairAddr() public view returns (address) {
    return Chairperson;
}

function Checkperiod() public view returns (uint256) {
    return period;
}

function ChangePeriod(uint256 k) public isChairperson {
    require(k == 1 || k == 2 || k == 3, "Invalid period");
    period = k;
}

function CheckVote(uint256 voterIndex, uint256 k)
    public
    view
    returns (uint256)
{
    return voters[voterAddr[voterIndex]].Pref[k];
}

function CheckHasVoted(uint256 voterIndex) public view returns (bool) {
    return voters[voterAddr[voterIndex]].hasVoted;
}

function CheckMajorityFound() public view returns (bool) {
    return majorityFound;
}

function CheckCandidateVote(uint256 k) public view returns (uint256) {
    return candidates[candidateAddr[k]].voteCount;
}

function Test() public {
    period = 2;
    voterAddr.push(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2);
    voterAddr.push(0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c);
    voterAddr.push(0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db);
    voterAddr.push(0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB);
    voterAddr.push(0x617F2E2fD72FD9D5503197092aC168c91465E7f2);
    voterAddr.push(0x17F6AD8Ef982297579C203069C1DbfFE4348c372);
    candidateAddr.push(voterAddr[0]);
    candidateAddr.push(voterAddr[1]);
    candidateAddr.push(voterAddr[2]);
    candidateAddr.push(voterAddr[3]);
    for (uint256 i = 0; i < 6; i++) {
        voters[voterAddr[i]].hasVoted = true;
        voters[voterAddr[i]].hasRequested = false;
        if (i < 4) {
            voters[voterAddr[i]].isCandidate = true;
            voters[voterAddr[i]].hasRequested = true;
            candidates[candidateAddr[i]].name = "blah";
            candidates[candidateAddr[i]].voteCount = 0;
            candidates[candidateAddr[i]].hasBeenEliminated = false;
        } else voters[voterAddr[i]].isCandidate = false;
    }
    voters[voterAddr[0]].Pref = [0, 2, 1, 3]; //->[0,2,1]
    voters[voterAddr[1]].Pref = [1, 0, 2, 3]; //->[1,0,2]
    voters[voterAddr[2]].Pref = [2, 0, 1, 3]; //->[2,0,1]
    voters[voterAddr[3]].Pref = [3, 2, 1, 0]; //->[2,1,0]
    voters[voterAddr[4]].Pref = [1, 2, 0, 3]; //->[1,2,0]
    voters[voterAddr[5]].Pref = [0, 2, 3, 1]; //->[0,2,1]
    candidates[candidateAddr[0]].voteCount = 1;
    candidates[candidateAddr[1]].voteCount = 2;
    candidates[candidateAddr[2]].voteCount = 3;
    candidates[candidateAddr[3]].voteCount = 3;
}

// voter0-0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
// voter1-0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c
// voter2-0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
// voter3-0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB
// voter4-0x617F2E2fD72FD9D5503197092aC168c91465E7f2
// voter5-0x17F6AD8Ef982297579C203069C1DbfFE4348c372
// chairperson-0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
// 0-[0,2,1]
// 1-[1,0,2]
// 2-[2,0,1]
// 3-[2,0,1]
// 4-[2,1,0]
// 5-[1,2,0]
*/
