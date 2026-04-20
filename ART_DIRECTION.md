# Art Direction: City of Vultures - Milestone 5

**Version**: 1.0  
**Date**: April 20, 2026  
**Art Director**: [AI Art Director]  
**Engine**: Godot 4.6.2 (Forward+ Renderer)  
**Target Platform**: PC (1080p–4K), Console Ports (Secondary)  

---

## Executive Summary

**City of Vultures** employs **Photorealistic Sun-Bleached Noir** visual direction—a hybrid style blending GTA-V's environmental verisimilitude with exaggerated character silhouettes and satirical environmental design. This balances production budgets (lower-poly character rigs) with immersive suburban decay. The aesthetic reinforces narrative themes: Sacramento's stark contrast between crumbling infrastructure and aspiration, rendered in perpetual hazy-afternoon light.

---

## 1. ART STYLE: Photorealistic Sun-Bleached Noir

### 1.1 Style Philosophy

**Core Concept**: "What if you were stuck in a decaying California suburb during eternal heatwave?"

- **Visual Anchor**: GTA-V meets *Trailer Park Boys* via Godot 4.6.2 Forward+ renderer.
- **Tone**: Satirical caricature grounded in photorealistic environments.
- **Character vs. Environment**: Environments are richly detailed (weathered asphalt, rust, graffiti); characters are stylized (cartoon proportions, exaggerated faces).

### 1.2 Platform Considerations

**PC (Primary Target)**
- Native 1080p–4K support.
- High-poly environmental assets (10k–50k tris per building section).
- Volumetric fog, dynamic shadows, advanced particle effects.
- 60 FPS target on mid-range GPUs (RTX 2070 equivalent).

**Console Ports (Secondary)**
- Justify with lower-poly character rigs (2k–5k tris).
- Pre-baked lightmaps for faster shadow computation.
- Draw call optimization via MultiMesh instancing (crowds, vegetation).
- Resolution: 1080p/30fps (PS5/Xbox Series X can push to dynamic 1440p/60fps).

### 1.3 Technical Rendering Strategy

**Godot 4.6.2 Forward+ Specifics**
```
PBR Workflow:
  - Albedo: Photorealistic base color (sRGB color space)
  - Metallic/Roughness: Split maps (0–1 range per pixel)
  - Normal: OpenGL format (RG compression for mobile, full for PC)
  - AO: Baked into albedo alpha channel (ORM texture packing)
  - Emission: Used sparingly (neon signs, vehicles headlights)

Shader Approach:
  - StandardMaterial3D for 90% of assets (fast, reliable)
  - Custom ShaderMaterial for: character skin (subsurface scattering), 
    vehicle paint (anisotropic), water (screen-space normals)
  - Decal shaders for graffiti overlay (avoid geometry multiplication)
```

**Performance Budget**
- Draw calls: < 1000 per frame (PC), < 500 (console).
- Triangles: < 5M per frame (PC), < 2M (console).
- Textures: 2K max (diffuse), 1K for distant LODs.
- Godot Profiler targets: GPU < 10ms, CPU < 16ms (60 FPS).

### 1.4 Visual Reference Anchors

| Game | Style Lesson |
|------|--------------|
| **GTA-V** | Environmental detail density, vehicle personality, radio realism |
| **Trailer Park Boys** | Caricatured character performances, lived-in decay |
| **Broken Age** | Hand-painted backgrounds (NOT emulated—our style is 3D) |
| **It Takes Two** | Whimsical exaggeration of mundane spaces (suburbs as absurd) |
| **Saints Row (2006)** | Satirical NPC archetypes, over-the-top dialogue → visual design |

---

## 2. COLOR PALETTES & MOOD BOARDS

### 2.1 Global Lighting Mood: "Perpetual Smog-Sunset"

All districts bathed in warm, hazy afternoon light (perpetual 4 PM, June 21).

**Base Sky-Sphere Gradient**
```
Zenith:     #FFD89B (hazy pale yellow)
Horizon:    #FF8C42 (smoggy orange-rust)
Ground Ref: #DEB887 (dusty tan reflection)
```

**ProceduralSkyMaterial Parameters**
```gdscript
sky_top_color = Color("#FFD89B")
sky_horizon_color = Color("#FF8C42")
ground_color = Color("#DEB887")
sun_brightness = 2.5  # Strong but hazy
sun_disk_size = 2.0   # Spread due to particles/haze
```

**Global Fog (Volumetric)**
```gdscript
# Volumetric fog for air-quality feel
environment.volumetric_fog_enabled = true
environment.volumetric_fog_density = 0.15
environment.volumetric_fog_air_density = 0.5
environment.volumetric_fog_emission = Color("#FFAA44") * 0.5
# Creates a haze that feels like Sacramento summer smog
```

### 2.2 District Color Palettes

#### **THE TRENCHES (Del Paso Heights)**
**Vibe**: Urban decay, abandonment, survival—the moral center where reality hits.

| Element | Hex | RGB | Usage |
|---------|-----|-----|-------|
| Asphalt (weathered) | #4A4A4A | 74,74,74 | Roads, parking lots |
| Rust (buildings) | #8B4513 | 139,69,19 | Corroded metal, fire escapes |
| Graffiti (accent) | #FF6B35 | 255,107,53 | Gang tags, political art |
| Poverty (shadow) | #2A2A2A | 42,42,42 | Dim interior spaces |
| Hope accent | #87CEEB | 135,206,235 | Clear sky peeks (contrast) |

**Mood Board Description**
- Boarded-up liquor stores with faded murals.
- Potholes the size of swimming pools (literal gameplay hazards).
- Rusted chain-link fences with dollar-store flags.
- Flickering utility lights (orange sodium vapor, 80–120V flicker).
- Tags layered over tags (environmental storytelling: territory history).
- Abandoned storefronts with hand-painted "CLOSED" signs.
- Street-level vegetation: cracked concrete, weeds (yellowish-brown).

**Lighting Note**: Sodium-vapor streetlights cast *warm yellow* shadows. During day, harsh contrast (hard shadows, deep alleys). At dusk, the haze amplifies orange tones.

**Environmental Details**
- Broken fire hydrants (spraying water systems)
- Missing manhole covers exposing infrastructure
- Hand-painted political yard signs ("RECALL THE GOVERNOR")
- Abandoned vehicles (stripped parts visible)
- Graffiti styles: Old-school 90s tags, recent SoundCloud rapper names

---

#### **THE SNOB 40s (Fabulous 40s)**
**Vibe**: Obscene wealth divorced from reality—Karen kingdom, satire of American excess.

