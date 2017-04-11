%%% (Synced)
%%% This experiment will have subjects play Rock-Paper-Scissors against a
%%% predicting algorithm to determine whether they are able to "act
%%% randomly". Subjects will do a practice round of generating a random
%%% series of the events "Rock", "Paper" or "Scissors"; they will then run
%%% two blocks of 100 event generations each; they will then practice
%%% playing R-P-S against the computer; followed by two blocks of 100
%%% rounds each of R-P-S playing with the algorithm predicting them;
%%% Group 1 will be unaware of the prediction, Group 2 will be aware;
%%% followed by two more blocks of simple random event generation.

% Rock, paper, scissors gestures images source: http://i.imgur.com/qbHME84.png


%% Setup
rng('shuffle');

%Experiment parameters
% expGroup=randi(3);       %(1 or 2 or 3) 1 FOR UNAWARE GROUP, 2 FOR AWARE, 3 FOR CONTROL
%  Currently there is an imbalance with too many condition-2 participants,
%  because in the first run all pariticapts were condition 2 (we forgot the
%  rng('shuffle') above). So fix this by creating a file where all the
%  number of conditions are kept and counter-balancing until all numbers
%  are even.
load('EvenOutExperimGroups.mat','nExpGroups')
pGroups=max(nExpGroups)-nExpGroups; pGroups=pGroups./sum(pGroups);
iInDraw=find(pGroups>0);
if (isempty(iInDraw))
    % All group sizes are equal, draw randomly
    expGroup=randi(length(nExpGroups));
elseif (length(iInDraw)==1)
    % only one group is smaller to others, take that group
    expGroup=iInDraw;
else
    % 2 groups are smaller than the third
    pGroups=pGroups(pGroups>0);
    if (rand<pGroups(1))
        expGroup=iInDraw(1);
    else
        expGroup=iInDraw(2);
    end
end
nExpGroups(expGroup)=nExpGroups(expGroup)+1;
save('EvenOutExperimGroups.mat','nExpGroups')

numPracticeTrials=10;     %(10)NUMBER OF PRACTICE TRIALS
numTrialsPerBlock=100;%%%%%EVEN ONLY(100)NUMBER OF TRIALS PER BLOCK
debug=false;              %True for debug, False for regular

numBlocks=2;            %(2)NUMBER OF BLOCKS PER CONDITION
numConditions=5;        %(5)NUMBER OF CONDITIONS (PRE-GEN, RPS-RAND, RPS-PREDICTED, RPS-CONT, POST-GEN)
numRPSConditions=3;     %(2)NUMBER OF ACTUAL PLAY CONDITIONS (AGAINST COMPUTER) (RPS-RAND & RPS-PRED)
numPractConditions=2;   %(2)NUMBER OF CONDITIONS WITH A PRACTICE BLOCK (PRE-GEN AND RPS)
textColor=[255 255 255];% White: [255 255 255]
backgroundColor=[150 150 150];
textSize = 40;

tic;
timeStartExp=GetSecs;

% Obtain participant denominator & demographics

subjInfoPrompt={'Please enter your initials (letters only):','Your age (numbers only):',...
    'Your gender (f, m or na):','Last 3 digits of your ID:'};
subjInfoTitle='Enter your information';
subjInfoDefault={'test',num2str(randi(30)),'na','123'};
subjInfo=inputdlg(subjInfoPrompt,subjInfoTitle,1,subjInfoDefault);
subjName=subjInfo{1};
subjAge=str2double(subjInfo{2});
subjGender=subjInfo{3};
subjID=subjInfo{4};

% Short survey about randomness abilities
subjSurveyPrompt={...
    'I am confident that I know what a random sequence is: ',...
    ['I am able to create a long, random sequence of Rock, Paper, and ',...
    'Scissors at will: '],...
    ['I am able to recognize a random sequence of Rock, Paper, and ',...
    'Scissors when I see one: ']};
subjSurveyTitle=sprintf(...
    ['\n\n\n\n\n\nPlease indicate to what degree you agree with the '...
    'following statements\non a scale from 1 to 7, 1 being strongest '...
    'agreement,\n4 being neutral and 7 being strongest disagreement.\n\n'...
    '   1     2     3     4     5     6     7\n'...
    'Strongly          Neutral           Strongly\n'...
    ' Agree                              Disagree\n\n']);
disp(subjSurveyTitle);
subjCreateConfidence=input(subjSurveyPrompt{1});
subjRecognizeConfidence=input(subjSurveyPrompt{2});
subjSequenceConfidence=input(subjSurveyPrompt{3});

% Close if participant doesn't enter a name
if isempty(subjInfo)
    fprintf('%s','Please enter a name. Try again.\n');
    sca;
    
    return
end

if (~debug)
    clear Screen
    ListenChar(2); %makes it so characters typed don?t show up in the command window
    HideCursor(); %hides the cursor
else
    ListenChar(2);
end
KbName('UnifyKeyNames'); %used for cross-platform compatibility of keynaming
KbQueueCreate; %creates queue using defaults

Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference', 'VisualDebugLevel', 1); % get rid of the opening PTB screen
if (debug)
    PsychDebugWindowConfiguration(1,.5); %#ok<*UNRCH> % Make background transparent
end

% Get screen info
screenSize=get(0,'ScreenSize');
if (debug)
    [win, winRect]=Screen('OpenWindow',0,backgroundColor, ...
        round([screenSize(3)*2/3 screenSize(2) screenSize(3) screenSize(4)*2/3]));
