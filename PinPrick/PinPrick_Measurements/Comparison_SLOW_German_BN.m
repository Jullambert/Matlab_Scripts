close all;clear all; clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Program made to analyse datas for the PinPrick
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ValPeaks = the values above the value of the PeakThreshold defined
%NumCycle = the number of cycle related with the ValPeak.

%ValidCycles = n° of cycle in [ms] for each first peaks of a trial
%ValidPeaks = Value in [N] of the the first peaks detected of a trial 

%% Variables
ValidCycles1 = zeros(90,1);
ValidPeaks1 =zeros(90,1);
CyclesForMean1 = zeros(90,1);
PeaksForMean1 = zeros(90,1);

ValidCycles2 = zeros(90,1);
ValidPeaks2 =zeros(90,1);
CyclesForMean2 = zeros(90,1);
PeaksForMean2 = zeros(90,1);

MeasurementNoise = zeros(201,1);

indG =[];
indBN =[];
MeanGerman =[];
MeanBN=[];

%% Parameters
PeakThreshold = 0.13; %valeur de seuil de detection de pic
PeakThresholdF = 0.15; 
PeakThresholdF2 = 0.13;%valeur de seuil de detection de pic
[B A] = butter(4,150/500,'low');
StartCycleMean1 = 135;
StopCycleMean1 = 185;
StartCycleMean2 = 125;
StopCycleMean2 = 175;
%% Import data to be analyzed
F1= importdata('manual_German_Trial2_LOW_0.csv');
Fz1 = -F1.data(:,9);
X1 = 1:length(Fz1);

F2= importdata('manual_BN_Trial2_LOW_0.csv');
Fz2 = -F2.data(:,9);
X2 = 1:length(Fz2);

[ValPeaks1, NumCycle1] = findpeaks(Fz1,'MINPEAKHEIGHT',PeakThreshold);
[ValPeaks2, NumCycle2] = findpeaks(Fz2,'MINPEAKHEIGHT',PeakThresholdF);

%% Peaks sort
% For the first dataset
for j=2:length(NumCycle1)
    
    if (NumCycle1(j)- NumCycle1(j-1))>450
        ValidCycles1 =[ValidCycles1 ;X1(NumCycle1(j))];
        ValidPeaks1 = [ValidPeaks1 ;Fz1(NumCycle1(j))];   
        
        if NumCycle1(j)+StopCycleMean1 >= length(Fz1)            
            CyclesForMean1 = [CyclesForMean1; X1(NumCycle1(j))];
        else 
            CyclesForMean1 = [CyclesForMean1; X1(NumCycle1(j)+StartCycleMean1);X1(NumCycle1(j)+StopCycleMean1)];       
        end
    end
end
ValidCycles1(1)= NumCycle1(1);
ValidCycles1(ValidCycles1==0)=[];

CyclesForMean1(1)= NumCycle1(1);
CyclesForMean1(2) = CyclesForMean1(1)+StartCycleMean1;
CyclesForMean1(3) = CyclesForMean1(1)+StopCycleMean1;
CyclesForMean1(1) =[];
CyclesForMean1(CyclesForMean1==0)=[];

CyclesForMean1([1 2 35 36 37 38 61 62 93 94]) =[];

 for k=1:length(CyclesForMean1)
      PeaksForMean1 = [PeaksForMean1 ;Fz1(CyclesForMean1(k))];
 end
ValidPeaks1(1)=ValPeaks1(1);
ValidPeaks1(ValidPeaks1==0)=[];
ValidCycles1([1 18 19 31 47])=[];
ValidPeaks1([1 18 19 31 47])=[];
PeaksForMean1(PeaksForMean1==0)=[];%Unecessary to calculate peaks value but easier to plot them!

%For the second dataset
for jj=2:length(NumCycle2)
    
    if (NumCycle2(jj)- NumCycle2(jj-1))>500
        ValidCycles2 =[ValidCycles2 ;X2(NumCycle2(jj))];
        ValidPeaks2 = [ValidPeaks2 ;Fz2(NumCycle2(jj))];   
        
        if NumCycle2(jj)+StopCycleMean2 >= length(Fz2)            
            CyclesForMean2 = [CyclesForMean2; X2(NumCycle2(jj))];
        else 
            CyclesForMean2 = [CyclesForMean2; X2(NumCycle2(jj)+StartCycleMean2);X2(NumCycle2(jj)+StopCycleMean2)];       
        end
    end
end
ValidCycles2(1)= NumCycle2(1);
ValidCycles2(ValidCycles2==0)=[];

CyclesForMean2(1)= NumCycle2(1);
CyclesForMean2(2) = CyclesForMean2(1)+StartCycleMean2;
CyclesForMean2(3) = CyclesForMean2(1)+StopCycleMean2;
CyclesForMean2(1) =[];

CyclesForMean2(CyclesForMean2==0)=[];

% remove artefacted trials
CyclesForMean2([15 16 31 32 53 54 69 70 85 86 91 92 95 96 105 106 113 114 121 122]) =[];
 
 for kk=1:length(CyclesForMean2)
      PeaksForMean2 = [PeaksForMean2 ;Fz2(CyclesForMean2(kk))];
 end
ValidPeaks2(1)=ValPeaks2(1);
ValidPeaks2(ValidPeaks2==0)=[];

% remove artefacted trials
ValidCycles2([8 16 27 35 43 46 48 53 57 61])=[];
ValidPeaks2([8 16 27 35 43 46 48 53 57 61])=[];

PeaksForMean2(PeaksForMean2==0)=[];%Unecessary to calculate peaks value but easier to plot them!


%% Stats
for w1 = 1:2: (length(CyclesForMean1) -1 )
     MeanForceG(w1) = mean(Fz1(CyclesForMean1(w1):CyclesForMean1(w1+1)));
end

for w2 = 1:2: (length(CyclesForMean2) -1 )
     MeanForceBN(w2) = mean(Fz2(CyclesForMean2(w2):CyclesForMean2(w2+1)));
end

MeanForceG(MeanForceG==0)=[];
MeanForceG = MeanForceG';
MeanForceG1 = MeanForceG;

MeanForceBN(MeanForceBN==0)=[];
MeanForceBN = MeanForceBN';
MeanForceBN1 = MeanForceBN;

%% Mean calculated on 30 random trials

for m=1:30
    index1 = round(rand*length(MeanForceG1));
    while index1 ==0
       index1 = round(rand*length(MeanForceG1));
    end
    indG=[indG index1];
    MeanGerman =[MeanGerman MeanForceG1(indG(m))];
    MeanForceG1(indG(m))=[];
    
    index2 = round(rand*length(MeanForceBN1));
    while index2 ==0
       index2 = round(rand*length(MeanForceBN1));
    end
    indBN=[indBN index2];
    MeanBN =[MeanBN MeanForceBN1(indBN(m))];
    MeanForceBN1(indBN(m))=[];
end

MeanForcePinPrickG = mean(MeanForceG)
StdForcePinPrickG = std(MeanForceG)

MeanForcePinPrickG1 = mean(MeanGerman)
StdForcePinPrickG1 = std(MeanGerman)

MeanForcePinPrickBN = mean(MeanForceBN)
StdForcePinPrickBN = std(MeanForceBN)

MeanForcePinPrickBN1 = mean(MeanBN)
StdForcePinPrickBN1 = std(MeanBN)


% Mean of max peaks

MeanPeaks1 = mean(ValidPeaks1)
StdPeaks1 =  std(ValidPeaks1)

MeanPeaks2 = mean(ValidPeaks2)
StdPeaks2 =  std(ValidPeaks2)
%% Representation of datas

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
