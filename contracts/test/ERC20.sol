pragma solidity =0.5.16;

import '../GMeowFiV2ERC20.sol';

contract ERC20 is GMeowFiV2ERC20 {
    constructor(uint _totalSupply) public {
        _mint(msg.sender, _totalSupply);
    }
}