else
    [win, winRect]=Screen('OpenWindow',0,backgroundColor); % For corner window: ,...round([screenSize(3)*2/3 screenSize(2) screenSize(3) screenSize(4)*2/3])
end

[width, height] = RectSize(winRect);
halfX = width / 2; halfY = height / 2; quarterX = width/4; quarterY = height/4;...
    threeQuarterX = 3*width/4; threeQuarterY = 3*height/4;
Screen('TextStyle', win, 1); % set font to bold
Screen('TextFont', win, 'Ariel'); % set font to fixed width

%%% Currently   'G' is 'Rock' is 1;
%%%             'H' is 'Paper' is 2;
%%%             'B' is 'Scissors' is 3!

% Load RPS images
numImages=3;
imageData=cell(1,numImages);
imageHandle=zeros(1,numImages);
for b=1:numImages;
    imageData{b}=imread(sprintf('RPSimage%d.png',b));
    imageHandle(b)=Screen('MakeTexture',win, imageData{b});
end
imageHeight=265; % pixel height currently
imageWidth=265; % pixel width currently

% Load Break images
numBreakImages=7;
BreakImageData=cell(1,numBreakImages);
BreakImageHandle=zeros(1,numBreakImages);
for b=1:numBreakImages;
    BreakImageData{b}=imread(sprintf('Breakim%d.png',b));
    BreakImageHandle(b)=Screen('MakeTexture',win, BreakImageData{b});
end
% imageHeight=265; % pixel height currently
% imageWidth=265; % pixel width currently

% Strings
instructionsPartOne=['PART ONE\n\nWelcome!\nThis is Part One of the game.',...
    '\n\nPlease generate a random sequence of the three events\n',...
    '"Rock", "Paper", and "Scissors". \n',...
    'You are asked to press the three buttons (G, H, or B) as randomly as possible.\n',...
    '(Note that:\nthe G key represents "Rock", H key represents "Paper", ',...
    'B key represents "Scissors".)\n\n',...
    'We will begin with a practice round.\n\npress any key when you are ready'];
instructionsPartTwo=['PART TWO\n\nAwesome! Now, let''s play some Rock Paper ',...
    'Scissors against the computer!\n\npress any key when you are ready to ',...
    'begin practice'];
instructionsPartThree=['PART TWO\n\nAwesome! Now, let''s play some Rock '...
    'Paper Scissors against the computer!\nThe computer will try to predict '...
    'which move you will choose next.\nTo win, you will have to play AS '...
    'RANDOMLY AS POSSIBLE!\n\npress any key when you are ready to begin'];
instructionsPartTwoC=['PART TWO\n\nAwesome! Now, let''s play some Rock Paper ',...
    'Scissors against the computer!\n\npress any key when you are ready to ',...
    'begin practice'];
instructionsPartFour=['PART THREE\n\nHope that was fun!\nFinally, your last '...
    'task is to once again generate a random sequence of "Rock", "Paper" '...
    'and "Scissors", as in Part One.\nPlease press the three buttons '...
    '(G, H, or B) as randomly as possible!\n\npress any key when you are ready to begin'];
practiceStringOne=['PRACTICE BLOCK\n\npress G, H, or B for "Rock", "Paper", '...
    'or "Scissors" at the "GO!" signal\n\npress any key to begin'];
threeString='3';
twoString='2';
oneString='1';
goString='GO!';
youString='YOU';
compString='COMPUTER';
tieString='TIE';
winString='YOU WIN!';
loseString='YOU LOSE';
lateString='TOO LATE!';
realString=['Alright!\nYou have finished the practice.\n\n'...
    'If you dare to do the real thing...\n\nPress any key to continue!'];
breakString=['BREAK\n\nPlease enjoy a one minute break.\n\n'...
    'Press any key when you are ready to continue'];
thankString = 'All done!\n\nThank you for participating in this study.';


%Results
keyResultsArray=NaN(numConditions,numBlocks*numTrialsPerBlock);
compResponseArray=NaN(numConditions,numBlocks*numTrialsPerBlock);
timeResultsArray=NaN(numConditions,numBlocks*numTrialsPerBlock);
winResultsArray=NaN(numRPSConditions,numBlocks*numTrialsPerBlock);
confidenceArray=NaN(numRPSConditions,numBlocks*numTrialsPerBlock);
subjPointsArray=NaN(numRPSConditions,numBlocks*numTrialsPerBlock);
if expGroup==1
    subjPointsArray(1,1)=100;
elseif expGroup==2
    subjPointsArray(2,1)=100;
elseif expGroup==3
    subjPointsArray(3,1)=100;
end
compPointsArray=NaN(numRPSConditions,numBlocks*numTrialsPerBlock);
if expGroup==1
    compPointsArray(1,1)=100;
elseif expGroup==2
    compPointsArray(2,1)=100;
elseif expGroup==3
    compPointsArray(3,1)=100;
end
waitTimeArray=NaN(numConditions,numBlocks*numTrialsPerBlock);
timeFromStartPart=NaN(numConditions,numBlocks*numTrialsPerBlock);
timeFromStartExp=NaN(numConditions,numBlocks*numTrialsPerBlock);
errorArray=NaN(numConditions,numBlocks*numTrialsPerBlock,6);
%3D ERRORS matrix for key, reaction time, wins/losses, subjPoints and
% compPoints, and confidence errors (in that order)
practiceResultsArray=NaN(numPractConditions,numPracticeTrials,8);
%3D PRACTICE matrix for key, reaction time, wins/losses, subjPoints and
% compPoints, confidence, time from start of exp. and compResponse in
% practice (in that order)
screenArray=[win,width,height];

