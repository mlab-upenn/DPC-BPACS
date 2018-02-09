%Only include certain data until 4pm of the first day
% DR Event
%time_range = 1:157;
%conf_range = 1:157;
% Power Tracking
time_range = 1:66;
conf_range = 1:69;


idx = isnan(prediction.('ymu'));
lconf = prediction.('ymu') - 2 * sqrt(prediction.('ysigma2'));
lconf(idx) = results.(vars.reference{1})(idx);
lconf = lconf / 1000000;
uconf = prediction.('ymu') + 2 * sqrt(prediction.('ysigma2'));
uconf(idx) = results.(vars.reference{1})(idx);
uconf = uconf/1000000;

base = baseline.(vars.reference{1});
base = base/1000000;
actual = results.(vars.reference{1});
actual = actual/1000000;


sa = results.('SupplyAirSP');
cw = results.('ChwSP');
clg = results.('ClgSP');
tempmid = results.('TempCoreMid');
uppertemp = repmat(25, 1, length(tempmid) + 50);
lowertemp = repmat(23, 1, length(tempmid) + 50);


dlmwrite('tempmid', tempmid(time_range), 'precision', 4)
dlmwrite('uppertemp', uppertemp, 'precision', 4)
dlmwrite('lowertemp', lowertemp, 'precision', 4)
dlmwrite('baseline', base, 'precision', 8)
dlmwrite('actual', actual(time_range), 'precision', 8)
dlmwrite('sa', sa(time_range), 'precision', 4)
dlmwrite('cw', cw(time_range), 'precision', 4)
dlmwrite('clg', clg(time_range), 'precision', 4)
dlmwrite('lconf', lconf(conf_range), 'precision', 8)
dlmwrite('uconf', uconf(conf_range), 'precision', 8)
