clear;clc;
%warning('off','all')
% Differential correlation is the index described in the supplementary
% material, see also figure S5
%Examples below 
 period=2;%Select the specific trial period
 do_extra_plots=0;
 
files_afterCorrect_i={'Aug_Raw_BasicAnalyses_incorrect_seven_files_-2640 trials_files_order corr_3_AfterCorrect.mat'};
files_afterCorrect_c={'Aug_Raw_BasicAnalyses_correct_seven_files_-2640 trials_files_order corr_3_AfterCorrect.mat'};
files_afterIncorrect_c={'Aug_Raw_BasicAnalyses_correct_seven_files_-2640 trials_files_order corr_3_AfterIncorrect.mat'};
files_afterIncorrect_i={'Aug_Raw_BasicAnalyses_incorrect_seven_files_-2640 trials_files_order corr_3_AfterIncorrect.mat'}; 
init_subplot_index=3;order=3;

for i=1:length(files_afterCorrect_c)
    if do_extra_plots
        figure
    end
    plotLocation=1;plotTitle='Discriminative signal-After correct';
    [total_delta_pos1,total_delta_neg1]=diffCorr(...
        files_afterCorrect_c{i},files_afterCorrect_i{i},plotLocation,period,plotTitle,do_extra_plots);
    
    if do_extra_plots
        plotLocation=2;plotTitle='Discriminative signal-After incorrect';
        set (gcf,'Name','Seven files norm to one');
    end
    [total_delta_pos2,total_delta_neg2]=diffCorr(...
        files_afterIncorrect_c{i},files_afterIncorrect_i{i},plotLocation,period,plotTitle,do_extra_plots);
    
    %Testing, for now only corrects after correct and incorrect.
    disp('______________________________________________________________________')
    disp(' ')
    disp('*********Comparing trial types:***********')
    [h1,p1]=lillietest(total_delta_neg1,'alpha',0.001);[h2,p2]=lillietest(total_delta_neg2,'alpha',0.001);
    [h3,p3]=lillietest(total_delta_pos1,'alpha',0.001);[h4,p4]=lillietest(total_delta_pos2,'alpha',0.001);
        disp(['noisecorrel delta, lilliefors min p=',num2str(min([p1,p2,p3,p4])),' max h=',num2str(max([h1,h2,h3,h4])),' (non-gauss if h=1, p<0.05)']),
        [p,h,stats]=ranksum(total_delta_neg1,total_delta_neg2);
        disp(['Delta from negative corr: after-correct vs after-incorrect W=',num2str(stats.ranksum),', p=',num2str(p),', n=',num2str(length(total_delta_neg1)),', h=',num2str(h),' (h=1 for unequal means)']),
        [h,p,~,stats]=ttest2(total_delta_neg1,total_delta_neg2);
        disp(['Delta from negative corr: after-correct vs after-incorrect T=',num2str(stats.tstat),', p=',num2str(p),', df=',num2str(stats.df),', h=',num2str(h),' (h=1 for unequal means)']),
        [p,h,stats] = signrank(total_delta_neg1,total_delta_neg2);
        disp(['Delta from negative corr: after-correct vs after-incorrect R=',num2str(stats.signedrank),', p=',num2str(p),', n=',num2str(length(total_delta_neg1)),', h=',num2str(h),' (h=1 for unequal means)']),
        
        [p,h,stats]=ranksum(total_delta_pos1,total_delta_pos2);
        disp(['Delta from pos corr: after-correct vs after-incorrect W=',num2str(stats.ranksum),', p=',num2str(p),', n=',num2str(length(total_delta_pos1)),', h=',num2str(h),' (h=1 for unequal means)']),
        [h,p,~,stats]=ttest2(total_delta_pos1,total_delta_pos2);
        disp(['Delta from pos corr: after-correct vs after-incorrect T=',num2str(stats.tstat),', p=',num2str(p),', df=',num2str(stats.df),', h=',num2str(h),' (h=1 for unequal means)']),
        [p,h,stats] = signrank(total_delta_pos1,total_delta_pos2);
        disp(['Delta from pos corr: after-correct vs after-incorrect R=',num2str(stats.signedrank),', p=',num2str(p),', n=',num2str(length(total_delta_neg1)),', h=',num2str(h),' (h=1 for unequal means)']),
        
        disp('*********Comparing relative deltas (pos-neg):***********')
        
        corr_compare1=[total_delta_pos1',total_delta_neg1']';deno1=max(corr_compare1);
        corr_compare2=[total_delta_pos2',total_delta_neg2']';deno2=max(corr_compare2);
        
        rel_delta1=(total_delta_pos1-total_delta_neg1)';
        rel_delta2=(total_delta_pos2-total_delta_neg2)';
          
        [h1,p1]=lillietest(rel_delta1,'alpha',0.001);[h2,p2]=lillietest(rel_delta2,'alpha',0.001);
        disp(['noisecorrel delta, lilliefors min p=',num2str(min([p1,p2])),' max h=',num2str(max([h1,h2])),' (non-gauss if h=1, p<0.05)']),
        [p,h,stats]=ranksum(rel_delta1,rel_delta2);
        disp(['Rel. delta (delta pos-delta neg): after-correct vs after-incorrect W=',num2str(stats.ranksum),', p=',num2str(p),', n=',num2str(length(total_delta_neg1)),', h=',num2str(h),' (h=1 for unequal means)']),
        [h,p,~,stats]=ttest2(rel_delta1,rel_delta2);
        disp(['Rel. delta (delta pos-delta neg): after-correct vs after-incorrect T=',num2str(stats.tstat),', p=',num2str(p),', df=',num2str(stats.df),', h=',num2str(h),' (h=1 for unequal means)']),
        [p,h,stats] = signrank(rel_delta1,rel_delta2);
        disp(['Rel. delta (delta pos-delta neg): after-correct vs after-incorrect R=',num2str(stats.signedrank),', p=',num2str(p),', n=',num2str(length(total_delta_neg1)),', h=',num2str(h),' (h=1 for unequal means)']),
    
        %Plotting, new figure
        if do_extra_plots
            hold off
            figure
            
            mean_delta_neg1=nanmean(total_delta_neg1);
            error_bar_delta_neg1=nanstd(total_delta_neg1)/sqrt(length(total_delta_neg1));
            mean_delta_pos1=nanmean(total_delta_pos1);
            error_bar_delta_pos1=nanstd(total_delta_pos1)/sqrt(length(total_delta_pos1));
            mean_delta_neg2=nanmean(total_delta_neg2);
            error_bar_delta_neg2=nanstd(total_delta_neg2)/sqrt(length(total_delta_neg2));
            mean_delta_pos2=nanmean(total_delta_pos2);
            error_bar_delta_pos2=nanstd(total_delta_pos2)/sqrt(length(total_delta_pos2));
            
            color_pink=[255,153,200]./255;
            color_grey=[0.7 0.7 0.7];
            
            subplot(2,3,period)
            errorbar(1,-mean_delta_neg1,error_bar_delta_neg1,'Color',color_pink,'Marker','none','LineWidth',1.5);hold on;
            errorbar(2.4,-mean_delta_neg2,error_bar_delta_neg2,'Color',color_pink,'Marker','none','LineWidth',1.5);hold on;
            bar(1,-mean_delta_neg1,'FaceColor',color_pink,'LineWidth',2,'EdgeColor',color_pink);hold on;
            bar(2.4,-mean_delta_neg2,'FaceColor',color_pink,'LineWidth',2,'EdgeColor',color_pink);hold on;
            errorbar(4,mean_delta_pos1,error_bar_delta_pos1,'Color',color_grey,'Marker','none','LineWidth',1.5);hold on;
            errorbar(5.4,mean_delta_pos2,error_bar_delta_pos2,'Color',color_grey,'Marker','none','LineWidth',1.5);hold on;
            bar(4,mean_delta_pos1,'FaceColor','none','LineWidth',2,'EdgeColor',color_grey);hold on;
            bar(5.4,mean_delta_pos2,'FaceColor','none','LineWidth',2,'EdgeColor',color_grey);hold on;
            set(gca,'XTick',[1 2.4 4 5.4]);
            set(gca,'XTickLabel',{'After Corr.','After Incorr.','After Corr.','After Incorr.'});
            set(gca,'XTickLabelRotation',45);
            xlim([0 6])
            tit=title(['PERIOD ',num2str(period),' Delta comparisons']);
            set(tit,'FontName','Arial','FontSize',10,'Color','k');
        end
    
    %Always plotting, the summary figure
    
    
    set(gcf,'color',[1 1 1]);
    
    init_color=[237,164,16]./255;
    stim_color=[217,83,25]./255;
    choice_color=[162,20,47]./255;
    periods_colors=[init_color;stim_color;choice_color];
    
    mean_rel_delta1=nanmean(rel_delta1);
    error_bar_rel_delta1=nanstd(rel_delta1)/sqrt(length(rel_delta1));
    mean_rel_delta2=nanmean(rel_delta2);
    error_bar_rel_delta2=nanstd(rel_delta2)/sqrt(length(rel_delta2));
    
    subplot_index=init_subplot_index+period;
    subplot(3,3,subplot_index)
    errorbar(1,mean_rel_delta1,error_bar_rel_delta1,'Color','k','Marker','none','LineWidth',1.5);hold on;
    errorbar(2.4,mean_rel_delta2,error_bar_rel_delta2,'Color','k','Marker','none','LineWidth',1.5);hold on;
    bar(1,mean_rel_delta1,'FaceColor','none','LineWidth',2,'EdgeColor','k');hold on;
    bar(2.4,mean_rel_delta2,'FaceColor','k','LineWidth',2,'EdgeColor','none');hold on;
    
    set(gca,'XTick',[1 2.4],'XColor',periods_colors(period,:),'YColor',periods_colors(period,:));
    set(gca,'XTickLabel',{'Unpredictable','Predictable'});
    set(gca,'XTickLabelRotation',45);
    xlim([0 3])
    %yl=ylabel([{'$\Delta \delta(\theta=$',num2str(order),'$)$'}],'Interpreter','latex','FontSize',10);
    yl=ylabel({'$\Delta \delta(\theta=3)$'},'Interpreter','latex','FontSize',10);
    set(yl,'Color','k')
    if period==1
        %tit=title(['PERIOD ',num2str(period),' Relative delta comparisons (delta pos-delta neg)']);
        tit=title('Initiation');
    elseif period==2
        tit=title('Stimulus');
    else
        tit=title('Choice');
    end
    set(tit,'FontName','Arial','FontSize',10,'Color',periods_colors(period,:));
end
hold on
%warning('on','all')








