#!/usr/bin/env node

const puppeteer = require('puppeteer');
const commandLineArgs = require('command-line-args')

const optionDefinitions = [
  { name: 'selector', alias: 's', type: String },
  { name: 'url', type: String, defaultOption: true},
  { name: 'output', alias: 'o', type: String},
  { name: 'gui', type: Boolean, defaultValue: false},
];

const opts = commandLineArgs(optionDefinitions);

(async () => {
  console.log(`capturing ${opts.selector} from ${opts.url}`);
  const browser = await puppeteer.launch({headless: !opts.gui});
  const page = await browser.newPage();
  // Adjustments particular to this page to ensure we hit desktop breakpoint.
  page.setViewport({width: 1500, height: 900, deviceScaleFactor: 1});

  await page.goto(
    opts.url,
    {waitUntil: 'networkidle2'}
  );

  try {
    await page.waitForSelector(opts.selector);
    const el = await page.$(opts.selector);
    await el.screenshot({ path: opts.output || 'capture.png'});
  } catch (e) {
    console.error(e);
  }

  browser.close();
})();

