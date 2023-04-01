//
//  Conversation+StaticData.swift
//  DogeChat
//
//  Created by Steve Yu on 2023/4/2.
//

import Foundation

extension Conversation {
    static let translationMessage: Conversation = .init(id: 0, messages: [
        .init(role: .assistant, content: "你好，我是修勾。有什么要问我的"),
        .init(role: .user, content: "可以帮我做一下翻译吗？"),
        .init(role: .assistant, content: "当然可以，请问需要翻译哪种语言？"),
        .init(role: .user, content: "中文翻译成English"),
        .init(role: .assistant, content: "好的，请问需要翻译哪段中文？")
    ], outline: "中文翻译成英文")
    
    static let mahjong: Conversation = .init(id: 1, messages: [
        .init(role: .assistant, content: "你好，我是修勾。有什么要问我的"),
        .init(role: .user, content: "修勾，你好，日麻的基本规则可以和我简述一下嘛？"),
        .init(role: .assistant, content: """
你好，日本麻将的基本规则如下：

1. 麻将牌：日本麻将使用136张牌，包括万、条、筒三种花色，每种花色有1-9张牌，每张牌有4个副本，另外还有字牌（东、南、西、北、白、发、中）。

2. 玩家：通常有4个玩家，每个玩家坐在一张桌子的四个方向上。

3. 目标：玩家的目标是通过组合手中的牌，形成特定的牌型，以达到最高的得分。

4. 开局：每个玩家开始时有13张牌，然后轮流从牌堆中摸牌，直到手中有14张牌。

5. 牌型：玩家需要组合手中的牌，形成特定的牌型，包括顺子、刻子、杠子、对子等。

6. 点数：每个牌型都有不同的点数，玩家可以根据自己的牌型和场上的情况，选择是否要自摸或者放弃摸牌，以达到最高的得分。

7. 结束：当有一个玩家达到设定的得分或者牌堆中的牌被摸完时，游戏结束。

以上是日本麻将的基本规则，希望对你有所帮助。
"""),
        .init(role: .user, content: "胡牌方法可以讲一下嘛？"),
        .init(role: .assistant, content: """
当玩家手中的牌组成了特定的牌型时，就可以胡牌了。以下是几种常见的胡牌方式：

1. 自摸胡：当玩家自己摸到一张牌后，手中的牌组成了特定的牌型，就可以自摸胡牌。

2. 点炮胡：当一名玩家打出一张牌后，其他玩家手中的牌组成了特定的牌型，就可以点炮胡牌。

3. 抢杠胡：当一名玩家碰了别人的牌，然后自己摸到了一张与碰的牌相同的牌，就可以抢杠胡牌。

4. 海底捞月：当牌堆中的最后一张牌被摸走后，如果玩家自己摸到了这张牌，就可以胡牌。

5. 杠上开花：当玩家在杠牌后摸到了一张牌，手中的牌组成了特定的牌型，就可以杠上开花胡牌。

以上是几种常见的胡牌方式，不同的麻将规则可能会有所不同。在实际游戏中，玩家需要根据手中的牌和场上的情况，灵活运用各种胡牌方式，以达到最高的得分。
""")], outline: "麻将的介绍和胡牌方法")
    
    static let markdown: Conversation = .init(id: 2, messages: [
        .init(role: .assistant, content: "你好，我是修勾。有什么要问我的"),
        .init(role: .user, content: "可以给一段markdown嘛"),
        .init(role: .assistant, content: """
当然可以，以下是一段示例的Markdown文本：

# 标题一

## 标题二

### 标题三

这是一段普通的文本，可以包含**加粗**、*斜体*、~~删除线~~等样式。

- 列表项1
- 列表项2
- 列表项3

1. 有序列表项1
2. 有序列表项2
3. 有序列表项3

> 这是一段引用文本。

`这是一段代码片段。`

```
这是一段代码块。
可以包含多行代码。
```

| 表头1 | 表头2 |
| ----- | ----- |
| 内容1 | 内容2 |
| 内容3 | 内容4 |

[链接文字](链接地址)

![图片描述](图片链接)
""")], outline: "Markdown 示例文本")

    static var sampleData: [Conversation] = [translationMessage, mahjong, markdown]
}
