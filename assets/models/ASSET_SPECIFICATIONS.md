# City of Vultures - 3D Asset Specifications (Milestone 5)

## Art Direction: "Sun-Bleached Noir"
- **Lighting**: Hazy yellow ambience, strong sun saturation
- **Style**: Caricatured human models, exaggerated features
- **Aesthetic**: Sacramento urban decay meets suburban excess
- **Tone**: Satirical, darkly comedic

---

## CHARACTER MODELS (3000-5000 tris)

### 1. Chet Miller (Main Character)
**Appearance**: Suburban transplant, 40s, athletic build
- Clean-cut haircut, light polo/casual shirt, khaki shorts
- Confident posture, slightly bewildered expression
- T-pose (arms extended 90°)
**Specifications**:
- Tris: 4200 (HIGH), 2800 (MED), 1200 (LOW)
- Bones: 55+ (full body rig with hand IK)
- Materials: Skin (caricatured), Fabric (polo), Shorts
- Textures: 2K albedo, normal, roughness/metallic
- Export: ChetMiller_HIGH.glb, ChetMiller_MED.glb, ChetMiller_LOW.glb

### 2. Karen NPC
**Appearance**: Wealthy suburban woman, 50s, sharp features
- Blonde highlighted hair, designer sunglasses/visor
- Athletic wear (yoga pants, tank top)
- Scowling expression, judgmental posture
**Specifications**:
- Tris: 3800 (HIGH), 2500 (MED), 1000 (LOW)
- Bones: 55+ (full humanoid rig)
- Materials: Skin, Athleisure fabric, Accessories
- Textures: 2K PBR
- Export: Karen_HIGH.glb, Karen_MED.glb, Karen_LOW.glb

### 3. Gang Kid NPC
**Appearance**: Urban youth, 20s, street fashion
- Backwards baseball cap, oversized hoodie, baggy jeans
- Sneakers (colorful), chain accessories
- Casual stance
**Specifications**:
- Tris: 3500 (HIGH), 2400 (MED), 950 (LOW)
- Bones: 55+ (humanoid rig)
- Looser topology (baggy clothing)
- Materials: Fabric (matte), Metal (chains)
- Export: GangKid_HIGH.glb, GangKid_MED.glb, GangKid_LOW.glb

### 4. Civilian NPC
**Appearance**: Generic middle-aged person, neutral clothing
- Jeans, t-shirt, neutral colors
- Realistic but caricatured
- Neutral expression
**Specifications**:
- Tris: 3200 (HIGH), 2200 (MED), 850 (LOW)
- Bones: 55+ (standard humanoid rig)
- Generic materials
- Export: Civilian_HIGH.glb, Civilian_MED.glb, Civilian_LOW.glb

### 5. Feral Turkey (Enemy)
**Appearance**: Wild turkey, aggressive pose, Sacramento urban
- Puffed feathers, angry expression
- Dark iridescent plumage with rust/bronze tones
- Talons emphasized
**Specifications**:
- Tris: 3000 (HIGH), 1800 (MED), 700 (LOW)
- Bones: 30+ (quadruped + head/neck)
- Materials: Feathers (metallic iridescent), Skin, Talons
- Export: Turkey_HIGH.glb, Turkey_MED.glb, Turkey_LOW.glb

---

## VEHICLE MODELS (2000-3000 tris total)

### 6. Honda Civic (Economy)
**Appearance**: 2000s-2010s Civic, slightly worn, Sacramento plates
- Practical family car, modest appearance
- Small dents/wear, sun-faded paint
- Basic interior (steering wheel, seats visible)
**Specifications**:
- Tris: 2800 (HIGH), 1900 (MED), 800 (LOW)
- Materials: Paint (matte with imperfections), Chrome, Rubber
- Interior: Minimal (cockpit only, no backseat detail)
- Textures: 2K albedo, normal, roughness/metallic
- Export: HondaCivic_HIGH.glb, HondaCivic_MED.glb, HondaCivic_LOW.glb

### 7. Tesla Model 3 (Eco-friendly)
**Appearance**: Modern EV, sleek, slightly pretentious
- Minimalist design, smooth curves
- Spotless (owner maintains it obsessively)
- Futuristic interior
**Specifications**:
- Tris: 2600 (HIGH), 1800 (MED), 750 (LOW)
- Materials: Matte black/white paint, Glass, Minimalist interior
- Interior: Steering wheel, dashboard with futuristic UI
- Export: Tesla_HIGH.glb, Tesla_MED.glb, Tesla_LOW.glb

