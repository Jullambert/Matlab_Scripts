%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Script made to analyze the calibration files for several conditions 
% for the Homemade pinprick of 64 mN with the DensoRobot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
clear all;
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Param.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PeakThreshold = 0.2; %valeur de seuil de detection de pic
Cutoff_Frequency = 50; %[Hz]
Sampling_Frequency = 1000; %[Hz]
[B A] = butter(4,Cutoff_Frequency/(Sampling_Frequency/2),'low');


StartCycleMean = 80;
StopCycleMean = StartCycleMean + 50;

FilterSpecifications = fdesign.notch('N,F0,Q,Ap',6,25,50,1,1000);
NotchFilterDesigned = design(FilterSpecifications);

% Params the calib analysis of the datas from the 23 of february 2015 :
% performed on a force and torque sensor Nano43
% PeakThreshold = 0.2; %valeur de seuil de detection de pic
% [B A] = butter(4,10/500,'low');
% Affichage = {'bx' 'go' 'r*' 'k^' 'mp' 'ch' };
% StartCycleMean = 80;
% StopCycleMean = StartCycleMean + 50;


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Import Data + Variables + Filtre
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% DataFiles = dataset;
% DataFiles = struct('FileName',{{}}, 'SubjNum',[], 'SubjName',{{}});
DataFiles = [];
DataFiles.FileName = {};
DataFiles.Fz_mean = [];
DataFiles.Fz_std = [];
DataFiles.StartCycleMean = [];
DataFiles.StopCycleMean = [];
Fz_Mean = [];
RootDir = uigetdir;
CalibrationFilesName = dir(RootDir);
CalibrationFilesName(1:2) = []; % delete . and ..
cd(RootDir)

for s = 1:length(CalibrationFilesName)
    
        filename = fullfile(RootDir,CalibrationFilesName(s).name);
        DataFiles.FileName{end+1,1} = filename;
        C = importdata(filename);
        c = C.data;
        Fz(:,s) = -c(:,17);
      
        %FiltreFz_Nano43 = filtfilt(B, A, Fz);
        [ValPic, NumCycle] = findpeaks(Fz(:,s),'MINPEAKHEIGHT',PeakThreshold);
        DataFiles.Fz_mean{end+1,1} = mean(Fz(NumCycle(1)+StartCycleMean:NumCycle(1)+StopCycleMean,s)); %mean(Fz(NumCycle(1)+StartCycleMean:NumCycle(1)+StopCycleMean));
        DataFiles.Fz_std{end+1,1} = std(Fz(NumCycle(1)+StartCycleMean:NumCycle(1)+StopCycleMean,s)); %std(Fz(NumCycle(1)+StartCycleMean:NumCycle(1)+StopCycleMean));
        DataFiles.StartCycleMean{end+1,1} = [NumCycle(1)+StartCycleMean];
        DataFiles.StopCycleMean{end+1,1} = [NumCycle(1)+StopCycleMean];%[NumCycle(1)+StopCycleMean];    
  
        %Filter the data
        Fz_filtered(:,s) = filtfilt(B,A,Fz(:,s));
        Fz_filtered_2(:,s) = filter(NotchFilterDesigned,Fz(:,s));
        
        % Ploting the data
        figure(s)
        plot(Fz(:,s))
        hold on
        plot(Fz_filtered(:,s),'r')
        plot(NumCycle(1),ValPic(1),'r*')
        plot(NumCycle(1)+StartCycleMean,Fz(NumCycle(1)+StartCycleMean,s),'c*')        
        plot(NumCycle(1)+StopCycleMean,Fz(NumCycle(1)+StopCycleMean,s),'c*')

        figure(50)
        grid minor
        plot(Fz(:,s))
        hold on
        plot(NumCycle(1),ValPic(1),'r*')
        plot(NumCycle(1)+StartCycleMean,Fz(NumCycle(1)+StartCycleMean,s),'c*')        
        plot(NumCycle(1)+StopCycleMean,Fz(NumCycle(1)+StopCycleMean,s),'c*')

        title('Calibration of the 64 mN homemade pinprick device - Fast condition')
        
            C=[];
            c=[];
         Fz_Mean = [Fz_Mean mean(Fz(NumCycle(1)+StartCycleMean:NumCycle(1)+StopCycleMean,s))];
end

X= 0:1250;
grid minor
hold on
plot(X,0.064,'.g','MarkerSize',5)
plot(mean(Fz'),'r')
xlabel('Time (ms)')
ylabel('Force (N)')

MeanFz = mean(Fz_Mean)
StdFz = std(Fz_Mean)

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Exporting all the data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
l= length(DataFiles.FileName);
savetable('Results_CalibrationHomemadePinPrick_64mN_Fast_Transducer',DataFiles,l);

filename = 'Results_CalibrationHomemadePinPrick_64mN_Fast_Transducer.mat';
save(filename)
