        .data
big:    .asciiz     #使用asciiz 末尾自动加结束符
    "Alpha\r\n","Bravo\r\n","China\r\n","Delta\r\n","Echo\r\n",
    "Foxtrot\r\n","Golf\r\n","Hotel\r\n","India\r\n","Juliet\r\n",
    "Kilo\r\n","Lima\r\n","Mary\r\n","November\r\n","Oscar\r\n",
    "Paper\r\n","Quebec\r\n","Reserach\r\n","Sierra\r\n","Tango\r\n",
    "Uniform\r\n","Victor\r\n","Whisky\r\n","X-ray\r\n","Yankee\r\n",
    "Zulu\r\n"
small:  .asciiz
    "alpha\r\n","bravo\r\n","china\r\n","delta\r\n","echo\r\n",
    "foxtrot\r\n","golf\r\n","hotel\r\n","india\r\n","juliet\r\n",
    "kilo\r\n","lima\r\n","mary\r\n","november\r\n","oscar\r\n",
    "paper\r\n","quebec\r\n","reserach\r\n","sierra\r\n","tango\r\n",
    "uniform\r\n","victor\r\n","whisky\r\n","x-ray\r\n","yankee\r\n",
    "zulu\r\n"
num:    .asciiz
    "zero\r\n","First\r\n","Second\r\n","Third\r\n","Fourth\r\n",
    "Fifth\r\n","Sixth\r\n","Seventh\r\n","Eighth\r\n","Ninth\r\n"
endline:    .asciiz     "\r\n"
# 字母对应的字符串的偏移量  
letter_offset:  .word   0,8,16,24,32,39,49,56,64,72,81,88,95,102,113,
            121,129,138,149,158,166,176,185,194,202,211
# 数字对应的字符串的偏移量
num_offset: .word   0,7,15,24,32,41,49,57,67,76
    .text
main:   
Loop:   li $v0,12      # v0=12 输入字符
    syscall         # 系统调用
    move $t0,$v0        # 由于又进行了一次系统调用 将读入字符存起来
    la $a0,endline     # 另起一行
    li $v0,4       # v0 = 4 输出字符串
    syscall         # 系统调用
    move $v0,$t0        # 将读入的字符转入 v0 中
    sub $t0,$v0,'?'     
    beqz $t0,End       # 若是'?' 程序结束
    blt $v0,'0',isOthers   # 对输入字符判断分支 小于'0'是其他字符
    ble $v0,'9',isNum  # 在‘0’与‘9’之间 
    blt $v0,'A',isOthers   # 大于 ‘9’ 小于 ‘A' 是其他字符
    ble $v0,'Z',isBig  # 在 ’A' 与 ‘Z’之间
    blt $v0,'a',isOthers   # 大于‘Z’ 小于 ‘a' 是其他字符
    ble $v0,'z',isSmall    # 在 'a' 与 ’z' 之间
    b isOthers      # 大于 'z' 是其他字符
isNum:  
    sub $t0,$v0,'0'     # 数字 减去‘0’ 
    sll $t0,$t0,2       # 一个字占4个字节 左移2位
    la $t1,num_offset  # t1 中存 num_offset 的地址
    add $t0,$t0,$t1        
    lw $t0,($t0)     # t0 地址处存放是对应字符串的偏移量
    la $t1,num     
    add $a0,$t0,$t1        # a0 待输出字符串的地址
    li $v0,4       # v0=4 输出字符串
    syscall
    b Loop
isBig:
    sub $t0,$v0,'A'     # 大写字母 减去‘A’    
    sll $t0,$t0,2       # 一个字占4个字节
    la $t1,letter_offset   # t1 中存 letter_offset 的地址
    add $t0,$t0,$t1
    lw $t0,($t0)        # t0 地址处存放是对应字符串的偏移量
    la $t1,big
    add $a0,$t0,$t1       # a0 待输出字符串的地址
    li $v0,4       # v0=4 输出字符串
    syscall
    b Loop
isSmall:
    sub $t0,$v0,'a'        # 小写字母 减去‘A’
    sll $t0,$t0,2      # 一个字占4个字节 
    la $t1,letter_offset   # t1 中存 letter_offset 的地址
    add $t0,$t0,$t1
    lw $t0,($t0)        # t0 地址处存放是对应字符串的偏移量
    la $t1,small
    add $a0,$t0,$t1       # a0 待输出字符串的地址
    li $v0,4       # v0=4 输出字符串
    syscall
    b Loop
isOthers:
    li $a0,'*'     # a0 待输出字符
    li $v0,11      # v0=11 输出字符
    syscall
    la $a0,endline     # 输出空行
    li $v0,4
    syscall
    b Loop
End:
    li $v0,10      # 退出程序
    syscall
