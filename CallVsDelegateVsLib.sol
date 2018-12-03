pragma solidity ^0.4.18;

contract SomeContract {
    event callMeEvent(address _from);
    function callMe() public returns (address){
        callMeEvent(this);
        return this;
    }
}

contract ThatCallsSomeContract {
    function callTheOtherContract(address _contractAddress) public returns (address, bool, bool, address) {
        SomeContract someContract = SomeContract(_contractAddress);
        // someContract.callMe();
        // _contractAddress.call(bytes4(keccak256("callMe()")));
        // _contractAddress.delegatecall(bytes4(keccak256("callMe()")));
        // SomeLib.calledSomeLibFun();
        return (someContract.callMe(),_contractAddress.call(bytes4(keccak256("callMe()"))),
            _contractAddress.delegatecall(bytes4(keccak256("callMe()"))), SomeLib.calledSomeLibFun());
    }
}

library SomeLib {
    event calledSomeLib(address _from);
    
    function calledSomeLibFun() public returns (address){
        calledSomeLib(this);
        return this;
    }
}