
figure()

subplot(3,2,1)

Data = ARCS_read("Fig3a.dat");
clim([0 2e-4])
% Set axis labels and title
xlabel('|{\bfq}| (2\pi/a)');
ylabel('{\itE} (meV)');
title('(0 0 8) + [{\itH} 0 0]');
xlim([-4 4])
ylim([0 25])


subplot(3,2,3)
Data = ARCS_read("Fig3c.dat");
clim([0 2e-4])
% Set axis labels and title
xlabel('|{\bfq}|  (\surd{2}\times2\pi/a)');
ylabel('{\itE} (meV)');
title('(-5 5 0) + [{\itH} {\itH} 0]')
xlim([-4 4])
ylim([0 25])


subplot(3,2,5)
Data = ARCS_read("Fig3e.dat");
clim([0 3e-4])
% Set axis labels and title
xlabel('|{\bfq}|  (\surd{3}\times2\pi/a)');
ylabel('{\itE} (meV)');
title('(-6 6 0) + [{\itH} {\itH} {\itH}]')
xlim([2 6])
ylim([0 25])


%%

ax2 = subplot(3,2,2);

Data = Euphonic_read("Fig3b.csv");
clim([0 30])
xlim([-4 4])
ylim([0 25])
% Set axis labels and title
xlabel('|{\bfq}|  (2\pi/a)');
ylabel('{\itE} (meV)');
title('(0 0 8) + [{\itH} 0 0]');

ax4 = subplot(3,2,4);

Data = Euphonic_read("Fig3d.csv");
clim([0 30])
xlim([-4 4])
ylim([0 25])
% Set axis labels and title
xlabel('|{\bfq}|  (\surd{2}\times2\pi/a)');
ylabel('{\itE} (meV)');
title('(-5 5 0) + [{\itH} {\itH} 0]')


ax6 = subplot(3,2,6);

Data = Euphonic_read("Fig3f.csv");
clim([0 45])
xlim([2 6])
ylim([0 25])
% Set axis labels and title
xlabel('|{\bfq}|  (\surd{3}\times2\pi/a)');
ylabel('{\itE} (meV)');
title('(-6 6 0) + [{\itH} {\itH} {\itH}]')

%% Creat a colormap for euphonic

cMap = jet(256);
dataMax = 30;
dataMin = 1;
centerPoint = 5;
scalingIntensity = 5;

x = 1:length(cMap); 
x = x - (centerPoint-dataMin)*length(x)/(dataMax-dataMin);
x = scalingIntensity * x/max(abs(x));

x = sign(x).* exp(abs(x));

x = x - min(x); x = x*511/max(x)+1; 

newMap = interp1(x, cMap, 1:512);
colormap(ax2,newMap)
colormap(ax4,newMap)
colormap(ax6,newMap)

%%
% figure(100)
% hold on
% plot(1:2:512,x)
% plot(1:512,1:512)
% hold off




%%

function y = ARCS_read(filepath)

% Load the data (assuming a text file or similar format)
data = readmatrix(filepath, 'FileType', 'text'); % Adjust if necessary

% Extract columns
intensity = data(:, 1);      % Intensity values
error = data(:, 2);          % Error values (might not be used in plotting)
H00 = data(:, 3);            % [H00] values
deltaE = data(:, 4);         % DeltaE values

% Find unique x and y values
H00_unique = unique(H00);        % Unique [H00] values for x-axis
deltaE_unique = unique(deltaE);  % Unique deltaE values for y-axis

% Create grid for x and y
[X, Y] = meshgrid(H00_unique, deltaE_unique);

% Interpolate intensity values onto the grid
Z = griddata(H00, deltaE, intensity, X, Y);

% Plot the filled colormap using imagesc
y = imagesc(H00_unique, deltaE_unique, Z);
set(gca, 'YDir', 'normal');  % Ensure the y-axis is oriented correctly
colormap(jet);               % Set colormap to jet

%colorbar;                    % Add a colorbar for intensity scale


end


function y = Euphonic_read(filepath)



% Load the data (assuming a text file or similar format)
data = readmatrix(filepath, 'FileType', 'text'); % Adjust if necessary

% Extract columns
intensity = data(:, 3);      % Intensity values
H00 = data(:, 1);            % [H00] values
deltaE = data(:, 2);         % DeltaE values

% Find unique x and y values
H00_unique = unique(H00);        % Unique [H00] values for x-axis
deltaE_unique = unique(deltaE);  % Unique deltaE values for y-axis

% Create grid for x and y
[X, Y] = meshgrid(H00_unique, deltaE_unique);

% Interpolate intensity values onto the grid
Z = griddata(H00, deltaE, intensity, X, Y);

% Plot the filled colormap using imagesc
y = imagesc(H00_unique, deltaE_unique, Z);
set(gca, 'YDir', 'normal');  % Ensure the y-axis is oriented correctly
colormap(jet);               % Set colormap to jet
%colorbar;                    % Add a colorbar for intensity scale


end
