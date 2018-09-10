
[X,Y]=meshgrid(linspace(min(TMS.CoilPositionX(TMS_IndEMG1_ok)),max(TMS.CoilPositionX(TMS_IndEMG1_ok)),100),linspace(min(TMS.CoilPositionY(TMS_IndEMG1_ok)),max(TMS.CoilPositionY(TMS_IndEMG1_ok)),100));%MA: meshgrid 2D
Z=griddata(TMS.CoilPositionX(TMS_IndEMG1_ok),TMS.CoilPositionY(TMS_IndEMG1_ok),TMS.PeaktopeakV(TMS_IndEMG1_ok),X,Y,'v4');%MA: interpolate scattered data
figure;
%surf(X,Y,Z,'EdgeColor','none','LineStyle','none');%MA: 3D
imagesc(-linspace(min(TMS.CoilPositionX(TMS_IndEMG1_ok)),max(TMS.CoilPositionX(TMS_IndEMG1_ok)),100),linspace(min(TMS.CoilPositionY(TMS_IndEMG1_ok)),max(TMS.CoilPositionY(TMS_IndEMG1_ok)),100),Z);%MA: 3D

hold on;

for k = 1:size(TMS.PeaktopeakV(TMS_IndEMG1_ok),1)
    % Arbitrary function which relies on the random variable
    % Plot line with color selected by random number
    plot3(-TMS.CoilPositionX(TMS_IndEMG1_ok(k)),TMS.CoilPositionY(TMS_IndEMG1_ok(k)),TMS.PeaktopeakV(TMS_IndEMG1_ok(k))+10,'o','Color',TMS_HomeColor1(find(TMS.PeaktopeakV(TMS_IndEMG1_ok(k))==TMS_PtPValuesEMG1),:),'MarkerFaceColor',TMS_HomeColor1(find(TMS.PeaktopeakV(TMS_IndEMG1_ok(k))==TMS_PtPValuesEMG1),:),'MarkerSize',10)
%     plot(TMSS1.CoilPositionX(IndEMG1_ok(k)),TMSS1.CoilPositionY(IndEMG1_ok(k)),'o')

end
	hold off;
	title('Map TMS EMG Channel 1')
