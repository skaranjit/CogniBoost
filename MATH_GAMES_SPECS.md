# Math Games Specifications

This document outlines the specifications for the "Math Games" category within the CogniBoost application. These games are designed to enhance mathematical thinking, including mental arithmetic, estimation, probabilistic reasoning, and understanding of fractions and measurements.

## 1. Mental Math Games

This sub-category includes games focused on rapid calculation, estimation, and numerical fluency without reliance on external calculation tools.

### A. Top That

*   **Game Name:** Top That
*   **Core Concept:** Users are presented with several items ("prizes") each having a monetary value. They must quickly estimate or calculate to select a combination of items whose total value gets as close as possible to a target budget without exceeding it, or alternatively, to pick the most expensive set of prizes that fits within a given budget. The design document emphasizes "picking most expensive prizes to exercise quick estimation."
*   **Cognitive Skills Targeted:**
    *   Primary: Quick Estimation, Arithmetic (Addition, Subtraction), Numerical Reasoning.
    *   Secondary: Decision Making, Working Memory, Strategic Thinking (if optimizing selection).
*   **Gameplay Mechanics:**
    *   **Interface:** Display of various items with their prices clearly visible. A target budget or goal value is also displayed.
    *   **Interaction:** User taps to select or deselect items to include in their chosen set.
    *   **Feedback:** Running total of the selected items' value is shown. Feedback on whether the selection is within budget and how close it is to the target (or if it's the optimal expensive set).
*   **Customizable Difficulty:**
    *   **Number of Items:** More items to choose from increases complexity.
    *   **Complexity of Prices:** Using whole numbers vs. decimals; simple vs. irregular price points.
    *   **Time Limits:** Imposing a time limit for selection.
    *   **Tightness of Budget:** A budget that requires very precise calculations or estimations.
    *   **Number of Items Allowed in Selection:** Limiting how many prizes can be chosen.
*   **Success Metrics:**
    *   **Accuracy of Estimation/Calculation:** How close the final selection's value is to the target or optimal value.
    *   **Speed of Decision:** Time taken to make the selection.
    *   **Value Achieved:** The total value of the selected prizes, especially if the goal is to maximize it under budget.
    *   Number of successful rounds.

### B. Chalkboard Challenge

*   **Game Name:** Chalkboard Challenge
*   **Core Concept:** Players solve as many arithmetic problems (addition, subtraction, multiplication, division) as possible within a specific time limit. Problems are presented sequentially, mimicking a rapid-fire quiz on a virtual chalkboard.
*   **Cognitive Skills Targeted:**
    *   Primary: Mental Arithmetic, Calculation Speed, Numerical Fluency.
    *   Secondary: Attention, Concentration, Working Memory.
*   **Gameplay Mechanics:**
    *   **Interface:** A simple interface resembling a chalkboard where arithmetic problems appear one after another.
    *   **Input:** User inputs their answer using an on-screen number pad or keyboard.
    *   **Feedback:** Immediate feedback (correct/incorrect) is provided. The correct answer may be shown if an error is made. The next problem appears immediately after response or brief feedback.
*   **Customizable Difficulty:**
    *   **Complexity of Numbers:** Single-digit, double-digit, or multi-digit numbers.
    *   **Types of Operations:** Focusing on one operation (e.g., just addition) or a mix. Introduction of more complex operations like percentages or exponents at higher levels.
    *   **Time Per Problem or Overall Time Limit:** Stricter time constraints.
    *   **Number of Digits:** Problems involving numbers with more digits.
    *   **Negative Numbers:** Introducing calculations with negative numbers.
*   **Success Metrics:**
    *   Number of correct answers within the time limit.
    *   Average time taken per problem.
    *   Accuracy rate (percentage of correct answers).
    *   Score, potentially weighted by difficulty of problems.

## 2. Probabilistic Reasoning Games

This sub-category focuses on games that require players to estimate likelihoods, understand chance, and make decisions based on probabilistic information.

### A. Magic Chance

