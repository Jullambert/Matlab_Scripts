%% Params

FreqVec = [250 350 500];
VoltVec = [0.6 0.8 1 1.2];
AngleVec = [-10 -5 0 5 10 20]; 
%% Données obtenues après analyse

Isppa_06 = [1.8241 2.5183 0.3882];
Isppa_08 = [2.955 3.8635 0.6211];
Isppa_1 = [4.066 5.3649 0.8569];
Isppa_12 = [6.1557 5.9255 1.0278];
Isppa_250 = [1.8241 2.955 4.066 6.1557];
Isppa_350 = [2.5183 3.8635 5.3649 5.9255];
Isppa_500 = [0.3882 0.6211 0.8569 1.0278];

Isppa_06 = [2.3365 2.4654 0.4348];
Isppa_08 = [4.0174 4.1323 0.7473];
Isppa_1 = [5.4692 5.5816 1.0113];
Isppa_12 = [6.059 6.2487 1.1873];
Isppa_250 = [2.3365 4.0174 5.4692 6.059];
Isppa_350 = [2.4654 4.1323 5.5816 6.2487];
Isppa_500 = [0.4348 0.7473 1.0113 1.1873];

% Isppa proto
Isppa_Proto_Hors = [4.9753 6.2812 1.2788];
Isppa_Proto_Zero = [5.0998 6.2287 1.2931];
Isppa_Proto_MoinsDix = [4.8282 6.4245 1.32];
Isppa_Proto_Zero_5Cycles_SansProtection = [5.0998 6.2287 1.2931];
Isppa_Proto_Zero_5Cycles_AvecProtection = [5.8499 6.6959 1.3536];
Isppa_Proto_Zero_200Cycles_AvecProtection = [6.5115 6.4484 0.9572];
Isppa_Proto_Zero_200Cycles_2Vpp_AvecProtection = [10.1020 7.5739 1.2822];
Isppa_Proto_Zero_200Cycles_2_6Vpp_AvecProtection = [10.4429 4.0866 0.6842];

figure()
plot(FreqVec,Isppa_Proto_Zero_200Cycles_AvecProtection,'*-b')
hold on
plot(FreqVec,Isppa_Proto_Zero_200Cycles_2Vpp_AvecProtection,'*-g')
plot(FreqVec,Isppa_Proto_Zero_200Cycles_2_6Vpp_AvecProtection,'*-r')
title('Validating stimulation prototype - effect of the driving voltage')
legend('1Vpp 200Cycles With cover','2Vpp 200Cycles With cover','2.6Vpp 200Cycles With cover')

figure()
plot(FreqVec,Isppa_Proto_Zero_5Cycles_SansProtection,'*-b')
hold on
plot(FreqVec,Isppa_Proto_Zero_5Cycles_AvecProtection,'*-g')
plot(FreqVec,Isppa_Proto_Zero_200Cycles_AvecProtection,'*-r')
title('Validating stimulation prototype - effect of the probe cover')
legend('1Vpp 5Cycles Without cover','1Vpp 5Cycles With cover','1Vpp 200Cycles With cover')

figure()
plot(FreqVec,Isppa_Proto_Hors,'*-b')
hold on
plot(FreqVec,Isppa_Proto_Zero,'*-k')
plot(FreqVec,Isppa_Proto_MoinsDix,'*-g')


%
Isppa_06_Skull = [0.3491 0.3014 0.02583];
Isppa_08_Skull = [0.5946 0.4952 0.08465];
Isppa_1_Skull = [0.8153 0.6695 0.0678];
Isppa_12_Skull = [0.9142 0.7502 0.0708];
Isppa_250_Skull = [0.3491 0.5946 0.8153 0.9142];
Isppa_350_Skull = [0.3014 0.4952 0.6695 0.7502];
Isppa_500_Skull = [0.02583 0.08465 0.0678 0.0708];

figure()
plot(VoltVec,Isppa_250,'b')
hold on
plot(VoltVec,Isppa_350,'r')
plot(VoltVec,Isppa_500,'g')
plot(VoltVec,Isppa_250_Skull,'--b')
plot(VoltVec,Isppa_350_Skull,'--r')
plot(VoltVec,Isppa_500_Skull,'--g')


figure()
plot(FreqVec,Isppa_06,'b')
hold on
plot(FreqVec,Isppa_08,'r')
plot(FreqVec,Isppa_1,'g')
plot(FreqVec,Isppa_12,'k')
plot(FreqVec,Isppa_06_Skull,'--b')
plot(FreqVec,Isppa_08_Skull,'--r')
plot(FreqVec,Isppa_1_Skull,'--g')
plot(FreqVec,Isppa_12_Skull,'--k')

