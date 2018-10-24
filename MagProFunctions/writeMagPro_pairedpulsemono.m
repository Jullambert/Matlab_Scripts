function [fileID]=writeMagPro_pairedpulsemono(filename,trial_number,delay,amplitude1,amplitude2,inter_pulse_interval)
fileID = fopen(filename,'a');
fprintf(fileID, '[protocol Line %d]\r\n',trial_number);
fprintf(fileID, 'Delay=%d\r\n',delay);
fprintf(fileID, 'Amplitude A Gain=%d\r\n',amplitude1/10);
fprintf(fileID, 'Mode=2\r\n');
fprintf(fileID, 'Current Direction=1\r\n');
fprintf(fileID, 'Wave Form=0\r\n');
fprintf(fileID, 'Burst Pulses=2\r\n');
fprintf(fileID, 'Inter Pulse Interval=%d\r\n',inter_pulse_interval);
fprintf(fileID, 'BA Ratio=%d\r\n',(amplitude2/amplitude1)*100);
fprintf(fileID, 'Repetition Rate=10\r\n');
fprintf(fileID, 'Train Pulses=1\r\n');
fclose(fileID)
end