### 8. SUV (Suburban)
**Appearance**: Generic suburban SUV (Ford Explorer style)
- Large, imposing, practical
- Family-oriented, slightly worn
- Spacious interior visible
**Specifications**:
- Tris: 3000 (HIGH), 2000 (MED), 850 (LOW)
- Materials: Metal (paint), Rubber, Plastic interior
- Interior: Larger cabin, 3-row seating suggested
- Export: SUV_HIGH.glb, SUV_MED.glb, SUV_LOW.glb

### 9. Transit Van (Utility)
**Appearance**: Commercial transit van, white/beige, utilitarian
- Boxy, delivery-style, functional
- Minimal windows, side panels
- Simple interior
**Specifications**:
- Tris: 2200 (HIGH), 1600 (MED), 650 (LOW)
- Materials: Matte paint, bare metal
- Interior: Minimal (steering wheel, basic cabin)
- Export: TransitVan_HIGH.glb, TransitVan_MED.glb, TransitVan_LOW.glb

### 10. Hummer (Excess)
**Appearance**: Military-style Hummer, absurdly oversized
- Massive, angry grille, armor-like appearance
- Satirical Sacramento excess
- Oversized interior
**Specifications**:
- Tris: 3200 (HIGH), 2100 (MED), 900 (LOW)
- Materials: Matte black/camo, metal accents
- Interior: Spacious, aggressive styling
- Export: Hummer_HIGH.glb, Hummer_MED.glb, Hummer_LOW.glb

---

## ENVIRONMENTAL ASSETS

### 11. Modular Building (Low-Poly Prefab)
**Appearance**: Generic 3-4 story building, Sacramento style
- Repeating window patterns, weathered brick/stucco
- Ground floor retail, upper floor residential
- Graffiti variations
**Specifications**:
- Tris: 1500 per building module
- Variations: 4-5 different facades (swappable)
- Materials: Brick, Stucco, Weathered metal
- Texture: 2K albedo/normal
- Export: Building_Base.glb (with LOD variants)

### 12. Street Lamp Post
**Appearance**: Standard municipal street light
- Weathered pole, functional lamphead
- Sacramento style
**Specifications**:
- Tris: 600 (HIGH), 300 (LOW)
- Materials: Metal (rust), Glass, Plastic
- Export: StreetLamp.glb (with emissive light material)

### 13. Park Bench
**Appearance**: Worn wooden bench, metal frame
- Realistic wear and tear
- Graffiti option
**Specifications**:
- Tris: 800 (HIGH), 400 (LOW)
- Materials: Wood, Metal with rust
- Export: ParkBench.glb

### 14. Trash Can
**Appearance**: Municipal trash receptacle, dented
- Overflowed, weathered, graffitied
**Specifications**:
- Tris: 400 (HIGH), 200 (LOW)
- Materials: Metal (matte, rust)
- Export: TrashCan.glb

### 15. Palm Tree
**Appearance**: California desert palm, isolated/single
- Stylized foliage, skinny trunk
- Interactive destruction (breakable)
**Specifications**:
- Tris: 1200 (HIGH foliage), 600 (LOW)
- Materials: Bark, Leaf (double-sided)
- Export: PalmTree_HIGH.glb, PalmTree_LOW.glb

### 16. Dead Grass Clump
**Appearance**: Dry, brown vegetation cluster
- Low poly vegetation scatter
- Tiling base
**Specifications**:
- Tris: 200 per clump
- Materials: Dried plant matter (low specularity)
- Export: DeadGrass_01.glb, DeadGrass_02.glb, DeadGrass_03.glb

---

## DESTRUCTION & MISSION PROPS

### 17. Debris Pile
**Appearance**: Scattered broken plaster, concrete chunks
- Modular pieces for reusability
- Sacramento decay theme
**Specifications**:
- Tris: 500 per piece (3-5 variations)
- Materials: Concrete, Plaster, Dirt
- Export: Debris_01.glb through Debris_05.glb

### 18. Pothole
**Appearance**: Realistic street damage, Sacramento authenticity
- Asphalt chunk missing, exposed ground
- Used for environmental hazards
**Specifications**:
- Tris: 300 (HIGH), 150 (LOW)
- Materials: Asphalt, Dirt
- Export: Pothole_HIGH.glb, Pothole_LOW.glb

### 19. Graffiti Wall Section
**Appearance**: Tagged urban wall, colorful tags
- 2m x 2m tiling section
- Various color variations
**Specifications**:
- Tris: 600 (simple quad + detail geometry)
- Materials: Brick (base), Graffiti (decal overlay)
- Export: GraffitiWall_01.glb through GraffitiWall_03.glb

