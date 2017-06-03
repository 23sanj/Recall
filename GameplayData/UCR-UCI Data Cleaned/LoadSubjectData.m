%This script loads up the object definitions by creating an example, then deleting it.  This fixes a Matlab deficiency.

test = SubjectData('testSubj');
clear test;

load('subjectData.mat');