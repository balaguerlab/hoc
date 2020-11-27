function [total_correct_pos,total_correct_neg,total_incorrect_pos,total_incorrect_neg]=...
    basicStatsCorrelSign(file_corr_basic,file_incorr_basic,location,period,plotTitle)
%This will give us the stats to compare the sings of correlations.  e.g., Figures 6, 7, S4 
%Balaguer-Ballester, E., Nogueira, R., Abofalia, J.M., Moreno-Bote, R. Sanchez-Vives, M.V., 2020. Representation of Foreseeable Choice Outcomes in Orbitofrontal Cortex Triplet-wise Interactions. Plos Computational Biology, 16(6): e1007862.

load(file_corr_basic);
load(file_incorr_basic);

[correct_blocks_noisecorrel,~,~]=get_period(correct_blocks_noisecorrel,period);
[incorrect_blocks_noisecorrel,pname,bins_vector]=get_period(incorrect_blocks_noisecorrel,period);
disp(' '),
disp(['************* Subplot: ',num2str(location),'. File: ',plotTitle,'. Period considered:',pname,'**************']),


%Correlation focusing on positive and negative correlations separately now

%1.1. Correct trials
matrix_correct_abs=abs(correct_blocks_noisecorrel);
 matrix_correct_neg=min(correct_blocks_noisecorrel,0);%sets zero the positives
 matrix_correct_pos=max(correct_blocks_noisecorrel,0);%sets zero the negatives
 %Alternatives
%matrix_correct_neg=correct_blocks_noisecorrel;
%matrix_correct_pos=correct_blocks_noisecorrel;
%matrix_correct_neg(matrix_correct_neg>0)=nan;
%matrix_correct_pos(matrix_correct_pos<=0)=nan;


all_correct_neg=nanmean(nanmean(abs(matrix_correct_neg),2));%allmed for all coeffs like fig 1
%all_correct_neg=nansum(nansum(abs(matrix_correct_neg),2));%allmed for all coeffs like fig 1
total_correct_neg=nanmean(abs(matrix_correct_neg),2);%Averaged for all coeffs like fig 1
%total_correct_neg=nansum(abs(matrix_correct_neg),2);%Averaged for all coeffs like fig 1
mean_correct_neg=nanmean(total_correct_neg);
error_bar_correct_neg=nanstd(total_correct_neg)/sqrt(length(total_correct_neg));

all_correct_pos=nanmean(nanmean(abs(matrix_correct_pos),2));%allmed for all coeffs like fig 1
%all_correct_pos=nansum(nansum(abs(matrix_correct_pos),2));%allmed for all coeffs like fig 1
total_correct_pos=nanmean(abs(matrix_correct_pos),2);%Averaged for all coeffs like fig 1
%total_correct_pos=nansum(abs(matrix_correct_pos),2);%Averaged for all coeffs like fig 1
mean_correct_pos=nanmean(total_correct_pos);
error_bar_correct_pos=nanstd(total_correct_pos)/sqrt(length(total_correct_pos));

 total_correct_abs=nanmean(abs(matrix_correct_abs),2);%Averaged for all coeffs like fig 1
 mean_correct_abs=nanmean(total_correct_abs);
 error_bar_correct_abs=nanstd(total_correct_abs)/sqrt(length(total_correct_abs));

diff_correct=(total_correct_pos-total_correct_neg);
means_correct_diff=nanmean(diff_correct);
error_bar_correct_diff=nanstd(diff_correct)/sqrt(length(diff_correct));

%1.2. Incorrect trials
 matrix_incorrect_abs=abs(incorrect_blocks_noisecorrel);
matrix_incorrect_neg=min(incorrect_blocks_noisecorrel,0);%sets zero the positives
 matrix_incorrect_pos=max(incorrect_blocks_noisecorrel,0);%sets zero the negatives
 
all_incorrect_neg=nanmean(nanmean(abs(matrix_incorrect_neg),2));%Summed for all coeffs like fig 1
%all_incorrect_neg=nansum(nansum(abs(matrix_incorrect_neg),2));%Summed for all coeffs like fig 1
total_incorrect_neg=nanmean(abs(matrix_incorrect_neg),2);%Averaged for all coeffs like fig 1
%total_incorrect_neg=nansum(abs(matrix_incorrect_neg),2);%Averaged for all coeffs like fig 1
mean_incorrect_neg=nanmean(total_incorrect_neg);
error_bar_incorrect_neg=nanstd(total_incorrect_neg)/sqrt(length(total_incorrect_neg));

