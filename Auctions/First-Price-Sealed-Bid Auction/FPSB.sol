// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
contract BlindAuction {
    struct Bid {
        bytes32 BlindBid;
        uint Dep;
    }

    address payable public Bnf;
    
    uint public EndBid;
    uint public result;
    bool public hasEnded;
    mapping(address => Bid[]) public bidstrct;
    address public hgst_bidder;
    uint public hgst_bid;

    mapping(address => uint) pendingRet;

    event EndofAuction(address winner, uint hgst_bid);
    error Bidding_ended(uint time);
    error Notyetstarted(uint time);
    error Auction_already_ended();

    modifier _after(uint _time) {
        if (block.timestamp <= _time) revert Notyetstarted(_time);
        _;
    }
      modifier before(uint _time) {
        if (block.timestamp >= _time) revert Bidding_ended(_time);
        _;
    }

    constructor(uint bidtime, uint reveal_time, address payable _Bnf) {
        Bnf = _Bnf;
        EndBid = block.timestamp + bidtime;
        result = EndBid + reveal_time;
    }

    function _Bid(bytes32 _BlindBid) public payable before(EndBid) {
        bidstrct[msg.sender].push(Bid({BlindBid: _BlindBid, Dep: msg.value}));
    }

    function reveal(uint[] memory _val, bool[] memory _wrong, bytes32[] memory _secret) public _after(EndBid) before(result) {
        uint length = bidstrct[msg.sender].length;
        require(_val.length == length);
        require(_secret.length == length);
        require(_wrong.length == length);
        uint refund;
        for (uint i = 0; i < length; i++) {
            Bid storage bidToCheck = bidstrct[msg.sender][i];
            (uint value, bool fake, bytes32 secret) = (_val[i], _wrong[i], _secret[i]);
            if (bidToCheck.BlindBid != keccak256(abi.encodePacked(value, fake, secret))) {
                continue;
            }
            refund += bidToCheck.Dep;
            if (!fake && bidToCheck.Dep >= value) {
                if (Place_bid(msg.sender, value))
                    refund -= value;
            }
            bidToCheck.BlindBid = bytes32(0);
        }
        payable(msg.sender).transfer(refund);
    }
    function backoff() public {
        uint amount = pendingRet[msg.sender];
        if (amount > 0) {
            pendingRet[msg.sender] = 0;
            payable(msg.sender).transfer(amount);
        }
    }
    
    function Place_bid(address bidder, uint value) internal returns (bool success) {
        if (value <= hgst_bid) {
            return false;
        }
        if (hgst_bidder != address(0)) {
            pendingRet[hgst_bidder] += hgst_bid;
        }
        hgst_bidder = bidder;
        hgst_bid = value;
        return true;
    }
    function Auction_Ended() public _after(result) {
        if (hasEnded) revert Auction_already_ended();
        emit EndofAuction(hgst_bidder, hgst_bid);
        hasEnded = true;
        Bnf.transfer(hgst_bid);
    }
}
