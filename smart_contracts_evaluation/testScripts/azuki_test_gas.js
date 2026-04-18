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

const maxBatchSize = 5;
const collectionSize = 10000;
const amountForAuctionAndDev = 5000;
const amountForDevs = 200;
const mintlistPrice = 100;
const publicPrice = 150;
const publicSaleKey = 777;
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

const testFolder = path.join(__dirname, '../tracefiles_long/azuki');
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

function ensureFile(dir, fileName, text) {
  const file = path.join(dir, fileName);
  if (!fs.existsSync(file)) {
    fs.writeFileSync(file, text);
  }
}

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

  if (transactionName == 'setAuctionSaleStartTime') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const ts1 = testFileIndex + 1;
      const ts2 = testFileIndex + 100;
      const text = `setAuctionSaleStartTime,constructor,,${maxBatchSize} ${collectionSize} ${amountForAuctionAndDev} ${amountForDevs},0,,false\nsetAuctionSaleStartTime,setAuctionSaleStartTime,instance,${ts1},0,,false\nsetAuctionSaleStartTime,setAuctionSaleStartTime,instance,${ts2},0,,true\n`;
      ensureFile(transactionFolderPath, fileName, text);
    });
  }

  if (transactionName == 'setPublicSaleKey') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const key1 = publicSaleKey + testFileIndex;
      const key2 = publicSaleKey + 100 + testFileIndex;
      const text = `setPublicSaleKey,constructor,,${maxBatchSize} ${collectionSize} ${amountForAuctionAndDev} ${amountForDevs},0,,false\nsetPublicSaleKey,setPublicSaleKey,instance,${key1},0,,false\nsetPublicSaleKey,setPublicSaleKey,instance,${key2},0,,true\n`;
      ensureFile(transactionFolderPath, fileName, text);
    });
  }

  if (transactionName == 'seedAllowlist') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const account1 = (testFileIndex % (deployAccountCount - 1)) + 1;
      const account2 = ((testFileIndex + 1) % (deployAccountCount - 1)) + 1;
      const slots1 = (testFileIndex % 3) + 1;
      const slots2 = ((testFileIndex + 1) % 3) + 1;
      const text = `seedAllowlist,constructor,,${maxBatchSize} ${collectionSize} ${amountForAuctionAndDev} ${amountForDevs},0,,false\nseedAllowlist,seedAllowlist,instance,accounts[${account1}] ${slots1},0,,false\nseedAllowlist,seedAllowlist,instance,accounts[${account2}] ${slots2},0,,true\n`;
      ensureFile(transactionFolderPath, fileName, text);
    });
  }

  if (transactionName == 'endAuctionAndSetupNonAuctionSaleInfo') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const mp1 = mintlistPrice + testFileIndex;
      const pp1 = publicPrice + testFileIndex;
      const pst1 = 10 + testFileIndex;
      const mp2 = mintlistPrice + 50 + testFileIndex;
      const pp2 = publicPrice + 50 + testFileIndex;
      const pst2 = 100 + testFileIndex;
      const text = `endAuctionAndSetupNonAuctionSaleInfo,constructor,,${maxBatchSize} ${collectionSize} ${amountForAuctionAndDev} ${amountForDevs},0,,false\nendAuctionAndSetupNonAuctionSaleInfo,endAuctionAndSetupNonAuctionSaleInfo,instance,${mp1} ${pp1} ${pst1},0,,false\nendAuctionAndSetupNonAuctionSaleInfo,endAuctionAndSetupNonAuctionSaleInfo,instance,${mp2} ${pp2} ${pst2},0,,true\n`;
      ensureFile(transactionFolderPath, fileName, text);
    });
  }

  if (transactionName == 'auctionMint') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const buyer = (testFileIndex % (deployAccountCount - 1)) + 1;
      const q1 = (testFileIndex % 2) + 1;
      const q2 = ((testFileIndex + 1) % 2) + 1;
      const text = `auctionMint,constructor,,${maxBatchSize} ${collectionSize} ${amountForAuctionAndDev} ${amountForDevs},0,,false\nauctionMint,setAuctionSaleStartTime,instance,1,0,,false\nauctionMint,auctionMint,instance,${q1},${buyer},,false\nauctionMint,auctionMint,instance,${q2},${buyer},,true\n`;
      ensureFile(transactionFolderPath, fileName, text);
    });
  }

  if (transactionName == 'allowlistMint') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const buyer = (testFileIndex % (deployAccountCount - 1)) + 1;
      const slots = 2;
      const text = `allowlistMint,constructor,,${maxBatchSize} ${collectionSize} ${amountForAuctionAndDev} ${amountForDevs},0,,false\nallowlistMint,endAuctionAndSetupNonAuctionSaleInfo,instance,${mintlistPrice} ${publicPrice} 10,0,,false\nallowlistMint,seedAllowlist,instance,accounts[${buyer}] ${slots},0,,false\nallowlistMint,allowlistMint,instance,,${buyer},,false\nallowlistMint,allowlistMint,instance,,${buyer},,true\n`;
      ensureFile(transactionFolderPath, fileName, text);
    });
  }

  if (transactionName == 'publicSaleMint') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const buyer = (testFileIndex % (deployAccountCount - 1)) + 1;
      const q1 = (testFileIndex % 2) + 1;
      const q2 = ((testFileIndex + 1) % 2) + 1;
      const text = `publicSaleMint,constructor,,${maxBatchSize} ${collectionSize} ${amountForAuctionAndDev} ${amountForDevs},0,,false\npublicSaleMint,endAuctionAndSetupNonAuctionSaleInfo,instance,${mintlistPrice} ${publicPrice} 10,0,,false\npublicSaleMint,setPublicSaleKey,instance,${publicSaleKey},0,,false\npublicSaleMint,publicSaleMint,instance,${q1} ${publicSaleKey},${buyer},,false\npublicSaleMint,publicSaleMint,instance,${q2} ${publicSaleKey},${buyer},,true\n`;
      ensureFile(transactionFolderPath, fileName, text);
    });
  }

  if (transactionName == 'devMint') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const q1 = (testFileIndex % 2) + 1;
      const q2 = ((testFileIndex + 1) % 2) + 1;
      const text = `devMint,constructor,,${maxBatchSize} ${collectionSize} ${amountForAuctionAndDev} ${amountForDevs},0,,false\ndevMint,devMint,instance,${q1},0,,false\ndevMint,devMint,instance,${q2},0,,true\n`;
      ensureFile(transactionFolderPath, fileName, text);
    });
  }

  if (transactionName == 'mintToken') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const holderIndex = randomAccountIndex();
      const tokenId1 = testFileIndex * 2 + helper.random(lowerBoundTokenId, upperBoundTokenId);
      const tokenId2 = tokenId1 + upperBoundTokenId;
      const text = `mintToken,constructor,,${maxBatchSize} ${collectionSize} ${amountForAuctionAndDev} ${amountForDevs},0,,false\nmintToken,mintToken,instance,accounts[${holderIndex}] ${tokenId1},0,,false\nmintToken,mintToken,instance,accounts[${holderIndex}] ${tokenId2},0,,true\n`;
      ensureFile(transactionFolderPath, fileName, text);
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
      const text = `approve,constructor,,${maxBatchSize} ${collectionSize} ${amountForAuctionAndDev} ${amountForDevs},0,,false\napprove,mintToken,instance,accounts[${holderIndex}] ${tokenId},0,,false\napprove,approve,instance,accounts[${approvedIndex1}] ${tokenId},${holderIndex},,false\napprove,approve,instance,accounts[${approvedIndex2}] ${tokenId},${holderIndex},,true\n`;
      ensureFile(transactionFolderPath, fileName, text);
    });
  }

  if (transactionName == 'setApprovalForAll') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const holderIndex = randomAccountIndex();
      const operatorIndex = randomDistinctAccountIndex([holderIndex]);
      const text = `setApprovalForAll,constructor,,${maxBatchSize} ${collectionSize} ${amountForAuctionAndDev} ${amountForDevs},0,,false\nsetApprovalForAll,setApprovalForAll,instance,accounts[${operatorIndex}] true,${holderIndex},,false\nsetApprovalForAll,setApprovalForAll,instance,accounts[${operatorIndex}] false,${holderIndex},,true\n`;
      ensureFile(transactionFolderPath, fileName, text);
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
      const text = `transferFrom,constructor,,${maxBatchSize} ${collectionSize} ${amountForAuctionAndDev} ${amountForDevs},0,,false\ntransferFrom,mintToken,instance,accounts[${holderIndex}] ${tokenId},0,,false\ntransferFrom,setApprovalForAll,instance,accounts[${operatorIndex}] true,${holderIndex},,false\ntransferFrom,transferFrom,instance,accounts[${holderIndex}] accounts[${recipientIndex1}] ${tokenId},${operatorIndex},,false\ntransferFrom,transferFrom,instance,accounts[${recipientIndex1}] accounts[${recipientIndex2}] ${tokenId},${recipientIndex1},,true\n`;
      ensureFile(transactionFolderPath, fileName, text);
    });
  }
});

helper.runTests(transactionCounts, transactionFolders, testFolder, contractName, min_version);
