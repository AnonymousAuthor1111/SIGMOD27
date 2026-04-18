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

const testFolder = path.join(__dirname, `../testTraces/fiatTokenProxy`);
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

  // Constructor: (impl: address). admin = deployer, implementation = impl.

  if(transactionName == 'changeAdmin') {
    // changeAdmin: sender == admin, newAdmin != 0.
    // Warmup changes admin -> target from new admin.
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let deployer = helper.random(0, deployAccountCount); // = admin
      let impl;
      do { impl = helper.random(0, deployAccountCount); } while(impl == deployer);
      let intermediate;
      do { intermediate = helper.random(0, deployAccountCount); } while(intermediate == deployer);
      let finalAdmin;
      do { finalAdmin = helper.random(0, deployAccountCount); } while(finalAdmin == intermediate);
      let text = `changeAdmin,constructor,,accounts[${impl}],${deployer},,false\n`;
      text += `changeAdmin,changeAdmin,instance,accounts[${intermediate}],${deployer},,false\n`;
      text += `changeAdmin,changeAdmin,instance,accounts[${finalAdmin}],${intermediate},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    })
  }

  if(transactionName == 'upgradeTo') {
    // upgradeTo: sender == admin, newImpl != 0. Admin unchanged.
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let deployer = helper.random(0, deployAccountCount);
      let impl;
      do { impl = helper.random(0, deployAccountCount); } while(impl == deployer);
      let newImpl1;
      do { newImpl1 = helper.random(0, deployAccountCount); } while(newImpl1 == deployer);
      let newImpl2;
      do { newImpl2 = helper.random(0, deployAccountCount); } while(newImpl2 == deployer || newImpl2 == newImpl1);
      let text = `upgradeTo,constructor,,accounts[${impl}],${deployer},,false\n`;
      text += `upgradeTo,upgradeTo,instance,accounts[${newImpl1}],${deployer},,false\n`;
      text += `upgradeTo,upgradeTo,instance,accounts[${newImpl2}],${deployer},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    })
  }

  if(transactionName == 'upgradeToAndCall') {
    // upgradeToAndCall: same as upgradeTo + calls new impl (out of scope).
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let deployer = helper.random(0, deployAccountCount);
      let impl;
      do { impl = helper.random(0, deployAccountCount); } while(impl == deployer);
      let newImpl1;
      do { newImpl1 = helper.random(0, deployAccountCount); } while(newImpl1 == deployer);
      let newImpl2;
      do { newImpl2 = helper.random(0, deployAccountCount); } while(newImpl2 == deployer || newImpl2 == newImpl1);
      let text = `upgradeToAndCall,constructor,,accounts[${impl}],${deployer},,false\n`;
      text += `upgradeToAndCall,upgradeToAndCall,instance,accounts[${newImpl1}],${deployer},,false\n`;
      text += `upgradeToAndCall,upgradeToAndCall,instance,accounts[${newImpl2}],${deployer},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    })
  }

})
helper.runTests(transactionCounts, transactionFolders, testFolder, contractName, min_version);
