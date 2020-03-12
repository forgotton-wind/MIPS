        .data
buf:    .space      1024
succ:   .asciiz     "Success! Location: "
fail:   .asciiz     "Fail!\r\n"
endline:    
    .asciiz     "\r\n"  
    .text
main:
    la $a0,buf     # a0 = 缓冲区地址
    li $a1,512     # a1 = 可以读取的最大字符数
    li $v0,8       # v0 = 8 读取字符串
    syscall         
Loop:
    li $v0,12      # v0 = 12 读取字符 存在v0中
    syscall
    move $t3,$v0        # 由于又进行了一次系统调用 所以先将读入字符存入t3中
    li $v0,4       # v0 =4 输出字符串
    la $a0,endline     # a0 待输出字符串的地址 输出空行
    syscall
    move $v0,$t3        # 将读入的字符读入v0中
    beq $v0,'?',End        # 读入‘？’ 结束程序
    la $t0,buf     # t0 存入缓冲区首地址
    li $t1,1       # t1 存放找到的字符的位置
Find:
    lb $t2,($t0)     # 从字符串首地址开始比较 如果到达字符串尾0 表明查找失败
    beq $t2,0,NotFindit    # 读到0 字符串结束 未找到
    beq $t2,$v0 Findit  # 找到
    add $t1,$t1,1       # 继续寻找 位置加1
    add $t0,$t0,1       # 字符串位置向后加1
    b Find
Findit:
    li $v0,4       # v0 = 4 输出字符串
    la $a0,succ        # a0 存放输出字符串的首地址
    syscall
    li $v0,1       # v0 = 1 输出整数
    move $a0,$t1        # a0 存放待输出字符
    syscall
    li $v0,4       # 输出空行
    la $a0,endline
    syscall
    b Loop
NotFindit:
    li $v0,4       # 查找失败
    la $a0,fail
    syscall
    b Loop
End:
    li $v0,10      # v0 = 10 退出程序
    syscall