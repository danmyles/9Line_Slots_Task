function [eventInfo] = setup_eventInfo()
% ----------------------------------------------------------------------
% [eventInfo] = setup_eventInfo()
% ----------------------------------------------------------------------
% Goal of the function :
%
% SET UP THE eventInfo DATA STRUCTURE
% Defines all event codes, and assigns them meaningful names
% ----------------------------------------------------------------------
% Input(s) :
% (none)
% ----------------------------------------------------------------------
% Output(s):
% eventInfo - For use with send_trigger()
% ----------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : April 2022
% Project : 9_Line_Slots_Task
% Version : 2021a
% ----------------------------------------------------------------------

% Experiment Start - 251
eventInfo.expStart = 251;

% Experiment End   - 252
eventInfo.expEnd = 252;

% Break Start - 253
eventInfo.breakStart = 253;
% Break End - 254
eventInfo.breakEnd = 254;

% Pulse Code - 255
eventInfo.pulse = 255;

% Block Start - 1
eventInfo.blockStart = 1;
% Block End - 2
eventInfo.blockEnd = 2;

% Trial Start - 3
eventInfo.trialStart = 3;
% Trial End - 4
eventInfo.trialEnd = 4;

% Display Bet - 5
eventInfo.displayBet = 5;

% Bet Choice Response - 6
%   - Choice
% 	  - BLUE - A: 61
% 	  - GREEN - B: 62
%   - Key 
% 	  - Left: 63
% 	  - Right: 64

eventInfo.betChoice.Response = 6;
% BLUE / GREEN 
eventInfo.betChoice.GAME= 61:62;
% LEFT / RIGHT
eventInfo.betChoice.LR = 63:64;

% Spin Animation Start - 71
eventInfo.spinStart = 71;
% Spin Animation End - 72
eventInfo.spinEnd = 72;

% Highlight Sequence Begin - 81
eventInfo.HL.start = 81;
% Highlight Sequence Complete - 82
eventInfo.HL.end = 82;

% Highlighted Quantity
% 	  1. 41
% 	  2. 42
% 	  3. 43  
eventInfo.HL.n = 41:43;

% Display Fixation Cross - 55
eventInfo.FC = 55;

% Display Outcome Stimulus - 10
% SF - Screen flip
eventInfo.outcome.SF = 10;

%    - Loss: 100
%    - Payout
%        - 30: 203
%        - 50: 205
%        - 130: 213
%        - 150: 215
%        - 450: 245
eventInfo.outcome.payout = [100, 203, 205, 213, 215, 245];

% Centre Stimulus: 
% 	  - Circle: 11
% 	  - Diamond: 12
% 	  - Triangle: 13
% 	  - Square: 14
% 	  - Pentagon: 15
eventInfo.outcome.symbol = 11:15;

end