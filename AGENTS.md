# Memo to Code Agents: City of Vultures Development

**Date**: April 20, 2026  
**Project**: City of Vultures - Open-World Action-Comedy Game  
**Engine**: Godot 4.6.2  

## Purpose
This memo provides context, technical guidelines, and coding standards for all code agents contributing to the development of **City of Vultures**. As AI-driven development assistants, agents must adhere to these standards to ensure consistent, maintainable, and performant code. The game is built on Godot 4.6.2, focusing on satirical gameplay in a Sacramento setting.

## Project Overview
- **Genre**: Open-world third-person action-comedy.
- **Core Features**: Vehicle physics, NIMBY Meter heat system, River Tokens economy, dynamic environments, satirical missions.
- **Target Platform**: PC (primary), with potential for consoles.
- **Key Mechanics**: Player-controlled Chet Miller, AI NPCs (e.g., feral turkeys, gang kids), environmental interactions.

Agents should reference [GameDesignDocument.md](GameDesignDocument.md) for gameplay details and [IDEA.md](IDEA.md) for original concept.

## Technical Stack
- **Engine**: Godot 4.6.2 (use latest stable features; avoid deprecated APIs).
- **Scripting**: Primary language is GDScript. Use C# only for performance-critical sections (e.g., complex AI).
- **Architecture**: Scene-based; modular nodes for reusability.
- **Physics**: Bullet physics for vehicles, collisions, and ragdolls.
- **Rendering**: Forward+ renderer; optimize with LOD and instancing.
- **AI**: NavigationServer3D for pathfinding; state machines for behaviors.
- **Audio**: Godot's AudioStreamPlayer for radio and SFX.
- **Version Control**: Git; commit frequently with descriptive messages.

## Coding Standards
### General
- **Readability**: Code must be self-documenting. Use clear variable/function names.
- **Comments**: Add comments for complex logic; use Godot's docstrings for functions.
- **Modularity**: Break code into small, reusable functions/classes.
- **Error Handling**: Use assertions and logging for debugging; avoid silent failures.
- **Performance**: Profile with Godot's debugger; aim for 60 FPS on target hardware.

### GDScript Specific
- **Naming Conventions**:
  - Variables: snake_case (e.g., `player_health`).
  - Functions: snake_case (e.g., `calculate_damage()`).
  - Classes/Scenes: PascalCase (e.g., `PlayerController`).
  - Constants: ALL_CAPS (e.g., `MAX_HEALTH`).
- **Structure**: Use class-based scripts; inherit from Node types appropriately.
- **Signals**: Use Godot signals for decoupling (e.g., `emit_signal("player_damaged", damage)`).
- **Resources**: Store data in Resource files (.tres); avoid hardcoding values.
- **Scenes**: Organize scenes hierarchically; use instancing for prefabs.

### File Organization
- **Scripts**: Place in `scripts/` subfolders (e.g., `scripts/agents/`, `scripts/mechanics/`).
- **Scenes**: `scenes/` with subfolders for levels/agents.
- **Assets**: `assets/` for models/textures/audio.
- **Agent Folder**: `agent/src/` for AI agent-specific code (if applicable).

### Best Practices
- **Testing**: Implement unit tests for core functions using Godot's testing framework.
- **Versioning**: Pin Godot version; update dependencies carefully.
- **Collaboration**: Use Git branches for features; merge via PRs.
- **Security**: Avoid exposing sensitive data; sanitize inputs.
- **Accessibility**: Ensure code supports subtitles, adjustable settings.

## Agent Responsibilities
- **Exploration Agents**: Gather context from docs; suggest improvements.
- **Coding Agents**: Implement features per GDD; follow standards.
- **Testing Agents**: Validate code; run builds and checks.
- **Documentation Agents**: Update docs as code evolves.

Agents must validate changes: Run builds/tests after edits. If issues arise, iterate fixes (up to 3 attempts) and document root causes.

## Integration Guidelines
- **Game Agents (NPCs)**: Implement AI as described in the original AGENTS.md concept (e.g., state machines for turkeys).
- **Player Systems**: Ensure Chet's abilities (e.g., Karen Rage) integrate with physics.
- **World Building**: Use procedural elements for districts; optimize for open world.

For questions, reference this memo or query the project lead. Let's build an epic satirical game!

**End of Memo**