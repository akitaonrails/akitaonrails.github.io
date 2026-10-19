// Run with: node --test scripts/test_search_keyboard.cjs
const { test } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const template = fs.readFileSync(process.env.HEAD_TEMPLATE || 'layouts/partials/custom/head-end.html', 'utf8');
const source = [...template.matchAll(/<script>([\s\S]*?)<\/script>/g)]
  .map(match => match[1]).find(script => script.includes('function onInputKey'));

// Minimal DOM for exercising the real inline script's event handlers without dependencies.
async function setup(path) {
  const doc = { listeners: {}, createTextNode: text => ({ textContent: text }) };
  class Element {
    constructor(tagName) {
      this.tagName = tagName; this.children = []; this.listeners = {};
      this.attributes = {}; this.value = ''; this.isConnected = true;
      this.classList = { toggle() {} };
    }
    appendChild(child) { this.children.push(child); child.parentNode = this; }
    setAttribute(name, value) { this.attributes[name] = value; }
    addEventListener(name, handler) { (this.listeners[name] ||= []).push(handler); }
    focus() { doc.activeElement = this; }
    scrollIntoView() {}
    set innerHTML(value) { this.children = []; }
    querySelectorAll() { return this.children.filter(child => child.tagName === 'a'); }
  }
  doc.createElement = tag => new Element(tag);
  doc.addEventListener = Element.prototype.addEventListener;
  doc.body = new Element('body');
  const trigger = new Element('a'); trigger.focus();
  const window = { location: { pathname: path } };
  vm.runInNewContext(source, { document: doc, window, fetch: async () => ({ json: async () => [
    { t: 'Ruby one', u: '/one/', d: '2026-01-01' },
    { t: 'Ruby two', u: '/two/', d: '2025-01-01' }
  ] }) });
  function key(target, key, shiftKey = false) {
    const e = { target, key, shiftKey, preventDefault() { this.defaultPrevented = true; } };
    for (let node = target; node; node = node.parentNode) {
      for (const handler of node.listeners?.keydown || []) handler(e);
    }
    for (const handler of doc.listeners.keydown || []) handler(e);
    return e;
  }
  key(trigger, 'r');
  await new Promise(resolve => setImmediate(resolve));
  const back = doc.body.children[0];
  const [input, , list] = back.children[0].children;
  return { doc, trigger, back, input, rows: list.children, key, window };
}
for (const path of ['/', '/en/']) {
  test(`${path} Escape closes from a result and restores focus`, async () => {
    const s = await setup(path); s.rows[0].focus();
    assert.equal(s.key(s.rows[0], 'Escape').defaultPrevented, true);
    assert.equal(s.back.hidden, true); assert.equal(s.doc.activeElement, s.trigger);
  });
  test(`${path} Tab wraps both dialog boundaries`, async () => {
    const s = await setup(path);
    assert.equal(s.back.attributes['aria-modal'], 'true');
    assert.equal(s.key(s.input, 'Tab', true).defaultPrevented, true);
    assert.equal(s.doc.activeElement, s.rows[1]);
    assert.equal(s.key(s.rows[1], 'Tab').defaultPrevented, true);
    assert.equal(s.doc.activeElement, s.input);
    assert.equal(s.key(s.input, 'Tab').defaultPrevented, undefined);
  });
  test(`${path} Empty results keep Tab on input; Escape restores focus`, async () => {
    const s = await setup(path); s.input.value = 'zzzz';
    s.input.listeners.input[0]();
    assert.equal(s.key(s.input, 'Tab').defaultPrevented, true);
    assert.equal(s.doc.activeElement, s.input);
    s.key(s.input, 'Escape'); assert.equal(s.doc.activeElement, s.trigger);
  });
  test(`${path} Arrow and Enter selection still navigate`, async () => {
    const s = await setup(path); s.key(s.input, 'ArrowDown'); s.key(s.input, 'Enter');
    assert.equal(s.window.location.href, '/two/');
  });
}
