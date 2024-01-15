// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

/*
 部署自己的 Token(ERC20)

• 编写一个TokenBank ,可以将Token 存入 TokenBank:

• 记录每个用户存入的 token 数量

• 管理员可以提取所有的Token (withdraw 方法)。
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
}
