// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "../src/Game.sol";
import "../src/Attacker.sol";

contract AttackTest is Test {
    Game public game;
    Attacker public attacker;

    address deployer = address(0xDEAD);
    address attackerEOA = address(0xBEEF);

    function setUp() public {
        vm.deal(deployer, 1 ether);
        vm.deal(attackerEOA, 1 ether);

        // deploy Game contract with some balance
        vm.prank(deployer);
        game = new Game{value: 1 ether}();

        // deploy attacker contract
        vm.prank(attackerEOA);
        attacker = new Attacker(address(game));
    }

    function testAttackSucceeds() public {
       

        // run attack from attackerEOA
        vm.prank(attackerEOA);
        attacker.attack();

        // verify attacker contract got the ether
        assertEq(address(game).balance, 0);

        // withdraw back to EOA
          vm.prank(attackerEOA);
          attacker.withdraw();

        assertEq(address(attackerEOA).balance, 2 ether);


        
    }
}