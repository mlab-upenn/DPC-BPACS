%Only include certain data until 4pm of the first day
time_range = 1:150;

idx = isnan(prediction.('ymu'));
lconf = prediction.('ymu') - 2 * sqrt(prediction.('ysigma2'));
lconf(idx) = results.(vars.reference{1})(idx);
uconf = prediction.('ymu') + 2 * sqrt(prediction.('ysigma2'));
uconf(idx) = results.(vars.reference{1})(idx);

base = baseline.(vars.reference{1});
actual = results.(vars.reference{1});


sa = results.('SupplyAirSP');
cw = results.('ChwSP');
clg = results.('ClgSP');
tempmid = results.('TempCoreMid');


dlmwrite('tempmid', tempmid(time_range), 'precision', 4)
dlmwrite('baseline', base, 'precision', 8)
dlmwrite('actual', actual(time_range), 'precision', 8)
dlmwrite('sa', sa(time_range), 'precision', 4)
dlmwrite('cw', cw(time_range), 'precision', 4)
dlmwrite('clg', clg(time_range), 'precision', 4)
dlmwrite('lconf', lconf(time_range), 'precision', 8)
dlmwrite('uconf', uconf(time_range), 'precision', 8)
