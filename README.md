# Solar System iOS App

A simple iOS application displaying planetary data for our solar system.

## Issue Fixed: IOS-6

**Problem**: Planetary data for Mars was showing Jupiter's moon count instead of Mars' actual moon count.

**Solution**: 
- ✅ Mars now correctly shows **2 moons** (Phobos and Deimos)
- ✅ Jupiter correctly shows **95 moons** (as of 2023)
- ✅ All planetary data has been verified and corrected

## Features

- 📱 Clean iOS interface displaying all 8 planets
- 🌙 Accurate moon counts for each planet
- 📏 Distance from Sun in Astronomical Units (AU)
- 📊 Planet diameter information
- 📝 Descriptive information for each planet

## Files Structure

- `PlanetaryData.swift` - Core data model and manager with corrected planetary information
- `PlanetViewController.swift` - Main view controller displaying the planet list
- `PlanetTableViewCell.swift` - Custom table view cell for planet display
- `PlanetaryDataTests.swift` - Unit tests ensuring data accuracy, especially Mars moon count

## Key Fix Details

### Before (Issue)
- Mars was incorrectly showing Jupiter's moon count (95+ moons)

### After (Fixed)
- Mars correctly shows 2 moons (Phobos and Deimos)
- Jupiter shows 95 moons (accurate as of 2023)
- All other planets have verified moon counts

## Testing

The `PlanetaryDataTests.swift` file includes comprehensive tests to ensure:
- Mars has exactly 2 moons
- Mars data is not confused with Jupiter data
- All planets have correct moon counts
- Data integrity is maintained

## Planet Moon Counts (Verified)

| Planet  | Moon Count | Notable Moons |
|---------|------------|---------------|
| Mercury | 0          | None |
| Venus   | 0          | None |
| Earth   | 1          | The Moon |
| **Mars** | **2**     | **Phobos, Deimos** |
| Jupiter | 95         | Io, Europa, Ganymede, Callisto |
| Saturn  | 146        | Titan, Enceladus |
| Uranus  | 27         | Miranda, Ariel |
| Neptune | 16         | Triton |

*Moon counts are accurate as of 2023 astronomical data.*
