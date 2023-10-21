// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract NoUseful is ERC721 {
  uint256 public tokensMinted = 0;
  constructor() ERC721("NoUseNFT", "NOUSENFT") {}
  function mint(address to) external returns (uint256) {
    tokensMinted++;
    uint256 tokenId = tokensMinted;
    _mint(to == address(0) ? msg.sender : to, tokenId);
    return tokenId;
  }
}

contract HW_Token is ERC721 {
  uint256 public tokensMinted = 0;
  constructor() ERC721("Dont send NFT to me", "NONFT") {}

  function tokenURI(uint256 tokenId) public pure override returns (string memory) {
    return "https://coffee-peaceful-squirrel-262.mypinata.cloud/ipfs/QmVB1rHQjWLmSJYVtCVrhuLfsP96YRd5hofGU1aguzJ57X?_gl=1*1ugs6jn*_ga*MTU0NzIzNjg1Ny4xNjk3NzE2NTQ2*_ga_5RMPXG14TE*MTY5Nzc4Mjg4NC4zLjEuMTY5Nzc4MzYzOS41Mi4wLjA.";
  }
  
  function mint(address to) external returns (uint256) {
    tokensMinted++;
    uint256 tokenId = tokensMinted;
    _mint(to == address(0) ? msg.sender : to, tokenId);
    return tokenId;
  }
}

contract NFTReceiver is IERC721Receiver {
    address HW_TokenAddress;
    constructor(address _HW_TokenAddress){
      HW_TokenAddress = _HW_TokenAddress;
    }
    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata) external returns (bytes4) {
        if(address(msg.sender) != HW_TokenAddress){
            IERC721(msg.sender).safeTransferFrom(address(this), address(from), tokenId);
            HW_Token(HW_TokenAddress).mint(address(from));
        }
      return this.onERC721Received.selector;
    }
}