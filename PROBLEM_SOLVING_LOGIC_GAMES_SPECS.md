# Problem-Solving & Logic Games Specifications

This document outlines the specifications for the "Problem-Solving & Logic Games" category within the CogniBoost application. These games are designed to stimulate and enhance logical thinking, strategic planning, problem-solving abilities, and reasoning skills.

## 1. Puzzle Games

This sub-category includes games that typically involve solving a problem with a well-defined solution, often through pattern recognition, logic, or completion of a structure.

### A. Sudoku

*   **Game Name:** Sudoku
*   **Core Concept:** Fill a 9x9 grid such that each column, each row, and each of the nine 3x3 subgrids (also called "boxes" or "regions") contain all of the digits from 1 to 9, without repetition in any row, column, or subgrid.
*   **Cognitive Skills Targeted:**
    *   Primary: Logical Thinking, Pattern Recognition, Deductive Reasoning.
    *   Secondary: Concentration, Problem-Solving, Working Memory.
*   **Gameplay Mechanics:**
    *   **Interface:** A 9x9 grid, with some cells pre-filled with digits.
    *   **Input:** User can select a cell and input a digit (1-9).
    *   **Validation:** The game can offer immediate validation (highlighting errors/conflicts) or validate upon completion.
    *   **Tools:** May include options for pencil marks (noting possible candidates in a cell), undo, and hints.
*   **Customizable Difficulty:**
    *   **Number of Pre-filled Cells:** Fewer pre-filled cells generally mean higher difficulty.
    *   **Symmetry:** Symmetrical puzzles are often aesthetically pleasing but don't directly correlate with difficulty.
    *   **Complexity of Logic Required:** Difficulty is determined by the types of logical techniques needed (e.g., hidden singles, naked pairs, X-wing).
    *   **Availability of Hints/Checks:** More assistance makes it easier.
*   **Success Metrics:**
    *   Time to completion.
    *   Number of errors made (incorrect entries).
    *   Use of hints or check functions.
    *   Completion of puzzle without errors.

### B. Crossword Puzzles / Word Games (General Category)

*   **Game Name:** Crossword Puzzles / Word Games
*   **Core Concept:** This category encompasses various games focused on vocabulary and word manipulation.
    *   **Crosswords:** Solve clues by fitting words into a grid of intersecting squares.
    *   **Word Searches:** Find hidden words within a grid of letters.
    *   **Anagrams/Jumbles:** Form words from a given set of letters.
    *   **Word Ladders:** Change one word into another by altering one letter at a time, with each intermediate step being a valid word.
*   **Cognitive Skills Targeted:**
    *   Primary: Vocabulary, Memory (semantic), Problem-Solving, Verbal Fluency.
    *   Secondary: Pattern Recognition, General Knowledge, Spelling.
*   **Gameplay Mechanics:**
    *   **Crosswords:** Grid, list of clues (across and down), text input for answers. Highlighting of selected clue and corresponding grid cells.
    *   **Word Searches:** Grid of letters, list of words to find. User highlights words found.
    *   **Anagrams:** Display of jumbled letters, input area for forming words.
    *   **Interface:** Clean, readable fonts, easy input methods (on-screen keyboard or system keyboard).
*   **Customizable Difficulty:**
    *   **Grid Size (Crosswords/Word Searches):** Larger grids are generally harder.
    *   **Clue Difficulty (Crosswords):** More cryptic or obscure clues increase difficulty.
    *   **Word Length/Obscurity (All types):** Longer or less common words.
    *   **Time Limits:** Optional time pressure.
    *   **Availability of Hints:** Revealing letters, words, or solving specific clues.
    *   **Theme (Crosswords/Word Searches):** Themed puzzles can be easier if the user knows the theme.
*   **Success Metrics:**
    *   Percentage of puzzle completed correctly.
    *   Time taken to complete.
    *   Number of correct words/letters found or placed.
    *   Use of hints.
    *   Score based on speed and accuracy.

## 2. Strategy Games

This sub-category includes games requiring foresight, planning, and making optimal decisions to achieve a specific goal, often involving resource management or navigating complex scenarios.

### A. Pirate Passage

