function Ordered=renumTrials(DataSet)
%Renumber the column end-1 such trials are correlative. See batch files
[n,~]=size(DataSet);
Ordered=DataSet;
trial=1;
Ordered(1,end-1)=trial;
for i=2:n
    if DataSet(i,end-1)~=DataSet(i-1,end-1)
        trial=trial+1;
    end
    Ordered(i,end-1)=trial;
end   
        