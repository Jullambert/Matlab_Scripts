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
PeakThreshold = 0.10; %valeur de seuil de detection de pic
[B A] = butter(4,10/500,'low');
Affichage = {'bx' 'go' 'r*' 'k^' 'mp' 'ch' };
StartCycleMean = 500;
StopCycleMean = StartCycleMean + 50;
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
  
        % Ploting the data

        figure(s)
        plot(Fz(:,s))
        hold on
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

        title('Calibration of the 64 mN The pinprick device')
        
            C=[];
            c=[];
         Fz_Mean = [Fz_Mean mean(Fz(NumCycle(1)+StartCycleMean:NumCycle(1)+StopCycleMean,s))];
end
X= 0:2700;
plot(X,0.064,'.g','MarkerSize',4)
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
savetable('CalibrationThePinPrick_64mN_Slow',DataFiles,l);


