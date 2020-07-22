% ----------------------------------------------------------------------
%% Common Phrases
% ----------------------------------------------------------------------
instructions.cont = 'Press any key to continue.';

instructions.break = {
    'Break:'; ...
    'Please take a moment to rest your eyes and get comfortable'; ...
    'When you''re ready, press any key to continue'; ...
    };

instructions.total = 'Your total credits:';

% ----------------------------------------------------------------------
%% Opening
% ----------------------------------------------------------------------
instructions.opening = {
    'Hello.'; ...
    'Welcome to the 9 Line Slot Task.'; ...
    'In this experiment you will play a simple slot machine.'; ...
    'It looks like this:'; ...
    'Each reel will spin just like a slot machine...'; ...
    'If three symbols line up a win occurs.'; ...
    'Nice!'; ...
    'When a match occurs the centre symbol will display the amount won'; ...
    'If the centre position doesn''t match you do not win credits'; ...
    ':''(';
    };

% ----------------------------------------------------------------------
%% Explain 9 lines
% ----------------------------------------------------------------------

instructions.lines = {
    'There are 5 different symbols:'; ...
    'Match 3 in a row of any symbol and the machine will payout!'; ...
    'There are 9 different ways that three symbols can match';
    };

% ----------------------------------------------------------------------
%% Explain Betting
% ----------------------------------------------------------------------

instructions.betting = {
    'Each of these 9 lines is a seperate bet'; ...
    'So if you bet 1 credit per line the total bet will be 9 credits'; ...
    'Before each spin you will be given a choice: Bet low or bet high?'; ...
    'A low bet of 1 credits on each line costs 9 credits'; ...
    'A high bet of 10 credits on each line costs 90 credits'; ...
    'If you bet high it will cost more, but any winnings will be 10x larger';
    };

% ----------------------------------------------------------------------
%% Explain Fixation Cross
% ----------------------------------------------------------------------

instructions.fixation = {
    'You may also have noticed this symbol during the previous demonstration'; ...
    'It''s is called a ''fixation cross'''; ...
    'The fixation cross will appear moments before the final symbol on each trial'; ...
    'Whenever it appears, try to remain still and gently focus your gaze on that point'; ...
    'This will help to improve the accuracy of the EEG recording'; ...
    };

% ----------------------------------------------------------------------
%% Practice
% ----------------------------------------------------------------------
instructions.practice = {
    'You will now be able to view a series of practice spins.'; ...
    'During this period feel free to ask the experimenter any questions'; ...
    'OK let''s go!';
    };
% ----------------------------------------------------------------------
%% Introduce Task
% ----------------------------------------------------------------------
instructions.taskIntro = {
    'You have now been given '; ...
    ' credits to play'; ...
    'We will pay you the final credit balance at the end of the experiment'; ...
	'x credits = $1.00'; ...
    'x credit = 1c'; ...
    'A random process is used to determine the outcome of each spin'; ...
    'So the final credit balance will depend on how many wins and losses occur'; ...
    'The experiment will now begin'; ...
    };

% ----------------------------------------------------------------------
%% Choose Bet
% ----------------------------------------------------------------------

instructions.left = 'Press left';
instructions.right = 'Press right';

% Bet High
instructions.betH = {
    'Bet High'; ...
    '10 credits per line x 9 lines'; ...
    '90 credits per spin'; ...
    'choices remaining'; ...
    };

% Bet Low
instructions.betL = {
    'Bet Low'; ...
    '1 credits per line x 9 lines'; ...
    '9 credits per spin'; ...
    'choices remaining'; ...
    };

% ----------------------------------------------------------------------
%% Fin
% ----------------------------------------------------------------------

% ----------------------------------------------------------------------
%% Demo sequence of spins for instructions
% ----------------------------------------------------------------------
% Get all columns from outputData
demoSequence = array2table(zeros(2, 25));
demoSequence.Properties.VariableNames = outputData.Properties.VariableNames;

% Set jackpot
demoSequence.multiplier(1) = reelInfo.multipliers(end);

% Create a row that wins along the centre.
demoSequence.LStop(1) = strfind(reelInfo.reelstrip(:, 1)', [2 1 3]) + 1;
demoSequence.RStop(1) = strfind(reelInfo.reelstrip(:, 2)', [4 1 5]) + 1;

demoSequence(1, [13:19]) = table(2, 1, 3, 1, 4, 1, 5);

demoSequence(1, 5:6) = table(1, 1);

% Second trial
demoSequence.LStop(2) = strfind(reelInfo.reelstrip(:, 1)', [5 1 3]) + 1;
demoSequence.RStop(2) = strfind(reelInfo.reelstrip(:, 2)', [2 1 4]) + 1;

demoSequence(2, [13:19]) = table(5, 1, 3, 4, 2, 1, 4);

% Assign Trial Numbers
demoSequence.TrialN = [1:height(demoSequence)]';

% Payout
demoSequence.payout = demoSequence.multiplier * 10;
