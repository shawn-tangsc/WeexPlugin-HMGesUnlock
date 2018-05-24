# 针对weex的简单iOS手势密码解锁插件


说明：
====================================
本插件是针对weex做的一个手势密码解锁插件，具体的效果可以查看[基于eros的手势密码Demo](https://github.com/shawn-tangsc/eros-gesture-demo)。


两种安装方式：
====================================

第一种，通过pod本地引入
------------------------------------

1. 首先，从git 下载到本地

``` bash
## 进入你weex项目中的ios目录，执行git clone
git clone https://github.com/shawn-tangsc/WeexPlugin-HMGesUnlock

```

2. 其次，修改你ios项目的`Podfile`文件，加入

``` bash
 pod 'WeexHMGesUnlock', :path=>'./WeexPlugin-HMGesUnlock/'
```

3. 从终端进入项目`Podfile`所在的文件夹，然后执行初始化命令

``` bash
pod install 
```

4. 将git仓库中的Image.xcassets 添加到你的工程中。

第二种，直接使用pod引入插件
------------------------------------

1. 在你的`Podfile` 文件中，添加

```
 pod 'WeexHMGesUnlock', :git => 'https://github.com/shawn-tangsc/WeexPlugin-HMGesUnlock.git', :tag => '1.0.0'
```

2. 从终端进入项目`Podfile`所在的文件夹，然后执行初始化命令

``` bash
pod install 
```
