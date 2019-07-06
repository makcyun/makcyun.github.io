---
title: Python 绘制 3 维以上的高维图
id: translating03
date: 2019-6-27 16:16:16
categories: Python分享
tags: [Python入门]
images: http://media.makcyun.top/win/20190627/dnERurnS44Ct.png?imageslim
keywords: [python绘制3维以上图,plotly绘图]

---

实用技巧。

<!-- more -->  

我们的大脑通常最多能感知三维空间，超过三维就很难想象了。尽管是三维，理解起来也很费劲，所以大多数情况下都使用二维平面。不过，我们仍然可以绘制出多维空间，今天就来用 Python 的 plotly 库绘制下三维到六维的图，看看长什么样。

数据我们使用一份来自 [UCI](https://archive.ics.uci.edu/ml/index.php) 的[真实汽车数据集](https://archive.ics.uci.edu/ml/datasets/automobile)，该数据集包括 205 个样本和 26 个特征，从中选择 6 个特征来绘制图形：

![前6列](http://media.makcyun.top/win/20190627/AJu7Aw8lwE8S.png?imageslim)

### 基础工作

安装好 plotly 包：

```python
pip install plotly
```

加载数据集（文末会提供）：

```python
import pandas as pd
data = pd.read_csv("cars.csv")
```



下面我们先绘制基础的二维图表，使用两个 RPM 和 Speed 两个特征即可：

### 绘制 2-D 图

![](http://media.makcyun.top/FlAC486KCRfJmMvJ1xlfGCo39V2M)

代码实现如下：

```python
import plotly
import plotly.graph_objs as go

#绘制散点图
fig1 = go.Scatter(x=data['curb-weight'],
                  y=data['price'],
                  mode='markers')

#绘制布局
mylayout = go.Layout(xaxis=dict(title="curb-weight"),
                     yaxis=dict( title="price"))

#绘图 html
plotly.offline.plot({"data": [fig1],
                     "layout": mylayout},
                     auto_open=True)
```

保存为 html 文件打开可以生成交互界面，也可以保存为 png 图片。

下面增加特征来绘制三维图。

### 绘制 3-D 图

可以 使用 plotly 的 plot.Scatter3D 方法绘制三维图：

![](http://media.makcyun.top/Fv5IpWE7MEYtU4N3gmhU5jU1h9c-)

代码实现如下：

```python
fig1 = go.Scatter3d(x=data['curb-weight'],
                    y=data['horsepower'],
                    z=data['price'],
                    marker=dict(opacity=0.9,
                                reversescale=True,
                                colorscale='Blues',
                                size=5),
                    line=dict (width=0.02),
                    mode='markers')

mylayout = go.Layout(scene=dict(xaxis=dict( title="curb-weight"),
                                yaxis=dict( title="horsepower"),
                                zaxis=dict(title="price")),)

plotly.offline.plot({"data": [fig1],
                     "layout": mylayout},
                     auto_open=True,
                     filename=("3DPlot.html"))
```



如何绘制更高维度的图呢？显然无法通过扩展坐标轴的形式，不过有个小技巧就是制造一个虚拟维度，可以用不同颜色、形状大小、形状类别来入手。这样就可以显示第四个维度了。

### 绘制 4-D 图

下面我们将第四个变量——车辆油耗（city-mpg）添加到原先的三维图中，用颜色深浅表示，这样就绘制出了四维图。可以看到当其他三个指标（马力、车身重量、车价格）越高时：车辆油耗是越少的。

![](http://media.makcyun.top/FsRiV3dDbl0efTpEr5LNiwoLdVB2)



### 绘制 5-D 图

基于这样的思想，我们还可以通过修改圆形大小再增加一个维度——发动机尺寸（engine-size）变成五维图：

![](http://media.makcyun.top/FmGxqd6iWLn09_07p440bgw2t-Az)

我们仍然可以比较容易地地发现：车越贵，发动机尺寸越大这样的规律。



### 绘制 6-D 图

接着还可以通过更改形状的方式增加第六个维度——车门数，圆形表示四车门，方形表示两车门。通常两个车门的都是昂贵的豪华跑车，在图中也可以看出方形主要集中在价格比较高的区域。

![](http://media.makcyun.top/Fs_SH0GPkVTJzgmQN01o8dtB2BZR)

这样我们就从普通的二维图扩展到了高维图，当然还可以继续拓展，不过分辨起来会越来越困难。

作者： [Prasad Ostwal](https://medium.com/@prasadostwal?source=user_popover)  

链接：[https://medium.com/@prasadostwal/multi-dimension-plots-in-python-from-2d-to-6d-9a2bf7b8cc74](https://medium.com/@prasadostwal/multi-dimension-plots-in-python-from-2d-to-6d-9a2bf7b8cc74)

文中代码可以在后台回复：**6D** 得到。

