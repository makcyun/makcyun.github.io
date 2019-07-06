---
title: 'Pyhton可视化(3): 中国66家环保股上市公司市值Top20强'
date: 2018-09-20 13:27:22
id: Python_visualization03
categories: Python可视化
tags: Python可视化
images: http://media.makcyun.top/18-9-20/43338753.jpg
keywords: [Python可视化,Python爬虫]


---

Tushare包提取中国环保股上市公司近10年市值排名，并结合D3.js做动态数据可视化表。

<!-- more -->  

**摘要：** 之前介绍过Tushare包和D3.js可视化动态表格，本文将二者进行结合，制作中国上市公司环境保护股Top20强，近十年的市值变化动态表。

制作近10年期间，环保板块市值最高的20只股票动态变化，需要获得各只股票在不同年份的市值。获取特定股票的市值可以利用`pro.daily_basic`接口获取到每日的市值，然后利用Resample函数获得年均市值。但获取环保板块所有几十只股票的数据，用手动输入股票代码就不是很方便，此时，可以利用该包另外一个接口`ts.get_stock_basics()接口`获取所有股票基本数据，该接口能够返回股票代码、行业类别等数据。两个接口合二为一就可以提取出所需的数据，下面开始详细实现步骤。

## 1. 提取所有股票代码

```python
import tushare as ts
# 获取所有股票列表
data = ts.get_stock_basics()
print(data.head())
# 返回数据如下，所有列值可以参考：http://tushare.org/fundamental.html
         name industry area      pe  outstanding  totals  totalAssets  \
code                                                                    
002936    N郑银       银行   河南    8.27         6.00   59.22  44363604.00   
600856   中天能源     供气供热   吉林   21.28        13.43   13.67   1712831.63   
300021   大禹节水     农业综合   甘肃   35.27         6.48    7.97    359294.91   
603111   康尼机电     运输设备   江苏    0.00         7.38    9.93    734670.69   
000498   山东路桥     建筑施工   山东   19.52         4.41   11.20   1926262.38   
```

可以看到，index是股票代码，name股票名称，industry是行业分类。我们需要获取环保类（可以获取任意行业类别，也可以全部获取所有股票，为了后期数据提取量耗时短一些，所以选择提取环保类股票）的股票代码和股票名称，代码如下：

```python
data = data[data.industry =='环境保护']
print(data.head()) #返回的环保股数据
print('环保股股票数量为'：len(data.industry)) #计算环保股股票数量
结果如下：
        name industry area     pe  outstanding  totals  totalAssets  \
code                                                                  
300056   三维丝     环境保护   福建   0.00         2.37    3.85    266673.63   
002549  凯美特气     环境保护   湖南  34.44         6.20    6.24    122630.13   
300422   博世科     环境保护   广西  19.22         2.64    3.56    509822.44   
601330  绿色动力     环境保护   深圳  59.83         1.16   11.61    784969.25   
000820  神雾节能     环境保护   辽宁   0.00         2.88    6.37    284674.34   
环保股股票数量为： 66
```

可以看到，环境保护股一共有66只，下面我们将用这66只股票的代码和名称，输入到`pro.daily_basic()接口`中，获取每只股票的每日数据，其中包括每日市值。时间期限从2009年1月1日至2018年9月10日，共10年的逐日数据。

## 2. 提股票每日市值

