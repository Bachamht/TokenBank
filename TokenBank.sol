// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
/*
发行一个具备回调功能的 ERC20Token , 加入回调token

tokensReceived

• 保持原有逻辑下,扩展 TokenBank, 实现在转账回调中,将

Token 存入 TokenBank

• 转账用 OpenZeppelin 的 safeTransferFrom
*/

interface IbtcToken {
        function  transferFrom(address from, address to, uint256 value) external;
        function  approve(address spender, uint256 value) external;
} 

contract TokenBank  {

    address private administrator;
    mapping(address => uint) private balances;
    error NotAdministrator(address user);
    modifier onlyAdministrator{
        if(msg.sender != administrator) revert NotAdministrator(msg.sender);
        _;
    }

    constructor() {
        administrator = msg.sender;
    }

    //用户存款
    function deposit(address token, uint amount) public {
        IbtcToken(token).transferFrom(msg.sender, address(this), amount);
        balances[msg.sender] += amount;
    }
    
    //管理员撤资
    function withdraw(address token) public  onlyAdministrator{
        IbtcToken(token).approve(administrator, address(this).balance);
        IbtcToken(token).transferFrom(address(this), administrator, address(this).balance);
    }
    
    //用户查看存款
    function viewBalance() public view returns(uint){
        return balances[msg.sender];
    }

    //对用户直接转进地址的代币进行处理
    function tokenRecieve(address user, uint amount) external {
        balances[user] += amount;
    }

}
