function [a] = substr(input)
    j=2;
    a =[];
    while 0
        for i=1:length(input)-j+1 
            a= [a input(i:i+j)];
        end
        if j== ceil(length(input)/2)
            break;
        end
        j= j+1;
     end
end

