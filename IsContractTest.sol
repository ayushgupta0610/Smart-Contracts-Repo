pragma solidity ^0.5.5;


contract Test{
    
    // Public keyword would allow to fetch isContract's bool value, called from the constructor of this contract.
    bool public isContract;
    
    // This btw is a very clever way to put the logic in the constructor itself which would act as an EOA for the other contract. 
    constructor() public{
        isContract = SimpleContract(<SimpleContractAddress>).checkForContract();
    }
    
    function isCallFromContract() public view returns (bool){
        return SimpleContract(<SimpleContractAddress>).checkForContract();
    }
    
}


contract SimpleContract{
    
    function isContract(address _addr) public view returns (bool isContract){
      uint32 size;
      assembly {
        size := extcodesize(_addr)
      }
      return (size > 0);
    }
    
    function checkForContract() public view returns (bool checkBool){
        if(isContract(msg.sender)){
            return true;
        } else {
            return false;
        }
    }
    
}
