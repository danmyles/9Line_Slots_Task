%% DRAW ALL SHAPES TO SCREEN
% Draw shapes to position 1:9 excluding position 4 and 6

%% DRAW ALL SHAPES TO SCREEN
% Draw shapes to position 1:9 excluding position 4 and 6

% I AM TRYING TO TURN THIS INTO A FUNCTION THAT SELECTS REELS (INPUT) TO
% DISPLAY (OUTPUT) OR IGNORE WHEN PRESENTING REELS ONE AT A TIME.

% function dan_output = draw_shapes(select_reels, reelInfo)
% 
%     for i = select_reels
%         if i ~= [4, 6]
%             switch(reelInfo.sym_shape{i})
%                 case "circ"
%                     Screen('FillOval', window, reelInfo.sym_col{i}, reelInfo.sym_position{i});
%                 case "tri"
%                     Screen('FillPoly', window, reelInfo.sym_col{i}, reelInfo.sym_position{i}, 1);
%                 case "rect"
%                     Screen('FillRect', window, reelInfo.sym_col{i}, reelInfo.sym_position{i});
%                 case "diam"
%                     Screen('FillPoly', window, reelInfo.sym_col{i}, reelInfo.sym_position{i}, 1);
%                 case "pent"
%                     Screen('FillPoly', window, reelInfo.sym_col{i}, reelInfo.sym_position{i}, 1);
%             end
%         end
%     end
% 
% end


for i = 1:9
    if i ~= [4, 6]
        switch(reelInfo.sym_shape{i})
            case "circ"
                Screen('FillOval', window, reelInfo.sym_col{i}, reelInfo.sym_position{i});
            case "tri"
                Screen('FillPoly', window, reelInfo.sym_col{i}, reelInfo.sym_position{i}, isConvex);
            case "rect"
                Screen('FillRect', window, reelInfo.sym_col{i}, reelInfo.sym_position{i});
            case "diam"
                Screen('FillPoly', window, reelInfo.sym_col{i}, reelInfo.sym_position{i}, isConvex);
            case "pent"
                Screen('FillPoly', window, reelInfo.sym_col{i}, reelInfo.sym_position{i}, isConvex);
        end
    end
end
