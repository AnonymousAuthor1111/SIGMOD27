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

const lowerBoundTokenId = 1;
const upperBoundTokenId = 1000;

function randomAccountIndex() {
  return helper.random(1, deployAccountCount);
}

function randomDistinctAccountIndex(excluded) {
  let idx = randomAccountIndex();
  while (excluded.includes(idx)) {
    idx = randomAccountIndex();
  }
  return idx;
}

const testFolder = path.join(__dirname, '../tracefiles_long/erc721');
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

  if (transactionName == 'mint') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const holderIndex = randomAccountIndex();
      const tokenId1 = testFileIndex * 2 + helper.random(lowerBoundTokenId, upperBoundTokenId);
      const tokenId2 = tokenId1 + upperBoundTokenId;
      const text = `mint,constructor,,,0,,false\nmint,mint,instance,accounts[${holderIndex}] ${tokenId1},0,,false\nmint,mint,instance,accounts[${holderIndex}] ${tokenId2},0,,true\n`;
      if (!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    });
  }

  if (transactionName == 'approve') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const holderIndex = randomAccountIndex();
      const approvedIndex1 = randomDistinctAccountIndex([holderIndex]);
      const approvedIndex2 = randomDistinctAccountIndex([holderIndex, approvedIndex1]);
      const tokenId = testFileIndex + helper.random(lowerBoundTokenId, upperBoundTokenId);
      const text = `approve,constructor,,,0,,false\napprove,mint,instance,accounts[${holderIndex}] ${tokenId},0,,false\napprove,approve,instance,accounts[${approvedIndex1}] ${tokenId},${holderIndex},,false\napprove,approve,instance,accounts[${approvedIndex2}] ${tokenId},${holderIndex},,true\n`;
      if (!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    });
  }

  if (transactionName == 'setApprovalForAll') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const holderIndex = randomAccountIndex();
      const operatorIndex = randomDistinctAccountIndex([holderIndex]);
      const text = `setApprovalForAll,constructor,,,0,,false\nsetApprovalForAll,setApprovalForAll,instance,accounts[${operatorIndex}] true,${holderIndex},,false\nsetApprovalForAll,setApprovalForAll,instance,accounts[${operatorIndex}] false,${holderIndex},,true\n`;
      if (!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    });
  }

  if (transactionName == 'transferFrom') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const holderIndex = randomAccountIndex();
      const operatorIndex = randomDistinctAccountIndex([holderIndex]);
      const recipientIndex1 = randomDistinctAccountIndex([holderIndex, operatorIndex]);
      const recipientIndex2 = randomDistinctAccountIndex([holderIndex, operatorIndex, recipientIndex1]);
      const tokenId = testFileIndex + helper.random(lowerBoundTokenId, upperBoundTokenId);
      const text = `transferFrom,constructor,,,0,,false\ntransferFrom,mint,instance,accounts[${holderIndex}] ${tokenId},0,,false\ntransferFrom,setApprovalForAll,instance,accounts[${operatorIndex}] true,${holderIndex},,false\ntransferFrom,transferFrom,instance,accounts[${holderIndex}] accounts[${recipientIndex1}] ${tokenId},${operatorIndex},,false\ntransferFrom,transferFrom,instance,accounts[${recipientIndex1}] accounts[${recipientIndex2}] ${tokenId},${recipientIndex1},,true\n`;
      if (!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    });
  }

  if (transactionName == 'burn') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const holderIndex = randomAccountIndex();
      const approvedIndex = randomDistinctAccountIndex([holderIndex]);
      const tokenId1 = testFileIndex * 2 + helper.random(lowerBoundTokenId, upperBoundTokenId);
      const tokenId2 = tokenId1 + upperBoundTokenId;
      const text = `burn,constructor,,,0,,false\nburn,mint,instance,accounts[${holderIndex}] ${tokenId1},0,,false\nburn,mint,instance,accounts[${holderIndex}] ${tokenId2},0,,false\nburn,approve,instance,accounts[${approvedIndex}] ${tokenId2},${holderIndex},,false\nburn,burn,instance,${tokenId1},${holderIndex},,false\nburn,burn,instance,${tokenId2},${approvedIndex},,true\n`;
      if (!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    });
  }
});

helper.runTests(transactionCounts, transactionFolders, testFolder, contractName, min_version);
