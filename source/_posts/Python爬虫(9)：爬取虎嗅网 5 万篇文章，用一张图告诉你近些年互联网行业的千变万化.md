---



title: pyspider 爬取并分析虎嗅网 5 万篇文章
date: 2018-11-4 16:16:24
id: web_scraping_withpython9
categories: Python爬虫,Python分析,Python可视化
tags: [Python爬虫,Python分析,Python可视化]
images: http://media.makcyun.top/18-12-22/86392230.jpg
keywords: [Python爬虫,虎嗅网]
---

数据抓取、清洗、分析一条龙，感受科技互连网世界的千变万化。

<!-- more -->  

**摘要：** 不少时候，一篇文章能否得到广泛的传播，除了文章本身实打实的质量以外，一个好的标题也至关重要。本文爬取了虎嗅网建站至今共 5 万条新闻标题内容，助你找到起文章标题的技巧与灵感。同时，分享一些值得关注的文章和作者。

## 1. 分析背景

### 1.1. 为什么选择虎嗅

在众多新媒体网站中，「虎嗅」网的文章内容和质量还算不错。在「新榜」科技类公众号排名中，它位居榜单第 3 名，还是比较受欢迎的。所以选择爬取该网站的文章信息，顺便从中了解一下这几年科技互联网都出现了哪些热点信息。

