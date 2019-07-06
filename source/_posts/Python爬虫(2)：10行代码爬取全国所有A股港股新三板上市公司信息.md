---
title: Python爬虫(2)：10行代码爬取全国所有A股/港股/新三板上市公司信息
images: http://media.makcyun.top/18-8-27/83156024.jpg
date: 2018-08-27 08:26:57
id: web_scraping_withpython2
categories: Python爬虫
tags: [Python爬虫,pandas,数据抓取]
keywords:
---

<b>*python爬虫第2篇*</b>   
利用pandas库中的read_html方法快速抓取网页中常见的表格型数据。

<!-- more -->  

**摘要：** 我们平常在浏览网页中会遇到一些表格型的数据信息，除了表格本身体现的内容以外，你可能想透过表格再更进一步地进行汇总、筛选、处理分析等操作从而得到更多有价值的信息，这时可用python爬虫来实现。本文采用pandas库中的read_html方法来快速准确地抓取表格数据。

**本文知识点：**  
- Table型表格抓取
- DataFrame.read_html函数使用  
- 爬虫数据存储到mysql数据库
- Navicat数据库的使用

## 1. table型表格

我们在网页上会经常看到这样一些表格，比如：
[QS2018世界大学排名](http://ranking.promisingedu.com/qs)：
![](http://media.makcyun.top/18-8-27/59439970.jpg)

[财富世界500强企业排名](http://www.fortunechina.com/fortune500/c/2018-07/19/content_311046.htm)：
![](http://media.makcyun.top/18-8-27/66712901.jpg)

[IMDB世界电影票房排行榜](https://www.boxofficemojo.com/)：
![](http://media.makcyun.top/18-8-27/76002510.jpg)

[中国上市公司信息](http://media.makcyun.top/18-8-27/78659021.jpg)：
![](http://media.makcyun.top/18-8-27/78659021.jpg)

他们除了都是表格以外，还一个共同点就是当你点击右键-定位时，可以看到他们都是table类型的表格形式。
![](http://media.makcyun.top/18-8-27/87245193.jpg)
![](http://media.makcyun.top/18-8-27/54573575.jpg)
![](http://media.makcyun.top/18-8-27/21054545.jpg)
![](http://media.makcyun.top/18-8-27/30765316.jpg)

从中可以看到table类型的表格网页结构大致如下：
```html
<table class="..." id="...">
    <thead>
    <tr>
    <th>...</th>
    </tr>
    </thead>
    <tbody>
        <tr>
            <td>...</td>
        </tr>
        <tr>...</tr>
        <tr>...</tr>
        <tr>...</tr>
        <tr>...</tr>
        ...
        <tr>...</tr>
        <tr>...</tr>
        <tr>...</tr>
        <tr>...</tr>        
    </tbody>
</table>

```
先来简单解释一下上文出现的几种标签含义：
```html
<table>	: 定义表格
<thead>	: 定义表格的页眉
<tbody>	: 定义表格的主体
<tr>	: 定义表格的行
<th>	: 定义表格的表头
<td>	: 定义表格单元
```
这样的表格数据，就可以利用pandas模块里的read_html函数方便快捷地抓取下来。下面我们就来操作一下。

## 2. 快速抓取
下面以中国上市公司信息这个网页中的表格为例，感受一下read_html函数的强大之处。
```python
import pandas as pd
import csv

for i in range(1,178):  # 爬取全部177页数据
	url = 'http://s.askci.com/stock/a/?reportTime=2017-12-31&pageNum=%s' % (str(i))
	tb = pd.read_html(url)[3] #经观察发现所需表格是网页中第4个表格，故为[3]
	tb.to_csv(r'1.csv', mode='a', encoding='utf_8_sig', header=1, index=0)
	print('第'+str(i)+'页抓取完成')

```
![](http://media.makcyun.top/18-8-27/96662344.jpg)
只需不到十行代码，1分钟左右就可以将全部178页共3536家A股上市公司的信息干净整齐地抓取下来。比采用正则表达式、xpath这类常规方法要省心省力地多。如果采取人工一页页地复制粘贴到excel中，就得操作到猴年马月去了。  
上述代码除了能爬上市公司表格以外，其他几个网页的表格都可以爬，只需做简单的修改即可。因此，可作为一个简单通用的代码模板。但是，为了让代码更健壮更通用一些，接下来，以爬取177页的A股上市公司信息为目标，讲解一下详细的代码实现步骤。

## 3. 详细代码实现 ##

### 3.1. read_html函数 ###
先来了解一下**read_html**函数的api:
```python
pandas.read_html(io, match='.+', flavor=None, header=None, index_col=None, skiprows=None, attrs=None, parse_dates=False, tupleize_cols=None, thousands=', ', encoding=None, decimal='.', converters=None, na_values=None, keep_default_na=True, displayed_only=True)

常用的参数：
io:可以是url、html文本、本地文件等；
flavor：解析器；
header：标题行；
skiprows：跳过的行；
attrs：属性，比如 attrs = {'id': 'table'}；
parse_dates：解析日期

注意：返回的结果是**DataFrame**组成的**list**。
```


参考：
> 1 http://pandas.pydata.org/pandas-docs/stable/io.html#io-read-html
> 2 http://pandas.pydata.org/pandas-docs/stable/generated/pandas.read_html.html

### 3.2. 分析网页url ###
首先，观察一下中商情报网第1页和第2页的网址：
```
http://s.askci.com/stock/a/?reportTime=2017-12-31&pageNum=1#QueryCondition
http://s.askci.com/stock/a/?reportTime=2017-12-31&pageNum=2#QueryCondition
```
可以发现，只有**pageNum**的值随着翻页而变化，所以基本可以断定pageNum=1代表第1页，pageNum=10代表第10页，以此类推。这样比较容易用for循环构造爬取的网址。
试着把**#QueryCondition**删除，看网页是否同样能够打开，经尝试发现网页依然能正常打开，因此在构造url时，可以使用这样的格式：  
**http://s.askci.com/stock/a/?reportTime=2017-12-31&pageNum=i**
再注意一下其他参数：  
**a**：表示A股，把a替换为**h**，表示**港股**；把a替换为**xsb**，则表示**新三板**。那么，在网址分页for循环外部再加一个for循环，就可以爬取这三个股市的股票了。  

### 3.3. 定义函数 ###
将整个爬取分为网页提取、内容解析、数据存储等步骤，依次建立相应的函数。
```python
# 网页提取函数
def get_one_page(i):
	try:
		headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36'
        }
		paras = {
		'reportTime': '2017-12-31',   
		#可以改报告日期，比如2018-6-30获得的就是该季度的信息
		'pageNum': i   #页码
		}
		url = 'http://s.askci.com/stock/a/?' + urlencode(paras)
		response = requests.get(url,headers = headers)
		if response.status_code == 200:
			return response.text
		return None
	except RequestException:
		print('爬取失败')

# beatutiful soup解析然后提取表格
def parse_one_page(html):
	soup = BeautifulSoup(html,'lxml')
	content = soup.select('#myTable04')[0] #[0]将返回的list改为bs4类型
	tbl = pd.read_html(content.prettify(),header = 0)[0]
	# prettify()优化代码,[0]从pd.read_html返回的list中提取出DataFrame
	
	tbl.rename(columns = {'序号':'serial_number', '股票代码':'stock_code', '股票简称':'stock_abbre', '公司名称':'company_name', '省份':'province', '城市':'city', '主营业务收入(201712)':'main_bussiness_income', '净利润(201712)':'net_profit', '员工人数':'employees', '上市日期':'listing_date', '招股书':'zhaogushu', '公司财报':'financial_report', '行业分类':'industry_classification', '产品类型':'industry_type', '主营业务':'main_business'},inplace = True)
	
	print(tbl)
	# return tbl
	# rename将表格15列的中文名改为英文名，便于存储到mysql及后期进行数据分析
	# tbl = pd.DataFrame(tbl,dtype = 'object') #dtype可统一修改列格式为文本

# 主函数
def main(page):
	for i in range(1,page):   # page表示提取页数
		html = get_one_page(i)
		parse_one_page(html)

# 单进程
if __name__ == '__main__':	
	main(178)   #共提取n页
		
```
上面两个函数相比于快速抓取的方法代码要多一些，如果需要抓的表格很少或只需要抓一次，那么推荐快速抓取法。如果页数比较多，这种方法就更保险一些。解析函数用了BeautifulSoup和css选择器，这种方法定位提取表格所在的**id为#myTable04**的table代码段，更为准确。

### 3.4. 存储到MySQL ###
接下来，我们可以将结果保存到本地csv文件，也可以保存到MySQL数据库中。这里为了练习一下MySQL，因此选择保存到MySQL中。

首先，需要先在数据库建立存放数据的表格，这里命名为**listed_company**。代码如下：
```python
import pymysql

def generate_mysql():
	conn = pymysql.connect(
		host='localhost',   # 本地服务器
		user='root',
		password='******',  # 你的数据库密码
		port=3306,          # 默认端口
		charset = 'utf8',
		db = 'wade')
	cursor = conn.cursor()

	sql = 'CREATE TABLE IF NOT EXISTS listed_company2 (serial_number INT(30) NOT NULL,stock_code INT(30) ,stock_abbre VARCHAR(30) ,company_name VARCHAR(30) ,province VARCHAR(30) ,city VARCHAR(30) ,main_bussiness_income VARCHAR(30) ,net_profit VARCHAR(30) ,employees INT(30) ,listing_date DATETIME(0) ,zhaogushu VARCHAR(30) ,financial_report VARCHAR(30) , industry_classification VARCHAR(255) ,industry_type VARCHAR(255) ,main_business VARCHAR(255) ,PRIMARY KEY (serial_number))'
    # listed_company是要在wade数据库中建立的表，用于存放数据
    
	cursor.execute(sql)
	conn.close()
	
generate_mysql()
```
上述代码定义了generate_mysql()函数，用于在MySQL中wade数据库下生成一个listed_company的表。表格包含15个列字段。根据每列字段的属性，分别设置为INT整形（长度为30）、VARCHAR字符型(长度为30) 、DATETIME(0) 日期型等。  
在Navicat中查看建立好之后的表格：
![](http://media.makcyun.top/18-8-28/33076915.jpg)
![](http://media.makcyun.top/18-8-28/97554452.jpg)

接下来就可以往这个表中写入数据，代码如下：
```python
import pymysql
from sqlalchemy import create_engine

def write_to_sql(tbl, db = 'wade'):
    engine = create_engine('mysql+pymysql://root:******@localhost:3306/{0}?charset=utf8'.format(db))
    # db = 'wade'表示存储到wade这个数据库中,root后面的*是密码
    try:
    	tbl.to_sql('listed_company',con = engine,if_exists='append',index=False)
    	# 因为要循环网页不断数据库写入内容，所以if_exists选择append，同时该表要有表头，parse_one_page（）方法中df.rename已设置
    except Exception as e:
    	print(e)

```
以上就完成了单个页面的表格爬取和存储工作，接下来只要在main()函数进行for循环，就可以完成所有总共178页表格的爬取和存储，完整代码如下：
```python
import requests
import pandas as pd
from bs4 import BeautifulSoup
from lxml import etree
import time
import pymysql
from sqlalchemy import create_engine
from urllib.parse import urlencode  # 编码 URL 字符串

start_time = time.time()  #计算程序运行时间

def get_one_page(i):
	try:
		headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36'
        }
		paras = {
		'reportTime': '2017-12-31',
		#可以改报告日期，比如2018-6-30获得的就是该季度的信息
		'pageNum': i   #页码
		}
		url = 'http://s.askci.com/stock/a/?' + urlencode(paras)
		response = requests.get(url,headers = headers)
		if response.status_code == 200:
			return response.text
		return None
	except RequestException:
		print('爬取失败')


def parse_one_page(html):
	soup = BeautifulSoup(html,'lxml')
	content = soup.select('#myTable04')[0] #[0]将返回的list改为bs4类型
	tbl = pd.read_html(content.prettify(),header = 0)[0]
	# prettify()优化代码,[0]从pd.read_html返回的list中提取出DataFrame
	tbl.rename(columns = {'序号':'serial_number', '股票代码':'stock_code', '股票简称':'stock_abbre', '公司名称':'company_name', '省份':'province', '城市':'city', '主营业务收入(201712)':'main_bussiness_income', '净利润(201712)':'net_profit', '员工人数':'employees', '上市日期':'listing_date', '招股书':'zhaogushu', '公司财报':'financial_report', '行业分类':'industry_classification', '产品类型':'industry_type', '主营业务':'main_business'},inplace = True)

	# print(tbl)
	return tbl
	# rename将中文名改为英文名，便于存储到mysql及后期进行数据分析
	# tbl = pd.DataFrame(tbl,dtype = 'object') #dtype可统一修改列格式为文本

def generate_mysql():
	conn = pymysql.connect(
		host='localhost',
		user='root',
		password='******',
		port=3306,
		charset = 'utf8',  
		db = 'wade')
	cursor = conn.cursor()

	sql = 'CREATE TABLE IF NOT EXISTS listed_company (serial_number INT(20) NOT NULL,stock_code INT(20) ,stock_abbre VARCHAR(20) ,company_name VARCHAR(20) ,province VARCHAR(20) ,city VARCHAR(20) ,main_bussiness_income VARCHAR(20) ,net_profit VARCHAR(20) ,employees INT(20) ,listing_date DATETIME(0) ,zhaogushu VARCHAR(20) ,financial_report VARCHAR(20) , industry_classification VARCHAR(20) ,industry_type VARCHAR(100) ,main_business VARCHAR(200) ,PRIMARY KEY (serial_number))'
    # listed_company是要在wade数据库中建立的表，用于存放数据
    
	cursor.execute(sql)
	conn.close()
	

def write_to_sql(tbl, db = 'wade'):
    engine = create_engine('mysql+pymysql://root:******@localhost:3306/{0}?charset=utf8'.format(db))
    try:
    	# df = pd.read_csv(df)
    	tbl.to_sql('listed_company2',con = engine,if_exists='append',index=False)
    	# append表示在原有表基础上增加，但该表要有表头
    except Exception as e:
    	print(e)


def main(page):
    generate_mysql()
	for i in range(1,page):  
		html = get_one_page(i)
		tbl = parse_one_page(html)
		write_to_sql(tbl)
		
# # 单进程
if __name__ == '__main__':	
	main(178)

	endtime = time.time()-start_time
	print('程序运行了%.2f秒' %endtime)
	

# 多进程
# from multiprocessing import Pool
# if __name__ == '__main__':
# 	pool = Pool(4)
# 	pool.map(main, [i for i in range(1,178)])  #共有178页

# 	endtime = time.time()-start_time
# 	print('程序运行了%.2f秒' %(time.time()-start_time))

```
最终，A股所有3535家企业的信息已经爬取到mysql中，如下图：
![](http://media.makcyun.top/18-8-28/63973864.jpg)

最后，需说明不是所有表格都可以用这种方法爬取，比如这个网站中的表格，表面是看起来是表格，但在html中不是前面的table格式，而是list列表格式。这种表格则不适用read_html爬取。得用其他的方法，比如selenium，以后再进行介绍。
![](http://media.makcyun.top/18-8-28/3402980.jpg)

本文完。