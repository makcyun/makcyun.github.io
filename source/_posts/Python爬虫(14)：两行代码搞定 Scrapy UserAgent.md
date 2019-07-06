---
title: Scrapy 中设置随机 User-Agent 的方法汇总
date: 2018-12-21 16:16:24
id: web_scraping_withpython14
categories: Python爬虫
tags: [Python爬虫]
images: http://media.makcyun.top/18-12-21/56146999.jpg
keywords: [Scrapy UA,随机UserAgent]
---

一行代码搞定 Scrapy 中的随机 UA 设置。

<!-- more -->  

**摘要：**爬虫过程中的反爬措施非常重要，其中设置随机 User-Agent 是一项重要的反爬措施，Scrapy 中设置随机 UA 的方式有很多种，有的复杂有的简单，本文就对这些方法进行汇总，提供一种只需要一行代码的设置方式。

最近使用 Scrapy 爬一个网站，遇到了网站反爬的情况，于是开始搜索一些反爬措施，了解到设置随机 UA 来伪装请求头是一种常用的方式，这能够做到一定程度上避免网站直接识别出你是一个爬虫从而封掉你。设置随机 UA 的方法有挺多种，有的需要好多行代码，有的却只需要一行代码就搞定了，接下来就来介绍下。

### ▌常规设置 UA

首先，说一下常规情况不使用 Scrapy 时的用法，比较方便的方法是利用 `fake_useragent`包，这个包内置大量的 UA 可以随机替换，这比自己去搜集罗列要方便很多，下面来看一下如何操作。

首先，安装好`fake_useragent`包，一行代码搞定：

```python
pip install fake-useragent
```

然后，就可以测试了：

```python
from fake_useragent import UserAgent
ua = UserAgent()
for i in range(10):
    print(ua.random)
```

这里，使用了 ua.random 方法，可以随机生成各种浏览器的 UA，见下图：

![](http://media.makcyun.top/18-12-21/34714572.jpg)

如果只想要某一个浏览器的，比如 Chrome ，那可以改成 `ua.chrome`，再次生成随机 UA 查看一下：

![](http://media.makcyun.top/18-12-21/15257325.jpg)

以上就是常规设置随机 UA 的一种方法，非常方便。



下面，我们来介绍在 Scrapy 中设置随机 UA 的几种方法。

先新建一个 Project，命名为 `wanojia`，测试的网站选择为：`http://httpbin.org/get`。

首先，我们来看一下，如果不添加 UA 会得到什么结果，可以看到显示了`scrapy`，这样就暴露了我们的爬虫，很容易被封。

![](http://media.makcyun.top/18-12-21/68168721.jpg)

下面，我们添加上 UA 。

### ▌直接设置 UA

![](http://media.makcyun.top/18-12-21/3222551.jpg)

第一种方法是和上面程序一样，直接在主程序中设置 UA，然后运行程序，通过下面这句命令可以输出该网站的 UA，见上图箭头处所示，每次请求都会随机生成 UA，这种方法比较简单，但是每个 requests 下的请求都需要设置，不是很方便，既然使用了 Scrapy，它提供了专门设置 UA 的地方，所以接下来我们看一下如何单独设置 UA。

```python
response.request.headers['User-Agent']
```

### ▌手动添加 UA

![](http://media.makcyun.top/18-12-21/52073035.jpg)

第二种方法，是在 settings.py 文件中手动添加一些 UA，然后通过 `random.choise` 方法随机调用，即可生成 UA，这种方便比较麻烦的就是需要自己去找 UA，而且增加了代码行数量。

### ▌middlewares.py 中设置 UA

第三种方法，是使用 fake-useragent 包，在 middlewares.py 中间件中改写 process_request() 方法，添加以下几行代码即可。

```python
from fake_useragent import UserAgent
class RandomUserAgent(object):
    def process_request(self, request, spider):
        ua = UserAgent()
        request.headers['User-Agent'] = ua.random
```

然后，我们回到 `settings.py` 文件中调用自定义的 UserAgent，注意这里要先关闭默认的 UA 设置方法才行。

```python
DOWNLOADER_MIDDLEWARES = {
    'scrapy.downloadermiddlewares.useragent.UserAgentMiddleware': None, 
    'wandoujia.middlewares.RandomUserAgent': 543,
}
```

可以看到，我们成功得到了随机 UA。

![](http://media.makcyun.top/18-12-21/43758922.jpg)



### ▌一行代码设置 UA

可以看到，上面几种方法其实都不太方便，代码量也比较多，有没有更简单的设置方法呢？

有的，**只需要一行代码就搞定，利用一款名为  `scrapy-fake-useragent ` 的包。**

先贴一下该包的官方网址：[https://pypi.org/project/scrapy-fake-useragent/](https://pypi.org/project/scrapy-fake-useragent/)，使用方法非常简单，安装好然后使用就行了。

执行下面的命令进行安装，然后在 settings.py 中启用随机 UA 设置命令就可以了，非常简单省事。

```python
pip install scrapy-fake-useragent
```

```python
DOWNLOADER_MIDDLEWARES = {
    'scrapy.downloadermiddlewares.useragent.UserAgentMiddleware': None, # 关闭默认方法
    'scrapy_fake_useragent.middleware.RandomUserAgentMiddleware': 400, # 开启
}
```

我们输出一下 UA 和网页 Response，可以看到成功输出了结果。

![](http://media.makcyun.top/18-12-21/60286497.jpg)



以上就是 Scrapy 中设置随机 UA 的几种方法，推荐最后一种方法，即安装 `scrapy-fake-useragent` 库，然后在 settings 中添加下面这一行代码即可：

```python
'scrapy_fake_useragent.middleware.RandomUserAgentMiddleware': 400,
```

另外，反爬措施除了设置随机 UA 以外，还有一种非常重要的措施是设置随机 IP，我们后续再进行介绍。

本文完。

---

推荐阅读：

[爬虫断了？一招搞定 MongoDB 重复数据](https://www.makcyun.top/web_scraping_withpython13.html)

[从函数 def 到类 Class](https://www.makcyun.top/web_scraping_withpython12.html)

[从 类 Class 到 Scrapy](https://www.makcyun.top/web_scraping_withpython12.html)