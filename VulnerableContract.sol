// Author: Saurabh Singh
pragma solidity ^0.8.0;

contract VulnerableContract {
    mapping(address => uint256) private balances;
    
    function deposit() external payable {
        // Vulnerability 1: Lack of input validation (SWC-101)
        balances[msg.sender] += msg.value;
    }
    
    function withdraw(uint256 amount) external {
        // Vulnerability 2: Reentrancy (SWC-107)
        if (balances[msg.sender] >= amount) {
            balances[msg.sender] -= amount;
            (bool success, ) = msg.sender.call{value: amount}("");
            require(success, "Withdrawal failed");
        }
    }
    
    function transfer(address payable recipient, uint256 amount) external {
        // Vulnerability 3: Unchecked Call Return Value (SWC-114)
        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Transfer failed");
    }
    
    function destroy() external {
        // Vulnerability 4: Use of Deprecated Solidity Functions (SWC-105)
        selfdestruct(payable(msg.sender));
    }
    
    // Vulnerability 5: Unprotected fallback function (SWC-116)
    fallback() external payable {
        balances[msg.sender] += msg.value;
    }
    
    // Vulnerability 6: Unprotected receive function (SWC-116)
    receive() external payable {
        balances[msg.sender] += msg.value;
    }
    
    // Vulnerability 7: Insecure Randomness (SWC-114)
    function generateRandomNumber() external view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty)));
    }
    
    // Vulnerability 9: Unprotected Ether Withdrawal (SWC-118)
    function withdrawBalance() external {
        require(balances[msg.sender] > 0, "No balance to withdraw");
        uint256 amount = balances[msg.sender];
        balances[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Withdrawal failed");
    }
    
    // Vulnerability 10: Integer Overflow or Underflow (SWC-101)
    function increment(uint256 value) external pure returns (uint256) {
        return value + 1;
    }
}
