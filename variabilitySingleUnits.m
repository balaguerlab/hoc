function results=variabilitySingleUnits(DataSet,bin_size,laboratories,trials_lim,name,doPlotLines,initial_to_plot,n_bins_x_trial)
%
%Inputs:
%     -DataMatrix = num. trials x (num. units+3) containing the iFR per unit
%       simultaneously recorded+ the LFP+a column which contains all responses in the trial (categories 1-8 see dataset descrption)
%       + a column with '1' indicating the offset of the second tone + a column grouping some of these categories (see below) and a final columns containing groups of trials constituting
%       super-trial (say 200 trials for instance)
%     -bin_size (1 x 1)= In millisec.
%      -laboratories=physical cores
%     -trials_lim (2 x 1)= First and last trial to be analysed in the
%          second and further plots (not influence in the first plot)
%      -name, do_plotLines=See code below
%     -initial_to_plot (1 x 1)=Handle for displaying in a specific
%     position. See code
%     -n_bins_x_trial=See code
%
%Outputs:
%    Smoothed activity coloured per task and animal in groups of trials. Global statistics of smoothed activity in quantiles
%     Polar plots of activity where LFP is divided in 360 degrees. Fano
%     factor per task, same displays)
% 
%by Emili Balaguer-Ballester. Comput neuro lab. Interdisiciplinary Neurosci Research Centre.
%Faculty of Science and Technology, Bournemouth University
%April 2020
%Notes: Uncomment "plotAllLines" statements below to plot the lines
%indicating the behavioral relevant periods of the trial

%addpath('shadedErrorBar');
disp('Trial-to-trial variability basic analysis interval-discrimination task')
disp('By  Emili Balaguer-Ballester 2015 (2020). Faculty of Science and Technology, Bournemouth University / BBCN  Heidleberg/Mannheim')
disp('*************************************')
disp(' '),
if ((nargin<2)||(bin_size<=0)),
    bin_size=60;
end
if ((nargin<3)||(laboratories<=0))
    laboratories=4;%physical cores
end
disp(['Bin size ',num2str(bin_size)]);
%n_block_trials=max(DataSet(:,end)); %Blocks of "n" real trials, depending on the dataset
if ((nargin<4)||(length(trials_lim)<2))
    trials_lim=[min(DataSet(:,end-1)),max(DataSet(:,end-1))];
end
disp(['Trials spanned ',num2str(trials_lim(1)),'-',num2str(trials_lim(2))]);
%n_trials=min(max(DataSet(:,end-1)),trials_lim(2)); %number of real trials
if ((nargin<7)||(initial_to_plot<=0))
    initial_to_plot=1;
end
disp(['First trial to be plotted ',num2str(initial_to_plot)]);
unitsActivity=DataSet(:,1:end-5);
n_units=length(unitsActivity(1,:));
kmax=floor(n_units/3);

%1. Rates, fano and varCE using x ms binned data. All behaviors grouped
%Lines are averages across trials. 
figure
ntrials=trials_lim(end);
all_tone1_1=zeros(1,ntrials);all_tone2_1=zeros(1,ntrials);
all_tone1_2=zeros(1,ntrials);all_tone2_2=zeros(1,ntrials);
all_movement=zeros(1,ntrials);
all_bins_x_trial=zeros(1,ntrials);
for tr=1:ntrials
    linesPositTrial1=DataSet(DataSet(:,end-1)==tr,end-3);
    if nargin<8
        n_bins_x_trial=length(linesPositTrial1);
    end
    
    %Computing position of the offsets of tones
    tone1_1=0;tone2_1=0;tone1_2=0;tone2_2=0;movement=0;
    for j=1:length(linesPositTrial1)
        if (linesPositTrial1(j)==1) && (tone1_1<1)
            tone1_1=j;
        elseif (linesPositTrial1(j)==1)&& (tone1_1>0)&& (tone1_2<1)
            tone1_2=j;
        elseif (linesPositTrial1(j)==2) && (tone2_1<1)
            tone2_1=j;
        elseif (linesPositTrial1(j)==2)&& (tone2_1>0)&& (tone2_2<1)
            tone2_2=j;
        elseif (linesPositTrial1(j)==3)&& (tone2_1>0)&& (tone2_2>0)
            movement=j;
        end
    end
    
    if tone1_2==0
        %disp('No tone 1 offset'),
        tone1_2=tone1_1;
    end
    if tone2_2==0
        %disp('No tone 2 offset'),
        tone2_2=tone2_1;
    end
    if movement==0
        %disp('no latency'),
        movement=tone2_2+1;
    end
    
    all_tone1_1(tr)=tone1_1;all_tone1_2(tr)=tone1_2;
    all_tone2_1(tr)=tone2_1;all_tone2_2(tr)=tone2_2;
    all_movement(tr)=movement;
    all_bins_x_trial(tr)=n_bins_x_trial;
