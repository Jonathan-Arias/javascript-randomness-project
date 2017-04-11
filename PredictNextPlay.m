function [nextItem, predictionConfidence] = ...
    PredictNextPlay (series, isLoseTieWin, possibleEntries)
% function [nextItem, predictionConfidence] = ...
%     PredictNextPlay (series, isLoseTieWin)
% 
% Predict the most likely next play given a series of the previous plays
% and (optional) whether they resulted in a win/loss/tie. The series is in
% {1,...,M}^N, where N is the length of the series and M the cardinality of
% each item. 'nextItem' is the function's prediction.
% 'predictionConfidence' is the degree of confidence in the selection of
% the next item.
% The prediction is based on the conditional probabilities of all the
% possible next moves given the history of moves ('series') and,
% optionally, wins ('isLoseTieWin' 1/2/3 for lose/tie/win). The possibility
% that is least likely by chance is the one picked. And the chance level is
% returned as 'predictionConfidence'.

% Unify 'series' and 'isLoseTieWin', first transforming false/true into
% -1/1, respectively, then multiplying that by series to have it all
% positive or negative depending on whether the move resulted in a win or
% loss. 
nLoseTieWinOpts=3;
if ((exist('isLoseTieWin','var'))&&(~isempty(isLoseTieWin)))
    series=nLoseTieWinOpts*(isLoseTieWin-1)+series;
end

maxBack=20; 
% For 'possibleEntries', we only care about the moves and not whether the
% person won or lost (the latter designated by negative number). So we take
% the absolute value.
if (~exist('possibleEntries','var')||isempty(possibleEntries))
    possibleEntries=unique(mod(series-1,nLoseTieWinOpts)+1);
end
nPossibleEntries=length(possibleEntries);
alphaLevel=1/nPossibleEntries;

if (isempty(series))
    noPredict=true; % true when there is equal evidence for false and true
    predictionConfidence=inf; 
else    
    % Convert into a string to use the 'strfind' command that locates
    % patterns in strings. The string is centered around 'm', as characters
    % could be above or below it given the negative entries in 'series'.
    str=char(double('a')+(series)); strLen=length(str);
    % Now look for a pattern 1 to 'max_back' characters backwards and for
    % each length find how many times the player chose one of the optional
    % entries following that pattern
    % We want to avoid overfitting, hence we train on the first half of the
    % string and test on the second half
    n=min(strLen-1,maxBack);
    choice=NaN(n,length(possibleEntries));
    for k=1:n
        i=strfind(str,str(end-k+1:end)); i(end)=[];
        if (isempty(i))
            choice(k:end,:)=0;
            break;
        else
            s=mod(str(i+k)-'a'-1,nLoseTieWinOpts)+1;
            choice(k,:)=hist(s,possibleEntries);
        end
    end
    % Among all the (1,2,...N) distributions of the patterns we searched,
    % we find the one most deviating from 1/nPossibleEntries (according to
    % its binomial cummulative distribution funcion), and store its index
    % into all 'pVals' as 'ind', and predict using it. If 2 or more indices
    % have values equally deviating from 1/nPossibleEntries, we take the
    % longest series (i.e., the one with the largest index. If the chance
    % level of the best prediction is above 1/1/nPossibleEntries, predict
    % at random.  
    pVals=1-binocdf(max(choice,[],2)-1,sum(choice,2),1/nPossibleEntries);
    predictionConfidence=min(pVals);
    noPredict=(isempty(predictionConfidence)||...
        (predictionConfidence>=alphaLevel)); 
    if (isempty(predictionConfidence))
        predictionConfidence=inf; 
    else
        ind=find(pVals==predictionConfidence,1,'last');
    end
end
if (noPredict)
    nextItem=ceil(rand*nPossibleEntries); 
else
    [~,iNextItem]=max(choice(ind,:));
    nextItem=possibleEntries(iNextItem);
end
end
