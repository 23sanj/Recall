LoadSubjectData;

completedSubjects = SubjectData.empty;

%Copy over all subjects who have both assessments
for subj=subjectData
    if(length(subj.assessmentSessions) == 2)
        completedSubjects(end+1) = subj;
    end
end

numSubjects = length(completedSubjects);

subjectNames = {completedSubjects(:).name};

%Cancellation Task

cancellationRowNum = length(completedSubjects(1).assessmentSessions(1).cancellation.rowData);
preCancellation = zeros(numSubjects, cancellationRowNum, 4);
postCancellation = zeros(numSubjects, cancellationRowNum, 4);

for i=1:numSubjects
    %In two different styles...
    
    %Individual
    preCancellation(i,:,1) = [completedSubjects(i).assessmentSessions(1).cancellation.rowData(:).hits];
    preCancellation(i,:,2) = [completedSubjects(i).assessmentSessions(1).cancellation.rowData(:).misses];
    preCancellation(i,:,3) = [completedSubjects(i).assessmentSessions(1).cancellation.rowData(:).fa];
    preCancellation(i,:,4) = [completedSubjects(i).assessmentSessions(1).cancellation.rowData(:).cr];

    %And vector
    postCancellation(i,:,:) = ...
    [completedSubjects(i).assessmentSessions(2).cancellation.rowData(:).hits; ...
    completedSubjects(i).assessmentSessions(2).cancellation.rowData(:).misses; ...
    completedSubjects(i).assessmentSessions(2).cancellation.rowData(:).fa; ...
    completedSubjects(i).assessmentSessions(2).cancellation.rowData(:).cr]';
end


%Dogs and Monkeys
DM_ELEM_STIM_TYPE=1;
DM_ELEM_STIM_POSTION=2;
DM_ELEM_RESPONSE_POSITION=3;
DM_ELEM_RESPONSE_CORRECT=4;
DM_ELEM_RESPONSE_TIME=5;

DM_STIM_TYPE_DOG = 1;
DM_STIM_TYPE_MONKEY = 0;

DM_STIM_POS_LEFT = 0;
DM_STIM_POS_RIGHT = 1;


DM_dogPracticeTrialNum = length(completedSubjects(1).assessmentSessions(1).dogsAndMonkeys.dogPractice);
DM_monkeyPracticeTrialNum = length(completedSubjects(1).assessmentSessions(1).dogsAndMonkeys.monkeyPractice);
DM_mixedFullTrialNum = length(completedSubjects(1).assessmentSessions(1).dogsAndMonkeys.mixedFull);

preDM_DogPractice = zeros(numSubjects,DM_dogPracticeTrialNum,5);
preDM_MonkeyPractice = zeros(numSubjects,DM_monkeyPracticeTrialNum,5);
preDM_MixedFull = zeros(numSubjects,DM_mixedFullTrialNum,5);

postDM_DogPractice = zeros(numSubjects,DM_dogPracticeTrialNum,5);
postDM_MonkeyPractice = zeros(numSubjects,DM_monkeyPracticeTrialNum,5);
postDM_MixedFull = zeros(numSubjects,DM_mixedFullTrialNum,5);

