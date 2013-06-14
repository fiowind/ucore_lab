
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 70 11 40 	lgdtl  0x40117018
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 04 00 00 00       	call   10002c <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>
	...

0010002c <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002c:	55                   	push   %ebp
  10002d:	89 e5                	mov    %esp,%ebp
  10002f:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100032:	ba 68 89 11 00       	mov    $0x118968,%edx
  100037:	b8 38 7a 11 00       	mov    $0x117a38,%eax
  10003c:	89 d1                	mov    %edx,%ecx
  10003e:	29 c1                	sub    %eax,%ecx
  100040:	89 c8                	mov    %ecx,%eax
  100042:	89 44 24 08          	mov    %eax,0x8(%esp)
  100046:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10004d:	00 
  10004e:	c7 04 24 38 7a 11 00 	movl   $0x117a38,(%esp)
  100055:	e8 91 5e 00 00       	call   105eeb <memset>

    cons_init();                // init the console
  10005a:	e8 f1 15 00 00       	call   101650 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10005f:	c7 45 f4 c0 60 10 00 	movl   $0x1060c0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100066:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100069:	89 44 24 04          	mov    %eax,0x4(%esp)
  10006d:	c7 04 24 dc 60 10 00 	movl   $0x1060dc,(%esp)
  100074:	e8 ce 02 00 00       	call   100347 <cprintf>

    print_kerninfo();
  100079:	e8 d8 07 00 00       	call   100856 <print_kerninfo>

    grade_backtrace();
  10007e:	e8 86 00 00 00       	call   100109 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100083:	e8 2c 43 00 00       	call   1043b4 <pmm_init>

    pic_init();                 // init interrupt controller
  100088:	e8 34 17 00 00       	call   1017c1 <pic_init>
    idt_init();                 // init interrupt descriptor table
  10008d:	e8 86 18 00 00       	call   101918 <idt_init>

    clock_init();               // init clock interrupt
  100092:	e8 c9 0c 00 00       	call   100d60 <clock_init>
    intr_enable();              // enable irq interrupt
  100097:	e8 8c 16 00 00       	call   101728 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  10009c:	eb fe                	jmp    10009c <kern_init+0x70>

0010009e <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10009e:	55                   	push   %ebp
  10009f:	89 e5                	mov    %esp,%ebp
  1000a1:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000ab:	00 
  1000ac:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000b3:	00 
  1000b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000bb:	e8 ca 0b 00 00       	call   100c8a <mon_backtrace>
}
  1000c0:	c9                   	leave  
  1000c1:	c3                   	ret    

001000c2 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000c2:	55                   	push   %ebp
  1000c3:	89 e5                	mov    %esp,%ebp
  1000c5:	53                   	push   %ebx
  1000c6:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000c9:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000cf:	8d 55 08             	lea    0x8(%ebp),%edx
  1000d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d5:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000d9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000dd:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000e1:	89 04 24             	mov    %eax,(%esp)
  1000e4:	e8 b5 ff ff ff       	call   10009e <grade_backtrace2>
}
  1000e9:	83 c4 14             	add    $0x14,%esp
  1000ec:	5b                   	pop    %ebx
  1000ed:	5d                   	pop    %ebp
  1000ee:	c3                   	ret    

001000ef <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000ef:	55                   	push   %ebp
  1000f0:	89 e5                	mov    %esp,%ebp
  1000f2:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000f5:	8b 45 10             	mov    0x10(%ebp),%eax
  1000f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1000ff:	89 04 24             	mov    %eax,(%esp)
  100102:	e8 bb ff ff ff       	call   1000c2 <grade_backtrace1>
}
  100107:	c9                   	leave  
  100108:	c3                   	ret    

00100109 <grade_backtrace>:

void
grade_backtrace(void) {
  100109:	55                   	push   %ebp
  10010a:	89 e5                	mov    %esp,%ebp
  10010c:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10010f:	b8 2c 00 10 00       	mov    $0x10002c,%eax
  100114:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  10011b:	ff 
  10011c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100120:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100127:	e8 c3 ff ff ff       	call   1000ef <grade_backtrace0>
}
  10012c:	c9                   	leave  
  10012d:	c3                   	ret    

0010012e <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10012e:	55                   	push   %ebp
  10012f:	89 e5                	mov    %esp,%ebp
  100131:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100134:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100137:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10013a:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10013d:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100140:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100144:	0f b7 c0             	movzwl %ax,%eax
  100147:	89 c2                	mov    %eax,%edx
  100149:	83 e2 03             	and    $0x3,%edx
  10014c:	a1 40 7a 11 00       	mov    0x117a40,%eax
  100151:	89 54 24 08          	mov    %edx,0x8(%esp)
  100155:	89 44 24 04          	mov    %eax,0x4(%esp)
  100159:	c7 04 24 e1 60 10 00 	movl   $0x1060e1,(%esp)
  100160:	e8 e2 01 00 00       	call   100347 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100165:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100169:	0f b7 d0             	movzwl %ax,%edx
  10016c:	a1 40 7a 11 00       	mov    0x117a40,%eax
  100171:	89 54 24 08          	mov    %edx,0x8(%esp)
  100175:	89 44 24 04          	mov    %eax,0x4(%esp)
  100179:	c7 04 24 ef 60 10 00 	movl   $0x1060ef,(%esp)
  100180:	e8 c2 01 00 00       	call   100347 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100185:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100189:	0f b7 d0             	movzwl %ax,%edx
  10018c:	a1 40 7a 11 00       	mov    0x117a40,%eax
  100191:	89 54 24 08          	mov    %edx,0x8(%esp)
  100195:	89 44 24 04          	mov    %eax,0x4(%esp)
  100199:	c7 04 24 fd 60 10 00 	movl   $0x1060fd,(%esp)
  1001a0:	e8 a2 01 00 00       	call   100347 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001a5:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001a9:	0f b7 d0             	movzwl %ax,%edx
  1001ac:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001b1:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b9:	c7 04 24 0b 61 10 00 	movl   $0x10610b,(%esp)
  1001c0:	e8 82 01 00 00       	call   100347 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001c5:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001c9:	0f b7 d0             	movzwl %ax,%edx
  1001cc:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001d1:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d9:	c7 04 24 19 61 10 00 	movl   $0x106119,(%esp)
  1001e0:	e8 62 01 00 00       	call   100347 <cprintf>
    round ++;
  1001e5:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001ea:	83 c0 01             	add    $0x1,%eax
  1001ed:	a3 40 7a 11 00       	mov    %eax,0x117a40
}
  1001f2:	c9                   	leave  
  1001f3:	c3                   	ret    

001001f4 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001f4:	55                   	push   %ebp
  1001f5:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001f7:	5d                   	pop    %ebp
  1001f8:	c3                   	ret    

001001f9 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001f9:	55                   	push   %ebp
  1001fa:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001fc:	5d                   	pop    %ebp
  1001fd:	c3                   	ret    

001001fe <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001fe:	55                   	push   %ebp
  1001ff:	89 e5                	mov    %esp,%ebp
  100201:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100204:	e8 25 ff ff ff       	call   10012e <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100209:	c7 04 24 28 61 10 00 	movl   $0x106128,(%esp)
  100210:	e8 32 01 00 00       	call   100347 <cprintf>
    lab1_switch_to_user();
  100215:	e8 da ff ff ff       	call   1001f4 <lab1_switch_to_user>
    lab1_print_cur_status();
  10021a:	e8 0f ff ff ff       	call   10012e <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10021f:	c7 04 24 48 61 10 00 	movl   $0x106148,(%esp)
  100226:	e8 1c 01 00 00       	call   100347 <cprintf>
    lab1_switch_to_kernel();
  10022b:	e8 c9 ff ff ff       	call   1001f9 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100230:	e8 f9 fe ff ff       	call   10012e <lab1_print_cur_status>
}
  100235:	c9                   	leave  
  100236:	c3                   	ret    
	...

00100238 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100238:	55                   	push   %ebp
  100239:	89 e5                	mov    %esp,%ebp
  10023b:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  10023e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100242:	74 13                	je     100257 <readline+0x1f>
        cprintf("%s", prompt);
  100244:	8b 45 08             	mov    0x8(%ebp),%eax
  100247:	89 44 24 04          	mov    %eax,0x4(%esp)
  10024b:	c7 04 24 67 61 10 00 	movl   $0x106167,(%esp)
  100252:	e8 f0 00 00 00       	call   100347 <cprintf>
    }
    int i = 0, c;
  100257:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10025e:	eb 01                	jmp    100261 <readline+0x29>
        else if (c == '\n' || c == '\r') {
            cputchar(c);
            buf[i] = '\0';
            return buf;
        }
    }
  100260:	90                   	nop
    if (prompt != NULL) {
        cprintf("%s", prompt);
    }
    int i = 0, c;
    while (1) {
        c = getchar();
  100261:	e8 6e 01 00 00       	call   1003d4 <getchar>
  100266:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100269:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10026d:	79 07                	jns    100276 <readline+0x3e>
            return NULL;
  10026f:	b8 00 00 00 00       	mov    $0x0,%eax
  100274:	eb 79                	jmp    1002ef <readline+0xb7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100276:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10027a:	7e 28                	jle    1002a4 <readline+0x6c>
  10027c:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100283:	7f 1f                	jg     1002a4 <readline+0x6c>
            cputchar(c);
  100285:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100288:	89 04 24             	mov    %eax,(%esp)
  10028b:	e8 df 00 00 00       	call   10036f <cputchar>
            buf[i ++] = c;
  100290:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100293:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100296:	81 c2 60 7a 11 00    	add    $0x117a60,%edx
  10029c:	88 02                	mov    %al,(%edx)
  10029e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1002a2:	eb 46                	jmp    1002ea <readline+0xb2>
        }
        else if (c == '\b' && i > 0) {
  1002a4:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002a8:	75 17                	jne    1002c1 <readline+0x89>
  1002aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002ae:	7e 11                	jle    1002c1 <readline+0x89>
            cputchar(c);
  1002b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002b3:	89 04 24             	mov    %eax,(%esp)
  1002b6:	e8 b4 00 00 00       	call   10036f <cputchar>
            i --;
  1002bb:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1002bf:	eb 29                	jmp    1002ea <readline+0xb2>
        }
        else if (c == '\n' || c == '\r') {
  1002c1:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002c5:	74 06                	je     1002cd <readline+0x95>
  1002c7:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002cb:	75 93                	jne    100260 <readline+0x28>
            cputchar(c);
  1002cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002d0:	89 04 24             	mov    %eax,(%esp)
  1002d3:	e8 97 00 00 00       	call   10036f <cputchar>
            buf[i] = '\0';
  1002d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002db:	05 60 7a 11 00       	add    $0x117a60,%eax
  1002e0:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002e3:	b8 60 7a 11 00       	mov    $0x117a60,%eax
  1002e8:	eb 05                	jmp    1002ef <readline+0xb7>
        }
    }
  1002ea:	e9 71 ff ff ff       	jmp    100260 <readline+0x28>
}
  1002ef:	c9                   	leave  
  1002f0:	c3                   	ret    
  1002f1:	00 00                	add    %al,(%eax)
	...

001002f4 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002f4:	55                   	push   %ebp
  1002f5:	89 e5                	mov    %esp,%ebp
  1002f7:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1002fd:	89 04 24             	mov    %eax,(%esp)
  100300:	e8 77 13 00 00       	call   10167c <cons_putc>
    (*cnt) ++;
  100305:	8b 45 0c             	mov    0xc(%ebp),%eax
  100308:	8b 00                	mov    (%eax),%eax
  10030a:	8d 50 01             	lea    0x1(%eax),%edx
  10030d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100310:	89 10                	mov    %edx,(%eax)
}
  100312:	c9                   	leave  
  100313:	c3                   	ret    

00100314 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100314:	55                   	push   %ebp
  100315:	89 e5                	mov    %esp,%ebp
  100317:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10031a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100321:	8b 45 0c             	mov    0xc(%ebp),%eax
  100324:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100328:	8b 45 08             	mov    0x8(%ebp),%eax
  10032b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10032f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100332:	89 44 24 04          	mov    %eax,0x4(%esp)
  100336:	c7 04 24 f4 02 10 00 	movl   $0x1002f4,(%esp)
  10033d:	e8 ac 53 00 00       	call   1056ee <vprintfmt>
    return cnt;
  100342:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100345:	c9                   	leave  
  100346:	c3                   	ret    

00100347 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100347:	55                   	push   %ebp
  100348:	89 e5                	mov    %esp,%ebp
  10034a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10034d:	8d 55 0c             	lea    0xc(%ebp),%edx
  100350:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100353:	89 10                	mov    %edx,(%eax)
    cnt = vcprintf(fmt, ap);
  100355:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100358:	89 44 24 04          	mov    %eax,0x4(%esp)
  10035c:	8b 45 08             	mov    0x8(%ebp),%eax
  10035f:	89 04 24             	mov    %eax,(%esp)
  100362:	e8 ad ff ff ff       	call   100314 <vcprintf>
  100367:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10036a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10036d:	c9                   	leave  
  10036e:	c3                   	ret    

0010036f <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  10036f:	55                   	push   %ebp
  100370:	89 e5                	mov    %esp,%ebp
  100372:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100375:	8b 45 08             	mov    0x8(%ebp),%eax
  100378:	89 04 24             	mov    %eax,(%esp)
  10037b:	e8 fc 12 00 00       	call   10167c <cons_putc>
}
  100380:	c9                   	leave  
  100381:	c3                   	ret    

00100382 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100382:	55                   	push   %ebp
  100383:	89 e5                	mov    %esp,%ebp
  100385:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100388:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  10038f:	eb 13                	jmp    1003a4 <cputs+0x22>
        cputch(c, &cnt);
  100391:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100395:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100398:	89 54 24 04          	mov    %edx,0x4(%esp)
  10039c:	89 04 24             	mov    %eax,(%esp)
  10039f:	e8 50 ff ff ff       	call   1002f4 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  1003a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1003a7:	0f b6 00             	movzbl (%eax),%eax
  1003aa:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003ad:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003b1:	0f 95 c0             	setne  %al
  1003b4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1003b8:	84 c0                	test   %al,%al
  1003ba:	75 d5                	jne    100391 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1003bc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003c3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003ca:	e8 25 ff ff ff       	call   1002f4 <cputch>
    return cnt;
  1003cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003d2:	c9                   	leave  
  1003d3:	c3                   	ret    

001003d4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003d4:	55                   	push   %ebp
  1003d5:	89 e5                	mov    %esp,%ebp
  1003d7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003da:	e8 d9 12 00 00       	call   1016b8 <cons_getc>
  1003df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003e6:	74 f2                	je     1003da <getchar+0x6>
        /* do nothing */;
    return c;
  1003e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003eb:	c9                   	leave  
  1003ec:	c3                   	ret    
  1003ed:	00 00                	add    %al,(%eax)
	...

001003f0 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003f0:	55                   	push   %ebp
  1003f1:	89 e5                	mov    %esp,%ebp
  1003f3:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003f9:	8b 00                	mov    (%eax),%eax
  1003fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003fe:	8b 45 10             	mov    0x10(%ebp),%eax
  100401:	8b 00                	mov    (%eax),%eax
  100403:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100406:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  10040d:	e9 c6 00 00 00       	jmp    1004d8 <stab_binsearch+0xe8>
        int true_m = (l + r) / 2, m = true_m;
  100412:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100415:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100418:	01 d0                	add    %edx,%eax
  10041a:	89 c2                	mov    %eax,%edx
  10041c:	c1 ea 1f             	shr    $0x1f,%edx
  10041f:	01 d0                	add    %edx,%eax
  100421:	d1 f8                	sar    %eax
  100423:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100426:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100429:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10042c:	eb 04                	jmp    100432 <stab_binsearch+0x42>
            m --;
  10042e:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100432:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100435:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100438:	7c 1b                	jl     100455 <stab_binsearch+0x65>
  10043a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10043d:	89 d0                	mov    %edx,%eax
  10043f:	01 c0                	add    %eax,%eax
  100441:	01 d0                	add    %edx,%eax
  100443:	c1 e0 02             	shl    $0x2,%eax
  100446:	03 45 08             	add    0x8(%ebp),%eax
  100449:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10044d:	0f b6 c0             	movzbl %al,%eax
  100450:	3b 45 14             	cmp    0x14(%ebp),%eax
  100453:	75 d9                	jne    10042e <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  100455:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100458:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10045b:	7d 0b                	jge    100468 <stab_binsearch+0x78>
            l = true_m + 1;
  10045d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100460:	83 c0 01             	add    $0x1,%eax
  100463:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100466:	eb 70                	jmp    1004d8 <stab_binsearch+0xe8>
        }

        // actual binary search
        any_matches = 1;
  100468:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10046f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100472:	89 d0                	mov    %edx,%eax
  100474:	01 c0                	add    %eax,%eax
  100476:	01 d0                	add    %edx,%eax
  100478:	c1 e0 02             	shl    $0x2,%eax
  10047b:	03 45 08             	add    0x8(%ebp),%eax
  10047e:	8b 40 08             	mov    0x8(%eax),%eax
  100481:	3b 45 18             	cmp    0x18(%ebp),%eax
  100484:	73 13                	jae    100499 <stab_binsearch+0xa9>
            *region_left = m;
  100486:	8b 45 0c             	mov    0xc(%ebp),%eax
  100489:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10048c:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  10048e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100491:	83 c0 01             	add    $0x1,%eax
  100494:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100497:	eb 3f                	jmp    1004d8 <stab_binsearch+0xe8>
        } else if (stabs[m].n_value > addr) {
  100499:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10049c:	89 d0                	mov    %edx,%eax
  10049e:	01 c0                	add    %eax,%eax
  1004a0:	01 d0                	add    %edx,%eax
  1004a2:	c1 e0 02             	shl    $0x2,%eax
  1004a5:	03 45 08             	add    0x8(%ebp),%eax
  1004a8:	8b 40 08             	mov    0x8(%eax),%eax
  1004ab:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004ae:	76 16                	jbe    1004c6 <stab_binsearch+0xd6>
            *region_right = m - 1;
  1004b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b3:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004b6:	8b 45 10             	mov    0x10(%ebp),%eax
  1004b9:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004be:	83 e8 01             	sub    $0x1,%eax
  1004c1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004c4:	eb 12                	jmp    1004d8 <stab_binsearch+0xe8>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004cc:	89 10                	mov    %edx,(%eax)
            l = m;
  1004ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004d4:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004db:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004de:	0f 8e 2e ff ff ff    	jle    100412 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004e8:	75 0f                	jne    1004f9 <stab_binsearch+0x109>
        *region_right = *region_left - 1;
  1004ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004ed:	8b 00                	mov    (%eax),%eax
  1004ef:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004f2:	8b 45 10             	mov    0x10(%ebp),%eax
  1004f5:	89 10                	mov    %edx,(%eax)
  1004f7:	eb 3b                	jmp    100534 <stab_binsearch+0x144>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004f9:	8b 45 10             	mov    0x10(%ebp),%eax
  1004fc:	8b 00                	mov    (%eax),%eax
  1004fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  100501:	eb 04                	jmp    100507 <stab_binsearch+0x117>
  100503:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100507:	8b 45 0c             	mov    0xc(%ebp),%eax
  10050a:	8b 00                	mov    (%eax),%eax
  10050c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10050f:	7d 1b                	jge    10052c <stab_binsearch+0x13c>
  100511:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100514:	89 d0                	mov    %edx,%eax
  100516:	01 c0                	add    %eax,%eax
  100518:	01 d0                	add    %edx,%eax
  10051a:	c1 e0 02             	shl    $0x2,%eax
  10051d:	03 45 08             	add    0x8(%ebp),%eax
  100520:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100524:	0f b6 c0             	movzbl %al,%eax
  100527:	3b 45 14             	cmp    0x14(%ebp),%eax
  10052a:	75 d7                	jne    100503 <stab_binsearch+0x113>
            /* do nothing */;
        *region_left = l;
  10052c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100532:	89 10                	mov    %edx,(%eax)
    }
}
  100534:	c9                   	leave  
  100535:	c3                   	ret    

00100536 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100536:	55                   	push   %ebp
  100537:	89 e5                	mov    %esp,%ebp
  100539:	53                   	push   %ebx
  10053a:	83 ec 54             	sub    $0x54,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  10053d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100540:	c7 00 6c 61 10 00    	movl   $0x10616c,(%eax)
    info->eip_line = 0;
  100546:	8b 45 0c             	mov    0xc(%ebp),%eax
  100549:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100550:	8b 45 0c             	mov    0xc(%ebp),%eax
  100553:	c7 40 08 6c 61 10 00 	movl   $0x10616c,0x8(%eax)
    info->eip_fn_namelen = 9;
  10055a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10055d:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100564:	8b 45 0c             	mov    0xc(%ebp),%eax
  100567:	8b 55 08             	mov    0x8(%ebp),%edx
  10056a:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10056d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100570:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100577:	c7 45 f4 c0 73 10 00 	movl   $0x1073c0,-0xc(%ebp)
    stab_end = __STAB_END__;
  10057e:	c7 45 f0 88 20 11 00 	movl   $0x112088,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100585:	c7 45 ec 89 20 11 00 	movl   $0x112089,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10058c:	c7 45 e8 7b 4a 11 00 	movl   $0x114a7b,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100593:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100596:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100599:	76 0d                	jbe    1005a8 <debuginfo_eip+0x72>
  10059b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10059e:	83 e8 01             	sub    $0x1,%eax
  1005a1:	0f b6 00             	movzbl (%eax),%eax
  1005a4:	84 c0                	test   %al,%al
  1005a6:	74 0a                	je     1005b2 <debuginfo_eip+0x7c>
        return -1;
  1005a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005ad:	e9 9e 02 00 00       	jmp    100850 <debuginfo_eip+0x31a>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005b2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005bf:	89 d1                	mov    %edx,%ecx
  1005c1:	29 c1                	sub    %eax,%ecx
  1005c3:	89 c8                	mov    %ecx,%eax
  1005c5:	c1 f8 02             	sar    $0x2,%eax
  1005c8:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005ce:	83 e8 01             	sub    $0x1,%eax
  1005d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1005d7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005db:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005e2:	00 
  1005e3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ea:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005f4:	89 04 24             	mov    %eax,(%esp)
  1005f7:	e8 f4 fd ff ff       	call   1003f0 <stab_binsearch>
    if (lfile == 0)
  1005fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005ff:	85 c0                	test   %eax,%eax
  100601:	75 0a                	jne    10060d <debuginfo_eip+0xd7>
        return -1;
  100603:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100608:	e9 43 02 00 00       	jmp    100850 <debuginfo_eip+0x31a>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  10060d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100610:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100613:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100616:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100619:	8b 45 08             	mov    0x8(%ebp),%eax
  10061c:	89 44 24 10          	mov    %eax,0x10(%esp)
  100620:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100627:	00 
  100628:	8d 45 d8             	lea    -0x28(%ebp),%eax
  10062b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10062f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100632:	89 44 24 04          	mov    %eax,0x4(%esp)
  100636:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100639:	89 04 24             	mov    %eax,(%esp)
  10063c:	e8 af fd ff ff       	call   1003f0 <stab_binsearch>

    if (lfun <= rfun) {
  100641:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100644:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100647:	39 c2                	cmp    %eax,%edx
  100649:	7f 72                	jg     1006bd <debuginfo_eip+0x187>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10064b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10064e:	89 c2                	mov    %eax,%edx
  100650:	89 d0                	mov    %edx,%eax
  100652:	01 c0                	add    %eax,%eax
  100654:	01 d0                	add    %edx,%eax
  100656:	c1 e0 02             	shl    $0x2,%eax
  100659:	03 45 f4             	add    -0xc(%ebp),%eax
  10065c:	8b 10                	mov    (%eax),%edx
  10065e:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100661:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100664:	89 cb                	mov    %ecx,%ebx
  100666:	29 c3                	sub    %eax,%ebx
  100668:	89 d8                	mov    %ebx,%eax
  10066a:	39 c2                	cmp    %eax,%edx
  10066c:	73 1e                	jae    10068c <debuginfo_eip+0x156>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10066e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100671:	89 c2                	mov    %eax,%edx
  100673:	89 d0                	mov    %edx,%eax
  100675:	01 c0                	add    %eax,%eax
  100677:	01 d0                	add    %edx,%eax
  100679:	c1 e0 02             	shl    $0x2,%eax
  10067c:	03 45 f4             	add    -0xc(%ebp),%eax
  10067f:	8b 00                	mov    (%eax),%eax
  100681:	89 c2                	mov    %eax,%edx
  100683:	03 55 ec             	add    -0x14(%ebp),%edx
  100686:	8b 45 0c             	mov    0xc(%ebp),%eax
  100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068f:	89 c2                	mov    %eax,%edx
  100691:	89 d0                	mov    %edx,%eax
  100693:	01 c0                	add    %eax,%eax
  100695:	01 d0                	add    %edx,%eax
  100697:	c1 e0 02             	shl    $0x2,%eax
  10069a:	03 45 f4             	add    -0xc(%ebp),%eax
  10069d:	8b 50 08             	mov    0x8(%eax),%edx
  1006a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a3:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a9:	8b 40 10             	mov    0x10(%eax),%eax
  1006ac:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006b2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006b5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006b8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006bb:	eb 15                	jmp    1006d2 <debuginfo_eip+0x19c>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c0:	8b 55 08             	mov    0x8(%ebp),%edx
  1006c3:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006cf:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d5:	8b 40 08             	mov    0x8(%eax),%eax
  1006d8:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006df:	00 
  1006e0:	89 04 24             	mov    %eax,(%esp)
  1006e3:	e8 7b 56 00 00       	call   105d63 <strfind>
  1006e8:	89 c2                	mov    %eax,%edx
  1006ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ed:	8b 40 08             	mov    0x8(%eax),%eax
  1006f0:	29 c2                	sub    %eax,%edx
  1006f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f5:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1006fb:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006ff:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  100706:	00 
  100707:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10070a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10070e:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100711:	89 44 24 04          	mov    %eax,0x4(%esp)
  100715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100718:	89 04 24             	mov    %eax,(%esp)
  10071b:	e8 d0 fc ff ff       	call   1003f0 <stab_binsearch>
    if (lline <= rline) {
  100720:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100723:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100726:	39 c2                	cmp    %eax,%edx
  100728:	7f 20                	jg     10074a <debuginfo_eip+0x214>
        info->eip_line = stabs[rline].n_desc;
  10072a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10072d:	89 c2                	mov    %eax,%edx
  10072f:	89 d0                	mov    %edx,%eax
  100731:	01 c0                	add    %eax,%eax
  100733:	01 d0                	add    %edx,%eax
  100735:	c1 e0 02             	shl    $0x2,%eax
  100738:	03 45 f4             	add    -0xc(%ebp),%eax
  10073b:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10073f:	0f b7 d0             	movzwl %ax,%edx
  100742:	8b 45 0c             	mov    0xc(%ebp),%eax
  100745:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100748:	eb 13                	jmp    10075d <debuginfo_eip+0x227>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  10074a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10074f:	e9 fc 00 00 00       	jmp    100850 <debuginfo_eip+0x31a>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100754:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100757:	83 e8 01             	sub    $0x1,%eax
  10075a:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10075d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100760:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100763:	39 c2                	cmp    %eax,%edx
  100765:	7c 4a                	jl     1007b1 <debuginfo_eip+0x27b>
           && stabs[lline].n_type != N_SOL
  100767:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10076a:	89 c2                	mov    %eax,%edx
  10076c:	89 d0                	mov    %edx,%eax
  10076e:	01 c0                	add    %eax,%eax
  100770:	01 d0                	add    %edx,%eax
  100772:	c1 e0 02             	shl    $0x2,%eax
  100775:	03 45 f4             	add    -0xc(%ebp),%eax
  100778:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10077c:	3c 84                	cmp    $0x84,%al
  10077e:	74 31                	je     1007b1 <debuginfo_eip+0x27b>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100780:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100783:	89 c2                	mov    %eax,%edx
  100785:	89 d0                	mov    %edx,%eax
  100787:	01 c0                	add    %eax,%eax
  100789:	01 d0                	add    %edx,%eax
  10078b:	c1 e0 02             	shl    $0x2,%eax
  10078e:	03 45 f4             	add    -0xc(%ebp),%eax
  100791:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100795:	3c 64                	cmp    $0x64,%al
  100797:	75 bb                	jne    100754 <debuginfo_eip+0x21e>
  100799:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10079c:	89 c2                	mov    %eax,%edx
  10079e:	89 d0                	mov    %edx,%eax
  1007a0:	01 c0                	add    %eax,%eax
  1007a2:	01 d0                	add    %edx,%eax
  1007a4:	c1 e0 02             	shl    $0x2,%eax
  1007a7:	03 45 f4             	add    -0xc(%ebp),%eax
  1007aa:	8b 40 08             	mov    0x8(%eax),%eax
  1007ad:	85 c0                	test   %eax,%eax
  1007af:	74 a3                	je     100754 <debuginfo_eip+0x21e>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007b1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007b7:	39 c2                	cmp    %eax,%edx
  1007b9:	7c 40                	jl     1007fb <debuginfo_eip+0x2c5>
  1007bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007be:	89 c2                	mov    %eax,%edx
  1007c0:	89 d0                	mov    %edx,%eax
  1007c2:	01 c0                	add    %eax,%eax
  1007c4:	01 d0                	add    %edx,%eax
  1007c6:	c1 e0 02             	shl    $0x2,%eax
  1007c9:	03 45 f4             	add    -0xc(%ebp),%eax
  1007cc:	8b 10                	mov    (%eax),%edx
  1007ce:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007d4:	89 cb                	mov    %ecx,%ebx
  1007d6:	29 c3                	sub    %eax,%ebx
  1007d8:	89 d8                	mov    %ebx,%eax
  1007da:	39 c2                	cmp    %eax,%edx
  1007dc:	73 1d                	jae    1007fb <debuginfo_eip+0x2c5>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007e1:	89 c2                	mov    %eax,%edx
  1007e3:	89 d0                	mov    %edx,%eax
  1007e5:	01 c0                	add    %eax,%eax
  1007e7:	01 d0                	add    %edx,%eax
  1007e9:	c1 e0 02             	shl    $0x2,%eax
  1007ec:	03 45 f4             	add    -0xc(%ebp),%eax
  1007ef:	8b 00                	mov    (%eax),%eax
  1007f1:	89 c2                	mov    %eax,%edx
  1007f3:	03 55 ec             	add    -0x14(%ebp),%edx
  1007f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007f9:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007fb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100801:	39 c2                	cmp    %eax,%edx
  100803:	7d 46                	jge    10084b <debuginfo_eip+0x315>
        for (lline = lfun + 1;
  100805:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100808:	83 c0 01             	add    $0x1,%eax
  10080b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  10080e:	eb 18                	jmp    100828 <debuginfo_eip+0x2f2>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100810:	8b 45 0c             	mov    0xc(%ebp),%eax
  100813:	8b 40 14             	mov    0x14(%eax),%eax
  100816:	8d 50 01             	lea    0x1(%eax),%edx
  100819:	8b 45 0c             	mov    0xc(%ebp),%eax
  10081c:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  10081f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100822:	83 c0 01             	add    $0x1,%eax
  100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100828:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10082b:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  10082e:	39 c2                	cmp    %eax,%edx
  100830:	7d 19                	jge    10084b <debuginfo_eip+0x315>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100832:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100835:	89 c2                	mov    %eax,%edx
  100837:	89 d0                	mov    %edx,%eax
  100839:	01 c0                	add    %eax,%eax
  10083b:	01 d0                	add    %edx,%eax
  10083d:	c1 e0 02             	shl    $0x2,%eax
  100840:	03 45 f4             	add    -0xc(%ebp),%eax
  100843:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100847:	3c a0                	cmp    $0xa0,%al
  100849:	74 c5                	je     100810 <debuginfo_eip+0x2da>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  10084b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100850:	83 c4 54             	add    $0x54,%esp
  100853:	5b                   	pop    %ebx
  100854:	5d                   	pop    %ebp
  100855:	c3                   	ret    

00100856 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100856:	55                   	push   %ebp
  100857:	89 e5                	mov    %esp,%ebp
  100859:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10085c:	c7 04 24 76 61 10 00 	movl   $0x106176,(%esp)
  100863:	e8 df fa ff ff       	call   100347 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100868:	c7 44 24 04 2c 00 10 	movl   $0x10002c,0x4(%esp)
  10086f:	00 
  100870:	c7 04 24 8f 61 10 00 	movl   $0x10618f,(%esp)
  100877:	e8 cb fa ff ff       	call   100347 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10087c:	c7 44 24 04 a3 60 10 	movl   $0x1060a3,0x4(%esp)
  100883:	00 
  100884:	c7 04 24 a7 61 10 00 	movl   $0x1061a7,(%esp)
  10088b:	e8 b7 fa ff ff       	call   100347 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100890:	c7 44 24 04 38 7a 11 	movl   $0x117a38,0x4(%esp)
  100897:	00 
  100898:	c7 04 24 bf 61 10 00 	movl   $0x1061bf,(%esp)
  10089f:	e8 a3 fa ff ff       	call   100347 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008a4:	c7 44 24 04 68 89 11 	movl   $0x118968,0x4(%esp)
  1008ab:	00 
  1008ac:	c7 04 24 d7 61 10 00 	movl   $0x1061d7,(%esp)
  1008b3:	e8 8f fa ff ff       	call   100347 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008b8:	b8 68 89 11 00       	mov    $0x118968,%eax
  1008bd:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008c3:	b8 2c 00 10 00       	mov    $0x10002c,%eax
  1008c8:	89 d1                	mov    %edx,%ecx
  1008ca:	29 c1                	sub    %eax,%ecx
  1008cc:	89 c8                	mov    %ecx,%eax
  1008ce:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008d4:	85 c0                	test   %eax,%eax
  1008d6:	0f 48 c2             	cmovs  %edx,%eax
  1008d9:	c1 f8 0a             	sar    $0xa,%eax
  1008dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008e0:	c7 04 24 f0 61 10 00 	movl   $0x1061f0,(%esp)
  1008e7:	e8 5b fa ff ff       	call   100347 <cprintf>
}
  1008ec:	c9                   	leave  
  1008ed:	c3                   	ret    

001008ee <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1008ee:	55                   	push   %ebp
  1008ef:	89 e5                	mov    %esp,%ebp
  1008f1:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1008f7:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008fe:	8b 45 08             	mov    0x8(%ebp),%eax
  100901:	89 04 24             	mov    %eax,(%esp)
  100904:	e8 2d fc ff ff       	call   100536 <debuginfo_eip>
  100909:	85 c0                	test   %eax,%eax
  10090b:	74 15                	je     100922 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  10090d:	8b 45 08             	mov    0x8(%ebp),%eax
  100910:	89 44 24 04          	mov    %eax,0x4(%esp)
  100914:	c7 04 24 1a 62 10 00 	movl   $0x10621a,(%esp)
  10091b:	e8 27 fa ff ff       	call   100347 <cprintf>
  100920:	eb 69                	jmp    10098b <print_debuginfo+0x9d>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100922:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100929:	eb 1a                	jmp    100945 <print_debuginfo+0x57>
            fnname[j] = info.eip_fn_name[j];
  10092b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10092e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100931:	01 d0                	add    %edx,%eax
  100933:	0f b6 10             	movzbl (%eax),%edx
  100936:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  10093c:	03 45 f4             	add    -0xc(%ebp),%eax
  10093f:	88 10                	mov    %dl,(%eax)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100941:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100945:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100948:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10094b:	7f de                	jg     10092b <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  10094d:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  100953:	03 45 f4             	add    -0xc(%ebp),%eax
  100956:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100959:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  10095c:	8b 55 08             	mov    0x8(%ebp),%edx
  10095f:	89 d1                	mov    %edx,%ecx
  100961:	29 c1                	sub    %eax,%ecx
  100963:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100966:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100969:	89 4c 24 10          	mov    %ecx,0x10(%esp)
                fnname, eip - info.eip_fn_addr);
  10096d:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100973:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100977:	89 54 24 08          	mov    %edx,0x8(%esp)
  10097b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10097f:	c7 04 24 36 62 10 00 	movl   $0x106236,(%esp)
  100986:	e8 bc f9 ff ff       	call   100347 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  10098b:	c9                   	leave  
  10098c:	c3                   	ret    

0010098d <read_eip>:

static __noinline uint32_t
read_eip(void) {
  10098d:	55                   	push   %ebp
  10098e:	89 e5                	mov    %esp,%ebp
  100990:	53                   	push   %ebx
  100991:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100994:	8b 5d 04             	mov    0x4(%ebp),%ebx
  100997:	89 5d f8             	mov    %ebx,-0x8(%ebp)
    return eip;
  10099a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  10099d:	83 c4 10             	add    $0x10,%esp
  1009a0:	5b                   	pop    %ebx
  1009a1:	5d                   	pop    %ebp
  1009a2:	c3                   	ret    

001009a3 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009a3:	55                   	push   %ebp
  1009a4:	89 e5                	mov    %esp,%ebp
  1009a6:	53                   	push   %ebx
  1009a7:	83 ec 34             	sub    $0x34,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009aa:	89 eb                	mov    %ebp,%ebx
  1009ac:	89 5d e8             	mov    %ebx,-0x18(%ebp)
    return ebp;
  1009af:	8b 45 e8             	mov    -0x18(%ebp),%eax
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
        uint32_t ebp ,eip; 
        ebp=read_ebp();
  1009b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	eip=read_eip();
  1009b5:	e8 d3 ff ff ff       	call   10098d <read_eip>
  1009ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i, j; 
	for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  1009bd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009c4:	eb 7b                	jmp    100a41 <print_stackframe+0x9e>
	  cprintf("ebp:0x%08x eip:0x%08x",ebp,eip); 
  1009c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009c9:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009d4:	c7 04 24 48 62 10 00 	movl   $0x106248,(%esp)
  1009db:	e8 67 f9 ff ff       	call   100347 <cprintf>
	  cprintf(" args:0x%08x 0x%08x 0x%08x 0x%08x",*((uint32_t *)(ebp+8)),*((uint32_t *)(ebp+12)),*((uint32_t *)(ebp+16)),*((uint32_t *)(ebp+20)));
  1009e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009e3:	83 c0 14             	add    $0x14,%eax
  1009e6:	8b 18                	mov    (%eax),%ebx
  1009e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009eb:	83 c0 10             	add    $0x10,%eax
  1009ee:	8b 08                	mov    (%eax),%ecx
  1009f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009f3:	83 c0 0c             	add    $0xc,%eax
  1009f6:	8b 10                	mov    (%eax),%edx
  1009f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009fb:	83 c0 08             	add    $0x8,%eax
  1009fe:	8b 00                	mov    (%eax),%eax
  100a00:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  100a04:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a08:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a10:	c7 04 24 60 62 10 00 	movl   $0x106260,(%esp)
  100a17:	e8 2b f9 ff ff       	call   100347 <cprintf>
          print_debuginfo(eip-1); 
  100a1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a1f:	83 e8 01             	sub    $0x1,%eax
  100a22:	89 04 24             	mov    %eax,(%esp)
  100a25:	e8 c4 fe ff ff       	call   1008ee <print_debuginfo>
	  eip = *(uint32_t *)(ebp+4); 
  100a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a2d:	83 c0 04             	add    $0x4,%eax
  100a30:	8b 00                	mov    (%eax),%eax
  100a32:	89 45 f0             	mov    %eax,-0x10(%ebp)
          ebp = *(uint32_t *)(ebp);
  100a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a38:	8b 00                	mov    (%eax),%eax
  100a3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
      */
        uint32_t ebp ,eip; 
        ebp=read_ebp();
	eip=read_eip();
	int i, j; 
	for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100a3d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a45:	74 0a                	je     100a51 <print_stackframe+0xae>
  100a47:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a4b:	0f 8e 75 ff ff ff    	jle    1009c6 <print_stackframe+0x23>
	  cprintf(" args:0x%08x 0x%08x 0x%08x 0x%08x",*((uint32_t *)(ebp+8)),*((uint32_t *)(ebp+12)),*((uint32_t *)(ebp+16)),*((uint32_t *)(ebp+20)));
          print_debuginfo(eip-1); 
	  eip = *(uint32_t *)(ebp+4); 
          ebp = *(uint32_t *)(ebp);
	}
}
  100a51:	83 c4 34             	add    $0x34,%esp
  100a54:	5b                   	pop    %ebx
  100a55:	5d                   	pop    %ebp
  100a56:	c3                   	ret    
	...

00100a58 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a58:	55                   	push   %ebp
  100a59:	89 e5                	mov    %esp,%ebp
  100a5b:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a65:	eb 0d                	jmp    100a74 <parse+0x1c>
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
  100a67:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a68:	eb 0a                	jmp    100a74 <parse+0x1c>
            *buf ++ = '\0';
  100a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  100a6d:	c6 00 00             	movb   $0x0,(%eax)
  100a70:	83 45 08 01          	addl   $0x1,0x8(%ebp)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a74:	8b 45 08             	mov    0x8(%ebp),%eax
  100a77:	0f b6 00             	movzbl (%eax),%eax
  100a7a:	84 c0                	test   %al,%al
  100a7c:	74 1d                	je     100a9b <parse+0x43>
  100a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  100a81:	0f b6 00             	movzbl (%eax),%eax
  100a84:	0f be c0             	movsbl %al,%eax
  100a87:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a8b:	c7 04 24 04 63 10 00 	movl   $0x106304,(%esp)
  100a92:	e8 99 52 00 00       	call   105d30 <strchr>
  100a97:	85 c0                	test   %eax,%eax
  100a99:	75 cf                	jne    100a6a <parse+0x12>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  100a9e:	0f b6 00             	movzbl (%eax),%eax
  100aa1:	84 c0                	test   %al,%al
  100aa3:	74 5e                	je     100b03 <parse+0xab>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100aa5:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100aa9:	75 14                	jne    100abf <parse+0x67>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100aab:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ab2:	00 
  100ab3:	c7 04 24 09 63 10 00 	movl   $0x106309,(%esp)
  100aba:	e8 88 f8 ff ff       	call   100347 <cprintf>
        }
        argv[argc ++] = buf;
  100abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ac2:	c1 e0 02             	shl    $0x2,%eax
  100ac5:	03 45 0c             	add    0xc(%ebp),%eax
  100ac8:	8b 55 08             	mov    0x8(%ebp),%edx
  100acb:	89 10                	mov    %edx,(%eax)
  100acd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ad1:	eb 04                	jmp    100ad7 <parse+0x7f>
            buf ++;
  100ad3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  100ada:	0f b6 00             	movzbl (%eax),%eax
  100add:	84 c0                	test   %al,%al
  100adf:	74 86                	je     100a67 <parse+0xf>
  100ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  100ae4:	0f b6 00             	movzbl (%eax),%eax
  100ae7:	0f be c0             	movsbl %al,%eax
  100aea:	89 44 24 04          	mov    %eax,0x4(%esp)
  100aee:	c7 04 24 04 63 10 00 	movl   $0x106304,(%esp)
  100af5:	e8 36 52 00 00       	call   105d30 <strchr>
  100afa:	85 c0                	test   %eax,%eax
  100afc:	74 d5                	je     100ad3 <parse+0x7b>
            buf ++;
        }
    }
  100afe:	e9 64 ff ff ff       	jmp    100a67 <parse+0xf>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
  100b03:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b07:	c9                   	leave  
  100b08:	c3                   	ret    

00100b09 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b09:	55                   	push   %ebp
  100b0a:	89 e5                	mov    %esp,%ebp
  100b0c:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b0f:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b12:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b16:	8b 45 08             	mov    0x8(%ebp),%eax
  100b19:	89 04 24             	mov    %eax,(%esp)
  100b1c:	e8 37 ff ff ff       	call   100a58 <parse>
  100b21:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b28:	75 0a                	jne    100b34 <runcmd+0x2b>
        return 0;
  100b2a:	b8 00 00 00 00       	mov    $0x0,%eax
  100b2f:	e9 85 00 00 00       	jmp    100bb9 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b3b:	eb 5c                	jmp    100b99 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b3d:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b43:	89 d0                	mov    %edx,%eax
  100b45:	01 c0                	add    %eax,%eax
  100b47:	01 d0                	add    %edx,%eax
  100b49:	c1 e0 02             	shl    $0x2,%eax
  100b4c:	05 20 70 11 00       	add    $0x117020,%eax
  100b51:	8b 00                	mov    (%eax),%eax
  100b53:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b57:	89 04 24             	mov    %eax,(%esp)
  100b5a:	e8 2c 51 00 00       	call   105c8b <strcmp>
  100b5f:	85 c0                	test   %eax,%eax
  100b61:	75 32                	jne    100b95 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b66:	89 d0                	mov    %edx,%eax
  100b68:	01 c0                	add    %eax,%eax
  100b6a:	01 d0                	add    %edx,%eax
  100b6c:	c1 e0 02             	shl    $0x2,%eax
  100b6f:	05 20 70 11 00       	add    $0x117020,%eax
  100b74:	8b 50 08             	mov    0x8(%eax),%edx
  100b77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b7a:	8d 48 ff             	lea    -0x1(%eax),%ecx
  100b7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b80:	89 44 24 08          	mov    %eax,0x8(%esp)
  100b84:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b87:	83 c0 04             	add    $0x4,%eax
  100b8a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b8e:	89 0c 24             	mov    %ecx,(%esp)
  100b91:	ff d2                	call   *%edx
  100b93:	eb 24                	jmp    100bb9 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b95:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b9c:	83 f8 02             	cmp    $0x2,%eax
  100b9f:	76 9c                	jbe    100b3d <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100ba1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100ba4:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ba8:	c7 04 24 27 63 10 00 	movl   $0x106327,(%esp)
  100baf:	e8 93 f7 ff ff       	call   100347 <cprintf>
    return 0;
  100bb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bb9:	c9                   	leave  
  100bba:	c3                   	ret    

00100bbb <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bbb:	55                   	push   %ebp
  100bbc:	89 e5                	mov    %esp,%ebp
  100bbe:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bc1:	c7 04 24 40 63 10 00 	movl   $0x106340,(%esp)
  100bc8:	e8 7a f7 ff ff       	call   100347 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bcd:	c7 04 24 68 63 10 00 	movl   $0x106368,(%esp)
  100bd4:	e8 6e f7 ff ff       	call   100347 <cprintf>

    if (tf != NULL) {
  100bd9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100bdd:	74 0e                	je     100bed <kmonitor+0x32>
        print_trapframe(tf);
  100bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  100be2:	89 04 24             	mov    %eax,(%esp)
  100be5:	e8 e2 0e 00 00       	call   101acc <print_trapframe>
  100bea:	eb 01                	jmp    100bed <kmonitor+0x32>
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
            }
        }
    }
  100bec:	90                   	nop
        print_trapframe(tf);
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100bed:	c7 04 24 8d 63 10 00 	movl   $0x10638d,(%esp)
  100bf4:	e8 3f f6 ff ff       	call   100238 <readline>
  100bf9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100bfc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c00:	74 ea                	je     100bec <kmonitor+0x31>
            if (runcmd(buf, tf) < 0) {
  100c02:	8b 45 08             	mov    0x8(%ebp),%eax
  100c05:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c0c:	89 04 24             	mov    %eax,(%esp)
  100c0f:	e8 f5 fe ff ff       	call   100b09 <runcmd>
  100c14:	85 c0                	test   %eax,%eax
  100c16:	79 d4                	jns    100bec <kmonitor+0x31>
                break;
  100c18:	90                   	nop
            }
        }
    }
}
  100c19:	c9                   	leave  
  100c1a:	c3                   	ret    

00100c1b <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c1b:	55                   	push   %ebp
  100c1c:	89 e5                	mov    %esp,%ebp
  100c1e:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c21:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c28:	eb 3f                	jmp    100c69 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c2d:	89 d0                	mov    %edx,%eax
  100c2f:	01 c0                	add    %eax,%eax
  100c31:	01 d0                	add    %edx,%eax
  100c33:	c1 e0 02             	shl    $0x2,%eax
  100c36:	05 20 70 11 00       	add    $0x117020,%eax
  100c3b:	8b 48 04             	mov    0x4(%eax),%ecx
  100c3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c41:	89 d0                	mov    %edx,%eax
  100c43:	01 c0                	add    %eax,%eax
  100c45:	01 d0                	add    %edx,%eax
  100c47:	c1 e0 02             	shl    $0x2,%eax
  100c4a:	05 20 70 11 00       	add    $0x117020,%eax
  100c4f:	8b 00                	mov    (%eax),%eax
  100c51:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c55:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c59:	c7 04 24 91 63 10 00 	movl   $0x106391,(%esp)
  100c60:	e8 e2 f6 ff ff       	call   100347 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c65:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c6c:	83 f8 02             	cmp    $0x2,%eax
  100c6f:	76 b9                	jbe    100c2a <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c76:	c9                   	leave  
  100c77:	c3                   	ret    

00100c78 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c78:	55                   	push   %ebp
  100c79:	89 e5                	mov    %esp,%ebp
  100c7b:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c7e:	e8 d3 fb ff ff       	call   100856 <print_kerninfo>
    return 0;
  100c83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c88:	c9                   	leave  
  100c89:	c3                   	ret    

00100c8a <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100c8a:	55                   	push   %ebp
  100c8b:	89 e5                	mov    %esp,%ebp
  100c8d:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100c90:	e8 0e fd ff ff       	call   1009a3 <print_stackframe>
    return 0;
  100c95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c9a:	c9                   	leave  
  100c9b:	c3                   	ret    

00100c9c <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100c9c:	55                   	push   %ebp
  100c9d:	89 e5                	mov    %esp,%ebp
  100c9f:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100ca2:	a1 60 7e 11 00       	mov    0x117e60,%eax
  100ca7:	85 c0                	test   %eax,%eax
  100ca9:	75 4c                	jne    100cf7 <__panic+0x5b>
        goto panic_dead;
    }
    is_panic = 1;
  100cab:	c7 05 60 7e 11 00 01 	movl   $0x1,0x117e60
  100cb2:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cb5:	8d 55 14             	lea    0x14(%ebp),%edx
  100cb8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100cbb:	89 10                	mov    %edx,(%eax)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cc0:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  100cc7:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ccb:	c7 04 24 9a 63 10 00 	movl   $0x10639a,(%esp)
  100cd2:	e8 70 f6 ff ff       	call   100347 <cprintf>
    vcprintf(fmt, ap);
  100cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cda:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cde:	8b 45 10             	mov    0x10(%ebp),%eax
  100ce1:	89 04 24             	mov    %eax,(%esp)
  100ce4:	e8 2b f6 ff ff       	call   100314 <vcprintf>
    cprintf("\n");
  100ce9:	c7 04 24 b6 63 10 00 	movl   $0x1063b6,(%esp)
  100cf0:	e8 52 f6 ff ff       	call   100347 <cprintf>
  100cf5:	eb 01                	jmp    100cf8 <__panic+0x5c>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
  100cf7:	90                   	nop
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    intr_disable();
  100cf8:	e8 31 0a 00 00       	call   10172e <intr_disable>
    while (1) {
        kmonitor(NULL);
  100cfd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d04:	e8 b2 fe ff ff       	call   100bbb <kmonitor>
    }
  100d09:	eb f2                	jmp    100cfd <__panic+0x61>

00100d0b <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d0b:	55                   	push   %ebp
  100d0c:	89 e5                	mov    %esp,%ebp
  100d0e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d11:	8d 55 14             	lea    0x14(%ebp),%edx
  100d14:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100d17:	89 10                	mov    %edx,(%eax)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d19:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d1c:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d20:	8b 45 08             	mov    0x8(%ebp),%eax
  100d23:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d27:	c7 04 24 b8 63 10 00 	movl   $0x1063b8,(%esp)
  100d2e:	e8 14 f6 ff ff       	call   100347 <cprintf>
    vcprintf(fmt, ap);
  100d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d36:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d3a:	8b 45 10             	mov    0x10(%ebp),%eax
  100d3d:	89 04 24             	mov    %eax,(%esp)
  100d40:	e8 cf f5 ff ff       	call   100314 <vcprintf>
    cprintf("\n");
  100d45:	c7 04 24 b6 63 10 00 	movl   $0x1063b6,(%esp)
  100d4c:	e8 f6 f5 ff ff       	call   100347 <cprintf>
    va_end(ap);
}
  100d51:	c9                   	leave  
  100d52:	c3                   	ret    

00100d53 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d53:	55                   	push   %ebp
  100d54:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d56:	a1 60 7e 11 00       	mov    0x117e60,%eax
}
  100d5b:	5d                   	pop    %ebp
  100d5c:	c3                   	ret    
  100d5d:	00 00                	add    %al,(%eax)
	...

00100d60 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d60:	55                   	push   %ebp
  100d61:	89 e5                	mov    %esp,%ebp
  100d63:	83 ec 28             	sub    $0x28,%esp
  100d66:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d6c:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d70:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d74:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d78:	ee                   	out    %al,(%dx)
  100d79:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d7f:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d83:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d87:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d8b:	ee                   	out    %al,(%dx)
  100d8c:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100d92:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100d96:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d9a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d9e:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d9f:	c7 05 4c 89 11 00 00 	movl   $0x0,0x11894c
  100da6:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100da9:	c7 04 24 d6 63 10 00 	movl   $0x1063d6,(%esp)
  100db0:	e8 92 f5 ff ff       	call   100347 <cprintf>
    pic_enable(IRQ_TIMER);
  100db5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100dbc:	e8 cb 09 00 00       	call   10178c <pic_enable>
}
  100dc1:	c9                   	leave  
  100dc2:	c3                   	ret    
	...

00100dc4 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100dc4:	55                   	push   %ebp
  100dc5:	89 e5                	mov    %esp,%ebp
  100dc7:	53                   	push   %ebx
  100dc8:	83 ec 14             	sub    $0x14,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100dcb:	9c                   	pushf  
  100dcc:	5b                   	pop    %ebx
  100dcd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return eflags;
  100dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100dd3:	25 00 02 00 00       	and    $0x200,%eax
  100dd8:	85 c0                	test   %eax,%eax
  100dda:	74 0c                	je     100de8 <__intr_save+0x24>
        intr_disable();
  100ddc:	e8 4d 09 00 00       	call   10172e <intr_disable>
        return 1;
  100de1:	b8 01 00 00 00       	mov    $0x1,%eax
  100de6:	eb 05                	jmp    100ded <__intr_save+0x29>
    }
    return 0;
  100de8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ded:	83 c4 14             	add    $0x14,%esp
  100df0:	5b                   	pop    %ebx
  100df1:	5d                   	pop    %ebp
  100df2:	c3                   	ret    

00100df3 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100df3:	55                   	push   %ebp
  100df4:	89 e5                	mov    %esp,%ebp
  100df6:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100df9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100dfd:	74 05                	je     100e04 <__intr_restore+0x11>
        intr_enable();
  100dff:	e8 24 09 00 00       	call   101728 <intr_enable>
    }
}
  100e04:	c9                   	leave  
  100e05:	c3                   	ret    

00100e06 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e06:	55                   	push   %ebp
  100e07:	89 e5                	mov    %esp,%ebp
  100e09:	53                   	push   %ebx
  100e0a:	83 ec 14             	sub    $0x14,%esp
  100e0d:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e13:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e17:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  100e1b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100e1f:	ec                   	in     (%dx),%al
  100e20:	89 c3                	mov    %eax,%ebx
  100e22:	88 5d f9             	mov    %bl,-0x7(%ebp)
    return data;
  100e25:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e2b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100e2f:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  100e33:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100e37:	ec                   	in     (%dx),%al
  100e38:	89 c3                	mov    %eax,%ebx
  100e3a:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
  100e3d:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e43:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e47:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  100e4b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100e4f:	ec                   	in     (%dx),%al
  100e50:	89 c3                	mov    %eax,%ebx
  100e52:	88 5d f1             	mov    %bl,-0xf(%ebp)
    return data;
  100e55:	66 c7 45 ee 84 00    	movw   $0x84,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e5b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100e5f:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  100e63:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100e67:	ec                   	in     (%dx),%al
  100e68:	89 c3                	mov    %eax,%ebx
  100e6a:	88 5d ed             	mov    %bl,-0x13(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e6d:	83 c4 14             	add    $0x14,%esp
  100e70:	5b                   	pop    %ebx
  100e71:	5d                   	pop    %ebp
  100e72:	c3                   	ret    

00100e73 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e73:	55                   	push   %ebp
  100e74:	89 e5                	mov    %esp,%ebp
  100e76:	53                   	push   %ebx
  100e77:	83 ec 24             	sub    $0x24,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e7a:	c7 45 f8 00 80 0b c0 	movl   $0xc00b8000,-0x8(%ebp)
    uint16_t was = *cp;
  100e81:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100e84:	0f b7 00             	movzwl (%eax),%eax
  100e87:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100e8e:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e93:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100e96:	0f b7 00             	movzwl (%eax),%eax
  100e99:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e9d:	74 12                	je     100eb1 <cga_init+0x3e>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100e9f:	c7 45 f8 00 00 0b c0 	movl   $0xc00b0000,-0x8(%ebp)
        addr_6845 = MONO_BASE;
  100ea6:	66 c7 05 86 7e 11 00 	movw   $0x3b4,0x117e86
  100ead:	b4 03 
  100eaf:	eb 13                	jmp    100ec4 <cga_init+0x51>
    } else {
        *cp = was;
  100eb1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100eb4:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100eb8:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100ebb:	66 c7 05 86 7e 11 00 	movw   $0x3d4,0x117e86
  100ec2:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100ec4:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ecb:	0f b7 c0             	movzwl %ax,%eax
  100ece:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100ed2:	c6 45 ed 0e          	movb   $0xe,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ed6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100eda:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100ede:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100edf:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ee6:	83 c0 01             	add    $0x1,%eax
  100ee9:	0f b7 c0             	movzwl %ax,%eax
  100eec:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ef0:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100ef4:	66 89 55 da          	mov    %dx,-0x26(%ebp)
  100ef8:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100efc:	ec                   	in     (%dx),%al
  100efd:	89 c3                	mov    %eax,%ebx
  100eff:	88 5d e9             	mov    %bl,-0x17(%ebp)
    return data;
  100f02:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f06:	0f b6 c0             	movzbl %al,%eax
  100f09:	c1 e0 08             	shl    $0x8,%eax
  100f0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    outb(addr_6845, 15);
  100f0f:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f16:	0f b7 c0             	movzwl %ax,%eax
  100f19:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100f1d:	c6 45 e5 0f          	movb   $0xf,-0x1b(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f21:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f25:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f29:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f2a:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f31:	83 c0 01             	add    $0x1,%eax
  100f34:	0f b7 c0             	movzwl %ax,%eax
  100f37:	66 89 45 e2          	mov    %ax,-0x1e(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f3b:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f3f:	66 89 55 da          	mov    %dx,-0x26(%ebp)
  100f43:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100f47:	ec                   	in     (%dx),%al
  100f48:	89 c3                	mov    %eax,%ebx
  100f4a:	88 5d e1             	mov    %bl,-0x1f(%ebp)
    return data;
  100f4d:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f51:	0f b6 c0             	movzbl %al,%eax
  100f54:	09 45 f0             	or     %eax,-0x10(%ebp)

    crt_buf = (uint16_t*) cp;
  100f57:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100f5a:	a3 80 7e 11 00       	mov    %eax,0x117e80
    crt_pos = pos;
  100f5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100f62:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
}
  100f68:	83 c4 24             	add    $0x24,%esp
  100f6b:	5b                   	pop    %ebx
  100f6c:	5d                   	pop    %ebp
  100f6d:	c3                   	ret    

00100f6e <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f6e:	55                   	push   %ebp
  100f6f:	89 e5                	mov    %esp,%ebp
  100f71:	53                   	push   %ebx
  100f72:	83 ec 54             	sub    $0x54,%esp
  100f75:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f7b:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f7f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f83:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f87:	ee                   	out    %al,(%dx)
  100f88:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f8e:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f92:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f96:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f9a:	ee                   	out    %al,(%dx)
  100f9b:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100fa1:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100fa5:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100fa9:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100fad:	ee                   	out    %al,(%dx)
  100fae:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fb4:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100fb8:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100fbc:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fc0:	ee                   	out    %al,(%dx)
  100fc1:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100fc7:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100fcb:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fcf:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fd3:	ee                   	out    %al,(%dx)
  100fd4:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100fda:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100fde:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fe2:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fe6:	ee                   	out    %al,(%dx)
  100fe7:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fed:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100ff1:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100ff5:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100ff9:	ee                   	out    %al,(%dx)
  100ffa:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101000:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101004:	66 89 55 c6          	mov    %dx,-0x3a(%ebp)
  101008:	0f b7 55 c6          	movzwl -0x3a(%ebp),%edx
  10100c:	ec                   	in     (%dx),%al
  10100d:	89 c3                	mov    %eax,%ebx
  10100f:	88 5d d9             	mov    %bl,-0x27(%ebp)
    return data;
  101012:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  101016:	3c ff                	cmp    $0xff,%al
  101018:	0f 95 c0             	setne  %al
  10101b:	0f b6 c0             	movzbl %al,%eax
  10101e:	a3 88 7e 11 00       	mov    %eax,0x117e88
  101023:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101029:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10102d:	66 89 55 c6          	mov    %dx,-0x3a(%ebp)
  101031:	0f b7 55 c6          	movzwl -0x3a(%ebp),%edx
  101035:	ec                   	in     (%dx),%al
  101036:	89 c3                	mov    %eax,%ebx
  101038:	88 5d d5             	mov    %bl,-0x2b(%ebp)
    return data;
  10103b:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101041:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101045:	66 89 55 c6          	mov    %dx,-0x3a(%ebp)
  101049:	0f b7 55 c6          	movzwl -0x3a(%ebp),%edx
  10104d:	ec                   	in     (%dx),%al
  10104e:	89 c3                	mov    %eax,%ebx
  101050:	88 5d d1             	mov    %bl,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101053:	a1 88 7e 11 00       	mov    0x117e88,%eax
  101058:	85 c0                	test   %eax,%eax
  10105a:	74 0c                	je     101068 <serial_init+0xfa>
        pic_enable(IRQ_COM1);
  10105c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101063:	e8 24 07 00 00       	call   10178c <pic_enable>
    }
}
  101068:	83 c4 54             	add    $0x54,%esp
  10106b:	5b                   	pop    %ebx
  10106c:	5d                   	pop    %ebp
  10106d:	c3                   	ret    

0010106e <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  10106e:	55                   	push   %ebp
  10106f:	89 e5                	mov    %esp,%ebp
  101071:	53                   	push   %ebx
  101072:	83 ec 24             	sub    $0x24,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101075:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  10107c:	eb 09                	jmp    101087 <lpt_putc_sub+0x19>
        delay();
  10107e:	e8 83 fd ff ff       	call   100e06 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101083:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  101087:	66 c7 45 f6 79 03    	movw   $0x379,-0xa(%ebp)
  10108d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101091:	66 89 55 da          	mov    %dx,-0x26(%ebp)
  101095:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101099:	ec                   	in     (%dx),%al
  10109a:	89 c3                	mov    %eax,%ebx
  10109c:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
  10109f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1010a3:	84 c0                	test   %al,%al
  1010a5:	78 09                	js     1010b0 <lpt_putc_sub+0x42>
  1010a7:	81 7d f8 ff 31 00 00 	cmpl   $0x31ff,-0x8(%ebp)
  1010ae:	7e ce                	jle    10107e <lpt_putc_sub+0x10>
        delay();
    }
    outb(LPTPORT + 0, c);
  1010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1010b3:	0f b6 c0             	movzbl %al,%eax
  1010b6:	66 c7 45 f2 78 03    	movw   $0x378,-0xe(%ebp)
  1010bc:	88 45 f1             	mov    %al,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1010bf:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010c3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010c7:	ee                   	out    %al,(%dx)
  1010c8:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  1010ce:	c6 45 ed 0d          	movb   $0xd,-0x13(%ebp)
  1010d2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010d6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010da:	ee                   	out    %al,(%dx)
  1010db:	66 c7 45 ea 7a 03    	movw   $0x37a,-0x16(%ebp)
  1010e1:	c6 45 e9 08          	movb   $0x8,-0x17(%ebp)
  1010e5:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1010e9:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1010ed:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010ee:	83 c4 24             	add    $0x24,%esp
  1010f1:	5b                   	pop    %ebx
  1010f2:	5d                   	pop    %ebp
  1010f3:	c3                   	ret    

001010f4 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010f4:	55                   	push   %ebp
  1010f5:	89 e5                	mov    %esp,%ebp
  1010f7:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010fa:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010fe:	74 0d                	je     10110d <lpt_putc+0x19>
        lpt_putc_sub(c);
  101100:	8b 45 08             	mov    0x8(%ebp),%eax
  101103:	89 04 24             	mov    %eax,(%esp)
  101106:	e8 63 ff ff ff       	call   10106e <lpt_putc_sub>
  10110b:	eb 24                	jmp    101131 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  10110d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101114:	e8 55 ff ff ff       	call   10106e <lpt_putc_sub>
        lpt_putc_sub(' ');
  101119:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101120:	e8 49 ff ff ff       	call   10106e <lpt_putc_sub>
        lpt_putc_sub('\b');
  101125:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10112c:	e8 3d ff ff ff       	call   10106e <lpt_putc_sub>
    }
}
  101131:	c9                   	leave  
  101132:	c3                   	ret    

00101133 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101133:	55                   	push   %ebp
  101134:	89 e5                	mov    %esp,%ebp
  101136:	53                   	push   %ebx
  101137:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  10113a:	8b 45 08             	mov    0x8(%ebp),%eax
  10113d:	b0 00                	mov    $0x0,%al
  10113f:	85 c0                	test   %eax,%eax
  101141:	75 07                	jne    10114a <cga_putc+0x17>
        c |= 0x0700;
  101143:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10114a:	8b 45 08             	mov    0x8(%ebp),%eax
  10114d:	25 ff 00 00 00       	and    $0xff,%eax
  101152:	83 f8 0a             	cmp    $0xa,%eax
  101155:	74 4e                	je     1011a5 <cga_putc+0x72>
  101157:	83 f8 0d             	cmp    $0xd,%eax
  10115a:	74 59                	je     1011b5 <cga_putc+0x82>
  10115c:	83 f8 08             	cmp    $0x8,%eax
  10115f:	0f 85 8c 00 00 00    	jne    1011f1 <cga_putc+0xbe>
    case '\b':
        if (crt_pos > 0) {
  101165:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10116c:	66 85 c0             	test   %ax,%ax
  10116f:	0f 84 a1 00 00 00    	je     101216 <cga_putc+0xe3>
            crt_pos --;
  101175:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10117c:	83 e8 01             	sub    $0x1,%eax
  10117f:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101185:	a1 80 7e 11 00       	mov    0x117e80,%eax
  10118a:	0f b7 15 84 7e 11 00 	movzwl 0x117e84,%edx
  101191:	0f b7 d2             	movzwl %dx,%edx
  101194:	01 d2                	add    %edx,%edx
  101196:	01 c2                	add    %eax,%edx
  101198:	8b 45 08             	mov    0x8(%ebp),%eax
  10119b:	b0 00                	mov    $0x0,%al
  10119d:	83 c8 20             	or     $0x20,%eax
  1011a0:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1011a3:	eb 71                	jmp    101216 <cga_putc+0xe3>
    case '\n':
        crt_pos += CRT_COLS;
  1011a5:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011ac:	83 c0 50             	add    $0x50,%eax
  1011af:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1011b5:	0f b7 1d 84 7e 11 00 	movzwl 0x117e84,%ebx
  1011bc:	0f b7 0d 84 7e 11 00 	movzwl 0x117e84,%ecx
  1011c3:	0f b7 c1             	movzwl %cx,%eax
  1011c6:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  1011cc:	c1 e8 10             	shr    $0x10,%eax
  1011cf:	89 c2                	mov    %eax,%edx
  1011d1:	66 c1 ea 06          	shr    $0x6,%dx
  1011d5:	89 d0                	mov    %edx,%eax
  1011d7:	c1 e0 02             	shl    $0x2,%eax
  1011da:	01 d0                	add    %edx,%eax
  1011dc:	c1 e0 04             	shl    $0x4,%eax
  1011df:	89 ca                	mov    %ecx,%edx
  1011e1:	66 29 c2             	sub    %ax,%dx
  1011e4:	89 d8                	mov    %ebx,%eax
  1011e6:	66 29 d0             	sub    %dx,%ax
  1011e9:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
        break;
  1011ef:	eb 26                	jmp    101217 <cga_putc+0xe4>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011f1:	8b 15 80 7e 11 00    	mov    0x117e80,%edx
  1011f7:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011fe:	0f b7 c8             	movzwl %ax,%ecx
  101201:	01 c9                	add    %ecx,%ecx
  101203:	01 d1                	add    %edx,%ecx
  101205:	8b 55 08             	mov    0x8(%ebp),%edx
  101208:	66 89 11             	mov    %dx,(%ecx)
  10120b:	83 c0 01             	add    $0x1,%eax
  10120e:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
        break;
  101214:	eb 01                	jmp    101217 <cga_putc+0xe4>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
  101216:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101217:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10121e:	66 3d cf 07          	cmp    $0x7cf,%ax
  101222:	76 5b                	jbe    10127f <cga_putc+0x14c>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101224:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101229:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10122f:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101234:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  10123b:	00 
  10123c:	89 54 24 04          	mov    %edx,0x4(%esp)
  101240:	89 04 24             	mov    %eax,(%esp)
  101243:	e8 ee 4c 00 00       	call   105f36 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101248:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10124f:	eb 15                	jmp    101266 <cga_putc+0x133>
            crt_buf[i] = 0x0700 | ' ';
  101251:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101256:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101259:	01 d2                	add    %edx,%edx
  10125b:	01 d0                	add    %edx,%eax
  10125d:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101262:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101266:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10126d:	7e e2                	jle    101251 <cga_putc+0x11e>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  10126f:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101276:	83 e8 50             	sub    $0x50,%eax
  101279:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  10127f:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  101286:	0f b7 c0             	movzwl %ax,%eax
  101289:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  10128d:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  101291:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101295:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101299:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  10129a:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1012a1:	66 c1 e8 08          	shr    $0x8,%ax
  1012a5:	0f b6 c0             	movzbl %al,%eax
  1012a8:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  1012af:	83 c2 01             	add    $0x1,%edx
  1012b2:	0f b7 d2             	movzwl %dx,%edx
  1012b5:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  1012b9:	88 45 ed             	mov    %al,-0x13(%ebp)
  1012bc:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1012c0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1012c4:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  1012c5:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  1012cc:	0f b7 c0             	movzwl %ax,%eax
  1012cf:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  1012d3:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  1012d7:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1012db:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1012df:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  1012e0:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1012e7:	0f b6 c0             	movzbl %al,%eax
  1012ea:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  1012f1:	83 c2 01             	add    $0x1,%edx
  1012f4:	0f b7 d2             	movzwl %dx,%edx
  1012f7:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  1012fb:	88 45 e5             	mov    %al,-0x1b(%ebp)
  1012fe:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101302:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101306:	ee                   	out    %al,(%dx)
}
  101307:	83 c4 34             	add    $0x34,%esp
  10130a:	5b                   	pop    %ebx
  10130b:	5d                   	pop    %ebp
  10130c:	c3                   	ret    

0010130d <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  10130d:	55                   	push   %ebp
  10130e:	89 e5                	mov    %esp,%ebp
  101310:	53                   	push   %ebx
  101311:	83 ec 14             	sub    $0x14,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101314:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  10131b:	eb 09                	jmp    101326 <serial_putc_sub+0x19>
        delay();
  10131d:	e8 e4 fa ff ff       	call   100e06 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101322:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  101326:	66 c7 45 f6 fd 03    	movw   $0x3fd,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10132c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101330:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  101334:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101338:	ec                   	in     (%dx),%al
  101339:	89 c3                	mov    %eax,%ebx
  10133b:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
  10133e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101342:	0f b6 c0             	movzbl %al,%eax
  101345:	83 e0 20             	and    $0x20,%eax
  101348:	85 c0                	test   %eax,%eax
  10134a:	75 09                	jne    101355 <serial_putc_sub+0x48>
  10134c:	81 7d f8 ff 31 00 00 	cmpl   $0x31ff,-0x8(%ebp)
  101353:	7e c8                	jle    10131d <serial_putc_sub+0x10>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101355:	8b 45 08             	mov    0x8(%ebp),%eax
  101358:	0f b6 c0             	movzbl %al,%eax
  10135b:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
  101361:	88 45 f1             	mov    %al,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101364:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101368:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10136c:	ee                   	out    %al,(%dx)
}
  10136d:	83 c4 14             	add    $0x14,%esp
  101370:	5b                   	pop    %ebx
  101371:	5d                   	pop    %ebp
  101372:	c3                   	ret    

00101373 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101373:	55                   	push   %ebp
  101374:	89 e5                	mov    %esp,%ebp
  101376:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101379:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10137d:	74 0d                	je     10138c <serial_putc+0x19>
        serial_putc_sub(c);
  10137f:	8b 45 08             	mov    0x8(%ebp),%eax
  101382:	89 04 24             	mov    %eax,(%esp)
  101385:	e8 83 ff ff ff       	call   10130d <serial_putc_sub>
  10138a:	eb 24                	jmp    1013b0 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  10138c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101393:	e8 75 ff ff ff       	call   10130d <serial_putc_sub>
        serial_putc_sub(' ');
  101398:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10139f:	e8 69 ff ff ff       	call   10130d <serial_putc_sub>
        serial_putc_sub('\b');
  1013a4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013ab:	e8 5d ff ff ff       	call   10130d <serial_putc_sub>
    }
}
  1013b0:	c9                   	leave  
  1013b1:	c3                   	ret    

001013b2 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1013b2:	55                   	push   %ebp
  1013b3:	89 e5                	mov    %esp,%ebp
  1013b5:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1013b8:	eb 32                	jmp    1013ec <cons_intr+0x3a>
        if (c != 0) {
  1013ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1013be:	74 2c                	je     1013ec <cons_intr+0x3a>
            cons.buf[cons.wpos ++] = c;
  1013c0:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  1013c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1013c8:	88 90 a0 7e 11 00    	mov    %dl,0x117ea0(%eax)
  1013ce:	83 c0 01             	add    $0x1,%eax
  1013d1:	a3 a4 80 11 00       	mov    %eax,0x1180a4
            if (cons.wpos == CONSBUFSIZE) {
  1013d6:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  1013db:	3d 00 02 00 00       	cmp    $0x200,%eax
  1013e0:	75 0a                	jne    1013ec <cons_intr+0x3a>
                cons.wpos = 0;
  1013e2:	c7 05 a4 80 11 00 00 	movl   $0x0,0x1180a4
  1013e9:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  1013ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1013ef:	ff d0                	call   *%eax
  1013f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1013f4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013f8:	75 c0                	jne    1013ba <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  1013fa:	c9                   	leave  
  1013fb:	c3                   	ret    

001013fc <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013fc:	55                   	push   %ebp
  1013fd:	89 e5                	mov    %esp,%ebp
  1013ff:	53                   	push   %ebx
  101400:	83 ec 14             	sub    $0x14,%esp
  101403:	66 c7 45 f6 fd 03    	movw   $0x3fd,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101409:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10140d:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  101411:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101415:	ec                   	in     (%dx),%al
  101416:	89 c3                	mov    %eax,%ebx
  101418:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
  10141b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10141f:	0f b6 c0             	movzbl %al,%eax
  101422:	83 e0 01             	and    $0x1,%eax
  101425:	85 c0                	test   %eax,%eax
  101427:	75 07                	jne    101430 <serial_proc_data+0x34>
        return -1;
  101429:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10142e:	eb 32                	jmp    101462 <serial_proc_data+0x66>
  101430:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101436:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10143a:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  10143e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101442:	ec                   	in     (%dx),%al
  101443:	89 c3                	mov    %eax,%ebx
  101445:	88 5d f1             	mov    %bl,-0xf(%ebp)
    return data;
  101448:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10144c:	0f b6 c0             	movzbl %al,%eax
  10144f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if (c == 127) {
  101452:	83 7d f8 7f          	cmpl   $0x7f,-0x8(%ebp)
  101456:	75 07                	jne    10145f <serial_proc_data+0x63>
        c = '\b';
  101458:	c7 45 f8 08 00 00 00 	movl   $0x8,-0x8(%ebp)
    }
    return c;
  10145f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  101462:	83 c4 14             	add    $0x14,%esp
  101465:	5b                   	pop    %ebx
  101466:	5d                   	pop    %ebp
  101467:	c3                   	ret    

00101468 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101468:	55                   	push   %ebp
  101469:	89 e5                	mov    %esp,%ebp
  10146b:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  10146e:	a1 88 7e 11 00       	mov    0x117e88,%eax
  101473:	85 c0                	test   %eax,%eax
  101475:	74 0c                	je     101483 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101477:	c7 04 24 fc 13 10 00 	movl   $0x1013fc,(%esp)
  10147e:	e8 2f ff ff ff       	call   1013b2 <cons_intr>
    }
}
  101483:	c9                   	leave  
  101484:	c3                   	ret    

00101485 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101485:	55                   	push   %ebp
  101486:	89 e5                	mov    %esp,%ebp
  101488:	53                   	push   %ebx
  101489:	83 ec 44             	sub    $0x44,%esp
  10148c:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101492:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  101496:	66 89 55 d6          	mov    %dx,-0x2a(%ebp)
  10149a:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10149e:	ec                   	in     (%dx),%al
  10149f:	89 c3                	mov    %eax,%ebx
  1014a1:	88 5d ef             	mov    %bl,-0x11(%ebp)
    return data;
  1014a4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1014a8:	0f b6 c0             	movzbl %al,%eax
  1014ab:	83 e0 01             	and    $0x1,%eax
  1014ae:	85 c0                	test   %eax,%eax
  1014b0:	75 0a                	jne    1014bc <kbd_proc_data+0x37>
        return -1;
  1014b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1014b7:	e9 61 01 00 00       	jmp    10161d <kbd_proc_data+0x198>
  1014bc:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1014c2:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  1014c6:	66 89 55 d6          	mov    %dx,-0x2a(%ebp)
  1014ca:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1014ce:	ec                   	in     (%dx),%al
  1014cf:	89 c3                	mov    %eax,%ebx
  1014d1:	88 5d eb             	mov    %bl,-0x15(%ebp)
    return data;
  1014d4:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1014d8:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1014db:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1014df:	75 17                	jne    1014f8 <kbd_proc_data+0x73>
        // E0 escape character
        shift |= E0ESC;
  1014e1:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014e6:	83 c8 40             	or     $0x40,%eax
  1014e9:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  1014ee:	b8 00 00 00 00       	mov    $0x0,%eax
  1014f3:	e9 25 01 00 00       	jmp    10161d <kbd_proc_data+0x198>
    } else if (data & 0x80) {
  1014f8:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014fc:	84 c0                	test   %al,%al
  1014fe:	79 47                	jns    101547 <kbd_proc_data+0xc2>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101500:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101505:	83 e0 40             	and    $0x40,%eax
  101508:	85 c0                	test   %eax,%eax
  10150a:	75 09                	jne    101515 <kbd_proc_data+0x90>
  10150c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101510:	83 e0 7f             	and    $0x7f,%eax
  101513:	eb 04                	jmp    101519 <kbd_proc_data+0x94>
  101515:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101519:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10151c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101520:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  101527:	83 c8 40             	or     $0x40,%eax
  10152a:	0f b6 c0             	movzbl %al,%eax
  10152d:	f7 d0                	not    %eax
  10152f:	89 c2                	mov    %eax,%edx
  101531:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101536:	21 d0                	and    %edx,%eax
  101538:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  10153d:	b8 00 00 00 00       	mov    $0x0,%eax
  101542:	e9 d6 00 00 00       	jmp    10161d <kbd_proc_data+0x198>
    } else if (shift & E0ESC) {
  101547:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10154c:	83 e0 40             	and    $0x40,%eax
  10154f:	85 c0                	test   %eax,%eax
  101551:	74 11                	je     101564 <kbd_proc_data+0xdf>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101553:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101557:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10155c:	83 e0 bf             	and    $0xffffffbf,%eax
  10155f:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    }

    shift |= shiftcode[data];
  101564:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101568:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  10156f:	0f b6 d0             	movzbl %al,%edx
  101572:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101577:	09 d0                	or     %edx,%eax
  101579:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    shift ^= togglecode[data];
  10157e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101582:	0f b6 80 60 71 11 00 	movzbl 0x117160(%eax),%eax
  101589:	0f b6 d0             	movzbl %al,%edx
  10158c:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101591:	31 d0                	xor    %edx,%eax
  101593:	a3 a8 80 11 00       	mov    %eax,0x1180a8

    c = charcode[shift & (CTL | SHIFT)][data];
  101598:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10159d:	83 e0 03             	and    $0x3,%eax
  1015a0:	8b 14 85 60 75 11 00 	mov    0x117560(,%eax,4),%edx
  1015a7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015ab:	01 d0                	add    %edx,%eax
  1015ad:	0f b6 00             	movzbl (%eax),%eax
  1015b0:	0f b6 c0             	movzbl %al,%eax
  1015b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1015b6:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1015bb:	83 e0 08             	and    $0x8,%eax
  1015be:	85 c0                	test   %eax,%eax
  1015c0:	74 22                	je     1015e4 <kbd_proc_data+0x15f>
        if ('a' <= c && c <= 'z')
  1015c2:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1015c6:	7e 0c                	jle    1015d4 <kbd_proc_data+0x14f>
  1015c8:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1015cc:	7f 06                	jg     1015d4 <kbd_proc_data+0x14f>
            c += 'A' - 'a';
  1015ce:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1015d2:	eb 10                	jmp    1015e4 <kbd_proc_data+0x15f>
        else if ('A' <= c && c <= 'Z')
  1015d4:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1015d8:	7e 0a                	jle    1015e4 <kbd_proc_data+0x15f>
  1015da:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1015de:	7f 04                	jg     1015e4 <kbd_proc_data+0x15f>
            c += 'a' - 'A';
  1015e0:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1015e4:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1015e9:	f7 d0                	not    %eax
  1015eb:	83 e0 06             	and    $0x6,%eax
  1015ee:	85 c0                	test   %eax,%eax
  1015f0:	75 28                	jne    10161a <kbd_proc_data+0x195>
  1015f2:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1015f9:	75 1f                	jne    10161a <kbd_proc_data+0x195>
        cprintf("Rebooting!\n");
  1015fb:	c7 04 24 f1 63 10 00 	movl   $0x1063f1,(%esp)
  101602:	e8 40 ed ff ff       	call   100347 <cprintf>
  101607:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10160d:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101611:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101615:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101619:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10161a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10161d:	83 c4 44             	add    $0x44,%esp
  101620:	5b                   	pop    %ebx
  101621:	5d                   	pop    %ebp
  101622:	c3                   	ret    

00101623 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101623:	55                   	push   %ebp
  101624:	89 e5                	mov    %esp,%ebp
  101626:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101629:	c7 04 24 85 14 10 00 	movl   $0x101485,(%esp)
  101630:	e8 7d fd ff ff       	call   1013b2 <cons_intr>
}
  101635:	c9                   	leave  
  101636:	c3                   	ret    

00101637 <kbd_init>:

static void
kbd_init(void) {
  101637:	55                   	push   %ebp
  101638:	89 e5                	mov    %esp,%ebp
  10163a:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  10163d:	e8 e1 ff ff ff       	call   101623 <kbd_intr>
    pic_enable(IRQ_KBD);
  101642:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101649:	e8 3e 01 00 00       	call   10178c <pic_enable>
}
  10164e:	c9                   	leave  
  10164f:	c3                   	ret    

00101650 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101650:	55                   	push   %ebp
  101651:	89 e5                	mov    %esp,%ebp
  101653:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101656:	e8 18 f8 ff ff       	call   100e73 <cga_init>
    serial_init();
  10165b:	e8 0e f9 ff ff       	call   100f6e <serial_init>
    kbd_init();
  101660:	e8 d2 ff ff ff       	call   101637 <kbd_init>
    if (!serial_exists) {
  101665:	a1 88 7e 11 00       	mov    0x117e88,%eax
  10166a:	85 c0                	test   %eax,%eax
  10166c:	75 0c                	jne    10167a <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  10166e:	c7 04 24 fd 63 10 00 	movl   $0x1063fd,(%esp)
  101675:	e8 cd ec ff ff       	call   100347 <cprintf>
    }
}
  10167a:	c9                   	leave  
  10167b:	c3                   	ret    

0010167c <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10167c:	55                   	push   %ebp
  10167d:	89 e5                	mov    %esp,%ebp
  10167f:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  101682:	e8 3d f7 ff ff       	call   100dc4 <__intr_save>
  101687:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  10168a:	8b 45 08             	mov    0x8(%ebp),%eax
  10168d:	89 04 24             	mov    %eax,(%esp)
  101690:	e8 5f fa ff ff       	call   1010f4 <lpt_putc>
        cga_putc(c);
  101695:	8b 45 08             	mov    0x8(%ebp),%eax
  101698:	89 04 24             	mov    %eax,(%esp)
  10169b:	e8 93 fa ff ff       	call   101133 <cga_putc>
        serial_putc(c);
  1016a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1016a3:	89 04 24             	mov    %eax,(%esp)
  1016a6:	e8 c8 fc ff ff       	call   101373 <serial_putc>
    }
    local_intr_restore(intr_flag);
  1016ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1016ae:	89 04 24             	mov    %eax,(%esp)
  1016b1:	e8 3d f7 ff ff       	call   100df3 <__intr_restore>
}
  1016b6:	c9                   	leave  
  1016b7:	c3                   	ret    

001016b8 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1016b8:	55                   	push   %ebp
  1016b9:	89 e5                	mov    %esp,%ebp
  1016bb:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  1016be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  1016c5:	e8 fa f6 ff ff       	call   100dc4 <__intr_save>
  1016ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  1016cd:	e8 96 fd ff ff       	call   101468 <serial_intr>
        kbd_intr();
  1016d2:	e8 4c ff ff ff       	call   101623 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  1016d7:	8b 15 a0 80 11 00    	mov    0x1180a0,%edx
  1016dd:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  1016e2:	39 c2                	cmp    %eax,%edx
  1016e4:	74 30                	je     101716 <cons_getc+0x5e>
            c = cons.buf[cons.rpos ++];
  1016e6:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  1016eb:	0f b6 90 a0 7e 11 00 	movzbl 0x117ea0(%eax),%edx
  1016f2:	0f b6 d2             	movzbl %dl,%edx
  1016f5:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1016f8:	83 c0 01             	add    $0x1,%eax
  1016fb:	a3 a0 80 11 00       	mov    %eax,0x1180a0
            if (cons.rpos == CONSBUFSIZE) {
  101700:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101705:	3d 00 02 00 00       	cmp    $0x200,%eax
  10170a:	75 0a                	jne    101716 <cons_getc+0x5e>
                cons.rpos = 0;
  10170c:	c7 05 a0 80 11 00 00 	movl   $0x0,0x1180a0
  101713:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  101716:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101719:	89 04 24             	mov    %eax,(%esp)
  10171c:	e8 d2 f6 ff ff       	call   100df3 <__intr_restore>
    return c;
  101721:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101724:	c9                   	leave  
  101725:	c3                   	ret    
	...

00101728 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101728:	55                   	push   %ebp
  101729:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  10172b:	fb                   	sti    
    sti();
}
  10172c:	5d                   	pop    %ebp
  10172d:	c3                   	ret    

0010172e <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  10172e:	55                   	push   %ebp
  10172f:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  101731:	fa                   	cli    
    cli();
}
  101732:	5d                   	pop    %ebp
  101733:	c3                   	ret    

00101734 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101734:	55                   	push   %ebp
  101735:	89 e5                	mov    %esp,%ebp
  101737:	83 ec 14             	sub    $0x14,%esp
  10173a:	8b 45 08             	mov    0x8(%ebp),%eax
  10173d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101741:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101745:	66 a3 70 75 11 00    	mov    %ax,0x117570
    if (did_init) {
  10174b:	a1 ac 80 11 00       	mov    0x1180ac,%eax
  101750:	85 c0                	test   %eax,%eax
  101752:	74 36                	je     10178a <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101754:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101758:	0f b6 c0             	movzbl %al,%eax
  10175b:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101761:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101764:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101768:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10176c:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  10176d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101771:	66 c1 e8 08          	shr    $0x8,%ax
  101775:	0f b6 c0             	movzbl %al,%eax
  101778:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  10177e:	88 45 f9             	mov    %al,-0x7(%ebp)
  101781:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101785:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101789:	ee                   	out    %al,(%dx)
    }
}
  10178a:	c9                   	leave  
  10178b:	c3                   	ret    

0010178c <pic_enable>:

void
pic_enable(unsigned int irq) {
  10178c:	55                   	push   %ebp
  10178d:	89 e5                	mov    %esp,%ebp
  10178f:	53                   	push   %ebx
  101790:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101793:	8b 45 08             	mov    0x8(%ebp),%eax
  101796:	ba 01 00 00 00       	mov    $0x1,%edx
  10179b:	89 d3                	mov    %edx,%ebx
  10179d:	89 c1                	mov    %eax,%ecx
  10179f:	d3 e3                	shl    %cl,%ebx
  1017a1:	89 d8                	mov    %ebx,%eax
  1017a3:	89 c2                	mov    %eax,%edx
  1017a5:	f7 d2                	not    %edx
  1017a7:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  1017ae:	21 d0                	and    %edx,%eax
  1017b0:	0f b7 c0             	movzwl %ax,%eax
  1017b3:	89 04 24             	mov    %eax,(%esp)
  1017b6:	e8 79 ff ff ff       	call   101734 <pic_setmask>
}
  1017bb:	83 c4 04             	add    $0x4,%esp
  1017be:	5b                   	pop    %ebx
  1017bf:	5d                   	pop    %ebp
  1017c0:	c3                   	ret    

001017c1 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1017c1:	55                   	push   %ebp
  1017c2:	89 e5                	mov    %esp,%ebp
  1017c4:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1017c7:	c7 05 ac 80 11 00 01 	movl   $0x1,0x1180ac
  1017ce:	00 00 00 
  1017d1:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1017d7:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  1017db:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1017df:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1017e3:	ee                   	out    %al,(%dx)
  1017e4:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1017ea:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  1017ee:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1017f2:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1017f6:	ee                   	out    %al,(%dx)
  1017f7:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1017fd:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  101801:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101805:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101809:	ee                   	out    %al,(%dx)
  10180a:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  101810:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  101814:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101818:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10181c:	ee                   	out    %al,(%dx)
  10181d:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  101823:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  101827:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10182b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10182f:	ee                   	out    %al,(%dx)
  101830:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  101836:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  10183a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10183e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101842:	ee                   	out    %al,(%dx)
  101843:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  101849:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  10184d:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101851:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101855:	ee                   	out    %al,(%dx)
  101856:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  10185c:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  101860:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101864:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101868:	ee                   	out    %al,(%dx)
  101869:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  10186f:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  101873:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101877:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  10187b:	ee                   	out    %al,(%dx)
  10187c:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  101882:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101886:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10188a:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10188e:	ee                   	out    %al,(%dx)
  10188f:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101895:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101899:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10189d:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1018a1:	ee                   	out    %al,(%dx)
  1018a2:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1018a8:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  1018ac:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1018b0:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1018b4:	ee                   	out    %al,(%dx)
  1018b5:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  1018bb:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  1018bf:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1018c3:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1018c7:	ee                   	out    %al,(%dx)
  1018c8:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  1018ce:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  1018d2:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1018d6:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1018da:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1018db:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  1018e2:	66 83 f8 ff          	cmp    $0xffff,%ax
  1018e6:	74 12                	je     1018fa <pic_init+0x139>
        pic_setmask(irq_mask);
  1018e8:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  1018ef:	0f b7 c0             	movzwl %ax,%eax
  1018f2:	89 04 24             	mov    %eax,(%esp)
  1018f5:	e8 3a fe ff ff       	call   101734 <pic_setmask>
    }
}
  1018fa:	c9                   	leave  
  1018fb:	c3                   	ret    

001018fc <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1018fc:	55                   	push   %ebp
  1018fd:	89 e5                	mov    %esp,%ebp
  1018ff:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101902:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101909:	00 
  10190a:	c7 04 24 20 64 10 00 	movl   $0x106420,(%esp)
  101911:	e8 31 ea ff ff       	call   100347 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  101916:	c9                   	leave  
  101917:	c3                   	ret    

00101918 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101918:	55                   	push   %ebp
  101919:	89 e5                	mov    %esp,%ebp
  10191b:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	int i;
	extern uintptr_t __vectors[];
	for(i=0;i<256;i++){	
  10191e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101925:	e9 c3 00 00 00       	jmp    1019ed <idt_init+0xd5>
	   SETGATE(idt[i],0,GD_KTEXT,__vectors[i],DPL_KERNEL);
  10192a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10192d:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  101934:	89 c2                	mov    %eax,%edx
  101936:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101939:	66 89 14 c5 c0 80 11 	mov    %dx,0x1180c0(,%eax,8)
  101940:	00 
  101941:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101944:	66 c7 04 c5 c2 80 11 	movw   $0x8,0x1180c2(,%eax,8)
  10194b:	00 08 00 
  10194e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101951:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  101958:	00 
  101959:	83 e2 e0             	and    $0xffffffe0,%edx
  10195c:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  101963:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101966:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  10196d:	00 
  10196e:	83 e2 1f             	and    $0x1f,%edx
  101971:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  101978:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10197b:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101982:	00 
  101983:	83 e2 f0             	and    $0xfffffff0,%edx
  101986:	83 ca 0e             	or     $0xe,%edx
  101989:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101990:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101993:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10199a:	00 
  10199b:	83 e2 ef             	and    $0xffffffef,%edx
  10199e:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  1019a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019a8:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  1019af:	00 
  1019b0:	83 e2 9f             	and    $0xffffff9f,%edx
  1019b3:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  1019ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019bd:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  1019c4:	00 
  1019c5:	83 ca 80             	or     $0xffffff80,%edx
  1019c8:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  1019cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019d2:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  1019d9:	c1 e8 10             	shr    $0x10,%eax
  1019dc:	89 c2                	mov    %eax,%edx
  1019de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019e1:	66 89 14 c5 c6 80 11 	mov    %dx,0x1180c6(,%eax,8)
  1019e8:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	int i;
	extern uintptr_t __vectors[];
	for(i=0;i<256;i++){	
  1019e9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1019ed:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  1019f4:	0f 8e 30 ff ff ff    	jle    10192a <idt_init+0x12>
	   SETGATE(idt[i],0,GD_KTEXT,__vectors[i],DPL_KERNEL);
	}
	SETGATE(idt[T_SYSCALL],1,GD_KTEXT,__vectors[T_SYSCALL], DPL_USER);
  1019fa:	a1 00 78 11 00       	mov    0x117800,%eax
  1019ff:	66 a3 c0 84 11 00    	mov    %ax,0x1184c0
  101a05:	66 c7 05 c2 84 11 00 	movw   $0x8,0x1184c2
  101a0c:	08 00 
  101a0e:	0f b6 05 c4 84 11 00 	movzbl 0x1184c4,%eax
  101a15:	83 e0 e0             	and    $0xffffffe0,%eax
  101a18:	a2 c4 84 11 00       	mov    %al,0x1184c4
  101a1d:	0f b6 05 c4 84 11 00 	movzbl 0x1184c4,%eax
  101a24:	83 e0 1f             	and    $0x1f,%eax
  101a27:	a2 c4 84 11 00       	mov    %al,0x1184c4
  101a2c:	0f b6 05 c5 84 11 00 	movzbl 0x1184c5,%eax
  101a33:	83 c8 0f             	or     $0xf,%eax
  101a36:	a2 c5 84 11 00       	mov    %al,0x1184c5
  101a3b:	0f b6 05 c5 84 11 00 	movzbl 0x1184c5,%eax
  101a42:	83 e0 ef             	and    $0xffffffef,%eax
  101a45:	a2 c5 84 11 00       	mov    %al,0x1184c5
  101a4a:	0f b6 05 c5 84 11 00 	movzbl 0x1184c5,%eax
  101a51:	83 c8 60             	or     $0x60,%eax
  101a54:	a2 c5 84 11 00       	mov    %al,0x1184c5
  101a59:	0f b6 05 c5 84 11 00 	movzbl 0x1184c5,%eax
  101a60:	83 c8 80             	or     $0xffffff80,%eax
  101a63:	a2 c5 84 11 00       	mov    %al,0x1184c5
  101a68:	a1 00 78 11 00       	mov    0x117800,%eax
  101a6d:	c1 e8 10             	shr    $0x10,%eax
  101a70:	66 a3 c6 84 11 00    	mov    %ax,0x1184c6
  101a76:	c7 45 f8 80 75 11 00 	movl   $0x117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101a7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a80:	0f 01 18             	lidtl  (%eax)
	lidt(&idt_pd);
}
  101a83:	c9                   	leave  
  101a84:	c3                   	ret    

00101a85 <trapname>:

static const char *
trapname(int trapno) {
  101a85:	55                   	push   %ebp
  101a86:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a88:	8b 45 08             	mov    0x8(%ebp),%eax
  101a8b:	83 f8 13             	cmp    $0x13,%eax
  101a8e:	77 0c                	ja     101a9c <trapname+0x17>
        return excnames[trapno];
  101a90:	8b 45 08             	mov    0x8(%ebp),%eax
  101a93:	8b 04 85 80 67 10 00 	mov    0x106780(,%eax,4),%eax
  101a9a:	eb 18                	jmp    101ab4 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a9c:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101aa0:	7e 0d                	jle    101aaf <trapname+0x2a>
  101aa2:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101aa6:	7f 07                	jg     101aaf <trapname+0x2a>
        return "Hardware Interrupt";
  101aa8:	b8 2a 64 10 00       	mov    $0x10642a,%eax
  101aad:	eb 05                	jmp    101ab4 <trapname+0x2f>
    }
    return "(unknown trap)";
  101aaf:	b8 3d 64 10 00       	mov    $0x10643d,%eax
}
  101ab4:	5d                   	pop    %ebp
  101ab5:	c3                   	ret    

00101ab6 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101ab6:	55                   	push   %ebp
  101ab7:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  101abc:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ac0:	66 83 f8 08          	cmp    $0x8,%ax
  101ac4:	0f 94 c0             	sete   %al
  101ac7:	0f b6 c0             	movzbl %al,%eax
}
  101aca:	5d                   	pop    %ebp
  101acb:	c3                   	ret    

00101acc <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101acc:	55                   	push   %ebp
  101acd:	89 e5                	mov    %esp,%ebp
  101acf:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ad9:	c7 04 24 7e 64 10 00 	movl   $0x10647e,(%esp)
  101ae0:	e8 62 e8 ff ff       	call   100347 <cprintf>
    print_regs(&tf->tf_regs);
  101ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae8:	89 04 24             	mov    %eax,(%esp)
  101aeb:	e8 a1 01 00 00       	call   101c91 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101af0:	8b 45 08             	mov    0x8(%ebp),%eax
  101af3:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101af7:	0f b7 c0             	movzwl %ax,%eax
  101afa:	89 44 24 04          	mov    %eax,0x4(%esp)
  101afe:	c7 04 24 8f 64 10 00 	movl   $0x10648f,(%esp)
  101b05:	e8 3d e8 ff ff       	call   100347 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b0d:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101b11:	0f b7 c0             	movzwl %ax,%eax
  101b14:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b18:	c7 04 24 a2 64 10 00 	movl   $0x1064a2,(%esp)
  101b1f:	e8 23 e8 ff ff       	call   100347 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101b24:	8b 45 08             	mov    0x8(%ebp),%eax
  101b27:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101b2b:	0f b7 c0             	movzwl %ax,%eax
  101b2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b32:	c7 04 24 b5 64 10 00 	movl   $0x1064b5,(%esp)
  101b39:	e8 09 e8 ff ff       	call   100347 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b41:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b45:	0f b7 c0             	movzwl %ax,%eax
  101b48:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b4c:	c7 04 24 c8 64 10 00 	movl   $0x1064c8,(%esp)
  101b53:	e8 ef e7 ff ff       	call   100347 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b58:	8b 45 08             	mov    0x8(%ebp),%eax
  101b5b:	8b 40 30             	mov    0x30(%eax),%eax
  101b5e:	89 04 24             	mov    %eax,(%esp)
  101b61:	e8 1f ff ff ff       	call   101a85 <trapname>
  101b66:	8b 55 08             	mov    0x8(%ebp),%edx
  101b69:	8b 52 30             	mov    0x30(%edx),%edx
  101b6c:	89 44 24 08          	mov    %eax,0x8(%esp)
  101b70:	89 54 24 04          	mov    %edx,0x4(%esp)
  101b74:	c7 04 24 db 64 10 00 	movl   $0x1064db,(%esp)
  101b7b:	e8 c7 e7 ff ff       	call   100347 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b80:	8b 45 08             	mov    0x8(%ebp),%eax
  101b83:	8b 40 34             	mov    0x34(%eax),%eax
  101b86:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b8a:	c7 04 24 ed 64 10 00 	movl   $0x1064ed,(%esp)
  101b91:	e8 b1 e7 ff ff       	call   100347 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b96:	8b 45 08             	mov    0x8(%ebp),%eax
  101b99:	8b 40 38             	mov    0x38(%eax),%eax
  101b9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ba0:	c7 04 24 fc 64 10 00 	movl   $0x1064fc,(%esp)
  101ba7:	e8 9b e7 ff ff       	call   100347 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101bac:	8b 45 08             	mov    0x8(%ebp),%eax
  101baf:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101bb3:	0f b7 c0             	movzwl %ax,%eax
  101bb6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bba:	c7 04 24 0b 65 10 00 	movl   $0x10650b,(%esp)
  101bc1:	e8 81 e7 ff ff       	call   100347 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc9:	8b 40 40             	mov    0x40(%eax),%eax
  101bcc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bd0:	c7 04 24 1e 65 10 00 	movl   $0x10651e,(%esp)
  101bd7:	e8 6b e7 ff ff       	call   100347 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bdc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101be3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101bea:	eb 3e                	jmp    101c2a <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101bec:	8b 45 08             	mov    0x8(%ebp),%eax
  101bef:	8b 50 40             	mov    0x40(%eax),%edx
  101bf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101bf5:	21 d0                	and    %edx,%eax
  101bf7:	85 c0                	test   %eax,%eax
  101bf9:	74 28                	je     101c23 <print_trapframe+0x157>
  101bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bfe:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101c05:	85 c0                	test   %eax,%eax
  101c07:	74 1a                	je     101c23 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c0c:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101c13:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c17:	c7 04 24 2d 65 10 00 	movl   $0x10652d,(%esp)
  101c1e:	e8 24 e7 ff ff       	call   100347 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c23:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101c27:	d1 65 f0             	shll   -0x10(%ebp)
  101c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c2d:	83 f8 17             	cmp    $0x17,%eax
  101c30:	76 ba                	jbe    101bec <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101c32:	8b 45 08             	mov    0x8(%ebp),%eax
  101c35:	8b 40 40             	mov    0x40(%eax),%eax
  101c38:	25 00 30 00 00       	and    $0x3000,%eax
  101c3d:	c1 e8 0c             	shr    $0xc,%eax
  101c40:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c44:	c7 04 24 31 65 10 00 	movl   $0x106531,(%esp)
  101c4b:	e8 f7 e6 ff ff       	call   100347 <cprintf>

    if (!trap_in_kernel(tf)) {
  101c50:	8b 45 08             	mov    0x8(%ebp),%eax
  101c53:	89 04 24             	mov    %eax,(%esp)
  101c56:	e8 5b fe ff ff       	call   101ab6 <trap_in_kernel>
  101c5b:	85 c0                	test   %eax,%eax
  101c5d:	75 30                	jne    101c8f <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  101c62:	8b 40 44             	mov    0x44(%eax),%eax
  101c65:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c69:	c7 04 24 3a 65 10 00 	movl   $0x10653a,(%esp)
  101c70:	e8 d2 e6 ff ff       	call   100347 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c75:	8b 45 08             	mov    0x8(%ebp),%eax
  101c78:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c7c:	0f b7 c0             	movzwl %ax,%eax
  101c7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c83:	c7 04 24 49 65 10 00 	movl   $0x106549,(%esp)
  101c8a:	e8 b8 e6 ff ff       	call   100347 <cprintf>
    }
}
  101c8f:	c9                   	leave  
  101c90:	c3                   	ret    

00101c91 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c91:	55                   	push   %ebp
  101c92:	89 e5                	mov    %esp,%ebp
  101c94:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c97:	8b 45 08             	mov    0x8(%ebp),%eax
  101c9a:	8b 00                	mov    (%eax),%eax
  101c9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ca0:	c7 04 24 5c 65 10 00 	movl   $0x10655c,(%esp)
  101ca7:	e8 9b e6 ff ff       	call   100347 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101cac:	8b 45 08             	mov    0x8(%ebp),%eax
  101caf:	8b 40 04             	mov    0x4(%eax),%eax
  101cb2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cb6:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  101cbd:	e8 85 e6 ff ff       	call   100347 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  101cc5:	8b 40 08             	mov    0x8(%eax),%eax
  101cc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ccc:	c7 04 24 7a 65 10 00 	movl   $0x10657a,(%esp)
  101cd3:	e8 6f e6 ff ff       	call   100347 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  101cdb:	8b 40 0c             	mov    0xc(%eax),%eax
  101cde:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ce2:	c7 04 24 89 65 10 00 	movl   $0x106589,(%esp)
  101ce9:	e8 59 e6 ff ff       	call   100347 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101cee:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf1:	8b 40 10             	mov    0x10(%eax),%eax
  101cf4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cf8:	c7 04 24 98 65 10 00 	movl   $0x106598,(%esp)
  101cff:	e8 43 e6 ff ff       	call   100347 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101d04:	8b 45 08             	mov    0x8(%ebp),%eax
  101d07:	8b 40 14             	mov    0x14(%eax),%eax
  101d0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d0e:	c7 04 24 a7 65 10 00 	movl   $0x1065a7,(%esp)
  101d15:	e8 2d e6 ff ff       	call   100347 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d1d:	8b 40 18             	mov    0x18(%eax),%eax
  101d20:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d24:	c7 04 24 b6 65 10 00 	movl   $0x1065b6,(%esp)
  101d2b:	e8 17 e6 ff ff       	call   100347 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101d30:	8b 45 08             	mov    0x8(%ebp),%eax
  101d33:	8b 40 1c             	mov    0x1c(%eax),%eax
  101d36:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d3a:	c7 04 24 c5 65 10 00 	movl   $0x1065c5,(%esp)
  101d41:	e8 01 e6 ff ff       	call   100347 <cprintf>
}
  101d46:	c9                   	leave  
  101d47:	c3                   	ret    

00101d48 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101d48:	55                   	push   %ebp
  101d49:	89 e5                	mov    %esp,%ebp
  101d4b:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d51:	8b 40 30             	mov    0x30(%eax),%eax
  101d54:	83 f8 2f             	cmp    $0x2f,%eax
  101d57:	77 21                	ja     101d7a <trap_dispatch+0x32>
  101d59:	83 f8 2e             	cmp    $0x2e,%eax
  101d5c:	0f 83 05 01 00 00    	jae    101e67 <trap_dispatch+0x11f>
  101d62:	83 f8 21             	cmp    $0x21,%eax
  101d65:	0f 84 82 00 00 00    	je     101ded <trap_dispatch+0xa5>
  101d6b:	83 f8 24             	cmp    $0x24,%eax
  101d6e:	74 57                	je     101dc7 <trap_dispatch+0x7f>
  101d70:	83 f8 20             	cmp    $0x20,%eax
  101d73:	74 16                	je     101d8b <trap_dispatch+0x43>
  101d75:	e9 b5 00 00 00       	jmp    101e2f <trap_dispatch+0xe7>
  101d7a:	83 e8 78             	sub    $0x78,%eax
  101d7d:	83 f8 01             	cmp    $0x1,%eax
  101d80:	0f 87 a9 00 00 00    	ja     101e2f <trap_dispatch+0xe7>
  101d86:	e9 88 00 00 00       	jmp    101e13 <trap_dispatch+0xcb>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
	ticks++;
  101d8b:	a1 4c 89 11 00       	mov    0x11894c,%eax
  101d90:	83 c0 01             	add    $0x1,%eax
  101d93:	a3 4c 89 11 00       	mov    %eax,0x11894c
	if(ticks%100==0) print_ticks();
  101d98:	8b 0d 4c 89 11 00    	mov    0x11894c,%ecx
  101d9e:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101da3:	89 c8                	mov    %ecx,%eax
  101da5:	f7 e2                	mul    %edx
  101da7:	89 d0                	mov    %edx,%eax
  101da9:	c1 e8 05             	shr    $0x5,%eax
  101dac:	6b c0 64             	imul   $0x64,%eax,%eax
  101daf:	89 ca                	mov    %ecx,%edx
  101db1:	29 c2                	sub    %eax,%edx
  101db3:	89 d0                	mov    %edx,%eax
  101db5:	85 c0                	test   %eax,%eax
  101db7:	0f 85 ad 00 00 00    	jne    101e6a <trap_dispatch+0x122>
  101dbd:	e8 3a fb ff ff       	call   1018fc <print_ticks>
        break;
  101dc2:	e9 a3 00 00 00       	jmp    101e6a <trap_dispatch+0x122>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101dc7:	e8 ec f8 ff ff       	call   1016b8 <cons_getc>
  101dcc:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101dcf:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101dd3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101dd7:	89 54 24 08          	mov    %edx,0x8(%esp)
  101ddb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ddf:	c7 04 24 d4 65 10 00 	movl   $0x1065d4,(%esp)
  101de6:	e8 5c e5 ff ff       	call   100347 <cprintf>
        break;
  101deb:	eb 7e                	jmp    101e6b <trap_dispatch+0x123>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101ded:	e8 c6 f8 ff ff       	call   1016b8 <cons_getc>
  101df2:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101df5:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101df9:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101dfd:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e01:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e05:	c7 04 24 e6 65 10 00 	movl   $0x1065e6,(%esp)
  101e0c:	e8 36 e5 ff ff       	call   100347 <cprintf>
        break;
  101e11:	eb 58                	jmp    101e6b <trap_dispatch+0x123>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101e13:	c7 44 24 08 f5 65 10 	movl   $0x1065f5,0x8(%esp)
  101e1a:	00 
  101e1b:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
  101e22:	00 
  101e23:	c7 04 24 05 66 10 00 	movl   $0x106605,(%esp)
  101e2a:	e8 6d ee ff ff       	call   100c9c <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  101e32:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e36:	0f b7 c0             	movzwl %ax,%eax
  101e39:	83 e0 03             	and    $0x3,%eax
  101e3c:	85 c0                	test   %eax,%eax
  101e3e:	75 2b                	jne    101e6b <trap_dispatch+0x123>
            print_trapframe(tf);
  101e40:	8b 45 08             	mov    0x8(%ebp),%eax
  101e43:	89 04 24             	mov    %eax,(%esp)
  101e46:	e8 81 fc ff ff       	call   101acc <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101e4b:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  101e52:	00 
  101e53:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
  101e5a:	00 
  101e5b:	c7 04 24 05 66 10 00 	movl   $0x106605,(%esp)
  101e62:	e8 35 ee ff ff       	call   100c9c <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101e67:	90                   	nop
  101e68:	eb 01                	jmp    101e6b <trap_dispatch+0x123>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
	ticks++;
	if(ticks%100==0) print_ticks();
        break;
  101e6a:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101e6b:	c9                   	leave  
  101e6c:	c3                   	ret    

00101e6d <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101e6d:	55                   	push   %ebp
  101e6e:	89 e5                	mov    %esp,%ebp
  101e70:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101e73:	8b 45 08             	mov    0x8(%ebp),%eax
  101e76:	89 04 24             	mov    %eax,(%esp)
  101e79:	e8 ca fe ff ff       	call   101d48 <trap_dispatch>

}
  101e7e:	c9                   	leave  
  101e7f:	c3                   	ret    

00101e80 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101e80:	1e                   	push   %ds
    pushl %es
  101e81:	06                   	push   %es
    pushl %fs
  101e82:	0f a0                	push   %fs
    pushl %gs
  101e84:	0f a8                	push   %gs
    pushal
  101e86:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101e87:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101e8c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101e8e:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101e90:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101e91:	e8 d7 ff ff ff       	call   101e6d <trap>

    # pop the pushed stack pointer
    popl %esp
  101e96:	5c                   	pop    %esp

00101e97 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101e97:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101e98:	0f a9                	pop    %gs
    popl %fs
  101e9a:	0f a1                	pop    %fs
    popl %es
  101e9c:	07                   	pop    %es
    popl %ds
  101e9d:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101e9e:	83 c4 08             	add    $0x8,%esp
    iret
  101ea1:	cf                   	iret   
	...

00101ea4 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101ea4:	6a 00                	push   $0x0
  pushl $0
  101ea6:	6a 00                	push   $0x0
  jmp __alltraps
  101ea8:	e9 d3 ff ff ff       	jmp    101e80 <__alltraps>

00101ead <vector1>:
.globl vector1
vector1:
  pushl $0
  101ead:	6a 00                	push   $0x0
  pushl $1
  101eaf:	6a 01                	push   $0x1
  jmp __alltraps
  101eb1:	e9 ca ff ff ff       	jmp    101e80 <__alltraps>

00101eb6 <vector2>:
.globl vector2
vector2:
  pushl $0
  101eb6:	6a 00                	push   $0x0
  pushl $2
  101eb8:	6a 02                	push   $0x2
  jmp __alltraps
  101eba:	e9 c1 ff ff ff       	jmp    101e80 <__alltraps>

00101ebf <vector3>:
.globl vector3
vector3:
  pushl $0
  101ebf:	6a 00                	push   $0x0
  pushl $3
  101ec1:	6a 03                	push   $0x3
  jmp __alltraps
  101ec3:	e9 b8 ff ff ff       	jmp    101e80 <__alltraps>

00101ec8 <vector4>:
.globl vector4
vector4:
  pushl $0
  101ec8:	6a 00                	push   $0x0
  pushl $4
  101eca:	6a 04                	push   $0x4
  jmp __alltraps
  101ecc:	e9 af ff ff ff       	jmp    101e80 <__alltraps>

00101ed1 <vector5>:
.globl vector5
vector5:
  pushl $0
  101ed1:	6a 00                	push   $0x0
  pushl $5
  101ed3:	6a 05                	push   $0x5
  jmp __alltraps
  101ed5:	e9 a6 ff ff ff       	jmp    101e80 <__alltraps>

00101eda <vector6>:
.globl vector6
vector6:
  pushl $0
  101eda:	6a 00                	push   $0x0
  pushl $6
  101edc:	6a 06                	push   $0x6
  jmp __alltraps
  101ede:	e9 9d ff ff ff       	jmp    101e80 <__alltraps>

00101ee3 <vector7>:
.globl vector7
vector7:
  pushl $0
  101ee3:	6a 00                	push   $0x0
  pushl $7
  101ee5:	6a 07                	push   $0x7
  jmp __alltraps
  101ee7:	e9 94 ff ff ff       	jmp    101e80 <__alltraps>

00101eec <vector8>:
.globl vector8
vector8:
  pushl $8
  101eec:	6a 08                	push   $0x8
  jmp __alltraps
  101eee:	e9 8d ff ff ff       	jmp    101e80 <__alltraps>

00101ef3 <vector9>:
.globl vector9
vector9:
  pushl $9
  101ef3:	6a 09                	push   $0x9
  jmp __alltraps
  101ef5:	e9 86 ff ff ff       	jmp    101e80 <__alltraps>

00101efa <vector10>:
.globl vector10
vector10:
  pushl $10
  101efa:	6a 0a                	push   $0xa
  jmp __alltraps
  101efc:	e9 7f ff ff ff       	jmp    101e80 <__alltraps>

00101f01 <vector11>:
.globl vector11
vector11:
  pushl $11
  101f01:	6a 0b                	push   $0xb
  jmp __alltraps
  101f03:	e9 78 ff ff ff       	jmp    101e80 <__alltraps>

00101f08 <vector12>:
.globl vector12
vector12:
  pushl $12
  101f08:	6a 0c                	push   $0xc
  jmp __alltraps
  101f0a:	e9 71 ff ff ff       	jmp    101e80 <__alltraps>

00101f0f <vector13>:
.globl vector13
vector13:
  pushl $13
  101f0f:	6a 0d                	push   $0xd
  jmp __alltraps
  101f11:	e9 6a ff ff ff       	jmp    101e80 <__alltraps>

00101f16 <vector14>:
.globl vector14
vector14:
  pushl $14
  101f16:	6a 0e                	push   $0xe
  jmp __alltraps
  101f18:	e9 63 ff ff ff       	jmp    101e80 <__alltraps>

00101f1d <vector15>:
.globl vector15
vector15:
  pushl $0
  101f1d:	6a 00                	push   $0x0
  pushl $15
  101f1f:	6a 0f                	push   $0xf
  jmp __alltraps
  101f21:	e9 5a ff ff ff       	jmp    101e80 <__alltraps>

00101f26 <vector16>:
.globl vector16
vector16:
  pushl $0
  101f26:	6a 00                	push   $0x0
  pushl $16
  101f28:	6a 10                	push   $0x10
  jmp __alltraps
  101f2a:	e9 51 ff ff ff       	jmp    101e80 <__alltraps>

00101f2f <vector17>:
.globl vector17
vector17:
  pushl $17
  101f2f:	6a 11                	push   $0x11
  jmp __alltraps
  101f31:	e9 4a ff ff ff       	jmp    101e80 <__alltraps>

00101f36 <vector18>:
.globl vector18
vector18:
  pushl $0
  101f36:	6a 00                	push   $0x0
  pushl $18
  101f38:	6a 12                	push   $0x12
  jmp __alltraps
  101f3a:	e9 41 ff ff ff       	jmp    101e80 <__alltraps>

00101f3f <vector19>:
.globl vector19
vector19:
  pushl $0
  101f3f:	6a 00                	push   $0x0
  pushl $19
  101f41:	6a 13                	push   $0x13
  jmp __alltraps
  101f43:	e9 38 ff ff ff       	jmp    101e80 <__alltraps>

00101f48 <vector20>:
.globl vector20
vector20:
  pushl $0
  101f48:	6a 00                	push   $0x0
  pushl $20
  101f4a:	6a 14                	push   $0x14
  jmp __alltraps
  101f4c:	e9 2f ff ff ff       	jmp    101e80 <__alltraps>

00101f51 <vector21>:
.globl vector21
vector21:
  pushl $0
  101f51:	6a 00                	push   $0x0
  pushl $21
  101f53:	6a 15                	push   $0x15
  jmp __alltraps
  101f55:	e9 26 ff ff ff       	jmp    101e80 <__alltraps>

00101f5a <vector22>:
.globl vector22
vector22:
  pushl $0
  101f5a:	6a 00                	push   $0x0
  pushl $22
  101f5c:	6a 16                	push   $0x16
  jmp __alltraps
  101f5e:	e9 1d ff ff ff       	jmp    101e80 <__alltraps>

00101f63 <vector23>:
.globl vector23
vector23:
  pushl $0
  101f63:	6a 00                	push   $0x0
  pushl $23
  101f65:	6a 17                	push   $0x17
  jmp __alltraps
  101f67:	e9 14 ff ff ff       	jmp    101e80 <__alltraps>

00101f6c <vector24>:
.globl vector24
vector24:
  pushl $0
  101f6c:	6a 00                	push   $0x0
  pushl $24
  101f6e:	6a 18                	push   $0x18
  jmp __alltraps
  101f70:	e9 0b ff ff ff       	jmp    101e80 <__alltraps>

00101f75 <vector25>:
.globl vector25
vector25:
  pushl $0
  101f75:	6a 00                	push   $0x0
  pushl $25
  101f77:	6a 19                	push   $0x19
  jmp __alltraps
  101f79:	e9 02 ff ff ff       	jmp    101e80 <__alltraps>

00101f7e <vector26>:
.globl vector26
vector26:
  pushl $0
  101f7e:	6a 00                	push   $0x0
  pushl $26
  101f80:	6a 1a                	push   $0x1a
  jmp __alltraps
  101f82:	e9 f9 fe ff ff       	jmp    101e80 <__alltraps>

00101f87 <vector27>:
.globl vector27
vector27:
  pushl $0
  101f87:	6a 00                	push   $0x0
  pushl $27
  101f89:	6a 1b                	push   $0x1b
  jmp __alltraps
  101f8b:	e9 f0 fe ff ff       	jmp    101e80 <__alltraps>

00101f90 <vector28>:
.globl vector28
vector28:
  pushl $0
  101f90:	6a 00                	push   $0x0
  pushl $28
  101f92:	6a 1c                	push   $0x1c
  jmp __alltraps
  101f94:	e9 e7 fe ff ff       	jmp    101e80 <__alltraps>

00101f99 <vector29>:
.globl vector29
vector29:
  pushl $0
  101f99:	6a 00                	push   $0x0
  pushl $29
  101f9b:	6a 1d                	push   $0x1d
  jmp __alltraps
  101f9d:	e9 de fe ff ff       	jmp    101e80 <__alltraps>

00101fa2 <vector30>:
.globl vector30
vector30:
  pushl $0
  101fa2:	6a 00                	push   $0x0
  pushl $30
  101fa4:	6a 1e                	push   $0x1e
  jmp __alltraps
  101fa6:	e9 d5 fe ff ff       	jmp    101e80 <__alltraps>

00101fab <vector31>:
.globl vector31
vector31:
  pushl $0
  101fab:	6a 00                	push   $0x0
  pushl $31
  101fad:	6a 1f                	push   $0x1f
  jmp __alltraps
  101faf:	e9 cc fe ff ff       	jmp    101e80 <__alltraps>

00101fb4 <vector32>:
.globl vector32
vector32:
  pushl $0
  101fb4:	6a 00                	push   $0x0
  pushl $32
  101fb6:	6a 20                	push   $0x20
  jmp __alltraps
  101fb8:	e9 c3 fe ff ff       	jmp    101e80 <__alltraps>

00101fbd <vector33>:
.globl vector33
vector33:
  pushl $0
  101fbd:	6a 00                	push   $0x0
  pushl $33
  101fbf:	6a 21                	push   $0x21
  jmp __alltraps
  101fc1:	e9 ba fe ff ff       	jmp    101e80 <__alltraps>

00101fc6 <vector34>:
.globl vector34
vector34:
  pushl $0
  101fc6:	6a 00                	push   $0x0
  pushl $34
  101fc8:	6a 22                	push   $0x22
  jmp __alltraps
  101fca:	e9 b1 fe ff ff       	jmp    101e80 <__alltraps>

00101fcf <vector35>:
.globl vector35
vector35:
  pushl $0
  101fcf:	6a 00                	push   $0x0
  pushl $35
  101fd1:	6a 23                	push   $0x23
  jmp __alltraps
  101fd3:	e9 a8 fe ff ff       	jmp    101e80 <__alltraps>

00101fd8 <vector36>:
.globl vector36
vector36:
  pushl $0
  101fd8:	6a 00                	push   $0x0
  pushl $36
  101fda:	6a 24                	push   $0x24
  jmp __alltraps
  101fdc:	e9 9f fe ff ff       	jmp    101e80 <__alltraps>

00101fe1 <vector37>:
.globl vector37
vector37:
  pushl $0
  101fe1:	6a 00                	push   $0x0
  pushl $37
  101fe3:	6a 25                	push   $0x25
  jmp __alltraps
  101fe5:	e9 96 fe ff ff       	jmp    101e80 <__alltraps>

00101fea <vector38>:
.globl vector38
vector38:
  pushl $0
  101fea:	6a 00                	push   $0x0
  pushl $38
  101fec:	6a 26                	push   $0x26
  jmp __alltraps
  101fee:	e9 8d fe ff ff       	jmp    101e80 <__alltraps>

00101ff3 <vector39>:
.globl vector39
vector39:
  pushl $0
  101ff3:	6a 00                	push   $0x0
  pushl $39
  101ff5:	6a 27                	push   $0x27
  jmp __alltraps
  101ff7:	e9 84 fe ff ff       	jmp    101e80 <__alltraps>

00101ffc <vector40>:
.globl vector40
vector40:
  pushl $0
  101ffc:	6a 00                	push   $0x0
  pushl $40
  101ffe:	6a 28                	push   $0x28
  jmp __alltraps
  102000:	e9 7b fe ff ff       	jmp    101e80 <__alltraps>

00102005 <vector41>:
.globl vector41
vector41:
  pushl $0
  102005:	6a 00                	push   $0x0
  pushl $41
  102007:	6a 29                	push   $0x29
  jmp __alltraps
  102009:	e9 72 fe ff ff       	jmp    101e80 <__alltraps>

0010200e <vector42>:
.globl vector42
vector42:
  pushl $0
  10200e:	6a 00                	push   $0x0
  pushl $42
  102010:	6a 2a                	push   $0x2a
  jmp __alltraps
  102012:	e9 69 fe ff ff       	jmp    101e80 <__alltraps>

00102017 <vector43>:
.globl vector43
vector43:
  pushl $0
  102017:	6a 00                	push   $0x0
  pushl $43
  102019:	6a 2b                	push   $0x2b
  jmp __alltraps
  10201b:	e9 60 fe ff ff       	jmp    101e80 <__alltraps>

00102020 <vector44>:
.globl vector44
vector44:
  pushl $0
  102020:	6a 00                	push   $0x0
  pushl $44
  102022:	6a 2c                	push   $0x2c
  jmp __alltraps
  102024:	e9 57 fe ff ff       	jmp    101e80 <__alltraps>

00102029 <vector45>:
.globl vector45
vector45:
  pushl $0
  102029:	6a 00                	push   $0x0
  pushl $45
  10202b:	6a 2d                	push   $0x2d
  jmp __alltraps
  10202d:	e9 4e fe ff ff       	jmp    101e80 <__alltraps>

00102032 <vector46>:
.globl vector46
vector46:
  pushl $0
  102032:	6a 00                	push   $0x0
  pushl $46
  102034:	6a 2e                	push   $0x2e
  jmp __alltraps
  102036:	e9 45 fe ff ff       	jmp    101e80 <__alltraps>

0010203b <vector47>:
.globl vector47
vector47:
  pushl $0
  10203b:	6a 00                	push   $0x0
  pushl $47
  10203d:	6a 2f                	push   $0x2f
  jmp __alltraps
  10203f:	e9 3c fe ff ff       	jmp    101e80 <__alltraps>

00102044 <vector48>:
.globl vector48
vector48:
  pushl $0
  102044:	6a 00                	push   $0x0
  pushl $48
  102046:	6a 30                	push   $0x30
  jmp __alltraps
  102048:	e9 33 fe ff ff       	jmp    101e80 <__alltraps>

0010204d <vector49>:
.globl vector49
vector49:
  pushl $0
  10204d:	6a 00                	push   $0x0
  pushl $49
  10204f:	6a 31                	push   $0x31
  jmp __alltraps
  102051:	e9 2a fe ff ff       	jmp    101e80 <__alltraps>

00102056 <vector50>:
.globl vector50
vector50:
  pushl $0
  102056:	6a 00                	push   $0x0
  pushl $50
  102058:	6a 32                	push   $0x32
  jmp __alltraps
  10205a:	e9 21 fe ff ff       	jmp    101e80 <__alltraps>

0010205f <vector51>:
.globl vector51
vector51:
  pushl $0
  10205f:	6a 00                	push   $0x0
  pushl $51
  102061:	6a 33                	push   $0x33
  jmp __alltraps
  102063:	e9 18 fe ff ff       	jmp    101e80 <__alltraps>

00102068 <vector52>:
.globl vector52
vector52:
  pushl $0
  102068:	6a 00                	push   $0x0
  pushl $52
  10206a:	6a 34                	push   $0x34
  jmp __alltraps
  10206c:	e9 0f fe ff ff       	jmp    101e80 <__alltraps>

00102071 <vector53>:
.globl vector53
vector53:
  pushl $0
  102071:	6a 00                	push   $0x0
  pushl $53
  102073:	6a 35                	push   $0x35
  jmp __alltraps
  102075:	e9 06 fe ff ff       	jmp    101e80 <__alltraps>

0010207a <vector54>:
.globl vector54
vector54:
  pushl $0
  10207a:	6a 00                	push   $0x0
  pushl $54
  10207c:	6a 36                	push   $0x36
  jmp __alltraps
  10207e:	e9 fd fd ff ff       	jmp    101e80 <__alltraps>

00102083 <vector55>:
.globl vector55
vector55:
  pushl $0
  102083:	6a 00                	push   $0x0
  pushl $55
  102085:	6a 37                	push   $0x37
  jmp __alltraps
  102087:	e9 f4 fd ff ff       	jmp    101e80 <__alltraps>

0010208c <vector56>:
.globl vector56
vector56:
  pushl $0
  10208c:	6a 00                	push   $0x0
  pushl $56
  10208e:	6a 38                	push   $0x38
  jmp __alltraps
  102090:	e9 eb fd ff ff       	jmp    101e80 <__alltraps>

00102095 <vector57>:
.globl vector57
vector57:
  pushl $0
  102095:	6a 00                	push   $0x0
  pushl $57
  102097:	6a 39                	push   $0x39
  jmp __alltraps
  102099:	e9 e2 fd ff ff       	jmp    101e80 <__alltraps>

0010209e <vector58>:
.globl vector58
vector58:
  pushl $0
  10209e:	6a 00                	push   $0x0
  pushl $58
  1020a0:	6a 3a                	push   $0x3a
  jmp __alltraps
  1020a2:	e9 d9 fd ff ff       	jmp    101e80 <__alltraps>

001020a7 <vector59>:
.globl vector59
vector59:
  pushl $0
  1020a7:	6a 00                	push   $0x0
  pushl $59
  1020a9:	6a 3b                	push   $0x3b
  jmp __alltraps
  1020ab:	e9 d0 fd ff ff       	jmp    101e80 <__alltraps>

001020b0 <vector60>:
.globl vector60
vector60:
  pushl $0
  1020b0:	6a 00                	push   $0x0
  pushl $60
  1020b2:	6a 3c                	push   $0x3c
  jmp __alltraps
  1020b4:	e9 c7 fd ff ff       	jmp    101e80 <__alltraps>

001020b9 <vector61>:
.globl vector61
vector61:
  pushl $0
  1020b9:	6a 00                	push   $0x0
  pushl $61
  1020bb:	6a 3d                	push   $0x3d
  jmp __alltraps
  1020bd:	e9 be fd ff ff       	jmp    101e80 <__alltraps>

001020c2 <vector62>:
.globl vector62
vector62:
  pushl $0
  1020c2:	6a 00                	push   $0x0
  pushl $62
  1020c4:	6a 3e                	push   $0x3e
  jmp __alltraps
  1020c6:	e9 b5 fd ff ff       	jmp    101e80 <__alltraps>

001020cb <vector63>:
.globl vector63
vector63:
  pushl $0
  1020cb:	6a 00                	push   $0x0
  pushl $63
  1020cd:	6a 3f                	push   $0x3f
  jmp __alltraps
  1020cf:	e9 ac fd ff ff       	jmp    101e80 <__alltraps>

001020d4 <vector64>:
.globl vector64
vector64:
  pushl $0
  1020d4:	6a 00                	push   $0x0
  pushl $64
  1020d6:	6a 40                	push   $0x40
  jmp __alltraps
  1020d8:	e9 a3 fd ff ff       	jmp    101e80 <__alltraps>

001020dd <vector65>:
.globl vector65
vector65:
  pushl $0
  1020dd:	6a 00                	push   $0x0
  pushl $65
  1020df:	6a 41                	push   $0x41
  jmp __alltraps
  1020e1:	e9 9a fd ff ff       	jmp    101e80 <__alltraps>

001020e6 <vector66>:
.globl vector66
vector66:
  pushl $0
  1020e6:	6a 00                	push   $0x0
  pushl $66
  1020e8:	6a 42                	push   $0x42
  jmp __alltraps
  1020ea:	e9 91 fd ff ff       	jmp    101e80 <__alltraps>

001020ef <vector67>:
.globl vector67
vector67:
  pushl $0
  1020ef:	6a 00                	push   $0x0
  pushl $67
  1020f1:	6a 43                	push   $0x43
  jmp __alltraps
  1020f3:	e9 88 fd ff ff       	jmp    101e80 <__alltraps>

001020f8 <vector68>:
.globl vector68
vector68:
  pushl $0
  1020f8:	6a 00                	push   $0x0
  pushl $68
  1020fa:	6a 44                	push   $0x44
  jmp __alltraps
  1020fc:	e9 7f fd ff ff       	jmp    101e80 <__alltraps>

00102101 <vector69>:
.globl vector69
vector69:
  pushl $0
  102101:	6a 00                	push   $0x0
  pushl $69
  102103:	6a 45                	push   $0x45
  jmp __alltraps
  102105:	e9 76 fd ff ff       	jmp    101e80 <__alltraps>

0010210a <vector70>:
.globl vector70
vector70:
  pushl $0
  10210a:	6a 00                	push   $0x0
  pushl $70
  10210c:	6a 46                	push   $0x46
  jmp __alltraps
  10210e:	e9 6d fd ff ff       	jmp    101e80 <__alltraps>

00102113 <vector71>:
.globl vector71
vector71:
  pushl $0
  102113:	6a 00                	push   $0x0
  pushl $71
  102115:	6a 47                	push   $0x47
  jmp __alltraps
  102117:	e9 64 fd ff ff       	jmp    101e80 <__alltraps>

0010211c <vector72>:
.globl vector72
vector72:
  pushl $0
  10211c:	6a 00                	push   $0x0
  pushl $72
  10211e:	6a 48                	push   $0x48
  jmp __alltraps
  102120:	e9 5b fd ff ff       	jmp    101e80 <__alltraps>

00102125 <vector73>:
.globl vector73
vector73:
  pushl $0
  102125:	6a 00                	push   $0x0
  pushl $73
  102127:	6a 49                	push   $0x49
  jmp __alltraps
  102129:	e9 52 fd ff ff       	jmp    101e80 <__alltraps>

0010212e <vector74>:
.globl vector74
vector74:
  pushl $0
  10212e:	6a 00                	push   $0x0
  pushl $74
  102130:	6a 4a                	push   $0x4a
  jmp __alltraps
  102132:	e9 49 fd ff ff       	jmp    101e80 <__alltraps>

00102137 <vector75>:
.globl vector75
vector75:
  pushl $0
  102137:	6a 00                	push   $0x0
  pushl $75
  102139:	6a 4b                	push   $0x4b
  jmp __alltraps
  10213b:	e9 40 fd ff ff       	jmp    101e80 <__alltraps>

00102140 <vector76>:
.globl vector76
vector76:
  pushl $0
  102140:	6a 00                	push   $0x0
  pushl $76
  102142:	6a 4c                	push   $0x4c
  jmp __alltraps
  102144:	e9 37 fd ff ff       	jmp    101e80 <__alltraps>

00102149 <vector77>:
.globl vector77
vector77:
  pushl $0
  102149:	6a 00                	push   $0x0
  pushl $77
  10214b:	6a 4d                	push   $0x4d
  jmp __alltraps
  10214d:	e9 2e fd ff ff       	jmp    101e80 <__alltraps>

00102152 <vector78>:
.globl vector78
vector78:
  pushl $0
  102152:	6a 00                	push   $0x0
  pushl $78
  102154:	6a 4e                	push   $0x4e
  jmp __alltraps
  102156:	e9 25 fd ff ff       	jmp    101e80 <__alltraps>

0010215b <vector79>:
.globl vector79
vector79:
  pushl $0
  10215b:	6a 00                	push   $0x0
  pushl $79
  10215d:	6a 4f                	push   $0x4f
  jmp __alltraps
  10215f:	e9 1c fd ff ff       	jmp    101e80 <__alltraps>

00102164 <vector80>:
.globl vector80
vector80:
  pushl $0
  102164:	6a 00                	push   $0x0
  pushl $80
  102166:	6a 50                	push   $0x50
  jmp __alltraps
  102168:	e9 13 fd ff ff       	jmp    101e80 <__alltraps>

0010216d <vector81>:
.globl vector81
vector81:
  pushl $0
  10216d:	6a 00                	push   $0x0
  pushl $81
  10216f:	6a 51                	push   $0x51
  jmp __alltraps
  102171:	e9 0a fd ff ff       	jmp    101e80 <__alltraps>

00102176 <vector82>:
.globl vector82
vector82:
  pushl $0
  102176:	6a 00                	push   $0x0
  pushl $82
  102178:	6a 52                	push   $0x52
  jmp __alltraps
  10217a:	e9 01 fd ff ff       	jmp    101e80 <__alltraps>

0010217f <vector83>:
.globl vector83
vector83:
  pushl $0
  10217f:	6a 00                	push   $0x0
  pushl $83
  102181:	6a 53                	push   $0x53
  jmp __alltraps
  102183:	e9 f8 fc ff ff       	jmp    101e80 <__alltraps>

00102188 <vector84>:
.globl vector84
vector84:
  pushl $0
  102188:	6a 00                	push   $0x0
  pushl $84
  10218a:	6a 54                	push   $0x54
  jmp __alltraps
  10218c:	e9 ef fc ff ff       	jmp    101e80 <__alltraps>

00102191 <vector85>:
.globl vector85
vector85:
  pushl $0
  102191:	6a 00                	push   $0x0
  pushl $85
  102193:	6a 55                	push   $0x55
  jmp __alltraps
  102195:	e9 e6 fc ff ff       	jmp    101e80 <__alltraps>

0010219a <vector86>:
.globl vector86
vector86:
  pushl $0
  10219a:	6a 00                	push   $0x0
  pushl $86
  10219c:	6a 56                	push   $0x56
  jmp __alltraps
  10219e:	e9 dd fc ff ff       	jmp    101e80 <__alltraps>

001021a3 <vector87>:
.globl vector87
vector87:
  pushl $0
  1021a3:	6a 00                	push   $0x0
  pushl $87
  1021a5:	6a 57                	push   $0x57
  jmp __alltraps
  1021a7:	e9 d4 fc ff ff       	jmp    101e80 <__alltraps>

001021ac <vector88>:
.globl vector88
vector88:
  pushl $0
  1021ac:	6a 00                	push   $0x0
  pushl $88
  1021ae:	6a 58                	push   $0x58
  jmp __alltraps
  1021b0:	e9 cb fc ff ff       	jmp    101e80 <__alltraps>

001021b5 <vector89>:
.globl vector89
vector89:
  pushl $0
  1021b5:	6a 00                	push   $0x0
  pushl $89
  1021b7:	6a 59                	push   $0x59
  jmp __alltraps
  1021b9:	e9 c2 fc ff ff       	jmp    101e80 <__alltraps>

001021be <vector90>:
.globl vector90
vector90:
  pushl $0
  1021be:	6a 00                	push   $0x0
  pushl $90
  1021c0:	6a 5a                	push   $0x5a
  jmp __alltraps
  1021c2:	e9 b9 fc ff ff       	jmp    101e80 <__alltraps>

001021c7 <vector91>:
.globl vector91
vector91:
  pushl $0
  1021c7:	6a 00                	push   $0x0
  pushl $91
  1021c9:	6a 5b                	push   $0x5b
  jmp __alltraps
  1021cb:	e9 b0 fc ff ff       	jmp    101e80 <__alltraps>

001021d0 <vector92>:
.globl vector92
vector92:
  pushl $0
  1021d0:	6a 00                	push   $0x0
  pushl $92
  1021d2:	6a 5c                	push   $0x5c
  jmp __alltraps
  1021d4:	e9 a7 fc ff ff       	jmp    101e80 <__alltraps>

001021d9 <vector93>:
.globl vector93
vector93:
  pushl $0
  1021d9:	6a 00                	push   $0x0
  pushl $93
  1021db:	6a 5d                	push   $0x5d
  jmp __alltraps
  1021dd:	e9 9e fc ff ff       	jmp    101e80 <__alltraps>

001021e2 <vector94>:
.globl vector94
vector94:
  pushl $0
  1021e2:	6a 00                	push   $0x0
  pushl $94
  1021e4:	6a 5e                	push   $0x5e
  jmp __alltraps
  1021e6:	e9 95 fc ff ff       	jmp    101e80 <__alltraps>

001021eb <vector95>:
.globl vector95
vector95:
  pushl $0
  1021eb:	6a 00                	push   $0x0
  pushl $95
  1021ed:	6a 5f                	push   $0x5f
  jmp __alltraps
  1021ef:	e9 8c fc ff ff       	jmp    101e80 <__alltraps>

001021f4 <vector96>:
.globl vector96
vector96:
  pushl $0
  1021f4:	6a 00                	push   $0x0
  pushl $96
  1021f6:	6a 60                	push   $0x60
  jmp __alltraps
  1021f8:	e9 83 fc ff ff       	jmp    101e80 <__alltraps>

001021fd <vector97>:
.globl vector97
vector97:
  pushl $0
  1021fd:	6a 00                	push   $0x0
  pushl $97
  1021ff:	6a 61                	push   $0x61
  jmp __alltraps
  102201:	e9 7a fc ff ff       	jmp    101e80 <__alltraps>

00102206 <vector98>:
.globl vector98
vector98:
  pushl $0
  102206:	6a 00                	push   $0x0
  pushl $98
  102208:	6a 62                	push   $0x62
  jmp __alltraps
  10220a:	e9 71 fc ff ff       	jmp    101e80 <__alltraps>

0010220f <vector99>:
.globl vector99
vector99:
  pushl $0
  10220f:	6a 00                	push   $0x0
  pushl $99
  102211:	6a 63                	push   $0x63
  jmp __alltraps
  102213:	e9 68 fc ff ff       	jmp    101e80 <__alltraps>

00102218 <vector100>:
.globl vector100
vector100:
  pushl $0
  102218:	6a 00                	push   $0x0
  pushl $100
  10221a:	6a 64                	push   $0x64
  jmp __alltraps
  10221c:	e9 5f fc ff ff       	jmp    101e80 <__alltraps>

00102221 <vector101>:
.globl vector101
vector101:
  pushl $0
  102221:	6a 00                	push   $0x0
  pushl $101
  102223:	6a 65                	push   $0x65
  jmp __alltraps
  102225:	e9 56 fc ff ff       	jmp    101e80 <__alltraps>

0010222a <vector102>:
.globl vector102
vector102:
  pushl $0
  10222a:	6a 00                	push   $0x0
  pushl $102
  10222c:	6a 66                	push   $0x66
  jmp __alltraps
  10222e:	e9 4d fc ff ff       	jmp    101e80 <__alltraps>

00102233 <vector103>:
.globl vector103
vector103:
  pushl $0
  102233:	6a 00                	push   $0x0
  pushl $103
  102235:	6a 67                	push   $0x67
  jmp __alltraps
  102237:	e9 44 fc ff ff       	jmp    101e80 <__alltraps>

0010223c <vector104>:
.globl vector104
vector104:
  pushl $0
  10223c:	6a 00                	push   $0x0
  pushl $104
  10223e:	6a 68                	push   $0x68
  jmp __alltraps
  102240:	e9 3b fc ff ff       	jmp    101e80 <__alltraps>

00102245 <vector105>:
.globl vector105
vector105:
  pushl $0
  102245:	6a 00                	push   $0x0
  pushl $105
  102247:	6a 69                	push   $0x69
  jmp __alltraps
  102249:	e9 32 fc ff ff       	jmp    101e80 <__alltraps>

0010224e <vector106>:
.globl vector106
vector106:
  pushl $0
  10224e:	6a 00                	push   $0x0
  pushl $106
  102250:	6a 6a                	push   $0x6a
  jmp __alltraps
  102252:	e9 29 fc ff ff       	jmp    101e80 <__alltraps>

00102257 <vector107>:
.globl vector107
vector107:
  pushl $0
  102257:	6a 00                	push   $0x0
  pushl $107
  102259:	6a 6b                	push   $0x6b
  jmp __alltraps
  10225b:	e9 20 fc ff ff       	jmp    101e80 <__alltraps>

00102260 <vector108>:
.globl vector108
vector108:
  pushl $0
  102260:	6a 00                	push   $0x0
  pushl $108
  102262:	6a 6c                	push   $0x6c
  jmp __alltraps
  102264:	e9 17 fc ff ff       	jmp    101e80 <__alltraps>

00102269 <vector109>:
.globl vector109
vector109:
  pushl $0
  102269:	6a 00                	push   $0x0
  pushl $109
  10226b:	6a 6d                	push   $0x6d
  jmp __alltraps
  10226d:	e9 0e fc ff ff       	jmp    101e80 <__alltraps>

00102272 <vector110>:
.globl vector110
vector110:
  pushl $0
  102272:	6a 00                	push   $0x0
  pushl $110
  102274:	6a 6e                	push   $0x6e
  jmp __alltraps
  102276:	e9 05 fc ff ff       	jmp    101e80 <__alltraps>

0010227b <vector111>:
.globl vector111
vector111:
  pushl $0
  10227b:	6a 00                	push   $0x0
  pushl $111
  10227d:	6a 6f                	push   $0x6f
  jmp __alltraps
  10227f:	e9 fc fb ff ff       	jmp    101e80 <__alltraps>

00102284 <vector112>:
.globl vector112
vector112:
  pushl $0
  102284:	6a 00                	push   $0x0
  pushl $112
  102286:	6a 70                	push   $0x70
  jmp __alltraps
  102288:	e9 f3 fb ff ff       	jmp    101e80 <__alltraps>

0010228d <vector113>:
.globl vector113
vector113:
  pushl $0
  10228d:	6a 00                	push   $0x0
  pushl $113
  10228f:	6a 71                	push   $0x71
  jmp __alltraps
  102291:	e9 ea fb ff ff       	jmp    101e80 <__alltraps>

00102296 <vector114>:
.globl vector114
vector114:
  pushl $0
  102296:	6a 00                	push   $0x0
  pushl $114
  102298:	6a 72                	push   $0x72
  jmp __alltraps
  10229a:	e9 e1 fb ff ff       	jmp    101e80 <__alltraps>

0010229f <vector115>:
.globl vector115
vector115:
  pushl $0
  10229f:	6a 00                	push   $0x0
  pushl $115
  1022a1:	6a 73                	push   $0x73
  jmp __alltraps
  1022a3:	e9 d8 fb ff ff       	jmp    101e80 <__alltraps>

001022a8 <vector116>:
.globl vector116
vector116:
  pushl $0
  1022a8:	6a 00                	push   $0x0
  pushl $116
  1022aa:	6a 74                	push   $0x74
  jmp __alltraps
  1022ac:	e9 cf fb ff ff       	jmp    101e80 <__alltraps>

001022b1 <vector117>:
.globl vector117
vector117:
  pushl $0
  1022b1:	6a 00                	push   $0x0
  pushl $117
  1022b3:	6a 75                	push   $0x75
  jmp __alltraps
  1022b5:	e9 c6 fb ff ff       	jmp    101e80 <__alltraps>

001022ba <vector118>:
.globl vector118
vector118:
  pushl $0
  1022ba:	6a 00                	push   $0x0
  pushl $118
  1022bc:	6a 76                	push   $0x76
  jmp __alltraps
  1022be:	e9 bd fb ff ff       	jmp    101e80 <__alltraps>

001022c3 <vector119>:
.globl vector119
vector119:
  pushl $0
  1022c3:	6a 00                	push   $0x0
  pushl $119
  1022c5:	6a 77                	push   $0x77
  jmp __alltraps
  1022c7:	e9 b4 fb ff ff       	jmp    101e80 <__alltraps>

001022cc <vector120>:
.globl vector120
vector120:
  pushl $0
  1022cc:	6a 00                	push   $0x0
  pushl $120
  1022ce:	6a 78                	push   $0x78
  jmp __alltraps
  1022d0:	e9 ab fb ff ff       	jmp    101e80 <__alltraps>

001022d5 <vector121>:
.globl vector121
vector121:
  pushl $0
  1022d5:	6a 00                	push   $0x0
  pushl $121
  1022d7:	6a 79                	push   $0x79
  jmp __alltraps
  1022d9:	e9 a2 fb ff ff       	jmp    101e80 <__alltraps>

001022de <vector122>:
.globl vector122
vector122:
  pushl $0
  1022de:	6a 00                	push   $0x0
  pushl $122
  1022e0:	6a 7a                	push   $0x7a
  jmp __alltraps
  1022e2:	e9 99 fb ff ff       	jmp    101e80 <__alltraps>

001022e7 <vector123>:
.globl vector123
vector123:
  pushl $0
  1022e7:	6a 00                	push   $0x0
  pushl $123
  1022e9:	6a 7b                	push   $0x7b
  jmp __alltraps
  1022eb:	e9 90 fb ff ff       	jmp    101e80 <__alltraps>

001022f0 <vector124>:
.globl vector124
vector124:
  pushl $0
  1022f0:	6a 00                	push   $0x0
  pushl $124
  1022f2:	6a 7c                	push   $0x7c
  jmp __alltraps
  1022f4:	e9 87 fb ff ff       	jmp    101e80 <__alltraps>

001022f9 <vector125>:
.globl vector125
vector125:
  pushl $0
  1022f9:	6a 00                	push   $0x0
  pushl $125
  1022fb:	6a 7d                	push   $0x7d
  jmp __alltraps
  1022fd:	e9 7e fb ff ff       	jmp    101e80 <__alltraps>

00102302 <vector126>:
.globl vector126
vector126:
  pushl $0
  102302:	6a 00                	push   $0x0
  pushl $126
  102304:	6a 7e                	push   $0x7e
  jmp __alltraps
  102306:	e9 75 fb ff ff       	jmp    101e80 <__alltraps>

0010230b <vector127>:
.globl vector127
vector127:
  pushl $0
  10230b:	6a 00                	push   $0x0
  pushl $127
  10230d:	6a 7f                	push   $0x7f
  jmp __alltraps
  10230f:	e9 6c fb ff ff       	jmp    101e80 <__alltraps>

00102314 <vector128>:
.globl vector128
vector128:
  pushl $0
  102314:	6a 00                	push   $0x0
  pushl $128
  102316:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  10231b:	e9 60 fb ff ff       	jmp    101e80 <__alltraps>

00102320 <vector129>:
.globl vector129
vector129:
  pushl $0
  102320:	6a 00                	push   $0x0
  pushl $129
  102322:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102327:	e9 54 fb ff ff       	jmp    101e80 <__alltraps>

0010232c <vector130>:
.globl vector130
vector130:
  pushl $0
  10232c:	6a 00                	push   $0x0
  pushl $130
  10232e:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102333:	e9 48 fb ff ff       	jmp    101e80 <__alltraps>

00102338 <vector131>:
.globl vector131
vector131:
  pushl $0
  102338:	6a 00                	push   $0x0
  pushl $131
  10233a:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10233f:	e9 3c fb ff ff       	jmp    101e80 <__alltraps>

00102344 <vector132>:
.globl vector132
vector132:
  pushl $0
  102344:	6a 00                	push   $0x0
  pushl $132
  102346:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10234b:	e9 30 fb ff ff       	jmp    101e80 <__alltraps>

00102350 <vector133>:
.globl vector133
vector133:
  pushl $0
  102350:	6a 00                	push   $0x0
  pushl $133
  102352:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102357:	e9 24 fb ff ff       	jmp    101e80 <__alltraps>

0010235c <vector134>:
.globl vector134
vector134:
  pushl $0
  10235c:	6a 00                	push   $0x0
  pushl $134
  10235e:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102363:	e9 18 fb ff ff       	jmp    101e80 <__alltraps>

00102368 <vector135>:
.globl vector135
vector135:
  pushl $0
  102368:	6a 00                	push   $0x0
  pushl $135
  10236a:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10236f:	e9 0c fb ff ff       	jmp    101e80 <__alltraps>

00102374 <vector136>:
.globl vector136
vector136:
  pushl $0
  102374:	6a 00                	push   $0x0
  pushl $136
  102376:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10237b:	e9 00 fb ff ff       	jmp    101e80 <__alltraps>

00102380 <vector137>:
.globl vector137
vector137:
  pushl $0
  102380:	6a 00                	push   $0x0
  pushl $137
  102382:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102387:	e9 f4 fa ff ff       	jmp    101e80 <__alltraps>

0010238c <vector138>:
.globl vector138
vector138:
  pushl $0
  10238c:	6a 00                	push   $0x0
  pushl $138
  10238e:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102393:	e9 e8 fa ff ff       	jmp    101e80 <__alltraps>

00102398 <vector139>:
.globl vector139
vector139:
  pushl $0
  102398:	6a 00                	push   $0x0
  pushl $139
  10239a:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  10239f:	e9 dc fa ff ff       	jmp    101e80 <__alltraps>

001023a4 <vector140>:
.globl vector140
vector140:
  pushl $0
  1023a4:	6a 00                	push   $0x0
  pushl $140
  1023a6:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1023ab:	e9 d0 fa ff ff       	jmp    101e80 <__alltraps>

001023b0 <vector141>:
.globl vector141
vector141:
  pushl $0
  1023b0:	6a 00                	push   $0x0
  pushl $141
  1023b2:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1023b7:	e9 c4 fa ff ff       	jmp    101e80 <__alltraps>

001023bc <vector142>:
.globl vector142
vector142:
  pushl $0
  1023bc:	6a 00                	push   $0x0
  pushl $142
  1023be:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1023c3:	e9 b8 fa ff ff       	jmp    101e80 <__alltraps>

001023c8 <vector143>:
.globl vector143
vector143:
  pushl $0
  1023c8:	6a 00                	push   $0x0
  pushl $143
  1023ca:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1023cf:	e9 ac fa ff ff       	jmp    101e80 <__alltraps>

001023d4 <vector144>:
.globl vector144
vector144:
  pushl $0
  1023d4:	6a 00                	push   $0x0
  pushl $144
  1023d6:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1023db:	e9 a0 fa ff ff       	jmp    101e80 <__alltraps>

001023e0 <vector145>:
.globl vector145
vector145:
  pushl $0
  1023e0:	6a 00                	push   $0x0
  pushl $145
  1023e2:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1023e7:	e9 94 fa ff ff       	jmp    101e80 <__alltraps>

001023ec <vector146>:
.globl vector146
vector146:
  pushl $0
  1023ec:	6a 00                	push   $0x0
  pushl $146
  1023ee:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1023f3:	e9 88 fa ff ff       	jmp    101e80 <__alltraps>

001023f8 <vector147>:
.globl vector147
vector147:
  pushl $0
  1023f8:	6a 00                	push   $0x0
  pushl $147
  1023fa:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1023ff:	e9 7c fa ff ff       	jmp    101e80 <__alltraps>

00102404 <vector148>:
.globl vector148
vector148:
  pushl $0
  102404:	6a 00                	push   $0x0
  pushl $148
  102406:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  10240b:	e9 70 fa ff ff       	jmp    101e80 <__alltraps>

00102410 <vector149>:
.globl vector149
vector149:
  pushl $0
  102410:	6a 00                	push   $0x0
  pushl $149
  102412:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102417:	e9 64 fa ff ff       	jmp    101e80 <__alltraps>

0010241c <vector150>:
.globl vector150
vector150:
  pushl $0
  10241c:	6a 00                	push   $0x0
  pushl $150
  10241e:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102423:	e9 58 fa ff ff       	jmp    101e80 <__alltraps>

00102428 <vector151>:
.globl vector151
vector151:
  pushl $0
  102428:	6a 00                	push   $0x0
  pushl $151
  10242a:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10242f:	e9 4c fa ff ff       	jmp    101e80 <__alltraps>

00102434 <vector152>:
.globl vector152
vector152:
  pushl $0
  102434:	6a 00                	push   $0x0
  pushl $152
  102436:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10243b:	e9 40 fa ff ff       	jmp    101e80 <__alltraps>

00102440 <vector153>:
.globl vector153
vector153:
  pushl $0
  102440:	6a 00                	push   $0x0
  pushl $153
  102442:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102447:	e9 34 fa ff ff       	jmp    101e80 <__alltraps>

0010244c <vector154>:
.globl vector154
vector154:
  pushl $0
  10244c:	6a 00                	push   $0x0
  pushl $154
  10244e:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102453:	e9 28 fa ff ff       	jmp    101e80 <__alltraps>

00102458 <vector155>:
.globl vector155
vector155:
  pushl $0
  102458:	6a 00                	push   $0x0
  pushl $155
  10245a:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10245f:	e9 1c fa ff ff       	jmp    101e80 <__alltraps>

00102464 <vector156>:
.globl vector156
vector156:
  pushl $0
  102464:	6a 00                	push   $0x0
  pushl $156
  102466:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10246b:	e9 10 fa ff ff       	jmp    101e80 <__alltraps>

00102470 <vector157>:
.globl vector157
vector157:
  pushl $0
  102470:	6a 00                	push   $0x0
  pushl $157
  102472:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102477:	e9 04 fa ff ff       	jmp    101e80 <__alltraps>

0010247c <vector158>:
.globl vector158
vector158:
  pushl $0
  10247c:	6a 00                	push   $0x0
  pushl $158
  10247e:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102483:	e9 f8 f9 ff ff       	jmp    101e80 <__alltraps>

00102488 <vector159>:
.globl vector159
vector159:
  pushl $0
  102488:	6a 00                	push   $0x0
  pushl $159
  10248a:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  10248f:	e9 ec f9 ff ff       	jmp    101e80 <__alltraps>

00102494 <vector160>:
.globl vector160
vector160:
  pushl $0
  102494:	6a 00                	push   $0x0
  pushl $160
  102496:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10249b:	e9 e0 f9 ff ff       	jmp    101e80 <__alltraps>

001024a0 <vector161>:
.globl vector161
vector161:
  pushl $0
  1024a0:	6a 00                	push   $0x0
  pushl $161
  1024a2:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1024a7:	e9 d4 f9 ff ff       	jmp    101e80 <__alltraps>

001024ac <vector162>:
.globl vector162
vector162:
  pushl $0
  1024ac:	6a 00                	push   $0x0
  pushl $162
  1024ae:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1024b3:	e9 c8 f9 ff ff       	jmp    101e80 <__alltraps>

001024b8 <vector163>:
.globl vector163
vector163:
  pushl $0
  1024b8:	6a 00                	push   $0x0
  pushl $163
  1024ba:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1024bf:	e9 bc f9 ff ff       	jmp    101e80 <__alltraps>

001024c4 <vector164>:
.globl vector164
vector164:
  pushl $0
  1024c4:	6a 00                	push   $0x0
  pushl $164
  1024c6:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1024cb:	e9 b0 f9 ff ff       	jmp    101e80 <__alltraps>

001024d0 <vector165>:
.globl vector165
vector165:
  pushl $0
  1024d0:	6a 00                	push   $0x0
  pushl $165
  1024d2:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1024d7:	e9 a4 f9 ff ff       	jmp    101e80 <__alltraps>

001024dc <vector166>:
.globl vector166
vector166:
  pushl $0
  1024dc:	6a 00                	push   $0x0
  pushl $166
  1024de:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1024e3:	e9 98 f9 ff ff       	jmp    101e80 <__alltraps>

001024e8 <vector167>:
.globl vector167
vector167:
  pushl $0
  1024e8:	6a 00                	push   $0x0
  pushl $167
  1024ea:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1024ef:	e9 8c f9 ff ff       	jmp    101e80 <__alltraps>

001024f4 <vector168>:
.globl vector168
vector168:
  pushl $0
  1024f4:	6a 00                	push   $0x0
  pushl $168
  1024f6:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1024fb:	e9 80 f9 ff ff       	jmp    101e80 <__alltraps>

00102500 <vector169>:
.globl vector169
vector169:
  pushl $0
  102500:	6a 00                	push   $0x0
  pushl $169
  102502:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102507:	e9 74 f9 ff ff       	jmp    101e80 <__alltraps>

0010250c <vector170>:
.globl vector170
vector170:
  pushl $0
  10250c:	6a 00                	push   $0x0
  pushl $170
  10250e:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102513:	e9 68 f9 ff ff       	jmp    101e80 <__alltraps>

00102518 <vector171>:
.globl vector171
vector171:
  pushl $0
  102518:	6a 00                	push   $0x0
  pushl $171
  10251a:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10251f:	e9 5c f9 ff ff       	jmp    101e80 <__alltraps>

00102524 <vector172>:
.globl vector172
vector172:
  pushl $0
  102524:	6a 00                	push   $0x0
  pushl $172
  102526:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10252b:	e9 50 f9 ff ff       	jmp    101e80 <__alltraps>

00102530 <vector173>:
.globl vector173
vector173:
  pushl $0
  102530:	6a 00                	push   $0x0
  pushl $173
  102532:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102537:	e9 44 f9 ff ff       	jmp    101e80 <__alltraps>

0010253c <vector174>:
.globl vector174
vector174:
  pushl $0
  10253c:	6a 00                	push   $0x0
  pushl $174
  10253e:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102543:	e9 38 f9 ff ff       	jmp    101e80 <__alltraps>

00102548 <vector175>:
.globl vector175
vector175:
  pushl $0
  102548:	6a 00                	push   $0x0
  pushl $175
  10254a:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10254f:	e9 2c f9 ff ff       	jmp    101e80 <__alltraps>

00102554 <vector176>:
.globl vector176
vector176:
  pushl $0
  102554:	6a 00                	push   $0x0
  pushl $176
  102556:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10255b:	e9 20 f9 ff ff       	jmp    101e80 <__alltraps>

00102560 <vector177>:
.globl vector177
vector177:
  pushl $0
  102560:	6a 00                	push   $0x0
  pushl $177
  102562:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102567:	e9 14 f9 ff ff       	jmp    101e80 <__alltraps>

0010256c <vector178>:
.globl vector178
vector178:
  pushl $0
  10256c:	6a 00                	push   $0x0
  pushl $178
  10256e:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102573:	e9 08 f9 ff ff       	jmp    101e80 <__alltraps>

00102578 <vector179>:
.globl vector179
vector179:
  pushl $0
  102578:	6a 00                	push   $0x0
  pushl $179
  10257a:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10257f:	e9 fc f8 ff ff       	jmp    101e80 <__alltraps>

00102584 <vector180>:
.globl vector180
vector180:
  pushl $0
  102584:	6a 00                	push   $0x0
  pushl $180
  102586:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10258b:	e9 f0 f8 ff ff       	jmp    101e80 <__alltraps>

00102590 <vector181>:
.globl vector181
vector181:
  pushl $0
  102590:	6a 00                	push   $0x0
  pushl $181
  102592:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102597:	e9 e4 f8 ff ff       	jmp    101e80 <__alltraps>

0010259c <vector182>:
.globl vector182
vector182:
  pushl $0
  10259c:	6a 00                	push   $0x0
  pushl $182
  10259e:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1025a3:	e9 d8 f8 ff ff       	jmp    101e80 <__alltraps>

001025a8 <vector183>:
.globl vector183
vector183:
  pushl $0
  1025a8:	6a 00                	push   $0x0
  pushl $183
  1025aa:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1025af:	e9 cc f8 ff ff       	jmp    101e80 <__alltraps>

001025b4 <vector184>:
.globl vector184
vector184:
  pushl $0
  1025b4:	6a 00                	push   $0x0
  pushl $184
  1025b6:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1025bb:	e9 c0 f8 ff ff       	jmp    101e80 <__alltraps>

001025c0 <vector185>:
.globl vector185
vector185:
  pushl $0
  1025c0:	6a 00                	push   $0x0
  pushl $185
  1025c2:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1025c7:	e9 b4 f8 ff ff       	jmp    101e80 <__alltraps>

001025cc <vector186>:
.globl vector186
vector186:
  pushl $0
  1025cc:	6a 00                	push   $0x0
  pushl $186
  1025ce:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1025d3:	e9 a8 f8 ff ff       	jmp    101e80 <__alltraps>

001025d8 <vector187>:
.globl vector187
vector187:
  pushl $0
  1025d8:	6a 00                	push   $0x0
  pushl $187
  1025da:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1025df:	e9 9c f8 ff ff       	jmp    101e80 <__alltraps>

001025e4 <vector188>:
.globl vector188
vector188:
  pushl $0
  1025e4:	6a 00                	push   $0x0
  pushl $188
  1025e6:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1025eb:	e9 90 f8 ff ff       	jmp    101e80 <__alltraps>

001025f0 <vector189>:
.globl vector189
vector189:
  pushl $0
  1025f0:	6a 00                	push   $0x0
  pushl $189
  1025f2:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1025f7:	e9 84 f8 ff ff       	jmp    101e80 <__alltraps>

001025fc <vector190>:
.globl vector190
vector190:
  pushl $0
  1025fc:	6a 00                	push   $0x0
  pushl $190
  1025fe:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102603:	e9 78 f8 ff ff       	jmp    101e80 <__alltraps>

00102608 <vector191>:
.globl vector191
vector191:
  pushl $0
  102608:	6a 00                	push   $0x0
  pushl $191
  10260a:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10260f:	e9 6c f8 ff ff       	jmp    101e80 <__alltraps>

00102614 <vector192>:
.globl vector192
vector192:
  pushl $0
  102614:	6a 00                	push   $0x0
  pushl $192
  102616:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  10261b:	e9 60 f8 ff ff       	jmp    101e80 <__alltraps>

00102620 <vector193>:
.globl vector193
vector193:
  pushl $0
  102620:	6a 00                	push   $0x0
  pushl $193
  102622:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102627:	e9 54 f8 ff ff       	jmp    101e80 <__alltraps>

0010262c <vector194>:
.globl vector194
vector194:
  pushl $0
  10262c:	6a 00                	push   $0x0
  pushl $194
  10262e:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102633:	e9 48 f8 ff ff       	jmp    101e80 <__alltraps>

00102638 <vector195>:
.globl vector195
vector195:
  pushl $0
  102638:	6a 00                	push   $0x0
  pushl $195
  10263a:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10263f:	e9 3c f8 ff ff       	jmp    101e80 <__alltraps>

00102644 <vector196>:
.globl vector196
vector196:
  pushl $0
  102644:	6a 00                	push   $0x0
  pushl $196
  102646:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10264b:	e9 30 f8 ff ff       	jmp    101e80 <__alltraps>

00102650 <vector197>:
.globl vector197
vector197:
  pushl $0
  102650:	6a 00                	push   $0x0
  pushl $197
  102652:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102657:	e9 24 f8 ff ff       	jmp    101e80 <__alltraps>

0010265c <vector198>:
.globl vector198
vector198:
  pushl $0
  10265c:	6a 00                	push   $0x0
  pushl $198
  10265e:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102663:	e9 18 f8 ff ff       	jmp    101e80 <__alltraps>

00102668 <vector199>:
.globl vector199
vector199:
  pushl $0
  102668:	6a 00                	push   $0x0
  pushl $199
  10266a:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10266f:	e9 0c f8 ff ff       	jmp    101e80 <__alltraps>

00102674 <vector200>:
.globl vector200
vector200:
  pushl $0
  102674:	6a 00                	push   $0x0
  pushl $200
  102676:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10267b:	e9 00 f8 ff ff       	jmp    101e80 <__alltraps>

00102680 <vector201>:
.globl vector201
vector201:
  pushl $0
  102680:	6a 00                	push   $0x0
  pushl $201
  102682:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102687:	e9 f4 f7 ff ff       	jmp    101e80 <__alltraps>

0010268c <vector202>:
.globl vector202
vector202:
  pushl $0
  10268c:	6a 00                	push   $0x0
  pushl $202
  10268e:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102693:	e9 e8 f7 ff ff       	jmp    101e80 <__alltraps>

00102698 <vector203>:
.globl vector203
vector203:
  pushl $0
  102698:	6a 00                	push   $0x0
  pushl $203
  10269a:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  10269f:	e9 dc f7 ff ff       	jmp    101e80 <__alltraps>

001026a4 <vector204>:
.globl vector204
vector204:
  pushl $0
  1026a4:	6a 00                	push   $0x0
  pushl $204
  1026a6:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1026ab:	e9 d0 f7 ff ff       	jmp    101e80 <__alltraps>

001026b0 <vector205>:
.globl vector205
vector205:
  pushl $0
  1026b0:	6a 00                	push   $0x0
  pushl $205
  1026b2:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1026b7:	e9 c4 f7 ff ff       	jmp    101e80 <__alltraps>

001026bc <vector206>:
.globl vector206
vector206:
  pushl $0
  1026bc:	6a 00                	push   $0x0
  pushl $206
  1026be:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1026c3:	e9 b8 f7 ff ff       	jmp    101e80 <__alltraps>

001026c8 <vector207>:
.globl vector207
vector207:
  pushl $0
  1026c8:	6a 00                	push   $0x0
  pushl $207
  1026ca:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1026cf:	e9 ac f7 ff ff       	jmp    101e80 <__alltraps>

001026d4 <vector208>:
.globl vector208
vector208:
  pushl $0
  1026d4:	6a 00                	push   $0x0
  pushl $208
  1026d6:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1026db:	e9 a0 f7 ff ff       	jmp    101e80 <__alltraps>

001026e0 <vector209>:
.globl vector209
vector209:
  pushl $0
  1026e0:	6a 00                	push   $0x0
  pushl $209
  1026e2:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1026e7:	e9 94 f7 ff ff       	jmp    101e80 <__alltraps>

001026ec <vector210>:
.globl vector210
vector210:
  pushl $0
  1026ec:	6a 00                	push   $0x0
  pushl $210
  1026ee:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1026f3:	e9 88 f7 ff ff       	jmp    101e80 <__alltraps>

001026f8 <vector211>:
.globl vector211
vector211:
  pushl $0
  1026f8:	6a 00                	push   $0x0
  pushl $211
  1026fa:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1026ff:	e9 7c f7 ff ff       	jmp    101e80 <__alltraps>

00102704 <vector212>:
.globl vector212
vector212:
  pushl $0
  102704:	6a 00                	push   $0x0
  pushl $212
  102706:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  10270b:	e9 70 f7 ff ff       	jmp    101e80 <__alltraps>

00102710 <vector213>:
.globl vector213
vector213:
  pushl $0
  102710:	6a 00                	push   $0x0
  pushl $213
  102712:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102717:	e9 64 f7 ff ff       	jmp    101e80 <__alltraps>

0010271c <vector214>:
.globl vector214
vector214:
  pushl $0
  10271c:	6a 00                	push   $0x0
  pushl $214
  10271e:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102723:	e9 58 f7 ff ff       	jmp    101e80 <__alltraps>

00102728 <vector215>:
.globl vector215
vector215:
  pushl $0
  102728:	6a 00                	push   $0x0
  pushl $215
  10272a:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10272f:	e9 4c f7 ff ff       	jmp    101e80 <__alltraps>

00102734 <vector216>:
.globl vector216
vector216:
  pushl $0
  102734:	6a 00                	push   $0x0
  pushl $216
  102736:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  10273b:	e9 40 f7 ff ff       	jmp    101e80 <__alltraps>

00102740 <vector217>:
.globl vector217
vector217:
  pushl $0
  102740:	6a 00                	push   $0x0
  pushl $217
  102742:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102747:	e9 34 f7 ff ff       	jmp    101e80 <__alltraps>

0010274c <vector218>:
.globl vector218
vector218:
  pushl $0
  10274c:	6a 00                	push   $0x0
  pushl $218
  10274e:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102753:	e9 28 f7 ff ff       	jmp    101e80 <__alltraps>

00102758 <vector219>:
.globl vector219
vector219:
  pushl $0
  102758:	6a 00                	push   $0x0
  pushl $219
  10275a:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10275f:	e9 1c f7 ff ff       	jmp    101e80 <__alltraps>

00102764 <vector220>:
.globl vector220
vector220:
  pushl $0
  102764:	6a 00                	push   $0x0
  pushl $220
  102766:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  10276b:	e9 10 f7 ff ff       	jmp    101e80 <__alltraps>

00102770 <vector221>:
.globl vector221
vector221:
  pushl $0
  102770:	6a 00                	push   $0x0
  pushl $221
  102772:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102777:	e9 04 f7 ff ff       	jmp    101e80 <__alltraps>

0010277c <vector222>:
.globl vector222
vector222:
  pushl $0
  10277c:	6a 00                	push   $0x0
  pushl $222
  10277e:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102783:	e9 f8 f6 ff ff       	jmp    101e80 <__alltraps>

00102788 <vector223>:
.globl vector223
vector223:
  pushl $0
  102788:	6a 00                	push   $0x0
  pushl $223
  10278a:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  10278f:	e9 ec f6 ff ff       	jmp    101e80 <__alltraps>

00102794 <vector224>:
.globl vector224
vector224:
  pushl $0
  102794:	6a 00                	push   $0x0
  pushl $224
  102796:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10279b:	e9 e0 f6 ff ff       	jmp    101e80 <__alltraps>

001027a0 <vector225>:
.globl vector225
vector225:
  pushl $0
  1027a0:	6a 00                	push   $0x0
  pushl $225
  1027a2:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1027a7:	e9 d4 f6 ff ff       	jmp    101e80 <__alltraps>

001027ac <vector226>:
.globl vector226
vector226:
  pushl $0
  1027ac:	6a 00                	push   $0x0
  pushl $226
  1027ae:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1027b3:	e9 c8 f6 ff ff       	jmp    101e80 <__alltraps>

001027b8 <vector227>:
.globl vector227
vector227:
  pushl $0
  1027b8:	6a 00                	push   $0x0
  pushl $227
  1027ba:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1027bf:	e9 bc f6 ff ff       	jmp    101e80 <__alltraps>

001027c4 <vector228>:
.globl vector228
vector228:
  pushl $0
  1027c4:	6a 00                	push   $0x0
  pushl $228
  1027c6:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1027cb:	e9 b0 f6 ff ff       	jmp    101e80 <__alltraps>

001027d0 <vector229>:
.globl vector229
vector229:
  pushl $0
  1027d0:	6a 00                	push   $0x0
  pushl $229
  1027d2:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1027d7:	e9 a4 f6 ff ff       	jmp    101e80 <__alltraps>

001027dc <vector230>:
.globl vector230
vector230:
  pushl $0
  1027dc:	6a 00                	push   $0x0
  pushl $230
  1027de:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1027e3:	e9 98 f6 ff ff       	jmp    101e80 <__alltraps>

001027e8 <vector231>:
.globl vector231
vector231:
  pushl $0
  1027e8:	6a 00                	push   $0x0
  pushl $231
  1027ea:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1027ef:	e9 8c f6 ff ff       	jmp    101e80 <__alltraps>

001027f4 <vector232>:
.globl vector232
vector232:
  pushl $0
  1027f4:	6a 00                	push   $0x0
  pushl $232
  1027f6:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1027fb:	e9 80 f6 ff ff       	jmp    101e80 <__alltraps>

00102800 <vector233>:
.globl vector233
vector233:
  pushl $0
  102800:	6a 00                	push   $0x0
  pushl $233
  102802:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102807:	e9 74 f6 ff ff       	jmp    101e80 <__alltraps>

0010280c <vector234>:
.globl vector234
vector234:
  pushl $0
  10280c:	6a 00                	push   $0x0
  pushl $234
  10280e:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102813:	e9 68 f6 ff ff       	jmp    101e80 <__alltraps>

00102818 <vector235>:
.globl vector235
vector235:
  pushl $0
  102818:	6a 00                	push   $0x0
  pushl $235
  10281a:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10281f:	e9 5c f6 ff ff       	jmp    101e80 <__alltraps>

00102824 <vector236>:
.globl vector236
vector236:
  pushl $0
  102824:	6a 00                	push   $0x0
  pushl $236
  102826:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  10282b:	e9 50 f6 ff ff       	jmp    101e80 <__alltraps>

00102830 <vector237>:
.globl vector237
vector237:
  pushl $0
  102830:	6a 00                	push   $0x0
  pushl $237
  102832:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102837:	e9 44 f6 ff ff       	jmp    101e80 <__alltraps>

0010283c <vector238>:
.globl vector238
vector238:
  pushl $0
  10283c:	6a 00                	push   $0x0
  pushl $238
  10283e:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102843:	e9 38 f6 ff ff       	jmp    101e80 <__alltraps>

00102848 <vector239>:
.globl vector239
vector239:
  pushl $0
  102848:	6a 00                	push   $0x0
  pushl $239
  10284a:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10284f:	e9 2c f6 ff ff       	jmp    101e80 <__alltraps>

00102854 <vector240>:
.globl vector240
vector240:
  pushl $0
  102854:	6a 00                	push   $0x0
  pushl $240
  102856:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  10285b:	e9 20 f6 ff ff       	jmp    101e80 <__alltraps>

00102860 <vector241>:
.globl vector241
vector241:
  pushl $0
  102860:	6a 00                	push   $0x0
  pushl $241
  102862:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102867:	e9 14 f6 ff ff       	jmp    101e80 <__alltraps>

0010286c <vector242>:
.globl vector242
vector242:
  pushl $0
  10286c:	6a 00                	push   $0x0
  pushl $242
  10286e:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102873:	e9 08 f6 ff ff       	jmp    101e80 <__alltraps>

00102878 <vector243>:
.globl vector243
vector243:
  pushl $0
  102878:	6a 00                	push   $0x0
  pushl $243
  10287a:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  10287f:	e9 fc f5 ff ff       	jmp    101e80 <__alltraps>

00102884 <vector244>:
.globl vector244
vector244:
  pushl $0
  102884:	6a 00                	push   $0x0
  pushl $244
  102886:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  10288b:	e9 f0 f5 ff ff       	jmp    101e80 <__alltraps>

00102890 <vector245>:
.globl vector245
vector245:
  pushl $0
  102890:	6a 00                	push   $0x0
  pushl $245
  102892:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102897:	e9 e4 f5 ff ff       	jmp    101e80 <__alltraps>

0010289c <vector246>:
.globl vector246
vector246:
  pushl $0
  10289c:	6a 00                	push   $0x0
  pushl $246
  10289e:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1028a3:	e9 d8 f5 ff ff       	jmp    101e80 <__alltraps>

001028a8 <vector247>:
.globl vector247
vector247:
  pushl $0
  1028a8:	6a 00                	push   $0x0
  pushl $247
  1028aa:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1028af:	e9 cc f5 ff ff       	jmp    101e80 <__alltraps>

001028b4 <vector248>:
.globl vector248
vector248:
  pushl $0
  1028b4:	6a 00                	push   $0x0
  pushl $248
  1028b6:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1028bb:	e9 c0 f5 ff ff       	jmp    101e80 <__alltraps>

001028c0 <vector249>:
.globl vector249
vector249:
  pushl $0
  1028c0:	6a 00                	push   $0x0
  pushl $249
  1028c2:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1028c7:	e9 b4 f5 ff ff       	jmp    101e80 <__alltraps>

001028cc <vector250>:
.globl vector250
vector250:
  pushl $0
  1028cc:	6a 00                	push   $0x0
  pushl $250
  1028ce:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1028d3:	e9 a8 f5 ff ff       	jmp    101e80 <__alltraps>

001028d8 <vector251>:
.globl vector251
vector251:
  pushl $0
  1028d8:	6a 00                	push   $0x0
  pushl $251
  1028da:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1028df:	e9 9c f5 ff ff       	jmp    101e80 <__alltraps>

001028e4 <vector252>:
.globl vector252
vector252:
  pushl $0
  1028e4:	6a 00                	push   $0x0
  pushl $252
  1028e6:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1028eb:	e9 90 f5 ff ff       	jmp    101e80 <__alltraps>

001028f0 <vector253>:
.globl vector253
vector253:
  pushl $0
  1028f0:	6a 00                	push   $0x0
  pushl $253
  1028f2:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1028f7:	e9 84 f5 ff ff       	jmp    101e80 <__alltraps>

001028fc <vector254>:
.globl vector254
vector254:
  pushl $0
  1028fc:	6a 00                	push   $0x0
  pushl $254
  1028fe:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102903:	e9 78 f5 ff ff       	jmp    101e80 <__alltraps>

00102908 <vector255>:
.globl vector255
vector255:
  pushl $0
  102908:	6a 00                	push   $0x0
  pushl $255
  10290a:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  10290f:	e9 6c f5 ff ff       	jmp    101e80 <__alltraps>

00102914 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102914:	55                   	push   %ebp
  102915:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102917:	8b 55 08             	mov    0x8(%ebp),%edx
  10291a:	a1 64 89 11 00       	mov    0x118964,%eax
  10291f:	89 d1                	mov    %edx,%ecx
  102921:	29 c1                	sub    %eax,%ecx
  102923:	89 c8                	mov    %ecx,%eax
  102925:	c1 f8 02             	sar    $0x2,%eax
  102928:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  10292e:	5d                   	pop    %ebp
  10292f:	c3                   	ret    

00102930 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102930:	55                   	push   %ebp
  102931:	89 e5                	mov    %esp,%ebp
  102933:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  102936:	8b 45 08             	mov    0x8(%ebp),%eax
  102939:	89 04 24             	mov    %eax,(%esp)
  10293c:	e8 d3 ff ff ff       	call   102914 <page2ppn>
  102941:	c1 e0 0c             	shl    $0xc,%eax
}
  102944:	c9                   	leave  
  102945:	c3                   	ret    

00102946 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  102946:	55                   	push   %ebp
  102947:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102949:	8b 45 08             	mov    0x8(%ebp),%eax
  10294c:	8b 00                	mov    (%eax),%eax
}
  10294e:	5d                   	pop    %ebp
  10294f:	c3                   	ret    

00102950 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102950:	55                   	push   %ebp
  102951:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102953:	8b 45 08             	mov    0x8(%ebp),%eax
  102956:	8b 55 0c             	mov    0xc(%ebp),%edx
  102959:	89 10                	mov    %edx,(%eax)
}
  10295b:	5d                   	pop    %ebp
  10295c:	c3                   	ret    

0010295d <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  10295d:	55                   	push   %ebp
  10295e:	89 e5                	mov    %esp,%ebp
  102960:	83 ec 10             	sub    $0x10,%esp
  102963:	c7 45 fc 50 89 11 00 	movl   $0x118950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  10296a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10296d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  102970:	89 50 04             	mov    %edx,0x4(%eax)
  102973:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102976:	8b 50 04             	mov    0x4(%eax),%edx
  102979:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10297c:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  10297e:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  102985:	00 00 00 
}
  102988:	c9                   	leave  
  102989:	c3                   	ret    

0010298a <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  10298a:	55                   	push   %ebp
  10298b:	89 e5                	mov    %esp,%ebp
  10298d:	53                   	push   %ebx
  10298e:	83 ec 54             	sub    $0x54,%esp
    assert(n > 0);
  102991:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102995:	75 24                	jne    1029bb <default_init_memmap+0x31>
  102997:	c7 44 24 0c d0 67 10 	movl   $0x1067d0,0xc(%esp)
  10299e:	00 
  10299f:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  1029a6:	00 
  1029a7:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
  1029ae:	00 
  1029af:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  1029b6:	e8 e1 e2 ff ff       	call   100c9c <__panic>
    struct Page *p = base;
  1029bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1029be:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  1029c1:	eb 7d                	jmp    102a40 <default_init_memmap+0xb6>
        assert(PageReserved(p));
  1029c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029c6:	83 c0 04             	add    $0x4,%eax
  1029c9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1029d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1029d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1029d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1029d9:	0f a3 10             	bt     %edx,(%eax)
  1029dc:	19 db                	sbb    %ebx,%ebx
  1029de:	89 5d e8             	mov    %ebx,-0x18(%ebp)
    return oldbit != 0;
  1029e1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1029e5:	0f 95 c0             	setne  %al
  1029e8:	0f b6 c0             	movzbl %al,%eax
  1029eb:	85 c0                	test   %eax,%eax
  1029ed:	75 24                	jne    102a13 <default_init_memmap+0x89>
  1029ef:	c7 44 24 0c 01 68 10 	movl   $0x106801,0xc(%esp)
  1029f6:	00 
  1029f7:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  1029fe:	00 
  1029ff:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
  102a06:	00 
  102a07:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  102a0e:	e8 89 e2 ff ff       	call   100c9c <__panic>
        p->flags = p->property = 0;
  102a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a16:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  102a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a20:	8b 50 08             	mov    0x8(%eax),%edx
  102a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a26:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  102a29:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102a30:	00 
  102a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a34:	89 04 24             	mov    %eax,(%esp)
  102a37:	e8 14 ff ff ff       	call   102950 <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  102a3c:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102a40:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a43:	89 d0                	mov    %edx,%eax
  102a45:	c1 e0 02             	shl    $0x2,%eax
  102a48:	01 d0                	add    %edx,%eax
  102a4a:	c1 e0 02             	shl    $0x2,%eax
  102a4d:	03 45 08             	add    0x8(%ebp),%eax
  102a50:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102a53:	0f 85 6a ff ff ff    	jne    1029c3 <default_init_memmap+0x39>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
  102a59:	8b 45 08             	mov    0x8(%ebp),%eax
  102a5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a5f:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  102a62:	8b 45 08             	mov    0x8(%ebp),%eax
  102a65:	83 c0 04             	add    $0x4,%eax
  102a68:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  102a6f:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102a72:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102a75:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102a78:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
  102a7b:	a1 58 89 11 00       	mov    0x118958,%eax
  102a80:	03 45 0c             	add    0xc(%ebp),%eax
  102a83:	a3 58 89 11 00       	mov    %eax,0x118958
    list_add(&free_list, &(base->page_link));
  102a88:	8b 45 08             	mov    0x8(%ebp),%eax
  102a8b:	83 c0 0c             	add    $0xc,%eax
  102a8e:	c7 45 dc 50 89 11 00 	movl   $0x118950,-0x24(%ebp)
  102a95:	89 45 d8             	mov    %eax,-0x28(%ebp)
  102a98:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102a9b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  102a9e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102aa1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  102aa4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102aa7:	8b 40 04             	mov    0x4(%eax),%eax
  102aaa:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102aad:	89 55 cc             	mov    %edx,-0x34(%ebp)
  102ab0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102ab3:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102ab6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102ab9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102abc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102abf:	89 10                	mov    %edx,(%eax)
  102ac1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102ac4:	8b 10                	mov    (%eax),%edx
  102ac6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102ac9:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102acc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102acf:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102ad2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102ad5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102ad8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102adb:	89 10                	mov    %edx,(%eax)
}
  102add:	83 c4 54             	add    $0x54,%esp
  102ae0:	5b                   	pop    %ebx
  102ae1:	5d                   	pop    %ebp
  102ae2:	c3                   	ret    

00102ae3 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  102ae3:	55                   	push   %ebp
  102ae4:	89 e5                	mov    %esp,%ebp
  102ae6:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  102ae9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102aed:	75 24                	jne    102b13 <default_alloc_pages+0x30>
  102aef:	c7 44 24 0c d0 67 10 	movl   $0x1067d0,0xc(%esp)
  102af6:	00 
  102af7:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  102afe:	00 
  102aff:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
  102b06:	00 
  102b07:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  102b0e:	e8 89 e1 ff ff       	call   100c9c <__panic>
    if (n > nr_free) {
  102b13:	a1 58 89 11 00       	mov    0x118958,%eax
  102b18:	3b 45 08             	cmp    0x8(%ebp),%eax
  102b1b:	73 0a                	jae    102b27 <default_alloc_pages+0x44>
        return NULL;
  102b1d:	b8 00 00 00 00       	mov    $0x0,%eax
  102b22:	e9 26 01 00 00       	jmp    102c4d <default_alloc_pages+0x16a>
    }
    struct Page *page = NULL;
  102b27:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  102b2e:	c7 45 f0 50 89 11 00 	movl   $0x118950,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  102b35:	eb 1c                	jmp    102b53 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
  102b37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b3a:	83 e8 0c             	sub    $0xc,%eax
  102b3d:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
  102b40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b43:	8b 40 08             	mov    0x8(%eax),%eax
  102b46:	3b 45 08             	cmp    0x8(%ebp),%eax
  102b49:	72 08                	jb     102b53 <default_alloc_pages+0x70>
            page = p;
  102b4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  102b51:	eb 18                	jmp    102b6b <default_alloc_pages+0x88>
  102b53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b56:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102b59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b5c:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  102b5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102b62:	81 7d f0 50 89 11 00 	cmpl   $0x118950,-0x10(%ebp)
  102b69:	75 cc                	jne    102b37 <default_alloc_pages+0x54>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
  102b6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102b6f:	0f 84 d5 00 00 00    	je     102c4a <default_alloc_pages+0x167>
        list_del(&(page->page_link));
  102b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b78:	83 c0 0c             	add    $0xc,%eax
  102b7b:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102b7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b81:	8b 40 04             	mov    0x4(%eax),%eax
  102b84:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102b87:	8b 12                	mov    (%edx),%edx
  102b89:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102b8c:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102b8f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b92:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102b95:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102b98:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102b9b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102b9e:	89 10                	mov    %edx,(%eax)
        if (page->property > n) {
  102ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ba3:	8b 40 08             	mov    0x8(%eax),%eax
  102ba6:	3b 45 08             	cmp    0x8(%ebp),%eax
  102ba9:	76 79                	jbe    102c24 <default_alloc_pages+0x141>
            struct Page *p = page + n;
  102bab:	8b 55 08             	mov    0x8(%ebp),%edx
  102bae:	89 d0                	mov    %edx,%eax
  102bb0:	c1 e0 02             	shl    $0x2,%eax
  102bb3:	01 d0                	add    %edx,%eax
  102bb5:	c1 e0 02             	shl    $0x2,%eax
  102bb8:	03 45 f4             	add    -0xc(%ebp),%eax
  102bbb:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
  102bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bc1:	8b 40 08             	mov    0x8(%eax),%eax
  102bc4:	89 c2                	mov    %eax,%edx
  102bc6:	2b 55 08             	sub    0x8(%ebp),%edx
  102bc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102bcc:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&free_list, &(p->page_link));
  102bcf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102bd2:	83 c0 0c             	add    $0xc,%eax
  102bd5:	c7 45 d4 50 89 11 00 	movl   $0x118950,-0x2c(%ebp)
  102bdc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102bdf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102be2:	89 45 cc             	mov    %eax,-0x34(%ebp)
  102be5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102be8:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  102beb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102bee:	8b 40 04             	mov    0x4(%eax),%eax
  102bf1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102bf4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  102bf7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102bfa:	89 55 c0             	mov    %edx,-0x40(%ebp)
  102bfd:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102c00:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102c03:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102c06:	89 10                	mov    %edx,(%eax)
  102c08:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102c0b:	8b 10                	mov    (%eax),%edx
  102c0d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102c10:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102c13:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102c16:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102c19:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102c1c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102c1f:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102c22:	89 10                	mov    %edx,(%eax)
    }
        nr_free -= n;
  102c24:	a1 58 89 11 00       	mov    0x118958,%eax
  102c29:	2b 45 08             	sub    0x8(%ebp),%eax
  102c2c:	a3 58 89 11 00       	mov    %eax,0x118958
        ClearPageProperty(page);
  102c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c34:	83 c0 04             	add    $0x4,%eax
  102c37:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  102c3e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102c41:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102c44:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102c47:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
  102c4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102c4d:	c9                   	leave  
  102c4e:	c3                   	ret    

00102c4f <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  102c4f:	55                   	push   %ebp
  102c50:	89 e5                	mov    %esp,%ebp
  102c52:	53                   	push   %ebx
  102c53:	81 ec 84 00 00 00    	sub    $0x84,%esp
    assert(n > 0);
  102c59:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102c5d:	75 24                	jne    102c83 <default_free_pages+0x34>
  102c5f:	c7 44 24 0c d0 67 10 	movl   $0x1067d0,0xc(%esp)
  102c66:	00 
  102c67:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  102c6e:	00 
  102c6f:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
  102c76:	00 
  102c77:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  102c7e:	e8 19 e0 ff ff       	call   100c9c <__panic>
    struct Page *p = base;
  102c83:	8b 45 08             	mov    0x8(%ebp),%eax
  102c86:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  102c89:	e9 9d 00 00 00       	jmp    102d2b <default_free_pages+0xdc>
        assert(!PageReserved(p) && !PageProperty(p));
  102c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c91:	83 c0 04             	add    $0x4,%eax
  102c94:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  102c9b:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102c9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ca1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102ca4:	0f a3 10             	bt     %edx,(%eax)
  102ca7:	19 db                	sbb    %ebx,%ebx
  102ca9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
    return oldbit != 0;
  102cac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102cb0:	0f 95 c0             	setne  %al
  102cb3:	0f b6 c0             	movzbl %al,%eax
  102cb6:	85 c0                	test   %eax,%eax
  102cb8:	75 2c                	jne    102ce6 <default_free_pages+0x97>
  102cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cbd:	83 c0 04             	add    $0x4,%eax
  102cc0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  102cc7:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102cca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102ccd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102cd0:	0f a3 10             	bt     %edx,(%eax)
  102cd3:	19 db                	sbb    %ebx,%ebx
  102cd5:	89 5d d8             	mov    %ebx,-0x28(%ebp)
    return oldbit != 0;
  102cd8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  102cdc:	0f 95 c0             	setne  %al
  102cdf:	0f b6 c0             	movzbl %al,%eax
  102ce2:	85 c0                	test   %eax,%eax
  102ce4:	74 24                	je     102d0a <default_free_pages+0xbb>
  102ce6:	c7 44 24 0c 14 68 10 	movl   $0x106814,0xc(%esp)
  102ced:	00 
  102cee:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  102cf5:	00 
  102cf6:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
  102cfd:	00 
  102cfe:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  102d05:	e8 92 df ff ff       	call   100c9c <__panic>
        p->flags = 0;
  102d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d0d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  102d14:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102d1b:	00 
  102d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d1f:	89 04 24             	mov    %eax,(%esp)
  102d22:	e8 29 fc ff ff       	call   102950 <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  102d27:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102d2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d2e:	89 d0                	mov    %edx,%eax
  102d30:	c1 e0 02             	shl    $0x2,%eax
  102d33:	01 d0                	add    %edx,%eax
  102d35:	c1 e0 02             	shl    $0x2,%eax
  102d38:	03 45 08             	add    0x8(%ebp),%eax
  102d3b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102d3e:	0f 85 4a ff ff ff    	jne    102c8e <default_free_pages+0x3f>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
  102d44:	8b 45 08             	mov    0x8(%ebp),%eax
  102d47:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d4a:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  102d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  102d50:	83 c0 04             	add    $0x4,%eax
  102d53:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  102d5a:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102d5d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102d60:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102d63:	0f ab 10             	bts    %edx,(%eax)
  102d66:	c7 45 cc 50 89 11 00 	movl   $0x118950,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102d6d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102d70:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  102d73:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  102d76:	e9 00 01 00 00       	jmp    102e7b <default_free_pages+0x22c>
        p = le2page(le, page_link);
  102d7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d7e:	83 e8 0c             	sub    $0xc,%eax
  102d81:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d87:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102d8a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102d8d:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  102d90:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
  102d93:	8b 45 08             	mov    0x8(%ebp),%eax
  102d96:	8b 50 08             	mov    0x8(%eax),%edx
  102d99:	89 d0                	mov    %edx,%eax
  102d9b:	c1 e0 02             	shl    $0x2,%eax
  102d9e:	01 d0                	add    %edx,%eax
  102da0:	c1 e0 02             	shl    $0x2,%eax
  102da3:	03 45 08             	add    0x8(%ebp),%eax
  102da6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102da9:	75 5a                	jne    102e05 <default_free_pages+0x1b6>
            base->property += p->property;
  102dab:	8b 45 08             	mov    0x8(%ebp),%eax
  102dae:	8b 50 08             	mov    0x8(%eax),%edx
  102db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102db4:	8b 40 08             	mov    0x8(%eax),%eax
  102db7:	01 c2                	add    %eax,%edx
  102db9:	8b 45 08             	mov    0x8(%ebp),%eax
  102dbc:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  102dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dc2:	83 c0 04             	add    $0x4,%eax
  102dc5:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  102dcc:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102dcf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102dd2:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102dd5:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
  102dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ddb:	83 c0 0c             	add    $0xc,%eax
  102dde:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102de1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102de4:	8b 40 04             	mov    0x4(%eax),%eax
  102de7:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102dea:	8b 12                	mov    (%edx),%edx
  102dec:	89 55 b8             	mov    %edx,-0x48(%ebp)
  102def:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102df2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102df5:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102df8:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102dfb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102dfe:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102e01:	89 10                	mov    %edx,(%eax)
  102e03:	eb 76                	jmp    102e7b <default_free_pages+0x22c>
        }
        else if (p + p->property == base) {
  102e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e08:	8b 50 08             	mov    0x8(%eax),%edx
  102e0b:	89 d0                	mov    %edx,%eax
  102e0d:	c1 e0 02             	shl    $0x2,%eax
  102e10:	01 d0                	add    %edx,%eax
  102e12:	c1 e0 02             	shl    $0x2,%eax
  102e15:	03 45 f4             	add    -0xc(%ebp),%eax
  102e18:	3b 45 08             	cmp    0x8(%ebp),%eax
  102e1b:	75 5e                	jne    102e7b <default_free_pages+0x22c>
            p->property += base->property;
  102e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e20:	8b 50 08             	mov    0x8(%eax),%edx
  102e23:	8b 45 08             	mov    0x8(%ebp),%eax
  102e26:	8b 40 08             	mov    0x8(%eax),%eax
  102e29:	01 c2                	add    %eax,%edx
  102e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e2e:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  102e31:	8b 45 08             	mov    0x8(%ebp),%eax
  102e34:	83 c0 04             	add    $0x4,%eax
  102e37:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
  102e3e:	89 45 ac             	mov    %eax,-0x54(%ebp)
  102e41:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102e44:	8b 55 b0             	mov    -0x50(%ebp),%edx
  102e47:	0f b3 10             	btr    %edx,(%eax)
            base = p;
  102e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e4d:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  102e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e53:	83 c0 0c             	add    $0xc,%eax
  102e56:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102e59:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102e5c:	8b 40 04             	mov    0x4(%eax),%eax
  102e5f:	8b 55 a8             	mov    -0x58(%ebp),%edx
  102e62:	8b 12                	mov    (%edx),%edx
  102e64:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  102e67:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102e6a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102e6d:	8b 55 a0             	mov    -0x60(%ebp),%edx
  102e70:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102e73:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102e76:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102e79:	89 10                	mov    %edx,(%eax)
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
  102e7b:	81 7d f0 50 89 11 00 	cmpl   $0x118950,-0x10(%ebp)
  102e82:	0f 85 f3 fe ff ff    	jne    102d7b <default_free_pages+0x12c>
            ClearPageProperty(base);
            base = p;
            list_del(&(p->page_link));
        }
    }
    nr_free += n;
  102e88:	a1 58 89 11 00       	mov    0x118958,%eax
  102e8d:	03 45 0c             	add    0xc(%ebp),%eax
  102e90:	a3 58 89 11 00       	mov    %eax,0x118958
    list_add_before(&free_list, &(base->page_link));
  102e95:	8b 45 08             	mov    0x8(%ebp),%eax
  102e98:	83 c0 0c             	add    $0xc,%eax
  102e9b:	c7 45 9c 50 89 11 00 	movl   $0x118950,-0x64(%ebp)
  102ea2:	89 45 98             	mov    %eax,-0x68(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102ea5:	8b 45 9c             	mov    -0x64(%ebp),%eax
  102ea8:	8b 00                	mov    (%eax),%eax
  102eaa:	8b 55 98             	mov    -0x68(%ebp),%edx
  102ead:	89 55 94             	mov    %edx,-0x6c(%ebp)
  102eb0:	89 45 90             	mov    %eax,-0x70(%ebp)
  102eb3:	8b 45 9c             	mov    -0x64(%ebp),%eax
  102eb6:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102eb9:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102ebc:	8b 55 94             	mov    -0x6c(%ebp),%edx
  102ebf:	89 10                	mov    %edx,(%eax)
  102ec1:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102ec4:	8b 10                	mov    (%eax),%edx
  102ec6:	8b 45 90             	mov    -0x70(%ebp),%eax
  102ec9:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102ecc:	8b 45 94             	mov    -0x6c(%ebp),%eax
  102ecf:	8b 55 8c             	mov    -0x74(%ebp),%edx
  102ed2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102ed5:	8b 45 94             	mov    -0x6c(%ebp),%eax
  102ed8:	8b 55 90             	mov    -0x70(%ebp),%edx
  102edb:	89 10                	mov    %edx,(%eax)
}
  102edd:	81 c4 84 00 00 00    	add    $0x84,%esp
  102ee3:	5b                   	pop    %ebx
  102ee4:	5d                   	pop    %ebp
  102ee5:	c3                   	ret    

00102ee6 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  102ee6:	55                   	push   %ebp
  102ee7:	89 e5                	mov    %esp,%ebp
    return nr_free;
  102ee9:	a1 58 89 11 00       	mov    0x118958,%eax
}
  102eee:	5d                   	pop    %ebp
  102eef:	c3                   	ret    

00102ef0 <basic_check>:

static void
basic_check(void) {
  102ef0:	55                   	push   %ebp
  102ef1:	89 e5                	mov    %esp,%ebp
  102ef3:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  102ef6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f00:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f06:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  102f09:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102f10:	e8 90 0e 00 00       	call   103da5 <alloc_pages>
  102f15:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f18:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  102f1c:	75 24                	jne    102f42 <basic_check+0x52>
  102f1e:	c7 44 24 0c 39 68 10 	movl   $0x106839,0xc(%esp)
  102f25:	00 
  102f26:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  102f2d:	00 
  102f2e:	c7 44 24 04 97 00 00 	movl   $0x97,0x4(%esp)
  102f35:	00 
  102f36:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  102f3d:	e8 5a dd ff ff       	call   100c9c <__panic>
    assert((p1 = alloc_page()) != NULL);
  102f42:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102f49:	e8 57 0e 00 00       	call   103da5 <alloc_pages>
  102f4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f51:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102f55:	75 24                	jne    102f7b <basic_check+0x8b>
  102f57:	c7 44 24 0c 55 68 10 	movl   $0x106855,0xc(%esp)
  102f5e:	00 
  102f5f:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  102f66:	00 
  102f67:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
  102f6e:	00 
  102f6f:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  102f76:	e8 21 dd ff ff       	call   100c9c <__panic>
    assert((p2 = alloc_page()) != NULL);
  102f7b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102f82:	e8 1e 0e 00 00       	call   103da5 <alloc_pages>
  102f87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102f8e:	75 24                	jne    102fb4 <basic_check+0xc4>
  102f90:	c7 44 24 0c 71 68 10 	movl   $0x106871,0xc(%esp)
  102f97:	00 
  102f98:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  102f9f:	00 
  102fa0:	c7 44 24 04 99 00 00 	movl   $0x99,0x4(%esp)
  102fa7:	00 
  102fa8:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  102faf:	e8 e8 dc ff ff       	call   100c9c <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  102fb4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fb7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102fba:	74 10                	je     102fcc <basic_check+0xdc>
  102fbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fbf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102fc2:	74 08                	je     102fcc <basic_check+0xdc>
  102fc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fc7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102fca:	75 24                	jne    102ff0 <basic_check+0x100>
  102fcc:	c7 44 24 0c 90 68 10 	movl   $0x106890,0xc(%esp)
  102fd3:	00 
  102fd4:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  102fdb:	00 
  102fdc:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  102fe3:	00 
  102fe4:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  102feb:	e8 ac dc ff ff       	call   100c9c <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  102ff0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ff3:	89 04 24             	mov    %eax,(%esp)
  102ff6:	e8 4b f9 ff ff       	call   102946 <page_ref>
  102ffb:	85 c0                	test   %eax,%eax
  102ffd:	75 1e                	jne    10301d <basic_check+0x12d>
  102fff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103002:	89 04 24             	mov    %eax,(%esp)
  103005:	e8 3c f9 ff ff       	call   102946 <page_ref>
  10300a:	85 c0                	test   %eax,%eax
  10300c:	75 0f                	jne    10301d <basic_check+0x12d>
  10300e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103011:	89 04 24             	mov    %eax,(%esp)
  103014:	e8 2d f9 ff ff       	call   102946 <page_ref>
  103019:	85 c0                	test   %eax,%eax
  10301b:	74 24                	je     103041 <basic_check+0x151>
  10301d:	c7 44 24 0c b4 68 10 	movl   $0x1068b4,0xc(%esp)
  103024:	00 
  103025:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  10302c:	00 
  10302d:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  103034:	00 
  103035:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  10303c:	e8 5b dc ff ff       	call   100c9c <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  103041:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103044:	89 04 24             	mov    %eax,(%esp)
  103047:	e8 e4 f8 ff ff       	call   102930 <page2pa>
  10304c:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  103052:	c1 e2 0c             	shl    $0xc,%edx
  103055:	39 d0                	cmp    %edx,%eax
  103057:	72 24                	jb     10307d <basic_check+0x18d>
  103059:	c7 44 24 0c f0 68 10 	movl   $0x1068f0,0xc(%esp)
  103060:	00 
  103061:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  103068:	00 
  103069:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  103070:	00 
  103071:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  103078:	e8 1f dc ff ff       	call   100c9c <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  10307d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103080:	89 04 24             	mov    %eax,(%esp)
  103083:	e8 a8 f8 ff ff       	call   102930 <page2pa>
  103088:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  10308e:	c1 e2 0c             	shl    $0xc,%edx
  103091:	39 d0                	cmp    %edx,%eax
  103093:	72 24                	jb     1030b9 <basic_check+0x1c9>
  103095:	c7 44 24 0c 0d 69 10 	movl   $0x10690d,0xc(%esp)
  10309c:	00 
  10309d:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  1030a4:	00 
  1030a5:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
  1030ac:	00 
  1030ad:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  1030b4:	e8 e3 db ff ff       	call   100c9c <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  1030b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1030bc:	89 04 24             	mov    %eax,(%esp)
  1030bf:	e8 6c f8 ff ff       	call   102930 <page2pa>
  1030c4:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  1030ca:	c1 e2 0c             	shl    $0xc,%edx
  1030cd:	39 d0                	cmp    %edx,%eax
  1030cf:	72 24                	jb     1030f5 <basic_check+0x205>
  1030d1:	c7 44 24 0c 2a 69 10 	movl   $0x10692a,0xc(%esp)
  1030d8:	00 
  1030d9:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  1030e0:	00 
  1030e1:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
  1030e8:	00 
  1030e9:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  1030f0:	e8 a7 db ff ff       	call   100c9c <__panic>

    list_entry_t free_list_store = free_list;
  1030f5:	a1 50 89 11 00       	mov    0x118950,%eax
  1030fa:	8b 15 54 89 11 00    	mov    0x118954,%edx
  103100:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103103:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103106:	c7 45 e0 50 89 11 00 	movl   $0x118950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  10310d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103110:	8b 55 e0             	mov    -0x20(%ebp),%edx
  103113:	89 50 04             	mov    %edx,0x4(%eax)
  103116:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103119:	8b 50 04             	mov    0x4(%eax),%edx
  10311c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10311f:	89 10                	mov    %edx,(%eax)
  103121:	c7 45 dc 50 89 11 00 	movl   $0x118950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  103128:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10312b:	8b 40 04             	mov    0x4(%eax),%eax
  10312e:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  103131:	0f 94 c0             	sete   %al
  103134:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  103137:	85 c0                	test   %eax,%eax
  103139:	75 24                	jne    10315f <basic_check+0x26f>
  10313b:	c7 44 24 0c 47 69 10 	movl   $0x106947,0xc(%esp)
  103142:	00 
  103143:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  10314a:	00 
  10314b:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
  103152:	00 
  103153:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  10315a:	e8 3d db ff ff       	call   100c9c <__panic>

    unsigned int nr_free_store = nr_free;
  10315f:	a1 58 89 11 00       	mov    0x118958,%eax
  103164:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  103167:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  10316e:	00 00 00 

    assert(alloc_page() == NULL);
  103171:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103178:	e8 28 0c 00 00       	call   103da5 <alloc_pages>
  10317d:	85 c0                	test   %eax,%eax
  10317f:	74 24                	je     1031a5 <basic_check+0x2b5>
  103181:	c7 44 24 0c 5e 69 10 	movl   $0x10695e,0xc(%esp)
  103188:	00 
  103189:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  103190:	00 
  103191:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
  103198:	00 
  103199:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  1031a0:	e8 f7 da ff ff       	call   100c9c <__panic>

    free_page(p0);
  1031a5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1031ac:	00 
  1031ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1031b0:	89 04 24             	mov    %eax,(%esp)
  1031b3:	e8 25 0c 00 00       	call   103ddd <free_pages>
    free_page(p1);
  1031b8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1031bf:	00 
  1031c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031c3:	89 04 24             	mov    %eax,(%esp)
  1031c6:	e8 12 0c 00 00       	call   103ddd <free_pages>
    free_page(p2);
  1031cb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1031d2:	00 
  1031d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1031d6:	89 04 24             	mov    %eax,(%esp)
  1031d9:	e8 ff 0b 00 00       	call   103ddd <free_pages>
    assert(nr_free == 3);
  1031de:	a1 58 89 11 00       	mov    0x118958,%eax
  1031e3:	83 f8 03             	cmp    $0x3,%eax
  1031e6:	74 24                	je     10320c <basic_check+0x31c>
  1031e8:	c7 44 24 0c 73 69 10 	movl   $0x106973,0xc(%esp)
  1031ef:	00 
  1031f0:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  1031f7:	00 
  1031f8:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
  1031ff:	00 
  103200:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  103207:	e8 90 da ff ff       	call   100c9c <__panic>

    assert((p0 = alloc_page()) != NULL);
  10320c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103213:	e8 8d 0b 00 00       	call   103da5 <alloc_pages>
  103218:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10321b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  10321f:	75 24                	jne    103245 <basic_check+0x355>
  103221:	c7 44 24 0c 39 68 10 	movl   $0x106839,0xc(%esp)
  103228:	00 
  103229:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  103230:	00 
  103231:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
  103238:	00 
  103239:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  103240:	e8 57 da ff ff       	call   100c9c <__panic>
    assert((p1 = alloc_page()) != NULL);
  103245:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10324c:	e8 54 0b 00 00       	call   103da5 <alloc_pages>
  103251:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103254:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103258:	75 24                	jne    10327e <basic_check+0x38e>
  10325a:	c7 44 24 0c 55 68 10 	movl   $0x106855,0xc(%esp)
  103261:	00 
  103262:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  103269:	00 
  10326a:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  103271:	00 
  103272:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  103279:	e8 1e da ff ff       	call   100c9c <__panic>
    assert((p2 = alloc_page()) != NULL);
  10327e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103285:	e8 1b 0b 00 00       	call   103da5 <alloc_pages>
  10328a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10328d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103291:	75 24                	jne    1032b7 <basic_check+0x3c7>
  103293:	c7 44 24 0c 71 68 10 	movl   $0x106871,0xc(%esp)
  10329a:	00 
  10329b:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  1032a2:	00 
  1032a3:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
  1032aa:	00 
  1032ab:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  1032b2:	e8 e5 d9 ff ff       	call   100c9c <__panic>

    assert(alloc_page() == NULL);
  1032b7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032be:	e8 e2 0a 00 00       	call   103da5 <alloc_pages>
  1032c3:	85 c0                	test   %eax,%eax
  1032c5:	74 24                	je     1032eb <basic_check+0x3fb>
  1032c7:	c7 44 24 0c 5e 69 10 	movl   $0x10695e,0xc(%esp)
  1032ce:	00 
  1032cf:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  1032d6:	00 
  1032d7:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
  1032de:	00 
  1032df:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  1032e6:	e8 b1 d9 ff ff       	call   100c9c <__panic>

    free_page(p0);
  1032eb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1032f2:	00 
  1032f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1032f6:	89 04 24             	mov    %eax,(%esp)
  1032f9:	e8 df 0a 00 00       	call   103ddd <free_pages>
  1032fe:	c7 45 d8 50 89 11 00 	movl   $0x118950,-0x28(%ebp)
  103305:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103308:	8b 40 04             	mov    0x4(%eax),%eax
  10330b:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  10330e:	0f 94 c0             	sete   %al
  103311:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  103314:	85 c0                	test   %eax,%eax
  103316:	74 24                	je     10333c <basic_check+0x44c>
  103318:	c7 44 24 0c 80 69 10 	movl   $0x106980,0xc(%esp)
  10331f:	00 
  103320:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  103327:	00 
  103328:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  10332f:	00 
  103330:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  103337:	e8 60 d9 ff ff       	call   100c9c <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  10333c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103343:	e8 5d 0a 00 00       	call   103da5 <alloc_pages>
  103348:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10334b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10334e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103351:	74 24                	je     103377 <basic_check+0x487>
  103353:	c7 44 24 0c 98 69 10 	movl   $0x106998,0xc(%esp)
  10335a:	00 
  10335b:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  103362:	00 
  103363:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
  10336a:	00 
  10336b:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  103372:	e8 25 d9 ff ff       	call   100c9c <__panic>
    assert(alloc_page() == NULL);
  103377:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10337e:	e8 22 0a 00 00       	call   103da5 <alloc_pages>
  103383:	85 c0                	test   %eax,%eax
  103385:	74 24                	je     1033ab <basic_check+0x4bb>
  103387:	c7 44 24 0c 5e 69 10 	movl   $0x10695e,0xc(%esp)
  10338e:	00 
  10338f:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  103396:	00 
  103397:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
  10339e:	00 
  10339f:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  1033a6:	e8 f1 d8 ff ff       	call   100c9c <__panic>

    assert(nr_free == 0);
  1033ab:	a1 58 89 11 00       	mov    0x118958,%eax
  1033b0:	85 c0                	test   %eax,%eax
  1033b2:	74 24                	je     1033d8 <basic_check+0x4e8>
  1033b4:	c7 44 24 0c b1 69 10 	movl   $0x1069b1,0xc(%esp)
  1033bb:	00 
  1033bc:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  1033c3:	00 
  1033c4:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
  1033cb:	00 
  1033cc:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  1033d3:	e8 c4 d8 ff ff       	call   100c9c <__panic>
    free_list = free_list_store;
  1033d8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1033db:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1033de:	a3 50 89 11 00       	mov    %eax,0x118950
  1033e3:	89 15 54 89 11 00    	mov    %edx,0x118954
    nr_free = nr_free_store;
  1033e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033ec:	a3 58 89 11 00       	mov    %eax,0x118958

    free_page(p);
  1033f1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1033f8:	00 
  1033f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1033fc:	89 04 24             	mov    %eax,(%esp)
  1033ff:	e8 d9 09 00 00       	call   103ddd <free_pages>
    free_page(p1);
  103404:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10340b:	00 
  10340c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10340f:	89 04 24             	mov    %eax,(%esp)
  103412:	e8 c6 09 00 00       	call   103ddd <free_pages>
    free_page(p2);
  103417:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10341e:	00 
  10341f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103422:	89 04 24             	mov    %eax,(%esp)
  103425:	e8 b3 09 00 00       	call   103ddd <free_pages>
}
  10342a:	c9                   	leave  
  10342b:	c3                   	ret    

0010342c <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  10342c:	55                   	push   %ebp
  10342d:	89 e5                	mov    %esp,%ebp
  10342f:	53                   	push   %ebx
  103430:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  103436:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10343d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  103444:	c7 45 ec 50 89 11 00 	movl   $0x118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  10344b:	eb 6b                	jmp    1034b8 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  10344d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103450:	83 e8 0c             	sub    $0xc,%eax
  103453:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  103456:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103459:	83 c0 04             	add    $0x4,%eax
  10345c:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  103463:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103466:	8b 45 cc             	mov    -0x34(%ebp),%eax
  103469:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10346c:	0f a3 10             	bt     %edx,(%eax)
  10346f:	19 db                	sbb    %ebx,%ebx
  103471:	89 5d c8             	mov    %ebx,-0x38(%ebp)
    return oldbit != 0;
  103474:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  103478:	0f 95 c0             	setne  %al
  10347b:	0f b6 c0             	movzbl %al,%eax
  10347e:	85 c0                	test   %eax,%eax
  103480:	75 24                	jne    1034a6 <default_check+0x7a>
  103482:	c7 44 24 0c be 69 10 	movl   $0x1069be,0xc(%esp)
  103489:	00 
  10348a:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  103491:	00 
  103492:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
  103499:	00 
  10349a:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  1034a1:	e8 f6 d7 ff ff       	call   100c9c <__panic>
        count ++, total += p->property;
  1034a6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1034aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034ad:	8b 50 08             	mov    0x8(%eax),%edx
  1034b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034b3:	01 d0                	add    %edx,%eax
  1034b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1034b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1034bb:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  1034be:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1034c1:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  1034c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1034c7:	81 7d ec 50 89 11 00 	cmpl   $0x118950,-0x14(%ebp)
  1034ce:	0f 85 79 ff ff ff    	jne    10344d <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  1034d4:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  1034d7:	e8 33 09 00 00       	call   103e0f <nr_free_pages>
  1034dc:	39 c3                	cmp    %eax,%ebx
  1034de:	74 24                	je     103504 <default_check+0xd8>
  1034e0:	c7 44 24 0c ce 69 10 	movl   $0x1069ce,0xc(%esp)
  1034e7:	00 
  1034e8:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  1034ef:	00 
  1034f0:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
  1034f7:	00 
  1034f8:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  1034ff:	e8 98 d7 ff ff       	call   100c9c <__panic>

    basic_check();
  103504:	e8 e7 f9 ff ff       	call   102ef0 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  103509:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103510:	e8 90 08 00 00       	call   103da5 <alloc_pages>
  103515:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  103518:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10351c:	75 24                	jne    103542 <default_check+0x116>
  10351e:	c7 44 24 0c e7 69 10 	movl   $0x1069e7,0xc(%esp)
  103525:	00 
  103526:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  10352d:	00 
  10352e:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
  103535:	00 
  103536:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  10353d:	e8 5a d7 ff ff       	call   100c9c <__panic>
    assert(!PageProperty(p0));
  103542:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103545:	83 c0 04             	add    $0x4,%eax
  103548:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  10354f:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103552:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103555:	8b 55 c0             	mov    -0x40(%ebp),%edx
  103558:	0f a3 10             	bt     %edx,(%eax)
  10355b:	19 db                	sbb    %ebx,%ebx
  10355d:	89 5d b8             	mov    %ebx,-0x48(%ebp)
    return oldbit != 0;
  103560:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  103564:	0f 95 c0             	setne  %al
  103567:	0f b6 c0             	movzbl %al,%eax
  10356a:	85 c0                	test   %eax,%eax
  10356c:	74 24                	je     103592 <default_check+0x166>
  10356e:	c7 44 24 0c f2 69 10 	movl   $0x1069f2,0xc(%esp)
  103575:	00 
  103576:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  10357d:	00 
  10357e:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
  103585:	00 
  103586:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  10358d:	e8 0a d7 ff ff       	call   100c9c <__panic>

    list_entry_t free_list_store = free_list;
  103592:	a1 50 89 11 00       	mov    0x118950,%eax
  103597:	8b 15 54 89 11 00    	mov    0x118954,%edx
  10359d:	89 45 80             	mov    %eax,-0x80(%ebp)
  1035a0:	89 55 84             	mov    %edx,-0x7c(%ebp)
  1035a3:	c7 45 b4 50 89 11 00 	movl   $0x118950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1035aa:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1035ad:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1035b0:	89 50 04             	mov    %edx,0x4(%eax)
  1035b3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1035b6:	8b 50 04             	mov    0x4(%eax),%edx
  1035b9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1035bc:	89 10                	mov    %edx,(%eax)
  1035be:	c7 45 b0 50 89 11 00 	movl   $0x118950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  1035c5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1035c8:	8b 40 04             	mov    0x4(%eax),%eax
  1035cb:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  1035ce:	0f 94 c0             	sete   %al
  1035d1:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1035d4:	85 c0                	test   %eax,%eax
  1035d6:	75 24                	jne    1035fc <default_check+0x1d0>
  1035d8:	c7 44 24 0c 47 69 10 	movl   $0x106947,0xc(%esp)
  1035df:	00 
  1035e0:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  1035e7:	00 
  1035e8:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  1035ef:	00 
  1035f0:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  1035f7:	e8 a0 d6 ff ff       	call   100c9c <__panic>
    assert(alloc_page() == NULL);
  1035fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103603:	e8 9d 07 00 00       	call   103da5 <alloc_pages>
  103608:	85 c0                	test   %eax,%eax
  10360a:	74 24                	je     103630 <default_check+0x204>
  10360c:	c7 44 24 0c 5e 69 10 	movl   $0x10695e,0xc(%esp)
  103613:	00 
  103614:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  10361b:	00 
  10361c:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  103623:	00 
  103624:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  10362b:	e8 6c d6 ff ff       	call   100c9c <__panic>

    unsigned int nr_free_store = nr_free;
  103630:	a1 58 89 11 00       	mov    0x118958,%eax
  103635:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  103638:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  10363f:	00 00 00 

    free_pages(p0 + 2, 3);
  103642:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103645:	83 c0 28             	add    $0x28,%eax
  103648:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  10364f:	00 
  103650:	89 04 24             	mov    %eax,(%esp)
  103653:	e8 85 07 00 00       	call   103ddd <free_pages>
    assert(alloc_pages(4) == NULL);
  103658:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10365f:	e8 41 07 00 00       	call   103da5 <alloc_pages>
  103664:	85 c0                	test   %eax,%eax
  103666:	74 24                	je     10368c <default_check+0x260>
  103668:	c7 44 24 0c 04 6a 10 	movl   $0x106a04,0xc(%esp)
  10366f:	00 
  103670:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  103677:	00 
  103678:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  10367f:	00 
  103680:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  103687:	e8 10 d6 ff ff       	call   100c9c <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  10368c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10368f:	83 c0 28             	add    $0x28,%eax
  103692:	83 c0 04             	add    $0x4,%eax
  103695:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  10369c:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10369f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1036a2:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1036a5:	0f a3 10             	bt     %edx,(%eax)
  1036a8:	19 db                	sbb    %ebx,%ebx
  1036aa:	89 5d a4             	mov    %ebx,-0x5c(%ebp)
    return oldbit != 0;
  1036ad:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  1036b1:	0f 95 c0             	setne  %al
  1036b4:	0f b6 c0             	movzbl %al,%eax
  1036b7:	85 c0                	test   %eax,%eax
  1036b9:	74 0e                	je     1036c9 <default_check+0x29d>
  1036bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036be:	83 c0 28             	add    $0x28,%eax
  1036c1:	8b 40 08             	mov    0x8(%eax),%eax
  1036c4:	83 f8 03             	cmp    $0x3,%eax
  1036c7:	74 24                	je     1036ed <default_check+0x2c1>
  1036c9:	c7 44 24 0c 1c 6a 10 	movl   $0x106a1c,0xc(%esp)
  1036d0:	00 
  1036d1:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  1036d8:	00 
  1036d9:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
  1036e0:	00 
  1036e1:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  1036e8:	e8 af d5 ff ff       	call   100c9c <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  1036ed:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  1036f4:	e8 ac 06 00 00       	call   103da5 <alloc_pages>
  1036f9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1036fc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103700:	75 24                	jne    103726 <default_check+0x2fa>
  103702:	c7 44 24 0c 48 6a 10 	movl   $0x106a48,0xc(%esp)
  103709:	00 
  10370a:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  103711:	00 
  103712:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
  103719:	00 
  10371a:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  103721:	e8 76 d5 ff ff       	call   100c9c <__panic>
    assert(alloc_page() == NULL);
  103726:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10372d:	e8 73 06 00 00       	call   103da5 <alloc_pages>
  103732:	85 c0                	test   %eax,%eax
  103734:	74 24                	je     10375a <default_check+0x32e>
  103736:	c7 44 24 0c 5e 69 10 	movl   $0x10695e,0xc(%esp)
  10373d:	00 
  10373e:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  103745:	00 
  103746:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
  10374d:	00 
  10374e:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  103755:	e8 42 d5 ff ff       	call   100c9c <__panic>
    assert(p0 + 2 == p1);
  10375a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10375d:	83 c0 28             	add    $0x28,%eax
  103760:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103763:	74 24                	je     103789 <default_check+0x35d>
  103765:	c7 44 24 0c 66 6a 10 	movl   $0x106a66,0xc(%esp)
  10376c:	00 
  10376d:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  103774:	00 
  103775:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
  10377c:	00 
  10377d:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  103784:	e8 13 d5 ff ff       	call   100c9c <__panic>

    p2 = p0 + 1;
  103789:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10378c:	83 c0 14             	add    $0x14,%eax
  10378f:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  103792:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103799:	00 
  10379a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10379d:	89 04 24             	mov    %eax,(%esp)
  1037a0:	e8 38 06 00 00       	call   103ddd <free_pages>
    free_pages(p1, 3);
  1037a5:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1037ac:	00 
  1037ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1037b0:	89 04 24             	mov    %eax,(%esp)
  1037b3:	e8 25 06 00 00       	call   103ddd <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  1037b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1037bb:	83 c0 04             	add    $0x4,%eax
  1037be:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  1037c5:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1037c8:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1037cb:	8b 55 a0             	mov    -0x60(%ebp),%edx
  1037ce:	0f a3 10             	bt     %edx,(%eax)
  1037d1:	19 db                	sbb    %ebx,%ebx
  1037d3:	89 5d 98             	mov    %ebx,-0x68(%ebp)
    return oldbit != 0;
  1037d6:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  1037da:	0f 95 c0             	setne  %al
  1037dd:	0f b6 c0             	movzbl %al,%eax
  1037e0:	85 c0                	test   %eax,%eax
  1037e2:	74 0b                	je     1037ef <default_check+0x3c3>
  1037e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1037e7:	8b 40 08             	mov    0x8(%eax),%eax
  1037ea:	83 f8 01             	cmp    $0x1,%eax
  1037ed:	74 24                	je     103813 <default_check+0x3e7>
  1037ef:	c7 44 24 0c 74 6a 10 	movl   $0x106a74,0xc(%esp)
  1037f6:	00 
  1037f7:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  1037fe:	00 
  1037ff:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  103806:	00 
  103807:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  10380e:	e8 89 d4 ff ff       	call   100c9c <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  103813:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103816:	83 c0 04             	add    $0x4,%eax
  103819:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  103820:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103823:	8b 45 90             	mov    -0x70(%ebp),%eax
  103826:	8b 55 94             	mov    -0x6c(%ebp),%edx
  103829:	0f a3 10             	bt     %edx,(%eax)
  10382c:	19 db                	sbb    %ebx,%ebx
  10382e:	89 5d 8c             	mov    %ebx,-0x74(%ebp)
    return oldbit != 0;
  103831:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  103835:	0f 95 c0             	setne  %al
  103838:	0f b6 c0             	movzbl %al,%eax
  10383b:	85 c0                	test   %eax,%eax
  10383d:	74 0b                	je     10384a <default_check+0x41e>
  10383f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103842:	8b 40 08             	mov    0x8(%eax),%eax
  103845:	83 f8 03             	cmp    $0x3,%eax
  103848:	74 24                	je     10386e <default_check+0x442>
  10384a:	c7 44 24 0c 9c 6a 10 	movl   $0x106a9c,0xc(%esp)
  103851:	00 
  103852:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  103859:	00 
  10385a:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
  103861:	00 
  103862:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  103869:	e8 2e d4 ff ff       	call   100c9c <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  10386e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103875:	e8 2b 05 00 00       	call   103da5 <alloc_pages>
  10387a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10387d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103880:	83 e8 14             	sub    $0x14,%eax
  103883:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103886:	74 24                	je     1038ac <default_check+0x480>
  103888:	c7 44 24 0c c2 6a 10 	movl   $0x106ac2,0xc(%esp)
  10388f:	00 
  103890:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  103897:	00 
  103898:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
  10389f:	00 
  1038a0:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  1038a7:	e8 f0 d3 ff ff       	call   100c9c <__panic>
    free_page(p0);
  1038ac:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1038b3:	00 
  1038b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1038b7:	89 04 24             	mov    %eax,(%esp)
  1038ba:	e8 1e 05 00 00       	call   103ddd <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  1038bf:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1038c6:	e8 da 04 00 00       	call   103da5 <alloc_pages>
  1038cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1038ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1038d1:	83 c0 14             	add    $0x14,%eax
  1038d4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1038d7:	74 24                	je     1038fd <default_check+0x4d1>
  1038d9:	c7 44 24 0c e0 6a 10 	movl   $0x106ae0,0xc(%esp)
  1038e0:	00 
  1038e1:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  1038e8:	00 
  1038e9:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
  1038f0:	00 
  1038f1:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  1038f8:	e8 9f d3 ff ff       	call   100c9c <__panic>

    free_pages(p0, 2);
  1038fd:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  103904:	00 
  103905:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103908:	89 04 24             	mov    %eax,(%esp)
  10390b:	e8 cd 04 00 00       	call   103ddd <free_pages>
    free_page(p2);
  103910:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103917:	00 
  103918:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10391b:	89 04 24             	mov    %eax,(%esp)
  10391e:	e8 ba 04 00 00       	call   103ddd <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  103923:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  10392a:	e8 76 04 00 00       	call   103da5 <alloc_pages>
  10392f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103932:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103936:	75 24                	jne    10395c <default_check+0x530>
  103938:	c7 44 24 0c 00 6b 10 	movl   $0x106b00,0xc(%esp)
  10393f:	00 
  103940:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  103947:	00 
  103948:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
  10394f:	00 
  103950:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  103957:	e8 40 d3 ff ff       	call   100c9c <__panic>
    assert(alloc_page() == NULL);
  10395c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103963:	e8 3d 04 00 00       	call   103da5 <alloc_pages>
  103968:	85 c0                	test   %eax,%eax
  10396a:	74 24                	je     103990 <default_check+0x564>
  10396c:	c7 44 24 0c 5e 69 10 	movl   $0x10695e,0xc(%esp)
  103973:	00 
  103974:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  10397b:	00 
  10397c:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
  103983:	00 
  103984:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  10398b:	e8 0c d3 ff ff       	call   100c9c <__panic>

    assert(nr_free == 0);
  103990:	a1 58 89 11 00       	mov    0x118958,%eax
  103995:	85 c0                	test   %eax,%eax
  103997:	74 24                	je     1039bd <default_check+0x591>
  103999:	c7 44 24 0c b1 69 10 	movl   $0x1069b1,0xc(%esp)
  1039a0:	00 
  1039a1:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  1039a8:	00 
  1039a9:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
  1039b0:	00 
  1039b1:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  1039b8:	e8 df d2 ff ff       	call   100c9c <__panic>
    nr_free = nr_free_store;
  1039bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1039c0:	a3 58 89 11 00       	mov    %eax,0x118958

    free_list = free_list_store;
  1039c5:	8b 45 80             	mov    -0x80(%ebp),%eax
  1039c8:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1039cb:	a3 50 89 11 00       	mov    %eax,0x118950
  1039d0:	89 15 54 89 11 00    	mov    %edx,0x118954
    free_pages(p0, 5);
  1039d6:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  1039dd:	00 
  1039de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1039e1:	89 04 24             	mov    %eax,(%esp)
  1039e4:	e8 f4 03 00 00       	call   103ddd <free_pages>

    le = &free_list;
  1039e9:	c7 45 ec 50 89 11 00 	movl   $0x118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1039f0:	eb 1f                	jmp    103a11 <default_check+0x5e5>
        struct Page *p = le2page(le, page_link);
  1039f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1039f5:	83 e8 0c             	sub    $0xc,%eax
  1039f8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  1039fb:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1039ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103a02:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103a05:	8b 40 08             	mov    0x8(%eax),%eax
  103a08:	89 d1                	mov    %edx,%ecx
  103a0a:	29 c1                	sub    %eax,%ecx
  103a0c:	89 c8                	mov    %ecx,%eax
  103a0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103a11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103a14:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103a17:	8b 45 88             	mov    -0x78(%ebp),%eax
  103a1a:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  103a1d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103a20:	81 7d ec 50 89 11 00 	cmpl   $0x118950,-0x14(%ebp)
  103a27:	75 c9                	jne    1039f2 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  103a29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103a2d:	74 24                	je     103a53 <default_check+0x627>
  103a2f:	c7 44 24 0c 1e 6b 10 	movl   $0x106b1e,0xc(%esp)
  103a36:	00 
  103a37:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  103a3e:	00 
  103a3f:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  103a46:	00 
  103a47:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  103a4e:	e8 49 d2 ff ff       	call   100c9c <__panic>
    assert(total == 0);
  103a53:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103a57:	74 24                	je     103a7d <default_check+0x651>
  103a59:	c7 44 24 0c 29 6b 10 	movl   $0x106b29,0xc(%esp)
  103a60:	00 
  103a61:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  103a68:	00 
  103a69:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  103a70:	00 
  103a71:	c7 04 24 eb 67 10 00 	movl   $0x1067eb,(%esp)
  103a78:	e8 1f d2 ff ff       	call   100c9c <__panic>
}
  103a7d:	81 c4 94 00 00 00    	add    $0x94,%esp
  103a83:	5b                   	pop    %ebx
  103a84:	5d                   	pop    %ebp
  103a85:	c3                   	ret    
	...

00103a88 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  103a88:	55                   	push   %ebp
  103a89:	89 e5                	mov    %esp,%ebp
    return page - pages;
  103a8b:	8b 55 08             	mov    0x8(%ebp),%edx
  103a8e:	a1 64 89 11 00       	mov    0x118964,%eax
  103a93:	89 d1                	mov    %edx,%ecx
  103a95:	29 c1                	sub    %eax,%ecx
  103a97:	89 c8                	mov    %ecx,%eax
  103a99:	c1 f8 02             	sar    $0x2,%eax
  103a9c:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  103aa2:	5d                   	pop    %ebp
  103aa3:	c3                   	ret    

00103aa4 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  103aa4:	55                   	push   %ebp
  103aa5:	89 e5                	mov    %esp,%ebp
  103aa7:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  103aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  103aad:	89 04 24             	mov    %eax,(%esp)
  103ab0:	e8 d3 ff ff ff       	call   103a88 <page2ppn>
  103ab5:	c1 e0 0c             	shl    $0xc,%eax
}
  103ab8:	c9                   	leave  
  103ab9:	c3                   	ret    

00103aba <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  103aba:	55                   	push   %ebp
  103abb:	89 e5                	mov    %esp,%ebp
  103abd:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  103ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  103ac3:	89 c2                	mov    %eax,%edx
  103ac5:	c1 ea 0c             	shr    $0xc,%edx
  103ac8:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103acd:	39 c2                	cmp    %eax,%edx
  103acf:	72 1c                	jb     103aed <pa2page+0x33>
        panic("pa2page called with invalid pa");
  103ad1:	c7 44 24 08 64 6b 10 	movl   $0x106b64,0x8(%esp)
  103ad8:	00 
  103ad9:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  103ae0:	00 
  103ae1:	c7 04 24 83 6b 10 00 	movl   $0x106b83,(%esp)
  103ae8:	e8 af d1 ff ff       	call   100c9c <__panic>
    }
    return &pages[PPN(pa)];
  103aed:	8b 0d 64 89 11 00    	mov    0x118964,%ecx
  103af3:	8b 45 08             	mov    0x8(%ebp),%eax
  103af6:	89 c2                	mov    %eax,%edx
  103af8:	c1 ea 0c             	shr    $0xc,%edx
  103afb:	89 d0                	mov    %edx,%eax
  103afd:	c1 e0 02             	shl    $0x2,%eax
  103b00:	01 d0                	add    %edx,%eax
  103b02:	c1 e0 02             	shl    $0x2,%eax
  103b05:	01 c8                	add    %ecx,%eax
}
  103b07:	c9                   	leave  
  103b08:	c3                   	ret    

00103b09 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  103b09:	55                   	push   %ebp
  103b0a:	89 e5                	mov    %esp,%ebp
  103b0c:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  103b12:	89 04 24             	mov    %eax,(%esp)
  103b15:	e8 8a ff ff ff       	call   103aa4 <page2pa>
  103b1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b20:	c1 e8 0c             	shr    $0xc,%eax
  103b23:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103b26:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103b2b:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103b2e:	72 23                	jb     103b53 <page2kva+0x4a>
  103b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b33:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103b37:	c7 44 24 08 94 6b 10 	movl   $0x106b94,0x8(%esp)
  103b3e:	00 
  103b3f:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103b46:	00 
  103b47:	c7 04 24 83 6b 10 00 	movl   $0x106b83,(%esp)
  103b4e:	e8 49 d1 ff ff       	call   100c9c <__panic>
  103b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b56:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103b5b:	c9                   	leave  
  103b5c:	c3                   	ret    

00103b5d <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  103b5d:	55                   	push   %ebp
  103b5e:	89 e5                	mov    %esp,%ebp
  103b60:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103b63:	8b 45 08             	mov    0x8(%ebp),%eax
  103b66:	83 e0 01             	and    $0x1,%eax
  103b69:	85 c0                	test   %eax,%eax
  103b6b:	75 1c                	jne    103b89 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103b6d:	c7 44 24 08 b8 6b 10 	movl   $0x106bb8,0x8(%esp)
  103b74:	00 
  103b75:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103b7c:	00 
  103b7d:	c7 04 24 83 6b 10 00 	movl   $0x106b83,(%esp)
  103b84:	e8 13 d1 ff ff       	call   100c9c <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  103b89:	8b 45 08             	mov    0x8(%ebp),%eax
  103b8c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103b91:	89 04 24             	mov    %eax,(%esp)
  103b94:	e8 21 ff ff ff       	call   103aba <pa2page>
}
  103b99:	c9                   	leave  
  103b9a:	c3                   	ret    

00103b9b <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  103b9b:	55                   	push   %ebp
  103b9c:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  103ba1:	8b 00                	mov    (%eax),%eax
}
  103ba3:	5d                   	pop    %ebp
  103ba4:	c3                   	ret    

00103ba5 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  103ba5:	55                   	push   %ebp
  103ba6:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  103ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  103bab:	8b 55 0c             	mov    0xc(%ebp),%edx
  103bae:	89 10                	mov    %edx,(%eax)
}
  103bb0:	5d                   	pop    %ebp
  103bb1:	c3                   	ret    

00103bb2 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  103bb2:	55                   	push   %ebp
  103bb3:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  103bb8:	8b 00                	mov    (%eax),%eax
  103bba:	8d 50 01             	lea    0x1(%eax),%edx
  103bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  103bc0:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  103bc5:	8b 00                	mov    (%eax),%eax
}
  103bc7:	5d                   	pop    %ebp
  103bc8:	c3                   	ret    

00103bc9 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103bc9:	55                   	push   %ebp
  103bca:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  103bcf:	8b 00                	mov    (%eax),%eax
  103bd1:	8d 50 ff             	lea    -0x1(%eax),%edx
  103bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  103bd7:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  103bdc:	8b 00                	mov    (%eax),%eax
}
  103bde:	5d                   	pop    %ebp
  103bdf:	c3                   	ret    

00103be0 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  103be0:	55                   	push   %ebp
  103be1:	89 e5                	mov    %esp,%ebp
  103be3:	53                   	push   %ebx
  103be4:	83 ec 14             	sub    $0x14,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103be7:	9c                   	pushf  
  103be8:	5b                   	pop    %ebx
  103be9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return eflags;
  103bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103bef:	25 00 02 00 00       	and    $0x200,%eax
  103bf4:	85 c0                	test   %eax,%eax
  103bf6:	74 0c                	je     103c04 <__intr_save+0x24>
        intr_disable();
  103bf8:	e8 31 db ff ff       	call   10172e <intr_disable>
        return 1;
  103bfd:	b8 01 00 00 00       	mov    $0x1,%eax
  103c02:	eb 05                	jmp    103c09 <__intr_save+0x29>
    }
    return 0;
  103c04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103c09:	83 c4 14             	add    $0x14,%esp
  103c0c:	5b                   	pop    %ebx
  103c0d:	5d                   	pop    %ebp
  103c0e:	c3                   	ret    

00103c0f <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  103c0f:	55                   	push   %ebp
  103c10:	89 e5                	mov    %esp,%ebp
  103c12:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103c15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103c19:	74 05                	je     103c20 <__intr_restore+0x11>
        intr_enable();
  103c1b:	e8 08 db ff ff       	call   101728 <intr_enable>
    }
}
  103c20:	c9                   	leave  
  103c21:	c3                   	ret    

00103c22 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103c22:	55                   	push   %ebp
  103c23:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103c25:	8b 45 08             	mov    0x8(%ebp),%eax
  103c28:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103c2b:	b8 23 00 00 00       	mov    $0x23,%eax
  103c30:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103c32:	b8 23 00 00 00       	mov    $0x23,%eax
  103c37:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103c39:	b8 10 00 00 00       	mov    $0x10,%eax
  103c3e:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103c40:	b8 10 00 00 00       	mov    $0x10,%eax
  103c45:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103c47:	b8 10 00 00 00       	mov    $0x10,%eax
  103c4c:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103c4e:	ea 55 3c 10 00 08 00 	ljmp   $0x8,$0x103c55
}
  103c55:	5d                   	pop    %ebp
  103c56:	c3                   	ret    

00103c57 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103c57:	55                   	push   %ebp
  103c58:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  103c5d:	a3 e4 88 11 00       	mov    %eax,0x1188e4
}
  103c62:	5d                   	pop    %ebp
  103c63:	c3                   	ret    

00103c64 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103c64:	55                   	push   %ebp
  103c65:	89 e5                	mov    %esp,%ebp
  103c67:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103c6a:	b8 00 70 11 00       	mov    $0x117000,%eax
  103c6f:	89 04 24             	mov    %eax,(%esp)
  103c72:	e8 e0 ff ff ff       	call   103c57 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103c77:	66 c7 05 e8 88 11 00 	movw   $0x10,0x1188e8
  103c7e:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103c80:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  103c87:	68 00 
  103c89:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103c8e:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  103c94:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103c99:	c1 e8 10             	shr    $0x10,%eax
  103c9c:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  103ca1:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103ca8:	83 e0 f0             	and    $0xfffffff0,%eax
  103cab:	83 c8 09             	or     $0x9,%eax
  103cae:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103cb3:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103cba:	83 e0 ef             	and    $0xffffffef,%eax
  103cbd:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103cc2:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103cc9:	83 e0 9f             	and    $0xffffff9f,%eax
  103ccc:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103cd1:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103cd8:	83 c8 80             	or     $0xffffff80,%eax
  103cdb:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103ce0:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103ce7:	83 e0 f0             	and    $0xfffffff0,%eax
  103cea:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103cef:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103cf6:	83 e0 ef             	and    $0xffffffef,%eax
  103cf9:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103cfe:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103d05:	83 e0 df             	and    $0xffffffdf,%eax
  103d08:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103d0d:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103d14:	83 c8 40             	or     $0x40,%eax
  103d17:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103d1c:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103d23:	83 e0 7f             	and    $0x7f,%eax
  103d26:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103d2b:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103d30:	c1 e8 18             	shr    $0x18,%eax
  103d33:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103d38:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  103d3f:	e8 de fe ff ff       	call   103c22 <lgdt>
  103d44:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103d4a:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103d4e:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  103d51:	c9                   	leave  
  103d52:	c3                   	ret    

00103d53 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103d53:	55                   	push   %ebp
  103d54:	89 e5                	mov    %esp,%ebp
  103d56:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103d59:	c7 05 5c 89 11 00 48 	movl   $0x106b48,0x11895c
  103d60:	6b 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103d63:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103d68:	8b 00                	mov    (%eax),%eax
  103d6a:	89 44 24 04          	mov    %eax,0x4(%esp)
  103d6e:	c7 04 24 e4 6b 10 00 	movl   $0x106be4,(%esp)
  103d75:	e8 cd c5 ff ff       	call   100347 <cprintf>
    pmm_manager->init();
  103d7a:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103d7f:	8b 40 04             	mov    0x4(%eax),%eax
  103d82:	ff d0                	call   *%eax
}
  103d84:	c9                   	leave  
  103d85:	c3                   	ret    

00103d86 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103d86:	55                   	push   %ebp
  103d87:	89 e5                	mov    %esp,%ebp
  103d89:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103d8c:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103d91:	8b 50 08             	mov    0x8(%eax),%edx
  103d94:	8b 45 0c             	mov    0xc(%ebp),%eax
  103d97:	89 44 24 04          	mov    %eax,0x4(%esp)
  103d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  103d9e:	89 04 24             	mov    %eax,(%esp)
  103da1:	ff d2                	call   *%edx
}
  103da3:	c9                   	leave  
  103da4:	c3                   	ret    

00103da5 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103da5:	55                   	push   %ebp
  103da6:	89 e5                	mov    %esp,%ebp
  103da8:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103dab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103db2:	e8 29 fe ff ff       	call   103be0 <__intr_save>
  103db7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103dba:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103dbf:	8b 50 0c             	mov    0xc(%eax),%edx
  103dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  103dc5:	89 04 24             	mov    %eax,(%esp)
  103dc8:	ff d2                	call   *%edx
  103dca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103dd0:	89 04 24             	mov    %eax,(%esp)
  103dd3:	e8 37 fe ff ff       	call   103c0f <__intr_restore>
    return page;
  103dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103ddb:	c9                   	leave  
  103ddc:	c3                   	ret    

00103ddd <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103ddd:	55                   	push   %ebp
  103dde:	89 e5                	mov    %esp,%ebp
  103de0:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103de3:	e8 f8 fd ff ff       	call   103be0 <__intr_save>
  103de8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103deb:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103df0:	8b 50 10             	mov    0x10(%eax),%edx
  103df3:	8b 45 0c             	mov    0xc(%ebp),%eax
  103df6:	89 44 24 04          	mov    %eax,0x4(%esp)
  103dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  103dfd:	89 04 24             	mov    %eax,(%esp)
  103e00:	ff d2                	call   *%edx
    }
    local_intr_restore(intr_flag);
  103e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103e05:	89 04 24             	mov    %eax,(%esp)
  103e08:	e8 02 fe ff ff       	call   103c0f <__intr_restore>
}
  103e0d:	c9                   	leave  
  103e0e:	c3                   	ret    

00103e0f <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103e0f:	55                   	push   %ebp
  103e10:	89 e5                	mov    %esp,%ebp
  103e12:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103e15:	e8 c6 fd ff ff       	call   103be0 <__intr_save>
  103e1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103e1d:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103e22:	8b 40 14             	mov    0x14(%eax),%eax
  103e25:	ff d0                	call   *%eax
  103e27:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103e2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103e2d:	89 04 24             	mov    %eax,(%esp)
  103e30:	e8 da fd ff ff       	call   103c0f <__intr_restore>
    return ret;
  103e35:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103e38:	c9                   	leave  
  103e39:	c3                   	ret    

00103e3a <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  103e3a:	55                   	push   %ebp
  103e3b:	89 e5                	mov    %esp,%ebp
  103e3d:	57                   	push   %edi
  103e3e:	56                   	push   %esi
  103e3f:	53                   	push   %ebx
  103e40:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  103e46:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  103e4d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103e54:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  103e5b:	c7 04 24 fb 6b 10 00 	movl   $0x106bfb,(%esp)
  103e62:	e8 e0 c4 ff ff       	call   100347 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103e67:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103e6e:	e9 0b 01 00 00       	jmp    103f7e <page_init+0x144>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103e73:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e76:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e79:	89 d0                	mov    %edx,%eax
  103e7b:	c1 e0 02             	shl    $0x2,%eax
  103e7e:	01 d0                	add    %edx,%eax
  103e80:	c1 e0 02             	shl    $0x2,%eax
  103e83:	01 c8                	add    %ecx,%eax
  103e85:	8b 50 08             	mov    0x8(%eax),%edx
  103e88:	8b 40 04             	mov    0x4(%eax),%eax
  103e8b:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103e8e:	89 55 bc             	mov    %edx,-0x44(%ebp)
  103e91:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e94:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e97:	89 d0                	mov    %edx,%eax
  103e99:	c1 e0 02             	shl    $0x2,%eax
  103e9c:	01 d0                	add    %edx,%eax
  103e9e:	c1 e0 02             	shl    $0x2,%eax
  103ea1:	01 c8                	add    %ecx,%eax
  103ea3:	8b 50 10             	mov    0x10(%eax),%edx
  103ea6:	8b 40 0c             	mov    0xc(%eax),%eax
  103ea9:	03 45 b8             	add    -0x48(%ebp),%eax
  103eac:	13 55 bc             	adc    -0x44(%ebp),%edx
  103eaf:	89 45 b0             	mov    %eax,-0x50(%ebp)
  103eb2:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
  103eb5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  103eb8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103ebb:	89 d0                	mov    %edx,%eax
  103ebd:	c1 e0 02             	shl    $0x2,%eax
  103ec0:	01 d0                	add    %edx,%eax
  103ec2:	c1 e0 02             	shl    $0x2,%eax
  103ec5:	01 c8                	add    %ecx,%eax
  103ec7:	83 c0 14             	add    $0x14,%eax
  103eca:	8b 00                	mov    (%eax),%eax
  103ecc:	89 45 84             	mov    %eax,-0x7c(%ebp)
  103ecf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103ed2:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103ed5:	89 c6                	mov    %eax,%esi
  103ed7:	89 d7                	mov    %edx,%edi
  103ed9:	83 c6 ff             	add    $0xffffffff,%esi
  103edc:	83 d7 ff             	adc    $0xffffffff,%edi
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
  103edf:	8b 4d c4             	mov    -0x3c(%ebp),%ecx

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  103ee2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103ee5:	89 d0                	mov    %edx,%eax
  103ee7:	c1 e0 02             	shl    $0x2,%eax
  103eea:	01 d0                	add    %edx,%eax
  103eec:	c1 e0 02             	shl    $0x2,%eax
  103eef:	01 c8                	add    %ecx,%eax
  103ef1:	8b 48 0c             	mov    0xc(%eax),%ecx
  103ef4:	8b 58 10             	mov    0x10(%eax),%ebx
  103ef7:	8b 45 84             	mov    -0x7c(%ebp),%eax
  103efa:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  103efe:	89 74 24 14          	mov    %esi,0x14(%esp)
  103f02:	89 7c 24 18          	mov    %edi,0x18(%esp)
  103f06:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103f09:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103f0c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103f10:	89 54 24 10          	mov    %edx,0x10(%esp)
  103f14:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103f18:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103f1c:	c7 04 24 08 6c 10 00 	movl   $0x106c08,(%esp)
  103f23:	e8 1f c4 ff ff       	call   100347 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  103f28:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103f2b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f2e:	89 d0                	mov    %edx,%eax
  103f30:	c1 e0 02             	shl    $0x2,%eax
  103f33:	01 d0                	add    %edx,%eax
  103f35:	c1 e0 02             	shl    $0x2,%eax
  103f38:	01 c8                	add    %ecx,%eax
  103f3a:	83 c0 14             	add    $0x14,%eax
  103f3d:	8b 00                	mov    (%eax),%eax
  103f3f:	83 f8 01             	cmp    $0x1,%eax
  103f42:	75 36                	jne    103f7a <page_init+0x140>
            if (maxpa < end && begin < KMEMSIZE) {
  103f44:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103f47:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103f4a:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103f4d:	77 2b                	ja     103f7a <page_init+0x140>
  103f4f:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103f52:	72 05                	jb     103f59 <page_init+0x11f>
  103f54:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  103f57:	73 21                	jae    103f7a <page_init+0x140>
  103f59:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103f5d:	77 1b                	ja     103f7a <page_init+0x140>
  103f5f:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103f63:	72 09                	jb     103f6e <page_init+0x134>
  103f65:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  103f6c:	77 0c                	ja     103f7a <page_init+0x140>
                maxpa = end;
  103f6e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103f71:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103f74:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103f77:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103f7a:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103f7e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103f81:	8b 00                	mov    (%eax),%eax
  103f83:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103f86:	0f 8f e7 fe ff ff    	jg     103e73 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  103f8c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103f90:	72 1d                	jb     103faf <page_init+0x175>
  103f92:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103f96:	77 09                	ja     103fa1 <page_init+0x167>
  103f98:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  103f9f:	76 0e                	jbe    103faf <page_init+0x175>
        maxpa = KMEMSIZE;
  103fa1:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  103fa8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  103faf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103fb2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103fb5:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103fb9:	c1 ea 0c             	shr    $0xc,%edx
  103fbc:	a3 c0 88 11 00       	mov    %eax,0x1188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  103fc1:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  103fc8:	b8 68 89 11 00       	mov    $0x118968,%eax
  103fcd:	83 e8 01             	sub    $0x1,%eax
  103fd0:	03 45 ac             	add    -0x54(%ebp),%eax
  103fd3:	89 45 a8             	mov    %eax,-0x58(%ebp)
  103fd6:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103fd9:	ba 00 00 00 00       	mov    $0x0,%edx
  103fde:	f7 75 ac             	divl   -0x54(%ebp)
  103fe1:	89 d0                	mov    %edx,%eax
  103fe3:	8b 55 a8             	mov    -0x58(%ebp),%edx
  103fe6:	89 d1                	mov    %edx,%ecx
  103fe8:	29 c1                	sub    %eax,%ecx
  103fea:	89 c8                	mov    %ecx,%eax
  103fec:	a3 64 89 11 00       	mov    %eax,0x118964

    for (i = 0; i < npage; i ++) {
  103ff1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103ff8:	eb 2f                	jmp    104029 <page_init+0x1ef>
        SetPageReserved(pages + i);
  103ffa:	8b 0d 64 89 11 00    	mov    0x118964,%ecx
  104000:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104003:	89 d0                	mov    %edx,%eax
  104005:	c1 e0 02             	shl    $0x2,%eax
  104008:	01 d0                	add    %edx,%eax
  10400a:	c1 e0 02             	shl    $0x2,%eax
  10400d:	01 c8                	add    %ecx,%eax
  10400f:	83 c0 04             	add    $0x4,%eax
  104012:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  104019:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10401c:	8b 45 8c             	mov    -0x74(%ebp),%eax
  10401f:	8b 55 90             	mov    -0x70(%ebp),%edx
  104022:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  104025:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  104029:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10402c:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104031:	39 c2                	cmp    %eax,%edx
  104033:	72 c5                	jb     103ffa <page_init+0x1c0>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  104035:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  10403b:	89 d0                	mov    %edx,%eax
  10403d:	c1 e0 02             	shl    $0x2,%eax
  104040:	01 d0                	add    %edx,%eax
  104042:	c1 e0 02             	shl    $0x2,%eax
  104045:	89 c2                	mov    %eax,%edx
  104047:	a1 64 89 11 00       	mov    0x118964,%eax
  10404c:	01 d0                	add    %edx,%eax
  10404e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  104051:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  104058:	77 23                	ja     10407d <page_init+0x243>
  10405a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  10405d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104061:	c7 44 24 08 38 6c 10 	movl   $0x106c38,0x8(%esp)
  104068:	00 
  104069:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  104070:	00 
  104071:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  104078:	e8 1f cc ff ff       	call   100c9c <__panic>
  10407d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104080:	05 00 00 00 40       	add    $0x40000000,%eax
  104085:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  104088:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10408f:	e9 7c 01 00 00       	jmp    104210 <page_init+0x3d6>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  104094:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104097:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10409a:	89 d0                	mov    %edx,%eax
  10409c:	c1 e0 02             	shl    $0x2,%eax
  10409f:	01 d0                	add    %edx,%eax
  1040a1:	c1 e0 02             	shl    $0x2,%eax
  1040a4:	01 c8                	add    %ecx,%eax
  1040a6:	8b 50 08             	mov    0x8(%eax),%edx
  1040a9:	8b 40 04             	mov    0x4(%eax),%eax
  1040ac:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1040af:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1040b2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1040b5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1040b8:	89 d0                	mov    %edx,%eax
  1040ba:	c1 e0 02             	shl    $0x2,%eax
  1040bd:	01 d0                	add    %edx,%eax
  1040bf:	c1 e0 02             	shl    $0x2,%eax
  1040c2:	01 c8                	add    %ecx,%eax
  1040c4:	8b 50 10             	mov    0x10(%eax),%edx
  1040c7:	8b 40 0c             	mov    0xc(%eax),%eax
  1040ca:	03 45 d0             	add    -0x30(%ebp),%eax
  1040cd:	13 55 d4             	adc    -0x2c(%ebp),%edx
  1040d0:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1040d3:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  1040d6:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1040d9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1040dc:	89 d0                	mov    %edx,%eax
  1040de:	c1 e0 02             	shl    $0x2,%eax
  1040e1:	01 d0                	add    %edx,%eax
  1040e3:	c1 e0 02             	shl    $0x2,%eax
  1040e6:	01 c8                	add    %ecx,%eax
  1040e8:	83 c0 14             	add    $0x14,%eax
  1040eb:	8b 00                	mov    (%eax),%eax
  1040ed:	83 f8 01             	cmp    $0x1,%eax
  1040f0:	0f 85 16 01 00 00    	jne    10420c <page_init+0x3d2>
            if (begin < freemem) {
  1040f6:	8b 45 a0             	mov    -0x60(%ebp),%eax
  1040f9:	ba 00 00 00 00       	mov    $0x0,%edx
  1040fe:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  104101:	72 17                	jb     10411a <page_init+0x2e0>
  104103:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  104106:	77 05                	ja     10410d <page_init+0x2d3>
  104108:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  10410b:	76 0d                	jbe    10411a <page_init+0x2e0>
                begin = freemem;
  10410d:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104110:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104113:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  10411a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  10411e:	72 1d                	jb     10413d <page_init+0x303>
  104120:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  104124:	77 09                	ja     10412f <page_init+0x2f5>
  104126:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  10412d:	76 0e                	jbe    10413d <page_init+0x303>
                end = KMEMSIZE;
  10412f:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  104136:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  10413d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104140:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104143:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104146:	0f 87 c0 00 00 00    	ja     10420c <page_init+0x3d2>
  10414c:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10414f:	72 09                	jb     10415a <page_init+0x320>
  104151:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  104154:	0f 83 b2 00 00 00    	jae    10420c <page_init+0x3d2>
                begin = ROUNDUP(begin, PGSIZE);
  10415a:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  104161:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104164:	03 45 9c             	add    -0x64(%ebp),%eax
  104167:	83 e8 01             	sub    $0x1,%eax
  10416a:	89 45 98             	mov    %eax,-0x68(%ebp)
  10416d:	8b 45 98             	mov    -0x68(%ebp),%eax
  104170:	ba 00 00 00 00       	mov    $0x0,%edx
  104175:	f7 75 9c             	divl   -0x64(%ebp)
  104178:	89 d0                	mov    %edx,%eax
  10417a:	8b 55 98             	mov    -0x68(%ebp),%edx
  10417d:	89 d1                	mov    %edx,%ecx
  10417f:	29 c1                	sub    %eax,%ecx
  104181:	89 c8                	mov    %ecx,%eax
  104183:	ba 00 00 00 00       	mov    $0x0,%edx
  104188:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10418b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  10418e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104191:	89 45 94             	mov    %eax,-0x6c(%ebp)
  104194:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104197:	ba 00 00 00 00       	mov    $0x0,%edx
  10419c:	89 c1                	mov    %eax,%ecx
  10419e:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  1041a4:	89 8d 78 ff ff ff    	mov    %ecx,-0x88(%ebp)
  1041aa:	89 d1                	mov    %edx,%ecx
  1041ac:	83 e1 00             	and    $0x0,%ecx
  1041af:	89 8d 7c ff ff ff    	mov    %ecx,-0x84(%ebp)
  1041b5:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  1041bb:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  1041c1:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1041c4:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  1041c7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1041ca:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1041cd:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1041d0:	77 3a                	ja     10420c <page_init+0x3d2>
  1041d2:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1041d5:	72 05                	jb     1041dc <page_init+0x3a2>
  1041d7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1041da:	73 30                	jae    10420c <page_init+0x3d2>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  1041dc:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  1041df:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  1041e2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1041e5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1041e8:	29 c8                	sub    %ecx,%eax
  1041ea:	19 da                	sbb    %ebx,%edx
  1041ec:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  1041f0:	c1 ea 0c             	shr    $0xc,%edx
  1041f3:	89 c3                	mov    %eax,%ebx
  1041f5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1041f8:	89 04 24             	mov    %eax,(%esp)
  1041fb:	e8 ba f8 ff ff       	call   103aba <pa2page>
  104200:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104204:	89 04 24             	mov    %eax,(%esp)
  104207:	e8 7a fb ff ff       	call   103d86 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  10420c:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  104210:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104213:	8b 00                	mov    (%eax),%eax
  104215:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  104218:	0f 8f 76 fe ff ff    	jg     104094 <page_init+0x25a>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  10421e:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  104224:	5b                   	pop    %ebx
  104225:	5e                   	pop    %esi
  104226:	5f                   	pop    %edi
  104227:	5d                   	pop    %ebp
  104228:	c3                   	ret    

00104229 <enable_paging>:

static void
enable_paging(void) {
  104229:	55                   	push   %ebp
  10422a:	89 e5                	mov    %esp,%ebp
  10422c:	53                   	push   %ebx
  10422d:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  104230:	a1 60 89 11 00       	mov    0x118960,%eax
  104235:	89 45 f4             	mov    %eax,-0xc(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  104238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10423b:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  10423e:	0f 20 c3             	mov    %cr0,%ebx
  104241:	89 5d f0             	mov    %ebx,-0x10(%ebp)
    return cr0;
  104244:	8b 45 f0             	mov    -0x10(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  104247:	89 45 f8             	mov    %eax,-0x8(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  10424a:	81 4d f8 2f 00 05 80 	orl    $0x8005002f,-0x8(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  104251:	83 65 f8 f3          	andl   $0xfffffff3,-0x8(%ebp)
  104255:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104258:	89 45 ec             	mov    %eax,-0x14(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  10425b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10425e:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  104261:	83 c4 10             	add    $0x10,%esp
  104264:	5b                   	pop    %ebx
  104265:	5d                   	pop    %ebp
  104266:	c3                   	ret    

00104267 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  104267:	55                   	push   %ebp
  104268:	89 e5                	mov    %esp,%ebp
  10426a:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  10426d:	8b 45 14             	mov    0x14(%ebp),%eax
  104270:	8b 55 0c             	mov    0xc(%ebp),%edx
  104273:	31 d0                	xor    %edx,%eax
  104275:	25 ff 0f 00 00       	and    $0xfff,%eax
  10427a:	85 c0                	test   %eax,%eax
  10427c:	74 24                	je     1042a2 <boot_map_segment+0x3b>
  10427e:	c7 44 24 0c 6a 6c 10 	movl   $0x106c6a,0xc(%esp)
  104285:	00 
  104286:	c7 44 24 08 81 6c 10 	movl   $0x106c81,0x8(%esp)
  10428d:	00 
  10428e:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  104295:	00 
  104296:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  10429d:	e8 fa c9 ff ff       	call   100c9c <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  1042a2:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  1042a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1042ac:	25 ff 0f 00 00       	and    $0xfff,%eax
  1042b1:	03 45 10             	add    0x10(%ebp),%eax
  1042b4:	03 45 f0             	add    -0x10(%ebp),%eax
  1042b7:	83 e8 01             	sub    $0x1,%eax
  1042ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1042bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1042c0:	ba 00 00 00 00       	mov    $0x0,%edx
  1042c5:	f7 75 f0             	divl   -0x10(%ebp)
  1042c8:	89 d0                	mov    %edx,%eax
  1042ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1042cd:	89 d1                	mov    %edx,%ecx
  1042cf:	29 c1                	sub    %eax,%ecx
  1042d1:	89 c8                	mov    %ecx,%eax
  1042d3:	c1 e8 0c             	shr    $0xc,%eax
  1042d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  1042d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1042dc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1042df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1042e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1042e7:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  1042ea:	8b 45 14             	mov    0x14(%ebp),%eax
  1042ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1042f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1042f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1042f8:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1042fb:	eb 6b                	jmp    104368 <boot_map_segment+0x101>
        pte_t *ptep = get_pte(pgdir, la, 1);
  1042fd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104304:	00 
  104305:	8b 45 0c             	mov    0xc(%ebp),%eax
  104308:	89 44 24 04          	mov    %eax,0x4(%esp)
  10430c:	8b 45 08             	mov    0x8(%ebp),%eax
  10430f:	89 04 24             	mov    %eax,(%esp)
  104312:	e8 cc 01 00 00       	call   1044e3 <get_pte>
  104317:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  10431a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10431e:	75 24                	jne    104344 <boot_map_segment+0xdd>
  104320:	c7 44 24 0c 96 6c 10 	movl   $0x106c96,0xc(%esp)
  104327:	00 
  104328:	c7 44 24 08 81 6c 10 	movl   $0x106c81,0x8(%esp)
  10432f:	00 
  104330:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  104337:	00 
  104338:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  10433f:	e8 58 c9 ff ff       	call   100c9c <__panic>
        *ptep = pa | PTE_P | perm;
  104344:	8b 45 18             	mov    0x18(%ebp),%eax
  104347:	8b 55 14             	mov    0x14(%ebp),%edx
  10434a:	09 d0                	or     %edx,%eax
  10434c:	89 c2                	mov    %eax,%edx
  10434e:	83 ca 01             	or     $0x1,%edx
  104351:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104354:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  104356:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10435a:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  104361:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  104368:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10436c:	75 8f                	jne    1042fd <boot_map_segment+0x96>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  10436e:	c9                   	leave  
  10436f:	c3                   	ret    

00104370 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  104370:	55                   	push   %ebp
  104371:	89 e5                	mov    %esp,%ebp
  104373:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  104376:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10437d:	e8 23 fa ff ff       	call   103da5 <alloc_pages>
  104382:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  104385:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104389:	75 1c                	jne    1043a7 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  10438b:	c7 44 24 08 a3 6c 10 	movl   $0x106ca3,0x8(%esp)
  104392:	00 
  104393:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  10439a:	00 
  10439b:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  1043a2:	e8 f5 c8 ff ff       	call   100c9c <__panic>
    }
    return page2kva(p);
  1043a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043aa:	89 04 24             	mov    %eax,(%esp)
  1043ad:	e8 57 f7 ff ff       	call   103b09 <page2kva>
}
  1043b2:	c9                   	leave  
  1043b3:	c3                   	ret    

001043b4 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  1043b4:	55                   	push   %ebp
  1043b5:	89 e5                	mov    %esp,%ebp
  1043b7:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  1043ba:	e8 94 f9 ff ff       	call   103d53 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  1043bf:	e8 76 fa ff ff       	call   103e3a <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  1043c4:	e8 68 04 00 00       	call   104831 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  1043c9:	e8 a2 ff ff ff       	call   104370 <boot_alloc_page>
  1043ce:	a3 c4 88 11 00       	mov    %eax,0x1188c4
    memset(boot_pgdir, 0, PGSIZE);
  1043d3:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1043d8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1043df:	00 
  1043e0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1043e7:	00 
  1043e8:	89 04 24             	mov    %eax,(%esp)
  1043eb:	e8 fb 1a 00 00       	call   105eeb <memset>
    boot_cr3 = PADDR(boot_pgdir);
  1043f0:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1043f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1043f8:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1043ff:	77 23                	ja     104424 <pmm_init+0x70>
  104401:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104404:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104408:	c7 44 24 08 38 6c 10 	movl   $0x106c38,0x8(%esp)
  10440f:	00 
  104410:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  104417:	00 
  104418:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  10441f:	e8 78 c8 ff ff       	call   100c9c <__panic>
  104424:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104427:	05 00 00 00 40       	add    $0x40000000,%eax
  10442c:	a3 60 89 11 00       	mov    %eax,0x118960

    check_pgdir();
  104431:	e8 19 04 00 00       	call   10484f <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  104436:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10443b:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  104441:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104446:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104449:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  104450:	77 23                	ja     104475 <pmm_init+0xc1>
  104452:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104455:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104459:	c7 44 24 08 38 6c 10 	movl   $0x106c38,0x8(%esp)
  104460:	00 
  104461:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  104468:	00 
  104469:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  104470:	e8 27 c8 ff ff       	call   100c9c <__panic>
  104475:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104478:	05 00 00 00 40       	add    $0x40000000,%eax
  10447d:	83 c8 03             	or     $0x3,%eax
  104480:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  104482:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104487:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  10448e:	00 
  10448f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104496:	00 
  104497:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  10449e:	38 
  10449f:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  1044a6:	c0 
  1044a7:	89 04 24             	mov    %eax,(%esp)
  1044aa:	e8 b8 fd ff ff       	call   104267 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  1044af:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1044b4:	8b 15 c4 88 11 00    	mov    0x1188c4,%edx
  1044ba:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  1044c0:	89 10                	mov    %edx,(%eax)

    enable_paging();
  1044c2:	e8 62 fd ff ff       	call   104229 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  1044c7:	e8 98 f7 ff ff       	call   103c64 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  1044cc:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1044d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  1044d7:	e8 0e 0a 00 00       	call   104eea <check_boot_pgdir>

    print_pgdir();
  1044dc:	e8 87 0e 00 00       	call   105368 <print_pgdir>

}
  1044e1:	c9                   	leave  
  1044e2:	c3                   	ret    

001044e3 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  1044e3:	55                   	push   %ebp
  1044e4:	89 e5                	mov    %esp,%ebp
  1044e6:	83 ec 38             	sub    $0x38,%esp
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     *   PTE_W           0x002                   // page table/directory entry flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry flags bit : User can access
     */

	pde_t *pdep = &pgdir[PDX(la)];      // (1) find page directory entry
  1044e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1044ec:	c1 e8 16             	shr    $0x16,%eax
  1044ef:	c1 e0 02             	shl    $0x2,%eax
  1044f2:	03 45 08             	add    0x8(%ebp),%eax
  1044f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	if (!(*pdep & PTE_P)) {                        // (2) check if entry is not present
  1044f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044fb:	8b 00                	mov    (%eax),%eax
  1044fd:	83 e0 01             	and    $0x1,%eax
  104500:	85 c0                	test   %eax,%eax
  104502:	0f 85 af 00 00 00    	jne    1045b7 <get_pte+0xd4>
            struct Page *page; 
            if (!create || (page = alloc_page()) == NULL) {// (3) check if creating is needed, then alloc page for page table
  104508:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10450c:	74 15                	je     104523 <get_pte+0x40>
  10450e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104515:	e8 8b f8 ff ff       	call   103da5 <alloc_pages>
  10451a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10451d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104521:	75 0a                	jne    10452d <get_pte+0x4a>
            return NULL;
  104523:	b8 00 00 00 00       	mov    $0x0,%eax
  104528:	e9 e6 00 00 00       	jmp    104613 <get_pte+0x130>
        }
        set_page_ref(page, 1);             // (4) set page reference
  10452d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104534:	00 
  104535:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104538:	89 04 24             	mov    %eax,(%esp)
  10453b:	e8 65 f6 ff ff       	call   103ba5 <set_page_ref>
        uintptr_t pa = page2pa(page);     // (5) get linear address of page
  104540:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104543:	89 04 24             	mov    %eax,(%esp)
  104546:	e8 59 f5 ff ff       	call   103aa4 <page2pa>
  10454b:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE); // (6) clear page content using memset
  10454e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104551:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104554:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104557:	c1 e8 0c             	shr    $0xc,%eax
  10455a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10455d:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104562:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  104565:	72 23                	jb     10458a <get_pte+0xa7>
  104567:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10456a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10456e:	c7 44 24 08 94 6b 10 	movl   $0x106b94,0x8(%esp)
  104575:	00 
  104576:	c7 44 24 04 7c 01 00 	movl   $0x17c,0x4(%esp)
  10457d:	00 
  10457e:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  104585:	e8 12 c7 ff ff       	call   100c9c <__panic>
  10458a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10458d:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104592:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104599:	00 
  10459a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1045a1:	00 
  1045a2:	89 04 24             	mov    %eax,(%esp)
  1045a5:	e8 41 19 00 00       	call   105eeb <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;   // (7) set page directory entry's permission
  1045aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1045ad:	89 c2                	mov    %eax,%edx
  1045af:	83 ca 07             	or     $0x7,%edx
  1045b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045b5:	89 10                	mov    %edx,(%eax)
   	 }
   	 return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];      // (8) return page table entry
  1045b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045ba:	8b 00                	mov    (%eax),%eax
  1045bc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1045c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1045c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1045c7:	c1 e8 0c             	shr    $0xc,%eax
  1045ca:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1045cd:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1045d2:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1045d5:	72 23                	jb     1045fa <get_pte+0x117>
  1045d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1045da:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1045de:	c7 44 24 08 94 6b 10 	movl   $0x106b94,0x8(%esp)
  1045e5:	00 
  1045e6:	c7 44 24 04 7f 01 00 	movl   $0x17f,0x4(%esp)
  1045ed:	00 
  1045ee:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  1045f5:	e8 a2 c6 ff ff       	call   100c9c <__panic>
  1045fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1045fd:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104602:	8b 55 0c             	mov    0xc(%ebp),%edx
  104605:	c1 ea 0c             	shr    $0xc,%edx
  104608:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  10460e:	c1 e2 02             	shl    $0x2,%edx
  104611:	01 d0                	add    %edx,%eax
}
  104613:	c9                   	leave  
  104614:	c3                   	ret    

00104615 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  104615:	55                   	push   %ebp
  104616:	89 e5                	mov    %esp,%ebp
  104618:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10461b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104622:	00 
  104623:	8b 45 0c             	mov    0xc(%ebp),%eax
  104626:	89 44 24 04          	mov    %eax,0x4(%esp)
  10462a:	8b 45 08             	mov    0x8(%ebp),%eax
  10462d:	89 04 24             	mov    %eax,(%esp)
  104630:	e8 ae fe ff ff       	call   1044e3 <get_pte>
  104635:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  104638:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10463c:	74 08                	je     104646 <get_page+0x31>
        *ptep_store = ptep;
  10463e:	8b 45 10             	mov    0x10(%ebp),%eax
  104641:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104644:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  104646:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10464a:	74 1b                	je     104667 <get_page+0x52>
  10464c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10464f:	8b 00                	mov    (%eax),%eax
  104651:	83 e0 01             	and    $0x1,%eax
  104654:	84 c0                	test   %al,%al
  104656:	74 0f                	je     104667 <get_page+0x52>
        return pa2page(*ptep);
  104658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10465b:	8b 00                	mov    (%eax),%eax
  10465d:	89 04 24             	mov    %eax,(%esp)
  104660:	e8 55 f4 ff ff       	call   103aba <pa2page>
  104665:	eb 05                	jmp    10466c <get_page+0x57>
    }
    return NULL;
  104667:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10466c:	c9                   	leave  
  10466d:	c3                   	ret    

0010466e <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  10466e:	55                   	push   %ebp
  10466f:	89 e5                	mov    %esp,%ebp
  104671:	83 ec 28             	sub    $0x28,%esp
     *                        edited are the ones currently in use by the processor.
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     */
	
	if (!(*ptep & PTE_P))  /* page not present */
  104674:	8b 45 10             	mov    0x10(%ebp),%eax
  104677:	8b 00                	mov    (%eax),%eax
  104679:	83 e0 01             	and    $0x1,%eax
  10467c:	85 c0                	test   %eax,%eax
  10467e:	74 4f                	je     1046cf <page_remove_pte+0x61>
		return;
	struct Page *p = pte2page(*ptep);
  104680:	8b 45 10             	mov    0x10(%ebp),%eax
  104683:	8b 00                	mov    (%eax),%eax
  104685:	89 04 24             	mov    %eax,(%esp)
  104688:	e8 d0 f4 ff ff       	call   103b5d <pte2page>
  10468d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (page_ref_dec (p) == 0)
  104690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104693:	89 04 24             	mov    %eax,(%esp)
  104696:	e8 2e f5 ff ff       	call   103bc9 <page_ref_dec>
  10469b:	85 c0                	test   %eax,%eax
  10469d:	75 13                	jne    1046b2 <page_remove_pte+0x44>
		free_page (p);
  10469f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1046a6:	00 
  1046a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046aa:	89 04 24             	mov    %eax,(%esp)
  1046ad:	e8 2b f7 ff ff       	call   103ddd <free_pages>
	*ptep = 0;
  1046b2:	8b 45 10             	mov    0x10(%ebp),%eax
  1046b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	tlb_invalidate(pgdir, la);          
  1046bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046be:	89 44 24 04          	mov    %eax,0x4(%esp)
  1046c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1046c5:	89 04 24             	mov    %eax,(%esp)
  1046c8:	e8 02 01 00 00       	call   1047cf <tlb_invalidate>
  1046cd:	eb 01                	jmp    1046d0 <page_remove_pte+0x62>
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     */
	
	if (!(*ptep & PTE_P))  /* page not present */
		return;
  1046cf:	90                   	nop
	if (page_ref_dec (p) == 0)
		free_page (p);
	*ptep = 0;
	tlb_invalidate(pgdir, la);          
	
}
  1046d0:	c9                   	leave  
  1046d1:	c3                   	ret    

001046d2 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  1046d2:	55                   	push   %ebp
  1046d3:	89 e5                	mov    %esp,%ebp
  1046d5:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1046d8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1046df:	00 
  1046e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1046e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1046ea:	89 04 24             	mov    %eax,(%esp)
  1046ed:	e8 f1 fd ff ff       	call   1044e3 <get_pte>
  1046f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  1046f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1046f9:	74 19                	je     104714 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  1046fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046fe:	89 44 24 08          	mov    %eax,0x8(%esp)
  104702:	8b 45 0c             	mov    0xc(%ebp),%eax
  104705:	89 44 24 04          	mov    %eax,0x4(%esp)
  104709:	8b 45 08             	mov    0x8(%ebp),%eax
  10470c:	89 04 24             	mov    %eax,(%esp)
  10470f:	e8 5a ff ff ff       	call   10466e <page_remove_pte>
    }
}  
  104714:	c9                   	leave  
  104715:	c3                   	ret    

00104716 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  104716:	55                   	push   %ebp
  104717:	89 e5                	mov    %esp,%ebp
  104719:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  10471c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104723:	00 
  104724:	8b 45 10             	mov    0x10(%ebp),%eax
  104727:	89 44 24 04          	mov    %eax,0x4(%esp)
  10472b:	8b 45 08             	mov    0x8(%ebp),%eax
  10472e:	89 04 24             	mov    %eax,(%esp)
  104731:	e8 ad fd ff ff       	call   1044e3 <get_pte>
  104736:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  104739:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10473d:	75 0a                	jne    104749 <page_insert+0x33>
        return -E_NO_MEM;
  10473f:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  104744:	e9 84 00 00 00       	jmp    1047cd <page_insert+0xb7>
    }
    page_ref_inc(page);
  104749:	8b 45 0c             	mov    0xc(%ebp),%eax
  10474c:	89 04 24             	mov    %eax,(%esp)
  10474f:	e8 5e f4 ff ff       	call   103bb2 <page_ref_inc>
    if (*ptep & PTE_P) {
  104754:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104757:	8b 00                	mov    (%eax),%eax
  104759:	83 e0 01             	and    $0x1,%eax
  10475c:	84 c0                	test   %al,%al
  10475e:	74 3e                	je     10479e <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  104760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104763:	8b 00                	mov    (%eax),%eax
  104765:	89 04 24             	mov    %eax,(%esp)
  104768:	e8 f0 f3 ff ff       	call   103b5d <pte2page>
  10476d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  104770:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104773:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104776:	75 0d                	jne    104785 <page_insert+0x6f>
            page_ref_dec(page);
  104778:	8b 45 0c             	mov    0xc(%ebp),%eax
  10477b:	89 04 24             	mov    %eax,(%esp)
  10477e:	e8 46 f4 ff ff       	call   103bc9 <page_ref_dec>
  104783:	eb 19                	jmp    10479e <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  104785:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104788:	89 44 24 08          	mov    %eax,0x8(%esp)
  10478c:	8b 45 10             	mov    0x10(%ebp),%eax
  10478f:	89 44 24 04          	mov    %eax,0x4(%esp)
  104793:	8b 45 08             	mov    0x8(%ebp),%eax
  104796:	89 04 24             	mov    %eax,(%esp)
  104799:	e8 d0 fe ff ff       	call   10466e <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  10479e:	8b 45 0c             	mov    0xc(%ebp),%eax
  1047a1:	89 04 24             	mov    %eax,(%esp)
  1047a4:	e8 fb f2 ff ff       	call   103aa4 <page2pa>
  1047a9:	0b 45 14             	or     0x14(%ebp),%eax
  1047ac:	89 c2                	mov    %eax,%edx
  1047ae:	83 ca 01             	or     $0x1,%edx
  1047b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047b4:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  1047b6:	8b 45 10             	mov    0x10(%ebp),%eax
  1047b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1047bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1047c0:	89 04 24             	mov    %eax,(%esp)
  1047c3:	e8 07 00 00 00       	call   1047cf <tlb_invalidate>
    return 0;
  1047c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1047cd:	c9                   	leave  
  1047ce:	c3                   	ret    

001047cf <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  1047cf:	55                   	push   %ebp
  1047d0:	89 e5                	mov    %esp,%ebp
  1047d2:	53                   	push   %ebx
  1047d3:	83 ec 24             	sub    $0x24,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  1047d6:	0f 20 db             	mov    %cr3,%ebx
  1047d9:	89 5d f0             	mov    %ebx,-0x10(%ebp)
    return cr3;
  1047dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  1047df:	89 c2                	mov    %eax,%edx
  1047e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1047e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1047e7:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1047ee:	77 23                	ja     104813 <tlb_invalidate+0x44>
  1047f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1047f7:	c7 44 24 08 38 6c 10 	movl   $0x106c38,0x8(%esp)
  1047fe:	00 
  1047ff:	c7 44 24 04 d9 01 00 	movl   $0x1d9,0x4(%esp)
  104806:	00 
  104807:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  10480e:	e8 89 c4 ff ff       	call   100c9c <__panic>
  104813:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104816:	05 00 00 00 40       	add    $0x40000000,%eax
  10481b:	39 c2                	cmp    %eax,%edx
  10481d:	75 0c                	jne    10482b <tlb_invalidate+0x5c>
        invlpg((void *)la);
  10481f:	8b 45 0c             	mov    0xc(%ebp),%eax
  104822:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  104825:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104828:	0f 01 38             	invlpg (%eax)
    }
}
  10482b:	83 c4 24             	add    $0x24,%esp
  10482e:	5b                   	pop    %ebx
  10482f:	5d                   	pop    %ebp
  104830:	c3                   	ret    

00104831 <check_alloc_page>:

static void
check_alloc_page(void) {
  104831:	55                   	push   %ebp
  104832:	89 e5                	mov    %esp,%ebp
  104834:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  104837:	a1 5c 89 11 00       	mov    0x11895c,%eax
  10483c:	8b 40 18             	mov    0x18(%eax),%eax
  10483f:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  104841:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  104848:	e8 fa ba ff ff       	call   100347 <cprintf>
}
  10484d:	c9                   	leave  
  10484e:	c3                   	ret    

0010484f <check_pgdir>:

static void
check_pgdir(void) {
  10484f:	55                   	push   %ebp
  104850:	89 e5                	mov    %esp,%ebp
  104852:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  104855:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  10485a:	3d 00 80 03 00       	cmp    $0x38000,%eax
  10485f:	76 24                	jbe    104885 <check_pgdir+0x36>
  104861:	c7 44 24 0c db 6c 10 	movl   $0x106cdb,0xc(%esp)
  104868:	00 
  104869:	c7 44 24 08 81 6c 10 	movl   $0x106c81,0x8(%esp)
  104870:	00 
  104871:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
  104878:	00 
  104879:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  104880:	e8 17 c4 ff ff       	call   100c9c <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  104885:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10488a:	85 c0                	test   %eax,%eax
  10488c:	74 0e                	je     10489c <check_pgdir+0x4d>
  10488e:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104893:	25 ff 0f 00 00       	and    $0xfff,%eax
  104898:	85 c0                	test   %eax,%eax
  10489a:	74 24                	je     1048c0 <check_pgdir+0x71>
  10489c:	c7 44 24 0c f8 6c 10 	movl   $0x106cf8,0xc(%esp)
  1048a3:	00 
  1048a4:	c7 44 24 08 81 6c 10 	movl   $0x106c81,0x8(%esp)
  1048ab:	00 
  1048ac:	c7 44 24 04 e7 01 00 	movl   $0x1e7,0x4(%esp)
  1048b3:	00 
  1048b4:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  1048bb:	e8 dc c3 ff ff       	call   100c9c <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  1048c0:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1048c5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1048cc:	00 
  1048cd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1048d4:	00 
  1048d5:	89 04 24             	mov    %eax,(%esp)
  1048d8:	e8 38 fd ff ff       	call   104615 <get_page>
  1048dd:	85 c0                	test   %eax,%eax
  1048df:	74 24                	je     104905 <check_pgdir+0xb6>
  1048e1:	c7 44 24 0c 30 6d 10 	movl   $0x106d30,0xc(%esp)
  1048e8:	00 
  1048e9:	c7 44 24 08 81 6c 10 	movl   $0x106c81,0x8(%esp)
  1048f0:	00 
  1048f1:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
  1048f8:	00 
  1048f9:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  104900:	e8 97 c3 ff ff       	call   100c9c <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  104905:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10490c:	e8 94 f4 ff ff       	call   103da5 <alloc_pages>
  104911:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  104914:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104919:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104920:	00 
  104921:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104928:	00 
  104929:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10492c:	89 54 24 04          	mov    %edx,0x4(%esp)
  104930:	89 04 24             	mov    %eax,(%esp)
  104933:	e8 de fd ff ff       	call   104716 <page_insert>
  104938:	85 c0                	test   %eax,%eax
  10493a:	74 24                	je     104960 <check_pgdir+0x111>
  10493c:	c7 44 24 0c 58 6d 10 	movl   $0x106d58,0xc(%esp)
  104943:	00 
  104944:	c7 44 24 08 81 6c 10 	movl   $0x106c81,0x8(%esp)
  10494b:	00 
  10494c:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
  104953:	00 
  104954:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  10495b:	e8 3c c3 ff ff       	call   100c9c <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  104960:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104965:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10496c:	00 
  10496d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104974:	00 
  104975:	89 04 24             	mov    %eax,(%esp)
  104978:	e8 66 fb ff ff       	call   1044e3 <get_pte>
  10497d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104980:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104984:	75 24                	jne    1049aa <check_pgdir+0x15b>
  104986:	c7 44 24 0c 84 6d 10 	movl   $0x106d84,0xc(%esp)
  10498d:	00 
  10498e:	c7 44 24 08 81 6c 10 	movl   $0x106c81,0x8(%esp)
  104995:	00 
  104996:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
  10499d:	00 
  10499e:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  1049a5:	e8 f2 c2 ff ff       	call   100c9c <__panic>
    assert(pa2page(*ptep) == p1);
  1049aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1049ad:	8b 00                	mov    (%eax),%eax
  1049af:	89 04 24             	mov    %eax,(%esp)
  1049b2:	e8 03 f1 ff ff       	call   103aba <pa2page>
  1049b7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1049ba:	74 24                	je     1049e0 <check_pgdir+0x191>
  1049bc:	c7 44 24 0c b1 6d 10 	movl   $0x106db1,0xc(%esp)
  1049c3:	00 
  1049c4:	c7 44 24 08 81 6c 10 	movl   $0x106c81,0x8(%esp)
  1049cb:	00 
  1049cc:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
  1049d3:	00 
  1049d4:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  1049db:	e8 bc c2 ff ff       	call   100c9c <__panic>
    assert(page_ref(p1) == 1);
  1049e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049e3:	89 04 24             	mov    %eax,(%esp)
  1049e6:	e8 b0 f1 ff ff       	call   103b9b <page_ref>
  1049eb:	83 f8 01             	cmp    $0x1,%eax
  1049ee:	74 24                	je     104a14 <check_pgdir+0x1c5>
  1049f0:	c7 44 24 0c c6 6d 10 	movl   $0x106dc6,0xc(%esp)
  1049f7:	00 
  1049f8:	c7 44 24 08 81 6c 10 	movl   $0x106c81,0x8(%esp)
  1049ff:	00 
  104a00:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
  104a07:	00 
  104a08:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  104a0f:	e8 88 c2 ff ff       	call   100c9c <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  104a14:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104a19:	8b 00                	mov    (%eax),%eax
  104a1b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104a20:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104a23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a26:	c1 e8 0c             	shr    $0xc,%eax
  104a29:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104a2c:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104a31:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104a34:	72 23                	jb     104a59 <check_pgdir+0x20a>
  104a36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a39:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104a3d:	c7 44 24 08 94 6b 10 	movl   $0x106b94,0x8(%esp)
  104a44:	00 
  104a45:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
  104a4c:	00 
  104a4d:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  104a54:	e8 43 c2 ff ff       	call   100c9c <__panic>
  104a59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a5c:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104a61:	83 c0 04             	add    $0x4,%eax
  104a64:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  104a67:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104a6c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104a73:	00 
  104a74:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104a7b:	00 
  104a7c:	89 04 24             	mov    %eax,(%esp)
  104a7f:	e8 5f fa ff ff       	call   1044e3 <get_pte>
  104a84:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104a87:	74 24                	je     104aad <check_pgdir+0x25e>
  104a89:	c7 44 24 0c d8 6d 10 	movl   $0x106dd8,0xc(%esp)
  104a90:	00 
  104a91:	c7 44 24 08 81 6c 10 	movl   $0x106c81,0x8(%esp)
  104a98:	00 
  104a99:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
  104aa0:	00 
  104aa1:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  104aa8:	e8 ef c1 ff ff       	call   100c9c <__panic>

    p2 = alloc_page();
  104aad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104ab4:	e8 ec f2 ff ff       	call   103da5 <alloc_pages>
  104ab9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  104abc:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104ac1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  104ac8:	00 
  104ac9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104ad0:	00 
  104ad1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104ad4:	89 54 24 04          	mov    %edx,0x4(%esp)
  104ad8:	89 04 24             	mov    %eax,(%esp)
  104adb:	e8 36 fc ff ff       	call   104716 <page_insert>
  104ae0:	85 c0                	test   %eax,%eax
  104ae2:	74 24                	je     104b08 <check_pgdir+0x2b9>
  104ae4:	c7 44 24 0c 00 6e 10 	movl   $0x106e00,0xc(%esp)
  104aeb:	00 
  104aec:	c7 44 24 08 81 6c 10 	movl   $0x106c81,0x8(%esp)
  104af3:	00 
  104af4:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  104afb:	00 
  104afc:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  104b03:	e8 94 c1 ff ff       	call   100c9c <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104b08:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104b0d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104b14:	00 
  104b15:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104b1c:	00 
  104b1d:	89 04 24             	mov    %eax,(%esp)
  104b20:	e8 be f9 ff ff       	call   1044e3 <get_pte>
  104b25:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104b28:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104b2c:	75 24                	jne    104b52 <check_pgdir+0x303>
  104b2e:	c7 44 24 0c 38 6e 10 	movl   $0x106e38,0xc(%esp)
  104b35:	00 
  104b36:	c7 44 24 08 81 6c 10 	movl   $0x106c81,0x8(%esp)
  104b3d:	00 
  104b3e:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
  104b45:	00 
  104b46:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  104b4d:	e8 4a c1 ff ff       	call   100c9c <__panic>
    assert(*ptep & PTE_U);
  104b52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b55:	8b 00                	mov    (%eax),%eax
  104b57:	83 e0 04             	and    $0x4,%eax
  104b5a:	85 c0                	test   %eax,%eax
  104b5c:	75 24                	jne    104b82 <check_pgdir+0x333>
  104b5e:	c7 44 24 0c 68 6e 10 	movl   $0x106e68,0xc(%esp)
  104b65:	00 
  104b66:	c7 44 24 08 81 6c 10 	movl   $0x106c81,0x8(%esp)
  104b6d:	00 
  104b6e:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
  104b75:	00 
  104b76:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  104b7d:	e8 1a c1 ff ff       	call   100c9c <__panic>
    assert(*ptep & PTE_W);
  104b82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b85:	8b 00                	mov    (%eax),%eax
  104b87:	83 e0 02             	and    $0x2,%eax
  104b8a:	85 c0                	test   %eax,%eax
  104b8c:	75 24                	jne    104bb2 <check_pgdir+0x363>
  104b8e:	c7 44 24 0c 76 6e 10 	movl   $0x106e76,0xc(%esp)
  104b95:	00 
  104b96:	c7 44 24 08 81 6c 10 	movl   $0x106c81,0x8(%esp)
  104b9d:	00 
  104b9e:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
  104ba5:	00 
  104ba6:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  104bad:	e8 ea c0 ff ff       	call   100c9c <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104bb2:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104bb7:	8b 00                	mov    (%eax),%eax
  104bb9:	83 e0 04             	and    $0x4,%eax
  104bbc:	85 c0                	test   %eax,%eax
  104bbe:	75 24                	jne    104be4 <check_pgdir+0x395>
  104bc0:	c7 44 24 0c 84 6e 10 	movl   $0x106e84,0xc(%esp)
  104bc7:	00 
  104bc8:	c7 44 24 08 81 6c 10 	movl   $0x106c81,0x8(%esp)
  104bcf:	00 
  104bd0:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
  104bd7:	00 
  104bd8:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  104bdf:	e8 b8 c0 ff ff       	call   100c9c <__panic>
    assert(page_ref(p2) == 1);
  104be4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104be7:	89 04 24             	mov    %eax,(%esp)
  104bea:	e8 ac ef ff ff       	call   103b9b <page_ref>
  104bef:	83 f8 01             	cmp    $0x1,%eax
  104bf2:	74 24                	je     104c18 <check_pgdir+0x3c9>
  104bf4:	c7 44 24 0c 9a 6e 10 	movl   $0x106e9a,0xc(%esp)
  104bfb:	00 
  104bfc:	c7 44 24 08 81 6c 10 	movl   $0x106c81,0x8(%esp)
  104c03:	00 
  104c04:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
  104c0b:	00 
  104c0c:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  104c13:	e8 84 c0 ff ff       	call   100c9c <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104c18:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104c1d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104c24:	00 
  104c25:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104c2c:	00 
  104c2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104c30:	89 54 24 04          	mov    %edx,0x4(%esp)
  104c34:	89 04 24             	mov    %eax,(%esp)
  104c37:	e8 da fa ff ff       	call   104716 <page_insert>
  104c3c:	85 c0                	test   %eax,%eax
  104c3e:	74 24                	je     104c64 <check_pgdir+0x415>
  104c40:	c7 44 24 0c ac 6e 10 	movl   $0x106eac,0xc(%esp)
  104c47:	00 
  104c48:	c7 44 24 08 81 6c 10 	movl   $0x106c81,0x8(%esp)
  104c4f:	00 
  104c50:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
  104c57:	00 
  104c58:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  104c5f:	e8 38 c0 ff ff       	call   100c9c <__panic>
    assert(page_ref(p1) == 2);
  104c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c67:	89 04 24             	mov    %eax,(%esp)
  104c6a:	e8 2c ef ff ff       	call   103b9b <page_ref>
  104c6f:	83 f8 02             	cmp    $0x2,%eax
  104c72:	74 24                	je     104c98 <check_pgdir+0x449>
  104c74:	c7 44 24 0c d8 6e 10 	movl   $0x106ed8,0xc(%esp)
  104c7b:	00 
  104c7c:	c7 44 24 08 81 6c 10 	movl   $0x106c81,0x8(%esp)
  104c83:	00 
  104c84:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
  104c8b:	00 
  104c8c:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  104c93:	e8 04 c0 ff ff       	call   100c9c <__panic>
    assert(page_ref(p2) == 0);
  104c98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c9b:	89 04 24             	mov    %eax,(%esp)
  104c9e:	e8 f8 ee ff ff       	call   103b9b <page_ref>
  104ca3:	85 c0                	test   %eax,%eax
  104ca5:	74 24                	je     104ccb <check_pgdir+0x47c>
  104ca7:	c7 44 24 0c ea 6e 10 	movl   $0x106eea,0xc(%esp)
  104cae:	00 
  104caf:	c7 44 24 08 81 6c 10 	movl   $0x106c81,0x8(%esp)
  104cb6:	00 
  104cb7:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  104cbe:	00 
  104cbf:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  104cc6:	e8 d1 bf ff ff       	call   100c9c <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104ccb:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104cd0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104cd7:	00 
  104cd8:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104cdf:	00 
  104ce0:	89 04 24             	mov    %eax,(%esp)
  104ce3:	e8 fb f7 ff ff       	call   1044e3 <get_pte>
  104ce8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104ceb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104cef:	75 24                	jne    104d15 <check_pgdir+0x4c6>
  104cf1:	c7 44 24 0c 38 6e 10 	movl   $0x106e38,0xc(%esp)
  104cf8:	00 
  104cf9:	c7 44 24 08 81 6c 10 	movl   $0x106c81,0x8(%esp)
  104d00:	00 
  104d01:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
  104d08:	00 
  104d09:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  104d10:	e8 87 bf ff ff       	call   100c9c <__panic>
    assert(pa2page(*ptep) == p1);
  104d15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d18:	8b 00                	mov    (%eax),%eax
  104d1a:	89 04 24             	mov    %eax,(%esp)
  104d1d:	e8 98 ed ff ff       	call   103aba <pa2page>
  104d22:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104d25:	74 24                	je     104d4b <check_pgdir+0x4fc>
  104d27:	c7 44 24 0c b1 6d 10 	movl   $0x106db1,0xc(%esp)
  104d2e:	00 
  104d2f:	c7 44 24 08 81 6c 10 	movl   $0x106c81,0x8(%esp)
  104d36:	00 
  104d37:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  104d3e:	00 
  104d3f:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  104d46:	e8 51 bf ff ff       	call   100c9c <__panic>
    assert((*ptep & PTE_U) == 0);
  104d4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d4e:	8b 00                	mov    (%eax),%eax
  104d50:	83 e0 04             	and    $0x4,%eax
  104d53:	85 c0                	test   %eax,%eax
  104d55:	74 24                	je     104d7b <check_pgdir+0x52c>
  104d57:	c7 44 24 0c fc 6e 10 	movl   $0x106efc,0xc(%esp)
  104d5e:	00 
  104d5f:	c7 44 24 08 81 6c 10 	movl   $0x106c81,0x8(%esp)
  104d66:	00 
  104d67:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  104d6e:	00 
  104d6f:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  104d76:	e8 21 bf ff ff       	call   100c9c <__panic>

    page_remove(boot_pgdir, 0x0);
  104d7b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104d80:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104d87:	00 
  104d88:	89 04 24             	mov    %eax,(%esp)
  104d8b:	e8 42 f9 ff ff       	call   1046d2 <page_remove>
    assert(page_ref(p1) == 1);
  104d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d93:	89 04 24             	mov    %eax,(%esp)
  104d96:	e8 00 ee ff ff       	call   103b9b <page_ref>
  104d9b:	83 f8 01             	cmp    $0x1,%eax
  104d9e:	74 24                	je     104dc4 <check_pgdir+0x575>
  104da0:	c7 44 24 0c c6 6d 10 	movl   $0x106dc6,0xc(%esp)
  104da7:	00 
  104da8:	c7 44 24 08 81 6c 10 	movl   $0x106c81,0x8(%esp)
  104daf:	00 
  104db0:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
  104db7:	00 
  104db8:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  104dbf:	e8 d8 be ff ff       	call   100c9c <__panic>
    assert(page_ref(p2) == 0);
  104dc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104dc7:	89 04 24             	mov    %eax,(%esp)
  104dca:	e8 cc ed ff ff       	call   103b9b <page_ref>
  104dcf:	85 c0                	test   %eax,%eax
  104dd1:	74 24                	je     104df7 <check_pgdir+0x5a8>
  104dd3:	c7 44 24 0c ea 6e 10 	movl   $0x106eea,0xc(%esp)
  104dda:	00 
  104ddb:	c7 44 24 08 81 6c 10 	movl   $0x106c81,0x8(%esp)
  104de2:	00 
  104de3:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  104dea:	00 
  104deb:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  104df2:	e8 a5 be ff ff       	call   100c9c <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104df7:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104dfc:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104e03:	00 
  104e04:	89 04 24             	mov    %eax,(%esp)
  104e07:	e8 c6 f8 ff ff       	call   1046d2 <page_remove>
    assert(page_ref(p1) == 0);
  104e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e0f:	89 04 24             	mov    %eax,(%esp)
  104e12:	e8 84 ed ff ff       	call   103b9b <page_ref>
  104e17:	85 c0                	test   %eax,%eax
  104e19:	74 24                	je     104e3f <check_pgdir+0x5f0>
  104e1b:	c7 44 24 0c 11 6f 10 	movl   $0x106f11,0xc(%esp)
  104e22:	00 
  104e23:	c7 44 24 08 81 6c 10 	movl   $0x106c81,0x8(%esp)
  104e2a:	00 
  104e2b:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
  104e32:	00 
  104e33:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  104e3a:	e8 5d be ff ff       	call   100c9c <__panic>
    assert(page_ref(p2) == 0);
  104e3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e42:	89 04 24             	mov    %eax,(%esp)
  104e45:	e8 51 ed ff ff       	call   103b9b <page_ref>
  104e4a:	85 c0                	test   %eax,%eax
  104e4c:	74 24                	je     104e72 <check_pgdir+0x623>
  104e4e:	c7 44 24 0c ea 6e 10 	movl   $0x106eea,0xc(%esp)
  104e55:	00 
  104e56:	c7 44 24 08 81 6c 10 	movl   $0x106c81,0x8(%esp)
  104e5d:	00 
  104e5e:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
  104e65:	00 
  104e66:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  104e6d:	e8 2a be ff ff       	call   100c9c <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
  104e72:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104e77:	8b 00                	mov    (%eax),%eax
  104e79:	89 04 24             	mov    %eax,(%esp)
  104e7c:	e8 39 ec ff ff       	call   103aba <pa2page>
  104e81:	89 04 24             	mov    %eax,(%esp)
  104e84:	e8 12 ed ff ff       	call   103b9b <page_ref>
  104e89:	83 f8 01             	cmp    $0x1,%eax
  104e8c:	74 24                	je     104eb2 <check_pgdir+0x663>
  104e8e:	c7 44 24 0c 24 6f 10 	movl   $0x106f24,0xc(%esp)
  104e95:	00 
  104e96:	c7 44 24 08 81 6c 10 	movl   $0x106c81,0x8(%esp)
  104e9d:	00 
  104e9e:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  104ea5:	00 
  104ea6:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  104ead:	e8 ea bd ff ff       	call   100c9c <__panic>
    free_page(pa2page(boot_pgdir[0]));
  104eb2:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104eb7:	8b 00                	mov    (%eax),%eax
  104eb9:	89 04 24             	mov    %eax,(%esp)
  104ebc:	e8 f9 eb ff ff       	call   103aba <pa2page>
  104ec1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104ec8:	00 
  104ec9:	89 04 24             	mov    %eax,(%esp)
  104ecc:	e8 0c ef ff ff       	call   103ddd <free_pages>
    boot_pgdir[0] = 0;
  104ed1:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104ed6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  104edc:	c7 04 24 4a 6f 10 00 	movl   $0x106f4a,(%esp)
  104ee3:	e8 5f b4 ff ff       	call   100347 <cprintf>
}
  104ee8:	c9                   	leave  
  104ee9:	c3                   	ret    

00104eea <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  104eea:	55                   	push   %ebp
  104eeb:	89 e5                	mov    %esp,%ebp
  104eed:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104ef0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104ef7:	e9 cb 00 00 00       	jmp    104fc7 <check_boot_pgdir+0xdd>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  104efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104eff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104f02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f05:	c1 e8 0c             	shr    $0xc,%eax
  104f08:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104f0b:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104f10:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104f13:	72 23                	jb     104f38 <check_boot_pgdir+0x4e>
  104f15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f18:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104f1c:	c7 44 24 08 94 6b 10 	movl   $0x106b94,0x8(%esp)
  104f23:	00 
  104f24:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
  104f2b:	00 
  104f2c:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  104f33:	e8 64 bd ff ff       	call   100c9c <__panic>
  104f38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f3b:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104f40:	89 c2                	mov    %eax,%edx
  104f42:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104f47:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104f4e:	00 
  104f4f:	89 54 24 04          	mov    %edx,0x4(%esp)
  104f53:	89 04 24             	mov    %eax,(%esp)
  104f56:	e8 88 f5 ff ff       	call   1044e3 <get_pte>
  104f5b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104f5e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104f62:	75 24                	jne    104f88 <check_boot_pgdir+0x9e>
  104f64:	c7 44 24 0c 64 6f 10 	movl   $0x106f64,0xc(%esp)
  104f6b:	00 
  104f6c:	c7 44 24 08 81 6c 10 	movl   $0x106c81,0x8(%esp)
  104f73:	00 
  104f74:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
  104f7b:	00 
  104f7c:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  104f83:	e8 14 bd ff ff       	call   100c9c <__panic>
        assert(PTE_ADDR(*ptep) == i);
  104f88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104f8b:	8b 00                	mov    (%eax),%eax
  104f8d:	89 c2                	mov    %eax,%edx
  104f8f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  104f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f98:	39 c2                	cmp    %eax,%edx
  104f9a:	74 24                	je     104fc0 <check_boot_pgdir+0xd6>
  104f9c:	c7 44 24 0c a1 6f 10 	movl   $0x106fa1,0xc(%esp)
  104fa3:	00 
  104fa4:	c7 44 24 08 81 6c 10 	movl   $0x106c81,0x8(%esp)
  104fab:	00 
  104fac:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
  104fb3:	00 
  104fb4:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  104fbb:	e8 dc bc ff ff       	call   100c9c <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104fc0:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  104fc7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104fca:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104fcf:	39 c2                	cmp    %eax,%edx
  104fd1:	0f 82 25 ff ff ff    	jb     104efc <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  104fd7:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104fdc:	05 ac 0f 00 00       	add    $0xfac,%eax
  104fe1:	8b 00                	mov    (%eax),%eax
  104fe3:	89 c2                	mov    %eax,%edx
  104fe5:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  104feb:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104ff0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104ff3:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  104ffa:	77 23                	ja     10501f <check_boot_pgdir+0x135>
  104ffc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104fff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105003:	c7 44 24 08 38 6c 10 	movl   $0x106c38,0x8(%esp)
  10500a:	00 
  10500b:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
  105012:	00 
  105013:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  10501a:	e8 7d bc ff ff       	call   100c9c <__panic>
  10501f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105022:	05 00 00 00 40       	add    $0x40000000,%eax
  105027:	39 c2                	cmp    %eax,%edx
  105029:	74 24                	je     10504f <check_boot_pgdir+0x165>
  10502b:	c7 44 24 0c b8 6f 10 	movl   $0x106fb8,0xc(%esp)
  105032:	00 
  105033:	c7 44 24 08 81 6c 10 	movl   $0x106c81,0x8(%esp)
  10503a:	00 
  10503b:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
  105042:	00 
  105043:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  10504a:	e8 4d bc ff ff       	call   100c9c <__panic>

    assert(boot_pgdir[0] == 0);
  10504f:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105054:	8b 00                	mov    (%eax),%eax
  105056:	85 c0                	test   %eax,%eax
  105058:	74 24                	je     10507e <check_boot_pgdir+0x194>
  10505a:	c7 44 24 0c ec 6f 10 	movl   $0x106fec,0xc(%esp)
  105061:	00 
  105062:	c7 44 24 08 81 6c 10 	movl   $0x106c81,0x8(%esp)
  105069:	00 
  10506a:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
  105071:	00 
  105072:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  105079:	e8 1e bc ff ff       	call   100c9c <__panic>

    struct Page *p;
    p = alloc_page();
  10507e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105085:	e8 1b ed ff ff       	call   103da5 <alloc_pages>
  10508a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  10508d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105092:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  105099:	00 
  10509a:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  1050a1:	00 
  1050a2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1050a5:	89 54 24 04          	mov    %edx,0x4(%esp)
  1050a9:	89 04 24             	mov    %eax,(%esp)
  1050ac:	e8 65 f6 ff ff       	call   104716 <page_insert>
  1050b1:	85 c0                	test   %eax,%eax
  1050b3:	74 24                	je     1050d9 <check_boot_pgdir+0x1ef>
  1050b5:	c7 44 24 0c 00 70 10 	movl   $0x107000,0xc(%esp)
  1050bc:	00 
  1050bd:	c7 44 24 08 81 6c 10 	movl   $0x106c81,0x8(%esp)
  1050c4:	00 
  1050c5:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
  1050cc:	00 
  1050cd:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  1050d4:	e8 c3 bb ff ff       	call   100c9c <__panic>
    assert(page_ref(p) == 1);
  1050d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1050dc:	89 04 24             	mov    %eax,(%esp)
  1050df:	e8 b7 ea ff ff       	call   103b9b <page_ref>
  1050e4:	83 f8 01             	cmp    $0x1,%eax
  1050e7:	74 24                	je     10510d <check_boot_pgdir+0x223>
  1050e9:	c7 44 24 0c 2e 70 10 	movl   $0x10702e,0xc(%esp)
  1050f0:	00 
  1050f1:	c7 44 24 08 81 6c 10 	movl   $0x106c81,0x8(%esp)
  1050f8:	00 
  1050f9:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
  105100:	00 
  105101:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  105108:	e8 8f bb ff ff       	call   100c9c <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  10510d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105112:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  105119:	00 
  10511a:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  105121:	00 
  105122:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105125:	89 54 24 04          	mov    %edx,0x4(%esp)
  105129:	89 04 24             	mov    %eax,(%esp)
  10512c:	e8 e5 f5 ff ff       	call   104716 <page_insert>
  105131:	85 c0                	test   %eax,%eax
  105133:	74 24                	je     105159 <check_boot_pgdir+0x26f>
  105135:	c7 44 24 0c 40 70 10 	movl   $0x107040,0xc(%esp)
  10513c:	00 
  10513d:	c7 44 24 08 81 6c 10 	movl   $0x106c81,0x8(%esp)
  105144:	00 
  105145:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
  10514c:	00 
  10514d:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  105154:	e8 43 bb ff ff       	call   100c9c <__panic>
    assert(page_ref(p) == 2);
  105159:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10515c:	89 04 24             	mov    %eax,(%esp)
  10515f:	e8 37 ea ff ff       	call   103b9b <page_ref>
  105164:	83 f8 02             	cmp    $0x2,%eax
  105167:	74 24                	je     10518d <check_boot_pgdir+0x2a3>
  105169:	c7 44 24 0c 77 70 10 	movl   $0x107077,0xc(%esp)
  105170:	00 
  105171:	c7 44 24 08 81 6c 10 	movl   $0x106c81,0x8(%esp)
  105178:	00 
  105179:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
  105180:	00 
  105181:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  105188:	e8 0f bb ff ff       	call   100c9c <__panic>

    const char *str = "ucore: Hello world!!";
  10518d:	c7 45 dc 88 70 10 00 	movl   $0x107088,-0x24(%ebp)
    strcpy((void *)0x100, str);
  105194:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105197:	89 44 24 04          	mov    %eax,0x4(%esp)
  10519b:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1051a2:	e8 67 0a 00 00       	call   105c0e <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  1051a7:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  1051ae:	00 
  1051af:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1051b6:	e8 d0 0a 00 00       	call   105c8b <strcmp>
  1051bb:	85 c0                	test   %eax,%eax
  1051bd:	74 24                	je     1051e3 <check_boot_pgdir+0x2f9>
  1051bf:	c7 44 24 0c a0 70 10 	movl   $0x1070a0,0xc(%esp)
  1051c6:	00 
  1051c7:	c7 44 24 08 81 6c 10 	movl   $0x106c81,0x8(%esp)
  1051ce:	00 
  1051cf:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
  1051d6:	00 
  1051d7:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  1051de:	e8 b9 ba ff ff       	call   100c9c <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  1051e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1051e6:	89 04 24             	mov    %eax,(%esp)
  1051e9:	e8 1b e9 ff ff       	call   103b09 <page2kva>
  1051ee:	05 00 01 00 00       	add    $0x100,%eax
  1051f3:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  1051f6:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1051fd:	e8 ae 09 00 00       	call   105bb0 <strlen>
  105202:	85 c0                	test   %eax,%eax
  105204:	74 24                	je     10522a <check_boot_pgdir+0x340>
  105206:	c7 44 24 0c d8 70 10 	movl   $0x1070d8,0xc(%esp)
  10520d:	00 
  10520e:	c7 44 24 08 81 6c 10 	movl   $0x106c81,0x8(%esp)
  105215:	00 
  105216:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
  10521d:	00 
  10521e:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  105225:	e8 72 ba ff ff       	call   100c9c <__panic>

    free_page(p);
  10522a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105231:	00 
  105232:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105235:	89 04 24             	mov    %eax,(%esp)
  105238:	e8 a0 eb ff ff       	call   103ddd <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
  10523d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105242:	8b 00                	mov    (%eax),%eax
  105244:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  105249:	89 04 24             	mov    %eax,(%esp)
  10524c:	e8 69 e8 ff ff       	call   103aba <pa2page>
  105251:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105258:	00 
  105259:	89 04 24             	mov    %eax,(%esp)
  10525c:	e8 7c eb ff ff       	call   103ddd <free_pages>
    boot_pgdir[0] = 0;
  105261:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105266:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  10526c:	c7 04 24 fc 70 10 00 	movl   $0x1070fc,(%esp)
  105273:	e8 cf b0 ff ff       	call   100347 <cprintf>
}
  105278:	c9                   	leave  
  105279:	c3                   	ret    

0010527a <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  10527a:	55                   	push   %ebp
  10527b:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  10527d:	8b 45 08             	mov    0x8(%ebp),%eax
  105280:	83 e0 04             	and    $0x4,%eax
  105283:	85 c0                	test   %eax,%eax
  105285:	74 07                	je     10528e <perm2str+0x14>
  105287:	b8 75 00 00 00       	mov    $0x75,%eax
  10528c:	eb 05                	jmp    105293 <perm2str+0x19>
  10528e:	b8 2d 00 00 00       	mov    $0x2d,%eax
  105293:	a2 48 89 11 00       	mov    %al,0x118948
    str[1] = 'r';
  105298:	c6 05 49 89 11 00 72 	movb   $0x72,0x118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
  10529f:	8b 45 08             	mov    0x8(%ebp),%eax
  1052a2:	83 e0 02             	and    $0x2,%eax
  1052a5:	85 c0                	test   %eax,%eax
  1052a7:	74 07                	je     1052b0 <perm2str+0x36>
  1052a9:	b8 77 00 00 00       	mov    $0x77,%eax
  1052ae:	eb 05                	jmp    1052b5 <perm2str+0x3b>
  1052b0:	b8 2d 00 00 00       	mov    $0x2d,%eax
  1052b5:	a2 4a 89 11 00       	mov    %al,0x11894a
    str[3] = '\0';
  1052ba:	c6 05 4b 89 11 00 00 	movb   $0x0,0x11894b
    return str;
  1052c1:	b8 48 89 11 00       	mov    $0x118948,%eax
}
  1052c6:	5d                   	pop    %ebp
  1052c7:	c3                   	ret    

001052c8 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  1052c8:	55                   	push   %ebp
  1052c9:	89 e5                	mov    %esp,%ebp
  1052cb:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  1052ce:	8b 45 10             	mov    0x10(%ebp),%eax
  1052d1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1052d4:	72 0e                	jb     1052e4 <get_pgtable_items+0x1c>
        return 0;
  1052d6:	b8 00 00 00 00       	mov    $0x0,%eax
  1052db:	e9 86 00 00 00       	jmp    105366 <get_pgtable_items+0x9e>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  1052e0:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  1052e4:	8b 45 10             	mov    0x10(%ebp),%eax
  1052e7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1052ea:	73 12                	jae    1052fe <get_pgtable_items+0x36>
  1052ec:	8b 45 10             	mov    0x10(%ebp),%eax
  1052ef:	c1 e0 02             	shl    $0x2,%eax
  1052f2:	03 45 14             	add    0x14(%ebp),%eax
  1052f5:	8b 00                	mov    (%eax),%eax
  1052f7:	83 e0 01             	and    $0x1,%eax
  1052fa:	85 c0                	test   %eax,%eax
  1052fc:	74 e2                	je     1052e0 <get_pgtable_items+0x18>
        start ++;
    }
    if (start < right) {
  1052fe:	8b 45 10             	mov    0x10(%ebp),%eax
  105301:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105304:	73 5b                	jae    105361 <get_pgtable_items+0x99>
        if (left_store != NULL) {
  105306:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  10530a:	74 08                	je     105314 <get_pgtable_items+0x4c>
            *left_store = start;
  10530c:	8b 45 18             	mov    0x18(%ebp),%eax
  10530f:	8b 55 10             	mov    0x10(%ebp),%edx
  105312:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  105314:	8b 45 10             	mov    0x10(%ebp),%eax
  105317:	c1 e0 02             	shl    $0x2,%eax
  10531a:	03 45 14             	add    0x14(%ebp),%eax
  10531d:	8b 00                	mov    (%eax),%eax
  10531f:	83 e0 07             	and    $0x7,%eax
  105322:	89 45 fc             	mov    %eax,-0x4(%ebp)
  105325:	83 45 10 01          	addl   $0x1,0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  105329:	eb 04                	jmp    10532f <get_pgtable_items+0x67>
            start ++;
  10532b:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  10532f:	8b 45 10             	mov    0x10(%ebp),%eax
  105332:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105335:	73 17                	jae    10534e <get_pgtable_items+0x86>
  105337:	8b 45 10             	mov    0x10(%ebp),%eax
  10533a:	c1 e0 02             	shl    $0x2,%eax
  10533d:	03 45 14             	add    0x14(%ebp),%eax
  105340:	8b 00                	mov    (%eax),%eax
  105342:	89 c2                	mov    %eax,%edx
  105344:	83 e2 07             	and    $0x7,%edx
  105347:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10534a:	39 c2                	cmp    %eax,%edx
  10534c:	74 dd                	je     10532b <get_pgtable_items+0x63>
            start ++;
        }
        if (right_store != NULL) {
  10534e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105352:	74 08                	je     10535c <get_pgtable_items+0x94>
            *right_store = start;
  105354:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105357:	8b 55 10             	mov    0x10(%ebp),%edx
  10535a:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  10535c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10535f:	eb 05                	jmp    105366 <get_pgtable_items+0x9e>
    }
    return 0;
  105361:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105366:	c9                   	leave  
  105367:	c3                   	ret    

00105368 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  105368:	55                   	push   %ebp
  105369:	89 e5                	mov    %esp,%ebp
  10536b:	57                   	push   %edi
  10536c:	56                   	push   %esi
  10536d:	53                   	push   %ebx
  10536e:	83 ec 5c             	sub    $0x5c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  105371:	c7 04 24 1c 71 10 00 	movl   $0x10711c,(%esp)
  105378:	e8 ca af ff ff       	call   100347 <cprintf>
    size_t left, right = 0, perm;
  10537d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105384:	e9 0b 01 00 00       	jmp    105494 <print_pgdir+0x12c>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  105389:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10538c:	89 04 24             	mov    %eax,(%esp)
  10538f:	e8 e6 fe ff ff       	call   10527a <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  105394:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105397:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10539a:	89 cb                	mov    %ecx,%ebx
  10539c:	29 d3                	sub    %edx,%ebx
  10539e:	89 da                	mov    %ebx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1053a0:	89 d6                	mov    %edx,%esi
  1053a2:	c1 e6 16             	shl    $0x16,%esi
  1053a5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1053a8:	89 d3                	mov    %edx,%ebx
  1053aa:	c1 e3 16             	shl    $0x16,%ebx
  1053ad:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1053b0:	89 d1                	mov    %edx,%ecx
  1053b2:	c1 e1 16             	shl    $0x16,%ecx
  1053b5:	8b 7d dc             	mov    -0x24(%ebp),%edi
  1053b8:	89 7d c4             	mov    %edi,-0x3c(%ebp)
  1053bb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1053be:	8b 7d c4             	mov    -0x3c(%ebp),%edi
  1053c1:	29 d7                	sub    %edx,%edi
  1053c3:	89 fa                	mov    %edi,%edx
  1053c5:	89 44 24 14          	mov    %eax,0x14(%esp)
  1053c9:	89 74 24 10          	mov    %esi,0x10(%esp)
  1053cd:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1053d1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1053d5:	89 54 24 04          	mov    %edx,0x4(%esp)
  1053d9:	c7 04 24 4d 71 10 00 	movl   $0x10714d,(%esp)
  1053e0:	e8 62 af ff ff       	call   100347 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  1053e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1053e8:	c1 e0 0a             	shl    $0xa,%eax
  1053eb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1053ee:	eb 5c                	jmp    10544c <print_pgdir+0xe4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1053f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1053f3:	89 04 24             	mov    %eax,(%esp)
  1053f6:	e8 7f fe ff ff       	call   10527a <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  1053fb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1053fe:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105401:	89 cb                	mov    %ecx,%ebx
  105403:	29 d3                	sub    %edx,%ebx
  105405:	89 da                	mov    %ebx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  105407:	89 d6                	mov    %edx,%esi
  105409:	c1 e6 0c             	shl    $0xc,%esi
  10540c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10540f:	89 d3                	mov    %edx,%ebx
  105411:	c1 e3 0c             	shl    $0xc,%ebx
  105414:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105417:	89 d1                	mov    %edx,%ecx
  105419:	c1 e1 0c             	shl    $0xc,%ecx
  10541c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  10541f:	89 7d c4             	mov    %edi,-0x3c(%ebp)
  105422:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105425:	8b 7d c4             	mov    -0x3c(%ebp),%edi
  105428:	29 d7                	sub    %edx,%edi
  10542a:	89 fa                	mov    %edi,%edx
  10542c:	89 44 24 14          	mov    %eax,0x14(%esp)
  105430:	89 74 24 10          	mov    %esi,0x10(%esp)
  105434:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105438:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  10543c:	89 54 24 04          	mov    %edx,0x4(%esp)
  105440:	c7 04 24 6c 71 10 00 	movl   $0x10716c,(%esp)
  105447:	e8 fb ae ff ff       	call   100347 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  10544c:	8b 15 dc 6b 10 00    	mov    0x106bdc,%edx
  105452:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105455:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105458:	89 ce                	mov    %ecx,%esi
  10545a:	c1 e6 0a             	shl    $0xa,%esi
  10545d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  105460:	89 cb                	mov    %ecx,%ebx
  105462:	c1 e3 0a             	shl    $0xa,%ebx
  105465:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  105468:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  10546c:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  10546f:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  105473:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105477:	89 44 24 08          	mov    %eax,0x8(%esp)
  10547b:	89 74 24 04          	mov    %esi,0x4(%esp)
  10547f:	89 1c 24             	mov    %ebx,(%esp)
  105482:	e8 41 fe ff ff       	call   1052c8 <get_pgtable_items>
  105487:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10548a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10548e:	0f 85 5c ff ff ff    	jne    1053f0 <print_pgdir+0x88>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105494:	8b 15 e0 6b 10 00    	mov    0x106be0,%edx
  10549a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10549d:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  1054a0:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  1054a4:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  1054a7:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  1054ab:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1054af:	89 44 24 08          	mov    %eax,0x8(%esp)
  1054b3:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  1054ba:	00 
  1054bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1054c2:	e8 01 fe ff ff       	call   1052c8 <get_pgtable_items>
  1054c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1054ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1054ce:	0f 85 b5 fe ff ff    	jne    105389 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  1054d4:	c7 04 24 90 71 10 00 	movl   $0x107190,(%esp)
  1054db:	e8 67 ae ff ff       	call   100347 <cprintf>
}
  1054e0:	83 c4 5c             	add    $0x5c,%esp
  1054e3:	5b                   	pop    %ebx
  1054e4:	5e                   	pop    %esi
  1054e5:	5f                   	pop    %edi
  1054e6:	5d                   	pop    %ebp
  1054e7:	c3                   	ret    

001054e8 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1054e8:	55                   	push   %ebp
  1054e9:	89 e5                	mov    %esp,%ebp
  1054eb:	56                   	push   %esi
  1054ec:	53                   	push   %ebx
  1054ed:	83 ec 60             	sub    $0x60,%esp
  1054f0:	8b 45 10             	mov    0x10(%ebp),%eax
  1054f3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1054f6:	8b 45 14             	mov    0x14(%ebp),%eax
  1054f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1054fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1054ff:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105502:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105505:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  105508:	8b 45 18             	mov    0x18(%ebp),%eax
  10550b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10550e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105511:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105514:	89 45 c8             	mov    %eax,-0x38(%ebp)
  105517:	89 55 cc             	mov    %edx,-0x34(%ebp)
  10551a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10551d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  105520:	89 d3                	mov    %edx,%ebx
  105522:	89 c6                	mov    %eax,%esi
  105524:	89 75 e0             	mov    %esi,-0x20(%ebp)
  105527:	89 5d f0             	mov    %ebx,-0x10(%ebp)
  10552a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10552d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105530:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105534:	74 1c                	je     105552 <printnum+0x6a>
  105536:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105539:	ba 00 00 00 00       	mov    $0x0,%edx
  10553e:	f7 75 e4             	divl   -0x1c(%ebp)
  105541:	89 55 f4             	mov    %edx,-0xc(%ebp)
  105544:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105547:	ba 00 00 00 00       	mov    $0x0,%edx
  10554c:	f7 75 e4             	divl   -0x1c(%ebp)
  10554f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105552:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105558:	89 d6                	mov    %edx,%esi
  10555a:	89 c3                	mov    %eax,%ebx
  10555c:	89 f0                	mov    %esi,%eax
  10555e:	89 da                	mov    %ebx,%edx
  105560:	f7 75 e4             	divl   -0x1c(%ebp)
  105563:	89 d3                	mov    %edx,%ebx
  105565:	89 c6                	mov    %eax,%esi
  105567:	89 75 e0             	mov    %esi,-0x20(%ebp)
  10556a:	89 5d dc             	mov    %ebx,-0x24(%ebp)
  10556d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105570:	89 45 c8             	mov    %eax,-0x38(%ebp)
  105573:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105576:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  105579:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10557c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  10557f:	89 c3                	mov    %eax,%ebx
  105581:	89 d6                	mov    %edx,%esi
  105583:	89 5d e8             	mov    %ebx,-0x18(%ebp)
  105586:	89 75 ec             	mov    %esi,-0x14(%ebp)
  105589:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10558c:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  10558f:	8b 45 18             	mov    0x18(%ebp),%eax
  105592:	ba 00 00 00 00       	mov    $0x0,%edx
  105597:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10559a:	77 56                	ja     1055f2 <printnum+0x10a>
  10559c:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10559f:	72 05                	jb     1055a6 <printnum+0xbe>
  1055a1:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1055a4:	77 4c                	ja     1055f2 <printnum+0x10a>
        printnum(putch, putdat, result, base, width - 1, padc);
  1055a6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1055a9:	8d 50 ff             	lea    -0x1(%eax),%edx
  1055ac:	8b 45 20             	mov    0x20(%ebp),%eax
  1055af:	89 44 24 18          	mov    %eax,0x18(%esp)
  1055b3:	89 54 24 14          	mov    %edx,0x14(%esp)
  1055b7:	8b 45 18             	mov    0x18(%ebp),%eax
  1055ba:	89 44 24 10          	mov    %eax,0x10(%esp)
  1055be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1055c1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1055c4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1055c8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1055cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1055d6:	89 04 24             	mov    %eax,(%esp)
  1055d9:	e8 0a ff ff ff       	call   1054e8 <printnum>
  1055de:	eb 1c                	jmp    1055fc <printnum+0x114>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1055e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055e7:	8b 45 20             	mov    0x20(%ebp),%eax
  1055ea:	89 04 24             	mov    %eax,(%esp)
  1055ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1055f0:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  1055f2:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  1055f6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1055fa:	7f e4                	jg     1055e0 <printnum+0xf8>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  1055fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1055ff:	05 44 72 10 00       	add    $0x107244,%eax
  105604:	0f b6 00             	movzbl (%eax),%eax
  105607:	0f be c0             	movsbl %al,%eax
  10560a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10560d:	89 54 24 04          	mov    %edx,0x4(%esp)
  105611:	89 04 24             	mov    %eax,(%esp)
  105614:	8b 45 08             	mov    0x8(%ebp),%eax
  105617:	ff d0                	call   *%eax
}
  105619:	83 c4 60             	add    $0x60,%esp
  10561c:	5b                   	pop    %ebx
  10561d:	5e                   	pop    %esi
  10561e:	5d                   	pop    %ebp
  10561f:	c3                   	ret    

00105620 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  105620:	55                   	push   %ebp
  105621:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105623:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105627:	7e 14                	jle    10563d <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  105629:	8b 45 08             	mov    0x8(%ebp),%eax
  10562c:	8b 00                	mov    (%eax),%eax
  10562e:	8d 48 08             	lea    0x8(%eax),%ecx
  105631:	8b 55 08             	mov    0x8(%ebp),%edx
  105634:	89 0a                	mov    %ecx,(%edx)
  105636:	8b 50 04             	mov    0x4(%eax),%edx
  105639:	8b 00                	mov    (%eax),%eax
  10563b:	eb 30                	jmp    10566d <getuint+0x4d>
    }
    else if (lflag) {
  10563d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105641:	74 16                	je     105659 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  105643:	8b 45 08             	mov    0x8(%ebp),%eax
  105646:	8b 00                	mov    (%eax),%eax
  105648:	8d 48 04             	lea    0x4(%eax),%ecx
  10564b:	8b 55 08             	mov    0x8(%ebp),%edx
  10564e:	89 0a                	mov    %ecx,(%edx)
  105650:	8b 00                	mov    (%eax),%eax
  105652:	ba 00 00 00 00       	mov    $0x0,%edx
  105657:	eb 14                	jmp    10566d <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  105659:	8b 45 08             	mov    0x8(%ebp),%eax
  10565c:	8b 00                	mov    (%eax),%eax
  10565e:	8d 48 04             	lea    0x4(%eax),%ecx
  105661:	8b 55 08             	mov    0x8(%ebp),%edx
  105664:	89 0a                	mov    %ecx,(%edx)
  105666:	8b 00                	mov    (%eax),%eax
  105668:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  10566d:	5d                   	pop    %ebp
  10566e:	c3                   	ret    

0010566f <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  10566f:	55                   	push   %ebp
  105670:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105672:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105676:	7e 14                	jle    10568c <getint+0x1d>
        return va_arg(*ap, long long);
  105678:	8b 45 08             	mov    0x8(%ebp),%eax
  10567b:	8b 00                	mov    (%eax),%eax
  10567d:	8d 48 08             	lea    0x8(%eax),%ecx
  105680:	8b 55 08             	mov    0x8(%ebp),%edx
  105683:	89 0a                	mov    %ecx,(%edx)
  105685:	8b 50 04             	mov    0x4(%eax),%edx
  105688:	8b 00                	mov    (%eax),%eax
  10568a:	eb 30                	jmp    1056bc <getint+0x4d>
    }
    else if (lflag) {
  10568c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105690:	74 16                	je     1056a8 <getint+0x39>
        return va_arg(*ap, long);
  105692:	8b 45 08             	mov    0x8(%ebp),%eax
  105695:	8b 00                	mov    (%eax),%eax
  105697:	8d 48 04             	lea    0x4(%eax),%ecx
  10569a:	8b 55 08             	mov    0x8(%ebp),%edx
  10569d:	89 0a                	mov    %ecx,(%edx)
  10569f:	8b 00                	mov    (%eax),%eax
  1056a1:	89 c2                	mov    %eax,%edx
  1056a3:	c1 fa 1f             	sar    $0x1f,%edx
  1056a6:	eb 14                	jmp    1056bc <getint+0x4d>
    }
    else {
        return va_arg(*ap, int);
  1056a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1056ab:	8b 00                	mov    (%eax),%eax
  1056ad:	8d 48 04             	lea    0x4(%eax),%ecx
  1056b0:	8b 55 08             	mov    0x8(%ebp),%edx
  1056b3:	89 0a                	mov    %ecx,(%edx)
  1056b5:	8b 00                	mov    (%eax),%eax
  1056b7:	89 c2                	mov    %eax,%edx
  1056b9:	c1 fa 1f             	sar    $0x1f,%edx
    }
}
  1056bc:	5d                   	pop    %ebp
  1056bd:	c3                   	ret    

001056be <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1056be:	55                   	push   %ebp
  1056bf:	89 e5                	mov    %esp,%ebp
  1056c1:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  1056c4:	8d 55 14             	lea    0x14(%ebp),%edx
  1056c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1056ca:	89 10                	mov    %edx,(%eax)
    vprintfmt(putch, putdat, fmt, ap);
  1056cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1056cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1056d3:	8b 45 10             	mov    0x10(%ebp),%eax
  1056d6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1056da:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1056e4:	89 04 24             	mov    %eax,(%esp)
  1056e7:	e8 02 00 00 00       	call   1056ee <vprintfmt>
    va_end(ap);
}
  1056ec:	c9                   	leave  
  1056ed:	c3                   	ret    

001056ee <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1056ee:	55                   	push   %ebp
  1056ef:	89 e5                	mov    %esp,%ebp
  1056f1:	56                   	push   %esi
  1056f2:	53                   	push   %ebx
  1056f3:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1056f6:	eb 17                	jmp    10570f <vprintfmt+0x21>
            if (ch == '\0') {
  1056f8:	85 db                	test   %ebx,%ebx
  1056fa:	0f 84 db 03 00 00    	je     105adb <vprintfmt+0x3ed>
                return;
            }
            putch(ch, putdat);
  105700:	8b 45 0c             	mov    0xc(%ebp),%eax
  105703:	89 44 24 04          	mov    %eax,0x4(%esp)
  105707:	89 1c 24             	mov    %ebx,(%esp)
  10570a:	8b 45 08             	mov    0x8(%ebp),%eax
  10570d:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10570f:	8b 45 10             	mov    0x10(%ebp),%eax
  105712:	0f b6 00             	movzbl (%eax),%eax
  105715:	0f b6 d8             	movzbl %al,%ebx
  105718:	83 fb 25             	cmp    $0x25,%ebx
  10571b:	0f 95 c0             	setne  %al
  10571e:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  105722:	84 c0                	test   %al,%al
  105724:	75 d2                	jne    1056f8 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  105726:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  10572a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  105731:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105734:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  105737:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10573e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105741:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105744:	eb 04                	jmp    10574a <vprintfmt+0x5c>
            goto process_precision;

        case '.':
            if (width < 0)
                width = 0;
            goto reswitch;
  105746:	90                   	nop
  105747:	eb 01                	jmp    10574a <vprintfmt+0x5c>
            goto reswitch;

        process_precision:
            if (width < 0)
                width = precision, precision = -1;
            goto reswitch;
  105749:	90                   	nop
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  10574a:	8b 45 10             	mov    0x10(%ebp),%eax
  10574d:	0f b6 00             	movzbl (%eax),%eax
  105750:	0f b6 d8             	movzbl %al,%ebx
  105753:	89 d8                	mov    %ebx,%eax
  105755:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  105759:	83 e8 23             	sub    $0x23,%eax
  10575c:	83 f8 55             	cmp    $0x55,%eax
  10575f:	0f 87 45 03 00 00    	ja     105aaa <vprintfmt+0x3bc>
  105765:	8b 04 85 68 72 10 00 	mov    0x107268(,%eax,4),%eax
  10576c:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  10576e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105772:	eb d6                	jmp    10574a <vprintfmt+0x5c>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  105774:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105778:	eb d0                	jmp    10574a <vprintfmt+0x5c>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10577a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  105781:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105784:	89 d0                	mov    %edx,%eax
  105786:	c1 e0 02             	shl    $0x2,%eax
  105789:	01 d0                	add    %edx,%eax
  10578b:	01 c0                	add    %eax,%eax
  10578d:	01 d8                	add    %ebx,%eax
  10578f:	83 e8 30             	sub    $0x30,%eax
  105792:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  105795:	8b 45 10             	mov    0x10(%ebp),%eax
  105798:	0f b6 00             	movzbl (%eax),%eax
  10579b:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  10579e:	83 fb 2f             	cmp    $0x2f,%ebx
  1057a1:	7e 39                	jle    1057dc <vprintfmt+0xee>
  1057a3:	83 fb 39             	cmp    $0x39,%ebx
  1057a6:	7f 34                	jg     1057dc <vprintfmt+0xee>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1057a8:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  1057ac:	eb d3                	jmp    105781 <vprintfmt+0x93>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  1057ae:	8b 45 14             	mov    0x14(%ebp),%eax
  1057b1:	8d 50 04             	lea    0x4(%eax),%edx
  1057b4:	89 55 14             	mov    %edx,0x14(%ebp)
  1057b7:	8b 00                	mov    (%eax),%eax
  1057b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1057bc:	eb 1f                	jmp    1057dd <vprintfmt+0xef>

        case '.':
            if (width < 0)
  1057be:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1057c2:	79 82                	jns    105746 <vprintfmt+0x58>
                width = 0;
  1057c4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1057cb:	e9 76 ff ff ff       	jmp    105746 <vprintfmt+0x58>

        case '#':
            altflag = 1;
  1057d0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1057d7:	e9 6e ff ff ff       	jmp    10574a <vprintfmt+0x5c>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
  1057dc:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
  1057dd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1057e1:	0f 89 62 ff ff ff    	jns    105749 <vprintfmt+0x5b>
                width = precision, precision = -1;
  1057e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1057ea:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1057ed:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1057f4:	e9 50 ff ff ff       	jmp    105749 <vprintfmt+0x5b>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1057f9:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  1057fd:	e9 48 ff ff ff       	jmp    10574a <vprintfmt+0x5c>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  105802:	8b 45 14             	mov    0x14(%ebp),%eax
  105805:	8d 50 04             	lea    0x4(%eax),%edx
  105808:	89 55 14             	mov    %edx,0x14(%ebp)
  10580b:	8b 00                	mov    (%eax),%eax
  10580d:	8b 55 0c             	mov    0xc(%ebp),%edx
  105810:	89 54 24 04          	mov    %edx,0x4(%esp)
  105814:	89 04 24             	mov    %eax,(%esp)
  105817:	8b 45 08             	mov    0x8(%ebp),%eax
  10581a:	ff d0                	call   *%eax
            break;
  10581c:	e9 b4 02 00 00       	jmp    105ad5 <vprintfmt+0x3e7>

        // error message
        case 'e':
            err = va_arg(ap, int);
  105821:	8b 45 14             	mov    0x14(%ebp),%eax
  105824:	8d 50 04             	lea    0x4(%eax),%edx
  105827:	89 55 14             	mov    %edx,0x14(%ebp)
  10582a:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  10582c:	85 db                	test   %ebx,%ebx
  10582e:	79 02                	jns    105832 <vprintfmt+0x144>
                err = -err;
  105830:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  105832:	83 fb 06             	cmp    $0x6,%ebx
  105835:	7f 0b                	jg     105842 <vprintfmt+0x154>
  105837:	8b 34 9d 28 72 10 00 	mov    0x107228(,%ebx,4),%esi
  10583e:	85 f6                	test   %esi,%esi
  105840:	75 23                	jne    105865 <vprintfmt+0x177>
                printfmt(putch, putdat, "error %d", err);
  105842:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105846:	c7 44 24 08 55 72 10 	movl   $0x107255,0x8(%esp)
  10584d:	00 
  10584e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105851:	89 44 24 04          	mov    %eax,0x4(%esp)
  105855:	8b 45 08             	mov    0x8(%ebp),%eax
  105858:	89 04 24             	mov    %eax,(%esp)
  10585b:	e8 5e fe ff ff       	call   1056be <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105860:	e9 70 02 00 00       	jmp    105ad5 <vprintfmt+0x3e7>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  105865:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105869:	c7 44 24 08 5e 72 10 	movl   $0x10725e,0x8(%esp)
  105870:	00 
  105871:	8b 45 0c             	mov    0xc(%ebp),%eax
  105874:	89 44 24 04          	mov    %eax,0x4(%esp)
  105878:	8b 45 08             	mov    0x8(%ebp),%eax
  10587b:	89 04 24             	mov    %eax,(%esp)
  10587e:	e8 3b fe ff ff       	call   1056be <printfmt>
            }
            break;
  105883:	e9 4d 02 00 00       	jmp    105ad5 <vprintfmt+0x3e7>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  105888:	8b 45 14             	mov    0x14(%ebp),%eax
  10588b:	8d 50 04             	lea    0x4(%eax),%edx
  10588e:	89 55 14             	mov    %edx,0x14(%ebp)
  105891:	8b 30                	mov    (%eax),%esi
  105893:	85 f6                	test   %esi,%esi
  105895:	75 05                	jne    10589c <vprintfmt+0x1ae>
                p = "(null)";
  105897:	be 61 72 10 00       	mov    $0x107261,%esi
            }
            if (width > 0 && padc != '-') {
  10589c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1058a0:	7e 7c                	jle    10591e <vprintfmt+0x230>
  1058a2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1058a6:	74 76                	je     10591e <vprintfmt+0x230>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1058a8:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  1058ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1058ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058b2:	89 34 24             	mov    %esi,(%esp)
  1058b5:	e8 21 03 00 00       	call   105bdb <strnlen>
  1058ba:	89 da                	mov    %ebx,%edx
  1058bc:	29 c2                	sub    %eax,%edx
  1058be:	89 d0                	mov    %edx,%eax
  1058c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1058c3:	eb 17                	jmp    1058dc <vprintfmt+0x1ee>
                    putch(padc, putdat);
  1058c5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1058c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1058cc:	89 54 24 04          	mov    %edx,0x4(%esp)
  1058d0:	89 04 24             	mov    %eax,(%esp)
  1058d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1058d6:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  1058d8:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1058dc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1058e0:	7f e3                	jg     1058c5 <vprintfmt+0x1d7>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1058e2:	eb 3a                	jmp    10591e <vprintfmt+0x230>
                if (altflag && (ch < ' ' || ch > '~')) {
  1058e4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1058e8:	74 1f                	je     105909 <vprintfmt+0x21b>
  1058ea:	83 fb 1f             	cmp    $0x1f,%ebx
  1058ed:	7e 05                	jle    1058f4 <vprintfmt+0x206>
  1058ef:	83 fb 7e             	cmp    $0x7e,%ebx
  1058f2:	7e 15                	jle    105909 <vprintfmt+0x21b>
                    putch('?', putdat);
  1058f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058fb:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  105902:	8b 45 08             	mov    0x8(%ebp),%eax
  105905:	ff d0                	call   *%eax
  105907:	eb 0f                	jmp    105918 <vprintfmt+0x22a>
                }
                else {
                    putch(ch, putdat);
  105909:	8b 45 0c             	mov    0xc(%ebp),%eax
  10590c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105910:	89 1c 24             	mov    %ebx,(%esp)
  105913:	8b 45 08             	mov    0x8(%ebp),%eax
  105916:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105918:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10591c:	eb 01                	jmp    10591f <vprintfmt+0x231>
  10591e:	90                   	nop
  10591f:	0f b6 06             	movzbl (%esi),%eax
  105922:	0f be d8             	movsbl %al,%ebx
  105925:	85 db                	test   %ebx,%ebx
  105927:	0f 95 c0             	setne  %al
  10592a:	83 c6 01             	add    $0x1,%esi
  10592d:	84 c0                	test   %al,%al
  10592f:	74 29                	je     10595a <vprintfmt+0x26c>
  105931:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105935:	78 ad                	js     1058e4 <vprintfmt+0x1f6>
  105937:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  10593b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10593f:	79 a3                	jns    1058e4 <vprintfmt+0x1f6>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105941:	eb 17                	jmp    10595a <vprintfmt+0x26c>
                putch(' ', putdat);
  105943:	8b 45 0c             	mov    0xc(%ebp),%eax
  105946:	89 44 24 04          	mov    %eax,0x4(%esp)
  10594a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  105951:	8b 45 08             	mov    0x8(%ebp),%eax
  105954:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105956:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10595a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10595e:	7f e3                	jg     105943 <vprintfmt+0x255>
                putch(' ', putdat);
            }
            break;
  105960:	e9 70 01 00 00       	jmp    105ad5 <vprintfmt+0x3e7>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105965:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105968:	89 44 24 04          	mov    %eax,0x4(%esp)
  10596c:	8d 45 14             	lea    0x14(%ebp),%eax
  10596f:	89 04 24             	mov    %eax,(%esp)
  105972:	e8 f8 fc ff ff       	call   10566f <getint>
  105977:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10597a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  10597d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105980:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105983:	85 d2                	test   %edx,%edx
  105985:	79 26                	jns    1059ad <vprintfmt+0x2bf>
                putch('-', putdat);
  105987:	8b 45 0c             	mov    0xc(%ebp),%eax
  10598a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10598e:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  105995:	8b 45 08             	mov    0x8(%ebp),%eax
  105998:	ff d0                	call   *%eax
                num = -(long long)num;
  10599a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10599d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1059a0:	f7 d8                	neg    %eax
  1059a2:	83 d2 00             	adc    $0x0,%edx
  1059a5:	f7 da                	neg    %edx
  1059a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1059aa:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1059ad:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1059b4:	e9 a8 00 00 00       	jmp    105a61 <vprintfmt+0x373>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1059b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1059bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059c0:	8d 45 14             	lea    0x14(%ebp),%eax
  1059c3:	89 04 24             	mov    %eax,(%esp)
  1059c6:	e8 55 fc ff ff       	call   105620 <getuint>
  1059cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1059ce:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1059d1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1059d8:	e9 84 00 00 00       	jmp    105a61 <vprintfmt+0x373>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1059dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1059e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059e4:	8d 45 14             	lea    0x14(%ebp),%eax
  1059e7:	89 04 24             	mov    %eax,(%esp)
  1059ea:	e8 31 fc ff ff       	call   105620 <getuint>
  1059ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1059f2:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1059f5:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  1059fc:	eb 63                	jmp    105a61 <vprintfmt+0x373>

        // pointer
        case 'p':
            putch('0', putdat);
  1059fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a01:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a05:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  105a0f:	ff d0                	call   *%eax
            putch('x', putdat);
  105a11:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a14:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a18:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  105a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  105a22:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105a24:	8b 45 14             	mov    0x14(%ebp),%eax
  105a27:	8d 50 04             	lea    0x4(%eax),%edx
  105a2a:	89 55 14             	mov    %edx,0x14(%ebp)
  105a2d:	8b 00                	mov    (%eax),%eax
  105a2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a32:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105a39:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105a40:	eb 1f                	jmp    105a61 <vprintfmt+0x373>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105a42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105a45:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a49:	8d 45 14             	lea    0x14(%ebp),%eax
  105a4c:	89 04 24             	mov    %eax,(%esp)
  105a4f:	e8 cc fb ff ff       	call   105620 <getuint>
  105a54:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a57:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105a5a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105a61:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105a65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105a68:	89 54 24 18          	mov    %edx,0x18(%esp)
  105a6c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105a6f:	89 54 24 14          	mov    %edx,0x14(%esp)
  105a73:	89 44 24 10          	mov    %eax,0x10(%esp)
  105a77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105a7d:	89 44 24 08          	mov    %eax,0x8(%esp)
  105a81:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105a85:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a88:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  105a8f:	89 04 24             	mov    %eax,(%esp)
  105a92:	e8 51 fa ff ff       	call   1054e8 <printnum>
            break;
  105a97:	eb 3c                	jmp    105ad5 <vprintfmt+0x3e7>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105a99:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105aa0:	89 1c 24             	mov    %ebx,(%esp)
  105aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  105aa6:	ff d0                	call   *%eax
            break;
  105aa8:	eb 2b                	jmp    105ad5 <vprintfmt+0x3e7>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105aaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  105aad:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ab1:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  105ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  105abb:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  105abd:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105ac1:	eb 04                	jmp    105ac7 <vprintfmt+0x3d9>
  105ac3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105ac7:	8b 45 10             	mov    0x10(%ebp),%eax
  105aca:	83 e8 01             	sub    $0x1,%eax
  105acd:	0f b6 00             	movzbl (%eax),%eax
  105ad0:	3c 25                	cmp    $0x25,%al
  105ad2:	75 ef                	jne    105ac3 <vprintfmt+0x3d5>
                /* do nothing */;
            break;
  105ad4:	90                   	nop
        }
    }
  105ad5:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105ad6:	e9 34 fc ff ff       	jmp    10570f <vprintfmt+0x21>
            if (ch == '\0') {
                return;
  105adb:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  105adc:	83 c4 40             	add    $0x40,%esp
  105adf:	5b                   	pop    %ebx
  105ae0:	5e                   	pop    %esi
  105ae1:	5d                   	pop    %ebp
  105ae2:	c3                   	ret    

00105ae3 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105ae3:	55                   	push   %ebp
  105ae4:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105ae6:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ae9:	8b 40 08             	mov    0x8(%eax),%eax
  105aec:	8d 50 01             	lea    0x1(%eax),%edx
  105aef:	8b 45 0c             	mov    0xc(%ebp),%eax
  105af2:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105af5:	8b 45 0c             	mov    0xc(%ebp),%eax
  105af8:	8b 10                	mov    (%eax),%edx
  105afa:	8b 45 0c             	mov    0xc(%ebp),%eax
  105afd:	8b 40 04             	mov    0x4(%eax),%eax
  105b00:	39 c2                	cmp    %eax,%edx
  105b02:	73 12                	jae    105b16 <sprintputch+0x33>
        *b->buf ++ = ch;
  105b04:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b07:	8b 00                	mov    (%eax),%eax
  105b09:	8b 55 08             	mov    0x8(%ebp),%edx
  105b0c:	88 10                	mov    %dl,(%eax)
  105b0e:	8d 50 01             	lea    0x1(%eax),%edx
  105b11:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b14:	89 10                	mov    %edx,(%eax)
    }
}
  105b16:	5d                   	pop    %ebp
  105b17:	c3                   	ret    

00105b18 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105b18:	55                   	push   %ebp
  105b19:	89 e5                	mov    %esp,%ebp
  105b1b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105b1e:	8d 55 14             	lea    0x14(%ebp),%edx
  105b21:	8d 45 f0             	lea    -0x10(%ebp),%eax
  105b24:	89 10                	mov    %edx,(%eax)
    cnt = vsnprintf(str, size, fmt, ap);
  105b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b29:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105b2d:	8b 45 10             	mov    0x10(%ebp),%eax
  105b30:	89 44 24 08          	mov    %eax,0x8(%esp)
  105b34:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b37:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  105b3e:	89 04 24             	mov    %eax,(%esp)
  105b41:	e8 08 00 00 00       	call   105b4e <vsnprintf>
  105b46:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105b4c:	c9                   	leave  
  105b4d:	c3                   	ret    

00105b4e <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105b4e:	55                   	push   %ebp
  105b4f:	89 e5                	mov    %esp,%ebp
  105b51:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105b54:	8b 45 08             	mov    0x8(%ebp),%eax
  105b57:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105b5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b5d:	83 e8 01             	sub    $0x1,%eax
  105b60:	03 45 08             	add    0x8(%ebp),%eax
  105b63:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105b6d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105b71:	74 0a                	je     105b7d <vsnprintf+0x2f>
  105b73:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105b76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b79:	39 c2                	cmp    %eax,%edx
  105b7b:	76 07                	jbe    105b84 <vsnprintf+0x36>
        return -E_INVAL;
  105b7d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105b82:	eb 2a                	jmp    105bae <vsnprintf+0x60>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105b84:	8b 45 14             	mov    0x14(%ebp),%eax
  105b87:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105b8b:	8b 45 10             	mov    0x10(%ebp),%eax
  105b8e:	89 44 24 08          	mov    %eax,0x8(%esp)
  105b92:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105b95:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b99:	c7 04 24 e3 5a 10 00 	movl   $0x105ae3,(%esp)
  105ba0:	e8 49 fb ff ff       	call   1056ee <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105ba5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105ba8:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105bae:	c9                   	leave  
  105baf:	c3                   	ret    

00105bb0 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105bb0:	55                   	push   %ebp
  105bb1:	89 e5                	mov    %esp,%ebp
  105bb3:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105bb6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105bbd:	eb 04                	jmp    105bc3 <strlen+0x13>
        cnt ++;
  105bbf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  105bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  105bc6:	0f b6 00             	movzbl (%eax),%eax
  105bc9:	84 c0                	test   %al,%al
  105bcb:	0f 95 c0             	setne  %al
  105bce:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105bd2:	84 c0                	test   %al,%al
  105bd4:	75 e9                	jne    105bbf <strlen+0xf>
        cnt ++;
    }
    return cnt;
  105bd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105bd9:	c9                   	leave  
  105bda:	c3                   	ret    

00105bdb <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105bdb:	55                   	push   %ebp
  105bdc:	89 e5                	mov    %esp,%ebp
  105bde:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105be1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105be8:	eb 04                	jmp    105bee <strnlen+0x13>
        cnt ++;
  105bea:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  105bee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105bf1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105bf4:	73 13                	jae    105c09 <strnlen+0x2e>
  105bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  105bf9:	0f b6 00             	movzbl (%eax),%eax
  105bfc:	84 c0                	test   %al,%al
  105bfe:	0f 95 c0             	setne  %al
  105c01:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105c05:	84 c0                	test   %al,%al
  105c07:	75 e1                	jne    105bea <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  105c09:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105c0c:	c9                   	leave  
  105c0d:	c3                   	ret    

00105c0e <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105c0e:	55                   	push   %ebp
  105c0f:	89 e5                	mov    %esp,%ebp
  105c11:	57                   	push   %edi
  105c12:	56                   	push   %esi
  105c13:	53                   	push   %ebx
  105c14:	83 ec 24             	sub    $0x24,%esp
  105c17:	8b 45 08             	mov    0x8(%ebp),%eax
  105c1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105c1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c20:	89 45 ec             	mov    %eax,-0x14(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105c23:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105c26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105c29:	89 d6                	mov    %edx,%esi
  105c2b:	89 c3                	mov    %eax,%ebx
  105c2d:	89 df                	mov    %ebx,%edi
  105c2f:	ac                   	lods   %ds:(%esi),%al
  105c30:	aa                   	stos   %al,%es:(%edi)
  105c31:	84 c0                	test   %al,%al
  105c33:	75 fa                	jne    105c2f <strcpy+0x21>
  105c35:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105c38:	89 fb                	mov    %edi,%ebx
  105c3a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  105c3d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  105c40:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105c43:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105c49:	83 c4 24             	add    $0x24,%esp
  105c4c:	5b                   	pop    %ebx
  105c4d:	5e                   	pop    %esi
  105c4e:	5f                   	pop    %edi
  105c4f:	5d                   	pop    %ebp
  105c50:	c3                   	ret    

00105c51 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105c51:	55                   	push   %ebp
  105c52:	89 e5                	mov    %esp,%ebp
  105c54:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105c57:	8b 45 08             	mov    0x8(%ebp),%eax
  105c5a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105c5d:	eb 21                	jmp    105c80 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  105c5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c62:	0f b6 10             	movzbl (%eax),%edx
  105c65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105c68:	88 10                	mov    %dl,(%eax)
  105c6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105c6d:	0f b6 00             	movzbl (%eax),%eax
  105c70:	84 c0                	test   %al,%al
  105c72:	74 04                	je     105c78 <strncpy+0x27>
            src ++;
  105c74:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105c78:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105c7c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  105c80:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105c84:	75 d9                	jne    105c5f <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  105c86:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105c89:	c9                   	leave  
  105c8a:	c3                   	ret    

00105c8b <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105c8b:	55                   	push   %ebp
  105c8c:	89 e5                	mov    %esp,%ebp
  105c8e:	57                   	push   %edi
  105c8f:	56                   	push   %esi
  105c90:	53                   	push   %ebx
  105c91:	83 ec 24             	sub    $0x24,%esp
  105c94:	8b 45 08             	mov    0x8(%ebp),%eax
  105c97:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105c9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c9d:	89 45 ec             	mov    %eax,-0x14(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  105ca0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105ca3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105ca6:	89 d6                	mov    %edx,%esi
  105ca8:	89 c3                	mov    %eax,%ebx
  105caa:	89 df                	mov    %ebx,%edi
  105cac:	ac                   	lods   %ds:(%esi),%al
  105cad:	ae                   	scas   %es:(%edi),%al
  105cae:	75 08                	jne    105cb8 <strcmp+0x2d>
  105cb0:	84 c0                	test   %al,%al
  105cb2:	75 f8                	jne    105cac <strcmp+0x21>
  105cb4:	31 c0                	xor    %eax,%eax
  105cb6:	eb 04                	jmp    105cbc <strcmp+0x31>
  105cb8:	19 c0                	sbb    %eax,%eax
  105cba:	0c 01                	or     $0x1,%al
  105cbc:	89 fb                	mov    %edi,%ebx
  105cbe:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105cc1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105cc4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105cc7:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  105cca:	89 5d e0             	mov    %ebx,-0x20(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  105ccd:	8b 45 e8             	mov    -0x18(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105cd0:	83 c4 24             	add    $0x24,%esp
  105cd3:	5b                   	pop    %ebx
  105cd4:	5e                   	pop    %esi
  105cd5:	5f                   	pop    %edi
  105cd6:	5d                   	pop    %ebp
  105cd7:	c3                   	ret    

00105cd8 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105cd8:	55                   	push   %ebp
  105cd9:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105cdb:	eb 0c                	jmp    105ce9 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105cdd:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105ce1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105ce5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105ce9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105ced:	74 1a                	je     105d09 <strncmp+0x31>
  105cef:	8b 45 08             	mov    0x8(%ebp),%eax
  105cf2:	0f b6 00             	movzbl (%eax),%eax
  105cf5:	84 c0                	test   %al,%al
  105cf7:	74 10                	je     105d09 <strncmp+0x31>
  105cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  105cfc:	0f b6 10             	movzbl (%eax),%edx
  105cff:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d02:	0f b6 00             	movzbl (%eax),%eax
  105d05:	38 c2                	cmp    %al,%dl
  105d07:	74 d4                	je     105cdd <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105d09:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d0d:	74 1a                	je     105d29 <strncmp+0x51>
  105d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  105d12:	0f b6 00             	movzbl (%eax),%eax
  105d15:	0f b6 d0             	movzbl %al,%edx
  105d18:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d1b:	0f b6 00             	movzbl (%eax),%eax
  105d1e:	0f b6 c0             	movzbl %al,%eax
  105d21:	89 d1                	mov    %edx,%ecx
  105d23:	29 c1                	sub    %eax,%ecx
  105d25:	89 c8                	mov    %ecx,%eax
  105d27:	eb 05                	jmp    105d2e <strncmp+0x56>
  105d29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105d2e:	5d                   	pop    %ebp
  105d2f:	c3                   	ret    

00105d30 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105d30:	55                   	push   %ebp
  105d31:	89 e5                	mov    %esp,%ebp
  105d33:	83 ec 04             	sub    $0x4,%esp
  105d36:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d39:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105d3c:	eb 14                	jmp    105d52 <strchr+0x22>
        if (*s == c) {
  105d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  105d41:	0f b6 00             	movzbl (%eax),%eax
  105d44:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105d47:	75 05                	jne    105d4e <strchr+0x1e>
            return (char *)s;
  105d49:	8b 45 08             	mov    0x8(%ebp),%eax
  105d4c:	eb 13                	jmp    105d61 <strchr+0x31>
        }
        s ++;
  105d4e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  105d52:	8b 45 08             	mov    0x8(%ebp),%eax
  105d55:	0f b6 00             	movzbl (%eax),%eax
  105d58:	84 c0                	test   %al,%al
  105d5a:	75 e2                	jne    105d3e <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105d5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105d61:	c9                   	leave  
  105d62:	c3                   	ret    

00105d63 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105d63:	55                   	push   %ebp
  105d64:	89 e5                	mov    %esp,%ebp
  105d66:	83 ec 04             	sub    $0x4,%esp
  105d69:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d6c:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105d6f:	eb 0f                	jmp    105d80 <strfind+0x1d>
        if (*s == c) {
  105d71:	8b 45 08             	mov    0x8(%ebp),%eax
  105d74:	0f b6 00             	movzbl (%eax),%eax
  105d77:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105d7a:	74 10                	je     105d8c <strfind+0x29>
            break;
        }
        s ++;
  105d7c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  105d80:	8b 45 08             	mov    0x8(%ebp),%eax
  105d83:	0f b6 00             	movzbl (%eax),%eax
  105d86:	84 c0                	test   %al,%al
  105d88:	75 e7                	jne    105d71 <strfind+0xe>
  105d8a:	eb 01                	jmp    105d8d <strfind+0x2a>
        if (*s == c) {
            break;
  105d8c:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
  105d8d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105d90:	c9                   	leave  
  105d91:	c3                   	ret    

00105d92 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105d92:	55                   	push   %ebp
  105d93:	89 e5                	mov    %esp,%ebp
  105d95:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105d98:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105d9f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105da6:	eb 04                	jmp    105dac <strtol+0x1a>
        s ++;
  105da8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105dac:	8b 45 08             	mov    0x8(%ebp),%eax
  105daf:	0f b6 00             	movzbl (%eax),%eax
  105db2:	3c 20                	cmp    $0x20,%al
  105db4:	74 f2                	je     105da8 <strtol+0x16>
  105db6:	8b 45 08             	mov    0x8(%ebp),%eax
  105db9:	0f b6 00             	movzbl (%eax),%eax
  105dbc:	3c 09                	cmp    $0x9,%al
  105dbe:	74 e8                	je     105da8 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  105dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  105dc3:	0f b6 00             	movzbl (%eax),%eax
  105dc6:	3c 2b                	cmp    $0x2b,%al
  105dc8:	75 06                	jne    105dd0 <strtol+0x3e>
        s ++;
  105dca:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105dce:	eb 15                	jmp    105de5 <strtol+0x53>
    }
    else if (*s == '-') {
  105dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  105dd3:	0f b6 00             	movzbl (%eax),%eax
  105dd6:	3c 2d                	cmp    $0x2d,%al
  105dd8:	75 0b                	jne    105de5 <strtol+0x53>
        s ++, neg = 1;
  105dda:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105dde:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105de5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105de9:	74 06                	je     105df1 <strtol+0x5f>
  105deb:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105def:	75 24                	jne    105e15 <strtol+0x83>
  105df1:	8b 45 08             	mov    0x8(%ebp),%eax
  105df4:	0f b6 00             	movzbl (%eax),%eax
  105df7:	3c 30                	cmp    $0x30,%al
  105df9:	75 1a                	jne    105e15 <strtol+0x83>
  105dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  105dfe:	83 c0 01             	add    $0x1,%eax
  105e01:	0f b6 00             	movzbl (%eax),%eax
  105e04:	3c 78                	cmp    $0x78,%al
  105e06:	75 0d                	jne    105e15 <strtol+0x83>
        s += 2, base = 16;
  105e08:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105e0c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105e13:	eb 2a                	jmp    105e3f <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  105e15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105e19:	75 17                	jne    105e32 <strtol+0xa0>
  105e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  105e1e:	0f b6 00             	movzbl (%eax),%eax
  105e21:	3c 30                	cmp    $0x30,%al
  105e23:	75 0d                	jne    105e32 <strtol+0xa0>
        s ++, base = 8;
  105e25:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105e29:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105e30:	eb 0d                	jmp    105e3f <strtol+0xad>
    }
    else if (base == 0) {
  105e32:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105e36:	75 07                	jne    105e3f <strtol+0xad>
        base = 10;
  105e38:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  105e42:	0f b6 00             	movzbl (%eax),%eax
  105e45:	3c 2f                	cmp    $0x2f,%al
  105e47:	7e 1b                	jle    105e64 <strtol+0xd2>
  105e49:	8b 45 08             	mov    0x8(%ebp),%eax
  105e4c:	0f b6 00             	movzbl (%eax),%eax
  105e4f:	3c 39                	cmp    $0x39,%al
  105e51:	7f 11                	jg     105e64 <strtol+0xd2>
            dig = *s - '0';
  105e53:	8b 45 08             	mov    0x8(%ebp),%eax
  105e56:	0f b6 00             	movzbl (%eax),%eax
  105e59:	0f be c0             	movsbl %al,%eax
  105e5c:	83 e8 30             	sub    $0x30,%eax
  105e5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105e62:	eb 48                	jmp    105eac <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105e64:	8b 45 08             	mov    0x8(%ebp),%eax
  105e67:	0f b6 00             	movzbl (%eax),%eax
  105e6a:	3c 60                	cmp    $0x60,%al
  105e6c:	7e 1b                	jle    105e89 <strtol+0xf7>
  105e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  105e71:	0f b6 00             	movzbl (%eax),%eax
  105e74:	3c 7a                	cmp    $0x7a,%al
  105e76:	7f 11                	jg     105e89 <strtol+0xf7>
            dig = *s - 'a' + 10;
  105e78:	8b 45 08             	mov    0x8(%ebp),%eax
  105e7b:	0f b6 00             	movzbl (%eax),%eax
  105e7e:	0f be c0             	movsbl %al,%eax
  105e81:	83 e8 57             	sub    $0x57,%eax
  105e84:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105e87:	eb 23                	jmp    105eac <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105e89:	8b 45 08             	mov    0x8(%ebp),%eax
  105e8c:	0f b6 00             	movzbl (%eax),%eax
  105e8f:	3c 40                	cmp    $0x40,%al
  105e91:	7e 38                	jle    105ecb <strtol+0x139>
  105e93:	8b 45 08             	mov    0x8(%ebp),%eax
  105e96:	0f b6 00             	movzbl (%eax),%eax
  105e99:	3c 5a                	cmp    $0x5a,%al
  105e9b:	7f 2e                	jg     105ecb <strtol+0x139>
            dig = *s - 'A' + 10;
  105e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  105ea0:	0f b6 00             	movzbl (%eax),%eax
  105ea3:	0f be c0             	movsbl %al,%eax
  105ea6:	83 e8 37             	sub    $0x37,%eax
  105ea9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105eaf:	3b 45 10             	cmp    0x10(%ebp),%eax
  105eb2:	7d 16                	jge    105eca <strtol+0x138>
            break;
        }
        s ++, val = (val * base) + dig;
  105eb4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105eb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105ebb:	0f af 45 10          	imul   0x10(%ebp),%eax
  105ebf:	03 45 f4             	add    -0xc(%ebp),%eax
  105ec2:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  105ec5:	e9 75 ff ff ff       	jmp    105e3f <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
  105eca:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
  105ecb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105ecf:	74 08                	je     105ed9 <strtol+0x147>
        *endptr = (char *) s;
  105ed1:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ed4:	8b 55 08             	mov    0x8(%ebp),%edx
  105ed7:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105ed9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105edd:	74 07                	je     105ee6 <strtol+0x154>
  105edf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105ee2:	f7 d8                	neg    %eax
  105ee4:	eb 03                	jmp    105ee9 <strtol+0x157>
  105ee6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105ee9:	c9                   	leave  
  105eea:	c3                   	ret    

00105eeb <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105eeb:	55                   	push   %ebp
  105eec:	89 e5                	mov    %esp,%ebp
  105eee:	57                   	push   %edi
  105eef:	56                   	push   %esi
  105ef0:	53                   	push   %ebx
  105ef1:	83 ec 24             	sub    $0x24,%esp
  105ef4:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ef7:	88 45 d0             	mov    %al,-0x30(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105efa:	0f be 45 d0          	movsbl -0x30(%ebp),%eax
  105efe:	8b 55 08             	mov    0x8(%ebp),%edx
  105f01:	89 55 f0             	mov    %edx,-0x10(%ebp)
  105f04:	88 45 ef             	mov    %al,-0x11(%ebp)
  105f07:	8b 45 10             	mov    0x10(%ebp),%eax
  105f0a:	89 45 e8             	mov    %eax,-0x18(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105f0d:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  105f10:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  105f14:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105f17:	89 ce                	mov    %ecx,%esi
  105f19:	89 d3                	mov    %edx,%ebx
  105f1b:	89 f1                	mov    %esi,%ecx
  105f1d:	89 df                	mov    %ebx,%edi
  105f1f:	f3 aa                	rep stos %al,%es:(%edi)
  105f21:	89 fb                	mov    %edi,%ebx
  105f23:	89 ce                	mov    %ecx,%esi
  105f25:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  105f28:	89 5d e0             	mov    %ebx,-0x20(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105f2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105f2e:	83 c4 24             	add    $0x24,%esp
  105f31:	5b                   	pop    %ebx
  105f32:	5e                   	pop    %esi
  105f33:	5f                   	pop    %edi
  105f34:	5d                   	pop    %ebp
  105f35:	c3                   	ret    

00105f36 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105f36:	55                   	push   %ebp
  105f37:	89 e5                	mov    %esp,%ebp
  105f39:	57                   	push   %edi
  105f3a:	56                   	push   %esi
  105f3b:	53                   	push   %ebx
  105f3c:	83 ec 38             	sub    $0x38,%esp
  105f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  105f42:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105f45:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f48:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105f4b:	8b 45 10             	mov    0x10(%ebp),%eax
  105f4e:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105f51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f54:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105f57:	73 4e                	jae    105fa7 <memmove+0x71>
  105f59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f5c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105f5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105f62:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105f65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105f68:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105f6b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105f6e:	89 c1                	mov    %eax,%ecx
  105f70:	c1 e9 02             	shr    $0x2,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105f73:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105f76:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105f79:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  105f7c:	89 d7                	mov    %edx,%edi
  105f7e:	89 c3                	mov    %eax,%ebx
  105f80:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  105f83:	89 de                	mov    %ebx,%esi
  105f85:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105f87:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105f8a:	83 e1 03             	and    $0x3,%ecx
  105f8d:	74 02                	je     105f91 <memmove+0x5b>
  105f8f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105f91:	89 f3                	mov    %esi,%ebx
  105f93:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  105f96:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  105f99:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105f9c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  105f9f:	89 5d d0             	mov    %ebx,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105fa2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105fa5:	eb 3b                	jmp    105fe2 <memmove+0xac>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105fa7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105faa:	83 e8 01             	sub    $0x1,%eax
  105fad:	89 c2                	mov    %eax,%edx
  105faf:	03 55 ec             	add    -0x14(%ebp),%edx
  105fb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105fb5:	83 e8 01             	sub    $0x1,%eax
  105fb8:	03 45 f0             	add    -0x10(%ebp),%eax
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  105fbb:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  105fbe:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  105fc1:	89 d6                	mov    %edx,%esi
  105fc3:	89 c3                	mov    %eax,%ebx
  105fc5:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  105fc8:	89 df                	mov    %ebx,%edi
  105fca:	fd                   	std    
  105fcb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105fcd:	fc                   	cld    
  105fce:	89 fb                	mov    %edi,%ebx
  105fd0:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  105fd3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  105fd6:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105fd9:	89 75 c8             	mov    %esi,-0x38(%ebp)
  105fdc:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  105fdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105fe2:	83 c4 38             	add    $0x38,%esp
  105fe5:	5b                   	pop    %ebx
  105fe6:	5e                   	pop    %esi
  105fe7:	5f                   	pop    %edi
  105fe8:	5d                   	pop    %ebp
  105fe9:	c3                   	ret    

00105fea <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105fea:	55                   	push   %ebp
  105feb:	89 e5                	mov    %esp,%ebp
  105fed:	57                   	push   %edi
  105fee:	56                   	push   %esi
  105fef:	53                   	push   %ebx
  105ff0:	83 ec 24             	sub    $0x24,%esp
  105ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  105ff6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ff9:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ffc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105fff:	8b 45 10             	mov    0x10(%ebp),%eax
  106002:	89 45 e8             	mov    %eax,-0x18(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  106005:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106008:	89 c1                	mov    %eax,%ecx
  10600a:	c1 e9 02             	shr    $0x2,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  10600d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  106010:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106013:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  106016:	89 d7                	mov    %edx,%edi
  106018:	89 c3                	mov    %eax,%ebx
  10601a:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  10601d:	89 de                	mov    %ebx,%esi
  10601f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  106021:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  106024:	83 e1 03             	and    $0x3,%ecx
  106027:	74 02                	je     10602b <memcpy+0x41>
  106029:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10602b:	89 f3                	mov    %esi,%ebx
  10602d:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  106030:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  106033:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  106036:	89 7d e0             	mov    %edi,-0x20(%ebp)
  106039:	89 5d dc             	mov    %ebx,-0x24(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  10603c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  10603f:	83 c4 24             	add    $0x24,%esp
  106042:	5b                   	pop    %ebx
  106043:	5e                   	pop    %esi
  106044:	5f                   	pop    %edi
  106045:	5d                   	pop    %ebp
  106046:	c3                   	ret    

00106047 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  106047:	55                   	push   %ebp
  106048:	89 e5                	mov    %esp,%ebp
  10604a:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  10604d:	8b 45 08             	mov    0x8(%ebp),%eax
  106050:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  106053:	8b 45 0c             	mov    0xc(%ebp),%eax
  106056:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  106059:	eb 32                	jmp    10608d <memcmp+0x46>
        if (*s1 != *s2) {
  10605b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10605e:	0f b6 10             	movzbl (%eax),%edx
  106061:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106064:	0f b6 00             	movzbl (%eax),%eax
  106067:	38 c2                	cmp    %al,%dl
  106069:	74 1a                	je     106085 <memcmp+0x3e>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  10606b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10606e:	0f b6 00             	movzbl (%eax),%eax
  106071:	0f b6 d0             	movzbl %al,%edx
  106074:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106077:	0f b6 00             	movzbl (%eax),%eax
  10607a:	0f b6 c0             	movzbl %al,%eax
  10607d:	89 d1                	mov    %edx,%ecx
  10607f:	29 c1                	sub    %eax,%ecx
  106081:	89 c8                	mov    %ecx,%eax
  106083:	eb 1c                	jmp    1060a1 <memcmp+0x5a>
        }
        s1 ++, s2 ++;
  106085:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  106089:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  10608d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  106091:	0f 95 c0             	setne  %al
  106094:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  106098:	84 c0                	test   %al,%al
  10609a:	75 bf                	jne    10605b <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  10609c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1060a1:	c9                   	leave  
  1060a2:	c3                   	ret    
