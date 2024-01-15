// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/utils/SafeERC20.sol";

contract TokenBank  {

    using SafeERC20 for IERC20;

    address private administrator;
    address private tokenPool;
    mapping(address => uint) private balances;

    error NotAdministrator(address user);
    error NotCorrectToken(address tokenPool);

    event TransferSuccess(address from, address bank, uint amount);
    event WithdrawSuccess(address receiver, uint amount);

    modifier onlyAdministrator {
        if(msg.sender != administrator) revert NotAdministrator(msg.sender);
        _;
    }
   
    //限定只能由规定的代币池向这个合约打钱
    modifier onlyTokenPool {
        if (msg.sender != tokenPool) revert NotCorrectToken(msg.sender);
        _;
    }

    constructor(address TokenPool) {
        administrator = msg.sender;
        tokenPool = TokenPool;
    }

    //用户存款
    function deposit(address token, uint amount) public {
        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
        balances[msg.sender] += amount;
        emit TransferSuccess(msg.sender, address(this), amount);
    }
    
    //管理员撤资
    function withdraw(address token) public  onlyAdministrator{
        IERC20(token).approve(administrator, address(this).balance);
        IERC20(token).safeTransferFrom(address(this), administrator, address(this).balance);
        emit WithdrawSuccess(administrator, address(this).balance);
    }
    
    //用户查看存款
    function viewBalance() public view returns(uint){
        return balances[msg.sender];
    }

    //对用户直接转进地址的代币进行处理
    function tokensRecieved(address user, uint amount) external onlyTokenPool{
        balances[user] += amount;
        emit TransferSuccess(user, address(this), amount);

    }

}
