% SET MMBT TO SIMPLE MODE

% Set duration of serial port pulse
% Should be slightly larger than 2 / sampling rate
% pulseDuration = 0.004; % 512 Hz
pulseDuration = 0.002; % 1024 Hz

% Get list of serial devices
s = serialportlist;

% Select device n (YOU MAY NEED TO CHECK THIS PRIOR TO EACH SESSION)
n = 2;
s = serialport(s(n), 9600);
clear n;

write(s, 0, 'uint8');

for i = ones(1, 60)
% Reset / all triggers off
    write(s, i, 'uint8');
    WaitSecs(pulseDuration);
    write(s, 0, 'uint8');
    WaitSecs(0.1);
end
    
for i = 0:255
    % Reset / all triggers off
    write(s, i, 'uint8');
    WaitSecs(pulseDuration);
    write(s, 0, 'uint8');
    WaitSecs(0.1);
end


