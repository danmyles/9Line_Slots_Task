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
    % Last update : July 2020
    % Project : 9_Line_Slots_Task
    % Version : 2020a
    % ----------------------------------------------------------------------
    
    % Get instructions and demo spins.
    [instructions, demoSequence] = setup_instructions(reelInfo, outputData);
    
    % ----------------------------------------------------------------------
    %% Opening Instructions
    % ----------------------------------------------------------------------
    
    % 1 - 'Hello.'
    % 2 - 'Welcome to the 9 Line Slot Task.'
    % 3 - 'In this experiment you will play a simple slot machine.'
    % 4 - 'It looks like this:'
    for i = 1:4
        
        % Text draw.
        draw_text(screenInfo, reelInfo, instructions, instructions.opening{i});
        Screen('Flip', screenInfo.window);  % Flip to the screen
        KbWait(-1, 2);                      % Wait for keypress
        
    end
    
    % Display Reels
    draw_grid(screenInfo);
    draw_shapes(screenInfo, reelInfo, reelInfo.pos.LR, trim_centre(reelInfo.outcome.dspSymbols));
    DrawFormattedText(screenInfo.window, instructions.cont, 'center', screenInfo.ydot);
    Screen('Flip', screenInfo.window);  % Flip to the screen
    KbWait(-1, 2);                      % Wait for keypress
    
    % WIN DEMO
    % While loop to allow user to repeat instructions if desired.
    keyCode = 38;
    
    while keyCode == 38
        
        % Reset demo interator
        reelInfo.demoIndex = 0;
        
        % 5 - 'When you play each reel will spin just like a slot machine...'; ...
        % 6 - 'If three symbols line up a win occurs.'; ...
        for i = 5:6
            
            % Text draw.
            draw_text(screenInfo, reelInfo, instructions, instructions.opening{i});
            Screen('Flip', screenInfo.window);  % Flip to the screen
            KbWait(-1, 2);                      % Wait for keypress
            
        end
        
        % Show reels:
        draw_grid(screenInfo);
        draw_shapes(screenInfo, reelInfo, reelInfo.pos.LR, trim_centre(reelInfo.outcome.dspSymbols));
        DrawFormattedText(screenInfo.window, instructions.cont, 'center', screenInfo.ydot);
        Screen('Flip', screenInfo.window);  % Flip to the screen
        KbWait(-1, 2);                      % Wait for keypress
        
        % Show a win
        [reelInfo, demoSequence] = present_demo(reelInfo, screenInfo, demoSequence, 1);
        
        % Display next two lines
        % 7 - 'Nice!'; ...
        % 8 - 'When a match occurs the centre symbol will display the amount won'; ...
        for i = 7:8
            draw_text(screenInfo, reelInfo, instructions, instructions.opening{i});
            Screen('Flip', screenInfo.window);  % Flip to the screen
            KbWait(-1, 2);                      % Wait for keypress
        end
        
        % So in the previous example the payout was .... credits
        draw_text(screenInfo, reelInfo, instructions, ...
            ['So in the previous example the payout was ' num2str(reelInfo.multipliers(end)*10) ' credits']);
        Screen('Flip', screenInfo.window);  % Flip to the screen
        KbWait(-1, 2);                      % Wait for keypress
        
        % Show previous outcome:
        draw_grid(screenInfo);
        draw_shapes(screenInfo, reelInfo, screenInfo.splitpos, reelInfo.outcome.dspSymbols);
        draw_payout(screenInfo, reelInfo, 1); % Display payout
        DrawFormattedText(screenInfo.window, instructions.cont, 'center', screenInfo.ydot);
        Screen('Flip', screenInfo.window);  % Flip to the screen
        KbWait(-1, 2);                      % Wait for keypress
        
        % 9 - 'If the centre position doesn't match you do not win credits'
        draw_text(screenInfo, reelInfo, instructions, instructions.opening{9});
        Screen('Flip', screenInfo.window);  % Flip to the screen
        KbWait(-1, 2);                      % Wait for keypress
        
        % LOSS DEMO
        [reelInfo, demoSequence] = present_demo(reelInfo, screenInfo, demoSequence, 1);
        
        % :'(
        draw_text(screenInfo, reelInfo, instructions, instructions.opening{10});
        Screen('Flip', screenInfo.window);                  % Flip
        KbWait(-1, 2);                                      % Wait for keypress
        
        keyCode = 0;
        
        % View these instructions again?
        DrawFormattedText(screenInfo.window,'To view these instructions again press the 9 key\n\nOtherwise press any key to continue', 'center', screenInfo.yCenter);
        Screen('Flip', screenInfo.window);
        [~, keyCode] = KbWait(-1, 2);
        
        % set key down and wait for user to make key press
        keyCode = find(keyCode);
        
    end
    
    % ----------------------------------------------------------------------
    %% Explain Fixation Cross
    % ----------------------------------------------------------------------
    
    % While loop to allow user to repeat instructions if desired.
    keyCode = 38;
    
    while keyCode == 38
        
        % Reset keyCode
        keyCode = 0;
        
        % Cycle through fixation cross instructions.
        for i = 1:length(instructions.fixation)
            
            i = ['|' repmat(' ', 1, 200) instructions.fixation{i} repmat(' ', 1, 200) '|'];
            
            % Text Draw
            DrawFormattedText(screenInfo.window, i, 'center', screenInfo.yCenter + floor(screenInfo.gridRect(4)/8) * 3);
            
            % Draw any key text
            DrawFormattedText(screenInfo.window, instructions.cont, 'center', screenInfo.cont);
            
            % Draw a little red dot :)
            Screen('FillOval', screenInfo.window, reelInfo.colours(1, :), ...
                get_dimensions(screenInfo, [screenInfo.xCenter, screenInfo.ydot], 1, [0, 0, 15, 15]) ...
                );
            
            draw_fixation(screenInfo, reelInfo);    % Fixation cross
            Screen('Flip', screenInfo.window);      % Screen flip
            
            KbWait(-1, 2);                          % Wait for user input
            
        end
        
        % View these instructions again?
        DrawFormattedText(screenInfo.window,'To view these instructions again press the 9 key\n\nOtherwise press any key to continue', 'center', screenInfo.yCenter);
        Screen('Flip', screenInfo.window);
        [~, keyCode] = KbWait(-1, 2);
        
        % set key down and wait for user to make key press
        keyCode = find(keyCode);
        
    end
    
    % ----------------------------------------------------------------------
    %% Explain Lines
    % ----------------------------------------------------------------------
    
    % While loop to allow user to repeat instructions if desired.
    keyCode = 38;
    
    while keyCode == 38
        
        % 'There are 5 different symbols:'; ...
        draw_text(screenInfo, reelInfo, instructions, instructions.lines{1}); % Text Draw
        Screen('Flip', screenInfo.window);                                    % Screen flip
        KbWait(-1, 2);                                                        % Wait for user input
        
        % Show symbols:
        draw_text(screenInfo, reelInfo, instructions, ''); % Empty text draw to get any key text.
        inArow(screenInfo, reelInfo);                      % Quick function to draw five symbols to centre.
        Screen('Flip', screenInfo.window);                 % Screen flip
        KbWait(-1, 2);                                     % Wait for user input
        
        % 2 - 'Match 3 of any symbol and the machine will payout!'; ...
        % 3 - 'There are 9 different ways that a three symbol match can occur'; ...
        for i = 2:3
            draw_text(screenInfo, reelInfo, instructions, instructions.lines{i}); % Text Draw
            Screen('Flip', screenInfo.window);                                    % Screen flip
            KbWait(-1, 2);                                                        % Wait for user input
        end
        
        % Throw up 9 lines one at a time
        demo_lines(screenInfo, reelInfo, instructions);
        
        keyCode = 0;
        
        % View these instructions again?
        DrawFormattedText(screenInfo.window,'To view these instructions again press the 9 key\n\nOtherwise press any key to continue', 'center', screenInfo.yCenter);
        Screen('Flip', screenInfo.window);
        [~, keyCode] = KbWait(-1, 2);
        
        % set key down and wait for user to make key press
        keyCode = find(keyCode);
        
    end
    
    % ----------------------------------------------------------------------
    %% Explain Betting
    % ----------------------------------------------------------------------
    
    % While loop to allow user to repeat instructions if desired.
    keyCode = 38;
    
    while keyCode == 38
        
        % Reset keyCode
        keyCode = 0;
        
        % Cycle through betting instructions.
        % 1 - 'Before each spin you will be shown the total credits you have'
        % 2 - 'You will also be given a choice: Bet low or bet high?'
        for i = 1:2
            draw_text(screenInfo, reelInfo, instructions, instructions.betting{i}); % Text Draw
            Screen('Flip', screenInfo.window);                                      % Screen flip
            KbWait(-1, 2);                                                          % Wait for user input
        end
        
        % Show betting screen:
        draw_Bet(screenInfo, reelInfo, outputData, 1:2)
        % Draw any key text
        DrawFormattedText(screenInfo.window, instructions.cont, 'center', screenInfo.cont);
        % Draw a little red dot :)
        Screen('FillOval', screenInfo.window, reelInfo.colours(1, :), ...
            get_dimensions(screenInfo, [screenInfo.xCenter, screenInfo.ydot], 1, [0, 0, 15, 15]) ...
            );
        Screen('Flip', screenInfo.window); % Flip screen
        KbWait(-1, 2);  % Wait for keyPress
        
        for i = 3:length(instructions.betting)
            draw_text(screenInfo, reelInfo, instructions, instructions.betting{i}); % Text Draw
            Screen('Flip', screenInfo.window);                                      % Screen flip
            KbWait(-1, 2);                                                          % Wait for user input
        end
        
        % View these instructions again?
        DrawFormattedText(screenInfo.window,'To view these instructions again press the 9 key\n\nOtherwise press any key to continue', 'center', screenInfo.yCenter);
        Screen('Flip', screenInfo.window);
        [~, keyCode] = KbWait(-1, 2);
        
        % set key down and wait for user to make key press
        keyCode = find(keyCode);
        
    end
    
    % ----------------------------------------------------------------------
    % FINAL INSTRUCTIONS
    % ----------------------------------------------------------------------
    
    % While loop to allow user to repeat instructions if desired.
    keyCode = 38;
    
    while keyCode == 38
        
        % Reset keyCode
        keyCode = 0;
        
        % Format credits with comma at thousands.
        jf=java.text.DecimalFormat; % comma for thousands, three decimal places
        credits = char(jf.format(reelInfo.credits));
        
        % Credits given:
        draw_text(screenInfo, reelInfo, instructions, ...
            ['You have been given ', credits, ' credits to play']);
        Screen('Flip', screenInfo.window); % Screen flip
        KbWait(-1, 2);                     % Wait for user input
        
        % Cycle through remaining instructions.
        for i = 3:length(instructions.taskIntro)
            draw_text(screenInfo, reelInfo, instructions, instructions.taskIntro{i}); % Text Draw
            Screen('Flip', screenInfo.window);   % Screen flip
            KbWait(-1, 2);                       % Wait for user input
        end
        
        % View these instructions again?
        DrawFormattedText(screenInfo.window,'To view these instructions again press the 9 key\n\nOtherwise press any key to continue', 'center', screenInfo.yCenter);
        Screen('Flip', screenInfo.window);
        [~, keyCode] = KbWait(-1, 2);
        
    end
    
end
