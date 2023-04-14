// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract UserRegister {
  receive() external payable {}

  struct User {
    bool exists;
    address userID;
    string userPwd;
    string userKey;
  }

  bool public isTransactionComplete;
  address public userAddress;
  mapping(address => User) users;

  constructor() {
    userAddress = msg.sender;
    isTransactionComplete = false;
  }

  modifier limitToUser() {
    require(msg.sender == userAddress);
    _;
  }

  //modifier TransactionIncomplete {
  //require(isTransactionComplete==false);
  //   _;
  // }

  function registerUser(
    address userID,
    string memory userPwd,
    string memory userKey
  ) public limitToUser {
    require(users[userID].exists == false);
    users[userID] = User(true, userID, userPwd, userKey);
  }

  function showUser(
    address userID
  ) public view returns (address, string memory, string memory) {
    return (users[userID].userID, users[userID].userPwd, users[userID].userKey);
  }

  function sendEther(
    address payable receiverAddress,
    address userID,
    string memory userPwd,
    string memory userKey
  ) public payable {
    if (
      users[userID].userID == userID &&
      keccak256(abi.encodePacked(users[userID].userPwd)) ==
      keccak256(abi.encodePacked(userPwd)) &&
      keccak256(abi.encodePacked(users[userID].userKey)) ==
      keccak256(abi.encodePacked(userKey))
    ) {
      bool isSent = receiverAddress.send(msg.value);
      require(isSent, "Oops! Your transaction failed!");
      isTransactionComplete = true;
    } else {
      require(isTransactionComplete == true, "Credentials didn't match BAKA!");
    }
  }

  //function validateUser(address userID, string storage userPwd, string storage userKey) private  returns(bool){
  //if(users[userID].userID == userID && keccak256(abi.encodePacked(users[userID].userPwd))==keccak256(abi.encodePacked(userPwd)) && keccak256(abi.encodePacked(users[userID].userKey))==keccak256(abi.encodePacked(userKey))){
  //   validateKey=true;
  //    return validateKey;

  // }
  // else{
  //     validateKey=false;
  //     return validateKey;

  //  }
  //}
}

}
