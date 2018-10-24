function [fileID]=writeMagPro_singlepulsemono_reversed(filename,trial_number,delay,amplitude)
fileID = fopen(filename,'a');
fprintf(fileID, '[protocol Line %d]\r\n',trial_number);
fprintf(fileID, 'Delay=%d\r\n',delay);
fprintf(fileID, 'Amplitude A Gain=%d\r\n',amplitude/10);
fprintf(fileID, 'Mode=0\r\n');
fprintf(fileID, 'Current Direction=0\r\n');
fprintf(fileID, 'Wave Form=0\r\n');
fprintf(fileID, 'Burst Pulses=2\r\n');
fprintf(fileID, 'Inter Pulse Interval=10000\r\n');
fprintf(fileID, 'BA Ratio=100\r\n');
fprintf(fileID, 'Repetition Rate=10\r\n');
fprintf(fileID, 'Train Pulses=1\r\n');
fclose(fileID);
end
