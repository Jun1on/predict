"use client";
import { signIn, signOut, useSession } from "next-auth/react";

export const SignIn = () => {
  const { data: session } = useSession();
  if (session) {
    return (
      <>
        <button onClick={() => signOut()}>
          <a
            href={`https://worldchain-mainnet.explorer.alchemy.com/address/${session?.user?.name}`}
            target="_blank"
            rel="noopener noreferrer"
          >
            {session?.user?.name?.slice(0, 6)}
          </a>
        </button>
        <br />
        <button onClick={() => signOut()}>Sign out</button>
      </>
    );
  } else {
    return (
      <>
        Not signed in <br />
        <button onClick={() => signIn()}>Sign in</button>
      </>
    );
  }
};
