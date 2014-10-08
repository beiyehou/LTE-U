# V2.0 time 2014/09/24
@ 主要修改 沈晓美
修改函数    Send_packet()
修改功能    改成由信道为目标遍历为以节点为目标遍历
修改错误    Line 60 index = []; 清空index

修改函数    Listen()
修改功能    listen 在同时有多个监听时 lisenQueue 的下标值只支持当个值的问题
                    现改为支持多个值
@ 主要修改  罗欢
修改函数    Write_Result()
修改功能    为了和新写的 Write_Sturct 函数相互配合，文件名给在函数的输出中

修改函数    Set_Packet()
修改错误    Line 139 index = []; 清空index

新加函数    Write_Struct ()
函数功能    只能用于本平台实现结构体字段向文件中写入的操作

@ 需要修改的问题
Dispatch_Stream()
分配信道 临频 共频  目前是分块注释的，希望改成以字符串标示的分配方式，类似 COM_4_1 etc。
Compute_SNR()
该函数计算的 SNR 目前没有和 Set_Packet 中的 Select_TBS 相对应。
#V3.0 time 2014/9/30
@修改函数   Set_Packet()    Send_Packet()
@修改功能   解决以前bit转换为时间片 存在累计误差的 bug，增加一个 packet_bit 字段暂存packet_length 
                       对应得bit数，每次记吞吐量都以 packet_bit 累加实现精确计数
                      解决 total_date 计数误差，改为 Gbit 10Mbit  bit 的三级进制方式存储数据，注意和total_input
                        的区别 total_input 是以 Gbit  Mbit bit 的三级进制方式存储数据的

@修改函数   Display_status()
@修改功能   修复视图显示 total_date 一维数组 ，单位 Kbit

@修改函数   Write_Struct()
@修改功能   在输入结果数据中，显示没有发出去停留在 waitQueue 中的包bit数，packet_bit
                        计算bit平衡 ，total_input = total_date + packet_bit + packet_receiver_bit + drop_bit (NOLBT 时碰撞丢弃的包bit)