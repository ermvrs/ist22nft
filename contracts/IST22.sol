pragma solidity >= 0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract IST22 is ERC721Enumerable {

    string public poapUri;
    uint256 public maxTokens = 1000;
    address public operator;
    bytes32 public eligibles;

    mapping(address => bool) public minters;

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {
        operator = msg.sender;
    }

    function setPoapUri(string memory _uri) public {
        require(msg.sender == operator, "only operator");
        poapUri = _uri;
    }

    function mint(bytes32[] calldata _proof) public {
        // only eligibles can mint
        bool isEligible = verifyEligible(_proof, msg.sender);
        require(isEligible, "Not eligible for mint");

        bool alreadyMinted = minters[msg.sender];
        require(!alreadyMinted, "Already minted");

        uint mintIndex = totalSupply() + 1;

        require(mintIndex < maxTokens, "All tokens minted");

        _safeMint(msg.sender, mintIndex);

        minters[msg.sender] = true;
    }

    //empty parameter for override
    function tokenURI(uint256 _tokenId) public view override returns(string memory) {
        return poapUri;
    }

    function setEligibleHash(bytes32 _root) public {
        require(msg.sender == operator, "only operator");
        eligibles = _root;
    }

    function verifyEligible(bytes32[] calldata _proof, address _user) internal view returns(bool) {
        bytes32 leaf = keccak256(abi.encodePacked(_user));

        return MerkleProof.verify(_proof, eligibles, leaf);
    }

}