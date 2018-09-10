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
PeakThreshold = 0.04; %valeur de seuil de detection de pic
PeakThreshold_Ft = 0.02;
Cutoff_Frequency = 50; %[Hz]
Sampling_Frequency = 1000; %[Hz]
[B A] = butter(4,Cutoff_Frequency/(Sampling_Frequency/2),'low');


StartCycleMean = 50;
StopCycleMean = StartCycleMean + 800;

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
DataFiles.Ft_mean = [];
DataFiles.Ft_std = [];
DataFiles.StartCycleMeanFt = [];
DataFiles.StopCycleMeanFt = [];
DataFiles.NumCyclePeak=[];
RootDir = uigetdir; % open a GUI to select the folder to open (where are stored the data)
CalibrationFilesName = dir(RootDir); % Variable with all the name inside the folder RootDir
CalibrationFilesName(1:2) = []; % delete . and ..
cd(RootDir) % Change the current folder to the folder where are the data

Fz_Mean = [];
Fz = zeros(8000,20);
Fz_Peak = [];
Ft_Mean = [];
Ft = zeros(8000,20);
Ft_Peak = [];
Ft_Matrix = [];
%% Normal Force
for s = 1:length(CalibrationFilesName)
    
        filename = fullfile(RootDir,CalibrationFilesName(s).name);
        disp(filename)
        DataFiles.FileName{end+1,1} = filename;
        C = importdata(filename);
        c = C.data;
        Fz(1:length(c(:,3)),s) = -c(:,3);
        
%         PeakThreshold = max(Fz)-0.001;
        %FiltreFz_Nano43 = filtfilt(B, A, Fz);
%         [ValPic, NumCycle] = findpeaks(Fz(:,s),'MINPEAKHEIGHT',PeakThreshold);
%         DataFiles.Fz_mean{end+1,1} = mean(Fz(NumCycle(1)+StartCycleMean:NumCycle(1)+StopCycleMean,s)); %mean(Fz(NumCycle(1)+StartCycleMean:NumCycle(1)+StopCycleMean));
%         DataFiles.Fz_std{end+1,1} = std(Fz(NumCycle(1)+StartCycleMean:NumCycle(1)+StopCycleMean,s)); %std(Fz(NumCycle(1)+StartCycleMean:NumCycle(1)+StopCycleMean));
        [ValPic, NumCycle] = findpeaks(Fz(1:length(c(:,3)),s),'MINPEAKHEIGHT',PeakThreshold);
        DataFiles.NumCyclePeak{end+1,1} = NumCycle(1);
        DataFiles.Fz_mean{end+1,1} = mean(Fz(NumCycle(1)+StartCycleMean:NumCycle(1)+StopCycleMean,s)); %mean(Fz(NumCycle(1)+StartCycleMean:NumCycle(1)+StopCycleMean));
        DataFiles.Fz_std{end+1,1} = std(Fz(NumCycle(1)+StartCycleMean:NumCycle(1)+StopCycleMean,s)); %std(Fz(NumCycle(1)+StartCycleMean:NumCycle(1)+StopCycleMean));
        DataFiles.StartCycleMean{end+1,1} = [NumCycle(1)+StartCycleMean];
        DataFiles.StopCycleMean{end+1,1} = [NumCycle(1)+StopCycleMean];%[NumCycle(1)+StopCycleMean];    
        
        Fz_Peak(s) = max(Fz(:,s));%Fz(NumCycle(1));
        
        %Filter the data
        
        if Notch_Data_Filtering
           Fz_filtered_Notch(:,s) = filter(NotchFilterDesigned,Fz); 
        end
       
        if Butter_Data_Filtering
          Fz_filtered_Butter(:,s) = filtfilt(B,A,Fz);   
        end
            
        % Ploting the data
        figure(s)
        plot(Fz(1:length(c(:,3)),s))
        hold on
        if Notch_Data_Filtering
          plot(Fz_filtered_Notch(:,s),'g')  
        end
        if Butter_Data_Filtering
        plot(Fz_filtered_Butter(:,s),'r')
        end
        plot(NumCycle(1),ValPic(1),'r*')
        plot(NumCycle(1)+StartCycleMean,Fz(NumCycle(1)+StartCycleMean,s),'c*')        
        plot(NumCycle(1)+StopCycleMean,Fz(NumCycle(1)+StopCycleMean,s),'c*')

        figure(50)
        grid minor
        plot(Fz(1:length(c(:,3)),s))
        hold on
        plot(NumCycle(1),ValPic(1),'r*')
        plot(NumCycle(1)+StartCycleMean,Fz(NumCycle(1)+StartCycleMean,s),'c*')        
        plot(NumCycle(1)+StopCycleMean,Fz(NumCycle(1)+StopCycleMean,s),'c*')

        title('Calibration of the 64 mN homemade pinprick device ')
        
             C=[];
             c=[];
        Fz_Mean = [Fz_Mean mean(Fz(NumCycle(1)+StartCycleMean:NumCycle(1)+StopCycleMean,s))];
        NumCycle=[];