all_incorrect_pos=nanmean(nanmean(abs(matrix_incorrect_pos),2));%Summed for all coeffs like fig 1
%all_incorrect_pos=nansum(nansum(abs(matrix_incorrect_pos),2));%Summed for all coeffs like fig 1
%total_incorrect_pos=nansum(abs(matrix_incorrect_pos),2);%Averaged for all coeffs like fig 1
total_incorrect_pos=nanmean(abs(matrix_incorrect_pos),2);%Averaged for all coeffs like fig 1
mean_incorrect_pos=nanmean(total_incorrect_pos);
error_bar_incorrect_pos=nanstd(total_incorrect_pos)/sqrt(length(total_incorrect_pos));

 total_incorrect_abs=nanmean(abs(matrix_incorrect_abs),2);%Averaged for all coeffs like fig 1
 mean_correct_abs=nanmean(total_incorrect_abs);
 error_bar_incorrect_abs=nanstd(total_incorrect_abs)/sqrt(length(total_incorrect_abs));

diff_incorrect=(total_incorrect_pos-total_incorrect_neg);
means_incorrect_diff=nanmean(diff_incorrect);
error_bar_incorrect_diff=nanstd(diff_incorrect)/sqrt(length(diff_incorrect));

%1.3. Plotting


%subplot(4,2,location)

% %%%Asume 40 ms bin-all trials%%%
%
% bin_size=40;
%
% times=(bins_vector(1):bin_size:bins_vector(2)*bin_size);
%
% n_pairs=length(matrix_correct_abs(1,:));
% values=nanmean(abs(matrix_correct_abs),2);
% if length(values)==length(times),
%     devs=nanstd(abs(matrix_correct_abs),0,2)/sqrt(n_pairs);
%     shadedErrorBar(times,values,devs,...
%         {'Color',[0 0 0.7],'Linewidth',2})
%     min1=min(values-devs);max1=max(values+devs);
% end
% hold on
%
% n_pairs=length(matrix_incorrect_abs(1,:));
% values=nanmean(abs(matrix_incorrect_abs),2);
% devs=nanstd(abs(matrix_incorrect_abs),0,2)/sqrt(n_pairs);
% if length(values)==length(times),
%     shadedErrorBar(times,values,devs,...
%         {'Color','k','Linewidth',2})
%     xlim([times(1),times(end)]);
%     min2=min(values-devs);max2=max(values+devs);
%     ylim([min(min1,min2),max(max1,max2)]);
% end
% xlabel('Time (ms)'), ylabel(['Correl order 3']),title('Full correlations'),
%
%
% subplot(5,2,location+2)
%
%     %%%Asume 40 ms bin%%%
%
%     bin_size=40;
%
%     times=(bins_vector(1):bin_size:bins_vector(2)*bin_size);
%
%     n_pairs=length(matrix_correct_pos(1,:));
%     values=nanmean(abs(matrix_correct_pos),2);
%     devs=nanstd(abs(matrix_correct_pos),0,2)/sqrt(n_pairs);
%     if length(values)==length(times),
%         shadedErrorBar(times,values,devs,...
%             {'Color',[0 0 0.7],'Linewidth',2})
%         min1=min(values-devs);max1=max(values+devs);
%     end
%     hold on
%
%     n_pairs=length(matrix_incorrect_pos(1,:));
%     values=nanmean(abs(matrix_incorrect_pos),2);
%     devs=nanstd(abs(matrix_incorrect_pos),0,2)/sqrt(n_pairs);
%     if length(values)==length(times),
%         shadedErrorBar(times,values,devs,...
%             {'Color','k','Linewidth',2})
%     xlim([times(1),times(end)]);
%     min2=min(values-devs);max2=max(values+devs);
%     ylim([min(min1,min2),max(max1,max2)]);
%     end
%     xlabel('Time (ms)'), ylabel(['Correl order 3']),title('Positive correlations'),
%

subplot(4,2,location+2)

%%%Asume 40 ms bin%%%

bin_size=40;

times=(bins_vector(1):bin_size:bins_vector(2)*bin_size);
n_pairs=length(matrix_correct_neg(1,:));
values=-nanmean(abs(matrix_correct_neg),2);
if length(values)==length(times),
    devs=nanstd(abs(matrix_correct_neg),0,2)/sqrt(n_pairs);
    shadedErrorBar(times,values,devs,...
        {'Color',[0 0 0.7],'Linewidth',2})
    min1=min(values-devs);max1=max(values+devs);
