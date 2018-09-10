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

max(max(Isppa_Rot0))
