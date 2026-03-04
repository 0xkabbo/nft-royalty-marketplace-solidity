# NFT Royalty Marketplace

A high-performance, flat-structured NFT marketplace that respects on-chain royalties. Built with Solidity 0.8.20, this repository provides the essential logic for decentralized secondary sales.

## Features
- **ERC-2981 Support**: Automatically calculates and distributes creator royalties upon sale.
- **Fixed Price Listings**: Simple, gas-efficient functions to list and purchase NFTs.
- **Pull-Payment Pattern**: Securely handles funds using an escrow-style withdrawal system.
- **Foundry Ready**: Includes a comprehensive test suite for marketplace logic.

## Technical Flow
1. **List**: Seller approves the marketplace and calls `listToken`.
2. **Buy**: Buyer sends ETH to `executeSale`.
3. **Payout**: The contract calculates royalties via `royaltyInfo`, sends them to the creator, and the remainder to the seller.



## Commands
- Build: `forge build`
- Test: `forge test -vv`