end
hold on

n_pairs=length(matrix_incorrect_neg(1,:));
values=-nanmean(abs(matrix_incorrect_neg),2);
devs=nanstd(abs(matrix_incorrect_neg),0,2)/sqrt(n_pairs);
if length(values)==length(times),
    shadedErrorBar(times,values,devs,...
        {'Color','k','Linewidth',2})
    xlim([times(1),times(end)]);
    min2=min(values-devs);max2=max(values+devs);
    ylim([min(min1,min2),max(max1,max2)]);
end
xlabel('Time (ms)'), ylabel(['Correlation']),ti=title('Negative triplets');
set(gca,'FontSize',8)
%set(ti,'Color',[1 1 1]);


%Novelty: Pie charts
subplot(8,4,location.^2)
hold on

all_abs=nanmean(nanmean(matrix_correct_abs))+nanmean(nanmean(matrix_incorrect_abs));
%all_abs=nansum(nansum(matrix_correct_abs))+nansum(nansum(matrix_incorrect_abs));
all_neg=all_correct_neg+all_incorrect_neg;
frac_neg=(all_neg/all_abs)*100;
%X=[all_abs-all_neg,all_abs];
X=[frac_neg,100-frac_neg];
explode=[1 1];
%={'Negative','Positive'};
h=pie(X,explode);
%h=pie(X,explode,labels);
set(h(1),'FaceColor',[1,1,0]);
set(h(3),'FaceColor','none');


hold off

%Bar chart
subplot(4,2,location+4)

errorbar(1,-mean_correct_neg,error_bar_correct_neg,'Color',[0,0,.7],'Marker','none','LineWidth',1);hold on;
errorbar(2.4,-mean_incorrect_neg,error_bar_incorrect_neg,'Color','k','Marker','none','LineWidth',1);hold on;

% errorbar(4,-mean_correct_pos,error_bar_correct_pos,'Color',[0,0,.7],'Marker','none','LineWidth',1);hold on;
% errorbar(5.4,-mean_incorrect_pos,error_bar_incorrect_pos,'Color','k','Marker','none','LineWidth',1);hold on;

%     errorbar(location+8,means_correct_diff,error_bar_correct_diff,'Color','k','Marker','none','LineWidth',1.5,'LineStyle','none');hold on;
%     errorbar(location+10,means_incorrect_diff,error_bar_incorrect_diff,'Color','k','Marker','none','LineWidth',1.5,'LineStyle','none');hold on;

bar(1,-mean_correct_neg,'FaceColor',[1,1,0],'LineWidth',1.5,'EdgeColor',[0,0,.7]);hold on;
bar(2.4,-mean_incorrect_neg,'FaceColor',[1,1,0],'LineWidth',1.5,'EdgeColor',[0 0 0]);hold on;


%ob=text(1,0.1+max(mean_correct_neg,mean_incorrect_neg),'Negative');
%set(ob,'FontName','Arial','FontSize',8);
%'FaceColor',[.1,.1,.1],

%     bar(4,mean_correct_pos,'FaceColor','none','LineWidth',1.5,'EdgeColor',[0,0,.7]);hold on;
%     bar(5.2,mean_incorrect_pos,'FaceColor','none','LineWidth',1.5,'EdgeColor',[0,0,0]);hold on;

%     ob=text(4,0.1+max(mean_correct_pos,mean_incorrect_pos),'Positive');
%     set(ob,'FontName','Arial','FontSize',8);

%     bar(7,means_correct_diff,'FaceColor',[0,0,.7],'LineWidth',1.5);hold on;
%     bar(8.2,means_incorrect_diff,'FaceColor',[.1,.1,.1],'LineWidth',1.5);

% set(gca,'XTick',[location location+2 location+4 location+6 location+8 location+10]);
%set(gca,'XTick',[1 2.2 4 5.2]);
set(gca,'XTick',[1 2.4]);
%set(gca,'XTickLabel',{'Correct','Others','Correct','Others','Diff Correct','Diff Others'});
%set(gca,'XTickLabel',{'Correct','Others','Correct','Others'});
set(gca,'XTickLabel',{'Correct','Others'});
set(gca,'XTickLabelRotation',35);
set(gca,'FontSize',8);

