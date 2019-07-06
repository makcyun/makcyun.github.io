---
title: 5 行代码入门 Python 爬虫
date: 2019-1-10 16:16:16
id: web_scraping_withpython18
categories: Python爬虫
tags: [Python爬虫]
images: http://media.makcyun.top/19-1-10/36857236.jpg
keywords: [Python爬虫,爬虫入门]
---

5 行代码就能写一个 Python 爬虫。

<!-- more -->  

**摘要**：5 行代码就能写一个 Python 爬虫。

如果你是比较早关注我的话，会发现我此前的大部分文章都是在写 Python 爬虫，前后大概写了十几个爬虫实战案例，一直在埋头往前写，但却没有回到原点过，没有写过为什么要爬虫、爬虫难不难、怎么入门爬虫这些问题。另外，我觉得关注我的朋友中有不少是刚刚入门 Python 或者想学习 Python 的，为了更加友好一些，所以也有必要说一说这几个问题。基于这两点思考，今天就来谈谈 **如何用快速入门爬虫**。

先说结论：**入门爬虫很容易，几行代码就可以，可以说是学习 Python 最简单的途径**。

以我纯小白、零基础的背景来说，入门爬虫其实很容易，容易在代码编写很简单，简单的爬虫通常几行就能搞定，而不容易在确定爬虫的目标，也就是说为什么要去写爬虫，有没有必要用到爬虫，是不是手动操作几乎无法完成，互联网上有数以百万千万计的网站，到底以哪一个网站作为入门首选，这些问题才是难点。所以在动手写爬虫前，最好花一些时间想一想这清楚这些问题。

「Talk is cheap. Show me the code」，下面，就以我写过的一个爬虫为例，说一说如入门 Python 的几个步骤。

### ▌确立目标

第一步，确立目标。

这里，以我之前写的「爬取国内所有上市公司信息」为例，文章见：

[∞ 10 行代码爬取全国所有A股/港股/新三板上市公司信息](https://www.makcyun.top/web_scraping_withpython2.html)

为什么当时想起写这个爬虫呢，是因为这是曾经在工作中想要解决的问题，当时不会爬虫，只能用 Excel 花了数个小时才勉强地把数据爬了下来， 所以在接触到爬虫后，第一个想法就是去实现曾未实现的目标。以这样的方式入门爬虫，好处显而易见，就是有了很明确的动力。
很多人学爬虫都是去爬网上教程中的那些网站，网站一样就算了，爬取的方法也一模一样，等于抄一遍，不是说这样无益，但是会容易导致动力不足，因为你没有带着目标去爬，只是为了学爬虫而爬，爬虫虽然是门技术活，但是如果能 **建立在兴趣爱好或者工作任务的前提下，学习的动力就会强很多。**

在确定好爬虫目标后，接着我就在脑中预想了想要得到什么样的结果、如何展示出来、以什么形式展现这些问题。所以，我在爬取网站之前，就预先构想出了想要的一个结果，大致是下面这张图的样子。

![](http://media.makcyun.top/19-1-10/9809664.jpg)

目标是利用爬下来的数据，尝试从不同维度年份、省份、城市去分析全国的股市信息，然后通过可视化图表呈现出来。

抛开数据，可能你会觉得这张图在排版布局、色彩搭配、字体文字等方面还挺好看的。这些呢，就跟爬虫没什么关系了，而跟审美有关，提升审美的一种方式是可以通过做 PPT 来实现：

[∞ 国外最牛逼的一套 PPT 作品分享给你](https://www.makcyun.top/weekly_sharing11.html)

所以你看，咱们说着说着就从爬虫跳到了 PPT，不得不说我此前发的文章铺垫地很好啊，哈哈。其实，在职场中，你拥有的技能越多越好。

### ▌直接开始

确定了目标后，第二步就可以开始写爬虫了，如果你像我一样，之前没有任何编程基础，那我下面说的思路，可能会有用。

![](http://media.makcyun.top/19-1-11/25331188.jpg)

刚开始动手写爬虫，我只关注最核心的部分，也就是先成功抓到数据，其他的诸如：下载速度、存储方式、代码条理性等先不管，这样的代码简短易懂、容易上手，能够增强信心。

所以，我在写第一遍的时候，只用了 5 行代码，就成功抓取了全部所需的信息，当时的感觉就是很爽，觉得爬虫不过如此啊，自信心爆棚。

```python
import pandas as pd
import csv
for i in range(1,178):  # 爬取全部页
	tb = pd.read_html('http://s.askci.com/stock/a/?reportTime=2017-12-31&pageNum=%s' % (str(i)))[3] 
	tb.to_csv(r'1.csv', mode='a', encoding='utf_8_sig', header=1, index=0)
```

3000+ 上市公司的信息，安安静静地躺在 Excel 中：

![](http://media.makcyun.top/18-8-27/96662344.jpg)



### ▌不断完善

有了上面的信心后，我开始继续完善代码，因为 5 行代码太单薄，功能也太简单，大致从以下几个方面进行了完善：

- 增加异常处理

由于爬取上百页的网页，中途很可能由于各种问题导致爬取失败，所以增加了 try except 、if 等语句，来处理可能出现的异常，让代码更健壮。

- 增加代码灵活性

初版代码由于固定了 URL 参数，所以只能爬取固定的内容，但是人的想法是多变的，一会儿想爬这个一会儿可能又需要那个，所以可以通过修改 URL 请求参数，来增加代码灵活性，从而爬取更灵活的数据。

- 修改存储方式

初版代码我选择了存储到 Excel 这种最为熟悉简单的方式，人是一种惰性动物，很难离开自己的舒适区。但是为了学习新知识，所以我选择将数据存储到 MySQL 中，以便练习 MySQL 的使用。

- 加快爬取速度

  初版代码使用了最简单的单进程爬取方式，爬取速度比较慢，考虑到网页数量比较大，所以修改为了多进程的爬取方式。

经过以上这几点的完善，代码量从原先的 5 行增加到了下面的几十行：

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
	return tbl

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
	cursor.execute(sql)
	conn.close()
	
def write_to_sql(tbl, db = 'wade'):
    engine = create_engine('mysql+pymysql://root:******@localhost:3306/{0}?charset=utf8'.format(db))
    try:
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
from multiprocessing import Pool
if __name__ == '__main__':
 	pool = Pool(4)
 	pool.map(main, [i for i in range(1,178)])  #共有178页
	endtime = time.time()-start_time
	print('程序运行了%.2f秒' %(time.time()-start_time))
```

但是这个过程却觉得很自然，因为每次修改都是针对一个小点，一点点去学，搞懂后添加进来，而如果让我上来就直接写出这几十行的代码，我很可能就放弃了。

所以，你可以看到，入门爬虫是有套路的，最重要的是给自己信心。

以上，我从一个小点结合一个实例，介绍了入门学习爬虫的方法，希望对你有用。当然还有其他点，之后再说。

本文完。

---

推荐阅读：

[∞ 10 行代码爬取全国所有 A股/港股/新三板上市公司信息](https://www.makcyun.top/web_scraping_withpython2.html)

[∞ 国外最牛逼的一套 PPT 作品分享给你](https://www.makcyun.top/weekly_sharing11.html)