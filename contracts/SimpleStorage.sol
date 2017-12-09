pragma solidity ^0.4.18;

import "./Owner.sol";

contract SimpleStorage is Owner {
    uint storedData;

    function set(uint x) public {
        storedData = x;
    }

    function get() public view returns (uint) {
        return storedData;
    }
}
