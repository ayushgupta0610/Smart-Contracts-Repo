pragma solidity ^0.4.22;
import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";
import "github.com/Arachnid/solidity-stringutils/strings.sol";

contract OraclizeDemo is usingOraclize {

   using strings for *;
   address owner;
   bytes32 public readAppOraclizeID;
   bytes32 public updateOraclizeID;
   bytes32 public readOraclizeID;
   bytes32 public createOraclizeID;
   
   mapping(string => string) hash_data;
   mapping(string => string) data_hash; 
   mapping(bytes32 => string) oraclizeID_hash;
   mapping(bytes32 => string) oraclizeID_data;
   
   event LogNewOraclizeQuery(string queryString);
  
   function KFSContract() {
       owner = msg.sender;
   }

   function __callback(bytes32 _myid, string _result) {
       require(msg.sender == oraclize_cbAddress());
       if (_myid == readOraclizeID){
            hash_data[oraclizeID_hash[_myid]] = _result;
       } else if (_myid == createOraclizeID){
            data_hash[oraclizeID_data[_myid]] = _result;
       } else if (_myid == readAppOraclizeID){
            hash_data[oraclizeID_hash[_myid]] = _result;
       } else if (_myid == updateOraclizeID){
            data_hash[oraclizeID_data[_myid]] = _result;
       }
       else revert();
   }
   
   function getHashOfOraclizeID(bytes32 _oraclizeID) constant returns (string retHash){
       return oraclizeID_hash[_oraclizeID];
   }
   
   function getHashOfData(string _dataString) constant returns (string retHash){
       return data_hash[_dataString];
   }
   
   function getDataOfHash(string _hashString) constant returns (string retData){
       return hash_data[_hashString];
   }
   
   function readFile(string _stringHash) payable {
       if (oraclize_getPrice("URL") > this.balance) {
           LogNewOraclizeQuery("Oraclize query was NOT sent for create function, please add some ETH to cover for the query fee");
       } else {
        //   bytes32 dataHash = stringToBytes32(_stringHash);
           LogNewOraclizeQuery("Oraclize query was sent for read function, standing by for the answer..");
           readOraclizeID = oraclize_query("URL", strConcat("http://159.65.80.74:3000/read/", _stringHash));
           oraclizeID_hash[readOraclizeID] = _stringHash;
       }
   }
   
   function getReadFile(string _stringHash) constant returns (string retFileData) {
       return hash_data[_stringHash];
   }
   
   function createFile(string _dataString) payable {
       if (oraclize_getPrice("URL") > this.balance) {
           LogNewOraclizeQuery("Oraclize query was NOT sent for create function, please add some ETH to cover for the query fee");
       } else {
            string memory _dataString1; string memory _dataString2;
           (_dataString1, _dataString2) = splitStringByDelimiter(_dataString, ";");
           LogNewOraclizeQuery("Oraclize query was sent for create function, standing by for the answer..");
           createOraclizeID = oraclize_query("URL", strConcat("http://159.65.80.74:3000/create?mime=", _dataString1, "&content=", _dataString2));
           oraclizeID_data[createOraclizeID] = _dataString;
       }
   }
   
   function getCreateFileHash(string _dataString) constant returns (string retCreateHash){
       return data_hash[_dataString];
   }
   
   function readAppData(string _appID) payable {
       if (oraclize_getPrice("URL") > this.balance) {
           LogNewOraclizeQuery("Oraclize query was NOT sent for create function, please add some ETH to cover for the query fee");
       } else {
           LogNewOraclizeQuery("Oraclize query was sent for read function, standing by for the answer..");
           readAppOraclizeID = oraclize_query("URL", strConcat("http://159.65.80.74:3000/appdata/", _appID));
           oraclizeID_hash[readAppOraclizeID] = _appID;
       }
   }
   
   function getReadAppData(string _appID) constant returns (string retAppData){
        return hash_data[_appID];
   }
   
   function updateAppData(string _appID, string _dataString) payable {
       if (oraclize_getPrice("URL") > this.balance) {
           LogNewOraclizeQuery("Oraclize query was NOT sent for create function, please add some ETH to cover for the query fee");
       } else {
            string memory _dataString1; string memory _dataString2;
           (_dataString1, _dataString2) = splitStringByDelimiter(_dataString, ";");
           LogNewOraclizeQuery("Oraclize query was sent for create function, standing by for the answer..");
           updateOraclizeID = oraclize_query("URL", strConcat(strConcat("http://159.65.80.74:3000/update?appID=", _appID, "&mime=", _dataString1, "&NewContent="), _dataString2));
           oraclizeID_data[updateOraclizeID] = _dataString;
       }
   }
   
   function getUpdateAppData(string _appID, string _dataString) constant returns (string retUpdatedHash){
        return data_hash[_dataString];
   }
   
   function bytes32ToString(bytes32 x) constant returns (string) {
        bytes memory bytesString = new bytes(32);
        uint charCount = 0;
        for (uint j = 0; j < 32; j++) {
            byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
            if (char != 0) {
                bytesString[charCount] = char;
                charCount++;
            }
        }
        bytes memory bytesStringTrimmed = new bytes(charCount);
        for (j = 0; j < charCount; j++) {
            bytesStringTrimmed[j] = bytesString[j];
        }
        return string(bytesStringTrimmed);
    }

    function stringToBytes32(string memory source) constant returns (bytes32 result) {
      bytes memory tempEmptyStringTest = bytes(source);
      if (tempEmptyStringTest.length == 0) {
        return 0x0;
      }
      assembly {
          result := mload(add(source, 32))
      }
    }
    
    function splitStringByDelimiter(string _value, string _delimiter) constant returns (string retString1, string retString2){
        var s = _value.toSlice();
        var delim = _delimiter.toSlice();
        var parts = new string[](s.count(delim) + 1);
        for(uint i = 0; i < parts.length; i++) {
            parts[i] = s.split(delim).toString();
        }
        return (parts[0], parts[1]);
    }
   
   function () payable {
       owner.transfer(this.balance);
   }
   
}