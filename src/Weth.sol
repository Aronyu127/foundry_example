// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract WrappedEtherEvents {
    event Deposited(address indexed from, uint256 value);
    event Withdrawn(address indexed from, uint256 value);
}

contract WrappedEther is ERC20, WrappedEtherEvents {
    constructor() ERC20("Wrapped Ether", "WETH"){

    }

    function deposit() external payable {
        _mint(msg.sender, msg.value);
        emit Deposited(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external {
        _burn(msg.sender, amount);
        payable(msg.sender).transfer(amount);
        emit Withdrawn(msg.sender, amount);
    }
}