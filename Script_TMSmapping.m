%% Script made to realize a TMS mapping over M1.
% The trigger will be delivered with a random ISI and for a predefined
% number of stimulation
clc
clear all
%% Parameters of the experiment
ISI_Min = 5;
ISI_Max = 8;
NumberTarget = 200; % related to the number of row and column defined in Visor 2
ISI = randi([ISI_Min,ISI_Max],NumberTarget,1);

disp('The experiment parameters are set up.')
%% Initialization of the NI
SamplingRate = 1000; %frerquency expressed in hertz
TriggerDuration = 1 ; %duration expressed in second
Trigger = zeros(TriggerDuration*SamplingRate,1);
Trigger([10:100],1) = 10;

TMSexpe.NI = daq.createSession('ni');
TMSexpe.NI.Rate = SamplingRate;
TMSexpe.Rate = SamplingRate;

addAnalogOutputChannel(TMSexpe.NI,'Dev1',0,'Voltage');
disp('DAQ initialized')
%% Generation of the experiment itself
SubjectName = input('What is the name of the subject : ','s');
str = input('If ready to start press any key ! ','s');
clc

for k=1:NumberTarget % loop to go through all the stimulation target defined
    TMSexpe.ISI(k) = ISI(k,1);
    disp('_________________')
    disp(['Stimulation # ' num2str(k)])
    queueOutputData(TMSexpe.NI,Trigger);
    prepare(TMSexpe.NI);
    pause(ISI(k,1));
    [data,time]=TMSexpe.NI.startForeground();
    TMSexpe.SubjectReport{k} = input('What did the subject feel? ','s');
end
filename = ['DonneesMapping_' SubjectName];
save(filename)
