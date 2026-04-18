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

const testFolder = path.join(__dirname, '../tracefiles_long/dai');
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

  if (transactionName == 'rely') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const guy1 = helper.random(1, deployAccountCount);
      let guy2 = helper.random(1, deployAccountCount);
      if (guy2 == guy1) guy2 = (guy2 + 1) % deployAccountCount || 1;
      const text = `rely,constructor,,1,0,,false\nrely,rely,instance,accounts[${guy1}],0,,false\nrely,rely,instance,accounts[${guy2}],0,,true\n`;
      if (!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    });
  }

  if (transactionName == 'deny') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const guy = helper.random(1, deployAccountCount);
      const text = `deny,constructor,,1,0,,false\ndeny,rely,instance,accounts[${guy}],0,,false\ndeny,deny,instance,accounts[${guy}],0,,true\n`;
      if (!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    });
  }

  if (transactionName == 'mint') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const targetIndex = helper.random(1, deployAccountCount);
      const mint1 = helper.random(lowerBound, upperBound + 1);
      const mint2 = helper.random(lowerBound, upperBound + 1);
      const text = `mint,constructor,,1,0,,false\nmint,mint,instance,accounts[${targetIndex}] ${mint1},0,,false\nmint,mint,instance,accounts[${targetIndex}] ${mint2},0,,true\n`;
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
      const mintAmount = helper.random(lowerBound + 10, upperBound + 50);
      const burn1 = helper.random(1, Math.max(2, Math.floor(mintAmount / 3)));
      const burn2 = helper.random(1, Math.max(2, Math.floor(mintAmount / 3)));
      const text = `burn,constructor,,1,0,,false\nburn,mint,instance,accounts[${holderIndex}] ${mintAmount},0,,false\nburn,burn,instance,accounts[${holderIndex}] ${burn1},${holderIndex},,false\nburn,burn,instance,accounts[${holderIndex}] ${burn2},${holderIndex},,true\n`;
      if (!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    });
  }

  if (transactionName == 'approve') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const holderIndex = helper.random(1, deployAccountCount);
      let spenderIndex = helper.random(1, deployAccountCount);
      if (spenderIndex == holderIndex) spenderIndex = (spenderIndex + 1) % deployAccountCount || 1;
      const mintAmount = helper.random(lowerBound + 10, upperBound + 50);
      const approve1 = helper.random(1, Math.max(2, Math.floor(mintAmount / 2)));
      const approve2 = approve1 + helper.random(0, Math.max(1, Math.floor(mintAmount / 3)));
      const text = `approve,constructor,,1,0,,false\napprove,mint,instance,accounts[${holderIndex}] ${mintAmount},0,,false\napprove,approve,instance,accounts[${spenderIndex}] ${approve1},${holderIndex},,false\napprove,approve,instance,accounts[${spenderIndex}] ${approve2},${holderIndex},,true\n`;
      if (!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    });
  }

  if (transactionName == 'transfer') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const holderIndex = helper.random(1, deployAccountCount);
      let recipientIndex = helper.random(1, deployAccountCount);
      if (recipientIndex == holderIndex) recipientIndex = (recipientIndex + 1) % deployAccountCount || 1;
      const mintAmount = helper.random(lowerBound + 10, upperBound + 50);
      const transfer1 = helper.random(1, Math.max(2, Math.floor(mintAmount / 3)));
      const transfer2 = helper.random(1, Math.max(2, Math.floor(mintAmount / 3)));
      const text = `transfer,constructor,,1,0,,false\ntransfer,mint,instance,accounts[${holderIndex}] ${mintAmount},0,,false\ntransfer,transfer,instance,accounts[${recipientIndex}] ${transfer1},${holderIndex},,false\ntransfer,transfer,instance,accounts[${recipientIndex}] ${transfer2},${holderIndex},,true\n`;
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
      let spenderIndex = helper.random(1, deployAccountCount);
      if (spenderIndex == holderIndex) spenderIndex = (spenderIndex + 1) % deployAccountCount || 1;
      let recipientIndex = helper.random(1, deployAccountCount);
      while (recipientIndex == holderIndex || recipientIndex == spenderIndex) {
        recipientIndex = helper.random(1, deployAccountCount);
      }
      const mintAmount = helper.random(lowerBound + 20, upperBound + 80);
      const approveAmount = helper.random(3, mintAmount + 1);
      const transfer1 = helper.random(1, Math.max(2, Math.floor(approveAmount / 3)));
      const transfer2 = helper.random(1, Math.max(2, Math.floor(approveAmount / 3)));
      const text = `transferFrom,constructor,,1,0,,false\ntransferFrom,mint,instance,accounts[${holderIndex}] ${mintAmount},0,,false\ntransferFrom,approve,instance,accounts[${spenderIndex}] ${approveAmount},${holderIndex},,false\ntransferFrom,transferFrom,instance,accounts[${holderIndex}] accounts[${recipientIndex}] ${transfer1},${spenderIndex},,false\ntransferFrom,transferFrom,instance,accounts[${holderIndex}] accounts[${recipientIndex}] ${transfer2},${spenderIndex},,true\n`;
      if (!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    });
  }

  if (transactionName == 'push') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const holderIndex = helper.random(1, deployAccountCount);
      let recipientIndex = helper.random(1, deployAccountCount);
      if (recipientIndex == holderIndex) recipientIndex = (recipientIndex + 1) % deployAccountCount || 1;
      const mintAmount = helper.random(lowerBound + 10, upperBound + 50);
      const push1 = helper.random(1, Math.max(2, Math.floor(mintAmount / 3)));
      const push2 = helper.random(1, Math.max(2, Math.floor(mintAmount / 3)));
      const text = `push,constructor,,1,0,,false\npush,mint,instance,accounts[${holderIndex}] ${mintAmount},0,,false\npush,push,instance,accounts[${recipientIndex}] ${push1},${holderIndex},,false\npush,push,instance,accounts[${recipientIndex}] ${push2},${holderIndex},,true\n`;
      if (!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    });
  }

  if (transactionName == 'pull') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const holderIndex = helper.random(1, deployAccountCount);
      let pullerIndex = helper.random(1, deployAccountCount);
      if (pullerIndex == holderIndex) pullerIndex = (pullerIndex + 1) % deployAccountCount || 1;
      const mintAmount = helper.random(lowerBound + 20, upperBound + 80);
      const approveAmount = helper.random(3, mintAmount + 1);
      const pull1 = helper.random(1, Math.max(2, Math.floor(approveAmount / 3)));
      const pull2 = helper.random(1, Math.max(2, Math.floor(approveAmount / 3)));
      const text = `pull,constructor,,1,0,,false\npull,mint,instance,accounts[${holderIndex}] ${mintAmount},0,,false\npull,approve,instance,accounts[${pullerIndex}] ${approveAmount},${holderIndex},,false\npull,pull,instance,accounts[${holderIndex}] ${pull1},${pullerIndex},,false\npull,pull,instance,accounts[${holderIndex}] ${pull2},${pullerIndex},,true\n`;
      if (!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    });
  }

  if (transactionName == 'move') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const holderIndex = helper.random(1, deployAccountCount);
      let moverIndex = helper.random(1, deployAccountCount);
      if (moverIndex == holderIndex) moverIndex = (moverIndex + 1) % deployAccountCount || 1;
      let recipientIndex = helper.random(1, deployAccountCount);
      while (recipientIndex == holderIndex || recipientIndex == moverIndex) {
        recipientIndex = helper.random(1, deployAccountCount);
      }
      const mintAmount = helper.random(lowerBound + 20, upperBound + 80);
      const approveAmount = helper.random(3, mintAmount + 1);
      const move1 = helper.random(1, Math.max(2, Math.floor(approveAmount / 3)));
      const move2 = helper.random(1, Math.max(2, Math.floor(approveAmount / 3)));
      const text = `move,constructor,,1,0,,false\nmove,mint,instance,accounts[${holderIndex}] ${mintAmount},0,,false\nmove,approve,instance,accounts[${moverIndex}] ${approveAmount},${holderIndex},,false\nmove,move,instance,accounts[${holderIndex}] accounts[${recipientIndex}] ${move1},${moverIndex},,false\nmove,move,instance,accounts[${holderIndex}] accounts[${recipientIndex}] ${move2},${moverIndex},,true\n`;
      if (!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    });
  }
});
helper.runTests(transactionCounts, transactionFolders, testFolder, contractName, min_version);
