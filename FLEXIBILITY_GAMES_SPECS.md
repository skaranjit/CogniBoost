# Flexibility Games Specifications

This document outlines the specifications for the "Flexibility Games" category within the CogniBoost application. These games are designed to challenge and enhance a player's cognitive flexibility, including their ability to switch between different tasks or rules, adapt to changing stimuli, and manage multiple concepts simultaneously.

## 1. Category Name
Flexibility Games

## 2. Core Concept
Flexibility games require players to quickly and efficiently switch between different tasks, adapt to changing rules or stimuli, and think about multiple concepts or perspectives. These games challenge cognitive flexibility by presenting dynamic situations where established patterns of thought or response need to be overridden or modified. The core is to move fluidly between different mental sets or operations.

## 3. Cognitive Skills Targeted
*   **Primary:** Cognitive Flexibility, Task Switching, Adaptability, Set Shifting.
*   **Secondary:** Rule Comprehension, Inhibition (of previous rules/responses), Attention (especially divided and alternating), Working Memory (to hold multiple rules active).

## 4. General Gameplay Mechanics
Flexibility games often employ one or more of the following mechanics:

*   **Rule Switching:** The player performs a task according to one rule (e.g., sort items by color). After a period or a specific cue, the rule changes (e.g., now sort the same items by shape). The player must inhibit the old rule and apply the new one.
*   **Set Shifting:** Similar to rule switching, users might categorize objects or respond to stimuli based on one attribute (e.g., is it a fruit?) and then must shift to categorizing or responding based on a different attribute (e.g., is it red?).
*   **Task Alternation:** Players alternate between two or more distinct tasks. For example, solving a math problem, then a word puzzle, then back to a math problem, with cues indicating which task is currently active.
*   **Responding to Changing Stimuli:** Stimuli that initially require one type of response may change their meaning based on context or a cue, requiring a different response. For example, a green light means "go" unless a siren sound is present, in which case it means "stop."
*   **Dimensional Change:** In tasks like card sorting, the relevant dimension for sorting (e.g., color, shape, number) changes without explicit instruction, and the player must deduce the new rule from feedback.

## 5. Examples of Specific Game Implementations / Thematic Variations

Based on names from the (hypothetical) CogniBoost strategic design report:

### A. Disillusion

*   **Possible Theme/Concept:** This game could revolve around optical illusions, ambiguous figures, or scenarios where initial perceptions are misleading. Players might need to switch between interpreting information literally versus figuratively, or identify true underlying patterns amidst perceptual distractors. The "correct" way to interpret or respond to stimuli might change based on subtle contextual cues or after a "disillusioning" reveal.
*   **Mechanic Focus:**
    *   **Rule switching:** Based on subtle cues that change the interpretation of visual stimuli.
    *   **Inhibition:** Overcoming pre-potent responses triggered by misleading visual information.
    *   **Set Shifting:** Shifting between focusing on global features vs. local details, or appearance vs. underlying rule.

### B. Ebb and Flow

*   **Possible Theme/Concept:** This game could be themed around natural cycles or processes that change dynamically, like tides, weather patterns, or musical tempo. Gameplay might involve responding to stimuli whose characteristics (e.g., speed, quantity, direction of movement) increase and then decrease, or where the rules for correct responses shift periodically and predictably (or unpredictably), requiring constant adaptation.
*   **Mechanic Focus:**
    *   **Adapting to changing task demands:** Modifying response speed or strategy as stimulus presentation rates change.
    *   **Task switching:** Based on environmental cues that signal a change in the "state" of the game (e.g., "high tide" rules vs. "low tide" rules).
    *   **Predictive shifting:** If the ebb and flow are cyclical, players might learn to anticipate rule changes.

### C. Brain Shift

*   **Possible Theme/Concept:** A more direct and abstract task-switching game. Users might perform a simple, clearly defined task (e.g., "tap left if the shape is blue, tap right if it is red") and then, with minimal warning (perhaps a quick cue), the task and its rules shift entirely (e.g., "tap left if the shape is a square, tap right if it is a circle," regardless of color).
*   **Mechanic Focus:**
    *   **Rapid task alternation:** Frequent switching between two or more simple tasks.
    *   **Set shifting:** Quickly changing the mental set from one set of S-R (stimulus-response) rules to another.
    *   **Cue processing:** Efficiently recognizing and implementing the rule associated with the current task cue.

## 6. Customizable Difficulty
Difficulty in Flexibility Games can be adjusted through several parameters:

*   **Speed/Frequency of Rule Changes or Task Switches:** More frequent switches increase demand on flexibility.
*   **Complexity of Individual Tasks/Rules:** Each task or rule set can be simple (e.g., one attribute) or complex (e.g., conjunction of attributes).
*   **Number of Different Rules/Tasks:** Switching between two rules is easier than switching between three or more.
*   **Clarity/Subtlety of Cues:** Cues indicating a switch can be obvious (e.g., "New Rule!") or subtle (e.g., a slight change in background color). Ambiguous cues increase difficulty.
*   **Overlap Between Rule Sets:** Higher overlap in stimuli but different required responses can increase interference and difficulty (e.g., a red square requires tapping left under rule 1, but tapping right under rule 2).
*   **Presence of Distractors:** Irrelevant information that needs to be ignored while switching tasks.
*   **Working Memory Load:** Requiring players to remember past stimuli or responses while also managing current task rules.
*   **Predictability of Switches:** Random switches are harder to prepare for than predictable ones.

## 7. Success Metrics
Performance in Flexibility Games is typically measured by:

*   **Reaction Time (RT):**
    *   **Switch Cost:** The primary metric. Calculated as the difference in RT between trials where the task/rule switched and trials where it remained the same (non-switch trials). Larger switch costs indicate lower flexibility.
    *   RT on non-switch trials can also indicate processing speed for individual tasks.
*   **Accuracy:**
    *   Overall percentage of correct responses.
    *   Accuracy on switch trials vs. non-switch trials. Errors often increase immediately after a switch.
    *   Perseveration errors: Number of times the player incorrectly applies a previous rule after a switch has occurred.
*   **Number of Successful Switches:** How many times the player correctly adapts to a new rule within a given timeframe or number of opportunities.
*   **Efficiency Score:** A composite score that might combine speed and accuracy, possibly weighting performance on switch trials more heavily.
*   **Learning Rate:** Improvement in switch cost or accuracy over time, indicating an improvement in the ability to adapt.

This document will serve as a blueprint for the development of these flexibility games and can be further detailed with specific UI/UX designs and interaction flows.
