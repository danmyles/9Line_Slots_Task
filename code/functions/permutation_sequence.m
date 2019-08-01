function sequence = permutation_sequence(num_chars, subsequence_length)
% ----------------------------------------------------------------------
% permutation_sequence(num_chars,subsequence_length)
% ----------------------------------------------------------------------
% Goal of the function :
% To generate a column vector that contains a sequence of numbers which 
% contains all perumatations of an alphabet of size n for subsequences of
% size k, without any repeats occuring within each subsequence. 
%
% Like a deBruijn or Kautz sequence, this sequence is circular so that
% the final k-1 members of the last subsequence can wrap around
% the beginning of the sequence.
%
% The sequence also contains no subsequence repeats, so that all
% permutations of n given k choices are represented with equal probability.
% 
% e.g [1; 2; 3] [3; 2; 1] [2; 3; 1] are all required (etc)
%  but [1; 1; 1] [5; 4; 5] [3; 3; 2] cannot occur
% ----------------------------------------------------------------------
% Input(s) :
% num_chars = (n) size of alphabet (number of distinct options). In our 
% case number of symbols in our slot machine
% subsequence_length = (k) number of choices (i.e. length of subsequence) 
% In our case the number of vertical reel positions
%
% NOTE: subsequence_length cannot be greater than alphabet size (num_chars)
% ----------------------------------------------------------------------
% Output(s):
% reelInfo.reelstrip1 and reelInfo.reelstrip2 as described above
% ----------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : 30 July 2019
% Project : 9_Line_Slots_Task
% Version : 2019a
% ----------------------------------------------------------------------
%    
% Calulate no. of total permutations for our input
% Formula for this: n! / (n-k)!
% See: https://en.wikipedia.org/wiki/Permutation

if nargin~=2
    display('Error: num_chars and subsequence_length are undefined')
        sequence = [];
    return
end

if floor(num_chars)~=num_chars | num_chars<1,
    display('Error: Number of characters must be positive integer')
    sequence = [];
    return
end

if floor(subsequence_length)~=subsequence_length | subsequence_length<1,
    display('Error: Subsequence length must be positive integer')
    sequence = [];
    return
end


if subsequence_length == 1,
    sequence = randperm(num_chars)';
    return
end

if subsequence_length > num_chars
    display('subsequence_length cannot be greater than alphabet size (num_chars)')
        sequence = [];
    return
end

% create a progress display bar:
progdisp = figure(...
    'Units',            'normalized',...
    'Position',         [0.5 0.5 0.25 0.02],...
    'NumberTitle',      'off',...
    'Resize',           'off',...
    'MenuBar',          'none',...
    'BackingStore',     'off' );
progaxes = axes(...
    'Position',         [0.02 0.15 0.96 0.70],...
    'XLim',             [0 1],...
    'YLim',             [0 1],...
    'Box',              'on',...
    'ytick',            [],...
    'xtick',            [] );
progpatch = patch(...
    'XData',            [0 0 0 0],...
    'YData',            [0 0 1 1]);

% Create a list of all permutations that do not include subsequence repeats

combination_list = get_permutations(num_chars, subsequence_length);

%==========================================================================

abort_flag = 0;
sequence = [];
%this loop allows multiple attempts to compute the sequence. If an attempt
%has gone on too long (currently, first backtrack time * 4), the program
%will start again.

%==========================================================================
while isempty(sequence), 
    if abort_flag==1
    	display('sequence generation aborted')
        sequence = [];
        return
    end
    [sequence,abort_flag] = attempt_sequence(num_chars,subsequence_length,combination_list,progdisp,progpatch);
end
%==========================================================================
if ishandle(progdisp),
    close(progdisp)
end

function [sequence,abort_flag] = attempt_sequence(num_chars,subsequence_length,combination_list,progdisp,progpatch);

abort_flag = 0;

sequence_length = size(combination_list,1);
tic;

sequence = []; %clear previous sequences
history = []; %clear previous sequence search history
backtrack_indices = []; %clear search route
%pick a starting group of characters at random:
history = randperm(size(combination_list,1));
backtrack_indices{1} = {history};
history = history(1); %add this choice to the search history

%use this starting group as the first element in the sequence:
sequence = combination_list(history,:)';
%current_spot tracks where the function is in the sequence generation:
current_spot = subsequence_length-(subsequence_length-2);
progress = (length(sequence)/(sequence_length+2)); %update progress bar

