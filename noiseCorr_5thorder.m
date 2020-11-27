function results=noiseCorr_5thorder(rates_mean,DataSet,bin_size,laboratories,trials_lim,name,doPlotLines,initial_to_plot,n_bins_x_trial)
%Inputs:
%      -rates_mean = see batch file and code below
%     -DataSet= ntrials x (nvariables+3) containing iFR per unit
%       simultaneously recorded+ the LFP+a column which contains all responses in the trial (categories 1-8 see dataset description)
%       + a column with '1' indicating the offset of the second tone + a column grouping some of these categories (see below) and a final columns containing groups of trials constituting
%       super-trial (say 200 trials for instance)
%      -bin_size (1 x 1)= In millisec.
%     -trials_lim (2 x 1)= First and last trial to be analysed in the
%          second and further plots (not influence in the first plot)
%      -name, do_plotLines=See code below
%     -initial_to_plot (1 x 1)=Handle for displaying in a specific
%     position. See code
%     -n_bins_x_trial=See code
%
%Outputs:
%    5th order noise correlation. See code. Needs large ensembles.
%
%by Emili Balaguer-Ballester. Comput neuro lab. Interdisiciplinary Neurosci Research Centre.
%Faculty of Science and Technology, Bournemouth University
%April 2020
%

addpath('shadedErrorBar');
disp('Noise corr. quintuplets interval-discrimination task')
disp('By  Emili Balaguer-Ballester 2018 (2020). Faculty of Science and Technology, Bournemouth University / BBCN  Heidleberg/Mannheim')
disp('*************************************')
disp(' '),
if ((nargin<3)||(bin_size<=0))
    bin_size=60;
end
if ((nargin<4)||(laboratories<=0))
    laboratories=4;
end
disp(['Bin size ',num2str(bin_size)]);
%n_block_trials=max(DataSet(:,end)); %Blocks of "n" real trials, depending on the dataset
if ((nargin<5)||(length(trials_lim)<2))
    trials_lim=[min(DataSet(:,end-1)),max(DataSet(:,end-1))];
end
disp(['Trials spanned ',num2str(trials_lim(1)),'-',num2str(trials_lim(2))]);
%n_trials=min(max(DataSet(:,end-1)),trials_lim(2)); %number of real trials of the
if ((nargin<8)||(initial_to_plot<=0))
    initial_to_plot=1;
end
disp(['First trial to be plotted ',num2str(initial_to_plot)]);
unitsActivity=DataSet(:,1:end-5);
n_units=length(unitsActivity(1,:));
kmax=floor(n_units/3);

% x ms binned data. All behaviors grouped
%Lines are averages across trials
figure
ntrials=trials_lim(end);
all_tone1_1=zeros(1,ntrials);all_tone2_1=zeros(1,ntrials);
all_tone1_2=zeros(1,ntrials);all_tone2_2=zeros(1,ntrials);
all_movement=zeros(1,ntrials);
all_bins_x_trial=zeros(1,ntrials);

for tr=1:ntrials
    linesPositTrial1=DataSet(DataSet(:,end-1)==tr,end-3);
    if nargin<9
        n_bins_x_trial=length(linesPositTrial1);
    end
    
    %computing position of the offsets of tones
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
        %disp('No tone 1 offset'),
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
%
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


n_bins_x_trial=round(mean(all_bins_x_trial));
%n_bins_x_trial=round(all_bins_x_trial(1));

times=(0:bin_size:(n_bins_x_trial-1)*bin_size);
% rates_mean=zeros(n_bins_x_trial,n_units);rates_std=zeros(n_bins_x_trial,n_units);


%order_2_corr=zeros(n_bins_x_trial,1); %Only pearson for now. That is for a pair of units
%total_corr=zeros(n_bins_x_trial,(n_units^2)-n_units);%These are the number of different corr coeffs. One per bin.
%Is an unnefective implementation but is clear how to do triplets instead, if needed.


t=0; %Counter of distict correlations

