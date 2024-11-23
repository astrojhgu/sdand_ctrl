#import "simplepaper.typ": *

#show figure: set block(breakable: true)

#show: project.with(
  title: [SDANDART控制协议], authors: (
  ), keywords: (), date: [2024-11-23 version 0.4], abstract: [
    
    版本历史：
    - 20241106 v0.1 初始版本
    - 20241116 v0.2 I2C读写指令增加一个写入或者读回的字节数字段
    - 20241116 v0.3 状态查询的上行回复消息中，增加了健康指标个数的字段
    - 20241123 v0.4 增加VGA控制指令
  ],
)

= 下行指令和上行消息的总体结构

== 下行指令一般格式
- 前3个字节为消息类型码，第4个字节为00
- 接下来4个字节是一个序列号，为发送方可以任意指定的32bit整数，用来匹配回复消息
- 之后为指令内容

== 上行消息一般格式
- 前3个字节为消息类型码，第4个字节为ff
- 接下来4个字节为一个32bit整数，与对应的下行指令中的序列号相等
- 之后为上行消息内容

== 对于非法指令的回复
设备接收到任何无法解析的指令，都应当回复一个统一的错误指令，其格式如下

#figure(caption:"非法指令")[
  #table(columns: (auto,auto,auto),
  table.header([偏移],[内容],[解释]),
  [0:3],[ff ff ff ff],[消息类型],
  [4:7],[?? ?? ?? ??],[可定制的消息序列号],
  [8:11],[?? ?? ?? ??],[错误码],
  [12:15],[?? ?? ?? ??],[错误信息文字描述长度，不包括结尾的0],
  [...],[...],[消息描述],
  [...],[00 00 00 00],[结尾0]
  )
]

= 状态查询
== 功能

查询设备状态

== 下行指令
#figure(caption:"查询指令")[
  #table(columns: (auto,auto,auto),
  table.header([偏移],[内容],[解释]),
  [0:3],[01 00 00 00],[消息类型],
  [4:7],[?? ?? ?? ??],[可定制的消息序列号],
  )
]

== 上行消息
#figure(caption:"查询指令回复")[
  #table(columns: (auto,auto,auto),
  table.header([偏移],[内容],[解释]),
  [0:3],[01 00 00 ff],[ff代表上行消息，之后的00..代表是对查询指令的回复],
  [4:7],[?? ?? ?? ??],[和下行指令中的消息序列号相等],
  [8:11],[xx xx xx xx],[固件版本],
  [12:15],[xx xx xx xx],[上一次pps上跳至今的10 MHz信号周期数],
  [16:19],[xx xx xx xx],[上上一次pps上跳至今的10 MHz信号周期数],
  [20:23],[00 00 00 ??],[时钟锁定状态0代表未锁定，1代表锁定],
  [24:27],[?? ?? ?? ??],[健康指标个数],
  [28:31],[?? ?? ?? ??],[健康指标1],
  [32:35],[?? ?? ?? ??],[健康指标2],
  [...],[...],[...]
  )
]

= 同步指令
== 功能

在下一个PPS脉冲到达时，各种计数器归零

== 下行指令
#figure(caption:"查询指令")[
  #table(columns: (auto,auto,auto),
  table.header([偏移],[内容],[解释]),
  [0:3],[02 00 00 00],[消息类型],
  [4:7],[?? ?? ?? ??],[可定制的消息序列号],
  )
]

== 上行消息

#figure(caption:"查询指令回复")[
  #table(columns: (auto,auto,auto),
  table.header([偏移],[内容],[解释]),
  [0:3],[02 00 00 ff],[ff代表上行消息，之后的00..代表是对查询指令的回复],
  [4:7],[?? ?? ?? ??],[和下行指令中的消息序列号相等],
  [8:11],[00/01 00 00 00],[00代表未锁定，01代表锁定]
  )
]

= 万兆网载荷数据帧头配置

== 下行指令

=== 单个万兆端口配置结构体

