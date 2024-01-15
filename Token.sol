// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

/*
 部署自己的 Token(ERC20)

• 编写一个TokenBank ,可以将Token 存入 TokenBank:

• 记录每个用户存入的 token 数量

• 管理员可以提取所有的Token (withdraw 方法)。
*/


import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

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
   


}