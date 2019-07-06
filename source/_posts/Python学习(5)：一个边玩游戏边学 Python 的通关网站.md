---

title: pythonchallenge 一个边玩游戏边学 Python 的通关网站 
id: Python_learning05
date: 2019-5-17 16:16:16
categories: Python学习
tags: [Python入门]
images: http://media.makcyun.top/win/20190517/b1PTPQSFbdi6.jpg?imageslim
keywords: [pythonchallenge,python学习游戏网站]
---
Python 趣味学习网站。

<!-- more -->  

这里是「每周分享」的第 28 期。往期分享内容可以在公众号后台的 「不务正业」菜单中找到，Python 类的文章在另一个「不误正业」菜单中。

这一期的话题是：**一个学习 Python 的趣味网站** 。

最近在网上看到一个非常有意思的 Python 游戏通关网站叫 ：[pythonchallenge](http://www.pythonchallenge.com/)。一共有 33 关，每一关都需要利用 Python 知识解题找到答案，然后进入下一关。很考验对 Python 的综合掌握能力，比如有的闯关需要用到正则表达式，有的要用到简单的爬虫。

平常学 Python 都是按章节顺序、包或者模块来学，容易前学后忘。正好可以拿这个网站来综合测试一下对 Python 的掌握情况，以便查缺补漏。

![mark](http://media.makcyun.top/win/20190517/zxEI9qCgGEX7.png?imageslim)

来说说这个网站怎么玩。

![mark](http://media.makcyun.top/win/20190517/ouAsVeqHH94B.png?imageslim)

这是网站主页面，很有历史感对吧，诞生了已有十几年了。但千万不要因为看着像老古董而小瞧它。

我们来玩玩看，点击「get challenged」开始挑战。

第 0 关是 Warming up 热身环节：

这一关要求是修改 URL 链接，给的提示是电脑上的数学表达式： 2 的 38 次方，所以大概就是需要计算出数值，然后修改url 进入下一关。

所以这关就是考Python 的基本数值运算，你知道怎么算么？



随意打开个 IDE，比如 Python 自带终端，只要一行代码就能计算出结果：

![mark](http://media.makcyun.top/win/20190517/jsSvU886Y3xw.png?imageslim)

把原链接中的 `0`替换为 `274877906944`回车就会进入下一关：

![mark](http://media.makcyun.top/win/20190517/ypFIjlp1IuLF.png?imageslim)

游戏这就正式开始了。图片中的笔记本给了三组字母，很容易发现规律：前面的字母往后移动两位就是后面的字母。

那么需要做的就是根据这个规律把下面的提示字符串，做位移解密得到真正的句子含义：

这道题考察字符串编码和 for 循环相关知识，代码实现如下：

```python
text = '''g fmnc wms bgblr rpylqjyrc gr zw fylb. rfyrq ufyr amknsrcpq
    ypc dmp. bmgle gr gl zw fylb gq glcddgagclr ylb rfyr'q
    ufw rfgq rcvr gq qm jmle. sqgle qrpgle.kyicrpylq()
    gq pcamkkclbcb. lmu ynnjw ml rfc spj.'''

text_translate = ''
for i in text:
    if str.isalpha(i):
        n = ord(i)
        if i >= 'y':
            n = ord(i) + 2 - 26
        else:
            n = ord(i) + 2
        text_translate += chr(n)
    else:
        text_translate += i
print(text_translate)
```

得到结果：

```test
i hope you didnt translate it by hand. 
thats what computers are for. 
doing it in by hand is inefficient and that's why this text is so long. 
using string.maketrans()is recommended. now apply on the url.
```

作者很风趣，当然不能手动去一个推算了，推荐用 string.maketrans() 这个方法解决，我们上面采取的是比较直接的方法，官方给出了更为精简的方法：

```python
import string
l = string.lowercase
t = string.maketrans(l, l[2:] + l[:2])
print (text.translate(t))
```

然后把 url 中的 `map` 改为`ocr`回车就来到了第 2 关：

![mark](http://media.makcyun.top/win/20190517/ehGvHsSHtovF.png?imageslim)

作者接着说过关的提示可能在书里（当然不可能了）也可能在网页源代码里。那就右键查看源代码往下拉看到绿色区域，果然找到了问题：

![mark](http://media.makcyun.top/win/20190517/g39fqrlV1JYP.png?imageslim)

意思就是：**要在下面这一大串字符里找到出现次数最少的几个字符**

考察了这么几个知识点：

- 正则表达式提取字符串
- list 计数
- 条件语句

如果是你，你会怎么做？



来看下，十行代码怎么实现的：

```python
import requests
url = 'http://www.pythonchallenge.com/pc/def/ocr.html'
res = requests.get(url).text
text = re.findall('.*?<!--.*-->.*<!--(.*)-->',res,re.S)
# list转为str便于遍历字符
str = ''.join(text)

lst = []
key=[]
#遍历字符
for i in str:
    #将字符存到list中
    lst.append(i)
    #如果字符是唯一的，则添加进key
    if i not in key:
        key.append(i)
# 将list列表中的字符出现字数统计出来
for items in key:
    print(items,lst.count(items))
```

首先，用 Requests 请求网页然后用正则提取出字符串，接着 for 循环计算每个字符出现的次数。

```python
% 6104
$ 6046
@ 6157
_ 6112
^ 6030
# 6115
) 6186
& 6043
! 6079
+ 6066
] 6152
* 6034
} 6105
[ 6108
( 6154
{ 6046

e 1
q 1
u 1
a 1
l 1
i 1
t 1
y 1
```

可以看到出现次数最少的就是最后几个字符，合起来是「equality」，替换 url 字符就闯过过了第 2 关进入下一关继续挑战。是不是有点意思？



后面每一关都需要用到相关的 Python 技巧解决，比如第 4 关：

![mark](http://media.makcyun.top/win/20190517/jbXJRTGYHxSc.png?imageslim)

这一关作者弄了个小恶作剧，需要手动输入数值到 url 中然后回车，你以为这样就完了么？并没有它有会不断重复弹出新的数值让你输入，貌似没完没了。

到这儿就能发现肯定不能靠手动去完成，要用到 Python 实现自动填充修改 url 回车跳转到新 url，循环直到网页再也无法跳转为止。

如果是你，你会怎么做？



其实一段简单的爬虫加正则就能搞定。思路很简单，把每次网页中的数值提取出来替换成新的 url 再请求网页，循环下去，代码实现如下：

```python
import requests
import re
import os

# 首页url
resp = requests.get(
    'http://www.pythonchallenge.com/pc/def/linkedlist.php?nothing=12345').text
url = 'http://www.pythonchallenge.com/pc/def/linkedlist.php?nothing='
# 计数器
count = 0
while True:
    try:
        # 提取下一页动态数值
        nextid = re.search('\d+', resp).group()
        count = count + 1
        nextid = int(nextid)
    except:
        print('最后一个url为：%s' % nexturl)
        break

    # 获取下一页url
    nexturl = url + str(nextid)
    print('url %s:%s' % (count, nexturl))
    # 重复请求
    resp = requests.get(nexturl).text
```

输出结果如下：

gif

可以看到，最终循环了 85 次找到了最后一个数字`16044`，输入到 url 中就闯关成功。



33 关既有趣又能锻炼使用 Python 解决问题的技巧，感兴趣的话去玩玩看。

网址：[http://www.pythonchallenge.com/](http://www.pythonchallenge.com/)

如果遇到不会做的题，可以在这里找到参考答案：

中参考文教程：

[https://www.cnblogs.com/jimnox/archive/2009/12/08/tips-to-python-challenge.html](https://www.cnblogs.com/jimnox/archive/2009/12/08/tips-to-python-challenge.html)

[https://blog.csdn.net/Jurbo/article/details/52136323](https://blog.csdn.net/Jurbo/article/details/52136323)

官方参考教程：

[http://garethrees.org/2007/05/07/python-challenge/](http://garethrees.org/2007/05/07/python-challenge/)