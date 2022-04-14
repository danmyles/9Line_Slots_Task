serialportlist

port = 6;

port = ['COM' num2str(port)];

port = serial(port);

set(port,'BaudRate',9600); % 9600 is recommended by Neurospec

fopen(port);

pulse = repmat(255, 1, 10);

pulse = 2.^([0:7, 7:-1:0]);

for i = repmat(pulse, 1, 50)
    fwrite(port, i)
end

for i = 1:10
    fwrite(port, 255)
    fwrite(port, 0)
end

for i = 1:10
    fwrite(port, 255)
    WaitSecs(0.002)
    fwrite(port, 0)
    WaitSecs(0.002)
end


for i = 1:10
    fwrite(port, 255)
    WaitSecs(0.008)
    fwrite(port, 0)
    WaitSecs(0.008)
end

for i = 1:10
    fwrite(port, 255)
    WaitSecs(0.016)
    fwrite(port, 0)
    WaitSecs(0.016)
end

fclose(port)
delete(port)
