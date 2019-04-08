function [] = draw_shapes(screenInfo, reelInfo, selectReels)

% Tell PTB that polygons should be convex (concave polygons require much
% more processing)
isConvex = 1;
    
for i = selectReels
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

end
