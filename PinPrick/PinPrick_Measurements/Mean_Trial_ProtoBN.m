close all;clear all; clc;
%% Variables
ValidCycles1 = zeros(90,1);
ValidPics1 =zeros(90,1);
CyclesForMean1 = zeros(90,1);
PeaksForMean1 = zeros(90,1);

ValidCycles2 = zeros(90,1);
ValidPics2 =zeros(90,1);
CyclesForMean2 = zeros(90,1);
PeaksForMean2 = zeros(90,1);


%% Parameters
SeuilPic = 0.3; %valeur de seuil de detection de pic
SeuilPicF = 0.2; 
SeuilPicF2 = 0.13;%valeur de seuil de detection de pic
[B A] = butter(4,15/500,'low');
StartCycleMean1 = 310;
StopCycleMean1 = 410;
StartCycleMean2 = 430;
StopCycleMean2 = 530;
%% Import data to be analyzed

F1= importdata('manual_ComparisonGerman1_0.csv');
Fz1 = -F1.data(:,9);
X1 = 1:length(Fz1);

F2= importdata('manual_Test_Proto_BN_0.csv');
Fz2 = -F2.data(:,9);
X2 = 1:length(Fz2);

[ValPic1, NumCycle1] = findpeaks(Fz1,'MINPEAKHEIGHT',SeuilPic);
[ValPic2, NumCycle2] = findpeaks(Fz2,'MINPEAKHEIGHT',SeuilPicF);

%% Peaks sort

%For the first dataset
for j=2:length(NumCycle1)
    
    if (NumCycle1(j)- NumCycle1(j-1))>990
        ValidCycles1 =[ValidCycles1 ;X1(NumCycle1(j))];
        ValidPics1 = [ValidPics1 ;Fz1(NumCycle1(j))];   
        
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


 for k=1:length(CyclesForMean1)
      PeaksForMean1 = [PeaksForMean1 ;Fz1(CyclesForMean1(k))];
 end
ValidPics1(1)=ValPic1(1);
ValidPics1(ValidPics1==0)=[];
PeaksForMean1(PeaksForMean1==0)=[];%Unecessary to calculate peaks value but easier to plot them!

%For the second dataset
for jj=2:length(NumCycle2)
    
    if (NumCycle2(jj)- NumCycle2(jj-1))>1200
        ValidCycles2 =[ValidCycles2 ;X2(NumCycle2(jj))];
        ValidPics2 = [ValidPics2 ;Fz2(NumCycle2(jj))];   
        
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
% Remove double peaks for the same trial [7 10 13 15 20 23 25 27 31 36 39
% 42 44 47 49 51 60 64 66 68 71 74] and 
ValidCycles2([7 10 13 15 20 23 25 27 31 36 39 42 44 47 49 51 60 64 66 68 71 74])=[];
CyclesForMean2([13 14 19 20 25 26 29 30 39 40 45 46 49 50 53 54 61 62 71 72 77 78 83 84 87 88 93 94 97 98 101 102 119 120 127 128 131 132 135 136 141 142 147 148])=[];
% remove outlayers peaks [1 2 12 29 30 51 56]
ValidCycles2([1 2 12 29 30 51 56])=[];
CyclesForMean2([1 2 3 4 23 24 57 58 59 60 101 102 111 112]) =[];
 for kk=1:length(CyclesForMean2)
      PeaksForMean2 = [PeaksForMean2 ;Fz2(CyclesForMean2(kk))];
 end
ValidPics2(1)=ValPic2(1);
ValidPics2(ValidPics2==0)=[];
% Remove double peaks for the same trial cfr ValidCycles2
ValidPics2([7 10 13 15 20 23 25 27 31 36 39 42 44 47 49 51 60 64 66 68 71 74])=[];
ValidPics2([1 2 12 29 30 51 56])=[];
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
MeanForceBN(MeanForceBN==0)=[];
MeanForceBN = MeanForceBN';
MeanForceBN([3 10 23 28 50 33]) =[];

% MeanForceG([12 13 16 17 18 19 25 26 28 29 32 36])=[] ;
% MeanForceBN([2 4 8 16 17 20 22 33])=[] ;
%trials removed related with the force profil
%available for the files named : 'manual_ComparisonBelgoNetherlands_0.csv'
%and 'manual_ComparisonGerman1_0.csv'
MeanForcePinPrickG = mean(MeanForceG)
StdForcePinPrickG = std(MeanForceG)

MeanForcePinPrickBN = mean(MeanForceBN)
StdForcePinPrickBN = std(MeanForceBN)


%% Representation of datas

figure(1)
F(1)=subplot(2,1,1);
plot(X1,Fz1)
hold on
plot(ValidCycles1,ValidPics1,'r*')
str = num2str((1:numel(ValidPics1)).', '%1d'); % ATTENTION le premier argument de NUM2STR doit être un vecteur colonne
text(ValidCycles1+0.01, ValidPics1+0.1, str)  
plot(CyclesForMean1,PeaksForMean1,'c*')
legend('PinPrickG','PeakDetected')

F(2)=subplot(2,1,2);
plot(X2,Fz2)
hold on
plot(ValidCycles2,ValidPics2,'r*')
str2 = num2str((1:numel(ValidPics2)).', '%1d');
text(ValidCycles2+0.01, ValidPics2+0.1, str2)
plot(CyclesForMean2,PeaksForMean2,'c*')
linkaxes(F,'xy')
legend('PinPrickBelNet','PeakDetected')


figure(2)
plot(MeanForceG,'d')
hold on
XMeanForceG = (1:length(MeanForceG))';
% str3 = num2str((1:numel(MeanForceG)), '%1d');
str3 = num2str(XMeanForceG, '%1d');
text(XMeanForceG+0.01,MeanForceG+0.1, str3)

figure(3)
XMeanForceBN = (1:length(MeanForceBN))';
plot(XMeanForceBN,MeanForceBN,'rd')
hold on
str4 = num2str((1:numel(MeanForceBN)).', '%1d');
text(XMeanForceBN+0.01,MeanForceBN+0.1, str4)
legend('MeanForceBN')
        


% hold on
        
    

%% Filtred Data and results based on them

Filtred_Fz1 = filtfilt(B, A, Fz1);
Filtred_Fz2 = filtfilt(B, A, Fz2);

% Peak Detection
[ValPicF1, NumCycleF1] = findpeaks(Filtred_Fz1,'MINPEAKHEIGHT',SeuilPicF);
[ValPicF2, NumCycleF2] = findpeaks(Filtred_Fz2,'MINPEAKHEIGHT',SeuilPicF2);


% Representation of the data
% figure(3)
% G(1)=subplot(2,1,1);
% plot(X1,Filtred_Fz1)
% hold on
% plot(NumCycleF1,ValPicF1,'r*')
% G(2)=subplot(2,1,2);
% plot(X2,Filtred_Fz2)
% hold on
% plot(NumCycleF2,ValPicF2,'r*')
% linkaxes(G,'x')
