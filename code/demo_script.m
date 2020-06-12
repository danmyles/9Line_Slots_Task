%% Script to draw a 9 random symbols onscreen one reel at a time
% Simple script for debugging and development
       
% TO DO: I may need to add outputData as input and output to a
% number of functions. For instance, if we are using it to track the trial
% number.

 %  TO DO: Create config file with all basic settings. For instance you
% should put:
%   - config.repeatSymbols == 1 << Change in highlight reels & generate
%                                   reelstrips
%   - RGB values for the symbols. 
%   - Sequential or simultaneous reel highlighting

%% TODO ? SAVE ALL SCREEN INFO TO FILE.
% see: http://www.martinszinte.net/Martin_Szinte/Teaching_files/Prog_c6.pdf

% TO DO: add output path to setup_file
% TO DO: create a function that sets up all experimental variables etc
% TO DO: make a function that calls all setup scripts

% TO DO: Series of tests and checks for all video features to ensure
% accurate timing. For instance checking the recorded inter frame interval
% or refresh rate against those desired.

% TO DO: HideCursor; To hide the mouse cursor? but this is annoying when
% debugging. Probably put this in setup_exp?

% TO DO: Output file. subjectInfo - Lay out output file and fill in subject details.

%% Set up inter stimulus interval
% Mean ISI e.g 200ms
% Range ISI e.g. +/- 50ms
% So ISI will fall randomly between 150 ms and 250 ms

%% TO DO SET SPEED OF PLAY
% Speed of play - From Harrigan & Dixon 2009
% We estimated the speed of play by using the second hand on a watch. On the two
% traditional mechanical reel slot machine games, the player can play approximately every
% 6 s, which is approximately 10 spins per minute, or 600 spins per hour. On the two video
% slots games, the player can play approximately every 3 s, which is 1,200 spins per hour.
   
% You will also need to consider the length of time neccesary to avoid
% artifacts from previous stimuli affecting the result. ~1000 ms from
% fixation cross to display of final symbol.

% Start experiment and run all setup functions 
% (screenInfo, output file, output path, reelinfo, )
[screenInfo, reelInfo, fileInfo, outputData] = boot_exp();

%% I'm toying around with the load screen. Seems silly to have it create 
% wait time. Perhaps best to use the dots . ... .....

loading_screen(screenInfo, reelInfo, 4)                                

% WaitSecs(0.25);

% Randomly draws postion at which to stop reels and fill reel_info
[reelInfo] = update_stops(reelInfo);

loading_screen(screenInfo, reelInfo, 5)

% Wait for a key press
KbWait(-1, 2);

% Iteratively display assortment of symbols to get started (just looks nice)
for i = 1:6
    
    % Fill out screen w/ symbols [1:5, 1]
    draw_shapes(screenInfo, reelInfo, reelInfo.pos.LR(1:i, :), trim_centre(reelInfo.outcome.dspSymbols))
    
    % Draw a grid
    draw_grid(screenInfo);
    
    % Flip to the screen
    Screen('Flip', screenInfo.window);
    
    WaitSecs(screenInfo.ifi.*8);
    
end

% Wait for a key press
KbWait(-1, 2);

% Spin both reels - present a trial

for i = 1:5
    [reelInfo, outputData] = spin(screenInfo, reelInfo, outputData);
    
    % Wait for a key press and store key press name
    [secs, keyCode] = KbWait(-1, 2);
    keyPressed = KbName(keyCode);
    
    % Exit experiment if Esc is pressed
    if strcmpi(keyPressed,'escape')
        sca;
    end
end

payoutText = ['<b>', 'Now all wins!'];

% Draw winning amount to centre
[cache] = DrawFormattedText2(payoutText, 'win', screenInfo.window, ...
    'sx', screenInfo.xCenter, 'sy', screenInfo.yCenter, ...
    'xalign','center','yalign','center','xlayout','center');

% Flip to the screen
    Screen('Flip', screenInfo.window);
    
KbWait(-1, 2);

for i = 1:5
    
[reelInfo, outputData] = spin_win(screenInfo, reelInfo, outputData);
    
    % Wait for a key press and store the name or the key
    [secs, keyCode] = KbWait(-1, 2);
    keyPressed = KbName(keyCode);
    
    % Exit code if Esc is pressed
    if strcmpi(keyPressed,'escape')
        sca;
    end
    
end

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

% Clear the screen
sca;


 