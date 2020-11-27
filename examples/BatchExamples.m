
%Batch file with examples
%April 2020

%Behavioural relevant periods in trial last for ~1200 ms

%I-Data formatting
clear;clc;close all;
bin=0.04;%0.08;0.02; rate time bin in seconds
trials_block=40;%40 trials in a block
labs=6;%8 cores in the machine
filetype='';%Default for full data files
doPlotLines=1;%Default plot lines of trial periods
isreal_trial=1;%1 for balancing the number of trials after correct/incorrect. See paper and below

if isreal_trial, isreal_text='real_trials_';
else
    isreal_text=''; 
end

trials_limits=[1 2640];%Upper limit on the number of trials
%trials_lim=[1 2000];
%trials_lim=[1 160];

tic

%Examples 
%5+ units
files={'movement_latency_4Class_92_10at0.04Bin40Trials-block.mat','movement_latency_4Class_92_11at0.04Bin40Trials-block.mat',...
    'movement_latency_3Class_92_24at0.04Bin40Trials-block.mat'...
    'movement_latency_3Class_95_23at0.04Bin40Trials-block.mat','movement_latency_3Class_95_24at0.04Bin40Trials-block.mat'}; selection='five';
disp('five files selected')

%Example passives. 95_23 lost neurons and it has 3-> %92_23 (same #units)
%  files={'Passive_a_92_10pa0.04Bin40Trials-block.mat',...
%      'Passive_a_92_11pa0.04Bin40Trials-block.mat',...
%     'Passive_a_92_23pa0.04Bin40Trials-block.mat'...
%     'Passive_a_92_24pa0.04Bin40Trials-block.mat',...
%     'Passive_a_95_24pa0.04Bin40Trials-block.mat'}; 
% disp('five files selected')
% selection='five';

names=files;

%--------------------------------------------------------------------------

%II-Standard analyses
parpool(labs)
display_on=1;
transformation='';%Flag for the saved file -anything can be used

trials_type='all';%All trials considered
%trials_type='correct';%Only correct trials considered
%trials_type='incorrect';%contains missed, premat. central and premat
%lateral.
%trials_type='missed';%Novelty: different kinds of not correct trials
%trials_type='prematCent';
% trials_type='prematLat';

n_bins_trial_before=0;min_bins=inf;
rates_acum=cell(1,length(files));stdev_acum=cell(1,length(files));fano_acum=cell(1,length(files));
varCE_acum=cell(1,length(files)); noisecorrel_acum=cell(1,length(files));
count=0;
tones_pos_acum=[];
if display_on
    for i=1:length(files)
        count=count+1;
        load(files{i});
        disp(files{i}),
        trials_lim=trials_limits;
        
        if strcmp(trials_type,'correct')
            SelectData=DataSet(DataSet(:,end-2)==1,:);
            disp(['Correct. Real max trial: ',num2str(max(SelectData(:,end-1)))]),
            
            if isreal_trial
                InputData=SelectData(SelectData(:,end-1)<=trials_lim(2),:);
                disp(['WARNING real limit to number of trials is ',num2str(max(InputData(:,end-1)))])
                InputData=renumTrials(InputData);
            else
                InputData=renumTrials(SelectData);
            end
            
            upper_trial=min([trials_lim(2),max(InputData(:,end-1))]);
            trials_lim=[1 upper_trial];
            disp(['Number of trials ',num2str(upper_trial)]),
                       
        elseif strcmp(trials_type,'incorrect')
            SelectData=DataSet(DataSet(:,end-2)~=1,:);
            disp(['Incorrect. Real max trial: ',num2str(max(SelectData(:,end-1)))]),
            if isreal_trial
                InputData=SelectData(SelectData(:,end-1)<=trials_lim(2),:);
                disp(['WARNING real limit to number of trials is ',num2str(max(InputData(:,end-1)))])
                InputData=renumTrials(InputData);
                
            else
                InputData=renumTrials(SelectData);
            end
            
            upper_trial=min([trials_lim(2),max(InputData(:,end-1))]);
            trials_lim=[1 upper_trial];
            disp(['Number of trials ',num2str(upper_trial)]),
            
        elseif strcmp(trials_type,'missed')
            SelectData=DataSet(DataSet(:,end-2)==2,:);
            disp(['Missed. Real max trial: ',num2str(max(SelectData(:,end-1)))]),
            
            if isreal_trial
                InputData=SelectData(SelectData(:,end-1)<=trials_lim(2),:);
                disp(['WARNING real limit to number of trials is ',num2str(max(InputData(:,end-1)))])
                InputData=renumTrials(InputData);
                
            else
                InputData=renumTrials(SelectData);
            end
            
            upper_trial=min([trials_lim(2),max(InputData(:,end-1))]);
            trials_lim=[1 upper_trial];
            disp(['Number of trials ',num2str(upper_trial)]),
                     
        elseif strcmp(trials_type,'prematCent')
            SelectData=DataSet(DataSet(:,end-2)==3,:);
            disp(['Premature Central. Real max trial: ',num2str(max(SelectData(:,end-1)))]),
            
            if isreal_trial
                InputData=SelectData(SelectData(:,end-1)<=trials_lim(2),:);
                disp(['WARNING real limit to number of trials is ',num2str(max(InputData(:,end-1)))])
                InputData=renumTrials(InputData);
                
            else
                InputData=renumTrials(SelectData);
            end
            
            upper_trial=min([trials_lim(2),max(InputData(:,end-1))]);
            trials_lim=[1 upper_trial];
            disp(['Number of trials ',num2str(upper_trial)]),
                      
        elseif strcmp(trials_type,'prematLat')
            SelectData=DataSet(DataSet(:,end-2)==4,:);
            disp(['Premature Lateral. Real max trial: ',num2str(max(SelectData(:,end-1)))]),
            
            if isreal_trial
                InputData=SelectData(SelectData(:,end-1)<=trials_lim(2),:);
                disp(['WARNING real limit to number of trials is ',num2str(max(InputData(:,end-1)))])
                InputData=renumTrials(InputData);  
                
            else
                InputData=renumTrials(SelectData);
            end
            
            upper_trial=min([trials_lim(2),max(InputData(:,end-1))]);
            trials_lim=[1 upper_trial];
            disp(['Number of trials ',num2str(upper_trial)]),    
            
        else
            disp(['All trials. Real max trial: ',num2str(max(DataSet(:,end-1)))]),
            InputData=DataSet;
            upper_trial=min([trials_lim(2),max(InputData(:,end-1))]);
            trials_lim=[1 upper_trial];
            
        end
        
        results=variabilitySingleUnits(InputData,bin*1000,labs,trials_lim,names{1,i},doPlotLines);%Bin in ms
        rates_mean=results.rates_mean;
        rates_stdev=results.rates_std;
        fano=results.fano;
        varCE=results.varCE;
        
        %Noise correlations. Uncomment the corresponding order to calculate it.
        results=noiseCorr(rates_mean,InputData,bin*1000,labs,trials_lim,names{1,i},doPlotLines);ordercorr='2';
        %results=noiseCorr_3rdorder(rates_mean,InputData,bin*1000,labs,trials_lim,names{1,i},doPlotLines);ordercorr='3';
        %results=noiseCorr_4rdorder(rates_mean,InputData,bin*1000,labs,trials_lim,names{1,i},doPlotLines);ordercorr='4';
        %results=noiseCorr_5thorder(rates_mean,InputData,bin*1000,labs,trials_lim,names{1,i},doPlotLines);ordercorr='5';
        
        noise_correl=results.noisecorrel;
        tones_pos=results.tones_positions;
        
        %Acumulating
        n_bins_trial_now=length(rates_mean(:,1));
        if n_bins_trial_now<min_bins
            min_bins=n_bins_trial_now;
        end
        rates_acum{count}=rates_mean;
        stdev_acum{count}=rates_stdev;
        fano_acum{count}=fano;
        varCE_acum{count}=varCE;
        noisecorrel_acum{count}=noise_correl;
        tones_pos_acum=[tones_pos_acum;tones_pos];
        %Now the same but separated by cognitive decisions.
        %         for j=1:decisions,
        %             disp(['Decision ',num2str(j)])
        %             %Select only the trials corresponding to a specific decision.
        %             Data2=DataSet(DataSet(:,end-2)==j,:);
        %             %Make trials consecutive
        %             orderedTrials=reorder(Data2(:,end-1));
        %             orderedBlocks=reorder(Data2(:,end));
        %             Data3=[Data2(:,1:end-2),orderedTrials',orderedBlocks'];
        %             fanoEtAl3(Data3,bin*1000);%Bin in ms
        %         end
        % end
    end
    
    save([transformation,'Data_per_files_',trials_type,'_',selection,'_files','_order corr_',ordercorr,filetype],'bin','min_bins','rates_acum','stdev_acum','fano_acum','varCE_acum','noisecorrel_acum','tones_pos_acum','trials_type','selection','ordercorr','filetype','transformation','doPlotLines');
     plotFinalAverages6(bin,min_bins,rates_acum,stdev_acum,fano_acum,varCE_acum,noisecorrel_acum,tones_pos_acum,trials_type,selection,ordercorr,doPlotLines,filetype,transformation);
    disp(['Time = ',num2str(toc/60),' minutes']);
end
delete(gcp('nocreate'))




