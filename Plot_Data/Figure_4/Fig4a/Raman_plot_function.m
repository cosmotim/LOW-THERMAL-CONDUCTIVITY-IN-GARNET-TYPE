function Raman_data = Raman_plot_function
Raman_data = readmatrix("Spot_1.csv","Range",'B:C');
plot(Raman_data(38:end,1).*0.123983,Raman_data(38:end,2),'LineStyle','-',LineWidth=1.5)
%plot([1090 1090]*0.123983, [0, 3e4],'--k')
%xline(1090*0.123983,'--k','Li_2CO_3','LabelHorizontalAlignment','left')
xlim([0 125])
xticks(0:25:125)
ylim([0 2e4])
ylabel("Intensity (a.u.)")
xlabel("Energy (meV)")
end