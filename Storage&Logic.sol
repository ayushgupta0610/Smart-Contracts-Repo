pragma solidity ^0.4.22;

contract UserStorage{
    
    mapping(address => bool) address_status;
    mapping(address => bool) owner_access;

    modifier platform(address _userAddress){
        require(owner_access[_userAddress] == true);
        _;
    }

    function UserStorage() public {
        owner_access[msg.sender] = true;
    }
    
    function checkUserAddress(address _userAddress) platform(_userAddress) external constant returns (bool){
        return address_status[_userAddress];
    }
    
    function setUser(address _userAddress, bool _flag) platform(_userAddress) external {
        address_status[_userAddress] = _flag;
    }

    function accessToPlatform(address _userAddress, bool _access) platform(_userAddress) external {
        owner_access[_userAddress] = _access;
    }
    
}

contract UserContract{
    
    UserStorage userStorage;
    
    function UserContract(address _userStorageAddress){
        userStorage = UserStorage(_userStorageAddress);
    }
    
    function isUserRegistered(address _userAddress) constant returns (bool userRegistered){
        return userStorage.checkUserAddress(_userAddress);
    }
    
    function setUserVisibility(address _userAddress, bool _flag) public {
        userStorage.setUser(_userAddress, _flag);
    }
    
    // The UserContract can deny the access to the msg.sender's account which was initially used to deploy the UserStorage contract
    function grantAccess(address _userAddress, bool _access) public {
        userStorage.accessToPlatform(_userAddress, _access);
    }

}