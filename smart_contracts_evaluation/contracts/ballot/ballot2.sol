contract Ballot {
  struct EffectiveVoteTuple {
    uint proposal;
    bool _valid;
  }
  struct EffectiveDelegateTuple {
    address delegator;
    bool _valid;
  }
  struct VoteCountTuple {
    uint c;
    bool _valid;
  }
  struct VotedTuple {
    bool b;
    bool _valid;
  }
  struct ChairpersonTuple {
    address p;
    bool _valid;
  }
  struct HasRightTuple {
    bool b;
    bool _valid;
  }
  struct WinningProposalTuple {
    uint p;
    uint maxVotes;
    bool _valid;
  }
  mapping(address=>EffectiveVoteTuple) effectiveVote;
  mapping(address=>EffectiveDelegateTuple) effectiveDelegate;
  WinningProposalTuple winningProposal;
  mapping(uint=>VoteCountTuple) voteCount;
  mapping(address=>VotedTuple) voted;
  ChairpersonTuple chairperson;
  mapping(address=>HasRightTuple) hasRight;
  event Vote(address voter,uint proposal);
  event Delegate(address sender,address to);
  event GiveRightToVote(address voter);
  constructor(uint numProposals) public {
    updateHasRightOnInsertConstructor_r16(numProposals);
    updateChairpersonOnInsertConstructor_r10(numProposals);
  }
  function delegate(address to) public    {
      bool r5 = updateDelegateOnInsertRecv_delegate_r5(to);
      if(r5==false) {
        revert("Rule condition failed");
      }
  }
  function getVoted(address voter) public view  returns (bool) {
      bool b = voted[voter].b;
      return b;
  }
  function giveRightToVote(address voter) public    {
      bool r13 = updateGiveRightToVoteOnInsertRecv_giveRightToVote_r13(voter);
      if(r13==false) {
        revert("Rule condition failed");
      }
  }
  function getHasRight(address voter) public view  returns (bool) {
      bool b = hasRight[voter].b;
      return b;
  }
  function getWinningProposal(uint maxVotes) public view  returns (uint) {
      uint p = winningProposal.p;
      return p;
  }
  function getVoteCount(uint proposal) public view  returns (uint) {
      uint c = voteCount[proposal].c;
      return c;
  }
  function vote(uint proposal) public    {
      bool r11 = updateVoteOnInsertRecv_vote_r11(proposal);
      if(r11==false) {
        revert("Rule condition failed");
      }
  }
  function updateVoteOnInsertRecv_vote_r11(uint p) private   returns (bool) {
      address s = msg.sender;
      if(false==voted[s].b) {
        if(true==hasRight[s].b) {
          if(p!=0) {
            updateEffectiveVoteOnInsertVote_r9(s,p);
            updateVotedOnInsertVote_r3(s,p);
            emit Vote(s,p);
            return true;
          }
        }
      }
      return false;
  }
  function effectivedelegator(address to) private view  returns (address) {
      address s = effectiveDelegate[to].delegator;
      return s;
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateVoteCountOnInsertEffectiveVote_r14(address _voter0,uint p) private    {
      EffectiveVoteTuple memory toDelete = effectiveVote[_voter0];
      if(toDelete._valid==true) {
        updateVoteCountOnDeleteEffectiveVote_r14(_voter0,toDelete.proposal);
      }
      int delta0 = int(1);
      updateWinningProposalOnIncrementVoteCount_r8(p,delta0);
      voteCount[p].c += 1;
  }
  function updateDelegateOnInsertRecv_delegate_r5(address to) private   returns (bool) {
      address s = msg.sender;
      if(false==voted[s].b) {
        if(true==hasRight[s].b) {
          if(s!=to && to!=address(0)) {
            updateEffectiveDelegateOnInsertDelegate_r12(s,to);
            updateVotedOnInsertDelegate_r7(s,to);
            emit Delegate(s,to);
            return true;
          }
        }
      }
      return false;
  }
  function updateVotedOnInsertDelegate_r7(address s,address _to1) private    {
      voted[s] = VotedTuple(true,true);
  }
  function updateWinningProposalOnIncrementVoteCount_r8(uint p,int c) private    {
      uint _currentVal = voteCount[p].c;
      uint _newVal = updateuintByint(_currentVal,c);
      uint _max = winningProposal.maxVotes;
      if(_newVal>_max) {
        winningProposal = WinningProposalTuple(p,_newVal,true);
      }
  }
  function updateEffectiveVoteOnInsertEffectivedelegator_r15(address d,address v) private    {
      updateEffectiveVoteOnDeleteEffectivedelegator_r15(d,effectivedelegator(d));
      uint p = effectiveVote[d].proposal;
      if(v!=address(0) && p!=0) {
        updateVoteCountOnInsertEffectiveVote_r14(v,p);
        updateEffectiveVoteOnInsertEffectiveVote_r15(v,p);
        effectiveVote[v] = EffectiveVoteTuple(p,true);
      }
  }
  function updateEffectiveVoteOnInsertEffectiveVote_r15(address d,uint p) private    {
      EffectiveVoteTuple memory toDelete = effectiveVote[d];
      if(toDelete._valid==true) {
        updateEffectiveVoteOnDeleteEffectiveVote_r15(d,toDelete.proposal);
      }
      address v = effectivedelegator(d);
      if(v!=address(0) && p!=0) {
        updateVoteCountOnInsertEffectiveVote_r14(v,p);
        updateEffectiveVoteOnInsertEffectiveVote_r15(v,p);
        effectiveVote[v] = EffectiveVoteTuple(p,true);
      }
  }
  function updateHasRightOnInsertConstructor_r16(uint _numProposals0) private    {
      address s = msg.sender;
      hasRight[s] = HasRightTuple(true,true);
  }
  function updateVotedOnInsertVote_r3(address s,uint _proposal1) private    {
      voted[s] = VotedTuple(true,true);
  }
  function updateChairpersonOnInsertConstructor_r10(uint _numProposals0) private    {
      address s = msg.sender;
      chairperson = ChairpersonTuple(s,true);
  }
  function updateVoteCountOnDeleteEffectiveVote_r14(address _voter0,uint p) private    {
      int delta0 = int(-1);
      updateWinningProposalOnIncrementVoteCount_r8(p,delta0);
      voteCount[p].c -= 1;
  }
  function updateHasRightOnInsertGiveRightToVote_r2(address v) private    {
      hasRight[v] = HasRightTuple(true,true);
  }
  function updateEffectiveVoteOnDeleteEffectiveVote_r15(address d,uint p) private    {
      address v = effectivedelegator(d);
      if(v!=address(0) && p!=0) {
        updateEffectiveVoteOnDeleteEffectiveVote_r15(v,p);
        updateVoteCountOnDeleteEffectiveVote_r14(v,p);
        if(p==effectiveVote[v].proposal) {
          effectiveVote[v] = EffectiveVoteTuple(0,false);
        }
      }
  }
  function updateGiveRightToVoteOnInsertRecv_giveRightToVote_r13(address v) private   returns (bool) {
      address s = msg.sender;
      if(s==chairperson.p) {
        if(false==voted[v].b) {
          if(false==hasRight[v].b) {
            if(v!=address(0)) {
              updateHasRightOnInsertGiveRightToVote_r2(v);
              emit GiveRightToVote(v);
              return true;
            }
          }
        }
      }
      return false;
  }
  function updateEffectivedelegatorOnInsertEffectiveDelegate_r4(address s,address to) private    {
      updateEffectiveVoteOnInsertEffectivedelegator_r15(to,s);
  }
  function updateEffectiveDelegateOnInsertDelegate_r12(address s,address to) private    {
      updateEffectivedelegatorOnInsertEffectiveDelegate_r4(s,to);
      effectiveDelegate[to] = EffectiveDelegateTuple(s,true);
  }
  function updateEffectiveVoteOnInsertVote_r9(address v,uint p) private    {
      updateVoteCountOnInsertEffectiveVote_r14(v,p);
      updateEffectiveVoteOnInsertEffectiveVote_r15(v,p);
      effectiveVote[v] = EffectiveVoteTuple(p,true);
  }
  function updateEffectiveVoteOnDeleteEffectivedelegator_r15(address d,address v) private    {
      uint p = effectiveVote[d].proposal;
      if(v!=address(0) && p!=0) {
        updateEffectiveVoteOnDeleteEffectiveVote_r15(v,p);
        updateVoteCountOnDeleteEffectiveVote_r14(v,p);
        if(p==effectiveVote[v].proposal) {
          effectiveVote[v] = EffectiveVoteTuple(0,false);
        }
      }
  }
}