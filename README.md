# CSM152A-Lab4: Electronic Piano
## Overview
For our project, we will create an electric piano on the FPGA board. 7 switches will be used to represent 7 notes in one musical octave. A user can use the up and down buttons to cycle between all seven octaves on the piano. In addition to playing the piano as normal, notes will be recorded in “recording mode”. The user can play them back in “playback mode” by pressing the appropriate button. A reset button will clear the recording and reset the mode and selected octave.

In order to implement our project, we will use a Pmod AMP2 component to connect the FPGA board to an external speaker via an audio jack. Any notes played or recorded by the user will be the input and each note’s audio frequency and will be the output.
## Recording Mode
Any notes played while in this mode will be saved. The user can play the electronic piano by toggling switches 1-7 representing notes C, D, E, F, G, A, and B respectively.  Using the up and down buttons, a user can cycle through octaves 1-7 on the piano to play all natural notes (white piano keys). We will not be implementing functionality for sharp and flat notes, or simultaneous notes. Invalid switch combinations will be ignored. The seven segment display will use two digits to indicate the latest note pressed and its octave number (i.e. C4, A2, B7). Another digit will be used to indicate the currently selected octave.
## Playback Mode
The left button will be used to toggle “playback mode” to play the most recently recorded song. Flipping the note switches will not have any effect during this mode. After the entire recording plays or if the left button is pressed again while in “playback mode”, the program will switch back into “recording mode.”

The right button will clear the recording in either mode. The mode will be reset to “recording mode”. The octave will be reset to 4 (the middle octave).

## Grading Rubric
* Playing on AMP2 (25%) - The ports should be mapped such that audio can be played correctly.
* Playing Notes Functionality (20%) - A single note should be played for a fixed duration when any switch state change causes exactly one note to be selected.
* Recording Functionality (20%) - Notes played should be recorded. Recorded notes should be played back in “playback mode” when the left button is pressed. An additional left button press during “playback mode” should disable “playback mode”.
* Selecting Octave Functionality (15%) - The up and down buttons should allow changing the octave of the next note played.
* Invalid Input Behavior (5%) - Multiple notes cannot be played at the same time. Instead, the piano will ignore this input. Additionally, switches will have no effect in “playback mode”. No notes will be recorded when the inputs are invalid.
* Reset Functionality (5%) - If the right button is pressed at any time: The recording should be cleared. The mode should be reset to “recording mode”. The currently selected octave should be reset to 4 (the middle octave).
* Last Note Indicator (5%) - The display should indicate the last note and octave played using two digits.
* Current Octave Indicator (5%) - The display should indicate the currently selected octave using one digit.
