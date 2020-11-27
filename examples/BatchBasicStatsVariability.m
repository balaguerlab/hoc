%This will give us the stats to compare means. Examples below correspond to S1 Fig
%Balaguer-Ballester, E., Nogueira, R., Abofalia, J.M., Moreno-Bote, R. Sanchez-Vives, M.V., 2020. Representation of Foreseeable Choice Outcomes in Orbitofrontal Cortex Triplet-wise Interactions. Plos Computational Biology, 16(6): e1007862.

clc;clear

load('BasicAnalyses_correct_five_files_order corr_3.mat')
load('BasicAnalyses_incorrect_five_files_order corr_3.mat')
load('Passive_BasicAnalyses_all_five_files_order corr_3.mat')

%Selection period
period=5;location=6+period;
if period>3
    location=period;
end

[correct_blocks_noisecorrel,~]=get_period(correct_blocks_noisecorrel,period);
[incorrect_blocks_noisecorrel,~]=get_period(incorrect_blocks_noisecorrel,period);
[passive_blocks_noisecorrel,pname]=get_period(blocks_noisecorrel,period);

disp(['*************Period considered:',pname,'**************']),
disp('*********************Noisecorrel*************************'),
correct_blocks_noisecorrel=abs(correct_blocks_noisecorrel);
incorrect_blocks_noisecorrel=abs(incorrect_blocks_noisecorrel);
passive_blocks_noisecorrel=abs(passive_blocks_noisecorrel);

[bins1,neurons1]=size(correct_blocks_noisecorrel);
[bins2,neurons2]=size(incorrect_blocks_noisecorrel);
[bins3,neurons3]=size(passive_blocks_noisecorrel);

bins=min([bins1,bins2,bins3]);neurons=min([neurons1,neurons2,neurons3]);

total_noisecorrel=[correct_blocks_noisecorrel(1:bins,1:neurons);incorrect_blocks_noisecorrel(1:bins,1:neurons);passive_blocks_noisecorrel(1:bins,1:neurons)];

%remove columns (neurons) with Nans in at least a bin. That enables matlab
%to run manova
total_noisecorrel_aux=[];
for i=1:neurons
    if ~any(isnan(total_noisecorrel(:,i)))
        total_noisecorrel_aux=[total_noisecorrel_aux,total_noisecorrel(:,i)];
    end
end
total_noisecorrel=total_noisecorrel_aux;  

