%Batch script summarizing results. Used to generate figures 6, 7, S9 in
%Balaguer-Ballester, E., Nogueira, R., Abofalia, J.M., Moreno-Bote, R. Sanchez-Vives, M.V., 2020. Representation of Foreseeable Choice Outcomes in Orbitofrontal Cortex Triplet-wise Interactions. Plos Computational Biology, 16(6): e1007862.
clear;clc;%close all;
period=1;%Period within the trial 
%warning('off','all')
% 
%An example
files_afterCorrect_i={'Aug_Raw_BasicAnalyses_incorrect_seven_files_-2640 trials_files_order corr_3_AfterCorrect.mat'};
files_afterCorrect_c={'Aug_Raw_BasicAnalyses_correct_seven_files_-2640 trials_files_order corr_3_AfterCorrect.mat'};
files_afterIncorrect_c={'Aug_Raw_BasicAnalyses_correct_seven_files_-2640 trials_files_order corr_3_AfterIncorrect.mat'};
files_afterIncorrect_i={'Aug_Raw_BasicAnalyses_incorrect_seven_files_-2640 trials_files_order corr_3_AfterIncorrect.mat'};


% files_afterCorrect_c={'Resid_BasicAnalyses_correct_seven_files_order corr_2_AfterCorrect.mat'};
% files_afterCorrect_i={'Resid_BasicAnalyses_incorrect_seven_files_order corr_2_AfterCorrect.mat'};
% files_afterIncorrect_c={'Resid_BasicAnalyses_correct_seven_files_order corr_2_AfterIncorrectRealistic.mat'};
% files_afterIncorrect_i={'Resid_BasicAnalyses_incorrect_seven_files_order corr_2_AfterIncorrectRealistic.mat'};


% files_afterCorrect_c={'March19_BasicAnalyses_correct_seven_files_order corr_2_AfterCorrect.mat'};
% files_afterCorrect_i={'March19_BasicAnalyses_incorrect_seven_files_order corr_2_AfterCorrect.mat'};
% files_afterIncorrect_c={'March19_BasicAnalyses_correct_seven_files_order corr_2_AfterIncorrectRealistic.mat'};
% files_afterIncorrect_i={'March19_BasicAnalyses_incorrect_seven_files_order corr_2_AfterIncorrectRealistic.mat'};

