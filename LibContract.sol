pragma solidity ^0.4.25;

library UserLib{

    // You can define any complex struct you think would solve your purpose, for demo pupose I have tried to keep it simple
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

    function getStoredBytes(bytes32 _bytesKey) public constant returns(string){
        return _bytesKey.getBytesStorage(dataStorageInstance);
    }

    function saveBytes(bytes32 _bytesKey, string _stringValue) public returns(bool){
        _bytesKey.setBytes(_stringValue, dataStorageInstance);
        return true;
    }

    function getStoredString(string _stringKey) public constant returns(string){
        return _stringKey.getStringStorage(dataStorageInstance);
    }

    function saveString(string _stringKey, string _stringValue) public returns(bool){
        _stringKey.setString(_stringValue, dataStorageInstance);
        return true;
    }

}

contract SimpleContract{
    
    struct DataStorage{
        mapping(bytes32 => string) bytes_string;
        mapping(string => string) string_string;
    }
    DataStorage dataStorage;
    
    function getStoredBytes(bytes32 _bytesKey) public constant returns(string){
        return dataStorage.bytes_string[_bytesKey];
    }

    function saveBytes(bytes32 _bytesKey, string _stringValue) public returns(bool){
        dataStorage.bytes_string[_bytesKey] = _stringValue;
        return true;
    }

    function getStoredString(string _stringKey) public constant returns(string){
        return dataStorage.string_string[_stringKey];
    }

    function saveString(string _stringKey, string _stringValue) public returns(bool){
        dataStorage.string_string[_stringKey] = _stringValue;
        return true;
    }
    
}