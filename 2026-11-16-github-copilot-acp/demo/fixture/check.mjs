import assert from 'node:assert/strict';
import { sum } from './sum.mjs';

assert.equal(sum([1, 2, 3]), 6);
assert.equal(sum([-2, 2]), 0);
assert.equal(sum([]), 0);
console.log('All three checks passed');
