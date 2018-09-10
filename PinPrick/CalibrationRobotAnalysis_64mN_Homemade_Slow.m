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
%% Param.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PeakThreshold = 0.05; %valeur de seuil de detection de pic
Cutoff_Frequency = 50; %[Hz]
Sampling_Frequency = 1000; %[Hz]
[B A] = butter(4,Cutoff_Frequency/(Sampling_Frequency/2),'low');


StartCycleMean = 0;
StopCycleMean = StartCycleMean + 950;

FilterSpecifications = fdesign.notch('N,F0,Q,Ap',6,25,50,1,1000);
NotchFilterDesigned = design(FilterSpecifications);

Notch_Data_Filtering = 0;
Butter_Data_Filtering = 0;


% Params the calib analysis of the datas from the 23 of february 2015 :
% performed on a force and torque sensor Nano43
% PeakThreshold = 0.10; %valeur de seuil de detection de pic
% [B A] = butter(4,10/500,'low');
% Affichage = {'bx' 'go' 'r*' 'k^' 'mp' 'ch' };
% StartCycleMean = 500;
% StopCycleMean = StartCycleMean + 50;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Import Data + Variables + Filtre
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
Fz = [];
Fz_Matrix = [];
RootDir = uigetdir; % open a GUI to select the folder to open (where are stored the data)
CalibrationFilesName = dir(RootDir); % Variable with all the name inside the folder RootDir
CalibrationFilesName(1:2) = []; % delete . and ..
cd(RootDir) % Change the current folder to the folder where are the data

for s = 1:length(CalibrationFilesName)
    
        filename = fullfile(RootDir,CalibrationFilesName(s).name);
        disp(filename)
        DataFiles.FileName{end+1,1} = filename;
        C = importdata(filename);
        c = C.data;
        % Fz(:,s) = c(:,17);
%         Fz(:,s) = -c(:,17);% for the calibration on the force sensor
        Fz = -c(:,9);

        Fz_Matrix(1:length(Fz),s) = Fz;
        
%         PeakThreshold = max(Fz)-0.001;
        %FiltreFz_Nano43 = filtfilt(B, A, Fz);
%         [ValPic, NumCycle] = findpeaks(Fz(:,s),'MINPEAKHEIGHT',PeakThreshold);
%         DataFiles.Fz_mean{end+1,1} = mean(Fz(NumCycle(1)+StartCycleMean:NumCycle(1)+StopCycleMean,s)); %mean(Fz(NumCycle(1)+StartCycleMean:NumCycle(1)+StopCycleMean));
%         DataFiles.Fz_std{end+1,1} = std(Fz(NumCycle(1)+StartCycleMean:NumCycle(1)+StopCycleMean,s)); %std(Fz(NumCycle(1)+StartCycleMean:NumCycle(1)+StopCycleMean));
        [ValPic, NumCycle] = findpeaks(Fz,'MINPEAKHEIGHT',PeakThreshold);
        DataFiles.Fz_mean{end+1,1} = mean(Fz(NumCycle(1)+StartCycleMean:NumCycle(1)+StopCycleMean)); %mean(Fz(NumCycle(1)+StartCycleMean:NumCycle(1)+StopCycleMean));
        DataFiles.Fz_std{end+1,1} = std(Fz(NumCycle(1)+StartCycleMean:NumCycle(1)+StopCycleMean)); %std(Fz(NumCycle(1)+StartCycleMean:NumCycle(1)+StopCycleMean));
        DataFiles.StartCycleMean{end+1,1} = [NumCycle(1)+StartCycleMean];
        DataFiles.StopCycleMean{end+1,1} = [NumCycle(1)+StopCycleMean];%[NumCycle(1)+StopCycleMean];    
               
        %Filter the data
        
        if Notch_Data_Filtering
           Fz_filtered_Notch(:,s) = filter(NotchFilterDesigned,Fz); 
        end
       
        if Butter_Data_Filtering
          Fz_filtered_Butter(:,s) = filtfilt(B,A,Fz);   
        end
            
        % Ploting the data
        figure(s)
        plot(Fz)
        hold on
        if Notch_Data_Filtering
          plot(Fz_filtered_Notch(:,s),'g')  
        end
        if Butter_Data_Filtering
        plot(Fz_filtered_Butter(:,s),'r')
        end
        plot(NumCycle(1),ValPic(1),'r*')
        plot(NumCycle(1)+StartCycleMean,Fz(NumCycle(1)+StartCycleMean),'c*')        
        plot(NumCycle(1)+StopCycleMean,Fz(NumCycle(1)+StopCycleMean),'c*')

        figure(50)
        grid minor
        plot(Fz)
        hold on
        plot(NumCycle(1),ValPic(1),'r*')
        plot(NumCycle(1)+StartCycleMean,Fz(NumCycle(1)+StartCycleMean),'c*')        
        plot(NumCycle(1)+StopCycleMean,Fz(NumCycle(1)+StopCycleMean),'c*')

        title('Calibration of the 64 mN homemade pinprick device - AfterTraining')
        
             C=[];
             c=[];
        Fz_Mean = [Fz_Mean mean(Fz(NumCycle(1)+StartCycleMean:NumCycle(1)+StopCycleMean))];
        Fz = [];
end
X= 0:2700;
plot(X,0.064,'.g','MarkerSize',4)
plot(mean(Fz'),'.r','MarkerSize',5)
xlabel('Time (ms)')
ylabel('Force (N)')
grid minor

MeanFz = mean(Fz_Mean)
StdFz = std(Fz_Mean)




%% Align the force waveform : keeping 1s before and 2s after detection of the peak

for i = 1 : length(CalibrationFilesName)
    
    Fz_Matrix_Align(1:length(Fz_Matrix(DataFiles.StartCycleMean{i}-1000:DataFiles.StartCycleMean{i}+2000,i)),i) = Fz_Matrix(DataFiles.StartCycleMean{i}-1000:DataFiles.StartCycleMean{i}+2000,i);
    
    plot(Fz_Matrix_Align(:,i))
    hold on
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Exporting all the data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

l= length(DataFiles.FileName);
savetable('Results_CalibrationHomemadePinPrick_64mN_DM_BeforeTraining',DataFiles,l);

filename = 'Results_Bart_Paper_64mN__DM_AfterTraining.mat';
save(filename)

