close all;clear all; clc;
%% Variables
ValidCycles1 = zeros(90,1);
ValidPics1 =zeros(90,1);
ValidCycles2 = zeros(90,1);
ValidPics2 =zeros(90,1);
        TestCyclesInit = zeros(90,1);
        TestCyclesEnd = zeros(90,1);
        TestValidPics1Init = zeros(90,1);
        TestValidPics1End = zeros(90,1);
        ValidCycles = zeros(200,1);

%% Parameters
SeuilPic = 0.3; %valeur de seuil de detection de pic
SeuilPicF = 0.1955; 
SeuilPicF2 = 0.155;%valeur de seuil de detection de pic
[B A] = butter(4,15/500,'low');


%% Import data to be analyzed

F1= importdata('manual_PinPrickG_2_0.csv');
Fz1 = -F1.data(:,9);
X1 = 1:length(Fz1);


F2= importdata('manual_PinPrickBN_2_0.csv');
Fz2 = -F2.data(:,9);
X2 = 1:length(Fz2);


[ValPic1, NumCycle1] = findpeaks(Fz1,'MINPEAKHEIGHT',SeuilPic);
[ValPic2, NumCycle2] = findpeaks(Fz2,'MINPEAKHEIGHT',SeuilPic);



%% Tri dans pics

for j=2:length(NumCycle1)
    
    if (NumCycle1(j)- NumCycle1(j-1))>990
        ValidCycles1 =[ValidCycles1 ;X1(NumCycle1(j))];
           
        if NumCycle1(j)+450 >= length(Fz1)
            
        TestCyclesInit = [TestCyclesInit; X1(NumCycle1(j))];
        TestCyclesEnd = [TestCyclesEnd; X1(NumCycle1(j))];
              
        else            
            
        TestCyclesInit = [TestCyclesInit; X1(NumCycle1(j)+250)];
        TestCyclesEnd = [TestCyclesEnd; X1(NumCycle1(j)+450)];
        end
    end
end
ValidCycles1(1)= NumCycle1(1);
ValidCycles1(ValidCycles1==0)=[];

ValidCycles(ValidCycles==0)=[];
TestCyclesInit(TestCyclesInit==0)=[];
TestCyclesEnd(TestCyclesEnd==0)=[];

 for k=2:length(ValidCycles1)

        ValidPics1 = [ValidPics1 ;Fz1(ValidCycles1(k))];
        if ValidCycles1(k)+1200 >= length(Fz1)
            
        TestValidPics1Init = [TestValidPics1Init ;Fz1(ValidCycles1(k))];
        TestValidPics1End = [TestValidPics1End ;Fz1(ValidCycles1(k))]; 
        
        else            

        TestValidPics1Init = [TestValidPics1Init ;Fz1(NumCycle1(k)+200)];
        TestValidPics1End = [TestValidPics1End ;Fz1(NumCycle1(k)+500)];
    
        end
    end

ValidPics1(1)=ValPic1(1);
ValidPics1(ValidPics1==0)=[];
TestValidPics1Init(TestValidPics1Init==0)=[];
TestValidPics1End(TestValidPics1End==0)=[];

for jj=2:length(NumCycle2)
    
    if (NumCycle2(jj)- NumCycle2(jj-1))>750
        ValidCycles2 =[ValidCycles2 ;NumCycle2(jj)];
        ValidPics2 = [ValidPics2 ;ValPic2(jj)];
    end
end





ValidCycles2(1)= NumCycle2(1);
ValidPics2(1)=ValPic2(1);
ValidCycles2(ValidCycles2==0)=[];
ValidPics2(ValidPics2==0)=[];

%% Stats



%% Representation of datas

figure(1)
F(1)=subplot(2,1,1);
plot(X1,Fz1)
hold on
plot(ValidCycles1,ValidPics1,'r*')
plot(TestCyclesInit,TestValidPics1Init,'c*')
plot(TestCyclesEnd,TestValidPics1End ,'c*') 
F(2)=subplot(2,1,2);
plot(X2,Fz2)
hold on
plot(ValidCycles2,ValidPics2,'r*')
linkaxes(F,'x')


        
        
        
        
    

%% Filtred Data and results based on them

Filtred_Fz1 = filtfilt(B, A, Fz1);
Filtred_Fz2 = filtfilt(B, A, Fz2);

% Peak Detection
[ValPicF1, NumCycleF1] = findpeaks(Filtred_Fz1,'MINPEAKHEIGHT',SeuilPicF);
[ValPicF2, NumCycleF2] = findpeaks(Filtred_Fz2,'MINPEAKHEIGHT',SeuilPicF2);


% Representation of the data
% figure(2)
% G(1)=subplot(2,1,1);
% plot(X1,Filtred_Fz1)
% hold on
% plot(NumCycleF1,ValPicF1,'r*')
% G(2)=subplot(2,1,2);
% plot(X2,Filtred_Fz2)
% hold on
% plot(NumCycleF2,ValPicF2,'r*')
% linkaxes(G,'x')
