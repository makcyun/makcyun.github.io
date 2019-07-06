---
title: 从 Class 类到 Scrapy
date: 2018-12-14 16:16:24
id: web_scraping_withpython12
categories: Python爬虫
tags: [Python爬虫]
images: http://media.makcyun.top/18-12-14/76286412.jpg
keywords: [python class,python爬虫]
---

对于 Python 初学者来说，习惯使用函数写代码后，开始学 Scrapy 会感到很复杂，不知如何下手写代码，本文通过实际案例，对比普通函数（类）和 Scrapy 中代码的写法，助你快速入门 Scrapy。

<!-- more -->  

**摘要：**通过实际爬虫案例，分别用普通函数（类）和 Scrapy 进行实现，通过代码，助你快速入门 Scrapy。

上一篇文章，我们通过 3 个实际爬虫案例，分别用函数（def）和 类（Class） 两种方法进行了实现，相信能够帮助你加深对类（Class）概念和用法的理解。在该文的第 3 个例子中，我们从类的写法延伸到了 Pyspider 中类代码的写法，本文进一步补充，通过实际爬虫案例分别用普通类的写法和 Scrapy 中类代码的写法进行实现。

[从函数 def 到类 Class](https://www.makcyun.top/web_scraping_withpython11.html)

Scrapy 爬虫框架非常强大，但是初学起来会觉得有点复杂，因为完整的一段代码需要拆分放在不同的模块下，比如写一个爬虫，原先我们只需要用函数或者类从头写到尾即可，一目了然，但是在 Scrapy 中则不同，我们首先要在 `items.py` 中定义爬取的字段内容，在主程序模块中编写爬虫主程序，在 `pipeline.py`模块中实现数据处理、存储，在 `middlewares.py` 模块中定义代理 IP、UA 等。

总之代码的写法会发生一些变化，我在没适应用 Scrapy 之前，习惯在 Sublime 中完整地用函数实现一遍，然后再迁移到 Scrapy 框架中，虽然慢，但是写多几次后就适应了Scrapy 的写法，这比一上来就直接在 Scrapy 中写过渡地要顺利一些。

好，下面我们就以之前一篇爬取酷安 App 的文章为例进行说明，这篇文章用了 Scrapy 来实现，下面再用普通的函数写法实现一遍，并对关键的地方进行一下对比。

[Scrapy 爬取并分析酷安 6000 款 App，找到良心佳软](https://www.makcyun.top/web_scraping_withpython10.html)



### ▌爬取思路分析

在上面这篇文章里，我面已经对 [目标网站](https://www.coolapk.com/apk?p=1) 进行了分析，这里简单回顾一下，便于把握后续的抓取思路。

首先，网页请求是 GET 形式，URL 只有一个页数递增参数，构造翻页非常简单。每页显示了 10 条  App 信息，通过点击尾页，发现一共有 610 页，也就是说一共有 6100 款左右的 App 。

![](http://media.makcyun.top/18-12-14/90161707.jpg)

接下来，我们需要进入每一个 App 的主页，抓取 App 相关字段信息，确定了 8 个关键字段，分别是：App 名称、下载量、评分、评分人数、评论数、关注人数、体积、App 分类标签。

![](http://media.makcyun.top/18-11-29/57226641.jpg)

然后，打开网页后台，利用正则表达式、CSS分别提取每个字段的信息即可。

![](http://media.makcyun.top/18-11-30/61796640.jpg)

如果你还不熟悉正则、CSS、Xpath 这几种网页内容提取方法，可以参考我早先总结的这篇文章：

[四种方法爬取猫眼 TOP100 电影](https://www.makcyun.top/web_scraping_withpython1.html)

通过上述分析，就可以确定爬取思路了：首先可以通过两种方式构造分页循环，一种是利用 for 循环直接构造 610 页 URL 链接，另外一种是获取下一页的节点，不断递增直到最后一页。第一种方式简单但只适合总页数确定的形式，第二种方式稍微复杂一点，但不管知不知道总页数都可以循环。

接着，每页抓取 10 款 App URL，进入 App 详情页后，利用 CSS 语法抓取每个 App 的 8 个字段信息，最后保存到 MongoDB中，结果形式如下：

![](http://media.makcyun.top/18-11-30/67473511.jpg)

下面我们就来实操对比一下。

### ▌获取网页 Response

首先，遍历每页的 URL 请求获得响应 Response，提取每款 App 主页的 URL 请求，以便下一步解析提取字段内容。

def 写法：

两次 for 循环，提取所有的 URL 链接，供下一步解析内容。

```python
headers = {
    'user-agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36'
}
def get_page(page):
    url = 'https://www.coolapk.com/apk?p=%s' %page
    response = requests.get(url,headers=headers).text
    content = pq(response)('.app_left_list>a').items()
    urls = []
    for item in content:
        url = urljoin('https://www.coolapk.com',item.attr('href'))
        urls.append(url)
    return urls

if __name__ == '__main__':
    for page in range(1, 610): 
        get_page(page)
```

Scrapy 写法：

```python
class KuspiderSpider(scrapy.Spider):
    name = 'kuspider'
    allowed_domains = ['www.coolapk.com']
    start_urls = ['https://www.coolapk.com/apk/']
    headers = {
        'user-agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36'
    }
     def start_requests(self):
        pages = []
        for page in range(1,610):  
            url = 'https://www.coolapk.com/apk/?page=%s' % page
            page = scrapy.Request(
                url, callback=self.parse, headers=self.headers)
            pages.append(page)
        return pages
    
    def parse(self, response):
        contents = response.css('.app_left_list>a')
        for content in contents:
            url = content.css('::attr("href")').extract_first()
            url = response.urljoin(url)
            yield scrapy.Request(url, callback=self.parse_url)
```

这里有几点不同的地方，简单进行说明：

-  循环构造方式不同

 普通函数用两个 for 循环就可以，Scrapy 中是构造最外层的循环，实现方法是先构造一个空列表，存放 page，URL 构造好之后通过 scrapy.Request () 方法进行请求，获得响应 response ，传递给 callback 参数指定的 parse() 方法，再进一步进行第二个 for 循环。

- 内容提取形式不同

  以 CSS 语法提取为例，普通函数和 Scrapy 中内容提取的方法稍有不同， 下面以提取提取单个节点文本、提取属性、提取多个节点，这三种最为常见的提取形式为例，将普通函数和 Scrapy 的写法进行对比：

  ```python
  
  #提取单个节点文本
  name = item('.list_app_title').text()
  name = item.css('.detail_app_title::text').extract_first()
  #提取属性
  url = item('.app_left_list>a').attr('href')
  url = item.css('::attr("href")').extract_first()
  #提取多个节点
  content = pq(response)('.app_left_list>a').items() 
  contents = response.css('.app_left_list>a')
  ```

这里顺便再说一下 Scrapy 遍历分页的第二种方式。

如果不通过构造 for 循环的方式遍历，可以先请求第一页获得 response 进行解析，然后再获取下一页 url 重复调用解析方法，直到解析完最后一页为止，这种方法 start_requests 构造就很简单，直接传递 url 到下一个 parse() 方法即可。

```python
 def start_requests(self):
    url = 'https://www.coolapk.com/apk/?page=1'
 	yield scrapy.Request(
                url, callback=self.parse, headers=self.headers)
            pages.append(page)
        return pages
 def parse(self, response):
    contents = response.css('.app_left_list>a')
    for content in contents:
        url = content.css('::attr("href")').extract_first()
        url = response.urljoin(url)
        yield scrapy.Request(url, callback=self.parse_url)
    
    next_page = response.css('.pagination li:nth-child(8) a::attr("href")').extract_first()
    url = response.urljoin(next_page)
    yield scrapy.Request(url,callback=self.parse )
```

### ▌解析网页提取字段

接下来，我们就要提取App 名称、下载量、评分这些字段信息了。

def 写法：

```python
def parse_content(urls):
    lst = []
    for url in urls:
        response = requests.get(url,headers=headers).text
        doc = pq(response) # pyquery解析
        name = doc('.detail_app_title').remove('span').text()
        # 若不想要子节点文本则先去除掉
        results = get_comment(doc)
        tags = get_tags(doc)
        score = doc('.rank_num').text()
        # 评论数
        num_score = doc('.apk_rank_p1').text()
        num_score = re.search('共(.*?)个评分',num_score).group(1)
        data ={
            'name':name,
            'volume':results[0],
            'download':results[1],
            'follow':results[2],
            'comment':results[3],
            'tags':str(tags),
            'score':score,
            'num_score':num_score
        }
        lst.append(data)
        data = pd.DataFrame(lst)
        return data
```

这里，值得注意一点：

pyquery 提取文本的时候，默认会提取节点内所有的文本内容，如果你只想要其中某个节点的，那么最好先删除掉不需要的节点，再提取文本。

![](http://media.makcyun.top/18-11-30/61796640.jpg)

比如这里，我们在提取 app 名称的时候，如果直接用：

```python
name = doc('.detail_app_title')text()
```

提取出来的则是「酷安 8.8.3」，如果只想要「酷安」，不想要下面的版本信息：8.8.3，需要删除子节点 span 后再提取：

```python
name = doc('.detail_app_title').remove('span').text()
```

Scrapy 写法：

获取字段信息，我们需要现在 settings.py 中设置，然后才能提取。

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

回到主程序中，通过 `item = Kuan2Item()` 来调用上面定义的字段信息。

```python
def parse(self, response):
    contents = response.css('.app_left_list>a')
    for content in contents:
        url = content.css('::attr("href")').extract_first()
        url = response.urljoin(url)
        yield scrapy.Request(url, callback=self.parse_url)

def parse_url(self, response):
    item = Kuan2Item()
    item['name'] = response.css('.detail_app_title::text').extract_first()
    results = self.get_comment(response)
    item['volume'] = results[0]
    item['download'] = results[1]
    item['follow'] = results[2]
    item['comment'] = results[3]
    item['tags'] = self.get_tags(response)
    item['score'] = response.css('.rank_num::text').extract_first()
    num_score = response.css('.apk_rank_p1::text').extract_first()
    item['num_score'] = re.search('共(.*?)个评分', num_score).group(1)
    yield item
```

### ▌存储到 MongoDB

提取完信息以后，我们便可以选择将数据存储到 MongoDB 中。

通过上面的方法，我们提取出了字段内容 data，然后转换为了 DataFrame，DataFrame 存储到 MongoDB 非常简单，几行代码就能搞定。

def 写法：

```python
client = pymongo.MongoClient('localhost',27017)
db = client.KuAn
mongo_collection = db.kuan
def save_file(data):
	content = json.loads(data.T.to_json()).values()
    if mongo_collection.insert_many(content):
        print('存储到 mongondb 成功')
```

这里用了 inset_many () 方法来插入数据，但其实不太建议，因为一旦出现爬虫中断，我们再接着爬的时候，它会插入重复数据，虽然我们可以再后续处理时去除重复数据，但有更好的方法，那就是用 update_one() 方法，该方法能够保证直插入新数据，重复数据不插入，下面我们在 Scrapy 中使用：

Scrapy 写法：

```python
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
        # update_one 方法可以不插入重复内容
        self.db[name].update_one(item, {'$set': item}, upsert=True)
        return item

    def close_spider(self,spider):
        self.client.close()
```

简单说明几点：

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

Scrapy 字段提取后，通过 yield 返回的是生成器，内容是单个字典信息，此时，我们可以下面这句代码，实现只插入新数据，忽略重复数据。

```python
self.db[name].update_one(item, {'$set': item}, upsert=True)
```

以上，我们从获取网页 Response、解析内容、MongoDB 存储三个方面，对比了普通函数和 Scrapy 代码的写法，这三部分内容是多数爬虫的主要部分。当然，还有其他的内容比如：下载图片、反爬措施等，我们留在后续的 Scrapy 文章中继续介绍。

如需完整代码，可以加入我的知识星球「**第2脑袋**」获取，里面有很多干货，期待你的到来。

![](http://media.makcyun.top/18-12-1/95375420.jpg)

本文完。

---


推荐阅读：

[从函数 def 到类 Class](https://www.makcyun.top/web_scraping_withpython12.html)

[Scrapy 爬取并分析酷安 6000 款 App，找到良心佳软](https://www.makcyun.top/web_scraping_withpython10.html)