| Element | Hex | RGB | Usage |
|---------|-----|-----|-------|
| Manicured Lawn | #90EE90 | 144,238,144 | Perfect grass (artificial polish) |
| Mansion Beige | #F5DEB3 | 245,222,179 | Stucco, house siding |
| Gold Accent | #FFD700 | 255,215,0 | Gate trim, door handles |
| Blood Red | #8B0000 | 139,0,0 | Accent doors, awnings |
| Pristine White | #FFFAFA | 255,250,250 | Clean window frames, columns |

**Mood Board Description**
- Spanish Colonial Revival mansions with 3-story stone gates.
- Excessive Christmas lights (even in June—Karen permanence).
- Ornate metal gates with names ("Miller Estate," "Tech Bro Headquarters").
- Perfect manicured lawns (HOA-enforced)—no blade out of place.
- Marble fountains with koi (aspirational water waste).
- Manicured hedges trimmed into animal shapes.
- Mercedes, Tesla, Hummer lineup in circular driveways.
- Lawn signs: Aggressive HOA notices, "ARMED RESPONSE" security placards.
- Fake vineyards (decorative, non-functional).
- Blindingly clean mid-century modern furniture visible through oversized windows.

**Lighting Note**: Brightest district (sunlight reflects off white surfaces, polished metals). Harsh, clinical shadows. At night, dramatic uplighting on mansions (wastes power for visual effect). Ring doorbell cameras cast subtle blue glow.

**Environmental Details**
- Pristine painted curbs (fire lane red/white)
- Immaculate driveways (no oil stains—power-washed daily)
- Decorative fountains (water features as status symbol)
- Replica statuary from galleries
- Obsessively manicured Italian and Japanese gardens
- Solar panels on roofs (green-washing)

---

#### **THE HOE STRIP (Stockton Blvd / Broadway)**
**Vibe**: Late-night chaos, neon energy, economic desperation meets nightlife—edgy but thriving.

| Element | Hex | RGB | Usage |
|---------|-----|-----|-------|
| Neon Pink | #FF1493 | 255,20,147 | Strip club signs, bar accents |
| Neon Cyan | #00FFFF | 0,255,255 | Business signs, vehicle lights |
| Dark Brick | #6B4423 | 107,68,35 | 1970s commercial buildings |
| Asphalt Wet | #3A3A3A | 58,58,58 | Street (rain-slicked appearance) |
| Amber (streetlight) | #FFAA33 | 255,170,51 | Old sodium lamps, neon glow |

**Mood Board Description**
- Vintage neon signs (flickering, some burnt-out tubes).
- 1970s–90s low-rise commercial buildings (aging but functional).
- Adult entertainment venues (strip clubs, massage parlors—discreet entrances).
- Late-night taco trucks (hand-painted side graphics, salsa recipes).
- Motels with neon palm trees and vacancies signs.
- Pawn shops with barred windows and "CASH NOW" banners.
- Pool halls, dive bars (dim interiors, blue neon beer signs).
- Questionable late-night services (phone numbers on bathroom walls).
- Parking lots with broken lights (shadows everywhere).
- Tire tracks, spilled liquids staining asphalt.

**Lighting Note**: Neon dominates night hours. During day, neon signs are mostly invisible (harsh daylight washes them out). This district transforms at sundown—moody, energetic, dangerous.

**Environmental Details**
- Neon signs with missing/flickering tubes (Coca-Cola sign missing letters)
- Boarded-up storefronts interspersed with active businesses
- Hand-painted murals advertising services
- Used car lots with plastic pennant strings
- Parking painted with fading lot numbers
- Visible security cameras on every corner

---

#### **CENTRAL HUB (Downtown / K-Street)**
**Vibe**: Crumbling aspirations, empty offices, institutional abandonment—the heart of civic rot.

| Element | Hex | RGB | Usage |
|---------|-----|-----|-------|
| Concrete Gray | #808080 | 128,128,128 | Office buildings, brutalist structures |
| Weathered Green | #5F8A5C | 95,138,92 | Aging copper/patina (rare metal details) |
| Faded Teal | #5F9999 | 95,153,153 | 80s office lobby trim |
| Shadow Black | #1A1A1A | 26,26,26 | Dark office interior depths |
| Bureaucratic Beige | #D4C5A9 | 212,197,169 | Government building exteriors |

**Mood Board Description**
- 10–20 story office buildings (1970s–2000s architecture).
- Empty storefronts at street level (leasing signs with outdated URLs).
- Crumbling arena (Sacramento Kings arena, built in 1988, visibly aging).
- Loaves & Fishes homeless shelter (white industrial building, tension point).
- City Hall (classical facade, juxtaposed against decay).
- King's statue in plaza (weathered, no longer polished).
- Public art installations (outdated fountains, broken sculptures).
- Light rail stops (modern infrastructure in midst of decay mismatch).
- Vacant office lobbies (potted plants dead/overgrown).
- Sidewalk tent encampments (play area for late-game chaos).

**Lighting Note**: Overhead sun bounces off gray concrete, creating diffuse, flat, depressing light. Long shadows in alleys. At night, amber streetlights create noir prison feel. Some buildings have *lit office windows* at random floors (occupied by night security, strange figures).

**Environmental Details**
- Broken fountain sculptures with algae growth
- Graffiti mixed with chalk art (homeless identity markers)
- Leasing signs with decades-old office park listings
- Boarded/tarped windows in upper floors
- Visible air conditioning units, rust stains
- Abandoned planters with dead shrubs

---

#### **THE WILDS (American River Parkway)**
**Vibe**: Nature reclamation, sovereign chaos, turkey territory—beauty corrupted by human disregard.

| Element | Hex | RGB | Usage |
|---------|-----|-----|-------|
| River Brown | #654321 | 101,67,33 | Water, mud, erosion |
| Willow Green | #6B8E23 | 107,142,35 | Vegetation, overgrown paths |
| Tent Blue | #4B5885 | 75,88,133 | Tarp encampments (tarps, though variable) |
| Levee Concrete | #A9A9A9 | 169,169,169 | Flood control walls |
| Turkey Brown | #8B4513 | 139,69,19 | Feral turkey plumage (fierce) |

**Mood Board Description**
- Overgrown bike paths (weeds through cracked pavement).
- Homeless encampments under bridges (blue tarps, shopping carts).
- Levee walls covered in moss/algae.
- Native oaks and willows (some dead, some thriving).
- River access points (muddy banks, pollution visible—plastic bottles).
- Graffiti murals on levee (gang tags mixed with political messages).
- Abandoned shopping carts in water (toxic fish habitat).
- Sovereign citizen compounds (ramshackle shelters, warning signs).
- Feral turkey roosts in trees (menacing presence, feathers on ground).
- Discarded furniture, appliances (dumping ground aesthetic).

**Lighting Note**: Dappled sunlight through tree canopy. Early morning fog rolls off river (moody, mysterious). At night, very dark—only moon and distant city lights. Isolated pockets of firelight (encampment cooking fires).

