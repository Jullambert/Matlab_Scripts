%% It's a script made to generate X randoms stimuli applied thanks to a DensoRobot inside a pre-determinated area
clc;
clear all;
%% Params

mvtCount = 0;
% trialCount = 0;
NrOfTrials = 1;
% NrOfSubMvt = 5; % SubMouvement is the number of mouveemnt in a pattern that we repeat X times during Y seconds
% Frequency = 1 %Hz
% TimeOfStimuli =  %secondes
NrOfMvts = 100;
%10 times:
%1 --> displacement to the stimulation coordinate
%2 --> stabilization on the point
%3 --> go in contact with the skin
%4 --> stabilization of the contact
%5 --> go up

NrOfCycles = [10000 5 498 4 498];
Z = [0 0 -5 0 0];
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

X = [0 3 6 12]; %length of one square = 15 mm , We use 12  
Ypos = [0:3:12];
Yneg = [12:-3:0];


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
        
       % Test to incerement de X position for the stimuli to deliver 
        if j>0 && j<26
            b=1;
        elseif j>25 && j<51
            b=2;
        elseif j>50 && j<76
            b=3;
        else
            b=4;
        end
        

        perMvt.TrialNo(mvtCount) = i;
        perMvt.MovNo(mvtCount) = j;
        perMvt.NrOfCycles(mvtCount)=NrOfCycles(a);        
        perMvt.X(mvtCount) = X(b);
        % Test to increment the y position for one row (along a value of x, constant for 75 mvt) of stimuli
        if (j>0 && j<26)| (j>50 && j<76)
            c =  mod(floor((mvtCount-1)/5),5)+1;
            perMvt.Y(mvtCount) = -Ypos(c);
        else
            c = mod(floor((mvtCount-1)/5),5)+1;
            perMvt.Y(mvtCount) = -Yneg(c);
        end
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

savetable('LeftHandStimuli1Hz',perMvt,l);
