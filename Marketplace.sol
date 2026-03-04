// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC721} from "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.0.0/contracts/token/ERC721/IERC721.sol";
import {IERC2981} from "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.0.0/contracts/interfaces/IERC2981.sol";
import {ReentrancyGuard} from "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.0.0/contracts/utils/ReentrancyGuard.sol";

/**
 * @title SimpleNFTMarketplace
 * @dev A minimal marketplace that supports ERC-2981 royalties.
 */
contract SimpleNFTMarketplace is ReentrancyGuard {
    struct Listing {
        address seller;
        uint256 price;
    }

    // Mapping from NFT Contract -> Token ID -> Listing Data
    mapping(address => mapping(uint256 => Listing)) public listings;

    event TokenListed(address indexed nftAddress, uint256 indexed tokenId, uint256 price, address seller);
    event TokenSold(address indexed nftAddress, uint256 indexed tokenId, uint256 price, address buyer);

    function listToken(address nftAddress, uint256 tokenId, uint256 price) external {
        require(price > 0, "Price must be > 0");
        IERC721(nftAddress).transferFrom(msg.sender, address(this), tokenId);
        
        listings[nftAddress][tokenId] = Listing(msg.sender, price);
        emit TokenListed(nftAddress, tokenId, price, msg.sender);
    }

    function executeSale(address nftAddress, uint256 tokenId) external payable nonReentrant {
        Listing memory listing = listings[nftAddress][tokenId];
        require(msg.value >= listing.price, "Insufficient payment");

        delete listings[nftAddress][tokenId];

        uint256 royaltyAmount = 0;
        address royaltyReceiver;

        // Check for ERC-2981 Royalty Support
        if (IERC165(nftAddress).supportsInterface(type(IERC2981).interfaceId)) {
            (royaltyReceiver, royaltyAmount) = IERC2981(nftAddress).royaltyInfo(tokenId, msg.value);
        }

        if (royaltyAmount > 0 && royaltyReceiver != address(0)) {
            payable(royaltyReceiver).transfer(royaltyAmount);
        }

        payable(listing.seller).transfer(msg.value - royaltyAmount);
        IERC721(nftAddress).transferFrom(address(this), msg.sender, tokenId);

        emit TokenSold(nftAddress, tokenId, msg.value, msg.sender);
    }
}

interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}
