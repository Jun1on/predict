// data/markets.js

const markets = [
    {
        id: 1,
        question: "What will be the S&P 500 price by Dec 31?",
        image: "/stocks.png",
        prize: "$1000",
        expiration: "Nov 31, 2024",
        description: "This market resolves based on the official closing price of the S&P 500 index on December 31, 2024, as reported by a credible financial news outlet. Participants should refer to the end-of-year official data.",
    },
    {
        id: 2,
        question: "How many attendees at Devcon 2024?",
        image: "/devcon.png",
        prize: "$500",
        expiration: "Nov 20, 2024",
        description: "The market resolves to the official attendance number released by the Devcon 2024 organizing committee at the conclusion of the event. This includes all registered attendees present.",
    },
    {
        id: 3,
        question: "What will the average temperature be on Jan 1?",
        image: "/weather.png",
        prize: "$200",
        expiration: "Dec 1, 2025",
        description: "The market resolves based on the average temperature of the Earth on January 1, 2025, using data from a recognized meteorological service such as the National Weather Service.",
    },
];

export default markets;
