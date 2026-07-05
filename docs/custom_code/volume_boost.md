# Volume Boost + Step

## Goal

Add volume boost (1x–20x ceiling) and volume step (1–20 raw slider increment) controls to MPC-BE, accessible from both the Audio options page and the Play menu.

## Files changed

| File | Change |
|---|---|
| `src/common.props` | Removed LTCG (caused heap error on soxr/dbesi0.c) |
| `src/apps/mplayerc/SettingsDefines.h` | `IDS_RS_VOLUMEBOOST`, `IDS_RS_VOLUME_STEP` setting keys |
| `src/apps/mplayerc/AppSettings.h` | `nVolumeStep`, `nVolumeBoost` members |
| `src/apps/mplayerc/AppSettings.cpp` | Defaults: `nVolumeBoost=5`, `nVolumeStep=5`; read range 1–20; write |
| `src/apps/mplayerc/PlayerToolBar.cpp` | `GetVolume()` uses `nVolumeBoost` multiplier |
| `src/apps/mplayerc/PlayerVolumeCtrl.cpp` | `SetPageSize(nVolumeStep)` for raw slider step |
| `src/apps/mplayerc/PPageAudio.h` | `m_nVolumeBoost`, `m_volboostctrl`, `m_nVolumeStep`, `m_volstepctrl` + old values |
| `src/apps/mplayerc/PPageAudio.cpp` | Boost slider (1–20), Step slider (1–20), tooltips, apply, scroll, cancel handlers |
| `src/apps/mplayerc/PPagePlayback.h` | Removed volume step combo member |
| `src/apps/mplayerc/PPagePlayback.cpp` | Removed volume step combo init/apply |
| `src/apps/mplayerc/MainFrm.h` | `OnVolumeBoostPreset`, `OnVolumeStepPreset` handlers |
| `src/apps/mplayerc/MainFrm.cpp` | Boost/Step preset handlers, OSD display |
| `src/apps/mplayerc/mplayerc.rc` | Boost (x2/x5/x10/x20) + Step (1/2/5/10/20) submenus under Play > Volume; step slider in Audio dialog |
| `src/apps/mplayerc/resource.h` | Command IDs for boost/step presets |
| `src/apps/mplayerc/mplayerc.cpp` | Auto-update startup check commented out |

## How it works

- **Boost** (`nVolumeBoost`, 1–20, default 5): multiplies the effective volume.  
  `effective_volume% = slider_pos * nVolumeBoost / 10`  
  Boost=5 → slider max = 500%, boost=20 → slider max = 2000%.
- **Step** (`nVolumeStep`, 1–20, default 5): raw slider increment per Volume Up/Down click.  
  The slider has range 0–1000; step=5 moves it by 5 positions.  
  Effective volume change per click = `step * boost / 10`%.
- Boost/Step sliders live in the **Audio options page** (IDD_PPAGEAUDIO).
- Boost/Step preset submenus in **Play > Volume** for quick access from the toolbar.

## Removed

- Old volume step combo box from Playback options page (IDD_PPAGEPLAYBACK, `IDC_COMBOVOLUME`).
- Individual Boost Up/Down menu items (replaced by Boost preset submenu).
- Auto-update commented out (startup check, menu item, handler).

## Build notes

- LTCG removed from `common.props` due to `fatal error C1002: compiler is out of heap space` on `soxr\dbesi0.c`.
- Pre-existing linker warnings `LNK4006` (strtold) and `LNK4088` (/FORCE) are unrelated.
- Build with `msbuild mpc-be.sln /p:Configuration=Release /p:Platform=x64 /t:Build /m:2`.
- Avoid Clean (wipes LTCG cache; use Build for incremental).
