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

% Start experiment and run all setup functions 
% (screenInfo, output file, output path, reelinfo, )
[screenInfo, reelInfo, fileInfo, outputData, ID, sessionInfo] = boot_exp();

% Load screen                         
loading_screen(screenInfo, reelInfo, 4)
loading_screen(screenInfo, reelInfo, 5)

% Wait for a key press
KbWait(-1, 2);

% ----------------------------------------------------------------------
%% Instructions
% ----------------------------------------------------------------------

% ----------------------------------------------------------------------
%% Display reels
% ----------------------------------------------------------------------

% Display outcome stimulus
draw_grid(screenInfo);
draw_shapes(screenInfo, reelInfo, reelInfo.pos.LR, trim_centre(reelInfo.outcome.dspSymbols));
Screen('Flip', screenInfo.window);
  
% ----------------------------------------------------------------------
%% Practice section
% ----------------------------------------------------------------------

for i = 1:10

    [reelInfo, outputData] = present_trial(reelInfo, screenInfo, outputData);

end

toc

% ----------------------------------------------------------------------
%% First block
% ----------------------------------------------------------------------

% Now display wins only.
payoutText = ['<b>', 'Now all wins!'];

% Draw text to centre
[cache] = DrawFormattedText2(payoutText, 'win', screenInfo.window, ...
    'sx', screenInfo.xCenter, 'sy', screenInfo.yCenter, ...
    'xalign','center','yalign','center','xlayout','center');

% Flip to the screen
    Screen('Flip', screenInfo.window);
   
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


 