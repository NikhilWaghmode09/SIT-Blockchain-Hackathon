// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract ArtOwnership {
    struct Artwork {
        address artist; //artist's address.
        address currentOwner; //current owner's address.
        string uniqueIdentifier; //unique artwork ID.
    }

    mapping(string => Artwork) public artworks; //stores history of prev. owners.

    event ArtworkRegistered(address indexed artist, string uniqueIdentifier);
    event OwnershipTransferred(string uniqueIdentifier, address indexed previousOwner, address indexed newOwner);

    //function to register new artwork using unique string ID.
    function registerArtwork(string memory _uniqueIdentifier) public {
        require(artworks[_uniqueIdentifier].artist == address(0), "Artwork is already registered");
        artworks[_uniqueIdentifier] = Artwork(msg.sender, msg.sender, _uniqueIdentifier);
        emit ArtworkRegistered(msg.sender, _uniqueIdentifier);
    }

    //function to transfer ownership of the artwork.
    function transferOwnership(string memory uniqueIdentifier, address newOwner) public {
        Artwork storage artwork = artworks[uniqueIdentifier];
        require(artwork.artist == msg.sender, "Only the artist can transfer ownership");
        require(artwork.currentOwner == msg.sender, "You are not the current owner");
        artwork.currentOwner = newOwner;
        emit OwnershipTransferred(uniqueIdentifier, msg.sender, newOwner);
    }
    //function to display current owner of the artwork.
    function getCurrentOwner(string memory uniqueIdentifier) public view returns (address) {
        return artworks[uniqueIdentifier].currentOwner;
    }
}
