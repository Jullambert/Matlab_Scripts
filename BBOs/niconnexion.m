function [NI, ch] = niconnexion(Signal_Output_Rate,NumberOfAIChannel,NumberOfAOChannel,NumberOfDIChannel,NumberOfDOChannel)
% This function establish a connexion to the NI PXIe 6343 BNC
% card. The different analog input/output and digital input/output are set

ch = {};
di = {};
do = {};
daq.reset
% daq.HardwareInfo.getInstance('DisableReferenceClockSynchronization',true);


a=daq.getDevices;
if isempty(a);
    disp('No NI device found.');
    return;
end;
disp('Initializing the NI device. This may take a few seconds.');
%create the session
NI.session=daq.createSession('ni');
%get devices
a=daq.getDevices;
NI.ID=a.ID;

NI.session.Rate = Signal_Output_Rate ;
NI.Rate = Signal_Output_Rate ;
if NumberOfAIChannel == 0
    i=0;
else
    for i=1:NumberOfAIChannel
    ch{i} = ['ch' num2str(i)] ;
    ch{i} = addAnalogInputChannel(NI.session,a.ID,i-1,'Voltage');
    ch{1,i}.Range = [-10,10];
    end
end

if NumberOfAOChannel == 0
    j=0;
else
    for j=1:NumberOfAOChannel
    ch{i+j} = ['ch' num2str(j+i)] ;
    ch{i+j} = addAnalogOutputChannel(NI.session,a.ID,j-1,'Voltage');
    end     
end

if NumberOfDIChannel == 0
    k=0;
else
    for k=1:NumberOfDIChannel
    ch{i+j+k} = ['ch' num2str(k+j+i)] ;
    di{k} = ['Port0/Line' num2str(k-1)];
    ch{i+j+k} = addDigitalChannel(NI.session,a.ID,di,'InputOnly');
    end    
end


if NumberOfDOChannel == 0
    l=0;
else
    for l=1:NumberOfDOChannel
    ch{i+j+k+l} = ['ch' num2str(l+k+j+i)] ;
    do{l} = ['Port0/Line' num2str(l-1+k)];
    ch{i+j+k+l} = addDigitalChannel(NI.session,a.ID,do,'OutputOnly');
    end
end
disp('Initialized!')
end


