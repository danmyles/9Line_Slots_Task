Screen('Preference', 'SkipSyncTests', 1);
[w,rect] = Screen('OpenWindow',0,[0 0 0]);
ntrials=10; % number of trials
r=50; % radius of circle in pixels
tmin = 1; % minimum time between trials
tmax = 3; % maximum
rtime = zeros(1,ntrials);
x0=rect(3)/2;
y0=rect(4)/2;
rkey=KbName('Space'); %response key = space bar
for i=1:ntrials
    keyisdown = 1;
    while(keyisdown) % first wait until all keys are released
        [keyisdown,secs,keycode] = KbCheck;
        WaitSecs(0.001); % delay to prevent CPU hogging
    end
    % draw fixation point
    Screen('FrameRect',w,[255 255 255],[x0-3,y0-3,x0+3,y0+3]);
    Screen('Flip',w);
    wait_time = rand * (tmax-tmin) + tmin;
    start_time = GetSecs;
    while(~keycode(rkey))
        if GetSecs-start_time > wait_time
            wait_time = Inf; % so as not to repeat this part
            Screen('FillOval',w,[255 255 255],[x0-r,y0-r,x0+r,y0+r]);
            Screen('Flip',w);
            time0=GetSecs;
        end
        [keyisdown,secs,keycode] = KbCheck;
        WaitSecs(0.001); % delay to prevent CPU hogging
    end
    rtime(i)=secs-time0;
    Screen('Flip',w);
end
Screen('Close',w)
avg_rtime = 1000*mean(rtime) % mean reaction time in milliseconds

          