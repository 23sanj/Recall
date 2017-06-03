
# coding: utf-8

# # Data Importation and Variable Creation

# In[5]:

import pandas as pd
from sklearn import linear_model as lm


# In[6]:

patternData=pd.read_excel("patternN2toN6_TapbackOnly.xlsx")


# ### Create Target/Nontarget

# In[7]:

for i, thepattern in enumerate(patternData.Pattern):
    if thepattern[-1]==thepattern[1]:
        patternData.loc[i, "Target"]='T'
    else:
        patternData.loc[i, "Target"]='NT'


# **Create backward attractors**

# In[8]:

for i, thepattern in enumerate(patternData.Pattern):
    if (patternData.loc[i,"Target"]=='T') and (thepattern[-1]==thepattern[0]):
        patternData.loc[i,"backwardAttractor"]=1
    else:
        patternData.loc[i,"backwardAttractor"]=0


# **Create forward attractors**

# In[9]:

for i, thepattern in enumerate(patternData.Pattern):
    if (patternData.loc[i,"Target"]=='T') and (thepattern[-1]==thepattern[2]):
        patternData.loc[i,"forwardAttractor"]=1
    else:
        patternData.loc[i,"forwardAttractor"]=0


# **Create both attractors**

# In[10]:

for i, thepattern in enumerate(patternData.Pattern):
    if (patternData.loc[i,"backwardAttractor"]==1) and (patternData.loc[i,"forwardAttractor"]==1):
        patternData.loc[i,"bothAttractors"]=1
    else:
        patternData.loc[i,"bothAttractors"]=0


# **Create Backwards Lures**

# In[11]:

for i, thepattern in enumerate(patternData.Pattern):
    if thepattern[-1]==thepattern[0]:
        patternData.loc[i,"backwardLure"]=1
    else:
        patternData.loc[i,"backwardLure"]=0


# **Create Forwards Lures**

# In[12]:

for i, thepattern in enumerate(patternData.Pattern):
    if thepattern[-1]==thepattern[2]:
        patternData.loc[i,"forwardLure"]=1
    else:
        patternData.loc[i,"forwardLure"]=0


# **Create Bidirectional Lures**

# In[13]:

for i, thepattern in enumerate(patternData.Pattern):
    if thepattern[-1]==thepattern[0] and thepattern[-1]==thepattern[2]:
        patternData.loc[i,"bothLures"]=1
    else:
        patternData.loc[i,"bothLures"]=0


# **Count Number of Colors in the Pattern**

# In[14]:

for i, thepattern in enumerate(patternData.Pattern):
    patternData.loc[i,"numColors"]=len(set(patternData.loc[i,"Pattern"]))


# **Get N level**

# In[15]:

for i, thepattern in enumerate(patternData.Pattern):
    patternData.loc[i,"nLevel"]=len(patternData.loc[i,"Pattern"])-2


# In[16]:

len(patternData.loc[1,"Pattern"])


# **Find if Last Color is Unique**

# In[17]:

for i, thepattern in enumerate(patternData.Pattern):
    if thepattern[-1] not in set(thepattern[:-1]):
        patternData.loc[i,"lastColorUnique"]=1
    else:
        patternData.loc[i,"lastColorUnique"]=0


# **Count Number of Substrings in the Pattern with Length > 2**

# In[18]:

import math


# In[19]:

def substr(string):
    j=2
    a=set()
    while True:
        for i in range(len(string)-j+1):
            a.add(string[i:i+j])
        if j==math.ceil(len(string)/2):
            break
        j+=1
        #string=string[1:]
    return a


# In[20]:

for i, thepattern in enumerate(patternData.Pattern):
    patternSubStrs=substr(thepattern)
    totalcount=0
    for x in patternSubStrs:
        if thepattern.count(x)>1:
            totalcount=totalcount+thepattern.count(x)-1
    patternData.loc[i,"totalRepeatingSubstrings"]=totalcount


# # Pull out samples with 25 observations or more for training data

# In[21]:

patternData25SamplesPlus=patternData[patternData.Count>25]


# In[22]:

patternData25SamplesPlus.shape


# In[23]:

import patsy


# Create our data for modeling

# In[24]:



# # Linear Regression

