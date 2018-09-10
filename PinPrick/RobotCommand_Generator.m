%% It's a script made to generate X randoms stimuli applied thanks to a DensoRobot inside a pre-determinated area
clc;
clear all;
%% Params

mvtCount = 0;
% trialCount = 0;
NrOfTrials = 30;
NrOfMvts = 5;
TimeVelocityStimulus = 100;
TimeSkinContact = 25;
%10 times:
%1 --> displacement to the stimulation coordinate
%2 --> stabilization on the point
%3 --> go in contact with the skin
%4 --> stabilization of the contact
%5 --> go up

NrOfCycles = [200 TimeVelocityStimulus TimeSkinContact TimeVelocityStimulus 1000];
X = zeros(1,NrOfMvts);
Y = zeros(1,NrOfMvts);
Z = [0 -10 -10 0 0];
Rz = zeros(1,NrOfMvts);
Fx = zeros(1,NrOfMvts);
Fx_control = zeros(1,NrOfMvts);
Fy = zeros(1,NrOfMvts);
Fy_control = zeros(1,NrOfMvts);
Fz = zeros(1,NrOfMvts);
Fz_control = zeros(1,NrOfMvts); 
TrigCam = zeros(1,NrOfMvts);
Relative = zeros(1,NrOfMvts) +1;
Acc = zeros(1,NrOfMvts)+100000;




for i = 1:NrOfTrials
    %% This loop will run per number of trials requested
    for j=1:NrOfMvts
        %% This loop run once per mouvement needed for  a trial. 
        mvtCount = mvtCount+1;
        % Test to know the nbr of the "submouvement"
        a = mod(mvtCount,5);
        if a==0
            a=5;
        end
        
        perMvt.TrialNo(mvtCount) = i;
        perMvt.MovNo(mvtCount) = j;
        perMvt.NrOfCycles(mvtCount)=NrOfCycles(a);        
        perMvt.X(mvtCount) = X(j);
        % Test to increment the y position for one row (along a value of x, constant for 75 mvt) of stimuli
        perMvt.Y(mvtCount) = Y(j);
        perMvt.Z(mvtCount) = Z(a);
        perMvt.Rz(mvtCount) = Rz(j);
        perMvt.Fx(mvtCount) = Fx(j);
        perMvt.Fx_control(mvtCount) = Fx_control(j);
        perMvt.Fy(mvtCount) = Fy(j);
        perMvt.Fy_control(mvtCount) = Fy_control(j);
        perMvt.Fz(mvtCount) = Fz(j);
        perMvt.Fz_control(mvtCount)= Fz_control(j);
        perMvt.TrigCam(mvtCount) = TrigCam(j);
        perMvt.Relative(mvtCount) = Relative(j);
        perMvt.Acc(mvtCount) = Acc(j);
    end
%     trialCount = trialCount+1;
end


fields = fieldnames(perMvt);
for f = 1:length(fields)
    perMvt.(fields{f}) = perMvt.(fields{f})(:); %Le (:) C'est pour etre sûr que tout est sous forme de colonne
end
l=length(perMvt.X);

savetable('CalibrationFast2',perMvt,l);
