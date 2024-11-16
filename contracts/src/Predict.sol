// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract PredictionGame {
    struct Game {
        address creator;
        string question;
        uint256 deadline;
        uint256 prize;
        Guess[] guesses;
        bool hasAnswer;
        int256 correctAnswer;
        address winner;
    }

    struct Guess {
        address guesser;
        int256 answer;
        uint256 timestamp;
    }

    IERC20 public usdc;
    uint256 public gameIdCounter;
    mapping(uint256 => Game) public games;

    event GameCreated(
        uint256 gameId,
        address creator,
        string question,
        uint256 deadline,
        uint256 prize
    );
    event GuessMade(uint256 gameId, address guesser, int256 answer);
    event AnswerSubmitted(uint256 gameId, int256 correctAnswer, address winner);

    constructor(address _usdc) {
        usdc = IERC20(_usdc);
    }

    modifier beforeDeadline(uint256 gameId) {
        require(block.timestamp < games[gameId].deadline, "Game has ended");
        _;
    }

    modifier afterDeadline(uint256 gameId) {
        require(
            block.timestamp >= games[gameId].deadline,
            "Game is still active"
        );
        _;
    }

    modifier onlyCreator(uint256 gameId) {
        require(
            games[gameId].creator == msg.sender,
            "Only game creator can call this"
        );
        _;
    }

    function createGame(
        string memory question,
        uint256 deadline,
        uint256 prize
    ) external {
        require(deadline > block.timestamp, "Deadline must be in the future");
        usdc.transferFrom(msg.sender, address(this), prize);

        uint256 gameId = gameIdCounter++;
        games[gameId] = Game({
            creator: msg.sender,
            question: question,
            deadline: deadline,
            prize: prize,
            hasAnswer: false,
            correctAnswer: 0,
            winner: address(0)
        });

        emit GameCreated(gameId, msg.sender, question, deadline, prize);
    }

    function makeGuess(
        uint256 gameId,
        int256 answer
    ) external beforeDeadline(gameId) {
        // Ensure unique human

        games[gameId].guesses.push(
            Guess({
                guesser: msg.sender,
                answer: answer,
                timestamp: block.timestamp
            })
        );

        emit GuessMade(gameId, msg.sender, answer);
    }

    function submitAnswer(
        uint256 gameId,
        int256 correctAnswer
    ) external afterDeadline(gameId) onlyCreator(gameId) {
        Game storage game = games[gameId];
        require(!game.hasAnswer, "Answer already submitted");

        game.correctAnswer = correctAnswer;
        game.hasAnswer = true;

        Guess[] storage guesses = game.guesses;
        require(guesses.length > 0, "No guesses made");

        uint256 closestGuesserIndex;
        uint256 closestDistance = type(uint256).max;

        // Find the closest guess
        uint256 length = guesses.length;
        for (uint256 i = 0; i < length; ) {
            uint256 distance = abs(correctAnswer, guesses[i].answer);
            if (
                distance < closestDistance ||
                (distance == closestDistance &&
                    guesses[i].timestamp <
                    guesses[closestGuesserIndex].timestamp)
            ) {
                closestDistance = distance;
                closestGuesserIndex = i;
            }
            unchecked {
                i++;
            }
        }

        game.winner = guesses[closestGuesserIndex].guesser;

        usdc.transfer(game.winner, game.prize);

        emit AnswerSubmitted(gameId, correctAnswer, game.winner);
    }

    function abs(int256 a, int256 b) private pure returns (uint256) {
        return a >= b ? uint256(a - b) : uint256(b - a);
    }
}
