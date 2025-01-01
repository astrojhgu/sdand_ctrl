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