每日基本指标的数据接口：[https://tushare.pro/document/2?doc_id=32](https://tushare.pro/document/2?doc_id=32)

```python
pro = ts.pro_api()
pro.daily_basic(ts_code='', trade_date='',start_date = '',end_date = '')
# ts_code是股票代码，格式为000002.SZ,可以为一只股票，也可以是列表组成的多支股票
# 后面三个是交易日期，可以为固定日期，也可以为一个时期，格式'20180919'
```

该接口股票代码的格式是`000002.SZ`，而上面股票代码格式是：`000002`，没有带后缀.SZ，由此需要添加上，然后就可获取每只股票近10年的逐日市值数据。

```python
data['code2'] = data.index
# apply方法添加.SZ后缀
data['code2'] = data['code2'].apply(lambda i:i+'.SZ')
data = data.set_index(['code2'])
# 将code和name转为dict，因为我们只需要表格中的代码和名称列
data = data['name']
data = data.to_dict()

# print(data) #测试返回的环保股字典数据 ok
{'300056.SZ': '三维丝', '002549.SZ': '凯美特气', '300422.SZ': '博世科', '601330.SZ': '绿色动力', '000820.SZ': '神雾节能', '300072.SZ': '三聚环保', '300055.SZ': '万邦达', '002717.SZ': '岭南股份', '300070.SZ': '碧水源', '000504.SZ': '南华生物', '300203.SZ': '聚光科技', '002672.SZ': '东江环保', '000967.SZ': '盈峰环境', '002322.SZ': '理工环科', '300272.SZ': '开能健康', '300495.SZ': '美尚生态', '603717.SZ': '天域生态', '300266.SZ': '兴源环境', '603126.SZ': '中材节能', '002200.SZ': '云投生态', '300385.SZ': '雪浪环境', '603200.SZ': '上海洗霸', '000826.SZ': '启迪桑德', '300262.SZ': '巴安水务', '002887.SZ': '绿茵生态', '603568.SZ': '伟明环保', '300631.SZ': '久吾高科', '002616.SZ': '长青集团', '300156.SZ': '神雾环保', '000920.SZ': '南方汇通', '600008.SZ': '首创股份', '601200.SZ': '上海环境', '603955.SZ': '大千生态', '603177.SZ': '德创环保', '600481.SZ': '双良节能', '300190.SZ': '维尔利', '603588.SZ': '高能环境', '002034.SZ': '旺能环境', '603817.SZ': '海峡环保', '002499.SZ': '科林环保', '603822.SZ': '嘉澳环保', '300664.SZ': '鹏鹞环保', '300332.SZ': '天壕环境', '600526.SZ': '菲达环保', '600874.SZ': '创业环保', '600292.SZ': '远达环保', '603903.SZ': '中持股份', '300172.SZ': '中电环保', '000544.SZ': '中原环保', '300692.SZ': '中环环保', '600388.SZ': '龙净环保', '300425.SZ': '环能科技', '300388.SZ': '国祯环保', '300362.SZ': '天翔环境', '300197.SZ': '铁汉生态', '300187.SZ': '永清环保', '300090.SZ': '盛运环保', '002573.SZ': '清新环境', '000035.SZ': '中国天楹', '603797.SZ': '联泰环保', '603603.SZ': '博天环境', '300137.SZ': '先河环保', '300355.SZ': '蒙草生态', '300152.SZ': '科融环境', '002658.SZ': '雪迪龙', '600217.SZ': '中再资环'}
```

可以看到，很完整地显示了环保股的股票代码和名称，下面通过for循环即可获取每日数据。为了方便，将上式代码命名为一个函数get_code()，return data 为上面的dict。

## 3. 提取环保股公司数据

```python
ts_codes = get_code()
start = '20090101'
end = '201809010'
for key,value in ts_codes.items():
	data = pro.daily_basic(ts_code=key, start_date=start, end_date=end) # 获取每只股票时间段数据
    # 添加代码列和名称列
    # 替换掉末尾的.SZ,regex设置为true才行
    data['code'] = data['ts_code'].replace('.SZ','',regex = True)
    data['name'] = value
    # 存储结果
    data.to_csv('environment.csv',mode='a',encoding = 'utf_8_sig',index = False,header = 0)
    print('数据提取完毕')
```

表格结果如下，66只股票10年一共产生了75933行数据。如果提前全部3000多家股票的数据，那么数据量会达到几百万行，量太大，所以这里仅提取了66支。其中，选中的列为每日市值（万元）。下面就可以根据日期、市值得到各只股票每年的市值均值，然后绘制股票动态表。

![](http://media.makcyun.top/18-9-20/15865243.jpg)

## 4. 绘制Top20强动态表

首先读取上面的表格，获取DataFrame信息：

```python
df = pd.read_csv('environment.csv',encoding = 'utf-8',converters = {'code':str})
# converters = {'code':str} 将数字前面不显示的0转为str显示
print(df.info())

Data columns (total 17 columns):
ts_code          75932 non-null object
trade_date       75932 non-null int64
close            75932 non-null float64
turnover_rate    75932 non-null float64
volume_ratio     0 non-null float64
pe               70861 non-null float64
e_ttm            69254 non-null float64
pb               73713 non-null float64
ps               75932 non-null float64
ps_ttm           75840 non-null float64
total_share      75932 non-null float64
float_share      75932 non-null float64
free_share       75932 non-null float64
total_mv         75932 non-null float64
circ_mv          75932 non-null float64
code             75932 non-null int64
name             75932 non-null object
dtypes: float64(13), int64(2), object(2)
```

可以看到trade_date交易日期是整形，需将交易日期先转换为字符型再转换为datetime日期型。

```python
from datetime import datetime
# trade_date是int型，需转为字符型
df['trade_date'] = df['trade_date'].apply(str)
# 或者
# df['trade_date'] = df['trade_date'].astype(str)
# 将object转为datatime
df['trade_date'] = pd.to_datetime(df['trade_date'],format = '%Y%m%d',errors = 'ignore') #errors忽略无法转换的数据，不然会报错
# 结果如下：
Data columns (total 17 columns):
ts_code          75932 non-null object
trade_date       75932 non-null datetime64[ns]
close            75932 non-null float64
turnover_rate    75932 non-null float64
volume_ratio     0 non-null float64
pe               70861 non-null float64
e_ttm            69254 non-null float64
pb               73713 non-null float64
ps               75932 non-null float64
ps_ttm           75840 non-null float64
total_share      75932 non-null float64
float_share      75932 non-null float64
free_share       75932 non-null float64
total_mv         75932 non-null float64
circ_mv          75932 non-null float64
code             75932 non-null int64
name             75932 non-null object
```



```python
# 设置总市值数字格式由万元变为亿元
df['total_mv'] = (df['total_mv']/10000)
# 保留四列,并将交易日期设为index
df = df[['ts_code','trade_date','total_mv','name']]
df = df.set_index('trade_date')
print(df.head())
# 结果如下:
               ts_code   total_mv  name
trade_date                            
2018-08-30  300090.SZ  36.034715  盛运环保
2018-08-29  300090.SZ  38.014644  盛运环保
2018-08-28  300090.SZ  39.202602  盛运环保
2018-08-27  300090.SZ  40.126569  盛运环保
2018-08-24  300090.SZ  38.938611  盛运环保
```

接下来，求出每只股票每年的市值平均值：

```python
求平均市值时需切片同一股票，这里股票名称切片赋值为value变量，也就是dict字典里66只股票名称
df = df[df.name == value]
# 不能用query方法,会报错 df = df.query('name == value')
# resampe按年统计数据
df = df.resample('AS').mean()  #年平均市值
print(df.head())
# 结果如下：
              total_mv code
trade_date                 
2009-01-01   25.184678  三维丝
2010-01-01   50.672849  三维丝
2011-01-01   46.488004  三维丝
2012-01-01   39.214508  三维丝
2013-01-01   59.110332  三维丝
# 再用to_period按年显示市值数据
df = df.to_period('A')
print(df.head())
# 结果如下:
                  total_mv code
trade_date                 
2009         25.184678  三维丝
2010         50.672849  三维丝
2011         46.488004  三维丝
2012         39.214508  三维丝
2013         59.110332  三维丝

```

经过以上处理，基本就获得了想要的数据。为了能够满足D3.js模板表格条件，再做一点修改：

```python
# 增加code列
df['code'] = value
# 重置index
df = df.reset_index()
# 重命名为d3.js格式
# 增加一列空type
df['type'] = ''
df = df[['code','type','total_mv','trade_date']]
df.rename(columns = {'code':'name','total_mv':'value','type':'type','trade_date':'date'})
# df.to_csv('parse_environment.csv',mode='a',encoding = 'utf_8_sig',index = False,float_format = '%.1f',header = 0)   # float_format = '%.1f' #设置输出浮点数格式为1位小数
```

最终，生成parse_environment.csv文件如下：

```python
name	type	value	date
中国天楹		8.8	2009
中国天楹		9.8	2010
中国天楹		15	2011
中国天楹		18.8	2012
中国天楹		22.5	2013
...
东方园林		177.1	2014
东方园林		320.5	2015
东方园林		288.4	2016
东方园林		481	2017
东方园林		461.5	2018
```

可绘制出动态可视化表格，见下面视频。可以看到前几年市值龙头由东方园林、碧桂园轮流坐庄，近两年三聚环保强势崛起，市值增长迅猛，跃居头名。

[https://www.bilibili.com/video/av32087716/](https://www.bilibili.com/video/av32087716/)

本文仅对比了环保股企业的市值变化，你还可以分析互联网股、金融股等100多种行业的企业市值对比。另外，Tushare包返回的参数还可以做更多其他分析。

文章完整的代码如下：

```python
import pandas as pd
import tushare as ts
from datetime import datetime
import matplotlib.pyplot as plt
ts.set_token('404ba015bd44c01cf09c8183dcd89bb9b25749057ff72b5f8671b9e6')
pro = ts.pro_api()
def get_code():
    # 所有股票列表
    data = ts.get_stock_basics()
    # data = data.query('industry == "环境保护"')
    # 或者
    data = data[data.industry =='环境保护']
    # 提取股票代码code并转化为list
    data['code2'] = data.index
    # apply方法添加.SZ后缀
    data['code2'] = data['code2'].apply(lambda i:i+'.SZ')
    data = data.set_index(['code2'])
    # 将code和name转为dict
    data = data['name']
    data = data.to_dict()
    # 增加东方园林
    data['002310.SZ'] = '东方园林'
    # print(data) #测试返回的环保股dict ok
    return data

def stock(key,start,end,value):
    data = pro.daily_basic(ts_code=key, start_date=start, end_date=end) # 获取每只股票时间段数据

    # 替换掉末尾的.SZ,regex设置为true才行
    data['code'] = data['ts_code'].replace('.SZ','',regex = True)
    data['name'] = value
    # print(data)
    data.to_csv('environment.csv',mode='a',encoding = 'utf_8_sig',index = False,header = 0)

def parse_code():
    df = pd.read_csv('environment.csv',encoding = 'utf-8',converters = {'code':str})
    # converters = {'code':str} 将数字前面不显示的0转为str显示
    df.columns = ['ts_code','trade_date','close','turnover_rate','volume_ratio','pe','e_ttm','pb','ps','ps_ttm','total_share','float_share','free_share','total_mv','circ_mv', 'code','name']
    # trade_date是int型，需转为字符型
	df['trade_date'] = df['trade_date'].apply(str)
	# 或者df['trade_date'] = df['trade_date'].astype(str)
	# 将object转为datatime
	df['trade_date'] = pd.to_datetime(df['trade_date'],format = '%Y%m%d',errors = 'ignore') #errors忽略无法转换的数据，不然会报错
    ## 设置总市值数字格式由万元变为亿元
    df['total_mv'] = (df['total_mv']/10000)
    # 保留四列,并将交易日期设为index
    df = df[['ts_code','trade_date','total_mv','name']]
    df = df.set_index('trade_date')

    df = df[df.name == value]
    # # 不能用query方法
    # # df = df.query('name == ')
    df = df.resample('AS').mean()/10000  #年平均市值
    df = df.to_period('A')
    # # 增加code列
    df['code'] = value
    # # 重置index
    df = df.reset_index()

    # 重命名为d3.js格式
    # 增加一列空type
    df['type'] = ''
    df = df[['code','type','total_mv','trade_date']]
    df.rename(columns = {'code':'name','total_mv':'value','type':'type','trade_date':'date'})
    df.to_csv('parse_environment.csv',mode='a',encoding = 'utf_8_sig',index = False,float_format = '%.1f',header = 0)
    float_format = '%.1f' #设置输出浮点数格式
    # print(df)
    # print(df.info())

def main():
    # get_code()  #提取环保股dict
    start = '20090101'
    end = '201809010'
    ts_codes = get_code()
    # dict_values转list
    keys = list(ts_codes.keys())
    values = list(ts_codes.values())
    for key,value in ts_codes.items():
        stock(key,start,end,value)
    for value in values:
        parse_code(value)

if __name__ == '__main__':
    main()
```

文件素材可以在这里获得：

[https://github.com/makcyun/web_scraping_with_python/tree/master/Tushare](https://github.com/makcyun/web_scraping_with_python/tree/master/Tushare)

本文完。