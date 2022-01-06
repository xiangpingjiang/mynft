// SPDX-License-Identifier: MIT
pragma solidity 0.6.6;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NftMarket is ERC721 {

  // set marketName
  string public marketName;
  // total number of class created
  uint256 public classCounter;
  // total number of crypto arts minted
  uint256 public cryptoArtCounter;


  // define class struct
   struct Class {
    uint256 classId;
    string className;
    address payable admin;
    bool transferable;
    bool burnable;
    bool mintable;
    bool frozen;
  }


  // define crypto art struct
   struct Crypto_art {
    uint256 classId;
    uint256 tokenId;
    string tokenName;
    string tokenURI;
    address payable mintedBy;
    address payable currentOwner;
    address payable previousOwner;
    uint256 price;
    uint256 numberOfTransfers;
  }

  // map classId to Class
  mapping(uint256 => Class) public allClass;
  // check if class name exists
  mapping(string => bool) public classNameExists;


  // map Crypto_art's token id to Crypto_art
  mapping(uint256 => Crypto_art) public allCrypto_arts;
  // check if token name exists
  mapping(string => bool) public tokenNameExists;
  // check if token URI exists
  mapping(string => bool) public tokenURIExists;


  // initialize contract
  constructor() ERC721("My NftMarket") {
    marketName = name();
    classCounter = 0;
    cryptoArtCounter = 0;
  }


  //  create a new Class
  function createClass(string memory className,bool memory transferable,bool memory burnable,bool memory mintable,bool memory frozen) public  {
    // check if this fucntion caller is not an zero address account
    require(msg.sender != address(0));
    // increment counter
    classCounter ++;
    // check if the token name already exists or not
    require(!classNameExists[className]);
    tokenNameExists[_name] = true;

    // creat a new Class (struct) and pass in new values
    Class memory newClass = Class(
    classCounter,
    className,
    msg.sender,
    transferable,
    burnable,
    mintable,
    frozen);

    // add the class id and it's class to all class mapping
    allClass[classCounter] = newClass;

  }


  //  Update the class properties
  function updateClass(uint256 memory _classId,bool memory transferable,bool memory burnable,bool memory mintable,bool memory frozen) public {
    // require caller of the function is not an empty address
    require(msg.sender != address(0));

    Class memory c = allClass[_classId]

    // check the admin of the class
    require(c.admin == msg.sender);

    // check the frozen value of the class
    require(c.frozen == false);
    // creat a new Class (struct) and pass in new values
    Class memory newClass = Class(
    c.classId,
    c.className,
    msg.sender,
    transferable,
    burnable,
    mintable,
    frozen);

    // update the  all class mapping
    allClass[classCounter] = newClass;

  }

  // mint a new Crypto art token
  function mintCrypto_art(uint256 memory _classId,string memory _name, string memory _tokenURI, uint256 _price) public {
    // check if this fucntion caller is not an zero address account
    require(msg.sender != address(0));
    Class memory c = allClass[_classId]
    // check the admin of the class
    require(c.admin == msg.sender);
    // check the mintable  of the class
    require(c.mintable == true);
    // increment tokenNumber
    cryptoArtCounter ++;
    // check if a token exists with the above token id => incremented counter
    require(!_exists(cryptoArtCounter));

    // check if the token URI already exists or not
    require(!tokenURIExists[_tokenURI]);
    // check if the token name already exists or not
    require(!tokenNameExists[_name]);

    // mint the token
    _mint(msg.sender, cryptoArtCounter);
    // set token URI (bind token id with the passed in token URI)
    _setTokenURI(cryptoArtCounter, _tokenURI);

    // make passed token URI as exists
    tokenURIExists[_tokenURI] = true;
    // make token name passed as exists
    tokenNameExists[_name] = true;

    // creat a new crypto boy (struct) and pass in new values
    Crypto_art memory newCrypto_art = Crypto_art(
    _classId,
    cryptoArtCounter,
    _name,
    _tokenURI,
    msg.sender,
    msg.sender,
    address(0),
    _price,
    0,
    true);
    // add the token id and it's crypto_art to allCrypto_arts mapping
    allCrypto_arts[cryptoArtCounter] = newCrypto_art;
  }

  // Burn a Crypto art token

  function burnToken(uint256 memory _tokenId) public {
    // check if this fucntion caller is not an zero address account
    require(msg.sender != address(0));
    Crypto_art memory art = allCrypto_arts[_tokenId]
    Class memory c = allClass[art.classId]
    // check the admin of the class
    require(c.admin == msg.sender);
    // check the burnable  of the class
    require(c.burnable == true);
    _burn(_tokenId)

  } 
}