 function [reelInfo, demoSequence] = present_demo(reelInfo, screenInfo, demoSequence, demo, prompt)
    % ----------------------------------------------------------------------
    % [reelInfo] = present_demo(reelInfo)
    % ----------------------------------------------------------------------
    % Goal of the function :
    % This function is a simplified version of the present_trial function
    % designed to display the demo and practice spins during the
    % introduction.
    %
    % ----------------------------------------------------------------------
    % Input(s) :
    % reelInfo: reelstrips, trialIndex
    % demoSequence: stop position, win/loss, payout amount
    % ----------------------------------------------------------------------
    % Output(s):
    % reelInfo: provides updated symbol positions to sym_shape
    % demoSequence: updates shown 0 -> 1
    % ----------------------------------------------------------------------
    % Function created by Dan Myles (dan.myles@monash.edu)
    % Last update : July 2022
    % Project : 9_Line_Slots_Task
    % Version : 2021a
    % ----------------------------------------------------------------------
       
    % Bump previous reelInfo.outcome to reelInfo.previous
    reelInfo.previous = reelInfo.outcome;
    
    % Get payout amount (if win occurs)
    reelInfo.outcome.payout = demoSequence.payout(reelInfo.demoIndex);
    
    % Get reel position to for each reelstrip
    reelInfo.outcome.stops(1) = demoSequence.LStop(reelInfo.demoIndex);
    reelInfo.outcome.stops(2) = demoSequence.RStop(reelInfo.demoIndex);
       
    % Get centre symbol
    reelInfo.outcome.centre = demoSequence.CS(reelInfo.demoIndex);
    
    % Get win/match T/F value
    reelInfo.outcome.match = demoSequence.match(reelInfo.demoIndex);
    
    % Find all indices for above and below the stops on reel 1 & 2
    % Then update reel information
    for i = [1, 2]
        reelInfo.outcome.allstops(:, i) = expandStopINDEX(reelInfo, reelInfo.outcome.stops(i), 1, 1);
    end
    
    % Fill out sym_shape from reel w/ allstops
    reelInfo.outcome.dspSymbols(:, 1) = reelInfo.reelstrip(reelInfo.outcome.allstops(:, 1), 1);
    reelInfo.outcome.dspSymbols(2, 2) = reelInfo.outcome.centre;
    reelInfo.outcome.dspSymbols(:, 3) = reelInfo.reelstrip(reelInfo.outcome.allstops(:, 2), 2);
    
    % ----------------------------------------------------------------------
    %% Spin reels
    % ----------------------------------------------------------------------
    
    % Spin reels
    [reelInfo, demoSequence, FlipTime] = spin(screenInfo, reelInfo, demoSequence, demo);
    
    % ISI for next screen flip
    FlipTime = FlipTime + reelInfo.timing.highlight - screenInfo.halfifi;
        
	% ----------------------------------------------------------------------
    % HIGHLIGHT ACTIVE REELS
    % ----------------------------------------------------------------------

    % Check if active
    if reelInfo.highlight == 2 || reelInfo.highlight == 3

        % This required a fair bit a messing about. Easier if we had some extra
        % variables I could toy with

        % Reel 1
        A = reelInfo.outcome.dspSymbols(1:3, 1);

        % Reel 2
        B = reelInfo.outcome.dspSymbols(1:3, 3);

        % C contains the identities of the matched elements, in our case the
        % symbol or shape code.
        % intersect() finds the locations in which the values of the two
        % vectors are the same.

        [C] = intersect(A, B, 'stable');

        % 1st arg contains indices for where these matches occur in argument A .
        % 2nd arg the same for argument B.
        % 'stable' returns the indices in IA and IB in the order that they
        % occur in argument A

        % Print highlighted squares to screen one match at a time
        % Uses intersect output to select colour (C = colour) (IA/IB to index grid posistion)
        
        for ih = 1:numel(C)

            Ai = ismember(A, C(ih));
            Bi = ismember(B, C(ih));

            % Reel 1 Highlights:
            highlight_pos = screenInfo.gridPos(1:3, :);
            Screen('FrameRect', screenInfo.window, reelInfo.colours(C(ih), :)', highlight_pos(Ai, :)', screenInfo.gridPenWidthPixel.*3);
            % Place another square on the inside of the highlight square (looks nice)
            highlight_pos = [highlight_pos(Ai, 1:2) + (3.*screenInfo.gridPenWidthPixel), highlight_pos(Ai, 3:4) - (3.*screenInfo.gridPenWidthPixel)];
            Screen('FrameRect', screenInfo.window, screenInfo.black, highlight_pos', screenInfo.gridPenWidthPixel)

            % Reel 2 Highlights:
            highlight_pos = screenInfo.gridPos(7:9, :);
            Screen('FrameRect', screenInfo.window, reelInfo.colours(C(ih), :)', highlight_pos(Bi, :)', screenInfo.gridPenWidthPixel.*3);
            % Place another square on the inside of the highlight square (looks nice)
            highlight_pos = [highlight_pos(Bi, 1:2) + (3.*screenInfo.gridPenWidthPixel), highlight_pos(Bi, 3:4) - (3.*screenInfo.gridPenWidthPixel)];
            Screen('FrameRect', screenInfo.window, screenInfo.black, highlight_pos', screenInfo.gridPenWidthPixel)

            draw_grid(screenInfo);
            draw_shapes(screenInfo, reelInfo, reelInfo.pos.LR, trim_centre(reelInfo.outcome.dspSymbols));

            % Flip to the screen
            FlipTime = Screen('Flip', screenInfo.window, FlipTime);
        
            % Wait time between highlighted reels (timing only for visual display)
            FlipTime = FlipTime + reelInfo.timing.highlight - screenInfo.halfifi;

        end

        % Re-draw without highlights
        draw_grid(screenInfo);
        draw_shapes(screenInfo, reelInfo, reelInfo.pos.LR, trim_centre(reelInfo.outcome.dspSymbols));

        % Flip to the screen
        [FlipTime, HLendTime] = Screen('Flip', screenInfo.window, FlipTime);

    end
   
	% ----------------------------------------------------------------------
    %% Fixation cross
    % ----------------------------------------------------------------------
       
    % Draw a fixation cross
    draw_grid(screenInfo);
    draw_shapes(screenInfo, reelInfo, reelInfo.pos.LR, trim_centre(reelInfo.outcome.dspSymbols));
    draw_fixation(screenInfo, reelInfo);
    
    % ISI for next screen flip
    FlipTime = FlipTime + reelInfo.timing.highlight - screenInfo.halfifi;
    
    % Flip to the screen
    [~, FixationOnsetTime] = Screen('Flip', screenInfo.window, FlipTime); % Wait ISI
    
	% ----------------------------------------------------------------------    
    %% Outcome stimulus
    % ----------------------------------------------------------------------
    
    % Caluculate random ISI
    FlipTime = FlipTime + (reelInfo.timing.fixationCross + (rand .* reelInfo.timing.jitter)) - screenInfo.halfifi;
    
    % Draw grid 
    draw_grid(screenInfo);
     
    % Draw shapes
    draw_shapes(screenInfo, reelInfo, reelInfo.pos.All, nonzeros(reelInfo.outcome.dspSymbols));
       
    % Check if win
    if demoSequence.match(reelInfo.demoIndex) == 1
        
        % Win
        
        if reelInfo.highlight == 1 || reelInfo.highlight == 2
        % Highlight winning grid positions and show payout amount
        highlight_win(screenInfo, reelInfo);
        end
        
        % Display payout
        draw_payout(screenInfo, reelInfo);
        
    else
        
        % Loss
        draw_payout(screenInfo, reelInfo);
        
    end
       
    % Flip to the screen (outcome stimulus, payout, win highlights)
    Screen('Flip', screenInfo.window, FlipTime); % Wait ISI for accurate timing
    
    % Wait a moment, before prompt
    WaitSecs(.500);
    
    draw_grid(screenInfo);
    draw_shapes(screenInfo, reelInfo, screenInfo.splitpos, reelInfo.outcome.dspSymbols);
    draw_payout(screenInfo, reelInfo); % Display payout
    
    % Draw key prompt
    DrawFormattedText(screenInfo.window, prompt, 'center', screenInfo.cont);
    
    % Draw a little red dot :)
    Screen('FillOval', screenInfo.window, reelInfo.colours(1, :), ...
           get_dimensions(screenInfo, [screenInfo.xCenter, screenInfo.ydot], 1, [0, 0, 15, 15]));
        
 end

 
 
 
 
 
 
 