**Environmental Details**
- Levee graffiti murals (tagging culture, territorial marks)
- Scattered supplies: blankets, cans, water bottles
- Fire rings (evidence of gatherings)
- Makeshift shelters (wood frames, tarps)
- Warning signs: "NO DUMPING," "PROPERTY OF USA ARMY CORPS"
- Turkey scratch marks in dirt, feather clusters

---

### 2.3 Time-of-Day Lighting Shifts

**Godot Time-of-Day System** (simplified for production feasibility)

The game exists in perpetual 4 PM haze, but environment transitions help punctuate narrative beats:

| Time | Sky Color | Fog Density | Ambient Brightness | Mood |
|------|-----------|-------------|-------------------|------|
| 6 AM | #87CEEB→#FFB84D | 0.10 | 0.7 | Eerie calm, sparse traffic |
| 12 PM | #FFD89B | 0.12 | 1.0 | Harsh heat, shadows sharp |
| 4 PM (BASE) | #FF8C42 | 0.15 | 1.2 | Perpetual smog, haze saturates everything |
| 7 PM | #FF6B35→#8B4513 | 0.18 | 0.8 | Golden dusk, transition to neon dominance |
| 10 PM | #1a1a3e | 0.08 | 0.3 | Dark blue night, neon glows intensify |
| 3 AM | #0d0d2b | 0.05 | 0.1 | Deep night, streetlight only illumination |

**Godot Implementation**
```gdscript
# Environment node animation
var time_of_day: float = 1.0  # 0–24 hours
func update_environment():
    var hour = fmod(time_of_day, 24.0)
    var sun_angle = (hour / 24.0) * PI * 2
    direct_light.rotation.x = (hour - 6) / 12.0 * PI
    environment.ambient_light_energy = lerp(0.3, 1.2, sin(sun_angle))
    environment.volumetric_fog_density = lerp(0.05, 0.18, sin(sun_angle))
```

---

## 3. CHARACTER DESIGN

### 3.1 Chet Miller - Protagonist

**Visual Identity**: "Suburban Dad in Denial"

**Appearance Spec**
- **Build**: Soft-bodied, 40s (age 42), beer gut not hidden by oversized clothing.
- **Height**: 5'11" (slightly above average—enough to think he can fight).
- **Posture**: Slouching walk (exhausted); stiff combat stance (untrained).
- **Face**: Weathered suburbanite—sun damage, frown lines, slightly droopy eyes.

**Color Palette (Chet)**
| Element | Color | Hex |
|---------|-------|-----|
| Sacramento Kings Jersey | Deep Purple | #5B2C6F |
| Cargo Shorts | Faded Denim Blue | #8899BB |
| Red Ball Cap | Faded Red | #CC3333 |
| Skin Tone | Sunburned Beige | #D4A574 |
| Facial Hair | Gray/Blonde Mix | #C9A961 |
| Shoes | White leather sneakers, yellowed | #F5F5DC |

**Clothing Breakdown**
```
Torso:      Purple Kings jersey (faded, armpit stains—yellowed)
Lower:      Oversized denim cargo shorts (stained, frayed)
Feet:       White Adidas shell-toes (yellowed sole, worn heel)
Accessories: Chain wallet, worn watch (broken glass), ring of keys on cargo clip
Head:       Red Sacramento Kings cap (faded, sweat stains on bill)
```

**Personality → Visual Design**
- **Posture**: Slouch walk reflects exhaustion; combat stance is awkward (feet too close).
- **Idle Animation**: Constantly adjusts cap, checks phone, tugs at shorts.
- **Facial Expression**: Default frown; rarely smiles unless mocking someone.
- **Scar/Marks**: Sunburned shoulders visible in sleeveless jersey.

**Model Specifications (Godot)**
```
Skeleton Rig: 65 bones (body, fingers, face for lip-sync)
Poly Count: 4,500 tris (LOD0), 2,200 (LOD1), 800 (LOD2)
Texture Resolution: 2K (diffuse/normal/ORM)
Estimated File Size: ~3.2 MB (.glb)
```

**Progression Cosmetics** (optional skins for upgrades)
- Chet in tattered tank top (post-heat damage)
- Chet in leaf-pickup uniform (disguise for stealth missions)
- Chet in silk tracksuit (post-wealth mission)

---

### 3.2 NPC Archetypes

#### **The Karen**
**Visual Tropes**: Aggressively fashionable, indignant posture.

| Feature | Design |
|---------|--------|
| Hair | Blonde highlights, sharp bob cut (asymmetrical) |
| Outfit | Lululemon leggings + oversized designer sunglasses + visible Apple Watch |
| Makeup | Heavy contour, aggressively purple eyeshadow |
| Accessories | Oversized leather purse, designer phone case |
| Posture | Hand on hip, head tilted (perpetual offense) |
| Color Palette | Pastels: #FFB6C1 (hot pink shirt), #E0FFFF (light cyan cardigan) |

**Poly Count**: 3,200 tris (less detailed than Chet, acceptable for NPCs).
**Voice**: High-pitched, nasally affect; speech patterns include "Actually," "I know my rights."

---

#### **The Gang Kid**
**Visual Tropes**: Scooter thug, SoundCloud rapper aesthetic.

| Feature | Design |
|---------|--------|
| Hair | Cornrows, dyed blonde tips, oversized wave cap underneath |
| Outfit | Oversized hoodie (taped holes), basketball shorts, white socks pulled up |
| Shoes | Scuffed Jordans or knockoff kicks |
| Accessories | Gold chains, bandana around wrist, small backpack |
| Posture | Slouch, aggressive stance during confrontation |
| Color Palette | Dark: #2F4F4F (gunmetal hoodie), #FFD700 (chain), #FF6347 (accent) |

**Poly Count**: 2,800 tris.
**Voice**: Teenage bravado, local slang ("Bruh," "Hella," "What you saying?").

---

#### **The Homeless Sage**
**Visual Tropes**: Lived-in wisdom, visible survival apparatus.

| Feature | Design |
|---------|--------|
| Hair | Long, matted, gray/brown |
| Outfit | Layers: hooded sweatshirt, duct-taped jacket, blanket cape |
| Shoes | Mismatched boots, taped together |
| Accessories | Shopping cart (converted to backpack/home), tin cup, signs |
| Face | Weathered, sun-damaged, kind eyes (wisdom cliché) |
| Color Palette | Grays/browns: #5C4033, #696969, #8B7355 |

**Poly Count**: 2,600 tris.
**Voice**: Cadence of deep knowledge; philosophical non-sequiturs ("The river remembers everything, brother").

---

#### **The Real Estate Bro**
**Visual Tropes**: Nouveau riche, finance-bro peacocking.

