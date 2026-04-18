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

const lowerBound = 20;
const upperBound = 200;

const testFolder = path.join(__dirname, '../tracefiles_long/uniswapPair');
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

  if (transactionName == 'initialize') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      let token0Index = helper.random(1, deployAccountCount);
      let token1Index = helper.random(1, deployAccountCount);
      while (token1Index == token0Index) token1Index = helper.random(1, deployAccountCount);
      const text = `initialize,constructor,,,0,,false\ninitialize,initialize,instance,accounts[${token0Index}] accounts[${token1Index}],0,,true\n`;
      if (!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    });
  }

  if (transactionName == 'mint') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      let token0Index = helper.random(1, deployAccountCount);
      let token1Index = helper.random(1, deployAccountCount);
      while (token1Index == token0Index) token1Index = helper.random(1, deployAccountCount);
      const toIndex = helper.random(1, deployAccountCount);
      const amount0 = helper.random(lowerBound, upperBound);
      const amount1 = helper.random(lowerBound, upperBound);
      const text = `mint,constructor,,,0,,false\nmint,initialize,instance,accounts[${token0Index}] accounts[${token1Index}],0,,false\nmint,mint,instance,accounts[${toIndex}] ${amount0} ${amount1},0,,true\n`;
      if (!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    });
  }

  if (transactionName == 'burn') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      let token0Index = helper.random(1, deployAccountCount);
      let token1Index = helper.random(1, deployAccountCount);
      while (token1Index == token0Index) token1Index = helper.random(1, deployAccountCount);
      const lpHolder = helper.random(1, deployAccountCount);
      let toIndex = helper.random(1, deployAccountCount);
      while (toIndex == lpHolder) toIndex = helper.random(1, deployAccountCount);
      const amount0 = helper.random(lowerBound + 20, upperBound + 40);
      const amount1 = helper.random(lowerBound + 20, upperBound + 40);
      const liquidity = Math.min(amount0, amount1) - 1;
      const text = `burn,constructor,,,0,,false\nburn,initialize,instance,accounts[${token0Index}] accounts[${token1Index}],0,,false\nburn,mint,instance,accounts[${lpHolder}] ${amount0} ${amount1},0,,false\nburn,burn,instance,accounts[${toIndex}] ${liquidity},${lpHolder},,true\n`;
      if (!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    });
  }

  if (transactionName == 'swap') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      let token0Index = helper.random(1, deployAccountCount);
      let token1Index = helper.random(1, deployAccountCount);
      while (token1Index == token0Index) token1Index = helper.random(1, deployAccountCount);
      const lpHolder = helper.random(1, deployAccountCount);
      let toIndex = helper.random(1, deployAccountCount);
      while (toIndex == lpHolder) toIndex = helper.random(1, deployAccountCount);
      const reserve0 = helper.random(100, 220);
      const reserve1 = helper.random(100, 220);
      const amount0In = helper.random(10, 40);
      const maxOut = Math.max(1, Math.floor((reserve1 * amount0In) / (reserve0 + amount0In)) - 1);
      const amount1Out = Math.max(1, maxOut);
      const text = `swap,constructor,,,0,,false\nswap,initialize,instance,accounts[${token0Index}] accounts[${token1Index}],0,,false\nswap,mint,instance,accounts[${lpHolder}] ${reserve0} ${reserve1},0,,false\nswap,swap,instance,${amount0In} 0 0 ${amount1Out} accounts[${toIndex}],0,,true\n`;
      if (!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    });
  }

  if (transactionName == 'sync') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      let token0Index = helper.random(1, deployAccountCount);
      let token1Index = helper.random(1, deployAccountCount);
      while (token1Index == token0Index) token1Index = helper.random(1, deployAccountCount);
      const lpHolder = helper.random(1, deployAccountCount);
      const reserve0 = helper.random(80, 160);
      const reserve1 = helper.random(80, 160);
      const newReserve0 = reserve0 + helper.random(5, 30);
      const newReserve1 = Math.max(1, reserve1 - helper.random(1, Math.min(20, reserve1 - 1)));
      const text = `sync,constructor,,,0,,false\nsync,initialize,instance,accounts[${token0Index}] accounts[${token1Index}],0,,false\nsync,mint,instance,accounts[${lpHolder}] ${reserve0} ${reserve1},0,,false\nsync,sync,instance,${newReserve0} ${newReserve1},0,,true\n`;
      if (!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    });
  }
});

helper.runTests(transactionCounts, transactionFolders, testFolder, contractName, min_version);
