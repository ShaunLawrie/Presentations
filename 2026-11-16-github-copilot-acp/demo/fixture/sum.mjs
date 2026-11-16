export function sum(values) {
  // Deliberate demo bug: an empty array needs a defined result.
  return values.reduce((total, value) => total + value);
}
