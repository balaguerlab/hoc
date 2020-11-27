
function [data_period,periodName,bins_vector]=get_period(data,period)
%Inputs:
%      -data=ntrials x (nvariables+3) containing iFR per unit
%       simultaneously recorded+ the LFP+a column which contains all responses in the trial (categories 1-8 see attached document)
%       + a column with '1' indicating the offset of the second tone + a column grouping some of these categories (see below) and a final columns containing groups of trials constituting
%       super-trial (say 200 trials for instance)
%     -period=behaviorally relevant period during the trial. See below.
%Outputs:
%    -data_period=dataset constrained during this period
%    -periodName=String
%    -bins_vector=2 x1 vector, indicating the lower and upper limits of
%    bins in this period
%
%by Emili Balaguer-Ballester. Comput neuro lab. Interdisiciplinary Neurosci Research Centre.
%Faculty of Science and Technology, Bournemouth University
%April 2020

nbins1=1;nbins2=(440/40)-2;%The animal can wait until the second tone offset to know
nbins4=(640/40);nbins5=(760/40);nbins6=(1280/40);
if period==1
    data_period=data(nbins1:nbins1+3,:);
    periodName=[' Initiation ',num2str(nbins1),'-',num2str((nbins1+3)*40)];
    bins_vector=[nbins1,nbins1+3];
elseif period==2
    data_period=data(nbins2:nbins2+3,:);
    periodName=[' Stimulus ',num2str(nbins2*40),'-',num2str((nbins2+3)*40)];
    bins_vector=[nbins2,nbins2+3];
elseif period==3
    data_period=data(nbins4:nbins4+3,:);
    periodName=[' Choice ',num2str(nbins4*40),'-',num2str((nbins4+3)*40)];
    bins_vector=[nbins4,nbins4+3];
elseif period==4
    data_period=data(nbins1:nbins5,:);
    periodName=' Full relevant trial ';
    bins_vector=[nbins1,nbins5];
elseif period==5
    data_period=data(nbins1:nbins5+2,:);
    periodName=' Full relevant trial plus two security bins ';
    bins_vector=[nbins1,nbins5+2];
else
    if nbins6>length(data(:,1)), nbins6=length(data(:,1)); end
    data_period=data(nbins1:nbins6,:);
    periodName=' Full trial ';
    bins_vector=[nbins1,nbins6];
    
end
