# LMFloatingBar
## preview
![Screen shot](Doc/preview.gif)

## 介绍
  使用Swift，实现了微信的浮窗功能(转场动画实现 [LMFloatingKeeper](https://github.com/LiumingGithub/LMFloatingKeeper) 已进行了介绍)，包含控制器到悬浮球的飞人效果，以及飞人过程中，图片跟随mask位置绘制的效果(本以为可以用ImageView做，但是测试发现在displayLink中修改ImageView的frame图片的位置总是有延迟，只能CoreGraphi绘制图片)
  

## 支持
 iOS 10以上, swift 4.0

## 许可证

LMFloatingBar 是基于 MIT 许可证下发布的，详情请参见 LICENSE。
