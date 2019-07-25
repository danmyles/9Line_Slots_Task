function [reelInfo] = setup_reelInfo()
% ----------------------------------------------------------------------
% create_reelInfo()
% ----------------------------------------------------------------------
% Goal of the function :
% SET UP THE reelInfo DATA STRUCTURE
% This script sets up a data struct that will contain information about
% the positions of each symbol determined by the spin, as well as
% information neccesary to draw the shapes the draw. This information is
% contributed to reelInfo using the update_reelInfo function.
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
% Version : development
% ----------------------------------------------------------------------

%% SET UP reelInfo DATA STRUCTURE
reelInfo.colours = zeros(5, 3);   % RGB values for all the colours
reelInfo.sym_shape = zeros(3, 3); % Symbol to display
reelInfo.sym_position = cell(3);  % Symbol screen position in pixels
reelInfo.sym_col = cell(3);       % Symbol RGB values for colour
reelInfo.sym_names = ["circ"; "diam"; "tri"; "rect"; "pent"];   
reelInfo.reelstrip1 = zeros((length(reelInfo.sym_names))^3, 3); % Set to length of deBruijn cycle (k^n)
reelInfo.reelstrip2 = zeros((length(reelInfo.sym_names))^3, 3); % Set to length of deBruijn cycle (k^n)

%% CREATE BASE COLOUR VALUES FOR SYMBOLS
reelInfo.colours(1,:) = [238/255, 000/255, 001/255]; % circ
reelInfo.colours(2,:) = [000/255, 162/255, 255/255]; % diam
reelInfo.colours(3,:) = [229/255, 211/255, 103/255]; % tri
reelInfo.colours(4,:) = [152/255, 230/255, 138/255]; % rect
reelInfo.colours(5,:) = [141/255, 038/255, 183/255]; % pent

%% Define reel strip pattern

% This part of the function will create a reel strip in which the sequence 
% of symbols along the reel will be arranged in a de Bruijn Sequence. 
% That is, a sequence in which every possible sequential order of stimuli 
% is included an equal number of times.

% The shortest circular sequence of length k^n such that every string 
% of length n on the alphabet a of size k occurs as a contiguous 
% subrange of the sequence described by a.
% See : http://mathworld.wolfram.com/deBruijnSequence.html
% Also see: https://cfn.upenn.edu/aguirre/wiki/public:de_bruijn

k = length(reelInfo.sym_names); % Number of reel symbols ? "alphabet"
n = 3; % Number of vertical reel positions - "word length"

% the number of distinct sequences for a given k and n is:

% distinct_solutions = factorial(k)^(k^(n-1))/(k^n); 

% In other words this quickly becomes enormous even for 
% small values of k and n.

% We use the deBruijn generator developed by  W. Owen Brimijoin

% CITATION:
% Brimijoin, W. O., & O?Neill, W. E. (2010). Patterned tone sequences reveal 
% non-linear interactions in auditory spectrotemporal receptive fields in 
% the inferior colliculus. Hearing Research, 267(1?2), 96?110. 
% https://doi.org/10.1016/j.heares.2010.04.005

% For convieniance I have located this function in ./functions
% directory (deBruijn.m).

reelInfo.reelstrip1(:, 1) = deBruijn(5, 3);
reelInfo.reelstrip2(:, 1) = deBruijn(5, 3);
end

