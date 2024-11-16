export default function CreateMarket({ onClick }) {
  return (
    <div
      onClick={onClick}
      className="border-2 border-dashed border-gray-300 rounded-lg text-center cursor-pointer shadow-md flex flex-col justify-center items-center h-52"
    >
      <div className="text-4xl mb-2">+</div>
      <h3 className="m-0">Create Market</h3>
    </div>
  );
}
