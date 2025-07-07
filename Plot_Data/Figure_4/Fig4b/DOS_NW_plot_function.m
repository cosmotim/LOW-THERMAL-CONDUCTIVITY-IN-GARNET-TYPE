function DOS_NW_plot_function()
h = 4.135667696; %meV/THz
DOS_data_unit = readmatrix("vdos_smooth_meVunit.csv");
DOS_PW = zeros(length(DOS_data_unit(:,3)),6);
weightlist = [0.197, 0.265, 0.071, 0.033, 0.070];
for i = 3:7
%plot(DOS_data_unit(:,1),DOS_data_unit(:,i),LineWidth=1)
DOS_PW(:,i-2) = DOS_data_unit(:,i).*weightlist(i-2);
%plot(DOS_data_unit(:,1),DOS_PW(:,i-2),LineWidth=1)
DOS_PW(:,6) = DOS_PW(:,6)+DOS_PW(:,i-2);
end
hold on
for i = 3:7
%plot(DOS_data_unit(:,1),DOS_data_unit(:,i),LineWidth=1)
%DOS_PW(:,i-2) = DOS_data_unit(:,i).*weightlist(i-2);
plot(DOS_data_unit(:,1),DOS_PW(:,i-2)./norm(DOS_PW(:,6),1)./(h*5*1e-4),LineWidth=1)
%DOS_PW(:,6) = DOS_PW(:,6)+DOS_PW(:,i-2);
end
%plot(DOS_data_unit(:,1),DOS_data_unit(:,2),'k--')
plot(DOS_data_unit(:,1),DOS_PW(:,6)./norm(DOS_PW(:,6),1)./(h*5*1e-4),'k--')
hold off
%xlim([0 1300])
xlim([0 100])
xticks(0:25:100)
ylim([0 0.025])
box on
DOS_list = ["Li","O","Zr","Ta","La","Total"];
legend(DOS_list,'FontSize',6)
xlabel("Energy (meV)")
ylabel("DOS (meV^{-1})")
end