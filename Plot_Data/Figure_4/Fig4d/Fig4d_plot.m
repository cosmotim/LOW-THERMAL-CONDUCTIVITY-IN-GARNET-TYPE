Data = readmatrix("Gruneisen_mesh.txt");

omega = Data(:,2);
gruneisen = Data(:,3);
Li_contribution = Data(:,4);

% Plot omega vs gruneisen but also make Li_contribution a color map
figure;

scatter(omega, gruneisen, 10, Li_contribution, 'filled');
colorbar();
xlabel('$E$ (meV)', 'Interpreter', 'latex');
ylabel('$\gamma$','Interpreter', 'latex');
title('Gruneisen Parameter vs energy with Li Contribution','Interpreter', 'latex');
% Set axis limits
xlim([0 100]);
ylim([-1 15]);
box on