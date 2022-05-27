pragma solidity >= 0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract IST22 is ERC721Enumerable {

    string public poapUri;
    address public operator;
    uint256 public mintingDuration = 48 hours;

    uint256 public startTime;
    uint256 public endTime;

    mapping(address => bool) public minters;

    constructor(string memory _name, string memory _symbol, string memory _poapUri) ERC721(_name, _symbol) {
        operator = msg.sender;
        startTime = block.timestamp;
        endTime = block.timestamp + mintingDuration;
        poapUri = _poapUri;
    }

    function mint() public {
        
        bool alreadyMinted = minters[msg.sender];
        require(!alreadyMinted, "Already minted");

        uint mintIndex = totalSupply();

        _safeMint(msg.sender, mintIndex);

        minters[msg.sender] = true;
    }

    //empty parameter for override
    function tokenURI(uint256 _tokenId) public view override returns(string memory) {
        return poapUri;
    }

}
