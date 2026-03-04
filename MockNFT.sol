// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721} from "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.0.0/contracts/token/ERC721/ERC721.sol";
import {ERC2981} from "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.0.0/contracts/token/common/ERC2981.sol";

contract MockNFT is ERC721, ERC2981 {
    uint256 private _nextTokenId;

    constructor() ERC721("ArtNFT", "ART") {}

    function mint(address to, uint96 royaltyFee) public {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenRoyalty(tokenId, to, royaltyFee); // e.g., 500 = 5%
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