end
%for the 50-200 ms ISI and for 300-500 ms.

tone1_1=round(mean(all_tone1_1));
tone1_2=round(mean(all_tone1_2));
shorts2_1=all_tone2_1(all_tone2_1<round(mean(all_tone2_1)));
shorts2_2=all_tone2_2(all_tone2_2<round(mean(all_tone2_2)));
tone2_1=round(mean(shorts2_1));
tone2_2=round(mean(shorts2_2));

long_tone1_1=tone1_1;
long_tone1_2=tone1_2;
longs2_1=all_tone2_1(all_tone2_1>round(mean(all_tone2_1)));
longs2_2=all_tone2_2(all_tone2_2>round(mean(all_tone2_2)));
long_tone2_1=round(mean(longs2_1));
long_tone2_2=round(mean(longs2_2));

movement=round(mean(all_movement));


% tone1_1=round(mean(all_tone1_1));
% tone1_2=round(mean(all_tone1_2));
% tone2_1=round(mean(all_tone2_1));
% tone2_2=round(mean(all_tone2_2));
%
% long_tone1_1=round(std(all_tone1_1));
% long_tone1_2=round(std(all_tone1_2));
% long_tone2_1=round(std(all_tone2_1));
% long_tone2_2=round(std(all_tone2_2));

% tone1_1=round(all_tone1_1(1));
% tone1_2=round(all_tone1_2(1));
% tone2_1=round(all_tone2_1(1));
% tone2_2=round(all_tone2_2(1));


%There is no much point in plotting way beyond the offset of the second
%tone. We set a number of bins per trial for comparison, one possibility
%is that the first trial is the guide, another is that is just the mean.
%Anyway it does not make difference because the
%second tone offset and the animal movement always occur very early in the
%trial, and the rest of the trial is not relevant for this study.

