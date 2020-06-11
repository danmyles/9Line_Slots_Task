function [reelInfo] = update_reelInfo(reelInfo, screenInfo)
% ----------------------------------------------------------------------
% update_reelInfo(reelInfo, gridInfo)
% ----------------------------------------------------------------------
% Goal of the function :
% Update reelInfo with values from last spin. This function used to be a
% lot longer. I eventually removed most of the content to place in
% individual functions as I found that I had need for each component.
% Function now just runs update_stops and then get_dimensions for all
% active positions.
% ----------------------------------------------------------------------
% Input(s) :
% reelInfo, gridInfo
% ----------------------------------------------------------------------
% Output(s):
% reelInfo - overwrites and updates reelInfo values in the base workspace 
% ----------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : 8th April 2019
% Project : 9_Line_Slots_Task
% Version : 2019a
% ----------------------------------------------------------------------  
% As of August 30th this function is no longer neccesary because the
% draw_shapes function now calls directly to the get_dimensions function to
% fill out the shape draw dimensions. In other words the only thing this
% function was doing was calling update_stops. So for now I have retired
% it.
% ----------------------------------------------------------------------  

%% RANDOMLY DRAW REELSTOPS
% This function randomly selects a position on the reelstrips to "stop" at.
% Information is updated in reelInfo.sym_shape

[reelInfo] = update_stops(reelInfo);

%% ASSIGN SCREEN DIMENSIONS FOR EACH SYMBOL GIVEN POSITION

%% I'm up to here. This section is no longer neccesary as the draw shapes 
    % function now just calls the get_dimensions function directly.

% 
% for i = 1:9 % i is the grid position to draw to
%     if i ~= [4, 6]
%         reelInfo.sym_position{i} = get_dimensions(screenInfo, i, reelInfo.sym_shape(i))
%     end
% end

end