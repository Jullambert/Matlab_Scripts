function [ValueDerated, LinearAttenuationCoeff] = deratedValue(ValueToDerate,AttenuationCoefficient,Distance,Frequency)

%AttenuationCoefficient = [dB/(cm*MHz)]
%Distance = [cm]
%Frequency = [MHz]
LinearAttenuationCoeff = 10^((AttenuationCoefficient*Distance*Frequency)/10);
ValueDerated = ValueToDerate/LinearAttenuationCoeff;
