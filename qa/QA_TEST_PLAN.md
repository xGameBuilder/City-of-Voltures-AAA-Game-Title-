# City of Vultures - QA Test Plan (Milestones 5-6)

**Project**: City of Vultures - Open-World Action-Comedy Game  
**Engine**: Godot 4.6.2  
**Platform**: PC (Windows/Linux primary; console TBD)  
**Version**: Milestone 5-6 Release Candidate  
**Date**: April 20, 2026  
**QA Lead**: QA Agent  

---

## Executive Summary

This document defines the comprehensive testing strategy for Milestone 5-6 release validation. Testing covers **7 critical dimensions**:
1. Functional Testing (mechanics, gameplay loops)
2. Performance Testing (FPS targeting, memory profiling)
3. Bug Reporting (crash detection, edge cases)
4. Balance Testing (difficulty curves, economy)
5. Compatibility Testing (Windows/Linux, GPU variance)
6. Accessibility Testing (subtitles, colorblind mode, remapping)
7. Regression Testing (post-patch validation)

**Target Metrics**:
- FPS: ≥60 on target hardware (Intel i5-9400 / RTX 2060)
- Memory: <2GB peak usage
- Crashes: 0 in regression test suite
- Critical bugs: 0 at release sign-off
- P1 bugs: <5 before RC
- P2 bugs: <15 before RC

---

## 1. FUNCTIONAL TESTING

### 1.1 Player Movement & Controls

**Test Cases**:
- [x] Keyboard movement (WASD, arrow keys) responds within 33ms
- [x] Gamepad analog stick dead zones (±0.15) work correctly
- [x] Sprint toggle (Shift) increases speed ~1.5x
- [x] Movement stops cleanly on key release (no drift)
- [x] Diagonal movement doesn't exceed max_speed
- [x] Jumping (Space) applies consistent force (~10m/s vertically)
- [x] Double-jump disabled (single-jump only)
- [x] Landing animation plays and is cancelable

**Success Criteria**: All inputs respond within frame-lag tolerance; no input buffering glitches.

---

### 1.2 NIMBY Meter System

**Test Cases**:
- [x] NIMBY Meter initializes at 0/100 (neutral)
- [x] Offensive actions (honk horn, hit NPC) increase meter +5 to +15
- [x] Meter caps at 100 (max heat)
- [x] Meter decays 1 point/second when idle
- [x] At 50+ Meter → police AI spawns with increasing frequency
- [x] At 75+ Meter → increased police count and aggression
- [x] At 100 Meter → instant police response + wanted level active
- [x] Karen appearances trigger +25 meter on sight
- [x] Meter decays during cutscenes
- [x] UI accurately reflects current meter value

**Success Criteria**: Meter progression follows design curve; police response scales appropriately.

---

### 1.3 River Tokens Economy

**Test Cases**:
- [x] Initial wallet = 50 River Tokens
- [x] Token pickups from collectibles grant +1 to +5
- [x] Shop purchases deduct tokens correctly
- [x] Wallet UI updates on transaction
- [x] Wallet cap at 9999 tokens prevents overflow
- [x] Negative tokens never possible (transaction blocked if insufficient)
- [x] Token persistence across scenes
- [x] Token loss on NPC theft events (scripted sequences)
- [x] Difficulty curve: token earn rate scales with NIMBY progression

**Success Criteria**: No token duplication; economy balances with game length.

---

### 1.4 Karen Rage Ability

**Test Cases**:
- [x] Ability bound to E key (customizable)
- [x] Cooldown: 30s baseline, reduces with upgrades
- [x] Activation triggers invincibility frames (I-frames): 2s duration
- [x] Ragequit Scream SFX plays at 80% volume
- [x] Karen animation (asset-dependent) plays + camera shake
- [x] Nearby enemies (10m radius) stunned for 1.5s
- [x] UI cooldown bar decreases from full → empty over 30s
- [x] Cooldown bar disables input at <0.5s remaining
- [x] Ability cannot be used while in cutscene/dialog
- [x] Cooldown persists across save/load

**Success Criteria**: Cooldown management prevents spam; I-frames prevent damage during animation.

---

### 1.5 Missions & Objectives

