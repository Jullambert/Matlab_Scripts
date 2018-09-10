function [tpy]=LSD_temperature_stimulation(NI,base_temperature,stim_temperature,stim_duration,foreperiod_duration,total_duration)
%function that generate stimulation for the LSD laser according to the
%base_temperature and the stimulation temperature [°C]. 
%The foreperiod_duration correspond to the ... in [s]
%The total_duration icorrespond to .. in [s]
% For debug :  
% base_temperature = 20;
% stim_temperature = 40;
% stim_duration = 0.1;
% foreperiod_duration = 0;
% total_duration = 3;

%duration_bins
duration_bins=total_duration*NI.Rate;
%
tpx=1:1:duration_bins;
tpx=(tpx-1)/NI.Rate;
tpx=tpx-foreperiod_duration;
%base temperature
tpy=zeros(size(tpx));
tpy=tpy+base_temperature;
%stimulus
[a,dx1]=min(abs(tpx));
[a,dx2]=min(abs(tpx-stim_duration));
tpy(dx1:dx2)=stim_temperature;
%CONVERT LASER_TEMP to LASER_VOLT
tpy=(tpy*NI.out_slope)+NI.out_intercept;

end