[subjStruct]=struct('name',subjName,'age',subjAge,'gender',subjGender, ...
    'ID',subjID,'Group',expGroup,...
    'keyResults',keyResultsArray,'compResponse',compResponseArray, ...
    'timeResults',timeResultsArray,'winLoseResults',winResultsArray, ...
    'predictionConfidence',confidenceArray,'subjPoints',subjPointsArray, ...
    'compPoints',compPointsArray,'practiceResults',practiceResultsArray, ...
    'waitTime',waitTimeArray,'timeFromStartPart',timeFromStartPart, ...
    'timeFromStartExp',timeFromStartExp, ...
    'errors3D',errorArray,'screenParams',screenArray); %Grand subject structure to be saved

% Save timestamps of everything in seconds
nMaxEvents=100000;
iTimeStamp=0;
timeStamps=repmat(...
    struct('eventTime',0,'eventDescription','start','eventCode',1000),...
    1,nMaxEvents);
iTimeStamp=iTimeStamp+1;
timeStamps(iTimeStamp).eventTime=0;
timeStamps(iTimeStamp).eventDescription='start';
timeStamps(iTimeStamp).eventCode=-1000;
% timeStamps2=cell(3,10000); %might need this... for saving more stamps

% For function inputs
practicePartOne='practicePartOne';
partOne='partOne';
practicePartTwo='practicePartTwo';
partTwo='partTwo';
practicePartThree='practicePartThree';
partThree='partThree';
partTwoC='partTwoC';
partFour='partFour';



%% Part One: Random Sequence Generation
%%% PART ONE.
%%% Your first task is to generate a random sequence of the three events
%%% "Rock", "Paper", and "Scissors". You will press the 3 buttons as
%%% randomly as possible.

% Draw INSTRUCTIONS in specific size, font & style
Screen('TextSize',win,textSize);
Screen('TextFont',win,'Arial');
Screen('TextStyle',win,1); % Style Bold
DrawFormattedText(win,instructionsPartOne,'center','center',textColor,70);

Screen('Flip',win);
iTimeStamp=iTimeStamp+1;
t=toc;
timeStamps(iTimeStamp).eventTime=t;
timeStamps(iTimeStamp).eventDescription='instr1';
timeStamps(iTimeStamp).eventCode=10; %code 10 for instructions

KbWait; % Wait for a key press to continue.
iTimeStamp=iTimeStamp+1;
t=toc;
timeStamps(iTimeStamp).eventTime=t;
timeStamps(iTimeStamp).eventDescription='instr1Press';
timeStamps(iTimeStamp).eventCode=11; %code 11 for response to instructions

WaitSecs(.5);
Screen('Flip',win);
iTimeStamp=iTimeStamp+1;
t=toc;
timeStamps(iTimeStamp).eventTime=t;
timeStamps(iTimeStamp).eventDescription='instr1Wait';
timeStamps(iTimeStamp).eventCode=12; %code 12 for wait after instructions

% Draw PRACTICE in specific size, font & style
Screen('TextSize',win,textSize);
Screen('TextFont',win,'Arial');
Screen('TextStyle',win,1); % Style Bold
DrawFormattedText(win,practiceStringOne,'center','center',textColor,70);

Screen('Flip',win);
iTimeStamp=iTimeStamp+1;
t=toc;
timeStamps(iTimeStamp).eventTime=t;
timeStamps(iTimeStamp).eventDescription='practInstr1';
timeStamps(iTimeStamp).eventCode=13; %code 13 for practice instructions

KbWait; % Wait for a key press to continue.
iTimeStamp=iTimeStamp+1;
t=toc;
timeStamps(iTimeStamp).eventTime=t;
timeStamps(iTimeStamp).eventDescription='practInstr1Press';
timeStamps(iTimeStamp).eventCode=11; %code 11 for response to instructions

WaitSecs(.5);
Screen('Flip',win);
iTimeStamp=iTimeStamp+1;
t=toc;
timeStamps(iTimeStamp).eventTime=t;
timeStamps(iTimeStamp).eventDescription='practInstr1Wait';
timeStamps(iTimeStamp).eventCode=12; %code 12 for wait after instructions

t=toc;
iTimeStamp=iTimeStamp+1;
timeStamps(iTimeStamp).eventTime=t;
timeStamps(iTimeStamp).eventDescription='startLoopPrac1';
timeStamps(iTimeStamp).eventCode=30; %code 30 for just before entering real loop

% PRACTICE LOOP (PART ONE)
[subjStruct,timeStamps,iTimeStamp]=CanPeopleBeRandomFunction(win,winRect,practicePartOne, ...
    1:numPracticeTrials,subjStruct,quarterY,[],numTrialsPerBlock,numBlocks,...
    timeStamps,timeStartExp,iTimeStamp);
t=toc;
iTimeStamp=iTimeStamp+1;
timeStamps(iTimeStamp).eventTime=t;
timeStamps(iTimeStamp).eventDescription='afterLoopPrac1';
timeStamps(iTimeStamp).eventCode=20; %code 20 for after a loop