index_trial_noisecorrel=[2.*ones(bins,1);ones(bins,1);zeros(bins,1)];
total_noisecorrel_bins=[correct_blocks_noisecorrel(1:bins,1:neurons)';incorrect_blocks_noisecorrel(1:bins,1:neurons)';passive_blocks_noisecorrel(1:bins,1:neurons)'];
index_trial_bins_noisecorrel=[2.*ones(neurons,1);ones(neurons,1);zeros(neurons,1)];

index_trial_noisecorrel_reduced1=[ones(bins,1);zeros(bins,1)];
total_noisecorrel_bins_reduced1=[incorrect_blocks_noisecorrel(1:bins,1:neurons)';passive_blocks_noisecorrel(1:bins,1:neurons)'];
index_trial_bins_noisecorrel_reduced1=[ones(neurons,1);zeros(neurons,1)];

index_trial_noisecorrel_reduced2=[ones(bins,1);zeros(bins,1)];
total_noisecorrel_bins_reduced2=[correct_blocks_noisecorrel(1:bins,1:neurons)';passive_blocks_noisecorrel(1:bins,1:neurons)'];
index_trial_bins_noisecorrel_reduced2=[ones(neurons,1);zeros(neurons,1)];



correct_mean_noisecorrel=nanmean(correct_blocks_noisecorrel,2);
%correct_std_noisecorrel=nanstd(correct_blocks_noisecorrel,0,2);
incorrect_mean_noisecorrel=nanmean(incorrect_blocks_noisecorrel,2);
%incorrect_std_noisecorrel=nanstd(incorrect_blocks_noisecorrel,0,2);
passive_mean_noisecorrel=nanmean(passive_blocks_noisecorrel,2);

%Compare passive with incorrect
[h1,p1]=lillietest(passive_mean_noisecorrel);[h2,p2]=lillietest(incorrect_mean_noisecorrel);
disp(['noisecorrel lilliefors min p=',num2str(min(p1,p2)),' max h=',num2str(max(h1,h2)),' (non-gauss if h=1, p<0.05)']),
[p,h,stats]=ranksum(passive_mean_noisecorrel,incorrect_mean_noisecorrel);
disp(['Ranskum passive vs incorrect: noisecorrel mean across units W=',num2str(stats.ranksum),', p=',num2str(p),', n=',num2str(length(passive_mean_noisecorrel)),', h=',num2str(h),' (h=1 for unequal means)']),
[h,p,~,stats]=ttest2(passive_mean_noisecorrel,incorrect_mean_noisecorrel);
pcorrected=p*3;%p*bins;
disp(['pcorrected=',num2str(pcorrected)]);   
disp(['Ttest2 passive vs incorrect: noisecorrel mean across units T=',num2str(stats.tstat),', p=',num2str(p),', df=',num2str(stats.df),', h=',num2str(h),' (h=1 for unequal means)']),
pcorrected=p*3;%p*bins;
disp(['pcorrected=',num2str(pcorrected)]);   
disp(' _______________________________') 
%Compare passive with correct
[h1,p1]=lillietest(passive_mean_noisecorrel);[h2,p2]=lillietest(correct_mean_noisecorrel);
disp(['noisecorrel lilliefors min p=',num2str(min(p1,p2)),' max h=',num2str(max(h1,h2)),' (non-gauss if h=1, p<0.05)']),
[p,h,stats]=ranksum(passive_mean_noisecorrel,correct_mean_noisecorrel);
disp(['Ranskum passive vs correct: noisecorrel mean across units W=',num2str(stats.ranksum),', p=',num2str(p),', n=',num2str(length(passive_mean_noisecorrel)),', h=',num2str(h),' (h=1 for unequal means)']),
[h,p,~,stats]=ttest2(passive_mean_noisecorrel,correct_mean_noisecorrel);
pcorrected=p*3;%p*bins;
disp(['pcorrected=',num2str(pcorrected)]);   
disp(['Ttest2 passive vs correct: noisecorrel mean across units T=',num2str(stats.tstat),', p=',num2str(p),', df=',num2str(stats.df),', h=',num2str(h),' (h=1 for unequal means)']),
pcorrected=p*3;%p*bins;
disp(['pcorrected=',num2str(pcorrected)]);

% 
% try
% [d,p,stats] = manova1(total_noisecorrel,index_trial_noisecorrel);
% catch 
%     orto_total_noisecorrel=orth(total_noisecorrel);
%     
%     [d,p,stats] = manova1(orto_total_noisecorrel,index_trial_noisecorrel);
%     warning('Orthogonalised matrix')
% end
%  
%  disp(['noisecorrel manova where DIMENSIONS ARE UNITS correct vs incorrect groups: Chi2=',num2str(stats.chisq),...
%      ', n=',num2str(stats.chisqdf),' p=',num2str(p),', Lambda=',num2str(stats.lambda),', d=',num2str(d)]), 
%  
  
 disp('noisecorrel manova where DIMENSIONS ARE BINS incorrect vs passive groups:'), 
 [d,p,stats] = manova1(total_noisecorrel_bins_reduced1,index_trial_bins_noisecorrel_reduced1)
 
  disp('noisecorrel manova where DIMENSIONS ARE BINS correct vs passive groups:'), 
 [d,p,stats] = manova1(total_noisecorrel_bins_reduced2,index_trial_bins_noisecorrel_reduced2)
 
 disp('noisecorrel manova where DIMENSIONS ARE BINS correct vs incorrect vs passive groups:'), 
 [d,p,stats] = manova1(total_noisecorrel_bins,index_trial_bins_noisecorrel)

%PLots for fig 1
figure

 subplot(3,3,location)
    %for SEM divide std by /sqrt(length(correct_mean_noisecorrel)
    errorbar(3.4,nanmean(correct_mean_noisecorrel),nanstd(correct_mean_noisecorrel),'Color',[0,0,1],'Marker','none','LineWidth',0.5,'LineStyle','none');hold on;
    errorbar(2.2,nanmean(incorrect_mean_noisecorrel),nanstd(incorrect_mean_noisecorrel),'Color','k','Marker','none','LineWidth',1.5,'LineStyle','none');hold on;
    errorbar(1,nanmean(passive_mean_noisecorrel),nanstd(passive_mean_noisecorrel),'Color',[0 0.7 0],'Marker','none','LineWidth',1.5,'LineStyle','none');hold on;
       
       % bar(1,mean(correct_mean_noisecorrel),'FaceColor',[0,0,.7],'LineWidth',1.5,'EdgeColor',[0 .9 .9]);hold on;

    
    bar(3.4,nanmean(correct_mean_noisecorrel),'FaceColor','none','LineWidth',1,'LineStyle',':','EdgeColor',[0,0,1]);hold on;
    bar(2.2,nanmean(incorrect_mean_noisecorrel),'FaceColor','none','LineWidth',1.5,'EdgeColor',[.1,.1,.1]);hold on;
    bar(1,nanmean(passive_mean_noisecorrel),'FaceColor','none','LineWidth',1.5,'EdgeColor',[0 0.7 0]);hold on;
    
   
    set(gca,'XTick',[1 2.2 3.4]);
    set(gca,'XTickLabel',{'Passive','Incorrect','Correct',});
    set(gca,'XTickLabelRotation',45);
    set(gca,'box','off');
    set(gca,'YLim',[(mean(incorrect_mean_noisecorrel))-2*nanstd(incorrect_mean_noisecorrel),mean(correct_mean_noisecorrel)+nanstd(correct_mean_noisecorrel)]);
        
   yl=ylabel('<Correlation>');
    
    tit=title(pname);
    set(tit,'FontName','Arial','FontSize',10,'FontAngle','Italic');
    set(gcf,'color',[1 1 1]);
    set(yl,'FontName','Arial','FontSize',8);
  
%clear p stats total_noisecorrel_bins index_trial_bins_noisecorrel total_noisecorrel index_trial_noisecorrel h1 p1 h2 p2 h p bins1 neurons1 bins2 neurons2 bins neurons correct_mean_noisecorrel incorrect_mean_noisecorrel d p3 p4
  
 
