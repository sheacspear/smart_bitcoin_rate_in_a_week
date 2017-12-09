pragma solidity ^0.4.2;

contract Owner {

    address owner;

    function Owner() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) public {
        require(msg.sender == owner);
        owner = newOwner;
    }

}