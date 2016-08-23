url_1<- url<-'https://raw.githubusercontent.com/meltemballan/R_data_frames/master/Training_1.csv'
dat_1<-read.csv(url_1,stringsAsFactors=FALSE)
url_2<-'https://raw.githubusercontent.com/meltemballan/R_data_frames/master/Training_2.csv'
dat_2<-read.csv(url_2,stringsAsFactors=FALSE, header=FALSE)
colnames(dat_2)<-names(dat_1)
dat_df<-rbind(dat_1,dat_2)
str(dat_df)
dat_df$Date.received<- as.Date(dat_df$Date.received, "%m/%d/%Y")
dat_df$Date.sent.to.company <- as.Date(dat_df$Date.sent.to.company, "%m/%d/%Y")
dat_df<-subset(dat_df, ,-c(Company.public.response,Consumer.consent.provided.,Consumer.complaint.narrative,Tags ))
str(dat_df)
names(dat_df)[names(dat_df)=="X"]<-"Customer_ID"
dat_df<-dat_df[order(dat_df$Date.received),]
dat_df<-dat_df[complete.cases(dat_df),]
unique(nchar(dat_df$Customer_ID))
dat_df<-dat_df[nchar(dat_df$Customer_ID)==5,]
View(dat_df)
View(table(dat_df$Customer_ID))
complains<-table(dat_df$Customer_ID)
barplot(table(dat_df$Customer_ID),names=unique(dat_df$Customer_ID))
View(table(paste(dat_df$Customer_ID,dat_df$Date.received)))
dat_df<-within(dat_df, date_Index <- ave(as.numeric(Date.received), list(Customer_ID), FUN=function(x) x-x[1]))
Freq_Complaints<-dat_df[dat_df$date_Index>0,]
View(table(dat_df$Product))
pie(table(dat_df$Product))
png(filename="pie_chart.png")
pie(table(dat_df$Product))
dev.off()
write.csv(Freq_Complaints,file="Freq_Complaints.csv")