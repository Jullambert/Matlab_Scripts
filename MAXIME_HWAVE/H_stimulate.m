function [data]=H_stimulate(NI,ISI)

%foreperiod
foreperiod=0.5;

%stim duration
stim_duration=0.05;

%duration_bins
duration_bins=2*NI.Rate;
%
tpx=1:1:duration_bins;
tpx=(tpx-1)/NI.Rate;
tpx=tpx-foreperiod;

%initialize tpy
tpy=zeros(duration_bins,2);

%laser
[a,dx1]=min(abs(tpx));
[a,dx2]=min(abs(tpx-stim_duration));
tpy(dx1:dx2,1)=5;

%elec
[a,dx1]=min(abs(tpx-ISI));
[a,dx2]=min(abs((tpx-ISI)-stim_duration));
tpy(dx1:dx2,2)=5;

%figure;
%subplot(2,1,1);
%plot(tpx,tpy(:,1));
%subplot(2,1,2);
%plot(tpx,tpy(:,2));

%queue the data to NI
queueOutputData(NI.session,tpy);
disp('Data sent to NI');
prepare(NI.session);
[data,time]=NI.session.startForeground();

disp('Trial finished');
end