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

const lowerBound = 10;
const upperBound = 1000;

const testFolder = path.join(__dirname, '../tracefiles_long/uni');
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

  if (transactionName == 'transfer') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const totalSupply = helper.random(lowerBound, upperBound + 1);
      let recipientIndex = helper.random(1, deployAccountCount);
      const transferAmount = helper.random(1, Math.max(2, Math.floor(totalSupply / 2)));
      const text = `transfer,constructor,,accounts[0] ${totalSupply},0,,false\ntransfer,transfer,instance,accounts[${recipientIndex}] ${transferAmount},0,,true\n`;
      if (!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    });
  }

  if (transactionName == 'delegate') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const totalSupply = helper.random(lowerBound, upperBound + 1);
      const delegateeIndex = helper.random(1, deployAccountCount);
      const text = `delegate,constructor,,accounts[0] ${totalSupply},0,,false\ndelegate,delegate,instance,accounts[${delegateeIndex}],0,,true\n`;
      if (!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    });
  }

  if (transactionName == 'delegateBySig') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const totalSupply = helper.random(lowerBound, upperBound + 1);
      const delegatorIndex = helper.random(1, deployAccountCount);
      let delegateeIndex = helper.random(0, deployAccountCount);
      if (delegateeIndex == delegatorIndex) {
        delegateeIndex = (delegateeIndex + 1) % deployAccountCount;
      }
      const transferAmount = helper.random(1, Math.max(2, Math.floor(totalSupply / 2)));
      const text = `delegateBySig,constructor,,accounts[0] ${totalSupply},0,,false\ndelegateBySig,transfer,instance,accounts[${delegatorIndex}] ${transferAmount},0,,false\ndelegateBySig,delegateBySig,instance,accounts[${delegatorIndex}] accounts[${delegateeIndex}],0,,true\n`;
      if (!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    });
  }
});
helper.runTests(transactionCounts, transactionFolders, testFolder, contractName, min_version);
