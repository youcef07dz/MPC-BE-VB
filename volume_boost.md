# Volume Boost & Step

## Slider range
Adapts to boost: `SetRange(0, 1000 / boost)`. Position always maps to 0–100% effective volume.

| Boost | Slider range |
|-------|-------------|
| 2x    | 0–500       |
| 5x    | 0–200       |
| 10x   | 0–100       |

Range rescales automatically when boost changes (preserves effective volume).

## Visual bar
Fills proportionally to `position / rangeMax`. Matches the OSD effective volume display.

## Step
One zone: **+5 OSD points per press**. Internally computed as `5 × 10 / boost` position units.

| Boost | Position step |
|-------|--------------|
| 2x    | +25          |
| 5x    | +10          |
| 10x   | +5           |

## Boost values
Max boost reduced to **10x** (1000% max effective). Values: 2, 5, 10. 20x removed from menus, slider, and registry.

## Step slider
Removed from Audio settings page. Step is hardcoded at 5 OSD points. Not persisted to registry — always starts at default on launch.

## Key files
- `PlayerVolumeCtrl.cpp` — slider range, bar draw, step calc, `SetRangeFromBoost()`
- `PPageAudio.cpp` — settings page, boost/step slider handlers
- `MainFrm.cpp` — menu preset handlers
- `AppSettings.cpp` — defaults and registry read/write
