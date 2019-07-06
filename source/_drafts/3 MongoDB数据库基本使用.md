---


title: Python爬虫(7)：IT桔子爬取创业公司投融资信息
date: 2018-10-17 16:16:24
id: web_scraping_withpython7
categories: Python爬虫
tags: [Python爬虫,]
images: http://pbscl931v.bkt.clouddn.com/Fnf-VlGgFGAb54iJ6MmH_3rnvPq0
keywords: [IT桔子网爬虫,python爬虫]
---

。

以IT桔子网站，介绍需登录网站的爬取方法，并爬取创业公司投融资信息。

<!-- more -->  

**摘要：** 之前爬的文章都是不需要登录就可以爬取的，但还有很多网站的内容需要登录才能够获取，比如豆瓣、知乎。这时采用之前的方法就不行了，所以需要先登录再爬虫。本文以IT桔子网站为例，介绍模拟登录、爬取内容并保存到MongoDB数据库中。





### 存储到MongoDB

数据爬取下来了，那么我们放到哪里呢？可以选择存储到csv中，但json数据中存在多层嵌套，csv不能够直观展现。这里，我们可以尝试之前没有用过的另一种数据库：MongoDB，当作练习。数据存储到该数据中，后期也可以导出为csv。

关于MongoDB的安装与基本使用，可以参考下面这两篇教程，之后我也会单独写一下：

> 安装
>
> [https://germey.gitbooks.io/python3webspider/content/1.4.2-MongoDB%E7%9A%84%E5%AE%89%E8%A3%85.html](https://germey.gitbooks.io/python3webspider/content/1.4.2-MongoDB%E7%9A%84%E5%AE%89%E8%A3%85.html)
>
> 使用
>
> [https://germey.gitbooks.io/python3webspider/content/5.3.1-MongoDB%E5%AD%98%E5%82%A8.html](https://germey.gitbooks.io/python3webspider/content/5.3.1-MongoDB%E5%AD%98%E5%82%A8.html)
>
> 可视化工具可采用Robo 3T(之前交RoboMongo)
>
> [https://www.mongodb.com/](https://www.mongodb.com/)

下面我们就将上面返回的json数据，存储到MongoDB中去：

```python
import pymongo
import numpy as np
# mongodb数据库初始化
client = pymongo.MongoClient('localhost', 27017)
# 指定数据库
db = client.ITjuzi
# 指定集合，类似于mysql中的表
mongo_collection1 = db.itjuzi_investevent

def save_to_mongo(self, response):
        try:
            data = response['data']['rows']  # dict可以连续选取字典层内的内容
            df = pd.DataFrame(data)
            table = json.loads(df.T.to_json()).values()
            if mongo_collection1.insert_many(table):  # investment
                print('存储到mongodb成功')
                sleep = np.random.randint(3, 7)
            	time.sleep(sleep)
        except Exception:
            print('存储到mongodb失败')
 def spider_itjuzi(self, start_page, end_page):
        for page in range(start_page, end_page):
            print('下载第%s页:' % (page))
            self.get_table(page)
        print('下载完成')
            
if __name__ == '__main__':
    spider = ITjuzi()
    spider.spider_itjuzi(1, 2)

```

这里，安装好MongoingDB数据库、Robo 3T和pymongo库后，我们就可以开始使用了。

首先，对数据库进行初始化，然后指定（如果没有则生成）数据将要存放的数据库和集合名称。接着，定义了**save_to_mongo**函数。由于表格里面的数据存储在键为**rows**的value值中，可使用`response['data']['rows']`来获取到json里面的嵌套数据，然后转为DataFrame。DataFrame存储MongoDB使用了[stackoverflow](https://stackoverflow.com/questions/20167194/insert-a-pandas-dataframe-into-mongodb-using-pymongo)上面的公式：**json.loads(df.T.to_json()).values()**。

然后，使用**mongo_collection1.insert_many(table)**方法将数据插入到mongo_collection1，也就是itjuzi_investevent集合中。爬取完一页数据后，我们设置了随机延时3-6s，避免爬取太频繁，这也能起到一定的反爬作用。

最后，我们定义一个分页循环爬取函数**spider_itjuzi**，利用for循环设置爬取起始页数就可以了，爬取结果如下：

![](http://pbscl931v.bkt.clouddn.com/18-10-18/32245012.jpg)

成功存储到MongoDB中：

![](http://pbscl931v.bkt.clouddn.com/18-10-18/48807142.jpg)

好，以上，我们就基本上完成了2018年投融资信息数据表的爬取，如果你想爬其他年份或者更多页的数据，更改相应的参数即可。





### 导出到CSV

数据存好后，如果还不太熟悉MongoDB的对数据的操作，那么我们可以将数据导出为CSV，在excel中操作。MongoDB不能直接导出CSV，但过程其实很简单，利用`mongoexport`命令，几行代码就可以输出csv文件。

`mongoexport`导出csv的方法：

[https://docs.mongodb.com/manual/reference/program/mongoexport/#mongoexport-fields-example](https://docs.mongodb.com/manual/reference/program/mongoexport/#mongoexport-fields-example)

首先，运行cmd，切换路径到MongoDB安装文件夹中的bin目录下，我这里是：

```python
cd C:\Program Files\MongoDB\Server\4.0\bin
```

接着，在桌面新建一个txt文件，命名为`fields`，在里面输入我们需要输出的表格列名，如下所示：

![](http://pbscl931v.bkt.clouddn.com/Fv3SDvCH-YELedOEbTOWjyIIbzNW)

然后，利用`mongoexport`命令，按照：表格所在的数据库、集合、输出格式、导出列名文件位置和输出文件名的格式，编写好命令并运行就可以导出了：

```python
mongoexport --db ITjuzi --collection itjuzi_investevent --type=csv --fieldFile C:\Users\sony\Desktop\fields.txt --out C:\Users\sony\Desktop\investevent.csv 
```

cmd命令：

![](http://pbscl931v.bkt.clouddn.com/FhWiQ9majkIgqMWDKAnAr-dij5xw)

导出csv结果：
![](http://pbscl931v.bkt.clouddn.com/FhoU_6rggZJ0foJcRnfayTGxS0u4)

*Tips：直接用excel可能会是乱码，需先用Notepad++转换为UTF-8编码，然后excel打开就正常了。*

### 避免插入重复值的方法

```python

import pymongo

client = pymongo.MongoClient('localhost',27017)
db = client.Huxiu
collection = db.test

data = [{'user':'A','title':'Physics','Bank':'Bank_A' },
{'user':'A','title':'Chemistry','Bank':'Bank_B' },
{'user':'B','title':'Chemistry','Bank':'Bank_A' },
{'user':'B','title':'Chemistry','Bank':'Bank_A' },
{'user':'C','title':'Chemistry','Bank':'Bank_A' },
]

for i in data:
    result = collection.insert_one(i)
    result = collection.update_one(i,{'$set':i},upsert=True)

    # collection.createIndex( { 'user': 1, 'title': 1, 'Bank': 1 },unique=True)
    # collection.createIndex( { 'user': 1, 'title': 1, 'Bank': 1 },{unique:true})


# doc = {'user': 'C', 'title': 'Chemistry', 'Bank':'Bank_A' }
# collection.update(doc,doc,upsert=False)
```





本文完。

![](http://pbscl931v.bkt.clouddn.com/%E5%85%AC%E4%BC%97%E5%8F%B7%E5%85%B3%E6%B3%A8.jpg)