%% Script to draw a 9 random symbols onscreen one reel at a time
% Simple script for debugging and development

%% TODO ? SAVE ALL SCREEN INFO TO FILE.

% TO DO: Series of tests and checks for all video features to ensure
% accurate timing. For instance checking the recorded inter frame interval
% or refresh rate against those desired.

% TO DO: HideCursor; To hide the mouse cursor? but this is annoying when
% debugging. Probably put this in setup_exp?

%% TO DO SET SPEED OF PLAY
% Speed of play - From Harrigan & Dixon 2009
% We estimated the speed of play by using the second hand on a watch. On the two
% traditional mechanical reel slot machine games, the player can play approximately every
% 6 s, which is approximately 10 spins per minute, or 600 spins per hour. On the two video
% slots games, the player can play approximately every 3 s, which is 1,200 spins per hour.

% You will also need to consider the length of time neccesary to avoid
% artifacts from previous stimuli affecting the result. ~1000 ms from
% fixation cross to display of final symbol.

% ----------------------------------------------------------------------
%% Run setup scripts
% ----------------------------------------------------------------------

% Event Marker (Start)

% Start Task Timer
tic;

% Start experiment and run all setup functions
[screenInfo, reelInfo, fileInfo, outputData, ID, sessionInfo] = boot_exp();

% Load screen
loading_screen(screenInfo, reelInfo, 4);
loading_screen(screenInfo, reelInfo, 5);

% Wait for a key press
KbWait(-1, 2);

% Get instructions and demo spins.
setup_instructions

% ----------------------------------------------------------------------
%% Opening Instructions
% ----------------------------------------------------------------------

% Display first 4 lines
for i = 1:4
    % Text draw.
    draw_text(screenInfo, reelInfo, instructions, instructions.opening{i});
    
    % Flip to the screen
    Screen('Flip', screenInfo.window);
    
    % Wait for keypress
    KbWait(-1, 2);
end

% It looks like this:

% Display
draw_grid(screenInfo);
draw_shapes(screenInfo, reelInfo, reelInfo.pos.LR, trim_centre(reelInfo.outcome.dspSymbols));
DrawFormattedText(screenInfo.window, instructions.cont, 'center', screenInfo.ydot);
Screen('Flip', screenInfo.window);

% Wait for keypress
KbWait(-1, 2);

% Display next two lines
for i = 5:6
    % Text draw.
    draw_text(screenInfo, reelInfo, instructions, instructions.opening{i});
    
    % Flip to the screen
    Screen('Flip', screenInfo.window);
    
    % Wait for keypress
    KbWait(-1, 2);
end

% Show reels:
draw_grid(screenInfo);
draw_shapes(screenInfo, reelInfo, reelInfo.pos.LR, trim_centre(reelInfo.outcome.dspSymbols));
DrawFormattedText(screenInfo.window, instructions.cont, 'center', screenInfo.ydot);
Screen('Flip', screenInfo.window);

% Wait for keypress
KbWait(-1, 2);

% Show a win
[reelInfo, demoSequence] = present_demo(reelInfo, screenInfo, demoSequence, 1);

% Display next two lines
for i = 7:8
    % Text draw.
    draw_text(screenInfo, reelInfo, instructions, instructions.opening{i});
    
    % Flip to the screen
    Screen('Flip', screenInfo.window);
    
    % Wait for keypress
    KbWait(-1, 2);
end

% Text draw.
draw_text(screenInfo, reelInfo, instructions, ...
    ['So in the previous example the payout was ' num2str(reelInfo.multipliers(end)*10) ' credits']);

% Flip to the screen
Screen('Flip', screenInfo.window);

% Wait for keypress
KbWait(-1, 2);

% Show spinning reels:
draw_grid(screenInfo);
draw_shapes(screenInfo, reelInfo, reelInfo.pos.All, reelInfo.outcome.dspSymbols);
DrawFormattedText(screenInfo.window, instructions.cont, 'center', screenInfo.ydot);
Screen('Flip', screenInfo.window);

% Wait for keypress
KbWait(-1, 2);

% Text draw.
draw_text(screenInfo, reelInfo, instructions, instructions.opening{9});

% Flip to the screen
Screen('Flip', screenInfo.window);

% Wait for keypress
KbWait(-1, 2);

% Show spinning reels:
draw_grid(screenInfo);
draw_shapes(screenInfo, reelInfo, reelInfo.pos.LR, trim_centre(reelInfo.outcome.dspSymbols));
DrawFormattedText(screenInfo.window, instructions.cont, 'center', screenInfo.ydot);
Screen('Flip', screenInfo.window);

% Wait for keypress
KbWait(-1, 2);

% Show a loss
[reelInfo, demoSequence] = present_demo(reelInfo, screenInfo, demoSequence, 1);

% Display next two lines
for i = 10:12
    % Text draw.
    draw_text(screenInfo, reelInfo, instructions, instructions.opening{i});
    
    % Flip to the screen
    Screen('Flip', screenInfo.window);
    
    % Wait for keypress
    KbWait(-1, 2);
end

% ----------------------------------------------------------------------
%% Explain Lines
% ----------------------------------------------------------------------

% Display next two lines
for i = 1:7
    
    % Text draw.
    draw_text(screenInfo, reelInfo, instructions, instructions.lines{i});
    
    % Flip to the screen
    Screen('Flip', screenInfo.window);
    
    % Wait for keypress
    KbWait(-1, 2);
    
end

% ----------------------------------------------------------------------
%% Explain Betting
% ----------------------------------------------------------------------

% ----------------------------------------------------------------------
%% Explain Fixation Cross
% ----------------------------------------------------------------------

% ----------------------------------------------------------------------
%% Practice section
% ----------------------------------------------------------------------

% This should run continously until the experimenter comes in to enter a
% key to close the experiment. The actual experiment should start from a
% seperate script.

for i = 1:10
    
    [reelInfo, outputData] = present_trial(reelInfo, screenInfo, outputData);
    
end

% ----------------------------------------------------------------------
%% First block
% ----------------------------------------------------------------------

% ----------------------------------------------------------------------
%% END text
% ----------------------------------------------------------------------

% Set up text for final text display
Screen('TextSize', screenInfo.window, reelInfo.payout.textSize);
Screen('TextFont', screenInfo.window, 'Garamond');
Screen('TextColor', screenInfo.window, screenInfo.black);
payoutText = ['<b>', 'Demo over :)'];

% Draw text to centre
[cache] = DrawFormattedText2(payoutText, 'win', screenInfo.window, ...
    'sx', screenInfo.xCenter, 'sy', screenInfo.yCenter, ...
    'xalign','center','yalign','center','xlayout','center');

% Flip to the screen
Screen('Flip', screenInfo.window);

KbWait(-1, 2);

% Session end time
sessionInfo.end = GetSecs;

% Event Marker (END)

% Session duration
sessionInfo.duration = (sessionInfo.end - sessionInfo.start);

% All shown?
sessionInfo.shown = sum(outputData.shown);

% Open notes for experimenter to add details.
sessionInfo.notes = inputdlg({ 'List Any Bad Channels:', 'Notes (e.g. errors, fixed channel at trial x etc):'}, ...
    'Enter Experimenter Notes', [1 150; 10 150]);

sessionInfo.badchannels = sessionInfo.notes{1};
sessionInfo.notes = sessionInfo.notes{2};

% Clear the screen
sca;


