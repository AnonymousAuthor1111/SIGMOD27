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

const testFolder = path.join(__dirname, `../testTraces/bat`);
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
const EXCHANGE_RATE = 6400;
const CAP = 1500000000;
const MIN_SUPPLY = 675000000;
// createTokens with v=1 mints 6400 tokens; small enough for multiple calls under cap
const createTokensValue = 1;
// finalize needs totalSupply >= MIN_SUPPLY; v=105469 gives 105469*6400=675001600 >= 675000000
const finalizeCreateValue = 105469;

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

  if(transactionName == 'createTokens') {
    // createTokens: payable, mints msg.value * exchangeRate tokens
    // Constructor: accounts[ethFund] accounts[batFund] 0 99999999999
    // Use v=1 wei so multiple calls fit under cap
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let ethFund = helper.random(0, deployAccountCount);
      let batFund;
      do { batFund = helper.random(0, deployAccountCount); } while(batFund == ethFund);
      let sender;
      do { sender = helper.random(0, deployAccountCount); } while(sender == ethFund || sender == batFund);
      let text = `createTokens,constructor,,accounts[${ethFund}] accounts[${batFund}] 0 99999999999,${ethFund},,false\n`;
      text += `createTokens,createTokens,instance,,${sender},${createTokensValue},,false\n`;
      text += `createTokens,createTokens,instance,,${sender},${createTokensValue},,true\n`;
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
    // transfer: needs balance > 0 via createTokens. n > 0 and n <= balance.
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let ethFund = helper.random(0, deployAccountCount);
      let batFund;
      do { batFund = helper.random(0, deployAccountCount); } while(batFund == ethFund);
      let sender;
      do { sender = helper.random(0, deployAccountCount); } while(sender == ethFund || sender == batFund);
      let arrayRandom = [];
      for (let index = 0; index < deployAccountCount; index++) {
        if(index != sender) arrayRandom.push(index);
      }
      let to = arrayRandom[helper.random(0, arrayRandom.length)];
      // createTokens v=1 gives 6400 tokens
      let amt1 = helper.random(1, 1001);
      let amt2 = helper.random(1, 1001);
      let text = `transfer,constructor,,accounts[${ethFund}] accounts[${batFund}] 0 99999999999,${ethFund},,false\n`;
      text += `transfer,createTokens,instance,,${sender},${createTokensValue},,false\n`;
      text += `transfer,transfer,instance,accounts[${to}] ${amt1},${sender},,false\n`;
      text += `transfer,transfer,instance,accounts[${to}] ${amt2},${sender},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    })
  }

  if(transactionName == 'approve') {
    // approve: always works (increase/decrease allowance)
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let ethFund = helper.random(0, deployAccountCount);
      let batFund;
      do { batFund = helper.random(0, deployAccountCount); } while(batFund == ethFund);
      let caller = helper.random(0, deployAccountCount);
      let arrayRandom = [];
      for (let index = 0; index < deployAccountCount; index++) {
        if(index != caller) arrayRandom.push(index);
      }
      let spender = arrayRandom[helper.random(0, arrayRandom.length)];
      let amt1 = helper.random(approveLowerBound, approveUpperBound + 1);
      let amt2 = amt1 + helper.random(1, approveUpperBound + 1);
      let text = `approve,constructor,,accounts[${ethFund}] accounts[${batFund}] 0 99999999999,${ethFund},,false\n`;
      text += `approve,approve,instance,accounts[${spender}] ${amt1},${caller},,false\n`;
      text += `approve,approve,instance,accounts[${spender}] ${amt2},${caller},,true\n`;
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
    // transferFrom: needs balance (createTokens) + allowance (approve), n > 0
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let ethFund = helper.random(0, deployAccountCount);
      let batFund;
      do { batFund = helper.random(0, deployAccountCount); } while(batFund == ethFund);
      let owner;
      do { owner = helper.random(0, deployAccountCount); } while(owner == ethFund || owner == batFund);
      let spender;
      do { spender = helper.random(0, deployAccountCount); } while(spender == owner);
      let arrayRandom = [];
      for (let index = 0; index < deployAccountCount; index++) {
        if(index != owner && index != spender) arrayRandom.push(index);
      }
      let to = arrayRandom[helper.random(0, arrayRandom.length)];
      let approveAmt = helper.random(2000, 5001);
      let tfAmt1 = helper.random(1, 501);
      let tfAmt2 = helper.random(1, 501);
      let text = `transferFrom,constructor,,accounts[${ethFund}] accounts[${batFund}] 0 99999999999,${ethFund},,false\n`;
      text += `transferFrom,createTokens,instance,,${owner},${createTokensValue},,false\n`;
      text += `transferFrom,approve,instance,accounts[${spender}] ${approveAmt},${owner},,false\n`;
      text += `transferFrom,transferFrom,instance,accounts[${owner}] accounts[${to}] ${tfAmt1},${spender},,false\n`;
      text += `transferFrom,transferFrom,instance,accounts[${owner}] accounts[${to}] ${tfAmt2},${spender},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    })
  }

  if(transactionName == 'finalize') {
    // finalize: one-shot. sender == ethFundDeposit, isFinalized == false, totalSupply >= min
    // createTokens with v=105469 gives 675001600 tokens >= 675000000 min
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let ethFund = helper.random(0, deployAccountCount);
      let batFund;
      do { batFund = helper.random(0, deployAccountCount); } while(batFund == ethFund);
      let funder;
      do { funder = helper.random(0, deployAccountCount); } while(funder == ethFund || funder == batFund);
      let text = `finalize,constructor,,accounts[${ethFund}] accounts[${batFund}] 0 99999999999,${ethFund},,false\n`;
      text += `finalize,createTokens,instance,,${funder},${finalizeCreateValue},,false\n`;
      text += `finalize,finalize,instance,,${ethFund},,true\n`;
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
