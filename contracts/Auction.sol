// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Auction {
  address payable beneficiary;
  uint auctionEndingtime;
  address highestBidder;
  uint highestBid;
  mapping (address => uint) pendingBids;
  bool auctionEnded;

  event highestBidding(address bidder, uint value);
  event declareHighestBidder(address bidder, uint value);

  constructor(address payable _beneficiary, uint _biddingTime) {
    beneficiary = _beneficiary;
    auctionEndingtime = block.timestamp + _biddingTime;
  }

  function bid() payable external{
    require(auctionEndingtime < block.timestamp, 'Auction already finished');
    require(msg.value <= highestBid, 'Bid Not High Enough');
    
    if(highestBid != 0){
      pendingBids[highestBidder] += highestBid;
    }
    highestBid = msg.value;
    highestBidder = msg.sender;
    emit highestBidding(highestBidder, highestBid);
  }

  function withdraw() external{
    uint _value = pendingBids[msg.sender];

    if(_value > 0){  
      pendingBids[msg.sender] = 0;
      if( payable(msg.sender).send(_value) == false){
        pendingBids[msg.sender] = _value;
      }
    }
  }

  function DeclareAuctionEnd() external{
    require(auctionEndingtime > block.timestamp, 'Auction not ended yet');
    require(auctionEnded, 'Ending Auction already called');
    auctionEnded = true;
    emit declareHighestBidder(highestBidder, highestBid);
    beneficiary.transfer(highestBid);
  }
}