% Draw REAL THING in specific size, font & style
Screen('TextSize',win,textSize);
Screen('TextFont',win,'Arial');
Screen('TextStyle',win,1); % Style Bold
DrawFormattedText(win,realString,'center','center',textColor,70);

Screen('Flip',win);
t=toc;
iTimeStamp=iTimeStamp+1;
timeStamps(iTimeStamp).eventTime=t;
timeStamps(iTimeStamp).eventDescription='Real1';
timeStamps(iTimeStamp).eventCode=21; %code 21 for displaying "Real Thing"

KbWait; % Wait for a key press to continue.
t=toc;
iTimeStamp=iTimeStamp+1;
timeStamps(iTimeStamp).eventTime=t;
timeStamps(iTimeStamp).eventDescription='Real1resp';
timeStamps(iTimeStamp).eventCode=22; %code 22 for response to "Real Thing"

WaitSecs(.5);
[timeStartPartOne]=Screen('Flip',win);
t=toc;
iTimeStamp=iTimeStamp+1;
timeStamps(iTimeStamp).eventTime=t;
timeStamps(iTimeStamp).eventDescription='startLoop1-1';
timeStamps(iTimeStamp).eventCode=30; %code 30 for just before entering real loop

% PART ONE LOOP: RANDOM SEQUENCE
[subjStruct,timeStamps,iTimeStamp]=CanPeopleBeRandomFunction(win,winRect,partOne, ...
    (1:numTrialsPerBlock/2),subjStruct,quarterY,timeStartPartOne, ...
    numTrialsPerBlock,numBlocks,timeStamps,timeStartExp,iTimeStamp); % BLOCK 1-1/2
t=toc;
iTimeStamp=iTimeStamp+1;
timeStamps(iTimeStamp).eventTime=t;
timeStamps(iTimeStamp).eventDescription='afterLoop1-1';
timeStamps(iTimeStamp).eventCode=20; %code 20 for after a loop

breakPlace=1;
% BREAK 1
[subjStruct,timeStamps,iTimeStamp,breakPlace,breakImageHandle]=RPSBreakScript(win,winRect, ...
    subjStruct,timeStamps,iTimeStamp,breakPlace);

WaitSecs(.5);

Screen('Flip',win);
t=toc;
iTimeStamp=iTimeStamp+1;
timeStamps(iTimeStamp).eventTime=t;
timeStamps(iTimeStamp).eventDescription='startLoop1-2';
timeStamps(iTimeStamp).eventCode=30; %code 30 for just before entering real loop

% PART ONE LOOP: RANDOM SEQUENCE
[subjStruct,timeStamps,iTimeStamp]=CanPeopleBeRandomFunction(win,winRect,partOne, ...
    ((numTrialsPerBlock/2+1):numTrialsPerBlock),subjStruct,quarterY,timeStartPartOne, ...
    numTrialsPerBlock,numBlocks,timeStamps,timeStartExp,iTimeStamp); % BLOCK 1-2/2

t=toc;
iTimeStamp=iTimeStamp+1;
timeStamps(iTimeStamp).eventTime=t;
timeStamps(iTimeStamp).eventDescription='afterLoop1-2';
timeStamps(iTimeStamp).eventCode=20; %code 20 for after a loop

% BREAK 2
[subjStruct,timeStamps,iTimeStamp,breakPlace]=RPSBreakScript(win,winRect, ...
    subjStruct,timeStamps,iTimeStamp,breakPlace,breakImageHandle);

WaitSecs(.5);

Screen('Flip',win);
t=toc;
iTimeStamp=iTimeStamp+1;
timeStamps(iTimeStamp).eventTime=t;
timeStamps(iTimeStamp).eventDescription='startLoop1-3';
timeStamps(iTimeStamp).eventCode=30; %code 30 for just before entering real loop

[subjStruct,timeStamps,iTimeStamp]=CanPeopleBeRandomFunction(win,winRect,partOne, ...
    (numTrialsPerBlock+1:(numTrialsPerBlock+numTrialsPerBlock/2)),subjStruct, ...
    quarterY,timeStartPartOne,numTrialsPerBlock,numBlocks,timeStamps,...
    timeStartExp,iTimeStamp); % BLOCK 2-1/2
t=toc;
iTimeStamp=iTimeStamp+1;
timeStamps(iTimeStamp).eventTime=t;
timeStamps(iTimeStamp).eventDescription='afterLoop1-3';
timeStamps(iTimeStamp).eventCode=20; %code 20 for after a loop

% BREAK 3
[subjStruct,timeStamps,iTimeStamp,breakPlace]=RPSBreakScript(win,winRect, ...
    subjStruct,timeStamps,iTimeStamp,breakPlace,breakImageHandle);

WaitSecs(.5);

Screen('Flip',win);
t=toc;
iTimeStamp=iTimeStamp+1;
timeStamps(iTimeStamp).eventTime=t;
timeStamps(iTimeStamp).eventDescription='startLoop1-4';
timeStamps(iTimeStamp).eventCode=30; %code 30 for just before entering real loop

[subjStruct,timeStamps,iTimeStamp]=CanPeopleBeRandomFunction(win,winRect,partOne, ...
    ((numTrialsPerBlock+numTrialsPerBlock/2)+1:numBlocks*numTrialsPerBlock),subjStruct, ...
    quarterY,timeStartPartOne,numTrialsPerBlock,numBlocks,timeStamps,...
    timeStartExp,iTimeStamp); % BLOCK 2-2/2
