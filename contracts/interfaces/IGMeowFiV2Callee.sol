/// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;

interface IGMeowFiV2Callee {
    function gMeowFiV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external;
}
