const {
  BN,
  constants,
  expectEvent,
  expectRevert,
  time,
} = require('@openzeppelin/test-helpers');

const helper = require('./helper_functions');
const fs = require('fs');
const path = require('path');

const lowerBoundId = 1;
const upperBoundId = 10;
const lowerBoundAmount = 10;
const upperBoundAmount = 100;

const testFolder = path.join(__dirname, '../tracefiles_long/erc1155');
const testPath = path.join(testFolder, '/setup.txt');
const setup = fs.readFileSync(testPath, 'utf-8');
let contractName;
let deployAccountCount = 10;
setup.split(/\r?\n/).some(line => {
  const lineArr = line.split(',');
  if (lineArr[0] == 'n') {
    contractName = lineArr[1];
    return true;
  }
  if (lineArr[0] == 'a') {
    deployAccountCount = +lineArr[1];
  }
});

const transactionFolders = fs.readdirSync(testFolder, { withFileTypes: true })
  .filter(dirent => dirent.isDirectory())
  .map(dirent => dirent.name);
const transactionCounts = transactionFolders.length;
let transactionName;
let transactionFolderPath;
let setupPath;
let transactionCount = 1;
let tracefileCount = 0;

helper.range(transactionCounts).forEach(l => {
  transactionName = transactionFolders[l];
  transactionFolderPath = path.join(testFolder, `/${transactionName}`);
  setupPath = path.join(transactionFolderPath, '/setup.txt');
  if (fs.existsSync(setupPath)) {
    const setupFS = fs.readFileSync(setupPath, 'utf-8');
    const setupLines = setupFS.split(/\r?\n/);
    let i = 0;
    while (i < setupLines.length) {
      const sl = setupLines[i];
      if (sl.startsWith('nt')) {
        transactionCount = +sl.split(',')[1];
      }
      i++;
    }
  }

  if (transactionName == 'setApprovalForAll') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const holderIndex = helper.random(1, deployAccountCount);
      let operatorIndex = helper.random(1, deployAccountCount);
      if (operatorIndex == holderIndex) operatorIndex = (operatorIndex + 1) % deployAccountCount || 1;
      const text = `setApprovalForAll,constructor,,,0,,false\nsetApprovalForAll,setApprovalForAll,instance,accounts[${operatorIndex}] true,${holderIndex},,false\nsetApprovalForAll,setApprovalForAll,instance,accounts[${operatorIndex}] false,${holderIndex},,true\n`;
      if (!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    });
  }

  if (transactionName == 'mint') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const holderIndex = helper.random(1, deployAccountCount);
      const id = helper.random(lowerBoundId, upperBoundId + 1);
      const amount1 = helper.random(lowerBoundAmount, upperBoundAmount + 1);
      const amount2 = helper.random(lowerBoundAmount, upperBoundAmount + 1);
      const text = `mint,constructor,,,0,,false\nmint,mint,instance,accounts[${holderIndex}] ${id} ${amount1},0,,false\nmint,mint,instance,accounts[${holderIndex}] ${id} ${amount2},0,,true\n`;
      if (!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    });
  }

  if (transactionName == 'burn') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const holderIndex = helper.random(1, deployAccountCount);
      const id = helper.random(lowerBoundId, upperBoundId + 1);
      const minted = helper.random(lowerBoundAmount + 20, upperBoundAmount + 80);
      const burn1 = helper.random(1, Math.max(2, Math.floor(minted / 3)));
      const burn2 = helper.random(1, Math.max(2, Math.floor(minted / 3)));
      const text = `burn,constructor,,,0,,false\nburn,mint,instance,accounts[${holderIndex}] ${id} ${minted},0,,false\nburn,burn,instance,accounts[${holderIndex}] ${id} ${burn1},${holderIndex},,false\nburn,burn,instance,accounts[${holderIndex}] ${id} ${burn2},${holderIndex},,true\n`;
      if (!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    });
  }

  if (transactionName == 'transferFrom') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const holderIndex = helper.random(1, deployAccountCount);
      let recipientIndex = helper.random(1, deployAccountCount);
      while (recipientIndex == holderIndex) {
        recipientIndex = helper.random(1, deployAccountCount);
      }
      let operatorIndex = helper.random(1, deployAccountCount);
      while (operatorIndex == holderIndex || operatorIndex == recipientIndex) {
        operatorIndex = helper.random(1, deployAccountCount);
      }
      const id = helper.random(lowerBoundId, upperBoundId + 1);
      const minted = helper.random(lowerBoundAmount + 20, upperBoundAmount + 80);
      const transfer1 = helper.random(1, Math.max(2, Math.floor(minted / 3)));
      const transfer2 = helper.random(1, Math.max(2, Math.floor(minted / 3)));
      const text = `transferFrom,constructor,,,0,,false\ntransferFrom,mint,instance,accounts[${holderIndex}] ${id} ${minted},0,,false\ntransferFrom,setApprovalForAll,instance,accounts[${operatorIndex}] true,${holderIndex},,false\ntransferFrom,transferFrom,instance,accounts[${holderIndex}] accounts[${recipientIndex}] ${id} ${transfer1},${operatorIndex},,false\ntransferFrom,transferFrom,instance,accounts[${holderIndex}] accounts[${recipientIndex}] ${id} ${transfer2},${operatorIndex},,true\n`;
      if (!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    });
  }
});

helper.runTests(transactionCounts, transactionFolders, testFolder, contractName, min_version);
