 
%%% load sequence just created by running 'Prepare_sequence.m', copy the name of the sequence %%%
load('sequence 2017-02-20-1440m40s.mat');

% prepare sounds %%%                              
[y1,Fs1] = audioread('Beep.wav');      
[y2,Fs2] = audioread('Cue.wav');
[y3,Fs3] = audioread('finish.wav');

%%% wait for keypress 'SPACE BAR' to start the script %%%
disp('PRESS SPACE TO START');
ok=0;            
while ok==0;
%     WaitSecs(1); 
    [onset_time,keycode,deltasecs]=KbWait([]);
    disp('Key was pressed');
    [a,b]=max(keycode);
    if b==32;
        ok=1;
    end;
end;

%%% repeat BEEP 30 times every 10 s and display trials on screen, the 30th is low tone %%%
for trialpos=1:length(seqfinal)
    label{trialpos}=num2str(trialpos);
    if seqfinal(trialpos,1)==1
        clc;
        disp(['TRIAL n°',label{trialpos}]);
        WaitSecs(8);
        sound(y2,Fs2);
        WaitSecs(1);
        sound(y1,Fs1);
        disp('PRESS SPACE');
        ok=0; 
        while ok==0;
%             WaitSecs(1);
            [onset_time,keycode,deltasecs]=KbWait([]);
            disp('Key was pressed');
            [a,b]=max(keycode);
            if b==32;
                ok=1;
            end;
        end;
    elseif seqfinal(trialpos,1)==2
        clc;
        disp(['TRIAL n°',label{trialpos}]);
        WaitSecs(8);
        sound(y2,Fs2);
        WaitSecs(1);
        sound(y1,Fs1);
        disp('!!! ASK RATING !!! ');
        disp('PRESS SPACE');
        ok=0;
        while ok==0;
%             WaitSecs(1);
            [onset_time,keycode,deltasecs]=KbWait([]);
            disp('Key was pressed');
            [a,b]=max(keycode);
            if b==32;
                ok=1;
            end;
        end;
    elseif seqfinal(trialpos,1)==3
        clc;
        disp(['TRIAL n°',label{trialpos}]);
        WaitSecs(8);
        sound(y2,Fs2);
        WaitSecs(1);
        sound(y1,Fs1);
        WaitSecs(3);
        sound(y3,Fs3);
        disp('FINISHED');
    elseif seqfinal(trialpos,1)==4
        clc;
        disp(['TRIAL n°',label{trialpos}]);
        WaitSecs(8);
        sound(y2,Fs2);
        WaitSecs(1);
        sound(y1,Fs1);
        WaitSecs(3);
        sound(y3,Fs3);
        disp('!!! ASK RATING !!!');
        disp ('FINISHED');
    end;
end;