---
title: Python爬虫(4)：图片批量下载-以澎湃网信息图为例
images: http://media.makcyun.top/18-9-3/29386748.jpg
date: {{ date }}
id: web_scraping_withpython4
categories: Python爬虫
tags: [Python爬虫,Ajax,图片下载]
keywords:
---

澎湃网文章的质量不错，它的"美数课"栏目的信息图做得也很好。图片干货多还能带来ppt和图表制作的技巧。为了更方便浏览所有文章图片，通过分析Ajax爬取栏目至今所有信息图的图片。

<!-- more -->  

**摘要：** 上一篇文章介绍了单页图片的爬取，但是当爬取多页时，难度会增加。同时，前几篇爬虫文章中的网站有一个明显的特点是：可以通过点击鼠标实现网页的翻页，并且url会发生相应的变化。除了此类网站以外，还有一类非常常见的网站特点是：没有"下一页"这样的按钮，而是"加载更多"或者会不断自动刷新从而呈现出更多的内容，同时网页url也不发生变化。这种类型的网页通常采用的是Ajax技术，要抓取其中的网页内容需要采取一定的技巧。本文以信息图做得非常棒的澎湃"美数课"为例，抓取该栏目至今所有文章的图片。  
栏目网址：[https://www.thepaper.cn/list_25635](https://www.thepaper.cn/list_25635)

![](http://media.makcyun.top/18-9-2/30853746.jpg)
![](http://media.makcyun.top/18-9-2/51553778.jpg)

**本文知识点：**  
- Ajax知识
- 多页图片爬取

## 1. Ajax知识 ##
在该主页上尝试不断下拉，会发现网页不断地加载出新的文章内容来，而并不需要通过点击"下一页"来实现，而且网址url也保持不变。也就是说在同一个网页中通过下拉源源不断地刷新出了网页内容。这种形式的网页在今天非常常见，它们普遍是采用了**Ajax**技术。   
> Ajax 全称是 Asynchronous JavaScript and XML（异步 JavaScript 和 XML）。
> 它不是一门编程语言，而是利用 JavaScript 在保证页面不被刷新、页面链接不改变的情况下与服务器交换数据并更新部分网页的技术。

Ajax更多参考：  
[https://germey.gitbooks.io/python3webspider/content/6.2-Ajax%E5%88%86%E6%9E%90%E6%96%B9%E6%B3%95.html](https://germey.gitbooks.io/python3webspider/content/6.2-Ajax%E5%88%86%E6%9E%90%E6%96%B9%E6%B3%95.html)

采用了Ajax的网页和普通的网页有一定的区别，普通网页的爬虫代码放在这种类型的网页上就行不通了，必须另辟出路。下面我们就来尝试一下如何爬取网易"数读"所有的文章。 


主页`右键-检查`，然后按`f5`刷新，会弹出很多链接文件。鼠标上拉回到第一个文件：**list_25635**，在右侧按`ctrl+f`搜索一下第一篇文章的标题："娃娃机生意经"，可以看到在html网页中找到了对应的源代码。

![](http://media.makcyun.top/18-9-2/67533549.jpg)

接着，我们拖动下拉鼠标，显示出更多文章。然后再次搜索一篇文章的标题："金砖峰会"，会发现搜不到相应的内容了。是不是感觉很奇怪？

![](http://media.makcyun.top/18-9-2/72910700.jpg)

其实，这里就是用了Ajax的技术，和普通网页翻页是刷新整个网页不同，这种类型网页可以再保持url不变的前提下只刷新部分内容。这就为我们进行爬虫带来了麻烦。因为，我们通过解析网页的url：`https://www.thepaper.cn/list_25635`只能爬取前面部分的内容而后面通过下拉刷新出来的内容是爬取不到的。这显然不完美，那么怎么才能够爬取到后面不断刷新出来的网页内容呢？   

## 2. url分析 ##
我们把右侧的选项卡从`ALL`切换到`Network`，然后按再次按`f5`刷新，可以发现`Name`列有4个结果。选择第3个链接打开并点击`Response`，通过滑动可以看到一些文本内容和网页中的文章标题是一一对应的。比如第一个是：**娃娃机生意经｜有没有好奇过抓娃娃机怎么又重新火起来了？**，一直往下拖拽可以看到有很多篇文章。此时，再切换到headers选项卡，复制`Request URL`后面的链接并打开，会显示一部分文章的标题和图片内容。数一下的话，可以发现一共有20个文章标题，也就是对应着20篇文章。  

这个链接其实和上面的**list_25635**链接的内容是一致的。这样看来，好像发现不了什么东西，不过不要着急。
![](http://media.makcyun.top/18-9-2/40705043.jpg)
![](http://media.makcyun.top/18-9-2/642179.jpg)


接下来，回到`Name`列，尝试滚动下拉鼠标，会发现弹出好几个新的开头为`load_index`的链接来。选中第一个`load_index`的链接，点击`Response`查看一下html源代码，尝试在网页中搜索一下：`十年金砖峰`这个文章的标题，惊奇地发现，在网页中找到了对于的文章标题。而前面，我们搜索这个词时，是没有搜索到的。
![](http://media.makcyun.top/18-9-2/83879931.jpg)

这说明了什么呢？说明`十年金砖峰`这篇文章的内容不在第一个**list_25635**链接中，而在这个`load_index`的链接里。鼠标点击`headers`，复制`Request URL`后面的链接并打开，就可以再次看到包括这篇文章在内的新的20篇文章。

![](http://media.makcyun.top/18-9-2/4302921.jpg)

是不是发现了点了什么？接着，我们继续下拉，会发现弹出更多的`load_index`的链接。再搜索一个标题：`地图湃｜海外港口热`，可以发现在网页中也同样找到了文章标题。
![](http://media.makcyun.top/18-9-2/68563785.jpg)

回到我们的初衷：**下载所有网页的图片内容**。那么现在就有解决办法礼：一个个地把出现的这些url网址中图片下载下来就大功告成了。

好，我们先来分析一下这些url，看看有没有相似性，如果有很明显的相似性，那么就可以像普通网页那样，通过构造翻页页数的url，实现for循环就可以批量下载所有网页的图片了。复制前3个链接如下：
```python
https://www.thepaper.cn/load_index.jsp?nodeids=25635&topCids=&pageidx=2&isList=true&lastTime=1533169319712  
https://www.thepaper.cn/load_index.jsp?nodeids=25635&topCids=&pageidx=3&isList=true&lastTime=1528625875167  
https://www.thepaper.cn/load_index.jsp?nodeids=25635&topCids=&pageidx=4&isList=true&lastTime=1525499007926
```
发现`pageidx`键的值呈现规律的数字递增变化，看起来是个好消息。但同时发现后面的lastTime键的值看起来是随机变化的，这个有没有影响呢？ 来测试一下，复制第一个链接，删掉`&lastTime=1533169319712`这一串字符，会发现网页一样能够正常打开，就说明着一对参数不影响网页内容，那就太好了。我们可以删除掉，这样所有url的区别只剩`pageidx`的值了，这时就可以构造url来实现for循环了。构造的url形式如下：
```python
https://www.thepaper.cn/load_index.jsp?nodeids=25635&pageidx=2
https://www.thepaper.cn/load_index.jsp?nodeids=25635&pageidx=3
https://www.thepaper.cn/load_index.jsp?nodeids=25635&pageidx=4
```
同时，尝试把数字2改成1并打开链接看看会有什么变化，发现呈现的内容就是第1页的内容。这样，我们就可以从第一页开始构造url循环了。  
`https://www.thepaper.cn/load_index.jsp?nodeids=25635&pageidx=1`  

既然确定了首页，那么也要相应地确定一下尾页。很简单，我们把数字改大然后打开链接看是否有内容即可。比如改为**10 **，打开发现有内容显示，很好。接着，再改为30，发现没有内容了。说明该栏目的页数介于这两个数之间，尝试几次后，发现`25`是最后一个有内容的网页，也意味着能够爬取的页数一共是25页。  

确定了首页和尾页后，下面我们就可以开始构造链接，先爬取第一篇文章网页里的图片（这个爬取过程，我们上一篇爬取网易"数读"已经尝试过了），然后爬取这一整页的图片，最后循环25页，爬取所有图片，下面开始吧。

## 3. 程序代码 ##

```python
import requests
from bs4 import BeautifulSoup
import re
import os
from hashlib import md5
from requests.exceptions import RequestException
from multiprocessing import Pool
from urllib.parse import urlencode

headers = {
    'user-agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36'
    }

# 1 获取索引界面网页内容
def get_page_index(i):
    # 下载1页
    # url = 'https://www.thepaper.cn/newsDetail_forward_2370041'

    # 2下载多页，构造url
    paras = {
        'nodeids': 25635,
        'pageidx': i
    }
    url = 'https://www.thepaper.cn/load_index.jsp?' + urlencode(paras)

    response = requests.get(url,headers = headers)
    if response.status_code == 200:
        return response.text
        # print(response.text)  # 测试网页内容是否提取成功ok

# 2 解析索引界面网页内容
def parse_page_index(html):
    soup = BeautifulSoup(html,'lxml')

    # 获取每页文章数
    num = soup.find_all(name = 'div',class_='news_li')
    for i in range(len(num)):
        yield{
        # 获取title
        'title':soup.select('h2 a')[i].get_text(),
        # 获取图片url，需加前缀
        'url':'https://www.thepaper.cn/' + soup.select('h2 a')[i].attrs['href']
        # print(url)  # 测试图片链接
        }

# 3 获取每条文章的详情页内容
def get_page_detail(item):
    url = item.get('url')
    # 增加异常捕获语句
    try:
        response = requests.get(url,headers = headers)
        if response.status_code == 200:
            return response.text
            # print(response.text)  # 测试网页内容是否提取成功
    except RequestException:
        print('网页请求失败')
        return None
        
# 4 解析每条文章的详情页内容
def parse_page_detail(html):
    soup = BeautifulSoup(html,'lxml')
    # 获取title
    if soup.h1:  #有的网页没有h1节点，因此必须要增加判断，否则会报错
        title = soup.h1.string
        # 每个网页只能拥有一个<H1>标签,因此唯一
        items = soup.find_all(name='img',width =['100%','600'])
        # 有的图片节点用width='100%'表示，有的用600表示，因此用list合并选择
        # https://blog.csdn.net/w_xuechun/article/details/76093950
        # print(items) # 测试返回的img节点ok
        for i in range(len(items)):
            pic = items[i].attrs['src']
            # print(pic) #测试图片链接ok
            yield{
            'title':title,
            'pic':pic,
            'num':i  # 图片添加编号顺序
            }
# 5 下载图片
def save_pic(pic):
    title = pic.get('title')
    # 标题规范命名：去掉符号非法字符| 等
     title = re.sub('[\/:*?"<>|]','-',title).strip()
    url = pic.get('pic')
    # 设置图片编号顺序
    num = pic.get('num')

    if not os.path.exists(title):
        os.mkdir(title)

    # 获取图片url网页信息
    response = requests.get(url,headers = headers)
    try:
    # 建立图片存放地址
        if response.status_code == 200:
            file_path = '{0}\{1}.{2}' .format(title,num,'jpg')
            # 文件名采用编号方便按顺序查看，而未采用哈希值md5(response.content).hexdigest()
            if not os.path.exists(file_path):
                # 开始下载图片
                with open(file_path,'wb') as f:
                    f.write(response.content)
                    print('文章"{0}"的第{1}张图片下载完成' .format(title,num))
            else:
                print('该图片%s 已下载' %title)
    except RequestException as e:
        print(e,'图片获取失败')
        return None

def main(i):
    # get_page_index(i) # 测试索引界面网页内容是否获取成功ok

    html = get_page_index(i)
    data = parse_page_index(html)  # 测试索引界面url是否获取成功ok
    for item in data:
        # print(item)  #测试返回的dict
        html = get_page_detail(item)
        data = parse_page_detail(html)
        for pic in data:
            save_pic(pic)

# 单进程
if __name__ == '__main__':
    for i in range(1,26):
        main(i)

# 多进程
if __name__ == '__main__':
    pool = Pool()
    pool.map(main,[i for i in range(1,26)])
    pool.close()
    pool.join()
```
结果：
![](http://media.makcyun.top/18-9-2/46673865.jpg)  

![](http://media.makcyun.top/18-9-3/4372426.jpg)  

文章代码和栏目从2015年至今437篇文章共1509张图片资源，可在下方链接中得到。
[https://github.com/makcyun/web_scraping_with_python](https://github.com/makcyun/web_scraping_with_python)

本文完。

![](http://media.makcyun.top/Fj4q0NIPPMC5dMshIU9H650qD_Tf)