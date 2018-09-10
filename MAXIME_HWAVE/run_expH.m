function run_expH

%load trialseq
load trialseq

%randomize trialseq
[a,b]=sort(rand(size(trialseq)));
trialseq=trialseq(b);

%%% filename %%%
filename=strcat(datestr(clock,'yyyy-mm-dd-HHMM'),'m',datestr(clock,'ss'),'s');
disp(filename);

save(filename,'trialseq');

%%% initialize NI %%%
disp('Initializing NI');
NI=H_initialize;

% Randomize 

for i=1:length(trialseq);
    WaitSecs(9.5);
    disp('Waiting for 9.5 s');
    H_stimulate(NI,trialseq(i));
end;



