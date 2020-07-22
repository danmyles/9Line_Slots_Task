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

%% TEXT SETUP 
% Setup some default text settings for the window
Screen('TextSize', screenInfo.window, 20);
Screen('TextFont', screenInfo.window, 'Helvetica Neue');
Screen('TextColor', screenInfo.window, screenInfo.black);

% ----------------------------------------------------------------------
%% Opening Instructions
% ----------------------------------------------------------------------

% 1 - 'Hello.'
% 2 - 'Welcome to the 9 Line Slot Task.'
% 3 - 'In this experiment you will play a simple slot machine.'
% 4 - 'It looks like this:'
for i = 1:4
    
    % Text draw.
    draw_text(screenInfo, reelInfo, instructions, instructions.opening{i});
    Screen('Flip', screenInfo.window);  % Flip to the screen
    KbWait(-1, 2);                      % Wait for keypress
    
end

% Display Reels
draw_grid(screenInfo);
draw_shapes(screenInfo, reelInfo, reelInfo.pos.LR, trim_centre(reelInfo.outcome.dspSymbols));
DrawFormattedText(screenInfo.window, instructions.cont, 'center', screenInfo.ydot);
Screen('Flip', screenInfo.window);  % Flip to the screen
KbWait(-1, 2);                      % Wait for keypress

% WIN DEMO
% While loop to allow user to repeat instructions if desired.
keyCode = 38;

while keyCode == 38
    
    % Reset demo interator
    reelInfo.demoIndex = 0;
    
    % 5 - 'When you play each reel will spin just like a slot machine...'; ...
    % 6 - 'If three symbols line up a win occurs.'; ...
    for i = 5:6
       
        % Text draw.
        draw_text(screenInfo, reelInfo, instructions, instructions.opening{i});
        Screen('Flip', screenInfo.window);  % Flip to the screen
        KbWait(-1, 2);                      % Wait for keypress
        
    end
    
    % Show reels:
    draw_grid(screenInfo);
    draw_shapes(screenInfo, reelInfo, reelInfo.pos.LR, trim_centre(reelInfo.outcome.dspSymbols));
    DrawFormattedText(screenInfo.window, instructions.cont, 'center', screenInfo.ydot);
    Screen('Flip', screenInfo.window);  % Flip to the screen
    KbWait(-1, 2);                      % Wait for keypress
    
    % Show a win
    [reelInfo, demoSequence] = present_demo(reelInfo, screenInfo, demoSequence, 1);
    
    % Display next two lines
    % 7 - 'Nice!'; ...
    % 8 - 'When a match occurs the centre symbol will display the amount won'; ...
    for i = 7:8
        draw_text(screenInfo, reelInfo, instructions, instructions.opening{i});
        Screen('Flip', screenInfo.window);  % Flip to the screen
        KbWait(-1, 2);                      % Wait for keypress
    end
    
    % So in the previous example the payout was .... credits
    draw_text(screenInfo, reelInfo, instructions, ...
        ['So in the previous example the payout was ' num2str(reelInfo.multipliers(end)*10) ' credits']);
    Screen('Flip', screenInfo.window);  % Flip to the screen
    KbWait(-1, 2);                      % Wait for keypress
    
    % Show previous outcome:
    draw_grid(screenInfo);
    draw_shapes(screenInfo, reelInfo, screenInfo.splitpos, reelInfo.outcome.dspSymbols);
    draw_payout(screenInfo, reelInfo, 1); % Display payout
    DrawFormattedText(screenInfo.window, instructions.cont, 'center', screenInfo.ydot);
    Screen('Flip', screenInfo.window);  % Flip to the screen
    KbWait(-1, 2);                      % Wait for keypress
    
    % 9 - 'If the centre position doesn't match you do not win credits'
    draw_text(screenInfo, reelInfo, instructions, instructions.opening{9});
    Screen('Flip', screenInfo.window);  % Flip to the screen
    KbWait(-1, 2);                      % Wait for keypress
    
	% LOSS DEMO
    % Show spinning reels:
    draw_grid(screenInfo);
    draw_shapes(screenInfo, reelInfo, screenInfo.splitpos, reelInfo.outcome.dspSymbols);
	draw_payout(screenInfo, reelInfo, 1); % Display payout
    DrawFormattedText(screenInfo.window, instructions.cont, 'center', screenInfo.ydot);
    Screen('Flip', screenInfo.window);  % Flip to the screen
    KbWait(-1, 2);                      % Wait for keypress
    
    % Show a loss
    [reelInfo, demoSequence] = present_demo(reelInfo, screenInfo, demoSequence, 1);
    
    % :'(
    draw_text(screenInfo, reelInfo, instructions, instructions.opening{10});
    Screen('Flip', screenInfo.window);                  % Flip
    KbWait(-1, 2);                                      % Wait for keypress
       
    keyCode = 0;
    
    % View these instructions again?
    DrawFormattedText(screenInfo.window,'To view these instructions again press the 9 key\n\nOtherwise press any key to continue', 'center', screenInfo.yCenter);
    Screen('Flip', screenInfo.window);
    [~, keyCode] = KbWait(-1, 2);
    
    % set key down and wait for user to make key press
    keyCode = find(keyCode);
    
