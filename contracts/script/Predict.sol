// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Predict} from "../src/Predict.sol";

contract PredictScript is Script {
    Predict public predict;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        predict = new Predict();

        vm.stopBroadcast();
    }
}
