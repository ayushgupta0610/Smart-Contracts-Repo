pragma solidity ^0.5.5;


contract Test{
    
    bool public isContract;
    
    constructor() public{
        isContract = SimpleContract(0x6f147068E4191d15cf2843b09Eea6B545A182713).checkForContract();
    }
    
    function isCallFromContract() public view returns (bool){
        return SimpleContract(0x6f147068E4191d15cf2843b09Eea6B545A182713).checkForContract();
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
