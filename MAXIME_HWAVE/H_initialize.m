function NI=H_initialize
disp('');
disp('AO0 : laser');
disp('A01 : elec');
disp('');
disp('Searching for devices');
daq.reset;
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
%set the DAQ samplingrate
NI.Rate=1000;
NI.session.Rate=NI.Rate;
%Add one analog output channels
addAnalogOutputChannel(NI.session,a.ID,0,'Voltage'); % laser
addAnalogOutputChannel(NI.session,a.ID,1,'Voltage'); % elec

%Add two analog input channels
addAnalogInputChannel(NI.session,a.ID,0,'Voltage'); % blank
addAnalogInputChannel(NI.session,a.ID,1,'Voltage'); % blank

disp('Initialized!');
end