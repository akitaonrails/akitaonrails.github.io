// Run with: node --test scripts/test_language_redirects.cjs
const assert = require('node:assert/strict');
const { readFileSync } = require('node:fs');
const { test } = require('node:test');
const vm = require('node:vm');

const template = readFileSync('layouts/partials/custom/head-end.html', 'utf8');
const scripts = [...template.matchAll(/<script>([\s\S]*?)<\/script>/g)]
  .map(match => match[1])
  .filter(script => script.includes('// Language preference.') || script.includes('// Cross-language nudge'));
assert.equal(scripts.length, 2);

function visit({ path = '/en/article/', language = 'pt-BR', cookies = {}, translated = true }) {
  const jar = new Map(Object.entries(cookies));
  const redirects = [];
  const events = [];
  const document = {
    get cookie() { return [...jar].map(([key, value]) => `${key}=${value}`).join('; '); },
    set cookie(value) { const [key, val] = value.split(';')[0].split('='); jar.set(key, val); },
    readyState: 'loading',
    querySelector(selector) {
      if (selector.includes('aor-current-lang')) return { getAttribute: () => path.startsWith('/en/') ? 'en' : 'pt-br' };
      if (!translated) return null;
      return { getAttribute: () => path.startsWith('/en/') ? path.slice(3) : `/en${path}` };
    },
    addEventListener(event) { events.push(event); }
  };
  const context = vm.createContext({ document, navigator: { language, userAgent: 'Mozilla/5.0' },
    window: { location: { pathname: path, replace: url => redirects.push(url) } } });
  for (const script of scripts) vm.runInContext(script, context);
  return { redirects, events, jar };
}

for (const [lang, browser, path] of [['en', 'pt-BR', '/en/article/'], ['pt', 'en-US', '/article/']]) {
  test(`manual ${lang} choice survives automatic redirection`, () => {
    const result = visit({ path, language: browser, cookies: { lang_auto: '1', lang_pref: lang } });
    assert.deepEqual(result.redirects, []);
    assert.deepEqual(result.events, []);
  });
}

for (const path of ['/', '/index.html', '/en/', '/en/index.html']) {
  test(`home session policy remains authoritative at ${path}`, () => {
    const en = path.startsWith('/en/');
    const result = visit({ path, language: en ? 'pt-BR' : 'en-US', cookies: { lang_session: '1', lang_auto: '1' } });
    assert.deepEqual(result.redirects, []);
    assert.deepEqual(result.events, []);
    assert.equal(result.jar.get('lang_pref'), en ? 'en' : 'pt');
  });
}

test('first home visit honors saved language without an opposing redirect', () => {
  const result = visit({ path: '/', language: 'pt-BR', cookies: { lang_pref: 'en', lang_auto: '1' } });
  assert.deepEqual(result.redirects, ['/en/']);
  assert.deepEqual(result.events, []);
});
test('automatic article redirect follows saved preference, not browser locale', () => {
  assert.deepEqual(visit({ path: '/article/', cookies: { lang_auto: '1', lang_pref: 'en' } }).redirects, ['/en/article/']);
});
test('without a preference automatic redirect still uses browser locale', () => {
  assert.deepEqual(visit({ cookies: { lang_auto: '1' } }).redirects, ['/article/']);
});
test('new visitors are offered a translation instead of forced navigation', () => {
  const result = visit({});
  assert.deepEqual(result.redirects, []);
  assert.deepEqual(result.events, ['DOMContentLoaded']);
});
test('dismissed prompts and disabled redirects stay suppressed', () => {
  for (const cookies of [{ lang_asked: '1' }, { lang_auto: '0' }]) {
    const result = visit({ cookies });
    assert.deepEqual(result.redirects, []);
    assert.deepEqual(result.events, []);
  }
});
test('pages without translations never redirect or prompt', () => {
  const result = visit({ translated: false, cookies: { lang_auto: '1' } });
  assert.deepEqual(result.redirects, []);
  assert.deepEqual(result.events, []);
});