![](http://media.makcyun.top/18-11-4/22792947.jpg)

> 「关于虎嗅」
>
> 虎嗅网创办于 2012 年 5 月，是一个聚合优质创新信息与人群的新媒体平台。该平台专注于贡献原创、深度、犀利优质的商业资讯，围绕创新创业的观点进行剖析与交流。虎嗅网的核心，是关注互联网及传统产业的融合、明星公司的起落轨迹、产业潮汐的动力与趋势。

### 1.2. 分析内容

- 分析虎嗅网 5 万篇文章的基本情况，包括收藏数、评论数等
- 发掘最受欢迎和最不受欢迎的文章及作者
- 分析文章标题形式（长度、句式）与受欢迎程度之间的关系
- 展现近些年科技互联网行业的热门词汇

### 1.3. 分析工具

- Python
- pyspider 
- MongoDB
- Matplotlib
- WordCloud
- Jieba

## 2. 数据抓取

使用 pyspider 抓取了虎嗅网的主页文章，文章抓取时期为 2012 年建站至 2018 年 11 月 1 日，共计约 5 万篇文章。抓取 了 7 个字段信息：文章标题、作者、发文时间、评论数、收藏数、摘要和文章链接。

### 2.1. 目标网站分析

这是要爬取的 [网页界面](https://www.huxiu.com/)，可以看到是通过 AJAX 加载的。

![](http://media.makcyun.top/18-11-4/38979674.jpg)

![](http://media.makcyun.top/18-11-5/33467436.jpg)

右键打开开发者工具查看翻页规律，可以看到 URL 请求是 POST 类型，下拉到底部查看 Form Data，表单需提交参数只有 3 项。经尝试， 只提交 page 参数就能成功获取页面的信息，其他两项参数无关紧要，所以构造分页爬取非常简单。

```python
huxiu_hash_code: 39bcd9c3fe9bc69a6b682343ee3f024a
page: 4
last_dateline: 1541123160
```

接着，切换选项卡到 Preview 和 Response 查看网页内容，可以看到数据都位于 data 字段里。total_page 为 2004，表示一共有 2004 页的文章内容，每一页有 25 篇文章，总共约 5 万篇，也就是我们要爬取的数量。

![](http://media.makcyun.top/18-11-5/80730129.jpg)

以上，我们就找到了所需内容，接下来可以开始构造爬虫，整个爬取思路比较简单。之前我们也练习过这一类 Ajax 文章的爬取，可以参考：

[抓取澎湃网建站至今 1500 期信息图栏目图片](https://www.makcyun.top/web_scraping_withpython4.html)

### 2.2. pyspider 介绍

和之前文章不同的是，这里我们使用一种新的工具来进行爬取，叫做：pyspider 框架。由国人 binux 大神开发，GitHub Star 数超过 12 K，足以证明它的知名度。可以说，学习爬虫不能不会使用这个框架。

网上关于这个框架的介绍和实操案例非常多，这里仅简单介绍一下。

我们之前的爬虫都是在 Sublime 、PyCharm 这种 IDE 窗口中执行的，整个爬取过程可以说是处在黑箱中，内部运行的些细节并不太清楚。而 pyspider 一大亮点就在于提供了一个可视化的 WebUI 界面，能够清楚地查看爬虫的运行情况。

![](http://media.makcyun.top/18-11-5/65831925.jpg)

pyspider 的架构主要分为 Scheduler(调度器)、Fetcher(抓取器)、Processer(处理器)三个部分。Monitor(监控器)对整个爬取过程进行监控，Result Worker(结果处理器)处理最后抓取的结果。



![](http://media.makcyun.top/18-11-5/51865737.jpg)

我们看看该框架的运行流程大致是怎么样的：

- 一个 pyppider 爬虫项目对应一个 Python 脚本，脚本里定义了一个 Handler 主类。爬取时首先调用 on_start() 方法生成最初的抓取任务，然后发送给 Scheduler。
- Scheduler 将抓取任务分发给 Fetcher 进行抓取，Fetcher 执行然后得到 Response、随后将 Response 发送给 Processer。
- Processer 处理响应并提取出新的 URL 然后生成新的抓取任务，然后通过消息队列的方式通知 Scheduler 当前抓取任务执行情况，并将新生成的抓取任务发送给 Scheduler。如果生成了新的提取结果，则将其发送到结果队列等待 Result Worker 处理。
- Scheduler 接收到新的抓取任务，然后查询数据库，判断其如果是新的抓取任务或者是需要重试的任务就继续进行调度，然后将其发送回 Fetcher 进行抓取。
- 不断重复以上工作、直到所有的任务都执行完毕，抓取结束。
- 抓取结束后、程序会回调 on_finished() 方法，这里可以定义后处理过程。

该框架比较容易上手，网页右边是代码区，先定义类（Class）然后在里面添加爬虫的各种方法（也可以称为函数），运行的过程会在左上方显示，左下方则是输出结果的区域。

这里，分享几个不错的教程以供参考：

GitHub 项目地址：[https://github.com/binux/pyspider](https://github.com/binux/pyspider)

官方主页：[http://docs.pyspider.org/en/latest/](http://docs.pyspider.org/en/latest/)

pyspider 中文网：[http://www.pyspider.cn/page/1.html](http://www.pyspider.cn/page/1.html)

pyspider 爬虫原理剖析：[http://python.jobbole.com/81109/](http://python.jobbole.com/81109/)

pyspider 爬淘宝图案例实操：[https://cuiqingcai.com/2652.html](https://cuiqingcai.com/2652.html)

安装好该框架后，下面我们可以就开始爬取了。

### 2.3. 抓取数据

CMD 命令窗口执行：pyspider all 命令，然后浏览器输入：[http://localhost:5000/](http://localhost:5000/) 就可以启动 pyspider 。

点击 Create 新建一个项目，Project Name 命名为：huxiu，因为要爬取的 URL 是 POST 类型，所以这里可以先不填写，之后可以在代码中添加，再次点击 Creat 便完成了该项目的新建。

![](http://media.makcyun.top/18-11-5/80480010.jpg)

新项目建立好后会自动生成一部分模板代码，我们只需在此基础上进行修改和完善，然后就可以运行爬虫项目了。现在，简单梳理下代码编写步骤。

![](http://media.makcyun.top/18-11-5/13729703.jpg)

```python
from pyspider.libs.base_handler import *
class Handler(BaseHandler):
    crawl_config:{
        "headers":{
            'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36',
            'X-Requested-With': 'XMLHttpRequest'
            }
    }
	def on_start(self):
        for page in range(2,3): # 先循环1页
            print('正在爬取第 %s 页' % page)
            self.crawl('https://www.huxiu.com/v2_action/article_list',method='POST',data={'page':page}, callback=self.index_page)
```

这里，首先定义了一个 Handler 主类，整个爬虫项目都主要在该类下完成。 接着，可以将爬虫基本的一些基本配置，比如 Headers、代理等设置写在下面的 crawl_config 属性中。（如果你还没有习惯从函数（def）转换到类（Class）的代码写法，那么需要先了解一下类的相关知识，之后我也会单独用一篇文章介绍一下。）

下面的 on_start()  方法是程序的入口，也就是说程序启动后会首先从这里开始运行。首先，我们将要爬取的 URL传入 crawl() 方法，同时将 URL 修改成虎嗅网的：https://www.huxiu.com/v2_action/article_list。由于 URL 是 POST 请求，所以我们还需要增加两个参数：method 和 data。method 表示 HTTP 请求方式，默认是 GET，这里我们需要设置为 POST；data 是 POST 请求表单参数，只需要添加一个 page 参数即可。

接着，通过 callback 参数定义一个 index_page() 方法，用来解析 crawl() 方法爬取 URL 成功后返回的 Response 响应。在后面的 index_page() 方法中，可以使用 PyQuery 提取响应中的所需内容。具体提取方法如下：

```python
import json
from pyquery import PyQuery as pq
def index_page(self, response):
        content = response.json['data']
        # 注意，在sublime中，json后面需要添加()，pyspider 中则不用
        doc = pq(content)
        lis = doc('.mod-art').items()
        data = [{
            'title': item('.msubstr-row2').text(),
            'url':'https://www.huxiu.com'+ str(item('.msubstr-row2').attr('href')),
            'name': item('.author-name').text(),
            'write_time':item('.time').text(),
            'comment':item('.icon-cmt+ em').text(),
            'favorites':item('.icon-fvr+ em').text(),
            'abstract':item('.mob-sub').text()
            } for item in lis ]   # 列表生成式结果返回每页提取出25条字典信息构成的list
        print(data)
        return data
    
```

这里，网页返回的 Response 是 json 格式，待提取的信息存放在其中的 data 键值中，由一段 HTML 代码构成。我们可以使用 response.json['data'] 获取该 HTML 信息，接着使用 PyQuery 搭配 CSS 语法提取出文章标题、链接、作者等所需信息。这里使用了列表生成式，能够精简代码并且转换为方便的 list 格式，便于后续存储到 MongoDB 中。我们输出并查看一下第 2 页的提取结果：

```python
# 由25个 dict 构成的 list
[{'title': '想要长生不老？杀死体内的“僵尸细胞”吧', 'url': 'https://www.huxiu.com/article/270086.html', 'name': '造就Talk', 'write_time': '19小时前', 'comment': '4', 'favorites': '28', 'abstract': '如果有了最终疗法，也不应该是每天都需要接受治疗'}, 
 {'title': '日本步入下流社会，我们还在买买买', 'url': 'https://www.huxiu.com/article/270112.html', 'name': '腾讯《大家》©', 'write_time': '20小时前', 'comment': '13', 'favorites': '142', 'abstract': '我买，故我在'}
...
]
```

可以看到，成功得到所需数据，然后就可以保存了，可以选择输出为 CSV、MySQL、MongoDB 等方式，这里我们选择保存到  MongoDB 中。

```python
import pandas as pd
import pymongo
import time
import numpy as np
client = pymongo.MongoClient('localhost',27017)
db = client.Huxiu
mongo_collection = db.huxiu_news

def on_result(self,result):
        if result:
            self.save_to_mongo(result)  
def save_to_mongo(self,result):
    df = pd.DataFrame(result)
    #print(df)
    content = json.loads(df.T.to_json()).values()
    if mongo_collection.insert_many(content):
        print('存储到 mongondb 成功')
        # 随机暂停
        sleep = np.random.randint(1,5)
        time.sleep(sleep)
```

上面，定义了一个 on_result() 方法，该方法专门用来获取 return 的结果数据。这里用来接收上面 index_page() 返回的 data 数据，在该方法里再定义一个存储到 MongoDB 的方法就可以保存到 MongoDB 中。关于数据如何存储到 MongoDB 中，我们在之前的 [一篇文章](https://www.makcyun.top/web_scraping_withpython7.html) 中有过介绍，如果忘记了可以回顾一下。

下面，我们来测试一下整个爬取和存储过程。点击左上角的 run 就可以顺利运行单个网页的抓取、解析和存储，结果如下：

![](http://media.makcyun.top/18-11-6/80607479.jpg)

上面完成了单页面的爬取，接下来，我们需要爬取全部 2000 余页内容。

需要修改两个地方，首先在 on_start() 方法中将 for 循环页数 3 改为 2002。改好以后，如果我们直接点击 run ，会发现还是只能爬取第 2 页的结果。这是因为，pyspider 以 URL的 MD5 值作为 唯一 ID 编号，ID 编号相同的话就视为同一个任务，便不会再重复爬取。由于 GET 请求的 分页URL 通常是有差异的，所以 ID 编号会不同，也就自然能够爬取多页。但这里 POST 请求的分页 URL 是相同的，所以爬完第 2 页，后面的页数便不会再爬取。

那有没有解决办法呢？ 当然是有的，我们需要重新写下 ID 编号的生成方式，方法很简单，在 on_start() 方法前面添加下面 2 行代码即可：

```python
def get_taskid(self,task):
    return md5string(task['url']+json.dumps(task['fetch'].get('data','')))
```

这样，我们再点击 run 就能够顺利爬取 2000 页的结果了，我这里一共抓取了 49,996 条结果，耗时 2 小时左右完成。

![](http://media.makcyun.top/18-11-6/36910200.jpg)

以上，就完成了数据的获取。有了数据我们就可以着手分析，不过这之前还需简单地进行一下数据的清洗、处理。

## 3. 数据清洗处理

首先，我们需要从 MongoDB 中读取数据，并转换为 DataFrame。

```python
client = pymongo.MongoClient(host='localhost', port=27017)
db = client['Huxiu']
collection = db['huxiu_news']
# 将数据库数据转为DataFrame
data = pd.DataFrame(list(collection.find()))
```

下面我们看一下数据的总体情况，可以看到数据的维度是 49996 行 × 8 列。发现多了一列无用的 _id 需删除，同时 name 列有一些特殊符号，比如© 需删除。另外，数据格式全部为 Object 字符串格式，需要将 comment 和 favorites 两列更改为数值格式、 write_time 列更改为日期格式。

```python
print(data.shape)  # 查看行数和列数
print(data.info()) # 查看总体情况
print(data.head()) # 输出前5行

# 结果：
(49996, 8)
Data columns (total 8 columns):
_id           49996 non-null object
abstract      49996 non-null object
comment       49996 non-null object
favorites     49996 non-null object
name          49996 non-null object
title         49996 non-null object
url           49996 non-null object
write_time    49996 non-null object
dtypes: object(8)
    
	_id	abstract	comment	favorites	name	title	url	write_time
0	5bdc2	“在你们看到…	22	50	普象工业设计小站©	看了苹果屌	https://	10小时前
1	5bdc2	中国”绿卡”号称“世界最难拿”	9	16	经济观察报©	递交材料厚	https://	10小时前
2	5bdc2	鲜衣怒马少年时	2	13	小马宋	金庸小说陪	https://	11小时前
3	5bdc2	预告还是预警？	3	10	Cuba Libre	阿里即将发	https://	11小时前
4	5bdc2	库克：咋回事？	2	3	Cuba Libre	【虎嗅早报	https://	11小时前
```

代码实现如下：

```python
# 删除无用_id列
data.drop(['_id'],axis=1,inplace=True)
# 替换掉特殊字符©
data['name'].replace('©','',inplace=True,regex=True)
# 字符更改为数值
data = data.apply(pd.to_numeric,errors='ignore')
# 更该日期格式
data['write_time'] = data['write_time'].replace('.*前','2018-10-31',regex=True) 
# 为了方便，将write_time列，包含几小时前和几天前的行，都替换为10月31日最后1天。
data['write_time'] = pd.to_datetime(data['write_time'])
```

下面，我们看一下数据是否有重复，如果有，那么需要删除。

```python
# 判断整行是否有重复值
print(any(data.duplicated()))
# 显示True，表明有重复值，进一步提取出重复值数量
data_duplicated = data.duplicated().value_counts()
print(data_duplicated) # 显示2 True ，表明有2个重复值
# 删除重复值
data = data.drop_duplicates(keep='first')
# 删除部分行后，index中断，需重新设置index
data = data.reset_index(drop=True)
#结果：
True 
False    49994
True         2
```

然后，我们再增加两列数据，一列是文章标题长度列，一列是年份列，便于后面进行分析。

```python
data['title_length'] = data['title'].apply(len)
data['year'] = data['write_time'].dt.year
Data columns (total 9 columns):
abstract        49994 non-null object
comment         49994 non-null int64
favorites       49994 non-null int64
name            49994 non-null object
title           49994 non-null object
url             49994 non-null object
write_time      49994 non-null datetime64[ns]
title_length    49994 non-null int64
year            49994 non-null int64
```

以上，就完成了基本的数据清洗处理过程，针对这 9 列数据可以开始进行分析了。

## 4. 描述性数据分析

通常，数据分析主要分为四类： 「描述型分析」、「诊断型分析」「预测型分析」「规范型分析」。「描述型分析」是用来概括、表述事物整体状况以及事物间关联、类属关系的统计方法，是这四类中最为常见的数据分析类型。通过统计处理可以简洁地用几个统计值来表示一组数据地集中性（如平均值、中位数和众数等）和离散型(反映数据的波动性大小，如方差、标准差等)。

这里，我们主要进行描述性分析，数据主要为数值型数据（包括离散型变量和连续型变量）和文本数据。

### 4.1. 总体情况

先来看一下总体情况。

```python
print(data.describe())
             comment     favorites  title_length 
count  49994.000000  49994.000000  49994.000000  
mean      10.860203     34.081810     22.775333  
std       24.085969     48.276213      9.540142  
min        0.000000      0.000000      1.000000  
25%        3.000000      9.000000     17.000000  
50%        6.000000     19.000000     22.000000  
75%       12.000000     40.000000     28.000000  
max     2376.000000   1113.000000    224.000000  
```

这里，使用了 data.describe() 方法对数值型变量进行统计分析。从上面可以简要得出以下几个结论：

- 读者的评论和收藏热情都不算太高，大部分文章（75 %）的评论数量为十几条，收藏数量不过几十个。这和一些微信大 V 公众号动辄百万级阅读、数万级评论和收藏量相比，虎嗅网的确相对小众一些。不过也正是因为小众，也才深得部分人的喜欢。
- 评论数最多的文章有 2376 条，收藏数最多的文章有 1113 个收藏量，说明还是有一些潜在的比较火或者质量比较好的文章。
- 最长的文章标题长达 224 个字，大部分文章标题长度在 20 来个字左右，所以标题最好不要太长或过短。

对于非数值型变量（name、write_time），使用 describe() 方法会产生另外一种汇总统计。

```python
print(data['name'].describe())
print(data['write_time'].describe())
# 结果：
count     49994
unique     3162
top          虎嗅
freq      10513
Name: name, dtype: object
count                   49994
unique                   2397
top       2014-07-10 00:00:00
freq                      274
first     2012-04-03 00:00:00
last      2018-10-31 00:00:00
```

unique 表示唯一值数量，top 表示出现次数最多的变量，freq 表示该变量出现的次数，所以可以简单得出以下几个结论：

- 在文章来源方面，3162 个作者贡献了这 5 万篇文章，其中自家官网「虎嗅」写的数量最多，超过了 1 万篇，这也很自然。
- 在文章发表时间方面，最早的一篇文章来自于 2012年 4 月 3 日。 6 年多时间，发文数最多的 1 天 是 2014 年 7 月 10 日，一共发了 274 篇文章。

### 4.2. 不同时期文章发布的数量变化

![](http://media.makcyun.top/18-11-6/47981964.jpg)

可以看到 ，以季度为时间尺度的6 年间，前几年发文数量比较稳定，大概在1750 篇左右，个别季度数量激增到 2000 篇以上。2016 年之后文章开始增加到 2000 篇以上，可能跟网站知名度提升有关。首尾两个季度日期不全，所以数量比较少。

具体代码实现如下：

```python
def analysis1(data):
    # # 汇总统计
    # print(data.describe())
    # print(data['name'].describe())
    # print(data['write_time'].describe())
    
    data.set_index(data['write_time'],inplace=True)
    data = data.resample('Q').count()['name']  # 以季度汇总
    data = data.to_period('Q')
    # 创建x,y轴标签
    x = np.arange(0,len(data),1)
    ax1.plot(x,data.values, #x、y坐标
        color = color_line , #折线图颜色为红色
        marker = 'o',markersize = 4 #标记形状、大小设置
        )
    ax1.set_xticks(x) # 设置x轴标签为自然数序列
    ax1.set_xticklabels(data.index) # 更改x轴标签值为年份
    plt.xticks(rotation=90) # 旋转90度，不至太拥挤

    for x,y in zip(x,data.values):
        plt.text(x,y + 10,'%.0f' %y,ha = 'center',color = colors,fontsize=fontsize_text )
        # '%.0f' %y 设置标签格式不带小数
    # 设置标题及横纵坐标轴标题
    plt.title('虎嗅网文章数量发布变化(2012-2018)',color = colors,fontsize=fontsize_title)
    plt.xlabel('时期')
    plt.ylabel('文章(篇)')
    plt.tight_layout()  # 自动控制空白边缘
    plt.savefig('虎嗅网文章数量发布变化.png',dpi=200)
    plt.show()
```



### 4.3. 文章收藏量 TOP 10

接下来，到了我们比较关心的问题：几万篇文章里，到底哪些文章写得比较好或者比较火？

| 序号 | title                                                        | favorites | comment |
| ---- | ------------------------------------------------------------ | --------- | ------- |
| 1    | 读完这10本书，你就能站在智商鄙视链的顶端了                   | 1113      | 13      |
| 2    | 京东打脸央视：你所谓的翻新iPhone均为正品，我们保留向警方报案的权利 | 867       | 10      |
| 3    | 离职创业？先读完这22本书再说                                 | 860       | 9       |
| 4    | 货币如水，覆水难收                                           | 784       | 39      |
| 5    | 自杀经济学                                                   | 778       | 119     |
| 6    | 2016年已经起飞的5只黑天鹅，都在罗振宇这份跨年演讲全文里      | 774       | 39      |
| 7    | 真正强大的商业分析能力是怎样炼成的？                         | 746       | 18      |
| 8    | 腾讯没有梦想                                                 | 705       | 32      |
| 9    | 段永平连答53问，核心是“不为清单”                             | 703       | 27      |
| 10   | 王健林的滑铁卢                                               | 701       | 92      |

此处选取了「favorites」(收藏数量)作为衡量标准。毕竟，一般好的文章，我们都会有收藏的习惯。

第一名「[读完这10本书，你就能站在智商鄙视链的顶端了](https://www.huxiu.com/article/123650.html) 」以 1113 次收藏位居第一，并且遥遥领先于后者，看来大家都怀有「想早日攀上人生巅峰，一览众人小」的想法啊。打开这篇文章的链接，文中提到了这几本书：《思考，快与慢》、《思考的技术》、《麦肯锡入职第一课：让职场新人一生受用的逻辑思考力》等。一本都没看过，看来这辈子是很难登上人生巅峰了。

发现两个有意思的地方。

第一，**文章标题都比较短小精炼。**

第二，文章收藏量虽然比较高，但评论数都不多，猜测这是因为 **大家都喜欢做伸手党**？

### 4.4. 历年文章收藏量 TOP3

在了解文章的总体排名之后，我们来看看历年的文章排名是怎样的。这里，每年选取了收藏量最多的 3 篇文章。

| year | title                                                        | favorites |
| ---- | ------------------------------------------------------------ | --------- |
| 2012 | 产品的思路——来自腾讯张小龙的分享（全版）                     | 187       |
|      | Fab CEO：创办四家公司教给我的90件事                          | 163       |
|      | 张小龙：微信背后的产品观                                     | 162       |
| 2013 | 创业者手记：我所犯的那些入门错误                             | 473       |
|      | 马化腾三小时讲话实录：千亿美金这个线，其实很恐怖             | 391       |
|      | 雕爷亲身谈：白手起家的我如何在30岁之前赚到1000万。读《MBA教不了的创富课》 | 354       |
| 2014 | 85后，突变的一代                                             | 528       |
|      | 雕爷自述：什么是我做餐饮时琢磨、而大部分“外人”无法涉猎的思考？ | 521       |
|      | 据说这40张PPT是蚂蚁金服的内部培训资料……                      | 485       |
| 2015 | 读完这10本书，你就能站在智商鄙视链的顶端了                   | 1113      |
|      | 京东打脸央视：你所谓的翻新iPhone均为正品，我们保留向警方报案的权利 | 867       |
|      | 离职创业？先读完这22本书再说                                 | 860       |
| 2016 | 蝗虫般的刷客大军：手握千万手机号，分秒间薅干一家平台         | 554       |
|      | 准CEO必读的这20本书，你读过几本？                            | 548       |
|      | 运营简史：一文读懂互联网运营的20年发展与演变                 | 503       |
| 2017 | 2016年已经起飞的5只黑天鹅，都在罗振宇这份跨年演讲全文里      | 774       |
|      | 真正强大的商业分析能力是怎样炼成的？                         | 746       |
|      | 王健林的滑铁卢                                               | 701       |
| 2018 | 货币如水，覆水难收                                           | 784       |
|      | 自杀经济学                                                   | 778       |
|      | 腾讯没有梦想                                                 | 705       |

![](http://media.makcyun.top/18-11-8/86110562.jpg)

可以看到，文章收藏量基本是逐年递增的，但 2015 年的 3 篇文章的收藏量却是最高的，包揽了总排名的前 3 名，不知道这一年的文章有什么特别之处。

以上只罗列了一小部分文章的标题，可以看到标题起地都蛮有水准的。关于标题的重要性，有这样通俗的说法：「`一篇好文章，标题占一半`」，一个好的标题可以大大增强文章的传播力和吸引力。文章标题虽只有短短数十字，但要想起好，里面也是很有很多技巧的。

好在，这里提供了 5 万个标题可以参考。`如需，可以在公众号后台回复「虎嗅」得到这份 CSV 文件。`

代码实现如下：

```python
def analysis2(data):
    # # 总收藏排名
    # top = data.sort_values(['favorites'],ascending = False)
    # # 收藏前10
    # top.index = (range(1,len(top.index)+1)) # 重置index，并从1开始编号
    # print(top[:10][['title','favorites','comment']])

    # 按年份排名
    # # 增加一列年份列
    # data['year'] = data['write_time'].dt.year
    def topn(data):
        top = data.sort_values('favorites',ascending=False)
        return top[:3]
    data = data.groupby(by=['year']).apply(topn)
    print(data[['title','favorites']])
    # 增加每年top123列，列依次值为1、2、3
    data['add'] = 1 # 辅助
    data['top'] = data.groupby(by='year')['add'].cumsum()
    data_reshape = data.pivot_table(index='year',columns='top',values='favorites').reset_index()
    # print(data_reshape)  # ok
    data_reshape.plot(
        # x='year',
        y=[1,2,3],
        kind='bar',
        width=0.3,
        color=['#1362A3','#3297EA','#8EC6F5']  # 设置不同的颜色
        # title='虎嗅网历年收藏数最多的3篇文章'
        )
    plt.xlabel('Year')
    plt.ylabel('文章收藏数量')
    plt.title('历年 TOP3 文章收藏量比较',color = colors,fontsize=fontsize_title)
    plt.tight_layout()  # 自动控制空白边缘，以全部显示x轴名称
    # plt.savefig('历年 Top3 文章收藏量比较.png',dpi=200)
    plt.show()
```



#### 4.4.1. 最高产作者 TOP20

上面，我们从收藏量指标进行了分析,下面，我们关注一下发布文章的作者（个人/媒体）。前面提到发文最多的是虎嗅官方，有一万多篇文章，这里我们筛除官媒，看看还有哪些比较高产的作者。

![](http://media.makcyun.top/18-11-8/9931236.jpg)

可以看到，前 20 名作者的发文量差距都不太大。发文比较多的有「娱乐资本论」、「Eastland」、「发条橙子」这类媒体号；也有虎嗅官网团队的作者：发条橙子、周超臣、张博文等；还有部分独立作者：假装FBI、孙永杰等。可以尝试关注一下这些高产作者。

代码实现如下：

```python
def analysis3(data):
    data = data.groupby(data['name'])['title'].count()
    data = data.sort_values(ascending=False)
    # pandas 直接绘制,.invert_yaxis()颠倒顺序
    data[1:21].plot(kind='barh',color=color_line).invert_yaxis()
    for y,x in enumerate(list(data[1:21].values)):
        plt.text(x+12,y+0.2,'%s' %round(x,1),ha='center',color=colors)
    plt.xlabel('文章数量')
    plt.ylabel('作者')
    plt.title('发文数量最多的 TOP20 作者',color = colors,fontsize=fontsize_title)
    plt.tight_layout()
    plt.savefig('发文数量最多的TOP20作者.png',dpi=200)
    plt.show()
```

#### 4.4.2. 平均文章收藏量最多作者 TOP 10

我们关注一个作者除了是因为文章高产以外，可能更看重的是其文章水准。这里我们选择「文章平均收藏量」（总收藏量/文章数）这个指标，来看看文章水准比较高的作者是哪些人。

这里，为了避免出现「某作者只写了一篇高收藏率的文章」这种不能代表其真实水准的情况，我们将筛选范围定在至少发布过 5 篇文章的作者们。

| name       | total_favorites | ariticls_num | avg_favorites |
| ---------- | --------------- | ------------ | ------------- |
| 重读       | 1947            | 6            | 324           |
| 楼台       | 2302            | 8            | 287           |
| 彭萦       | 2487            | 9            | 276           |
| 曹山石     | 1187            | 5            | 237           |
| 饭统戴老板 | 7870            | 36           | 218           |
| 笔记侠     | 1586            | 8            | 198           |
| 辩手李慕阳 | 11989           | 62           | 193           |
| 李录       | 2370            | 13           | 182           |
| 高晓松     | 889             | 5            | 177           |
| 宁南山     | 2827            | 16           | 176           |

可以看到，前 10 名作者包括：遥遥领先的 **重读**、两位高产又有质量的 **辩手李慕阳** 和 **饭统戴老板**  ，还有大众比较熟悉的 **高晓松**、**宁南山 **等。

如果你将这份名单和上面那份高产作者名单进行对比，会发现他们没有出现在这个名单中。相比于数量，质量可能更重要吧。

下面，我们就来看看排名第一的 **重读** 都写了哪些高收藏量文章。

| order | title                                              | favorites | write_time |
| ----- | -------------------------------------------------- | --------- | ---------- |
| 1     | 我采访出200多万字素材，还原了阿里系崛起前传        | 231       | 2018/10/31 |
| 2     | 阿里史上最强人事地震回顾：中供铁军何以被生生解体   | 494       | 2018/4/9   |
| 3     | 马云“斩”卫哲：复原阿里史上最震撼的人事地震         | 578       | 2018/3/15  |
| 4     | 重读一场马云发起、针对卫哲的批斗会                 | 269       | 2017/8/31  |
| 5     | 阿里“中供系”前世今生：马云麾下最神秘的子弟兵       | 203       | 2017/5/10  |
| 6     | 揭秘马云麾下最神秘的子弟兵：阿里“中供系”的前世今生 | 172       | 2017/4/26  |

居然写的都是清一色关于马老板家的文章。

了解了前十名作者之后，我们顺便也看看那些处于最后十名的都是哪些作者。

| name        | total_favorites | ariticls_num | avg_favorites |
| ----------- | --------------- | ------------ | ------------- |
| 于斌        | 25              | 11           | 2             |
| 朝克图      | 33              | 23           | 1             |
| 东风日产    | 24              | 13           | 1             |
| 董晓常      | 14              | 8            | 1             |
| 蔡钰        | 31              | 16           | 1             |
| 马继华      | 12              | 11           | 1             |
| angeljie    | 7               | 5            | 1             |
| 薛开元      | 6               | 6            | 1             |
| pookylee    | 15              | 24           | 0             |
| Yang Yemeng | 0               | 7            | 0             |

一对比，就能看到他们的文章收藏量就比较寒碜了。尤其好奇最后一位作者 **Yang Yemeng** ，他写了 7 篇文章，竟然一个收藏都没有。

来看看他究竟写了些什么文章。

![](http://media.makcyun.top/18-11-7/59717401.jpg)

原来写的全都是英文文章，看来大家并不太钟意阅读英文类的文章啊。

具体实现代码：

```python
def analysis4(data):
    data = pd.pivot_table(data,values=['favorites'],index='name',aggfunc=[np.sum,np.size])
    data['avg'] = data[('sum','favorites')]/data[('size','favorites')]
    # 平均收藏数取整
    # data['avg'] = data['avg'].round(decimals=1)
    data['avg'] = data['avg'].astype('int')
    # flatten 平铺列
    data.columns = data.columns.get_level_values(0)
    data.columns = ['total_favorites','ariticls_num','avg_favorites']
    # 筛选出文章数至少5篇的
    data=data.query('ariticls_num > 4')
    data = data.sort_values(by=['avg_favorites'],ascending=False)
    # # 查看平均收藏率第一名详情
    # data = data.query('name == "重读"')
    # # 查看平均收藏率倒数第一名详情
    # data = data.query('name == "Yang Yemeng"')
    # print(data[['title','favorites','write_time']])
    print(data[:10]) 	# 前10名
    print(data[-10:])	# 后10名
```



### 4.5. 文章评论数最多 TOP10

说完了收藏量。下面，我们再来看看评论数量最多的文章是哪些。

| order | title                                         | comment | favorites |
| ----- | --------------------------------------------- | ------- | --------- |
| 1     | 喜瓜2.0—明星社交应用的中国式引进与创新        | 2376    | 3         |
| 2     | 百度，请给“儿子们”好好起个名字                | 1297    | 9         |
| 3     | 三星S5为什么对凤凰新闻客户端下注？            | 1157    | 1         |
| 4     | 三星Tab S：马是什么样的马？鞍又是什么样的鞍？ | 951     | 0         |
| 5     | 三星，正在重塑你的营销观                      | 914     | 1         |
| 6     | 马化腾，你就把微信卖给运营商得了！            | 743     | 20        |
| 7     | 【文字直播】罗永浩 VS 王自如 网络公开辩论     | 711     | 33        |
| 8     | 看三星Hub如何推动数字内容消费变革             | 684     | 1         |
| 9     | 三星要重新定义软件与内容商店新模式，SO?       | 670     | 0         |
| 10    | 三星Hub——数字内容交互新模式                   | 611     | 0         |

基本上都是和 **三星** 有关的文章，这些文章大多来自 2014 年，那几年 **三星** 好像是挺火的，不过这两年国内基本上都见不到三星的影子了，世界变化真快。

发现了两个有意思的现象。

第一，上面关于 **三星** 和前面 **阿里** 的这些批量文章，它们「霸占」了评论和收藏榜，结合知乎上曾经的一篇关于介绍虎嗅这个网站的文章：[虎嗅网其实是这样的](
https://www.zhihu.com/question/20799239/answer/20698562) ，貌似能发现些微妙的事情。

第二，这些文章评论数和收藏数两个指标几乎呈极端趋势，评论量多的文章收藏量却很少，评论量少的文章收藏量却很多。

我们进一步观察下这两个参数的关系。

![](http://media.makcyun.top/18-11-6/85687626.jpg)

可以看到，大多数点都位于左下角，意味着这些文章收藏量和评论数都比较低。但也存在少部分位于上方和右侧的异常值，表明这些文章呈现 「多评论、少收藏」或者「少评论、多收藏」的特点。

### 4.6. 文章标题长度

下面，我们再来看看文章标题的长度和收藏量之间有没有什么关系。

![](http://media.makcyun.top/18-11-6/93399033.jpg)

大致可以看出两点现象：

第一，**收藏量高的文章，他们的标题都比较短**（右侧的部分散点）。

第二，**标题很长的文章，它们的收藏量都非常低**（左边形成了一条垂直线）。

看来，文章起标题时最好不要起太长的。

实现代码如下：

```python
def analysis5(data):
    plt.scatter(
        x=data['favorites'],
        y =data['comment'],
        s=data['title_length']/2,
        )
    plt.xlabel('文章收藏量')
    plt.ylabel('文章评论数')
    plt.title('文章标题长度与收藏量和评论数之间的关系',color = colors,fontsize=fontsize_title)
    plt.tight_layout() 
    plt.show()
```

### 文章标题形式

下面，我们看看作者在起文章标题的时候，在标点符号方面有没有什么偏好。

可以看到，五万篇文章中，大多数文章的标题是陈述性标题。三分之一（34.8%） 的文章标题使用了问号「？」，而仅有 5% 的文章用了叹号「！」。通常，问号会让人们产生好奇，从而想去点开文章；而叹号则会带来一种紧张或者压迫感，使人不太想去点开。所以，**可以尝试多用问号而少用叹号。**

![](http://media.makcyun.top/18-11-8/44309942.jpg)

### 4.7. 文本分析

最后，我们从这 5 万篇文章中的标题和摘要中，来看看虎嗅网的文章主要关注的都是哪些主题领域。

这里首先运用了 jieba 分词包对标题进行了分词，然后用 WordCloud 做成了词云图，因虎嗅网含有「虎」字，故选取了一张老虎头像。（关于 jieba 和 WordCloud 两个包，之后再详细介绍）

![](http://media.makcyun.top/18-11-8/24683879.jpg)

可以看到文章的主题内容侧重于：互联网、知名公司、电商、投资这些领域。这和网站本身对外宣传的核心内容，即「关注互联网与移动互联网一系列明星公司的起落轨迹、产业潮汐的动力与趋势，以及互联网与移动互联网如何改造传统产业」大致相符合。

实现代码如下：

```python
def analysis6(data):
    text=''
    for i in data['title'].values:
        symbol_to_replace = '[!"#$%&\'()*+,-./:;<=>?@，。?★、…【】《》？“”‘’！[\\]^_`{|}~]+'
        i = re.sub(symbol_to_replace,'',i)
        text+=' '.join(jieba.cut(i,cut_all=False))
    d = path.dirname(__file__) if "__file__" in locals() else os.getcwd()

    background_Image = np.array(Image.open(path.join(d, "tiger.png")))
    font_path = 'C:\Windows\Fonts\SourceHanSansCN-Regular.otf'  # 思源黑字体

    # 添加stopswords
    stopwords = set()
    # 先运行对text进行词频统计再排序，再选择要增加的停用词
    stopwords.update(['如何','怎么','一个','什么','为什么','还是','我们','为何','可能','不是','没有','哪些','成为','可以','背后','到底','就是','这么','不要','怎样','为了','能否','你们','还有','这样','这个','真的','那些'])
    wc = WordCloud(
        background_color = 'black',
        font_path = font_path,
        mask = background_Image,
        stopwords = stopwords,
        max_words = 2000,
        margin =2,
        max_font_size = 100,
        random_state = 42,
        scale = 2,
    )
    wc.generate_from_text(text)
    process_word = WordCloud.process_text(wc, text)
    # 下面是字典排序
    sort = sorted(process_word.items(),key=lambda e:e[1],reverse=True) # sort为list
    print(sort[:50])  # 输出前词频最高的前50个，然后筛选出不需要的stopwords，添加到前面的stopwords.update()方法中
    img_colors = ImageColorGenerator(background_Image)
    wc.recolor(color_func=img_colors)  # 颜色跟随图片颜色
    plt.imshow(wc,interpolation='bilinear')
    plt.axis('off')
    plt.tight_layout()  # 自动控制空白边缘
    plt.savefig('huxiu20.png',dpi=200)
    plt.show()
```

上面的关键词是这几年总体的概况，而科技互联网行业每年的发展都是不同的，所以，我们再来看看历年的一些关键词，透过这些关键词看看这几年互联网行业、科技热点、知名公司都有些什么不同变化。

![](http://media.makcyun.top/18-11-7/78186420.jpg)

可以看到每年的关键词都有一些相同之处，但也不同的地方：

- 中国互联网、公司、苹果、腾讯、阿里等这些热门关键词一直都是热门，这几家公司真是稳地一批啊。
- 每年会有新热点涌现：比如 2013 年的微信（刚开始火）、2016 年的直播（各大直播平台如雨后春笋般出现）、2017年的 iPhone（上市十周年）、2018年的小米（上市）。
- 不断有新的热门技术出现：2013 - 2015 年的 O2O、2016 年的 VR、2017 年的 AI 、2018 年的「区块链」。这些科技前沿技术也是这几年大家口耳相传的热门词汇。

通过这一幅图，就看出了这几年科技互联网行业、明星公司、热点信息的风云变化。

## 5. 小结

- 本文简要分析了虎嗅网 5 万篇文章信息，大致了解了近些年科技互联网的千变万化。
- 发掘了那些优秀的文章和作者，能够节省宝贵的时间成本。
- 一篇文章要想传播广泛，文章本身的质量和标题各占一半，文中的5 万个标题相信能够带来一些灵感。
- 本文尚未做深入的文本挖掘，而文本挖掘可能比数据挖掘涵盖的信息量更大，更有价值。进行这些分析需要机器学习和深度学习的知识，待后期学习后再来补充。

本文完。

文中的完整代码和素材可以在公众号后台回复「**虎嗅**」 或者在下面的链接中获取：

[https://github.com/makcyun/web_scraping_with_python](https://github.com/makcyun/web_scraping_with_python)



---

推荐阅读：

[做 PPT 没灵感？澎湃网 1500 期信息图送给你](https://www.makcyun.top/web_scraping_withpython4.html)

[听说你想创业找投资？国内创业公司的信息都在这里了](https://www.makcyun.top/web_scraping_withpython7.html) 



![](http://media.makcyun.top/%E5%85%AC%E4%BC%97%E5%8F%B7%E5%85%B3%E6%B3%A8.jpg)

<center>欢迎扫一扫识别关注我的公众号</center>