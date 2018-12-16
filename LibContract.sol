pragma solidity ^0.4.25;

library UserLib{

    // You can define sny complex you think would solve your purpose, for demo pupose I have tried to keep it simple
    struct DataStorage{
        mapping(bytes32 => string) bytes_string;
        mapping(string => string) string_string;
    }
    // struct BytesStorage{
    //     mapping(bytes32 => string) bytes_string;
        
    // }

    // struct StringStorage{
    //     mapping(string => string) string_string;
    // }
    function setBytes(bytes32 _key, string _value, DataStorage storage dataStorage) public returns(bool){
        dataStorage.bytes_string[_key] = _value;
        return true;
    }

    function setString(string _key, string _value, DataStorage storage dataStorage) public returns(bool){
        dataStorage.string_string[_key] = _value;
        return true;
    }

    function getBytesStorage(bytes32 _key, DataStorage storage dataStorage) public constant returns(string){
        return dataStorage.bytes_string[_key];
    }

    function getStringStorage(string _key, DataStorage storage dataStorage) public constant returns(string){
        return dataStorage.string_string[_key];
    }

}

contract UserContract{
    UserLib.DataStorage dataStorageInstance;

    using UserLib for bytes32;
    using UserLib for string;

    function getStoredBytes(bytes32 _bytesValues) public constant returns(string){
        return _bytesValues.getBytesStorage(dataStorageInstance);
    }

    function saveBytes(bytes32 _bytesKey, string _stringValue) public returns(bool){
        _bytesKey.setBytes(_stringValue, dataStorageInstance);
        return true;
    }

    function getStoredString(string _stringValue) public constant returns(string){
        return _stringValue.getStringStorage(dataStorageInstance);
    }

    function saveString(string _stringKey, string _stringValue) public returns(bool){
        _stringKey.setString(_stringValue, dataStorageInstance);
        return true;
    }

    

}