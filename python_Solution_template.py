# import pandas, numpy
# Create the required data frames by reading in the files

# Q1 Find least sales amount for each item
# has been solved as an example
def least_sales(df):
    # write code to return pandas dataframe
    ls = df.groupby(["Item"])["Sale_amt"].min().reset_index()
    return ls

# Q2 compute total sales at each year X region
def sales_year_region(df):
    # write code to return pandas dataframe
    ans=df.groupby("Region").sum().sort_values("Sale_amt")
    return ans

# Q3 append column with no of days difference from present date to each order date
def days_diff(df):
    # write code to return pandas dataframe
    df['days_diff']=pd.to_datetime("now")-df['OrderDate']
    return df
  
    

# Q4 get dataframe with manager as first column and  salesman under them as lists in rows in second column.
def mgr_slsmn(df):
    # write code to return pandas dataframe
    gkk = df.groupby(['Manager', 'SalesMan'])
    return gkk

# Q5 For all regions find number of salesman and number of units
def slsmn_units(df):
    # write code to return pandas dataframe
    ans=df[['Region','Sale_amt']].groupby(['Region']).agg(['count', 'sum'])
    return ans

# Q6 Find total sales as percentage for each manager
def sales_pct(df4):
    sumdf4 = df4.groupby(['Manager']).sum().sort_values("Sale_amt")
    t=df.sum().Sale_amt
    rt=pd.DataFrame(sumdf4.div(t, level='Manager') * 100)
    rt = rt.rename(columns = {"Sale_amt":"Percentage"})

    # write code to return pandas dataframe
    return rt

# Q7 get imdb rating for fifth movie of dataframe
def fifth_movie(df):
	# write code here
    df = pd.read_csv('imdb.csv', header=0, escapechar='\\')
    return df.imdbRating[4]
    

# Q8 return titles of movies with shortest and longest run time
def movies(df):
	# write code here
    df2 = df[['wordsInTitle', 'duration']]
    result1 = df2[df2["duration"]==df2.duration.min()]
    result2 = df2[df2["duration"]==df2.duration.max()]
    return(result1,result2)





# Q9 sort by two columns - release_date (earliest) and Imdb rating(highest to lowest)
def sort_df(df):
	# write code here
    result = df.sort_values(['year','imdbRating'], ascending=[True, False])
    return result

# Q10 subset revenue more than 2 million and spent less than 1 million & duration between 30 mintues to 180 minutes
def subset_df(df):
	# write code here
    result = df[(df['duration'] > 30) & (df['duration'] < 180)]
    return result

# Q11 count the duplicate rows of diamonds DataFrame.
def dupl_rows(df):
	# write code here
    a=df.duplicated().sum()
    return a
# Q12 droping those rows where any value in a row is missing in carat and cut columns
def drop_row(df):
	# write code here
    df2=df.dropna(subset=['carat', 'cut'], how='any')
    return df2

# Q13 subset only numeric columns
def sub_numeric(df):
	# write code here
    df3=df.select_dtypes(include=[np.number])
    return df3

# Q14 compute volume as (x*y*z) when depth > 60 else 8
def volume(df):
	# write code here
 
    df['volume']=np.zeros(len(df))
    for i in range(0,len(df)):
    if(df['depth'][i]>60):
        df['volume'][i]=df['x'][i]*df['y'][i]*df['z'][i]
    else:
        df['volume'][i]=8
    return df

    

# Q15 impute missing price values with mean
def impute(df):
	# write code here
    result=df.fillna(df.price.mean())
    return result
#BONUS QUESTIONS
#q1
def rep(df):
    df1=df.filter(['year','type','imdbRating','duration'],axis=1)
    df2=df.iloc[:,17:46]
    str=""
    df1["Genre_combo"]=(df2.apply(lambda x: x.index[x.astype(bool)].tolist(),1)).apply(lambda x: str.join(x))
    df1=df1.groupby(['year','Genre_combo','type']).agg({'imdbRating':[min,max,np.mean],'duration':np.sum})
    return df1

#q2
def perc(df):
    df.dropna(inplace=True)
    fms=pd.DataFrame()
    fms=df.filter(["imdbRating","year","duration"],axis=1)
    fms['length_title']=df["wordsInTitle"].str.len()
    fms['length_title'].corr(fms["imdbRating"])
    quantile=pd.DataFrame(df["duration"].quantile([0.25,0.5,0.75]).reset_index())
    fms['percentile']=fms["duration"].apply(lambda x:1 if x<quantile.iloc[0,1] else(2 if x<quantile.iloc[1,1] else (3 if x< quantile.iloc[2,1] else 4)))
    fm_table=fms.pivot_table(index="year",columns="percentile",values="length_title",aggfunc={"length_title":'count'},fill_value=0)
    fm_table[["min","max"]]=fms.groupby("year").agg({"length_title":[min,max]})
    return fm_table
#q3
def cross_tab(dm1):
    bins=(pd.qcut(list(dm1['Volume']),q=5,precision=1)).codes
    d=pd.CategoricalDtype(['1','2','3','4','5'],ordered=True)
    cat=pd.Categorical.from_codes(bins,dtype=d)
    return pd.crosstab(dm1['cut'],cat).apply(lambda r: r/r.sum(),axis=1)
#q4
def ans(df3):
    df1 = (df3.groupby('title_year').apply(lambda x: x.nlargest(int(len(x) * 0.1), 'gross')))
    df5=pd.DataFrame
    df5=df1.groupby('genres').agg({'movie_title':["unique","count"]})
    return df5
#q5


def (imdb1)
    imdb1['decile_2'] = pd.qcut(df['duration'], q=10, labels= False)
    imdb1.groupby('decile_2').agg({"nrOfNominations":"sum", "nrOfWins":"sum","title":'count',})

    return imdb1
#q6
def ans(df)
    an = Analyser(df, y='imdb_score')
    an.get_report(quick=False)
    return df