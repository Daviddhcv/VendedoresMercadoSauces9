% =========================================================================
% Title:   Vendor-Centric Diagnostic of Traditional Public Markets
%          Complete Figure Generation Script (Version 2 — GitHub Release)
% Project: Municipal Market "Sauces 9", Guayaquil, Ecuador (2026)
% Author:  Research Team (anonymised for peer review)
% Purpose: Reproduces ALL figures in the manuscript:
%          Fig 1  — Commercial activity bar chart
%          Fig 2  — Administrative compliance grouped bar chart
%          Fig 3  — Loading dock pie chart
%          Fig 4  — Digital adoption bar chart
%          Fig 5  — Sales trend bar chart
%          Fig 6  — Musculoskeletal pain line chart
%          Fig 7  — Monte Carlo PDF (main logistics figure)
%          Fig 8  — Sensitivity analysis horizontal bar chart
%          Fig 9  — PLS-SEM path diagram (SVG-style annotation)
% Output:  All figures saved as high-resolution PNG (300 dpi) and PDF
% =========================================================================

clear; clc; close all;
rng(2026);   % Fixed seed for exact reproducibility

% -------------------------------------------------------------------------
% COLOUR PALETTE  (consistent across all figures)
% -------------------------------------------------------------------------
C_BLUE   = [0.20, 0.40, 0.65];   % primary bars / histogram
C_ORANGE = [0.85, 0.40, 0.10];   % KDE curve / accent
C_GREEN  = [0.18, 0.60, 0.35];   % positive sensitivity
C_RED    = [0.80, 0.15, 0.15];   % negative sensitivity / critical line
C_PURPLE = [0.50, 0.25, 0.70];   % digital adoption
C_PINK   = [0.85, 0.25, 0.55];   % sales trend decreased
C_GREY   = [0.45, 0.45, 0.45];   % stable sales
C_TEAL   = [0.20, 0.50, 0.55];   % Monte Carlo histogram
FONT_SZ  = 10;

% Output folder
outDir = 'figures_V2';
if ~exist(outDir, 'dir'); mkdir(outDir); end

function save_fig(fig, name, outDir)
    exportgraphics(fig, fullfile(outDir, [name '.png']), ...
        'Resolution', 300);
    exportgraphics(fig, fullfile(outDir, [name '.pdf']));
    fprintf('Saved: %s\n', name);
end

% =========================================================================
% FIGURE 1 — Distribution of Commercial Activities (n = 201)
% =========================================================================
sectors   = {'Vegetables','Groceries','Misc.\ Goods','Fruits', ...
             'Seafood','Poultry','Prep.\ Foods','Others'};
freq_act  = [62, 29, 27, 19, 15, 11, 10, 28];   % 28 = collapsed others

