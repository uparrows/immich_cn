import { isNumberInRange } from '../numbers';

export function parseLatitude(input: string | number | null): number | null {
  if (input === null) {
    return null;
  }
  const latitude = typeof input === 'string' ? Number.parseFloat(input) : input;

  if (isNumberInRange(latitude, -90, 90)) {
    return latitude;
  }
  return null;
}

export function parseLongitude(input: string | number | null): number | null {
  if (input === null) {
    return null;
  }

  const longitude = typeof input === 'string' ? Number.parseFloat(input) : input;

  if (isNumberInRange(longitude, -180, 180)) {
    return longitude;
  }
  return null;
}
