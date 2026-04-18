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

const testFolder = path.join(__dirname, `../testTraces/weth`);
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

const transactionFolders = fs.readdirSync(testFolder, {withFileTypes: true})
  .filter(dirent => dirent.isDirectory())
  .map(dirent => dirent.name);
const transactionCounts = transactionFolders.length;
var transactionName;
var transactionFolderPath;
var setupPath;
var transactionCount = 1;
var tracefileCount = 0;

const DEPOSIT_FUND = 10000;
const APPROVE_AMT = 8000;

helper.range(transactionCounts).forEach(l => {
  transactionName = transactionFolders[l];
  transactionFolderPath = path.join(testFolder, `/${transactionName}`);
  setupPath = path.join(transactionFolderPath, '/setup.txt');
  if (fs.existsSync(setupPath)) {
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

  // Constructor: no args. maxUint sentinel set.

  if(transactionName == 'deposit') {
    // payable, no preconditions. mints balance = msg.value.
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let deployer = helper.random(0, deployAccountCount);
      let sender = helper.random(0, deployAccountCount);
      let val1 = helper.random(100, 1001);
      let val2 = helper.random(100, 1001);
      let text = `deposit,constructor,,,${deployer},,false\n`;
      text += `deposit,deposit,instance,,${sender},${val1},false\n`;
      text += `deposit,deposit,instance,,${sender},${val2},true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    })
  }

  if(transactionName == 'withdraw') {
    // Needs balanceOf[sender] >= wad. Deposit first.
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let deployer = helper.random(0, deployAccountCount);
      let sender = helper.random(0, deployAccountCount);
      let w1 = helper.random(100, 2001);
      let w2 = helper.random(100, 2001);
      let text = `withdraw,constructor,,,${deployer},,false\n`;
      text += `withdraw,deposit,instance,,${sender},${DEPOSIT_FUND},,false\n`;
      text += `withdraw,withdraw,instance,${w1},${sender},,false\n`;
      text += `withdraw,withdraw,instance,${w2},${sender},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    })
  }

  if(transactionName == 'transfer') {
    // Needs balanceOf[sender] >= n. Deposit first.
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let deployer = helper.random(0, deployAccountCount);
      let sender = helper.random(0, deployAccountCount);
      let arrayRandom = [];
      for (let index = 0; index < deployAccountCount; index++) {
        if(index != sender) arrayRandom.push(index);
      }
      let to = arrayRandom[helper.random(0, arrayRandom.length)];
      let amt1 = helper.random(100, 2001);
      let amt2 = helper.random(100, 2001);
      let text = `transfer,constructor,,,${deployer},,false\n`;
      text += `transfer,deposit,instance,,${sender},${DEPOSIT_FUND},,false\n`;
      text += `transfer,transfer,instance,accounts[${to}] ${amt1},${sender},,false\n`;
      text += `transfer,transfer,instance,accounts[${to}] ${amt2},${sender},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    })
  }

  if(transactionName == 'transferFrom') {
    // owner != spender case: needs balance (deposit) + allowance (approve).
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let deployer = helper.random(0, deployAccountCount);
      let owner = helper.random(0, deployAccountCount);
      let spender;
      do { spender = helper.random(0, deployAccountCount); } while(spender == owner);
      let arrayRandom = [];
      for (let index = 0; index < deployAccountCount; index++) {
        if(index != owner && index != spender) arrayRandom.push(index);
      }
      let to = arrayRandom[helper.random(0, arrayRandom.length)];
      let tf1 = helper.random(100, 1001);
      let tf2 = helper.random(100, 1001);
      let text = `transferFrom,constructor,,,${deployer},,false\n`;
      text += `transferFrom,deposit,instance,,${owner},${DEPOSIT_FUND},,false\n`;
      text += `transferFrom,approve,instance,accounts[${spender}] ${APPROVE_AMT},${owner},,false\n`;
      text += `transferFrom,transferFrom,instance,accounts[${owner}] accounts[${to}] ${tf1},${spender},,false\n`;
      text += `transferFrom,transferFrom,instance,accounts[${owner}] accounts[${to}] ${tf2},${spender},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    })
  }

  if(transactionName == 'approve') {
    // Always works. IncreaseAllowance or DecreaseAllowance.
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let deployer = helper.random(0, deployAccountCount);
      let caller = helper.random(0, deployAccountCount);
      let arrayRandom = [];
      for (let index = 0; index < deployAccountCount; index++) {
        if(index != caller) arrayRandom.push(index);
      }
      let spender = arrayRandom[helper.random(0, arrayRandom.length)];
      let amt1 = helper.random(10, 501);
      let amt2 = amt1 + helper.random(1, 501);
      let text = `approve,constructor,,,${deployer},,false\n`;
      text += `approve,approve,instance,accounts[${spender}] ${amt1},${caller},,false\n`;
      text += `approve,approve,instance,accounts[${spender}] ${amt2},${caller},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    })
  }

})
helper.runTests(transactionCounts, transactionFolders, testFolder, contractName, min_version);
