%% point 1
abs(1.8876 - 4.3166)/1.8876 % comparaison 0.6Vpp et 1 Vpp @250 kHz = 128%68
abs(2.4654 - 5.5816)/2.4654 % comparaison 0.6Vpp et 1 Vpp @350 kHz = 126%40
abs(0.4348 - 1.0113)/0.4348 % comparaison 0.6Vpp et 1 Vpp @250 kHz = 132%59
% en moyenne 129.22%
%% point 2
% [10*log10(9.1167/2.0115) 10*log10(8.7850/1.4784) 10*log10(8.155/1.542)]
abs(4.5744-6.4085)/4.5744 %data Calib at df=20mm 1 Vpp 250 kHz + data sans skull = 0.4009 %

abs(8.2353-10.73717)/8.2353 %data Calib at df=21mm 1 Vpp 300 kHz + data sans skull = 30.38%
abs(8.2353-13.75821)/8.2353 %data Calib at df=22mm 1 Vpp 300 kHz + data sans skull = 67.06 %

abs(5.479262-4.6422)/5.479262 %data Calib at df=20mm 1 Vpp 350 kHz + data sans skull = 15.28%
abs(5.479262-5.6007)/5.479262 %data Calib at df=21mm 1 Vpp 350 kHz + data sans skull = 2.22%
abs(5.479262-5.2475)/5.479262 %data Calib at df=22mm 1 Vpp 350 kHz + data sans skull = 4.23 %
abs(5.479262-6.40974)/5.479262 %data Calib at df=23mm 1 Vpp 350 kHz + data sans skull =16.98%


% abs(2.4654-3.67636)/2.4654 %data Calib at df=20mm 0.6 Vpp 350 kHz + data sans skull =49.12%
% abs(2.4654-2.800972)/2.4654 %data Calib at df=21mm 0.6 Vpp 350 kHz + data sans skull = 13.61%
% abs(2.4654-3.488301)/2.4654 %data Calib at df=22mm 0.6 Vpp 350 kHz + data sans skull = 41.49%
% abs(2.4654-3.419602)/2.4654 %data Calib at df=23mm 0.6 Vpp 350 kHz + data sans skull 38.7%


%% point 3
Isppa_06 = mean([9.1167624 8.78507192 8.15157394 7.81330371 6.9518263 8.59349283])/2.2922;

abs(Isppa_06-2.800971617)/Isppa_06 %data Calib at df=21mm 0.6 Vpp 300 kHz + data sans skull = 31.52%
abs(Isppa_06-3.488301356)/Isppa_06%data Calib at df=22mm 1 Vpp 300 kHz + data sans skull = 68.53 %


%%
Alpha =  11.6;
EpaisseurCrane = 0.5; %[cm]
UltrasoundBurstFrequency = 300000;
NumberOfCycles = 200;
UltrasoundBurstPeriod = 1/UltrasoundBurstFrequency;
PulseRepetitonFrequency = 1; %!!!![kHz]
ToneBurstDuration = NumberOfCycles * UltrasoundBurstPeriod  ;
DutyCycle = ToneBurstDuration* 1000 * PulseRepetitonFrequency;% *1000 pour avoir des [ms] et pour le calcul du DutyCycle la PRF est en [kHz]

%results from the measures witht the calibration prototype 0.6Vpp @300 kHz
%from 25->20 mm 
% Isppa = [19.83514/1.3152 16.90659/1.3152 13.20256/1.3152 13.44037/1.3152 12.30221/1.3152 18.29359/1.3152]; % Isppa = [9.1167 8.7850 8.1515 7.8133 6.9518];

% Isppa = [19.83514 16.90659 13.20256 13.44037 12.30221 18.29359]; % Isppa = [9.1167 8.7850 8.1515 7.8133 6.9518];
% mean(Isppa)

Isppa_InSitu = 2.13248e+5./(10.^(Alpha.*(EpaisseurCrane/10)))
Ispta_InSitu = Isppa_InSitu.*DutyCycle