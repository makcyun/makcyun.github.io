---
title: 【机器学习07】使用网格搜索（GridSearchCV）快速找到 kNN 模型最佳超参数
id: Machine_learning09
date: 2019-6-17 16:16:16
categories: 机器学习
tags: [机器学习]
images: http://media.makcyun.top/win/20190611/qU67AoKqYGiJ.png?imageslim
keywords: [机器学习K近邻算法,kNN 超参数,GridSearchCV,网格搜索] 
---

网格搜索 GridSearchCV。

<!-- more -->  

**摘要：**介绍 sklearn 的网格搜索（GridSearchCV）。

上一篇文章我们说到了「网格搜索」，这是一种机器学习模型通常都会用到的模型调参方法，它能够返回最好的模型参数组合，采用这些参数建模便能得到最好的模型。为了解释网格搜索概念，我们还通过手写 for 循环遍历的方式模拟网格搜索思路，并找到了 kNN 模型的最好超参数组合。

![](http://media.makcyun.top/Fq5SZTsAH4vRcWn5N2UJbnMxBgiZ)

```python
# 图上参数组合对应的 kNN 模型为：
kNN_clf1 = KNeighborsClassifier(n_neighbors=1,weights='distance',p=1)
kNN_clf2 = KNeighborsClassifier(n_neighbors=3,weights='distance',p=2)
...
kNN_clfn = KNeighborsClassifier(n_neighbors=n,weights='distance',p=n)
```

但这种手写方式有个缺陷，就是不够智能需要手动调整。比如说，当我们的 kNN 模型在不考虑距离权重时，搜索超参数组合中的 weights 是 `uniform`，当超参数组合中有参数 p 的时候，就得将 `uniform`改成 `distance`，这很不方便，我们希望超参数在取不同的值时，能够自如地相互匹配。

好在，在 Sklearn 中有一个网格搜索函数（`GridSearchCV`）能够很轻松解决这个问题。我们只需要添加超参数即可，它会自动匹配超参数之间的关系，让模型正确运行，最终返回最好的一组超参数组合。

下面，我们就来介绍如何使用这个网格搜索函数，为了便于跟上一篇文章对比，这里仍采用葡萄酒数据集搭建 kNN 模型。

先加载并划分数据集，顺便获得随机最佳超参数下的模型得分：0.76（上一篇文章中的结果）。

![](http://media.makcyun.top/FnppuTf4SMT73fH7SsxbVKdaHktc)

### 定义超参数

第一步，在 GridSearchCV 函数的 param_grid 参数中定义超参数。该参数是一个数组，数组中包括一个个字典，我们只需要把每一组超参数组合放置在该字典中即可。字典的键为超参数名称，键的值为超参数的搜索取值范围。

![mark](http://media.makcyun.top/win/20190611/JG9gWiEAbjg6.png?imageslim)

比如，第一个字典中有两个超参数：n_neighbors 和 weights 。n_neighbors 取值范围是 1-20，weights 键值 uniform 表示不考虑距离，这组参数会循环搜索 20 次。

第二个字典中 weights 变为 distance 表示要考虑距离，n_neighbors 和 p 两个超参数循环 20*10 共 200 次。

两个字典加起来一共要循环搜索 220 次，后续就会建立 220 个模型中并根据得分返回最好的超参数组合。



### 建模

第二步，建模。先创建默认的 kNN 模型，把模型和刚才的超参数传进网格搜索函数中，接着传入训练数据集进行 fit 拟合，这时模型会尝试 220 组超参数组合，数据大的话会比较费时，可以使用 %%time 魔法命令记录运行时间。

![mark](http://media.makcyun.top/win/20190611/1ACizrxRmBby.png?imageslim)

模型训练好之后可以通过它的方法查看训练结果。

![mark](http://media.makcyun.top/win/20190611/K7ad42w7Mltk.png?imageslim)

best_params_参数查看最佳超参数组合：

```python
'n_neighbors': 4, 'p': 1, 'weights': 'distance'
```

模型最高得分 best_score_ 0.83，这个得分不是 kNN 模型的真实得分，因为评分标准不一样（以后说）。 要想查看该参数组合下的模型真实得分可以传入该参数给 kNN 模型，最终计算出得分是 0.76。

如果你有印象的话，我们在上一篇文章手动搜索出的最佳参数得分是 0.81，组合是：

```python
'n_neighbors': 15, 'p': 1, 'weights': 'distance'
```

这和上面使用网格搜索的结果并不一样，主要是网格搜索使用了更为复杂的计算方式。

上面的 param_grid 是网格搜索中的一个参数，还有其他几个重要参数，比如 n_jobs，使用该参数可以让电脑多核并行计算以节省时间。 

![mark](http://media.makcyun.top/win/20190611/CcwhyC70qza8.png?imageslim)

![mark](http://media.makcyun.top/win/20190611/kInXgUxtqlBA.png?imageslim)

更多网格搜索参数可以在[官网](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.GridSearchCV.html)了解它的 API，之后我们在讲**交叉验证**（Cross-Validation，GridSearchCV 的 CV）的时候还会再来介绍它。

前后这两篇文章我们介绍了 kNN 模型和网格搜索的超参数问题，通过调参能进一步获得更好的 kNN 模型，但是影响 kNN 模型的好坏还有一个至关重要的因素，就是**距离（数据）的归一化问题**，下一篇文章来介绍。

本文的 jupyter notebook 代码，可以在我公众号：「**高级农民工**」后台回复「**kNN7**」得到，加油！

Changelog

- 其实 p 和 weights 权重没有关系，p 是计算距离的，weights 为 uniform 或者 distance 都可以使用不同的 p。：2019/7/2