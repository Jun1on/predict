"use client";
import {
  MiniKit,
  tokenToDecimals,
  Tokens,
  PayCommandInput,
} from "@worldcoin/minikit-js";

const PREDICTABI = require("../../ABI/Predict.json");

const sendTransactionCommand = async () => {
  const { commandPayload, finalPayload } =
    await MiniKit.commandsAsync.sendTransaction({
      transaction: [
        {
          address: "0x373B210bD71C7F2e3acE1723A133D84771477eBf",
          abi: PREDICTABI,
          functionName: "increment",
          args: [],
        },
      ],
    });
  return finalPayload;
};

const handlePay = async () => {
  if (!MiniKit.isInstalled()) {
    console.error("MiniKit is not installed");
    return;
  }
  const finalPayload = await sendTransactionCommand();
  console.log(finalPayload.transaction_id);
};

export const PayBlock = () => {
  return (
    <button className="bg-blue-500 p-4" onClick={handlePay}>
      Pay
    </button>
  );
};
