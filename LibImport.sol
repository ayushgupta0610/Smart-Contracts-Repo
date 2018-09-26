pragma solidity ^0.4.22;

library UserLib{
    
    struct DataStorage {
        mapping(address => bool) address_status;
    }
    
    function userAddressExists(address _self, DataStorage storage _dataStorage) constant returns (bool){
        return _dataStorage.address_status[_self];
    }
    
    function setUserAddress(address _self, DataStorage storage _dataStorage) public {
        _dataStorage.address_status[_self] = true;
    }
    
}

contract UserContract{
    UserLib.DataStorage contractStorage;
    
    using UserLib for address;
    
    function checkUserAddressExistence() constant returns (bool){
        return msg.sender.userAddressExists(contractStorage);
    }
    
    function registerMe() public{
        msg.sender.setUserAddress(contractStorage);
    }
}