function [reelInfo] = generate_reelstrip(n, k, reelInfo)
% ----------------------------------------------------------------------
% generate_reelstrip(n, k, reelInfo)
% ----------------------------------------------------------------------
% Goal of the function :
% To select appropriate reelstrip generator given input from
% reelInfo.repeatSymbols value.
% 
% I've also included a fair amount of documentation inside this function
% explaining each alternative. Note that two of the subfunctions were
% written by others and found on MATLAB file exchange (see citations). 
% I edited one of these to create the default setting I wanted for this 
% experiment. Considering that I had to pull both functions apart to 
% understand them I figured I may as well include them as options within 
% the final product.
% ----------------------------------------------------------------------
% Citations:
% ----------------------------------------------------------------------
% 
% deBruijn.m 
%
% Brimijoin, W. O., & O'Neill, W. E. (2010). Patterned tone sequences 
% reveal non-linear interactions in auditory spectrotemporal receptive 
% fields in the inferior colliculus. Hearing Research, 267(1-2), 96-110.
% https://doi.org/10.1016/j.heares.2010.04.005
%
% kautz_generator.m
% 
% Brimijoin, W. O., McShefferty, D., & Akeroyd, M. A. (2010). Auditory 
% and visual orienting responses in listeners with and without
% hearing-impairment. The Journal of the Acoustical Society of America,
% 127(6), 3678-3688.
% https://doi.org/10.1121/1.3409488
% ----------------------------------------------------------------------
% Input(s) :
% n = Number of reel symbols -  "alphabet"
% k = Number of vertical reel positions - "subsequence or word length"
% reelInfo = data structure containing 
% ----------------------------------------------------------------------
% Output(s):
% reelInfo
% ----------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : Augst 2019
% Project : 9_Line_Slots_Task
% Version : 2019a
% ----------------------------------------------------------------------
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Reelstrips that include no repetition inside subsequences %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if reelInfo.repeatSymbols == 0
        
    % This part of the function will create a column vector in which each
    % symbol is represented by the numbers 1 - 5 (by default). This column
    % vector is the shortest possible sequence that includes all possible 
    % arrangments of the 5 symbols (n) accross the 3 vertical positions (k)
    %
    % n = Number of reel symbols -  "alphabet"
    % k = Number of vertical reel positions - "subsequence or word length"
    %
    % Additionally this sequence has the following properties:
    %  - No subsequence can contain an individual symbol more than once. 
    %    In other words, no symbol will repeat within two positions of
    %    where is appears at any point along the strip. 
    %    e.g [1; 2; 1] [5; 5; 4] [1; 3; 3] will not occur.
    %  - This sequence is circular so that the final k-1 elements  of the 
    %    last subsequence can wrap around the first k-1 elements of the 
    %    sequence.
    %
    % The benefit of this is that the machine cannot generate situations 
    % where multiple wins occur. If the experimenter wants multiple wins to
    % occur, consider using de Bruijn sequence (will allow all lines to 
    % come up as one symbol), or Kautz sequence which will prevent
    % consecutive symbols occuring [1; 1; 2] [2; 1; 1] but not [1; 2; 1].
    %
    % This function is based closely on a function for generating Kautz 
    % sequences developed by Owen Brimijoin and collegues. These sequences 
    % are similar in a number of ways. For more information see citation 
    % list at the top of this function or the documentation below.
        
        reelInfo.reelstrip1(:, 1) = permutation_sequence(n, k);
        reelInfo.reelstrip2(:, 1) = permutation_sequence(n, k);       
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Reelstrips that include repetition - de Bruijn sequence %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if reelInfo.repeatSymbols == 1
        
    % This part of the function will create a reel strip in which the sequence
    % of symbols along the reel will be arranged in a de Bruijn Sequence.
    % That is, a sequence in which every possible sequential order of stimuli
    % is included an equal number of times.
        
    % The shortest circular sequence of length k^n such that every string
    % of length n on the alphabet a of size k occurs as a contiguous
    % subrange of the sequence described by a.
    % See : http://mathworld.wolfram.com/deBruijnSequence.html
    % Also see: https://cfn.upenn.edu/aguirre/wiki/public:de_bruijn
        
    % n = Number of reel symbols ? "alphabet"
    % k = Number of vertical reel positions - "word length"
        
    % The number of distinct sequences quickly becomes enormous even 
    % for small values of k and n.
        
    % We use the deBruijn generator developed by W. Owen Brimijoin. 
    % See function information above for full citation.
        
    % For convenience I have located this function in ./functions
    % directory (deBruijn.m).
        
        reelInfo.reelstrip1(:, 1) = deBruijn(n, k);
        reelInfo.reelstrip2(:, 1) = deBruijn(n, k);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% No consecutive repeats inside subsequences - "Kautz Sequence" %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if reelInfo.repeatSymbols == 2
    
    % This part of the function will create a reel strip in which the sequence
    % of symbols along the reel will be arranged in a Kautz Sequence.
    % That is, a sequence in which every possible sequential order of 
    % stimuli is included an equal number of times. But with the additional
    % requirement that subsequence cannot contain any consecutive repeats 
    % element of n.
    %    
    % e.g [1 2 1] is permitted but not [1 1 2]
    %
    % n = Number of reel symbols ? "alphabet"
    % k = Number of vertical reel positions - "word length"
    % 
    % We use the Kautz sequence generator developed by W. Owen Brimijoin. 
    % This was found on MATLAB file exchange. See function information 
    % above for full citation.
    %
    % For convenience I have located this function in ./functions
    % directory (deBruijn.m).
        
        reelInfo.reelstrip1(:, 1) = kautz_generator(n, k);
        reelInfo.reelstrip2(:, 1) = kautz_generator(n, k);
    end
end

