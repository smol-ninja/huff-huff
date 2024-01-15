// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.23;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";

contract MathTest is Test {
    Math public math;

    function setUp() public {
        math = Math(HuffDeployer.deploy("Math"));
    }

    function testFuzz_Add(uint256 a, uint256 b) public {
        uint256 expected;
        unchecked {
            expected = a + b;
        }
        vm.assume(expected >= a);

        uint256 actual = math.add(a, b);
        assertEq(actual, expected, "add");
    }

    function testFuzz_Revert_Add(uint256 a, uint256 b) public {
        uint256 expected;
        unchecked {
            expected = a + b;
        }
        vm.assume(expected < a);

        vm.expectRevert();
        math.add(a, b);
    }

    function testFuzz_Sub(uint256 a, uint256 b) public {
        vm.assume(b <= a);

        uint256 expected = a - b;
        uint256 actual = math.sub(a, b);
        assertEq(actual, expected, "sub");
    }

    function testFuzz_Revert_Sub(uint256 a, uint256 b) public {
        vm.assume(b > a);

        vm.expectRevert();
        math.sub(a, b);
    }

    function testFuzz_Mul(uint256 a, uint256 b) public {
        uint256 expected;
        unchecked {
            expected = a * b;
        }

        if (a > 0) {
            vm.assume(expected / a == b);
        }

        uint256 actual = math.mul(a, b);
        assertEq(actual, expected, "mul");
    }

    function testFuzz_Revert_Mul(uint256 a, uint256 b) public {
        vm.assume(a > 0);

        uint256 expected;
        unchecked {
            expected = a * b;
        }
        vm.assume(expected / a != b);

        vm.expectRevert();
        math.mul(a, b);
    }

    function testFuzz_Div(uint256 a, uint256 b) public {
        vm.assume(b > 0);
        uint256 expected = a / b;

        uint256 actual = math.div(a, b);
        assertEq(actual, expected, "div");
    }

    function testFuzz_Revert_Div(uint256 a) public {
        uint256 b = 0;

        vm.expectRevert();
        math.div(a, b);
    }
}

interface Math {
    function add(uint256, uint256) external returns (uint256);
    function sub(uint256, uint256) external returns (uint256);
    function mul(uint256, uint256) external returns (uint256);
    function div(uint256, uint256) external returns (uint256);
}
