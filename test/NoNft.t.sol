// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {NoUseful, HW_Token, NFTReceiver} from "../src/NoNft.sol";

contract NFTReceiverTest is Test {
    NFTReceiver public nftReceiver;
    HW_Token public hw_Token;
    NoUseful public no_useful;

    function test_onERC721Received() public {
        hw_Token = new HW_Token();
        nftReceiver = new NFTReceiver(address(hw_Token));
        no_useful = new NoUseful();
        // test mint HW_Token token for user
        address user1 = makeAddr('user1');
        uint256 no_useful_token_id = no_useful.mint(address(user1));
        assertEq(no_useful.balanceOf(address(user1)), 1);

        vm.startPrank(user1);
        no_useful.safeTransferFrom(address(user1), address(nftReceiver), no_useful_token_id);

        //test send back original NFT to user1
        assertEq(no_useful.ownerOf(no_useful_token_id), address(user1));

        //test mint HW_Token for user1
        assertEq(hw_Token.balanceOf(address(user1)), 1);
        vm.stopPrank();
    }
}
