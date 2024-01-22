import { isDecimalNumber, isNumberInRange, toNumberOrNull } from './numbers';

describe('checks if a number is a decimal number', () => {
  it('returns false for non-decimal numbers', () => {
    expect(isDecimalNumber(NaN)).toBe(false);
    expect(isDecimalNumber(Infinity)).toBe(false);
    expect(isDecimalNumber(-Infinity)).toBe(false);
  });

  it('returns true for decimal numbers', () => {
    expect(isDecimalNumber(0)).toBe(true);
    expect(isDecimalNumber(-0)).toBe(true);
    expect(isDecimalNumber(10.12345)).toBe(true);
    expect(isDecimalNumber(Number.MAX_VALUE)).toBe(true);
    expect(isDecimalNumber(Number.MIN_VALUE)).toBe(true);
  });
});

describe('checks if a number is within a range', () => {
  it('returns false for numbers outside the range', () => {
    expect(isNumberInRange(0, 10, 10)).toBe(false);
    expect(isNumberInRange(0.01, 10, 10)).toBe(false);
    expect(isNumberInRange(50.1, 0, 50)).toBe(false);
  });

  it('returns true for numbers inside the range', () => {
    expect(isNumberInRange(0, 0, 50)).toBe(true);
    expect(isNumberInRange(50, 0, 50)).toBe(true);
    expect(isNumberInRange(-50.12345, -50.12345, 0)).toBe(true);
  });
});

describe('converts input to a number or null', () => {
  it('returns null for invalid inputs', () => {
    expect(toNumberOrNull(null)).toBeNull();
    expect(toNumberOrNull(undefined)).toBeNull();
    expect(toNumberOrNull('')).toBeNull();
    expect(toNumberOrNull(NaN)).toBeNull();
  });

  it('returns a number for valid inputs', () => {
    expect(toNumberOrNull(0)).toBeCloseTo(0);
    expect(toNumberOrNull('0')).toBeCloseTo(0);
    expect(toNumberOrNull('-123.45')).toBeCloseTo(-123.45);
  });
});
