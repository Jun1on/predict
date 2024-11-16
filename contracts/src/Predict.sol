// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ByteHasher} from "./helpers/ByteHasher.sol";
import {IWorldID} from "./interfaces/IWorldID.sol";

contract Predict {
    using ByteHasher for bytes;

    /// @notice Thrown when attempting to reuse a nullifier
    error DuplicateNullifier(uint256 nullifierHash);

    /// @dev The World ID instance that will be used for verifying proofs
    IWorldID internal immutable worldId;

    /// @dev The contract's external nullifier hash
    uint256 internal immutable externalNullifier;

    /// @dev The World ID group ID (always 1)
    uint256 internal immutable groupId = 1;

    /// @dev Whether a nullifier hash has been used already. Used to guarantee an action is only performed once by a single person
    mapping(uint256 => bool) internal nullifierHashes;

    /// @param nullifierHash The nullifier hash for the verified proof
    /// @dev A placeholder event that is emitted when a user successfully verifies with World ID
    event Verified(uint256 nullifierHash);

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

    constructor(
        address _worldId,
        string memory _appId,
        string memory _actionId,
        address _usdc
    ) {
        worldId = IWorldID(_worldId);
        externalNullifier = abi
            .encodePacked(abi.encodePacked(_appId).hashToField(), _actionId)
            .hashToField();
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
        Game storage game = games[gameId];
        game.creator = msg.sender;
        game.question = question;
        game.deadline = deadline;
        game.prize = prize;
        game.hasAnswer = false;
        game.correctAnswer = 0;
        game.winner = address(0);

        emit GameCreated(gameId, msg.sender, question, deadline, prize);
    }

    /// @param signal An arbitrary input from the user, usually the user's wallet address (check README for further details)
    /// @param root The root of the Merkle tree (returned by the JS widget).
    /// @param nullifierHash The nullifier hash for this proof, preventing double signaling (returned by the JS widget).
    /// @param proof The zero-knowledge proof that demonstrates the claimer is registered with World ID (returned by the JS widget).
    /// @dev Feel free to rename this method however you want! We've used `claim`, `verify` or `execute` in the past.
    function verifyAndExecute(
        address signal,
        uint256 root,
        uint256 nullifierHash,
        uint256[8] calldata proof,
        uint256 gameId,
        int256 answer
    ) public {
        // First, we make sure this person hasn't done this before
        if (nullifierHashes[nullifierHash])
            revert DuplicateNullifier(nullifierHash);

        // We now verify the provided proof is valid and the user is verified by World ID
        worldId.verifyProof(
            root,
            groupId,
            abi.encodePacked(signal).hashToField(),
            nullifierHash,
            externalNullifier,
            proof
        );

        // We now record the user has done this, so they can't do it again (proof of uniqueness)
        nullifierHashes[nullifierHash] = true;

        // Finally, execute your logic here, for example issue a token, NFT, etc...
        // Make sure to emit some kind of event afterwards!

        emit Verified(nullifierHash);

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