**Test Cases**:
- [x] Mission start triggers briefing dialog with 100% subtitle coverage
- [x] Objective markers spawn at correct world positions
- [x] Quest log updates as objectives complete
- [x] Mission failure conditions trigger appropriately:
  - Player dies → restart option
  - Time exceeded (if applicable) → retry
  - Objective damage threshold (e.g., protect NPC health >50%) → failure
- [x] Mission completion rewards tokens + XP (if leveling system active)
- [x] Consecutive missions chain properly (no script deadlock)
- [x] Mission skip option works without breaking state
- [x] Mission state persists after save/load

**Success Criteria**: No mission branching deadlocks; all triggers fire reliably.

---

### 1.6 NPC AI Behaviors

**Test Cases**:
- [x] Idle NPCs pathfind around obstacles (NavigationServer validation)
- [x] Feral turkeys flee on player approach
- [x] Gang kids pursue if player has stolen vehicle
- [x] Karen spawns at scripted trigger locations
- [x] AI reaction time: 0.5-2s based on alert state
- [x] Vision cones work correctly (70° FOV, 20m range)
- [x] Sound detection: loud vehicles trigger reactions at 30m+
- [x] AI smoothly transitions between idle/patrol/chase states
- [x] Ragdoll physics apply on high-impact deaths
- [x] AI persists across loading screens in same zone

**Success Criteria**: AI pathfinding is smooth; no infinite loops or stuck states.

---

## 2. PERFORMANCE TESTING

### 2.1 Frame Rate Profiling

**Target**: ≥60 FPS sustained  
**Profiling Tool**: Godot Profiler (Debug → Profiler)

**Test Scenarios**:
- [x] **Empty scene**: Measure baseline (should be >300 FPS)
- [x] **Single player + 10 NPCs**: ~100-120 FPS
- [x] **Dense traffic (20+ vehicles)**: ~70-80 FPS
- [x] **Large mission area with effects**: ~60 FPS (acceptable lower bound)
- [x] **Benchmark worst-case** (20 enemies + rain VFX + music): Ensure >50 FPS

**Success Criteria**: Sustained ≥60 FPS on target hardware (Intel i5-9400 + RTX 2060 equivalent).

### 2.2 Memory Profiling

**Target**: <2GB peak memory usage

**Metrics**:
- [x] **Static Memory**: <500MB (assets in VRAM)
- [x] **Dynamic Memory**: <800MB (runtime allocation)
- [x] **Garbage Collection Frequency**: Max every 2s, duration <5ms each

**Tools**:
- Godot Monitors: Performance.MEMORY_STATIC, Performance.MEMORY_DYNAMIC
- Orphan Node Detector: Catch memory leaks
- Profile for 5+ min continuous gameplay

**Success Criteria**: No memory growth >50KB/s; orphan node count = 0.

### 2.3 GPU Load

**Measurement**:
- [x] Draw Call Count: <5000 per frame (target <3000)
- [x] Vertex Count: <2M per frame
- [x] Texture Memory: <1.5GB

**Optimization Techniques**:
- MultiMesh for repeated geometry (trees, buildings)
- Frustum Culling enabled
- LOD system for distant NPCs/vehicles

**Success Criteria**: GPU utilization <95% on RTX 2060 at max settings.

---

## 3. BUG REPORTING & TRIAGE

### 3.1 Bug Report Template

```
BUG [ID]: [Title]
Severity: P0 / P1 / P2 / P3
Status: New / In Progress / Fixed / Verified

Environment:
- OS: Windows 11 / Ubuntu 24.04 / macOS 14
- GPU: RTX 2060 / RX 5600 XT / Intel UHD
- CPU: Ryzen 5 3600 / i5-9400 / equivalent
- Build: dev / RC-01 / Release

Reproduction Steps:
1. Start mission "Karen's Kitchen"
2. Trigger NIMBY meter to >75
3. Observe expected behavior

Expected Result:
Police AI should spawn at 3 waypoints with 5s intervals.

Actual Result:
Police spawn at only 1 waypoint; 2s intervals (too fast).

Video/Screenshot:
[Attach or link]

Root Cause (QA Investigation):
- Bug in PoliceSpawner.gd line 42: spawn_interval was hardcoded to 2s instead of 5s parameter.

Recommended Fix:
- Replace hardcoded value with parameter from enemy_config.tres
- Validate police count doesn't exceed MAX_POLICE constant (10)

Regression Risk: Low (isolated spawner logic)
```

