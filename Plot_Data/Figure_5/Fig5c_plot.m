Data = ARCS_read("Fig5c.dat");
clim([0 1.5e-3])
% Set axis labels and title
xlabel('[H00] (2\pi/a)');
ylabel('{\itE} (meV)');
%title('[H 0 0]');
xlim([0 8])
ylim([-5 5])


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