def regReturn():
    yData,xData=patsy.dmatrices("Accuracy~C(Target)+forwardLure+backwardLure+bothLures+numColors+nLevel+lastColorUnique+totalRepeatingSubstrings+forwardAttractor+backwardAttractor+bothAttractors",patternData25SamplesPlus)
    regression=lm.LinearRegression()
    patternRegFit=regression.fit(xData,yData)
    return patternRegFit


# # Block Difficulty Classifier Library

# In[103]:

import pandas as pd
import math

def createPatternDataframe(blockData,nLevel):
    """Breaks up a string or numeric value into patterns for prediction, 
    assumes that each letter or numeric value is a seperate color/stimulus in the n-back task"""
    blockData=str(blockData)
    patternData=pd.DataFrame()
    patternList=list()
    for i in range(0,len(blockData)-nLevel):
        patternList.append(blockData[i:i+nLevel+2])
    patternData.insert(0,"Pattern",patternList)
    return patternData

def substr(string):
    j=2
    a=set()
    while True:
        for i in range(len(string)-j+1):
            a.add(string[i:i+j])
        if j==math.ceil(len(string)/2):
            break
        j+=1
        #string=string[1:]
    return a

def createFeatures(patternData):
    """Creates all features necessary to predict accuracy based on the fitted regression, 
    takes in and returns a Pandas data frame"""
    for i, thepattern in enumerate(patternData.Pattern):
        if thepattern[-1]==thepattern[1]:
            patternData.loc[i, "Target"]='T'
        else:
            patternData.loc[i, "Target"]='NT'
        if (patternData.loc[i,"Target"]=='T') and (thepattern[-1]==thepattern[0]):
            patternData.loc[i,"backwardAttractor"]=1
        else:
            patternData.loc[i,"backwardAttractor"]=0
        if (patternData.loc[i,"Target"]=='T') and (thepattern[-1]==thepattern[2]):
            patternData.loc[i,"forwardAttractor"]=1
        else:
            patternData.loc[i,"forwardAttractor"]=0
        if (patternData.loc[i,"backwardAttractor"]==1) and (patternData.loc[i,"forwardAttractor"]==1):
            patternData.loc[i,"bothAttractors"]=1
        else:
            patternData.loc[i,"bothAttractors"]=0
        if thepattern[-1]==thepattern[0]:
            patternData.loc[i,"backwardLure"]=1
        else:
            patternData.loc[i,"backwardLure"]=0
        if thepattern[-1]==thepattern[2]:
            patternData.loc[i,"forwardLure"]=1
        else:
            patternData.loc[i,"forwardLure"]=0
        if thepattern[-1]==thepattern[0] and thepattern[-1]==thepattern[2]:
            patternData.loc[i,"bothLures"]=1
        else:
            patternData.loc[i,"bothLures"]=0
        patternData.loc[i,"numColors"]=len(set(patternData.loc[i,"Pattern"]))
        patternData.loc[i,"nLevel"]=len(patternData.loc[i,"Pattern"])-1
        if thepattern[-1] not in set(thepattern[:-1]):
            patternData.loc[i,"lastColorUnique"]=1
        else:
            patternData.loc[i,"lastColorUnique"]=0
        patternSubStrs=substr(thepattern)
        totalcount=0
        for x in patternSubStrs:
            if thepattern.count(x)>1:
                totalcount=totalcount+thepattern.count(x)-1
        patternData.loc[i,"totalRepeatingSubstrings"]=totalcount
    return patternData

def calculateAccuracies(patternData,regFit):
    """Calculates predicted accuracies using fitted regression model from a data 
    frame containing the patterns and features"""
    yData,xData=patsy.dmatrices("Pattern~C(Target)+forwardLure+backwardLure+bothLures+numColors+nLevel+lastColorUnique+totalRepeatingSubstrings+forwardAttractor+backwardAttractor+bothAttractors",patternData)
    patternData["PredictedAccuracy"]=regFit.predict(xData)
    return patternData

def automatePrediction(blockData,nLevel):
    regressionFit = regReturn()
    predPatternData=createPatternDataframe(blockData,nLevel)
    predPatternData=createFeatures(predPatternData)
    predPatternData=calculateAccuracies(predPatternData,regressionFit)
    return predPatternData

def getAverageAccuracy(predPatternData):
    return predPatternData["PredictedAccuracy"].mean()