### 20. Briefcase
**Appearance**: Metal briefcase, River Tokens item
- Shiny, important looking
- Small prop for hand-holding
**Specifications**:
- Tris: 200
- Materials: Metal (polished), Leather handle
- Export: Briefcase.glb

### 21. Recycling Bin
**Appearance**: Blue residential recycling bin
- Standard design, operational prop
- Economy mission item
**Specifications**:
- Tris: 400
- Materials: Plastic (blue, weathered)
- Export: RecyclingBin.glb

### 22. Vending Machine
**Appearance**: Beverage vending machine, retro Sacramento style
- Interactive prop, can dispense drinks
- Damaged option
**Specifications**:
- Tris: 600 (HIGH), 350 (LOW)
- Materials: Metal frame, Glass front, Stickers
- Interior: Visible products
- Export: VendingMachine_HIGH.glb, VendingMachine_LOW.glb

---

## PBR MATERIAL SPECIFICATIONS

All assets must include:
- **Albedo (Color)**: 2K texture, sRGB color space
- **Normal Map**: 2K, tangent-space, DirectX format
- **Roughness**: 2K grayscale (0=shiny, 1=matte)
- **Metallic**: 2K grayscale (0=non-metal, 1=metal)

Optional:
- **Ambient Occlusion**: Baked into albedo or separate
- **Emission**: For light sources (lamp posts, vending machines)
- **Alpha Transparency**: For foliage, graffiti decals

---

## RIGGING SPECIFICATIONS (Characters Only)

### Standard Human Rig (55+ bones)
```
Root
├── Pelvis
│   ├── Spine
│   │   ├── Chest
│   │   │   ├── Left Shoulder → Left Arm (3 joints) → Left Hand (5 fingers)
│   │   │   └── Right Shoulder → Right Arm (3 joints) → Right Hand (5 fingers)
│   │   └── Neck → Head
│   ├── Left Leg (5 joints) → Left Foot
│   └── Right Leg (5 joints) → Right Foot
```

### Turkey Rig (30+ bones)
- Root → Pelvis (fused)
- Neck with multiple segments (flexible)
- Head with beak
- 4 legs, tail
- Wing bones (2 per side)

---

## EXPORT STANDARDS

### GLB Format (Binary GLTF)
- Single file with embedded textures
- Compress to <5MB per character, <3MB per vehicle
- Include all LOD variants as separate .glb files

### Naming Convention
```
{AssetName}_{QUALITY_LEVEL}.glb
Examples:
- ChetMiller_HIGH.glb (4200 tris)
- ChetMiller_MED.glb (2800 tris)
- ChetMiller_LOW.glb (1200 tris)
```

### LOD Levels
- **HIGH** (4K-8K viewing distance): Full detail, all features
- **MEDIUM** (8K-15K viewing distance): Reduced geometry, simplified textures
- **LOW** (15K+ viewing distance): Extreme simplification, 1K textures

---

## INTEGRATION INTO GODOT

1. **Import Settings**:
   - Root type: Node3D
   - Meshes → Ensure Tangents: ON
   - Materials → Import: ON
   - Reimport after texture changes

2. **Scene Templates** (see separate files):
   - Character scenes with AnimationPlayer nodes
   - Vehicle scenes with physics bodies
   - Environmental prop scenes with static bodies

3. **Material Override**:
   - StandardMaterial3D for PBR (Godot native)
   - Custom ShaderMaterial for special effects (sun-bleached look)

---

## PERFORMANCE TARGETS
- Character draw call: 1 (instanced materials)
- Vehicle draw call: 2-3 (body + interior + windows)
- Environment total: <500 draw calls per loaded district
- FPS target: 60 on mid-range GPU (GTX 1060 equivalent)

---

## TIMELINE & DELIVERABLES

**Phase 1 (Characters)**: 5 models + 3 LOD variants each = 20 files
**Phase 2 (Vehicles)**: 5 models + 3 LOD variants each = 20 files
**Phase 3 (Environment)**: 6 base types + variations = 15 files
**Phase 4 (Props)**: 6 models + LOD = 12 files

**Total**: ~67 .glb files, organized in assets/models/ with PBR textures

---

## REVISION & FEEDBACK

Asset creation follows an iterative process:
1. Initial AI generation (layout, proportions)
2. Manual refinement (topology, rigging)
3. Texture baking & PBR setup
4. Godot integration & LOD testing
5. Performance profiling & optimization
6. Art director feedback & revision rounds (2-3)

Expected completion: 2-3 weeks with full team, 4-6 weeks with AI + manual polish.
