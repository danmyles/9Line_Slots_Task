%% Script to draw a 9 random symbols onscreen
% Script for developing ideas

% Start experiment and run all setup functions
[screenInfo, reelInfo, gridInfo, fileInfo] = boot_exp();

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

for i = 1:5
    loadScreen.sym_position{i} = [splitXpos(i), screenInfo.yCenter];
end

% Each of these central points will be of value and so I want to add them 
% to either screenInfo as a 3x3 cell array, each cell will be placed in the
% cell as per their corresponding grid+symbol position.

for i = 1:5
    switch(reelInfo.sym_names{i})
            case {"tri", "diam", "pent"}
                
                switch(reelInfo.sym_names{i})
                    case "tri"
                        numSides = 3;
                    case "diam"
                        numSides = 4;
                    case "pent"
                        numSides = 5;
                end
                
                anglesDeg = linspace(0, 360, numSides + 1 ) - 90;
                anglesRad = anglesDeg * (pi / 180);
                
                xPosVector = cos(anglesRad) .* radius + loadScreen.sym_position{i}(1);
                yPosVector = sin(anglesRad) .* radius + loadScreen.sym_position{i}(2);
                
                loadScreen.sym_position{i} = [xPosVector; yPosVector]';
                
            case {"circ", "rect"}
                loadScreen.sym_position{i} = ...
                    CenterRectOnPointd(baseRect, ...
                    loadScreen.sym_position{i}(1), ... 
                    loadScreen.sym_position{i}(2))';
   
    end
end

% adjust triangle position to meet rect
loadScreen.sym_position{3}(6:7) = loadScreen.sym_position{4}(4);
loadScreen.sym_position{3}([5,8]) = loadScreen.sym_position{4}(2);

isConvex = 1;

for i = 1:5
    switch(reelInfo.sym_names(i))
        case "circ"
            Screen('FillOval', screenInfo.window, reelInfo.colours{i}, loadScreen.sym_position{i});
        case "diam"
            Screen('FillPoly', screenInfo.window, reelInfo.colours{i}, loadScreen.sym_position{i}, isConvex); % Set isConvex = 1
        case "tri"
            Screen('FillPoly', screenInfo.window, reelInfo.colours{i}, loadScreen.sym_position{i}, isConvex); % Set isConvex = 1
        case "rect"
            Screen('FillRect', screenInfo.window, reelInfo.colours{i}, loadScreen.sym_position{i});
        case "pent"
            Screen('FillPoly', screenInfo.window, reelInfo.colours{i}, loadScreen.sym_position{i}, isConvex); % Set isConvex = 1
    end
end

line1 = '\n\n\n\n\n 9 Line Slot Task';
line2 = '\n Created by Dan Myles';
line3 = 'Loading deBruijn cycle';

Screen('TextSize', screenInfo.window, 28);
Screen('TextFont', screenInfo.window, 'Arial');
DrawFormattedText(screenInfo.window, [line1, line2], 'center', 'center', screenInfo.black);

Screen('TextSize', screenInfo.window, 18);
Screen('TextFont', screenInfo.window, 'Arial');
DrawFormattedText(screenInfo.window, [line3], 'center', [screenInfo.yCenter *1.33], screenInfo.black);


% Flip to the screen
Screen('Flip', screenInfo.window);

[reelInfo] = deBruijn_reels(reelInfo);

% Wait for a key press
KbStrokeWait;
   
% Clear the screen
sca;
