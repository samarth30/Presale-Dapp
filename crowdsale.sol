// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import './DevToken.sol';

contract DevTokenSale {
    // address of admin
    address payable public  admin;
    // define the instance of DevToken
    DevToken public devtoken;
    // token price variable
    uint256 public tokenprice;
    // count of token sold vaariable
    uint256 public totalsold; 
     
    event Sell(address sender,uint256 totalvalue); 
   
    // constructor 
    constructor(address _tokenaddress,uint256 _tokenvalue){
        admin  = msg.sender;
        tokenprice = _tokenvalue;
        devtoken  = DevToken(_tokenaddress);
    }
   
    // buyTokens function
    function buyTokens() public payable{
    // check if the contract has the tokens or not
    require(devtoken.balanceOf(address(this)) >= msg.value*tokenprice,'the smart contract dont hold the enough tokens');
    // transfer the token to the user
    devtoken.transfer(msg.sender,msg.value*tokenprice);
    // increase the token sold
    totalsold += msg.value*tokenprice;
    // emit sell event for ui
     emit Sell(msg.sender, msg.value*tokenprice);
    }

    // end sale
    function endsale() public{
    // check if admin has clicked the function
    require(msg.sender == admin , ' you are not the admin');
    // transfer all the remaining tokens to admin
    devtoken.transfer(msg.sender,devtoken.balanceOf(address(this)));
    // transfer all the etherum to admin and self selfdestruct the contract
    selfdestruct(admin);
    }
}