---
title: "NSTextAlignment.rightなUITextFieldのスペースが表示されない"
emoji: "📝"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["iOS", "Swift", "Objective-C"]
published: false
---

## 何が起きたか
UITextField に AlignmentRight 属性を指定した場合、テキストの末尾にスペースを入力しても入力されていないように見える。
データ上はスペースが入力されているので、続けてなにか文字を入力すると、スペースと一緒に表示される。


![ng_version.gif](https://qiita-image-store.s3.amazonaws.com/0/77522/92b74055-3d4b-391d-210b-93766c0d5a55.gif)


stackoverflow の質問もあって、どうやら iOS 7 からの現象ぽい
https://stackoverflow.com/questions/19569688/right-aligned-uitextfield-spacebar-does-not-advance-cursor-in-ios-7

## どうしたか

UITextField を編集したときに呼ばれる  `textField(_:shouldChangeCharactersIn:replacementString:)` に修正を加える
もしスペースが入力されたら、 [non-breaking space](https://en.wikipedia.org/wiki/Non-breaking_space) に置き換えて表示してやる

```ViewController.swift
func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text!
        
        if range.location == text.characters.count && string == " " {
            textField.text = text + "\u{00a0}"
            return false
        }
        
        return true
    }
```

```ViewController.m
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.location == textField.text.length && [string isEqualToString:@" "]) {
        textField.text = [textField.text stringByAppendingString:@"\u00a0"];
        return NO;
    }

    return YES;
}
```

![ok_version.gif](https://qiita-image-store.s3.amazonaws.com/0/77522/48453292-bf9e-6290-03ae-6f42f19b0932.gif)


これでよさそう
サンプルコードはこちらhttps://gist.github.com/tdrk18/bdbaabd4ba898dcbdb0d8e5c62fbabad

## 🐢
`NSTextAlignment.left` とかにすればいいんですけど、 いろいろと制約があって `NSTextAlignment.right` のままで回避したい場合に。
