%% Script to draw a 9 random symbols onscreen
% Script for developing ideas

sca;
close all;
clearvars;
rng shuffle; % See notes below

% It is recomended that the rng be reseeded at the beginning of any MATLAB 
% session if we wish to think of output from the rng as being
% statistically independent. Only needs to be done once at the start of the
% session.

% The deBruijn package notes also recomend reseeding MATLAB rng prior to 
% each session.

% Call setup scripts ?> TODO THIS AS FUNCTION
[screenInfo] = setup_screen();

% Create reel.Info struct
[reelInfo] = create_reelInfo();

% Set up grid
[gridInfo, screenInfo] = setup_grid(screenInfo);

% Fill reel.Info struct with current spin info
[reelInfo] = update_reelInfo(reelInfo, screenInfo, 1:9, 1);

[reelInfo] = deBruijn_reels(reelInfo);

% Give the program maximum priority (limit background programs e.g. antivirus)
priorityLevel = MaxPriority(screenInfo.window);
Priority(priorityLevel);

draw_grid(screenInfo, gridInfo);

% Flip to the screen
Screen('Flip', screenInfo.window);

% Wait for a key press
KbStrokeWait;

%% I WANT TO WRITE A SCRIPT THAT GENERATES Y POSITIONS FOR ALL 125 of the reels
reelspin_pos = zeros(125, 2);
reelspin_pos(:,1) = screenInfo.splitpos{1}(1, 1); % X position for the centre of the left hand grid line

% Y positions for the centre of the left hand grid line
for i = 1:3
reelspin_pos((122 + i) ,2) = screenInfo.splitpos{i}(1, 2);
end

for i = 122:-1:1
    reelspin_pos(i ,2) = reelspin_pos((i + 1) ,2) - (reelspin_pos(125 ,2) - reelspin_pos(124 ,2));
end

%% ADD position information to the second column of deBruijn reel DS

for i = length(reelInfo.reelstrip1):-1:1
   reelInfo.reelstrip1{i,2} = reelspin_pos(i, :);
end

baseRect = [0 0 100 100];
radius = max(baseRect)/1.5;

% Use centre positions to generate appropriate position info for the shape
for i = 1:length(reelInfo.reelstrip1)
     switch(reelInfo.reelstrip1{i, 1})
            case {"tri", "diam", "pent"}
                
                switch(reelInfo.reelstrip1{i, 1})
                    case "tri"
                        numSides = 3;
                    case "diam"
                        numSides = 4;
                    case "pent"
                        numSides = 5;
                end
                
                anglesDeg = linspace(0, 360, numSides + 1 ) - 90;
                anglesRad = anglesDeg * (pi / 180);
                
                xPosVector = cos(anglesRad) .* radius + reelInfo.reelstrip1{i,2}(1); % X
                yPosVector = sin(anglesRad) .* radius + reelInfo.reelstrip1{i,2}(2); % Y
                
                reelInfo.reelstrip1{i, 2} = [xPosVector; yPosVector]';
                
            case {"circ", "rect"}
                reelInfo.reelstrip1{i, 2} = ...
                    CenterRectOnPointd(baseRect, ... % Create Rect using x and y positions
                    reelInfo.reelstrip1{i,2}(1), ... % X
                    reelInfo.reelstrip1{i,2}(2))'; % Y
        end
end    

%% FIND sym_position COMBO ON reelstrip1
%

% I have left this aside for the moment while I change over all my cell
% arrays to matrices to improve speed

% % Go to reelInfo.sym_shape
% strfind()
% 
% reelInfo.sym_shape{1:3}
% 
% reelInfo.reelstrip1{:, 1}
% 
% selectReels = 1:3
% vector = strings(1, 3)
% 
% for i = selectReels
% vector(i) = reelInfo.sym_shape{i}
% end
% 
% % Find row numbers which match this combination
% reelInfo.reelstrip1{:, 1}(vector)
% 
% if reelInfo.reelstrip1{:, 1} == vector(1)
%     if reelInfo.reelstrip1{:, 1} == vector(2)
%         if reelInfo.reelstrip1{:, 1} == vector(3)
%         end
%     end
% end

%% ALTERED DRAW SHAPES FUNCTION HERE

isConvex = 1;

for j = 1:750
    
    for i = 1:125
        switch(reelInfo.reelstrip1{i})
            case "circ"
                Screen('FillOval', screenInfo.window, reelInfo.colours(1, 1:3), reelInfo.reelstrip1{i,2});
            case "diam"
                Screen('FillPoly', screenInfo.window, reelInfo.colours(2, 1:3), reelInfo.reelstrip1{i,2}, isConvex);
            case "tri"
                Screen('FillPoly', screenInfo.window, reelInfo.colours(3, 1:3), reelInfo.reelstrip1{i,2}, isConvex);
            case "rect"
                Screen('FillRect', screenInfo.window, reelInfo.colours(4, 1:3), reelInfo.reelstrip1{i,2});
            case "pent"
                Screen('FillPoly', screenInfo.window, reelInfo.colours(5, 1:3), reelInfo.reelstrip1{i,2}, isConvex);
        end
    end
    
    speed = 50 %% THIS NEEDS TO GO SOMEWHERE ELSE
    
    for i = 1:75 % THIS is a temp fix. We will want the loop to be continuous until it gets a stop input of some kind.
        switch(reelInfo.reelstrip1{i, 1})
            case {"tri", "diam", "pent"}
                reelInfo.reelstrip1{i, 2}(:, 2) = reelInfo.reelstrip1{i, 2}(:, 2) + speed; % Index Y positions only
            case {"circ"}
                reelInfo.reelstrip1{i, 2}([2; 4]) = reelInfo.reelstrip1{i, 2}([2; 4]) + speed; % Index Y positions only
            case {"rect"}
                reelInfo.reelstrip1{i, 2}([2; 4]) = reelInfo.reelstrip1{i, 2}([2; 4]) + speed; % Index Y positions only
        end
    end 
    
    % Draw grid
    draw_grid(screenInfo, gridInfo);
    
    % Flip to the screen
    Screen('Flip', screenInfo.window);
    
end