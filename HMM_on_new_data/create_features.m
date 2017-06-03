% Data Importation and Variable Creation

function [pattern_data] = create_features()

%Read the data
[num, text,pattern_data] = xlsread('/home/csgrads/ssand024/Desktop/n-back/lameback-data/patternN2toN6_TapbackOnly.xlsx');

newCellCols = cell(size(pattern_data,1),11);

newCellCols{1,1} = 'Target';
newCellCols{1,2} = 'backwardAttractor';
newCellCols{1,3} = 'forwardAttractor';
newCellCols{1,4} = 'bothAttractors';
newCellCols{1,5} = 'backwardLure';
newCellCols{1,6} = 'forwardLure';
newCellCols{1,7} = 'bothLures';
newCellCols{1,8} = 'numColors';
newCellCols{1,9} = 'nLevel';
newCellCols{1,10} = 'lastColorUnique';
newCellCols{1,11} = 'PredictedAccuracy';

pattern_data =[pattern_data newCellCols];

%Creating targets and non-targets
for i=2:size(pattern_data,1)
    thepattern=pattern_data(i,1)
    thepattern= char(thepattern)
     if thepattern(2)==thepattern(end)
         pattern_data{i,4} = 'T';
     else
         pattern_data{i,4} = 'NT';
     end
end

%Create backward attractors
for i=2:size(pattern_data,1)
    thepattern=pattern_data(i,1);
    thepattern= char(thepattern);
     target =  pattern_data{i,4};
     if isequal(target,'T') &&  isequal(thepattern(1),thepattern(end))
         pattern_data{i,5}  = 1;
     else
         pattern_data{i,5} = 0;
     end
end

%Create forward attractors
for i=2:size(pattern_data,1)
    thepattern=pattern_data(i,1);
    thepattern= char(thepattern);
     target =  pattern_data{i,4};
     if isequal(target,'T') &&  isequal(thepattern(3),thepattern(end))
         pattern_data{i,6}  = 1;
     else
         pattern_data{i,6} = 0;
     end
end


%Create both attractors
for i=2:size(pattern_data,1)
    thepattern=pattern_data(i,1);
    thepattern= char(thepattern);
     backwardAttractor =  pattern_data{i,5};
     forwardAttractor =  pattern_data{i,6};
     if isequal(backwardAttractor,1) &&  isequal(forwardAttractor,1)
         pattern_data{i,7}  = 1;
     else
         pattern_data{i,7} = 0;
     end
end


%Create backward lures
for i=2:size(pattern_data,1)
    thepattern=pattern_data(i,1);
    thepattern= char(thepattern);
     if isequal(thepattern(1),thepattern(end))
         pattern_data{i,8}  = 1;
     else
         pattern_data{i,8} = 0;
     end
end

%Create forward lures
for i=2:size(pattern_data,1)
    thepattern=pattern_data(i,1);
    thepattern= char(thepattern);
     if isequal(thepattern(3),thepattern(end))
         pattern_data{i,9}  = 1;
     else
         pattern_data{i,9} = 0;
     end
end


%Create bidirectional lures
for i=2:size(pattern_data,1)
     backwardlure =  pattern_data{i,8};
     forwardlure =  pattern_data{i,9};
     if isequal(backwardlure,1) &&  isequal(forwardlure,1)
         pattern_data{i,10}  = 1;
     else
         pattern_data{i,10} = 0;
     end
end

%Count Number of Colors in the Pattern
for i=2:size(pattern_data,1)
    thepattern=pattern_data(i,1);
    thepattern= char(thepattern);
    pattern_data{i,11}= length(unique(thepattern));
end

%Get N level
for i=2:size(pattern_data,1)
    thepattern=pattern_data(i,1);
    thepattern= char(thepattern);
    pattern_data{i,12}= length(thepattern)-2;
end

%Find if Last Color is Unique
for i=2:size(pattern_data,1)
    thepattern=pattern_data(i,1);
    thepattern= char(thepattern);
    lastcolor= thepattern(end);
    allcolors = thepattern(1:end-1);
    if sum(find(lastcolor== allcolors)) == 0 %if unique
        pattern_data{i,13}= 1;
    else
        pattern_data{i,13}= 0;
    end
end
save('pattern_data.mat','pattern_data');
end
