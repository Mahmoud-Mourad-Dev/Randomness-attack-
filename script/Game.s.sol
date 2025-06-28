//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "src/Game.sol";

contract DeployGame is Script {
    function run() external{

        vm.startBroadcast() ;

       Game game = new Game{value: 1 ether}();
 


        vm.stopBroadcast ();

    }
}