t=toc;
iTimeStamp=iTimeStamp+1;
timeStamps(iTimeStamp).eventTime=t;
timeStamps(iTimeStamp).eventDescription='afterLoop1-4';
timeStamps(iTimeStamp).eventCode=20; %code 20 for after a loop


%% Part Two A: Unaware of Prediction Rock-Paper-Scissors Play
%%% PART TWO(A).
%%% The second task is to play Rock-Paper-Scissors against the computer.
%%% In this group, the computer will predict the player's actions, but
%%% the subject will not be told about it ("unaware").

if expGroup==1
    % Draw INSTRUCTIONS in specific size, font & style
    Screen('TextSize',win,textSize);
    Screen('TextFont',win,'Arial');
    Screen('TextStyle',win,1); % Style Bold
    DrawFormattedText(win,instructionsPartTwo,'center','center',textColor,70);
    
    Screen('Flip',win);
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='instr2';
    timeStamps(iTimeStamp).eventCode=10; %code 10 for instructions
    
    KbWait; % Wait for a key press to continue.
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='instr2Press';
    timeStamps(iTimeStamp).eventCode=11; %code 11 for response to instructions
    
    WaitSecs(.5);
    Screen('Flip',win);
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='instr2Wait';
    timeStamps(iTimeStamp).eventCode=12; %code 12 for wait after instructions
    
    % Draw PRACTICE in specific size, font & style
    Screen('TextSize',win,textSize);
    Screen('TextFont',win,'Arial');
    Screen('TextStyle',win,1); % Style Bold
    DrawFormattedText(win,practiceStringOne,'center','center',textColor,70);
    
    Screen('Flip',win);
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='practInstr2';
    timeStamps(iTimeStamp).eventCode=13; %code 13 for practice instructions
    
    KbWait; % Wait for a key press to continue.
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='practInstr2Press';
    timeStamps(iTimeStamp).eventCode=11; %code 11 for response to instructions
    
    Screen('Flip',win);
    WaitSecs(.5);
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='practInstr2Wait';
    timeStamps(iTimeStamp).eventCode=12; %code 12 for wait after instructions
    
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='startLoopPrac2';
    timeStamps(iTimeStamp).eventCode=30; %code 30 for just before entering loop
    
    % PRACTICE LOOP (PART TWO: UNAWARE RPS GAME)
    [subjStruct,timeStamps,iTimeStamp]=CanPeopleBeRandomFunction(win,winRect,practicePartTwo, ...
        1:numPracticeTrials,subjStruct,quarterY,[],numTrialsPerBlock,numBlocks,...
        timeStamps,timeStartExp,iTimeStamp);
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='afterLoopPrac2';
    timeStamps(iTimeStamp).eventCode=20; %code 20 for after a loop
    
    % Draw REAL THING in specific size, font & style
    Screen('TextSize',win,textSize);
    Screen('TextFont',win,'Arial');
    Screen('TextStyle',win,1); % Style Bold
    DrawFormattedText(win,realString,'center','center',textColor,70);
    
    Screen('Flip',win);
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='Real2';
    timeStamps(iTimeStamp).eventCode=21; %code 21 for displaying "Real Thing"
    
    KbWait; % Wait for a key press to continue.
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='respReal2';
    timeStamps(iTimeStamp).eventCode=22; %code 22 for response to "Real Thing"
    
    WaitSecs(.5);
    [timeStartPartTwo]=Screen('Flip',win);
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='startLoop2-1';
    timeStamps(iTimeStamp).eventCode=30; %code 30 for just before entering real loop
    
    % REAL THING LOOP (PART TWO)
    [subjStruct,timeStamps,iTimeStamp]=CanPeopleBeRandomFunction(win,winRect,partTwo, ...
        1:numTrialsPerBlock,subjStruct,quarterY,timeStartPartTwo, ...
        numTrialsPerBlock,numBlocks,timeStamps,timeStartExp,iTimeStamp); % BLOCK 1
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='afterLoop2-1';
    timeStamps(iTimeStamp).eventCode=20; %code 20 for after a loop
    
    % BREAK 4
    [subjStruct,timeStamps,iTimeStamp,breakPlace]=RPSBreakScript(win,winRect, ...
        subjStruct,timeStamps,iTimeStamp,breakPlace,breakImageHandle);
    
    WaitSecs(.5);
    Screen('Flip',win);
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='startLoop2-2';
    timeStamps(iTimeStamp).eventCode=30; %code 30 for just before entering real loop
    
    [subjStruct,timeStamps,iTimeStamp]=CanPeopleBeRandomFunction(win,winRect,partTwo, ...
        numTrialsPerBlock+1:numBlocks*numTrialsPerBlock,subjStruct, ...
        quarterY,timeStartPartTwo,numTrialsPerBlock,numBlocks,timeStamps,...
        timeStartExp,iTimeStamp); % BLOCK 2f
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='afterLoop2-2';
    timeStamps(iTimeStamp).eventCode=20; %code 20 for after a loop
    
