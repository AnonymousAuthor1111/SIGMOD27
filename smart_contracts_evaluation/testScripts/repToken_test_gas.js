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

const testFolder = path.join(__dirname, `../testTraces/repToken`);
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

// Constructor: (legacy, freezeAmt, freezeAcct, targetSupply).
// Use freezeAmt+MIGRATE_AMT == targetSupply for tx needing initialized=true;
// use HIGH target for tx not needing initialization so migrate/approve stay unpinned.
const FREEZE_AMT = 1000;
const MIGRATE_AMT = 500;
const TARGET_INIT = FREEZE_AMT + MIGRATE_AMT;
const TARGET_HIGH = 10 * TARGET_INIT;

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

  if(transactionName == 'transfer') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let deployer = helper.random(0, deployAccountCount);
      let legacy;    do { legacy = helper.random(0, deployAccountCount); } while(legacy == deployer);
      let freeze;    do { freeze = helper.random(0, deployAccountCount); } while(freeze == deployer || freeze == legacy);
      let holder;    do { holder = helper.random(0, deployAccountCount); } while(holder == deployer || holder == legacy || holder == freeze);
      let to;        do { to = helper.random(0, deployAccountCount); } while(to == holder);
      let amt1 = helper.random(10, 201);
      let amt2 = helper.random(10, 201);
      let text = `transfer,constructor,,accounts[${legacy}] ${FREEZE_AMT} accounts[${freeze}] ${TARGET_INIT},${deployer},,false\n`;
      text += `transfer,migrateBalance,instance,accounts[${holder}] ${MIGRATE_AMT},${deployer},,false\n`;
      text += `transfer,unpause,instance,,${deployer},,false\n`;
      text += `transfer,transfer,instance,accounts[${to}] ${amt1},${holder},,false\n`;
      text += `transfer,transfer,instance,accounts[${to}] ${amt2},${holder},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    })
  }

  if(transactionName == 'transferFrom') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let deployer = helper.random(0, deployAccountCount);
      let legacy;    do { legacy = helper.random(0, deployAccountCount); } while(legacy == deployer);
      let freeze;    do { freeze = helper.random(0, deployAccountCount); } while(freeze == deployer || freeze == legacy);
      let owner;     do { owner = helper.random(0, deployAccountCount); } while(owner == deployer || owner == legacy || owner == freeze);
      let spender;   do { spender = helper.random(0, deployAccountCount); } while(spender == owner);
      let to;        do { to = helper.random(0, deployAccountCount); } while(to == owner || to == spender);
      let tf1 = helper.random(10, 101);
      let tf2 = helper.random(10, 101);
      let text = `transferFrom,constructor,,accounts[${legacy}] ${FREEZE_AMT} accounts[${freeze}] ${TARGET_INIT},${deployer},,false\n`;
      text += `transferFrom,migrateBalance,instance,accounts[${owner}] ${MIGRATE_AMT},${deployer},,false\n`;
      text += `transferFrom,unpause,instance,,${deployer},,false\n`;
      text += `transferFrom,approve,instance,accounts[${spender}] 300,${owner},,false\n`;
      text += `transferFrom,transferFrom,instance,accounts[${owner}] accounts[${to}] ${tf1},${spender},,false\n`;
      text += `transferFrom,transferFrom,instance,accounts[${owner}] accounts[${to}] ${tf2},${spender},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    })
  }

  if(transactionName == 'approve') {
    // Pattern: approve(amt1) -> approve(0) -> approve(amt2, target).
    // Rule: (n>0, current==0) increase OR (n==0, current>0) decrease.
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let deployer = helper.random(0, deployAccountCount);
      let legacy;    do { legacy = helper.random(0, deployAccountCount); } while(legacy == deployer);
      let freeze;    do { freeze = helper.random(0, deployAccountCount); } while(freeze == deployer || freeze == legacy);
      let caller = helper.random(0, deployAccountCount);
      let spender;   do { spender = helper.random(0, deployAccountCount); } while(spender == caller);
      let amt1 = helper.random(10, 501);
      let amt2 = helper.random(10, 501);
      let text = `approve,constructor,,accounts[${legacy}] ${FREEZE_AMT} accounts[${freeze}] ${TARGET_HIGH},${deployer},,false\n`;
      text += `approve,approve,instance,accounts[${spender}] ${amt1},${caller},,false\n`;
      text += `approve,approve,instance,accounts[${spender}] 0,${caller},,false\n`;
      text += `approve,approve,instance,accounts[${spender}] ${amt2},${caller},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    })
  }

  if(transactionName == 'transferOwnership') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let deployer = helper.random(0, deployAccountCount);
      let legacy;    do { legacy = helper.random(0, deployAccountCount); } while(legacy == deployer);
      let freeze;    do { freeze = helper.random(0, deployAccountCount); } while(freeze == deployer || freeze == legacy);
      let intermediate; do { intermediate = helper.random(0, deployAccountCount); } while(intermediate == deployer);
      let finalOwner;   do { finalOwner = helper.random(0, deployAccountCount); } while(finalOwner == intermediate);
      let text = `transferOwnership,constructor,,accounts[${legacy}] ${FREEZE_AMT} accounts[${freeze}] ${TARGET_HIGH},${deployer},,false\n`;
      text += `transferOwnership,transferOwnership,instance,accounts[${intermediate}],${deployer},,false\n`;
      text += `transferOwnership,transferOwnership,instance,accounts[${finalOwner}],${intermediate},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    })
  }

  if(transactionName == 'pause') {
    // Needs paused=false. Flow: ctor -> migrate (init) -> unpause -> pause.
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let deployer = helper.random(0, deployAccountCount);
      let legacy;    do { legacy = helper.random(0, deployAccountCount); } while(legacy == deployer);
      let freeze;    do { freeze = helper.random(0, deployAccountCount); } while(freeze == deployer || freeze == legacy);
      let holder;    do { holder = helper.random(0, deployAccountCount); } while(holder == deployer || holder == legacy || holder == freeze);
      let text = `pause,constructor,,accounts[${legacy}] ${FREEZE_AMT} accounts[${freeze}] ${TARGET_INIT},${deployer},,false\n`;
      text += `pause,migrateBalance,instance,accounts[${holder}] ${MIGRATE_AMT},${deployer},,false\n`;
      text += `pause,unpause,instance,,${deployer},,false\n`;
      text += `pause,pause,instance,,${deployer},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    })
  }

  if(transactionName == 'unpause') {
    // Needs paused=true + initialized=true. One-shot.
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let deployer = helper.random(0, deployAccountCount);
      let legacy;    do { legacy = helper.random(0, deployAccountCount); } while(legacy == deployer);
      let freeze;    do { freeze = helper.random(0, deployAccountCount); } while(freeze == deployer || freeze == legacy);
      let holder;    do { holder = helper.random(0, deployAccountCount); } while(holder == deployer || holder == legacy || holder == freeze);
      let text = `unpause,constructor,,accounts[${legacy}] ${FREEZE_AMT} accounts[${freeze}] ${TARGET_INIT},${deployer},,false\n`;
      text += `unpause,migrateBalance,instance,accounts[${holder}] ${MIGRATE_AMT},${deployer},,false\n`;
      text += `unpause,unpause,instance,,${deployer},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    })
  }

  if(transactionName == 'migrateBalance') {
    // Needs sender=owner, initialized=false. Use HIGH target so not reached.
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let deployer = helper.random(0, deployAccountCount);
      let legacy;    do { legacy = helper.random(0, deployAccountCount); } while(legacy == deployer);
      let freeze;    do { freeze = helper.random(0, deployAccountCount); } while(freeze == deployer || freeze == legacy);
      let holder1;   do { holder1 = helper.random(0, deployAccountCount); } while(holder1 == deployer || holder1 == legacy || holder1 == freeze);
      let holder2;   do { holder2 = helper.random(0, deployAccountCount); } while(holder2 == deployer || holder2 == legacy || holder2 == freeze || holder2 == holder1);
      let amt1 = helper.random(50, 501);
      let amt2 = helper.random(50, 501);
      let text = `migrateBalance,constructor,,accounts[${legacy}] ${FREEZE_AMT} accounts[${freeze}] ${TARGET_HIGH},${deployer},,false\n`;
      text += `migrateBalance,migrateBalance,instance,accounts[${holder1}] ${amt1},${deployer},,false\n`;
      text += `migrateBalance,migrateBalance,instance,accounts[${holder2}] ${amt2},${deployer},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    })
  }

})
helper.runTests(transactionCounts, transactionFolders, testFolder, contractName, min_version);
