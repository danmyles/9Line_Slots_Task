function reelInfo = create_reelInfo()
% ----------------------------------------------------------------------
% create_reelInfo()
% ----------------------------------------------------------------------
% Goal of the function :
% SET UP THE reelInfo DATA STRUCTURE
% This script sets up a data struct that will contain information about
% the positions of each symbol determined by the spin, as well as
% information neccesary to draw the shapes the draw. This information is
% contributed to reelInfo using the update_reelInfo function
% ----------------------------------------------------------------------
% Input(s) :
% (none)
% ----------------------------------------------------------------------
% Output(s):
% reelInfo
% [reelInfo] = create_reelInfo() to call into base workspace
% ----------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : 8th April 2019
% Project : 9_Line_Slots_Task
% Version : development
% ----------------------------------------------------------------------

%% SET UP reelInfo DATA STRUCTURE
reelInfo.reel_ID = cell(3); % Contains Reel ID Row x Reel
reelInfo.sym_position = cell(3); % Symbol screen Position in pixels
reelInfo.sym_shape = cell(3); % Symbol to display
reelInfo.sym_col = cell(3); % Symbol RGB values for colour
reelInfo.grid_position = cell(3); % Grid screen Position in pixels

%% ASSIGN REEL IDs
for i = 1:3
    for j = 1:3
        reelInfo.reel_ID{j, i} = [j, i];
    end
end
end

