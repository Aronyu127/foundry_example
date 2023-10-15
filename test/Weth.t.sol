// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {WrappedEther, WrappedEtherEvents} from "../src/Weth.sol";

contract WrappedEtherTest is Test, WrappedEtherEvents {
    WrappedEther public wrapped_ether;

    function setUp() public {
        vm.label(msg.sender, "MSG_SENDER");
        wrapped_ether = new WrappedEther();
    }

    function test_deposit() public payable {
        uint256 _amount = 1000;
        
        vm.deal(msg.sender, _amount);
        vm.startPrank(msg.sender);
        //3: deposit 應該要 emit Deposit event
        vm.expectEmit(true, true, false, false);
        // vm.expectEmit(true, false, false, true, address(wrapped_ether)); 會失敗不知道為什麼
        emit Deposited(msg.sender, msg.value);

        wrapped_ether.deposit{value: _amount}();
        //1: deposit 應該將與 msg.value 相等的 ERC20 token mint 給 user
        assertEq(wrapped_ether.balanceOf(address(msg.sender)), _amount);
        //2: deposit 應該將 msg.value 的 ether 轉入合約
        assertEq(address(wrapped_ether).balance, _amount);
        vm.stopPrank();
    }

    function test_withdraw() public payable {
        uint256 _amount = 1000;
        
        vm.deal(msg.sender, _amount);
        vm.startPrank(msg.sender);
        wrapped_ether.deposit{value: _amount}();

        uint256 balanceBeforeWithdraw = wrapped_ether.balanceOf(address(msg.sender));
        uint256 totalSupplyBeforeWithdraw = wrapped_ether.totalSupply();
        uint256 ETHBeforeWithdraw = address(msg.sender).balance;

        // 6: withdraw 應該要 emit Withdraw event
        vm.expectEmit(true, true, false, false);
        emit Withdrawn(msg.sender, _amount);

        wrapped_ether.withdraw(_amount);
        //4: withdraw 應該要 burn 掉與 input parameters 一樣的 erc20 token
        assertEq(wrapped_ether.balanceOf(address(msg.sender)), balanceBeforeWithdraw - _amount);
        assertEq(wrapped_ether.totalSupply(), totalSupplyBeforeWithdraw - _amount);
        //5: withdraw 應該將 burn 掉的 erc20 換成 ether 轉給 user
        assertEq(address(msg.sender).balance, ETHBeforeWithdraw + _amount);

        vm.stopPrank();
    }

    function test_transfer() public {
        address user1 = makeAddr('user1');
        address user2 = makeAddr('user2');

        uint256 _amount = 1000;
        
        vm.deal(user1, _amount);
        vm.startPrank(user1);
        wrapped_ether.deposit{value: _amount}();

        uint256 User1balanceBeforeTransfer = wrapped_ether.balanceOf(address(user1));
        uint256 User2balanceBeforeTransfer = wrapped_ether.balanceOf(address(user2));

        wrapped_ether.transfer(address(user2), _amount);
        //7: transfer 應該要將 erc20 token 轉給別人
        assertEq(wrapped_ether.balanceOf(address(user1)), User1balanceBeforeTransfer - _amount);
        assertEq(wrapped_ether.balanceOf(address(user2)), User2balanceBeforeTransfer + _amount);
        vm.stopPrank();
    }

    function test_approve() public {
        uint256 _approve_allowance = 1000;
        address user1 = makeAddr('user1');
        address contract1 = makeAddr('contract1');

        vm.startPrank(user1);
        wrapped_ether.approve(address(contract1), _approve_allowance);
        //8: approve 應該要給他人 allowance
        assertEq(wrapped_ether.allowance(user1, contract1), _approve_allowance);
        vm.stopPrank();
    }

    function test_transferFrom() public {
        uint256 _approve_allowance = 1000;
        uint256 _transfer_balance = 200;
        uint256 _amount = 2000;
        address user1 = makeAddr('user1');
        address user2 = makeAddr('user2');
        address contract1 = makeAddr('contract1');

        vm.startPrank(user1);
        vm.deal(user1, _amount);
        wrapped_ether.deposit{value: _amount}();
        wrapped_ether.approve(address(contract1), _approve_allowance);
        vm.stopPrank();

        vm.startPrank(contract1);
        uint256 User1balanceBeforeTransferFrom = wrapped_ether.balanceOf(address(user1));
        uint256 User2balanceBeforeTransferFrom = wrapped_ether.balanceOf(address(user2));
        wrapped_ether.transferFrom(user1, user2, _transfer_balance);
        //9: transferFrom 應該要可以使用他人的 allowance
        assertEq(wrapped_ether.balanceOf(address(user1)), User1balanceBeforeTransferFrom - _transfer_balance);
        assertEq(wrapped_ether.balanceOf(address(user2)), User2balanceBeforeTransferFrom + _transfer_balance);

        //10: transferFrom 後應該要減除用完的 allowance
        assertEq(wrapped_ether.allowance(user1, contract1), _approve_allowance - _transfer_balance);
        vm.stopPrank();
    }
}
