# 多媒体信息检索期末项目 - 照片文本数据检索系统

华东师范大学计算机学院《多媒体信息检索》课程期末项目，以下为提交的文字报告。视频和 Keynote 未上传。

## 概述

这是一个照片文本数据检索系统，帮助用户快速从大量图片数据中进行文字检索。本工具支持导入、分类图片，对图片进行机器学习处理并提取其中的文字。用户可以输入关键字进行检索，支持正则表达式检索、多条件（与、或）检索和限定分类检索。

![Screen Shot 2021-12-23 at 22.32.53](https://cdn.jsdelivr.net/gh/JJAYCHEN1e/Image@2021/default/202112232232899.png)

## 导入

本工具支持直接拖拽文件来导入图片：

![Screen Shot 2021-12-23 at 22.50.28](https://cdn.jsdelivr.net/gh/JJAYCHEN1e/Image@2021/default/202112232250861.png)

导入图片后，也可以删除选中图片或删除全部图片：

![Screen Shot 2021-12-23 at 22.55.54](https://cdn.jsdelivr.net/gh/JJAYCHEN1e/Image@2021/default/202112232258282.png)

## 分类

工具内支持对照片进行归类整理，例如将选中的照片加入 Favorite 分类中：

![Screen Shot 2021-12-23 at 22.56.32](https://cdn.jsdelivr.net/gh/JJAYCHEN1e/Image@2021/default/202112232258121.png)

添加至 Favorite 分类的照片会带有 ⭐️ 标志，并且可以单独查看：

![Screen Shot 2021-12-23 at 22.57.08](https://cdn.jsdelivr.net/gh/JJAYCHEN1e/Image@2021/default/202112232258438.png)

## 自动文字提取

在图片导入后，工具会自动调用训练好的机器学习模型对其进行文字提取并展示可视化结果：

![Screen Shot 2021-12-23 at 23.00.48](https://cdn.jsdelivr.net/gh/JJAYCHEN1e/Image@2021/default/202112232301240.png)

![Screen Shot 2021-12-23 at 23.00.52](https://cdn.jsdelivr.net/gh/JJAYCHEN1e/Image@2021/default/202112232302858.png)

![Screen Shot 2021-12-23 at 23.00.57](https://cdn.jsdelivr.net/gh/JJAYCHEN1e/Image@2021/default/202112232302613.png)

## 检索

### 普通检索

输入关键字后，本工具会过滤出包含关键字的结果，并高亮包含关键字的文字。例如输入关键字 Crash，会过滤出包含 Crash 文字的图片（不区分大小写）：

![Screen Shot 2021-12-23 at 23.05.04](https://cdn.jsdelivr.net/gh/JJAYCHEN1e/Image@2021/default/202112232305857.png)

### 正则表达式检索

工具支持使用正则表达式作为关键字，例如输入关键字 `文.*楼` 可以同时检索到**文史楼**、**文附楼**：

![Screen Shot 2021-12-23 at 23.10.45](https://cdn.jsdelivr.net/gh/JJAYCHEN1e/Image@2021/default/202112232311214.png)

![Screen Shot 2021-12-23 at 23.10.11](https://cdn.jsdelivr.net/gh/JJAYCHEN1e/Image@2021/default/202112232310411.png)

### 多条件检索（与/或）

通过打开多条件检索，允许指定多个关键字（用空格分割）。多条件检索支持 AND 模式和 OR 模式。例如，在 OR 模式下检索 `结果 检查 报告 ` 就会展示包含**结果**或**检查**或**报告**的图片：

![Screen Shot 2021-12-23 at 23.19.44](https://cdn.jsdelivr.net/gh/JJAYCHEN1e/Image@2021/default/202112232321825.png)

在 AND 模式下检索 `文史楼 文附楼 ` 就会展示包含**文史楼**和**文附楼**的图片：

![Screen Shot 2021-12-23 at 23.16.50](https://cdn.jsdelivr.net/gh/JJAYCHEN1e/Image@2021/default/202112232316809.png)

### 限定分类检索

本工具支持在限定分类下进行检索，例如限定在 Favorite 分类中进行检索。

例如，限定分类在 Favorite 后，在多条件的 OR 模式下检索 `张国荣 Leslie ` 就会展示包含**张国荣**或**Leslie**的 Favorite 图片：

![Screen Shot 2021-12-23 at 23.23.58](https://cdn.jsdelivr.net/gh/JJAYCHEN1e/Image@2021/default/202112232324451.png)





