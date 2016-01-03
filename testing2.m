x = [1,3,4,7,13,19,42];
y = [2,4,6,8,11,36,52];

plot(x, y, 'b*-', 'LineWidth', 2, 'MarkerSize', 15);

coeffs = polyfit(x, y, 1);
% Get fitted values
fittedX = linspace(min(x), max(x), 200);
fittedY = polyval(coeffs, fittedX);
% Plot the fitted line
hold on;
plot(fittedX, fittedY, 'r-', 'LineWidth', 3);