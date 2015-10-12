

close all
clc

run facial_expressions_mds.m;

[n,~] = size(facial); %number of points


% stress = zeros(1,n-1);
% 
% for j=1:n-1 
% ndim = j; %number of dimensions
% [Y,stress(j)] = mdscale(facial,ndim);
% end
% 
% figure()
% plot(1:n-1,stress);
% xlabel('number of dimensions');ylabel('stress');


%
ndim = 3
[Y,stress,disparities] = mdscale(facial,ndim);


%labels = cellstr( num2str([1:n]') );  
labels = {'grief at death', 'savouring a coke', 'pleasant surprise', 'maternal love', 'physical exhaustion', 'smthing wrong with plane', 'anger', 'pulling hard', ...
    'unexpectedly meets old boyfriend', 'revulsion', 'extrm pain', 'knows plane crash', 'light sleep' };  


figure()

U = 2;
V = 3;

plot(Y(:,U),Y(:,V),'o');
xlabel(['dimension ' num2str(U)]);ylabel(['dimension ' num2str(V)]);
text(Y(:,U), Y(:,V), labels, 'VerticalAlignment','bottom', ...
                             'HorizontalAlignment','center')
title(['stress = ' num2str(stress) ' for ' num2str(ndim) ' dimensions'],'fontsize',12);


figure()

plot3(Y(:,1),Y(:,2),Y(:,3),'o');
xlabel('dimension 1');ylabel('dimension 2');zlabel('dimension 3');
text(Y(:,1), Y(:,2), Y(:,3), labels, 'VerticalAlignment','bottom', ...
                             'HorizontalAlignment','center')
title(['stress = ' num2str(stress) ' for ' num2str(ndim) ' dimensions'],'fontsize',12);
grid('on')



figure()
dissimilarities = squareform(facial);
 
       % Use non-metric scaling to recreate the data in 2D, and make a
       % Shepard plot of the results.
       [Y,stress,disparities] = mdscale(dissimilarities,3);
       distances = pdist(Y);
       [dum,ord] = sortrows([disparities(:) dissimilarities(:)]);
       plot(dissimilarities,distances,'bo', ...
            dissimilarities(ord),disparities(ord),'r.-');
       xlabel('Dissimilarities'); ylabel('Distances/Disparities')
