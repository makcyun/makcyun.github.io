---
title: 线性回归 Statsmodels 模型预测波士顿房价
id: Machine_learning05
date: 2019-5-12 16:16:16
categories: 机器学习
tags: [机器学习]
images: http://media.makcyun.top/win/20190402/z29AGjNfcl4c.jpg?imageslim
keywords: [线性回归波士顿房价预测,线性回归]
---

机器学习之线性回归。

<!-- more -->  

线性回归是入门机器学习的第一课。波士顿房价数据集是建立线性回归的一个很好案例，下面将分别使用 Statsmodels 和 Sklearn 模型建立线性回归模型，最终预测该地区房价。本文先使用 Statsmodels 模型。

这份 [数据来源](https://www.cs.toronto.edu/~delve/data/boston/bostonDetail.html) 于 1978 年发表的一份杂志上，数据量很小一共只有 506 行 * 14 列，各特征变量含义如下：

```python
CRIM: 城镇人均犯罪率，百分比%
ZN: 住宅用地所占比例，百分比%
INDUS: 城镇中非住宅用地所占比例，百分比%
CHAS: CHAS 虚拟变量，用于回归分析
NOX: 环保指数
RM: 每栋住宅的房间数
AGE: 1940 年以前建成的自住单位的比例，百分比%
DIS: 距离 5 个波士顿的就业中心的加权距离
RAD: 距离高速公路的便利指数
TAX: 每一万美元的不动产税率,百分比%
PTRATIO: 城镇中的教师学生比例，百分比%
B: 关于黑人比例的一个参数
LSTAT: 地区中有多少房东属于低收入人群，百分比%
MEDV: 自住房屋房价中位数（也就是均价），单位 $1000 美元
```

### 加载数据

数据集包含 sklearn 包中，只需要两行代码就可以加载：

```python
from sklearn import datasets
data = datasets.load_boston()
```

查看数据集相关特征，可以用这些方法：

```python
data.DESCR # 查看数据集描述
data.feature_names # 查看特征变量名 
data.target # 查看目标变量数据
data.data # 查看自变量数据
```

大致结果如下：

```python
Boston House Prices dataset
===========================

Notes
------
Data Set Characteristics:  

    :Number of Instances: 506 

    :Number of Attributes: 13 numeric/categorical predictive
    
    :Median Value (attribute 14) is usually the target

    :Attribute Information (in order):
        - CRIM     per capita crime rate by town
        - ZN       proportion of residential land zoned for lots over 25,000 sq.ft.
        - INDUS    proportion of non-retail business
 ...
---

['CRIM' 'ZN' 'INDUS' 'CHAS' 'NOX' 'RM' 'AGE' 'DIS' 'RAD' 'TAX' 'PTRATIO'
 'B' 'LSTAT']

---
...
```

为便于后续建模，把数据集转换为 DataFrame 格式：

```python
# 将数据集转为 dataframe 格式 
import pandas as pd 
boston = pd.DataFrame(data.data,columns=data.feature_names)
boston['Price'] = data.data # 因变量也加入dataframe
boston.head()
```

![](http://media.makcyun.top/Fl8FE1-L0i9YbLBhtb-YHj_kPCRl)

13 个自变量中有 6 个的单位是百分比：

- ZN
- INDUS
- AGE
- TAX
- PTRATIO
- LSTAT

接下来把数据拆分为训练集和测试集，可以用 train_test_split ，也可以用 shuffle：

```python
"""
方法1 train_test_split
"""
from sklearn.model_selection import train_test_split
col_x = boston.columns[:-1]
train, test = train_test_split(boston, test_size=0.2, random_state=123)
print(train.shape)
print(test.shape)

# output：
(404, 14)
(102, 14)
```

用 shuffle：

```python
"""
方法2 shuffle
"""
from sklearn.utils import shuffle 
x,y = shuffle(boston[col_x],boston['Price'],random_state=124)
offset = int(x.shape[0]*0.8)
x_train ,y_train= x[:offset],y[:offset]
x_test ,y_test= x[offset:],y[offset:]
```

数据集划分好后，测试集就放在一边不动，直到模型型建立好后再来用它。



### 探索性数据分析

下面对测试集数据做简单的探索性分析，即：EDA（Exploratory Data Analysis），以便快速了解特征变量情况，比如是数值/类别/还是字符变量，为后面特征工程做准备。

```python
boston.info()
# output：
RangeIndex: 506 entries, 0 to 505
Data columns (total 14 columns):
CRIM       506 non-null float64
ZN         506 non-null float64
INDUS      506 non-null float64
CHAS       506 non-null float64
NOX        506 non-null float64
RM         506 non-null float64
AGE        506 non-null float64
DIS        506 non-null float64
RAD        506 non-null float64
TAX        506 non-null float64
PTRATIO    506 non-null float64
B          506 non-null float64
LSTAT      506 non-null float64
Price      506 non-null float64
dtypes: float64(14)
```

可以看到全部自变量都是数值值，且没有缺失值，属于很理想的数据集，实际项目中会比这要复杂很多，不过鉴于我们用这个数据集是初步学习线性回归，数据集简单些也好，重心好放在后面的模型建立和检验部分。

先了解数据集分布情况：

```python
boston.describe().round(2)
# output：
```

![](http://media.makcyun.top/FpVfZiuyvI5RqCSVx82Yo-7TT-sD)

重点看一下因变量 Price 房价情况，平均房价是 22.53，单位是千美元，也就是房价均值是 2 万多美元，数据来源于 1978 年，可见房价并不便宜。

绘制直方图进一步查看房价的分布：

![](http://media.makcyun.top/Fg4jwfUcPG4JieAvAoX1hDuJZPbD)

同红色标准正态分布曲线对比，可以看到数据集呈右偏趋势，且峰度较高，另外数据集在 50 处被截断了。在后续建模时可能需要处理转化为标准正态分布。

代码实现如下：

```python
import matplotlib.pyplot as plt 
import seaborn as sns
import scipy.stats as stats 

sns.set(rc={'figure.figsize':(8,6),'font.sans-serif':['simhei','Arial']})  #设置字体，避免中文不显示
sns.distplot(train.Price,bins=20,
            fit = stats.norm, # 拟合标准正态分布
            kde_kws={'label':'核密度曲线'},
            fit_kws={'color':'red','label':'标准正态分布曲线'}
            )
plt.legend()
```

> seaborn 绘图中文容易变成方框不显示，需要额外设置中文字体

查看各变量同因变量之间的相关性：

```python
train.corrwith(train.Price).sort_values(ascending=False)
# output:
Price      1.000000
RM         0.716973
ZN         0.360129
B          0.327933
DIS        0.255739
CHAS       0.119402
AGE       -0.380633
CRIM      -0.386443
RAD       -0.392065
NOX       -0.436879
TAX       -0.493560
INDUS     -0.496211
PTRATIO   -0.506643
LSTAT     -0.746059
dtype: float64
```

可以看到跟因变量相关系数比较高的自变量有：

- RM：每栋住宅房间数，呈正相关，很好理解，房间数越多房价一般越高；
- LSTAT：所在地区房东属于低收入人群比例，呈负相关，也好理解，低收入比例越高说明该地区整体比较穷，房价自然就低；
- PTRATIO：教师与学生的比例，呈负相关，也好理解，类似国内的学区房，资源越好的地方，学生比老师多地多，该比例低，而房价会很高。

还可以详细查看一下各变量之间的相关系数：

![mark](http://media.makcyun.top/win/20190512/azgy1nhzdwt9.jpg?imageslim)

```python
import statsmodels.api as sm
sns.set(style='ticks',rc={'figure.figsize':(12,12)})

train_corr = train.corr()
sns.set(style='ticks',rc={'figure.figsize':(10,10)})
sns.heatmap(train_corr,cbar=True,annot=True,square=True,fmt='0.2f',annot_kws={'size':12})
```

> annot=True 可以添加相关系数

以上初步确定了跟因变量相关系数比较高的几个变量，另外我们还可以使用 SelectKBest 方法直接筛选自变量：

```python
from sklearn.feature_selection import SelectKBest,f_regression
X1 = train.iloc[:,:13]
selector = SelectKBest(f_regression,k=3) # k：筛选k个变量
selector.fit_transform(X1,train['Price'])
X1.columns[selector.get_support(indices=True)].tolist()
#output:
['RM', 'PTRATIO', 'LSTAT']
```

我们这里假设筛选出了 3 个最相关的变量，结果和前面一致。

由于下面我们需要先练习一元线性回归，那么只需要一个自变量，这里更改 k 值为 1能够得到最相关的自变量为：LSTAT。下面，就利用这个自变量使用 StatsModels 模型建立房价的一元线性回归。



### 一元线性回归

ChangeLog

- 2019/5/12 建立