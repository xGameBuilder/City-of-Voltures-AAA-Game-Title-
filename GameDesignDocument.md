# Game Design Document: City of Vultures

**Version**: 1.0  
**Date**: April 20, 2026  
**Engine**: Godot 4.6.2  
**Genre**: Open-World Action-Comedy  
**Platform**: PC (primary), potential console ports  

## 1. Introduction

### 1.1 Purpose
This Game Design Document (GDD) serves as the blueprint for **City of Vultures**, an open-world third-person action-comedy game. It outlines the vision, mechanics, and implementation details to guide development on Godot 4.6.2.

### 1.2 Game Summary
Players control Chet "The Gent" Miller, a suburban transplant stranded in Sacramento's Del Paso Heights after a crypto-scam. Through satirical missions, players navigate the city's chaos, parodying crime games with California's capital's unique blend of decay, wealth, and absurdity.

### 1.3 Target Audience
- Age: 18+ (mature themes, satire)
- Interests: Fans of GTA, Saints Row, or satirical games like South Park.
- Platform: PC gamers seeking humor and open-world freedom.

## 2. Game Overview

### 2.1 Core Gameplay Loop
- Explore Sacramento's districts.
- Complete satirical missions.
- Manage the NIMBY Meter to avoid escalating heat.
- Earn River Tokens for upgrades and bribes.
- Experience dynamic events (e.g., turkey attacks, heatwaves).

### 2.2 Unique Selling Points
- Satirical take on Sacramento's culture.
- Innovative mechanics like Post-Suburban Karen Rage and Climate Engine.
- Immersive radio stations and local easter eggs.

### 2.3 Win/Lose Conditions
- No strict win/lose; open-ended progression.
- "Escape the 916" by completing main story or reaching high chaos thresholds.

## 3. Story and Setting

### 3.1 Narrative Overview
Chet arrives in Sacramento optimistic but quickly realizes the city's underbelly. Missions parody real issues: inequality, homelessness, bureaucracy. The story unfolds through quests, radio chatter, and environmental storytelling.

### 3.2 Setting
A condensed Sacramento with districts:
- **The Trenches (Del Paso Heights)**: Urban decay, gangs, potholes.
- **The Snob 40s**: Wealthy mansions, Karens.
- **The Hoe Strip (Stockton Blvd)**: Nightlife, prostitutes.
- **Central Hub (Downtown)**: Empty offices, Loaves & Fishes.
- **The Wilds (American River Parkway)**: Encampments, turkeys.

### 3.3 Themes
Satire of California politics, inequality, and suburban naivety. Humor through exaggeration of local stereotypes.

## 4. Gameplay Mechanics

### 4.1 Core Mechanics
- **Movement**: Third-person controls with sprint, jump, crouch.
- **Combat**: Melee and ranged; focus on evasion over direct fights.
- **Driving**: Vehicle handling with random failures (e.g., check engine light).
- **Stealth**: Disguises, distractions for missions.

### 4.2 Unique Systems
- **NIMBY Meter**: Heat system escalating from social media posts to tank chases.
  - Levels: 1-5 stars; 5 summons SacPD Tank.
- **River Tokens Economy**: Earn via recycling, vending, influencing.
  - Spend on upgrades (health, vehicle mods).
- **Climate Engine**: Seasonal effects.
  - Summer: Heatstroke without drinks.
  - Spring: Sneezing affects aim/steering.
- **Radio System**: Dynamic stations with lore and humor.

### 4.3 Missions
- **Structure**: Main story, side quests, random events.
- **Examples**:
  - Evade scooter gang in shopping cart maze.
  - Rob mansion using leaf pickup disguise.
  - Recruit "employees" via bar dialogue.
  - Retrieve laptop in encampment chase.

### 4.4 Progression
- Skill trees for Chet's abilities.
- Unlock districts and vehicles.
- Achievements for satirical feats (e.g., "Turkey Slayer").

## 5. Characters

See [AGENTS.md](AGENTS.md) for detailed character breakdowns.

## 6. Levels and World Design

### 6.1 World Layout
- Open-world map ~10-15 km².
- Seamless travel between districts.
- Dynamic events: Pileups from Beam laser, turkey flocks.

### 6.2 Level Design Principles
- Verticality in mansions; mazes in encampments.
- Environmental hazards: Potholes, fluff, heatwaves.
- Easter Eggs: Tower Records, Governor cameo.

## 7. Art and Audio

### 7.1 Art Style
- **Sun-Bleached Noir**: Hazy yellow lighting, caricatured models.
- **Godot Implementation**: Use Environment nodes for lighting; ShaderMaterials for effects.

### 7.2 Audio
- **Radio Stations**: Looped tracks with dynamic interruptions.
- **SFX**: Vehicle failures, sneezes, turkey gobbles.
- **Music**: Jazz, rap, talk radio.

### 7.3 Assets
- 3D Models: Low-poly for performance.
- Textures: Photorealistic with satirical overlays.

## 8. Technical Design

### 8.1 Engine Specifics (Godot 4.6.2)
- **Architecture**: Scene-based; main scene loads districts dynamically.
- **Scripting**: GDScript for logic; C# optional for performance.
- **Physics**: Bullet physics for vehicles and ragdolls.
- **Rendering**: Forward+ renderer; LOD for distant objects.
- **AI**: NavigationServer3D for agents; state machines.
- **Multi-threading**: Use threads for heavy computations (e.g., pathfinding).

### 8.2 Performance Targets
- 60 FPS on mid-range PCs.
- Draw calls <1000; use instancing for crowds.

### 8.3 Tools and Pipelines
- Version Control: Git with Godot's scene merging.
- Asset Pipeline: Import models via GLTF; audio via WAV/OGG.
- Testing: Godot's profiler for optimization.

## 9. User Interface and Experience

### 9.1 HUD
- Mini-map with districts.
- NIMBY Meter bar.
- Health, tokens display.

### 9.2 Menus
- Main Menu: Start, options, credits.
- Pause: Save, settings.
- Dialogue: Branching choices.

### 9.3 Accessibility
- Subtitles for radio/dialogue.
- Adjustable difficulty for heat/stealth.

## 10. Monetization and Distribution

### 10.1 Business Model
- Paid game on Steam/Itch.io.
- Potential DLC: New districts, vehicles.

### 10.2 Marketing
- Satirical trailers highlighting Sacramento humor.
- Community: Mod support via Godot's open nature.

## 11. Development Roadmap

### 11.1 Phases
- **Pre-Production**: Finalize GDD, prototype mechanics.
- **Production**: Build core loop, districts, missions.
- **Polish**: Audio, UI, balancing.
- **Release**: Beta testing, launch.

### 11.2 Risks
- Satire may offend; ensure disclaimers.
- Performance on large open world.

## 12. Appendices

- **References**: GTA, Saints Row for mechanics.
- **Inspirations**: Sacramento culture, local news.
- **Change Log**: Track updates to this GDD.

This GDD will evolve with development. For code samples, see the project's scripts folder.