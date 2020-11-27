 function  plotAllLines(tone1_1,long_tone1_1,tone1_2,long_tone1_2,tone2_1,long_tone2_1,tone2_2,long_tone2_2,values,times,movement)
%by Emili Balaguer-Ballester. Comput neuro lab. Interdisiciplinary Neurosci Research Centre.
%Faculty of Science and Technology, Bournemouth University
%April 2020
        plotLines(tone1_1,tone1_2,tone2_1,tone2_2,values,times);
        plotLines(long_tone1_1,long_tone1_2,long_tone2_1,long_tone2_2,values,times,'-',4,':',1,[.6 .6 1],[.6 .6 1]);
        line([times(movement),times(movement)],[0,max(values)],'LineStyle','-','Color',[0.6 1 0.6],'LineWidth',4),  
    end