%% It's a script made to generate X randoms stimuli applied thanks to a DensoRobot inside a pre-determinated area
clc;
clear all;
%% Params
LengthAreaX = 40;
LengthAreaY = 60;
mvtCount = 0;
% trialCount = 0;
NrOfTrials = 1;
NrOfMvts = 5*6*10;
%10 times:
%1 --> displacement to the stimulation coordinate
%2 --> stabilization on the point
%3 --> go in contact with the skin
%4 --> stabilization of the contact
%5 --> go up

NrOfCycles = [36 5 60 5 60];
Z = [-5 -5 0 -5 -5];
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

X = [0 3 6 12]; %length of one square = 15 mm , We use 12 because we 
Ypos = [0:1.4:20];
Yneg = [19.6:-1.4:0];


for i = 1:NrOfTrials
    
    for j=1:NrOfMvts
        
        mvtCount = mvtCount+1;
        a = mod(mvtCount,5);
        if a==0
            a=5;
        end
        
        if j>0 && j<76
            b=1;
        elseif j>75 && j<151
            b=2;
        elseif j>150 && j<226
            b=3;
        else
            b=4;
        end
        
        
        perMvt.TrialNo(mvtCount) = i;
        perMvt.MovNo(mvtCount) = j;
        perMvt.NrOfCycles(mvtCount)=NrOfCycles(a);        
        perMvt.X(mvtCount) = X(b);
        
        
        perMvt.Y(mvtCount) = Yneg(b);
        
        
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
