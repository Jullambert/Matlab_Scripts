function [fileID]=writeMagProsinglepulse(filename,trial_number,delay,amplitude)
fileID = fopen(filename,'a');
fprintf(fileID, 'ModelOption=3\r\n')

[protocol Line 1]
Delay=10000
Amplitude A Gain=8
Mode=2
Current Direction=1
Wave Form=1
Burst Pulses=2
Inter Pulse Interval=2500
BA Ratio=150
Repetition Rate=10
Train Pulses=1

end
