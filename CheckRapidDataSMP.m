% Filter design
cutoff_frequency = 150;
sampling_frequency = 1000;
[B A] = butter(2,cutoff_frequency/(sampling_frequency/2),'low');

data_files_root_dir = uigetdir; % open a GUI to select the folder to open (where are stored the data)
cd(data_files_root_dir) % Change the current folder to the folder where are the data
data_files_name = dir('*.csv'); % Variable with all the name inside the folder RootDir

for ii=1:length(data_files_name)
    Filename{ii,1} = data_files_name(ii).name;
    st=data_files_name(ii).name;
%             idx=strfind(st,'Num_Step_')+9;
    idx=strfind(st,'_JL_')+4;
    idx2=strfind(st,'.csv')-1;
    stval(ii)=str2num(st(idx:idx2));
    [a,b]=sort(stval);
end
Filename2 = Filename(b);
%% Importing the data into a Matrix. One colonne = 1 trial
Data = zeros(11001,size(Filename2,1));
for i=1:size(Filename2,1)
    Data = xlsread(Filename2{i});
    normal_force(:,i) = -Data(:,11);
    tangential_force_x(:,i) = Data(:,9);
    tangential_force_y(:,i) = Data(:,10);
    tangential_force(:,i) = sqrt(tangential_force_x(:,i).^2+tangential_force_y(:,i).^2);
    normal_force_filtered(:,i)= filtfilt(B, A,normal_force(:,i));
    robot_force_setpoint(:,i) = -Data(:,23);
    Yin(:,i)=Data(:,2);
    Yout(:,i)=Data(:,6);
    Zin(:,i)=Data(:,3);
    Zout(:,i)=Data(:,7);
    Stimtac(:,i)=Data(:,24);
%     figure
%     plot(Yin(:,i)-50,'r')
%     hold on
%     plot(Yout(:,i)-50,'b')
%     plot(Stimtac(:,i),'g')
    figure
    plot(normal_force_filtered(:,i),'r')
    hold on
    plot(Zout(:,i)-217,'b')
    plot(Stimtac(:,i),'g')
end
