pragma solidity ^0.4.6;

import './Ownable.sol';

contract BlockArrayChain is Ownable {
  mapping (bytes32 => address) public records;
  mapping (bytes32 => uint256) public timestamps;

  event _BlockArrayChained(bytes32 indexed record, address indexed transact, uint256 timestamp);

  function transact(bytes32 record) external {
    bytes32 hash = keccak256(record);
    require(hash != keccak256(""));
    require(records[hash] == address(0));
    require(timestamps[hash] == 0);
    records[hash] = msg.sender;
    timestamps[hash] = block.timestamp;

    _BlockArrayChained(hash, msg.sender, block.timestamp);
  }

  function exists(bytes32 record) constant returns (bool) {
    bytes32 hash = keccak256(record);
    return records[hash] != address(0);
  }

  function getTransact(bytes32 record) constant returns (address) {
    return records[keccak256(record)];
  }

  function getTimestamp(bytes32 record) constant returns (uint256) {
    return timestamps[keccak256(record)];
  }

  function didTransact(bytes32 record) constant returns (bool) {
    return records[keccak256(record)] == msg.sender;
  }

  function isTransact(bytes32 record, address transact) constant returns (bool) {
    return records[keccak256(record)] == transact;
  }

  function ecrecovery(bytes32 hash, bytes sig) public constant returns (address) {
    bytes32 r;
    bytes32 s;
    uint8 v;

    if (sig.length != 65) {
      return 0;
    }

    assembly {
      r := mload(add(sig, 32))
      s := mload(add(sig, 64))
      v := and(mload(add(sig, 65)), 255)
    }
 if (v < 27) {
         v += 27;
    }

    if (v != 27 && v != 28) {
      return 0;
    }

    return ecrecover(hash, v, r, s);
  }
   function ecverify(bytes32 hash, bytes sig, address signer) public constant returns (bool) {
      return signer == ecrecovery(hash, sig);
  }
}
