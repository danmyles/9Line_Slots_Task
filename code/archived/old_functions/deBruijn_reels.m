function [reelInfo] = deBruijn_reels(reelInfo)

    %% I HAVE RETIRED THIS FUNCTION 31/05/2019
    % I would like to place some of the information below into the
    % create_reelInfo function.
    
% This script will create a reel strip in which the sequence of symbols
% along the reel will be arranged in a de Bruijn Sequence. That is, a
% sequence in every possible sequential order of stimuli is included an 
% equal number of times.

% The shortest circular sequence of length k^n such that every string 
% of length n on the alphabet a of size k occurs as a contiguous 
% subrange of the sequence described by a.
% See : http://mathworld.wolfram.com/deBruijnSequence.html
% Also see: https://cfn.upenn.edu/aguirre/wiki/public:de_bruijn

k = length(reelInfo.sym_names); % Number of reel symbols ? "alphabet"
n = 3; % Number of vertical reel positions - "word length"

% the number of distinct sequences for a given k and n is:

% distinct_solutions = factorial(k)^(k^(n-1))/(k^n); 

% Clearly the number of possibilities is enormous even for 
% small values of k and n.

% We use the deBruijn generator developed by  W. Owen Brimijoin

% CITATION:
% Brimijoin, W. O., & O?Neill, W. E. (2010). Patterned tone sequences reveal 
% non-linear interactions in auditory spectrotemporal receptive fields in 
% the inferior colliculus. Hearing Research, 267(1?2), 96?110. 
% https://doi.org/10.1016/j.heares.2010.04.005

% Generate de Bruijn cycle with alphabet size k, and permutation lengths of
% n
tempReel = deBruijn(k, n);

% Assign symbol name to each number

% Index symbol postion on reel using length of tempReel
% Select symbol name using indexed tempReel deBruijn number
% Assign this to corresponding position in reelInfo.reelstrip1
for i = 1:length(tempReel)
    switch tempReel(i)
        case 1
            reelInfo.reelstrip1(i) = reelInfo.sym_names{tempReel(i)};
        case 2
            reelInfo.reelstrip1(i) = reelInfo.sym_names{tempReel(i)};
        case 3
            reelInfo.reelstrip1(i) = reelInfo.sym_names{tempReel(i)};
        case 4
            reelInfo.reelstrip1(i) = reelInfo.sym_names{tempReel(i)};
        case 5
            reelInfo.reelstrip1(i) = reelInfo.sym_names{tempReel(i)};
        otherwise
            error("Number of reel symbols in de Bruijn alphabet exceeds reelInfo known symbols.")
    end
end


% Repeat process for reelstrip2

tempReel = deBruijn(k, n);

for i = 1:length(tempReel)
    switch tempReel(i)
        case 1
            reelInfo.reelstrip2(i) = reelInfo.sym_names{tempReel(i)};
        case 2
            reelInfo.reelstrip2(i) = reelInfo.sym_names{tempReel(i)};
        case 3
            reelInfo.reelstrip2(i) = reelInfo.sym_names{tempReel(i)};
        case 4
            reelInfo.reelstrip2(i) = reelInfo.sym_names{tempReel(i)};
        case 5
            reelInfo.reelstrip2(i) = reelInfo.sym_names{tempReel(i)};
        otherwise
            error("Number of reel symbols in de Bruijn alphabet exceeds reelInfo known symbols.")
    end
end

