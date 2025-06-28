// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "src/Attacker.sol";

contract DeployAttacker is Script{

    function run()external{
        vm.startBroadcast();

    Attacker attacker = new Attacker {value : 0 }(0x881FcC64Dd79512eF46524e1900674BF6B54684a ); 


        vm.stopBroadcast();
    }
}