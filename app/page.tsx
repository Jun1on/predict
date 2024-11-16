"use client";
import { useState } from "react";
import MarketComponent from "../components/MarketComponent";
import CreateMarket from "../components/CreateMarket";
import Modal from "../components/Modal";
import { SignIn } from "@/components/SignIn";
import markets from "./markets";

export default function Home() {
  const [selectedMarket, setSelectedMarket] = useState(null);

  const openModal = (market) => setSelectedMarket(market);
  const closeModal = () => setSelectedMarket(null);

  return (
    <div>
      <div className="flex justify-between items-center p-5">
        <h1 className="flex items-center">
          <img src={"/icon.png"} alt="Icon" className="w-6 h-6 mr-2" />
          Predict
        </h1>
        <SignIn />
      </div>
      <div className="grid grid-cols-[repeat(auto-fill,_minmax(200px,_1fr))] gap-5 px-5 overflow-y-scroll h-[80vh]">
        {markets.map((market) => (
          <MarketComponent
            key={market.id}
            market={market}
            onClick={() => openModal(market)}
          />
        ))}
        <CreateMarket onClick={() => openModal("coming soon")} />
      </div>
      <Modal market={selectedMarket} onClose={closeModal} />
    </div>
  );
}
