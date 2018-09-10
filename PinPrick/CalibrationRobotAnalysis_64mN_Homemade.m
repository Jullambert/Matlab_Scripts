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
SeuilPic = 0.09; %valeur de seuil de detection de pic
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

RootDir = uigetdir;
CalibrationFilesName = dir(RootDir);
CalibrationFilesName(1:2) = []; % delete . and ..

for s = 1:length(CalibrationFilesName)
    
        filename = fullfile(RootDir,CalibrationFilesName(s).name);
        DataFiles.FileName{end+1,1} = filename;
        C = importdata(filename);
        c = C.data;
        Fz = -c(:,17);
        X1 = length(Fz);
        %FiltreFz_Nano43 = filtfilt(B, A, Fz);
        [ValPic, NumCycle] = findpeaks(Fz,'MINPEAKHEIGHT',SeuilPic);
        DataFiles.Fz_mean{end+1,1} = mean(Fz(NumCycle+StartCycleMean:NumCycle+StopCycleMean));
        DataFiles.Fz_std{end+1,1} = std(Fz(NumCycle+StartCycleMean:NumCycle+StopCycleMean));
        DataFiles.StartCycleMean = [NumCycle+StartCycleMean];
        DataFiles.StopCycleMean = [NumCycle+StopCycleMean];    
  
        % Ploting the data

        figure(s)
        plot(X1,Fz)
        hold on
        plot(NumCycle,ValPic,'r*')
        str = num2str((1:numel(VaPic)).', '%1d'); % ATTENTION le premier argument de NUM2STR doit être un vecteur colonne
        text(NumCycle+0.01, ValPic+0.1, str)  
%         plot(CyclesForMean1,PeaksForMean1,'c*')
%         legend('PinPrickG','PeakDetected')

            C=[];
            c=[];
            
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Exporting all the data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

l= length(DataFiles.FileName);
savetable('testing3',DataFiles,l);


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Tracés des résultats.
%La boucle permet de faire le tri (en fonction de la température de stimulation)
%dans les données propres à un sujet et d'afficher sur un même graphe les
%essais des sujets pour une même température de stimulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for t=1:length(TempStimuli)
%     for p=1:length(SubjDirs)
%         figure(t)
%         plot(DataFiles.FnStat1_mean(DataFiles.Temp_Box0==TempStimuli(t) & DataFiles.SubjNum== p),DataFiles.CFStat1(DataFiles.Temp_Box0==TempStimuli(t) & DataFiles.SubjNum==p),Affichage{p});
%         hold on
%         legend(SubjDirs.name);
%         title('CF Statique pour une temp de stimuli constante');
%         
%         figure(t+3)
%         plot(DataFiles.FnStat1_mean(DataFiles.Temp_Box0==TempStimuli(t) & DataFiles.SubjNum== p),DataFiles.CFDyn1(DataFiles.Temp_Box0==TempStimuli(t) & DataFiles.SubjNum==p),Affichage{p});
%         hold on
%         legend(SubjDirs.name);
%         title('CF Dynamique pour une temp de stimuli constante');
%         %figure(t+6)
%         %errorbar((DataFiles.FnStat1_mean(DataFiles.Temp_Box0==TempStimuli(t) & DataFiles.SubjNum== p),DataFiles.CFStat1(DataFiles.Temp_Box0==TempStimuli(t) & DataFiles.SubjNum==p),Affichage{p});
%         
%     end
% end


%% Ploting the data

figure(1)
F(1)=subplot(2,1,1);
plot(X1,Fz1)
hold on
plot(ValidCycles1,ValidPeaks1,'r*')
str = num2str((1:numel(ValidPeaks1)).', '%1d'); % ATTENTION le premier argument de NUM2STR doit être un vecteur colonne
text(ValidCycles1+0.01, ValidPeaks1+0.1, str)  
plot(CyclesForMean1,PeaksForMean1,'c*')
legend('PinPrickG','PeakDetected')

F(2)=subplot(2,1,2);
plot(X2,Fz2)
hold on
plot(ValidCycles2,ValidPeaks2,'r*')
str2 = num2str((1:numel(ValidPeaks2)).', '%1d');
text(ValidCycles2+0.01, ValidPeaks2+0.1, str2)
plot(CyclesForMean2,PeaksForMean2,'c*')
linkaxes(F,'xy')
legend('PinPrickBelNet','PeakDetected')

% 
% figure(2)
% plot(MeanForceG,'d')
% hold on
% XMeanForceG = (1:length(MeanForceG))';
% % str3 = num2str((1:numel(MeanForceG)), '%1d');
% str3 = num2str(XMeanForceG, '%1d');
% text(XMeanForceG+0.01,MeanForceG+0.1, str3)
% 
% figure(3)
% XMeanForceBN = (1:length(MeanForceBN))';
% plot(XMeanForceBN,MeanForceBN,'rd')
% hold on
% str4 = num2str((1:numel(MeanForceBN)).', '%1d');
% text(XMeanForceBN+0.01,MeanForceBN+0.1, str4)
% legend('MeanForceBN')
        


% hold on
        
    

%% Filtred Data and results based on them

%Take from num of cycle from 150 until 350 from the
%file 'manual_German_Trial2_LOW_0.csv'

MeasurementNoise = Fz1(150:350);
NFFT = 2^nextpow2(length(MeasurementNoise));
FzFFT = fft(MeasurementNoise,NFFT)/length(MeasurementNoise);
f = 1000/2*linspace(0,1,NFFT/2);

% figure()
% plot(f,2*abs(FzFFT(1:NFFT/2)))


Filtred_Fz1 = filtfilt(B, A, Fz1);
Filtred_Fz2 = filtfilt(B, A, Fz2);
% 
% % Peak Detection
% [ValPicF1, NumCycleF1] = findpeaks(Filtred_Fz1,'MINPEAKHEIGHT',PeakThresholdF);
% [ValPicF2, NumCycleF2] = findpeaks(Filtred_Fz2,'MINPEAKHEIGHT',PeakThresholdF2);


% Derivate the signal to analyse
dFz1 = deriv(Filtred_Fz1,1000);
dFz2 = deriv(Filtred_Fz2,1000);

[B1 A1] = butter(4,50/500,'low');
Filtred_dFz1 = filtfilt(B1, A1, dFz1);

figure(3)
% G(1)=subplot(2,1,1);
% plot(X1,Fz1)

plot(X2,Filtred_Fz2,'g')
hold on
plot(X2,dFz2,'r')
legend('Fz filtred','Fz derivated')
% G(2)=subplot(2,1,2);
% plot(X2,Fz2)
% hold on
% plot(X2,Filtred_Fz2,'g')
% plot(X2,dFz2,'r')
% linkaxes(G,'xy')



% figure(4)
% % G(1)=subplot(2,1,1);
% plot(X1,Fz1)
% hold on
% plot(X1,Filtred_Fz1,'g')
% plot(X1,Filtred_dFz1,'r')


