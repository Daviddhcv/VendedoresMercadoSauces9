% =========================================================================
% Title: Monte Carlo Simulation Script - Logistics Unloading Time Analysis
% Project: Vendor-Centric Diagnostic of Traditional Public Markets (2026)
% Description: Step-by-step commented MATLAB code for stochastic modeling
%              of vendor unloading durations and loading dock bottlenecks.
% =========================================================================

clear; clc; close all;

% Set random number generator seed for exact reproducibility
rng(2026);

%% STEP 1: Define Simulation Parameters and Empirical Distributions
N_iterations = 10000;

% Empirical baseline parameters derived from field logistics audits (Module IV)
% Log-normal distribution parameters to capture right-skewed congestion delays
mu_log = log(45);     % Log-scale baseline scale parameter (approx. 45 minutes)
sigma_log = 0.32;     % Dispersion factor reflecting peak-hour dock friction

%% STEP 2: Execute Monte Carlo Stochastic Engine (N = 10,000 iterations)
simulated_unload_times = lognrnd(mu_log, sigma_log, N_iterations, 1);

% Introduce a morning peak-hour stochastic shock factor 
% (approx. 65% of vendors face congested delivery windows with delayed access)
peak_indicator = rand(N_iterations, 1) < 0.65;
simulated_unload_times(peak_indicator) = simulated_unload_times(peak_indicator) * 1.28;

%% STEP 3: Extract Key Operational Statistics
mean_time = mean(simulated_unload_times);
std_time = std(simulated_unload_times);
median_time = median(simulated_unload_times);
percentile_90 = prctile(simulated_unload_times, 90); % 90th percentile upper operational bound

% Calculate the exact percentage of stalls exceeding the 60-minute critical delay threshold
critical_delay_pct = (sum(simulated_unload_times > 60) / N_iterations) * 100;

fprintf('=== MONTE CARLO LOGISTICS SIMULATION RESULTS ===\n');
fprintf('Expected Mean Unloading Duration (mu):    %.2f minutes\n', mean_time);
fprintf('Operational Standard Deviation (sigma): %.2f minutes\n', std_time);
fprintf('Median Unloading Duration:              %.2f minutes\n', median_time);
fprintf('90th Percentile (Upper Bound):          %.2f minutes\n', percentile_90);
fprintf('Stalls exceeding 60-min critical delay: %%.2f%%\n\n', critical_delay_pct);

%% STEP 4: Generate Probability Density Function (PDF) Plot
figure('Color', 'white', 'Position', [150, 150, 750, 450]);
histogram(simulated_unload_times, 50, 'Normalization', 'pdf', ...
          'FaceColor', [0.20, 0.50, 0.55], 'EdgeColor', 'none');
hold on;

% Compute smooth kernel density estimation curve
[pdf_y, pdf_x] = ksdensity(simulated_unload_times);
plot(pdf_x, pdf_y, 'LineWidth', 2.5, 'Color', [0.85, 0.30, 0.10]);

% Reference line marking the 60-minute operational friction threshold
xline(60, '--r', 'LineWidth', 1.8, 'Label', 'Critical Congestion Threshold (60 min)');

title('Monte Carlo Probability Density: Vendor Unloading Times', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Simulated Unloading Duration (Minutes)', 'FontSize', 10);
ylabel('Probability Density Function (PDF)', 'FontSize', 10);
grid on;
legend({'Simulation Histogram', 'Kernel Density Fit', 'Critical Threshold'}, 'Location', 'northeast');
box on;