contract Voting {
  struct QuorumSizeTuple {
    uint q;
    bool _valid;
  }
  struct IsVoterTuple {
    bool b;
    bool _valid;
  }
  struct WinningProposalTuple {
    uint proposal;
    bool _valid;
  }
  struct VotedTuple {
    bool b;
    bool _valid;
  }
  struct VotesTuple {
    uint c;
    bool _valid;
  }
  struct HasWinnerTuple {
    bool b;
    bool _valid;
  }
  QuorumSizeTuple quorumSize;
  mapping(address=>IsVoterTuple) isVoter;
  WinningProposalTuple winningProposal;
  mapping(address=>VotedTuple) voted;
  HasWinnerTuple hasWinner;
  mapping(uint=>VotesTuple) votes;
  event AddVoter(address voter);
  event Vote(address p,uint proposal);
  constructor(uint quorumSize) public {
    updateQuorumSizeOnInsertConstructor_r1(quorumSize);
  }
  function getWinningProposal() public view  returns (uint) {
      uint proposal = winningProposal.proposal;
      return proposal;
  }
  function getHasWinner() public view  returns (bool) {
      bool b = hasWinner.b;
      return b;
  }
  function vote(uint proposal) public    {
      bool r8 = updateVoteOnInsertRecv_vote_r8(proposal);
      if(r8==false) {
        revert("Rule condition failed");
      }
  }
  function getVoted(address p) public view  returns (bool) {
      bool b = voted[p].b;
      return b;
  }
  function getVotes(uint proposal) public view  returns (uint) {
      uint c = votes[proposal].c;
      return c;
  }
  function addVoter(address voter) public    {
      bool r0 = updateAddVoterOnInsertRecv_addVoter_r0(voter);
      if(r0==false) {
        revert("Rule condition failed");
      }
  }
  function getWins(uint proposal) public view  returns (bool) {
      bool b = wins(proposal);
      return b;
  }
  function getIsVoter(address v) public view  returns (bool) {
      bool b = isVoter[v].b;
      return b;
  }
  function updateHasWinnerOnInsertWins_r3(uint _proposal0,bool b) private    {
      updateHasWinnerOnDeleteWins_r3(_proposal0,wins(_proposal0));
      if(b==true) {
        hasWinner = HasWinnerTuple(true,true);
      }
  }
  function updateHasWinnerOnDeleteWins_r3(uint _proposal0,bool b) private    {
      if(b==true) {
        hasWinner = HasWinnerTuple(false,false);
      }
  }
  function updateWinsOnInsertVotes_r4(uint p,uint c) private    {
      VotesTuple memory toDelete = votes[p];
      if(toDelete._valid==true) {
        updateWinsOnDeleteVotes_r4(p,toDelete.c);
      }
      uint q = quorumSize.q;
      if(c>=q) {
        updateHasWinnerOnInsertWins_r3(p,bool(true));
        updateWinningProposalOnInsertWins_r6(p,bool(true));
      }
  }
  function updateVotedOnInsertVote_r5(address v,uint _proposal1) private    {
      voted[v] = VotedTuple(true,true);
  }
  function updateVotesOnInsertVote_r2(address _p0,uint p) private    {
      int delta1 = int(1);
      updateWinsOnIncrementVotes_r4(p,delta1);
      votes[p].c += 1;
  }
  function updateVoteOnInsertRecv_vote_r8(uint p) private   returns (bool) {
      if(false==hasWinner.b) {
        address v = msg.sender;
        if(true==isVoter[v].b) {
          if(false==voted[v].b) {
            updateVotesOnInsertVote_r2(v,p);
            updateVotedOnInsertVote_r5(v,p);
            emit Vote(v,p);
            return true;
          }
        }
      }
      return false;
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateWinningProposalOnInsertWins_r6(uint p,bool b) private    {
      updateWinningProposalOnDeleteWins_r6(p,wins(p));
      if(b==true) {
        winningProposal = WinningProposalTuple(p,true);
      }
  }
  function updateWinsOnDeleteVotes_r4(uint p,uint c) private    {
      uint q = quorumSize.q;
      if(c>=q) {
        updateHasWinnerOnDeleteWins_r3(p,bool(true));
        updateWinningProposalOnDeleteWins_r6(p,bool(true));
      }
  }
  function updateIsVoterOnInsertAddVoter_r7(address v) private    {
      isVoter[v] = IsVoterTuple(true,true);
  }
  function updateAddVoterOnInsertRecv_addVoter_r0(address v) private   returns (bool) {
      if(v==msg.sender) {
        updateIsVoterOnInsertAddVoter_r7(v);
        emit AddVoter(v);
        return true;
      }
      return false;
  }
  function updateWinningProposalOnDeleteWins_r6(uint p,bool b) private    {
      if(b==true) {
        winningProposal = WinningProposalTuple(0,false);
      }
  }
  function updateQuorumSizeOnInsertConstructor_r1(uint q) private    {
      quorumSize = QuorumSizeTuple(q,true);
  }
  function wins(uint p) private view  returns (bool) {
      uint q = quorumSize.q;
      uint c = votes[p].c;
      if(c>=q) {
        return true;
      }
  }
  function updateWinsOnIncrementVotes_r4(uint p,int c) private    {
      int _delta = int(c);
      uint newValue = updateuintByint(votes[p].c,_delta);
      updateWinsOnInsertVotes_r4(p,newValue);
  }
}