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

const testFolder = path.join(__dirname, '../tracefiles_long/pepe');
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
      const recipientIndex = helper.random(1, deployAccountCount);
      const amount = helper.random(1, Math.max(2, Math.floor(totalSupply / 2)));
      const text = `transfer,constructor,,${totalSupply},0,,false\ntransfer,transfer,instance,accounts[${recipientIndex}] ${amount},0,,true\n`;
      if (!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    });
  }

  if (transactionName == 'approve') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const totalSupply = helper.random(lowerBound, upperBound + 1);
      const spenderIndex = helper.random(1, deployAccountCount);
      const amount = helper.random(1, Math.max(2, Math.floor(totalSupply / 2)));
      const text = `approve,constructor,,${totalSupply},0,,false\napprove,approve,instance,accounts[${spenderIndex}] ${amount},0,,true\n`;
      if (!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    });
  }

  if (transactionName == 'transferFrom') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const totalSupply = helper.random(lowerBound, upperBound + 1);
      const spenderIndex = helper.random(1, deployAccountCount);
      let recipientIndex = helper.random(1, deployAccountCount);
      if (recipientIndex == spenderIndex) {
        recipientIndex = (recipientIndex + 1) % deployAccountCount;
        if (recipientIndex == 0) recipientIndex = 1;
      }
      const approvedAmount = helper.random(2, Math.max(3, totalSupply));
      const transferAmount = helper.random(1, Math.max(2, Math.floor(approvedAmount / 2)));
      const text = `transferFrom,constructor,,${totalSupply},0,,false\ntransferFrom,approve,instance,accounts[${spenderIndex}] ${approvedAmount},0,,false\ntransferFrom,transferFrom,instance,accounts[0] accounts[${recipientIndex}] ${transferAmount},${spenderIndex},,true\n`;
      if (!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    });
  }

  if (transactionName == 'increaseAllowance') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const totalSupply = helper.random(lowerBound, upperBound + 1);
      const spenderIndex = helper.random(1, deployAccountCount);
      const amount = helper.random(1, Math.max(2, Math.floor(totalSupply / 2)));
      const text = `increaseAllowance,constructor,,${totalSupply},0,,false\nincreaseAllowance,increaseAllowance,instance,accounts[${spenderIndex}] ${amount},0,,true\n`;
      if (!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    });
  }

  if (transactionName == 'decreaseAllowance') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const totalSupply = helper.random(lowerBound, upperBound + 1);
      const spenderIndex = helper.random(1, deployAccountCount);
      const approveAmount = helper.random(2, Math.max(3, totalSupply));
      const decreaseAmount = helper.random(1, Math.max(2, Math.floor(approveAmount / 2)));
      const text = `decreaseAllowance,constructor,,${totalSupply},0,,false\ndecreaseAllowance,approve,instance,accounts[${spenderIndex}] ${approveAmount},0,,false\ndecreaseAllowance,decreaseAllowance,instance,accounts[${spenderIndex}] ${decreaseAmount},0,,true\n`;
      if (!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    });
  }

  if (transactionName == 'burn') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const totalSupply = helper.random(lowerBound, upperBound + 1);
      const burnAmount = helper.random(1, Math.max(2, Math.floor(totalSupply / 2)));
      const text = `burn,constructor,,${totalSupply},0,,false\nburn,burn,instance,${burnAmount},0,,true\n`;
      if (!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    });
  }

  if (transactionName == 'blacklist') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const totalSupply = helper.random(lowerBound, upperBound + 1);
      const targetIndex = helper.random(1, deployAccountCount);
      const text = `blacklist,constructor,,${totalSupply},0,,false\nblacklist,blacklist,instance,accounts[${targetIndex}] 1,0,,true\n`;
      if (!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    });
  }

  if (transactionName == 'setRule') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const totalSupply = helper.random(lowerBound, upperBound + 1);
      const pairIndex = helper.random(1, deployAccountCount);
      const maxHolding = helper.random(Math.max(20, lowerBound), upperBound + 20);
      const minHolding = helper.random(1, Math.max(2, Math.floor(maxHolding / 4)));
      const text = `setRule,constructor,,${totalSupply},0,,false\nsetRule,setRule,instance,1 accounts[${pairIndex}] ${maxHolding} ${minHolding},0,,true\n`;
      if (!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    });
  }
});
helper.runTests(transactionCounts, transactionFolders, testFolder, contractName, min_version);
