# R_data_frames
This note is intended to provide easy to follow instructions to seasoned analysts and budding data gigs 
In this note I will quickly talk about csv files on a basic scenario. 
I have loaded two csv files with customer complaints on my github account. The complaints are unique and a customer might complain more than once. Customer Id is encrypted as XX000 and assume that missing values don't have the same pattern and number of strings.
 After the basic preprocessing we want to know the number of complaints by customers and the time window between the first and last complaint.
There might be different ways of finding the number of complaints; however, I will use dates and compute the differences between the dates and I will find the biggest pain point. 
Let’s take a look at my reposotory:https://github.com/meltemballan/R_data_frames. You will see two files called Training_1 and Training_2. 
Let’s read the files one by one and see how they look:
>url_1<-'https://raw.githubusercontent.com/meltemballan/R_data_frames/master/Training_1.csv'
>dat_1<-read.csv(url_1,stringsAsFactors=FALSE)
>url_2<-'https://raw.githubusercontent.com/meltemballan/R_data_frames/master/Training_2.csv'
>dat_2<-read.csv(url_2,stringsAsFactors=FALSE)
>View(dat_1)
>View(dat_2)
Please note that the dat_1 looks slightly different than original file. As the default R inserts “.” to replace space between words of a column name. I prefer this version; but, you can prevent this by identifying check.names=FALSE (dat_1<-read.csv(url_1,check.names=FALSE).

Dat_2 is even messier than dat_1.dat_2 is missing the column names and using the first row of data as the column name. In order to prevent that we can tell R that there is no header like >dat_2<-read.csv(url_2,header=False, stringsAsFactors=FALSE)

This is another opportunity to go back on the notes and name the columns of dat_2:
> colnames(dat_2)<-names(dat_1)

Let’s append the files and start cleaning up.

>dat_df<-rbind(dat_1,dat_2)
> str(dat_df)
'data.frame':   37 obs. of  19 variables:
 $ Date.received               : chr  "1/5/2015" "1/12/2015" "1/6/2015" "1/11/2015" ...
 $ Product                     : chr  "Debt collection" "Consumer Loan" "Prepaid card" "Bank account or service" ...
 $ Sub.product                 : chr  "I do not know" "Installment loan" "General purpose card" "Checking account" ...
 $ Issue                       : chr  "Cont'd attempts collect debt not owed" "Managing the loan or lease" "Unauthorized transactions/trans. issues" "Account opening, closing, or management" ...
 $ Sub.issue                   : chr  "Debt is not mine" "" "" "" ...
 $ Consumer.complaint.narrative: logi  NA NA NA NA NA NA ...
 $ Company.public.response     : logi  NA NA NA NA NA NA ...
 $ Company                     : chr  "Allied Interstate LLC" "Amex" "Amex" "Bank of America" ...
 $ State                       : chr  "NJ" "HI" "GA" "CA" ...
 $ ZIP.code                    : int  7640 96792 31606 91309 23322 98110 17603 33952 97068 33308 ...
 $ Tags                        : chr  "Older American" "Older American" "Older American" "Older American" ...
 $ Consumer.consent.provided.  : chr  "N/A" "N/A" "N/A" "N/A" ...
 $ Submitted.via               : chr  "Web" "Web" "Web" "Web" ...
 $ Date.sent.to.company        : chr  "1/5/2015" "1/15/2015" "1/13/2015" "1/11/2015" ...
 $ Company.response.to.consumer: chr  "Closed with non-monetary relief" "Closed with explanation" "Closed with explanation" "Closed with explanation" ...
 $ Timely.response.            : chr  "Yes" "Yes" "Yes" "Yes" ...
 $ Consumer.disputed.          : chr  "No" "No" "No" "Yes" ...
 $ Complaint.ID                : int  1180307 1190491 1183093 1189651 1181357 1177393 1182283 1180596 1175029 1190524 ...
 $ X                           : chr  "AI001" "AM001" "AM002" "BA001" ...

The data includes a date column. There are two dates to be considered Date.Received and Date.sent.to.company. The dates formatted as dd/mm/yyyy. Let’s make sure that R knows that:
> dat_df$Date.received<- as.Date(dat_df$Date.received, "%m/%d/%Y")
> dat_df$Date.sent.to.company <- as.Date(dat_df$Date.sent.to.company, "%m/%d/%Y")
Interpreting the data further, it  seems like Consumer.complaint.narrative,Company.public.response and Consumer.consent.provided have never provided. We don’t need those information and we can simply remove them from further explorations. In the same token, the Tags are the same for all. So, let’s clean those up. 

When we call the summary of data we will see that we have less variables; but, it is obvious that we need to take couple steps further even before we start making the data visually appealing.

> str(dat_df)
'data.frame':   37 obs. of  15 variables:
 $ Date.received               : Date, format: "2015-01-05" "2015-01-12" ...
 $ Product                     : chr  "Debt collection" "Consumer Loan" "Prepaid card" "Bank account or service" ...
 $ Sub.product                 : chr  "I do not know" "Installment loan" "General purpose card" "Checking account" ...
 $ Issue                       : chr  "Cont'd attempts collect debt not owed" "Managing the loan or lease" "Unauthorized transactions/trans. issues" "Account opening, closing, or management" ...
 $ Sub.issue                   : chr  "Debt is not mine" "" "" "" ...
 $ Company                     : chr  "Allied Interstate LLC" "Amex" "Amex" "Bank of America" ...
 $ State                       : chr  "NJ" "HI" "GA" "CA" ...
 $ ZIP.code                    : int  7640 96792 31606 91309 23322 98110 17603 33952 97068 33308 ..    $ Submitted.via               : chr  "Web" "Web" "Web" "Web" ...
 $ Date.sent.to.company        : Date, format: "2015-01-05" "2015-01-15" ...
 $ Company.response.to.consumer: chr  "Closed with non-monetary relief" "Closed with explanation" "Closed with explanation" "Closed with explanation" ...
 $ Timely.response.            : chr  "Yes" "Yes" "Yes" "Yes" ...
 $ Consumer.disputed.          : chr  "No" "No" "No" "Yes" ...
 $ Complaint.ID                : int  1180307 1190491 1183093 1189651 1181357 1177393 1182283 1180596 1175029 1190524 ...
 $ X                           : chr  "AI001" "AM001" "AM002" "BA001" …

X as a column name seems like an error or overlook at the data.Assume that the variables in the column are Customer IDs. So, we can call the column name as Customer_ID.
> names(dat_df)[names(dat_df)=="X"]<-"Customer_ID"
I feel like the data looks better now. We can order the records by the date received. 

>dat_df<-dat_df[order(dat_df$Date.received),]
NOTE: Make sure to put the comma at the end as we are doing operations with multidimensional data frames
What if we only want to use the complete table? That is also a very easy request for R. I will use the simplest way I know which is complete.cases method:
>dat_df<-dat_df[complete.cases(dat_df),]
>str(dat_df)
NOTE: “complete.cases” only works with NA. It didn't help us to omit all the rows without customer ID.
Let’s get a little fancy and use nchar. It seems like the format of Customer_ID is LetterLetterNumberNumberNumber (5 characters). 
>unique(nchar(dat_df$Customer_ID))
>dat_df<-dat_df[nchar(dat_df$Customer_ID)==5,]
>View(dat_df)
>View(table(dat_df$Customer_ID))
NOTE: You can also try the regular expression command grep to find the patterns and select the Customers with an ID matching the pattern.
We are very much interested to know the frequency of the complaints and we can simple apply table function and visualize on a histogram.
> complains<-table(dat_df$Customer_ID)
> barplot(table(dat_df$Customer_ID),names=unique(dat_df$Customer_ID))
Let’s see whether there is a peak date where the most complaints are received.
>View(table(paste(dat_df$Customer_ID,dat_df$Date.received)))
As I mentioned I wanted to use date information for the analysis. So, let’s find the differences between first and last days of a customer’s complaint. 
>dat_df<-within(dat_df, date_Index <- ave(as.numeric(Date.received), list(Customer_ID), FUN=function(x) x-x[1]))
>Freq_Complaints<-dat_df[dat_df$date_Index>0,]
We can also look at the problematic products visually as a  table and chart it:  
> View(table(dat_df$Product))
>pie(table(dat_df$Product))
Let’s save the pie chart to use in this publication. 
NOTE: getwd() # to see if we are in the working directory that we want to be in
# if not remember setwd()
>png(filename="pie_chart.png")
>pie(table(dat_df$Product))
>dev.off()
Let's save a copy of the file on our local directory
>write.csv(Freq_Complaints,file="Freq_Complaints.csv")