单个万兆端口的配置信息长度32字节
#figure(caption:"单个万兆端口配置结构体")[
  #table(columns: (auto,auto,auto),
  table.header([偏移],[内容],[解释]),
  [0:7],[xx xx xx xx xx xx 00 00],[目标 mac地址],
  [8:15],[xx xx xx xx xx xx 00 00],[源 mac地址],
  [16:19],[xx xx xx xx],[目标ip地址],
  [20:23],[xx xx xx xx],[源ip地址],
  [24:27],[xx xx 00 00],[目标端口号，小端],
  [28:31],[xx xx 00 00],[源端口号，小端],
  )
]

=== 完整下行指令
#figure(caption:"完整万兆载荷数据帧头指令")[
  #table(columns: (auto,auto,auto),
  table.header([偏移],[内容],[解释]),
  [0:3],[03 00 00 00],[消息类型],
  [4:7],[?? ?? ?? ??],[可定制的消息序列号],
  [...],[...],[端口1配置信息],
  [...],[...],[端口2配置信息],
  [...],[...],[端口3配置信息],
  [...],[...],[端口4配置信息],
  )
]

== 上行消息

#figure(caption:"万兆载荷数据帧头配置上行消息")[
  #table(columns: (auto,auto,auto),
  table.header([偏移],[内容],[解释]),
  [0:3],[03 00 00 ff],[消息类型],
  [4:7],[?? ?? ?? ??],[可定制的消息序列号],
  )
]

= I2C 相关指令
== 扫描总线上的设备
=== 下行指令
#figure(caption:"扫描总线上的设备")[
  #table(columns: (auto,auto,auto),
  table.header([偏移],[内容],[解释]),
  [0:3],[04 00 00 00],[消息类型],
  [4:7],[?? ?? ?? ??],[可定制的消息序列号],
  )
]

=== 上行消息
#figure(caption:"扫描总线设备的上行消息")[
  #table(columns: (auto,auto,auto),
  table.header([偏移],[内容],[解释]),
  [0:3],[04 00 00 ff],[消息类型],
  [4:7],[?? ?? ?? ??],[可定制的消息序列号],
  [8:39],[...],[32个字节,256位，第n位上位1，代表有设备，否则代表没有设备]
  )
]

== 对单个设备写入
=== 下行指令
#figure(caption:"单个设备写入")[
  #table(columns: (auto,auto,auto),
  table.header([偏移],[内容],[解释]),
  [0:3],[04 01 00 00],[消息类型],
  [4:7],[?? ?? ?? ??],[可定制的消息序列号],
  [8:11],[?? ?? 00 00],[8/10位从设备地址],
  [12:15],[?? ?? 00 00],[写入字节数],
  [...],[...],[写入的字节]
  )
]

=== 上行消息
#figure(caption:"单个设备写入上行消息")[
  #table(columns: (auto,auto,auto),
  table.header([偏移],[内容],[解释]),
  [0:3],[04 01 00 ff],[消息类型],
  [4:7],[?? ?? ?? ??],[可定制的消息序列号],
  [8:11],[00/ff 00 00 00],[00代表成功，ff代表失败，若有必要，细化错误码]
  )
]

== 对单个设备的内部寄存器地址写入
=== 下行指令
#figure(caption:"单个设备的内部地址写入")[
  #table(columns: (auto,auto,auto),
  table.header([偏移],[内容],[解释]),
  [0:3],[04 02 00 00],[消息类型],
  [4:7],[?? ?? ?? ??],[可定制的消息序列号],
  [8:11],[?? ?? 00 00],[8/10位从设备地址],
  [12:15],[?? ?? ?? ??],[内部寄存器起始地址],
  [16:19],[?? ?? 00 00],[写入字节数],
  [...],[...],[写入的字节]
  )
]
=== 上行消息

#figure(caption:"单个设备的内部地址写入的上行消息")[
  #table(columns: (auto,auto,auto),
  table.header([偏移],[内容],[解释]),
  [0:3],[04 02 00 ff],[消息类型],
  [4:7],[?? ?? ?? ??],[可定制的消息序列号],
  [8:11],[00/ff 00 00 00],[00代表成功，ff代表失败，若有必要，细化错误码]
  )
]

