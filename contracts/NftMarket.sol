// SPDX-License-Identifier: MIT
pragma solidity 0.6.6;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NftMarket is ERC721 {

  // set marketName
  string public marketName;
  // total number of class created
  uint256 public classCounter;


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



  // initialize contract while deployment with contract's collection name and token
  constructor() ERC721("My NftMarket") {
    marketName = name();
    classCounter = 0;
  }


  //  create a new Class
  function createClass(string memory className,bool memory transferable,bool memory burnable,bool memory mintable,bool memory frozen) external  {
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
    classCounter,
    className,
    msg.sender,
    transferable,
    burnable,
    mintable,
    frozen);

    // update the  all class mapping
    allClass[classCounter] = newClass;

  }


 
}