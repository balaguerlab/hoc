    function plotLines(tone1_1,tone1_2,tone2_1,tone2_2,values,times,style1,width1,style2,width2,color1,color2)
    %Plot onset and offset of the tones
    %offset of the second tone colour and style
    %by Emili Balaguer-Ballester. Comput neuro lab. Interdisiciplinary Neurosci Research Centre.
    %Faculty of Science and Technology, Bournemouth University
    %April 2020
     if nargin<11, color1=[1 0.6 0.6]; color2=[1 0.6 0.6];  end %Just for the second tone
     if nargin<7, style2=':'; style1='-'; width1=4; width2=1; end 
   
        line([times(tone1_1),times(tone1_1)],[0,max(values)],'LineStyle','-','Color',[0.6 0.6 0.6],'LineWidth',4),
        line([times(tone1_2),times(tone1_2)],[0,max(values)],'LineStyle',':','Color',[0.6 0.6 0.6],'LineWidth',1),
        
        line([times(tone2_1),times(tone2_1)],[0,max(values)],'LineStyle',style1,'Color',color1,'LineWidth',width1),
        line([times(tone2_2),times(tone2_2)],[0,max(values)],'LineStyle',style2,'Color',color2,'LineWidth',width2),
        
        xlim([0 max(times)]),
    end