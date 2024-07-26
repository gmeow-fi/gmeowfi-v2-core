pragma solidity =0.5.16;

import './interfaces/IGMeowFiV2Factory.sol';
import './GMeowFiV2Pair.sol';

contract GMeowFiV2Factory is IGMeowFiV2Factory {
    bytes32 public constant INIT_CODE_POOL_HASH = keccak256(abi.encodePacked(type(GMeowFiV2Pair).creationCode));
    address public feeTo;
    address public feeToSetter;

    mapping(address => mapping(address => address)) public getPair;
    address[] public allPairs;

    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    constructor(address _feeToSetter) public {
        feeToSetter = _feeToSetter;
    }

    function allPairsLength() external view returns (uint) {
        return allPairs.length;
    }

    function createPair(address tokenA, address tokenB) external returns (address pair) {
        require(tokenA != tokenB, 'GMEOWFIV2: IDENTICAL_ADDRESSES');
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'GMEOWFIV2: ZERO_ADDRESS');
        require(getPair[token0][token1] == address(0), 'GMEOWFIV2: PAIR_EXISTS'); // single check is sufficient
        bytes memory bytecode = type(GMeowFiV2Pair).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        IGMeowFiV2Pair(pair).initialize(token0, token1);
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair; // populate mapping in the reverse direction
        allPairs.push(pair);

        emit PairCreated(token0, token1, pair, allPairs.length);
    }

    function setFeeTo(address _feeTo) external {
        require(msg.sender == feeToSetter, 'GMEOWFIV2: FORBIDDEN');
        feeTo = _feeTo;
    }

    function setFeeToSetter(address _feeToSetter) external {
        require(msg.sender == feeToSetter, 'GMEOWFIV2: FORBIDDEN');
        feeToSetter = _feeToSetter;
    }

    function getPairs(uint256 offset, uint256 length) external view returns (address[] memory) {
        if (offset > allPairs.length) {
            return new address[](0);
        }
        uint256 end = offset + length;
        if (end > allPairs.length) {
            end = allPairs.length;
        }
        address[] memory pairs = new address[](end - offset);
        for (uint256 i = offset; i < end; i++) {
            pairs[i - offset] = allPairs[i];
        }
        return pairs;
    }
}
