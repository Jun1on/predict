// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Predict} from "../src/Predict.sol";
import {MockERC20} from "../lib/forge-std/src/mocks/MockERC20.sol";

contract PredictScript is Script {
    Predict public predict;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        // MockERC20 mockUsdc = new MockERC20();
        // mockUsdc.initialize("Mock USDC", "USDC", 6);

        predict = new Predict(
            0x163b09b4fE21177c455D850BD815B6D583732432,
            "app_e11ef22c71e3086c308c0352221c327c",
            "guess",
            0x79A02482A880bCE3F13e09Da970dC34db4CD24d1
        );

        // mockUsdc.approve(address(predict), type(uint256).max);

        // predict.createGame(
        //     "What will be the S&P 500 price by Dec 31?",
        //     1732986000,
        //     1000e6
        // );
        // predict.createGame(
        //     "How many attendees at Devcon 2024?",
        //     1732986000,
        //     500e6
        // );
        // predict.createGame(
        //     "What will the average temperature be on Jan 1?",
        //     1732986000,
        //     200e6
        // );

        vm.stopBroadcast();
    }
}
