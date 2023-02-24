// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

contract PoseidonTest is Test {
    /// @dev Address of the Poseidon contract.
    Poseidon public poseidon;

    uint256 constant Q =
        21888242871839275222246405745257275088548364400416034343698204186575808495617;
    uint256 constant C0 =
        4417881134626180770308697923359573201005643519861877412381846989312604493735;
    uint256 constant C1 =
        5433650512959517612316327474713065966758808864213826738576266661723522780033;
    uint256 constant C2 =
        13641176377184356099764086973022553863760045607496549923679278773208775739952;
    uint256 constant M00 =
        2910766817845651019878574839501801340070030115151021261302834310722729507541;
    uint256 constant M01 =
        19727366863391167538122140361473584127147630672623100827934084310230022599144;
    uint256 constant M10 =
        5776684794125549462448597414050232243778680302179439492664047328281728356345;
    uint256 constant M11 =
        8348174920934122550483593999453880006756108121341067172388445916328941978568;

    function hash(uint256 input) internal pure returns (uint256 result) {
        assembly {
            let q := Q
            //ROUND 0 - FULL
            let s0 := C0
            let s1 := add(input, C1)
            // SBOX
            let t := mulmod(s0, s0, q)
            s0 := mulmod(mulmod(t, t, q), s0, q)
            t := mulmod(s1, s1, q)
            s1 := mulmod(mulmod(t, t, q), s1, q)
            // MIX
            t := add(mulmod(s0, M00, q), mulmod(s1, M01, q))
            s1 := add(mulmod(s0, M10, q), mulmod(s1, M11, q))
            s0 := t

            result := s0
        }
    }

    /// @dev Setup the testing environment.
    function setUp() public {
        poseidon = Poseidon(HuffDeployer.deploy("Poseidon"));
    }

    /// @dev Ensure that you can hash a value.
    function testHasher(uint256 value) public {
        assertEq(hash(value), poseidon.hash(value));
    }
}

interface Poseidon {
    function hash(uint256) external view returns (uint256);
}
