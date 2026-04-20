# City of Vultures

## Overview

**City of Vultures** is an open-world, third-person action-comedy game that parodies the "gritty" crime genre by transplanting it into the unique, often-overlooked chaos of California's capital, Sacramento. Players control Chet "The Gent" Miller, a suburban transplant stranded in Del Paso Heights after a failed crypto-scam. To escape the "916," Chet must navigate crumbling infrastructure, aggressive turkeys, and the most confusing light rail system in the world.

This game is built using the Godot Engine version 4.6.2, leveraging its powerful 3D capabilities, scripting in GDScript, and modular architecture for an immersive satirical experience.

## Features

- **Open-World Exploration**: Navigate a condensed, satirical version of Sacramento, featuring diverse districts like The Trenches (Del Paso Heights), The Snob 40s, The Hoe Strip, Central Hub, and The Wilds.
- **Unique Gameplay Mechanics**:
  - Vehicle Physics with random "Check Engine" failures.
  - NIMBY Meter heat system, escalating from Nextdoor posts to SacPD Tank chases.
  - River Tokens economy earned through recycling, street vending, or political influence.
- **Satirical Missions**: Engage in quests like evading scooter gangs, robbing mansions, recruiting "employees," and navigating homeless encampments.
- **Dynamic Environments**: Climate Engine with seasonal effects (e.g., heatstroke in summer, allergies in spring) and local references like the Beam laser and feral turkeys.
- **Radio Stations**: Immersive audio with stations like 91.6 The Bridge (smooth jazz with ads), K-RAP (traffic rhymes), and Aggie Talk (student complaints).
- **Art Style**: Sun-Bleached Noir with hazy lighting, caricatured characters, and a perpetual smog-sunset vibe.

## Installation and Setup

### Prerequisites
- Godot Engine 4.6.2 (download from [godotengine.org](https://godotengine.org/))
- Basic knowledge of GDScript for scripting

### Steps
1. Clone the repository:
   ```
   git clone https://github.com/xGameBuilder/City-of-Voltures-AAA-Game-Title-.git
   cd City-of-Voltures-AAA-Game-Title-
   ```

2. Open the project in Godot 4.6.2:
   - Launch Godot.
   - Select "Import" and choose the `project.godot` file (to be created in the project root).

3. Install dependencies (if any):
   - The project uses Godot's built-in modules. No external dependencies required.

4. Run the game:
   - Press F5 or click the play button in Godot's editor.

### Development Setup
- Use Godot's scene system for level design.
- Scripts are in GDScript; place them in the `scripts/` folder.
- Assets (models, textures) should be organized in `assets/`.

## Project Structure
```
City-of-Voltures-AAA-Game-Title-/
├── IDEA.md                 # Original game concept
├── README.md               # This file
├── AGENTS.md               # Character and agent documentation
├── GameDesignDocument.md   # Detailed GDD
├── project.godot           # Godot project file (to be created)
├── assets/                 # Game assets (models, textures, sounds)
├── scenes/                 # Godot scenes
├── scripts/                # GDScript files
├── agent/                  # AI agent related code
│   └── src/
└── ...
```

## Contributing
Contributions are welcome! Please follow these steps:
1. Fork the repository.
2. Create a feature branch: `git checkout -b feature/your-feature`.
3. Commit changes: `git commit -m 'Add your feature'`.
4. Push to the branch: `git push origin feature/your-feature`.
5. Open a Pull Request.

Ensure code follows Godot best practices and includes comments.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Credits
- Concept and Design: Based on IDEA.md
- Engine: Godot 4.6.2
- Inspiration: Sacramento's unique culture and chaos

For more details, see the [Game Design Document](GameDesignDocument.md) and [Agents Documentation](AGENTS.md). 
