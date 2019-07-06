---
title: 'Python数据处理分析(1)：日期型数据处理'
date: 2018-09-11 09:36:41
id: python_data_analysis&mining01
categories: Python数据清洗处理
tags: [Python数据分析,Python包,Tushare]
images: http://media.makcyun.top/18-9-24/10908675.jpg
keywords:

---

以调用大名鼎鼎的Tushare包案例，介绍日期数据的处理。

<!-- more -->  

**摘要：** Python数据处理分析中，日期型数据的处理是相对复杂且非常重要的一环。本文以调用Tushare包获得股票的各种信息数据为案例，介绍日期数据的处理。

之前的[一篇文章](https://www.makcyun.top/web_scraping_withpython2.html)用爬虫实现了上市公司信息的抓取。但还有更简单的方法，就是调用Tushare包，可以很便捷地拿到干净的各种股市数据。

强烈推荐一下这款由国内团队开发的包，Github上目前Star数 6000+。Tushare是一个开源免费、强大的python金融财经数据接口包。调用该包返回的数据格式基本是Pandas DataFrame类型，非常便于后续处理分析。包的数据来源于新浪财经、腾讯财经、上交所和深交所，比较齐全，质量也很可靠。

> 参考：
> https://tushare.pro/document/2
> https://github.com/waditu/Tushare

下面我们就来简单体检一下这款包的便利，然后利用它返回的数据处理其中的日期型数据。

## 1. 获取数据 ##

接口使用前提：首先在官网注册成功后获得token，然后通过下面命令下载Tushare包，然后在程序中调用就可以使用了。
```python 
pip instasll tushare
```
可以获得的信息接口非常多，包括：行情数据、基础数据、财务数据板块等。
![](http://media.makcyun.top/18-9-11/86932586.jpg)  

下面就简单使用下部分接口。首先，获取国内股票列表数据。
```python
import tushare as ts
ts.set_token('你的token')
pro = ts.pro_api()
data = pro.stock_basic(exchange_id='', is_hs='', fields='symbol,name,is_hs,list_date,list_status')
print(data)
# ''表示获取全部
```
`exchange_id`表示股票代码，可以获取特定股票的基础信息，为空则获取全部;`is_hs`表示是否沪深港通，为空表示提取所有股市；`fields`表示想要提取的信息列表。

结果如下：

```python
        ts_code  symbol  name list_status  list_date is_hs
0     000001.SZ  000001  平安银行           L   19910403     S
1     000002.SZ  000002   万科A           L   19910129     S
2     000004.SZ  000004  国农科技           L   19910114     N
3     000005.SZ  000005  世纪星源           L   19901210     N
4     000006.SZ  000006  深振业A           L   19920427     S
5     000007.SZ  000007   全新好           L   19920413     N
6     000008.SZ  000008  神州高铁           L   19920507     S
7     000009.SZ  000009  中国宝安           L   19910625     S
8     000010.SZ  000010  美丽生态           L   19951027     N
9     000011.SZ  000011  深物业A           L   19920330     S
10    000012.SZ  000012   南玻A           L   19920228     S
···
3532  603987.SH  603987   康德莱           L   20161121     N
3533  603988.SH  603988  中电电机           L   20141104     N
3534  603989.SH  603989  艾华集团           L   20150515     H
3535  603990.SH  603990  麦迪科技           L   20161208     N
3536  603991.SH  603991  至正股份           L   20170308     N
3537  603993.SH  603993  洛阳钼业           L   20121009     H
3538  603996.SH  603996  中新科技           L   20151222     N
3539  603997.SH  603997  继峰股份           L   20150302     H
3540  603998.SH  603998  方盛制药           L   20141205     N
3541  603999.SH  603999  读者传媒           L   20151210     N
```
很轻松地就能获得3542家上市公司的基本情况。下面就将这个数据作为日期型处理的基础数据。

## 2. 日期型数据处理

查看一下数据结构：

```python
RangeIndex: 3542 entries, 0 to 3541
Data columns (total 6 columns):
ts_code        3542 non-null object
symbol         3542 non-null object
name           3542 non-null object
list_status    3542 non-null object
list_date      3542 non-null object
is_hs          3542 non-null object
dtypes: object(6)
```
所有列都是object字符型。这里想对日期做数据分析，比如可以统计一下历年上市公司数量。需更改日期型数据字符型为日期型。
```python
data['list_date'] = pd.to_datetime(data['list_date'])
```
pd.to_datetime将'list_date'列格式改为datetime格式，再来看一下：

```python
RangeIndex: 3542 entries, 0 to 3541
Data columns (total 6 columns):
ts_code        3542 non-null object
symbol         3542 non-null object
name           3542 non-null object
list_status    3542 non-null object
list_date      3542 non-null datetime64[ns]
is_hs          3542 non-null object
dtypes: object(6)
```

### 2.1. 按日期切片筛选数据

有时候我们需要按年、季度、月、日这样的日期格式来筛选提取相应的数据。

#### 2.1.1. 按年度

- 获取单一年份数据，比如2017年

```python
data = data.set_index(data['list_date'])
data = data['2017']
print(data.head())
# 结果
              ts_code  symbol  name list_status  list_date is_hs
list_date                                                       
2017-12-25  001965.SZ  001965  招商公路           L 2017-12-25     S
2017-03-24  002774.SZ  002774  快意电梯           L 2017-03-24     N
2017-01-12  002824.SZ  002824  和胜股份           L 2017-01-12     N
2017-01-06  002838.SZ  002838  道恩股份           L 2017-01-06     N
2017-01-24  002839.SZ  002839  张家港行           L 2017-01-24     S
```

- 获取多个年份，比如2015-2017

```python
data = data['2015':'2017']
print(data.head())
# 结果
              ts_code  symbol  name list_status  list_date is_hs
list_date                                                       
2015-01-26  000166.SZ  000166  申万宏源           L 2015-01-26     S
2017-12-25  001965.SZ  001965  招商公路           L 2017-12-25     S
2015-12-30  001979.SZ  001979  招商蛇口           L 2015-12-30     S
2015-01-27  002734.SZ  002734  利民股份           L 2015-01-27     N
2015-01-22  002739.SZ  002739  万达电影           L 2015-01-22     S
```

#### 2.1.2. 按月度

```python
data = data['2017-1']
print(data.head())
# 结果
              ts_code  symbol  name list_status  list_date is_hs
list_date                                                       
2017-01-12  002824.SZ  002824  和胜股份           L 2017-01-12     N
2017-01-06  002838.SZ  002838  道恩股份           L 2017-01-06     N
2017-01-24  002839.SZ  002839  张家港行           L 2017-01-24     S
2017-01-10  002840.SZ  002840  华统股份           L 2017-01-10     N
2017-01-19  002841.SZ  002841  视源股份           L 2017-01-19     S
```

#### 2.1.3. 按具体天

```python
data = data['2017-1-12']
print(data.head())
# 结果
              ts_code  symbol  name list_status  list_date is_hs
list_date                                                       
2017-01-12  002824.SZ  002824  和胜股份           L 2017-01-12     N
2017-01-12  300584.SZ  300584  海辰药业           L 2017-01-12     N
2017-01-12  603628.SH  603628  清源股份           L 2017-01-12     H
2017-01-12  603639.SH  603639   海利尔           L 2017-01-12     H
```



### 2.2. to_period按日期显示数据

dataframe.to_period方法只是用于显示数据，但不会进行统计。

#### 2.2.1. 按年度

```python
data = data.to_period('A')  # 'A'默认是从'A-DEC'开始算,也可以根据情况设置为'A-JAN'
print(data.head())
# 结果
             ts_code  symbol  name list_status  list_date is_hs
list_date                                                      
1991       000001.SZ  000001  平安银行           L 1991-04-03     S
1991       000002.SZ  000002   万科A           L 1991-01-29     S
1991       000004.SZ  000004  国农科技           L 1991-01-14     N
1990       000005.SZ  000005  世纪星源           L 1990-12-10     N
1992       000006.SZ  000006  深振业A           L 1992-04-27     S
```

可以看到，相比上面筛选数据时是按原始的日期，这里利用to_period方法，设置参数为'A'后，可以直接显示为年，这在后期可视化绘图时非常有用。

#### 2.2.2. 按季度

```python
data = data.to_period('Q')   # 'Q'默认是从'Q-DEC'开始算,也可以根据情况设置为“Q-SEP”，“Q-FEB”等
print(data.head())
# 结果
             ts_code  symbol  name list_status  list_date is_hs
list_date                                                      
1991Q2     000001.SZ  000001  平安银行           L 1991-04-03     S
1991Q1     000002.SZ  000002   万科A           L 1991-01-29     S
1991Q1     000004.SZ  000004  国农科技           L 1991-01-14     N
1990Q4     000005.SZ  000005  世纪星源           L 1990-12-10     N
1992Q2     000006.SZ  000006  深振业A           L 1992-04-27     S
```

#### 2.2.3. 按月度

```python
data = data.to_period('M')
print(data.head())
# 结果
             ts_code  symbol  name list_status  list_date is_hs
list_date                                                      
1991-04    000001.SZ  000001  平安银行           L 1991-04-03     S
1991-01    000002.SZ  000002   万科A           L 1991-01-29     S
1991-01    000004.SZ  000004  国农科技           L 1991-01-14     N
1990-12    000005.SZ  000005  世纪星源           L 1990-12-10     N
1992-04    000006.SZ  000006  深振业A           L 1992-04-27     S
```

### 2.3. resample按日期统计数据

按日期进行统计数据，可以利用resample方法。

#### 2.3.1. 按年度

```python
data = data.resample('AS').count()['name']  # count对各年上市公司数量进行计数
print(data.head())
# 结果
list_date
1990-01-01      7
1991-01-01      4
1992-01-01     37
1993-01-01    106
1994-01-01     99
```

#### 2.3.2. 按季度

```python
data = data.resample('Q').count()['name']  
print(data.head())
# 结果
list_date
1990-12-31    7
1991-03-31    2
1991-06-30    2
1991-09-30    0
1991-12-31    0
```

#### 2.3.3. 按月度

```python
data = data.resample('M').count()['name']  
print(data.head())
# 结果
list_date
1990-12-31    7
1991-01-31    2
1991-02-28    0
1991-03-31    0
1991-04-30    1
```



### 2.4. 统计和显示结合

利用前面的resample和to.period方法，可以按年、季度、月份汇总数据。

```python
# 汇总各年上市公司数量
data = data.set_index(['list_date'])
data = data.resample('AS').count()['ts_code']
data = data.to_period('A')
print(data.head())
print(data.tail())
```
结果如下：
```python
list_date
1990      7
1991      4
1992     37
1993    106
1994     99
Freq: A-DEC, Name: name, dtype: int64
list_date
2014    124
2015    223
2016    227
2017    438
2018     78
Freq: A-DEC, Name: name, dtype: int64
```
基于上述数据，可以利用matplotlib绘制出历年上市公司数量的折线图：

![](http://media.makcyun.top/18-9-17/25609726.jpg)

折线图的具体绘制方法，见后续文章。

以上就是简单利用了Tushare的一个接口返回的数据，介绍了日期型数据的转换和处理。

本文完。