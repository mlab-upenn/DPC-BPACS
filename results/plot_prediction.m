
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Requires GPML toolbox
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% specify after how many samples we need to slice
n_samples = 96*[21];
model_target = 'TotalLoad';
kernel = 'sqexp';
n_plot_days = 1;
pidx = 1:n_plot_days*96;

% training data file
load(['gp_sqexp_' model_target '.mat']);

% normalize training data (not all fields)
normalized_fields = {'Ambient', 'Humidity', 'TotalLoad', ...
    'ClgSP', 'LgtSP', 'SupplyAirSP', 'ChwSP',...
    'TempBasement', 'TempCoreBottom', 'TempCoreMid', 'TempCoreTop'};
% test data file
testfname = 'baseline.mat';
data_test = load(testfname);

% normalize test data (same as for training)
data_test_norm = normalize_data(data_test, normalized_fields, normparams);

y_train_min =  normparams.(model_target).min;
y_train_max = normparams.(model_target).max;
model_inputs = training_result.model_inputs;
stepsahead = training_result.stepsahead;
model_excepts = training_result.model_excepts;

[X_test_norm, y_test_norm] = construct_data(data_test_norm, model_inputs, model_target, stepsahead, model_excepts);
[X_test, y_test] = construct_data(data_test, model_inputs, model_target, stepsahead, model_excepts);

model = training_result.model;
hyp = training_result.hyp;

% prediction on test data
[mu_test, var_test, muf_test, varf_test] = gp(hyp, ...
    model.inference_method, model.mean_function, ...
    model.covariance_function, model.likelihood, ...
    X_train_norm, y_train_norm, X_test_norm);
y_mean_test = postNorm(mu_test, y_train_min, y_train_max);
y_var_test = postNormVar(var_test, y_train_min, y_train_max);

% loss metrics
validation_result = struct();
[validation_result.ae, validation_result.se, validation_result.lpd, ...
        validation_result.mrse, validation_result.smse, validation_result.msll] = loss(y_test(pidx), y_mean_test(pidx), y_var_test(pidx));
    validation_result.rmse = sqrt(validation_result.se);
    
figure;
t = (0:size(y_mean_test(pidx),1)-1)';
sys = y_test(pidx)/1e3;
y = y_mean_test(pidx)/1e3;
std = sqrt(y_var_test(pidx))/1e3;

ix_plot = 1:length(t);
xfill = [t(ix_plot); flipdim(t(ix_plot),1)]; 
yfill = [y(ix_plot)+2*std(ix_plot);flipdim(y(ix_plot)-2*std(ix_plot),1)]; 

lw = 1;

h1 = subplot(3,1,1:2); hold on; grid on;
fill(xfill, yfill, [249, 229, 255]/255, 'EdgeColor', [249, 229, 255]/255);
h = plot(t,sys, '-', 'LineWidth', lw);
plot(t,y, '--k', 'LineWidth', lw); 
ax = gca;
ax.XTick = [16, 32, 48, 64, 80];
ax.XTickLabel = {}';
xlim([0 t(end)]);
ylim([0 1500]);
ylabel('power [kW]'); 
hold off;
hleg = legend('\mu \pm 2\sigma_y', 'system', '\mu', 'Location','South', 'Orientation', 'Horizontal'); 
set(hleg, 'box', 'off');
box on;
 
h2 = subplot(3,1,3); hold on; grid on;
xfill = [t(ix_plot); flipdim(t(ix_plot),1)]; 
yfill = [2*std(ix_plot);zeros(size(std(ix_plot)))]; 
fill(xfill, yfill, [249, 229, 255]/255, 'EdgeColor', [249, 229, 255]/255);
plot(t,abs(y-sys), '-', 'LineWidth', lw);
ax = gca;
ax.YTick = [0, 100, 200];
ax.XTick = [16, 32, 48, 64, 80];
ax.XTickLabel = {'4am','8am','12pm','4pm', '8pm'}';
xlim([0 t(end)]);
ylabel('error [kW]'); 
% xlabel('time');
box on;

cleanfigure();
matlab2tikz('width', '\fwidth', 'height', '\hwidth', ['../paper/figures/prediction_' model_target '.tex'],...
    'extraaxisoptions',['xlabel style={font=\footnotesize},'...
                       'ylabel style={font=\footnotesize},',...
                       'legend style={font=\footnotesize},',...
                       'ticklabel style={font=\footnotesize},'...
                       'title style={font=\normalsize},'...
                       'title style={yshift=2ex},'...                       
                       'ylabel shift = -5 pt,'...
                       'xlabel shift = -5 pt,']);