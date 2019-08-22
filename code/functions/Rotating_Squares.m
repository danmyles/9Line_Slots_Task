% Clear the workspace and the screen
sca;
close all;
clearvars;

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

Screen('Preference', 'SkipSyncTests', 1);

% Get the screen numbers
screens = Screen('Screens');

% Draw to the external screen if avaliable
screenNumber = max(screens);

% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white, [0, 0, 640, 480], [], [], [], 6, []);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Maximum priority level
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Set up alpha-blending for smooth (anti-aliased) lines
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% Define a simple 4 by 4 checker board
checkerboard = repmat(eye(2), 2, 2);

% Make the checkerboard into a texure (4 x 4 pixels)
checkerTexture = Screen('MakeTexture', window, checkerboard);

% We are going to draw four textures to show how a black and white texture
% can be color modulated upon drawing
yPos = yCenter;
xPos = linspace(screenXpixels * 0.2, screenXpixels * 0.8, 4);

% Define the destination rectangles for our spiral textures. Each scaled by
% 50x
[s1, s2] = size(checkerboard);
baseRect = [0 0 s1 s2] .* 50;
dstRects = nan(4, 4);
for i = 1:4
    dstRects(:, i) = CenterRectOnPointd(baseRect, xPos(i), yPos);
end

% Color Modulation
colorMod = [1 1 1; 1 0 0; 0 1 0; 0 0 1]';

% Switch filter mode to simple nearest neighbour
filterMode = 0;

% Set the inital rotation angle and increment per frame to 3
% degrees
angles = 0;
degPerFrame = 3;

% Sync us and get a time stamp
vbl = Screen('Flip', window);
waitframes = 1;

% Maximum priority level
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);

% Batch Draw all of the texures to screen
while ~KbCheck

    % Batch draw our scaled, rotated and color modulated textures
    Screen('DrawTextures', window, checkerTexture, [], dstRects,...
        angles, filterMode, [], colorMod);

    % Flip to the screen
    vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);

    % Increment the angle for the next drawing loop
    angles = angles + degPerFrame;

end

% Clear the screen
sca;