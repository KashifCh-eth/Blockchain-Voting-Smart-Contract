//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;

error _CandidateAlreadyExit();
error _AlreadyVoted();
error _CandidateNotVoteItSlef();

contract BlockchainVoting {
    address Manger;
    uint256 TotalCandidates;
    uint256 TotalVoters;

    constructor() {
        Manger = msg.sender;
    }

    struct voter {
        uint256 Id;
        string name;
        bool vote;
        address voterAddress;
    }

    struct Candidate {
        string name;
        address _CandidateAddress;
    }

    struct propsal {
        string name;
        address _CandidateAddress;
    }

    voter[] voters;
    Candidate[] Candidates;
    propsal[] propsals;

    function SetCandidate(address _Address, string memory _name)
        external
        OnlyManger
    {
        for (uint256 i = 0; i < Candidates.length; i++) {
            if (Candidates[i]._CandidateAddress == _Address) {
                revert _CandidateAlreadyExit();
            }
        }
        Candidates.push(Candidate(_name, _Address));
        TotalCandidates++;
    }

    function SetVote(
        uint256 _Id,
        string memory _name,
        address _voterAddress
    ) external {
        for (uint256 i = 0; i < voters.length; i++) {
            if (voters[i].Id == _Id && voters[i].vote == true) {
                revert _AlreadyVoted();
            }
        }

        for (uint256 i = 0; i < Candidates.length; i++) {
            if (Candidates[i]._CandidateAddress == _voterAddress) {
                revert _CandidateNotVoteItSlef();
            }
        }

        voters.push(voter(_Id, _name, true, _voterAddress));
        TotalVoters++;
    }

    function RequestForNextVoting(address _requestAddress, string memory _name)
        external
    {
        propsals.push(propsal(_name, _requestAddress));
    }

    function getRequestPropsal() external view  returns  (propsal[] memory) {
        return propsals;
    }

    function getCandidate() external view returns (Candidate[] memory) {
        return Candidates;
    }

    function getVoter() external view returns (voter[] memory) {
        return voters;
    }

    modifier OnlyManger() {
        require(msg.sender == Manger);
        _;
    }
}
