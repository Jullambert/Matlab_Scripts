function results=run_expSIFEC(trialseq,seq_label,temperature)
results=[];
%%% initialize NI %%%
NI=SIFEC_initialize;

%%% 1=laser
WaitSecs(3);

%%% filename %%%
filename=strcat(datestr(clock,'yyyy-mm-dd-HHMM'),'m',datestr(clock,'ss'),'s');
disp(filename);

%%% wait for keypress 's' to deliver the stimulation %%%
for trialpos=1:length(trialseq);
    disp('Waiting for keypress');
    ok=0;
    while ok==0;
        WaitSecs(1);
        [onset_time,keycode,deltasecs]=KbWait([]);
        disp('Key was pressed');
        [a,b]=max(keycode);
        if b==32;
            disp('SPACE : starting');
            ok=1;
        end;
    end;
    clc;
    WaitSecs(1);
    disp(seq_label{trialpos});
%     LSD_stimulate(trialseq(trialpos,1))
if trialseq(trialpos,1)==1;
    results(trialpos).data=SIFEC_stimulate(NI,20,temperature,30,0,40);
    results(trialpos).trial=trialseq(trialpos,1);
else
end;
disp('OK');
save(filename,'results');
end
end
