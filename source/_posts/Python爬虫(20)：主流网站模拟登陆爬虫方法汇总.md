---
title: 主流网站 Python 爬虫模拟登陆方法汇总 
date: 2019-3-19 16:16:16
id: web_scraping_withpython21
categories: Python爬虫
tags: [Python爬虫]
images: http://media.makcyun.top/win/20190319/CALOE89VgtJR.jpg?imageslim
keywords: [Python爬虫]
---

微信、知乎、新浪、京东、淘宝等大型网站的模拟登陆方法。

<!-- more -->  

摘要：介绍微信、知乎、新浪等一众主流网站的模拟登陆爬取方法。

网络上有形形色色的网站，不同类型的网站爬虫策略不同，难易程度也不一样。从是否需要登陆来说，一些简单网站不需要登陆就可以爬，比如之前爬过的猫眼电影、东方财富网等。有一些网站需要先登陆才能爬，比如知乎、微信等。这类网站在模拟登陆时需要处理验证码、js 加密参数这些问题，爬取难度会大很多。费很大力气登陆进去后才能爬取想要的内容，很花时间。

是不是一定要自己动手去实现每一个网站的模拟登陆方法呢，从效率上来讲，其实大可不必，已经有前人替我们造好轮子了。

最近发现一个神库，汇总了数十个主流网站的模拟登陆方法：

-   [知乎](http://zhihu.com/)
-   [微信网页版登录并获取好友列表](https://wx.qq.com/)
-   [Bilibili](https://www.bilibili.com/)
-   [Facebook](https://www.facebook.com/)
-   [无需身份验证即可抓取Twitter前端API](https://twitter.com/)
-   [微博网页版](http://weibo.com/)
-   [QQZone](https://qzone.qq.com/)
-   [CSDN](https://www.csdn.net/)
-   [淘宝](https://github.com/CriseLYJ/awesome-python-login-model/blob/master/www.taobao.com)
-   [Baidu](https://github.com/CriseLYJ/awesome-python-login-model/blob/master/www.baidu.com)
-   [果壳](https://www.guokr.com/)
-   [JingDong 模拟登录](https://www.jd.com/)
-   [163mail](https://mail.163.com/)
-   [拉钩](https://www.lagou.com/)
-   [豆瓣](https://www.douban.com/)
-   [Baidu2](https://github.com/CriseLYJ/awesome-python-login-model/blob/master/www.baidu.com)
-   [猎聘网](https://www.liepin.com/)
-   [Github](https://github.com/)
-   [爬取图虫相应的图片](https://tuchong.com/)
-   [网易云音乐](https://music.163.com/)
-   [糗事百科](https://www.qiushibaike.com/)

这些网站基本采用是直接登录或者使用 selenium+webdriver 的方式。每一个网站都有完整的模拟登陆代码，拿来就可以用到自己的爬虫中。

下面我们来测试一下。

先说说很难爬的「知乎」，假如我们想爬取知乎主页的 HTML 内容，就必须要先登陆才能爬，不然看不到这个界面。下面来简单梳理一下流程。

![](http://media.makcyun.top/FtpqTJuPqtURAgdSwt2ent2AOH7V)

![](http://media.makcyun.top/FkqvSBeRrlq04E4g5I_cbzbp8sBS)

知乎需要手机号才能注册登陆。为了方便测试，可以随便找个手机号，手机号到哪儿去找呢，我上周写的那篇文章就发挥作用了。文章里介绍了一个免费电话号码网站，用上面的手机号可以成功注册。

文章传送门：[两个神网站保护你的隐私](https://mp.weixin.qq.com/s?__biz=MzA5NDk4NDcwMw==&mid=2651386828&idx=1&sn=b33210dde8e0eea6d06932c0ab70b299&chksm=8bba135cbccd9a4acdd08a4af2536e6dc311ea2bd1845f8c8df9a6fd943aee7f4b7e7dabce4b&token=258555898&lang=zh_CN#rd)

![](http://media.makcyun.top/Fh_rim4X-hVVpqOcUDt3lJ0BdKwn)

![](http://media.makcyun.top/FpF3VQg-CG-cg7J45uHmH0uPN5hJ)

顺利登录后就可以进入主页了。

下面，我们用这个库提供的代码来模拟登陆，输出主页 HTML 内容作测试。操作很简单，只需要输入手机号、密码和验证码就可以了。

![](https://i.loli.net/2019/03/19/5c9095ba5cc7f.gif)

成功登陆后，接下来就可以做一些有意思的事了。比如曾有人爬取所有知乎账号的信息，分析了知乎用户群体画像。

是不是有点意思。

再来看看微信。用上面的微信代码可以把全部微信好友信息爬取下来，比如：昵称、性别、地域、个性签名。接着可以分析一下你的朋友圈是什么样的，应该会很有趣。

![](https://i.loli.net/2019/03/19/5c909c202df83.gif)

还可以爬 B 站：

![img](https://github.com/CriseLYJ/awesome-python-login-model/raw/master/images/bilibili.gif)

还可以爬链家租房信息：

![img](https://github.com/CriseLYJ/awesome-python-login-model/raw/master/images/lianjia.gif)



还有很多实用有趣的内容，就不一一罗列了，感兴趣的话可以试试，最后放上 GitHub 库地址：

[https://github.com/CriseLYJ/awesome-python-login-model](https://github.com/CriseLYJ/awesome-python-login-model)

不要闷头造轮子，多抬抬头会发现你在做/想做的东西，别人早已经弄好了，拿来用或者参考学习都是件好事。

本文完。