const {
  BN,
  constants,
  expectEvent,
  expectRevert,
  time,
} = require('@openzeppelin/test-helpers');

const helper = require("./helper_functions");
const fs = require('fs');
const path = require('path');

const testFolder = path.join(__dirname, `../testTraces/brickBlockToken`);
// set up tests for contracts
const testPath = path.join(testFolder, '/setup.txt');
const setup = fs.readFileSync(testPath, 'utf-8');
let contractName;
let deployAccountCount = 10;
setup.split(/\r?\n/).some(line => {
  let lineArr = line.split(',');
  if(lineArr[0] == 'n') {
    contractName = lineArr[1];
    return true;
  }
  if(lineArr[0] == 'a') {
    deployAccountCount = +lineArr[1];
  }
})

// read setup.txt in each test folder
const transactionFolders = fs.readdirSync(testFolder, {withFileTypes: true})
  .filter(dirent => dirent.isDirectory())
  .map(dirent => dirent.name);
const transactionCounts = transactionFolders.length;
var transactionName;
var transactionFolderPath;
var setupPath;
var transactionCount = 1;
var tracefileCount = 0;

const approveUpperBound = 500;
const approveLowerBound = 10;
const increaseApprovalUpperBound = 500;
const increaseApprovalLowerBound = 10;

