// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Predict} from "../src/Predict.sol";

contract PredictTest is Test {
    Predict public predict;

    function setUp() public {
        predict = new Predict();
        predict.setNumber(0);
    }

    function test_Increment() public {
        predict.increment();
        assertEq(predict.number(), 1);
    }

    function testFuzz_SetNumber(uint256 x) public {
        predict.setNumber(x);
        assertEq(predict.number(), x);
    }
}