%xlim([0 9]);
xlim([0 3.4]);

yl=ylabel('Correlation');

tit=title([num2str(location),'-',plotTitle]);
set(tit,'FontName','Arial','FontSize',8,'FontAngle','Italic');
set(gcf,'color',[1 1 1]);
set(yl,'FontName','Arial','FontSize',8);



%1.4. Testing

warning off
%Negatives for correct and Others
[h1,p1]=lillietest(total_correct_neg,'alpha',0.001);[h2,p2]=lillietest(total_incorrect_neg,'alpha',0.001);
disp(['noisecorrel negative lilliefors min p=',num2str(min(p1,p2)),' max h=',num2str(max(h1,h2)),' (non-gauss if h=1, p<0.05)']),
[h1,p1]=kstest(total_correct_neg,'alpha',0.001);[h2,p2]=kstest(total_incorrect_neg,'alpha',0.001);
disp(['noisecorrel negative ks min p=',num2str(min(p1,p2)),' max h=',num2str(max(h1,h2)),' (non-gauss if h=1, p<0.05)']),
[p,h,stats]=ranksum(total_correct_neg,total_incorrect_neg,'tail','left');
disp(['noisecorrel negative correct vs incorrrect W=',num2str(stats.ranksum),', p=',num2str(p),', n=',num2str(length(total_correct_neg)),', h=',num2str(h),' (h=1 for unequal means)']),
[h,p,~,stats]=ttest2(total_correct_neg,total_incorrect_neg);
disp(['noisecorrel negative correct vs incorrrect T=',num2str(stats.tstat),', p=',num2str(p),', df=',num2str(stats.df),', h=',num2str(h),' (h=1 for unequal means)']),
[p,h,stats] = signrank(total_correct_neg,total_incorrect_neg');
disp(['noisecorrel negative correct vs incorrrect R=',num2str(stats.signedrank),', p=',num2str(p),', n=',num2str(length(total_correct_neg)),', h=',num2str(h),' (h=1 for unequal means)']),

%Testing manova
[bins1,pairs1]=size(matrix_incorrect_neg);
[bins2,pairs2]=size(matrix_correct_neg);
bins=min(bins1,bins2);pairs=min(pairs1,pairs2);
total_corr=[matrix_correct_neg(1:bins,:)';matrix_incorrect_neg(1:bins,:)'];

%remove columns (triplets or pairs of neurons) with Nans in at least a bin. That enables matlab
%to run manova

total_corr_aux=[];flag=0;
for i=1:bins
    if ~any(isnan(total_corr(:,i)))
        total_corr_aux=[total_corr_aux,total_corr(:,i)];
        flag=1;
    end
end
if flag
    total_corr=total_corr_aux;
    index_trial_corr=[ones(pairs,1);zeros(pairs,1)];
    try
        [d,p,stats] = manova1(total_corr,index_trial_corr);
    catch
        orto_total_corr=orth(total_corr);
        
        [d,p,stats] = manova1(orto_total_corr,index_trial_corr);
        warning('Orthogonalised matrix')
    end
    
    disp(['noisecorrel manova where DIMENSIONS ARE BINS correct vs incorrect groups: Chi2=',num2str(stats.chisq),...
        ', n=',num2str(stats.chisqdf),' p=',num2str(p),', Lambda=',num2str(stats.lambda),', d=',num2str(d)]),
end

%Differences from positive for correct and incorrect
%     [h1,p1]=lillietest(diff_correct);[h2,p2]=lillietest(diff_incorrect);
%     disp(['noisecorrel diff pos-neg lilliefors min p=',num2str(min(p1,p2)),' max h=',num2str(max(h1,h2)),' (non-gauss if h=1, p<0.05)']),
%     [p,h,stats]=ranksum(diff_correct,diff_incorrect);
%     disp(['noisecorrel diff pos-neg correct vs incorrrect W=',num2str(stats.ranksum),', p=',num2str(p),', n=',num2str(length(diff_correct)),', h=',num2str(h),' (h=1 for unequal means)']),
%     [h,p,~,stats]=ttest2(diff_correct,diff_incorrect);
%     disp(['noisecorrel diff pos-neg correct vs incorrrect T=',num2str(stats.tstat),', p=',num2str(p),', df=',num2str(stats.df),', h=',num2str(h),' (h=1 for unequal means)']),


warning on
