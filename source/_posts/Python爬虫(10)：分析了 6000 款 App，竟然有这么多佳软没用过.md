---



title: Scrapy 爬取并分析酷安 6000 款 App，找到良心佳软（抓取篇）
date: 2018-11-29 16:16:24
id: web_scraping_withpython10
categories: Python爬虫
tags: [Python爬虫]
images: http://media.makcyun.top/18-12-1/60882782.jpg
keywords: [Python爬虫]
---

发现了RE 管理器、一个木函、VIA 浏览器、快图浏览等一众好软件。

<!-- more -->  

**摘要：** 如今移动互联网越来越发达，我们每个人的手机上至少都安装了好几十款 App，随着各式各样的 App 层出不穷，也就产生了优劣之分，而我们肯定愿意去使用那些良心佳软，而如何去发现这些 App 呢，本文使用 Scrapy 框架爬取了著名应用下载市场「酷安网」上的 6000 余款 App，通过分析，发现了各个类别领域下的佼佼者，这些 App 堪称真正的良心心之作，使用它们将会给你带来全新的手机使用体验。

## 1. 分析背景

### 1.1. 为什么选择酷安

如果说 GitHub 是程序员的天堂，那么 **酷安** 则是手机 App 爱好者们（别称「搞机」爱好者）的天堂，相比于那些传统的手机应用下载市场，酷安有三点特别之处：

第一、可以搜索下载到各种 **神器、佳软**，其他应用下载市场几乎很难找得到。

比如之前的文章中说过的终端桌面「Aris」、安卓最强阅读器「静读天下」、RSS 阅读器 「Feedme」 等。

第二、可以找到很多 App 的破解版。

我们提倡「为好东西付费」，但是有些 App 很蛋疼，比如「百度网盘」，在这里面就可以找到很多 App 的破解版。

第三、可以找到 App 的历史版本。

很多人喜欢用最新版本的 App，一有更新就马上升级，但是现在很多 App 越来越功利、越更新越臃肿、广告满天飞，倒不如回归本源，使用体积小巧、功能精简、无广告的早期版本。

作为一名 App 爱好者，我在酷安上发现了很多不错的 App，越用越感觉自己知道的仅仅是冰山一角，便想扒一扒这个网站上到底有多少好东西，手动一个个去找肯定是不现实了，自然想到最好的方法——用爬虫来解决，为了实现此目的，最近就学习了一下 Scrapy 爬虫框架，爬取了该网 6000 款左右的 App，通过分析，找到了不同领域下的精品 App，下面我们就来一探究竟。

### 1.2. 分析内容

- 总体分析 6000 款 App 的评分、下载量、体积等指标。
- 根据日常使用功能场景，将 App 划分为：系统工具、资讯阅读、社交娱乐等 10 大类别，筛选出每个类别下的精品 App。


### 1.3. 分析工具

- Python
- Scrapy
- MongoDB
- Pyecharts
- Matplotlib

## 2. 数据抓取

由于酷安手机端 App 设置了反扒措施，使用 Charles 尝试后发现无法抓包， 暂退而求其次，使用 Scrapy 抓取网页端的 App 信息。抓取时期截止到 2018 年 11 月 23日，共计 6086 款 App，共抓取 了 8 个字段信息：App 名称、下载量、评分、评分人数、评论数、关注人数、体积、App 分类标签。

### 2.1. 目标网站分析

