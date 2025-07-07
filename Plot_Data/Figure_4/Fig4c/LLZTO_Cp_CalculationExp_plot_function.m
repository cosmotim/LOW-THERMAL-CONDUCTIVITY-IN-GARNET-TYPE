function LLZTO_Cp_CalculationExp_plot_function


Data = readmatrix("LLZTO-sc 2-400 process 02282022.dat");
SampleTempKelvin = Data(:,8);
%SampHCJgK = Data(:,10).*1e-6./(16.3*1e-3);
%SampleHCError = Data(:,11).*1e-6./(16.3*1e-3);
SampHCJgK = Data(:,10);
SampleHCError = Data(:,11);
HC_data1 = [SampleTempKelvin, SampHCJgK, SampleHCError];

% Read in single crystal data

%%

V = 2176.68 * 1e-30; % A^3
M = (881.139) * 8 * (1.66 * 1e-24) * 1e-3; 
Density = M/V;
N = (6.5+3+2+12)*8;
N_density = N/V;

kb = 1.380649E-23; % J/K

hold on
scatter(HC_data1(:,1),HC_data1(:,2),'*','DisplayName','PPMS');
%errorbar(HC_data1(:,1),HC_data1(:,2),HC_data1(:,3),'Marker','none');

DataDSC2 = readmatrix("ExpDat_LLZTO-04072022-cool.csv");
DataDSC2(:,1) = DataDSC2(:,1)+273.15;
%smooth data and erase defect
DataDSC2smooth = smoothdata(DataDSC2(:,2));

deviation = (DataDSC2(:,2)-DataDSC2smooth).^2;
idx = DataDSC2(:,1) < 785;

for i  = 1:length(idx)
    if mod(i,10) ~= 0 
        idx(i) = false;
    end
end


scatter(DataDSC2(idx,1),DataDSC2smooth(idx),'x','DisplayName','DSC')




Data2 = readmatrix("LLZTO-HC-ZheCheng.csv");
Data2(:,2) = Data2(:,2)./(Density*1e-3);
%scatter(Data2(:,1),Data2(:,2),'square','DisplayName','Cheng et al.')
scatter(Data2(:,1),Data2(:,2),'square','DisplayName','Polycrystal [8]')

Data_DFT = readmatrix("LLZTO_Cp_QHA.csv");
plot(Data_DFT(:,1),Data_DFT(:,2),'-',"LineWidth",2.0,'DisplayName','Calculation')

Dulong_Limit = 3 * N_density * kb / Density *1e-3;
x1 = [0, 900];
y1 = [Dulong_Limit, Dulong_Limit];
plot(x1, y1,'k--','DisplayName','Dulong-Petit Limit');
hold off

ylabel("{\itC_p} (J g^{-1} K^{-1})")
xlabel("{\itT} (K)")

xlim([0 900])
legend('Location','southeast','FontSize',6)
%title("LLZTO Cp")

box on
end