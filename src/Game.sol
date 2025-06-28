// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract Game {
    constructor() payable{

    }

    function play(uint256 guess) external{
        uint256 randomNumber = block.timestamp + block.number ; 

        if(randomNumber == guess){
           payable(msg.sender). transfer(address(this).balance);        
        }
    }


   
   
}