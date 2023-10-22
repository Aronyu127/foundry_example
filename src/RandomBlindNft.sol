// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract RandomTokenNft is ERC721, Ownable(msg.sender) {
    // 為什麼在 remix 上面只要 Ownable() 就可以 而跑測試時不使用 Ownable(msg.sender)會出現錯誤
    uint256 public constant maxTokens = 500;
    uint256 public tokensMinted;
    bool public isBlinded = true;

    constructor() ERC721("MyERC721", "MYNFT") {
        tokensMinted = 0;
    }

    function mint() external returns(uint256 tokenId) {
        require(tokensMinted < maxTokens, "Maximum number of tokens minted");
        tokensMinted++;
        uint256 _tokenId = generateRandomTokenId();
        _mint(msg.sender, _tokenId);
        return _tokenId;
    }

    function setBlinded(bool _isBlinded) external onlyOwner {
        isBlinded = _isBlinded;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
      if (isBlinded) {
        return "https://coffee-peaceful-squirrel-262.mypinata.cloud/ipfs/Qme83sroXh3P2LotonTuMFSoJf7x98LxrMeXHu3mgpoU5A?_gl=1*bvwahx*_ga*MTU0NzIzNjg5Ny4xNjk3NzE2NTQ2*_ga_5RMPXG14TE*MTY5NzcyMTI3Ni4yLjEuMTY5NzcyMTM1NC42MC4wLjA";
      } 

      uint256 nft_data_id = tokenId % 10;
        // Using abi.encodePacked to concatenate the URI and the tokenId
      return string(abi.encodePacked("https://coffee-peaceful-squirrel-262.mypinata.cloud/ipfs/QmNuNQXTsLP9UcTuuiAYg36xQ1ydBApHuMK516DrzKCaay/", Strings.toString(nft_data_id), ".json"));
    }

    function generateRandomTokenId() internal view returns (uint256) {
      uint256 randomNumber = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender)));
      return randomNumber % (10 ** 15); // limit the maximum token ID to 15 digits
    }
}
