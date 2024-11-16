import React, { useState } from "react";
import {
  MiniKit,
  tokenToDecimals,
  Tokens,
  PayCommandInput,
} from "@worldcoin/minikit-js";

const PREDICTABI = require("../ABI/Predict.json");

import { VerifyBlock } from "@/components/Verify";
import { Verify } from "crypto";

export default function Modal({ market, onClose }) {
  const [guess, setGuess] = useState("");
  const [guessed, setGuessed] = useState("");
  const [verifiedProof, setVerifiedProof] = useState(false);

  console.log("vp");
  console.log(verifiedProof);
  console.log(MiniKit.user);

  const handleClose = () => {
    setGuess("");
    setGuessed("");
    setVerifiedProof(false);
    onClose();
  };

  const handleVerify = () => {
    // Simulate verification logic here
    setVerifiedProof(true); // Assume verification is successful
  };

  const handleSubmit = async () => {
    if (!MiniKit.isInstalled()) {
      console.error("MiniKit is not installed");
      return;
    }
    const sentGuess = guess;
    const finalPayload = await sendGuess(market.id, sentGuess);
    if (finalPayload.status === "success") {
      setGuessed(sentGuess);
    }
  };

  if (!market) return <div> </div>;
  if (!market.question)
    return (
      <div className="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center z-50">
        <div className="relative bg-slate-900 p-5 rounded-lg max-w-lg w-full">
          <button
            onClick={handleClose}
            className="absolute top-2 right-2 text-white text-2xl"
          >
            &times;
          </button>
          <h2 className="text-xl font-bold mb-4">{market}</h2>
        </div>
      </div>
    );

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center z-50">
      <div className="relative bg-slate-900 p-5 rounded-lg max-w-lg w-full">
        <button
          onClick={handleClose}
          className="absolute top-2 right-2 text-white text-2xl"
        >
          &times;
        </button>
        {!verifiedProof ? (
          <div className="text-center text-white">
            <h2 className="text-xl font-bold mb-4">Verification Required</h2>
            <p className="mb-4">Verify with World to make a prediction.</p>
            <VerifyBlock id={market.id} setVerifiedProof={setVerifiedProof} />
          </div>
        ) : guessed !== "" ? (
          <div className="text-center text-white">
            <h2 className="text-xl font-bold mb-4">
              Your Guess Was Submitted!
            </h2>
            <p className="mb-4">You guessed: {guessed}</p>
            <button
              onClick={handleClose}
              className="bg-blue-500 text-white p-2 rounded-lg"
            >
              Done
            </button>
          </div>
        ) : (
          <>
            <h2 className="text-xl font-bold mb-4">{market.question}</h2>
            <img
              src={market.image}
              alt={market.question}
              className="w-full h-32 object-cover rounded-lg"
            />
            <p className="mb-2 text-center text-slate-500">
              Prize: {market.prize} ・ Expiration: {market.expiration}
            </p>
            <input
              type="number"
              className="mb-4 p-2 border rounded-lg w-full text-black"
              placeholder="Enter your guess"
              value={guess}
              onChange={(e) => setGuess(e.target.value)}
            />
            <button
              className="bg-blue-500 text-white p-2 rounded-lg w-full"
              onClick={handleSubmit}
            >
              Submit
            </button>
          </>
        )}
      </div>
    </div>
  );
}

const sendGuess = async (id, guess) => {
  const { commandPayload, finalPayload } =
    await MiniKit.commandsAsync.sendTransaction({
      transaction: [
        {
          address: "0x373B210bD71C7F2e3acE1723A133D84771477eBf",
          abi: PREDICTABI,
          functionName: "setNumber",
          args: [guess],
        },
      ],
    });
  return finalPayload;
};