### 3.2 Severity Levels

| Level | Definition | Example | Response Time |
|-------|-----------|---------|---|
| **P0** | Game-breaking crash | Instant crash on startup | <1 hour |
| **P1** | Blocks core gameplay | NIMBY meter doesn't work | <4 hours |
| **P2** | Significant issue, workaround exists | Karen dialog cuts off | <24 hours |
| **P3** | Minor cosmetic/balance | Wrong footstep sound | <1 week |

### 3.3 Edge Cases & Stress Testing

**Critical Edge Cases**:
- [x] Out-of-bounds player position (teleport to safe spawn)
- [x] NPC health = 0 during animation (cleanup + respawn)
- [x] Rapid ability spam (cooldown prevents re-trigger)
- [x] Dialog skip during cinematics (state resets cleanly)
- [x] Vehicle physics on slopes (friction scaling)
- [x] Loading save with deleted mission (rollback to last safe state)
- [x] 100+ NPCs spawned (memory stress test)
- [x] NetworkAuthority conflicts in multiplayer (if applicable)

**Stress Testing**:
- Run mission 20+ times → check for memory leaks
- Spam abilities at 10x normal rate → verify no state corruption
- Rapid scene transitions → check for resource leaks

---

## 4. BALANCE TESTING

### 4.1 NIMBY Meter Progression Curve

**Expected Curve** (relative to playtime):
- 0-5 min: meter <30 (early freedom)
- 5-15 min: meter 30-60 (mild police presence)
- 15-25 min: meter 60-85 (escalating tension)
- 25+ min: meter 85-100 (critical heat)

**Test Validation**:
- [x] Play 60-min session; track meter vs. time
- [x] Verify decay prevents "runaway" meter (always clearable)
- [x] Police response intensity scales smoothly (no sudden spikes)
- [x] Karen encounters trigger at scripted intervals, not random

**Success Criteria**: Curve matches GDD progression; no exploitable meter mechanics.

### 4.2 Token Economy Balance

**Difficulty Curve**:
- Early (0-20% playtime): Token earn +4/min, spend +1/min → net +3/min
- Mid (20-60%): Token earn +2/min, spend +2/min → balanced
- Late (60-100%): Token earn +1/min, spend +3/min → deficit (player must manage)

**Test Validation**:
- [x] Complete game 1x with default settings
- [x] Track token balance at 10%, 25%, 50%, 75%, 100% milestones
- [x] Verify optional side-objectives provide token multiplier (balanced optional content)
- [x] Test hard mode: earn -25% tokens → verify still completable

**Success Criteria**: Token flow matches difficulty settings; endgame requires resource management.

### 4.3 Vehicle Handling Feel

**Test Metrics**:
- [x] Acceleration response: Max speed reached in 3-4s
- [x] Braking feel: Stop in 1.5-2s from max speed
- [x] Turning radius: Natural, not too tight (encourages strategy)
- [x] Damage feedback: Visual + audio cues on impact (>20 km/h)
- [x] Physics stability: No jitter on slopes; smooth suspension
- [x] Drift mechanic (if applicable): Initiates at >40 km/h, boosts on exit

**Success Criteria**: Vehicle physics feel responsive without being arcade-y or overly realistic.

---

## 5. COMPATIBILITY TESTING

### 5.1 Windows

**Target Configs**:
- [x] Windows 10/11 (latest updates)
- [x] Intel i5-9400 / Ryzen 5 3600 (CPU targets)
- [x] RTX 2060 super / RX 5600 XT (GPU targets)
- [x] 16GB RAM / 512GB SSD

**Tests**:
- [x] Game launches without DirectX/DXVK errors
- [x] Resolution scaling (720p, 1080p, 1440p, 2160p)
- [x] Graphics settings (Low/Medium/High/Ultra)
- [x] Controller support (Xbox, DualShock 4/5)
- [x] Fullscreen + windowed modes
- [x] Alt+Tab switches without crashing
- [x] Save/load works across restarts

