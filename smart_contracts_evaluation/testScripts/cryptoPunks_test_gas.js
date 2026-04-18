const helper = require('./helper_functions');
const fs = require('fs');
const path = require('path');

const testFolder = path.join(__dirname, '../tracefiles_long/cryptoPunks');
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

function ensureFile(dir, fileName, text) {
  const file = path.join(dir, fileName);
  if (!fs.existsSync(file)) {
    fs.writeFileSync(file, text);
  }
}

helper.range(transactionCounts).forEach(l => {
  const transactionName = transactionFolders[l];
  const transactionFolderPath = path.join(testFolder, `/${transactionName}`);
  const setupPath = path.join(transactionFolderPath, '/setup.txt');
  let transactionCount = 1;
  if (fs.existsSync(setupPath)) {
    const setupFS = fs.readFileSync(setupPath, 'utf-8');
    setupFS.split(/\r?\n/).forEach(sl => {
      if (sl.startsWith('nt')) {
        transactionCount = +sl.split(',')[1];
      }
    });
  }

  helper.range(transactionCount).forEach(testFileIndex => {
    const fileName = `${transactionName}_${testFileIndex}.txt`;
    const sellerIndex = (testFileIndex % 4) + 1;
    const buyerIndex = ((testFileIndex + 1) % 4) + 5;
    const recipientIndex = ((testFileIndex + 2) % 4) + 5;
    const bidderIndex = ((testFileIndex + 3) % 4) + 1;
    const punkIndex = testFileIndex + 11;
    const minPrice = 100 + (testFileIndex * 10);
    const higherBid = minPrice + 50;

    let text = '';

    if (transactionName == 'allInitialOwnersAssigned') {
      text = `allInitialOwnersAssigned,constructor,,,0,,false\nallInitialOwnersAssigned,allInitialOwnersAssigned,instance,,0,,true\n`;
    }

    if (transactionName == 'getPunk') {
      text = `getPunk,constructor,,,0,,false\ngetPunk,allInitialOwnersAssigned,instance,,0,,false\ngetPunk,getPunk,instance,${punkIndex},${sellerIndex},,true\n`;
    }

    if (transactionName == 'transferPunk') {
      text = `transferPunk,constructor,,,0,,false\ntransferPunk,allInitialOwnersAssigned,instance,,0,,false\ntransferPunk,getPunk,instance,${punkIndex},${sellerIndex},,false\ntransferPunk,transferPunk,instance,accounts[${recipientIndex}] ${punkIndex},${sellerIndex},,true\n`;
    }

    if (transactionName == 'punkNoLongerForSale') {
      text = `punkNoLongerForSale,constructor,,,0,,false\npunkNoLongerForSale,allInitialOwnersAssigned,instance,,0,,false\npunkNoLongerForSale,getPunk,instance,${punkIndex},${sellerIndex},,false\npunkNoLongerForSale,offerPunkForSale,instance,${punkIndex} ${minPrice},${sellerIndex},,false\npunkNoLongerForSale,punkNoLongerForSale,instance,${punkIndex},${sellerIndex},,true\n`;
    }

    if (transactionName == 'offerPunkForSale') {
      text = `offerPunkForSale,constructor,,,0,,false\nofferPunkForSale,allInitialOwnersAssigned,instance,,0,,false\nofferPunkForSale,getPunk,instance,${punkIndex},${sellerIndex},,false\nofferPunkForSale,offerPunkForSale,instance,${punkIndex} ${minPrice},${sellerIndex},,true\n`;
    }

    if (transactionName == 'buyPunk') {
      text = `buyPunk,constructor,,,0,,false\nbuyPunk,allInitialOwnersAssigned,instance,,0,,false\nbuyPunk,getPunk,instance,${punkIndex},${sellerIndex},,false\nbuyPunk,offerPunkForSale,instance,${punkIndex} ${minPrice},${sellerIndex},,false\nbuyPunk,buyPunk,instance,${punkIndex},${buyerIndex},${minPrice},true\n`;
    }

    if (transactionName == 'enterBidForPunk') {
      text = `enterBidForPunk,constructor,,,0,,false\nenterBidForPunk,allInitialOwnersAssigned,instance,,0,,false\nenterBidForPunk,getPunk,instance,${punkIndex},${sellerIndex},,false\nenterBidForPunk,enterBidForPunk,instance,${punkIndex},${buyerIndex},${higherBid},true\n`;
    }

    if (transactionName == 'acceptBidForPunk') {
      text = `acceptBidForPunk,constructor,,,0,,false\nacceptBidForPunk,allInitialOwnersAssigned,instance,,0,,false\nacceptBidForPunk,getPunk,instance,${punkIndex},${sellerIndex},,false\nacceptBidForPunk,enterBidForPunk,instance,${punkIndex},${buyerIndex},${higherBid},false\nacceptBidForPunk,acceptBidForPunk,instance,${punkIndex} ${minPrice},${sellerIndex},,true\n`;
    }

    if (transactionName == 'withdrawBidForPunk') {
      text = `withdrawBidForPunk,constructor,,,0,,false\nwithdrawBidForPunk,allInitialOwnersAssigned,instance,,0,,false\nwithdrawBidForPunk,getPunk,instance,${punkIndex},${sellerIndex},,false\nwithdrawBidForPunk,enterBidForPunk,instance,${punkIndex},${buyerIndex},${higherBid},false\nwithdrawBidForPunk,withdrawBidForPunk,instance,${punkIndex},${buyerIndex},,true\n`;
    }

    if (transactionName == 'withdraw') {
      text = `withdraw,constructor,,,0,,false\nwithdraw,allInitialOwnersAssigned,instance,,0,,false\nwithdraw,getPunk,instance,${punkIndex},${sellerIndex},,false\nwithdraw,offerPunkForSale,instance,${punkIndex} ${minPrice},${sellerIndex},,false\nwithdraw,buyPunk,instance,${punkIndex},${buyerIndex},${minPrice},false\nwithdraw,withdraw,instance,,${sellerIndex},,true\n`;
    }

    ensureFile(transactionFolderPath, fileName, text);
  });
});

helper.runTests(transactionCounts, transactionFolders, testFolder, contractName, min_version);
