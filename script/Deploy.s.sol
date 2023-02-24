// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Script.sol";

interface Poseidon {
    function hash(uint256) external view returns (uint256);
}

contract Deploy is Script {
    function run() public returns (Poseidon poseidon) {
        poseidon = Poseidon(HuffDeployer.deploy("Poseidon"));
    }
}