helper.range(transactionCounts).forEach(l => {
  transactionName = transactionFolders[l];
  transactionFolderPath = path.join(testFolder, `/${transactionName}`);
  setupPath = path.join(transactionFolderPath, '/setup.txt');
  if (fs.existsSync(setupPath)) {
    console.log('setup exists');
    const setupFS = fs.readFileSync(setupPath, 'utf-8');
    const setupLines = setupFS.split(/\r?\n/);
    let i = 0;
    while(i < setupLines.length) {
      let sl = setupLines[i];
      if(sl.startsWith('nt')) {
        transactionCount = +sl.split(',')[1];
      }
      i++;
    }
  }

  if(transactionName == 'approve') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let owner = helper.random(0, deployAccountCount);
      let caller = helper.random(0, deployAccountCount);
      let arrayRandom = [];
      for (let index = 0; index < deployAccountCount; index++) {
        if(index != caller) arrayRandom.push(index);
      }
      let spender = arrayRandom[helper.random(0, arrayRandom.length)];
      let amt1 = helper.random(approveLowerBound, approveUpperBound + 1);
      let amt2 = amt1 + helper.random(1, approveUpperBound + 1);
      let bonusAddr = (owner + 1) % deployAccountCount;
      let text = `approve,constructor,,accounts[${bonusAddr}],${owner},,false\napprove,unpause,instance,,${owner},,false\napprove,approve,instance,accounts[${spender}] ${amt1},${caller},,false\napprove,approve,instance,accounts[${spender}] ${amt2},${caller},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    })
  }

  if(transactionName == 'increaseApproval') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let owner = helper.random(0, deployAccountCount);
      let caller = helper.random(0, deployAccountCount);
      let arrayRandom = [];
      for (let index = 0; index < deployAccountCount; index++) {
        if(index != caller) arrayRandom.push(index);
      }
      let spender = arrayRandom[helper.random(0, arrayRandom.length)];
      let amt1 = helper.random(increaseApprovalLowerBound, increaseApprovalUpperBound + 1);
      let amt2 = helper.random(increaseApprovalLowerBound, increaseApprovalUpperBound + 1);
      let bonusAddr = (owner + 1) % deployAccountCount;
      let text = `increaseApproval,constructor,,accounts[${bonusAddr}],${owner},,false\nincreaseApproval,unpause,instance,,${owner},,false\nincreaseApproval,increaseApproval,instance,accounts[${spender}] ${amt1},${caller},,false\nincreaseApproval,increaseApproval,instance,accounts[${spender}] ${amt2},${caller},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    })
  }

  if(transactionName == 'decreaseApproval') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let owner = helper.random(0, deployAccountCount);
      let caller = helper.random(0, deployAccountCount);
      let arrayRandom = [];
      for (let index = 0; index < deployAccountCount; index++) {
        if(index != caller) arrayRandom.push(index);
      }
      let spender = arrayRandom[helper.random(0, arrayRandom.length)];
      let amt1 = helper.random(10, 200);
      let amt2 = helper.random(10, 200);
      let bigAmount = amt1 + amt2 + helper.random(50, 300);
      // increaseApproval first to build allowance, then decrease twice
      // Need: bigAmount >= amt1 + amt2 so remaining after first decrease >= amt2
      let bonusAddr = (owner + 1) % deployAccountCount;
      let text = `decreaseApproval,constructor,,accounts[${bonusAddr}],${owner},,false\ndecreaseApproval,unpause,instance,,${owner},,false\ndecreaseApproval,increaseApproval,instance,accounts[${spender}] ${bigAmount},${caller},,false\ndecreaseApproval,decreaseApproval,instance,accounts[${spender}] ${amt1},${caller},,false\ndecreaseApproval,decreaseApproval,instance,accounts[${spender}] ${amt2},${caller},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    })
  }

  if(transactionName == 'unpause') {
    // unpause: needs sender==owner, paused==true (from constructor), dead==false (default)
    // One-shot: after unpause, paused=false, can't call again
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let owner = helper.random(0, deployAccountCount);
      let bonusAddr = (owner + 1) % deployAccountCount;
      let text = `unpause,constructor,,accounts[${bonusAddr}],${owner},,false\nunpause,unpause,instance,,${owner},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    })
  }

  if(transactionName == 'toggleDead') {
    // toggleDead: needs sender==owner, toggles dead flag
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let owner = helper.random(0, deployAccountCount);
      let bonusAddr = (owner + 1) % deployAccountCount;
      let text = `toggleDead,constructor,,accounts[${bonusAddr}],${owner},,false\ntoggleDead,toggleDead,instance,,${owner},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    })
  }

  if(transactionName == 'changeFountainContractAddress') {
    // changeFountainContractAddress: needs sender==owner, a!=owner, a!=address(this)
    // Doesn't change state, so can call multiple times for warm-up
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let owner = helper.random(0, deployAccountCount);
      let arrayRandom = [];
      for (let index = 0; index < deployAccountCount; index++) {
        if(index != owner) arrayRandom.push(index);
      }
      let addr = arrayRandom[helper.random(0, arrayRandom.length)];
      let bonusAddr = (owner + 1) % deployAccountCount;
      let text = `changeFountainContractAddress,constructor,,accounts[${bonusAddr}],${owner},,false\nchangeFountainContractAddress,changeFountainContractAddress,instance,accounts[${addr}],${owner},,false\nchangeFountainContractAddress,changeFountainContractAddress,instance,accounts[${addr}],${owner},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    })
  }

  if(transactionName == 'transfer') {
    // transfer: needs paused==false (call unpause first as setup), balance >= n, to != address(0)
    // No mint available, so balance is always 0 -> n must be 0
    // unpause gas is NOT counted (marked false)
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let owner = helper.random(0, deployAccountCount);
      let sender = helper.random(0, deployAccountCount);
      let arrayRandom = [];
      for (let index = 0; index < deployAccountCount; index++) {
        if(index != sender) arrayRandom.push(index);
      }
      let to = arrayRandom[helper.random(0, arrayRandom.length)];
      let bonusAddr = (owner + 1) % deployAccountCount;
      let text = `transfer,constructor,,accounts[${bonusAddr}],${owner},,false\ntransfer,unpause,instance,,${owner},,false\ntransfer,transfer,instance,accounts[${to}] 0,${sender},,false\ntransfer,transfer,instance,accounts[${to}] 0,${sender},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    })
  }

  if(transactionName == 'transferFrom') {
    // transferFrom: needs allowed[from][sender] >= n, balances[from] >= n, to != address(0)
    // With n=0: 0<=0 for both checks. No approval or balance needed.
    // No paused check in transferFrom.
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let owner = helper.random(0, deployAccountCount);
      let sender = helper.random(0, deployAccountCount);
      let arrayRandom = [];
      for (let index = 0; index < deployAccountCount; index++) {
        if(index != sender) arrayRandom.push(index);
      }
      let frm = arrayRandom[helper.random(0, arrayRandom.length)];
      let arrayRandom2 = [];
      for (let index = 0; index < deployAccountCount; index++) {
        if(index != sender && index != frm) arrayRandom2.push(index);
      }
      let to = arrayRandom2[helper.random(0, arrayRandom2.length)];
      let bonusAddr = (owner + 1) % deployAccountCount;
      let text = `transferFrom,constructor,,accounts[${bonusAddr}],${owner},,false\ntransferFrom,unpause,instance,,${owner},,false\ntransferFrom,transferFrom,instance,accounts[${frm}] accounts[${to}] 0,${sender},,false\ntransferFrom,transferFrom,instance,accounts[${frm}] accounts[${to}] 0,${sender},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    })
  }

})
helper.runTests(transactionCounts, transactionFolders, testFolder, contractName, min_version);
