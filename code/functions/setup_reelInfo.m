function [reelInfo] = setup_reelInfo(screenInfo, reelInfo)
% ----------------------------------------------------------------------
% [reelInfo] = setup_reelInfo(screenInfo, reelInfo)
% ----------------------------------------------------------------------
% Goal of the function :
%
% SET UP THE reelInfo DATA STRUCTURE
% This function and the data structure it sets up have become the 
% defacto major config file. Many of the key information about the
% animations and display settings used in the experiment can be tweaked
% here
%
% This function sets up a data struct that will contain information about
% neccesary to draw the shapes the draw.
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
% Last update : June 2020
% Project : 9_Line_Slots_Task
% Version : 2020a
% ----------------------------------------------------------------------

% -------------------------------------------------------------------------
%% Trial Index
% -------------------------------------------------------------------------
reelInfo.trialIndex = 0; % iterator to keep track of trials

% -------------------------------------------------------------------------
%% Basic symbol information
% -------------------------------------------------------------------------
reelInfo.num_symbols = 5; % Circle, diamond, triangle, rectangle, pentagon, 
% This Rect is used to set the base dimensions used in many of our shapes.
% Computed relative to the screen size so that the shapes are proportional accross monitors.
reelInfo.baseRect = screenInfo.windowRect;
reelInfo.baseRect(3:4) = screenInfo.windowRect(4) / 9;

%% Payout information
% Set possible payout amounts here
reelInfo.payout.amounts = reelInfo.multipliers .* reelInfo.lineBet;
% Slightly smaller rect for payout display background
reelInfo.payout.rect = reelInfo.baseRect .* 0.5;
reelInfo.payout.textSize = reelInfo.baseRect(4)/5;

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

% Progress loading screen
loading_screen(screenInfo, reelInfo, 1);

% -------------------------------------------------------------------------
%% Outcomes
% -------------------------------------------------------------------------

% I've filled all this out with a random draw. This provides a random 
% starting position for the reels when the exp loads.
reelInfo.outcome.stops = randi(reelInfo.reel_length, 1, 2); % Vector with stops for L and R reel
reelInfo.outcome.centre = randi(5, 1); % Symbol to be displayed at centre

% Indices for above and below the stop for reel 1 & 2
for i = [1, 2]
    reelInfo.outcome.allstops(:, i) = expandStopINDEX(reelInfo, reelInfo.outcome.stops(i), 1, 1);
end

% Symbol codes displayed at startup/ replaced with each spin
reelInfo.outcome.dspSymbols = zeros(3, 3); 
reelInfo.outcome.dspSymbols(:, 1) = reelInfo.reelstrip(reelInfo.outcome.allstops(:, 1), 1);
reelInfo.outcome.dspSymbols(2, 2) = reelInfo.outcome.centre;
reelInfo.outcome.dspSymbols(:, 3) = reelInfo.reelstrip(reelInfo.outcome.allstops(:, 2), 2);

reelInfo.outcome.payout = max(reelInfo.payout.amounts); % Payout amount if win occurs on intro spin.

reelInfo.spin = zeros(4, 3); % To hold temporary info for spin animations

% -------------------------------------------------------------------------
%% Timing Information
% -------------------------------------------------------------------------

% Set timing information for experiment in seconds
reelInfo.timing.jitter = 0.200; % Add 0 - 200 ms to FC/Outcome ISI
reelInfo.timing.highlight = 0.500; % Reel Highlighting doesn't need to be jittered
reelInfo.timing.fixationCross = 0.600; % Minimum Time for fiaxtion cross
reelInfo.timing.outcome = 1.000; % Minimum Time before participant can proceed to next trial

% Progress loading screen
loading_screen(screenInfo, reelInfo, 2);

% -------------------------------------------------------------------------
%% Define reel highlighting behaviour
% -------------------------------------------------------------------------

% This allows the user to set the highlighting behaviour of the slot game
%       0 = No highlights (neither wins, nor potential matches)
%       1 = Win highlighting (only wins are highlighted, after they occur)
%       2 = Full highlighting. Both potential matches prior to final symbol
%           and wins are highlighted.
%       3 = Potential match highlighting only (wins are not highlighted)

reelInfo.highlight = 3;

% Progress loading screen
loading_screen(screenInfo, reelInfo, 3);

end

