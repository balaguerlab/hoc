function [total_delta_pos,total_delta_neg]=...
    diffCorr(file_corr_basic,file_incorr_basic,location,period,plotTitle,do_plot)
%Calculates the differential correlation shown in the suplementary methods
%and in Figure S5 of Balaguer-Ballester et al., 2020 Plos Comput Biol.
%Inputs:
%      -file_corr_basic, file_incorr_basic= data files. See format in
%      dataset.
%     -location=position in a 3 x 2 subplot grid
%     -period=behaviorally relevant period during the trial. See
%     "get_period.m"
%      -plotTitle=String
%      -do_plot=flag 0/1 to show the plot
%Outputs:
%    total_delta_pos,total_delta_neg=Differential correlations. See
%    Supplementary Methods in Balaguer-Ballester et al., 2020 Plos Comput Biol.
%
%by Emili Balaguer-Ballester. Comput neuro lab. Interdisiciplinary Neurosci Research Centre.
%Faculty of Science and Technology, Bournemouth University
%April 2020

if nargin<6, do_plot=0; end
load(file_corr_basic);
load(file_incorr_basic);

[correct_blocks_noisecorrel,~,~]=get_period(correct_blocks_noisecorrel,period);
[incorrect_blocks_noisecorrel,pname,bins_vector]=get_period(incorrect_blocks_noisecorrel,period);
disp(' '),
disp(['************* Subplot: ',num2str(location),'. File: ',plotTitle,'. Period considered:',pname,'**************']),


%Correct trials
matrix_correct_neg=min(correct_blocks_noisecorrel,0);%sets zero the positives
matrix_correct_pos=max(correct_blocks_noisecorrel,0);%sets zero the negatives

%Incorrect trials
matrix_incorrect_neg=min(incorrect_blocks_noisecorrel,0);%sets zero the positives
matrix_incorrect_pos=max(incorrect_blocks_noisecorrel,0);%sets zero the negatives

%---------------------------------new Jannuary explore---------------------
matrix_delta_pos=(abs(matrix_correct_pos)-abs(matrix_incorrect_pos));%./(abs(matrix_correct_pos)+abs(matrix_incorrect_pos));
matrix_delta_neg=(abs(matrix_correct_neg)-abs(matrix_incorrect_neg));%./(abs(matrix_correct_neg)+abs(matrix_incorrect_neg));

%total_delta_pos=nanmean(abs(matrix_delta_pos),1);%Averaged for all time bins of the period
total_delta_pos=nansum(abs(matrix_delta_pos),1);%Sum for all time bins of the period
mean_delta_pos=nanmean(total_delta_pos);
%mean_delta_pos=nansum(total_delta_pos);
error_bar_delta_pos=nanstd(total_delta_pos)/sqrt(length(total_delta_pos));

%total_delta_neg=nanmean(abs(matrix_delta_neg),1);%Averaged for all time bins of the period
total_delta_neg=nansum(abs(matrix_delta_neg),1);%Sum for all time bins of the period
mean_delta_neg=nanmean(total_delta_neg);
%mean_delta_neg=nansum(total_delta_neg);
error_bar_delta_neg=nanstd(total_delta_neg)/sqrt(length(total_delta_neg));

