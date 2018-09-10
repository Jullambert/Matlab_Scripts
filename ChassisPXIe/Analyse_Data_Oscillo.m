%% Analyse pour Frequence Burst = 250 kHz
Fs = 5000000 ; % 10000000  cfr fichier .csv de l'oscillo, 1/Sample Interval
Freq_Burst = 200000;
DureeProgrammee_Burst = 0.0002;
NumSample_Burst = Fs * DureeProgrammee_Burst;
Tension_Prevue = 5.0;
Seuil_Detection_Pic_Positif = 4.1;
Seuil_Detection_Pic_Negatif = 4.1;
Burst_Tension_Maximum_Positive_Moyenne = [];
Burst_EcartType_Tension_Maximum_Positive_Moyenne = [];
Burst_Tension_Maximum_Negative_Moyenne = [];
Burst_EcartType_Tension_Maximum_Negative_Moyenne = [];
DutyCycle_Tension_Moyenne = [];
DutyCycle_EcartType = [];

% Détection de l'ensemble des pics du signal
[ValPicPositifRecorded, NumSamplePositifRecorded] = findpeaks(Burst(:,2),'MINPEAKHEIGHT',Seuil_Detection_Pic_Positif,'MINPEAKDISTANCE',6);
[ValPicNegatifRecorded, NumSampleNegatifRecorded] = findpeaks(-Burst(:,2),'MINPEAKHEIGHT',Seuil_Detection_Pic_Negatif,'MINPEAKDISTANCE',6);

figure
plot(Burst(:,1),Burst(:,2))
hold on
plot(Burst(NumSamplePositifRecorded,1),ValPicPositifRecorded,'r*')
plot(Burst(NumSampleNegatifRecorded,1),-ValPicNegatifRecorded,'c*')


if (length(ValPicNegatifRecorded) == length(ValPicPositifRecorded)) & (length(ValPicPositifRecorded) == Freq_Burst*DureeProgrammee_Burst)
    disp('OK')
else
    disp('KO')
end


Burst_Tension_Maximum_Positive_Moyenne = mean(ValPicPositifRecorded);
Burst_EcartType_Tension_Maximum_Positive_Moyenne = std(ValPicPositifRecorded);
Burst_Tension_Maximum_Negative_Moyenne = mean(ValPicNegatifRecorded);
Burst_EcartType_Tension_Maximum_Negative_Moyenne = std(ValPicNegatifRecorded);

Temps_Debut_Burst = Burst(NumSamplePositifRecorded(1),1)-0.000004/4; %0.000004 --> durée d'une période à 250 kHz, /4 car c'est un quart de période avant le premier cycle que le burst commence
%Temps_Fin_Burst = Burst(NumSamplePositifRecorded(end),1)+(0.000004/4)*3;
% Temps_Debut_Burst = 3e-07;

% Analyse FFT du Burst
L1 = length(Burst(find(Burst(:,1)== Temps_Debut_Burst):find(Burst(:,1)==Temps_Debut_Burst)+NumSample_Burst,2));                     % Length of signal
NFFT1 = 2^nextpow2(L1); % Next power of 2 from length of y
FFT_Burst_Amplitude = fft(Burst(find(Burst(:,1)==Temps_Debut_Burst):find(Burst(:,1)==Temps_Debut_Burst)+NumSample_Burst,2),NFFT1)/L1;
FFT_Burst_Frequence = Fs/2*linspace(0,1,NFFT1/2+1);
FFT_Burst_Freq_Centrale = FFT_Burst_Frequence(find(FFT_Burst_Amplitude==max(FFT_Burst_Amplitude(1:NFFT1/2+1))));

figure()
plot(FFT_Burst_Frequence,2*abs(FFT_Burst_Amplitude(1:NFFT1/2+1)))

title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')

% Analyse FFt du Duty Cycle après Burst
L2 = length(Burst(find(Burst(:,1)==Temps_Debut_Burst)+NumSample_Burst+1:end,2));                     % Length of signal
NFFT2 = 2^nextpow2(L2); % Next power of 2 from length of y
FFT_DutyCycle_Amplitude = fft(Burst(find(Burst(:,1)==Temps_Debut_Burst)+NumSample_Burst+10:end,2),NFFT2)/L2;
FFT_DutyCycle_Frequence = Fs/2*linspace(0,1,NFFT2/2+1);

figure()
plot(FFT_DutyCycle_Frequence,2*abs(FFT_DutyCycle_Amplitude(1:NFFT2/2+1)))
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')


DutyCycle_Tension_Moyenne = mean(Burst(find(Burst(:,1)==Temps_Debut_Burst)+NumSample_Burst+10:end,2));
DutyCycle_EcartType = std(Burst(find(Burst(:,1)==Temps_Debut_Burst)+NumSample_Burst+10:end,2));

save('Analyse_Donnees_Oscillo_Burst_200kHz_5.0_PRF_1kHz.mat')

plot(Burst(find(Burst(:,1)==Temps_Debut_Burst)+NumSample_Burst+10:end,2))