Ispta_06 = [0.036483 0.0359 0.003882];
Ispta_08 = [0.0591 0.0551 0.006211];
Ispta_1 = [0.0813 0.0766 0.008569];
Ispta_12 = [0.1231 0.0846 0.0102];
Ispta_250 = [0.036483 0.0591 0.0813 0.1231];
Ispta_350 = [0.0359 0.551 0.0766 0.0846];
Ispta_500 = [0.003882 0.006211 0.008569 0.0102];

MI_06 = [0.49707 0.49552 0.1829];
MI_08 = [0.65132 0.61371 0.22761];
MI_1 = [0.75071 0.7249 0.27516];
MI_12 = [0.95045 0.76906 0.30552];
MI_250 = [0.49707 0.65132 0.75071 0.95045];
MI_350 = [0.49552 0.61371 0.7249 0.76906];
MI_500 = [0.1829 0.22761 0.27516 0.30552];



Ratio_12V = [1-0.148522957 1-0.126604325 1-0.068939072]./0.78;
Ratio_1V = [1-0.200493961 1-0.124804498 1-0.07917568]./0.78;
Ratio_08V = [1-0.201217208 1-0.128193542 1-0.136278369]./0.78;
Ratio_06V = [1-0.19138508 1-0.119701509 1-0.066597341]./0.78;

figure()
plot(FreqVec,Ratio_12V,'*-k')
hold on
plot(FreqVec,Ratio_1V,'*-g')
plot(FreqVec,Ratio_08V,'*-r')
plot(FreqVec,Ratio_06V,'*-b')



% Données concernant l'influence de l'angle entre hydrophone et
% transducteur - "Session Decembre"
Isppa_MoinsDixDeg = [6.0119 5.5636 1.1515];
Isppa_MoinsCinqDeg = [4.758 4.3247 0.66464];
Isppa_ZeroDeg = [5.4915 6.2312 1.3624];
Isppa_CinqDeg = [5.3880 4.9617 0.94656];
Isppa_DixDeg = [4.9667 4.3370 0.68829];
Isppa_VingtDeg = [5.5507 5.6786 1.1985];


Isppa_Angle_250 = [6.0119 4.758 5.4915 5.3880 4.9667 5.5507];
Isppa_Angle_350 = [5.5636 4.3247 6.2312 4.9617 4.3370 5.6786];
Isppa_Angle_500 = [1.1515 0.66464 1.3624 0.94656 0.68829 1.1985];

Ispta_ZeroDeg = [0.10983 0.08901759 0.01362418];
Ispta_MoinsCinqDeg = [0.09515944 0.06178183 0.00664638];
Ispta_CinqDeg = [0.10776 0.07088123 0.00946563];
Ispta_DixDeg = [0.9933463 0.06195776 0.00688285];

MI_ZeroDeg = [0.8891 0.7622 0.3302];
MI_MoinsCinqDeg = [0.8316 0.6492 0.2314];
MI_CinqDeg = [0.8861 0.6951 0.2655];
MI_DixDeg = [0.8646 0.6599 0.2340];

MI_Angle_250 = [0.8316 0.8891 0.8861 0.8646];
MI_Angle_350 = [0.6492 0.7622 0.6951 0.6599];
MI_Angle_500 = [0.2314 0.3302 0.2655 0.2340];
%% Plot Isppa en fonction de l'angle
figure()
plot(AngleVec,Isppa_Angle_250,'b*-')
title('Effect of the Angle, Vpp = 1 V')
xlabel('Angle [°]')
ylabel('Isppa [W/cm²]')
hold on
plot(AngleVec,Isppa_Angle_350,'k*-')
plot(AngleVec,Isppa_Angle_500,'g*-')
legend('Frequence = 250 [kHz]','Frequence = 350 [kHz]','Frequence = 500 [kHz]')

figure()
plot(AngleVec,MI_Angle_250,'b*-')
title('Effect of the Angle, Vpp = 1 V')
xlabel('Angle [°]')
ylabel('MI')
hold on
plot(AngleVec,MI_Angle_350,'k*-')
plot(AngleVec,MI_Angle_500,'g*-')
legend('Frequence = 250 [kHz]','Frequence = 350 [kHz]','Frequence = 500 [kHz]')
%% Plot Isppa en fonction de la frequence ou de la tension

