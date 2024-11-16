export default function MarketComponent({ market, onClick }) {
  return (
    <div
      onClick={onClick}
      className="border border-gray-300 rounded-lg text-center cursor-pointer shadow-md"
    >
      <img
        src={market.image}
        alt={market.question}
        className="w-full h-32 object-cover rounded-t-lg"
      />
      <div className="p-3">
        <h3 className="my-2 text-lg font-semibold">{market.question}</h3>
        <p className="my-1 font-bold">Prize: {market.prize}</p>
        <p className="my-1 text-gray-600">Expires: {market.expiration}</p>
      </div>
    </div>
  );
}
