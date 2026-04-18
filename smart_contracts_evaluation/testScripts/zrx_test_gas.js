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

const testFolder = path.join(__dirname, `../testTraces/zrx`);
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
    // approve: always works (IncreaseAllowance or DecreaseAllowance)
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
      let amt1 = helper.random(approveLowerBound, approveUpperBound + 1);
      let amt2 = amt1 + helper.random(1, approveUpperBound + 1);
      let text = `approve,constructor,,,${deployer},,false\napprove,approve,instance,accounts[${spender}] ${amt1},${caller},,false\napprove,approve,instance,accounts[${spender}] ${amt2},${caller},,true\n`;
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
    // transfer: only works with amount=0 (totalMint not updated, no balance)
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
      let text = `transfer,constructor,,,${deployer},,false\ntransfer,transfer,instance,accounts[${to}] 0,${sender},,false\ntransfer,transfer,instance,accounts[${to}] 0,${sender},,true\n`;
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
    // transferFrom: only works with amount=0
    // Both TransferFromLimited (r2) and TransferFrom (r9) succeed with n=0
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let deployer = helper.random(0, deployAccountCount);
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
      let text = `transferFrom,constructor,,,${deployer},,false\ntransferFrom,transferFrom,instance,accounts[${frm}] accounts[${to}] 0,${sender},,false\ntransferFrom,transferFrom,instance,accounts[${frm}] accounts[${to}] 0,${sender},,true\n`;
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
