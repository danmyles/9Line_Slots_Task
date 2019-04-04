%% Script to run basic Screen Set up
% Based on http://peterscarfe.com/ptbtutorials.html

% Clear the workspace and the screen
sca;
close all;
clearvars;

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 1);  

% Get the screen numbers. This gives us a number for each of the screens
% attached to our computer.
% For help see: Screen Screens?
screens = Screen('Screens');

% We select the minimum of these numbers if we plan to draw to our laptop or main screen. 
% If we choose maximum this will set up a situation where when
% have two screens attached to our monitor we will draw to the external
% screen.
% screenNumber = max(screens);
screenNumber = min(screens);

% Define white (white will be 1 and black 0). This is because
% luminace values are (in general) defined between 0 and 1.
% For help see: help BlackIndex
black = BlackIndex(screenNumber);
white = WhiteIndex(screenNumber);

% For help see: Screen OpenWindow?
% Open the main window with multi-sampling for anti-aliasing
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white, [], [], [], [], 6, []);

% Setup for playing on laptiop only (ie no external)
% [window, windowRect] = PsychImaging('OpenWindow', screenNumber, white, [0, 0, 640, 480], [], [], [], 6, []);

% Get the size of the on screen window in pixels
% For help see: Screen WindowSize?
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window in pixels
% For help see: help RectCenter
[xCenter, yCenter] = RectCenter(windowRect);

%% Old Code

% % % Screen X positions of our three rectangles
% splitXpos = [screenXpixels * 0.25 screenXpixels * 0.5 screenXpixels * 0.75];
% splitYpos = [screenYpixels * 0.75 screenYpixels * 0.5 screenYpixels * 0.25];