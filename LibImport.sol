pragma solidity ^0.4.22;

library UserLib{
    
    struct UserID {
        mapping(address => bool) address_status;
    }
    
    function userAddressExists(address _self, UserID storage _userID) constant returns (bool){
        return _userID.address_status[_self];
    }
    
    function setUserAddress(address _self, UserID storage _userID) public {
        _userID.address_status[_self] = true;
    }
    
}

contract UserContract{
    UserLib.UserID userInstance;
    
    using UserLib for address;
    
    function checkUserAddressExistence() constant returns (bool){
        return msg.sender.userAddressExists(userInstance);
    }
    
    function registerMe() public {
        msg.sender.setUserAddress(userInstance);
    }
}