// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "tokenBank/lib/chainlink-brownie-contracts/contracts/src/v0.8//AutomationCompatible.sol";

contract TokenBank  is AutomationCompatibleInterface {

    using SafeERC20 for IERC20;

    address private administrator;
    address private tokenPool;
    mapping(address => uint) private balances;

    error NotAdministrator(address user);
    error NotCorrectToken(address tokenPool);

    event TransferSuccess(address from, address bank, uint amount);
    event WithdrawSuccess(address receiver, uint amount);

    uint256 upperLimit;
    uint256 totalAmount;

    modifier onlyAdministrator {
        if(msg.sender != administrator) revert NotAdministrator(msg.sender);
        _;
    }
   
    //限定只能由规定的代币池向这个合约打钱
    modifier onlyTokenPool {
        if (msg.sender != tokenPool) revert NotCorrectToken(msg.sender);
        _;
    }

    constructor(address TokenPool, uint256 _upperLimit) {
        administrator = msg.sender;
        tokenPool = TokenPool;
        upperLimit = _upperLimit;
    }

    //用户存款
    function deposit(uint amount) public {
        IERC20(tokenPool).safeTransferFrom(msg.sender, address(this), amount);
        balances[msg.sender] += amount;
        totalAmount += amount;
        emit TransferSuccess(msg.sender, address(this), amount);
    }
    
    //管理员撤资
    function withdraw() public onlyAdministrator{
        IERC20(tokenPool).approve(administrator, address(this).balance);
        IERC20(tokenPool).safeTransferFrom(address(this), administrator, address(this).balance);
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

    /**
     * 
     */
      function checkUpkeep(bytes calldata) external view returns (bool overLimit, bytes memory ) {
        overLimit = totalAmount > upperLimit;
    }


    /**
     * 
     */
      function performUpkeep(bytes calldata ) external {
        //(bool si, uint amount) = Math.tryDiv(totalAmount, 2);
        //IERC20(tokenPool).approve(administrator, amount);
        //IERC20(tokenPool).safeTransferFrom(address(this), administrator, amount);
        //emit WithdrawSuccess(administrator, amount);
        

    }

}
