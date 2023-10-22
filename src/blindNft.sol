// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract BlindNft is ERC721, Ownable(msg.sender) {
    uint256 public constant maxTokens = 500;
    uint256 public tokensMinted;
    bool public isBlinded = true;

    constructor() ERC721("MyERC721", "MYNFT") {
        tokensMinted = 0;
    }

    function mint() external {
        require(tokensMinted < maxTokens, "Maximum number of tokens minted");
        tokensMinted++;
        uint256 tokenId = tokensMinted;
        _mint(msg.sender, tokenId);
    }

    function setBlinded(bool _isBlinded) external onlyOwner {
        isBlinded = _isBlinded;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
      if (isBlinded) {
        return "https://coffee-peaceful-squirrel-262.mypinata.cloud/ipfs/Qme83sroXh3P2LotonTuMFSoJf7x98LxrMeXHu3mgpoU5A?_gl=1*bvwahx*_ga*MTU0NzIzNjg5Ny4xNjk3NzE2NTQ2*_ga_5RMPXG14TE*MTY5NzcyMTI3Ni4yLjEuMTY5NzcyMTM1NC42MC4wLjA";
      } 

      // 槓龜NFT
      if(tokenId > 10){
        return "https://coffee-peaceful-squirrel-262.mypinata.cloud/ipfs/QmVB1rHQjWLmSJYVtCVrhuLfsP96YRd5hofGU1aguzJ57X?_gl=1*1bwpzxe*_ga*MTU0NzIzNjg1Ny4xNjk3NzE2NTQ2*_ga_5RMPXG14TE*MTY5Nzk1NjUwMS40LjAuMTY5Nzk1NzY0MS42MC4wLjA.";
      }
        // Using abi.encodePacked to concatenate the URI and the tokenId
      return string(abi.encodePacked("https://coffee-peaceful-squirrel-262.mypinata.cloud/ipfs/QmNuNQXTsLP9UcTuuiAYg36xQ1ydBApHuMK516DrzKCaay/", Strings.toString(tokenId), ".json"));
    }
}
