%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Script to filtering the data based on the frequency of the measurements
%noise with the DensoRobot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

C = importdata(filename);
c = C.data;
Fz = -c(2000:end,17);

m = length(Fz); % Windowlength
n = pow2(nextpow2(m)); %Transform length
y= fft(Fz,n); %DFT
f = (0:n-1)*(Sampling_Frequency/n); %Frequencyrange
power = y.*conj(y)/n; %Power of the DFT

figure()
plot(f(1:floor(n/2)),power(1:floor(n/2)))
xlabel('Frequency(Hz)')
ylabel('Power')
title('{\bf Periodogram}')

