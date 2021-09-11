---
title: "NSTextAlignment.rightなUITextFieldのスペースが表示されない"
emoji: "📝"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["ios", "swift", "objectivec"]
published: false
---

## 何が起きたか
UITextField に AlignmentRight 属性を指定した場合、テキストの末尾にスペースを入力しても入力されていないように見える。
データ上はスペースが入力されているので、続けてなにか文字を入力すると、スペースと一緒に表示される。


![ng_version.gif](https://storage.googleapis.com/zenn-user-upload/00b399bf77d6e9dca156ae83.gif)


stackoverflow の質問もあって、どうやら iOS 7 からの現象ぽい
https://stackoverflow.com/questions/19569688/right-aligned-uitextfield-spacebar-does-not-advance-cursor-in-ios-7

## どうしたか

UITextField を編集したときに呼ばれる  `textField(_:shouldChangeCharactersIn:replacementString:)` に修正を加える
もしスペースが入力されたら、 [non-breaking space](https://en.wikipedia.org/wiki/Non-breaking_space) に置き換えて表示してやる

```swift
func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text!
        
        if range.location == text.characters.count && string == " " {
            textField.text = text + "\u{00a0}"
            return false
        }
        
        return true
    }
```

```objc
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.location == textField.text.length && [string isEqualToString:@" "]) {
        textField.text = [textField.text stringByAppendingString:@"\u00a0"];
        return NO;
    }

    return YES;
}
```

![ok_version.gif](https://storage.googleapis.com/zenn-user-upload/cfabacb91a81f6397c9cfef6.gif)


これでよさそう
サンプルコードはこちらhttps://gist.github.com/tdrk18/bdbaabd4ba898dcbdb0d8e5c62fbabad

## 🐢
`NSTextAlignment.left` とかにすればいいんですけど、 いろいろと制約があって `NSTextAlignment.right` のままで回避したい場合に。

---

Copy from https://qiita.com/tdrk/items/f0a373899facf3fc2ed1