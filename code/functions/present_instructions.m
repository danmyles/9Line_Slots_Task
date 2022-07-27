function [] = present_instructions(screenInfo, reelInfo, outputData)
    % ------------------------------------------------------------------------
    % [] = present_instructions(screenInfo, reelInfo, outputData)
    % ------------------------------------------------------------------------
    % Goal of this function:
    % Run through instructions sequence
    % ----------------------------------------------------------------------
    % Input(s) :
    % reelInfo, screenInfo
    % ----------------------------------------------------------------------
    % Function created by Dan Myles (dan.myles@monash.edu)
    % Last update : July 2022
    % Project : 9_Line_Slots_Task
    % Version : 2021a
    % ----------------------------------------------------------------------
       
        % Here I set a large while loop to move through the instructions step by
    % step, the iterator, i will track the position in the
    % instructions.loop struct.
    % The while loop (rather than a for loop) allows the users to move forwards
    % or backwards through these directions
    %   i.e when i = , Instruction =
    %   1 - 'Hello.'
    %   2 - 'Welcome to the 9 Line Slot Task.'
    %   3 - 'In this experiment you will play a simple slot machine.'
    %   ... etc.
    % There are also a number of visual demonstrations throughout the task,
    % these each have there own nested loops or conditionals
    % If i is numeric there is a conditional statement to catch this and 
    % display a visual demonstration.

    % Set Font / Text:
    Screen('TextSize', screenInfo.window, reelInfo.TextSize);
    Screen('TextFont', screenInfo.window, reelInfo.Font);
    Screen('TextColor', screenInfo.window, screenInfo.black);
    
    % Setup instructions 
    instructions.cont = 'Press any key to continue.';

    instructions.prompt = '< Back | Next >';
    
    % comma for thousands, three decimal places, used below
    jf=java.text.DecimalFormat;
    credits = char(jf.format(reelInfo.credits));
    
    instructions.task = {
        %% Opening
        'Hello.'; ...
        'Welcome to the 9 Line Slot Task.'; ...
        'In this experiment you will play a simple slot machine.'; ...
        'It looks like this:'; ...
        1; ... % Display demo 1
        'Each reel will spin just like a slot machine.'; ...
        'If three symbols line up a win occurs...'; ...
        2; ... % Display demo 2
        'Nice!'; ...
        'When a match occurs the centre symbol will display the amount won.'; ...
        ['So in the previous example the payout was ' num2str(reelInfo.multipliers(end)*10) ' credits']; ...
        3; ... % Display demo 3
        'If the centre position doesn''t match you do not win credits.'; ...
        4; ... % Display demo 4
        ':''('; ...
        %% Explain 9 lines
        'There are 5 different symbols:'; ...
        5; ... % Display demo 5
        'Match 3 of the same symbol and the machine will payout!'; ...
        'There are 9 different ways that three symbols can match...'; ...
        6; ... % Display demo 6
        'All potential winning lines will be highlighted during each spin'; ...
        % Betting
        'Before each spin you will be shown your total credits.'; ...
        'You will also be given a choice between two slot machine games.'; ...
        7; ... % Display demo 7
        'Each game is subtly different.'; ...
        'Your task is to determine which of the two games is the most advantageous.'; ...
        'Every bet will cost 90 credits.'; ...
        'That''s 10 credits for each of the 9 ways that a win can occur.'; ...
        ['You have been given ', credits, ' credits to play']; ...
        '1,000 credits = $1'; ...
        '10 credits = 1c'; ...
        'We will pay you the final credit balance at the end of the experiment.'; ...
        'A random process is used to determine the outcome of each spin.'; ...
        'So the final credit balance will depend on how many wins and losses occur.'; ...
        'And how often you decide to bet on each of the two games.'};

    % Some draw dimensions are slightly different for the fixation cross
    % instructions. So I've broken these up so the iterator can make
    % adjustments throughout. See conditional at top of while loop.

    instructions.fixation = {
        % Explain Fixation Cross
        'You may have noticed this symbol during the previous demonstration.'; ...
        'It''s is called a ''fixation cross''.'; ...
        'The fixation cross will appear moments before the final symbol on each trial.'; ...
        'This point indicates where the outcome will be displayed.'; ...
        'Whenever it appears, try to remain still and gently focus your gaze on that point.'; ...
        'Gently hold your gaze without blinking for a moment after the outcome is displayed'; ...
        'Blinks and eye movements impact the accuracy of the EEG recording.'; ...
        'A gentle effort to minimise these actions will improve the recording.'; ...
        'So long as you don''t find this too distracting or uncomfortable.'; ...
        'If you find this distracting or uncomfortable, it''s better to relax and focus on the task.'; ...
        'In the next sequence try to practice keeping your eyes still and focused without straining.'; ...
        % Display demo 8
        8};

    instructions.final = {
        'The experiment will begin in a moment...'; ...
        'If you have any further questions please ask the experimenter now.'
        };

    % Combine instructions into while loop sequence
    instructions.loop = [instructions.task; instructions.fixation; instructions.final];
    
    % Setup demo spins.
    [demoSequence] = setup_demo(reelInfo, outputData);
    
    % ----------------------------------------------------------------------
    %% Instructions
    % ----------------------------------------------------------------------

    % Initiate while loop at 1
    i = 1;
        
    while i < length(instructions.loop) + 1
                
        % Check if fixation instructions
        if i > length(instructions.task) & i <= (length(instructions.loop) - length(instructions.final))
            fixation = 1;
        else
            fixation = 0;
        end
        
        % Demo sequences
        if isnumeric(instructions.loop{i})
            
            demo = instructions.loop{i};
            
            switch demo
                case 1 % Display task first time
                    
                    % Display Reels
                    draw_grid(screenInfo);
                    draw_shapes(screenInfo, reelInfo, reelInfo.pos.LR, trim_centre(reelInfo.outcome.dspSymbols));
                    
                    % Draw key prompt
                    DrawFormattedText(screenInfo.window, instructions.prompt, 'center', screenInfo.cont);
                    
                    % Draw a little red dot :)
                    Screen('FillOval', screenInfo.window, reelInfo.colours(1, :), ...
                           get_dimensions(screenInfo, [screenInfo.xCenter, screenInfo.ydot], 1, [0, 0, 15, 15]));
                    
                case 2 % Demo Win
                    
                    % Display Reels
                    draw_grid(screenInfo);
                    draw_shapes(screenInfo, reelInfo, reelInfo.pos.LR, trim_centre(reelInfo.outcome.dspSymbols));
                    DrawFormattedText(screenInfo.window, instructions.cont, 'center', screenInfo.ydot);
                    Screen('Flip', screenInfo.window);  % Flip to the screen
                    KbWait(-1, 2);                      % Wait for keypress 

                    % Show a win
                    reelInfo.demoIndex = 1;
                    [reelInfo, demoSequence] = present_demo(reelInfo, screenInfo, demoSequence, 1, instructions.prompt);
                
                case 3 % Repeat Win display
                    
                    % Show previous outcome:
                    draw_grid(screenInfo);
                    draw_shapes(screenInfo, reelInfo, screenInfo.splitpos, reelInfo.outcome.dspSymbols);
                    draw_payout(screenInfo, reelInfo); % Display payout
                    
                    % Draw key prompt
                    DrawFormattedText(screenInfo.window, instructions.prompt, 'center', screenInfo.cont);
                    
                    % Draw a little red dot :)
                    Screen('FillOval', screenInfo.window, reelInfo.colours(1, :), ...
                           get_dimensions(screenInfo, [screenInfo.xCenter, screenInfo.ydot], 1, [0, 0, 15, 15]));
                    
                case 4 % Demo Loss
                    
                    reelInfo.demoIndex = 2;
                    [reelInfo, demoSequence] = present_demo(reelInfo, screenInfo, demoSequence, 1, instructions.prompt);
                    
                case 5 % Show symbols
                    
                    % Quick function to draw five symbols to centre.
                    inArow(screenInfo, reelInfo);
                    
                    % Draw key prompt
                    DrawFormattedText(screenInfo.window, instructions.prompt, 'center', screenInfo.cont);
                    
                    % Draw a little red dot :)
                    Screen('FillOval', screenInfo.window, reelInfo.colours(1, :), ...
                           get_dimensions(screenInfo, [screenInfo.xCenter, screenInfo.ydot], 1, [0, 0, 15, 15]));
                    
                case 6 % Show lines
                    
                    % Throw up 9 lines one at a time
                    [i] = demo_lines(screenInfo, reelInfo, instructions, i);
                    
                case 7 % Show betting screen
                    
                    % Show betting screen:
                    draw_Bet(screenInfo, reelInfo, outputData, 1:2);
                    
                    % Draw key prompt
                    DrawFormattedText(screenInfo.window, instructions.prompt, 'center', screenInfo.cont);
                    
                    % Draw a little red dot :)
                    Screen('FillOval', screenInfo.window, reelInfo.colours(1, :), ...
                           get_dimensions(screenInfo, [screenInfo.xCenter, screenInfo.ydot], 1, [0, 0, 15, 15]));
                    
                case 8 % Fixation cross practice
                    
                    reelInfo.demoIndex = 3;
                    [reelInfo, demoSequence] = present_demo(reelInfo, screenInfo, demoSequence, 1, instructions.prompt);
                    
            end
            
        end
        
        % Text draw.
        if ischar(instructions.loop{i})
        
        	% Note the hacky workaround for annoying psychtoolbox textbounds behaviour.
            % The | character sets the height (y dim) of every line to be the same
            % The spaces (repmat) drive the | outside of the window.
            adjust = ceil([screenInfo.screenXpixels / 6]);
            text = ['|' repmat(' ', 1, adjust) instructions.loop{i} repmat(' ', 1, adjust) '|'];

            if fixation == 1
                draw_fixation(screenInfo, reelInfo);    % Fixation cross
                y = screenInfo.yCenter + floor(screenInfo.gridRect(4)/8) * 3;
            else
                y = screenInfo.yCenter;
            end

            DrawFormattedText2(text, ...
                'win', screenInfo.window, ...
                'sx', screenInfo.xCenter, 'sy', y, ...
                'xalign','center','yalign','center','xlayout','center');
            
            % Draw key prompt
            DrawFormattedText(screenInfo.window, instructions.prompt, 'center', screenInfo.cont);

            % Draw a little red dot :)
            Screen('FillOval', screenInfo.window, reelInfo.colours(1, :), ...
                   get_dimensions(screenInfo, [screenInfo.xCenter, screenInfo.ydot], 1, [0, 0, 15, 15]));

        end
        
        % Drawing Finished
        Screen('DrawingFinished', screenInfo.window);      
        
        % Flip to next available frame
        Screen('Flip', screenInfo.window);

        [~, keyCode, ~] = KbWait([], 2); % Wait for keypress
        
        % Code participant response
        % If participant pressed back we need to go back one step
        if any(find(keyCode) == KbName('LeftArrow'))
            if i > 1 % Prevents 0 when i == 1
                i = i-1; 
            end
        elseif any(find(keyCode) == KbName('ESCAPE'))
            sca;
            error('User entered escape during instructions')
        else % we continue
            i = i+1;
        end
        
    end
    
end