end

% ----------------------------------------------------------------------
%% Explain Lines
% ----------------------------------------------------------------------

% While loop to allow user to repeat instructions if desired.
keyCode = 38;

while keyCode == 38
    
    % 'There are 5 different symbols:'; ...
    draw_text(screenInfo, reelInfo, instructions, instructions.lines{1}); % Text Draw
    Screen('Flip', screenInfo.window);                                    % Screen flip
    KbWait(-1, 2);                                                        % Wait for user input
    
    % Show symbols:
    draw_text(screenInfo, reelInfo, instructions, ''); % Empty text draw to get any key text.
    inArow(screenInfo, reelInfo);                      % Quick function to draw five symbols to centre.
    Screen('Flip', screenInfo.window);                 % Screen flip
    KbWait(-1, 2);                                     % Wait for user input
    
    % 2 - 'Match 3 of any symbol and the machine will payout!'; ...
    % 3 - 'There are 9 different ways that a three symbol match can occur'; ...
    for i = 2:3
        draw_text(screenInfo, reelInfo, instructions, instructions.lines{i}); % Text Draw
        Screen('Flip', screenInfo.window);                                    % Screen flip
        KbWait(-1, 2);                                                        % Wait for user input
    end
    
    % Throw up 9 lines one at a time
    demo_lines(screenInfo, reelInfo, instructions);
    
    keyCode = 0;
    
    % View these instructions again?
    DrawFormattedText(screenInfo.window,'To view these instructions again press the 9 key\n\nOtherwise press any key to continue', 'center', screenInfo.yCenter);
    Screen('Flip', screenInfo.window);
    [~, keyCode] = KbWait(-1, 2);
    
    % set key down and wait for user to make key press
    keyCode = find(keyCode);
    
end

% ----------------------------------------------------------------------
%% Explain Betting
% ----------------------------------------------------------------------

% While loop to allow user to repeat instructions if desired.
keyCode = 38;

while keyCode == 38
        
    % Reset keyCode
    keyCode = 0;
    
    % Cycle through betting instructions.
    for i = 1:length(instructions.betting)
        draw_text(screenInfo, reelInfo, instructions, instructions.betting{i}); % Text Draw
        Screen('Flip', screenInfo.window);                                      % Screen flip
        KbWait(-1, 2);                                                          % Wait for user input
    end
    
    % View these instructions again?
    DrawFormattedText(screenInfo.window,'To view these instructions again press the 9 key\n\nOtherwise press any key to continue', 'center', screenInfo.yCenter);
    Screen('Flip', screenInfo.window);
	[~, keyCode] = KbWait(-1, 2);
    
    % set key down and wait for user to make key press   
    keyCode = find(keyCode);
    
end

% ----------------------------------------------------------------------
%% Explain Fixation Cross
% ----------------------------------------------------------------------

% While loop to allow user to repeat instructions if desired.
keyCode = 38;

while keyCode == 38
    
    % Reset keyCode
    keyCode = 0;
    
    % Cycle through fixation cross instructions.
    for i = 1:length(instructions.fixation)
        
        i = ['|' repmat(' ', 1, 200) instructions.fixation{i} repmat(' ', 1, 200) '|'];

        % Text Draw
        DrawFormattedText(screenInfo.window, i, 'center', screenInfo.yCenter + floor(screenInfo.gridRect(4)/8) * 3); 

        % Draw any key text
        DrawFormattedText(screenInfo.window, instructions.cont, 'center', screenInfo.cont);
        
        % Draw a little red dot :)
        Screen('FillOval', screenInfo.window, reelInfo.colours(1, :), ...
            get_dimensions(screenInfo, [screenInfo.xCenter, screenInfo.ydot], 1, [0, 0, 15, 15]) ... 
            );
        
        draw_fixation(screenInfo, reelInfo);    % Fixation cross
        Screen('Flip', screenInfo.window);      % Screen flip
        
        KbWait(-1, 2);                          % Wait for user input
        
    end
    
    % View these instructions again?
    DrawFormattedText(screenInfo.window,'To view these instructions again press the 9 key\n\nOtherwise press any key to continue', 'center', screenInfo.yCenter);
    Screen('Flip', screenInfo.window);
	[~, keyCode] = KbWait(-1, 2);
    
    % set key down and wait for user to make key press   
    keyCode = find(keyCode);
    
end

% Debugging
DrawFormattedText(screenInfo.window,'End of debugging', 'center', screenInfo.yCenter);
Screen('Flip', screenInfo.window);
KbWait(-1, 2);

% ----------------------------------------------------------------------
%% Practice section
% ----------------------------------------------------------------------

% This should run continously until the experimenter comes in to enter a
% key to begin the experiment. The actual experiment should start from a
% seperate script.

for i = 1:10
    
    [reelInfo, outputData] = present_trial(reelInfo, screenInfo, outputData);
    
end

% ----------------------------------------------------------------------
%% Introduce Task
% ----------------------------------------------------------------------

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


