%%Chargement des fichiers de résultat
load('C:\Users\jullambert\Dropbox (NOCIONS)\jlambert\UCL_PhD\Setup\Mesures_Welcome\Data_PieceAlignement_1Vpp\Resultats_Analyse_AlignementLaiton_1Vpp_5C_Rot0')
load('C:\Users\jullambert\Dropbox (NOCIONS)\jlambert\UCL_PhD\Setup\Mesures_Welcome\Data_PieceAlignement_1Vpp_rot15\Resultats_Analyse_AlignementLaiton_1Vpp_5C_Rot15')
load('C:\Users\jullambert\Dropbox (NOCIONS)\jlambert\UCL_PhD\Setup\Mesures_Welcome\Data_PieceAlignement_1Vpp_rot15_bis\Resultats_Analyse_AlignementLaiton_1Vpp_5C_Rot15_bis')

for x = 1:size(Isppa_Rot0,1)
   for y = 1:size(Isppa_Rot0,2) 
    
    Delta_Isppa_Rot0_Rot15(x,y) = Isppa_Rot0(x,y)- Isppa_Rot15(x,y);
    Delta_Isppa_Rot0_Rot15_bis(x,y) = Isppa_Rot0(x,y)- Isppa_Rot15_bis(x,y);
    Delta_Isppa_Rot15_Rot15_bis(x,y) = Isppa_Rot15(x,y)- Isppa_Rot15_bis(x,y);
    
    Delta_Pi_Rot0_Rot15(x,y) = Pi_Rot0(x,y)- Pi_Rot15(x,y);
    Delta_Pi_Rot0_Rot15_bis(x,y) = Pi_Rot0(x,y)- Pi_Rot15_bis(x,y);
    Delta_Pi_Rot15_Rot15_bis(x,y) = Pi_Rot15(x,y)- Pi_Rot15_bis(x,y);
    
    
   end
end


[PositionX_maxIsppa_Rot0, PositionY_maxIsppa_Rot0] = find(Isppa_Rot0==max(max(Isppa_Rot0)));
[PositionX_maxIsppa_Rot15, PositionY_maxIsppa_Rot15] = find(Isppa_Rot15==max(max(Isppa_Rot15)));
[PositionX_maxIsppa_Rot15_bis, PositionY_maxIsppa_Rot15_bis] = find(Isppa_Rot15_bis==max(max(Isppa_Rot15_bis)));

[PositionX_maxPi_Rot0, PositionY_maxPi_Rot0] = find(Pi_Rot0==max(max(Pi_Rot0)));
[PositionX_maxPi_Rot15, PositionY_maxPi_Rot15] = find(Pi_Rot15==max(max(Pi_Rot15)));
[PositionX_maxPi_Rot15_bis, PositionY_maxPi_Rot15_bis] = find(Pi_Rot15_bis==max(max(Pi_Rot15_bis)));

% [PositionX_maxPi_Complet, PositionY_maxPi_Complet] = find(Pi_Complet==max(max(Pi_Complet)));