这是我们要抓取的 [目标网页](https://www.coolapk.com/apk?p=1)，点击翻页可以发现两点有用的信息：

- 每页显示了 10 条  App 信息，一共有610页，也就是 6100 个左右的 App 。
- 网页请求是 GET 形式，URL 只有一个页数递增参数，构造翻页非常简单。

![](http://media.makcyun.top/18-11-29/13499186.jpg)

接下来，我们来看看选择抓取哪些信息，可以看到，主页面内显示了 App 名称、下载量、评分等信息，我们再点击 App 图标进入详情页，可以看到提供了更齐全的信息，包括：分类标签、评分人数、关注人数等。由于，我们后续需要对 App 进行分类筛选，故分类标签很有用，所以这里我们选择进入每个 App 主页抓取所需信息指标。

![](http://media.makcyun.top/18-11-29/57226641.jpg)

![](C:\Users\sony\AppData\Roaming\Typora\typora-user-images\1543460157799.png)

通过上述分析，我们就可以确定抓取流程了，首先遍历主页面 ，抓取 10 个 App 的详情页 URL，然后详情页再抓取每个 App 的指标，如此遍历下来，我们需要抓取 6000 个左右网页内容，抓取工作量不算小，所以，我们接下来尝试使用 Scrapy 框架进行抓取。

### 2.2. Scrapy 框架介绍

介绍 Scrapy 框架之前，我们先回忆一下 Pyspider 框架，之前一篇爬取分析 [虎嗅网](https://www.makcyun.top/web_scraping_withpython9.html) 的文章，我们使用了它，它是由国内大神编写的一个爬虫利器， Github Star 超过 10K，但是它的整体功能还是相对单薄一些，还有比它更强大的框架么？有的，就是这里要说的 Scrapy 框架，Github Star 超过 30K，是 Python  爬虫界使用最广泛的爬虫框架，玩爬虫这个框架必须得会。

网上关于 Scrapy 的官方文档和教程很多，这里罗列几个。

> [Scrapy 中文文档](https://scrapy-chs.readthedocs.io/zh_CN/0.24/index.html)
>
> [崔庆才的 Scrapy 专栏](https://cloud.tencent.com/developer/column/1108/tag-10756)
>
> [Scrapy 爬拉勾](https://blog.csdn.net/hk2291976/article/details/51405052)
>
> [Scrapy 爬豆瓣电影](https://zhuanlan.zhihu.com/p/24769534)

Scrapy 框架相对于 Pyspider 相对要复杂一些，有不同的处理模块，项目文件也由好几个程序组成，不同的爬虫模块需要放在不同的程序中去，所以刚开始入门会觉得程序七零八散，容易把人搞晕，建议采取以下思路快速入门 Scrapy：

- 首先，快速过一下上面的参考教程，了解 Scrapy 的爬虫逻辑和各程序的用途与配合。

- 接着，看上面两个实操案例，熟悉在 Scrapy 中怎么写爬虫。

- 最后，找个自己感兴趣的网站作为爬虫项目，遇到不懂的就看教程或者 Google。


这样的学习路径是比较快速而有效的，比一直抠教程不动手要好很多。下面，我们就以酷安网为例，用 Scrapy 来爬取一下。

### 2.3. 抓取数据

首先要安装好 Scrapy 框架，如果是 Windwos 系统，且已经安装了 Anaconda，那么安装 Scrapy 框架就非常简单，只需打开 Anaconda Prompt 命令窗口，输入下面一句命令即可，会自动帮我们安装好 Scrapy 所有需要安装和依赖的库。

```python
conda pip scrapy
```

#### 2.3.1. 创建项目

接着，我们需要创建一个爬虫项目，所以我们先从根目录切换到需要放置项目的工作路径，比如我这里设置的存放路径为：E:\my_Python\training\kuan，接着继续输入下面一行代码即可创建 kuan 爬虫项目：

```python
# 切换工作路径
e:
cd E:\my_Python\training\kuan
# 生成项目
scrapy startproject kuspider
```

执行上面的命令后，就会生成一个名为 kuan 的 scrapy 爬虫项目，包含以下几个文件：

```python
scrapy. cfg # Scrapy 部署时的配置文件
kuan # 项目的模块，需要从这里引入
_init__.py
items.py # 定义爬取的数据结构
middlewares.py # Middlewares 中间件
pipelines.py # 数据管道文件，可用于后续存储
settings.py # 配置文件
spiders # 爬取主程序文件夹
_init_.py
```

下面，我们需要再 spiders 文件夹中创建一个爬取主程序：kuan.py，接着运行下面两行命令即可：

```python
cd kuan # 进入刚才生成的 kuan 项目文件夹
scrapy genspider kuan www.coolapk.com  # 生成爬虫主程序文件 kuan.py
```

#### 2.3.2. 声明 item

项目文件创建好以后，我们就可以开始写爬虫程序了。

首先，需要在 items.py 文件中，预先定义好要爬取的字段信息名称，如下所示：

```python
class KuanItem(scrapy.Item):
# define the fields for your item here like:
name = scrapy.Field()
volume = scrapy.Field()
download = scrapy.Field()
follow = scrapy.Field()
comment = scrapy.Field()
tags = scrapy.Field()
score = scrapy.Field()
num_score = scrapy.Field()
```

这里的字段信息就是我们前面在网页中定位的 8 个字段信息，包括：name 表示 App 名称、volume 表示体积、download 表示 下载数量。在这里定义好之后，我们在后续的爬取主程序中会利用到这些字段信息。

#### 2.3.3. 爬取主程序

创建好 kuan 项目后，Scrapy 框架会自动生成爬取的部分代码，我们接下来就需要在 parse 方法中增加网页抓取的字段解析内容。

```python
class KuspiderSpider(scrapy.Spider):
    name = 'kuan'
    allowed_domains = ['www.coolapk.com']
    start_urls = ['http://www.coolapk.com/']

    def parse(self, response):
        pass
```

打开主页 Dev Tools，找到每项抓取指标的节点位置，然后可以采用 CSS、Xpath、正则等方法进行提取解析，这些方法 Scrapy 都支持，可随意选择，这里我们选用 CSS 语法来定位节点，不过需要注意的是，Scrapy 的 CSS 语法和之前我们利用 pyquery 使用的 CSS 语法稍有不同，举几个例子，对比说明一下。

![](http://media.makcyun.top/18-11-30/64130730.jpg)

首先，我们定位到第一个 APP 的主页 URL 节点，可以看到 URL 节点位于 class 属性为 `app_left_list` 的 div 节点下的 a 节点中，其 href 属性就是我们需要的 URL 信息，这里是相对地址，拼接后就是完整的 URL ：[www.coolapk.com/apk/com.coolapk.market](https://www.coolapk.com/apk/com.coolapk.market)。

接着我们进入酷安详情页，选择 App 名称并进行定位，可以看到 App 名称节点位于 class 属性为 `.detail_app_title` 的 p 节点的文本中。

![](http://media.makcyun.top/18-11-30/61796640.jpg)

定位到这两个节点之后，我们就可以使用 CSS 提取字段信息了，这里对比一下常规写法和 Scrapy 中的写法：

```python
# 常规写法
url = item('.app_left_list>a').attr('href')
name = item('.list_app_title').text()
# Scrapy 写法
url = item.css('::attr("href")').extract_first()
name = item.css('.detail_app_title::text').extract_first()
```

可以看到，要获取 href 或者 text 属性，需要用 :: 表示，比如获取 text，则用 ::text。extract_first()  表示提取第一个元素，如果有多个元素，则用 extract() 。接着，我们就可以参照写出 8 个字段信息的解析代码。

首先，我们需要在主页提取 App 的 URL 列表，然后再进入每个 App 的详情页进一步提取 8 个字段信息。

```python
def parse(self, response):
    contents = response.css('.app_left_list>a')
    for content in contents:
        url = content.css('::attr("href")').extract_first()
        url = response.urljoin(url)  # 拼接相对 url 为绝对 url
        yield scrapy.Request(url,callback=self.parse_url)
```

这里，利用 response.urljoin() 方法将提取出的相对 URL 拼接为完整的 URL，然后利用 scrapy.Request() 方法构造每个 App 详情页的请求，这里我们传递两个参数：url 和 callback，url 为详情页 URL，callback 是回调函数，它将主页 URL 请求返回的响应 response 传给专门用来解析字段内容的 parse_url() 方法，如下所示：

```python
def parse_url(self,response):
    item = KuanItem()
    item['name'] = response.css('.detail_app_title::text').extract_first()
    results = self.get_comment(response)
    item['volume'] = results[0]
    item['download'] = results[1]
    item['follow'] = results[2]
    item['comment'] = results[3]
    item['tags'] = self.get_tags(response)
    item['score'] = response.css('.rank_num::text').extract_first()
    num_score = response.css('.apk_rank_p1::text').extract_first()
    item['num_score'] = re.search('共(.*?)个评分',num_score).group(1)
    yield item
    
def get_comment(self,response):
    messages = response.css('.apk_topba_message::text').extract_first()
    result = re.findall(r'\s+(.*?)\s+/\s+(.*?)下载\s+/\s+(.*?)人关注\s+/\s+(.*?)个评论.*?',messages)  # \s+ 表示匹配任意空白字符一次以上
    if result: # 不为空
        results = list(result[0]) # 提取出list 中第一个元素
        return results

def get_tags(self,response):
    data = response.css('.apk_left_span2')
    tags = [item.css('::text').extract_first() for item in data]
    return tags
```

这里，单独定义了 get_comment() 和 get_tags() 两个方法.

get_comment() 方法通过正则匹配提取 volume、download、follow、comment 四个字段信息，正则匹配结果如下：

```python
result = re.findall(r'\s+(.*?)\s+/\s+(.*?)下载\s+/\s+(.*?)人关注\s+/\s+(.*?)个评论.*?',messages)
print(result) # 输出第一页的结果信息
# 结果如下：
[('21.74M', '5218万', '2.4万', '5.4万')]
[('75.53M', '2768万', '2.3万', '3.0万')]
[('46.21M', '1686万', '2.3万', '3.4万')]
[('54.77M', '1603万', '3.8万', '4.9万')]
[('3.32M', '1530万', '1.5万', '3343')]
[('75.07M', '1127万', '1.6万', '2.2万')]
[('92.70M', '1108万', '9167', '1.3万')]
[('68.94M', '1072万', '5718', '9869')]
[('61.45M', '935万', '1.1万', '1.6万')]
[('23.96M', '925万', '4157', '1956')]
```

然后利用 result[0]、result[1] 等分别提取出四项信息，以 volume 为例，输出第一页的提取结果：

```python
item['volume'] = results[0]
print(item['volume'])
21.74M
75.53M
46.21M
54.77M
3.32M
75.07M
92.70M
68.94M
61.45M
23.96M
```

这样一来，第一页 10 款 App 的所有字段信息都被成功提取出来，然后返回到 yied item 生成器中，我们输出一下它的内容：

```python
[
{'name': '酷安', 'volume': '21.74M', 'download': '5218万', 'follow': '2.4万', 'comment': '5.4万', 'tags': "['酷市场', '酷安', '市场', 'coolapk', '装机必备']", 'score': '4.4', 'num_score': '1.4万'}, 
{'name': '微信', 'volume': '75.53M', 'download': '2768万', 'follow': '2.3万', 'comment': '3.0万', 'tags': "['微信', 'qq', '腾讯', 'tencent', '即时聊天', '装机必备']",'score': '2.3', 'num_score': '1.1万'},
...
]
```

#### 2.3.4. 分页爬取

以上，我们爬取了第一页内容，接下去需要遍历爬取全部 610 页的内容，这里有两种思路：

- 第一种是提取翻页的节点信息，然后构造出下一页的请求，然后重复调用 parse 方法进行解析，如此循环往复，直到解析完最后一页。
- 第二种是先直接构造出 610 页的 URL 地址，然后批量调用 parse 方法进行解析。

这里，我们分别写出两种方法的解析代码。

第一种方法很简单，直接接着 parse 方法继续添加以下几行代码即可：

```python
def parse(self, response):
    contents = response.css('.app_left_list>a')
    for content in contents:
        ...
    
    next_page = response.css('.pagination li:nth-child(8) a::attr(href)').extract_first()
    url = response.urljoin(next_page)
    yield scrapy.Request(url,callback=self.parse )
```

第二种方法，我们在最开头的 parse() 方法前，定义一个 start_requests() 方法，用来批量生成 610 页的 URL，然后通过 scrapy.Request() 方法中的 callback 参数，传递给下面的 parse() 方法进行解析。

```python
def start_requests(self):
        pages = []
        for page in range(1,610):  # 一共有610页
            url = 'https://www.coolapk.com/apk/?page=%s'%page
            page =  scrapy.Request(url,callback=self.parse)
            pages.append(page)
        return pages
```

以上就是全部页面的爬取思路，爬取成功后，我们需要存储下来。这里，我面选择存储到 MongoDB 中，不得不说，相比 MySQL，MongoDB 要方便省事很多。

#### 2.3.5. 存储结果

我们在 pipelines.py 程序中，定义数据存储方法，MongoDB 的一些参数，比如地址和数据库名称，需单独存放在 settings.py 设置文件中去，然后在 pipelines 程序中进行调用即可。

```python
import pymongo
class MongoPipeline(object):
    def __init__(self,mongo_url,mongo_db):
        self.mongo_url = mongo_url
        self.mongo_db = mongo_db
    @classmethod
    def from_crawler(cls,crawler):
        return cls(
            mongo_url = crawler.settings.get('MONGO_URL'),
            mongo_db = crawler.settings.get('MONGO_DB')
        )
    def open_spider(self,spider):
        self.client = pymongo.MongoClient(self.mongo_url)
        self.db = self.client[self.mongo_db]
    def process_item(self,item,spider):
        name = item.__class__.__name__
        self.db[name].insert(dict(item))
        return item
    def close_spider(self,spider):
        self.client.close()
```

首先，我们定义一个 MongoPipeline(）存储类，里面定义了几个方法，简单进行一下说明：

from crawler() 是一个类方法，用 ＠class method 标识，这个方法的作用主要是用来获取我们在 settings.py 中设置的这几项参数：

```python
MONGO_URL = 'localhost'
MONGO_DB = 'KuAn'
ITEM_PIPELINES = {
   'kuan.pipelines.MongoPipeline': 300,
}
```

open_spider() 方法主要进行一些初始化操作 ，在 Spider 开启时，这个方法就会被调用 。

process_item() 方法是最重要的方法，实现插入数据到 MongoDB 中。

![](http://media.makcyun.top/18-11-30/67473511.jpg)

完成上述代码以后，输入下面一行命令就可以开始整个爬虫的抓取和存储过程了，单机跑的话，6000 个网页需要不少时间才能完成，保持耐心。

```python
scrapy crawl kuan
```

这里，还有两点补充：

第一，**为了减轻网站压力，我们最好在每个请求之间设置几秒延时**，可以在 KuspiderSpider() 方法开头出，加入以下几行代码：

```python
custom_settings = {
        "DOWNLOAD_DELAY": 3, # 延迟3s,默认是0，即不延迟
        "CONCURRENT_REQUESTS_PER_DOMAIN": 8 # 每秒默认并发8次，可适当降低
    }
```

第二，为了更好监控爬虫程序运行，有必要 **设置输出日志文件**，可以通过 Python 自带的 logging 包实现：

```python
import logging

logging.basicConfig(filename='kuan.log',filemode='w',level=logging.WARNING,format='%(asctime)s %(message)s',datefmt='%Y/%m/%d %I:%M:%S %p')
logging.warning("warn message")
logging.error("error message")
```

这里的 level 参数表示警告级别，严重程度从低到高分别是：DEBUG < INFO < WARNING < ERROR < CRITICAL，如果想日志文件不要记录太多内容，可以设置高一点的级别，这里设置为 WARNING，意味着只有 WARNING 级别以上的信息才会输出到日志中去。

添加 datefmt 参数是为了在每条日志前面加具体的时间，这点很有用处。

![](http://media.makcyun.top/18-11-30/67506230.jpg)

以上，我们就完成了整个数据的抓取，有了数据我们就可以着手进行分析，不过这之前还需简单地对数据做一下清洗和处理。

## 3. 数据清洗处理

首先，我们从 MongoDB 中读取数据并转化为 DataFrame，然后查看一下数据的基本情况。

```python
def parse_kuan():
    client = pymongo.MongoClient(host='localhost', port=27017)
    db = client['KuAn']
    collection = db['KuAnItem']
    # 将数据库数据转为DataFrame
    data = pd.DataFrame(list(collection.find()))
    print(data.head())
    print(df.shape)
    print(df.info())
    print(df.describe())

```

![](http://media.makcyun.top/18-11-30/16708510.jpg)

从 data.head() 输出的前 5 行数据中可以看到，除了 score 列是 float 格式以外，其他列都是 object 文本类型。

comment、download、follow、num_score 这 5 列数据中部分行带有「万」字后缀，需要将字符去掉再转换为数值型；volume 体积列，则分别带有「M」和「K」后缀，为了统一大小，则需将「K」除以 1024，转换为 「M」体积。

整个数据一共有 6086 行 x 8 列，每列均没有缺失值。

df.describe() 方法对 score 列做了基本统计，可以看到，所有 App 的平均得分是 3.9 分（5 分制），最低得分 1.6 分，最高得分 4.8 分。

下面，我们将以上几列文本型数据转换为数值型数据，代码实现如下：

```python
def data_processing(df):
#处理'comment','download','follow','num_score','volume' 5列数据，将单位万转换为单位1，再转换为数值型
    str = '_ori'
    cols = ['comment','download','follow','num_score','volume']
    for col in cols:
        colori = col+str
        df[colori] = df[col] # 复制保留原始列
        if not (col == 'volume'):
            df[col] = clean_symbol(df,col)# 处理原始列生成新列
        else:
            df[col] = clean_symbol2(df,col)# 处理原始列生成新列

    # 将download单独转换为万单位
    df['download'] = df['download'].apply(lambda x:x/10000)
    # 批量转为数值型
    df = df.apply(pd.to_numeric,errors='ignore')
    
def clean_symbol(df,col):
    # 将字符“万”替换为空
    con = df[col].str.contains('万$')
    df.loc[con,col] = pd.to_numeric(df.loc[con,col].str.replace('万','')) * 10000
    df[col] = pd.to_numeric(df[col])
    return df[col]

def clean_symbol2(df,col):
    # 字符M替换为空
    df[col] = df[col].str.replace('M$','')
    # 体积为K的除以 1024 转换为M
    con = df[col].str.contains('K$')
    df.loc[con,col] = pd.to_numeric(df.loc[con,col].str.replace('K$',''))/1024
    df[col] = pd.to_numeric(df[col])
    return df[col]

```

以上，就完成了几列文本型数据的转换，我们再来查看一下基本情况：

|       | comment | download | follow | num_score | score | volume |
| :---: | :-----: | :------: | :----: | :-------: | :---: | :----: |
| count |  6086   |   6086   |  6086  |   6086    | 6086  |  6086  |
| mean  |  255.5  |   13.7   | 729.3  |   133.1   |  3.9  |  17.7  |
|  std  | 1437.3  |    98    | 1893.7 |   595.4   |  0.6  |  20.6  |
|  min  |    0    |    0     |   0    |     1     |  1.6  |   0    |
|  25%  |   16    |   0.2    |   65   |    5.2    |  3.7  |  3.5   |
|  50%  |   38    |   0.8    |  180   |    17     |   4   |  10.8  |
|  75%  |   119   |   4.5    | 573.8  |    68     |  4.3  |  25.3  |
|  max  |  53000  |   5190   | 38000  |   17000   |  4.8  | 294.2  |

从中可以看出以下几点信息：

- download 列为 App 下载数量，下载量最多的 App 有 5190 万次，最少的为 0 (很少很少)，平均下载次数为 14 万次；
- volume 列为 App 体积，体积最大的 App 达到近 300M，体积最小的几乎为 0，平均体积在 18M 左右。
- comment 列为 App 评分，评分数最多的达到了 5 万多条，平均有 200 多条。

以上，就完成了基本的数据清洗处理过程，下面一篇文章我们将对数据进行探索性分析。



## 4. 资源获取

如需完整代码可以搜索加入我的「**知识星球：第2脑袋**」获取，期待你的到来。

![](http://media.makcyun.top/18-12-1/95375420.jpg)

本文完。

---

推荐阅读：

[pyspider 爬取并分析虎嗅网 5 万篇文章](https://www.makcyun.top/web_scraping_withpython9.html)

