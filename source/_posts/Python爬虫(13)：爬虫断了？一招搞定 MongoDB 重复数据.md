---
title: 爬虫断了？一招搞定 MongoDB 重复数据
date: 2018-12-19 16:16:24
id: web_scraping_withpython13
categories: Python爬虫
tags: [Python爬虫]
images: http://media.makcyun.top/18-12-19/93466082.jpg
keywords: [MongoDB避免爬重复数据,python爬虫]
---

MongoDB 避免插入重复数据。

<!-- more -->  

**摘要：**尽量使用 update_one() 方法而不是 insert_one() 插入数据。

相信你一定有过这样的经历：大晚上好不容易写好一个爬虫，添加了种种可能出现的异常处理，测试了很多遍都没有问题，点击了 RUN 开始正式运行 ，然后美滋滋地准备钻被窝睡觉，睡前还特意检查了下确认没有问题，合上眼后期待着第二天起来，数据都乖乖地躺在 MongoDB 中。第二天早上一睁眼就满心欢喜地冲到电脑前，结果发现爬虫半夜断了，你气得想要砸电脑，然后你看了一下 MongoDB 中爬了一半的数据，在想是删掉重新爬，还是保留下来接着爬。

到这儿问题就来了，删掉太可惜，接着爬很可能会爬到重复数据，虽然后期可以去重，但你有强迫症，就是不想爬到重复数据，怎么办呢？

这就遇到了「爬虫断点续传」问题，关于这个问题的解决方法有很多种，不过本文主要介绍**数据存储到 MongoDB 时如何做到只插入新数据，而重复数据自动过滤不插入。**

先来个简单例子，比如现在有两个 list ，data2 中的第一条数据和 data 列表中的第一条数据是重复的，我们想将这两个 list 依次插入 MnogoDB 中去， 通常我们会使用 insert_one() 或者 insert_many() 方法插入，这里我们使用 insert_one() 插入，看一下效果。

```python
data = [
{'index':'A','name':'James','rank':'1' },
{'index':'B','name':'Wade','rank':'2' },
{'index':'C','name':'Paul','rank':'3' },
]

data2 = [
{'index':'A','name':'James','rank':'1' },
{'index':'D','name':'Anthony','rank':'4' },
]

import pymongo
client = pymongo.MongoClient('localhost',27017)
db = client.Douban
mongo_collection = db.douban

for i in data:
    mongo_collection.insert_one(i)
    
```

插入第一个 list ：

![](http://media.makcyun.top/18-12-19/73105799.jpg)



插入第二个 list ：

![](http://media.makcyun.top/18-12-19/64313840.jpg)

你会发现，重复的数据 A 被插入进去了，那么怎么只插入 D，而不插入 A 呢，这里就要用到 update_one() 方法了，改写一下插入方法：

```python
for i in data2:
    mongo_collection.update_one(i,{'$set':i},upsert=True)
```

![](http://media.makcyun.top/18-12-19/5158090.jpg)

这里用到了 `$set` 运算符，该运算符作用是将字段的值替换为指定的值，upsert 为 True 表示插入。这里也可以用 update() 方法，但是这个方法比较老了，不建议使用。另外尝试使用 update_many() 方法发现不能更新多个相同的值。

```python
for i in data2:
	mongo_collection.update(i, i, upsert=True)
```

下面举一个豆瓣电影 TOP250 的实例，假设我们先获取 10 个电影的信息，然后再获取前 20 个电影，分别用 insert_one() 和 update_one() 方法对比一下结果。

insert_one() 方法会重复爬取 前 10 个电影的数据：

![](http://media.makcyun.top/18-12-19/34180814.jpg)

update_one() 方法则只会插入新的 10 个电影的数据：

![](http://media.makcyun.top/18-12-19/19347856.jpg)

这就很好了对吧，所以当我们去爬那些需要分页的网站，最好在爬取之前使用 update_one() 方法，这样就算爬虫中断了，也不用担心会爬取重复数据。

​			

​			

代码实现如下：

```python
import requests
import json
import csv
import pandas as pd
from urllib.parse import urlencode
import pymongo

client = pymongo.MongoClient('localhost', 27017)
db = client.Douban
mongo_collection = db.douban
class Douban(object):
    def __init__(self):
        self.url = 'https://api.douban.com/v2/movie/top250?'

    def get_content(self, start_page):
        params = {
            'start': start_page,
            'count': 10
        }
        response = requests.get(self.url, params=params).json()
        movies = response['subjects']
        data = [{
            'rating': item['rating']['average'],
            'genres':item['genres'],
            'name':item['title'],
            'actor':self.get_actor(item['casts']),
            'original_title':item['original_title'],
            'year':item['year'],
        } for item in movies]

        self.write_to_mongodb(data)

    def get_actor(self, actors):
        actor = [i['name'] for i in actors]
        return actor

    def write_to_mongodb(self, data):
        for item in data:
            if mongo_collection.update_one(item, {'$set': item}, upsert=True):
                # if mongo_collection.insert_one(item):
                print('存储成功')
            else:
                print('存储失败')

    def get_douban(self, total_movie):
        # 每页10条，start_page循环1次
        for start_page in range(0, total_movie, 10):
            self.get_content(start_page)

if __name__ == '__main__':
    douban = Douban()
    douban.get_douban(10)
```



本文完。

---


推荐阅读：

[从函数 def 到类 Class](https://www.makcyun.top/web_scraping_withpython12.html)

[从 类 Class 到 Scrapy](https://www.makcyun.top/web_scraping_withpython12.html)