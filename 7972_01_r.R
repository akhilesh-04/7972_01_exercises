#sales dataset
df<-read_excel('SaleData.xlsx',sheet='Sales Data')
#Q1.
least_sales<- function(df)
{
  df1<-aggregate(df$Sale_amt,by=list(item=df$Item),FUN=min)
  return(df1)
}

#Q2.
df$year<-format(as.Date(df$OrderDate , format="%d/%m/%Y"),"%Y")

sales_year_region<-function(df)
{
  df$year<-format(as.Date(df$OrderDate , format="%d/%m/%Y"),"%Y")
  df1<-df %>% group_by(year,Region) %>%  summarise(Net = sum(Sale_amt))
  return(df1)
}

#Q3.
days_diff<-function(df)
{
  df2<-df
  df2$days_diff<-as.numeric(Sys.Date()- as.Date(df$OrderDate))
  return(df2)
}

#Q4.
mgr_slsman<-function(df)
{
  df2<-lapply(split(df$SalesMan, df$Manager) , unique)
  return(df2)
}

#q5.
slsman_units<-function(df)
{
  df1<-df %>% group_by(Region) %>%  summarise(total = sum(Sale_amt),count=n_distinct(SalesMan))
  return(df1)
}

#Q6.
sales_pct<-function(df)
{
  df1<-df %>% group_by(Manager) %>% summarise(total = sum(Sale_amt))
  df11<-mutate(df1, mtcars_new = 100*total /sum(df1$total))
  return(df11)
}

#IMDB DATASET
#DATA preprocessing: -
df<-read.csv('imdb.csv',sep=",")
#Q7.Get the imdb rating for fifth movie of dataframe
imdb=read.csv('imdb.csv',skipNul = TRUE,stringsAsFactors = FALSE)
imdb=na.omit(imdb)
imdb[5,'imdbRating']
#q8
imdb['duration']=as.numeric(as.character(imdb$duration))
imdb=na.omit(imdb)
imdb[imdb['duration'] == min(imdb['duration']) | imdb['duration'] ==max(imdb['duration'])]
#q9
imdb1=arrange(imdb,as.year(year),desc(imdbRating))
#q10
filter(imdb,as.numeric(duration)>=30,as.numeric(duration<=180))


#DIAMONDS.csv
df<-read.csv('diamonds.csv')
#Q11
dupl_rows<-function(df)
{
  return(nrow(df)-nrow(unique(df)))
}

#Q12
drop_row<-function(df)
{
  ans<-na.omit(df,as.list('carat','cut'))
  return(ans)
}

#Q13
sub_numeric<-function(df)
{
  ans<-select_if(df,is.numeric)
  return(ans)
}

#Q14
#Compute volume as (x y z) when depth is greater than 60.
#In case of depth less than 60 default volume to 8
volume<-function(df)
{
  df$x <- as.double(df$x) 
  df$y <- as.double(df$y) 
  df$z <- as.double(df$z) 
  df$volume=0
  for(i in 1:nrow(df))
  {
    if(df[i,'depth']>=60)
    {
      df[i,'volume']=df[i,'x']*df[i,'y']*df[i,'z']
    }
    else
    {
      df[i,'volume']=8
    }
  }
  return(df)
}

#Q15
impute<-function(df)
{
  df[is.na(df$price),]['price']=mean(df$price,na.rm=TRUE)
  ans<-df
  return(ans)
}
#BONUS Q1
bonus1 <- function(df){
  df2<-df %>%select(16:44)
  df['genre_combo'] <- apply(df2,1,function(x) paste(names(x[x==1]),collapse=" "))
  df2<- df%>% group_by(year,type,genre_combo)%>%
    summarise(avg_rating=mean(imdbRating),min_rating=min(imdbRating),max_rating=max(imdbRating),total_run_time_mins=(sum(duration)/60))
  return(df2)
}
#BONUS Q2
bonus2<-function(df.2)
{ 
  x<-na_mean(df.2)
  x$year=floor(x$year)
  x$len=nchar(x$wordsInTitle)
  x[is.na(x$wordsInTitle),"len"]=nchar(as.character(unlist(x[is.na(x$wordsInTitle),"title"])))
  x$percentile<-bin_data(x$duration,bins=4,binType = "quantile")
  d<-as.data.frame.matrix(table(x$year,x$percentile))
  colnames(d)<-c("num_videos_less_than25Percentile","num_videos_25_50Percentile ","num_videos_50_75Percentile","num_videos_greaterthan75Precentile")
  y<-x%>%group_by(year)%>%summarise(min=min(len),max=max(len))
  return (cbind(y,d))
}
#BONUS Q3
bonus3<-function(df){
  
  
  df$volume2 <- as.numeric(ntile(df$volume,5))
  CT<-table(df$cut,df$volume2)
  CT<-prop.table(as.matrix(CT[,1:5]), margin = 1)
  return(CT)
  
}
#BONUS Q4
bonus4<-function(df)
{
  df=na.omit(df)
  x=df %>% group_by(title_year)
  x=x[with(x,order(-gross)),]
  x<-x %>% group_map(~head(.x,ifelse(nrow(.x)<10,1,as.numeric(0.1*nrow(.x)))),keep=TRUE)%>%bind_rows()
  t<-x %>%group_by(title_year,genres)%>%summarise(avg=mean(imdb_score),count=n())
  return(t)
}

#BONUS Q5
bonus5 <-function(df){  
  df<-df[!is.na(df$duration),]
  df1<-mutate(df, decile_rank = as.numeric(bin_data(df$duration, bins = 10,binType = "quantile"))) 
  dfgenre<-df1%>%group_by(decile_rank)%>%summarize_if(is.numeric, sum, na.rm=TRUE)
  dfgenre<-dfgenre %>%select(12:39)
  df2<- df1%>% group_by(decile_rank)%>%
    summarise(sum_nom=sum(nrOfNominations),sum_rating=sum(nrOfWins),NO=n())
  df2["TOP3"]<- col_concat(t(apply(dfgenre,1,function(x) names(x)[-1][order(x[-x],na.last=NA)][1:3])),sep=" ")
  return(df2)}
#BONUS Q6
bonus6<-function(df){
  IMDB <- df[df$title_year >= 1980,]
  ggplot(IMDB, aes(title_year)) +
    geom_bar() +
    labs(x = "Year movie was released", y = "Movie Count", title = "Histogram of Movie released") +theme(axis.text.x = element_text( vjust = 01)) +
    xlab("title_year") +
    theme(plot.title = element_text(hjust = 0.5))
  #2nd Insight
  library(shiny)
  library(formattable)
  library(plotly)
  df %>%
    group_by(director_name) %>%
    summarise(avg_imdb = mean(imdb_score))%>%
    arrange(desc(avg_imdb)) %>%
    top_n(20, avg_imdb)  %>% formattable(list(avg_imdb = color_bar("orange")), align = 'l')
  #3rd Insight
  IMDB %>%
    plot_ly(x = ~movie_facebook_likes, y = ~imdb_score, color = ~content_rating , mode = "markers", text = ~content_rating, alpha = 1, type = "scatter")
}

