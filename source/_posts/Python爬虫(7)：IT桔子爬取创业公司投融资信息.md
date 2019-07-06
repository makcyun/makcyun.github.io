---


title: Python爬虫(7)：IT桔子网，国内创业公司的信息都在这里了
date: 2018-10-17 16:16:24
id: web_scraping_withpython7
categories: Python爬虫
tags: [Python爬虫,MongoDB,模拟登录]
images: http://media.makcyun.top/Fj3MRuSEnuwtTIGCXGEq-fAa73XF
keywords: [IT桔子网爬虫,python爬虫,IT桔子]
---

以 IT 桔子网为例，介绍需登录网站的爬取方法。爬取该网站数据库中的信息：创业公司投融资情况、投资机构信息、独角兽公司。

<!-- more -->  

**摘要：** 之前爬的网站都是不需要登录就可以爬取的，但还有很多网站的内容需要先登录才能爬，比如 IT 桔子、豆瓣、知乎等。这时采用之前的方法就不行了，需要先登录再去爬。本文以 IT 桔子网站为例，介绍模拟登录方法，然后爬取该网站数据库中的数据信息，并保存到 MongoDB 数据库中。

## 1. 网站介绍

网址：[https://www.itjuzi.com/](https://www.itjuzi.com/)

![](http://media.makcyun.top/18-10-17/90303578.jpg)

对于创投圈的人来说，国内的`IT桔子`和国外的 `Crunchbase`应该算是必备网站。今天，我们要说的就是IT桔子，这个网站提供了很多有价值的信息。

信息的价值体现在哪里呢，举个简单的例子。你运营了一个不错的公众号，有着 10 万粉丝群，这时候你想找投资继续做大，但你不知道该到哪里去找投资。这时候你偶然发现了IT桔子，在网站上你看到了同领域的大 V 号信息，他们得到了好几家公司上千万的投资。你看着心生羡慕，也跃跃欲试。于是，你经过综合对比分析，对自己公众号估值 200 万，然后就去找投资大 V 号的那几家公司洽谈。由于目的性明确，准备也充分，你很快就得到了融资。

这个例子中，IT 桔子提供了创业公司（运营公众号也是创业）融资金额和投资机构等相关宝贵的信息。当然，这只是非常小的一点价值，该网站数据库提供了自 2000 年以来的海量数据，包括：超过11 万家的创业公司、6 万多条投融资信息、7 千多家投资机构以及其他数据，可以说是非常全了。这些数据的背后蕴含着大量有价值的信息。

![](http://media.makcyun.top/18-10-20/32908700.jpg)

接下来，本文尝试爬取该网站数据库的信息，之后做一些数据分析，尝试找到一些有意思的信息。

**主要内容：**

- 模拟登录
- 分析 Ajax 然后抓取
- 存储到 MongoDB 数据库
- 导出 csv
- 数据分析(后期)

## 2. 模拟登录

### 2.1. Session 和 Cookies

观察这个网站，是需要先登录才能看到数据信息的，但是好在不用输验证码。我们需要利用账号和密码，然后实现模拟登录。

![](http://media.makcyun.top/18-10-17/98135777.jpg)

模拟登录的方法有好几种，比如 Post 直接提交账号、先登录获取 Cookies 再直接请求、Selenium 模拟登录等。其中：

- Post 方法需要在后台获取登录的 url，填写表单参数然后再请求，比较麻烦；

- 直接复制 Cookies 的方法就是先登录账号，复制出 Cookies 并添加到 Headers 中，再用 **requests.get** 方法提交请求，这种方法最为方便；

- Selenium 模拟登录方法是直接输入账号、密码，也比较方便，但速度会有点慢。

之后，会单独介绍几种方法的具体实现的步骤。这里，我们就先采用第二种方法。

首先，需要先了解两个知识点：Session 和 Cookies。

> Session 在服务端，也就是网站的服务器，用来保存用户的会话信息，Cookies 在客户端，也可以理解为浏览器端，有了 Cookies，浏览器在下次访问网页时会自动附带上它发送给服务器，服务器通过识别 Cookies 并鉴定出是哪个用户，然后再判断用户是否是登录状态，然后返回对应的 Response。所以我们可以理解为 Cookies 里面保存了登录的凭证，有了它我们只需要在下次请求携带 Cookies 发送 Request 而不必重新输入用户名、密码等信息重新登录了。
> 因此在爬虫中，有时候处理需要登录才能访问的页面时，我们一般会直接将登录成功后获取的 Cookies 放在 Request Headers 里面直接请求。

更多知识，可以参考崔庆才大神的文章：

[https://germey.gitbooks.io/python3webspider/content/2.4-Session%E5%92%8CCookies.html](https://germey.gitbooks.io/python3webspider/content/2.4-Session%E5%92%8CCookies.html)

在了解 Cookies 知识后，我们就可以进入正题了。

### 2.2. Requests 请求登录

首先，利用已有的账号和密码，登录进网站主页，然后右键-检查，打开第一个 `www.itjuzi.com` 请求：

![](http://media.makcyun.top/18-10-18/84996738.jpg)

向下拉到 Requests Headers 选项，可以看到有很多字段信息，这些信息之后我们都要添加到 Get 请求中去。

定位到下方的 Cookie 字段，可以看到有很多 Cookie 值和名称，这是在登录后自动产生的。我们将整个 Cookies 复制 Request Headers 里，然后请求网页就可以顺利登陆然后爬取。如果不加 Cookies，那么就卡在登录界面，也就无法进行后面的爬取，所以 Cookies 很重要，需要把它放到 Request Headers 里去。

下面，我们按照 json 格式开始构造 Request Headers。这里推荐一个好用的网站，可以帮我们自动构造 Request Headers：[https://curl.trillworks.com/](https://curl.trillworks.com/)

![](http://media.makcyun.top/18-10-18/58555393.jpg)

使用方法也很简单，右键复制`cURL链接`到这个网页中。

![](http://media.makcyun.top/18-10-19/77493357.jpg)

将 cURL 复制到左边选框，默认选择语言为 Python，然后右侧就会自动构造后 requests 请求，包括 headers，复制下来直接可以用。登录好以后，我们就转到投融资速递网页中（url：[http://radar.itjuzi.com/investevent](http://radar.itjuzi.com/investevent)），然后就可以获取该页面网页内容了。代码如下：

```python
import requests
headers = {
    'Connection': 'keep-alive',
    'Cache-Control': 'max-age=0',
    'Upgrade-Insecure-Requests': '1',
    'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
    'DNT': '1',
    'Referer': 'http://radar.itjuzi.com/investevent',
    'Accept-Encoding': 'gzip, deflate, br',
    'Accept-Language': 'zh-CN,zh;q=0.9,en;q=0.8,zh-TW;q=0.7',
    'If-None-Match': 'W/^\\^5bc7df15-19cdc^\\^',
    'If-Modified-Since': 'Thu, 18 Oct 2018 01:17:09 GMT',
    # 主页cookie
    'Cookie': '你的cookie',
    }

url = 'http://radar.itjuzi.com/investevent'   # 投融资信息
s = requests.Session()
response = s.get(url,headers = headers)
print(response.status_code)
print(response.text)
```

![](http://media.makcyun.top/18-10-18/21995265.jpg)

可以看到，添加 Cookie 后，我们请求投融资信息网页就成功了。这里如果不加 Cookie 的结果就什么也得不到：

![](http://media.makcyun.top/18-10-18/26869412.jpg)

好，这样就算成功登录了。但是整个 headers 请求头的参数太多，是否一定需要带这么多参数呢？ 这里就去尝试看哪些参数是请求一定要的，哪些则是不用的，不用的可以去掉以精简代码。经过尝试，仅需要下面三个参数就能请求成功。


```python
headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36'
    'X-Requested-With': 'XMLHttpRequest',
    # 主页cookie
    'Cookie': '复制你的cookie',
    }
```

> Tips：爬取失效的时候需要重新注册帐号，然后生成新的 Cookie
>
> 如果你没那么多邮箱账号，那么推荐一个可生成随机账号的免费邮箱，用来接收注册激活链接：
>
> [https://10minutemail.net/](https://10minutemail.net/)

## 3. 网页爬取分析

在成功登录以后，我们就可以通过分析网页结构来采取相应的爬取方法。这里，我们将爬取投融资速递、创业公司、投资机构和千里马等几个子板块的数据。首先，以投融资速递信息为例。

网址：[http://radar.itjuzi.com/investevent](http://radar.itjuzi.com/investevent)

### 3.1. 分析网页

![](http://media.makcyun.top/18-10-18/54988425.jpg)

可以看到，投融资事件信息网页中的数据是表格形式。经尝试点击翻页，发现url不变，可以初步判定网页数据采用 Ajax 形式呈现。切换到后台，点击翻页可以发现出现有规律的 `info?locatiop 开头的请求`，页数随 page 参数而发生规律的变化。

![](http://media.makcyun.top/18-10-18/23929665.jpg)

点击请求查分别查看 Response 和 Preview，发现表格数据是 json 格式，这就太好了。因为 json 格式的数据非常整齐也很容易抓取。上一篇文章，我们正好解决了 json 格式数据的处理方法，如果不太熟悉可以回顾一下：

[https://www.makcyun.top/web_scraping_withpython6.html](https://www.makcyun.top/web_scraping_withpython6.html)

接着，我们就可以通过构造 url 参数，然后用 Get 请求就可以获取网页中的表格数据，最后再加个循环，就可以爬取多页数据了。

### 3.2. 构造 url

下面，我们来构造一下 url，切换到 Headers 选项卡，拉到最底部可以看到 url 需带的请求参数。这里有三项，很好理解。location：in，表示国内数据； orderby：def，表示默认排序；page：1，表示第一页。所以，只需要改变 page 参数就可以查看其他页的结果，非常简单。

![](http://media.makcyun.top/18-10-18/23739456.jpg)

这里，如果我们对表格进行筛选，比如行业选择教育、时间选择 2018 年，那么相应的请求参数也会增加。通过构造参数就可以爬取指定的数据，这样就不用全部爬下来了，也对网站友好点。

![](http://media.makcyun.top/18-10-18/96770843.jpg)

### 3.3. 爬取数据

到这儿，我们就可以直接开始爬了。可以使用函数，也可以用定义类（Class）的方法。考虑到，Python 是一种面向对象的编程，类（Class）是面向对象最重要的概念之一，运用类的思想编程非常重要。所以，这里我们尝试采用类的方法来实现爬虫。

```python
import requests
import pymongo
import random
import time
import json
import pandas as pd
from fake_useragent import UserAgent
ua = UserAgent()

class ITjuzi(object):
    def __init__(self):
        self.headers = {
            'User-Agent': ua.random,
            'X-Requested-With': 'XMLHttpRequest',
            'Cookie': '你的cookie',
        }
        self.url = 'http://radar.itjuzi.com/investevent/info?'    # investevent
        self.session = requests.Session()
        
    def get_table(self, page):
        """
        1 获取投融资事件数据
        """
        params = {                # invsestevent
            'location': 'in',
            'orderby': 'def',
            'page': page,
            'date': 2018  # 年份
        }
        response = self.session.get(
            self.url, params=params, headers=self.headers).json()
        print(response)
        # self.save_to_mongo(response)

if __name__ == '__main__':
    spider = itjuzi()
    spider.get_table(1)
```

如果你之前一直是用 Def 函数的写法，而没有接触过 Class 类的写法，可能会看地比较别扭，我之前就是这样的，搞不懂`为什么要有 self`、`为什么用__init__`。这种思维的转变可以通过看教程和别人写的实际案例去揣摩。这里，我先略过，之后会单独介绍。

简单解释一下上面代码的意思。首先定义了一个类（class），类名是 **ITjuzi**，类名通常是大写开头的单词。后面的 **(object)**  表示该类是从哪个类继承下来的，这个可以暂时不用管，填上就可以。然后定义了一个特殊的`__init__`方法，`__init__`方法的第一个参数永远是 `self`，之后是其他想要设置的属性参数。在这个方法里可以绑定些确定而且必须的属性，比如 headers、url 等。

在 headers 里面，User-Agent 没有使用固定的 UA，而是借助 `fake_useragent包` 生成随机的 UA：`ua.random`。因为，这个网站做了一定的反爬措施，这样可以起到一定的反爬效果，后续我们会再说到。接着，定义了一个 get_table() 函数，这个函数和普通函数没有什么区别，除了第一个参数永远是实例变量 `self`。在 session.get（）方法中传入 url、请求参数和 headers，请求网页并指定获取的数据类型为 json 格式，然后就可以顺利输出 2018 年投融资信息的第 1 页数据：

![](http://media.makcyun.top/18-10-18/606314.jpg)

### 3.4. 存储到 MongoDB

数据爬取下来了，那么我们放到哪里呢？可以选择存储到 csv 中，但 json 数据中存在多层嵌套，csv 不能够直观展现。这里，我们可以尝试之前没有用过的 MongoDB 数据库，当作练习。另外，数据存储到该数据库中，后期也可以导出 csv，一举两得。

关于 MongoDB 的安装与基本使用，可以参考下面这两篇教程，之后我也会单独再写一下：

> 安装
>
> [https://germey.gitbooks.io/python3webspider/content/1.4.2-MongoDB%E7%9A%84%E5%AE%89%E8%A3%85.html](https://germey.gitbooks.io/python3webspider/content/1.4.2-MongoDB%E7%9A%84%E5%AE%89%E8%A3%85.html)
>
> 使用
>
> [https://germey.gitbooks.io/python3webspider/content/5.3.1-MongoDB%E5%AD%98%E5%82%A8.html](https://germey.gitbooks.io/python3webspider/content/5.3.1-MongoDB%E5%AD%98%E5%82%A8.html)
>
> 可视化工具可采用 Robo 3T (之前叫 RoboMongo)
>
> [https://www.mongodb.com/](https://www.mongodb.com/)

下面我们就将上面返回的 json 数据，存储到 MongoDB 中去：

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

这里，安装好 MongoingDB 数据库、Robo 3T 和 pymongo 库后，我们就可以开始使用了。

首先，对数据库进行初始化，然后指定（如果没有则生成）数据将要存放的数据库和集合名称。接着，定义了**save_to_mongo **函数。由于表格里面的数据存储在键为 **rows** 的 value 值中，可使用 `response['data']['rows']` 来获取到 json 里面的嵌套数据，然后转为 DataFrame。DataFrame 存储 MongoDB 参考了 [stackoverflow](https://stackoverflow.com/questions/20167194/insert-a-pandas-dataframe-into-mongodb-using-pymongo) 上面的一个回答：**json.loads(df.T.to_json()).values()**。

然后，使用 **mongo_collection1.insert_many(table)** 方法将数据插入到 mongo_collection1，也就是 itjuzi_investevent 集合中。爬取完一页数据后，设置随机延时 3-6 s，避免爬取太频繁，这也能起到一定的反爬作用。

最后，我们定义一个分页循环爬取函数 **spider_itjuzi**，利用 for 循环设置爬取起始页数就可以了，爬取结果如下：

![](http://media.makcyun.top/18-10-18/32245012.jpg)

打开 Robo 3T，可以看到数据成功存储到 MongoDB 中了：

![](http://media.makcyun.top/18-10-18/48807142.jpg)

好，以上，我们就基本上完成了 2018 年投融资信息数据表的爬取，如果你想爬其他年份或者更多页的数据，更改相应的参数即可。

### 3.5. 导出到 csv

数据存好后，如果还不太熟悉 MongoDB 的对数据的操作，那么我们可以将数据导出为 csv，在 excel 中操作。MongoDB不能直接导出 csv，但操作起来也不麻烦，利用`mongoexport`命令，几行代码就可以输出 csv。

`mongoexport`导出 csv 的方法：

[https://docs.mongodb.com/manual/reference/program/mongoexport/#mongoexport-fields-example](https://docs.mongodb.com/manual/reference/program/mongoexport/#mongoexport-fields-example)

首先，运行 cmd，切换路径到 MongoDB 安装文件夹中的 bin 目录下，我这里是：

```python
cd C:\Program Files\MongoDB\Server\4.0\bin
```

接着，在桌面新建一个txt文件，命名为`fields`，在里面输入我们需要输出的表格列名，如下所示：

![](http://media.makcyun.top/Fv3SDvCH-YELedOEbTOWjyIIbzNW)

然后，利用`mongoexport`命令，按照：表格所在的数据库、集合、输出格式、导出列名文件位置和输出文件名的格式，编写好命令并运行就可以导出了：

```python
mongoexport --db ITjuzi --collection itjuzi_investevent --type=csv --fieldFile C:\Users\sony\Desktop\fields.txt --out C:\Users\sony\Desktop\investevent.csv 
```

cmd 命令：

![](http://media.makcyun.top/FhWiQ9majkIgqMWDKAnAr-dij5xw)

导出 csv 结果如下：
![](http://media.makcyun.top/FhoU_6rggZJ0foJcRnfayTGxS0u4)

**Tips：直接用 excel 打开可能会是乱码，需先用 Notepad++ 转换为 UTF-8 编码，然后 excel 再打开就正常了。**

以上，我们就完成了整个数据表的爬取。

### 3.6. 完整代码

下面，可以再尝试爬取创业公司、投资机构和千里马的数据。他们的数据结构形式是一样的，只需要更换相应的参数就可以了，感兴趣的话可以尝试下。将上面的代码再稍微整理一下，完整代码如下：

```python
import requests
import re
import pymongo
import random
import time
import json
import random
import numpy as np
import csv
import pandas as pd
from fake_useragent import UserAgent
import socket  # 断线重试
from urllib.parse import urlencode
# 随机ua
ua = UserAgent()
# mongodb数据库初始化
client = pymongo.MongoClient('localhost', 27017)
# 获得数据库
db = client.ITjuzi
# 获得集合
mongo_collection1 = db.itjuzi_investevent
mongo_collection2 = db.itjuzi_company
mongo_collection3 = db.itjuzi_investment
mongo_collection4 = db.itjuzi_horse

class itjuzi(object):
    def __init__(self):

        self.headers = {
            'User-Agent': ua.random,
            'X-Requested-With': 'XMLHttpRequest',
            # 主页cookie
            'Cookie': '你的cookie',
        }
        self.url = 'http://radar.itjuzi.com/investevent/info?'    # investevent
        # self.url = 'http://radar.itjuzi.com/company/infonew?'       # company
        # self.url = 'http://radar.itjuzi.com/investment/info?'       # investment
        # self.url = 'https://www.itjuzi.com/horse'               # horse
        self.session = requests.Session()

    def get_table(self, page):
        """
        1 获取投融资事件网页内容
        """
        params = {                # 1 invsestevent
        'location': 'in',
        'orderby': 'def',
        'page': page,
        'date':2018  #年份  
        }

        # # # # # # # # # # # # # # # # # # # # # # # # # ## # # # # # # # # # # #
        # params = {                  # 2 company
        #     'page': page,
        #     # 'scope[]': 1,  # 行业 1教育
        #     'orderby': 'pv',
        #     'born_year[]': 2018,  # 只能单年，不能多年筛选，会保留最后一个
        # }
        # # # # # # # # # # # # # # # # # # # # # # # # # ## # # # # # # # # # # #
        # params = {                  # 3 investment
        # 'orderby': 'num',
        # 'page': page
        # }
        # # # # # # # # # # # # # # # # # # # # # # # # # ## # # # # # # # # # # #
        # params = {                  # 4 horse
        # }
        # 可能会遇到请求失败，则设置3次重新请求
        retrytimes = 3
        while retrytimes:
            try:
                response = self.session.get(
                    self.url, params=params, headers=self.headers,timeout = (5,20)).json()
                self.save_to_mongo(response)
                break
            except socket.timeout:
                print('下载第{}页，第{}次网页请求超时' .format(page,retrytimes))
                retrytimes -=1

    def save_to_mongo(self, response):
        try:
            data = response['data']['rows']  # dict可以连续选取字典层内的内容
            # data =response  # 爬取千里马时需替换为此data
            df = pd.DataFrame(data)
            table = json.loads(df.T.to_json()).values()
            if mongo_collection1.insert_many(table):      # investevent
            # if mongo_collection2.insert_many(table):    # company
            # if mongo_collection3.insert_many(table):    # investment
            # if mongo_collection4.insert_many(table):    # horse 
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
    spider = itjuzi()
    spider.spider_itjuzi(1, 2)   
```

源代码也可以在公众号后台回复：「**it桔子**」，或者在下面的链接中获取：

[https://github.com/makcyun/web_scraping_with_python](https://github.com/makcyun/web_scraping_with_python)

后续文章，我们将对这些数据进行分析，尝试从中找出一些有意思的发现。

## 4. 总结：

- 本文以 IT 桔子网为例，介绍了需登录网站的爬取方法。即：先模拟登录再爬取数据信息。但是还有一些网站登录时需要输入验证码，这让爬取难度又增加，后期会再进行介绍。
- IT 桔子相比之前的爬虫网站，反爬措施高了很多。本文通过设置随机延时、随机 UserAgent，可一定程度上增加爬虫的稳定性。但是仍然会受到反爬措施的限制，后期可尝试通过设置 IP 代理池进一步提升爬虫效率。
- 上面的爬虫程序在爬取过程容易中断，接着再进行爬取即可。但是手动修改非常不方便，也容易造成数据重复爬取或者漏爬。所以，为了更完整地爬取，需增加断点续传的功能。



本文完。

![](http://media.makcyun.top/%E5%85%AC%E4%BC%97%E5%8F%B7%E5%85%B3%E6%B3%A8.jpg)

<center>欢迎扫一扫关注我的微信公众号</center>

