// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

/*
发行一个具备回调功能的 ERC20Token , 加入回调token

tokensReceived

• 保持原有逻辑下,扩展 TokenBank, 实现在转账回调中,将

Token 存入 TokenBank

• 转账用 OpenZeppelin 的 safeTransferFrom
*/


import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

interface IBank {
        function tokenRecieve(address user, uint amount) external;
} 

contract btcToken is ERC20{
    
    constructor() ERC20("bitcoin", "BTC"){
         owner = msg.sender;
    }

    address private owner;
    error NotOwner(address user);
    modifier onlyOwner{
        if(msg.sender != owner) revert NotOwner(msg.sender);
        _;
    }

   //铸造代币给对应用户
   function distributeTokens(address receiver, uint amount) public onlyOwner{
        _mint(receiver, amount);
   }
   
   //用户直接向目标地址存款
   function deposit(address bank, uint amount) public{
         _transfer(msg.sender, bank, amount);
        IBank(bank).tokenRecieve(msg.sender, amount);

   }


}