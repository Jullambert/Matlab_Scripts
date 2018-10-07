function [Pi,Isppa,Ispta,mechanicalIndex, thermalIndex,PII] = ultrasoundParameters(BurstPressureWaveform,TimeVector,Density,SoundVelocity,UltrasoundBurstFrequency,DutyCycle,SamplingFrequency,SonicationDuration)

% Isppa in [W/m^2]
% Pressure in [Pa]
% Density in [kg/m^3] cfr Tufail : 1028 
% SoundVelocity in m/s  cfr Tufail 1515
% UltrasoundBurstFrequency = 350000
% PulseRepetitonFrequency = 1 [kHz]

%% Computation of the pulse pressure squared integral 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SquaredBurstPressureWaveform = BurstPressureWaveform.^2;
PII = cumsum(SquaredBurstPressureWaveform)/SamplingFrequency; %Modif en "sum" PII : pulse intensity integral
Pi = PII(end);

%% Computation the pulse duration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Equal 1.25 times the interval between the time integral of the
% instantaneous acoustic pressure squared reaches 10 % and 90 % of its
% final value (pulse pressure squared integral)

% First step : calculate t1
IndiceT1 = find(PII >= (0.1*Pi),1);
t1 = TimeVector(IndiceT1);
% Second step : calculate t2
IndiceT2 = find(PII >= (0.9*Pi),1);
t2 = TimeVector(IndiceT2);
%last step : calculate the pulse duration
td = 1.25 *(t2(1)-t1(1));

%% Computation of Isppa
%%%%%%%%%%%%%%%%%%%%%%%
Z = Density * SoundVelocity;
Isppa = (Pi./Z)./td;
Isppa = Isppa;

%% Computation of Ispta
%%%%%%%%%%%%%%%%%%%%%%%
Ispta = Isppa*DutyCycle;

%% Computation of the mechanical index
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mechanicalIndex = (abs(min(BurstPressureWaveform)*1e-6))/(sqrt(UltrasoundBurstFrequency*1e-6));
%[MPa/MHz]
%% thermal index
thermalIndex = 2*0.0175*(Isppa*DutyCycle*1e-4)*SonicationDuration/3.811;

end

% function [Isppa,mechanicalIndex] = ultrasoundParameters(maxPositivePressure,Density,soundVelocity,ultrasoundFrequency)

% Pressurekilo = maxPositivePressure/1000;

% Isppa = (maxPositivePressure.^2)./(2*Density*soundVelocity); %[W/m²]
% Isppa = Isppa/10000; %W/cm²]
% 
% mechanicalIndex = Pressurekilo/(ultrasoundFrequency^0.5);
