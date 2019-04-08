%% Script to draw a 9 random symbols onscreen
% Slimmed down draw script
% Bibiliogra phy:
% http://peterscarfe.com/ptbtutorials.html

% Create file directories
% TO DO: create a function that creates a struct full of file path names

% Call setup scripts
[screenInfo] = setup_screen();

% Create reel.Info struct
[reelInfo] = create_reelInfo();

% Fill reel.Info struct with current spin info
update_reelInfo; % also sets up grid dimensions

% Draw a grid
draw_grid;

% Draw each symbol
for i = 1:3
    if i ~= [4, 6]
        switch(reelInfo.sym_shape{i})
            case "circ"
                Screen('FillOval', screenInfo.window, reelInfo.sym_col{i}, reelInfo.sym_position{i});
            case "tri"
                Screen('FillPoly', screenInfo.window, reelInfo.sym_col{i}, reelInfo.sym_position{i}, isConvex);
            case "rect"
                Screen('FillRect', screenInfo.window, reelInfo.sym_col{i}, reelInfo.sym_position{i});
            case "diam"
                Screen('FillPoly', screenInfo.window, reelInfo.sym_col{i}, reelInfo.sym_position{i}, isConvex);
            case "pent"
                Screen('FillPoly', screenInfo.window, reelInfo.sym_col{i}, reelInfo.sym_position{i}, isConvex);
        end
    end
end

% Flip to the screen
Screen('Flip', screenInfo.window);

% Wait for a key press
KbStrokeWait;

% Draw a grid
draw_grid;

% Draw each symbol
for i = [1:3, 7:9]
    if i ~= [4, 6]
        switch(reelInfo.sym_shape{i})
            case "circ"
                Screen('FillOval', screenInfo.window, reelInfo.sym_col{i}, reelInfo.sym_position{i});
            case "tri"
                Screen('FillPoly', screenInfo.window, reelInfo.sym_col{i}, reelInfo.sym_position{i}, isConvex);
            case "rect"
                Screen('FillRect', screenInfo.window, reelInfo.sym_col{i}, reelInfo.sym_position{i});
            case "diam"
                Screen('FillPoly', screenInfo.window, reelInfo.sym_col{i}, reelInfo.sym_position{i}, isConvex);
            case "pent"
                Screen('FillPoly', screenInfo.window, reelInfo.sym_col{i}, reelInfo.sym_position{i}, isConvex);
        end
    end
end

% Flip to the screen
Screen('Flip', screenInfo.window);

% Draw a grid
draw_grid;

% Draw each symbol
for i = [1:3, 7:9]
    if i ~= [4, 6]
        switch(reelInfo.sym_shape{i})
            case "circ"
                Screen('FillOval', screenInfo.window, reelInfo.sym_col{i}, reelInfo.sym_position{i});
            case "tri"
                Screen('FillPoly', screenInfo.window, reelInfo.sym_col{i}, reelInfo.sym_position{i}, isConvex);
            case "rect"
                Screen('FillRect', screenInfo.window, reelInfo.sym_col{i}, reelInfo.sym_position{i});
            case "diam"
                Screen('FillPoly', screenInfo.window, reelInfo.sym_col{i}, reelInfo.sym_position{i}, isConvex);
            case "pent"
                Screen('FillPoly', screenInfo.window, reelInfo.sym_col{i}, reelInfo.sym_position{i}, isConvex);
        end
    end
end

% Flip to the screen
Screen('Flip', screenInfo.window);

% Wait for a key press
KbStrokeWait;

% Draw a grid
draw_grid;

% Draw each symbol
for i = [1:3, 7:9]
    if i ~= [4, 6]
        switch(reelInfo.sym_shape{i})
            case "circ"
                Screen('FillOval', screenInfo.window, reelInfo.sym_col{i}, reelInfo.sym_position{i});
            case "tri"
                Screen('FillPoly', screenInfo.window, reelInfo.sym_col{i}, reelInfo.sym_position{i}, isConvex);
            case "rect"
                Screen('FillRect', screenInfo.window, reelInfo.sym_col{i}, reelInfo.sym_position{i});
            case "diam"
                Screen('FillPoly', screenInfo.window, reelInfo.sym_col{i}, reelInfo.sym_position{i}, isConvex);
            case "pent"
                Screen('FillPoly', screenInfo.window, reelInfo.sym_col{i}, reelInfo.sym_position{i}, isConvex);
        end
    end
end

% Set the size of the fixation cross arms
fixCrossDimPix = 22;

% Set the line width for our fixation cross
lineWidthPix = 1;

% Now we set the coordinates (these are all relative to zero we will let
% the drawing routine center the cross in the center of our monitor for us)
xCoords = [-fixCrossDimPix, fixCrossDimPix, 0, 0];
yCoords = [0, 0, -fixCrossDimPix, fixCrossDimPix];
allCoords = [xCoords; yCoords];

% Draw a fixation cross in white at the centre of the screen
Screen('DrawLines', screenInfo.window, allCoords,...
    lineWidthPix, screenInfo.black, screenCenter, 2);

% Flip cross the the screen
Screen('Flip', screenInfo.window);

% Wait for a key press
KbStrokeWait;

% Draw a grid
draw_grid;

% Draw each symbol
for i = 1:9
    if i ~= [4, 6]
        switch(reelInfo.sym_shape{i})
            case "circ"
                Screen('FillOval', screenInfo.window, reelInfo.sym_col{i}, reelInfo.sym_position{i});
            case "tri"
                Screen('FillPoly', screenInfo.window, reelInfo.sym_col{i}, reelInfo.sym_position{i}, isConvex);
            case "rect"
                Screen('FillRect', screenInfo.window, reelInfo.sym_col{i}, reelInfo.sym_position{i});
            case "diam"
                Screen('FillPoly', screenInfo.window, reelInfo.sym_col{i}, reelInfo.sym_position{i}, isConvex);
            case "pent"
                Screen('FillPoly', screenInfo.window, reelInfo.sym_col{i}, reelInfo.sym_position{i}, isConvex);
        end
    end
end

% Flip to the screen
Screen('Flip', screenInfo.window);

% Wait for a key press
KbStrokeWait;

% Clear the screen
sca;

