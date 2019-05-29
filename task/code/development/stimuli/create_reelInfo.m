function [reelInfo] = create_reelInfo()
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
% ----------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : 8th April 2019
% Project : 9_Line_Slots_Task
% Version : development
% ----------------------------------------------------------------------

%% SET UP reelInfo DATA STRUCTURE
reelInfo.reel_ID = cell(3);
reelInfo.colours = zeros(5, 3);% RGB values for all the colours
reelInfo.sym_shape = zeros(3, 3); % Symbol to display
reelInfo.sym_position = cell(3); % Symbol screen position in pixels
reelInfo.sym_col = cell(3); % Symbol RGB values for colour
reelInfo.grid_position = cell(3); % Grid screen position in pixels
reelInfo.sym_names = ["circ"; "diam"; "tri"; "rect"; "pent"];
reelInfo.reelstrip1 = cell((length(reelInfo.sym_names))^3, 3); % Set to length of deBruijn cycle (k^n)
reelInfo.reelstrip2 = cell((length(reelInfo.sym_names))^3, 3); % Set to length of deBruijn cycle (k^n)

%% ASSIGN REEL IDs for quick indexing

for i = 1:3
    for j = 1:3
        reelInfo.reel_ID{j, i} = [j, i];
    end
end

%% CREATE BASE COLOUR VALUES FOR SYMBOLS
reelInfo.colours(1,:) = [238/255, 000/255, 001/255]; % circ
reelInfo.colours(2,:) = [000/255, 162/255, 255/255]; % diam
reelInfo.colours(3,:)  = [229/255, 211/255, 103/255]; % tri
reelInfo.colours(4,:) = [152/255, 230/255, 138/255]; % rect
reelInfo.colours(5,:) = [141/255, 038/255, 183/255]; % pent

end

