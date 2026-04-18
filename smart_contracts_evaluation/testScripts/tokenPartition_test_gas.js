const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert,
  time, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

const helper = require("./helper_functions");
const fs = require('fs');
const path = require('path');

const lowerBoundPartition = 1;
const upperBoundPartition = 10;
const lowerBoundAmount = 10;
const upperBoundAmount = 100;


const testFolder = path.join(__dirname, `../testTraces/tokenPartition`);
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
  // get the setup file
  transactionFolderPath = path.join(testFolder, `/${transactionName}`);
  setupPath = path.join(transactionFolderPath, '/setup.txt');
  // get the transaction count in setup.txt for each transaction
  if (fs.existsSync(setupPath)) {
    console.log('setup exists');
    const setupFS = fs.readFileSync(setupPath, 'utf-8');
    const setupLines = setupFS.split(/\r?\n/);
    let i = 0;
    while(i < setupLines.length) {
      let sl = setupLines[i];
      if (sl.startsWith('nt')) {
        transactionCount = +sl.split(',')[1];
      }
      i++;
    }
  }


  if(transactionName == 'issueByPartition') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let ownerIndex = helper.random(0, deployAccountCount);
      let partitionIndex_1 = helper.random(0, deployAccountCount);
      let partitionAmount_1 = helper.random(lowerBoundPartition, upperBoundPartition+1);
      let amount_1 = helper.random(lowerBoundAmount, upperBoundAmount+1);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != partitionIndex_1) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let partitionIndex_2 = arrayRandom[helper.random(0, arrayRandomLen)];
      let partitionAmount_2 = helper.random(lowerBoundPartition, upperBoundPartition+1);
      let amount_2 = helper.random(lowerBoundAmount, upperBoundAmount+1);
      let text = `issueByPartition,constructor,,,${ownerIndex},,false\nissueByPartition,issueByPartition,instance,accounts[${partitionIndex_1}] ${partitionAmount_1} ${amount_1},${ownerIndex},,false\nissueByPartition,issueByPartition,instance,accounts[${partitionIndex_2}] ${partitionAmount_2} ${amount_2},${ownerIndex},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    }) 
  }

  if(transactionName == 'redeemByPartition') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let ownerIndex = helper.random(0, deployAccountCount);
      let partitionIndex_1 = helper.random(0, deployAccountCount);
      let partitionAmount_1 = helper.random(lowerBoundPartition, upperBoundPartition+1);
      let amount_1 = helper.random(lowerBoundAmount, upperBoundAmount+1);
      let redeemAmount_1 = helper.random(lowerBoundAmount, amount_1+1);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != partitionIndex_1) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let partitionIndex_2 = arrayRandom[helper.random(0, arrayRandomLen)];
      let partitionAmount_2 = helper.random(lowerBoundPartition, upperBoundPartition+1);
      let amount_2 = helper.random(lowerBoundAmount, upperBoundAmount+1);
      let redeemAmount_2 = helper.random(lowerBoundAmount, amount_2+1);
      let text = `redeemByPartition,constructor,,,${ownerIndex},,false\nredeemByPartition,issueByPartition,instance,accounts[${partitionIndex_1}] ${partitionAmount_1} ${amount_1},${ownerIndex},,false\nredeemByPartition,redeemByPartition,instance,accounts[${partitionIndex_1}] ${partitionAmount_1} ${redeemAmount_1},${ownerIndex},,false\nredeemByPartition,issueByPartition,instance,accounts[${partitionIndex_2}] ${partitionAmount_2} ${amount_2},${ownerIndex},,false\nredeemByPartition,redeemByPartition,instance,accounts[${partitionIndex_2}] ${partitionAmount_2} ${redeemAmount_2},${ownerIndex},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    }) 
  }


if(transactionName == 'transferByPartition') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let ownerIndex = helper.random(0, deployAccountCount);
      let partitionAmount = helper.random(lowerBoundPartition, upperBoundPartition+1);
      let partitionIndex_from = helper.random(0, deployAccountCount);
      let amount_from = helper.random(lowerBoundAmount, upperBoundAmount+1);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != partitionIndex_from) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let partitionIndex_to = arrayRandom[helper.random(0, arrayRandomLen)];
      let amount_to = helper.random(lowerBoundAmount, upperBoundAmount+1);
      let transferAmount_1 = helper.random(lowerBoundAmount, amount_from);
      let transferAmount_2 = helper.random(1, amount_from - transferAmount_1);
      let text = `transferByPartition,constructor,,,${ownerIndex},,false\ntransferByPartition,issueByPartition,instance,accounts[${partitionIndex_from}] ${partitionAmount} ${amount_from},${ownerIndex},,false\ntransferByPartition,issueByPartition,instance,accounts[${partitionIndex_to}] ${partitionAmount} ${amount_to},${ownerIndex},,false\ntransferByPartition,transferByPartition,instance,accounts[${partitionIndex_from}] accounts[${partitionIndex_to}] ${partitionAmount} ${transferAmount_1},${ownerIndex},,false\ntransferByPartition,transferByPartition,instance,accounts[${partitionIndex_from}] accounts[${partitionIndex_to}] ${partitionAmount} ${transferAmount_2},${ownerIndex},,true\n`;
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
helper.runTests(transactionCounts, transactionFolders, testFolder, contractName, min_version)
