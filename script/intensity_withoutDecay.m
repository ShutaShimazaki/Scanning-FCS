%% Correct for deplation due to photobleaching
%   Eq.4  
%   doi: 10.1016/j.bpj.2008.12.3888
%% 各列(位置)に対してloop
XT_corrected  
for i = 1:PIXEL
 
end

%% 蛍光強度の減衰を表す多重指数関数:multiexp の生成
i =3;
intensity_x = XT(:,i); %列iの蛍光強度F(x=i ,t)
dataframe_bleaching = table([1:TIME_SERIES]',intensity_x);

beta0_bleaching = [20, 10,10^-5, 10^-2];
modelfun_bleaching = @(b, t) b(1).*exp(-b(3).*t) + b(2).*exp(-b(4).*t); % 2重指数関数  A*exp(-t) + B*exp(-t)
mdl_bleaching = fitnlm(dataframe_bleaching, modelfun_bleaching, beta0_bleaching)
parms_bleaching = (mdl_bleaching.Coefficients.Estimate)'
decay_multiexp = (modelfun_bleaching(parms_bleaching,[1:TIME_SERIES]))';

figure;
plot(1:TIME_SERIES, intensity_x)
hold on;
plot(1:TIME_SERIES, decay_multiexp)
hold off;

% legend("もとの蛍光強度", "指数関数：　" + func2str(modelfun_bleaching));
% xlabel("スキャン回数", 'FontSize',14,'FontWeight','bold');
% ylabel("蛍光強度", 'FontSize',14,'FontWeight','bold');
% title("補正した蛍光強度");
%% 蛍光強度を補正
% Eq.4
intensity_corrected = intensity_x ./ sqrt(decay_multiexp ./ decay_multiexp(1)) +  decay_multiexp(1).*(1-sqrt(decay_multiexp./decay_multiexp(1)));
figure;
plot(1:TIME_SERIES, intensity_corrected);
% xlabel("時間", 'FontSize',14,'FontWeight','bold');
% ylabel("蛍光強度", 'FontSize',14,'FontWeight','bold');
% title("補正した蛍光強度");