for unit1=1:n_units
    
    for unit2=unit1:n_units
        
        for unit3=unit2:n_units
            
            for unit4=unit3:n_units
                
                for unit5=unit4:n_units
                    
                    aggr_data_trial1=zeros(n_bins_x_trial,trials_lim(2)-trials_lim(1)+1);
                    aggr_data_trial2=zeros(n_bins_x_trial,trials_lim(2)-trials_lim(1)+1);
                    aggr_data_trial3=zeros(n_bins_x_trial,trials_lim(2)-trials_lim(1)+1);
                    aggr_data_trial4=zeros(n_bins_x_trial,trials_lim(2)-trials_lim(1)+1);
                    aggr_data_trial5=zeros(n_bins_x_trial,trials_lim(2)-trials_lim(1)+1);
                    
                    if ~((unit1==unit2)&&(unit2==unit3)&&(unit3==unit4)&&(unit4==unit5))
                        t=t+1;
                        for current_bin=1:n_bins_x_trial
                            
                            %Select the jth bin of each trial
                            parfor trial=trials_lim(1):trials_lim(2),
                                data_trial=DataSet(DataSet(:,end-1)==trial,1:end-5);
                                if current_bin<=length(data_trial(:,unit1)),
                                    aggr_data_trial1(current_bin,trial)=data_trial(current_bin,unit1);
                                    aggr_data_trial2(current_bin,trial)=data_trial(current_bin,unit2);
                                    aggr_data_trial3(current_bin,trial)=data_trial(current_bin,unit3);
                                    aggr_data_trial4(current_bin,trial)=data_trial(current_bin,unit4);
                                    aggr_data_trial5(current_bin,trial)=data_trial(current_bin,unit5);
                                end
                            end
                            
                            %                         mr1=aggr_data_trial1(current_bin,:)-(rates_mean(current_bin,unit1).*ones(1,ntrials));
                            %                         mr2=aggr_data_trial2(current_bin,:)-(rates_mean(current_bin,unit2).*ones(1,ntrials));
                            %                         mr3=aggr_data_trial3(current_bin,:)-(rates_mean(current_bin,unit3).*ones(1,ntrials));
                            %                         mr4=aggr_data_trial4(current_bin,:)-(rates_mean(current_bin,unit4).*ones(1,ntrials));
                            %
                            mr1=aggr_data_trial1(current_bin,:)-mean(aggr_data_trial1(current_bin,:),2).*ones(1,ntrials);
                            mr2=aggr_data_trial2(current_bin,:)-mean(aggr_data_trial2(current_bin,:),2).*ones(1,ntrials);
                            mr3=aggr_data_trial3(current_bin,:)-mean(aggr_data_trial3(current_bin,:),2).*ones(1,ntrials);
                            mr4=aggr_data_trial4(current_bin,:)-mean(aggr_data_trial4(current_bin,:),2).*ones(1,ntrials);
                            mr5=aggr_data_trial5(current_bin,:)-mean(aggr_data_trial5(current_bin,:),2).*ones(1,ntrials);
                            
                            
                            
                            numerator=sum(mr1.*mr2.*mr3.*mr4.*mr5);
                            denominator=(( sum(mr1.^5)* sum(mr2.^5)* sum(mr3.^5) * sum(mr4.^5)* sum(mr5.^5) ).^(1/5));
                            if isreal(denominator) && ( abs(numerator/denominator)<0.3 )
                                total_corr(current_bin,t)=numerator/denominator;
                            else
                                total_corr(current_bin,t)=NaN;
                                %error('not real')
                            end
                            total_corr(current_bin,t)=numerator/denominator;
                            
                        end
                        
                        subplot(211)
                        values=total_corr(:,t);
                        plot(times,values,'Color',[0.8 0.8 0.8]),
                        xlabel('Time (ms)'), ylabel('correl.'),
                        xlim([times(1),times(end)]);
                        hold on
                        %Plotting lines and mean values
                        if doPlotLines>0
                            plotAllLines(tone1_1,long_tone1_1,tone1_2,long_tone1_2,tone2_1,long_tone2_1,tone2_2,long_tone2_2,values,times,movement)
                        end
                    end
                end
            end
        end
    end
    
    hold off
    %set(gcf,'Name',name)
    
    %Now a figure with all means
    %figure
    subplot(223)
    values=nanmean(abs(total_corr),2);
    devs=nanstd(abs(total_corr),0,2)/sqrt(t);
    shadedErrorBar(times,values,devs,...
        {'Color',[0 0 0.7],'Linewidth',2})
    if doPlotLines>0
        plotAllLines(tone1_1,long_tone1_1,tone1_2,long_tone1_2,tone2_1,long_tone2_1,tone2_2,long_tone2_2,values,times,movement)
    end
    xlim([times(1),times(end)]);
    if min(values-devs)<max(values+devs)
        ylim([min(values-devs),max(values+devs)]);
    end
    xlabel('Time (ms)'), ylabel('5th order correl.'),title('abs values'),
    
    
    subplot(224)
    values=nanmean((total_corr),2);
    devs=nanstd((total_corr),0,2)/sqrt(t);
    shadedErrorBar(times,values,devs,...
        {'Color',[0 0 0.7],'Linewidth',2})
    if doPlotLines>0
        plotAllLines(tone1_1,long_tone1_1,tone1_2,long_tone1_2,tone2_1,long_tone2_1,tone2_2,long_tone2_2,values,times,movement)
    end
    xlim([times(1),times(end)]);
    if min(values-devs)<max(values+devs)
        ylim([min(values-devs),max(values+devs)]);
    end
    xlabel('Time (ms)'), ylabel('5th order correl.'),title('real values'),
    set(gcf,'Name',name)
    
    results.noisecorrel=total_corr;
    results.tones_positions=[tone1_1,long_tone1_1,tone1_2,long_tone1_2,tone2_1,long_tone2_1,tone2_2,long_tone2_2,movement];
    
end