// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "src/Game.sol";

contract gameTest is Test {
    Game game ;

    address player1 = address(1234) ;  // account call play 
    address player2 = address(567);

    function setUp() public{

         game = new Game {value : 1 ether}(); //deploy Game

        vm.deal(player1 ,1 ether ) ; 
        vm.deal(player2 , 1 ether);
    }


    function testInitialBalance () public view {
        assertEq(address(game).balance , 1 ether );
    }


    function testCorrectGuess() public{

        uint256 correctGuess = block.timestamp + block.number ;

        vm.prank(player1);  // player run

        game.play(correctGuess);

        assertEq(player1.balance , 2 ether) ;
        assertEq(address(game).balance , 0 ) ;

        
    }

    function testIncorrectGuess() public{

        uint256 incorrectGuess = 1 ;

        vm.prank(player1);  // player run

        game.play(incorrectGuess);

        assertEq(player1.balance , 1 ether) ;
        assertEq(address(game).balance , 1 ether ) ;

        
    }

    function testMultipleAttempts() public {

        vm.prank(player1);

        uint correctNumber = block.timestamp + block.number  ; 

        game.play(correctNumber) ;

        assertEq(player1.balance , 2 ether);


        vm.prank(player2);

        game.play(12454);

        assertEq(player2.balance , 1 ether) ;

    }

    function testCannotWinAfterPrizeClaimed() public{
        vm.prank(player1);

        uint correctnumber = block.timestamp + block.number  ; 

        game.play(correctnumber) ;

        assertEq(player1.balance , 2 ether);


        vm.prank(player2);

        uint correct = block.timestamp + block.number  ; 


        game.play(correct);

        assertEq(player2.balance , 1 ether) ;

    }


}