%Plotting
if do_plot
    subplot(3,2,location)
    
    %%%Asume 40 ms bin%%%
    
    bin_size=40;
    color_pink=[255,153,200]./255;
    color_grey=[0.7 0.7 0.7];
    times=(bins_vector(1):bin_size:bins_vector(2)*bin_size);
    n_pairs=length(matrix_delta_neg(1,:));
    values=nanmean(abs(matrix_delta_neg),2);
    if length(values)==length(times),
        devs=nanstd(abs(matrix_delta_neg),0,2)/sqrt(n_pairs);
        shadedErrorBar(times,values,devs,...
            {'Color',color_pink,'Linewidth',2})
        min1=min(values-devs);max1=max(values+devs);
    end
    hold on
    
    n_pairs=length(matrix_delta_pos(1,:));
    values=nanmean(abs(matrix_delta_pos),2);
    devs=nanstd(abs(matrix_delta_pos),0,2)/sqrt(n_pairs);
    if length(values)==length(times),
        shadedErrorBar(times,values,devs,...
            {'Color',color_grey,'Linewidth',2})
        xlim([times(1),times(end)]);
        min2=min(values-devs);max2=max(values+devs);
        ylim([min(min1,min2),max(max1,max2)]);
    end
    xlabel('Time (ms)'), ylabel(['Delta (/correct-incorrect/)']),ti=title('Pink: from /negative/, Grey: positive');
    set(gca,'FontSize',8)
    %set(ti,'Color',[1 1 1]);
    
    hold off
    
    %Bar chart. Uncomment to show other plot locations.
    subplot(3,2,location+2)
    
    errorbar(1,mean_delta_neg,error_bar_delta_neg,'Color',color_pink,'Marker','none','LineWidth',1);hold on;
    errorbar(2.4,mean_delta_pos,error_bar_delta_pos,'Color',[0.5 0.5 0.5],'Marker','none','LineWidth',1);hold on;
    
    % errorbar(4,-mean_correct_pos,error_bar_correct_pos,'Color',[0,0,.7],'Marker','none','LineWidth',1);hold on;
    % errorbar(5.4,-mean_incorrect_pos,error_bar_incorrect_pos,'Color','k','Marker','none','LineWidth',1);hold on;
    
    %     errorbar(location+8,means_correct_diff,error_bar_correct_diff,'Color','k','Marker','none','LineWidth',1.5,'LineStyle','none');hold on;
    %     errorbar(location+10,means_incorrect_diff,error_bar_incorrect_diff,'Color','k','Marker','none','LineWidth',1.5,'LineStyle','none');hold on;
    
    bar(1,mean_delta_neg,'FaceColor',color_pink,'LineWidth',1.5,'EdgeColor',color_pink);hold on;
    bar(2.4,mean_delta_pos,'FaceColor',[0.5 0.5 0.5],'LineWidth',1.5,'EdgeColor',[0.5 0.5 0.5]);hold on;
    
    
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
    set(gca,'XTickLabel',{'From neg','From pos'});
    set(gca,'XTickLabelRotation',35);
    set(gca,'FontSize',8);
    
    %xlim([0 9]);
    xlim([0 3.4]);
    
    yl=ylabel('Delta');
    
    tit=title([num2str(location),'-',plotTitle]);
    set(tit,'FontName','Arial','FontSize',8,'FontAngle','Italic');
    set(gcf,'color',[1 1 1]);
    set(yl,'FontName','Arial','FontSize',8);
    
end

%1.4. Testing

warning off

[h1,p1]=lillietest(total_delta_neg,'alpha',0.001);[h2,p2]=lillietest(total_delta_pos,'alpha',0.001);
disp(['delta lilliefors min p=',num2str(min(p1,p2)),' max h=',num2str(max(h1,h2)),' (non-gauss if h=1, p<0.05)']),
[h1,p1]=kstest(total_delta_neg,'alpha',0.001);[h2,p2]=kstest(total_delta_pos,'alpha',0.001);
disp(['delta ks min p=',num2str(min(p1,p2)),' max h=',num2str(max(h1,h2)),' (non-gauss if h=1, p<0.05)']),
[p,h,stats]=ranksum(total_delta_neg,total_delta_pos,'tail','left');
disp(['delta negative vs pos W=',num2str(stats.ranksum),', p=',num2str(p),', n=',num2str(length(total_delta_neg)),', h=',num2str(h),' (h=1 for unequal means)']),
[h,p,~,stats]=ttest2(total_delta_neg,total_delta_pos);
disp(['delta negative vs pos T=',num2str(stats.tstat),', p=',num2str(p),', df=',num2str(stats.df),', h=',num2str(h),' (h=1 for unequal means)']),
[p,h,stats] = signrank(total_delta_neg,total_delta_pos');
disp(['delta negative vs pos R=',num2str(stats.signedrank),', p=',num2str(p),', n=',num2str(length(total_delta_neg)),', h=',num2str(h),' (h=1 for unequal means)']),

%Testing manova
[bins1,pairs1]=size(matrix_delta_pos);
[bins2,pairs2]=size(matrix_delta_neg);
bins=min(bins1,bins2);pairs=min(pairs1,pairs2);
total_corr=[matrix_delta_neg(1:bins,:)';matrix_delta_pos(1:bins,:)'];

%remove columns (triplets or pairs of neurons) with Nans in at least a bin. That enables matlab
%to run manova

total_corr_aux=[];flag=0;
for i=1:bins
    if ~any(isnan(total_corr(:,i)))
        total_corr_aux=[total_corr_aux,total_corr(:,i)];
        flag=1;
    end
end
total_corr=total_corr_aux;
index_trial_corr=[ones(pairs,1);zeros(pairs,1)];
if flag
    try
        [d,p,stats] = manova1(total_corr,index_trial_corr);
    catch
        orto_total_corr=orth(total_corr);
        
        [d,p,stats] = manova1(orto_total_corr,index_trial_corr);
        warning('Orthogonalised matrix')
    end
    
    disp(['noisecorrel manova where DIMENSIONS ARE BINS pos vs neg groups: Chi2=',num2str(stats.chisq),...
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
