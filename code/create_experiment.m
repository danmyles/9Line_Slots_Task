% ----------------------------------------------------------------------
% create_experiment()
% ----------------------------------------------------------------------
% Goal of this script:
% To generate a set of sequences to use in my 9LST experiment
% ----------------------------------------------------------------------
% Input(s) :
% reelInfo ? takes the reelstrips as input
% ----------------------------------------------------------------------
% Output(s):
% reelInfo - provides updated symbol positions to sym_shape
% ----------------------------------------------------------------------
% Created by Dan Myles (dan.myles@monash.edu)
% Last update : June 2020
% Project : 9_Line_Slots_Task
% Version : 2020a
% ----------------------------------------------------------------------

% Generate the reelstips:
%% Define reel strip pattern

n = 5; % Number of reel symbols - "alphabet"
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

% It will be very useful to know the length of these reels for other
% functions. By using this we can keep large amounts of the code relative
% to allow the length of the reelstrips to change

reelInfo.reel_length = length(reelInfo.reelstrip(:, 1));
