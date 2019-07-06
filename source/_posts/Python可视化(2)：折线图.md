---
title: 'Python可视化(2)：折线图'
date: 2018-09-11 09:36:41
id: Python__visualization02
categories: Python可视化
tags: [Python可视化]
images: http://media.makcyun.top/18-9-18/28886645.jpg
keywords:
---

日期型数据的折线图绘制。

<!-- more -->  

**摘要：** 利用matplotlib绘制横轴为日期格式的折线图时，存在不少技巧。本文借助Tushare包返回的股票数据，介绍日期折线图绘制的方法。

[上一篇文章](https://www.makcyun.top/python_data_analysis01.html)的最后讲到了折线图的绘制，本文详细介绍绘制方法。

折线图绘制的数据源，采用Tushare包获取上市公司基本数据表，格式如下：

```python
import pandas as pd
data = pd.read('get_stock_basics.csv',encoding = 'utf8')
print(data.head())

ts_code	symbol	name	list_status	list_date	is_hs
000001.SZ	1	平安银行	L	19910403	S
000002.SZ	2	万科A	L	19910129	S
000004.SZ	4	国农科技	L	19910114	N
000005.SZ	5	世纪星源	L	19901210	N

```

然后利用`resample`和`to.period`方法汇总各年度的上市公司数量数据，格式为Pandas.Series数组格式。

```python
# 汇总各年上市公司数量
data = data.set_index(['list_date'])
data = data.resample('AS').count()['ts_code']
data = data.to_period('A')
print(data.head())
print(data.tail())
# 结果如下：
list_date
1990      7
1991      4
1992     37
1993    106
1994     99
...
list_date
2014    124
2015    223
2016    227
2017    438
2018     78
```

## 1. Series直接绘制折线图

首先，我们可以直接利用pandas的数组Series绘制折线图：

```python
import matplotlib.pyplot as plt
plt.style.use('ggplot')  # 设置绘图风格
fig = plt.figure(figsize = (10,6))  # 设置图框的大小
ax1 = fig.add_subplot(1,1,1)
data.plot() # 绘制折线图

# 设置标题及横纵坐标轴标题
colors1 = '#6D6D6D'  #设置标题颜色为灰色
plt.title('历年中国内地上市公司数量变化',color = colors1,fontsize = 18)
plt.xlabel('年份')
plt.ylabel('数量(家)')
plt.show()
```

![](http://media.makcyun.top/18-9-18/15047153.jpg)

可以发现，图中存在两个问题：一是缺少数值标签，二是横坐标年份被自动分割了。我们希望能够添加上数值标签，然后坐标轴显示每一年的年份值。接下来，需要采用新的方法重新绘制折线图。

## 2. 折线图完善

```python 
# 创建x,y轴标签
x = np.arange(0,len(data),1)
    ax1.plot(x,data.values, #x、y坐标
    color = '#C42022', #折线图颜色为红色
    marker = 'o',markersize = 4 #标记形状、大小设置
    )
ax1.set_xticks(x) # 设置x轴标签为自然数序列
ax1.set_xticklabels(data.index) # 更改x轴标签值为年份
plt.xticks(rotation=90) # 旋转90度，不至太拥挤

for x,y in zip(x,data.values):
    plt.text(x,y + 10,'%.0f' %y,ha = 'center',color = colors1,fontsize = 10 )
    # '%.0f' %y 设置标签格式不带小数
# 设置标题及横纵坐标轴标题
plt.title('历年中国内地上市公司数量变化',color = colors1,fontsize = 18)
plt.xlabel('年份')
plt.ylabel('数量(家)')
# plt.savefig('stock.png',bbox_inches = 'tight',dpi = 300)
plt.show()
```

完善后的折线图如下：

![](http://media.makcyun.top/18-9-19/84420184.jpg)

可以看到，x轴逐年的数据都显示并且数值标签也添加上了。

## 3. 多元折线图

上面介绍了一元折线图的绘制，当需要绘制多元折线图时，方法也很简单，只要重复绘图函数即可。这里我们以二元折线图为例，绘制国内两家知名地产公司万科和保利地产2017年的市值变化对比折线图。

### 3.1. 数据来源

数据源仍然采用tushare包的`pro.daily_basic()`接口，该接口能够返回股票的每日股市数据，其中包括每日市值`total_mv`。我们需要的两只股票分别是万科地产(000002.SZ)和保利地产(600048.SH)，下面就来获取两只股票2017年的市值数据。

```python
import tushare as ts
ts.set_token('你的token')  # 官网注册后可以获得
pro = ts.pro_api()
def get_stock():
    lst = []
    ts_codes = ['000002.SZ', '600048.SH']
    for ts_code in ts_codes:
        data = pro.daily_basic(
            ts_code=ts_code, start_date='20170101', end_date='20180101')
    print(lst)
    reutrn lst
	# 结果如下，total_mv为当日市值（万元）：
    #万科地产数据
    	ts_code	trade_date	close	…	total_mv	circ_mv
0	000002.SZ	20171229	31.06	…	3.43E+07	3.02E+07
1	000002.SZ	20171228	30.7	…	3.39E+07	2.98E+07
2	000002.SZ	20171227	30.79	…	3.40E+07	2.99E+07
3	000002.SZ	20171226	30.5	…	3.37E+07	2.96E+07
4	000002.SZ	20171225	30.37	…	3.35E+07	2.95E+07

	#保利地产数据
    	ts_code	trade_date	close	…	total_mv	circ_mv
0	600048.SH	20171229	14.15	…	1.68E+07	1.66E+07
1	600048.SH	20171228	13.71	…	1.63E+07	1.61E+07
2	600048.SH	20171227	13.65	…	1.62E+07	1.60E+07
3	600048.SH	20171226	13.85	…	1.64E+07	1.63E+07
4	600048.SH	20171225	13.55	…	1.61E+07	1.59E+07

```

下面对数据作进一步修改，从DataFrame中提取total_mv列，index设置为日期。

```python
data['trade_date'] = pd.to_datetime(data['trade_date'])
# 设置index为日期
data = data.set_index(data['trade_date']).sort_index(ascending=True)
# 按月汇总和显示
data = data.resample('m')
data = data.to_period()
# 市值改为亿元
market_value = data['total_mv']/10000

# 二者结果分别如下，万科地产：
2017-01    2291.973270
2017-02    2286.331037
2017-03    2306.894790
2017-04    2266.337906
2017-05    2131.053098
2017-06    2457.716659
2017-07    2686.982164
2017-08    2524.462077
2017-09    2904.085487
2017-10    2976.999550
2017-11    3263.374043
2017-12    3317.107474
# 保利地产：
2017-01    1089.008286
2017-02    1120.023350
2017-03    1145.731640
2017-04    1153.760435
2017-05    1108.230609
2017-06    1157.276044
2017-07    1244.966905
2017-08    1203.580209
2017-09    1290.706606
2017-10    1244.438756
2017-11    1336.661916
2017-12    1531.150616
```

### 3.2. 绘制二元折线图

利用上面的Series数据就可以作图了。

```pyhon
# 设置绘图风格
plt.style.use('ggplot')
fig = plt.figure(figsize = (10,6))
colors1 = '#6D6D6D'  #标题颜色

# data1万科，data2保利
data1 = lst[0]
data2 = lst[1]
# 绘制第一条折线图
data1.plot(
color = '#C42022', #折线图颜色
marker = 'o',markersize = 4, #标记形状、大小设置
label = '万科'
)
# 绘制第二条折线图
data2.plot(
color = '#4191C0', #折线图颜色
marker = 'o',markersize = 4, #标记形状、大小设置
label = '保利'
)
# 还可以绘制更多条
# 设置标题及横纵坐标轴标题
plt.title('2017年万科与保利地产市值对比',color = colors1,fontsize = 18)
plt.xlabel('月份')
plt.ylabel('市值(亿元)')
plt.savefig('stock1.png',bbox_inches = 'tight',dpi = 300)
plt.legend() # 显示图例
plt.show()
```

绘图结果如下：

![](http://media.makcyun.top/18-9-28/31064491.jpg)

如果想添加数值标签，则可以使用下面的代码：

```python
# 绘制第一条折线图
# 创建x,y轴标签
x = np.arange(0,len(data1),1)
ax1.plot(x,data1.values, #x、y坐标
color = '#C42022', #折线图颜色红色
marker = 'o',markersize = 4, #标记形状、大小设置
label = '万科'
)
ax1.set_xticks(x) # 设置x轴标签
ax1.set_xticklabels(data1.index) # 设置x轴标签值
# plt.xticks(rotation=90)
for x,y in zip(x,data1.values):
    plt.text(x,y + 10,'%.0f' %y,ha = 'center',color = colors1,fontsize = 10 )
    # '%.0f' %y 设置标签格式不带小数

# 绘制第二条折线图
x = np.arange(0,len(data2),1)

ax1.plot(x,data2.values, #x、y坐标
color = '#4191C0', #折线图颜色蓝色
marker = 'o',markersize = 4, #标记形状、大小设置
label = '保利'
)
ax1.set_xticks(x) # 设置x轴标签
ax1.set_xticklabels(data2.index) # 设置x轴标签值
# plt.xticks(rotation=90)
for x,y in zip(x,data2.values):
    plt.text(x,y + 10,'%.0f' %y,ha = 'center',color = colors1,fontsize = 10 )
    # '%.0f' %y 设置标签格式不带小数

# 设置标题及横纵坐标轴标题
plt.title('2017年万科与保利地产市值对比',color = colors1,fontsize = 18)
plt.xlabel('月份')
plt.ylabel('市值(亿元)')

plt.savefig('stock1.png',bbox_inches = 'tight',dpi = 300)
plt.legend() # 显示图例
plt.show()
```

结果如下图所示：

![](http://media.makcyun.top/18-9-28/45373948.jpg)

可以看到，两只股票市值从2017年初开始一直在上涨，万科的市值是保利的2倍左右。

本文仅简单提取了两只股票的市值数据，只要你愿意，3000多只股票的数据都可以拿来绘图。

文章代码及素材可在下面链接中获得：

[https://github.com/makcyun/web_scraping_with_python/tree/master/date_plot](https://github.com/makcyun/web_scraping_with_python/tree/master/date_plot)

本文完。