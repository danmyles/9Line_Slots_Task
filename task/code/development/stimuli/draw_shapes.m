%% DRAW ALL SHAPES TO SCREEN
% Draw shapes to position 1:9 excluding position 4 and 6

% I AM TRYING TO TURN THIS INTO A FUNCTION THAT SELECTS REELS (INPUT) TO
% DISPLAY (OUTPUT) OR IGNORE WHEN PRESENTING REELS ONE AT A TIME.

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