elseif expGroup==2
    %% Part Two B: Predicted Rock-Paper-Scissors Play
    %%% PART TWO(B).
    %%% The third task is to play Rock-Paper-Scissors against the computer.
    %%% In this group, the computer will predict the subject's actions, and
    %%% the subject will know this.
    
    
    % Draw INSTRUCTIONS in specific size, font & style
    Screen('TextSize',win,textSize);
    Screen('TextFont',win,'Arial');
    Screen('TextStyle',win,1); % Style Bold
    DrawFormattedText(win,instructionsPartThree,'center','center',textColor,70);
    
    Screen('Flip',win);
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='instr3';
    timeStamps(iTimeStamp).eventCode=10; %code 10 for instructions
    
    KbWait; % Wait for a key press to continue.
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='instr3Press';
    timeStamps(iTimeStamp).eventCode=11; %code 11 for response to instructions
    
    Screen('Flip',win);
    WaitSecs(.5);
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='instr3Wait';
    timeStamps(iTimeStamp).eventCode=12; %code 12 for wait after instructions
    
    % Draw PRACTICE in specific size, font & style
    Screen('TextSize',win,textSize);
    Screen('TextFont',win,'Arial');
    Screen('TextStyle',win,1); % Style Bold
    DrawFormattedText(win,practiceStringOne,'center','center',textColor,70);
    
    Screen('Flip',win);
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='practInstr3';
    timeStamps(iTimeStamp).eventCode=13; %code 13 for practice instructions
    
    KbWait; % Wait for a key press to continue.
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='practInstr3Press';
    timeStamps(iTimeStamp).eventCode=11; %code 11 for response to instructions
    
    Screen('Flip',win);
    WaitSecs(.5);
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='practInstr3Wait';
    timeStamps(iTimeStamp).eventCode=12; %code 12 for wait after instructions
    
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='startLoopPrac3';
    timeStamps(iTimeStamp).eventCode=30; %code 30 for just before entering loop
    
    % PRACTICE LOOP (PART TWO B: PREDICTED RPS GAME)
    [subjStruct,timeStamps,iTimeStamp]=CanPeopleBeRandomFunction(win,winRect,practicePartTwo, ...
        1:numPracticeTrials,subjStruct,quarterY,[],numTrialsPerBlock,numBlocks,...
        timeStamps,timeStartExp,iTimeStamp);
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='afterLoopPrac3';
    timeStamps(iTimeStamp).eventCode=20; %code 20 for after a loop
    
    % Draw REAL THING in specific size, font & style
    Screen('TextSize',win,textSize);
    Screen('TextFont',win,'Arial');
    Screen('TextStyle',win,1); % Style Bold
    DrawFormattedText(win,realString,'center','center',textColor,70);
    
    Screen('Flip',win);
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='Real3';
    timeStamps(iTimeStamp).eventCode=21; %code 21 for displaying "Real Thing"
    
    KbWait; % Wait for a key press to continue.
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='respReal3';
    timeStamps(iTimeStamp).eventCode=22; %code 22 for response to "Real Thing"
    
    WaitSecs(.5);
    [timeStartPartThree]=Screen('Flip',win);
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='startLoop3-1';
    timeStamps(iTimeStamp).eventCode=30; %code 30 for just before entering real loop
    
    % REAL THING LOOP (PART THREE [TWO B])
    [subjStruct,timeStamps,iTimeStamp]=CanPeopleBeRandomFunction(win,winRect,partThree, ...
        1:numTrialsPerBlock,subjStruct,quarterY,timeStartPartThree, ...
        numTrialsPerBlock,numBlocks,timeStamps,timeStartExp,iTimeStamp); % BLOCK 1
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='afterLoop3-1';
    timeStamps(iTimeStamp).eventCode=20; %code 20 for after a loop
    
    
    % BREAK 4
    [subjStruct,timeStamps,iTimeStamp,breakPlace]=RPSBreakScript(win,winRect, ...
        subjStruct,timeStamps,iTimeStamp,breakPlace,breakImageHandle);
    
    WaitSecs(.5);
    Screen('Flip',win);
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='startLoop3-2';
    timeStamps(iTimeStamp).eventCode=30; %code 30 for just before entering real loop
    
    [subjStruct,timeStamps,iTimeStamp]=CanPeopleBeRandomFunction(win,winRect,partThree, ...
        numTrialsPerBlock+1:numBlocks*numTrialsPerBlock,subjStruct, ...
        quarterY,timeStartPartThree,numTrialsPerBlock,numBlocks,timeStamps,...
        timeStartExp,iTimeStamp); % BLOCK 2
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='afterLoop3-2';
    timeStamps(iTimeStamp).eventCode=20; %code 20 for after a loop
    
