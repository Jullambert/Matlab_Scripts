%% It's a script made to generate X randoms stimuli applied thanks to a DensoRobot
% inside a pre-determinated area (which is inside to co-centered circles )

% The movement sequence of a stimulation is :
%   1)Postionning above the point to stimulate within the defined area
%   2)Random number of time to wait before stimulation (ISI)
%   3)Going down in order to go in contact with the skin
%   4)Staying in the lower position (so in contact with the skin)
%   5)Going up in order to stop the contact with the skin

% All the movement will be processed at once , meaning that there will be 
% only one trial with X repetition of a movement
% !!!! If kindMvt = 1==> the reference should be the center on the circles 
clc;
clear all;

%% Stimulation Parameters
Number_Stimulations = 20;
X_Coord = zeros(Number_Stimulations,1);
Y_Coord = zeros(Number_Stimulations,1);
X_Init = 100; % value ~=0 necessary if the ParamMvtType ~=1
Y_Init = 50; % value ~=0 necessary if the ParamMvtType ~=1
R_NoStim = 10; %[mm]
R_Stim = 20; %[mm]
ISI_Min = 2; %[s]
ISI_Max = 8;%[s]
MinimalDistanceBetweenStim = 2;%[mm] Same condition for X and Y axis
%% Robot related Params
mvtCount = 0;
NbrOfMvts = 5;
TimeVelocityStimulus = 900; % Correspond to the number of cycles (so ms) 
% necessary for the 15 mm displacement along the z-axis.
% Those values correspond to the values used in the script for the
% RajebRobot
TimeContactWithSkin = 1000;
ParamZ = [0 0 -15 -15 0];
ParamRz = zeros(1,NbrOfMvts);
ParamFx = zeros(1,NbrOfMvts);
ParamFx_control = zeros(1,NbrOfMvts);
ParamFy = zeros(1,NbrOfMvts);
ParamFy_control = zeros(1,NbrOfMvts);
ParamFz = zeros(1,NbrOfMvts);
ParamFz_control = zeros(1,NbrOfMvts); 
ParamTrigCam = zeros(1,NbrOfMvts);
ParamMvtType = ones(1,NbrOfMvts); 
% 0 => every displacement in absolute value 
% 1 => in relative position according to a reference defined in the LV program
Acceleration = 100000.* ones(1,NbrOfMvts);

Plot = 1;
%% Preparation of the X-Y coordinates
ISI_Min = ISI_Min*1000; %[ms]
ISI_Max = ISI_Max*1000; %[ms]
ISI = randi([ISI_Min,ISI_Max],Number_Stimulations,1); %to get the ISI in ms which is needed according to the DensoRobot LabView program
R = randi([R_NoStim+1,R_Stim-1],Number_Stimulations,1); %produces a random vector whose length is <=radius
Theta = randn(Number_Stimulations,1).*2.*pi; % produces a random angle

for i=1:Number_Stimulations
    X_Coord(i,1) = R(i).*cos(Theta(i)); %calculate x coord
    Y_Coord(i,1) = R(i).*sin(Theta(i)); % calculate y coord
end

n=1;
while n<Number_Stimulations
    n=n+1;
    if ((round(X_Coord(n-1),1)== round(X_Coord(n),1)) && (round(Y_Coord(n-1),1)==round(Y_Coord(n),1)))||(abs(round(X_Coord(n-1),1)-round(X_Coord(n),1))<MinimalDistanceBetweenStim && abs(round(Y_Coord(n-1),1)-round(Y_Coord(n),1))<MinimalDistanceBetweenStim)
        R = randi([R_NoStim,R_Stim],Number_Stimulations,1); %produces a random vector whose length is <=radius
        Theta = randn(Number_Stimulations,1).*2.*pi; % produces a random angle
        for i=1:Number_Stimulations
            X_Coord = R(i).*cos(Theta(i)); %calculate x coord
            Y_Coord = R(i).*sin(Theta(i)); % calculate y coord
        end
        n=1;
    end
end
clear i

%% Creating the commands table for the DensoRobot
for i = 1:Number_Stimulations
    StimCycles = [1000 ISI(i) TimeVelocityStimulus TimeContactWithSkin TimeVelocityStimulus ];
    % This loop will run per number of trials requested
    for j=1:NbrOfMvts
        % This loop run once per mouvement needed for  a trial. 
        mvtCount = mvtCount+1;
        % Test to know the nbr of the "submouvement"
        a = mod(mvtCount,NbrOfMvts);
        if a==0
            a=NbrOfMvts;
        end
        TrialNo(mvtCount,1) = 1;
        NbrCycles(mvtCount,1)= StimCycles(j);
        if ParamMvtType(j)
            X(mvtCount,1) = round(X_Coord(i),2);
            Y(mvtCount,1) = round(Y_Coord(i),2);
        else
            X(mvtCount,1) = round(X_Coord+X_Init,2);
            Y(mvtCount,1) = round(Y_Coord+Y_Init,2);
        end
        Z(mvtCount,1) = ParamZ(a);
        Rz(mvtCount,1) = ParamRz(j);
        Fx(mvtCount,1) = ParamFx(j);
        Fx_control(mvtCount,1) = ParamFx_control(j);
        Fy(mvtCount,1) = ParamFy(j);
        Fy_control(mvtCount,1) = ParamFy_control(j);
        Fz(mvtCount,1) = ParamFz(j);
        Fz_control(mvtCount,1)= ParamFz_control(j);
        TrigCam(mvtCount,1) = ParamTrigCam(j);
        Relative(mvtCount,1) = ParamMvtType(j);
        Acc(mvtCount,1) = Acceleration(j);
    end
%     trialCount = trialCount+1;
end
MovNo(:,1) = [1 : Number_Stimulations*NbrOfMvts]';
Table_DensoRobot_TactileStim = table(TrialNo,MovNo,NbrCycles,X,Y,Z,Rz,Fx,Fx_control,Fy,Fy_control,Fz,Fz_control,TrigCam,Relative,Acc);
MovNo(:,1) = [1 : Number_Stimulations*NbrOfMvts]';
if Plot
    R1 = R_NoStim;
    Theta1 = 0:0.1:2*pi;
    X1 = X_Init+ R1.*cos(Theta1); 
    Y1 = Y_Init+ R1.*sin(Theta1);
    R2 = R_Stim;
    X2 = X_Init + R2.*cos(Theta1); 
    Y2 = Y_Init + R2.*sin(Theta1);
    figure
    plot(X1,Y1,'r')
    hold on
    plot(X2,Y2,'r')
    for i=1:Number_Stimulations
    plot(X_Coord(i)+X_Init,Y_Coord(i)+Y_Init,'*')
    text(X_Coord(i)+X_Init,Y_Coord(i)+Y_Init,num2str(i))
    end
end

TotalTime = sum(NbrCycles(:,1));
TotalTimeMinute = TotalTime/(1000*60);
%% Exporting the table into a .mat file and a .tsv file
save('Table_DensoRobot_TactileStim.mat','TrialNo','MovNo','NbrCycles','X','Y','Z','Rz','Fx','Fx_control','Fy','Fy_control','Fz','Fz_control','TrigCam','Relative','Acc');
writetable(Table_DensoRobot_TactileStim,'Table_DensoRobot_TactileStim.txt','Delimiter','tab','WriteRowNames',true)


