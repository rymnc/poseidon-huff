// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

contract PoseidonSol {
    uint256 constant Q =
        21888242871839275222246405745257275088548364400416034343698204186575808495617;
    uint256 constant C0 =
        4417881134626180770308697923359573201005643519861877412381846989312604493735;
    uint256 constant C1 =
        5433650512959517612316327474713065966758808864213826738576266661723522780033;
    uint256 constant C2 =
        13641176377184356099764086973022553863760045607496549923679278773208775739952;
    uint256 constant C3 =
        17949713444224994136330421782109149544629237834775211751417461773584374506783;
    uint256 constant C4 =
        13765628375339178273710281891027109699578766420463125835325926111705201856003;
    uint256 constant C5 =
        19179513468172002314585757290678967643352171735526887944518845346318719730387;
    uint256 constant C6 =
        5157412437176756884543472904098424903141745259452875378101256928559722612176;
    uint256 constant C7 =
        535160875740282236955320458485730000677124519901643397458212725410971557409;
    uint256 constant C8 =
        1050793453380762984940163090920066886770841063557081906093018330633089036729;
    uint256 constant C9 =
        10665495010329663932664894101216428400933984666065399374198502106997623173873;
    uint256 constant M00 =
        2910766817845651019878574839501801340070030115151021261302834310722729507541;
    uint256 constant M01 =
        19727366863391167538122140361473584127147630672623100827934084310230022599144;
    uint256 constant M10 =
        5776684794125549462448597414050232243778680302179439492664047328281728356345;
    uint256 constant M11 =
        8348174920934122550483593999453880006756108121341067172388445916328941978568;

    function hash(uint256 input) external pure returns (uint256 result) {
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

            //ROUND 1 - FULL
            s0 := add(s0, C2)
            s1 := add(s1, C3)
            // SBOX
            t := mulmod(s0, s0, q)
            s0 := mulmod(mulmod(t, t, q), s0, q)
            t := mulmod(s1, s1, q)
            s1 := mulmod(mulmod(t, t, q), s1, q)
            // MIX
            t := add(mulmod(s0, M00, q), mulmod(s1, M01, q))
            s1 := add(mulmod(s0, M10, q), mulmod(s1, M11, q))
            s0 := t

            //ROUND 2 - FULL
            s0 := add(s0, C4)
            s1 := add(s1, C5)
            // SBOX
            t := mulmod(s0, s0, q)
            s0 := mulmod(mulmod(t, t, q), s0, q)
            t := mulmod(s1, s1, q)
            s1 := mulmod(mulmod(t, t, q), s1, q)
            // MIX
            t := add(mulmod(s0, M00, q), mulmod(s1, M01, q))
            s1 := add(mulmod(s0, M10, q), mulmod(s1, M11, q))
            s0 := t

            //ROUND 3 - FULL
            s0 := add(s0, C6)
            s1 := add(s1, C7)
            // SBOX
            t := mulmod(s0, s0, q)
            s0 := mulmod(mulmod(t, t, q), s0, q)
            t := mulmod(s1, s1, q)
            s1 := mulmod(mulmod(t, t, q), s1, q)
            // MIX
            t := add(mulmod(s0, M00, q), mulmod(s1, M01, q))
            s1 := add(mulmod(s0, M10, q), mulmod(s1, M11, q))
            s0 := t

            //ROUND 4 - PARTIAL
            s0 := add(s0, C8)
            s1 := add(s1, C9)
            // SBOX
            t := mulmod(s0, s0, q)
            s0 := mulmod(mulmod(t, t, q), s0, q)
            // MIX
            t := add(mulmod(s0, M00, q), mulmod(s1, M01, q))
            s1 := add(mulmod(s0, M10, q), mulmod(s1, M11, q))
            s0 := t

            result := s0
        }
    }
}

contract PoseidonTest is Test {
    /// @dev Address of the Poseidon contract.
    Poseidon public poseidon;
    PoseidonSol public poseidonSol;

    /// @dev Setup the testing environment.
    function setUp() public {
        poseidon = Poseidon(HuffDeployer.deploy("Poseidon"));
        poseidonSol = new PoseidonSol();
    }

    /// @dev Ensure that you can hash a value.
    function testHasher(uint256 value) public {
        assertEq(poseidonSol.hash(value), poseidon.hash(value));
    }

    function testGasSolHasher(uint256 value) public {
        poseidonSol.hash(value);
    }

    function testGasHuffHasher(uint256 value) public {
        poseidon.hash(value);
    }
}

interface Poseidon {
    function hash(uint256) external view returns (uint256);
}