end
X= 0:2700;
plot(X,0.064,'.g','MarkerSize',4)
plot(mean(Fz'),'.r','MarkerSize',5)
xlabel('Time (ms)')
ylabel('Force (N)')
grid minor

MeanFz = mean(Fz_Mean)
StdFz = std(Fz_Mean)

MeanFz_Peak = mean(Fz_Peak)
StdFz_Peak = std(Fz_Peak)
%% Tangential forces

for i = 1:length(CalibrationFilesName)
    
        filename = fullfile(RootDir,CalibrationFilesName(i).name);
        disp(filename)
        DataFiles.FileName{end+1,1} = filename;
        C = importdata(filename);
        c = C.data;
        % Fz(:,s) = c(:,17);
%         Fz(:,s) = -c(:,17);% for the calibration on the force sensor
        Fx(1:length(c(:,1)),i) = c(:,1);
        Fy(1:length(c(:,2)),i) = c(:,2); 
        
        Ft(1:length(c(:,2)),i) = sqrt((Fx(1:length(c(:,1)),i).^2)+(Fy(1:length(c(:,2)),i).^2));
        
%         PeakThreshold = max(Fz)-0.001;
        %FiltreFz_Nano43 = filtfilt(B, A, Fz);
%         [ValPic, NumCycle] = findpeaks(Fz(:,s),'MINPEAKHEIGHT',PeakThreshold);
%         DataFiles.Fz_mean{end+1,1} = mean(Fz(NumCycle(1)+StartCycleMean:NumCycle(1)+StopCycleMean,s)); %mean(Fz(NumCycle(1)+StartCycleMean:NumCycle(1)+StopCycleMean));
%         DataFiles.Fz_std{end+1,1} = std(Fz(NumCycle(1)+StartCycleMean:NumCycle(1)+StopCycleMean,s)); %std(Fz(NumCycle(1)+StartCycleMean:NumCycle(1)+StopCycleMean));
        [ValPic_Ft, NumCycle_Ft] = findpeaks(Ft(:,i),'MINPEAKHEIGHT',PeakThreshold_Ft);
        DataFiles.Ft_mean{end+1,1} = mean(Ft(NumCycle_Ft(1)+StartCycleMean:NumCycle_Ft(1)+StopCycleMean,i)); %mean(Fz(NumCycle(1)+StartCycleMean:NumCycle(1)+StopCycleMean));
        DataFiles.Ft_std{end+1,1} = std(Ft(NumCycle_Ft(1)+StartCycleMean:NumCycle_Ft(1)+StopCycleMean,i)); %std(Fz(NumCycle(1)+StartCycleMean:NumCycle(1)+StopCycleMean));
        DataFiles.StartCycleMeanFt{end+1,1} = [NumCycle_Ft(1)+StartCycleMean];
        DataFiles.StopCycleMeanFt{end+1,1} = [NumCycle_Ft(1)+StopCycleMean];%[NumCycle(1)+StopCycleMean];    
        
        Ft_Peak(i) = max(Ft(:,i));%Ft(NumCycle_Ft(1));
        %Filter the data
        
        if Notch_Data_Filtering
           Fz_filtered_Notch(:,i) = filter(NotchFilterDesigned,Ft); 
        end
       
        if Butter_Data_Filtering
          Fz_filtered_Butter(:,i) = filtfilt(B,A,Ft);   
        end
            
        % Ploting the data
        figure(s+i)
        plot(Ft(1:length(c(:,2)),i))
        hold on
        if Notch_Data_Filtering
          plot(Fz_filtered_Notch(:,s),'g')  
        end
        if Butter_Data_Filtering
        plot(Fz_filtered_Butter(:,s),'r')
        end
        plot(NumCycle_Ft(1),ValPic_Ft(1),'r*')
        plot(NumCycle_Ft(1)+StartCycleMean,Ft(NumCycle_Ft(1)+StartCycleMean,i),'c*')        
        plot(NumCycle_Ft(1)+StopCycleMean,Ft(NumCycle_Ft(1)+StopCycleMean,i),'c*')

        figure(101)
        grid minor
        plot(Ft)
        hold on
        plot(NumCycle_Ft(1),ValPic_Ft(1),'r*')
        plot(NumCycle_Ft(1)+StartCycleMean,Ft(NumCycle_Ft(1)+StartCycleMean,i),'c*')        
        plot(NumCycle_Ft(1)+StopCycleMean,Ft(NumCycle_Ft(1)+StopCycleMean,i),'c*')

        title('Calibration of the 64 mN homemade pinprick device - AfterTraining')
        
             C=[];
             c=[];
        Ft_Mean = [Ft_Mean mean(Ft(NumCycle_Ft(1)+StartCycleMean:NumCycle_Ft(1)+StopCycleMean,i))];
end
X= 0:2700;
plot(X,0.064,'.g','MarkerSize',4)
plot(mean(Ft'),'.r','MarkerSize',5)
xlabel('Time (ms)')
ylabel('Tangential Force (N)')
grid minor

MeanFt = mean(Ft_Mean)
StdFt = std(Ft_Mean)

MeanFt_Peak = mean(Ft_Peak)
StdFt_Peak = std(Ft_Peak)


%% Align the force waveform : keeping 1s before and 2s after detection of the peak
figure
Time=[-500:2000];
for j = 1 : length(CalibrationFilesName)
    
    Fz_Matrix_Aligned(1:length(Fz(DataFiles.NumCyclePeak{j}-500:DataFiles.NumCyclePeak{j}+2000,j)),j) = Fz(DataFiles.NumCyclePeak{j}-500:DataFiles.NumCyclePeak{j}+2000,j);
    
    plot(Time,Fz_Matrix_Aligned(:,j))
    hold on
end
figure
for jj = 1 : length(CalibrationFilesName)

    Ft_Matrix_Aligned(1:length(Ft_Matrix(DataFiles.StartCycleMean{jj}-1000:DataFiles.StartCycleMean{jj}+2000,jj)),jj) = Ft_Matrix(DataFiles.StartCycleMean{jj}-1000:DataFiles.StartCycleMean{jj}+2000,jj);
    
    plot(Ft_Matrix_Aligned(:,jj))
    hold on
end
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Exporting all the data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% l= length(DataFiles.FileName);
% savetable('Results_CalibrationHomemadePinPrick_64mN_DM_BeforeTraining',DataFiles,l);

Datafilename = 'Results_96mNCalibration_PinprickRobotAndForcesensor_Pupil.mat';
save(Datafilename)

xlswrite('Results_64mNCalibration_PinprickRobotAndForcesensor_Pupil.xls',Fx,'Fx')
xlswrite('Results_64mNCalibration_PinprickRobotAndForcesensor_Pupil.xls',Fy,'Fy')
xlswrite('Results_96mNCalibration_PinprickRobotAndForcesensor_Pupil.xls',Fz_Matrix_Aligned,'Fz')
xlswrite('Results_64mNCalibration_PinprickRobotAndForcesensor_Pupil.xls',Ft,'Ft')


