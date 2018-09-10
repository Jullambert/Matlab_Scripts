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
PeakThreshold = 0.1; %valeur de seuil de detection de pic
[B A] = butter(4,10/500,'low');
Affichage = {'bx' 'go' 'r*' 'k^' 'mp' 'ch' };
StartCycleMean = 80;
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
        X1 = length(Fz);
        %FiltreFz_Nano43 = filtfilt(B, A, Fz);
        [ValPic, NumCycle] = findpeaks(Fz(:,s),'MINPEAKHEIGHT',PeakThreshold);
        if NumCycle(1)+StopCycleMean < length(Fz)
            b = NumCycle(1)+StopCycleMean;
            DataFiles.Fz_mean{end+1,1} = mean(Fz(NumCycle(1)+StartCycleMean:NumCycle(1)+StopCycleMean,s)); 
            DataFiles.Fz_std{end+1,1} = std(Fz(NumCycle(1)+StartCycleMean:NumCycle(1)+StopCycleMean,s)); 
            DataFiles.StartCycleMean{end+1,1} = [NumCycle(1)+StartCycleMean];
            DataFiles.StopCycleMean{end+1,1} = [NumCycle(1)+StopCycleMean];
            
            % Ploting the data
            figure(s)
            plot(Fz(:,s))
            hold on
            plot(NumCycle(1),ValPic(1),'r*')
            plot(NumCycle(1)+StartCycleMean,Fz(NumCycle(1)+StartCycleMean,s),'c*')        
            plot(NumCycle(1)+StopCycleMean,Fz(NumCycle(1)+StopCycleMean,s),'c*')
            Fz_Mean = [Fz_Mean mean(Fz(NumCycle(1)+StartCycleMean:NumCycle(1)+StopCycleMean,s))];
        else
            b = length(Fz);
            DataFiles.Fz_mean{end+1,1} = mean(Fz(NumCycle(1)+StartCycleMean:length(Fz),s)); %mean(Fz(NumCycle(1)+StartCycleMean:NumCycle(1)+StopCycleMean));
            DataFiles.Fz_std{end+1,1} = std(Fz(NumCycle(1)+StartCycleMean:length(Fz),s)); %std(Fz(NumCycle(1)+StartCycleMean:NumCycle(1)+StopCycleMean));
            DataFiles.StartCycleMean{end+1,1} = [NumCycle(1)+StartCycleMean];
            DataFiles.StopCycleMean{end+1,1} = [length(Fz)];%[NumCycle(1)+StopCycleMean];
            disp(s)
            % Ploting the data
            figure(s)
            plot(Fz(:,s))
            hold on
            plot(NumCycle(1),ValPic(1),'r*')
            plot(NumCycle(1)+StartCycleMean,Fz(NumCycle(1)+StartCycleMean,s),'c*')        
            plot(NumCycle(1)+StopCycleMean,Fz(length(Fz),s),'c*')
            Fz_Mean = [Fz_Mean mean(Fz(NumCycle(1)+StartCycleMean:length(Fz),s))];
        end
        
        figure(50)
        grid minor
        plot(Fz(:,s))
        hold on
        plot(NumCycle(1),ValPic(1),'r*')
        plot(NumCycle(1)+StartCycleMean,Fz(NumCycle(1)+StartCycleMean,s),'c*')        
        plot(b,Fz(b,s),'c*')

        title('Calibration of the 64 mN The pinprick device - Fast condition')
        
%         plot(CyclesForMean1,PeaksForMean1,'c*')
%         legend('PinPrickG','PeakDetected')

            C=[];
            c=[];

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
savetable('CalibrationThePinPrick_64mN_Fast',DataFiles,l);


