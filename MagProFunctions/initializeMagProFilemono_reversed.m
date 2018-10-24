function  [fileID] = initializeMagProFilemono_reversed(filename,number_trial_in_block)
% initializeMagProFile open and write in a text file specified by the
% filename variable, the first bloc of instructions required by the MagPro
% in order to read experiment protocol file.
% NOTE : the extension given in the filename should be CG3!!!
fileID = fopen(filename,'w');
fprintf(fileID, '[Model Option]\r\n');
fprintf(fileID, 'ModelOption=3\r\n');
fprintf(fileID, '[Main Menu]\r\n');
fprintf(fileID, 'Mode=0\r\n');
fprintf(fileID, 'Current Direction=0\r\n');
fprintf(fileID, 'Wave Form=0\r\n');
fprintf(fileID, 'Inter Pulse Interval=100\r\n');
fprintf(fileID, 'Burst Pulses=0\r\n');
fprintf(fileID, 'Pulse BA Ratio=100\r\n');
fprintf(fileID, '[Timing Menu]\r\n');
fprintf(fileID, 'Timing Control=0\r\n');
fprintf(fileID, 'Rep Rate=3\r\n');
fprintf(fileID, 'Pulses in train=1\r\n');
fprintf(fileID, 'Number of Trains=1\r\n');
fprintf(fileID, 'Inter Train Interval=30\r\n');
fprintf(fileID, '[Trigger Menu]\r\n');
fprintf(fileID, 'Trig Output=1\r\n');
fprintf(fileID, 'Twin Trig output=1\r\n');
fprintf(fileID, 'Twin Trig Input=0\r\n');
fprintf(fileID, 'Polarity Input=1\r\n');
fprintf(fileID, 'Polarity output=1\r\n');
fprintf(fileID, 'Delay Input Trig=0\r\n');
fprintf(fileID, 'Delay Output Trig=0\r\n');
fprintf(fileID, '[Configuration Menu]\r\n');
fprintf(fileID, 'Charge Delay=300\r\n');
fprintf(fileID, 'Auto Discharge Time=60\r\n');
fprintf(fileID, 'Prior Warning Sound=0\r\n');
fprintf(fileID, 'Coil Type Display=1\r\n');
fprintf(fileID, '[MEP Menu]\r\n');
fprintf(fileID, 'Time=5 ms/div\r\n');
fprintf(fileID, 'Sensitivity=500 uV/div\r\n');
fprintf(fileID, 'Scroll=0 ms\r\n');
fprintf(fileID, 'Curve No=0\r\n');
fprintf(fileID, 'Baseline=1\r\n');
fprintf(fileID, 'Lower Freq=100 Hz\r\n');
fprintf(fileID, 'Upper Freq=5 kHz\r\n');
fprintf(fileID, 'Trigger mode=0\r\n');
fprintf(fileID, 'Size=0\r\n');
fprintf(fileID, 'On Top=1\r\n');
fprintf(fileID, '[Protocol Setup]\r\n');
fprintf(fileID,'Number of Lines=%d\r\n',number_trial_in_block);
fclose(fileID);
end
