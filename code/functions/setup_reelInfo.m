function [reelInfo] = setup_reelInfo()
% ----------------------------------------------------------------------
% setup_reelInfo()
% ----------------------------------------------------------------------
% Goal of the function :
% SET UP THE reelInfo DATA STRUCTURE
% This function sets up a data struct that will contain information about
% the positions of each symbol determined by the spin, as well as
% information neccesary to draw the shapes the draw. 
%
% reelInfo is also passed informaion from the update_reelInfo function.
%
% Symbol codes are loosely assigned by number of sides (exc diam)
%
%                       1 = circle
%                       2 = diamond
%                       3 = triangle
%                       4 = rectangle
%                       5 = pentagon
%
% ----------------------------------------------------------------------
% Input(s) :
% (none)
% ----------------------------------------------------------------------
% Output(s):
% reelInfo - All sub struct are listed below
% ----------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : 8th April 2019
% Project : 9_Line_Slots_Task
% Version : 2019a
% ----------------------------------------------------------------------

%% SET UP reelInfo DATA STRUCTURE
reelInfo.colours = zeros(5, 3);   % RGB values for all the colours
reelInfo.sym_shape = zeros(3, 3); % Symbol to display
reelInfo.sym_position = cell(3);  % Symbol screen position in pixels
reelInfo.sym_names = ["circ"; "diam"; "tri"; "rect"; "pent"];   
% reelInfo.reelstrip1 - created below
% reelInfo.reelstrip2 - created below

%% CREATE BASE COLOUR VALUES FOR SYMBOLS
reelInfo.colours(1,:) = [238/255, 000/255, 001/255]; % circ
reelInfo.colours(2,:) = [000/255, 162/255, 255/255]; % diam
reelInfo.colours(3,:) = [229/255, 211/255, 103/255]; % tri
reelInfo.colours(4,:) = [152/255, 230/255, 138/255]; % rect
reelInfo.colours(5,:) = [141/255, 038/255, 183/255]; % pent

%% Define reel strip pattern

n = length(reelInfo.sym_names); % Number of reel symbols ? "alphabet"
k = 3; % Number of vertical reel positions - "word length"

% Determine reelstrip structure
%       0 = no repetition of symbols within subsequences
%       1 = de Bruijn sequence 
%       2 = Kautz sequence
% For more information see documentation inside generate_reelstrip function

reelInfo.repeatSymbols = 0;

% By default this will generate a sequence of symbols that does not include
% repeats. This can be altered in the config. See documentation for the
% generate_reelstrip function for more information.

[reelInfo] = generate_reelstrip(n, k, reelInfo);

% Create columns for position information (may end up deleting this)

reelInfo.reelstrip1(:, 2:3) = zeros(length(reelInfo.reelstrip1(:, 2)), 2);
reelInfo.reelstrip2(:, 2:3) = zeros(length(reelInfo.reelstrip1(:, 2)), 2);
end

