%% Script to draw a 9 random symbols onscreen
% Script for developing ideas

% Start experiment and run all setup functions
[screenInfo, reelInfo, fileInfo] = boot_exp();

%% Set shape sizes

% These variables are used to determine the size of each of our logo shapes
baseRect = [0 0 50 50];
radius = max(baseRect)/1.5;

%% Set up logo X coordinates

% Use the x dimensions of the base shape size to adjust from the center.
% This will give use five sets of x dimensions

adjustX = baseRect(3)*1.35;

splitXpos = [screenInfo.xCenter - 2*adjustX, ...
    screenInfo.xCenter - adjustX, ... 
    screenInfo.xCenter, ...
    screenInfo.xCenter + adjustX, ...
    screenInfo.xCenter + 2*adjustX];

% Fill in X,Y cordinates for loading screen symbols 

for i = 1:5
    loadScreen.sym_position(i, :) = [splitXpos(i), screenInfo.yCenter];
end

% Triangle position will be slightly above the rectangle if we use 
% get_dimensions, so a little bit of tweaking here. This part of the script
% will use the lower y dimensions from the rectangle to adjust the location
% of the triangle

replace_sq = get_dimensions(screenInfo, loadScreen.sym_position(4, :), 4, baseRect);
triangle_dim = get_dimensions(screenInfo, loadScreen.sym_position(3, :), 3, baseRect);

triangle_dim([1, 4], 2) = replace_sq(2);
triangle_dim([2, 3], 2) = replace_sq(4);

isConvex = 1;

for i = 1:5
    switch i 
        case 1
            Screen('FillOval', screenInfo.window, reelInfo.colours(i, :), get_dimensions(screenInfo, loadScreen.sym_position(i, :), i, baseRect));
        case 2
            Screen('FillPoly', screenInfo.window, reelInfo.colours(i, :), get_dimensions(screenInfo, loadScreen.sym_position(i, :), i, baseRect), isConvex); % Set isConvex = 1
        case 3
            Screen('FillPoly', screenInfo.window, reelInfo.colours(i, :), triangle_dim, isConvex); % Set isConvex = 1
        case 4
            Screen('FillRect', screenInfo.window, reelInfo.colours(i, :), get_dimensions(screenInfo, loadScreen.sym_position(i, :), i, baseRect));
        case 5
            Screen('FillPoly', screenInfo.window, reelInfo.colours(i, :), get_dimensions(screenInfo, loadScreen.sym_position(i, :), i, baseRect), isConvex); % Set isConvex = 1
    end
end

line1 = '\n\n\n\n\n 9 Line Slot Task';
line2 = '\n Created by Dan Myles';
line3 = 'Loading';

Screen('TextSize', screenInfo.window, 28);
Screen('TextFont', screenInfo.window, 'Courier');
DrawFormattedText(screenInfo.window, [line1, line2], 'center', 'center', screenInfo.black);

Screen('TextSize', screenInfo.window, 18);
Screen('TextFont', screenInfo.window, 'Courier');
DrawFormattedText(screenInfo.window, [line3], 'center', [screenInfo.yCenter + 150], screenInfo.black);

% Flip to the screen
Screen('Flip', screenInfo.window);

% Wait for a key press
KbStrokeWait;
   
% Clear the screen
sca;
