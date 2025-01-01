= 同步指令<cmd:sync>
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