| Feature | Design |
|---------|--------|
| Hair | Styled, copious product (swoosh cut) |
| Outfit | Blazer over hoodie (trying too hard), slim fit jeans, expensive sneakers |
| Accessories | Rolex watch, visible AirPods, multiple gold rings, Tesla key |
| Posture | Aggressive posturing, chest-forward |
| Face | Spray tan, aggressively white teeth, perpetual smirk |
| Color Palette | Pastels: #FFB6C1 (pink shirt), #E0FFFF (blue blazer), #FFD700 (bling) |

**Poly Count**: 3,400 tris.
**Voice**: Slick sales pitch accent, says "bro" every sentence, laughs about his own jokes.

---

### 3.3 Character Design Guidelines for Modelers

1. **Stylization Over Realism**: NPCs are caricatures (51–120% exaggeration of real proportions).
2. **Silhouette Clarity**: From 30 feet away, NPCs must be instantly identifiable by shape alone.
3. **Clothing as Archetype Marker**: Outfit = character type (not subtle).
4. **Face Geometry**: Exaggerated features (large noses, sharp jaws, asymmetrical eyes).
5. **Animation Target**: All characters must reach 60 FPS with multiple on-screen; use LOD swapping at distance.

---

## 4. VEHICLE DESIGN

### 4.1 Vehicle Palette

**Design Philosophy**: Each vehicle marries realistic model with satirical stat progression.

#### **Honda Civic (The Underdog)**
**Spec**
- **Gen**: 2008–2012 (peak scene car era)
- **Condition**: Abused but functional (dented quarter panels, mismatched door)
- **Paint**: Faded silver or midnight blue
- **Cosmetics**: Aftermarket spoiler (too large), underbody lights (blue, flickering)
- **Sound**: Tinny engine, rattling bodywork

**Stat Tie-Ins**
- Speed: 6/10 (not fastest, but nimble)
- Durability: 4/10 (rust, brittle plastic)
- Heat Generation: 8/10 (revving attracts police)
- Check Engine Light Chance: 35% (high—owner does aggressive mods)
- Resale Value: $3,500 River Tokens

**Godot Model Specs**: 8,500 tris, 2K textures, metallic paint shader.

---

#### **Tesla Model 3 (Tech Bro Mobile)**
**Spec**
- **Gen**: Latest (2024 model)
- **Condition**: Pristine, recently purchased
- **Paint**: Solid white or pearl matte gray
- **Cosmetics**: Minimal—steering yoke visible, Brembo brakes implied
- **Sound**: Near-silent electric whine, tire noise

**Stat Tie-Ins**
- Speed: 8/10 (electric acceleration torque)
- Durability: 9/10 (modern, well-built)
- Heat Generation: 2/10 (eco-friendly image = lower NIMBY escalation initially)
- Check Engine Light Chance: 2% (too new to fail)
- Resale Value: $12,000 River Tokens

**Satire Hook**: Autopilot footage appears in news media; player blamed for owner's recklessness.

**Godot Model Specs**: 12,000 tris, leather interior detail, glass reflection shader.

---

