---
title: python爬虫(3)：单页图片下载-网易"数读"信息图
images: http://media.makcyun.top/18-9-2/6163569.jpg
date: {{ date }}
id: web_scraping_withpython3
categories: Python爬虫
tags: [Python爬虫,Ajax,图片下载]
keywords:
---

下载网络中的图片是件有意思的事，除了"右键另存为"这种方式以外，还可以用Python爬虫来自动下载。本文以信息图做得非常棒的网易"数读"栏目为例，介绍如何下载一个网页中的图片。


<!-- more -->  

![](http://media.makcyun.top/18-9-2/65507772.jpg)  

**本文知识点：**  
- 单张图片下载
- 单页图片下载  
- Ajax技术介绍


## 1. 单张图片下载 ##
以一篇最近比较热的涨房价的文章为例：[暴涨的房租，正在摧毁中国年轻人的生活](http://data.163.com/18/0901/01/DQJ3D0D9000181IU.html)，从文章里随意挑选一张[北京房租地图图片](http://cms-bucket.nosdn.127.net/2018/08/31/df39aac05e0b417a80487562cdf6ca40.png)，通过**Requests的content属性**来实现单张图片的下载。
![](http://media.makcyun.top/18-9-2/14528855.jpg)
```python
import requests
url = 'http://cms-bucket.nosdn.127.net/2018/08/31/df39aac05e0b417a80487562cdf6ca40.png'
response = requests.get(url)
with open('北京房租地图.jpg', 'wb') as f:
    f.write(response.content)
```
5行代码就能将这张图片下载到电脑上。不只是该张图片，任意图片都可以下载，只要替换图片的url即可。  
这里用到了**Requests的content属性**，将图片存储为二进制数据。至于，图片为什么可以用二进制数据进行存储，可以参考这个教程：  
[https://www.zhihu.com/question/36269548/answer/66734582](https://www.zhihu.com/question/36269548/answer/66734582)

5行代码看起来很短，但如果只是下载一张图片显然没有必要写代码，"右键另存为"更快。现在，我们放大一下范围，去下载这篇文章中的所有图片。粗略数一下，网页里有超过15张图片，这时，如果再用"右键另存为"的方法，显然就比较繁琐了。下面，我们用代码来实现下载该网页中的所有图片。

## 2. 单页图片下载 ##
### 2.1. Requests获取网页内容 ###
首先，用堪称python"爬虫利器"的**Requests库**来获取该篇文章的html内容。  
Requests库可以说是一款python爬虫的利器，它的更多用法，可参考下面的教程：   
[http://docs.python-requests.org/zh_CN/latest/index.html](http://docs.python-requests.org/zh_CN/latest/index.html)  
[https://cuiqingcai.com/2556.html](https://cuiqingcai.com/2556.html)

```python
import requests

headers = {
    'user-agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36'
    }
url = 'http://data.163.com/18/0901/01/DQJ3D0D9000181IU.html'

response = requests.get(url,headers = headers)
if response.status_code == 200:
    # return response.text
    print(response.text)  # 测试网页内容是否提取成功ok
```
### 2.2. 解析网页内容 ###
通过上面方法可以获取到html内容，接下来解析html字符串内容，从中提取出网页内的图片url。解析和提取url的方法有很多种，常见的有5种，分别是：正则表达式、Xpath、BeautifulSoup、CSS、PyQuery。任选一种即可，这里为了再次加强练习，5种方法全部尝试一遍。  
首先，在网页中定位到图片url所在的位置，如下图所示：  
![](http://media.makcyun.top/18-9-2/91340067.jpg)

从外到内定位url的位置：`<p>节点-<a>节点-<img>节点里的src属性值`。   

#### 2.2.1. 正则表达式 ####
```python
import re
pattern =re.compile('<p>.*?<img alt="房租".*?src="(.*?)".*?style',re.S)
    items = re.findall(pattern,html)
    # print(items)
    for item in items:
        yield{
        'url':item
        }
```
运行结果如下:  
```html
{'url': 'http://cms-bucket.nosdn.127.net/2018/08/31/425eca61322a4f99837988bb78a001ac.png'}
{'url': 'http://cms-bucket.nosdn.127.net/2018/08/31/df39aac05e0b417a80487562cdf6ca40.png'}
{'url': 'http://cms-bucket.nosdn.127.net/2018/08/31/d6cb58a6bb014b8683b232f3c00f0e39.png'}
{'url': 'http://cms-bucket.nosdn.127.net/2018/08/31/88d2e535765a4ed09e03877238647aa5.png'}
{'url': 'http://cms-bucket.nosdn.127.net/2018/09/01/98d2f9579e9e49aeb76ad6155e8fc4ea.png'}
{'url': 'http://cms-bucket.nosdn.127.net/2018/08/31/7410ed4041a94cab8f30e8de53aaaaa1.png'}
{'url': 'http://cms-bucket.nosdn.127.net/2018/08/31/49a0c80a140b4f1aa03724654c5a39af.png'}
{'url': 'http://cms-bucket.nosdn.127.net/2018/08/31/3070964278bf4637ba3d92b6bb771cea.png'}
{'url': 'http://cms-bucket.nosdn.127.net/2018/08/31/812b7a51475246a9b57f467940626c5c.png'}
{'url': 'http://cms-bucket.nosdn.127.net/2018/08/31/8bcbc7d180f74397addc74e47eaa1f63.png'}
{'url': 'http://cms-bucket.nosdn.127.net/2018/08/31/e593efca849744489096a77aafd10d3e.png'}
{'url': 'http://cms-bucket.nosdn.127.net/2018/08/31/7653feecbfd94758a8a0ff599915d435.png'}
{'url': 'http://cms-bucket.nosdn.127.net/2018/08/31/edbaa24a17dc4cca9430761bfc557ffb.png'}
{'url': 'http://cms-bucket.nosdn.127.net/2018/08/31/f768d440d9f14b8bb58e3c425345b97e.png'}
{'url': 'http://cms-bucket.nosdn.127.net/2018/08/31/3430043fd305411782f43d3d8635d632.png'}
{'url': 'http://cms-bucket.nosdn.127.net/2018/08/31/111ba73d11084c68b8db85cdd6d474a7.png'}
```

#### 2.2.2. Xpath语法 ####
```python
from lxml import etree
    parse = etree.HTML(html)
    items = parse.xpath('*//p//img[@alt = "房租"]/@src')
    print(items)
    for item in items:
        yield{
        'url':item
        }
```
结果同上。

#### 2.2.3. CSS选择器 ####
```python
soup = BeautifulSoup(html,'lxml')
    items = soup.select('p > a > img') #>表示下级绝对节点
    # print(items)
    for item in items:
        yield{
        'url':item['src']
        }
```

#### 2.2.4. BeautifulSoup find_all方法 ####
```python
soup = BeautifulSoup(html,'lxml')
# 每个网页只能拥有一个<H1>标签,因此唯一
item = soup.find_all(name='img',width =['100%'])
for i in range(len(item)):
    url = item[i].attrs['src']
    yield{
    'url':url
    }
    # print(pic) #测试图片链接ok
```

#### 2.2.5. PyQuery ####
```python
from pyquery import PyQuery as pq
data = pq(html)
data2 = data('p > a > img')
# print(items)
for item in data2.items():   #注意这里和BeautifulSoup 的css用法不同
    yield{
    'url':item.attr('src')
    # 或者'url':item.attr.src
    }
```
以上用了5种方法提取出了该网页的url地址，任选一种即可。这里假设选择了第4种方法，接下来就可以下载图片了。提取出的网址是一个**dict字典**，通过dict的get方法调用里面的键和值。
```python
title = pic.get('title')
url = pic.get('pic')
# 设置图片编号顺序
num = pic.get('num')

# 建立文件夹
if not os.path.exists(title):
    os.mkdir(title)

# 获取图片url网页信息
response = requests.get(url,headers = headers)

# 建立图片存放地址
file_path = '{0}\{1}.{2}' .format(title,num,'jpg')
# 文件名采用编号方便按顺序查看

# 开始下载图片
with open(file_path,'wb') as f:
   f.write(response.content)
   print('该图片已下载完成',title)

```
很快，15张图片就按着文章的顺序下载下来了。
![](http://media.makcyun.top/18-9-2/94009879.jpg)

将上述代码整理一下，增加一点异常处理和图片的标题、编号的代码以让爬虫更健壮，完整的代码如下所示：
### 2.3. 全部代码 ###

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

def get_page():
    # 下载1页
    url = 'http://data.163.com/18/0901/01/DQJ3D0D9000181IU.html'

    # 增加异常捕获语句
    try:
        response = requests.get(url,headers = headers)
        if response.status_code == 200:
            return response.text
            # print(response.text)  # 测试网页内容是否提取成功
    except RequestException:
        print('网页请求失败')
        return None

def parse_page(html):
    soup = BeautifulSoup(html,'lxml')
    # 获取title
    title = soup.h1.string
    # 每个网页只能拥有一个<H1>标签,因此唯一
    item = soup.find_all(name='img',width =['100%'])
    # print(item) # 测试

    for i in range(len(item)):
        pic = item[i].attrs['src']
        yield{
        'title':title,
        'pic':pic,
        'num':i  # 图片添加编号顺序
        }
        # print(pic) #测试图片链接ok

def save_pic(pic):
    title = pic.get('title')
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
                    print('该图片已下载完成',title)
            else:
                print('该图片%s 已下载' %title)
    except RequestException as e:
        print(e,'图片获取失败')
        return None
def main():
    # get_page() # 测试网页内容是获取成功ok
    html = get_page()
    # parse_page(html) # 测试网页内容是否解析成功ok

    data = parse_page(html)
    for pic in data:
        # print(pic) #测试dict
        save_pic(pic)
# 单进程
if __name__ == '__main__':
    main()

```
**小结**  
上面通过爬虫实现下载一张图片延伸到下载一页图片，相比于手动操作，爬虫的优势逐渐显现。那么，能否实现多页循环批量下载更多的图片呢，当然可以，下一篇文章将进行介绍。  

你也可以尝试一下，这里先放上"福利"：网易"数读"栏目从2012年至今350篇文章的全部图片已下载完成。
![](http://media.makcyun.top/18-9-2/90267464.jpg)

如果你需要，可以到我的github下载。  
[https://github.com/makcyun/web_scraping_with_python](https://github.com/makcyun/web_scraping_with_python)  

本文完。  

![](http://media.makcyun.top/Fj4q0NIPPMC5dMshIU9H650qD_Tf)