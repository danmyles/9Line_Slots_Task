function screenInfo = setup_screen()
% ----------------------------------------------------------------------
% setup_screen()
% ----------------------------------------------------------------------
% Goal of the function :
% Setup Screen for PTB and create a data struct full of all necessary 
% information about the screen and the monitor.
% ----------------------------------------------------------------------
% Input(s) :
% (none) ? may change
% ----------------------------------------------------------------------
% Output(s):
% screenInfo - struct containing all screen configuration.
% [screenInfo] = setup_screen() to call into base workspace
% ----------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : 8th April 2019
% Project : 9_Line_Slots_Task
% Version : dev
% ----------------------------------------------------------------------

%% FELETE THIS SECTION WHEN setup_exp is finished
% Clear the workspace and the screen
sca;
close all;
clearvars;
%%

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 1);  

% Get the screen numbers. This gives us a number for each of the screens
% attached to our computer.
% For help see: Screen Screens?
screenInfo.screens = Screen('Screens');

% We select the minimum of these numbers if we plan to draw to our laptop or main screen. 
% If we choose maximum this will set up a situation where when
% have two screens attached to our monitor we will draw to the external
% screen.
% screenInfo.screenNumber = max(screenInfo.screens);
screenInfo.screenNumber = min(screenInfo.screens);

% Define white (white will be 1 and black 0). This is because
% luminace values are (in general) defined between 0 and 1.
% For help see: help BlackIndex
screenInfo.black = BlackIndex(screenInfo.screenNumber);
screenInfo.white = WhiteIndex(screenInfo.screenNumber);

% For help see: Screen OpenWindow?
% Open the main window with multi-sampling for anti-aliasing
[screenInfo.window, screenInfo.windowRect] = PsychImaging('OpenWindow', screenInfo.screenNumber, screenInfo.white, [], [], [], [], 6, []);

% Setup for playing on laptiop only (ie no external)
% [screenInfo.window, screenInfo.windowRect] = PsychImaging('OpenWindow', screenInfo.screenNumber, screenInfo.white, [0, 0, 640, 480], [], [], [], 6, []);


% Get the size of the on screen window in pixels
% For help see: Screen WindowSize?
[screenInfo.screenXpixels, screenInfo.screenYpixels] = Screen('WindowSize', screenInfo.window);

% Get the centre coordinates of the window in pixels
% For help see: help RectCenter
[screenInfo.xCenter, screenInfo.yCenter] = RectCenter(screenInfo.windowRect);
screenInfo.screenCenter = [screenInfo.xCenter, screenInfo.yCenter];

% Set up alpha-blending for smooth (anti-aliased) lines
Screen('BlendFunction', screenInfo.window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% Query the frame duration
screenInfo.ifi = Screen('GetFlipInterval', screenInfo.window);

%% Get the Frame rate and check against desired.

% If we want to do this you need to set up vairables in setup_experiment

% Below is copied from: 
% http://www.martinszinte.net/Martin_Szinte/Teaching_files/Prog_c6.pdf. 
% check if ifi will suffice.

% % Frame rate : (fps)
% screenInfo.fps = 1/(Screen('FrameRate',screenInfo.screenNumber));
% if screenInfo.fps == inf;
%     screenInfo.fps = 1/60;
% elseif screenInfo.fps == 0;
%     screenInfo.fps = 1/60;
% end
% 
% % Frame rate : (hertz)
% screenInfo.Hz = 1/(screenInfo.fps);
% if (screenInfo.Hz >= 1.1*const.desiredFPS || screenInfo.Hz <= 0.9*const.desiredFPS) && const.expStart
%  error('Incorrect refresh rate => Please restart the program after changing the refresh rate to %i Hz', const.desiredFPS);
% end
%%

%% TEXT SETUP 
% Will probably relocate to a text setup function eventually
% Setup the text type for the window
Screen('TextFont', screenInfo.window, 'Ariel');
Screen('TextSize', screenInfo.window, 36);

%% TODO ? SAVE ALL SCREEN INFO TO FILE.
% see: http://www.martinszinte.net/Martin_Szinte/Teaching_files/Prog_c6.pdf
end