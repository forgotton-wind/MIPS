        .data
big:    .asciiz     #ʹ��asciiz ĩβ�Զ��ӽ�����
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
# ��ĸ��Ӧ���ַ�����ƫ����  
letter_offset:  .word   0,8,16,24,32,39,49,56,64,72,81,88,95,102,113,
            121,129,138,149,158,166,176,185,194,202,211
# ���ֶ�Ӧ���ַ�����ƫ����
num_offset: .word   0,7,15,24,32,41,49,57,67,76
    .text
main:   
Loop:   li $v0,12      # v0=12 �����ַ�
    syscall         # ϵͳ����
    move $t0,$v0        # �����ֽ�����һ��ϵͳ���� �������ַ�������
    la $a0,endline     # ����һ��
    li $v0,4       # v0 = 4 ����ַ���
    syscall         # ϵͳ����
    move $v0,$t0        # ��������ַ�ת�� v0 ��
    sub $t0,$v0,'?'     
    beqz $t0,End       # ����'?' �������
    blt $v0,'0',isOthers   # �������ַ��жϷ�֧ С��'0'�������ַ�
    ble $v0,'9',isNum  # �ڡ�0���롮9��֮�� 
    blt $v0,'A',isOthers   # ���� ��9�� С�� ��A' �������ַ�
    ble $v0,'Z',isBig  # �� ��A' �� ��Z��֮��
    blt $v0,'a',isOthers   # ���ڡ�Z�� С�� ��a' �������ַ�
    ble $v0,'z',isSmall    # �� 'a' �� ��z' ֮��
    b isOthers      # ���� 'z' �������ַ�
isNum:  
    sub $t0,$v0,'0'     # ���� ��ȥ��0�� 
    sll $t0,$t0,2       # һ����ռ4���ֽ� ����2λ
    la $t1,num_offset  # t1 �д� num_offset �ĵ�ַ
    add $t0,$t0,$t1        
    lw $t0,($t0)     # t0 ��ַ������Ƕ�Ӧ�ַ�����ƫ����
    la $t1,num     
    add $a0,$t0,$t1        # a0 ������ַ����ĵ�ַ
    li $v0,4       # v0=4 ����ַ���
    syscall
    b Loop
isBig:
    sub $t0,$v0,'A'     # ��д��ĸ ��ȥ��A��    
    sll $t0,$t0,2       # һ����ռ4���ֽ�
    la $t1,letter_offset   # t1 �д� letter_offset �ĵ�ַ
    add $t0,$t0,$t1
    lw $t0,($t0)        # t0 ��ַ������Ƕ�Ӧ�ַ�����ƫ����
    la $t1,big
    add $a0,$t0,$t1       # a0 ������ַ����ĵ�ַ
    li $v0,4       # v0=4 ����ַ���
    syscall
    b Loop
isSmall:
    sub $t0,$v0,'a'        # Сд��ĸ ��ȥ��A��
    sll $t0,$t0,2      # һ����ռ4���ֽ� 
    la $t1,letter_offset   # t1 �д� letter_offset �ĵ�ַ
    add $t0,$t0,$t1
    lw $t0,($t0)        # t0 ��ַ������Ƕ�Ӧ�ַ�����ƫ����
    la $t1,small
    add $a0,$t0,$t1       # a0 ������ַ����ĵ�ַ
    li $v0,4       # v0=4 ����ַ���
    syscall
    b Loop
isOthers:
    li $a0,'*'     # a0 ������ַ�
    li $v0,11      # v0=11 ����ַ�
    syscall
    la $a0,endline     # �������
    li $v0,4
    syscall
    b Loop
End:
    li $v0,10      # �˳�����
    syscall