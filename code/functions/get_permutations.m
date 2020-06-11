function [k_perms] = get_permutations(n, k)
% ----------------------------------------------------------------------
% get_permutations()
% ----------------------------------------------------------------------
% Goal of the function :
% Generate a list of all permutations for n given k WITHOUT REPLACEMENT 
% That is there should be no repititions of any element of n in side each
% subsequence of length k.
%
% MATLAB Does not have a function to generate permutations in this way
% ----------------------------------------------------------------------
% Input(s) :
% n = size of alphabet (number of distinct options) - in our case number of
% symbols
% k = number of choices (i.e. length of subsequence) - in our case vertical
% NOTE: *k cannot be greater than n*
% ----------------------------------------------------------------------
% Output(s):
% all_perms = A matrix of all possible permutations of symbols in each reel
% position
% ----------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : 30 July 2019
% Project : 9_Line_Slots_Task
% Version : 2019a
% ----------------------------------------------------------------------
    
% Calulate no. of total permutations for our input
% Formula for this: n! / (n-k)!
% See: https://en.wikipedia.org/wiki/Permutation
    
    total_perm = factorial(n) / factorial( (n - k));
    
    if total_perm > 1320;
        
        % Anything involving combinatorics has a tendancy to scale really
        % rapidly so this is a fail safe to keep things within reason.
        % I doubt I'll be generating anything other than n = 5, k = 3
        % anyway. See else statement below for warning message.
        
        warning('Total permutations too large. Function cancelled')
        
    else
               
        % Our output matrix will therefore need to have nperm() different
        % (rows) for k choices each (columns).
        
        k_perms = zeros(total_perm, k);
        
        % MATLAB allows us to calculate all permutations without repitions 
        % but does not allow us to set the number of choices
        
        all_perms = perms(1:n);
        
        % If we just take the first k rows we will have all our
        % permutations.
        
        all_perms = all_perms(: , 1:k);
        
        % However, we now have lots of repeats.
        % For example: [1, 2, 3, 4, 5] & [1, 2, 3 ,5, 4] will both produce 
        % the shorter [1, 2, 3] if n = 5 and k = 3.
        
        % To fix this, all we have to do now is find and delete repeats
        
        k_perms = unique(all_perms, 'rows');
    end
    
end