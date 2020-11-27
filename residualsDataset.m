function [ResidDataSet,r2s,fs,ps]=residualsDataset(file_name)
%Regressing units with previous trial and retaining
%residuals
%by Emili Balaguer-Ballester. Comput neuro lab. Interdisiciplinary Neurosci Research Centre.
%Faculty of Science and Technology, Bournemouth University
%April 2020

D=load(file_name);DataSet=D.DataSet;
n_trials=max(DataSet(:,end-1));
n_units=length(DataSet(1,1:end-5));
ResidDataSet=DataSet;
r2s=zeros(n_trials,n_units);
fs=zeros(n_trials,n_units);
ps=zeros(n_trials,n_units);
ResidDataSet=[];
warning('off')
for trial=2:n_trials
    columns_trial=DataSet(DataSet(:,end-1)==trial,end-4:end);
    data_trial=DataSet(DataSet(:,end-1)==trial,1:end-5);
    data_previous_trial=DataSet(DataSet(:,end-1)==trial-1,1:end-5);
    residDataTrial=[];
    nbins_trial=length(data_trial(:,1));
    nbins_previous_trial=length(data_previous_trial(:,1));
    nbins_allowed=min(nbins_trial,nbins_previous_trial);%For using regress, both trials have to have the same nukber of bins.
    columns_trial=columns_trial(1:nbins_allowed,:);
    for unit=1:n_units
       %Trials have different lengths 
        x=[ones(nbins_allowed,1), data_previous_trial(1:nbins_allowed,unit)];%Column of ones for the constant
        y= data_trial(1:nbins_allowed,unit);       
        [~,~,resid,~,STATS] = regress(y,x);
        r2s(trial,unit)=STATS(1);
        fs(trial,unit)=STATS(2);
        ps(trial,unit)=STATS(3);
        residDataTrial=[residDataTrial,resid];
    end
    ResidDataSet=[ResidDataSet;[residDataTrial,columns_trial]];
end
ResidDataSet=renumTrials(ResidDataSet);
warning('on')  
   
        
        
        
        