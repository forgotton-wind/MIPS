        .data
buf:    .space      1024
succ:   .asciiz     "Success! Location: "
fail:   .asciiz     "Fail!\r\n"
endline:    
    .asciiz     "\r\n"  
    .text
main:
    la $a0,buf     # a0 = ��������ַ
    li $a1,512     # a1 = ���Զ�ȡ������ַ���
    li $v0,8       # v0 = 8 ��ȡ�ַ���
    syscall         
Loop:
    li $v0,12      # v0 = 12 ��ȡ�ַ� ����v0��
    syscall
    move $t3,$v0        # �����ֽ�����һ��ϵͳ���� �����Ƚ������ַ�����t3��
    li $v0,4       # v0 =4 ����ַ���
    la $a0,endline     # a0 ������ַ����ĵ�ַ �������
    syscall
    move $v0,$t3        # ��������ַ�����v0��
    beq $v0,'?',End        # ���롮���� ��������
    la $t0,buf     # t0 ���뻺�����׵�ַ
    li $t1,1       # t1 ����ҵ����ַ���λ��
Find:
    lb $t2,($t0)     # ���ַ����׵�ַ��ʼ�Ƚ� ��������ַ���β0 ��������ʧ��
    beq $t2,0,NotFindit    # ����0 �ַ������� δ�ҵ�
    beq $t2,$v0 Findit  # �ҵ�
    add $t1,$t1,1       # ����Ѱ�� λ�ü�1
    add $t0,$t0,1       # �ַ���λ������1
    b Find
Findit:
    li $v0,4       # v0 = 4 ����ַ���
    la $a0,succ        # a0 �������ַ������׵�ַ
    syscall
    li $v0,1       # v0 = 1 �������
    move $a0,$t1        # a0 ��Ŵ�����ַ�
    syscall
    li $v0,4       # �������
    la $a0,endline
    syscall
    b Loop
NotFindit:
    li $v0,4       # ����ʧ��
    la $a0,fail
    syscall
    b Loop
End:
    li $v0,10      # v0 = 10 �˳�����
    syscall