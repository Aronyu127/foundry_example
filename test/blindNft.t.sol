// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {BlindNft} from "../src/blindNft.sol";

contract BlindNftTest is Test {
    BlindNft public blindNft;

    function test_tokenURI() public {
        blindNft = new BlindNft();
        // test mint BlindNft token for user
        address user1 = makeAddr('user1');
        blindNft.mint();
        assertEq(blindNft.balanceOf(address(this)), 1);
        assertEq(blindNft.tokenURI(1), "https://coffee-peaceful-squirrel-262.mypinata.cloud/ipfs/Qme83sroXh3P2LotonTuMFSoJf7x98LxrMeXHu3mgpoU5A?_gl=1*bvwahx*_ga*MTU0NzIzNjg5Ny4xNjk3NzE2NTQ2*_ga_5RMPXG14TE*MTY5NzcyMTI3Ni4yLjEuMTY5NzcyMTM1NC42MC4wLjA");
        blindNft.setBlinded(false);
        assertEq(blindNft.tokenURI(1), "https://coffee-peaceful-squirrel-262.mypinata.cloud/ipfs/QmNuNQXTsLP9UcTuuiAYg36xQ1ydBApHuMK516DrzKCaay/1.json");
    }
}