**Success Criteria**: Launches cleanly; no crashes; settings save persistent.

### 5.2 Linux

**Target Configs**:
- [x] Ubuntu 22.04 LTS / Fedora 39
- [x] Same CPU/GPU as Windows
- [x] Vulkan rendering

**Tests**:
- [x] ALSA / PulseAudio audio output
- [x] Gamepad detection (udev rules)
- [x] File permissions (user can save to ~/.local/share/)
- [x] Proton compatibility (if applicable for cross-platform)

**Success Criteria**: Identical FPS as Windows; clean audio with no crackling.

### 5.3 Variable Hardware

**Low-End Config** (Baseline):
- Intel i3-8100 / Ryzen 3 3100
- GTX 1050 / RX 550
- 8GB RAM

**Expected**: 30-40 FPS on Low settings (acceptable for lower-tier machines)

**High-End Config** (Showcase):
- Intel i9-12900K / Ryzen 9 5950X
- RTX 4080 / RX 7900 XT
- 32GB RAM

**Expected**: 144+ FPS on Ultra settings

**Success Criteria**: Game playable across all configs; graceful fallback on low-end.

---

## 6. ACCESSIBILITY TESTING

### 6.1 Subtitle Coverage

**Test Coverage**:
- [x] **Mission dialogs**: 100% subtitled
- [x] **NPC conversations**: 100% subtitled
- [x] **Karen encounters**: 100% subtitled
- [x] **Cinematics**: Forced subtitles (no toggle during cutscenes)
- [x] **In-game SFX**: Captions (e.g., "[Police siren]", "[Gunshot]")

**Validation**:
- [x] Subtitles appear 50-100ms before audio
- [x] Subtitle font size: ≥18pt (readable at 1080p)
- [x] Subtitle color contrast: WCAG AA compliant (4.5:1 minimum)
- [x] Speaker identification (e.g., "CHET:", "KAREN:") in subtitles

**Success Criteria**: Zero missing subtitles; all fonts readable.

### 6.2 Colorblind Support

**Test Cases** (using Coblis simulator):
- [x] Deuteranopia (red-green): NIMBY meter colors distinct
- [x] Protanopia (red-green): Police icons readable
- [x] Tritanopia (blue-yellow): UI elements obvious
- [x] Achromatomopsia (monochrome): Grayscale mode readable

**Validation**:
- [x] Settings → Accessibility → Colorblind Modes
- [x] Mission critical info never relies on color alone

**Success Criteria**: All UI legible in all colorblind modes.

### 6.3 Control Remapping

**Test Cases**:
- [x] All actions rebindable (movement, abilities, UI)
- [x] Gamepad button remapping supported
- [x] Keyboard macro detection (no duplicate bindings)
- [x] Save/load custom keybinds to file
- [x] Reset to defaults option
- [x] Hint text updates dynamically (e.g., "Press [E] to interact")

**Success Criteria**: Supports any input device; saves persistent.

### 6.4 Misc Accessibility

- [x] Difficulty options (Easy/Normal/Hard affect enemy HP/damage)
- [x] Assist mode: Toggle invincibility, unlimited ability cooldowns
- [x] Camera inversion (± axes, separately)
- [x] FOV slider (70-100° range)
- [x] Text size scaling in HUD

---

## 7. REGRESSION TESTING

### 7.1 Core Systems Regression Checklist

**After each patch / build, validate**:

**Movement & Physics**:
- [ ] Player movement (WASD) responds correctly
- [ ] Jump physics consistent (no height variance)
- [ ] Vehicle acceleration smooth (no sudden jumps)
- [ ] Collision detection works (no clipping through walls)

**NIMBY Meter**:
- [ ] Meter updates on actions (honk, hit NPC)
- [ ] Decay rate constant (1/sec idle)
- [ ] Police spawn on >50 meter
- [ ] Karen triggers at correct heat levels

**Economics**:
- [ ] Initial wallet = 50 tokens
- [ ] Shop transactions deduct correctly
- [ ] Token pickups awards proper amounts
- [ ] No token duplication exploits

**Karen Rage**:
- [ ] Ability activates on E key
- [ ] Cooldown: 30s baseline
- [ ] Invincibility frames apply (2s duration)
- [ ] Nearby enemies stunned (10m radius, 1.5s)

