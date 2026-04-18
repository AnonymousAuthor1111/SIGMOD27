pragma solidity ^0.8.0;

contract Voting {
    uint256 public quorumSize;
    bool public hasWinner;
    uint256 public winningProposal;

    mapping(address => bool) public isVoter;
    mapping(address => bool) public voted;
    mapping(uint256 => uint256) public votes;

    event VoterAdded(address indexed voter);
    event VoteCast(address indexed voter, uint256 proposal);
    event WinnerDeclared(uint256 proposal);

    constructor(uint256 _quorumSize) {
        require(_quorumSize > 0, "quorum must be positive");
        quorumSize = _quorumSize;
        hasWinner = false;
        winningProposal = type(uint256).max;
    }

    function addVoter(address voter) external {
        require(!isVoter[voter], "already voter");
        isVoter[voter] = true;
        emit VoterAdded(voter);
    }

    function vote(uint256 proposal) external {
        require(!hasWinner, "vote closed");
        require(isVoter[msg.sender], "not voter");
        require(!voted[msg.sender], "already voted");

        voted[msg.sender] = true;
        votes[proposal] += 1;
        emit VoteCast(msg.sender, proposal);

        if (votes[proposal] >= quorumSize) {
            hasWinner = true;
            winningProposal = proposal;
            emit WinnerDeclared(proposal);
        }
    }

    function getVoteCount(uint256 proposal) external view returns (uint256) {
        return votes[proposal];
    }

    function getWinningProposal() external view returns (uint256) {
        require(hasWinner, "no winner yet");
        return winningProposal;
    }
}
