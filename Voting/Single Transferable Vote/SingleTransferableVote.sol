pragma solidity ^0.8.6;
pragma experimental ABIEncoderV2;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.


     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}


contract SingleTransferableVote {
    address public chairperson;
    struct Voter {
        bool RightGiven;
        uint256[] pref;
        bool hasVoted;
        uint region;
    }
    struct Candidate {
        //string name;
        bool iVC;
        bool isE;
        bool hasWon;
        address[] voteCount;
        address add;
    }
    mapping(address=>Voter) public VoterList;
    Candidate[] public candidates;
    uint numRegions = 1;
    

    constructor(address[] memory cand) {
        chairperson = msg.sender;
        address[] memory tmp = new address[](0);
        for(uint i=0;i<cand.length;i++) {
            candidates.push(Candidate({iVC: true, isE: false,hasWon: false, voteCount: tmp ,add: cand[i]}));
        }
        
    }
    
    function giveRightToVote(address _voter, uint _region) public {
        require(msg.sender == chairperson, "Only chairperson can give right to Vote");
        require(!VoterList[_voter].RightGiven, "Voter already verified");
        VoterList[_voter].RightGiven = true;
        VoterList[_voter].region  = _region;
        VoterList[_voter].hasVoted = false;
        if(_region>numRegions) {
            numRegions = _region;
        }
    }
    
    function vote(uint256[] memory _pref) public {
        Voter storage sender = VoterList[msg.sender];  
        require(sender.RightGiven, "Voter is not verified");
        require(sender.hasVoted, "Voter has already Voted");
        sender.hasVoted = true;
        sender.pref = _pref;
        candidates[_pref[0]].voteCount.push(msg.sender);
    }
    //uint256 c = a / b;
    uint[] public winnerList = new uint[](numRegions);
    function mainComp() public{
        uint numVotes = 0;
        for(uint i=0;i<candidates.length;i++) {
            numVotes+=candidates[i].voteCount.length;
        }
        uint256 threshold = SafeMath.div(numVotes, numRegions);
        uint numDelegates = 0;
        uint cnt=0;
        uint f=100;
        while(numDelegates<numRegions) {
            uint max = 0;
            uint maxi = 255;
            uint min = 999;
            uint mini = 255;
            for(uint i=0;i<candidates.length;i++) {
                if(!candidates[i].hasWon && candidates[i].voteCount.length>max) {
                    max = candidates[i].voteCount.length;
                    maxi = i;
                }
                if(!candidates[i].isE && candidates[i].voteCount.length<min) {
                    min = candidates[i].voteCount.length;
                    mini = i;
                }
            }
            if(maxi==255) {
                break;
            }
            if(max == threshold) {
                candidates[maxi].hasWon = true;
                numDelegates++;
                winnerList[cnt++] = maxi;
                continue;
            } else if(max>threshold) {
                // max/threshold
                numDelegates += (candidates[maxi].voteCount.length/threshold);
                for(uint i=0;i<max/threshold;i++) {
                    winnerList.push(maxi);
                }
                for(uint i=candidates[maxi].voteCount.length-1;i>=threshold*(max/threshold);i--) {
                    address x = candidates[maxi].voteCount[i];
                    for(uint j=1;j<VoterList[x].pref.length;j++) {
                        // !hasWon and !isE
                        if(!candidates[VoterList[x].pref[j]].hasWon && !candidates[VoterList[x].pref[j]].isE) {
                            candidates[VoterList[x].pref[j]].voteCount.push(x);
                            break;
                        }
                    }
                }
            } else {
                // someone has to be eliminated
                candidates[mini].isE = true;
                for(uint i=candidates[mini].voteCount.length-1;i>=0;i--) {
                    address x = candidates[mini].voteCount[i];
                    for(uint j=1;j<VoterList[x].pref.length;j++) {
                        // !hasWon and !isE
                         if(!candidates[VoterList[x].pref[j]].hasWon && !candidates[VoterList[x].pref[j]].isE) {
                            candidates[VoterList[x].pref[j]].voteCount.push(x);
                            break;
                        }
                    }
                }
            }
            if(--f<0) break;
        }
    }
}
