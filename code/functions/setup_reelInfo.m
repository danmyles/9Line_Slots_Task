function [reelInfo] = setup_reelInfo(screenInfo)
% ----------------------------------------------------------------------
% setup_reelInfo()
% ----------------------------------------------------------------------
% Goal of the function :
%
% SET UP THE reelInfo DATA STRUCTURE
% This function sets up a data struct that will contain information about
% the positions of each symbol determined by the spin, as well as
% information neccesary to draw the shapes the draw. 
%
% This function and the data structure it sets up have become the 
% defacto major config file. Many of the key information about the
% animations and display settings used in the experiment can be tweaked
% here
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
% Last update : 7th April 2020
% Project : 9_Line_Slots_Task
% Version : 2020a
% ----------------------------------------------------------------------

%% SET UP reelInfo DATA STRUCTURES

%% Basic symbol information
reelInfo.colours = zeros(5, 3);   % RGB values for all the colours
reelInfo.num_symbols = 5; % Circle, diamond, triangle, rectangle, pentagon, 
% This Rect is used to set the base dimensions used in many of our shapes.
% Computed relative to the screen size so that the shapes are proportional accross monitors.
reelInfo.baseRect = screenInfo.windowRect;
reelInfo.baseRect(3:4) = screenInfo.windowRect(4) / 9;

%% Payout information
% Set possible payout amounts here
reelInfo.payout.amounts = [0, 60, 120, 500];
% Slightly smaller rect for payout display background
reelInfo.payout.rect = reelInfo.baseRect .* 0.5;
reelInfo.payout.textSize = reelInfo.baseRect(4)/5;

%% Outcome information
reelInfo.outcome.trialNumber = 0 ; % Set N trial to 0 (for indexing output)
reelInfo.outcome.stops = zeros(1, 2); % Vector with stops for L and R reel
reelInfo.outcome.centre = 0; % Symbol to be displayed at centre
reelInfo.outcome.allstops = zeros(3, 2); % Indices for above and below the stop for reel 1 & 2
reelInfo.outcome.dspSymbols = zeros(3, 3); % Symbols codes displayed at this spin
reelInfo.outcome.payout = 0; % Payout amount if win occurs.

reelInfo.spin = zeros(4, 3); % To hold temporary info for spin animations

%% Subsets of reel positions
% To streamline drawing shapes to different combinations of reel positions
% a few subsets of screen position will be useful. These are all saved
% within a nested data structure:
reelInfo.pos.L = screenInfo.splitpos(1:3, :); % Position dimensions for left reel
reelInfo.pos.R = screenInfo.splitpos(7:9, :); % Position dimensions for right reel
reelInfo.pos.LR = [reelInfo.pos.L; reelInfo.pos.R]; % All except centre
reelInfo.pos.All = [reelInfo.pos.L; screenInfo.screenCenter; reelInfo.pos.R]; % All

%% RGB values for symbol colours
reelInfo.colours(1,:) = [238/255, 000/255, 001/255]; % circ
reelInfo.colours(2,:) = [000/255, 162/255, 255/255]; % diam
reelInfo.colours(3,:) = [229/255, 211/255, 103/255]; % tri
reelInfo.colours(4,:) = [152/255, 230/255, 138/255]; % rect
reelInfo.colours(5,:) = [141/255, 038/255, 183/255]; % pent

loading_screen(screenInfo, reelInfo, 1);

%% Define reel strip pattern

n = reelInfo.num_symbols; % Number of reel symbols - "alphabet"
k = 3; % Number of vertical reel positions - "word length"

% By default generate_reelstrip will generate a sequence of symbols that 
% does not include repeats. This feature can be changed as below by
% defining the repeatSymbols setting.

% Determine reelstrip structure
%       0 = no repetition of symbols within subsequences
%       1 = de Bruijn sequence 
%       2 = Kautz sequence
% For more information see documentation inside generate_reelstrip function

reelInfo.repeatSymbols = 0;

[reelInfo] = generate_reelstrip(screenInfo, n, k, reelInfo);

loading_screen(screenInfo, reelInfo, 3)

% It will be very useful to know the length of these reels for other
% functions. By using this we can keep large amounts of the code relative
% to allow the length of the reelstrips to change

reelInfo.reel_length = length(reelInfo.reelstrip(:, 1));

%% Define reel highlighting behaviour

% This allows the user to set the highlighting behaviour of the slot game
%       0 = No highlights (neither wins, nor potential matches)
%       1 = Win highlighting (only wins are highlighted, after they occur)
%       2 = Full highlighting. Both potential matches prior to final symbol
%           and wins are highlighted.
%       3 = Potential match highlighting only (wins are not highlighted)

reelInfo.highlight = 3;

end