elseif expGroup==3
    %% Part Two C: Control Rock-Paper-Scissors Play
    %%% PART TWO(C).
    %%% The second task is to play Rock-Paper-Scissors against the computer.
    %%% In this group, the computer will NOT predict the player's actions.
    
    
    % Draw INSTRUCTIONS in specific size, font & style
    Screen('TextSize',win,textSize);
    Screen('TextFont',win,'Arial');
    Screen('TextStyle',win,1); % Style Bold
    DrawFormattedText(win,instructionsPartTwoC,'center','center',textColor,70);
    
    Screen('Flip',win);
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='instr2';
    timeStamps(iTimeStamp).eventCode=10; %code 10 for instructions
    
    KbWait; % Wait for a key press to continue.
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='instr2Press';
    timeStamps(iTimeStamp).eventCode=11; %code 11 for response to instructions
    
    WaitSecs(.5);
    Screen('Flip',win);
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='instr2Wait';
    timeStamps(iTimeStamp).eventCode=12; %code 12 for wait after instructions
    
    % Draw PRACTICE in specific size, font & style
    Screen('TextSize',win,textSize);
    Screen('TextFont',win,'Arial');
    Screen('TextStyle',win,1); % Style Bold
    DrawFormattedText(win,practiceStringOne,'center','center',textColor,70);
    
    Screen('Flip',win);
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='practInstr2';
    timeStamps(iTimeStamp).eventCode=13; %code 13 for practice instructions
    
    KbWait; % Wait for a key press to continue.
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='practInstr2Press';
    timeStamps(iTimeStamp).eventCode=11; %code 11 for response to instructions
    
    Screen('Flip',win);
    WaitSecs(.5);
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='practInstr2Wait';
    timeStamps(iTimeStamp).eventCode=12; %code 12 for wait after instructions
    
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='startLoopPrac2';
    timeStamps(iTimeStamp).eventCode=30; %code 30 for just before entering loop
    
    % PRACTICE LOOP (PART TWO C: UNPREDICTED RPS GAME)
    [subjStruct,timeStamps,iTimeStamp]=CanPeopleBeRandomFunction(win,winRect,practicePartTwo, ...
        1:numPracticeTrials,subjStruct,quarterY,[],numTrialsPerBlock,numBlocks,...
        timeStamps,timeStartExp,iTimeStamp);
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='afterLoopPrac2';
    timeStamps(iTimeStamp).eventCode=20; %code 20 for after a loop
    
    % Draw REAL THING in specific size, font & style
    Screen('TextSize',win,textSize);
    Screen('TextFont',win,'Arial');
    Screen('TextStyle',win,1); % Style Bold
    DrawFormattedText(win,realString,'center','center',textColor,70);
    
    Screen('Flip',win);
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='Real2';
    timeStamps(iTimeStamp).eventCode=21; %code 21 for displaying "Real Thing"
    
    KbWait; % Wait for a key press to continue.
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='respReal2';
    timeStamps(iTimeStamp).eventCode=22; %code 22 for response to "Real Thing"
    
    WaitSecs(.5);
    [timeStartPartTwo]=Screen('Flip',win);
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='startLoop2-1';
    timeStamps(iTimeStamp).eventCode=30; %code 30 for just before entering real loop
    
    % REAL THING LOOP (PART TWO)
    [subjStruct,timeStamps,iTimeStamp]=CanPeopleBeRandomFunction(win,winRect,partTwoC, ...
        1:numTrialsPerBlock,subjStruct,quarterY,timeStartPartTwo, ...
        numTrialsPerBlock,numBlocks,timeStamps,timeStartExp,iTimeStamp); % BLOCK 1
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='afterLoop2-1';
    timeStamps(iTimeStamp).eventCode=20; %code 20 for after a loop
    
    % BREAK 4
    [subjStruct,timeStamps,iTimeStamp,breakPlace]=RPSBreakScript(win,winRect, ...
        subjStruct,timeStamps,iTimeStamp,breakPlace,breakImageHandle);
    
    WaitSecs(.5);
    Screen('Flip',win);
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='startLoop2-2';
    timeStamps(iTimeStamp).eventCode=30; %code 30 for just before entering real loop
    
    [subjStruct,timeStamps,iTimeStamp]=CanPeopleBeRandomFunction(win,winRect,partTwoC, ...
        numTrialsPerBlock+1:numBlocks*numTrialsPerBlock,subjStruct, ...
        quarterY,timeStartPartTwo,numTrialsPerBlock,numBlocks,timeStamps,...
        timeStartExp,iTimeStamp); % BLOCK 2
    t=toc;
    iTimeStamp=iTimeStamp+1;
    timeStamps(iTimeStamp).eventTime=t;
    timeStamps(iTimeStamp).eventDescription='afterLoop2-2';
    timeStamps(iTimeStamp).eventCode=20; %code 20 for after a loop
    
end
%% Part Four: Generation of random pattern ("Post")
%%% PART FOUR.
%%% Finally, please generate a sequence of the three options "Rock",
%%% "Paper" or "Scissors", again, as randomly as you can.

% Draw INSTRUCTIONS in specific size, font & style
Screen('TextSize',win,textSize);
Screen('TextFont',win,'Arial');
Screen('TextStyle',win,1); % Style Bold
DrawFormattedText(win,instructionsPartFour,'center','center',textColor,70);

Screen('Flip',win);
t=toc;
iTimeStamp=iTimeStamp+1;
timeStamps(iTimeStamp).eventTime=t;
timeStamps(iTimeStamp).eventDescription='instr4';
timeStamps(iTimeStamp).eventCode=10; %code 10 for instructions

KbWait; % Wait for a key press to continue.
t=toc;
iTimeStamp=iTimeStamp+1;
timeStamps(iTimeStamp).eventTime=t;
timeStamps(iTimeStamp).eventDescription='instr4Press';
timeStamps(iTimeStamp).eventCode=11; %code 11 for response to instructions

Screen('Flip',win);
WaitSecs(.5);
t=toc;
iTimeStamp=iTimeStamp+1;
timeStamps(iTimeStamp).eventTime=t;
timeStamps(iTimeStamp).eventDescription='instr4Wait';
timeStamps(iTimeStamp).eventCode=12; %code 12 for wait after instructions

[timeStartPartFour]=Screen('Flip',win);
t=toc;
iTimeStamp=iTimeStamp+1;
timeStamps(iTimeStamp).eventTime=t;
timeStamps(iTimeStamp).eventDescription='startLoop4-1';
timeStamps(iTimeStamp).eventCode=30; %code 30 for just before entering real loop