#### **Hummer H2 (Compensatory Excess)**
**Spec**
- **Gen**: 2006–2009 (peak absurdity)
- **Condition**: Overmaintained, chrome shining
- **Paint**: Glossy black with custom flames (gold pinstriping)
- **Cosmetics**: Neon underglow, oversized wheels (22"+ rims), tinted windows
- **Sound**: Aggressive V8 growl, wasteful

**Stat Tie-Ins**
- Speed: 5/10 (heavy, slow acceleration)
- Durability: 8/10 (built like tank, parts expensive)
- Heat Generation: 9/10 (environmental disaster = instant NIMBY escalation)
- Check Engine Light Chance: 25% (pushed too hard by owner)
- Resale Value: $8,000 River Tokens

**Satire Hook**: Protagonist drives it unironically despite environmental criticism from NPCs.

**Godot Model Specs**: 15,000 tris (largest road vehicle), heavy particle system for fumes.

---

#### **2004 Nissan Altima (Gig Economy Standard)**
**Spec**
- **Gen**: 2002–2006 ("Altima Driver" meme)
- **Condition**: Beaten down, missing bumper, ductape repairs
- **Paint**: Faded white or gray
- **Cosmetics**: Mismatched hubcaps, taped windows, visible dents
- **Sound**: Rattling loose parts, engine knock

**Stat Tie-Ins**
- Speed: 4/10 (aging, underpowered)
- Durability: 3/10 (structural rust, systems failing)
- Heat Generation: 3/10 (invisible, forgettable)
- Check Engine Light Chance: 70% (always on, ignored)
- Resale Value: $1,200 River Tokens

**Satire Hook**: Protagonist drives for quick access to low-income neighborhoods; NPCs trust him more in this car.

**Godot Model Specs**: 7,200 tris, weathered matte paint, visible interior deterioration.

---

#### **Transit Van (Cargo & Chaos)**
**Spec**
- **Gen**: Ford Transit Custom (white commercial van)
- **Condition**: Work-worn but maintained
- **Paint**: Faded white, panel van design
- **Cosmetics**: Hand-painted business logo on side, missing side mirror
- **Sound**: Diesel engine, commercial cargo shift

**Stat Tie-Ins**
- Speed: 2/10 (cargo vehicle, top-heavy)
- Durability: 9/10 (built for abuse)
- Heat Generation: 4/10 (utility vehicle, not flashy)
- Check Engine Light Chance: 40% (commercial maintenance sporadic)
- Resale Value: $4,500 River Tokens
- Cargo Capacity: Highest (missions require transport)

**Satire Hook**: Protagonist uses for "leaf pickup" missions (stealth disguise).

**Godot Model Specs**: 10,500 tris, opening rear doors, interior cargo space modeled.

---

### 4.2 Vehicle Detail Standards

**Wheel Design**
- Unique rim designs per vehicle type.
- Tire wear visible (racing slicks for tuned Civic, all-season for Altima).
- Godot PhysicsBody3D + WheelJoint3D for suspension simulation.

**Window & Glass**
- Reflective shader: Mix of environment map + slight opacity.
- Tinted windows for luxury/gang vehicles.
- Dirty glass on older cars (dust particles, rain spots).

**Interior Detail**
- Dashboard visible through windshield (steering wheel, dashboard color).
- Luxury vehicles: Leather steering wheels, modern infotainment.
- Beater cars: Steering wheel cover, missing trim, visible wiring.

**Damage States**
- LOD0: Pristine → LOD1: Light scratches → LOD2: Heavy dents.
- Breakable headlights/taillights (gameplay mechanic—reduced visibility).
- Doors dent/crumple realistically (visual feedback).

**Physics Integration**
```gdscript
# Vehicle weight affects acceleration, braking
var weight: float = 1200  # kg (Civic) vs 2500 (Hummer)
var drag_coefficient: float = 0.32
var check_engine_chance: float = 0.35

# Dashboard indicates status
var check_engine_light_on: bool = randf() < check_engine_chance
var engine_power_modifier: float = 1.0 if !check_engine_light_on else 0.85
```

---

## 5. UI VISUAL STYLE

### 5.1 HUD Design Philosophy

**Core Principle**: "Functional Satire"—UI mimics game UI tropes but subverts them with Sacramento-specific humor.

**Visual Anchor**: Yellow-and-orange alerts (smog-era safety warnings), retro 90s computer graphics.

### 5.2 HUD Elements

#### **NIMBY Meter (Primary Heat System)**
**Design Concept**: Nextdoor app notifications, escalating drama.

```
Visual States:
  Level 1: 🟢 "A few concerned posts"
           — Single yellow notification bubble (corner of screen)
           — Text: "Local mom upset about noise"
           
  Level 2: 🟡 "Trending on Nextdoor"
           — Multiple notification bubbles stacking
           — Text: "40+ posts about disturbance"
           
  Level 3: 🟠 "City Council Aware"
           — Orange notification pulsing
           — Text: "Mayor's office fielded 100+ complaints"
           
  Level 4: 🔴 "Police Dispatched"
           — Red notification, loud alert sound
           — Cop car icon, siren animation
           
  Level 5: 💥 "NIMBY APOCALYPSE"
           — Screen fills with red Nextdoor posts
           — SacPD TANK visual warning
           — Text: "MILITARY GRADE RESPONSE INITIATED"
```

**Godot UI Implementation**
```gdscript
extends Control
class_name NIMBYMeterHUD

var nimby_level: int = 0
@onready var notification_container = VBoxContainer.new()

func update_nimby_level(new_level: int):
    nimby_level = new_level
    var colors = [Color.GREEN, Color.YELLOW, Color.ORANGE, Color.RED, Color.RED]
    var bg_color = colors[new_level - 1]
    notification_container.self_modulate = bg_color
    
    # Pulsing animation for high heat
    if new_level >= 3:
        var tween = create_tween()
        tween.set_loops()
        tween.tween_property(notification_container, "scale", Vector2(1.1, 1.1), 0.3)
        tween.tween_property(notification_container, "scale", Vector2(1.0, 1.0), 0.3)
```

**Visual Style**
- Font: Pixel art or retro sans-serif (like Ubuntu Mono, 8-bit feeling).
- Color: Transitions #FFD700 (gold/level 1) → #FF0000 (red/level 5).
- Info Text: Nextdoor joke headers ("Karen spotted at Trader Joe's").
- Icon: Small notification bell, Nextdoor logo parody.

---

#### **River Tokens Counter**
**Design Concept**: Currency aesthetic—gold coins, worn paper money, symbolic water drops.

```
Display:
  Icon: Stylized water droplet + dollar sign (hybrid symbol)
  Text: "River Tokens: 5,234"
  Color: #4A90E2 (water blue) + #FFD700 (gold highlight)
```

**Iconic Aesthetic**
- Worn paper textures (simulate worn currency).
- Coin stack visuals when earning/spending (particle feedback).
- Floating "+500 Tokens" popups when completing tasks.

**Godot Implementation**
```gdscript
@onready var tokens_label: Label
func update_tokens(amount: int):
    tokens_label.text = "River Tokens: %d" % amount
    # Particle burst on earn
    var particles = GPUParticles2D.new()
    # ... particle setup
    add_child(particles)
```

---

#### **Health Bar & Status Effects**
**Design Concept**: Minimalist health bar styled as "Chet's Condition."

```
Normal:     ▓▓▓▓▓▓▓▓▓░ (green #00AA00)
Damage:     ▓▓▓▓░░░░░░ (yellow #FFDD00 when < 50%)
Critical:   ▓░░░░░░░░░ (red #FF3333 when < 25%)

Status Effects (small icons above bar):
  🔥 Heatstroke (orange icon—overheating)
  🤧 Allergy (blue snot bubble icon—spring sneezing)
  💤 Exhaustion (sleeping Z icon—low stamina)
  🚔 Wanted (police star—NIMBY heat)
```

**Godot Implementation**
```gdscript
extends ProgressBar
class_name HealthBar

func apply_status_effect(effect: String):
    var status_icon = TextureRect.new()
    # Load icon based on effect
    status_container.add_child(status_icon)
```

---

#### **Minimap**
**Design Concept**: Satellite view of Sacramento with district overlays.

```
Features:
  - Circular minimap (bottom-right corner)
  - District color coding (matching mood board)
  - Player icon (downward arrow—top-down perspective)
  - Objective markers ("X marks the spot" style)
  - Road network (faint grid)
  - Heat hotspots (red glow—cop locations)
```

**Colors by District**
- The Trenches: #8B4513 (rust brown)
- Snob 40s: #FFD700 (gold)
- Hoe Strip: #FF1493 (neon pink)
- Downtown: #808080 (gray)
- The Wilds: #6B8E23 (olive green)

---

### 5.3 Main Menu & Pause Screen Design

**Visual Style**: Retro California DMV aesthetics—bureaucratic, slightly disheveled.

**Main Menu Mockup**
```
┌─────────────────────────────────┐
│   CITY OF VULTURES              │
│   Sacramento, California         │
│                                 │
│   [ NEW GAME ]                  │
│   [ LOAD GAME ]                 │
│   [ OPTIONS ]                   │
│   [ CREDITS ]                   │
│   [ QUIT ]                      │
│                                 │
│   "Come for the farm-to-fork,   │
│    stay because your catcon     │
│    was stolen."                 │
└─────────────────────────────────┘
```

**Typography**
- Header: GMod-style impact font (bold, yellowish).
- Body: Clean sans-serif (Arial/Helvetica equivalent).
- Accent: Pixel font for number displays (River Tokens, NIMBY Level).

**Background**: Blurred screenshot of Sacramento haze (perpetual 4 PM).

---

### 5.4 Dialogue UI & Dialogue Wheel

**Design Concept**: Branching dialogue tree styled as "Chet's Internal Monologue."

```
Dialogue Presentation:
  - Character portrait (top-left, 256x256px)
  - Dialogue text (center, word-wrapped RichTextLabel)
  - Choice wheel (bottom, radial menu):
    ○ Aggressive Response (red)
    ○ Compliant Response (blue)
    ○ Sarcastic Response (yellow)
    ○ Karen Rage (special—purple)
```

**Godot DialogueController**
```gdscript
class DialogueOption:
    var text: String
    var color: Color
    var icon: Texture2D
```

---

## 6. ENVIRONMENTAL STORYTELLING

### 6.1 Asset Design Guidelines

**Philosophy**: Details whisper narrative—every object earns its place through visual storytelling.

#### **Graffiti as Historical Record**
**Design Approach**: Layers tell history of territory conflicts, cultural shifts.

```
Layer 1 (Bottom):     Old 90s tags (#FF6B35 orange spray paint)
Layer 2 (Middle):     2010s tags (#FFD700 gold, stylized)
Layer 3 (Top):        Current/Active tags (#00FFFF cyan, SoundCloud rapper names)
Protective Murals:    Local artist murals covering tags (respect/community)
```

**Specific Examples**
- Building wall: "TREÑCH KINGS" (gang territory marker).
- Underpass: Stylized mural of Sacramento king (dated 2005).
- Storefront: "HELP WANTED - APPLY WITHIN" (handwritten, faded).

**Godot Implementation**: Decal shaders overlay graffiti textures without additional geometry.

---

#### **Political Signage as Social Commentary**
**Design Types**
```
Yard Signs (The Snob 40s):
  - "VOTE NO ON MEASURE C" (HOA property tax increase)
  - "SUPERVISED VISITATION PROTECTED AREA" (custody battle jokes)
  - "THIS LAWN TREATED WITH PESTICIDES" (legal warning, ironic excess)

Street Signs (The Trenches):
  - "POLICE HAVE BEEN CALLED" (permanent warning sign)
  - "COMMUNITY JUSTICE ZONE—NO NARCS" (hand-painted)
  - Recall governor signs (weathered, multiple candidates)

Business Signs (Downtown):
  - "OFFICE SPACE FOR LEASE—CALL 1999" (outdated phone)
  - Boarded storefronts: "CLOSED DUE TO CIRCUMSTANCES"
  - "COMING SOON" (painted 15 years ago, never opening)
```

**Visual Execution**: Hand-painted fonts on cheap plywood/cardboard (low-fidelity aesthetic).

---

#### **Broken Infrastructure as World-Building**
**Pothole Design**
```
Visual Spec:
  - Irregular shape (not perfect circles)
  - Cracked asphalt edges (jagged)
  - Dark shadow interior (depth perception)
  - Visible dirt/water inside (realism)
  - Size: Playable hazards (stops traffic, slows combat)

Godot Physics:
  - Trigger Area3D detects player/vehicle entry
  - Applies downward impulse (bounce/sink effect)
  - Damage player/vehicle if large enough
  - Particle effect on collision (dust cloud)
```

**Missing Manhole Covers**
```
Visual: Circular pit exposing sewer/utility infrastructure
Dangers: Falling hazard, NPC dialogue ("Watch the hole!")
Sound: Metallic echo when struck
Gameplay: Narrative justification for infrastructure rot
```

---

#### **Visible Economic Disparity**
**The Snob 40s → The Trenches Transition Zone**
```
Snob 40s Side:
  - Perfect curbs (fresh paint)
  - Manicured grass
  - Clean sidewalks
  - Visible security cameras

Transition (property line):
  - Abrupt color shift in asphalt (different repair eras)
  - Vegetation suddenly unkempt
  - Trash accumulation begins
  - Signs of gentrification resistance ("LUXURY HOUSING = DISPLACEMENT")

The Trenches Side:
  - Overgrown grass/weeds
  - Broken sidewalk
  - Trash, debris
  - No security (abandoned cameras)
```

**Godot Implementation**: Separate material/texture sets swapped across district boundaries.

---

### 6.2 Asset Checklist for Modelers

**High Priority (Milestone 5)**
- [ ] Chet Miller base mesh + rig (4,500 tris)
- [ ] Karen NPC (3,200 tris)
- [ ] Gang Kid NPC (2,800 tris)
- [ ] Honda Civic (8,500 tris)
- [ ] Tesla Model 3 (12,000 tris)
- [ ] Hummer H2 (15,000 tris)
- [ ] 2004 Nissan Altima (7,200 tris)
- [ ] Transit Van (10,500 tris)
- [ ] The Trenches district (modular buildings: 50k tris)
- [ ] The Snob 40s mansion block (75k tris)
- [ ] The Wilds levee section (40k tris)
- [ ] Homeless encampment tents (variable LOD)

**Medium Priority**
- [ ] Radio station interior (Downtown K Street)
- [ ] Loaves & Fishes shelter (detailed exterior)
- [ ] Strip clubs on Hoe Strip (neon signs, entrance)
- [ ] Police tank variant (SacPD military vehicle)

**Low Priority (Post-Launch)**
- [ ] Governor cameo location (hair salon interior)
- [ ] Tower Records landmark (exterior detail)
- [ ] Light rail station (architecture detail)

---

## 7. LIGHTING & MOOD SYSTEM

### 7.1 Godot Forward+ Rendering Strategy

**DirectionalLight3D Configuration** (Primary Sun)
```gdscript
# Base sun at 4 PM angle (perpetual smog-sunset)
$DirectionalLight3D.rotation_degrees = Vector3(60, -45, 0)  # 4 PM angle
$DirectionalLight3D.light_energy_lux = 80000  # Strong Sacramento sun
$DirectionalLight3D.light_color = Color("#FFE4B5")  # Warm, dust-laden

# Shadows for depth & silhouettes
$DirectionalLight3D.shadow_enabled = true
$DirectionalLight3D.directional_shadow_mode = 3  # SHADOW_CASCADED
$DirectionalLight3D.directional_shadow_split_1 = 0.1
$DirectionalLight3D.directional_shadow_split_2 = 0.5
$DirectionalLight3D.directional_shadow_split_3 = 0.9
```

**Environment Ambient Lighting**
```gdscript
var env = WorldEnvironment.new()
var environment = env.environment

# Ambient light mimics scattered skylight
environment.ambient_light_source = Environment.AMBIENT_LIGHT_SKY
environment.ambient_light_energy = 1.2
environment.ambient_light_sky_contribution = 0.8

# Fog creates atmospheric depth (air quality effect)
environment.volumetric_fog_enabled = true
environment.volumetric_fog_density = 0.15
environment.volumetric_fog_air_density = 0.5
environment.volumetric_fog_emission = Color("#FFAA44") * 0.1
environment.volumetric_fog_emission_energy_multiplier = 1.0
```

**Reflection Probes** (for shiny surfaces: windows, vehicles)
```gdscript
var reflection_probe = ReflectionProbe.new()
reflection_probe.box_projection = true
reflection_probe.size = Vector3(50, 50, 50)  # Update frequency zone
# Place strategically around: mansions, car lots, downtown buildings
```

---

### 7.2 District-Specific Lighting

#### **The Trenches**
```
Primary Light: Harsh streetlight (sodium-vapor) casting long shadows
Time-Based: Morning—hard shadows; Afternoon—softer diffuse
Color Temp: Warm yellow (#FFAA33) mixed with harsh shadows
Secondary: Utility lights on buildings (flickering, inconsistent)
Nighttime: Very dark (high crime = budget streetlights); isolated light pools

Shaders: Add slight chromatic aberration to streetlights (poor electrical systems)
```

#### **The Snob 40s**
```
Primary Light: Clean sunlight, no haze (manicured air quality)
Time-Based: Consistent brightness (HOA-mandated landscape lighting)
Color Temp: Neutral white (#FFFFFF) with slight color-graded warmth
Secondary: Uplighting on mansions (theatrical, wasteful)
Nighttime: Well-lit (security systems); visible patio heaters, fire features

Shaders: High-polish reflection on windows, gates, vehicle paint
```

#### **The Hoe Strip**
```
Primary Light: Neon signs dominate nighttime
Time-Based: Day—harsh shadows; Night—neon replaces sun
Color Temp: Saturated pinks (#FF1493) and cyans (#00FFFF)
Secondary: Cheap fluorescent interior lights (buzzing, flickering)
Nighttime: Neon requires emission maps; create god-rays through fog

Shaders: Flickering shader for broken neon tubes; transparency for window displays
```

#### **Central Hub (Downtown)**
```
Primary Light: Flat, diffuse (concrete reflects light uniformly)
Time-Based: Morning—depressing gray; Afternoon—slightly better
Color Temp: Cool gray (#C0C0C0) with very slight warm filter
Secondary: Office lights in windows (random occupied/unoccupied)
Nighttime: Few lights (budget issues); eerie emptiness

Shaders: Expose lights in office windows (dynamic switching)
```

#### **The Wilds**
```
Primary Light: Dappled sunlight through trees (forest effect)
Time-Based: Early AM—silvery fog; Afternoon—warm dapples; Dusk—golden
Color Temp: Cool morning (#E0F6FF) → warm gold (#FFE4B5) → deep blue night
Secondary: Fire rings from encampments (dynamic, flickering)
Nighttime: Very dark with moon; campfire is primary light source

Shaders: Tree canopy transparency shader; volumetric light rays through fog
```

---

### 7.3 Volumetric Fog Implementation

**Purpose**: Air quality as visual metaphor (Sacramento smog).

```gdscript
# Fog density increases during heat events
var base_fog_density = 0.15
var heat_event_fog_density = 0.25  # Haze intensifies with summer heat

# Fog color shifts with time-of-day
func update_fog_color(time_of_day: float):
    var hour = fmod(time_of_day, 24.0)
    var haze_color: Color
    
    if hour < 6 or hour > 20:
        haze_color = Color("#1a1a3e")  # Cool night blue
    elif hour < 12:
        haze_color = Color("#FFB84D")  # Morning amber
    elif hour < 18:
        haze_color = Color("#FF8C42")  # Afternoon orange
    else:
        haze_color = Color("#FF6B35")  # Sunset red
    
    environment.volumetric_fog_emission = haze_color * 0.1
```

**Gameplay Integration**: Fog density affects visibility (missions in dense fog = harder navigation).

---

### 7.4 Dynamic Lighting Events

**Heatwave Effect**
```
Trigger: Summer season (in-game)
Visual: Screen tint orange (#FF6B35)
Fog Density: Increase to 0.25
Volumetric Fog: Intensify yellow emission
Audio: Crackling electricity (power strain sounds)
Gameplay: Health drain if Chet outside without hydration
```

**Police Response Lighting**
```
Trigger: NIMBY Level 4–5
Visual: Flashing red/blue siren lights cast on nearby buildings
Fog: Strobe effect through volumetric fog (god-rays effect)
Duration: 30–60 seconds per police vehicle proximity
Shader: Custom strobe pattern (not constant, realistic siren cycle)
```

**The Beam Event** (Tower/Laser)
```
Trigger: Sacramento Kings playoff victory
Visual: Massive purple laser shoots skyward (volumetric god-ray)
Effect: Blinds player (screen white-out for 2 seconds)
Physics: AI traffic causes pileup in laser's shadow
Audio: Laser hum + car crash sounds
Narrative: News reports damage on next radio broadcast
```

---

### 7.5 Lighting Performance Optimization

**Draw Call Reduction**
```
Strategy: Bake shadows in pre-made levels (lightmaps)
Implementation:
  - Mark static geometry for baking
  - Bake DirectionalLight shadows (24h cycle → static map)
  - Runtime lights only for: moving vehicles, dynamic events, player actions

Godot Settings:
  gi_probes_enabled = true  # VoxelGI for faster indirect light
  use_occlusion_culling = true  # Cull off-screen lights
```

**Godot Profiler Targets**
- Lighting pass: < 3ms (GPU time)
- Shadow updates: < 2ms (cascaded shadows)
- Volumetric fog: < 2ms (samples per frame)

---

## 8. ART PRODUCTION PIPELINE

### 8.1 Asset Submission Checklist

**For 3D Character Models**
```
✓ FBX/GLBX format (verified in Godot import)
✓ Named skeleton rig (bones: Armature.Skeleton3D.Bone[i])
✓ Texture maps:  Diffuse (sRGB), Normal (OpenGL), ORM (packed)
✓ Materials: StandardMaterial3D ready (no custom shaders)
✓ LOD variants (0, 1, 2 with clear naming)
✓ Positioned at origin (0, 0, 0)
✓ Scale: 1:1 meter = 1 Godot unit
✓ Vertex color (if used for variation, documented)
✓ No triangles > 180° (avoid inverted normals)
✓ UV seams hidden in inconspicuous places
```

**For Environments / Architecture**
```
✓ Modular sections (buildings tiled via GridMap or instances)
✓ Collision geometry (separate from visual mesh)
✓ Texture atlases (max 2K resolution)
✓ Decal-compatible surfaces (graffiti, weathering)
✓ NavMesh-compatible floor geometry
✓ Performance budget met (50k tris max per "block")
✓ Named groups: "Roof", "Walls", "Doors" for material overrides
```

**For VFX & Particles**
```
✓ GPUParticles3D templates (.tres files)
✓ Emission shapes defined (cone, sphere, box)
✓ Lifetime profiles (acceleration, fade-out)
✓ Texture atlases (if animated particles)
✓ Collision-aware (raycast, sphere cast)
```

---

### 8.2 Workflow Integration with Godot

**Scene Template (Character)**
```gdscript
# template_character.tscn structure
- Node3D  [CharacterName]
  - Skeleton3D
    - BoneAttachment3D (Armature)
  - MeshInstance3D (with StandardMaterial3D)
  - CollisionShape3D (CapsuleShape3D for body)
  - AnimationPlayer (animations folder)
  - StateChartNode (AI behavior tree)
```

**Scene Template (Vehicle)**
```gdscript
# template_vehicle.tscn structure
- Node3D  [VehicleName]
  - VehicleBody3D (parent physics body)
    - MeshInstance3D (chassis)
    - WheelJoint3D × 4 (suspension)
    - CollisionShape3D (bounding box)
    - AudioStreamPlayer3D (engine sound)
    - GPUParticles3D (exhaust fumes)
    - [Optional] WindshieldCamera3D (driver view)
```

---

### 8.3 Review Criteria (Art Director Sign-Off)

**Visual Quality Checks**
- [ ] Silhouette clarity at 30+ meters distance
- [ ] Textures display correctly in-engine (no inverted colors, misaligned UVs)
- [ ] Lighting reacts properly (specular highlights on metallic surfaces, diffuse on fabric)
- [ ] LOD transitions are smooth (no pop-in, no jitter)
- [ ] Performance: Profiler shows asset under budget

**Stylistic Consistency Checks**
- [ ] Character archetype recognizable at a glance
- [ ] Environmental detail supports satirical tone (not gritty, not cartoon—in-between)
- [ ] District color palette applied correctly
- [ ] No assets copying competitor games (originality check)

**Integration Checks**
- [ ] Asset imports without errors
- [ ] Collision geometry matches visual bounds
- [ ] Animation rigs compatible with motion capture (if applicable)
- [ ] Shader parameters exposed for dynamic tuning

---

## 9. APPROVED COLOR HEX PALETTES (Quick Reference)

### Global
```
Sky Zenith:        #FFD89B
Sky Horizon:       #FF8C42
Fog Emission:      #FFAA44
Shadow:            #1A1A1A
Ground Reflection: #DEB887
```

### The Trenches
```
Asphalt:      #4A4A4A
Rust:         #8B4513
Graffiti:     #FF6B35
Shadow:       #2A2A2A
Hope Accent:  #87CEEB
```

### The Snob 40s
```
Lawn:        #90EE90
Siding:      #F5DEB3
Gold:        #FFD700
Door Red:    #8B0000
Pure White:  #FFFAFA
```

### The Hoe Strip
```
Neon Pink:   #FF1493
Neon Cyan:   #00FFFF
Brick:       #6B4423
Wet Asphalt: #3A3A3A
Streetlight: #FFAA33
```

### Downtown
```
Concrete:   #808080
Patina:     #5F8A5C
Teal Trim:  #5F9999
Black:      #1A1A1A
Beige Govt: #D4C5A9
```

### The Wilds
```
River:      #654321
Vegetation: #6B8E23
Tarp:       #4B5885
Levee:      #A9A9A9
Turkey:     #8B4513
```

### NPCs
```
Karen Pink:       #FFB6C1
Karen Cyan:       #E0FFFF
Gang Kid Gold:    #FFD700
Gang Kid Dark:    #2F4F4F
Gang Kid Red:     #FF6347
```

### UI
```
NIMBY Level 1: #00AA00 (Green)
NIMBY Level 2: #FFDD00 (Yellow)
NIMBY Level 3: #FF8800 (Orange)
NIMBY Level 4: #FF3333 (Red)
NIMBY Level 5: #990000 (Dark Red)
River Tokens:  #4A90E2 (Water Blue)
```

---

## 10. NEXT STEPS & APPROVAL

### Immediate Actions (Week 1–2)
1. **Asset Broker Assignment**: Assign modelers to character/vehicle/environment pipelines.
2. **Texture Library Setup**: Create shared texture sets (metal, wood, concrete, fabric, paint).
3. **Shader Template Library**: Establish StandardMaterial3D presets for quick material creation.
4. **Lighting Reference Scene**: Create empty district blocks with lighting pre-configured.

### Milestone 5 Deliverables
- [ ] Chet Miller + animations (6–8 idle/walk/run/combat states)
- [ ] 5 NPC archetypes (Karen, Gang Kid, Sage, Bro, Guard)
- [ ] 5 drivable vehicles with physics integrated
- [ ] The Trenches and Snob 40s districts (playable blocks)
- [ ] HUD mockups (NIMBY Meter, River Tokens, Health)
- [ ] Lighting system tested across all districts
- [ ] Art Direction document approved (this document)

### Review Schedule
- **Week 1**: Character art review (Chet + 2 NPCs)
- **Week 2**: Vehicle design review (3 vehicles)
- **Week 3**: Environment art review (district blocks)
- **Week 4**: Integrated scene review (all assets in-engine)
- **Week 5**: Final art polish & optimization pass

---

## 11. REFERENCES & INSPIRATIONAL MEDIA

| Media | Lesson |
|-------|--------|
| GTA-V | Environmental detail density, district flavor, vehicle mechanics |
| Saints Row (2006) | Satirical character archetypes, over-the-top missions |
| Trailer Park Boys | Caricatured characters, lived-in decay aesthetic |
| South Park (Game | Stylized character design, political satire integration |
| It Takes Two | Whimsy in mundane spaces, environmental storytelling |
| What Remains of Edith Finch | Intimate environmental storytelling, subtle narrative |

---

## DOCUMENT APPROVAL

**Art Director**: [Signature/Approval Date]  
**Producer**: [Signature/Approval Date]  
**Lead Modeler**: [Signature/Approval Date]  

**Version History**
| Version | Date | Changes |
|---------|------|---------|
| 1.0 | April 20, 2026 | Initial Art Direction document |

---

**END OF ART DIRECTION DOCUMENT**

---

## Appendix A: Color Swatch Sheet (For Print Reference)

```
THE TRENCHES PALETTE:          THE SNOB 40s PALETTE:
┌──────────────────────┐       ┌──────────────────────┐
│ █ #4A4A4A Asphalt    │       │ █ #90EE90 Lawn       │
│ █ #8B4513 Rust       │       │ █ #F5DEB3 Siding     │
│ █ #FF6B35 Graffiti   │       │ █ #FFD700 Gold       │
│ █ #2A2A2A Shadow     │       │ █ #8B0000 Red Door   │
│ █ #87CEEB Hope       │       │ █ #FFFAFA White      │
└──────────────────────┘       └──────────────────────┘

THE HOE STRIP PALETTE:         DOWNTOWN PALETTE:
┌──────────────────────┐       ┌──────────────────────┐
│ █ #FF1493 Neon Pink  │       │ █ #808080 Concrete   │
│ █ #00FFFF Neon Cyan  │       │ █ #5F8A5C Patina     │
│ █ #6B4423 Brick      │       │ █ #5F9999 Teal      │
│ █ #3A3A3A Wet Road   │       │ █ #1A1A1A Black      │
│ █ #FFAA33 Streetlt   │       │ █ #D4C5A9 Bio Govt   │
└──────────────────────┘       └──────────────────────┘

THE WILDS PALETTE:
┌──────────────────────┐
│ █ #654321 River      │
│ █ #6B8E23 Vegetation │
│ █ #4B5885 Tarp       │
│ █ #A9A9A9 Levee      │
│ █ #8B4513 Turkey     │
└──────────────────────┘
```

