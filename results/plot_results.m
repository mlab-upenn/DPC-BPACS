
kernel = 'sqexp';
ctrl_hzn = 4;
sim_days = 2;

% load(fullfile(['dr_' kernel '_horizon' num2str(ctrl_hzn) '_simdays' num2str(sim_days)]));
load(fullfile(['power_track_' kernel '_horizon' num2str(ctrl_hzn) '_simdays' num2str(sim_days)]));
% load(fullfile(['temp_track_' kernel '_horizon' num2str(ctrl_hzn) '_simdays' num2str(sim_days)]));

%% plot data

for idn = 1:numel(vars.control)
    figure; hold on; grid on;
    plot(results.(vars.control{idn}), 'LineWidth', 2);
    ylabel(vars.control{idn})
    xlabel('time')
end

figure; hold on; grid on;
h1 = plot(results.(vars.reference{1}), 'LineWidth', 2);
h2 = plot(baseline.(vars.reference{1}), '--', 'LineWidth', 2);
h3 = plot(prediction.('ymu'), '-', 'LineWidth', 2);
legend([h1, h2, h3], 'closed-loop', 'reference', 'prediction');
xlabel('time')

figure; hold on; grid on;
h1 = plot(results.('TempCoreMid'), 'LineWidth', 2);
h2 = plot(baseline.('TempCoreMid'), '--', 'LineWidth', 2);
ylabel('TempCoreMid')
legend([h1, h2], 'closed-loop', 'reference');
xlabel('time')
