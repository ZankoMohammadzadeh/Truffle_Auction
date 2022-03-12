// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Auction {
  address payable proficienary;
  uint endingTime;
  address highestBidder;
  uint highestBid;
  mapping (address => uint) remainedBid;

  event highestBidding(address, uint);

  constructor(address payable _proficienary, uint _EndingTime) {
    proficienary = _proficienary;
    endingTime = block.timestamp + _EndingTime;
  }

  function bid() payable public{
    require(endingTime <= block.timestamp, 'Auction is already finished');
    if(msg.value > highestBid){
      if(highestBid != 0){
        remainedBid[highestBidder] = highestBid;
      }
      highestBid = msg.value;
      highestBidder = msg.sender;
      emit highestBidding(highestBidder, highestBid);
    }
  }

  
}
