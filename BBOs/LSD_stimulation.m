function [data]=LSD_stimulate(NI,base_temperature,stim_temperature,stim_duration,foreperiod_duration,total_duration)
%function that generate stimulation for the LSD laser according to the
%base_temperature and the stimulation temperature [°C]. 
%The foreperiod_duration correspond to the ... in [s]
%The total_duration icorrespond to .. in [s]
base_temperature = 20;
stim_temperature = 40;
stim_duration = 0.1;
foreperiod_duration = 0;
total_duration = 3;


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
%trigger
tpy2=zeros(size(tpx));
tpy2(dx1:dx2)=5;
%fpy
fpy(:,1)=tpy;
fpy(:,2)=tpy2;
fpy(:,3)=0*fpy(:,2);
fpy(:,4)=fpy(:,3);
%queue the data to NI
queueOutputData(NI.session,fpy);
disp('Data sent to NI');
prepare(NI.session);
[data,time]=NI.session.startForeground();
disp('Trial finished');
%data(:,1) should be the laser trigger
%data(:,2) should be the RT trigger
%data(:,3) should be the temp signal
%fetch the reaction time
rt_trig=min(find(data(:,2)<4));
if isempty(rt_trig);
    RT=-1;
else
    RT=(rt_trig/NI.Rate)-foreperiod_duration;
end;

end