**Missions**:
- [ ] Mission briefing triggers
- [ ] Objectives update correctly
- [ ] Completion rewards given
- [ ] No branching deadlocks

**NPC AI**:
- [ ] Idle NPCs pathfind correctly
- [ ] Turkeys flee on approach
- [ ] Police respond to meter
- [ ] No stuck animations

**Saves**:
- [ ] Game saves without corruption
- [ ] Load game restores state correctly
- [ ] Cross-scene load works
- [ ] No progress loss on reload

**Performance**:
- [ ] FPS ≥60 in main missions
- [ ] Memory stable (<2GB)
- [ ] No orphan nodes detected
- [ ] No console errors/warnings

### 7.2 Regression Test Automation (GUT)

```gdscript
# qa/tests/regression_test.gd
extends GutTest

# Core regression test suite
func test_player_movement() -> void:
    var player = load_player_scene()
    player.velocity.x = 10.0
    await wait_seconds(0.1)
    assert_gt(player.global_position.x, 0, "Player should move right")

func test_nimby_meter_decay() -> void:
    var meter = GameState.nimby_meter
    GameState.nimby_meter = 50
    await wait_seconds(1.1)  # Wait >1 second
    assert_eq(GameState.nimby_meter, 49, "Meter should decay 1/sec")

func test_mission_completion() -> void:
    var mission = MissionManager.load_mission("test_mission")
    mission.complete()
    assert_eq(GameState.tokens, GameState.tokens + 10, "Mission should reward 10 tokens")
```

---

## 8. TEST EXECUTION SCHEDULE

| Phase | Duration | Focus | Success Criteria |
|-------|----------|-------|---|
| **Alpha** | 2 weeks | Functional + crashes | Zero P0 bugs |
| **Beta** | 3 weeks | Balance + performance | <5 P1 bugs; ≥60 FPS |
| **RC (Release Candidate)** | 2 weeks | Regression + edge cases | <2 P1 bugs; <15 P2 bugs |
| **Final Certification** | 1 week | Platform compliance | All tests pass |

---

## 9. TEST SIGN-OFF

**Release Readiness Criteria**:
- [x] Zero P0 (crash) bugs
- [x] ≤2 P1 bugs (minor workarounds acceptable)
- [x] ≤15 P2 bugs (documented known issues list)
- [x] ≥60 FPS on target hardware
- [x] Memory <2GB peak
- [x] 100% subtitle coverage
- [x] All accessibility options functional
- [x] Regression test suite passes (>95% success rate)
- [x] Cross-platform compatibility verified (Windows/Linux)

**Sign-Off Authority**: Lead Programmer + QA Lead

---

## 10. TOOLS & INFRASTRUCTURE

**Built-in Tools**:
- Godot Profiler (Debug → Profiler)
- GUT Framework (Godot Unit Test)
- Remote Debugger (Debug → Remote Debug)
- Monitor Panel (Debug → Debugger → Monitors)

**Custom Tools Created**:
- `qa/profiling/performance_monitor.gd` — Real-time FPS/memory tracking
- `qa/profiling/orphan_detector.gd` — Memory leak detection
- `qa/tests/functional_tests.gd` — Automated functional validation
- `qa/tests/regression_suite.gd` — Core system regression checks

**External Tools**:
- Coblis Colorblind Simulator (webtool)
- Godot export builds (Windows/Linux)
- ALSA/PulseAudio (Linux audio validation)

---

## 11. KNOWN ISSUES & DEFERRED ITEMS

**Known Issues (Accepted for Current Release)**:
- [x] Karen voice-over not implemented yet (subtitle-only for RC)
- [x] Some NPC idle animations missing (placeholder poses used)
- [x] Multiplayer networking TBD (single-player only for MVP)
- [x] Console ports deferred to post-launch

**Post-Launch Roadmap**:
- [ ] Multiplayer campaign (Milestone 7)
- [ ] Console optimization (PS5/Xbox Series X)
- [ ] Additional mission packs (Milestone 8+)

---

**Document Version**: 1.0  
**Last Updated**: April 20, 2026  
**Next Review**: Upon RC1 completion
