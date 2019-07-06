---



title: Python 可视化(4)：WordCloud 中英文词云图绘制方法汇总
date: 2018-11-14 16:16:24
id: Python_visualization04
categories: Python可视化
tags: [WordCloud 词云]
images: http://media.makcyun.top/18-12-22/86118901.jpg
keywords: [wordcloud词云图,python 词云]
---

英文和中文词云图绘制总结。

<!-- more -->  

**摘要：** 当我们手中有一篇文档，比如书籍、小说、电影剧本，若想快速了解其主要内容是什么，那么可以通过绘制WordCloud 词云图，通过关键词（高频词）就可视化直观地展示出来，非常方便。本文主要介绍常见的英文和中文文本的词云图绘制，以及通过 DataFrame 数据框绘制 Frequency 频率词云图。

在上一篇文章「[pyspider 爬取并分析虎嗅网 5 万篇文章](https://www.makcyun.top/web_scraping_withpython9.html) 」中的文本可视化部分，我们通过 WordCloud 和 jieba 两个包绘制了中文词云图，当时只是罗列出了代码，并没有详细介绍。接下来，将详细说明词云图绘制步骤，并且对词云图的种类进行拓展。

![](http://media.makcyun.top/18-11-7/78186420.jpg)

## 1. 英文词云

这里，我们先绘制英文文本的词云图，因为它相对简单一些，这里，以《海上钢琴师》这部电影的剧本为例。

首先，需要准备好电影剧本的文本文件（如下图）：

![](http://media.makcyun.top/18-11-13/56930265.jpg)

接下来，我们绘制一个最简单的矩形词云图，代码如下：

```python
import os
from os import path
from wordcloud import WordCloud
from matplotlib import pyplot as plt
# 获取当前文件路径
d = path.dirname(__file__) if "__file__" in locals() else os.getcwd()
# 获取文本text
text = open(path.join(d,'legend1900.txt')).read()
# 生成词云
wc = WordCloud(scale=2,max_font_size = 100)
wc.generate_from_text(text)
# 显示图像
plt.imshow(wc,interpolation='bilinear')
plt.axis('off')
plt.tight_layout()
#存储图像
wc.to_file('1900_basic.png')
# or
# plt.savefig('1900_basic.png',dpi=200)
plt.show()
```

首先，通过 open() 方法读取文本文件，然后 WordCloud 方法设置了词云参数，generate_from_text() 生成该文本词云，然后显示和保存词云图，十几行代码就可以生成最简单的词云图。

![](http://media.makcyun.top/18-11-13/4871189.jpg)

通过上面的词云图，你可能会发现有几点问题：

- 可不可以随便更换背景，比如白色？
- 词云图是矩形，能不能换成其他形状或者自定义图片样式？
- 词云中最显眼的词汇 「ONE」，并没有实际含义，能不能去掉？

以上这些都是可以更改的，如果你想实现以上想法，那么需要先了解一下 WordCloud 的API 参数及它的一些方法。

这里，我们列出它的各项参数，并注释重要的几项：

```python
wordcloud.WordCloud(
    font_path=None,  # 字体路径，英文不用设置路径，中文需要，否则无法正确显示图形
    width=400, # 默认宽度
    height=200, # 默认高度
    margin=2, # 边缘
    ranks_only=None, 
    prefer_horizontal=0.9, 
    mask=None, # 背景图形，如果想根据图片绘制，则需要设置
    scale=1, 
    color_func=None, 
    max_words=200, # 最多显示的词汇量
    min_font_size=4, # 最小字号
    stopwords=None, # 停止词设置，修正词云图时需要设置
    random_state=None, 
    background_color='black', # 背景颜色设置，可以为具体颜色,比如white或者16进制数值
    max_font_size=None, # 最大字号
    font_step=1, 
    mode='RGB', 
    relative_scaling='auto', 
    regexp=None, 
    collocations=True, 
    colormap='viridis', # matplotlib 色图，可更改名称进而更改整体风格
    normalize_plurals=True, 
    contour_width=0, 
    contour_color='black', 
    repeat=False)
```

了解各项参数后，我们就可以自定义想要的词云图了。比如更换一下背景颜色和整体风格，就可以修改以下几项：

```python
wc = WordCloud(
    scale=2,# 缩放2倍
    max_font_size = 100,
    background_color = '#383838',# 灰色
    colormap = 'Blues') 
# colormap名称 https://matplotlib.org/examples/color/colormaps_reference.html
```

![](http://media.makcyun.top/18-11-13/7484409.jpg)

接下来，我们提升一点难度，通过设置 StopWords 去掉没有实际意义的「ONE」，然后将词云图绘制在我们自定义的一张图片上。

![](http://media.makcyun.top/18-11-13/96391276.jpg)

代码实现如下：

```python
import os
from os import path
import numpy as np
from wordcloud import WordCloud,STOPWORDS,ImageColorGenerator
from PIL import Image
from matplotlib import pyplot as plt
from scipy.misc import imread
import random

def wc_english():
    # 获取当前文件路径
    d = path.dirname(__file__) if "__file__" in locals() else os.getcwd()
    # 获取文本text
    text = open(path.join(d,'legend1900.txt')).read()
    # 读取背景图片
    background_Image = np.array(Image.open(path.join(d, "mask1900.jpg")))
    # or
    # background_Image = imread(path.join(d, "mask1900.jpg"))
    # 提取背景图片颜色
    img_colors = ImageColorGenerator(background_Image)
    # 设置英文停止词
    stopwords = set(STOPWORDS)
    wc = WordCloud(
        margin = 2, # 设置页面边缘
        mask = background_Image,
        scale = 2,
        max_words = 200, # 最多词个数
        min_font_size = 4, # 最小字体大小
        stopwords = stopwords,
        random_state = 42,
        background_color = 'white', # 背景颜色
        max_font_size = 150, # 最大字体大小
        )
    # 生成词云
    wc.generate_from_text(text)
    # 等价于
    # wc.generate(text)
    # 根据图片色设置背景色
    wc.recolor(color_func=img_colors)
    #存储图像
    wc.to_file('1900pro1.png')
    # 显示图像
    plt.imshow(wc,interpolation='bilinear')
    plt.axis('off')
    plt.tight_layout()
    plt.show()
```

首先，通过 open() 方法读取文本文件，Image.open() 方法读取了背景图片，np.array 方法将图片转换为矩阵。接着设置了词云自带的英文 StopWords 停止词，用来分割筛除文本中不需要的词汇，比如：a、an、the 这些。然后，在 wordcloud 方法中，设置词云的具体参数。generate_from_text() 方法生成该词云，recolor() 则是根据图片色彩绘制词云颜色，绘制效果如下：

![](http://media.makcyun.top/18-11-13/67270011.jpg)

接着，我们还是看到了显眼的「ONE」，下面我们将它去除掉，方法也很简单，几行代码搞定：

```python
# 获取文本词排序，可调整 stopwords
process_word = WordCloud.process_text(wc,text)
sort = sorted(process_word.items(),key=lambda e:e[1],reverse=True)
print(sort[:50]) # 获取文本词频最高的前50个词
# 结果
[('one', 60), ('ship', 47), ('Nineteen Hundred', 43), ('know', 38), ('music', 36), ...]

stopwords = set(STOPWORDS)
stopwords.add('one')
```

这里，我们可以对文本词频进行排序，通过输出看到 「ONE」词频最高，然后添加进 stopwords 中，就可以屏蔽该词从而不再显示。这种手动添加停止词的方法适用于词数量比较少的情况。

![](http://media.makcyun.top/18-11-13/21724138.jpg)

另外，我们还可以将词云图颜色显示为黑白渐变色，也只需修改几行代码即可：

```python
def grey_color_func(word, font_size, position, orientation, random_state=None,
                    **kwargs):
        return "hsl(0, 0%%, %d%%)" % random.randint(50, 100)
		# 随机设置hsl色值
wc.recolor(color_func=grey_color_func) 
```

![](http://media.makcyun.top/18-11-13/72250527.jpg)

以上，就是英文词云图绘制的几种方法，下面我们介绍中文词云图的绘制。

## 2. 中文词云

相比于英文词云，中文在绘制词云图前，需要先切割词汇，这里推荐使用 jieba 包来切割分词。因为它可以说是最好的中文分词包了，GitHub 上拥有 160 K 的 Star 数。

安装好 jieba 包后，我们就可以对文本进行分词然后生成词云了。这里，选取吴军老师的著作《浪潮之巅》作为中文文本的案例，仍然采用图片形式的词云图。素材准备好后，接下来就可以开始中文词云图绘制。

![](http://media.makcyun.top/18-11-13/11957799.jpg)

首先，需要读取文本文件，相比于英文，这里要添加文本编码格式，否则会报错，添加几行检测代码即可：

```python
text = open(path.join(d,'langchao.txt'),'rb').read()
text_charInfo = chardet.detect(text)
print(text_charInfo)
# 结果
{'encoding': 'UTF-8-SIG', 'confidence': 1.0, 'language': ''}
text = open(path.join(d,r'langchao.txt'),encoding='UTF-8-SIG').read()
```

接着，对文本进行分词。jieba 分词有 3 种方式：精确模式、全模式和搜索引擎模式，它们之间的差别，可以用一个例子来体现。

比如，有这样的一句话：「"我来到北京清华大学"」，用 3 种模式进行分词，结果分别如下：

- 全模式: 我/ 来到/ 北京/ 清华/ 清华大学/ 华大/ 大学

- 精确模式: 我/ 来到/ 北京/ 清华大学

- 搜索引擎模式： 我/ 来/ 来到/ 北京/ 清华/ 大学/ 清华大学/

根据结果可知，我们应该选择「精确模式」来分词。关于 jieba 包的详细用法，可以参考 GitHub 仓库链接：

[https://github.com/fxsjy/jieba](https://github.com/fxsjy/jieba)

分词完成后，我们还需要设置 stopwords 停止词，由于 WordCloud 没有中文停止词，所以我们需要自行构造。这里可以采取两种方式来构造：

- 通过 stopwords.update() 方法手动添加
- 根据已有 stopwords 词库遍历文本筛除停止词

### 2.1. stopwords.update() 手动添加

这种方法和前面的英文停止词构造的方法是一样的，目的是在词云图中不显示 stopwords 就行了 。先不设置 stopwords，而是先对文本词频进行排序，然后将不需要的词语添加为 stopwords 即可。下面用代码实现：

```python
# 获取文本词排序，可调整 stopwords
process_word = WordCloud.process_text(wc,text)
sort = sorted(process_word.items(),key=lambda e:e[1],reverse=True)
print(sort[:50]) # # 获取文本词频最高的前50个词

[('公司', 1273), ('但是', 769), ('IBM', 668), ('一个', 616), ('Google', 429), ('自己', 396), ('因此', 363), ('微软', 358), ('美国', 344), ('没有', 334)...]
```

可以看到，我们先输出文本词频最高的一些词汇后，发现：但是、一个、因此、没有等这些词都是不需要显示在词云图中的。因此，可以把这些词用列表的形式添加到 stopwords 中，然后再次绘制词云图就能得出比较理想的效果，完整代码如下：


```python
import chardet
import jieba
text+=' '.join(jieba.cut(text,cut_all=False)) # cut_all=False 表示采用精确模式
# 设置中文字体
font_path = 'C:\Windows\Fonts\SourceHanSansCN-Regular.otf'  # 思源黑体
# 读取背景图片
background_Image = np.array(Image.open(path.join(d, "wave.png")))
# 提取背景图片颜色
img_colors = ImageColorGenerator(background_Image)
# 设置中文停止词
stopwords = set('')
stopwords.update(['但是','一个','自己','因此','没有','很多','可以','这个','虽然','因为','这样','已经','现在','一些','比如','不是','当然','可能','如果','就是','同时','比如','这些','必须','由于','而且','并且','他们'])

wc = WordCloud(
        font_path = font_path, # 中文需设置路径
        margin = 2, # 页面边缘
        mask = background_Image,
        scale = 2,
        max_words = 200, # 最多词个数
        min_font_size = 4, #
        stopwords = stopwords,
        random_state = 42,
        background_color = 'white', # 背景颜色
        # background_color = '#C3481A', # 背景颜色
        max_font_size = 100,
        )
wc.generate(text)
# 获取文本词排序，可调整 stopwords
process_word = WordCloud.process_text(wc,text)
sort = sorted(process_word.items(),key=lambda e:e[1],reverse=True)
print(sort[:50]) # 获取文本词频最高的前50个词
# 设置为背景色，若不想要背景图片颜色，就注释掉
wc.recolor(color_func=img_colors)
# 存储图像
wc.to_file('浪潮之巅basic.png')
# 显示图像
plt.imshow(wc,interpolation='bilinear')
plt.axis('off')
plt.tight_layout()
plt.show()    
```

我们对比以下 stopwords 添加前后的效果就可以大致看出效果。

stopwords 添加之前：

![](http://media.makcyun.top/18-11-13/56340530.jpg)

stopwords 添加之后：

![](http://media.makcyun.top/18-11-13/83641740.jpg)

可以看到，stopwords.update() 这种方法需要手动去添加，比较麻烦一些，而且如果 stopwords 过多的话，添加就比较费时了。下面介绍第 2 种 自动去除 stopwords 的方法。

### 2.2. stopwords 库自动遍历删除

这种方法的思路也比较简单。主要分为 2 个步骤：

- 利用已有的中文 stopwords 词库，对原文本进行分词后，遍历词库去除停止词，然后生成新的文本文件。

- 根据新的文件绘制词云图，便不会再出现 stopwords，如果发现 stopwords 词库不全可以进行补充，然后再次生成词云图即可。

代码实现如下：

```python
# 对原文本分词
def cut_words():
    # 获取当前文件路径
    d = path.dirname(__file__) if "__file__" in locals() else os.getcwd()
    text = open(path.join(d,r'langchao.txt'),encoding='UTF-8-SIG').read()
    text = jieba.cut(text,cut_all=False)
    content = ''
    for i in text:
        content += i
        content += " "
    return content

# 加载stopwords
def load_stopwords():
    filepath = path.join(d,r'stopwords_cn.txt')
    stopwords = [line.strip() for line in open(filepath,encoding='utf-8').readlines()]
    # print(stopwords) # ok
    return stopwords

# 去除原文stopwords,并生成新的文本
def move_stopwwords(content,stopwords):
    content_after = ''
    for word in content:
        if word not in stopwords:
            if word != '\t'and'\n':
                content_after += word

    content_after = content_after.replace("   ", " ").replace("  ", " ")
    # print(content_after)
    # 写入去停止词后生成的新文本
    with open('langchao2.txt','w',encoding='UTF-8-SIG') as f:
        f.write(content_after)
```

网上有很多中文 stopwords 词库资料，这里选取了一套包含近 [2000 个词汇和标点符号的词库](https://blog.csdn.net/shijiebei2009/article/details/39696571)：stopwords_cn.txt，结构形式如下：

![](http://media.makcyun.top/18-11-13/83684654.jpg)

遍历该 stopwords 词库，删除停止词获得新的文本，然后利用第一种方法绘制词云图即可。

首先输出一下文本词频最高的部分词汇，可以看到常见的停止词已经没有了。

```python
[('公司', 1462), ('美国', 366), ('IBM', 322), ('微软', 320), ('市场', 287), ('投资', 263), ('世界', 236), ('硅谷', 235), ('技术', 234), ('发展', 225), ('计算机', 218), ('摩托罗拉', 203)...]
```

最终绘制词云图，效果如下：

![](http://media.makcyun.top/18-11-13/18929834.jpg)

## 3. Frenquency 词云图

除了直接读入文本生成词云，还可以使用 **DataFrame** 或者 **字典格式** 的词频作为输入绘制词云。

下面，以此前我们爬过的一份 10 年「世界大学排名 TOP500 强」 数据为例，介绍如何绘制词云图。

数据为 5001行 x 6 列，我们想根据各国 TOP 500 强大学的数量之和，展示各国顶尖大学数量的一个大概情况对比。

​	

```python
world_rank	university	score	quantity	year	country
1	哈佛大学	100	500	2009	USA
2	斯坦福大学	73.1	499	2009	USA
3	加州大学-伯克利	71	498	2009	USA
4	剑桥大学	70.2	497	2009	UK
5	麻省理工学院	69.5	496	2009	USA
...
496	犹他州立大学		2018	USA
497	圣拉斐尔生命健康大学		2018	Italy
498	早稻田大学		2018	Japan
499	韦恩州立大学		2018	USA
500	西弗吉尼亚大学		2018	USA
```

有两种格式可以直接生成频率词云图，第一种是 Series 生成。

```python
import pandas as pd
import matplotlib.dates as mdate
from wordcloud import WordCloud
import matplotlib.pyplot as plt

df = pd.read_csv('university.csv',encoding = 'utf-8')
df = df.groupby(by = 'country').count()
df = df['world_rank'].sort_values(ascending = False)
print(df[:10])
# 结果如下：
country
USA               1459
Germany            382
UK                 379
China              320
France             210
Canada             209
Japan              206
Australia          199
Italy              195
Netherlands        122
```

第二种转换为 dict 字典生成。

```python
df = dict(df)
print(df)
# 结果如下：
{'USA': 1459, 'Germany': 382, 'UK': 379, 'China': 320, 'France': 210,..}
```

这两种数据都可以快速生成词云图，代码实现如下：


```python
font_path='C:\Windows\Fonts\SourceHanSansCN-Regular.otf'  # 思源黑
wordcloud = WordCloud(
    background_color = '#F3F3F3',
    font_path = font_path,
    width = 5000,
    height = 300,
    margin = 2,
    max_font_size = 200,
    random_state = 42,
    scale = 2,
    colormap = 'viridis',  # 默认virdis
    )
wordcloud.generate_from_frequencies(df)
# or
# wordcloud.fit_words(df)
plt.imshow(wordcloud,interpolation = 'bilinear')
plt.axis('off')
plt.show()
```

结果如下：

![](http://media.makcyun.top/18-11-13/73471381.jpg)

可以看到，美国最为突出，其次是德国、英国、中国等。

文中代码及素材可以在公众号后台回复 **词云 **或者在下面的链接中获取：

本文完。

---

推荐阅读：

[做 PPT 没灵感？澎湃网 1500 期信息图送给你](https://www.makcyun.top/web_scraping_withpython4.html)

[国内创业公司的信息都在这里了](https://www.makcyun.top/web_scraping_withpython7.html) 



![](http://media.makcyun.top/%E5%85%AC%E4%BC%97%E5%8F%B7%E5%85%B3%E6%B3%A8.jpg)

<center>欢迎扫一扫识别关注我的公众号</center>