for i=1:numSubjects
    preDM_DogPractice(i,:,:) = ...
    [completedSubjects(i).assessmentSessions(1).dogsAndMonkeys.dogPractice(:).target; ...
    completedSubjects(i).assessmentSessions(1).dogsAndMonkeys.dogPractice(:).stimPosition; ...
    completedSubjects(i).assessmentSessions(1).dogsAndMonkeys.dogPractice(:).responsePosition; ...
    completedSubjects(i).assessmentSessions(1).dogsAndMonkeys.dogPractice(:).correctResponse; ...
    completedSubjects(i).assessmentSessions(1).dogsAndMonkeys.dogPractice(:).responseTime;]';
    
    preDM_MonkeyPractice(i,:,:) = ...
    [completedSubjects(i).assessmentSessions(1).dogsAndMonkeys.monkeyPractice(:).target; ...
    completedSubjects(i).assessmentSessions(1).dogsAndMonkeys.monkeyPractice(:).stimPosition; ...
    completedSubjects(i).assessmentSessions(1).dogsAndMonkeys.monkeyPractice(:).responsePosition; ...
    completedSubjects(i).assessmentSessions(1).dogsAndMonkeys.monkeyPractice(:).correctResponse; ...
    completedSubjects(i).assessmentSessions(1).dogsAndMonkeys.monkeyPractice(:).responseTime;]';
    
    preDM_MixedFull(i,:,:) = ...
    [completedSubjects(i).assessmentSessions(1).dogsAndMonkeys.mixedFull(:).target; ...
    completedSubjects(i).assessmentSessions(1).dogsAndMonkeys.mixedFull(:).stimPosition; ...
    completedSubjects(i).assessmentSessions(1).dogsAndMonkeys.mixedFull(:).responsePosition; ...
    completedSubjects(i).assessmentSessions(1).dogsAndMonkeys.mixedFull(:).correctResponse; ...
    completedSubjects(i).assessmentSessions(1).dogsAndMonkeys.mixedFull(:).responseTime;]';
    
    postDM_DogPractice(i,:,:) = ...
    [completedSubjects(i).assessmentSessions(2).dogsAndMonkeys.dogPractice(:).target; ...
    completedSubjects(i).assessmentSessions(2).dogsAndMonkeys.dogPractice(:).stimPosition; ...
    completedSubjects(i).assessmentSessions(2).dogsAndMonkeys.dogPractice(:).responsePosition; ...
    completedSubjects(i).assessmentSessions(2).dogsAndMonkeys.dogPractice(:).correctResponse; ...
    completedSubjects(i).assessmentSessions(2).dogsAndMonkeys.dogPractice(:).responseTime;]';
    
    postDM_MonkeyPractice(i,:,:) = ...
    [completedSubjects(i).assessmentSessions(2).dogsAndMonkeys.monkeyPractice(:).target; ...
    completedSubjects(i).assessmentSessions(2).dogsAndMonkeys.monkeyPractice(:).stimPosition; ...
    completedSubjects(i).assessmentSessions(2).dogsAndMonkeys.monkeyPractice(:).responsePosition; ...
    completedSubjects(i).assessmentSessions(2).dogsAndMonkeys.monkeyPractice(:).correctResponse; ...
    completedSubjects(i).assessmentSessions(2).dogsAndMonkeys.monkeyPractice(:).responseTime;]';
    
    postDM_MixedFull(i,:,:) = ...
    [completedSubjects(i).assessmentSessions(2).dogsAndMonkeys.mixedFull(:).target; ...
    completedSubjects(i).assessmentSessions(2).dogsAndMonkeys.mixedFull(:).stimPosition; ...
    completedSubjects(i).assessmentSessions(2).dogsAndMonkeys.mixedFull(:).responsePosition; ...
    completedSubjects(i).assessmentSessions(2).dogsAndMonkeys.mixedFull(:).correctResponse; ...
    completedSubjects(i).assessmentSessions(2).dogsAndMonkeys.mixedFull(:).responseTime;]';
end


%Letter Number Span 
LETTER_NUMBER_FORM_TRIAL_COUNT = 21;
LN_CORRECT = 1;
LN_INCORRECT = 0;
LN_NO_RESPONSE = -1;

preLetterNumberSpan = -1 * ones(numSubjects, LETTER_NUMBER_FORM_TRIAL_COUNT);
postLetterNumberSpan = -1 * ones(numSubjects, LETTER_NUMBER_FORM_TRIAL_COUNT);

for i=1:numSubjects
    letterNumberSpan = completedSubjects(i).assessmentSessions(1).letterNumberSpan;
    preLetterNumberSpan(i, 1:length(letterNumberSpan.trials)) = [letterNumberSpan.trials(:).correctResponse;];

    letterNumberSpan = completedSubjects(i).assessmentSessions(2).letterNumberSpan;
    postLetterNumberSpan(i, 1:length(letterNumberSpan.trials)) = [letterNumberSpan.trials(:).correctResponse;];
end

%CorsiBlocks
CORSI_FORM_TRIAL_COUNT = 21;

preCorsiForward = -1 * ones(numSubjects, CORSI_FORM_TRIAL_COUNT);
preCorsiReverse = -1 * ones(numSubjects, CORSI_FORM_TRIAL_COUNT);
postCorsiForward = -1 * ones(numSubjects, CORSI_FORM_TRIAL_COUNT);
postCorsiReverse = -1 * ones(numSubjects, CORSI_FORM_TRIAL_COUNT);

