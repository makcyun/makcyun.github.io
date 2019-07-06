---


title: Python爬虫(9)：利用网站提供的 API 进行爬取
date: 2018-10-20 16:16:24
id: web_scraping_withpython8
categories: Python爬虫
tags: [Python爬虫,模拟登录]
images: http://pbscl931v.bkt.clouddn.com/18-10-24/82009803.jpg
keywords: [python模拟登录,python爬虫]
---

利用网站提供的 API 进行爬虫，是最省心省力的爬虫方法。

<!-- more -->  

**摘要：** 

数据爬虫主要有两种方式

- 通过网站提供的 API 进行爬取。
   这是最为简单直接的方式，例如豆瓣网提供了对于电影、书籍等资源的各种数据的API，我们可以通过调用API来得到所需的数据。通过API的缺点是有些网站会限制API调用的次数和频率，用户需要付费来升级成高级用户来获取更灵活的API调用。
- 基于HTML的数据抓取。这个方法比较麻烦，优点就是不受API的调用限制。通过访问网页的HTML代码，并从中抓取到所需节点上的数据。这个方法还有一个缺点就是，网页一旦发生一点小小的结构变化，抓取代码就有可能需要重写。

作者：刘刻

链接：https://www.jianshu.com/p/98f165a32318

來源：简书

简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。































## 总结：

- 建议优先选择先获取cookies再请求的方法
- 这里模拟登录的网站，没有输入验证码。但是还有很多网站还需要输入验证码才能登录，后续将介绍验证码的处理方法。

参考：

> [http://docs.python-requests.org/zh_CN/latest/user/advanced.html](http://docs.python-requests.org/zh_CN/latest/user/advanced.html)

本文完。

![](http://pbscl931v.bkt.clouddn.com/%E5%85%AC%E4%BC%97%E5%8F%B7%E5%85%B3%E6%B3%A8.jpg)

<center>欢迎扫一扫识别关注我的公众号</center>

