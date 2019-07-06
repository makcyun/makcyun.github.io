---
title: 【机器学习04】Sklearn 的 model.score 和 accuracy_score 函数
id: Machine_learning06
date: 2019-6-9 16:16:16
categories: 机器学习
tags: [机器学习]
images: http://media.makcyun.top/win/20190608/YA17J1xobvgy.png?imageslim
keywords: [机器学习K近邻算法,sklearn model.score]
---

手写 kNN模型分类准确度。

<!-- more -->  

**摘要：**手写 kNN 模型分类准确度，理解 Sklearn 的 model.score 和 accuracy_score 函数。

上一篇文章我们手写了划分数据集的函数，把 178 个葡萄酒数据集划分成了 124 个训练样本和 54 个测试样本。

数据准备好之后，我们下面就使用 kNN 模型来训练这份数据集，最后通过模型得分来评价分类效果。

### 调用 Sklearn 中的模型得分库

先来调用 Skearn 中的 kNN 模型计算模型得分：

![mark](http://media.makcyun.top/win/20190608/akpvCsDffa0t.png?imageslim)

只需要几行代码， Sklearn 就训练好了 kNN模型，并且给出了 0.76 的模型得分。也就是说这个 kNN 模型在 54 个红酒样本测试集上，正确分类出了 76% 的样本，剩下 24% 则预测错了，结果不坏但也算不上好。可以进一步优化模型，之后的文章我们再讲。

现在我们想搞明白 **Sklearn 如何计算模型得分**的。

上面 Sklearn 使用了两种方法计算模型得分，一种是调用包，即：

 `from sklearn.metrics import accuracy_score`

accuracy_score 函数利用 y_test 和 y_predict 计算出得分，这种方法需要先计算出 y_predict。而有些时候我们并不需要知道 y_predict ，而只关心模型最终的得分，那么可以跳过 predict 直接计算得分么，答案是可以的，就是第二种方法。

一行代码就能计算出来，更为简洁：

```python
kNN_clf.score(X_test,y_test)
```

这行代码直接利用 X_test 和 y_test 就计算出得分，和第一种方法结果一样。

下面，我们就来深入了解一下 Sklearn 是如何计算模型得分的，仍然选择手写实现。

### 手写分类准确度算法

这里为了多加练习，不使用 Sklearn 的 kNN 模型而使用之前手写的，调用 kNN_sklearn.py 中的 kNNCliassifier 类即可。

![mark](http://media.makcyun.top/win/20190608/LnzOSsxE31tG.png?imageslim)

先用 X_train 和 y_train 进行 fit  拟合，之后用 X_test predict 预测出新的标签值 y_predict。

计算模型得分很简单，使用 np.sum 函数统计 y_predict 和 y_test 值相同的样本数再除以总测试样本数即可。

模型得 0.74 分，和刚才 Sklearn 计算出的 0.76 略有出入，是因为 Sklearn 的使用的算法和我们写的不同更加复杂。

下面，我们把计算得分的函数封装起来，像 Sklearn 中的 accuracy_score 函数一样进行调用。

新建一个名为 metrics_score.py 程序保存在 train_test 文件夹下：

文件目录层级如下：

```python
kNN/
	train_test_split.ipynb
	train_test/
    	__init__.py
        model_selection.py
        kNN_sklearn.py
        metrics_score.py
```

metrics_score.py 文件如下：

```python
import numpy as np
def accuracy_score(y_test, y_predict):
    assert y_test.shape[0] == y_predict.shape[0], "预测的y值和测试集的y值行数要一样"
    return sum(y_test == y_predict) / len(y_predict)
```

调用该函数就可以得到一样的结果：

```python
from train_test.metrics_score import accuracy_score
accuracy_score(y_test,y_predict)

[out]：0.7407407407407407

```

Sklearn 的第二种方法是直接调用 model.score 方法得到模型分数，我们仍然可以尝试做到。

打开之前手写的 kNN_sklearn.py 程序，添加一个 `score` 函数即可：

```python
from .metrics_score import accuracy_score
def score(self,X_test,y_test):
    y_predict = self.predict(X_test)
    return accuracy_score(y_test,y_predict)
```

这个函数通过调用自身的 predict 函数计算出 y_predict ，传入上面的 accuracy_score 函数中得到模型得分，然后调用 model 即可计算出：

```python
kNN_clf.score(X_test,y_test)
```

![mark](http://media.makcyun.top/win/20190608/8DW5h2yaF97r.png?imageslim)

三种方法得到的结果是一样的，对 Sklearn 的 model.score 和 accuracy_score 两个计算模型得分的函数理解会更深刻。

通过昨天和今天的两篇文章，我们初步学会了用 kNN 算法去解决葡萄酒分类问题并且计算出模型得分，对模型好坏有了大致判断。下一篇文章我们以两个常见的数据集**鸢尾花**和**手写数字识别**为例，完整地走一遍 kNN算法。

本文的 jupyter notebook 代码，可以在我公众号：「**高级农民工**」后台回复「**kNN4**」得到，加油！