% REAL THING LOOP (PART FOUR)
[subjStruct,timeStamps,iTimeStamp]=CanPeopleBeRandomFunction(win,winRect,partFour, ...
    (1:numTrialsPerBlock/2),subjStruct,quarterY,timeStartPartFour, ...
    numTrialsPerBlock,numBlocks,timeStamps,timeStartExp,iTimeStamp); % BLOCK 1-1/2
t=toc;
iTimeStamp=iTimeStamp+1;
timeStamps(iTimeStamp).eventTime=t;
timeStamps(iTimeStamp).eventDescription='afterLoop4-1';
timeStamps(iTimeStamp).eventCode=20; %code 20 for after a loop

% BREAK 5
[subjStruct,timeStamps,iTimeStamp,breakPlace]=RPSBreakScript(win,winRect, ...
    subjStruct,timeStamps,iTimeStamp,breakPlace,breakImageHandle);

WaitSecs(.5);
Screen('Flip',win);
t=toc;
iTimeStamp=iTimeStamp+1;
timeStamps(iTimeStamp).eventTime=t;
timeStamps(iTimeStamp).eventDescription='startLoop4-2';
timeStamps(iTimeStamp).eventCode=30; %code 30 for just before entering real loop

[subjStruct,timeStamps,iTimeStamp]=CanPeopleBeRandomFunction(win,winRect,partFour, ...
    ((numTrialsPerBlock/2+1):numTrialsPerBlock),subjStruct,quarterY,timeStartPartFour, ...
    numTrialsPerBlock,numBlocks,timeStamps,timeStartExp,iTimeStamp); % BLOCK 1-2/2

t=toc;
iTimeStamp=iTimeStamp+1;
timeStamps(iTimeStamp).eventTime=t;
timeStamps(iTimeStamp).eventDescription='afterLoop4-2';
timeStamps(iTimeStamp).eventCode=20; %code 20 for after a loop

% BREAK 6
[subjStruct,timeStamps,iTimeStamp,breakPlace]=RPSBreakScript(win,winRect, ...
    subjStruct,timeStamps,iTimeStamp,breakPlace,breakImageHandle);

WaitSecs(.5);
Screen('Flip',win);
t=toc;
iTimeStamp=iTimeStamp+1;
timeStamps(iTimeStamp).eventTime=t;
timeStamps(iTimeStamp).eventDescription='startLoop4-3';
timeStamps(iTimeStamp).eventCode=30; %code 30 for just before entering real loop

[subjStruct,timeStamps,iTimeStamp]=CanPeopleBeRandomFunction(win,winRect,partFour, ...
    (numTrialsPerBlock+1:(numTrialsPerBlock+numTrialsPerBlock/2)),subjStruct, ...
    quarterY,timeStartPartFour,numTrialsPerBlock,numBlocks,timeStamps,...
    timeStartExp,iTimeStamp); % BLOCK 2-1/2

t=toc;
iTimeStamp=iTimeStamp+1;
timeStamps(iTimeStamp).eventTime=t;
timeStamps(iTimeStamp).eventDescription='afterLoop4-3';
timeStamps(iTimeStamp).eventCode=20; %code 20 for after a loop

% BREAK 7
[subjStruct,timeStamps,iTimeStamp,breakPlace]=RPSBreakScript(win,winRect, ...
    subjStruct,timeStamps,iTimeStamp,breakPlace,breakImageHandle);

WaitSecs(.5);
Screen('Flip',win);
t=toc;
iTimeStamp=iTimeStamp+1;
timeStamps(iTimeStamp).eventTime=t;
timeStamps(iTimeStamp).eventDescription='startLoop4-4';
timeStamps(iTimeStamp).eventCode=30; %code 30 for just before entering real loop

[subjStruct,timeStamps,iTimeStamp]=CanPeopleBeRandomFunction(win,winRect,partFour, ...
    ((numTrialsPerBlock+numTrialsPerBlock/2)+1:numBlocks*numTrialsPerBlock),subjStruct, ...
    quarterY,timeStartPartFour,numTrialsPerBlock,numBlocks,timeStamps,...
    timeStartExp,iTimeStamp); % BLOCK 2-2/2

t=toc;
iTimeStamp=iTimeStamp+1;
timeStamps(iTimeStamp).eventTime=t;
timeStamps(iTimeStamp).eventDescription='afterLoop4-4';
timeStamps(iTimeStamp).eventCode=20; %code 20 for after a loop

%% Ending and exiting the task


% timeStamps(:,col+1:end)=[]; %truncate the timestamps cell array at the
% end. We'll see about that.

save([cat(2,subjName,num2str(subjAge),subjGender,subjID) '.mat']);

% Draw THANK YOU in specific size, font & style
Screen('TextSize',win,textSize);
Screen('TextFont',win,'Arial');
Screen('TextStyle',win,1); % Style Bold
% Get text bounds on screen given size, font, style, ...
txtBounds=Screen('TextBounds',win,thankString);
DrawFormattedText(win,thankString,'center','center',textColor,55);
Screen('Flip',win);

WaitSecs(2);

ListenChar(0); %makes it so characters typed do show up in the command window
ShowCursor(); %shows the cursor

Screen('CloseAll'); %Closes Screen
sca;
clear Screen;




