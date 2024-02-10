// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RealEstateMarketplace is ERC721, Ownable {
    using SafeMath for uint256;

    struct Listing {
        string propertyAddress;
        string zkProofOfOwnership;
        string generalPropertyInfo;
        string[] imageURIs;
        uint256 purchasePrice;
        string agentOrSellerPhoneNumber;
        string escrowTerms;
        bool isSold;
    }

    Listing[] public listings;

    // Mapping from token ID to listing ID
    mapping(uint256 => uint256) public tokenIdToListingId;

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}

    function createListing(
        string memory _propertyAddress,
        string memory _zkProofOfOwnership,
        string memory _generalPropertyInfo,
        string[] memory _imageURIs,
        uint256 _purchasePrice,
        string memory _agentOrSellerPhoneNumber,
        string memory _escrowTerms
    ) external {
        require(_imageURIs.length > 0, "Must include at least one image URI");
        
        Listing memory newListing = Listing({
            propertyAddress: _propertyAddress,
            zkProofOfOwnership: _zkProofOfOwnership,
            generalPropertyInfo: _generalPropertyInfo,
            imageURIs: _imageURIs,
            purchasePrice: _purchasePrice,
            agentOrSellerPhoneNumber: _agentOrSellerPhoneNumber,
            escrowTerms: _escrowTerms,
            isSold: false
        });

        uint256 listingId = listings.length;
        listings.push(newListing);

        // Mint an NFT for this listing
        _mint(msg.sender, listingId);
        tokenIdToListingId[listingId] = listingId;
    }

    function buyListing(uint256 _tokenId) external payable {
        require(_exists(_tokenId), "Token does not exist");
        require(ownerOf(_tokenId) != msg.sender, "Cannot buy your own listing");
        uint256 listingId = tokenIdToListingId[_tokenId];
        Listing storage listing = listings[listingId];

        require(!listing.isSold, "Listing already sold");
        require(msg.value >= listing.purchasePrice, "Insufficient funds");

        // Handle escrow terms if needed

        // Transfer ownership
        transferFrom(ownerOf(_tokenId), msg.sender, _tokenId);

        // Mark listing as sold
        listing.isSold = true;

        // Transfer funds to the seller
        payable(ownerOf(_tokenId)).transfer(msg.value);

        // You can implement NFT creation for receipt and confirmation here
    }
}
