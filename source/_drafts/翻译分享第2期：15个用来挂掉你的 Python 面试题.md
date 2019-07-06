---
title: 美国 IT 大牛建议：2019 年如何学习数据科学
id: translating01
date: 2019-2-21 16:16:16
categories: Python学习
tags: [数据科学]
images: http://media.makcyun.top/stock-photo-142658051.jpg
keywords: [学习数据科学]
---
初学 / 转行 Python 的困惑，这里都有答案。

<!-- more -->  

**摘要**：初学、转行 Python 的困惑，这里都有答案。

作者 | Thomas Nield 

来源 | [They Use These 15+ Python Interview Questions To Fail You ](https://blog.finxter.com/python-interview-questions/)

# They Use These 15+ Python Interview Questions To Fail You 



害怕你的编码面试？本文将向您介绍如何使您的编码面试成功。

## 准备面试的一般提示 

- 观看[Google面试技巧](https://www.youtube.com/watch?v=qc1owf2-220)。
- 阅读[Philip Guo 教授的建议](http://www.pgbovine.net/programming-interview-tips.htm)。
- 在Google文档中练习编码。不要在训练时使用代码突出显示编辑器。
- 解决至少[50多个代码难题](http://finxter.com/)。
- 最重要的是：**不要惊慌**。



## 编程面试应该做哪些准备 

By reading this article, you will learn about these 15 popular interview questions. Feel free to jump ahead to any question that interests you most.

- [问题1：从整数列表1-100中获取缺失的数字。](https://blog.finxter.com/python-interview-questions/#1)
- [问题2：在整数列表中找到重复的数字。](https://blog.finxter.com/python-interview-questions/#2)
- [问题3：检查列表是否包含整数x。](https://blog.finxter.com/python-interview-questions/#3)
- [问题4：找到未排序列表中的最大和最小数字。](https://blog.finxter.com/python-interview-questions/#4)
- [问题5：在列表中查找整数对，使它们的和等于整数x。](https://blog.finxter.com/python-interview-questions/#5)
- [问题6：从整数列表中删除所有重复项。](https://blog.finxter.com/python-interview-questions/#6)
- [问题7：使用Quicksort算法对列表进行排序。](https://blog.finxter.com/python-interview-questions/#7)
- [问题8：使用Mergesort算法对列表进行排序。](https://blog.finxter.com/python-interview-questions/#8)
- [问题9：检查两个字符串是否是字谜。](https://blog.finxter.com/python-interview-questions/#9)
- [问题10：计算两个列表。](https://blog.finxter.com/python-interview-questions/#10)
- [问题11：使用递归反转字符串。](https://blog.finxter.com/python-interview-questions/#11)
- [问题12：查找字符串的所有排列。](https://blog.finxter.com/python-interview-questions/#12)
- [问题13：检查字符串是否是回文。](https://blog.finxter.com/python-interview-questions/#13)
- [问题14：计算前n个斐波纳契数。](https://blog.finxter.com/python-interview-questions/#14)
- [问题15：使用列表作为堆栈，数组和队列。](https://blog.finxter.com/python-interview-questions/#15)
- [问题16：在O（log n）中搜索已排序的列表。](https://blog.finxter.com/python-interview-questions/#16)

为了让您轻松学习这些问题，我创建了这篇**Python采访备**

To make it easy for you to learn these questions, I have created this **Python Interview Cheat Sheet** with 14 interview questions from this article.

![img](https://blog.finxter.com/wp-content/uploads/2018/11/CheatSheet-Python-6-Coding-Interview-Questions-Email-Course-Ad-1.png)



### **问题1：从整数列表1-100中获取缺失的数字。**

```python3
def get_missing_number(l):
	nxt = 1
	while nxt < len(l):
		if nxt != l[nxt-1]:
			return nxt
		nxt = nxt + 1
```



There are many other ways to solve this problem (and more concise ones). For example, you can create a set of numbers from 1 to 100 and remove all elements in the list l. This is an elegant solution as it returns not one but all numbers that are missing in the sequence. Here is this solution:



1. set(range(l[len(l)-1])[1:]) - set(l)



### **Question 2: Find duplicate number in integer list.** 

Say we have a list of integer numbers called *elements*. The goal is to create a function that finds ALL integer elements in that list that are duplicated, i.e., that exist at least two times in the list. For example, when applying our function to the list *elements*=[2, 2, 3, 4, 3], it returns a new list [2, 3] as integer elements 2 and 3 are duplicated in the list *elements*. In an interview, before even starting out with “programming on paper”, you should always ask the interviewer back with concrete examples to show that you have understood the question. 

So let’s start coding. Here is my first attempt:



1. **def** find_duplicates(elements):
2. 
3. duplicates = set()
4. seen = set() 
5. 
6. **for** element **in** elements:
7.   **if** element **in** seen: # O(1) operation
8. ​    duplicates.add(element)
9.   seen.add(element)
10. **return** list(duplicates)
11. 
12. l = [2, 2, 2, 3, 4, 3, 6, 4, 3]
13. print(find_duplicates(l))
14. \# [2, 3, 4]



Note that the runtime complexity is pretty good. We iterate over all elements once in the main loop. The body of the main loop has constant runtime because I have selected a set for both variables “duplicates” and “seen”. Checking whether an element is in a set, as well as adding an element to the set has constant runtime (O(1)). Hence, the total runtime complexity is linear in the input size.

### **Question 3: Check if a list contains an integer x.** 

This is a very easy problem. I don’t know why an interviewer would ask such simple questions – maybe it’s the first “warm-up” question to make the interviewed person feel more comfortable. Still, many people reported that this was one of their interview questions. 

To check whether a Python list contains an element x in Python, could be done by iterating over the whole list and checking whether the element is equal to the current iteration element. In fact, this would be my choice as well, if the list elements were complex objects that are not hashable.

However, the easy path is often the best one. The interview question explicitly asks for containment of an integer value x. As integer values are hashable, you can simply use the Python “in” keyword as follows.



1. l = [3, 3, 4, 5, 2, 111, 5]
2. **print**(111 **in** l)
3. \# True



### **Question 4: Find the largest and the smallest number in an unsorted list.** 

Again, this question is a simple question that shows your proficient use with the basic Python keywords. Remember: you don’t have a fancy editor with source code highlighting! Thus, if you do not train coding in Google Docs, this may be a serious hurdle. Even worse: the problem is in fact easy but if you fail to solve it, you will instantly fail the interview! NEVER UNDERESTIMATE ANY PROBLEM IN CODING! 

Here is a simple solution for Python:



1. l = [4, 3, 6, 3, 4, 888, 1, -11, 22, 3]
2. print(max(l))
3. \# 888
4. **print**(min(l))
5. \# -11



It feels like cheating, doesn’t it? But note that we didn’t even use a library to solve this interview question. Of course, you could also do something like this:



1. **def** find_max(l):
2.   maxi = l[0]
3.   **for** element **in** l:
4. ​    **if** element > maxi:
5. ​      maxi = element
6.   **return** maxi
7. l = [4, 3, 6, 3, 4, 888, 1, -11, 22, 3]
8. **print**(max(l))
9. \# 888



Which version do you prefer?

### **Question 5: Find pairs of integers in a list so that their sum is equal to the integer x.** 

This problem is interesting. The straightforward solution is to use two nested for loops and check for each combination of elements whether their sum is equal to integer x. Here is what I mean:



1. **def** find_pairs(l, x):
2.   pairs = []
3.   **for** (i, element_1) **in** enumerate(l):
4. ​    **for** (j, element_2) **in** enumerate(l[i+1:]):
5. ​      **if** element_1 + element_2 == x:
6. ​        pairs.add((element_1, element_2))
7.   **return** pairs
8. 
9. l = [4, 3, 6, 3, 4, 888, 1, -11, 22, 3]
10. print(find_pairs(l, 9))



Fail! It throws an exception: “AttributeError: ‘list’ object has no attribute ‘add’”

This is what I meant: it’s easy to underestimate the difficulty level of the puzzles, only to learn that you did a careless mistake again. So the corrected solution is this:



1. **def** find_pairs(l, x):
2.   pairs = []
3.   **for** (i, element_1) **in** enumerate(l):
4. ​    **for** (j, element_2) **in** enumerate(l[i+1:]):
5. ​      **if** element_1 + element_2 == x:
6. ​        pairs.append((element_1, element_2))
7.   **return** pairs
8. 
9. l = [4, 3, 6, 3, 4, 888, 1, -11, 22, 3]
10. print(find_pairs(l, 9))



Now it depends whether your interviewer will accept this answer. The reason is that you have a lot of duplicated pairs. If he asked you to remove them, you could simply do a post-processing by removing all the duplicates from the list.

Actually, this is a common interview question as well (see next question).

Here is another beautiful one-liner solution submitted by one of our readers:



1. \# Solution from user Martin 
2. l = [4, 3, 6, 4, 888, 1, -11, 22, 3] 
3. match = 9
4. res = set([(x, match - x) **for** e, x **in** enumerate(l) **if** x <= match / 2 **and** match - x **in** l[:e] + l[e+1:]]) **print**(res) 



### **Question 6: Remove all duplicates from an integer list.** 

Given a list, the goal is to remove all elements, which exist more than once in the list. Note that you should be careful not to remove elements while iterating over a list. 

Wrong example of modifying a list while iterating over it (don’t try this at home): 



1. lst = list(range(10))
2. **for** element **in** lst:
3.   **if** element>=5:
4. ​    lst.remove(element)
5. 
6. **print**(lst)
7. \# [0, 1, 2, 3, 4, 6, 8]



As you can see, modifying the sequence over which you iterate causes unspecified behavior. After it removes the element 5 from the list, the iterator increases the index to 6. The iterator assumes this is the next element in the list. However, that’s not the case. As we have removed the element 5, element 6 is now at position 5. The iterator simply ignores the element. Hence, you get this unexpected semantics. 

Yet, there is a much better way how to remove duplicates in Python. You have to know that sets in Python allow only a single instance of an element. So after converting the list to a set, all duplicates will be removed by Python. In contrast of the naive approach (checking all pairs of elements whether they are duplicates), this method has linear runtime complexity. The reason is that creation of a set is linear in the number of set elements. Now, we simply have to convert the set back to a list and voilà, the duplicates are removed.



1. lst = list(range(10)) + list(range(10))
2. lst = list(set(lst))
3. **print**(lst)
4. \# [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
5. 
6. \# Does this also work for tuples? Yes!
7. 
8. lst = [(10,5), (10,5), (5,10), (3,2), (3, 4)]
9. lst = list(set(lst))
10. **print**(lst)
11. \# [(3, 4), (10, 5), (5, 10), (3, 2)]



### **Question 7: Sort a list with the Quicksort algorithm.** 

This is a difficult problem to solve during a coding interview. In my opinion, most software developers are not able to write the Quicksort algorithm correctly in a Google document. Still, we will do it, won’t we?

The main idea of [Quicksort ](https://en.wikipedia.org/wiki/Quicksort)is to select a pivot element and then placing all elements that are larger or equal than the pivot element to the right and all elements that are smaller than the pivot element to the left. Now, you have divided the big problem of sorting the list into two smaller subproblems: sorting the right and the left partition of the list. What you do now is to repeat this procedure recursively until you obtain a list with zero elements. This list is already sorted, so the recursion terminates. Here is the quicksort algorithm as a Python one-liner:



1. **def** qsort(L):
2. ​    **if** L == []: **return** []
3. ​    **return** qsort([x **for** x **in** L[1:] **if** x< L[0]]) + L[0:1] + qsort([x **for** x **in** L[1:] **if** x>=L[0]])
4. lst = [44, 33, 22, 5, 77, 55, 999]
5. print(qsort(lst))
6. \# [5, 22, 33, 44, 55, 77, 999]



### **Question 8: Sort a list with the Mergesort algorithm.** 

It can be quite difficult to code the [Mergesort](https://en.wikipedia.org/wiki/Merge_sort) algorithm under emotional and time pressure. So take your time now understanding it properly.

The idea is to break up the list into two sublists. For each of the sublist, you now call merge sort in a recursive manner. Assuming that both lists are sorted, you now merge the two sorted lists. Note that it is very efficient to merge two sorted lists: it takes only linear time in the size of the list.

Here is the algorithm solving this problem. 



1. **def** msort(lst):
2.   **if** len(lst)<=1: **return** lst
3.   left = msort(lst[:len(lst)//2])
4.   right = msort(lst[len(lst)//2:])
5.   **return** merge(left, right)
6. 
7. 
8. **def** merge(lst1, lst2):
9.   **if** len(lst1)==0: **return** lst2
10.   **if** len(lst2)==0: **return** lst1
11.   merged_list = []
12.   index_lst1 = 0
13.   index_lst2 = 0
14.   **while** len(merged_list) < (len(lst1) + len(lst2)):
15. ​    **if** lst1[index_lst1] < lst2[index_lst2]:
16. ​      merged_list.append(lst1[index_lst1])
17. ​      index_lst1 += 1
18. ​      **if** index_lst1 == len(lst1):
19. ​        merged_list += lst2[index_lst2:]
20. ​    **else**:
21. ​      merged_list.append(lst2[index_lst2])
22. ​      index_lst2 += 1
23. ​      **if** index_lst2 == len(lst2):
24. ​        merged_list += lst1[index_lst1:]
25.   **return** merged_list
26. 
27. 
28. lst = [44, 33, 22, 5, 77, 55, 999]
29. print(msort(lst))
30. \# [5, 22, 33, 44, 55, 77, 999]



### Question 9: Check if two strings are anagrams.

You can find this interview question at so many different places online. It is one of the most popular interview questions.

The reason is that most students who have pursued an academic education in computer science, know exactly what to do here. It serves as a filter, a secret language, that immediately reveals whether you are in or out of this community. 

In fact, it is nothing more. Checking for anagrams has little to no practical applicability. But it’s fun, I have to admit!

**So what are anagrams?** Two words are anagrams if they consist of exactly the same characters. [Wikipedia ](https://en.wikipedia.org/wiki/Anagram)defines it a bit more precisely: *“An anagram is a word or phrase formed by rearranging the letters of a different word or phrase, typically using all the original letters exactly once”*.

Here are a few examples:

- “listen” → “silence”
- “funeral” → “real fun”
- “elvis” → “lives”

![img](https://blog.finxter.com/wp-content/uploads/2018/11/Anagram.png)

Ok, now you know exactly what to do, right? So let’s start coding.





1. **def** is_anagram(s1, s2):
2. ​    **return** set(s1) == set(s2)
3. 
4. s1 = "elvis"
5. s2 = "lives"
6. s3 = "not"
7. s4 = "hello"
8. 
9. **print**(is_anagram(s1, s2)) # True
10. print(is_anagram(s2, s3)) # False
11. print(is_anagram(s2, s4)) # False
12. print(is_anagram(s2, s1)) # True



As you can see, the program solves the problem efficiently and correctly. But this was not my first attempt. I suffered the old weakness of programmers: starting to code to early. I used a hands-on approach and created a recursive function is_anagram(s1, s2). I used the observation that s1 and s2 are anagrams iff (1) they have two equal characters and (2) they are still anagrams if we remove these two characters (the smaller problem). While this solution worked out, it also sucked out 10 minutes of my time. 

While thinking about the problem, it struck me: why not using a bag-of-characters approach? **Two strings are anagrams if they consist of the same set of characters.** It’s that easy.

I am sure, without looking it up, that converting the strings to sets and comparing the sets (as done in the code) is the cleanest solution to this problem.

### **Question 10: Compute the intersection of two lists.**

This problem seems to be easy (be careful!). Of course, if you have some library knowledge (like numpy), you could solve this problem with a single function call. For example, Python’s library for linear algebra (numpy) has an implementation of the intersection function. Yet, we assume that we do NOT have any library knowledge in the coding interview (it’s a much safer bet).

The intersection function takes two lists as input and returns a new list that contains all elements that exist in both lists.

Here is an example of what we want to do:

- intersect([1, 2, 3], [2, 3]) → [2, 3]
- intersect([“hi”, “my”, “name”, “is”, “slim”, “shady”], [“i”, “like”, “slim”]) → [“slim”]
- intersect([3, 3, 3], [3, 3]) → [3, 3]

You can use the following code to do this.



1. **def** intersect2(lst1, lst2):
2. ​    res = []
3. ​    lst2_copy = lst2[:]
4. ​    **for** el **in** lst1:
5. ​        **if** el **in** lst2_copy:
6. ​            res.append(el)
7. ​            lst2_copy.remove(el)
8. ​    **return** res
9. 
10. 
11. \# Are the results ok?
12. print(intersect([1, 2, 3], [2, 3]))
13. \# [2, 3]
14. **print**(intersect("hi my name is slim shady".split(" "),
15. ​                "i like slim".split(" ")))
16. \# ['slim']
17. print(intersect([3, 3, 3], [3, 3]))
18. \# [3, 3]
19. 
20. \# Are the original lists untouched?
21. lst1 = [4, 4, 3]
22. lst2 = [3, 4, 2]
23. print(intersect(lst1, lst2))
24. \# [4, 3]
25. ​      
26. print(lst1)
27. \# [4, 4, 3]
28. print(lst2)
29. \# [3, 4, 2]



So, we got the semantics right which should be enough to pass the interview. The code is correct and it ensures that the original list is not touched.

But is it really the most concise version? I don’t think so! My first idea was to use sets again on which we can perform operations such as set intersection. But when using sets, we lose the information about duplicated entries in the list. So a simple solution in this direction is not in sight.

Then, I was thinking about [list comprehension](https://docs.python.org/3/tutorial/datastructures.html). Can we do something on these lines? The first idea is to use list comprehension like this:



1. **def** intersect(lst1, lst2):
2. ​    lst2_copy = lst2[:]
3. ​    **return** [x **for** x **in** lst1 **if** lst2.remove(x)]



However, do you see the problem with this approach? 

The problem is that intersect([4, 4, 3], [4, 2]) returns [4, 4]. This is a clear mistake! It’s not easy to see – I have found many online resources which simply ignore this problem…

The number 4 exists twice in the first list but if you check “4 in [4, 2]”, it returns True – no matter how often you check. That’s why we need to remove the integer number 4 from the second list after finding it the first time.

This is exactly what I did in the above code. If you have any idea how to solve this with list comprehension, please let me know (admin@finxter.com)!

### Question 11: Reverse string using recursion

Now let’s move on to the next problem: reversing a string using recursion. 

Here is what we want to achieve:

- “hello” → “olleh”
- “no” → “on”
- “yes we can” → “nac ew sey”

There is a restriction on your solution: you have to use recursion. Roughly speaking, the function should call itself on a smaller problem instance.

[Wikipedia ](https://en.wikipedia.org/wiki/Recursion)explains recursion in an understandable way:

> *“Recursion in computer programming is exemplified when a function is defined in terms of simpler, often smaller versions of itself. The solution to the problem is then devised by combining the solutions obtained from the simpler versions of the problem.”*

Clearly, the following strategy would solve the problem in a recursive way. First, you take the first element of a string and move it to the end. Second, you take the rest of the string and recursively repeat this procedure until only a single character is left.

Here is the code:



1. **def** reverse(string):
2. ​    **if** len(string)<=1:
3. ​        **return** string
4. ​    **else**:
5. ​        **return** reverse(string[1:]) + string[0]
6. 
7. 
8. phrase1 = "hello"
9. phrase2 = "no"
10. phrase3 = "yes we can"
11. 
12. print(reverse(phrase1))
13. \# olleh
14. **print**(reverse(phrase2))
15. \# on
16. print(reverse(phrase3))
17. \# nac ew sey



The program does exactly what I described earlier: moving the first element to the end and calling the function recursively on the remaining string.

### Question 12: Find all permutations of a string

This is a common problem of many coding interviews. Similar to the anagrams problem presented in the question above, the purpose of this question is twofold. First, the interviewers check your creativity and ability to solve algorithmic problems. Second, they check your pre-knowledge of computer science terminology. 

**What is a permutation?** You get a permutation from a string by reordering its characters. Let’s go back to the anagram problem. Two anagrams are permutations from each other as you can construct the one from the other by reordering characters. 

Here are all permutations from a few example strings:

- ‘hello’ → {‘olhel’, ‘olhle’, ‘hoell’, ‘ellho’, ‘lhoel’, ‘ollhe’, ‘hlleo’, ‘lhloe’, ‘hello’, ‘lhelo’, ‘hlelo’, ‘eohll’, ‘oellh’, ‘hlole’, ‘lhole’, ‘lehlo’, ‘ohlel’, ‘oehll’, ‘lleoh’, ‘olleh’, ‘lloeh’, ‘elhol’, ‘leolh’, ‘ehllo’, ‘lohle’, ‘eolhl’, ‘llheo’, ‘elhlo’, ‘ohlle’, ‘lohel’, ‘elohl’, ‘helol’, ‘loehl’, ‘lheol’, ‘holle’, ‘elloh’, ‘llhoe’, ‘eollh’, ‘olehl’, ‘lhleo’, ‘loleh’, ‘ohell’, ‘leohl’, ‘lelho’, ‘olelh’, ‘heoll’, ‘ehlol’, ‘loelh’, ‘llohe’, ‘lehol’, ‘holel’, ‘hleol’, ‘leloh’, ‘elolh’, ‘oelhl’, ‘hloel’, ‘lleho’, ‘eholl’, ‘hlloe’, ‘lolhe’}
- ‘hi’ → {‘hi’, ‘ih’}
- ‘bye’ → {‘bye’, ‘ybe’, ‘bey’, ‘yeb’, ‘eby’, ‘eyb’}

Conceptually, you can think about a string as a bucket of characters. Let’s say the string has length n. In this case, you have n positions to fill from the bucket of n characters. Having filled all n positions, you obtain a permutation from the string. You want to find ALL such permutations.

My first idea is to **solve this problem recursively**. Suppose, we already know all permutations from a string with n characters. Now, we want to find all permutations with n+1 characters by adding a character x. We obtain all such permutations by inserting x into each position of an existing permutation. We repeat this for all existing permutations.

However, as a rule-of-thumb: **avoid overcomplicating the problem in a coding interview at all costs!** Don’t try to be fancy! (And don’t use recursion – that is a logical conclusion from the previous statements…)

So is there an easier iterative solution? Unfortunately, I could not find a simple iterative solution (there is the [Johnson-Trotter algorithm](https://en.wikipedia.org/wiki/Steinhaus%E2%80%93Johnson%E2%80%93Trotter_algorithm) but this is hardly a solution to present at a coding interview).

Thus, I went back to implement the recursive solution described above. (**Teeth-gnashingly**)





1. **def** get_permutations(word):
2. 
3. ​    \# single word permutations
4. ​    **if** len(word)<=1:
5. ​        **return** set(word)
6. 
7. ​    \# solve smaller problem recursively
8. ​    smaller_perms = get_permutations(word[1:])
9. 
10. ​    \# find all permutation by inserting the first character
11. ​    \# to each position of each smaller permutation
12. ​    perms = set()
13. ​    **for** small_perm **in** smaller_perms:
14. ​        **for** pos **in** range(0,len(small_perm)+1):
15. ​            perm = small_perm[:pos] + word[0] + small_perm[pos:]
16. ​            perms.add(perm)
17. ​    **return** perms
18. 
19. ​        
20. 
21. print(get_permutations("nan"))
22. print(get_permutations("hello"))
23. print(get_permutations("coffee"))
24. 
25. \# {'nna', 'ann', 'nan'}
26. \# {'olhel', 'olhle', 'hoell', 'ellho', 'lhoel', 'ollhe', 'hlleo', 'lhloe', 'hello', 'lhelo', 'hlelo', 'eohll', 'oellh', 'hlole', 'lhole', 'lehlo', 'ohlel', 'oehll', 'lleoh', 'olleh', 'lloeh', 'elhol', 'leolh', 'ehllo', 'lohle', 'eolhl', 'llheo', 'elhlo', 'ohlle', 'lohel', 'elohl', 'helol', 'loehl', 'lheol', 'holle', 'elloh', 'llhoe', 'eollh', 'olehl', 'lhleo', 'loleh', 'ohell', 'leohl', 'lelho', 'olelh', 'heoll', 'ehlol', 'loelh', 'llohe', 'lehol', 'holel', 'hleol', 'leloh', 'elolh', 'oelhl', 'hloel', 'lleho', 'eholl', 'hlloe', 'lolhe'}
27. \# {'coeeff', 'ceoeff', 'ceofef', 'foecef', 'feecof', 'effeoc', 'eofefc', 'efcfoe', 'fecofe', 'eceoff', 'ceeffo', 'ecfeof', 'coefef', 'effoce', 'fceefo', 'feofce', 'fecefo', 'ocefef', 'ffecoe', 'ofcefe', 'fefceo', 'ffeoce', 'ffoeec', 'oefcfe', 'ofceef', 'efeofc', 'eefcof', 'ceffoe', 'eocfef', 'ceffeo', 'eoffec', 'ceoffe', 'fcoefe', 'cefofe', 'oeeffc', 'oeffec', 'fceeof', 'ecfofe', 'feefoc', 'ffcoee', 'feocef', 'ffceeo', 'fofcee', 'fecfoe', 'fefoec', 'eefcfo', 'eofcfe', 'ffceoe', 'ofcfee', 'ceefof', 'effoec', 'offcee', 'fofeec', 'eecffo', 'cofefe', 'feeofc', 'ecofef', 'effceo', 'cfeefo', 'ffeoec', 'eofcef', 'cffeeo', 'cffoee', 'efcefo', 'efoefc', 'eofecf', 'ffeceo', 'ofefec', 'foeecf', 'oefefc', 'oecffe', 'foecfe', 'eeffoc', 'ofecfe', 'oceeff', 'offece', 'efofce', 'fcoeef', 'fcofee', 'oefecf', 'fcefeo', 'cfefoe', 'cefoef', 'eoceff', 'ffoece', 'feofec', 'offeec', 'oceffe', 'eeoffc', 'cfoeef', 'fefcoe', 'ecoeff', 'oeecff', 'efofec', 'eeffco', 'eeofcf', 'ecfefo', 'feoefc', 'ecefof', 'feceof', 'oeefcf', 'ecffoe', 'efecfo', 'cefeof', 'fceofe', 'effeco', 'ecfoef', 'efeocf', 'ceeoff', 'foceef', 'focfee', 'eoeffc', 'efoecf', 'oefcef', 'oeffce', 'ffocee', 'efceof', 'fcfeeo', 'eoefcf', 'ocffee', 'oeceff', 'fcfeoe', 'fefeoc', 'efefco', 'cefefo', 'fecfeo', 'ffeeco', 'ofefce', 'cfofee', 'cfefeo', 'efcoef', 'ofeecf', 'eecoff', 'ffeeoc', 'eefofc', 'ecoffe', 'coeffe', 'eoecff', 'fceoef', 'foefec', 'cfeeof', 'cfoefe', 'efefoc', 'eeocff', 'eecfof', 'ofeefc', 'effcoe', 'efocef', 'eceffo', 'fefeco', 'cffeoe', 'feecfo', 'ecffeo', 'coffee', 'feefco', 'eefocf', 'fefoce', 'fofece', 'fcefoe', 'ocfeef', 'eoffce', 'efcofe', 'foefce', 'fecoef', 'cfeoef', 'focefe', 'ocfefe', 'eocffe', 'efocfe', 'feoecf', 'efecof', 'cofeef', 'fcfoee', 'oecfef', 'feeocf', 'ofecef', 'cfeofe', 'feocfe', 'efcfeo', 'foeefc'}



If you have any questions, please let me know! I was really surprised to find that there is not a Python one-liner solution to this problem. If you know one, please share it with me (admin@finxter.com)!

### Question 13: Check if a string is a palindrome. 

First things first. **What’s a palindrome?** 

> “A palindrome is a word, number, phrase, or other sequence of characters which reads the same backward as forward, such as *madam* or *racecar* or the number *10201.* “
>
> [Wikipedia](https://en.wikipedia.org/wiki/Palindrome)

Here are a few fun examples:

- “Mr. Owl ate my metal worm”
- “Was it a car or a cat I saw?”
- “Go hang a salami, I’m a lasagna hog”
- “Rats live on no evil star”
- “Hannah”
- “Anna”
- “Bob”

Now, this sounds like there is a short and concise one-liner solution in Python!



1. **def** is_palindrome(phrase):
2. ​    **return** phrase == phrase[::-1]
3. 
4. print(is_palindrome("anna"))
5. **print**(is_palindrome("kdljfasjf"))
6. print(is_palindrome("rats live on no evil star"))
7. 
8. \# True
9. \# False
10. \# True



Here is an important tip: learn slicing in Python by heart for your coding interview. You can download my free slicing book to really prepare you thoroughly for the slicing part of the interview. Just [register for my free newsletter](http://eepurl.com/dyk-en) and I will send you the version as soon as it is ready and proofreaded!

### Question 14: Compute the first n Fibonacci numbers. 

And here is … yet another toy problem that will instantly destroy your chances of success if not solved correctly. 

The Fibonacci series was discovered by the Italian mathematician Leonardo Fibonacci in 1202 and even earlier by Indian mathematicians. The series appears in unexpected areas such as economics, mathematics, art, and nature.

The series starts with the Fibonacci numbers zero and one. Then, you can calculate the next element of the series as the sum of both last elements. 

For this, the algorithm has to keep track only of the last two elements in the series. Thus, we maintain two variables a and b, being the second last and last element in the series, respectively.



1. \# Fibonacci series:
2. a, b = 0, 1
3. n = 10 # how many numbers we calculate
4. **for** i **in** range(n):
5. ​    **print**(b)
6. ​    a, b = b, a+b
7. 
8. \##1
9. \##1
10. \##2
11. \##3
12. \##5
13. \##8
14. \##13
15. \##21
16. \##34
17. \##55



For clarity of the code, I used the language feature of multiple assignments in the first and the last line.

This feature works as follows. On the left-hand side of the assignment, there is any sequence of variables such as a list or a tuple. On the right-hand side of the assignment, you specify the values to be assigned to these variables. Both sequences on the left and on the right must have the same length. Otherwise, the Python interpreter will throw an error.

Note that all expressions on the right-hand side are first evaluated before they are assigned. This is an important property for our algorithm. Without this property, the last line would be wrong as expression ‘a+b’ would consider the wrong value for ‘a’.

### Question 15: **Use a list as stack, array, and queue.** 

This problem sounds easy. But I am sure that it does what it is meant to do: separate the experienced programmers from the beginners.

To solve it, you have to know the syntax of lists by heart. And how many beginners have studied in detail how to access a list in Python? I guess not too many…

So take your time to study this problem carefully. Your knowledge about the list data structure is of great importance for your successful programming career!

Let’s start using a list in three different ways: as a stack, as an array, and as a queue.



1. \# as a list ...
2. l = []
3. l.append(3) # l = [3]
4. l.append(4) # l = [3, 4]
5. l +=  [5, 6] # l = [3, 4, 5, 6]
6. l.pop(0) # l = [4, 5, 6]
7. 
8. 
9. \# ... as a stack ...
10. l.append(10) # l = [4, 5, 6, 10]
11. l.append(11) # l = [4, 5, 6, 10, 11]
12. l.pop() # l = [4, 5, 6, 10]
13. l.pop() # l = [4, 5, 6]
14. 
15. \# ... and as a queue
16. l.insert(0, 5) # l = [5, 4, 5, 6]
17. l.insert(0, 3) # l = [3, 5, 4, 5, 6]
18. l.pop() # l = [3, 5, 4, 5]
19. l.pop() # l = [3, 5, 4]
20. 
21. **print**(l)
22. \# [3, 5, 4]



If you need some background knowledge, check out the [Python tutorial](https://docs.python.org/2/tutorial/datastructures.html) and these articles about the [stack data structure](https://en.wikipedia.org/wiki/Stack_(abstract_data_type)) and the [queue data structure](https://en.wikipedia.org/wiki/FIFO_(computing_and_electronics)). 

### Question 16: Search a sorted list in O(log n)

How to search a list in logarithmic runtime? This problem has so many practical applications that I can understand that the coding interviewers love it.

The most popular algorithm that solves this problem is the binary search algorithm. Here are some of the applications:

> “Applications of the binary search algorithm include sets, trees, dictionaries, bags, bag trees, bag dictionaries, hash sets, hash tables, maps and arrays.” 
>
> [Quora](https://www.quora.com/What-are-the-applications-of-a-binary-search)


Think about the impact of efficient searching! You use these data structures in every single non-trivial program (and in many trivial ones as well).

![img](https://blog.finxter.com/wp-content/uploads/2018/11/Binary-Search.png)

The graphic shows you the binary search algorithm at work. The sorted list consists of eight values. Suppose, you want to find the value 56 in the list. 

The trivial algorithm goes over the whole list from the first to the last element comparing each against the searched value. If your list contains n elements, the trivial algorithm results in n comparisons. Hence, the runtime complexity of the trivial algorithm is O(n). 

(If you don’t feel comfortable using the Big-O notation, refresh your knowledge of the Landau symbols [here](https://en.wikipedia.org/wiki/Big_O_notation).)

But our goal is to traverse the sorted list in logarithmic time O(log n). So we can not afford to touch each element in the list. 

The binary search algorithm in the graphic repeatedly probes the element in the middle of the list (rounding down). There are three cases: 

1. This element x is larger than the searched value 55. In this case, the algorithm ignores the right part of the list as all elements are larger than 55 as well. This is because the list is already sorted.
2. The element x is smaller than the searched value 55. This is the case, we observe in the figure. Here, the algorithm ignores the left part of the list as they are smaller as well (again, using the property that the list is already sorted).
3. The element x is equal to the searched value 55. You can see this case in the last line in the figure. Congrats, you have found the element in the list!

In each phase of the algorithm, the search space is reduced by half! This means that after a logarithmic number of steps, we have found the element!
After having understood the algorithm, it is easy to come up with the code. Here is my version of the binary search algorithm.



1. **def** binary_search(lst, value):
2. ​    lo, hi = 0, len(lst)-1
3. ​    **while** lo <= hi:
4. ​        mid = (lo + hi) // 2
5. ​        **if** lst[mid] < value:
6. ​            lo = mid + 1
7. ​        **elif** value < lst[mid]:
8. ​            hi = mid - 1
9. ​        **else**:
10. ​            **return** mid
11. ​    **return** -1
12. 
13. ​    
14. l = [3, 6, 14, 16, 33, 55, 56, 89]
15. x = 56
16. **print**(binary_search(l,x))
17. \# 6 (the index of the found element)



------

Congratulations, you made it through these 15+ wildly popular interview questions. Don’t forget to solve at least 50 Python code puzzles [here](http://finxter.com/).

Thanks for reading this article. If you have any more interview questions (or you struggle with one of the above), please write me an email to admin@finxter.com.

[∞ How it feels to learn data science in 2019](https://towardsdatascience.com/how-it-feels-to-learn-data-science-in-2019-6ee688498029)