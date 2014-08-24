## Getting and Cleaning Data Course Project Code Book

###Summary
> This codebook describes the data file called tidyData2.txt in the git repository 		 
	https://github.com/cjhuxley/GCD_Tidy_Data_project 
	
> The data file consists of the mean values for 80 observations for 6 activites and 30 participant subjects. As per the requirements of the assignment, the file is a tidy data set with the average of each variable for each activity and each subject.

#### Files relevant to this data file and its creation
- tidyData2.txt
- Code_book.md (this file)
- run_analysis.R

#### Extent of processing
> The file run_analysis.R contains the code used to generate tidyData2.txt
> See the section below **How the data was created** for an overview of the processing.

#### Data format
> The file is a text file with space delimiters
___

### About the data
> The goal in creating the datatable was to demonstrate the ability to prepare tidy data for later analysis. No information was provided as to what that analysis might be. The data is in the repo file "tidyData2.txt" and is a space delimited text file. The form of the data is narrow form.

> The original source of the data presented was obtained from the UCI Machine Learning repository. The data and background of the data collection can be found here:

> [data link](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

> A description of the variables in the original data and how they were measured or calculated are found in the features_info.txt file in the UCI HAR Dataset folder. Two instruments were used to generate the data, a smartphone accelerometer and gyroscope. The raw signals were recorded 50 times per second and the data filtered. It was then separated into into body and gravity acceleration signals.Next, body linear acceleration and angular velocity measurements were calculated and used to determine "Jerk signals" as well as Euclidean norm magnitudes. Finally, a Fast Fourier Transform(FFT) method was applied to the data to derive a range of frequency domain signals. By averaging signals in a signal window sample a number of vectors were generated from which angles between vectors could be calculated. 

> In the original data set a wide range of statistics were also calculated but these have been excluded from the final data set as the aim was only to deal with mean and standard deviation data.

> The aim of preparing the data in the file tidydata2.txt was to create a tidy data file. In doing this the paper by [Hadley Wickham Tiday] (http://vita.had.co.nz/papers/tidy-data.pdf) was used as a guide. An attempt has been made to ensure that:

>>each variable forms a column (subjects and activites);
each observation forms a row (measurements);
each type of observational unit forms a table.

> Observation names are in camel case. While it might be argued that all lower case names is more 'tidy'. I took the view that Camel case makes the titles more readable and provides a range of handles for subsetting data in the future. I probably would have done something slightly different if I knew what the subsequent analysis of the data would entail.

> The citation for this data is: 

>>Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012)</p>

### How the data was created
>This is a summary of the steps and coding in the file “run_analysis.R”. The steps below are in the order requested in the assignment outline. The code in “run_analysis.R” is the way it is for readability. Normally the 5 steps here would all be coded as separate functions but it is the way it is ,hopefully, to make things easier for the judges of the process.

>**Step 1.** Merge the training and the test sets to create one data set.

1.Loaded activity labels from the file "activity_labels.txt"

2.Loaded training data then test data and add subject ID to each. Simple use of read.table used for this. Data and subject identifers were combined using the cbind function.

>Files involved were:
- "X_train.txt"(training data), 
- subject_train.txt" (subject identifiers for participants in the training subgroup), 
- "X_test.txt" (the test data), and
- "subject_test.txt" (the test participant identifiers).
 
>Next, the training and test data were merged into a data frame called "dataSet" and titles from the features.txt file were added on the far right of the table

>**Step 2.** Extract only the measurements on the mean and standard deviation for each measurement. 

>This was fairly straightforward using the grep function applied to the names of the columns in dataset. The simple regex expression
 "mean|std|subject" was used to identify any column dealing with a mean, standard deviation and the subject column. The result was saved as a table called “meanStdData”

>**Step 3.** Use descriptive activity names to name the activities in the data set

>A similar process was used for the training and test data by binding activity data into a single object and then using use a for loop and the functions sapply and gsub to replace numbers with labels. The result was bound the right side of “meanStdData” and the column title “activity’ pasted into the names for the table.

>**Step 4.** Appropriately labels the data set with descriptive variable names. 

>Tidy data might expect names of columns to be all lower case but the names here use a form of camel case. The reason being that I think it makes the names more understandable and I found that it provides some flexibility in portioning the data for subsequent analysis (although this was not part of the brief).

>The following steps were applied using the gsub function to a copy of  names(meanStdData) called “temp”:
- Removal of punctuation characters
- Lower case ‘m’ in mean was replaced with a capital 
- Lower case ‘s’ in std was replaced with a capital 
- ‘t’ at the start of time domain data was replaced with the string’time’
- ‘f’ at the start of the frequency data was replaced with the more meaningful string ‘freq’.

>The processed names were then substituted for names(meanStdData).

>**Step 5.** Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

>(A check was made for missing values in the original function used for this stage. The code has been retained in the final code.)

>This part of the code uses the package “reshape2”. The data was melted using "activity" and"subject" as the id columns into an object called “melt1”.

>Two dcast calls were made to create a table for activity means (variable~activity) and subject means (variable~subject). The two tables were merged into a single one called “summaryTable”. The resulting tables had column names requiring attention. Underscores (_) were removed, lowercase was applied, and “subject” was added to the subject names.

>**Step 6.** Save the final data table as a text file using write.table() with row.names-FALSE.

>This was done using: 

	write.table(summaryTable, file="tidyData2.txt", sep=" ",row.names=FALSE)

>As the code indicates, the final file is called "tidyData2.txt”





### Data Explanation

<table style="width:700px">
    <tr>
		<th>Variable/Observation</th>
		<th>Column Location</th> 
		<th>Variable Definition</th>
		<th>Range of Values</th>
		<th>Units of this variable</th>
    </tr>
    <tr>
        	<td><p>subject</p></td>
      		<td>Columns 8 to 37</td>
      		<td>A string consisting of &quot;subject&quot; and a number  identifying the experiment participant</td>
      		<td>subject1,subject2... , subject30</td>
      		<td>a string</td>
    </tr>
    <tr>
      <td>activity</td>
      <td>Columns 2 to 7</td>
      <td><p>A string identifying one of the experimental activites:</p>
        <ul>
          <li>laying down</li>
          <li>            sitting</li>
          <li>standing</li>
          <li>walking</li>
          <li>walking downstairs</li>
          <li>walking upstairs</li>
      </ul></td>
      <td>laying<br>
        sitting<br>
        standing<br>
        walking<br>
        walkingdownstairs<br>
      walkingupstairs</td>
      <td>a string</td>
    </tr>
    <tr>
      <td width="244">freqBodyAccJerkMeanFreqX</td>
      <td>Row 1</td>
      <td>The mean body Jerk signal frequency along the X axis</td>
      <td>0.086800054 to -0.219176266</td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>freqBodyAccJerkMeanFreqY</td>
      <td>Row 2</td>
      <td>The mean body Jerk frequency signal along the Y axis</td>
      <td>-0.081561131 to-0.347751351</td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>freqBodyAccJerkMeanFreqZ</td>
      <td>Row 3</td>
      <td>The mean body Jerk frequency signal  along the Z axis</td>
      <td>0.011238506 to -0.290292303</td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>freqBodyAccJerkMeanX</td>
      <td>Row 4</td>
      <td>The mean body Jerk acceleration signal along the X axis</td>
      <td>-0.54724304 to -0.804144643</td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>freqBodyAccJerkMeanY</td>
      <td>Row 5</td>
      <td>The mean body Jerk acceleration signal   along the Y axis</td>
      <td>-0.495906216 to -0.748627002</td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>freqBodyAccJerkMeanZ</td>
      <td>Row 6</td>
      <td>The mean body Jerk acceleration signal  along the Z axis</td>
      <td>-0.57887081 to -0.849504849</td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>freqBodyAccJerkStdX</td>
      <td>Row 7</td>
      <td>Thestandard deviation of the body Jerk acceleration signal along the X axis</td>
      <td>-0.543979776 to -0.807712526</td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>freqBodyAccJerkStdY</td>
      <td>Row 8</td>
      <td>Thestandard deviation of the body Jerk acceleration signal   along the Y axis</td>
      <td>-0.437837459 to -0.739197835</td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>freqBodyAccJerkStdZ</td>
      <td><p>Row 9</p></td>
      <td>Thestandard deviation of the body Jerk acceleration signal  along the Z axis</td>
      <td>-0.627540368 to -0.870541516</td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>freqBodyAccMagMean</td>
      <td>Row 10</td>
      <td>The mean magnitude of the body acceleration</td>
      <td>-0.473974924 to -0.697732862</td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>freqBodyAccMagMeanFreq</td>
      <td>Row 11</td>
      <td>The mean frequency of the body acceleration magintude</td>
      <td>0.192199738 to -0.060068127</td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>freqBodyAccMagStd</td>
      <td>Row 12</td>
      <td>The standard deviation of the frequency of the body acceleration magintude</td>
      <td>-0.548269931 to -0.734883057</td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>freqBodyAccMeanFreqX</td>
      <td>Row 13</td>
      <td>The mean frequency of the body acceleration in the X direction</td>
      <td>-0.106763419 to -0.319171142</td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>freqBodyAccMeanFreqY</td>
      <td>Row 14</td>
      <td>The mean frequency of the body acceleration in the Y direction</td>
      <td>0.128076958 to -0.153083508</td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>freqBodyAccMeanFreqZ</td>
      <td>Row 15</td>
      <td>The mean frequency of the body acceleration in the Z direction</td>
      <td>0.160383894 to -0.107844299</td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>freqBodyAccMeanX</td>
      <td>Row 16</td>
      <td>The mean  body acceleration in the X direction</td>
      <td>-0.506174926 to -0.74841651</td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>freqBodyAccMeanY</td>
      <td>Row 17</td>
      <td>The mean body acceleration in the Y direction</td>
      <td>-0.374944236 to -0.671572147</td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>freqBodyAccMeanZ</td>
      <td>Row 18</td>
      <td>The mean body acceleration in the Z direction</td>
      <td>-0.440650672 to -0.761229192</td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>freqBodyAccStdX</td>
      <td><p>Row 19</p></td>
      <td>The standard deviation of the body acceleration in the X direction measured by the accelerometer</td>
      <td>-0.492829886 to -0.705223687</td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>freqBodyAccStdY</td>
      <td>Row 20</td>
      <td>The standard deviation of the body acceleration in the Y direction measured by the accelerometer</td>
      <td>-0.376829989 to -0.661844531</td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>freqBodyAccStdZ</td>
      <td>Row 21</td>
      <td>The standard deviation of the body acceleration in the Z direction measured by the accelerometer</td>
      <td>-0.275013722 to -0.718490476<br></td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>freqBodyBodyAccJerkMagMean</td>
      <td>Row 22</td>
      <td>Mean Jerk body acceleration magnitude used in determining an angle vector and measured by the accelerometer</td>
      <td>-0.494882316 to -0.779190076<br></td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>freqBodyBodyAccJerkMagMeanFreq</td>
      <td>Row 23</td>
      <td>Mean Jerk body acceleration frequency magnitude used in determining an angle vector and measured by the accelerometer</td>
      <td>0.27152887 to 0.081704621<br></td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>freqBodyBodyAccJerkMagStd</td>
      <td>Row 24</td>
      <td>Standard deviation of the Jerk body acceleration used in determining an angle vector and measured by the accelerometer</td>
      <td>-0.516711262 to -0.78354723<br></td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>freqBodyBodyGyroJerkMagMean</td>
      <td>Row 25</td>
      <td>Mean gyroscope Jerk body acceleration magnitude used in determining an angle vector</td>
      <td>-0.58411105 to -0.884663023</td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>freqBodyBodyGyroJerkMagMeanFreq</td>
      <td>Row 26</td>
      <td>Mean gyroscope Jerk body acceleration frequency magnitude used in determining an angle vector</td>
      <td>0.232792536 to -0.002009238<br></td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>freqBodyBodyGyroJerkMagStd</td>
      <td>Row 27</td>
      <td>Standard deviation of the  gyroscope Jerk body acceleration frequency magnitude used in determining an angle vector</td>
      <td>-0.593735302 to -0.902206781<br></td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>freqBodyBodyGyroMagMean</td>
      <td>Row 28</td>
      <td>Mean magnitude of the body acceleration magnitude derived from the gyroscope </td>
      <td>-0.534657192 to -0.817128819<br></td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>freqBodyBodyGyroMagMeanFreq</td>
      <td><p>Row 29</p></td>
      <td>Mean frequency of the body acceleration magnitude derived from the gyroscope </td>
      <td>0.154723198 to -0.22082033<br></td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>freqBodyBodyGyroMagStd</td>
      <td>Row 30</td>
      <td>Standard deviation of the magnitude of the body acceleration magnitude derived from the gyroscope </td>
      <td>-0.516930496 to -0.802078223<br></td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>freqBodyGyroMeanFreqX</td>
      <td>Row 31</td>
      <td>Mean frequency of the body acceleration in the X direction derived from the gyroscope </td>
      <td>0.028908719 to -0.241341061<br></td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>freqBodyGyroMeanFreqY</td>
      <td>Row 32</td>
      <td>Mean frequency of the body acceleration in the Y direction derived from the gyroscope </td>
      <td>-0.042790021 to -0.375332545<br></td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>freqBodyGyroMeanFreqZ</td>
      <td>Row 33</td>
      <td>Mean frequency of the body acceleration in the Z direction derived from the gyroscope </td>
      <td>0.101044784 to -0.212818475<br></td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>freqBodyGyroMeanX</td>
      <td>Row 34</td>
      <td>Mean of the body acceleration derived from the gyroscope in the X direction</td>
      <td>-0.537201442 to -0.789780147<br></td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>freqBodyGyroMeanY</td>
      <td>Row 35</td>
      <td>Mean of the body acceleration derived from the gyroscope in the Y direction</td>
      <td>-0.497783811 to -0.831527531<br></td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>freqBodyGyroMeanZ</td>
      <td>Row 36</td>
      <td>Mean of the body acceleration derived from the gyroscope in the Z direction</td>
      <td>-0.423918214 to -0.756286642<br></td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>freqBodyGyroStdX</td>
      <td>Row 37</td>
      <td>Standard deviation of the body acceleration derived from the gyroscope in the X direction</td>
      <td>-0.666071316 to -0.812175241<br></td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>freqBodyGyroStdY</td>
      <td>Row 38</td>
      <td>Standard deviation of the body acceleration derived from the gyroscope in the Y direction</td>
      <td>-0.348864187 to -0.809421448<br></td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>freqBodyGyroStdZ</td>
      <td><p>Row 39</p></td>
      <td>Standard deviation of the body acceleration derived from the gyroscope in the Z direction</td>
      <td>-0.407672097 to -0.771208929</td>
      <td>a normalised frequency value in hertz (Hz)</td>
    </tr>
    <tr>
      <td>timeBodyAccJerkMagMean</td>
      <td>Row 40</td>
      <td>Time domain mean of body acceleration Jerk magnitude measurement measured by the accelerometer</td>
      <td>-0.534248617 to -0.783445354<br></td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeBodyAccJerkMagStd</td>
      <td>Row 41</td>
      <td>Time domain standard deviation of body acceleration Jerk magnitude measurement measured by the accelerometer</td>
      <td>-0.502935062 to -0.780451868<br></td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeBodyAccJerkMeanX</td>
      <td>Row 42</td>
      <td>Time domain mean of body acceleration Jerk measurement in the X direction</td>
      <td>0.084215745 to 0.070173126<br></td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeBodyAccJerkMeanY</td>
      <td>Row 43</td>
      <td>Time domain mean of body acceleration Jerk measurement in the Y direction measured by the accelerometer</td>
      <td>0.020047096 to 0.000479281<br></td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeBodyAccJerkMeanZ</td>
      <td>Row 44</td>
      <td>Time domain mean of body acceleration Jerk measurement in the Z direction</td>
      <td>0.00270288 to -0.019671991<br></td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeBodyAccJerkStdX</td>
      <td>Row 45</td>
      <td>Time domain standard deviation of body acceleration Jerk  measurement in the X direction measured by the accelerometer</td>
      <td>-0.524721923 to -0.79682335<br></td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeBodyAccJerkStdY</td>
      <td>Row 46</td>
      <td>Time domain standard deviation of body acceleration Jerk  measurement in the Y direction measured by the accelerometer</td>
      <td>-0.454437497 to -0.735080198</td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeBodyAccJerkStdZ</td>
      <td>Row 47</td>
      <td>Time domain standard deviation of body acceleration Jerk  measurement in the Z direction measured by the accelerometer</td>
      <td>-0.60304877 to -0.860669383<br></td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeBodyAccMagMean</td>
      <td>Row 48</td>
      <td>Time domain mean of body acceleration magnitude vector measured by the accelerometer</td>
      <td>-0.45326262 to -0.658370952<br></td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeBodyAccMagStd</td>
      <td><p>Row 49</p></td>
      <td>Time domain standard deviation of body acceleration magnitude vector</td>
      <td>-0.474058613 to -0.68967189<br></td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeBodyAccMeanX</td>
      <td>Row 50</td>
      <td>Time domain mean of body acceleration magnitude measurement in the X direction measured by the accelerometer</td>
      <td>0.27917796 to 0.265696921</td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeBodyAccMeanY</td>
      <td>Row 51</td>
      <td>Time domain mean of body acceleration magnitude measurement in the Y direction measured by the accelerometer</td>
      <td>-0.014808155 to -0.020946656<br></td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeBodyAccMeanZ</td>
      <td>Row 52</td>
      <td>Time domain mean of body acceleration magnitude measurement in the Z direction measured by the accelerometer</td>
      <td>-0.100985936 to -0.11827718<br></td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeBodyAccStdX</td>
      <td>Row 53</td>
      <td>Time domain standard deviation of body acceleration magnitude measurement in the X direction measured by the accelerometer</td>
      <td>-0.505086085 to -0.716264538<br></td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeBodyAccStdY</td>
      <td>Row 54</td>
      <td>Time domain standard deviation  of body acceleration magnitude measurement in the Y direction measured by the accelerometer</td>
      <td>-0.349383732 to -0.649947068<br></td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeBodyAccStdZ</td>
      <td>Row 55</td>
      <td>Time domain standard deviation  of body acceleration magnitude measurement in the Z direction measured by the accelerometer</td>
      <td>-0.293542715 to -0.709492736<br></td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeBodyGyroJerkMagMean</td>
      <td>Row 56</td>
      <td>Time domain mean of body acceleration Jerk magnitude vector measured by the gyroscope</td>
      <td>-0.621936159 to -0.860446372<br></td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeBodyGyroJerkMagStd</td>
      <td>Row 57</td>
      <td>Time domain standard deviation of body acceleration Jerk magnitude vector measured by the gyroscope</td>
      <td>-0.573942888 to -0.888565337<br></td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeBodyGyroJerkMeanX</td>
      <td>Row 58</td>
      <td>Time domain mean of body acceleration Jerk magnitude vector in the X direction measured by the gyroscope</td>
      <td>-0.073113438 to -0.109257562<br></td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeBodyGyroJerkMeanY</td>
      <td><p>Row 59</p></td>
      <td>Time domain mean of body acceleration Jerk magnitude vector in the Y direction measured by the gyroscope</td>
      <td>-0.038320874 to -0.049391407<br></td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeBodyGyroJerkMeanZ</td>
      <td>Row 60</td>
      <td>Time domain mean of body acceleration Jerk magnitude vector in the Z direction measured by the gyroscope</td>
      <td>-0.045069384 to -0.062195909<br></td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeBodyGyroJerkStdX</td>
      <td>Row 61</td>
      <td>Time domain standard deviation of body acceleration Jerk magnitude vector in the X direction measured by the gyroscope</td>
      <td>-0.546009968 to -0.858298719</td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeBodyGyroJerkStdY</td>
      <td>Row 62</td>
      <td>Time domain standard deviation of body acceleration Jerk magnitude vector in the Y direction measured by the gyroscope</td>
      <td>-0.546043594 to -0.902628081<br></td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeBodyGyroJerkStdZ</td>
      <td>Row 63</td>
      <td>Time domain standard deviation of body acceleration Jerk magnitude vector in the Z direction measured by the gyroscope</td>
      <td>-0.526908306 to -0.838614663<br></td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeBodyGyroMagMean</td>
      <td>Row 64</td>
      <td>Time domain mean of the body acceleration magnitude vector measured by the gyroscope</td>
      <td>-0.416459777 to -0.718168776<br></td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeBodyGyroMagStd</td>
      <td>Row 65</td>
      <td>Time domain standard deviation of body acceleration  magnitude vector measured by the gyroscope</td>
      <td>-0.471486715 to -0.784822866<br></td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeBodyGyroMeanX</td>
      <td>Row 66</td>
      <td>Time domain mean of the body acceleration magnitude vector measured by the gyroscope in the X direction</td>
      <td>0.003590539 to -0.070131815<br></td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeBodyGyroMeanY</td>
      <td>Row 67</td>
      <td>Time domain mean of the body acceleration magnitude vector measured by the gyroscope  in the Y direction</td>
      <td>-0.047147402 to -0.095492115<br></td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeBodyGyroMeanZ</td>
      <td>Row 68</td>
      <td>Time domain mean of the body acceleration magnitude vector measured by the gyroscope  in the Z direction</td>
      <td>0.109092913 to 0.060671245<br></td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeBodyGyroStdX</td>
      <td><p>Row 69</p></td>
      <td>Time domain standard deviation of the body acceleration magnitude vector measured by the gyroscope in the X direction</td>
      <td>-0.637789915 to -0.804533729</td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeBodyGyroStdY</td>
      <td>Row 70</td>
      <td>Time domain standard deviation  of the body acceleration magnitude vector measured by the gyroscope  in the Y direction</td>
      <td>-0.398959363 to -0.810124134<br></td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeBodyGyroStdZ</td>
      <td>Row 71</td>
      <td>Time domain standard deviation  of the body acceleration magnitude vector measured by the gyroscope  in the Z direction</td>
      <td>-0.364478193 to -0.74741022<br></td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeGravityAccMagMean</td>
      <td>Row 72</td>
      <td>Time domain mean of gravitational acceleration magnitude vector measured by the accelerometer</td>
      <td>-0.45326262 to -0.658370952<br></td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeGravityAccMagStd</td>
      <td>Row 73</td>
      <td>Time domain standard deviation of gravitational acceleration magnitude vector</td>
      <td>-0.474058613 to -0.68967189<br></td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeGravityAccMeanX</td>
      <td>Row 74</td>
      <td>Time domain mean of gravitational acceleration magnitude measurement in the X direction measured by the accelerometer</td>
      <td>0.744867412 to 0.475323016<br></td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeGravityAccMeanY</td>
      <td>Row 75</td>
      <td>Time domain mean of gravitational acceleration magnitude measurement in the Y direction measured by the accelerometer</td>
      <td>0.115489758 to -0.147577755<br></td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeGravityAccMeanZ</td>
      <td>Row 76</td>
      <td>Time domain mean of gravitational acceleration magnitude measurement in the Z direction measured by the accelerometer</td>
      <td>0.239226041 to -0.161179728<br></td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeGravityAccStdX</td>
      <td>Row 77</td>
      <td>Time domain standard deviation of gravitational acceleration magnitude measurement in the X direction measured by the accelerometer</td>
      <td>-0.941245715 to -0.980138676</td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeGravityAccStdY</td>
      <td>Row 78</td>
      <td>Time domain standard deviation of gravitational acceleration magnitude measurement in the Y direction measured by the accelerometer</td>
      <td>-0.901088771 to -0.972505175</td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
    <tr>
      <td>timeGravityAccStdZ</td>
      <td><p>Row 79</p></td>
      <td>Time domain standard deviation of gravitational acceleration magnitude measurement in the Z direction measured by the accelerometer</td>
      <td>-0.880682331 to -0.959434178</td>
      <td>a normalised time value (m/s^2)</td>
    </tr>
</table>