*   **Game Name:** Magic Chance
*   **Core Concept:** Users engage in tasks like matching card patterns or predicting outcomes based on visual probability cues. For instance, they might need to guess which of two displayed sets of cards is more likely to yield a specific hand (e.g., a pair, a flush) or predict the next item in a sequence that has probabilistic rather than deterministic elements. The design document states: "matching card patterns based on probability."
*   **Cognitive Skills Targeted:**
    *   Primary: Probabilistic Reasoning, Estimation, Statistical Intuition, Pattern Recognition.
    *   Secondary: Decision Making, Logical Thinking, Risk Assessment.
*   **Gameplay Mechanics:**
    *   **Interface:** Visual display of elements like cards, spinners, dice, or items in sequences with varying distributions.
    *   **Interaction:** User makes a choice by selecting an option (e.g., "Set A is more likely," "The next item will be blue").
    *   **Feedback:** The game reveals the outcome and provides feedback on the correctness of the prediction. Ideally, it might also visually explain the underlying probabilities after a choice is made (e.g., showing the full composition of card decks).
*   **Customizable Difficulty:**
    *   **Subtlety of Probability Differences:** Small differences in likelihood between choices make it harder.
    *   **Number of Variables/Outcomes:** More possible outcomes or factors influencing probability.
    *   **Complexity of Patterns:** More intricate patterns or conditional probabilities.
    *   **Time Pressure:** Requiring quick judgments.
    *   **Information Provided:** Amount of information given about the sample space (e.g., showing some cards vs. none).
*   **Success Metrics:**
    *   Accuracy of predictions or matches.
    *   Demonstrated understanding of probabilities (e.g., performance on questions that explicitly ask about odds, if included).
    *   Number of correct choices over a series of trials.
    *   Ability to adapt strategy based on observed frequencies if the game involves learning probabilities.

## 3. Fractions/Measurement Games

This sub-category includes games designed to improve understanding and manipulation of fractions, ratios, and units of measurement in a visual and applied context.

### A. Halve Your Cake

*   **Game Name:** Halve Your Cake
*   **Core Concept:** Players visually represent, manipulate, and apply fractions or measurements. This could involve tasks like accurately cutting a virtual cake into specified fractional pieces (e.g., "cut 1/3 of the cake"), measuring virtual ingredients for a recipe according to given amounts, or dividing objects into proportional parts. The design document mentions: "measuring ingredients, visually representing fractions."
*   **Cognitive Skills Targeted:**
    *   Primary: Understanding of Fractions, Measurement Skills, Spatial Reasoning (for visual representation), Proportional Thinking.
    *   Secondary: Estimation, Numerical Reasoning, Attention to Detail.
*   **Gameplay Mechanics:**
    *   **Interface:** Visual representation of objects to be divided or measured (e.g., cakes, pizzas, liquids in measuring cups, lengths on a ruler).
    *   **Tools:** Interactive tools for cutting (e.g., a draggable knife), pouring, or marking measurements.
    *   **Instructions:** Clear instructions given (e.g., "Measure 3/4 cup of flour," "Divide the chocolate bar into 1/2 and two 1/4 pieces").
    *   **Feedback:** Visual feedback on the accuracy of the division or measurement. May show the correct division alongside the user's attempt.
*   **Customizable Difficulty:**
    *   **Complexity of Fractions:** Simple fractions (1/2, 1/4) vs. more complex ones (2/3, 3/5) or mixed numbers.
    *   **Precision Required:** Tolerance for error in cuts or measurements.
    *   **Number of Steps/Operations:** Single actions vs. multi-step tasks (e.g., measure multiple ingredients).
    *   **Types of Units:** Introducing different units of measurement (metric, imperial) and conversions at higher levels.
    *   **Abstract Representation:** Moving from concrete visual objects to more abstract representations of fractions.
*   **Success Metrics:**
    *   Accuracy of the fractional division or measurement (e.g., percentage error).
    *   Time taken to complete the task.
    *   Adherence to all instructions in multi-step tasks.
    *   Number of successful tasks completed.

This document will serve as a blueprint for the development of these math games, and can be further detailed with specific UI/UX designs, visual styles, and interaction flows.
