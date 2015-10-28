%Table I. Cumulative preference matrix (N = 60). Note. Absolute
%frequencies are given with which the sound in the row was judged
%to be more unpleasant than the sound in the column. Sounds: 1 -
%truck, 2 - brake, 3 - train, 4 - water, 5 - boat, 6 - jackhammer, 7 -
%mower, 8 - crash, 9 - mixer, 10 - vent.

A = {[1];[2];[3];[4];[5];[6];[7];[8];[9];[10]};

unpleasant=[0 9 16 45 56 5 29 6 24 33
            51 0 34 58 58 13 46 30 39 50
            44 26 0 55 57 9 48 37 38 55
            15 2 5 0 38 2 17 6 6 20
            4 2 3 22 0 3 6 3 3 12
            55 47 51 58 57 0 58 53 55 57
            31 14 12 43 54 2 0 16 17 41
            54 30 23 54 57 7 44 0 40 52
            36 21 22 54 57 5 43 20 0 43
            27 10 5 40 48 3 19 8 17 0];

[p, chistat] = fOptiPt(unpleasant, A)

%%Check for stochastic transitivity:

%First compute the different percentages:
unpleasant_percentages = unpleasant ./60

%% Now traverse through matrix to check for weak stochastic transitivity:
wst = 0;
j = 1;

for j = 1 : 10
    
    for i = 1 : 10
        
        if unpleasant_percentages(i,j) > 0.5
            
            k = i;
            
                for m = 1 : 10

                     if unpleasant_percentages(m,k) > 0.5

                         p = m;
                         

                            if unpleasant_percentages(p,j) > 0.5
                                wst = wst + 1;

                            end
                     end
                end
        end
    end
end


%% Now traverse through matrix to check for moderate stochastic transitivity:
mst = 0;
j = 1;

for j = 1 : 10
    
    for i = 1 : 10
        
        if unpleasant_percentages(i,j) > 0.5
            
            k = i;
            
                for m = 1 : 10

                     if unpleasant_percentages(m,k) > 0.5

                         p = m;

                            if unpleasant_percentages(m,i)
                                mst = mst + 1;

                            end
                     end
                end
        end
    end
end














