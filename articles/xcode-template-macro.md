---
title: "Xcodeのファイルヘッダーをカスタマイズする"
emoji: "🖊️"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["xcode"]
published: false
---

# Xcodeで新規作成するファイルのヘッダーの内容をカスタマイズする

Xcode でファイルを新規作成したときに、下記のようなヘッダーが自動生成されます。
この内容をカスタマイズする方法です。

```
//
//  ContentView.swift
//  MyApp
//  
//  Created by tdrk18 on 2022/04/21.
//  Copyright © 2022 tdrk18. All rights reserved.
//
```

## 用意するもの

`IDETemplateMacros.plist` というファイルを作成します。
このファイルに自動生成されるファイルの中身を書きます。

Xcode のデフォルト設定と同じになる内容が以下です。
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>FILEHEADER</key>
    <string>
//  ___FILENAME___
//  ___TARGETNAME___
//  
//  Created by ___USERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//</string>
</dict>
</plist>
```

https://gist.github.com/tdrk18/8fe575d21fce3363320bc15684f5ea47

`_` ３つで囲むと、日付やプロジェクト名などを自動展開してくれます。
必要に応じて内容を変更することで、ヘッダー部分をカスタマイズできます。

## ファイルを配置する場所

Xcode がファイルを認識してくれる箇所はいくつかあるので、必要に応じて配置します。
- Project user data
    - `<ProjectName>.xcodeproj/xcuserdata/<UserName>.xcuserdata/IDETemplateMacros.plist`
- Project shared data
    - `<ProjectName>.xcodeproj/xcshareddata/IDETemplateMacros.plist`
- Workspace user data
    - `<WorkspaceName>.xcworkspace/xcuserdata/<UserName>.xcuserdata/IDETemplateMacros.plist`
- Workspace shared data
    - `<WorkspaceName>.xcworkspace/xcshareddata/IDETemplateMacros.plist`
- Xcode user data
    - `$HOME/Library/Developer/Xcode/UserData/IDETemplateMacros.plist`
