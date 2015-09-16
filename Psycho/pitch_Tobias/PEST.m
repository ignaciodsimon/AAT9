%% PEST function : [step, nrereversals,results,turns] = PEST(delta_f,useranswer,turns,target,results)
% the function returns a step for the frequency discriminating (between f0 and f0 + delta_f ) test, using PEST algorithm. 
% define a initial delta_f in the main program, and at each iteration new_delta_f = delta_f + step.



function [step, nreversals,results,turns] = PEST(delta_f,useranswer,turns,target,results)
%



A = sum(useranswer) / length(useranswer); %   ->   % of good answers
disp('% of good answers = '); disp(A*100);

%%
if (A<target) %below
    step = delta_f/2; %higher delta
    
    if (isempty(results))
    results = 0;
    else
    results = [results, 0];
    end;
    disp('lower than 75%');disp('higher delta...');disp('results = ');(disp(results));
    
elseif(A >= target); %above
    step = -delta_f/2; %lower delta
     if (isempty(results))
    results = 1;
     else
    results = [results, 1];
     end;
        disp('higher than 75%');disp('lower delta...');disp('results = ');(disp(results));

end;
%%

if(isempty(turns))
        turns = 0;
end;

if(length(results) > 1)
    
if(results(length(results)) ~= results(length(results)-1))
    % IF THE TWO LASTS ARE DIFFERENT
    turns = [turns , 1];
    
    
    if ( length(turns) > 2)
        disp('more than 2 sets...')
        if ( turns(length(turns)) == 1 )
            disp('and a reversal... modif x0.5 !');
            step = step * 0.5;
            
        end
    end 
else % IF TWO LAST ARE SAME
    
    turns = [turns , 0]; % no returns
   
    if ( length(turns) > 2)    
                disp('more than two sets...')
        if ( turns(length(turns) -1) == 0 ) && ( turns(length(turns)- 2) == 0 )
            disp('and the two lasts were in the same direction... modif x2 !');
            step = step * 1.5;
            
            
            
            
        end
    end;
end;
end;


disp('nb of turns = '); disp(turns);

nreversals = sum(turns);
disp('number of reversals : ');disp(nreversals);

end