== 读取单个设备

=== 下行指令
#figure(caption:"单个设备的内部地址读出")[
  #table(columns: (auto,auto,auto),
  table.header([偏移],[内容],[解释]),
  [0:3],[04 03 00 00],[消息类型],
  [4:7],[?? ?? ?? ??],[可定制的消息序列号],
  [8:11],[?? ?? 00 00],[8/10位从设备地址],
  [12:15],[?? ?? ?? ??],[想要读取的字节数，小端],
  )
]

=== 上行消息
#figure(caption:"单个设备的内部地址读出的上行消息")[
  #table(columns: (auto,auto,auto),
  table.header([偏移],[内容],[解释]),
  [0:3],[04 03 00 ff],[消息类型],
  [4:7],[?? ?? ?? ??],[可定制的消息序列号],
  [8:11],[00/ff ?? 00 00],[00代表成功，ff代表失败，若有必要，细化错误码],
  [12:15],[?? ?? 00 00],[读回字节数],
  [...],[...],[读到的字节],
  )
]

== 读取单个设备的内部寄存器地址

=== 下行指令
#figure(caption:"单个设备的内部地址读出")[
  #table(columns: (auto,auto,auto),
  table.header([偏移],[内容],[解释]),
  [0:3],[04 04 00 00],[消息类型],
  [4:7],[?? ?? ?? ??],[可定制的消息序列号],
  [8:11],[?? ?? 00 00],[8/10位从设备地址],
  [12:15],[?? ?? 00 00],[寄存器地址，小端],
  [16:19],[?? ?? ?? ??],[想要读取的字节数，小端],
  )
]

=== 上行消息
#figure(caption:"单个设备的内部地址读出的上行消息")[
  #table(columns: (auto,auto,auto),
  table.header([偏移],[内容],[解释]),
  [0:3],[04 04 00 ff],[消息类型],
  [4:7],[?? ?? ?? ??],[可定制的消息序列号],
  [8:11],[00/ff ?? 00 00],[00代表成功，ff代表失败，若有必要，细化错误码],
  [12:15],[?? ?? 00 00],[读回字节数],
  [...],[...],[读到的字节],
  )
]

= 载荷数据流启停

注意：设备在收到启停指令后，需要等待下一个pps脉冲的到达才执行动作

== 下行指令
#figure(caption:"载荷数据流启停")[
  #table(columns: (auto,auto,auto),
  table.header([偏移],[内容],[解释]),
  [0:3],[05 01/02 00 00],[消息类型，01代表启动数据流，02
  代表停止数据流],
  [4:7],[?? ?? ?? ??],[可定制的消息序列号],
  )
]

== 上行消息
#figure(caption:"载荷数据流启停")[
  #table(columns: (auto,auto,auto),
  table.header([偏移],[内容],[解释]),
  [0:3],[05 01/02 00 ff],[消息类型，01代表启动数据流，02
  代表停止数据流],
  [4:7],[?? ?? ?? ??],[可定制的消息序列号],
  )
]

= VGA控制
== 下行指令
#figure(caption:"VGA增益控制")[
  #table(columns: (auto,auto,auto),
  table.header([偏移],[内容],[解释]),
  [0:3],[06 00 00 00],[消息类型],
  [4:7],[?? ?? ?? ??],[可定制的消息序列号],
  [8:11], [?? ?? ?? ??], [VGA通道个数],
  [12:15], [?? ?? ?? ??], [VGA增益值],
  [...],[...],[...]
  )
]

== 上行消息
#figure(caption:"VGA增益控制")[
  #table(columns: (auto,auto,auto),
  table.header([偏移],[内容],[解释]),
  [0:3],[06 00 00 ff],[消息类型],
  [4:7],[?? ?? ?? ??],[可定制的消息序列号],
  [8:11],[?? ?? ?? ??],[返回错误码，全零代表成果],  
  )
]

//#bibliography("ref.bib")