if ~ishandle(progdisp)
    abort_flag = 1;
    sequence = [];
    return
end

set(progpatch,'XData',[0 progress progress 0])
set(progpatch,'FaceColor',[.55 .6 .8]);
set(progdisp,'Name','Attempting to compute sequence...')
drawnow

%continue until sequence is complete...
backtrack_warning = 0;
while length(sequence)<sequence_length+(subsequence_length-1),
    match = sequence(end-(subsequence_length-2):end); %find the last bit of the sequence so far
    %find subsequences whose 1st members match last members of sequence
    working_combination_list = combination_list; %define an alternate character array
    working_combination_list(history,:) = 0; %zero those entries already chosen
    index = sum(abs(working_combination_list(:,1:subsequence_length-1)...
        - repmat(match',size(working_combination_list,1),1)),2); 
    index = find(index==0);
    backtrack_indices = [backtrack_indices;{index}];
    if sum(index)>0,
        %choose at random from matching subsequences:
        random_pick = randperm(length(index));
        random_pick = random_pick(1);
        index = index(random_pick); 
        %remove this choice from options:
        temp_backtrack = (backtrack_indices{end});
        temp_backtrack(temp_backtrack==index) = [];
        backtrack_indices{end} = {temp_backtrack};
        sequence = [sequence;combination_list(index,end)]; %add new subsequence to sequence
        progress = (length(sequence)/(sequence_length+2)); %update progress bar
        
        if ~ishandle(progdisp)
            abort_flag = 1;
            sequence = [];
            return
        end
        
        set(progpatch,'XData',[0 progress progress 0])
        set(progpatch,'FaceColor',[.55 .6 .8]);
        if backtrack_warning == 0,
            set(progdisp,'Name','Attempting to compute sequence...')
        else
            set(progdisp,'Name','Backtracking and Choosing Alternates...')
        end
        drawnow
        history = [history;index];
    else
        if backtrack_warning == 0,
            attempt_duration = toc*10; %define the cutoff time for restart
        end
        backtrack_warning = 1;
        while length(cell2mat(backtrack_indices{end}))<1,
            if isempty(sequence), % if the code has backtracked to the beginning, 
                sequence = []; %clear sequence
                history = []; %clear previous sequence search history
                backtrack_indices = []; %clear search route
                %pick a starting group of characters at random:
                history = randperm(size(combination_list,1));
                backtrack_indices{1} = {history};
                history = history(1); %add this choice to the search history
                %use this starting group as the first element in the sequence:
                sequence = combination_list(history,:)';
                %current_spot tracks where the function is in the sequence generation:
                current_spot = subsequence_length-(subsequence_length-2);
            else % or if not,
                if length(history)<1
                    sequence = zeros(sequence_length,1);%empty out the sequence.
                    display('sequence generation failed')
                    return
                else
                    history(end) = []; %remove the last history entry
                    backtrack_indices(end) = []; % remove last backtrack index
                    sequence(end) = []; %remove last sequence character
                end
            end
        end
        new_indices = cell2mat(backtrack_indices{end}); % look at the last backtrack index
        random_pick = randperm(length(new_indices)); % choose one at random
        index = new_indices(random_pick(1)); 
        temp_backtrack = cell2mat((backtrack_indices{end}));
        temp_backtrack(temp_backtrack==index) = []; %remove this choice from options
        backtrack_indices{end} = {temp_backtrack}; %add this choice to backtrack index
        sequence = [sequence;combination_list(index,end)]; %add new subsequence to sequence
        progress = (length(sequence)/(sequence_length+2)); %update progress bar
        
        if ~ishandle(progdisp)
            abort_flag = 1;
            sequence = [];
            return
        end
        
        set(progpatch,'XData',[0 progress progress 0])
        set(progpatch,'FaceColor',[.55 .6 .8]);
        if backtrack_warning == 0,
            set(progdisp,'Name','Attempting to compute sequence...')
        else
            set(progdisp,'Name','Backtracking and Choosing Alternates...')
        end
        drawnow
        history = [history;index];
        if toc>attempt_duration %restart if the attempt has gone on too long.
            sequence = []; %empty out the sequence.
            return
        end
    end
end

sequence = sequence(1:sequence_length); %remove circular portion of sequence

%the end.