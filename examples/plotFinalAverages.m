
function plotFinalAverages(bin_size,min_bins,rates_acum,stdev_acum,fano_acum,varCE_acum,noisecorrel_acum,tones_pos,trials_type,selection,ordercorr,plotLines,filetype,transformation,color_rgb_vector)
%Plot final averages of variance and noise correlations of a specific order
%April 2020

if nargin<15, color_rgb_vector=[0 0 0.7]; end

times=(0:bin_size:(min_bins-1)*bin_size)*1000;
blocks_ra=[];blocks_stdev=[];blocks_fano=[];blocks_varCE=[];blocks_noisecorrel=[];
[filesnum,positions]=size(tones_pos);
if filesnum>1
    mt=round(mean(tones_pos));
else
    mt=round(tones_pos);
end
for i=1:length(rates_acum),
    ra=rates_acum{i};
    blocks_ra=[blocks_ra,ra(1:min_bins,:)];%Acumulating units
    stdev=stdev_acum{i};
    blocks_stdev=[blocks_stdev,stdev(1:min_bins,:)];%Acumulating units
    fano=fano_acum{i};
    blocks_fano=[blocks_fano,fano(1:min_bins,:)];%Acumulating units
    varCE=varCE_acum{i};
    blocks_varCE=[blocks_varCE,varCE(1:min_bins,:)];%Acumulating units
    noisecorrel=noisecorrel_acum{i};
    blocks_noisecorrel=[blocks_noisecorrel,noisecorrel(1:min_bins,:)];%Acumulating units
end
if strcmp(trials_type,'incorrect')
    incorrect_blocks_ra=blocks_ra;
    incorrect_blocks_stdev=blocks_stdev;
    incorrect_blocks_fano=blocks_fano;
    incorrect_blocks_varCE=blocks_varCE;
    incorrect_blocks_noisecorrel=blocks_noisecorrel;
    save([transformation,'_BasicAnalyses_',trials_type,'_',selection,'_files','_order corr_',ordercorr,filetype],'incorrect_blocks_ra','incorrect_blocks_stdev','incorrect_blocks_fano','incorrect_blocks_varCE','incorrect_blocks_noisecorrel','mt');
elseif strcmp(trials_type,'correct')
    correct_blocks_ra=blocks_ra;
    correct_blocks_stdev=blocks_stdev;
    correct_blocks_fano=blocks_fano;
    correct_blocks_varCE=blocks_varCE;
    correct_blocks_noisecorrel=blocks_noisecorrel;
    save([transformation,'_BasicAnalyses_',trials_type,'_',selection,'_files','_order corr_',ordercorr,filetype],'correct_blocks_ra','correct_blocks_stdev','correct_blocks_fano','correct_blocks_varCE','correct_blocks_noisecorrel','mt');
else
    save([transformation,'_BasicAnalyses_',trials_type,'_',selection,'_files','_order corr_',ordercorr,filetype],'blocks_ra','blocks_stdev','blocks_fano','blocks_varCE','blocks_noisecorrel');
end

%Plots
figure

n_units=length(blocks_ra(1,:));
subplot(231)
values=nanmean(blocks_ra,2);
devs=nanstd(blocks_ra,0,2)/sqrt(n_units);
shadedErrorBar(times,values,devs,...
    {'Color',color_rgb_vector,'Linewidth',2})
if plotLines>0
    plotAllLines(mt(1),mt(2),mt(3),mt(4),mt(5),mt(6),mt(7),mt(8),values,times,mt(9))
end
xlim([times(1),times(end)]);
ylim([min(values-devs),max(values+devs)]);
xlabel('Time (ms)'), ylabel('ifr(spikes^-1)'),
subplot(232)
values=nanmean(blocks_stdev,2);
devs=nanstd(blocks_stdev,0,2)/sqrt(n_units);
shadedErrorBar(times,values,devs,...
    {'Color',color_rgb_vector,'Linewidth',2})
if plotLines>0
    plotAllLines(mt(1),mt(2),mt(3),mt(4),mt(5),mt(6),mt(7),mt(8),values,times,mt(9))
end
xlim([times(1),times(end)]);
ylim([min(values-devs),max(values+devs)]);
xlabel('Time (ms)'), ylabel('ifr(spikes^-1)'),
subplot(233)
values=nanmean(blocks_fano,2);
devs=nanstd(blocks_fano,0,2)/sqrt(n_units);
shadedErrorBar(times,values,devs,...
    {'Color',color_rgb_vector,'Linewidth',2})
if plotLines>0
    plotAllLines(mt(1),mt(2),mt(3),mt(4),mt(5),mt(6),mt(7),mt(8),values,times,mt(9))
end
xlim([times(1),times(end)]);
ylim([min(values-devs),max(values+devs)]);
xlabel('Time (ms)'), ylabel('fano factor'),
subplot(234)
values=nanmean(blocks_varCE,2);
devs=nanstd(blocks_varCE,0,2)/sqrt(n_units);
shadedErrorBar(times,values,devs,...
    {'Color',color_rgb_vector,'Linewidth',2})
if plotLines>0
    plotAllLines(mt(1),mt(2),mt(3),mt(4),mt(5),mt(6),mt(7),mt(8),values,times,mt(9))
end
xlim([times(1),times(end)]);
ylim([min(values-devs),max(values+devs)]);
xlabel('Time (ms)'), ylabel('varCE'),
subplot(235)
n_pairs=length(noisecorrel(1,:));
values=nanmean(abs(blocks_noisecorrel),2);
devs=nanstd(abs(blocks_noisecorrel),0,2)/sqrt(n_pairs);
shadedErrorBar(times,values,devs,...
    {'Color',color_rgb_vector,'Linewidth',2})
if plotLines>0
    plotAllLines(mt(1),mt(2),mt(3),mt(4),mt(5),mt(6),mt(7),mt(8),values,times,mt(9))
end
xlim([times(1),times(end)]);
ylim([min(values-devs),max(values+devs)]);
xlabel('Time (ms)'), ylabel(['Correl order ',ordercorr]),title('abs values'),
subplot(236)
n_pairs=length(noisecorrel(1,:));
values=nanmean((blocks_noisecorrel),2);
devs=nanstd((blocks_noisecorrel),0,2)/sqrt(n_pairs);
shadedErrorBar(times,values,devs,...
    {'Color',color_rgb_vector,'Linewidth',2})
if plotLines>0
    plotAllLines(mt(1),mt(2),mt(3),mt(4),mt(5),mt(6),mt(7),mt(8),values,times,mt(9))
end
xlim([times(1),times(end)]);
ylim([min(values-devs),max(values+devs)]);
xlabel('Time (ms)'), ylabel(['Correl order ',ordercorr]),title('real values'),


set(gcf,'name',[transformation,'_BasicAnalyses_',trials_type,'_',selection,'_files',filetype]),
end