*   **Game Name:** Pirate Passage
*   **Core Concept:** Players navigate a map to find treasure, planning optimal routes to collect rewards while avoiding obstacles, traps, or opponents (e.g., other pirates, sea monsters). Requires planning several moves ahead.
*   **Cognitive Skills Targeted:**
    *   Primary: Strategic Thinking, Planning, Problem-Solving, Forward Thinking.
    *   Secondary: Spatial Reasoning, Risk Assessment, Decision Making.
*   **Gameplay Mechanics:**
    *   **Interface:** A map displayed with islands, sea routes, treasure locations, player token, and potential hazards.
    *   **Movement:** Turn-based or path-drawing movement. Player selects next move or destination.
    *   **Obstacles:** May include fixed obstacles (reefs), moving opponents, or event-based hazards (storms).
    *   **Resources:** Could involve managing limited resources like moves per turn, fuel, or crew.
    *   **Goal:** Reach one or more treasure locations, possibly with the highest score or in the fewest turns.
*   **Customizable Difficulty:**
    *   **Map Complexity:** Larger maps, more complex routes, or hidden areas.
    *   **Number/Behavior of Obstacles/Opponents:** More hazards, or smarter AI for opponents.
    *   **Resource Limitations:** Tighter constraints on available resources.
    *   **Visibility of Map (Fog of War):** Parts of the map may be initially hidden.
    *   **Number of Treasures/Goals:** More items to collect or objectives to achieve.
*   **Success Metrics:**
    *   Efficiency of route (e.g., shortest path, fewest moves).
    *   Time taken or turns used.
    *   Amount of treasure collected / resources remaining.
    *   Successful avoidance of hazards or defeat of opponents.
    *   Score based on multiple factors.

### B. Masterpiece

*   **Game Name:** Masterpiece
*   **Core Concept:** Players assemble a complete image or fill a specific outline using a set of geometric shapes (e.g., Tangram-like pieces, jigsaw puzzle pieces, or custom mosaic tiles).
*   **Cognitive Skills Targeted:**
    *   Primary: Spatial Reasoning, Problem-Solving, Pattern Recognition, Visual Closure.
    *   Secondary: Fine Motor Skills (if drag-and-drop), Attention to Detail, Patience.
*   **Gameplay Mechanics:**
    *   **Interface:** A workspace showing the target outline or a faint background image, and a collection of available puzzle pieces.
    *   **Interaction:** Players drag, drop, rotate, and possibly flip pieces to fit them into the target area.
    *   **Piece Types:** Can range from simple polygons (Tangrams) to complex jigsaw shapes.
    *   **Feedback:** Pieces might snap into place or provide visual/auditory feedback when correctly placed.
*   **Customizable Difficulty:**
    *   **Number of Pieces:** More pieces increase complexity.
    *   **Complexity of Shapes:** More intricate or similar shapes are harder to place.
    *   **Obscurity of Target Outline:** A less defined outline or no guiding image makes it harder.
    *   **Time Limits:** Optional time pressure.
    *   **Hints:** Showing the correct placement for a piece or the outline of a few pieces.
    *   **Rotation/Flipping:** Allowing or restricting piece rotation/flipping.
*   **Success Metrics:**
    *   Time to completion.
    *   Number of moves or attempts.
    *   Accuracy of fit (e.g., no overlaps, gaps filled).
    *   Percentage of image completed.
    *   Use of hints.

### C. Fuse Clues

*   **Game Name:** Fuse Clues
*   **Core Concept:** Players deduce missing numbers or complete patterns in a grid or schematic (e.g., a circuit board) based on a set of given clues. Clues might involve mathematical relationships, logical conditions, or sequence rules to "restore power" or complete the puzzle.
*   **Cognitive Skills Targeted:**
    *   Primary: Logical Reasoning, Numerical Reasoning, Pattern Recognition, Deductive Thinking.
    *   Secondary: Problem-Solving, Working Memory, Mathematical Skills.
*   **Gameplay Mechanics:**
    *   **Interface:** A grid, circuit diagram, or other schematic with some values filled and others empty.
    *   **Clues:** A list of rules or statements (e.g., "Row 1 sums to 10," "A is twice B," "Current flows from X to Y only if Z is active").
    *   **Input:** User inputs numbers or makes connections based on their deductions.
    *   **Feedback:** Visual feedback on whether inputs satisfy local rules or contribute to the overall solution.
