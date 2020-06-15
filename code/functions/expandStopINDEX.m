function [stop] = expandStopINDEX(reelInfo, stop)
% Quick switch statement to expand a single reel stop into the three
% indices (centre, above and below).

switch stop
    case 1
        stop = [reelInfo.reel_length, 1, 2];
    case 2
        stop = [1:3];
    case reelInfo.reel_length
        stop = [reelInfo.reel_length - 1:reelInfo.reel_length, 1];
    otherwise
        stop = [stop - 1, stop, stop + 1];
end

end