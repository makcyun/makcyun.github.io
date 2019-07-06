---



title: 除了 Pyecharts，不妨尝尝 Uber 开发的这款高逼格地理空间可视化库
date: 2019-7-2 16:16:24
id: Python_visualization05
categories: Python可视化
tags: [WPython可视化]
images: http://media.makcyun.top/win/20190702/cW7aVXijcAh0.jpg?imageslim
keywords: [Python可视化,pyechrts,地图可视化]
---

一款Jupyter notebook 空间可视化库。

<!-- more -->  

作者 | [Shan He](https://medium.com/vis-gl/introducing-kepler-gl-for-jupyter-f72d41659fbf)

译者 | 高级农民工

说起 Python 中的可视化，我们一般用的最多的是 Matplotlib，绘制一般的图效果都很好。有时候也会用风格比较好看的 Pyecharts 库，尤其是在展示空间地图上的数据时，在以前的文章中也多次使用了该库：

参考：[2018 年大学毕业生薪酬排行榜](https://www.makcyun.top/2019/02/25/data_analysis&mining03.html)

![](http://media.makcyun.top/Fjdt5Eisn6x8XBMYRXh0MBxYWU5A)

不过它的效果相比今天要介绍的一款地理空间可视化库可要逊色不少。

这个库就是：[**kepler.gl**](http://kepler.gl/)，由大名鼎鼎的独角兽公司 Uber 团队开发，现已开源。库直接集成到了 Jupyter Notebook 中，非常方便使用。

先来看看它效果有多酷炫：

![](http://media.makcyun.top/Fnvj6PI3YdMGdSeSl2GFJSVUs442)

![](http://media.makcyun.top/FkBr41Qk23bhroBADF_Frp_KNrrb)

![](http://media.makcyun.top/FgV8Hs7bKDwWqOHFb4iMMnr1IKE_)



是不是还不错？

在 Jupyter Notebook 中使用它也非常简单。

首先，一行命令安装好该库：

```python
$ pip install keplergl
```

接着加载地图：

```python
# 类可为空，也可以添加多项参数
from keplergl import KeplerGl
map_1 = KeplerGl()
map_1
```

当类为空时，默认地图是这样的：

![](http://media.makcyun.top/Fj2XTUP9WcNgk3-qtSVJck4atSRo)

接下来就可以在图中到导入数据展示。

数据支持多种常见格式，包括：CSV 文件、Pandas 的 DataFrame、地图文件 GEOJSON 等，非常友好。

每种数据的导入方式如下：

```python
# DataFrame
df = pd.read_csv('hex-data.csv')
map_1.add_data(data=df, name='data_1')

# CSV
with open('csv-data.csv', 'r') as f:
    csvData = f.read()
map_1.add_data(data=csvData, name='data_2')

# GeoJSON as string
with open('sf_zip_geo.json', 'r') as f:
    geojson = f.read()

map_1.add_data(data=geojson, name='geojson')
```



数据导入进来后，作一些简单的自定义设置，就可以生成逼格满满的空间可视化图：

![](http://media.makcyun.top/win/20190702/VAsSJoPbmv6W.gif)

除了在 Jupyter Notebook 展示，还可以导出为可交互式的 HTML 文件，并进一步导出 PNG 图片格式。

上面用的都是美国地图，转变为中国地图或者世界地图也不难。

以后需要展示地理空间可视化图形时，不妨考虑使用该库。

参考链接：[https://medium.com/vis-gl/introducing-kepler-gl-for-jupyter-f72d41659fbf](https://medium.com/vis-gl/introducing-kepler-gl-for-jupyter-f72d41659fbf)

项目 GitHub 库地址：https://github.com/keplergl/kepler.gl





