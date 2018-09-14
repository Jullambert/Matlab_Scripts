%% Script made to generate command files for the SMP for David Gueorguiev's experiment 
% Septembre 2018
% Script made by J.Lambert
clc;
clear all;
%% Parameters of the experiment
% one trial is composed of two consecutive slidings onthe plateform
% for one sliding, the normal force could stay at a baseline value during
% the whole sliding or could be modify by a value equal to DeltaForceN

NbrOfForceCondition = 6;
NbrOfConditionRepetition = 12;
NbrSlidingPerTrial = 2;
ForceCondition = combin1([NbrOfConditionRepetition,NbrOfForceCondition]);
StimCondition = [1,2]; % condition 1 = baseline, condition 2=stimulation with variation of normal force

ForceBaseline = 1; %[N]
DeltaForceN = [0, 0.1 , 0.2, 0.3, 0.38, 0.5]; %[N]

RandomizationForce = 0;
RandomizationStimulation = 0;
%% Parameters for the robot movement
% Here under, the different steps for ONE sliding will be defined,

NbrOfMvts = 9;
NrOfCycles = [500 1000 1000 50 200 50 700 500 1000]; % one cylce = 1ms
X = zeros(1,NbrOfMvts);
Y = [0 0 -20 -21 -25 -26 -40 -40 0] ;%zeros(1,NbrOfMvts);
Z = zeros(1,NbrOfMvts);
Rz = zeros(1,NbrOfMvts);
Fx = zeros(1,NbrOfMvts);
Fx_control = zeros(1,NbrOfMvts);
Fy = zeros(1,NbrOfMvts);
Fy_control = zeros(1,NbrOfMvts);
Fz = repmat(ForceBaseline,1,NbrOfMvts);
Fz_control = [0 1 1 1 1 1 1 0 0]; 
TrigCam = zeros(1,NbrOfMvts);
Relative = zeros(1,NbrOfMvts) +1;
Acc = zeros(1,NbrOfMvts)+50000;
VoltageStimtac = zeros(1,NbrOfMvts);
% NbrOfMvts = 10;
% NrOfCycles = [500 1000 1000 1000 100 100 100 700 500 1000]; % one cylce = 1ms
% X = zeros(1,NbrOfMvts);
% Y = [0 0 -4 -24 -26 -28 -30 -44 -44 0] ;%zeros(1,NbrOfMvts);
% Z = zeros(1,NbrOfMvts);
% Rz = zeros(1,NbrOfMvts);
% Fx = zeros(1,NbrOfMvts);
% Fx_control = zeros(1,NbrOfMvts);
% Fy = zeros(1,NbrOfMvts);
% Fy_control = zeros(1,NbrOfMvts);
% Fz = repmat(ForceBaseline,1,NbrOfMvts);
% Fz_control = [0 1 1 1 1 1 1 1 0 0]; 
% TrigCam = zeros(1,NbrOfMvts);
% Relative = zeros(1,NbrOfMvts) +1;
% Acc = zeros(1,NbrOfMvts)+50000;
% VoltageStimtac = zeros(1,NbrOfMvts);

%% Generating the structure for the experiment
if RandomizationForce
    idx = randperm(size(ForceCondition,1));
    RandomForceCondition=ForceCondition(idx,:);
end
if RandomizationStimulation
    [~,idx2] = sort(rand(NbrOfForceCondition*NbrOfConditionRepetition,numel(StimCondition)),2);
    RandomStimCondition=StimCondition(idx2);
else
    StimCondition = repmat(StimCondition,NbrOfConditionRepetition*NbrOfForceCondition,1);
end
Count = 0;
Xinit = 0;
Yinit = 0;
ConditionCount=0;

for i = 1:NbrOfConditionRepetition*NbrOfForceCondition
    % This loop will run per number of trials requested
    MovementCount=0;
    ConditionCount = ConditionCount+1;
    for k=1:NbrSlidingPerTrial 
        for j=1:NbrOfMvts
        % This loop run once per movement needed for one sliding movement. We multiple by 2 because we have two sliding per trial
            Count = Count+1;
            MovementCount=MovementCount+1;
            % Test to know the nbr of the "submouvement"
            a = mod(Count,NbrOfMvts);
            if a==0
                a=NbrOfMvts;
            end
            perMvt.TrialNo(Count) = i;
            perMvt.MovNo(Count) = MovementCount;
            perMvt.NrOfCycles(Count)=NrOfCycles(a);        
            perMvt.X(Count) = X(a);
            % Test to increment the y position for one row (along a value of x, constant for 75 mvt) of stimuli
            perMvt.Y(Count) = Y(a);
            perMvt.Z(Count) = Z(a);
            perMvt.Rz(Count) = Rz(a);
            perMvt.Fx(Count) = Fx(a);
            perMvt.Fx_control(Count) = Fx_control(a);
            perMvt.Fy(Count) = Fy(a);
            perMvt.Fy_control(Count) = Fy_control(a);
            if RandomizationStimulation
                if RandomStimCondition(i,k)== 1
                    perMvt.Fz(Count) = Fz(a);
                else
                    if RandomizationForce
                        if a==4||a==5||a==6
                            perMvt.Fz(Count) = ForceBaseline-DeltaForceN(RandomForceCondition(i,2));
                        else
                            perMvt.Fz(Count) = Fz(a);
                        end
                    else
                        if a==4||a==5||a==6
                            perMvt.Fz(Count) = ForceBaseline-DeltaForceN(ForceCondition(i,2));
                        else
                            perMvt.Fz(Count) = Fz(a);
                        end
                    end
                end
            else
                if StimCondition(i,k)== 1
                    perMvt.Fz(Count) = Fz(a);
                else
                    if RandomizationForce
                        if a==4||a==5||a==6
                            perMvt.Fz(Count) = ForceBaseline-DeltaForceN(RandomForceCondition(i,2));
                        else
                            perMvt.Fz(Count) = Fz(a);
                        end
                    else
                        if a==4||a==5||a==6
                            perMvt.Fz(Count) = ForceBaseline-DeltaForceN(ForceCondition(i,2));
                        else
                            perMvt.Fz(Count) = Fz(a);
                        end
                    end
                end
            end
            perMvt.Fz_control(Count)= Fz_control(a);
            perMvt.TrigCam(Count) = TrigCam(a);
            perMvt.Relative(Count) = Relative(a);
            perMvt.Acc(Count) = Acc(a);
            perMvt.VoltageStimtac(Count) = VoltageStimtac(a);
        end
    end
%     trialCount = trialCount+1;
end

%% Writing the tsv file
fields = fieldnames(perMvt);
for f = 1:length(fields)
    perMvt.(fields{f}) = perMvt.(fields{f})(:); %Le (:) C'est pour etre sûr que tout est sous forme de colonne
end
l=length(perMvt.X);

savetable('Test_9mvt_NoRand_Acc50000_50',perMvt,l);
save('Test_9mvt_NoRand_Acc50000_50.mat')