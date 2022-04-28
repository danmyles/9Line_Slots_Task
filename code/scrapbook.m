% Draw grid
draw_grid(screenInfo);
% Draw shapes
draw_shapes(screenInfo, reelInfo, reelInfo.pos.All, nonzeros(reelInfo.outcome.dspSymbols));
draw_payout(screenInfo, reelInfo, 1);

Screen('Flip', screenInfo.window);