n_bins_x_trial=round(mean(all_bins_x_trial));
times=(0:bin_size:(n_bins_x_trial-1)*bin_size);
rates_mean=zeros(n_bins_x_trial,n_units);rates_std=zeros(n_bins_x_trial,n_units);
fano=zeros(n_bins_x_trial,n_units); varCE=zeros(n_bins_x_trial,n_units);
for unit=1:n_units
    %One computation per unit
    aggr_data_trial=zeros(n_bins_x_trial,trials_lim(2)-trials_lim(1)+1);
    for current_bin=1:n_bins_x_trial
        %Select the jth bin of each trial
        parfor trial=trials_lim(1):trials_lim(2)
            data_trial=DataSet(DataSet(:,end-1)==trial,1:end-5);%Select spikes
            if current_bin<=length(data_trial(:,unit))
                aggr_data_trial(current_bin,trial)=data_trial(current_bin,unit);
            end
        end
    end
    rates_mean(:,unit)=mean(aggr_data_trial');
    rates_std(:,unit)=var(aggr_data_trial');
    fano(:,unit)=var(aggr_data_trial')./mean(aggr_data_trial');
    varCE(:,unit)=var(aggr_data_trial')-mean(aggr_data_trial');
    
    subplot(221)
    values=rates_mean(:,unit);
    plot(times,values,'Color',[0.8 0.8 0.8]),
    xlabel('Time (ms)'), ylabel('ifr(spikes^-1)'),
    %xlim([times(1),times(end)]);
    hold on
    %Plotting lines and mean values. Uncomment "plotAllLines" statements below to plot them.
    if doPlotLines>0
        %plotAllLines(tone1_1,long_tone1_1,tone1_2,long_tone1_2,tone2_1,long_tone2_1,tone2_2,long_tone2_2,values,times,movement)
    end
    subplot(222)
    values=rates_std(:,unit);
    plot(times,values,'Color',[0.8 0.8 0.8]), xlabel('Time (ms)'), ylabel('ifr(spikes^-1)'),
    %xlim([times(1),times(end)]);
    hold on
    if doPlotLines>0
        %plotAllLines(tone1_1,long_tone1_1,tone1_2,long_tone1_2,tone2_1,long_tone2_1,tone2_2,long_tone2_2,values,times,movement)
    end
    subplot(223)
    values=fano(:,unit);
    plot(times,values,'Color',[0.8 0.8 0.8]), xlabel('Time (ms)'), ylabel('fano factor'),
    %xlim([times(1),times(end)]);
    %ylim=([max(values),min(values)]);
    hold on
    if doPlotLines>0
        %plotAllLines(tone1_1,long_tone1_1,tone1_2,long_tone1_2,tone2_1,long_tone2_1,tone2_2,long_tone2_2,values,times,movement)
    end
    
    subplot(224)
    values=varCE(:,unit);
    plot(times,values,'Color',[0.8 0.8 0.8]), xlabel('Time (ms)'), ylabel('varCE'),
    %xlim([times(1),times(end)]);
    %ylim=([max(values),min(values)]);
    hold on
    if doPlotLines>0
        %plotAllLines(tone1_1,long_tone1_1,tone1_2,long_tone1_2,tone2_1,long_tone2_1,tone2_2,long_tone2_2,values,times,movement)
    end
end
set(gcf,'Name',name)

%Summarized figure with all means
figure
subplot(221)
values=mean(rates_mean,2);
devs=std(rates_mean,0,2)/sqrt(n_units);
if (length(times)==length(values))&&(length(times)==length(devs))&&((length(times)+length(values)+length(devs))>0)
shadedErrorBar(times,values,devs,...
    {'Color',[0 0 0.7],'Linewidth',2})
end
if doPlotLines>0
    %plotAllLines(tone1_1,long_tone1_1,tone1_2,long_tone1_2,tone2_1,long_tone2_1,tone2_2,long_tone2_2,values,times,movement)
end
%xlim([times(1),times(end)]);
ylim([min(values-devs),max(values+devs)]);
xlabel('Time (ms)'), ylabel('ifr(spikes^-1)'),
subplot(222)
values=mean(rates_std,2);
devs=std(rates_std,0,2)/sqrt(n_units);
if (length(times)==length(values))&&(length(times)==length(devs))&&((length(times)+length(values)+length(devs))>0)
shadedErrorBar(times,values,devs,...
    {'Color',[0 0 0.7],'Linewidth',2})
end
if doPlotLines>0
    %plotAllLines(tone1_1,long_tone1_1,tone1_2,long_tone1_2,tone2_1,long_tone2_1,tone2_2,long_tone2_2,values,times,movement)
end
%xlim([times(1),times(end)]);
ylim([min(values-devs),max(values+devs)]);
xlabel('Time (ms)'), ylabel('ifr(spikes^-1)'),
subplot(223)
values=nanmean(fano,2);
devs=nanstd(fano,0,2)/sqrt(n_units);
if (length(times)==length(values))&&(length(times)==length(devs))&&((length(times)+length(values)+length(devs))>0)
shadedErrorBar(times,values,devs,...
    {'Color',[0 0 0.7],'Linewidth',2})
end
if doPlotLines>0
    %plotAllLines(tone1_1,long_tone1_1,tone1_2,long_tone1_2,tone2_1,long_tone2_1,tone2_2,long_tone2_2,values,times,movement)
end
%xlim([times(1),times(end)]);
ylim([min(values-devs),max(values+devs)]);
xlabel('Time (ms)'), ylabel('fano factor'),
subplot(224)
values=mean(varCE,2);
devs=std(varCE,0,2)/sqrt(n_units);
if (length(times)==length(values))&&(length(times)==length(devs))&&((length(times)+length(values)+length(devs))>0)
shadedErrorBar(times,values,devs,...
    {'Color',[0 0 0.7],'Linewidth',2})
end
if doPlotLines>0
    %plotAllLines(tone1_1,long_tone1_1,tone1_2,long_tone1_2,tone2_1,long_tone2_1,tone2_2,long_tone2_2,values,times,movement)
end
%xlim([times(1),times(end)]);
ylim([min(values-devs),max(values+devs)]);
xlabel('Time (ms)'), ylabel('varCE'),

set(gcf,'Name',name)

results.rates_mean=rates_mean;
results.rates_std=rates_std;
results.fano=fano;
results.varCE=varCE;
results.tones_positions=[tone1_1,long_tone1_1,tone1_2,long_tone1_2,tone2_1,long_tone2_1,tone2_2,long_tone2_2,movement];

end