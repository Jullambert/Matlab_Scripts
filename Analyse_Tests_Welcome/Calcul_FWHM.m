%%Full width half maximum

Max_Isppa_500_Rot15 = max(max(Isppa_500_Rot15_1Vpp));
Isppa_500_Rot15_1Vpp_Normalisee = Isppa_500_Rot15_1Vpp./Max_Isppa_500_Rot15;

[PositionX_maxIsppa_Rot15, PositionY_maxIsppa_Rot15] = find(Isppa_500_Rot15_1Vpp==max(max(Isppa_500_Rot15_1Vpp)))
[PositionX_maxIsppa_Rot15_Normalisee, PositionY_maxIsppa_Rot15_Normalisee] = find(Isppa_500_Rot15_1Vpp_Normalisee==1)
FHWM_Matrix = zeros(size(v,1),size(v,2));

for x=1:size(v,1);
    for y=1:size(v,2);
       if Isppa_500_Rot15_1Vpp_Normalisee(x,y) >= 0.5
            FHWM_Matrix(x,y) = 1;
       end
    end;
    
end;
