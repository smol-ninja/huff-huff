// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.23;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";

interface Math {
    function add(uint256, uint256) external returns (uint256);
    function sub(uint256, uint256) external returns (uint256);
    function mul(uint256, uint256) external returns (uint256);
    function div(uint256, uint256) external returns (uint256);
}

contract Benchmark {
    Math public immutable huffMath;

    constructor(Math _huffMath) {
        huffMath = _huffMath;
    }

    function add(uint256 a, uint256 b) public pure returns (uint256) {
        return a + b;
    }

    function addWithHuff(uint256 a, uint256 b) public returns (uint256) {
        return huffMath.add(a, b);
    }

    function sub(uint256 a, uint256 b) public pure returns (uint256) {
        return a - b;
    }

    function subWithHuff(uint256 a, uint256 b) public returns (uint256) {
        return huffMath.sub(a, b);
    }

    function mul(uint256 a, uint256 b) public pure returns (uint256) {
        return a * b;
    }

    function mulWithHuff(uint256 a, uint256 b) public returns (uint256) {
        return huffMath.mul(a, b);
    }

    function div(uint256 a, uint256 b) public pure returns (uint256) {
        return a / b;
    }

    function divWithHuff(uint256 a, uint256 b) public returns (uint256) {
        return huffMath.div(a, b);
    }
}

contract BenchmarkTest is Test {
    Math public huffMath;
    Benchmark public benchmark;
    uint256 public constant NUM_A = 1000000;
    uint256 public constant NUM_B = 800000;

    function setUp() public {
        huffMath = Math(HuffDeployer.deploy("Math"));
        benchmark = new Benchmark(huffMath);
    }

    function test_add() public {
        uint256 actual = benchmark.add(NUM_A, NUM_B);
        assertEq(actual, NUM_A + NUM_B, "simple-add");
    }

    function test_addWithHuff() public {
        uint256 actual = benchmark.addWithHuff(NUM_A, NUM_B);
        assertEq(actual, NUM_A + NUM_B, "huff-add");
    }

    function test_sub() public {
        uint256 actual = benchmark.sub(NUM_A, NUM_B);
        assertEq(actual, NUM_A - NUM_B, "simple-sub");
    }

    function test_subWithHuff() public {
        uint256 actual = benchmark.subWithHuff(NUM_A, NUM_B);
        assertEq(actual, NUM_A - NUM_B, "huff-sub");
    }

    function test_mul() public {
        uint256 actual = benchmark.mul(NUM_A, NUM_B);
        assertEq(actual, NUM_A * NUM_B, "simple-mul");
    }

    function test_mulWithHuff() public {
        uint256 actual = benchmark.mulWithHuff(NUM_A, NUM_B);
        assertEq(actual, NUM_A * NUM_B, "huff-mul");
    }

    function test_div() public {
        uint256 actual = benchmark.div(NUM_A, NUM_B);
        assertEq(actual, NUM_A / NUM_B, "simple-div");
    }

    function test_divWithHuff() public {
        uint256 actual = benchmark.divWithHuff(NUM_A, NUM_B);
        assertEq(actual, NUM_A / NUM_B, "huff-div");
    }
}
