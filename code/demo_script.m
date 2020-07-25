%% Script to draw a 9 random symbols onscreen one reel at a time
% Simple script for debugging and development

%% TODO ? SAVE ALL SCREEN INFO TO FILE?

%% TODO ? SET ALL EVENT MARKERS
% Be sure to add markers from betChoice

%% TO DO: Series of tests and checks for all video features to ensure
% accurate timing. For instance checking the recorded inter frame interval
% or refresh rate against those desired.

%% TO DO: HideCursor; To hide the mouse cursor? but this is annoying when
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
% Clear the workspace and the screen
% ----------------------------------------------------------------------

sca;
close all;
clearvars;
rng shuffle; % See notes below

% HideCursor % Off when debugging

% It is recomended that the rng be reseeded at the beginning of any MATLAB 
% session if we wish to think of output from the rng as being
% statistically independent. Only needs to be done once at the start of the
% session.

% The deBruijn package notes also recomend reseeding MATLAB rng prior to 
% each session.

% ----------------------------------------------------------------------
% BEGIN TIMING
% ----------------------------------------------------------------------

% Get time
sessionInfo.date = datetime;
sessionInfo.start = GetSecs;

% Event Marker (Start)

% ----------------------------------------------------------------------
% RUN SETUP SCRIPTS
% ----------------------------------------------------------------------

% Start experiment and run all setup functions
[screenInfo, reelInfo, fileInfo, outputData, ID] = boot_exp();

% Load screen
loading_screen(screenInfo, reelInfo, 4);
loading_screen(screenInfo, reelInfo, 5);

%% TEXT SETUP 
% Setup some default text settings for the window
Screen('TextSize', screenInfo.window, 20);
Screen('TextFont', screenInfo.window, 'Helvetica Neue');
Screen('TextColor', screenInfo.window, screenInfo.black);

%% Empty Table for block timing info
% Empty table
sessionInfo.timing = array2table(zeros(4, 9));

% Create and set VarNames
names = num2str([1:reelInfo.blockN]');
names = join([repmat(["Block_"], 9, 1), names], "");
sessionInfo.timing.Properties.VariableNames = names;
sessionInfo.timing.Properties.RowNames = ["BlockStart", "BlockEnd", "BreakStart", "BreakEnd"];

% ----------------------------------------------------------------------
% Task Instructions
% ----------------------------------------------------------------------

present_instructions(screenInfo, reelInfo, outputData);

% Ready?
DrawFormattedText(screenInfo.window, ...
    'When you are ready press the 9 key to begin the experiment', ...
    'center', screenInfo.yCenter);
% Flip screen
Screen('Flip', screenInfo.window);

% Wait for 9 Key or terminate on ESCAPE.
keyCode = 0;
nineKey = KbName('9(');
escapeKey = KbName('ESCAPE');

% Wait until 9 key before starting first trial
while keyCode ~= nineKey
    
    [keyDown, KeyTime, keyCode] = KbCheck(-1); % Check keyboard
    keyCode = find(keyCode);                     % Get keycode
        
    if keyDown == 0
	keyCode = 0;
    end
     
    % Exit experiment on ESCAPE    
    if keyCode == escapeKey
        sca;
        return
    end
    
    WaitSecs(0.001); % slight delay to prevent CPU hogging
    
end

sessionInfo.instrEndT = sessionInfo.start - KeyTime;

% ----------------------------------------------------------------------
% 1ST BLOCK
% ----------------------------------------------------------------------

sessionInfo.timing{"BlockStart", "Block_1"} = sessionInfo.start - GetSecs;

for i = 1:5 %reelInfo.blocksize * 1 % Block One
    
    [reelInfo, outputData] = present_trial(screenInfo, sessionInfo, reelInfo, outputData);
    
end

sessionInfo.timing{"BlockEnd", "Block_1"} = sessionInfo.start - GetSecs;

% ----------------------------------------------------------------------
% 1ST BREAK
% ----------------------------------------------------------------------

sessionInfo.timing{"BreakStart", "Block_1"} = sessionInfo.start - GetSecs;

for i = 1:5 %reelInfo.blocksize * 1 % Block One
    
    [reelInfo, outputData] = present_trial(screenInfo, sessionInfo, reelInfo, outputData);
    
end

sessionInfo.timing{"BreakEnd", "Block_1"} = sessionInfo.start - GetSecs;

% ----------------------------------------------------------------------
% 2ND BLOCK
% ----------------------------------------------------------------------

% ----------------------------------------------------------------------
% 2ND BREAK
% ----------------------------------------------------------------------

% ----------------------------------------------------------------------
% END text
% ----------------------------------------------------------------------

% Draw text to centre
[cache] = DrawFormattedText2(payoutText, 'win', screenInfo.window, ...
    'sx', screenInfo.xCenter, 'sy', screenInfo.yCenter, ...
    'xalign','center','yalign','center','xlayout','center');

% Flip to the screen
Screen('Flip', screenInfo.window);

KbWait(-1, 2);

% EVENT MARKER (END)

% Session end time
sessionInfo.end = GetSecs;

% Session duration
sessionInfo.duration = (sessionInfo.end - sessionInfo.start);

% All shown?
sessionInfo.shown = sum(outputData.shown);

% Clear the screen
sca;

% Open notes for experimenter to add details.
sessionInfo.notes = inputdlg({ 'List Any Bad Channels:', 'Notes (e.g. errors, fixed channel at trial x etc):'}, ...
    'Enter Experimenter Notes', [1 150; 10 150]);

sessionInfo.badchannels = sessionInfo.notes{1};
sessionInfo.notes = sessionInfo.notes{2};