*   **Customizable Difficulty:**
    *   **Complexity of Patterns/Relationships:** More intricate mathematical or logical rules.
    *   **Number of Missing Values:** More unknowns to solve for.
    *   **Indirectness of Clues:** Clues that require multiple steps of deduction.
    *   **Number of Interdependent Clues:** More complex interactions between rules.
*   **Success Metrics:**
    *   Correctly identified patterns, numbers, or connections.
    *   Time taken to solve the puzzle.
    *   Number of attempts or errors.
    *   Use of hints (if available).

## 3. Reasoning Games

This sub-category focuses on games that require applying logical principles, deductive or inductive reasoning, and understanding conditional relationships to solve problems.

### A. Organic Order

*   **Game Name:** Organic Order
*   **Core Concept:** Players must arrange items (e.g., plant seeds in a garden, organize objects on shelves) in a specific sequence or spatial layout based on a given set of logical rules or conditions. For example, "Tulips must be planted before roses," and "Roses cannot be planted next to daisies."
*   **Cognitive Skills Targeted:**
    *   Primary: Logical Reasoning, Planning, Sequential Thinking, Rule Application.
    *   Secondary: Working Memory, Deductive Reasoning, Spatial Awareness.
*   **Gameplay Mechanics:**
    *   **Interface:** A visual representation of the area to be organized (e.g., garden plot, shelves).
    *   **Items:** A selection of items to be placed.
    *   **Rules Display:** A clear list of rules that must be followed.
    *   **Interaction:** Player selects and places items. The game provides feedback on whether a placement violates any rules, either immediately or upon checking.
*   **Customizable Difficulty:**
    *   **Number of Rules:** More rules to consider.
    *   **Complexity of Rules:** Rules with multiple conditions or dependencies (e.g., "If A is next to B, then C cannot be in the same row").
    *   **Number of Item Types/Items:** More items or types of items to arrange.
    *   **Size of Area:** Larger area for arrangement.
    *   **Abstractness of Rules:** Less direct or more conditional rules.
*   **Success Metrics:**
    *   Correct sequence or arrangement achieved that satisfies all rules.
    *   Time taken to complete the arrangement.
    *   Number of incorrect moves or rule violations.
    *   Efficiency of solution (if multiple solutions are possible).

### B. Logic Balls

*   **Game Name:** Logic Balls
*   **Core Concept:** Players manipulate objects (e.g., "logic balls") according to a set of rules or by using available tools (e.g., redirectors, color changers, gates) to guide them to a target destination or achieve a specific configuration. (Reference from design document: "Logic Balls.8" - implying a specific existing concept).
*   **Cognitive Skills Targeted:**
    *   Primary: Logical Reasoning, Problem-Solving, Strategic Thinking, Sequential Thinking.
    *   Secondary: Spatial Reasoning, Cause and Effect Understanding, Planning.
*   **Gameplay Mechanics:**
    *   **Interface:** A play area (grid-based or free-form) containing balls, obstacles, interactive elements (gates, switches, teleporters, color mixers), and target zones.
    *   **Interaction:** Player may place or orient tools, activate triggers, or directly influence balls (if allowed by specific game rules, e.g., a limited "push").
    *   **Goal:** Get specific balls to specific locations, achieve a certain color pattern, or trigger a final event.
    *   **Rules:** Each interactive element has defined behavior (e.g., "red gates only let red balls pass," "this switch reverses gravity for blue balls").
*   **Customizable Difficulty:**
    *   **Number of Balls and Target Complexity:** More balls to manage, or more intricate target states.
    *   **Complexity of Rules/Interactions:** More sophisticated behaviors of tools and elements.
    *   **Number of Available Tools/Limited Uses:** Restricting the tools available or how many times they can be used.
    *   **Number of Steps/Moves Allowed:** Requiring a solution within a certain limit.
    *   **Size of Play Area:** Larger or more constrained environments.
*   **Success Metrics:**
    *   Successful achievement of the target configuration/goal.
    *   Number of moves or time taken.
    *   Optimal solution (e.g., fewest moves, fastest time, using fewest tools).
    *   Completion of levels with increasing complexity.

This document will serve as a blueprint for the development of these problem-solving and logic games, and can be further detailed with specific UI/UX designs and interaction flows.
