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

const testFolder = path.join(__dirname, `../testTraces/ownedUpgradeabilityProxy`);
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

  // Constructor: no args. proxyOwner = deployer, pendingProxyOwner = 0.

  if(transactionName == 'transferProxyOwnership') {
    // sender == proxyOwner, newOwner != 0. Sets pendingProxyOwner only.
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let deployer = helper.random(0, deployAccountCount);
      let pending1, pending2;
      do { pending1 = helper.random(0, deployAccountCount); } while(pending1 == deployer);
      do { pending2 = helper.random(0, deployAccountCount); } while(pending2 == deployer || pending2 == pending1);
      let text = `transferProxyOwnership,constructor,,,${deployer},,false\n`;
      text += `transferProxyOwnership,transferProxyOwnership,instance,accounts[${pending1}],${deployer},,false\n`;
      text += `transferProxyOwnership,transferProxyOwnership,instance,accounts[${pending2}],${deployer},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    })
  }

  if(transactionName == 'claimProxyOwnership') {
    // sender == pendingProxyOwner != 0. Need transferProxyOwnership first.
    // Warmup: transfer+claim round 1. Target: transfer+claim round 2.
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let deployer = helper.random(0, deployAccountCount);
      let pending1, pending2;
      do { pending1 = helper.random(0, deployAccountCount); } while(pending1 == deployer);
      do { pending2 = helper.random(0, deployAccountCount); } while(pending2 == deployer || pending2 == pending1);
      let text = `claimProxyOwnership,constructor,,,${deployer},,false\n`;
      text += `claimProxyOwnership,transferProxyOwnership,instance,accounts[${pending1}],${deployer},,false\n`;
      text += `claimProxyOwnership,claimProxyOwnership,instance,,${pending1},,false\n`;
      text += `claimProxyOwnership,transferProxyOwnership,instance,accounts[${pending2}],${pending1},,false\n`;
      text += `claimProxyOwnership,claimProxyOwnership,instance,,${pending2},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    })
  }

  if(transactionName == 'upgradeTo') {
    // sender == proxyOwner, newImpl != currentImpl.
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let deployer = helper.random(0, deployAccountCount);
      let impl1, impl2;
      do { impl1 = helper.random(0, deployAccountCount); } while(impl1 == deployer);
      do { impl2 = helper.random(0, deployAccountCount); } while(impl2 == deployer || impl2 == impl1);
      let text = `upgradeTo,constructor,,,${deployer},,false\n`;
      text += `upgradeTo,upgradeTo,instance,accounts[${impl1}],${deployer},,false\n`;
      text += `upgradeTo,upgradeTo,instance,accounts[${impl2}],${deployer},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    })
  }

})
helper.runTests(transactionCounts, transactionFolders, testFolder, contractName, min_version);