for i=1:numSubjects
    corsiBlocks = completedSubjects(i).assessmentSessions(1).corsiBlocks;
    preCorsiForward(i, 1:length(corsiBlocks.forwardTrials)) = [corsiBlocks.forwardTrials(:).correct;];
    preCorsiReverse(i, 1:length(corsiBlocks.reverseTrials)) = [corsiBlocks.reverseTrials(:).correct;];

    corsiBlocks = completedSubjects(i).assessmentSessions(2).corsiBlocks;
    postCorsiForward(i, 1:length(corsiBlocks.forwardTrials)) = [corsiBlocks.forwardTrials(:).correct;];
    postCorsiReverse(i, 1:length(corsiBlocks.reverseTrials)) = [corsiBlocks.reverseTrials(:).correct;];
end

%Near Transfer
NT_MAX_N_LEVEL = 20;

NT_COND_TRUCKS = 1;
NT_COND_ANIMALS = 0;

preNearTransferCond = zeros(1,numSubjects);
postNearTransferCond = zeros(1,numSubjects);
preNearTransfer = nan(numSubjects,2,NT_MAX_N_LEVEL,4);
postNearTransfer = nan(numSubjects,2,NT_MAX_N_LEVEL,4);

for i=1:numSubjects
    nearTransfer = completedSubjects(i).assessmentSessions(1).nearTransfer;
    preNearTransfer(i, 1, 1:length(nearTransfer.noLureBlocks), :) = ...
    [arrayfun(@(task) task.hits, nearTransfer.noLureBlocks);...
    arrayfun(@(task) task.misses, nearTransfer.noLureBlocks);...
    arrayfun(@(task) task.fa, nearTransfer.noLureBlocks);...
    arrayfun(@(task) 0, nearTransfer.noLureBlocks);]';

    preNearTransfer(i, 2, 1:length(nearTransfer.lureBlocks), :) = ...
    [arrayfun(@(task) task.hits, nearTransfer.lureBlocks);...
    arrayfun(@(task) task.misses, nearTransfer.lureBlocks);...
    arrayfun(@(task) task.fa, nearTransfer.lureBlocks);...
    arrayfun(@(task) 0, nearTransfer.lureBlocks);]';

    preNearTransferCond(i) = nearTransfer.trucks;

    nearTransfer = completedSubjects(i).assessmentSessions(2).nearTransfer;
    postNearTransfer(i, 1, 1:length(nearTransfer.noLureBlocks), :) = ...
    [arrayfun(@(task) task.hits, nearTransfer.noLureBlocks);...
    arrayfun(@(task) task.misses, nearTransfer.noLureBlocks);...
    arrayfun(@(task) task.fa, nearTransfer.noLureBlocks);...
    arrayfun(@(task) 0, nearTransfer.noLureBlocks);]';

    postNearTransfer(i, 2, 1:length(nearTransfer.lureBlocks), :) = ...
    [arrayfun(@(task) task.hits, nearTransfer.lureBlocks);...
    arrayfun(@(task) task.misses, nearTransfer.lureBlocks);...
    arrayfun(@(task) task.fa, nearTransfer.lureBlocks);...
    arrayfun(@(task) 0, nearTransfer.lureBlocks);]';

    postNearTransferCond(i) = nearTransfer.trucks;
end

%SymmetrySpan
SS_ELEM_SEQUENCE_LENGTH = 1;
SS_ELEM_SYMMETRY_PERCENTAGE_CORRECT = 2;
SS_ELEM_SEQUENCE_CORRECT = 3;

SS_MAX_SEQ_LEN = 5;
SS_TRIALS_PER_SEQ_LEN = 3;

SS_TOTAL_TRIAL_NUM = (SS_MAX_SEQ_LEN - 1) * SS_TRIALS_PER_SEQ_LEN;

preSymmetrySpan = zeros(numSubjects,SS_TOTAL_TRIAL_NUM,3);
postSymmetrySpan = zeros(numSubjects,SS_TOTAL_TRIAL_NUM,3);

for i=1:numSubjects
    symmetrySpan = completedSubjects(i).assessmentSessions(1).symmetrySpan;
    preSymmetrySpan(i, :, :) = ...
    [arrayfun(@(task) length(task.sequence), symmetrySpan.task);...
    [symmetrySpan.task(:).symmPerc];...
    [symmetrySpan.task(:).correctResponse];]';

    symmetrySpan = completedSubjects(i).assessmentSessions(2).symmetrySpan;
    postSymmetrySpan(i,:, :) = ...
    [arrayfun(@(task) length(task.sequence), symmetrySpan.task);...
    [symmetrySpan.task(:).symmPerc];...
    [symmetrySpan.task(:).correctResponse];]';
end