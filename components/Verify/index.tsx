"use client";
import {
  MiniKit,
  VerificationLevel,
  ISuccessResult,
  MiniAppVerifyActionErrorPayload,
  IVerifyResponse,
} from "@worldcoin/minikit-js";
import { useCallback, useState } from "react";

export type VerifyCommandInput = {
  action: string;
  signal?: string;
  verification_level?: VerificationLevel; // Default: Orb
};

export const VerifyBlock = ({ id, setVerifiedProof }) => {
  const handleVerify = useCallback(async () => {
    if (!MiniKit.isInstalled()) {
      console.warn("Tried to invoke 'verify', but MiniKit is not installed.");
      return null;
    }

    const { finalPayload } = await MiniKit.commandsAsync.verify({
      action: "guess",
      signal: id.toString(),
    });

    if (finalPayload.status === "error") return;

    setVerifiedProof(finalPayload);
  }, []);

  return (
    <button
      onClick={handleVerify}
      className="bg-green-500 text-white p-2 rounded-lg"
    >
      Verify
    </button>
  );
};