for i=1:length(files_afterCorrect_c)
    figure
    plotPosition=1;plotTitle='After correct';
    [total_correct_pos1,total_correct_neg1,total_incorrect_pos1,total_incorrect_neg1]=basicStatsCorrelSign(...
        files_afterCorrect_c{i},files_afterCorrect_i{i},plotPosition,period,plotTitle);
    plotPosition=2;plotTitle='After incorrect';
    [total_correct_pos2,total_correct_neg2,total_incorrect_pos2,total_incorrect_neg2]=basicStatsCorrelSign(...
        files_afterIncorrect_c{i},files_afterIncorrect_i{i},plotPosition,period,plotTitle);
    set (gcf,'Name','Seven files norm to one');
    
    %Testing, for now only corrects after correct and incorrect.
    disp('______________________________________________________________________')
    disp(' ')
    disp('*********Only correct choice:***********')
    [h1,p1]=lillietest(total_correct_neg1,'alpha',0.001);[h2,p2]=lillietest(total_correct_neg2,'alpha',0.001);
    [h3,p3]=lillietest(total_correct_pos1,'alpha',0.001);[h4,p4]=lillietest(total_correct_pos2,'alpha',0.001);
    disp(['noisecorrel correct, lilliefors min p=',num2str(min([p1,p2,p3,p4])),' max h=',num2str(max([h1,h2,h3,h4])),' (non-gauss if h=1, p<0.05)']),
    [p,h,stats]=ranksum(total_correct_neg1,total_correct_neg2);
    disp(['noisecorrel negative correct after-correct vs after-incorrect W=',num2str(stats.ranksum),', p=',num2str(p),', n=',num2str(length(total_correct_neg1)),', h=',num2str(h),' (h=1 for unequal means)']),
    [h,p,~,stats]=ttest2(total_correct_neg1,total_correct_neg2);
    disp(['noisecorrel negative correct after-correct vs after-incorrect T=',num2str(stats.tstat),', p=',num2str(p),', df=',num2str(stats.df),', h=',num2str(h),' (h=1 for unequal means)']),
    [p,h,stats] = signrank(total_correct_neg1,total_correct_neg2);
    disp(['noisecorrel negative correct after-correct vs after-incorrect R=',num2str(stats.signedrank),', p=',num2str(p),', n=',num2str(length(total_correct_neg1)),', h=',num2str(h),' (h=1 for unequal means)']),  
    
    [p,h,stats]=ranksum(total_correct_pos1,total_correct_pos2);
    disp(['noisecorrel positive correct after-correct vs after-incorrect W=',num2str(stats.ranksum),', p=',num2str(p),', n=',num2str(length(total_correct_pos1)),', h=',num2str(h),' (h=1 for unequal means)']),
    [h,p,~,stats]=ttest2(total_correct_pos1,total_correct_pos2);
    disp(['noisecorrel positive correct after-correct vs after-incorrect T=',num2str(stats.tstat),', p=',num2str(p),', df=',num2str(stats.df),', h=',num2str(h),' (h=1 for unequal means)']),
    [p,h,stats] = signrank(total_correct_pos1,total_correct_pos2);
    disp(['noisecorrel positive correct after-correct vs after-incorrect R=',num2str(stats.signedrank),', p=',num2str(p),', n=',num2str(length(total_correct_neg1)),', h=',num2str(h),' (h=1 for unequal means)']),

    
    %Plotting, only correct
    mean_correct_neg1=nanmean(total_correct_neg1);
    error_bar_correct_neg1=nanstd(total_correct_neg1)/sqrt(length(total_correct_neg1));
    mean_correct_pos1=nanmean(total_correct_pos1);
    error_bar_correct_pos1=nanstd(total_correct_pos1)/sqrt(length(total_correct_pos1));
    mean_correct_neg2=nanmean(total_correct_neg2);
    error_bar_correct_neg2=nanstd(total_correct_neg2)/sqrt(length(total_correct_neg2));
    mean_correct_pos2=nanmean(total_correct_pos2);
    error_bar_correct_pos2=nanstd(total_correct_pos2)/sqrt(length(total_correct_pos2));
    
    subplot(5,2,9)
    errorbar(1,-mean_correct_neg1,error_bar_correct_neg1,'Color',[0 0 .7],'Marker','none','LineWidth',1.5);hold on;
    errorbar(2.4,-mean_correct_neg2,error_bar_correct_neg2,'Color',[0 0 .7],'Marker','none','LineWidth',1.5);hold on;
    bar(1,-mean_correct_neg1,'FaceColor',[1,1,0],'LineWidth',2,'EdgeColor',[0 0 .7]);hold on;
    bar(2.4,-mean_correct_neg2,'FaceColor',[1,1,0],'LineWidth',2,'EdgeColor',[0 0 .7]);hold on;
    errorbar(4,mean_correct_pos1,error_bar_correct_pos1,'Color',[0 0 .7],'Marker','none','LineWidth',1.5);hold on;
    errorbar(5.4,mean_correct_pos2,error_bar_correct_pos2,'Color',[0 0 0.7],'Marker','none','LineWidth',1.5);hold on;
    bar(4,mean_correct_pos1,'FaceColor','none','LineWidth',2,'EdgeColor',[0 0 0.7]);hold on;
    bar(5.4,mean_correct_pos2,'FaceColor','none','LineWidth',2,'EdgeColor',[0 0 0.7]);hold on;
    set(gca,'XTick',[1 2.4 4 5.4]);
    set(gca,'XTickLabel',{'After Corr.','After Incorr.','After Corr.','After Incorr.'});
    set(gca,'XTickLabelRotation',45);
    xlim([0 6])
    tit=title('Correct choice');
    set(tit,'FontName','Arial','FontSize',10,'Color',[0 0 .7]);
    
     disp(' ')
    disp('*********Only incorrect choice:***********')
      %Testing, for now only incorrects after correct and incorrect.
    [h1,p1]=lillietest(total_incorrect_neg1,'alpha',0.001);[h2,p2]=lillietest(total_incorrect_neg2,'alpha',0.001);
    [h3,p3]=lillietest(total_incorrect_pos1,'alpha',0.001);[h4,p4]=lillietest(total_incorrect_pos2,'alpha',0.001);
    disp(['noisecorrel incorrect, lilliefors min p=',num2str(min([p1,p2,p3,p4])),' max h=',num2str(max([h1,h2,h3,h4])),' (non-gauss if h=1, p<0.05)']),
    [p,h,stats]=ranksum(total_incorrect_neg1,total_incorrect_neg2);
    disp(['noisecorrel negative incorrect after-correct vs after-incorrect W=',num2str(stats.ranksum),', p=',num2str(p),', n=',num2str(length(total_incorrect_neg1)),', h=',num2str(h),' (h=1 for unequal means)']),
    [h,p,~,stats]=ttest2(total_incorrect_neg1,total_incorrect_neg2);
    disp(['noisecorrel negative incorrect after-correct vs after-incorrect T=',num2str(stats.tstat),', p=',num2str(p),', df=',num2str(stats.df),', h=',num2str(h),' (h=1 for unequal means)']),
    [p,h,stats]=ranksum(total_incorrect_pos1,total_incorrect_pos2);
    disp(['noisecorrel positive incorrect after-correct vs after-incorrect W=',num2str(stats.ranksum),', p=',num2str(p),', n=',num2str(length(total_incorrect_pos1)),', h=',num2str(h),' (h=1 for unequal means)']),
    [h,p,~,stats]=ttest2(total_incorrect_pos1,total_incorrect_pos2);
    disp(['noisecorrel positive incorrect after-correct vs after-incorrect T=',num2str(stats.tstat),', p=',num2str(p),', df=',num2str(stats.df),', h=',num2str(h),' (h=1 for unequal means)']),
    
    
    %Plotting, only incorrect
    mean_incorrect_neg1=nanmean(total_incorrect_neg1);
    error_bar_incorrect_neg1=nanstd(total_incorrect_neg1)/sqrt(length(total_incorrect_neg1));
    mean_incorrect_pos1=nanmean(total_incorrect_pos1);
    error_bar_incorrect_pos1=nanstd(total_incorrect_pos1)/sqrt(length(total_incorrect_pos1));
    mean_incorrect_neg2=nanmean(total_incorrect_neg2);
    error_bar_incorrect_neg2=nanstd(total_incorrect_neg2)/sqrt(length(total_incorrect_neg2));
    mean_incorrect_pos2=nanmean(total_incorrect_pos2);
    error_bar_incorrect_pos2=nanstd(total_incorrect_pos2)/sqrt(length(total_incorrect_pos2));
    
    subplot(5,2,10)
    errorbar(1,-mean_incorrect_neg1,error_bar_incorrect_neg1,'Color',[0 0 0],'Marker','none','LineWidth',1.5);hold on;
    errorbar(2.4,-mean_incorrect_neg2,error_bar_incorrect_neg2,'Color',[0 0 0],'Marker','none','LineWidth',1.5);hold on;
    bar(1,-mean_incorrect_neg1,'FaceColor',[1,1,0],'LineWidth',2,'EdgeColor',[0 0 0]);hold on;
    bar(2.4,-mean_incorrect_neg2,'FaceColor',[1,1,0],'LineWidth',2,'EdgeColor',[0 0 0]);hold on;
    errorbar(4,mean_incorrect_pos1,error_bar_incorrect_pos1,'Color',[0 0 0],'Marker','none','LineWidth',1.5);hold on;
    errorbar(5.4,mean_incorrect_pos2,error_bar_incorrect_pos2,'Color',[0 0 0],'Marker','none','LineWidth',1.5);hold on;
    bar(4,mean_incorrect_pos1,'FaceColor','none','LineWidth',2,'EdgeColor',[0 0 0]);hold on;
    bar(5.4,mean_incorrect_pos2,'FaceColor','none','LineWidth',2,'EdgeColor',[0 0 0]);hold on;
    set(gca,'XTick',[1 2.4 4 5.4]);
    set(gca,'XTickLabel',{'After Corr.','After Incorr.','After Corr.','After Incorr.'});
    set(gca,'XTickLabelRotation',45);
    xlim([0 6])
    tit=title('Incorrect choice');
    set(tit,'FontName','Arial','FontSize',10,'Color',[0 0 0]);
    
    
end
%warning('on','all')

