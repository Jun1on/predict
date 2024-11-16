export default function Modal({ market, onClose }) {
  if (!market) return <div> </div>;

  if (!market.question)
    return (
      <div className="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center z-50">
        <div className="relative bg-slate-900 p-5 rounded-lg max-w-lg w-full">
          <button
            onClick={onClose}
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
          onClick={onClose}
          className="absolute top-2 right-2 text-white text-2xl"
        >
          &times;
        </button>
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
          className="mb-4 p-2 border rounded-lg w-full"
          placeholder="Enter your guess"
        />
        <button
          className="bg-blue-500 text-white p-2 rounded-lg w-full"
          onClick={handleSubmit}
        >
          Submit
        </button>
      </div>
    </div>
  );
}

function handleSubmit() {}