figure()
plot(FreqVec,Isppa_06,'*-')
title('Effect of the frequency, Vpp = 0.6 V')
xlabel('Frequency [kHz]')
ylabel('Isppa [W/cm²]')
figure()
plot(FreqVec,Isppa_08,'*-')
title('Effect of the frequency, Vpp = 0.8 V')
xlabel('Frequency [kHz]')
ylabel('Isppa [W/cm²]')
figure()
plot(FreqVec,Isppa_1,'*-')
title('Effect of the frequency, Vpp = 1 V')
xlabel('Frequency [kHz]')
ylabel('Isppa [W/cm²]')
figure()
plot(FreqVec,Isppa_12,'*-')
title('Effect of the frequency, Vpp = 1.2 V')
xlabel('Frequency [kHz]')
ylabel('Isppa [W/cm²]')

figure()
plot(VoltVec,Isppa_250,'*-')
title('Effect of the voltage, Acoustic Frequency = 250 [kHz]')
xlabel('Driving voltage [V]')
ylabel('Isppa [W/cm²]')
figure()
plot(VoltVec,Isppa_350,'*-')
title('Effect of the voltage, Acoustic Frequency = 350 [kHz]')
xlabel('Driving voltage [V]')
ylabel('Isppa [W/cm²]')
figure()
plot(VoltVec,Isppa_500,'*-')
title('Effect of the voltage, Acoustic Frequency = 500 [kHz]')
xlabel('Driving voltage [V]')
ylabel('Isppa [W/cm²]')



%% Plot Ispta en fonction de la frequence ou de la tension
figure()
plot(FreqVec,Ispta_06,'*-')
title('Effect of the frequency, Vpp = 0.6 V')
xlabel('Frequency [kHz]')
ylabel('Ispta [W/cm²]')
figure()
plot(FreqVec,Ispta_08,'*-')
title('Effect of the frequency, Vpp = 0.8 V')
xlabel('Frequency [kHz]')
ylabel('Ispta [W/cm²]')
figure()
plot(FreqVec,Ispta_1,'*-')
title('Effect of the frequency, Vpp = 1 V')
xlabel('Frequency [kHz]')
ylabel('Ispta [W/cm²]')
figure()
plot(FreqVec,Ispta_12,'*-')
title('Effect of the frequency, Vpp = 1.2 V')
xlabel('Frequency [kHz]')
ylabel('Ispta [W/cm²]')

figure()
plot(VoltVec,Ispta_250,'*-')
title('Effect of the voltage, Acoustic Frequency = 250 [kHz]')
xlabel('Driving voltage [V]')
ylabel('Ispta [W/cm²]')
figure()
plot(VoltVec,Ispta_350,'*-')
title('Effect of the voltage, Acoustic Frequency = 350 [kHz]')
xlabel('Driving voltage [V]')
ylabel('Ispta [W/cm²]')
figure()
plot(VoltVec,Ispta_500,'*-')
title('Effect of the voltage, Acoustic Frequency = 500 [kHz]')
xlabel('Driving voltage [V]')
ylabel('Ispta [W/cm²]')


%% Plot MI en fonction de la frequence ou de la tension
figure()
plot(FreqVec,MI_06,'*-')
title('Effect of the frequency, Vpp = 0.6 V')
xlabel('Frequency [kHz]')
ylabel('MI')
figure()
plot(FreqVec,MI_08,'*-')
title('Effect of the frequency, Vpp = 0.8 V')
xlabel('Frequency [kHz]')
ylabel('MI')
figure()
plot(FreqVec,MI_1,'*-')
title('Effect of the frequency, Vpp = 1 V')
xlabel('Frequency [kHz]')
ylabel('MI')
figure()
plot(FreqVec,MI_12,'*-')
title('Effect of the frequency, Vpp = 1.2 V')
xlabel('Frequency [kHz]')
ylabel('MI')

figure()
plot(VoltVec,MI_250,'*-')
title('Effect of the voltage, Acoustic Frequency = 250 [kHz]')
xlabel('Driving voltage [V]')
ylabel('MI]')
figure()
plot(VoltVec,MI_350,'*-')
title('Effect of the voltage, Acoustic Frequency = 350 [kHz]')
xlabel('Driving voltage [V]')
ylabel('MI]')
figure()
plot(VoltVec,MI_500,'*-')
title('Effect of the voltage, Acoustic Frequency = 500 [kHz]')
xlabel('Driving voltage [V]')
ylabel('MI')