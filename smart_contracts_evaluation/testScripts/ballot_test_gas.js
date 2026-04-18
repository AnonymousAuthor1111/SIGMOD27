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
const numProposals = 3;

const testFolder = path.join(__dirname, `../testTraces/ballot`);
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

  // Generate vote traces: chairperson gives right to random voters, then each voter votes for a random proposal
  if(transactionName == 'vote') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let numVoters = helper.random(3, 7); // 3 to 6 voters
      let voters = [];
      while(voters.length < numVoters) {
        let v = helper.random(1, deployAccountCount); // avoid 0 (chairperson)
        if(!voters.includes(v)) voters.push(v);
      }
      let proposal = helper.random(1, numProposals + 1);
      // constructor: chairperson = accounts[0]
      let text = `vote,constructor,,${numProposals},0,,false\n`;
      // give right to vote
      voters.forEach(v => {
        text += `vote,giveRightToVote,instance,accounts[${v}],0,,false\n`;
      });
      // each voter votes for the same proposal (target transaction)
      voters.forEach(v => {
        text += `vote,vote,instance,${proposal},${v},,true\n`;
      });
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    })
  }

  // Generate delegate traces: chairperson gives right, then a voter delegates to another voter
  if(transactionName == 'delegate') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let numVoters = helper.random(3, 7);
      let voters = [];
      while(voters.length < numVoters) {
        let v = helper.random(1, deployAccountCount);
        if(!voters.includes(v)) voters.push(v);
      }
      // constructor
      let text = `delegate,constructor,,${numProposals},0,,false\n`;
      // give right to vote
      voters.forEach(v => {
        text += `delegate,giveRightToVote,instance,accounts[${v}],0,,false\n`;
      });
      // delegate: first voter delegates to second voter (target transaction)
      text += `delegate,delegate,instance,accounts[${voters[1]}],${voters[0]},,true\n`;
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