fig1 = figure('Color','white','Position',[100 100 700 420]);
b = bar(freq_act, 'FaceColor', C_BLUE, 'EdgeColor', 'none');
set(gca, 'XTickLabel', sectors, 'FontSize', FONT_SZ, 'Box', 'off');
xlabel('Commercial Sector',   'FontSize', FONT_SZ+1);
ylabel('Number of Vendors',   'FontSize', FONT_SZ+1);
%title('Fig.~1 — Distribution of commercial activities among surveyed market stalls','FontSize', FONT_SZ+1, 'FontWeight', 'bold');
xtickangle(30); grid on; ylim([0 70]);
text(1:numel(freq_act), freq_act+1, num2str(freq_act'), ...
    'HorizontalAlignment','center','FontSize',8);
save_fig(fig1, 'vendor_activity', outDir);

% =========================================================================
% FIGURE 2 — Administrative Compliance Grouped Bar Chart (n = 201)
% =========================================================================
params_adm   = {'Occupancy Permit','Operating Tax','Cadastral Registry', ...
                'Price List Display'};
compliant    = [197, 198, 195, 189];
noncompliant = [4,   3,   6,   12];
data_adm     = [compliant; noncompliant]';

fig2 = figure('Color','white','Position',[100 100 700 420]);
b2 = bar(data_adm, 'grouped');
b2(1).FaceColor = [0.15, 0.60, 0.30];   % green
b2(2).FaceColor = [0.75, 0.15, 0.15];   % red
b2(1).EdgeColor = 'none';
b2(2).EdgeColor = 'none';
set(gca,'XTickLabel', params_adm,'FontSize',FONT_SZ,'Box','off');
xlabel('Administrative Parameter','FontSize',FONT_SZ+1);
ylabel('Number of Stalls','FontSize',FONT_SZ+1);
%title('Fig.~2 — Administrative and municipal permit compliance among vendors','FontSize',FONT_SZ+1,'FontWeight','bold');
legend({'Yes / Compliant','No / Irregular'},'Location','northeast','FontSize',9);
xtickangle(20); grid on; ylim([0 210]);
save_fig(fig2, 'vendor_permits', outDir);

% =========================================================================
% FIGURE 3 — Loading Dock Evaluation Pie Chart (n = 201)
% =========================================================================
dock_vals    = [62.69, 33.83, 3.48];
dock_labels  = {'Adequate \& Orderly','Conflictive / Insufficient','Chaotic / Uncontrolled'};
dock_colors  = [C_BLUE; [0.95,0.60,0.10]; C_RED];

fig3 = figure('Color','white','Position',[100 100 600 440]);
p = pie(dock_vals);
for k = 1:2:length(p)
    p(k).FaceColor = dock_colors((k+1)/2, :);
    p(k).EdgeColor = 'white';
end
for k = 2:2:length(p)
    p(k).FontSize = 10;
end
%title('Fig.~3 — Vendor evaluation of loading dock access and logistical friction','FontSize',FONT_SZ+1,'FontWeight','bold');
legend(dock_labels,'Location','southoutside','FontSize',9,'Orientation','horizontal');
save_fig(fig3, 'vendor_dock', outDir);

% =========================================================================
% FIGURE 4 — Digital Adoption Bar Chart (n = 201)
% =========================================================================
dig_labels = {'Basic Usage','Habitual Use','No Digital Tools'};
dig_vals   = [91, 56, 54];

fig4 = figure('Color','white','Position',[100 100 620 420]);
bar(dig_vals, 'FaceColor', C_PURPLE, 'EdgeColor','none');
set(gca,'XTickLabel', dig_labels,'FontSize',FONT_SZ,'Box','off');
ylabel('Number of Vendors','FontSize',FONT_SZ+1);
xlabel('Adoption Level','FontSize',FONT_SZ+1);
%title('Fig.~4 — Adoption of digital tools and electronic payment systems among vendors','FontSize',FONT_SZ+1,'FontWeight','bold');
grid on; ylim([0 100]);
text(1:3, dig_vals+1.5, num2str(dig_vals'),'HorizontalAlignment','center','FontSize',9);
save_fig(fig4, 'vendor_digital', outDir);

% =========================================================================
% FIGURE 5 — Sales Trend Bar Chart (n = 201)
% =========================================================================
sales_labels = {'Decreased','Maintained','Increased'};
sales_vals   = [103, 88, 9];
sales_colors = [C_PINK; C_GREY; [0.75, 0.80, 0.20]];

fig5 = figure('Color','white','Position',[100 100 620 420]);
bh = bar(sales_vals);
for k = 1:3
    bh.FaceColor = 'flat';
    bh.CData(k,:) = sales_colors(k,:);
end
set(gca,'XTickLabel', sales_labels,'FontSize',FONT_SZ,'Box','off');
ylabel('Number of Vendors','FontSize',FONT_SZ+1);
xlabel('Sales Trend (compared to previous year)','FontSize',FONT_SZ+1);
%title('Fig.~5 — Daily sales and income trends compared to the previous operational year','FontSize',FONT_SZ+1,'FontWeight','bold');
grid on; ylim([0 115]);
text(1:3, sales_vals+2, num2str(sales_vals'),'HorizontalAlignment','center','FontSize',9);
save_fig(fig5, 'vendor_sales', outDir);

% =========================================================================
% FIGURE 6 — Musculoskeletal Pain Line Chart (n = 201)
% =========================================================================
pain_labels = {'Never','Rarely','Frequently','Always'};
pain_vals   = [82, 64, 48, 7];

fig6 = figure('Color','white','Position',[100 100 620 420]);
plot(1:4, pain_vals, '-o', 'Color', [0.50 0.10 0.10], ...
    'LineWidth', 2.2, 'MarkerSize', 8, 'MarkerFaceColor', [0.50 0.10 0.10]);
set(gca,'XTick',1:4,'XTickLabel', pain_labels,'FontSize',FONT_SZ,'Box','off');
ylabel('Number of Vendors','FontSize',FONT_SZ+1);
xlabel('Pain Frequency','FontSize',FONT_SZ+1);
%title('Fig.~6 — Frequency of vendor musculoskeletal fatigue and physical pain','FontSize',FONT_SZ+1,'FontWeight','bold');
grid on; ylim([0 90]);
text(1:4, pain_vals+2, num2str(pain_vals'),'HorizontalAlignment','center','FontSize',9);
save_fig(fig6, 'vendor_pain', outDir);

% =========================================================================
% FIGURE 7 — Monte Carlo Probability Density (MAIN LOGISTICS FIGURE)
% =========================================================================
N_iterations = 10000;
mu_log    = log(45);
sigma_log = 0.32;
simulated_unload_times = lognrnd(mu_log, sigma_log, N_iterations, 1);

% Morning peak-hour stochastic shock (65 % of vendors face congested windows)
peak_indicator = rand(N_iterations, 1) < 0.65;
simulated_unload_times(peak_indicator) = ...
    simulated_unload_times(peak_indicator) * 1.28;

% Summary statistics
mean_time          = mean(simulated_unload_times);
std_time           = std(simulated_unload_times);
median_time        = median(simulated_unload_times);
percentile_90      = prctile(simulated_unload_times, 90);
critical_delay_pct = (sum(simulated_unload_times > 60) / N_iterations) * 100;

fprintf('\n=== MONTE CARLO LOGISTICS SIMULATION RESULTS ===\n');
fprintf('  Mean unloading duration (mu):         %.2f min\n', mean_time);
fprintf('  Standard deviation (sigma):           %.2f min\n', std_time);
fprintf('  Median unloading duration:            %.2f min\n', median_time);
fprintf('  90th percentile:                      %.2f min\n', percentile_90);
fprintf('  P(unloading > 60 min):                %.2f%%\n\n', critical_delay_pct);

fig7 = figure('Color','white','Position',[150, 150, 750, 450]);
histogram(simulated_unload_times, 50, 'Normalization','pdf', ...
          'FaceColor', C_TEAL, 'EdgeColor','none'); hold on;

[pdf_y, pdf_x] = ksdensity(simulated_unload_times);
plot(pdf_x, pdf_y, 'LineWidth', 2.5, 'Color', C_ORANGE);

xline(60, '--r', 'LineWidth', 1.8, ...
    'Label', sprintf('Critical Threshold (60 min)\nP(T>60) = %.1f%%', ...
    critical_delay_pct), 'LabelOrientation','horizontal', ...
    'LabelVerticalAlignment','bottom');

xlabel('Simulated Unloading Duration (Minutes)', 'FontSize', FONT_SZ+1);
ylabel('Probability Density Function (PDF)',      'FontSize', FONT_SZ+1);
%title(sprintf(['Fig.~7 — Monte Carlo PDF: Vendor Unloading Times\n''\\mu =
%%.1f min,  \\sigma = %.1f min,  N = %d iterations'],mean_time, std_time, N_iterations),'FontSize', FONT_SZ+1, 'FontWeight', 'bold');
legend({'Simulation Histogram','Kernel Density Fit','Critical Threshold'}, ...
    'Location','northeast','FontSize',9);
grid on; box on; xlim([0 200]);
save_fig(fig7, 'montecarlomercado', outDir);

% =========================================================================
% FIGURE 8 — Sensitivity Analysis Horizontal Bar Chart
% =========================================================================
sens_labels = {'Credit Access','Wholesale Price Index','Digital Adoption', ...
               'Loading Dock Delay','Electrical Stability'};
sens_vals   = [-0.18, -0.31, 0.28, 0.35, 0.42];
colors_sens = arrayfun(@(v) ...
    [((v < 0)*C_RED(1) + (v >= 0)*C_GREEN(1)), ...
     ((v < 0)*C_RED(2) + (v >= 0)*C_GREEN(2)), ...
     ((v < 0)*C_RED(3) + (v >= 0)*C_GREEN(3))], ...
    sens_vals, 'UniformOutput', false);
colors_sens = vertcat(colors_sens{:});

fig8 = figure('Color','white','Position',[100 100 680 380]);
bh8 = barh(sens_vals,'FaceColor','flat','EdgeColor','none');
bh8.CData = colors_sens;
set(gca,'YTickLabel', sens_labels,'FontSize',FONT_SZ,'Box','off');
xlabel('Sensitivity Coefficient (Standardised Regression)','FontSize',FONT_SZ+1);
%title('Fig.~8 — Sensitivity coefficients of primary operational parameters on vendor commercial profitability','FontSize',FONT_SZ+1,'FontWeight','bold');
xline(0,'k-','LineWidth',0.8); grid on;
xlim([-0.40 0.55]);
save_fig(fig8, 'sensitivity_analysis', outDir);

% =========================================================================
% FIGURE 9 — PLS-SEM Path Diagram (schematic annotation)
% =========================================================================
fig9 = figure('Color','white','Position',[100 100 800 480]);
axis off; hold on;

% Box positions [x_center, y_center, width, height]
boxes = struct();
boxes.xi1  = [0.15, 0.75, 0.22, 0.12];  % Infrastructure Stability
boxes.xi2  = [0.15, 0.50, 0.22, 0.12];  % Logistics Friction
boxes.xi3  = [0.15, 0.25, 0.22, 0.12];  % Digital Adoption
boxes.eta  = [0.72, 0.50, 0.22, 0.12];  % Commercial Resilience

draw_box = @(b, label, clr) annotation('textbox', ...
    [b(1)-b(3)/2, b(2)-b(4)/2, b(3), b(4)], ...
    'String', label, 'HorizontalAlignment','center', ...
    'VerticalAlignment','middle', 'FontSize', 10, 'FontWeight','bold', ...
    'BackgroundColor', clr, 'EdgeColor', [0.3 0.3 0.3], ...
    'LineWidth', 1.4, 'FitBoxToText', false);

draw_box(boxes.xi1, sprintf('Infrastructure\nStability (\x03BE_1)'), [0.75 0.88 0.95]);
draw_box(boxes.xi2, sprintf('Logistics\nFriction (\x03BE_2)'),       [1.00 0.80 0.70]);
draw_box(boxes.xi3, sprintf('Digital\nAdoption (\x03BE_3)'),         [0.75 0.95 0.75]);
draw_box(boxes.eta, sprintf('Commercial\nResilience (\x03B7)'),       [0.95 0.95 0.70]);

% Arrows and beta labels
arrow_props = {'HeadStyle','vback2','LineStyle','-','LineWidth',2.0};

arr_col = @(b) [0.1 0.1 0.1];

% H1: xi1 -> eta  (positive)
annotation('arrow',[boxes.xi1(1)+boxes.xi1(3)/2, 0.62], ...
    [boxes.xi1(2), boxes.eta(2)+0.02], arrow_props{:}, 'Color',C_GREEN);
text(0.43, 0.71, '\beta = +0.499***', 'FontSize',9.5, ...
    'Color',C_GREEN,'FontWeight','bold','Units','normalized');

% H2: xi2 -> eta  (negative)
annotation('arrow',[boxes.xi2(1)+boxes.xi2(3)/2, 0.61], ...
    [boxes.xi2(2), boxes.eta(2)], arrow_props{:}, 'Color',C_RED);
text(0.43, 0.49, '\beta = -0.316**', 'FontSize',9.5, ...
    'Color',C_RED,'FontWeight','bold','Units','normalized');

% H3: xi3 -> eta  (positive)
annotation('arrow',[boxes.xi3(1)+boxes.xi3(3)/2, 0.62], ...
    [boxes.xi3(2), boxes.eta(2)-0.02], arrow_props{:}, 'Color',C_GREEN);
text(0.43, 0.29, '\beta = +0.355***', 'FontSize',9.5, ...
    'Color',C_GREEN,'FontWeight','bold','Units','normalized');

% R2 label inside eta box area
text(0.72, 0.38, 'R^2 = 0.487', 'FontSize',9,'Units','normalized', ...
    'HorizontalAlignment','center','Color',[0.3 0.3 0.3]);

% Hypothesis labels
text(0.08, 0.75, 'H1', 'FontSize',9,'FontWeight','bold','Units','normalized');
text(0.08, 0.50, 'H2', 'FontSize',9,'FontWeight','bold','Units','normalized');
text(0.08, 0.25, 'H3', 'FontSize',9,'FontWeight','bold','Units','normalized');

%title('Fig.~9 — PLS-SEM structural path diagram: hypotheses H1–H3', 'FontSize',FONT_SZ+1,'FontWeight','bold');
annotation('textbox',[0.01 0.01 0.5 0.06],'String', ...
    '*** p < 0.001  ** p < 0.01   (bootstrapping 5,000 subsamples)', ...
    'FontSize',8,'EdgeColor','none','Color',[0.4 0.4 0.4]);

save_fig(fig9, 'plssem_path_diagram', outDir);

% =========================================================================
% FIGURE 10 — PLS-SEM Measurement Model Summary (bar chart of loadings)
% =========================================================================
indicator_names = {'\xi_1 — Lighting adequacy', ...
                   '\xi_1 — Electrical reliability', ...
                   '\xi_1 — Refrigeration access', ...
                   '\xi_2 — Dock congestion (rev.)', ...
                   '\xi_2 — Wait-time category', ...
                   '\xi_3 — Digital tool level', ...
                   '\xi_3 — Training interest', ...
                   '\eta — Sales trend', ...
                   '\eta — Income diversification', ...
                   '\eta — Credit access'};
loadings = [0.783, 0.812, 0.634, 0.801, 0.708, 0.836, 0.738, 0.792, 0.741, 0.616];
load_colors = [repmat(C_BLUE,3,1); repmat(C_RED,2,1); ...
               repmat(C_GREEN,2,1); repmat(C_PURPLE,3,1)];

fig10 = figure('Color','white','Position',[100 100 750 480]);
bh10 = barh(loadings,'FaceColor','flat','EdgeColor','none');
bh10.CData = load_colors;
set(gca,'YTickLabel', indicator_names, 'FontSize', 9, 'Box','off');
xlabel('Outer Loading (\lambda)','FontSize',FONT_SZ+1);
%title('Fig.~10 — PLS-SEM outer loadings for all reflective indicators', 'FontSize',FONT_SZ+1,'FontWeight','bold');
xline(0.70, 'k--','LineWidth',1.2,'Label','Threshold \lambda = 0.70');
xlim([0.50 0.90]); grid on;
legend({'\xi_1 Infrastructure Stability','\xi_2 Logistics Friction', ...
    '\xi_3 Digital Adoption','\eta Commercial Resilience'}, ...
    'Location','southeast','FontSize',8);
save_fig(fig10, 'plssem_loadings', outDir);

% =========================================================================
% FINAL CONSOLE SUMMARY
% =========================================================================
fprintf('\n=== ALL FIGURES GENERATED ===\n');
fprintf('Output folder: %s\n', fullfile(pwd, outDir));
fprintf('Files: vendor_activity, vendor_permits, vendor_dock, vendor_digital,\n');
fprintf('       vendor_sales, vendor_pain, montecarlomercado, sensitivity_analysis,\n');
fprintf('       plssem_path_diagram, plssem_loadings  (PNG + PDF each)\n\n');
fprintf('Monte Carlo key results (seed = 2026, N = %d):\n', N_iterations);
fprintf('  mu = %.2f min | sigma = %.2f min | P(T>60) = %.2f%%\n', ...
    mean_time, std_time, critical_delay_pct);
fprintf('  Median = %.2f min | 90th percentile = %.2f min\n\n', ...
    median_time, percentile_90);
