
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 70 11 00 	lgdtl  0x117018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 04 00 00 00       	call   c010002c <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>
	...

c010002c <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002c:	55                   	push   %ebp
c010002d:	89 e5                	mov    %esp,%ebp
c010002f:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100032:	ba 68 89 11 c0       	mov    $0xc0118968,%edx
c0100037:	b8 38 7a 11 c0       	mov    $0xc0117a38,%eax
c010003c:	89 d1                	mov    %edx,%ecx
c010003e:	29 c1                	sub    %eax,%ecx
c0100040:	89 c8                	mov    %ecx,%eax
c0100042:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100046:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010004d:	00 
c010004e:	c7 04 24 38 7a 11 c0 	movl   $0xc0117a38,(%esp)
c0100055:	e8 91 5e 00 00       	call   c0105eeb <memset>

    cons_init();                // init the console
c010005a:	e8 f1 15 00 00       	call   c0101650 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005f:	c7 45 f4 c0 60 10 c0 	movl   $0xc01060c0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100066:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100069:	89 44 24 04          	mov    %eax,0x4(%esp)
c010006d:	c7 04 24 dc 60 10 c0 	movl   $0xc01060dc,(%esp)
c0100074:	e8 ce 02 00 00       	call   c0100347 <cprintf>

    print_kerninfo();
c0100079:	e8 d8 07 00 00       	call   c0100856 <print_kerninfo>

    grade_backtrace();
c010007e:	e8 86 00 00 00       	call   c0100109 <grade_backtrace>

    pmm_init();                 // init physical memory management
c0100083:	e8 2c 43 00 00       	call   c01043b4 <pmm_init>

    pic_init();                 // init interrupt controller
c0100088:	e8 34 17 00 00       	call   c01017c1 <pic_init>
    idt_init();                 // init interrupt descriptor table
c010008d:	e8 86 18 00 00       	call   c0101918 <idt_init>

    clock_init();               // init clock interrupt
c0100092:	e8 c9 0c 00 00       	call   c0100d60 <clock_init>
    intr_enable();              // enable irq interrupt
c0100097:	e8 8c 16 00 00       	call   c0101728 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c010009c:	eb fe                	jmp    c010009c <kern_init+0x70>

c010009e <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c010009e:	55                   	push   %ebp
c010009f:	89 e5                	mov    %esp,%ebp
c01000a1:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000ab:	00 
c01000ac:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000b3:	00 
c01000b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000bb:	e8 ca 0b 00 00       	call   c0100c8a <mon_backtrace>
}
c01000c0:	c9                   	leave  
c01000c1:	c3                   	ret    

c01000c2 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000c2:	55                   	push   %ebp
c01000c3:	89 e5                	mov    %esp,%ebp
c01000c5:	53                   	push   %ebx
c01000c6:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000c9:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000cf:	8d 55 08             	lea    0x8(%ebp),%edx
c01000d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01000d5:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000d9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000dd:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000e1:	89 04 24             	mov    %eax,(%esp)
c01000e4:	e8 b5 ff ff ff       	call   c010009e <grade_backtrace2>
}
c01000e9:	83 c4 14             	add    $0x14,%esp
c01000ec:	5b                   	pop    %ebx
c01000ed:	5d                   	pop    %ebp
c01000ee:	c3                   	ret    

c01000ef <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000ef:	55                   	push   %ebp
c01000f0:	89 e5                	mov    %esp,%ebp
c01000f2:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000f5:	8b 45 10             	mov    0x10(%ebp),%eax
c01000f8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01000fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01000ff:	89 04 24             	mov    %eax,(%esp)
c0100102:	e8 bb ff ff ff       	call   c01000c2 <grade_backtrace1>
}
c0100107:	c9                   	leave  
c0100108:	c3                   	ret    

c0100109 <grade_backtrace>:

void
grade_backtrace(void) {
c0100109:	55                   	push   %ebp
c010010a:	89 e5                	mov    %esp,%ebp
c010010c:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010010f:	b8 2c 00 10 c0       	mov    $0xc010002c,%eax
c0100114:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c010011b:	ff 
c010011c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100120:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100127:	e8 c3 ff ff ff       	call   c01000ef <grade_backtrace0>
}
c010012c:	c9                   	leave  
c010012d:	c3                   	ret    

c010012e <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010012e:	55                   	push   %ebp
c010012f:	89 e5                	mov    %esp,%ebp
c0100131:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100134:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100137:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010013a:	8c 45 f2             	mov    %es,-0xe(%ebp)
c010013d:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100140:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100144:	0f b7 c0             	movzwl %ax,%eax
c0100147:	89 c2                	mov    %eax,%edx
c0100149:	83 e2 03             	and    $0x3,%edx
c010014c:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c0100151:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100155:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100159:	c7 04 24 e1 60 10 c0 	movl   $0xc01060e1,(%esp)
c0100160:	e8 e2 01 00 00       	call   c0100347 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100165:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100169:	0f b7 d0             	movzwl %ax,%edx
c010016c:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c0100171:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100175:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100179:	c7 04 24 ef 60 10 c0 	movl   $0xc01060ef,(%esp)
c0100180:	e8 c2 01 00 00       	call   c0100347 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100185:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100189:	0f b7 d0             	movzwl %ax,%edx
c010018c:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c0100191:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100195:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100199:	c7 04 24 fd 60 10 c0 	movl   $0xc01060fd,(%esp)
c01001a0:	e8 a2 01 00 00       	call   c0100347 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001a5:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001a9:	0f b7 d0             	movzwl %ax,%edx
c01001ac:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001b1:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b9:	c7 04 24 0b 61 10 c0 	movl   $0xc010610b,(%esp)
c01001c0:	e8 82 01 00 00       	call   c0100347 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c5:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001c9:	0f b7 d0             	movzwl %ax,%edx
c01001cc:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001d1:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d9:	c7 04 24 19 61 10 c0 	movl   $0xc0106119,(%esp)
c01001e0:	e8 62 01 00 00       	call   c0100347 <cprintf>
    round ++;
c01001e5:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001ea:	83 c0 01             	add    $0x1,%eax
c01001ed:	a3 40 7a 11 c0       	mov    %eax,0xc0117a40
}
c01001f2:	c9                   	leave  
c01001f3:	c3                   	ret    

c01001f4 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001f4:	55                   	push   %ebp
c01001f5:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001f7:	5d                   	pop    %ebp
c01001f8:	c3                   	ret    

c01001f9 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001f9:	55                   	push   %ebp
c01001fa:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001fc:	5d                   	pop    %ebp
c01001fd:	c3                   	ret    

c01001fe <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001fe:	55                   	push   %ebp
c01001ff:	89 e5                	mov    %esp,%ebp
c0100201:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100204:	e8 25 ff ff ff       	call   c010012e <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100209:	c7 04 24 28 61 10 c0 	movl   $0xc0106128,(%esp)
c0100210:	e8 32 01 00 00       	call   c0100347 <cprintf>
    lab1_switch_to_user();
c0100215:	e8 da ff ff ff       	call   c01001f4 <lab1_switch_to_user>
    lab1_print_cur_status();
c010021a:	e8 0f ff ff ff       	call   c010012e <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010021f:	c7 04 24 48 61 10 c0 	movl   $0xc0106148,(%esp)
c0100226:	e8 1c 01 00 00       	call   c0100347 <cprintf>
    lab1_switch_to_kernel();
c010022b:	e8 c9 ff ff ff       	call   c01001f9 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100230:	e8 f9 fe ff ff       	call   c010012e <lab1_print_cur_status>
}
c0100235:	c9                   	leave  
c0100236:	c3                   	ret    
	...

c0100238 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100238:	55                   	push   %ebp
c0100239:	89 e5                	mov    %esp,%ebp
c010023b:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c010023e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100242:	74 13                	je     c0100257 <readline+0x1f>
        cprintf("%s", prompt);
c0100244:	8b 45 08             	mov    0x8(%ebp),%eax
c0100247:	89 44 24 04          	mov    %eax,0x4(%esp)
c010024b:	c7 04 24 67 61 10 c0 	movl   $0xc0106167,(%esp)
c0100252:	e8 f0 00 00 00       	call   c0100347 <cprintf>
    }
    int i = 0, c;
c0100257:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010025e:	eb 01                	jmp    c0100261 <readline+0x29>
        else if (c == '\n' || c == '\r') {
            cputchar(c);
            buf[i] = '\0';
            return buf;
        }
    }
c0100260:	90                   	nop
    if (prompt != NULL) {
        cprintf("%s", prompt);
    }
    int i = 0, c;
    while (1) {
        c = getchar();
c0100261:	e8 6e 01 00 00       	call   c01003d4 <getchar>
c0100266:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100269:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010026d:	79 07                	jns    c0100276 <readline+0x3e>
            return NULL;
c010026f:	b8 00 00 00 00       	mov    $0x0,%eax
c0100274:	eb 79                	jmp    c01002ef <readline+0xb7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100276:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c010027a:	7e 28                	jle    c01002a4 <readline+0x6c>
c010027c:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100283:	7f 1f                	jg     c01002a4 <readline+0x6c>
            cputchar(c);
c0100285:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100288:	89 04 24             	mov    %eax,(%esp)
c010028b:	e8 df 00 00 00       	call   c010036f <cputchar>
            buf[i ++] = c;
c0100290:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100293:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100296:	81 c2 60 7a 11 c0    	add    $0xc0117a60,%edx
c010029c:	88 02                	mov    %al,(%edx)
c010029e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01002a2:	eb 46                	jmp    c01002ea <readline+0xb2>
        }
        else if (c == '\b' && i > 0) {
c01002a4:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002a8:	75 17                	jne    c01002c1 <readline+0x89>
c01002aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002ae:	7e 11                	jle    c01002c1 <readline+0x89>
            cputchar(c);
c01002b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002b3:	89 04 24             	mov    %eax,(%esp)
c01002b6:	e8 b4 00 00 00       	call   c010036f <cputchar>
            i --;
c01002bb:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002bf:	eb 29                	jmp    c01002ea <readline+0xb2>
        }
        else if (c == '\n' || c == '\r') {
c01002c1:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002c5:	74 06                	je     c01002cd <readline+0x95>
c01002c7:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002cb:	75 93                	jne    c0100260 <readline+0x28>
            cputchar(c);
c01002cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002d0:	89 04 24             	mov    %eax,(%esp)
c01002d3:	e8 97 00 00 00       	call   c010036f <cputchar>
            buf[i] = '\0';
c01002d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002db:	05 60 7a 11 c0       	add    $0xc0117a60,%eax
c01002e0:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002e3:	b8 60 7a 11 c0       	mov    $0xc0117a60,%eax
c01002e8:	eb 05                	jmp    c01002ef <readline+0xb7>
        }
    }
c01002ea:	e9 71 ff ff ff       	jmp    c0100260 <readline+0x28>
}
c01002ef:	c9                   	leave  
c01002f0:	c3                   	ret    
c01002f1:	00 00                	add    %al,(%eax)
	...

c01002f4 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002f4:	55                   	push   %ebp
c01002f5:	89 e5                	mov    %esp,%ebp
c01002f7:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01002fd:	89 04 24             	mov    %eax,(%esp)
c0100300:	e8 77 13 00 00       	call   c010167c <cons_putc>
    (*cnt) ++;
c0100305:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100308:	8b 00                	mov    (%eax),%eax
c010030a:	8d 50 01             	lea    0x1(%eax),%edx
c010030d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100310:	89 10                	mov    %edx,(%eax)
}
c0100312:	c9                   	leave  
c0100313:	c3                   	ret    

c0100314 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100314:	55                   	push   %ebp
c0100315:	89 e5                	mov    %esp,%ebp
c0100317:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010031a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100321:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100324:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100328:	8b 45 08             	mov    0x8(%ebp),%eax
c010032b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010032f:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100332:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100336:	c7 04 24 f4 02 10 c0 	movl   $0xc01002f4,(%esp)
c010033d:	e8 ac 53 00 00       	call   c01056ee <vprintfmt>
    return cnt;
c0100342:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100345:	c9                   	leave  
c0100346:	c3                   	ret    

c0100347 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100347:	55                   	push   %ebp
c0100348:	89 e5                	mov    %esp,%ebp
c010034a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010034d:	8d 55 0c             	lea    0xc(%ebp),%edx
c0100350:	8d 45 f0             	lea    -0x10(%ebp),%eax
c0100353:	89 10                	mov    %edx,(%eax)
    cnt = vcprintf(fmt, ap);
c0100355:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100358:	89 44 24 04          	mov    %eax,0x4(%esp)
c010035c:	8b 45 08             	mov    0x8(%ebp),%eax
c010035f:	89 04 24             	mov    %eax,(%esp)
c0100362:	e8 ad ff ff ff       	call   c0100314 <vcprintf>
c0100367:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010036a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010036d:	c9                   	leave  
c010036e:	c3                   	ret    

c010036f <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c010036f:	55                   	push   %ebp
c0100370:	89 e5                	mov    %esp,%ebp
c0100372:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100375:	8b 45 08             	mov    0x8(%ebp),%eax
c0100378:	89 04 24             	mov    %eax,(%esp)
c010037b:	e8 fc 12 00 00       	call   c010167c <cons_putc>
}
c0100380:	c9                   	leave  
c0100381:	c3                   	ret    

c0100382 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100382:	55                   	push   %ebp
c0100383:	89 e5                	mov    %esp,%ebp
c0100385:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100388:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c010038f:	eb 13                	jmp    c01003a4 <cputs+0x22>
        cputch(c, &cnt);
c0100391:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100395:	8d 55 f0             	lea    -0x10(%ebp),%edx
c0100398:	89 54 24 04          	mov    %edx,0x4(%esp)
c010039c:	89 04 24             	mov    %eax,(%esp)
c010039f:	e8 50 ff ff ff       	call   c01002f4 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01003a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01003a7:	0f b6 00             	movzbl (%eax),%eax
c01003aa:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003ad:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003b1:	0f 95 c0             	setne  %al
c01003b4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01003b8:	84 c0                	test   %al,%al
c01003ba:	75 d5                	jne    c0100391 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003bc:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003bf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003c3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003ca:	e8 25 ff ff ff       	call   c01002f4 <cputch>
    return cnt;
c01003cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003d2:	c9                   	leave  
c01003d3:	c3                   	ret    

c01003d4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003d4:	55                   	push   %ebp
c01003d5:	89 e5                	mov    %esp,%ebp
c01003d7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003da:	e8 d9 12 00 00       	call   c01016b8 <cons_getc>
c01003df:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003e6:	74 f2                	je     c01003da <getchar+0x6>
        /* do nothing */;
    return c;
c01003e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003eb:	c9                   	leave  
c01003ec:	c3                   	ret    
c01003ed:	00 00                	add    %al,(%eax)
	...

c01003f0 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003f0:	55                   	push   %ebp
c01003f1:	89 e5                	mov    %esp,%ebp
c01003f3:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003f9:	8b 00                	mov    (%eax),%eax
c01003fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003fe:	8b 45 10             	mov    0x10(%ebp),%eax
c0100401:	8b 00                	mov    (%eax),%eax
c0100403:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0100406:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c010040d:	e9 c6 00 00 00       	jmp    c01004d8 <stab_binsearch+0xe8>
        int true_m = (l + r) / 2, m = true_m;
c0100412:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100415:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100418:	01 d0                	add    %edx,%eax
c010041a:	89 c2                	mov    %eax,%edx
c010041c:	c1 ea 1f             	shr    $0x1f,%edx
c010041f:	01 d0                	add    %edx,%eax
c0100421:	d1 f8                	sar    %eax
c0100423:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100426:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100429:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010042c:	eb 04                	jmp    c0100432 <stab_binsearch+0x42>
            m --;
c010042e:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100432:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100435:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100438:	7c 1b                	jl     c0100455 <stab_binsearch+0x65>
c010043a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010043d:	89 d0                	mov    %edx,%eax
c010043f:	01 c0                	add    %eax,%eax
c0100441:	01 d0                	add    %edx,%eax
c0100443:	c1 e0 02             	shl    $0x2,%eax
c0100446:	03 45 08             	add    0x8(%ebp),%eax
c0100449:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010044d:	0f b6 c0             	movzbl %al,%eax
c0100450:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100453:	75 d9                	jne    c010042e <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100455:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100458:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010045b:	7d 0b                	jge    c0100468 <stab_binsearch+0x78>
            l = true_m + 1;
c010045d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100460:	83 c0 01             	add    $0x1,%eax
c0100463:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100466:	eb 70                	jmp    c01004d8 <stab_binsearch+0xe8>
        }

        // actual binary search
        any_matches = 1;
c0100468:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c010046f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100472:	89 d0                	mov    %edx,%eax
c0100474:	01 c0                	add    %eax,%eax
c0100476:	01 d0                	add    %edx,%eax
c0100478:	c1 e0 02             	shl    $0x2,%eax
c010047b:	03 45 08             	add    0x8(%ebp),%eax
c010047e:	8b 40 08             	mov    0x8(%eax),%eax
c0100481:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100484:	73 13                	jae    c0100499 <stab_binsearch+0xa9>
            *region_left = m;
c0100486:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100489:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010048c:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c010048e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100491:	83 c0 01             	add    $0x1,%eax
c0100494:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100497:	eb 3f                	jmp    c01004d8 <stab_binsearch+0xe8>
        } else if (stabs[m].n_value > addr) {
c0100499:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010049c:	89 d0                	mov    %edx,%eax
c010049e:	01 c0                	add    %eax,%eax
c01004a0:	01 d0                	add    %edx,%eax
c01004a2:	c1 e0 02             	shl    $0x2,%eax
c01004a5:	03 45 08             	add    0x8(%ebp),%eax
c01004a8:	8b 40 08             	mov    0x8(%eax),%eax
c01004ab:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004ae:	76 16                	jbe    c01004c6 <stab_binsearch+0xd6>
            *region_right = m - 1;
c01004b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004b3:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004b6:	8b 45 10             	mov    0x10(%ebp),%eax
c01004b9:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004be:	83 e8 01             	sub    $0x1,%eax
c01004c1:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004c4:	eb 12                	jmp    c01004d8 <stab_binsearch+0xe8>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004c6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004cc:	89 10                	mov    %edx,(%eax)
            l = m;
c01004ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004d4:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004db:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004de:	0f 8e 2e ff ff ff    	jle    c0100412 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004e8:	75 0f                	jne    c01004f9 <stab_binsearch+0x109>
        *region_right = *region_left - 1;
c01004ea:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004ed:	8b 00                	mov    (%eax),%eax
c01004ef:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004f2:	8b 45 10             	mov    0x10(%ebp),%eax
c01004f5:	89 10                	mov    %edx,(%eax)
c01004f7:	eb 3b                	jmp    c0100534 <stab_binsearch+0x144>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01004f9:	8b 45 10             	mov    0x10(%ebp),%eax
c01004fc:	8b 00                	mov    (%eax),%eax
c01004fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100501:	eb 04                	jmp    c0100507 <stab_binsearch+0x117>
c0100503:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c0100507:	8b 45 0c             	mov    0xc(%ebp),%eax
c010050a:	8b 00                	mov    (%eax),%eax
c010050c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010050f:	7d 1b                	jge    c010052c <stab_binsearch+0x13c>
c0100511:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100514:	89 d0                	mov    %edx,%eax
c0100516:	01 c0                	add    %eax,%eax
c0100518:	01 d0                	add    %edx,%eax
c010051a:	c1 e0 02             	shl    $0x2,%eax
c010051d:	03 45 08             	add    0x8(%ebp),%eax
c0100520:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100524:	0f b6 c0             	movzbl %al,%eax
c0100527:	3b 45 14             	cmp    0x14(%ebp),%eax
c010052a:	75 d7                	jne    c0100503 <stab_binsearch+0x113>
            /* do nothing */;
        *region_left = l;
c010052c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010052f:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100532:	89 10                	mov    %edx,(%eax)
    }
}
c0100534:	c9                   	leave  
c0100535:	c3                   	ret    

c0100536 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100536:	55                   	push   %ebp
c0100537:	89 e5                	mov    %esp,%ebp
c0100539:	53                   	push   %ebx
c010053a:	83 ec 54             	sub    $0x54,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c010053d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100540:	c7 00 6c 61 10 c0    	movl   $0xc010616c,(%eax)
    info->eip_line = 0;
c0100546:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100549:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100550:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100553:	c7 40 08 6c 61 10 c0 	movl   $0xc010616c,0x8(%eax)
    info->eip_fn_namelen = 9;
c010055a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055d:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100564:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100567:	8b 55 08             	mov    0x8(%ebp),%edx
c010056a:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c010056d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100570:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100577:	c7 45 f4 c0 73 10 c0 	movl   $0xc01073c0,-0xc(%ebp)
    stab_end = __STAB_END__;
c010057e:	c7 45 f0 88 20 11 c0 	movl   $0xc0112088,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100585:	c7 45 ec 89 20 11 c0 	movl   $0xc0112089,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c010058c:	c7 45 e8 7b 4a 11 c0 	movl   $0xc0114a7b,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c0100593:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100596:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100599:	76 0d                	jbe    c01005a8 <debuginfo_eip+0x72>
c010059b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010059e:	83 e8 01             	sub    $0x1,%eax
c01005a1:	0f b6 00             	movzbl (%eax),%eax
c01005a4:	84 c0                	test   %al,%al
c01005a6:	74 0a                	je     c01005b2 <debuginfo_eip+0x7c>
        return -1;
c01005a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005ad:	e9 9e 02 00 00       	jmp    c0100850 <debuginfo_eip+0x31a>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005b2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005bf:	89 d1                	mov    %edx,%ecx
c01005c1:	29 c1                	sub    %eax,%ecx
c01005c3:	89 c8                	mov    %ecx,%eax
c01005c5:	c1 f8 02             	sar    $0x2,%eax
c01005c8:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005ce:	83 e8 01             	sub    $0x1,%eax
c01005d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01005d7:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005db:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005e2:	00 
c01005e3:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005e6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005ea:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005ed:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005f4:	89 04 24             	mov    %eax,(%esp)
c01005f7:	e8 f4 fd ff ff       	call   c01003f0 <stab_binsearch>
    if (lfile == 0)
c01005fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005ff:	85 c0                	test   %eax,%eax
c0100601:	75 0a                	jne    c010060d <debuginfo_eip+0xd7>
        return -1;
c0100603:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100608:	e9 43 02 00 00       	jmp    c0100850 <debuginfo_eip+0x31a>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c010060d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100610:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100613:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100616:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100619:	8b 45 08             	mov    0x8(%ebp),%eax
c010061c:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100620:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100627:	00 
c0100628:	8d 45 d8             	lea    -0x28(%ebp),%eax
c010062b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010062f:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100632:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100636:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100639:	89 04 24             	mov    %eax,(%esp)
c010063c:	e8 af fd ff ff       	call   c01003f0 <stab_binsearch>

    if (lfun <= rfun) {
c0100641:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100644:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100647:	39 c2                	cmp    %eax,%edx
c0100649:	7f 72                	jg     c01006bd <debuginfo_eip+0x187>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c010064b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010064e:	89 c2                	mov    %eax,%edx
c0100650:	89 d0                	mov    %edx,%eax
c0100652:	01 c0                	add    %eax,%eax
c0100654:	01 d0                	add    %edx,%eax
c0100656:	c1 e0 02             	shl    $0x2,%eax
c0100659:	03 45 f4             	add    -0xc(%ebp),%eax
c010065c:	8b 10                	mov    (%eax),%edx
c010065e:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100661:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100664:	89 cb                	mov    %ecx,%ebx
c0100666:	29 c3                	sub    %eax,%ebx
c0100668:	89 d8                	mov    %ebx,%eax
c010066a:	39 c2                	cmp    %eax,%edx
c010066c:	73 1e                	jae    c010068c <debuginfo_eip+0x156>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010066e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100671:	89 c2                	mov    %eax,%edx
c0100673:	89 d0                	mov    %edx,%eax
c0100675:	01 c0                	add    %eax,%eax
c0100677:	01 d0                	add    %edx,%eax
c0100679:	c1 e0 02             	shl    $0x2,%eax
c010067c:	03 45 f4             	add    -0xc(%ebp),%eax
c010067f:	8b 00                	mov    (%eax),%eax
c0100681:	89 c2                	mov    %eax,%edx
c0100683:	03 55 ec             	add    -0x14(%ebp),%edx
c0100686:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010068f:	89 c2                	mov    %eax,%edx
c0100691:	89 d0                	mov    %edx,%eax
c0100693:	01 c0                	add    %eax,%eax
c0100695:	01 d0                	add    %edx,%eax
c0100697:	c1 e0 02             	shl    $0x2,%eax
c010069a:	03 45 f4             	add    -0xc(%ebp),%eax
c010069d:	8b 50 08             	mov    0x8(%eax),%edx
c01006a0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a3:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006a6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a9:	8b 40 10             	mov    0x10(%eax),%eax
c01006ac:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006af:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006b2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006b5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006b8:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006bb:	eb 15                	jmp    c01006d2 <debuginfo_eip+0x19c>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006bd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c0:	8b 55 08             	mov    0x8(%ebp),%edx
c01006c3:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006cf:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006d2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d5:	8b 40 08             	mov    0x8(%eax),%eax
c01006d8:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006df:	00 
c01006e0:	89 04 24             	mov    %eax,(%esp)
c01006e3:	e8 7b 56 00 00       	call   c0105d63 <strfind>
c01006e8:	89 c2                	mov    %eax,%edx
c01006ea:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006ed:	8b 40 08             	mov    0x8(%eax),%eax
c01006f0:	29 c2                	sub    %eax,%edx
c01006f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f5:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01006f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01006fb:	89 44 24 10          	mov    %eax,0x10(%esp)
c01006ff:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100706:	00 
c0100707:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010070a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010070e:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100711:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100715:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100718:	89 04 24             	mov    %eax,(%esp)
c010071b:	e8 d0 fc ff ff       	call   c01003f0 <stab_binsearch>
    if (lline <= rline) {
c0100720:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100723:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100726:	39 c2                	cmp    %eax,%edx
c0100728:	7f 20                	jg     c010074a <debuginfo_eip+0x214>
        info->eip_line = stabs[rline].n_desc;
c010072a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010072d:	89 c2                	mov    %eax,%edx
c010072f:	89 d0                	mov    %edx,%eax
c0100731:	01 c0                	add    %eax,%eax
c0100733:	01 d0                	add    %edx,%eax
c0100735:	c1 e0 02             	shl    $0x2,%eax
c0100738:	03 45 f4             	add    -0xc(%ebp),%eax
c010073b:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c010073f:	0f b7 d0             	movzwl %ax,%edx
c0100742:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100745:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100748:	eb 13                	jmp    c010075d <debuginfo_eip+0x227>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c010074a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010074f:	e9 fc 00 00 00       	jmp    c0100850 <debuginfo_eip+0x31a>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100754:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100757:	83 e8 01             	sub    $0x1,%eax
c010075a:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010075d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100760:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100763:	39 c2                	cmp    %eax,%edx
c0100765:	7c 4a                	jl     c01007b1 <debuginfo_eip+0x27b>
           && stabs[lline].n_type != N_SOL
c0100767:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010076a:	89 c2                	mov    %eax,%edx
c010076c:	89 d0                	mov    %edx,%eax
c010076e:	01 c0                	add    %eax,%eax
c0100770:	01 d0                	add    %edx,%eax
c0100772:	c1 e0 02             	shl    $0x2,%eax
c0100775:	03 45 f4             	add    -0xc(%ebp),%eax
c0100778:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010077c:	3c 84                	cmp    $0x84,%al
c010077e:	74 31                	je     c01007b1 <debuginfo_eip+0x27b>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100780:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100783:	89 c2                	mov    %eax,%edx
c0100785:	89 d0                	mov    %edx,%eax
c0100787:	01 c0                	add    %eax,%eax
c0100789:	01 d0                	add    %edx,%eax
c010078b:	c1 e0 02             	shl    $0x2,%eax
c010078e:	03 45 f4             	add    -0xc(%ebp),%eax
c0100791:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100795:	3c 64                	cmp    $0x64,%al
c0100797:	75 bb                	jne    c0100754 <debuginfo_eip+0x21e>
c0100799:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010079c:	89 c2                	mov    %eax,%edx
c010079e:	89 d0                	mov    %edx,%eax
c01007a0:	01 c0                	add    %eax,%eax
c01007a2:	01 d0                	add    %edx,%eax
c01007a4:	c1 e0 02             	shl    $0x2,%eax
c01007a7:	03 45 f4             	add    -0xc(%ebp),%eax
c01007aa:	8b 40 08             	mov    0x8(%eax),%eax
c01007ad:	85 c0                	test   %eax,%eax
c01007af:	74 a3                	je     c0100754 <debuginfo_eip+0x21e>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007b1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007b7:	39 c2                	cmp    %eax,%edx
c01007b9:	7c 40                	jl     c01007fb <debuginfo_eip+0x2c5>
c01007bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007be:	89 c2                	mov    %eax,%edx
c01007c0:	89 d0                	mov    %edx,%eax
c01007c2:	01 c0                	add    %eax,%eax
c01007c4:	01 d0                	add    %edx,%eax
c01007c6:	c1 e0 02             	shl    $0x2,%eax
c01007c9:	03 45 f4             	add    -0xc(%ebp),%eax
c01007cc:	8b 10                	mov    (%eax),%edx
c01007ce:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007d4:	89 cb                	mov    %ecx,%ebx
c01007d6:	29 c3                	sub    %eax,%ebx
c01007d8:	89 d8                	mov    %ebx,%eax
c01007da:	39 c2                	cmp    %eax,%edx
c01007dc:	73 1d                	jae    c01007fb <debuginfo_eip+0x2c5>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01007de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007e1:	89 c2                	mov    %eax,%edx
c01007e3:	89 d0                	mov    %edx,%eax
c01007e5:	01 c0                	add    %eax,%eax
c01007e7:	01 d0                	add    %edx,%eax
c01007e9:	c1 e0 02             	shl    $0x2,%eax
c01007ec:	03 45 f4             	add    -0xc(%ebp),%eax
c01007ef:	8b 00                	mov    (%eax),%eax
c01007f1:	89 c2                	mov    %eax,%edx
c01007f3:	03 55 ec             	add    -0x14(%ebp),%edx
c01007f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007f9:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c01007fb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01007fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100801:	39 c2                	cmp    %eax,%edx
c0100803:	7d 46                	jge    c010084b <debuginfo_eip+0x315>
        for (lline = lfun + 1;
c0100805:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100808:	83 c0 01             	add    $0x1,%eax
c010080b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c010080e:	eb 18                	jmp    c0100828 <debuginfo_eip+0x2f2>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100810:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100813:	8b 40 14             	mov    0x14(%eax),%eax
c0100816:	8d 50 01             	lea    0x1(%eax),%edx
c0100819:	8b 45 0c             	mov    0xc(%ebp),%eax
c010081c:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c010081f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100822:	83 c0 01             	add    $0x1,%eax
c0100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100828:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010082b:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c010082e:	39 c2                	cmp    %eax,%edx
c0100830:	7d 19                	jge    c010084b <debuginfo_eip+0x315>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100832:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100835:	89 c2                	mov    %eax,%edx
c0100837:	89 d0                	mov    %edx,%eax
c0100839:	01 c0                	add    %eax,%eax
c010083b:	01 d0                	add    %edx,%eax
c010083d:	c1 e0 02             	shl    $0x2,%eax
c0100840:	03 45 f4             	add    -0xc(%ebp),%eax
c0100843:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100847:	3c a0                	cmp    $0xa0,%al
c0100849:	74 c5                	je     c0100810 <debuginfo_eip+0x2da>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c010084b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100850:	83 c4 54             	add    $0x54,%esp
c0100853:	5b                   	pop    %ebx
c0100854:	5d                   	pop    %ebp
c0100855:	c3                   	ret    

c0100856 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100856:	55                   	push   %ebp
c0100857:	89 e5                	mov    %esp,%ebp
c0100859:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c010085c:	c7 04 24 76 61 10 c0 	movl   $0xc0106176,(%esp)
c0100863:	e8 df fa ff ff       	call   c0100347 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100868:	c7 44 24 04 2c 00 10 	movl   $0xc010002c,0x4(%esp)
c010086f:	c0 
c0100870:	c7 04 24 8f 61 10 c0 	movl   $0xc010618f,(%esp)
c0100877:	e8 cb fa ff ff       	call   c0100347 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c010087c:	c7 44 24 04 a3 60 10 	movl   $0xc01060a3,0x4(%esp)
c0100883:	c0 
c0100884:	c7 04 24 a7 61 10 c0 	movl   $0xc01061a7,(%esp)
c010088b:	e8 b7 fa ff ff       	call   c0100347 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c0100890:	c7 44 24 04 38 7a 11 	movl   $0xc0117a38,0x4(%esp)
c0100897:	c0 
c0100898:	c7 04 24 bf 61 10 c0 	movl   $0xc01061bf,(%esp)
c010089f:	e8 a3 fa ff ff       	call   c0100347 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008a4:	c7 44 24 04 68 89 11 	movl   $0xc0118968,0x4(%esp)
c01008ab:	c0 
c01008ac:	c7 04 24 d7 61 10 c0 	movl   $0xc01061d7,(%esp)
c01008b3:	e8 8f fa ff ff       	call   c0100347 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008b8:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c01008bd:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008c3:	b8 2c 00 10 c0       	mov    $0xc010002c,%eax
c01008c8:	89 d1                	mov    %edx,%ecx
c01008ca:	29 c1                	sub    %eax,%ecx
c01008cc:	89 c8                	mov    %ecx,%eax
c01008ce:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008d4:	85 c0                	test   %eax,%eax
c01008d6:	0f 48 c2             	cmovs  %edx,%eax
c01008d9:	c1 f8 0a             	sar    $0xa,%eax
c01008dc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01008e0:	c7 04 24 f0 61 10 c0 	movl   $0xc01061f0,(%esp)
c01008e7:	e8 5b fa ff ff       	call   c0100347 <cprintf>
}
c01008ec:	c9                   	leave  
c01008ed:	c3                   	ret    

c01008ee <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c01008ee:	55                   	push   %ebp
c01008ef:	89 e5                	mov    %esp,%ebp
c01008f1:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c01008f7:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01008fa:	89 44 24 04          	mov    %eax,0x4(%esp)
c01008fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0100901:	89 04 24             	mov    %eax,(%esp)
c0100904:	e8 2d fc ff ff       	call   c0100536 <debuginfo_eip>
c0100909:	85 c0                	test   %eax,%eax
c010090b:	74 15                	je     c0100922 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c010090d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100910:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100914:	c7 04 24 1a 62 10 c0 	movl   $0xc010621a,(%esp)
c010091b:	e8 27 fa ff ff       	call   c0100347 <cprintf>
c0100920:	eb 69                	jmp    c010098b <print_debuginfo+0x9d>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100922:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100929:	eb 1a                	jmp    c0100945 <print_debuginfo+0x57>
            fnname[j] = info.eip_fn_name[j];
c010092b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010092e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100931:	01 d0                	add    %edx,%eax
c0100933:	0f b6 10             	movzbl (%eax),%edx
c0100936:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
c010093c:	03 45 f4             	add    -0xc(%ebp),%eax
c010093f:	88 10                	mov    %dl,(%eax)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100941:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100945:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100948:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010094b:	7f de                	jg     c010092b <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c010094d:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
c0100953:	03 45 f4             	add    -0xc(%ebp),%eax
c0100956:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100959:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c010095c:	8b 55 08             	mov    0x8(%ebp),%edx
c010095f:	89 d1                	mov    %edx,%ecx
c0100961:	29 c1                	sub    %eax,%ecx
c0100963:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100966:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100969:	89 4c 24 10          	mov    %ecx,0x10(%esp)
                fnname, eip - info.eip_fn_addr);
c010096d:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100973:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100977:	89 54 24 08          	mov    %edx,0x8(%esp)
c010097b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010097f:	c7 04 24 36 62 10 c0 	movl   $0xc0106236,(%esp)
c0100986:	e8 bc f9 ff ff       	call   c0100347 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c010098b:	c9                   	leave  
c010098c:	c3                   	ret    

c010098d <read_eip>:

static __noinline uint32_t
read_eip(void) {
c010098d:	55                   	push   %ebp
c010098e:	89 e5                	mov    %esp,%ebp
c0100990:	53                   	push   %ebx
c0100991:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100994:	8b 5d 04             	mov    0x4(%ebp),%ebx
c0100997:	89 5d f8             	mov    %ebx,-0x8(%ebp)
    return eip;
c010099a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c010099d:	83 c4 10             	add    $0x10,%esp
c01009a0:	5b                   	pop    %ebx
c01009a1:	5d                   	pop    %ebp
c01009a2:	c3                   	ret    

c01009a3 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009a3:	55                   	push   %ebp
c01009a4:	89 e5                	mov    %esp,%ebp
c01009a6:	53                   	push   %ebx
c01009a7:	83 ec 34             	sub    $0x34,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009aa:	89 eb                	mov    %ebp,%ebx
c01009ac:	89 5d e8             	mov    %ebx,-0x18(%ebp)
    return ebp;
c01009af:	8b 45 e8             	mov    -0x18(%ebp),%eax
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
        uint32_t ebp ,eip; 
        ebp=read_ebp();
c01009b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	eip=read_eip();
c01009b5:	e8 d3 ff ff ff       	call   c010098d <read_eip>
c01009ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i, j; 
	for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c01009bd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009c4:	eb 7b                	jmp    c0100a41 <print_stackframe+0x9e>
	  cprintf("ebp:0x%08x eip:0x%08x",ebp,eip); 
c01009c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009c9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009d0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009d4:	c7 04 24 48 62 10 c0 	movl   $0xc0106248,(%esp)
c01009db:	e8 67 f9 ff ff       	call   c0100347 <cprintf>
	  cprintf(" args:0x%08x 0x%08x 0x%08x 0x%08x",*((uint32_t *)(ebp+8)),*((uint32_t *)(ebp+12)),*((uint32_t *)(ebp+16)),*((uint32_t *)(ebp+20)));
c01009e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009e3:	83 c0 14             	add    $0x14,%eax
c01009e6:	8b 18                	mov    (%eax),%ebx
c01009e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009eb:	83 c0 10             	add    $0x10,%eax
c01009ee:	8b 08                	mov    (%eax),%ecx
c01009f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009f3:	83 c0 0c             	add    $0xc,%eax
c01009f6:	8b 10                	mov    (%eax),%edx
c01009f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009fb:	83 c0 08             	add    $0x8,%eax
c01009fe:	8b 00                	mov    (%eax),%eax
c0100a00:	89 5c 24 10          	mov    %ebx,0x10(%esp)
c0100a04:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100a08:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100a0c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a10:	c7 04 24 60 62 10 c0 	movl   $0xc0106260,(%esp)
c0100a17:	e8 2b f9 ff ff       	call   c0100347 <cprintf>
          print_debuginfo(eip-1); 
c0100a1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a1f:	83 e8 01             	sub    $0x1,%eax
c0100a22:	89 04 24             	mov    %eax,(%esp)
c0100a25:	e8 c4 fe ff ff       	call   c01008ee <print_debuginfo>
	  eip = *(uint32_t *)(ebp+4); 
c0100a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a2d:	83 c0 04             	add    $0x4,%eax
c0100a30:	8b 00                	mov    (%eax),%eax
c0100a32:	89 45 f0             	mov    %eax,-0x10(%ebp)
          ebp = *(uint32_t *)(ebp);
c0100a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a38:	8b 00                	mov    (%eax),%eax
c0100a3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
      */
        uint32_t ebp ,eip; 
        ebp=read_ebp();
	eip=read_eip();
	int i, j; 
	for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100a3d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a45:	74 0a                	je     c0100a51 <print_stackframe+0xae>
c0100a47:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a4b:	0f 8e 75 ff ff ff    	jle    c01009c6 <print_stackframe+0x23>
	  cprintf(" args:0x%08x 0x%08x 0x%08x 0x%08x",*((uint32_t *)(ebp+8)),*((uint32_t *)(ebp+12)),*((uint32_t *)(ebp+16)),*((uint32_t *)(ebp+20)));
          print_debuginfo(eip-1); 
	  eip = *(uint32_t *)(ebp+4); 
          ebp = *(uint32_t *)(ebp);
	}
}
c0100a51:	83 c4 34             	add    $0x34,%esp
c0100a54:	5b                   	pop    %ebx
c0100a55:	5d                   	pop    %ebp
c0100a56:	c3                   	ret    
	...

c0100a58 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a58:	55                   	push   %ebp
c0100a59:	89 e5                	mov    %esp,%ebp
c0100a5b:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a65:	eb 0d                	jmp    c0100a74 <parse+0x1c>
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
c0100a67:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a68:	eb 0a                	jmp    c0100a74 <parse+0x1c>
            *buf ++ = '\0';
c0100a6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a6d:	c6 00 00             	movb   $0x0,(%eax)
c0100a70:	83 45 08 01          	addl   $0x1,0x8(%ebp)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a74:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a77:	0f b6 00             	movzbl (%eax),%eax
c0100a7a:	84 c0                	test   %al,%al
c0100a7c:	74 1d                	je     c0100a9b <parse+0x43>
c0100a7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a81:	0f b6 00             	movzbl (%eax),%eax
c0100a84:	0f be c0             	movsbl %al,%eax
c0100a87:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a8b:	c7 04 24 04 63 10 c0 	movl   $0xc0106304,(%esp)
c0100a92:	e8 99 52 00 00       	call   c0105d30 <strchr>
c0100a97:	85 c0                	test   %eax,%eax
c0100a99:	75 cf                	jne    c0100a6a <parse+0x12>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100a9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a9e:	0f b6 00             	movzbl (%eax),%eax
c0100aa1:	84 c0                	test   %al,%al
c0100aa3:	74 5e                	je     c0100b03 <parse+0xab>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100aa5:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100aa9:	75 14                	jne    c0100abf <parse+0x67>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100aab:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100ab2:	00 
c0100ab3:	c7 04 24 09 63 10 c0 	movl   $0xc0106309,(%esp)
c0100aba:	e8 88 f8 ff ff       	call   c0100347 <cprintf>
        }
        argv[argc ++] = buf;
c0100abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ac2:	c1 e0 02             	shl    $0x2,%eax
c0100ac5:	03 45 0c             	add    0xc(%ebp),%eax
c0100ac8:	8b 55 08             	mov    0x8(%ebp),%edx
c0100acb:	89 10                	mov    %edx,(%eax)
c0100acd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100ad1:	eb 04                	jmp    c0100ad7 <parse+0x7f>
            buf ++;
c0100ad3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100ad7:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ada:	0f b6 00             	movzbl (%eax),%eax
c0100add:	84 c0                	test   %al,%al
c0100adf:	74 86                	je     c0100a67 <parse+0xf>
c0100ae1:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ae4:	0f b6 00             	movzbl (%eax),%eax
c0100ae7:	0f be c0             	movsbl %al,%eax
c0100aea:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100aee:	c7 04 24 04 63 10 c0 	movl   $0xc0106304,(%esp)
c0100af5:	e8 36 52 00 00       	call   c0105d30 <strchr>
c0100afa:	85 c0                	test   %eax,%eax
c0100afc:	74 d5                	je     c0100ad3 <parse+0x7b>
            buf ++;
        }
    }
c0100afe:	e9 64 ff ff ff       	jmp    c0100a67 <parse+0xf>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
c0100b03:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b07:	c9                   	leave  
c0100b08:	c3                   	ret    

c0100b09 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b09:	55                   	push   %ebp
c0100b0a:	89 e5                	mov    %esp,%ebp
c0100b0c:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b0f:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b12:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b16:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b19:	89 04 24             	mov    %eax,(%esp)
c0100b1c:	e8 37 ff ff ff       	call   c0100a58 <parse>
c0100b21:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b28:	75 0a                	jne    c0100b34 <runcmd+0x2b>
        return 0;
c0100b2a:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b2f:	e9 85 00 00 00       	jmp    c0100bb9 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b3b:	eb 5c                	jmp    c0100b99 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b3d:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b40:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b43:	89 d0                	mov    %edx,%eax
c0100b45:	01 c0                	add    %eax,%eax
c0100b47:	01 d0                	add    %edx,%eax
c0100b49:	c1 e0 02             	shl    $0x2,%eax
c0100b4c:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100b51:	8b 00                	mov    (%eax),%eax
c0100b53:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b57:	89 04 24             	mov    %eax,(%esp)
c0100b5a:	e8 2c 51 00 00       	call   c0105c8b <strcmp>
c0100b5f:	85 c0                	test   %eax,%eax
c0100b61:	75 32                	jne    c0100b95 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b63:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b66:	89 d0                	mov    %edx,%eax
c0100b68:	01 c0                	add    %eax,%eax
c0100b6a:	01 d0                	add    %edx,%eax
c0100b6c:	c1 e0 02             	shl    $0x2,%eax
c0100b6f:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100b74:	8b 50 08             	mov    0x8(%eax),%edx
c0100b77:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b7a:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0100b7d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b80:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100b84:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b87:	83 c0 04             	add    $0x4,%eax
c0100b8a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b8e:	89 0c 24             	mov    %ecx,(%esp)
c0100b91:	ff d2                	call   *%edx
c0100b93:	eb 24                	jmp    c0100bb9 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b95:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b9c:	83 f8 02             	cmp    $0x2,%eax
c0100b9f:	76 9c                	jbe    c0100b3d <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100ba1:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100ba4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ba8:	c7 04 24 27 63 10 c0 	movl   $0xc0106327,(%esp)
c0100baf:	e8 93 f7 ff ff       	call   c0100347 <cprintf>
    return 0;
c0100bb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bb9:	c9                   	leave  
c0100bba:	c3                   	ret    

c0100bbb <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bbb:	55                   	push   %ebp
c0100bbc:	89 e5                	mov    %esp,%ebp
c0100bbe:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100bc1:	c7 04 24 40 63 10 c0 	movl   $0xc0106340,(%esp)
c0100bc8:	e8 7a f7 ff ff       	call   c0100347 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100bcd:	c7 04 24 68 63 10 c0 	movl   $0xc0106368,(%esp)
c0100bd4:	e8 6e f7 ff ff       	call   c0100347 <cprintf>

    if (tf != NULL) {
c0100bd9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100bdd:	74 0e                	je     c0100bed <kmonitor+0x32>
        print_trapframe(tf);
c0100bdf:	8b 45 08             	mov    0x8(%ebp),%eax
c0100be2:	89 04 24             	mov    %eax,(%esp)
c0100be5:	e8 e2 0e 00 00       	call   c0101acc <print_trapframe>
c0100bea:	eb 01                	jmp    c0100bed <kmonitor+0x32>
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
            }
        }
    }
c0100bec:	90                   	nop
        print_trapframe(tf);
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100bed:	c7 04 24 8d 63 10 c0 	movl   $0xc010638d,(%esp)
c0100bf4:	e8 3f f6 ff ff       	call   c0100238 <readline>
c0100bf9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100bfc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c00:	74 ea                	je     c0100bec <kmonitor+0x31>
            if (runcmd(buf, tf) < 0) {
c0100c02:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c05:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c0c:	89 04 24             	mov    %eax,(%esp)
c0100c0f:	e8 f5 fe ff ff       	call   c0100b09 <runcmd>
c0100c14:	85 c0                	test   %eax,%eax
c0100c16:	79 d4                	jns    c0100bec <kmonitor+0x31>
                break;
c0100c18:	90                   	nop
            }
        }
    }
}
c0100c19:	c9                   	leave  
c0100c1a:	c3                   	ret    

c0100c1b <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c1b:	55                   	push   %ebp
c0100c1c:	89 e5                	mov    %esp,%ebp
c0100c1e:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c21:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c28:	eb 3f                	jmp    c0100c69 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c2d:	89 d0                	mov    %edx,%eax
c0100c2f:	01 c0                	add    %eax,%eax
c0100c31:	01 d0                	add    %edx,%eax
c0100c33:	c1 e0 02             	shl    $0x2,%eax
c0100c36:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c3b:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c41:	89 d0                	mov    %edx,%eax
c0100c43:	01 c0                	add    %eax,%eax
c0100c45:	01 d0                	add    %edx,%eax
c0100c47:	c1 e0 02             	shl    $0x2,%eax
c0100c4a:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c4f:	8b 00                	mov    (%eax),%eax
c0100c51:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c55:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c59:	c7 04 24 91 63 10 c0 	movl   $0xc0106391,(%esp)
c0100c60:	e8 e2 f6 ff ff       	call   c0100347 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c65:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c6c:	83 f8 02             	cmp    $0x2,%eax
c0100c6f:	76 b9                	jbe    c0100c2a <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100c71:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c76:	c9                   	leave  
c0100c77:	c3                   	ret    

c0100c78 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100c78:	55                   	push   %ebp
c0100c79:	89 e5                	mov    %esp,%ebp
c0100c7b:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100c7e:	e8 d3 fb ff ff       	call   c0100856 <print_kerninfo>
    return 0;
c0100c83:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c88:	c9                   	leave  
c0100c89:	c3                   	ret    

c0100c8a <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100c8a:	55                   	push   %ebp
c0100c8b:	89 e5                	mov    %esp,%ebp
c0100c8d:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100c90:	e8 0e fd ff ff       	call   c01009a3 <print_stackframe>
    return 0;
c0100c95:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c9a:	c9                   	leave  
c0100c9b:	c3                   	ret    

c0100c9c <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100c9c:	55                   	push   %ebp
c0100c9d:	89 e5                	mov    %esp,%ebp
c0100c9f:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100ca2:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
c0100ca7:	85 c0                	test   %eax,%eax
c0100ca9:	75 4c                	jne    c0100cf7 <__panic+0x5b>
        goto panic_dead;
    }
    is_panic = 1;
c0100cab:	c7 05 60 7e 11 c0 01 	movl   $0x1,0xc0117e60
c0100cb2:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100cb5:	8d 55 14             	lea    0x14(%ebp),%edx
c0100cb8:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100cbb:	89 10                	mov    %edx,(%eax)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100cbd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100cc0:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100cc4:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cc7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ccb:	c7 04 24 9a 63 10 c0 	movl   $0xc010639a,(%esp)
c0100cd2:	e8 70 f6 ff ff       	call   c0100347 <cprintf>
    vcprintf(fmt, ap);
c0100cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cda:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cde:	8b 45 10             	mov    0x10(%ebp),%eax
c0100ce1:	89 04 24             	mov    %eax,(%esp)
c0100ce4:	e8 2b f6 ff ff       	call   c0100314 <vcprintf>
    cprintf("\n");
c0100ce9:	c7 04 24 b6 63 10 c0 	movl   $0xc01063b6,(%esp)
c0100cf0:	e8 52 f6 ff ff       	call   c0100347 <cprintf>
c0100cf5:	eb 01                	jmp    c0100cf8 <__panic+0x5c>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
c0100cf7:	90                   	nop
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    intr_disable();
c0100cf8:	e8 31 0a 00 00       	call   c010172e <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100cfd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d04:	e8 b2 fe ff ff       	call   c0100bbb <kmonitor>
    }
c0100d09:	eb f2                	jmp    c0100cfd <__panic+0x61>

c0100d0b <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d0b:	55                   	push   %ebp
c0100d0c:	89 e5                	mov    %esp,%ebp
c0100d0e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d11:	8d 55 14             	lea    0x14(%ebp),%edx
c0100d14:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100d17:	89 10                	mov    %edx,(%eax)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d19:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d1c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d20:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d23:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d27:	c7 04 24 b8 63 10 c0 	movl   $0xc01063b8,(%esp)
c0100d2e:	e8 14 f6 ff ff       	call   c0100347 <cprintf>
    vcprintf(fmt, ap);
c0100d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d36:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d3a:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d3d:	89 04 24             	mov    %eax,(%esp)
c0100d40:	e8 cf f5 ff ff       	call   c0100314 <vcprintf>
    cprintf("\n");
c0100d45:	c7 04 24 b6 63 10 c0 	movl   $0xc01063b6,(%esp)
c0100d4c:	e8 f6 f5 ff ff       	call   c0100347 <cprintf>
    va_end(ap);
}
c0100d51:	c9                   	leave  
c0100d52:	c3                   	ret    

c0100d53 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d53:	55                   	push   %ebp
c0100d54:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d56:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
}
c0100d5b:	5d                   	pop    %ebp
c0100d5c:	c3                   	ret    
c0100d5d:	00 00                	add    %al,(%eax)
	...

c0100d60 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d60:	55                   	push   %ebp
c0100d61:	89 e5                	mov    %esp,%ebp
c0100d63:	83 ec 28             	sub    $0x28,%esp
c0100d66:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d6c:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d70:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100d74:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100d78:	ee                   	out    %al,(%dx)
c0100d79:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100d7f:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100d83:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100d87:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100d8b:	ee                   	out    %al,(%dx)
c0100d8c:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100d92:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100d96:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100d9a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100d9e:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100d9f:	c7 05 4c 89 11 c0 00 	movl   $0x0,0xc011894c
c0100da6:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100da9:	c7 04 24 d6 63 10 c0 	movl   $0xc01063d6,(%esp)
c0100db0:	e8 92 f5 ff ff       	call   c0100347 <cprintf>
    pic_enable(IRQ_TIMER);
c0100db5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100dbc:	e8 cb 09 00 00       	call   c010178c <pic_enable>
}
c0100dc1:	c9                   	leave  
c0100dc2:	c3                   	ret    
	...

c0100dc4 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100dc4:	55                   	push   %ebp
c0100dc5:	89 e5                	mov    %esp,%ebp
c0100dc7:	53                   	push   %ebx
c0100dc8:	83 ec 14             	sub    $0x14,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100dcb:	9c                   	pushf  
c0100dcc:	5b                   	pop    %ebx
c0100dcd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return eflags;
c0100dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100dd3:	25 00 02 00 00       	and    $0x200,%eax
c0100dd8:	85 c0                	test   %eax,%eax
c0100dda:	74 0c                	je     c0100de8 <__intr_save+0x24>
        intr_disable();
c0100ddc:	e8 4d 09 00 00       	call   c010172e <intr_disable>
        return 1;
c0100de1:	b8 01 00 00 00       	mov    $0x1,%eax
c0100de6:	eb 05                	jmp    c0100ded <__intr_save+0x29>
    }
    return 0;
c0100de8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ded:	83 c4 14             	add    $0x14,%esp
c0100df0:	5b                   	pop    %ebx
c0100df1:	5d                   	pop    %ebp
c0100df2:	c3                   	ret    

c0100df3 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100df3:	55                   	push   %ebp
c0100df4:	89 e5                	mov    %esp,%ebp
c0100df6:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100df9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100dfd:	74 05                	je     c0100e04 <__intr_restore+0x11>
        intr_enable();
c0100dff:	e8 24 09 00 00       	call   c0101728 <intr_enable>
    }
}
c0100e04:	c9                   	leave  
c0100e05:	c3                   	ret    

c0100e06 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e06:	55                   	push   %ebp
c0100e07:	89 e5                	mov    %esp,%ebp
c0100e09:	53                   	push   %ebx
c0100e0a:	83 ec 14             	sub    $0x14,%esp
c0100e0d:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e13:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100e17:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0100e1b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100e1f:	ec                   	in     (%dx),%al
c0100e20:	89 c3                	mov    %eax,%ebx
c0100e22:	88 5d f9             	mov    %bl,-0x7(%ebp)
    return data;
c0100e25:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e2b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100e2f:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0100e33:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100e37:	ec                   	in     (%dx),%al
c0100e38:	89 c3                	mov    %eax,%ebx
c0100e3a:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
c0100e3d:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e43:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100e47:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0100e4b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100e4f:	ec                   	in     (%dx),%al
c0100e50:	89 c3                	mov    %eax,%ebx
c0100e52:	88 5d f1             	mov    %bl,-0xf(%ebp)
    return data;
c0100e55:	66 c7 45 ee 84 00    	movw   $0x84,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e5b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100e5f:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0100e63:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100e67:	ec                   	in     (%dx),%al
c0100e68:	89 c3                	mov    %eax,%ebx
c0100e6a:	88 5d ed             	mov    %bl,-0x13(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e6d:	83 c4 14             	add    $0x14,%esp
c0100e70:	5b                   	pop    %ebx
c0100e71:	5d                   	pop    %ebp
c0100e72:	c3                   	ret    

c0100e73 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e73:	55                   	push   %ebp
c0100e74:	89 e5                	mov    %esp,%ebp
c0100e76:	53                   	push   %ebx
c0100e77:	83 ec 24             	sub    $0x24,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e7a:	c7 45 f8 00 80 0b c0 	movl   $0xc00b8000,-0x8(%ebp)
    uint16_t was = *cp;
c0100e81:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100e84:	0f b7 00             	movzwl (%eax),%eax
c0100e87:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100e8e:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e93:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100e96:	0f b7 00             	movzwl (%eax),%eax
c0100e99:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100e9d:	74 12                	je     c0100eb1 <cga_init+0x3e>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e9f:	c7 45 f8 00 00 0b c0 	movl   $0xc00b0000,-0x8(%ebp)
        addr_6845 = MONO_BASE;
c0100ea6:	66 c7 05 86 7e 11 c0 	movw   $0x3b4,0xc0117e86
c0100ead:	b4 03 
c0100eaf:	eb 13                	jmp    c0100ec4 <cga_init+0x51>
    } else {
        *cp = was;
c0100eb1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100eb4:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100eb8:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100ebb:	66 c7 05 86 7e 11 c0 	movw   $0x3d4,0xc0117e86
c0100ec2:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ec4:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ecb:	0f b7 c0             	movzwl %ax,%eax
c0100ece:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100ed2:	c6 45 ed 0e          	movb   $0xe,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ed6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100eda:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100ede:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100edf:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ee6:	83 c0 01             	add    $0x1,%eax
c0100ee9:	0f b7 c0             	movzwl %ax,%eax
c0100eec:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ef0:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100ef4:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0100ef8:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0100efc:	ec                   	in     (%dx),%al
c0100efd:	89 c3                	mov    %eax,%ebx
c0100eff:	88 5d e9             	mov    %bl,-0x17(%ebp)
    return data;
c0100f02:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f06:	0f b6 c0             	movzbl %al,%eax
c0100f09:	c1 e0 08             	shl    $0x8,%eax
c0100f0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    outb(addr_6845, 15);
c0100f0f:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f16:	0f b7 c0             	movzwl %ax,%eax
c0100f19:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100f1d:	c6 45 e5 0f          	movb   $0xf,-0x1b(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f21:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f25:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100f29:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f2a:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f31:	83 c0 01             	add    $0x1,%eax
c0100f34:	0f b7 c0             	movzwl %ax,%eax
c0100f37:	66 89 45 e2          	mov    %ax,-0x1e(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f3b:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100f3f:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0100f43:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0100f47:	ec                   	in     (%dx),%al
c0100f48:	89 c3                	mov    %eax,%ebx
c0100f4a:	88 5d e1             	mov    %bl,-0x1f(%ebp)
    return data;
c0100f4d:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100f51:	0f b6 c0             	movzbl %al,%eax
c0100f54:	09 45 f0             	or     %eax,-0x10(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f57:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100f5a:	a3 80 7e 11 c0       	mov    %eax,0xc0117e80
    crt_pos = pos;
c0100f5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100f62:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
}
c0100f68:	83 c4 24             	add    $0x24,%esp
c0100f6b:	5b                   	pop    %ebx
c0100f6c:	5d                   	pop    %ebp
c0100f6d:	c3                   	ret    

c0100f6e <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f6e:	55                   	push   %ebp
c0100f6f:	89 e5                	mov    %esp,%ebp
c0100f71:	53                   	push   %ebx
c0100f72:	83 ec 54             	sub    $0x54,%esp
c0100f75:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f7b:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f7f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f83:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f87:	ee                   	out    %al,(%dx)
c0100f88:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f8e:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f92:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f96:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f9a:	ee                   	out    %al,(%dx)
c0100f9b:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100fa1:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100fa5:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100fa9:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100fad:	ee                   	out    %al,(%dx)
c0100fae:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fb4:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100fb8:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fbc:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fc0:	ee                   	out    %al,(%dx)
c0100fc1:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fc7:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fcb:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fcf:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fd3:	ee                   	out    %al,(%dx)
c0100fd4:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fda:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fde:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fe2:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fe6:	ee                   	out    %al,(%dx)
c0100fe7:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fed:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100ff1:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100ff5:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100ff9:	ee                   	out    %al,(%dx)
c0100ffa:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101000:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101004:	66 89 55 c6          	mov    %dx,-0x3a(%ebp)
c0101008:	0f b7 55 c6          	movzwl -0x3a(%ebp),%edx
c010100c:	ec                   	in     (%dx),%al
c010100d:	89 c3                	mov    %eax,%ebx
c010100f:	88 5d d9             	mov    %bl,-0x27(%ebp)
    return data;
c0101012:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101016:	3c ff                	cmp    $0xff,%al
c0101018:	0f 95 c0             	setne  %al
c010101b:	0f b6 c0             	movzbl %al,%eax
c010101e:	a3 88 7e 11 c0       	mov    %eax,0xc0117e88
c0101023:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101029:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c010102d:	66 89 55 c6          	mov    %dx,-0x3a(%ebp)
c0101031:	0f b7 55 c6          	movzwl -0x3a(%ebp),%edx
c0101035:	ec                   	in     (%dx),%al
c0101036:	89 c3                	mov    %eax,%ebx
c0101038:	88 5d d5             	mov    %bl,-0x2b(%ebp)
    return data;
c010103b:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101041:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101045:	66 89 55 c6          	mov    %dx,-0x3a(%ebp)
c0101049:	0f b7 55 c6          	movzwl -0x3a(%ebp),%edx
c010104d:	ec                   	in     (%dx),%al
c010104e:	89 c3                	mov    %eax,%ebx
c0101050:	88 5d d1             	mov    %bl,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101053:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0101058:	85 c0                	test   %eax,%eax
c010105a:	74 0c                	je     c0101068 <serial_init+0xfa>
        pic_enable(IRQ_COM1);
c010105c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101063:	e8 24 07 00 00       	call   c010178c <pic_enable>
    }
}
c0101068:	83 c4 54             	add    $0x54,%esp
c010106b:	5b                   	pop    %ebx
c010106c:	5d                   	pop    %ebp
c010106d:	c3                   	ret    

c010106e <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c010106e:	55                   	push   %ebp
c010106f:	89 e5                	mov    %esp,%ebp
c0101071:	53                   	push   %ebx
c0101072:	83 ec 24             	sub    $0x24,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101075:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c010107c:	eb 09                	jmp    c0101087 <lpt_putc_sub+0x19>
        delay();
c010107e:	e8 83 fd ff ff       	call   c0100e06 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101083:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c0101087:	66 c7 45 f6 79 03    	movw   $0x379,-0xa(%ebp)
c010108d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101091:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101095:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101099:	ec                   	in     (%dx),%al
c010109a:	89 c3                	mov    %eax,%ebx
c010109c:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
c010109f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01010a3:	84 c0                	test   %al,%al
c01010a5:	78 09                	js     c01010b0 <lpt_putc_sub+0x42>
c01010a7:	81 7d f8 ff 31 00 00 	cmpl   $0x31ff,-0x8(%ebp)
c01010ae:	7e ce                	jle    c010107e <lpt_putc_sub+0x10>
        delay();
    }
    outb(LPTPORT + 0, c);
c01010b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01010b3:	0f b6 c0             	movzbl %al,%eax
c01010b6:	66 c7 45 f2 78 03    	movw   $0x378,-0xe(%ebp)
c01010bc:	88 45 f1             	mov    %al,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01010bf:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010c3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010c7:	ee                   	out    %al,(%dx)
c01010c8:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010ce:	c6 45 ed 0d          	movb   $0xd,-0x13(%ebp)
c01010d2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010d6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010da:	ee                   	out    %al,(%dx)
c01010db:	66 c7 45 ea 7a 03    	movw   $0x37a,-0x16(%ebp)
c01010e1:	c6 45 e9 08          	movb   $0x8,-0x17(%ebp)
c01010e5:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01010e9:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01010ed:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010ee:	83 c4 24             	add    $0x24,%esp
c01010f1:	5b                   	pop    %ebx
c01010f2:	5d                   	pop    %ebp
c01010f3:	c3                   	ret    

c01010f4 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010f4:	55                   	push   %ebp
c01010f5:	89 e5                	mov    %esp,%ebp
c01010f7:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010fa:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010fe:	74 0d                	je     c010110d <lpt_putc+0x19>
        lpt_putc_sub(c);
c0101100:	8b 45 08             	mov    0x8(%ebp),%eax
c0101103:	89 04 24             	mov    %eax,(%esp)
c0101106:	e8 63 ff ff ff       	call   c010106e <lpt_putc_sub>
c010110b:	eb 24                	jmp    c0101131 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c010110d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101114:	e8 55 ff ff ff       	call   c010106e <lpt_putc_sub>
        lpt_putc_sub(' ');
c0101119:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101120:	e8 49 ff ff ff       	call   c010106e <lpt_putc_sub>
        lpt_putc_sub('\b');
c0101125:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010112c:	e8 3d ff ff ff       	call   c010106e <lpt_putc_sub>
    }
}
c0101131:	c9                   	leave  
c0101132:	c3                   	ret    

c0101133 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101133:	55                   	push   %ebp
c0101134:	89 e5                	mov    %esp,%ebp
c0101136:	53                   	push   %ebx
c0101137:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c010113a:	8b 45 08             	mov    0x8(%ebp),%eax
c010113d:	b0 00                	mov    $0x0,%al
c010113f:	85 c0                	test   %eax,%eax
c0101141:	75 07                	jne    c010114a <cga_putc+0x17>
        c |= 0x0700;
c0101143:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c010114a:	8b 45 08             	mov    0x8(%ebp),%eax
c010114d:	25 ff 00 00 00       	and    $0xff,%eax
c0101152:	83 f8 0a             	cmp    $0xa,%eax
c0101155:	74 4e                	je     c01011a5 <cga_putc+0x72>
c0101157:	83 f8 0d             	cmp    $0xd,%eax
c010115a:	74 59                	je     c01011b5 <cga_putc+0x82>
c010115c:	83 f8 08             	cmp    $0x8,%eax
c010115f:	0f 85 8c 00 00 00    	jne    c01011f1 <cga_putc+0xbe>
    case '\b':
        if (crt_pos > 0) {
c0101165:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010116c:	66 85 c0             	test   %ax,%ax
c010116f:	0f 84 a1 00 00 00    	je     c0101216 <cga_putc+0xe3>
            crt_pos --;
c0101175:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010117c:	83 e8 01             	sub    $0x1,%eax
c010117f:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101185:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c010118a:	0f b7 15 84 7e 11 c0 	movzwl 0xc0117e84,%edx
c0101191:	0f b7 d2             	movzwl %dx,%edx
c0101194:	01 d2                	add    %edx,%edx
c0101196:	01 c2                	add    %eax,%edx
c0101198:	8b 45 08             	mov    0x8(%ebp),%eax
c010119b:	b0 00                	mov    $0x0,%al
c010119d:	83 c8 20             	or     $0x20,%eax
c01011a0:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c01011a3:	eb 71                	jmp    c0101216 <cga_putc+0xe3>
    case '\n':
        crt_pos += CRT_COLS;
c01011a5:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011ac:	83 c0 50             	add    $0x50,%eax
c01011af:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c01011b5:	0f b7 1d 84 7e 11 c0 	movzwl 0xc0117e84,%ebx
c01011bc:	0f b7 0d 84 7e 11 c0 	movzwl 0xc0117e84,%ecx
c01011c3:	0f b7 c1             	movzwl %cx,%eax
c01011c6:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c01011cc:	c1 e8 10             	shr    $0x10,%eax
c01011cf:	89 c2                	mov    %eax,%edx
c01011d1:	66 c1 ea 06          	shr    $0x6,%dx
c01011d5:	89 d0                	mov    %edx,%eax
c01011d7:	c1 e0 02             	shl    $0x2,%eax
c01011da:	01 d0                	add    %edx,%eax
c01011dc:	c1 e0 04             	shl    $0x4,%eax
c01011df:	89 ca                	mov    %ecx,%edx
c01011e1:	66 29 c2             	sub    %ax,%dx
c01011e4:	89 d8                	mov    %ebx,%eax
c01011e6:	66 29 d0             	sub    %dx,%ax
c01011e9:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
        break;
c01011ef:	eb 26                	jmp    c0101217 <cga_putc+0xe4>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011f1:	8b 15 80 7e 11 c0    	mov    0xc0117e80,%edx
c01011f7:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011fe:	0f b7 c8             	movzwl %ax,%ecx
c0101201:	01 c9                	add    %ecx,%ecx
c0101203:	01 d1                	add    %edx,%ecx
c0101205:	8b 55 08             	mov    0x8(%ebp),%edx
c0101208:	66 89 11             	mov    %dx,(%ecx)
c010120b:	83 c0 01             	add    $0x1,%eax
c010120e:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
        break;
c0101214:	eb 01                	jmp    c0101217 <cga_putc+0xe4>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
c0101216:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c0101217:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010121e:	66 3d cf 07          	cmp    $0x7cf,%ax
c0101222:	76 5b                	jbe    c010127f <cga_putc+0x14c>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101224:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101229:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c010122f:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101234:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c010123b:	00 
c010123c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101240:	89 04 24             	mov    %eax,(%esp)
c0101243:	e8 ee 4c 00 00       	call   c0105f36 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101248:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c010124f:	eb 15                	jmp    c0101266 <cga_putc+0x133>
            crt_buf[i] = 0x0700 | ' ';
c0101251:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101256:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101259:	01 d2                	add    %edx,%edx
c010125b:	01 d0                	add    %edx,%eax
c010125d:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101262:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101266:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010126d:	7e e2                	jle    c0101251 <cga_putc+0x11e>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c010126f:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101276:	83 e8 50             	sub    $0x50,%eax
c0101279:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c010127f:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0101286:	0f b7 c0             	movzwl %ax,%eax
c0101289:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c010128d:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101291:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101295:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101299:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c010129a:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01012a1:	66 c1 e8 08          	shr    $0x8,%ax
c01012a5:	0f b6 c0             	movzbl %al,%eax
c01012a8:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c01012af:	83 c2 01             	add    $0x1,%edx
c01012b2:	0f b7 d2             	movzwl %dx,%edx
c01012b5:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c01012b9:	88 45 ed             	mov    %al,-0x13(%ebp)
c01012bc:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01012c0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01012c4:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c01012c5:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c01012cc:	0f b7 c0             	movzwl %ax,%eax
c01012cf:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c01012d3:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c01012d7:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012db:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012df:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01012e0:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01012e7:	0f b6 c0             	movzbl %al,%eax
c01012ea:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c01012f1:	83 c2 01             	add    $0x1,%edx
c01012f4:	0f b7 d2             	movzwl %dx,%edx
c01012f7:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012fb:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012fe:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101302:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101306:	ee                   	out    %al,(%dx)
}
c0101307:	83 c4 34             	add    $0x34,%esp
c010130a:	5b                   	pop    %ebx
c010130b:	5d                   	pop    %ebp
c010130c:	c3                   	ret    

c010130d <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c010130d:	55                   	push   %ebp
c010130e:	89 e5                	mov    %esp,%ebp
c0101310:	53                   	push   %ebx
c0101311:	83 ec 14             	sub    $0x14,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101314:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c010131b:	eb 09                	jmp    c0101326 <serial_putc_sub+0x19>
        delay();
c010131d:	e8 e4 fa ff ff       	call   c0100e06 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101322:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c0101326:	66 c7 45 f6 fd 03    	movw   $0x3fd,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010132c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101330:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101334:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101338:	ec                   	in     (%dx),%al
c0101339:	89 c3                	mov    %eax,%ebx
c010133b:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
c010133e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101342:	0f b6 c0             	movzbl %al,%eax
c0101345:	83 e0 20             	and    $0x20,%eax
c0101348:	85 c0                	test   %eax,%eax
c010134a:	75 09                	jne    c0101355 <serial_putc_sub+0x48>
c010134c:	81 7d f8 ff 31 00 00 	cmpl   $0x31ff,-0x8(%ebp)
c0101353:	7e c8                	jle    c010131d <serial_putc_sub+0x10>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101355:	8b 45 08             	mov    0x8(%ebp),%eax
c0101358:	0f b6 c0             	movzbl %al,%eax
c010135b:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
c0101361:	88 45 f1             	mov    %al,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101364:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101368:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010136c:	ee                   	out    %al,(%dx)
}
c010136d:	83 c4 14             	add    $0x14,%esp
c0101370:	5b                   	pop    %ebx
c0101371:	5d                   	pop    %ebp
c0101372:	c3                   	ret    

c0101373 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101373:	55                   	push   %ebp
c0101374:	89 e5                	mov    %esp,%ebp
c0101376:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101379:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010137d:	74 0d                	je     c010138c <serial_putc+0x19>
        serial_putc_sub(c);
c010137f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101382:	89 04 24             	mov    %eax,(%esp)
c0101385:	e8 83 ff ff ff       	call   c010130d <serial_putc_sub>
c010138a:	eb 24                	jmp    c01013b0 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c010138c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101393:	e8 75 ff ff ff       	call   c010130d <serial_putc_sub>
        serial_putc_sub(' ');
c0101398:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010139f:	e8 69 ff ff ff       	call   c010130d <serial_putc_sub>
        serial_putc_sub('\b');
c01013a4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01013ab:	e8 5d ff ff ff       	call   c010130d <serial_putc_sub>
    }
}
c01013b0:	c9                   	leave  
c01013b1:	c3                   	ret    

c01013b2 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c01013b2:	55                   	push   %ebp
c01013b3:	89 e5                	mov    %esp,%ebp
c01013b5:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c01013b8:	eb 32                	jmp    c01013ec <cons_intr+0x3a>
        if (c != 0) {
c01013ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01013be:	74 2c                	je     c01013ec <cons_intr+0x3a>
            cons.buf[cons.wpos ++] = c;
c01013c0:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c01013c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01013c8:	88 90 a0 7e 11 c0    	mov    %dl,-0x3fee8160(%eax)
c01013ce:	83 c0 01             	add    $0x1,%eax
c01013d1:	a3 a4 80 11 c0       	mov    %eax,0xc01180a4
            if (cons.wpos == CONSBUFSIZE) {
c01013d6:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c01013db:	3d 00 02 00 00       	cmp    $0x200,%eax
c01013e0:	75 0a                	jne    c01013ec <cons_intr+0x3a>
                cons.wpos = 0;
c01013e2:	c7 05 a4 80 11 c0 00 	movl   $0x0,0xc01180a4
c01013e9:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c01013ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01013ef:	ff d0                	call   *%eax
c01013f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013f4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013f8:	75 c0                	jne    c01013ba <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013fa:	c9                   	leave  
c01013fb:	c3                   	ret    

c01013fc <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013fc:	55                   	push   %ebp
c01013fd:	89 e5                	mov    %esp,%ebp
c01013ff:	53                   	push   %ebx
c0101400:	83 ec 14             	sub    $0x14,%esp
c0101403:	66 c7 45 f6 fd 03    	movw   $0x3fd,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101409:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010140d:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101411:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101415:	ec                   	in     (%dx),%al
c0101416:	89 c3                	mov    %eax,%ebx
c0101418:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
c010141b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c010141f:	0f b6 c0             	movzbl %al,%eax
c0101422:	83 e0 01             	and    $0x1,%eax
c0101425:	85 c0                	test   %eax,%eax
c0101427:	75 07                	jne    c0101430 <serial_proc_data+0x34>
        return -1;
c0101429:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010142e:	eb 32                	jmp    c0101462 <serial_proc_data+0x66>
c0101430:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101436:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010143a:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c010143e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101442:	ec                   	in     (%dx),%al
c0101443:	89 c3                	mov    %eax,%ebx
c0101445:	88 5d f1             	mov    %bl,-0xf(%ebp)
    return data;
c0101448:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c010144c:	0f b6 c0             	movzbl %al,%eax
c010144f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if (c == 127) {
c0101452:	83 7d f8 7f          	cmpl   $0x7f,-0x8(%ebp)
c0101456:	75 07                	jne    c010145f <serial_proc_data+0x63>
        c = '\b';
c0101458:	c7 45 f8 08 00 00 00 	movl   $0x8,-0x8(%ebp)
    }
    return c;
c010145f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0101462:	83 c4 14             	add    $0x14,%esp
c0101465:	5b                   	pop    %ebx
c0101466:	5d                   	pop    %ebp
c0101467:	c3                   	ret    

c0101468 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101468:	55                   	push   %ebp
c0101469:	89 e5                	mov    %esp,%ebp
c010146b:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c010146e:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0101473:	85 c0                	test   %eax,%eax
c0101475:	74 0c                	je     c0101483 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101477:	c7 04 24 fc 13 10 c0 	movl   $0xc01013fc,(%esp)
c010147e:	e8 2f ff ff ff       	call   c01013b2 <cons_intr>
    }
}
c0101483:	c9                   	leave  
c0101484:	c3                   	ret    

c0101485 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101485:	55                   	push   %ebp
c0101486:	89 e5                	mov    %esp,%ebp
c0101488:	53                   	push   %ebx
c0101489:	83 ec 44             	sub    $0x44,%esp
c010148c:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101492:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c0101496:	66 89 55 d6          	mov    %dx,-0x2a(%ebp)
c010149a:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c010149e:	ec                   	in     (%dx),%al
c010149f:	89 c3                	mov    %eax,%ebx
c01014a1:	88 5d ef             	mov    %bl,-0x11(%ebp)
    return data;
c01014a4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c01014a8:	0f b6 c0             	movzbl %al,%eax
c01014ab:	83 e0 01             	and    $0x1,%eax
c01014ae:	85 c0                	test   %eax,%eax
c01014b0:	75 0a                	jne    c01014bc <kbd_proc_data+0x37>
        return -1;
c01014b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01014b7:	e9 61 01 00 00       	jmp    c010161d <kbd_proc_data+0x198>
c01014bc:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014c2:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c01014c6:	66 89 55 d6          	mov    %dx,-0x2a(%ebp)
c01014ca:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01014ce:	ec                   	in     (%dx),%al
c01014cf:	89 c3                	mov    %eax,%ebx
c01014d1:	88 5d eb             	mov    %bl,-0x15(%ebp)
    return data;
c01014d4:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c01014d8:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c01014db:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c01014df:	75 17                	jne    c01014f8 <kbd_proc_data+0x73>
        // E0 escape character
        shift |= E0ESC;
c01014e1:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014e6:	83 c8 40             	or     $0x40,%eax
c01014e9:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c01014ee:	b8 00 00 00 00       	mov    $0x0,%eax
c01014f3:	e9 25 01 00 00       	jmp    c010161d <kbd_proc_data+0x198>
    } else if (data & 0x80) {
c01014f8:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014fc:	84 c0                	test   %al,%al
c01014fe:	79 47                	jns    c0101547 <kbd_proc_data+0xc2>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101500:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101505:	83 e0 40             	and    $0x40,%eax
c0101508:	85 c0                	test   %eax,%eax
c010150a:	75 09                	jne    c0101515 <kbd_proc_data+0x90>
c010150c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101510:	83 e0 7f             	and    $0x7f,%eax
c0101513:	eb 04                	jmp    c0101519 <kbd_proc_data+0x94>
c0101515:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101519:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c010151c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101520:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c0101527:	83 c8 40             	or     $0x40,%eax
c010152a:	0f b6 c0             	movzbl %al,%eax
c010152d:	f7 d0                	not    %eax
c010152f:	89 c2                	mov    %eax,%edx
c0101531:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101536:	21 d0                	and    %edx,%eax
c0101538:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c010153d:	b8 00 00 00 00       	mov    $0x0,%eax
c0101542:	e9 d6 00 00 00       	jmp    c010161d <kbd_proc_data+0x198>
    } else if (shift & E0ESC) {
c0101547:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010154c:	83 e0 40             	and    $0x40,%eax
c010154f:	85 c0                	test   %eax,%eax
c0101551:	74 11                	je     c0101564 <kbd_proc_data+0xdf>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c0101553:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c0101557:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010155c:	83 e0 bf             	and    $0xffffffbf,%eax
c010155f:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    }

    shift |= shiftcode[data];
c0101564:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101568:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c010156f:	0f b6 d0             	movzbl %al,%edx
c0101572:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101577:	09 d0                	or     %edx,%eax
c0101579:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    shift ^= togglecode[data];
c010157e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101582:	0f b6 80 60 71 11 c0 	movzbl -0x3fee8ea0(%eax),%eax
c0101589:	0f b6 d0             	movzbl %al,%edx
c010158c:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101591:	31 d0                	xor    %edx,%eax
c0101593:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8

    c = charcode[shift & (CTL | SHIFT)][data];
c0101598:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010159d:	83 e0 03             	and    $0x3,%eax
c01015a0:	8b 14 85 60 75 11 c0 	mov    -0x3fee8aa0(,%eax,4),%edx
c01015a7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015ab:	01 d0                	add    %edx,%eax
c01015ad:	0f b6 00             	movzbl (%eax),%eax
c01015b0:	0f b6 c0             	movzbl %al,%eax
c01015b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c01015b6:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01015bb:	83 e0 08             	and    $0x8,%eax
c01015be:	85 c0                	test   %eax,%eax
c01015c0:	74 22                	je     c01015e4 <kbd_proc_data+0x15f>
        if ('a' <= c && c <= 'z')
c01015c2:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c01015c6:	7e 0c                	jle    c01015d4 <kbd_proc_data+0x14f>
c01015c8:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c01015cc:	7f 06                	jg     c01015d4 <kbd_proc_data+0x14f>
            c += 'A' - 'a';
c01015ce:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c01015d2:	eb 10                	jmp    c01015e4 <kbd_proc_data+0x15f>
        else if ('A' <= c && c <= 'Z')
c01015d4:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c01015d8:	7e 0a                	jle    c01015e4 <kbd_proc_data+0x15f>
c01015da:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c01015de:	7f 04                	jg     c01015e4 <kbd_proc_data+0x15f>
            c += 'a' - 'A';
c01015e0:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c01015e4:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01015e9:	f7 d0                	not    %eax
c01015eb:	83 e0 06             	and    $0x6,%eax
c01015ee:	85 c0                	test   %eax,%eax
c01015f0:	75 28                	jne    c010161a <kbd_proc_data+0x195>
c01015f2:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c01015f9:	75 1f                	jne    c010161a <kbd_proc_data+0x195>
        cprintf("Rebooting!\n");
c01015fb:	c7 04 24 f1 63 10 c0 	movl   $0xc01063f1,(%esp)
c0101602:	e8 40 ed ff ff       	call   c0100347 <cprintf>
c0101607:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c010160d:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101611:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101615:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c0101619:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c010161a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010161d:	83 c4 44             	add    $0x44,%esp
c0101620:	5b                   	pop    %ebx
c0101621:	5d                   	pop    %ebp
c0101622:	c3                   	ret    

c0101623 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c0101623:	55                   	push   %ebp
c0101624:	89 e5                	mov    %esp,%ebp
c0101626:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c0101629:	c7 04 24 85 14 10 c0 	movl   $0xc0101485,(%esp)
c0101630:	e8 7d fd ff ff       	call   c01013b2 <cons_intr>
}
c0101635:	c9                   	leave  
c0101636:	c3                   	ret    

c0101637 <kbd_init>:

static void
kbd_init(void) {
c0101637:	55                   	push   %ebp
c0101638:	89 e5                	mov    %esp,%ebp
c010163a:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c010163d:	e8 e1 ff ff ff       	call   c0101623 <kbd_intr>
    pic_enable(IRQ_KBD);
c0101642:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0101649:	e8 3e 01 00 00       	call   c010178c <pic_enable>
}
c010164e:	c9                   	leave  
c010164f:	c3                   	ret    

c0101650 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c0101650:	55                   	push   %ebp
c0101651:	89 e5                	mov    %esp,%ebp
c0101653:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c0101656:	e8 18 f8 ff ff       	call   c0100e73 <cga_init>
    serial_init();
c010165b:	e8 0e f9 ff ff       	call   c0100f6e <serial_init>
    kbd_init();
c0101660:	e8 d2 ff ff ff       	call   c0101637 <kbd_init>
    if (!serial_exists) {
c0101665:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c010166a:	85 c0                	test   %eax,%eax
c010166c:	75 0c                	jne    c010167a <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c010166e:	c7 04 24 fd 63 10 c0 	movl   $0xc01063fd,(%esp)
c0101675:	e8 cd ec ff ff       	call   c0100347 <cprintf>
    }
}
c010167a:	c9                   	leave  
c010167b:	c3                   	ret    

c010167c <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c010167c:	55                   	push   %ebp
c010167d:	89 e5                	mov    %esp,%ebp
c010167f:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101682:	e8 3d f7 ff ff       	call   c0100dc4 <__intr_save>
c0101687:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c010168a:	8b 45 08             	mov    0x8(%ebp),%eax
c010168d:	89 04 24             	mov    %eax,(%esp)
c0101690:	e8 5f fa ff ff       	call   c01010f4 <lpt_putc>
        cga_putc(c);
c0101695:	8b 45 08             	mov    0x8(%ebp),%eax
c0101698:	89 04 24             	mov    %eax,(%esp)
c010169b:	e8 93 fa ff ff       	call   c0101133 <cga_putc>
        serial_putc(c);
c01016a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01016a3:	89 04 24             	mov    %eax,(%esp)
c01016a6:	e8 c8 fc ff ff       	call   c0101373 <serial_putc>
    }
    local_intr_restore(intr_flag);
c01016ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01016ae:	89 04 24             	mov    %eax,(%esp)
c01016b1:	e8 3d f7 ff ff       	call   c0100df3 <__intr_restore>
}
c01016b6:	c9                   	leave  
c01016b7:	c3                   	ret    

c01016b8 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c01016b8:	55                   	push   %ebp
c01016b9:	89 e5                	mov    %esp,%ebp
c01016bb:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c01016be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c01016c5:	e8 fa f6 ff ff       	call   c0100dc4 <__intr_save>
c01016ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c01016cd:	e8 96 fd ff ff       	call   c0101468 <serial_intr>
        kbd_intr();
c01016d2:	e8 4c ff ff ff       	call   c0101623 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c01016d7:	8b 15 a0 80 11 c0    	mov    0xc01180a0,%edx
c01016dd:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c01016e2:	39 c2                	cmp    %eax,%edx
c01016e4:	74 30                	je     c0101716 <cons_getc+0x5e>
            c = cons.buf[cons.rpos ++];
c01016e6:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c01016eb:	0f b6 90 a0 7e 11 c0 	movzbl -0x3fee8160(%eax),%edx
c01016f2:	0f b6 d2             	movzbl %dl,%edx
c01016f5:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01016f8:	83 c0 01             	add    $0x1,%eax
c01016fb:	a3 a0 80 11 c0       	mov    %eax,0xc01180a0
            if (cons.rpos == CONSBUFSIZE) {
c0101700:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101705:	3d 00 02 00 00       	cmp    $0x200,%eax
c010170a:	75 0a                	jne    c0101716 <cons_getc+0x5e>
                cons.rpos = 0;
c010170c:	c7 05 a0 80 11 c0 00 	movl   $0x0,0xc01180a0
c0101713:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101716:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101719:	89 04 24             	mov    %eax,(%esp)
c010171c:	e8 d2 f6 ff ff       	call   c0100df3 <__intr_restore>
    return c;
c0101721:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101724:	c9                   	leave  
c0101725:	c3                   	ret    
	...

c0101728 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101728:	55                   	push   %ebp
c0101729:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c010172b:	fb                   	sti    
    sti();
}
c010172c:	5d                   	pop    %ebp
c010172d:	c3                   	ret    

c010172e <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c010172e:	55                   	push   %ebp
c010172f:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c0101731:	fa                   	cli    
    cli();
}
c0101732:	5d                   	pop    %ebp
c0101733:	c3                   	ret    

c0101734 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101734:	55                   	push   %ebp
c0101735:	89 e5                	mov    %esp,%ebp
c0101737:	83 ec 14             	sub    $0x14,%esp
c010173a:	8b 45 08             	mov    0x8(%ebp),%eax
c010173d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101741:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101745:	66 a3 70 75 11 c0    	mov    %ax,0xc0117570
    if (did_init) {
c010174b:	a1 ac 80 11 c0       	mov    0xc01180ac,%eax
c0101750:	85 c0                	test   %eax,%eax
c0101752:	74 36                	je     c010178a <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c0101754:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101758:	0f b6 c0             	movzbl %al,%eax
c010175b:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101761:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101764:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101768:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010176c:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c010176d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101771:	66 c1 e8 08          	shr    $0x8,%ax
c0101775:	0f b6 c0             	movzbl %al,%eax
c0101778:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c010177e:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101781:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101785:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101789:	ee                   	out    %al,(%dx)
    }
}
c010178a:	c9                   	leave  
c010178b:	c3                   	ret    

c010178c <pic_enable>:

void
pic_enable(unsigned int irq) {
c010178c:	55                   	push   %ebp
c010178d:	89 e5                	mov    %esp,%ebp
c010178f:	53                   	push   %ebx
c0101790:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101793:	8b 45 08             	mov    0x8(%ebp),%eax
c0101796:	ba 01 00 00 00       	mov    $0x1,%edx
c010179b:	89 d3                	mov    %edx,%ebx
c010179d:	89 c1                	mov    %eax,%ecx
c010179f:	d3 e3                	shl    %cl,%ebx
c01017a1:	89 d8                	mov    %ebx,%eax
c01017a3:	89 c2                	mov    %eax,%edx
c01017a5:	f7 d2                	not    %edx
c01017a7:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c01017ae:	21 d0                	and    %edx,%eax
c01017b0:	0f b7 c0             	movzwl %ax,%eax
c01017b3:	89 04 24             	mov    %eax,(%esp)
c01017b6:	e8 79 ff ff ff       	call   c0101734 <pic_setmask>
}
c01017bb:	83 c4 04             	add    $0x4,%esp
c01017be:	5b                   	pop    %ebx
c01017bf:	5d                   	pop    %ebp
c01017c0:	c3                   	ret    

c01017c1 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c01017c1:	55                   	push   %ebp
c01017c2:	89 e5                	mov    %esp,%ebp
c01017c4:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c01017c7:	c7 05 ac 80 11 c0 01 	movl   $0x1,0xc01180ac
c01017ce:	00 00 00 
c01017d1:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01017d7:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c01017db:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01017df:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01017e3:	ee                   	out    %al,(%dx)
c01017e4:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c01017ea:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c01017ee:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01017f2:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01017f6:	ee                   	out    %al,(%dx)
c01017f7:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c01017fd:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c0101801:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101805:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101809:	ee                   	out    %al,(%dx)
c010180a:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c0101810:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c0101814:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101818:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010181c:	ee                   	out    %al,(%dx)
c010181d:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c0101823:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c0101827:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010182b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010182f:	ee                   	out    %al,(%dx)
c0101830:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c0101836:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c010183a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010183e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101842:	ee                   	out    %al,(%dx)
c0101843:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c0101849:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c010184d:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101851:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101855:	ee                   	out    %al,(%dx)
c0101856:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c010185c:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c0101860:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101864:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101868:	ee                   	out    %al,(%dx)
c0101869:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c010186f:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c0101873:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101877:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c010187b:	ee                   	out    %al,(%dx)
c010187c:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c0101882:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c0101886:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010188a:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c010188e:	ee                   	out    %al,(%dx)
c010188f:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c0101895:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0101899:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010189d:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01018a1:	ee                   	out    %al,(%dx)
c01018a2:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c01018a8:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c01018ac:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01018b0:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01018b4:	ee                   	out    %al,(%dx)
c01018b5:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c01018bb:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c01018bf:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01018c3:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01018c7:	ee                   	out    %al,(%dx)
c01018c8:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c01018ce:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c01018d2:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01018d6:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c01018da:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c01018db:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c01018e2:	66 83 f8 ff          	cmp    $0xffff,%ax
c01018e6:	74 12                	je     c01018fa <pic_init+0x139>
        pic_setmask(irq_mask);
c01018e8:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c01018ef:	0f b7 c0             	movzwl %ax,%eax
c01018f2:	89 04 24             	mov    %eax,(%esp)
c01018f5:	e8 3a fe ff ff       	call   c0101734 <pic_setmask>
    }
}
c01018fa:	c9                   	leave  
c01018fb:	c3                   	ret    

c01018fc <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c01018fc:	55                   	push   %ebp
c01018fd:	89 e5                	mov    %esp,%ebp
c01018ff:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0101902:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0101909:	00 
c010190a:	c7 04 24 20 64 10 c0 	movl   $0xc0106420,(%esp)
c0101911:	e8 31 ea ff ff       	call   c0100347 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c0101916:	c9                   	leave  
c0101917:	c3                   	ret    

c0101918 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0101918:	55                   	push   %ebp
c0101919:	89 e5                	mov    %esp,%ebp
c010191b:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	int i;
	extern uintptr_t __vectors[];
	for(i=0;i<256;i++){	
c010191e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101925:	e9 c3 00 00 00       	jmp    c01019ed <idt_init+0xd5>
	   SETGATE(idt[i],0,GD_KTEXT,__vectors[i],DPL_KERNEL);
c010192a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010192d:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c0101934:	89 c2                	mov    %eax,%edx
c0101936:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101939:	66 89 14 c5 c0 80 11 	mov    %dx,-0x3fee7f40(,%eax,8)
c0101940:	c0 
c0101941:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101944:	66 c7 04 c5 c2 80 11 	movw   $0x8,-0x3fee7f3e(,%eax,8)
c010194b:	c0 08 00 
c010194e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101951:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c0101958:	c0 
c0101959:	83 e2 e0             	and    $0xffffffe0,%edx
c010195c:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c0101963:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101966:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c010196d:	c0 
c010196e:	83 e2 1f             	and    $0x1f,%edx
c0101971:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c0101978:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010197b:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101982:	c0 
c0101983:	83 e2 f0             	and    $0xfffffff0,%edx
c0101986:	83 ca 0e             	or     $0xe,%edx
c0101989:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101990:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101993:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010199a:	c0 
c010199b:	83 e2 ef             	and    $0xffffffef,%edx
c010199e:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c01019a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019a8:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c01019af:	c0 
c01019b0:	83 e2 9f             	and    $0xffffff9f,%edx
c01019b3:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c01019ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019bd:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c01019c4:	c0 
c01019c5:	83 ca 80             	or     $0xffffff80,%edx
c01019c8:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c01019cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019d2:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c01019d9:	c1 e8 10             	shr    $0x10,%eax
c01019dc:	89 c2                	mov    %eax,%edx
c01019de:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019e1:	66 89 14 c5 c6 80 11 	mov    %dx,-0x3fee7f3a(,%eax,8)
c01019e8:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	int i;
	extern uintptr_t __vectors[];
	for(i=0;i<256;i++){	
c01019e9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01019ed:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c01019f4:	0f 8e 30 ff ff ff    	jle    c010192a <idt_init+0x12>
	   SETGATE(idt[i],0,GD_KTEXT,__vectors[i],DPL_KERNEL);
	}
	SETGATE(idt[T_SYSCALL],1,GD_KTEXT,__vectors[T_SYSCALL], DPL_USER);
c01019fa:	a1 00 78 11 c0       	mov    0xc0117800,%eax
c01019ff:	66 a3 c0 84 11 c0    	mov    %ax,0xc01184c0
c0101a05:	66 c7 05 c2 84 11 c0 	movw   $0x8,0xc01184c2
c0101a0c:	08 00 
c0101a0e:	0f b6 05 c4 84 11 c0 	movzbl 0xc01184c4,%eax
c0101a15:	83 e0 e0             	and    $0xffffffe0,%eax
c0101a18:	a2 c4 84 11 c0       	mov    %al,0xc01184c4
c0101a1d:	0f b6 05 c4 84 11 c0 	movzbl 0xc01184c4,%eax
c0101a24:	83 e0 1f             	and    $0x1f,%eax
c0101a27:	a2 c4 84 11 c0       	mov    %al,0xc01184c4
c0101a2c:	0f b6 05 c5 84 11 c0 	movzbl 0xc01184c5,%eax
c0101a33:	83 c8 0f             	or     $0xf,%eax
c0101a36:	a2 c5 84 11 c0       	mov    %al,0xc01184c5
c0101a3b:	0f b6 05 c5 84 11 c0 	movzbl 0xc01184c5,%eax
c0101a42:	83 e0 ef             	and    $0xffffffef,%eax
c0101a45:	a2 c5 84 11 c0       	mov    %al,0xc01184c5
c0101a4a:	0f b6 05 c5 84 11 c0 	movzbl 0xc01184c5,%eax
c0101a51:	83 c8 60             	or     $0x60,%eax
c0101a54:	a2 c5 84 11 c0       	mov    %al,0xc01184c5
c0101a59:	0f b6 05 c5 84 11 c0 	movzbl 0xc01184c5,%eax
c0101a60:	83 c8 80             	or     $0xffffff80,%eax
c0101a63:	a2 c5 84 11 c0       	mov    %al,0xc01184c5
c0101a68:	a1 00 78 11 c0       	mov    0xc0117800,%eax
c0101a6d:	c1 e8 10             	shr    $0x10,%eax
c0101a70:	66 a3 c6 84 11 c0    	mov    %ax,0xc01184c6
c0101a76:	c7 45 f8 80 75 11 c0 	movl   $0xc0117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101a7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101a80:	0f 01 18             	lidtl  (%eax)
	lidt(&idt_pd);
}
c0101a83:	c9                   	leave  
c0101a84:	c3                   	ret    

c0101a85 <trapname>:

static const char *
trapname(int trapno) {
c0101a85:	55                   	push   %ebp
c0101a86:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101a88:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a8b:	83 f8 13             	cmp    $0x13,%eax
c0101a8e:	77 0c                	ja     c0101a9c <trapname+0x17>
        return excnames[trapno];
c0101a90:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a93:	8b 04 85 80 67 10 c0 	mov    -0x3fef9880(,%eax,4),%eax
c0101a9a:	eb 18                	jmp    c0101ab4 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a9c:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101aa0:	7e 0d                	jle    c0101aaf <trapname+0x2a>
c0101aa2:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101aa6:	7f 07                	jg     c0101aaf <trapname+0x2a>
        return "Hardware Interrupt";
c0101aa8:	b8 2a 64 10 c0       	mov    $0xc010642a,%eax
c0101aad:	eb 05                	jmp    c0101ab4 <trapname+0x2f>
    }
    return "(unknown trap)";
c0101aaf:	b8 3d 64 10 c0       	mov    $0xc010643d,%eax
}
c0101ab4:	5d                   	pop    %ebp
c0101ab5:	c3                   	ret    

c0101ab6 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101ab6:	55                   	push   %ebp
c0101ab7:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101ab9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101abc:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101ac0:	66 83 f8 08          	cmp    $0x8,%ax
c0101ac4:	0f 94 c0             	sete   %al
c0101ac7:	0f b6 c0             	movzbl %al,%eax
}
c0101aca:	5d                   	pop    %ebp
c0101acb:	c3                   	ret    

c0101acc <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101acc:	55                   	push   %ebp
c0101acd:	89 e5                	mov    %esp,%ebp
c0101acf:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101ad2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ad5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ad9:	c7 04 24 7e 64 10 c0 	movl   $0xc010647e,(%esp)
c0101ae0:	e8 62 e8 ff ff       	call   c0100347 <cprintf>
    print_regs(&tf->tf_regs);
c0101ae5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ae8:	89 04 24             	mov    %eax,(%esp)
c0101aeb:	e8 a1 01 00 00       	call   c0101c91 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101af0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101af3:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101af7:	0f b7 c0             	movzwl %ax,%eax
c0101afa:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101afe:	c7 04 24 8f 64 10 c0 	movl   $0xc010648f,(%esp)
c0101b05:	e8 3d e8 ff ff       	call   c0100347 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101b0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b0d:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101b11:	0f b7 c0             	movzwl %ax,%eax
c0101b14:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b18:	c7 04 24 a2 64 10 c0 	movl   $0xc01064a2,(%esp)
c0101b1f:	e8 23 e8 ff ff       	call   c0100347 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101b24:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b27:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101b2b:	0f b7 c0             	movzwl %ax,%eax
c0101b2e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b32:	c7 04 24 b5 64 10 c0 	movl   $0xc01064b5,(%esp)
c0101b39:	e8 09 e8 ff ff       	call   c0100347 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101b3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b41:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101b45:	0f b7 c0             	movzwl %ax,%eax
c0101b48:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b4c:	c7 04 24 c8 64 10 c0 	movl   $0xc01064c8,(%esp)
c0101b53:	e8 ef e7 ff ff       	call   c0100347 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101b58:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b5b:	8b 40 30             	mov    0x30(%eax),%eax
c0101b5e:	89 04 24             	mov    %eax,(%esp)
c0101b61:	e8 1f ff ff ff       	call   c0101a85 <trapname>
c0101b66:	8b 55 08             	mov    0x8(%ebp),%edx
c0101b69:	8b 52 30             	mov    0x30(%edx),%edx
c0101b6c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101b70:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101b74:	c7 04 24 db 64 10 c0 	movl   $0xc01064db,(%esp)
c0101b7b:	e8 c7 e7 ff ff       	call   c0100347 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101b80:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b83:	8b 40 34             	mov    0x34(%eax),%eax
c0101b86:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b8a:	c7 04 24 ed 64 10 c0 	movl   $0xc01064ed,(%esp)
c0101b91:	e8 b1 e7 ff ff       	call   c0100347 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b96:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b99:	8b 40 38             	mov    0x38(%eax),%eax
c0101b9c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ba0:	c7 04 24 fc 64 10 c0 	movl   $0xc01064fc,(%esp)
c0101ba7:	e8 9b e7 ff ff       	call   c0100347 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101bac:	8b 45 08             	mov    0x8(%ebp),%eax
c0101baf:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101bb3:	0f b7 c0             	movzwl %ax,%eax
c0101bb6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bba:	c7 04 24 0b 65 10 c0 	movl   $0xc010650b,(%esp)
c0101bc1:	e8 81 e7 ff ff       	call   c0100347 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101bc6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bc9:	8b 40 40             	mov    0x40(%eax),%eax
c0101bcc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bd0:	c7 04 24 1e 65 10 c0 	movl   $0xc010651e,(%esp)
c0101bd7:	e8 6b e7 ff ff       	call   c0100347 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101bdc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101be3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101bea:	eb 3e                	jmp    c0101c2a <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101bec:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bef:	8b 50 40             	mov    0x40(%eax),%edx
c0101bf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101bf5:	21 d0                	and    %edx,%eax
c0101bf7:	85 c0                	test   %eax,%eax
c0101bf9:	74 28                	je     c0101c23 <print_trapframe+0x157>
c0101bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bfe:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101c05:	85 c0                	test   %eax,%eax
c0101c07:	74 1a                	je     c0101c23 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c0c:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101c13:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c17:	c7 04 24 2d 65 10 c0 	movl   $0xc010652d,(%esp)
c0101c1e:	e8 24 e7 ff ff       	call   c0100347 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101c23:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101c27:	d1 65 f0             	shll   -0x10(%ebp)
c0101c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c2d:	83 f8 17             	cmp    $0x17,%eax
c0101c30:	76 ba                	jbe    c0101bec <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101c32:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c35:	8b 40 40             	mov    0x40(%eax),%eax
c0101c38:	25 00 30 00 00       	and    $0x3000,%eax
c0101c3d:	c1 e8 0c             	shr    $0xc,%eax
c0101c40:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c44:	c7 04 24 31 65 10 c0 	movl   $0xc0106531,(%esp)
c0101c4b:	e8 f7 e6 ff ff       	call   c0100347 <cprintf>

    if (!trap_in_kernel(tf)) {
c0101c50:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c53:	89 04 24             	mov    %eax,(%esp)
c0101c56:	e8 5b fe ff ff       	call   c0101ab6 <trap_in_kernel>
c0101c5b:	85 c0                	test   %eax,%eax
c0101c5d:	75 30                	jne    c0101c8f <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101c5f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c62:	8b 40 44             	mov    0x44(%eax),%eax
c0101c65:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c69:	c7 04 24 3a 65 10 c0 	movl   $0xc010653a,(%esp)
c0101c70:	e8 d2 e6 ff ff       	call   c0100347 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101c75:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c78:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101c7c:	0f b7 c0             	movzwl %ax,%eax
c0101c7f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c83:	c7 04 24 49 65 10 c0 	movl   $0xc0106549,(%esp)
c0101c8a:	e8 b8 e6 ff ff       	call   c0100347 <cprintf>
    }
}
c0101c8f:	c9                   	leave  
c0101c90:	c3                   	ret    

c0101c91 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101c91:	55                   	push   %ebp
c0101c92:	89 e5                	mov    %esp,%ebp
c0101c94:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101c97:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c9a:	8b 00                	mov    (%eax),%eax
c0101c9c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ca0:	c7 04 24 5c 65 10 c0 	movl   $0xc010655c,(%esp)
c0101ca7:	e8 9b e6 ff ff       	call   c0100347 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101cac:	8b 45 08             	mov    0x8(%ebp),%eax
c0101caf:	8b 40 04             	mov    0x4(%eax),%eax
c0101cb2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cb6:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0101cbd:	e8 85 e6 ff ff       	call   c0100347 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101cc2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cc5:	8b 40 08             	mov    0x8(%eax),%eax
c0101cc8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ccc:	c7 04 24 7a 65 10 c0 	movl   $0xc010657a,(%esp)
c0101cd3:	e8 6f e6 ff ff       	call   c0100347 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101cd8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cdb:	8b 40 0c             	mov    0xc(%eax),%eax
c0101cde:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ce2:	c7 04 24 89 65 10 c0 	movl   $0xc0106589,(%esp)
c0101ce9:	e8 59 e6 ff ff       	call   c0100347 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101cee:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cf1:	8b 40 10             	mov    0x10(%eax),%eax
c0101cf4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cf8:	c7 04 24 98 65 10 c0 	movl   $0xc0106598,(%esp)
c0101cff:	e8 43 e6 ff ff       	call   c0100347 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101d04:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d07:	8b 40 14             	mov    0x14(%eax),%eax
c0101d0a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d0e:	c7 04 24 a7 65 10 c0 	movl   $0xc01065a7,(%esp)
c0101d15:	e8 2d e6 ff ff       	call   c0100347 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101d1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d1d:	8b 40 18             	mov    0x18(%eax),%eax
c0101d20:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d24:	c7 04 24 b6 65 10 c0 	movl   $0xc01065b6,(%esp)
c0101d2b:	e8 17 e6 ff ff       	call   c0100347 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101d30:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d33:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101d36:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d3a:	c7 04 24 c5 65 10 c0 	movl   $0xc01065c5,(%esp)
c0101d41:	e8 01 e6 ff ff       	call   c0100347 <cprintf>
}
c0101d46:	c9                   	leave  
c0101d47:	c3                   	ret    

c0101d48 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101d48:	55                   	push   %ebp
c0101d49:	89 e5                	mov    %esp,%ebp
c0101d4b:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101d4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d51:	8b 40 30             	mov    0x30(%eax),%eax
c0101d54:	83 f8 2f             	cmp    $0x2f,%eax
c0101d57:	77 21                	ja     c0101d7a <trap_dispatch+0x32>
c0101d59:	83 f8 2e             	cmp    $0x2e,%eax
c0101d5c:	0f 83 05 01 00 00    	jae    c0101e67 <trap_dispatch+0x11f>
c0101d62:	83 f8 21             	cmp    $0x21,%eax
c0101d65:	0f 84 82 00 00 00    	je     c0101ded <trap_dispatch+0xa5>
c0101d6b:	83 f8 24             	cmp    $0x24,%eax
c0101d6e:	74 57                	je     c0101dc7 <trap_dispatch+0x7f>
c0101d70:	83 f8 20             	cmp    $0x20,%eax
c0101d73:	74 16                	je     c0101d8b <trap_dispatch+0x43>
c0101d75:	e9 b5 00 00 00       	jmp    c0101e2f <trap_dispatch+0xe7>
c0101d7a:	83 e8 78             	sub    $0x78,%eax
c0101d7d:	83 f8 01             	cmp    $0x1,%eax
c0101d80:	0f 87 a9 00 00 00    	ja     c0101e2f <trap_dispatch+0xe7>
c0101d86:	e9 88 00 00 00       	jmp    c0101e13 <trap_dispatch+0xcb>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
	ticks++;
c0101d8b:	a1 4c 89 11 c0       	mov    0xc011894c,%eax
c0101d90:	83 c0 01             	add    $0x1,%eax
c0101d93:	a3 4c 89 11 c0       	mov    %eax,0xc011894c
	if(ticks%100==0) print_ticks();
c0101d98:	8b 0d 4c 89 11 c0    	mov    0xc011894c,%ecx
c0101d9e:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101da3:	89 c8                	mov    %ecx,%eax
c0101da5:	f7 e2                	mul    %edx
c0101da7:	89 d0                	mov    %edx,%eax
c0101da9:	c1 e8 05             	shr    $0x5,%eax
c0101dac:	6b c0 64             	imul   $0x64,%eax,%eax
c0101daf:	89 ca                	mov    %ecx,%edx
c0101db1:	29 c2                	sub    %eax,%edx
c0101db3:	89 d0                	mov    %edx,%eax
c0101db5:	85 c0                	test   %eax,%eax
c0101db7:	0f 85 ad 00 00 00    	jne    c0101e6a <trap_dispatch+0x122>
c0101dbd:	e8 3a fb ff ff       	call   c01018fc <print_ticks>
        break;
c0101dc2:	e9 a3 00 00 00       	jmp    c0101e6a <trap_dispatch+0x122>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101dc7:	e8 ec f8 ff ff       	call   c01016b8 <cons_getc>
c0101dcc:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101dcf:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101dd3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101dd7:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101ddb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ddf:	c7 04 24 d4 65 10 c0 	movl   $0xc01065d4,(%esp)
c0101de6:	e8 5c e5 ff ff       	call   c0100347 <cprintf>
        break;
c0101deb:	eb 7e                	jmp    c0101e6b <trap_dispatch+0x123>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101ded:	e8 c6 f8 ff ff       	call   c01016b8 <cons_getc>
c0101df2:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101df5:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101df9:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101dfd:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101e01:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e05:	c7 04 24 e6 65 10 c0 	movl   $0xc01065e6,(%esp)
c0101e0c:	e8 36 e5 ff ff       	call   c0100347 <cprintf>
        break;
c0101e11:	eb 58                	jmp    c0101e6b <trap_dispatch+0x123>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101e13:	c7 44 24 08 f5 65 10 	movl   $0xc01065f5,0x8(%esp)
c0101e1a:	c0 
c0101e1b:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
c0101e22:	00 
c0101e23:	c7 04 24 05 66 10 c0 	movl   $0xc0106605,(%esp)
c0101e2a:	e8 6d ee ff ff       	call   c0100c9c <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101e2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e32:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101e36:	0f b7 c0             	movzwl %ax,%eax
c0101e39:	83 e0 03             	and    $0x3,%eax
c0101e3c:	85 c0                	test   %eax,%eax
c0101e3e:	75 2b                	jne    c0101e6b <trap_dispatch+0x123>
            print_trapframe(tf);
c0101e40:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e43:	89 04 24             	mov    %eax,(%esp)
c0101e46:	e8 81 fc ff ff       	call   c0101acc <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101e4b:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0101e52:	c0 
c0101e53:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
c0101e5a:	00 
c0101e5b:	c7 04 24 05 66 10 c0 	movl   $0xc0106605,(%esp)
c0101e62:	e8 35 ee ff ff       	call   c0100c9c <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101e67:	90                   	nop
c0101e68:	eb 01                	jmp    c0101e6b <trap_dispatch+0x123>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
	ticks++;
	if(ticks%100==0) print_ticks();
        break;
c0101e6a:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101e6b:	c9                   	leave  
c0101e6c:	c3                   	ret    

c0101e6d <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101e6d:	55                   	push   %ebp
c0101e6e:	89 e5                	mov    %esp,%ebp
c0101e70:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101e73:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e76:	89 04 24             	mov    %eax,(%esp)
c0101e79:	e8 ca fe ff ff       	call   c0101d48 <trap_dispatch>

}
c0101e7e:	c9                   	leave  
c0101e7f:	c3                   	ret    

c0101e80 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101e80:	1e                   	push   %ds
    pushl %es
c0101e81:	06                   	push   %es
    pushl %fs
c0101e82:	0f a0                	push   %fs
    pushl %gs
c0101e84:	0f a8                	push   %gs
    pushal
c0101e86:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101e87:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101e8c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101e8e:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101e90:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101e91:	e8 d7 ff ff ff       	call   c0101e6d <trap>

    # pop the pushed stack pointer
    popl %esp
c0101e96:	5c                   	pop    %esp

c0101e97 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101e97:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101e98:	0f a9                	pop    %gs
    popl %fs
c0101e9a:	0f a1                	pop    %fs
    popl %es
c0101e9c:	07                   	pop    %es
    popl %ds
c0101e9d:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101e9e:	83 c4 08             	add    $0x8,%esp
    iret
c0101ea1:	cf                   	iret   
	...

c0101ea4 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101ea4:	6a 00                	push   $0x0
  pushl $0
c0101ea6:	6a 00                	push   $0x0
  jmp __alltraps
c0101ea8:	e9 d3 ff ff ff       	jmp    c0101e80 <__alltraps>

c0101ead <vector1>:
.globl vector1
vector1:
  pushl $0
c0101ead:	6a 00                	push   $0x0
  pushl $1
c0101eaf:	6a 01                	push   $0x1
  jmp __alltraps
c0101eb1:	e9 ca ff ff ff       	jmp    c0101e80 <__alltraps>

c0101eb6 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101eb6:	6a 00                	push   $0x0
  pushl $2
c0101eb8:	6a 02                	push   $0x2
  jmp __alltraps
c0101eba:	e9 c1 ff ff ff       	jmp    c0101e80 <__alltraps>

c0101ebf <vector3>:
.globl vector3
vector3:
  pushl $0
c0101ebf:	6a 00                	push   $0x0
  pushl $3
c0101ec1:	6a 03                	push   $0x3
  jmp __alltraps
c0101ec3:	e9 b8 ff ff ff       	jmp    c0101e80 <__alltraps>

c0101ec8 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101ec8:	6a 00                	push   $0x0
  pushl $4
c0101eca:	6a 04                	push   $0x4
  jmp __alltraps
c0101ecc:	e9 af ff ff ff       	jmp    c0101e80 <__alltraps>

c0101ed1 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101ed1:	6a 00                	push   $0x0
  pushl $5
c0101ed3:	6a 05                	push   $0x5
  jmp __alltraps
c0101ed5:	e9 a6 ff ff ff       	jmp    c0101e80 <__alltraps>

c0101eda <vector6>:
.globl vector6
vector6:
  pushl $0
c0101eda:	6a 00                	push   $0x0
  pushl $6
c0101edc:	6a 06                	push   $0x6
  jmp __alltraps
c0101ede:	e9 9d ff ff ff       	jmp    c0101e80 <__alltraps>

c0101ee3 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101ee3:	6a 00                	push   $0x0
  pushl $7
c0101ee5:	6a 07                	push   $0x7
  jmp __alltraps
c0101ee7:	e9 94 ff ff ff       	jmp    c0101e80 <__alltraps>

c0101eec <vector8>:
.globl vector8
vector8:
  pushl $8
c0101eec:	6a 08                	push   $0x8
  jmp __alltraps
c0101eee:	e9 8d ff ff ff       	jmp    c0101e80 <__alltraps>

c0101ef3 <vector9>:
.globl vector9
vector9:
  pushl $9
c0101ef3:	6a 09                	push   $0x9
  jmp __alltraps
c0101ef5:	e9 86 ff ff ff       	jmp    c0101e80 <__alltraps>

c0101efa <vector10>:
.globl vector10
vector10:
  pushl $10
c0101efa:	6a 0a                	push   $0xa
  jmp __alltraps
c0101efc:	e9 7f ff ff ff       	jmp    c0101e80 <__alltraps>

c0101f01 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101f01:	6a 0b                	push   $0xb
  jmp __alltraps
c0101f03:	e9 78 ff ff ff       	jmp    c0101e80 <__alltraps>

c0101f08 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101f08:	6a 0c                	push   $0xc
  jmp __alltraps
c0101f0a:	e9 71 ff ff ff       	jmp    c0101e80 <__alltraps>

c0101f0f <vector13>:
.globl vector13
vector13:
  pushl $13
c0101f0f:	6a 0d                	push   $0xd
  jmp __alltraps
c0101f11:	e9 6a ff ff ff       	jmp    c0101e80 <__alltraps>

c0101f16 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101f16:	6a 0e                	push   $0xe
  jmp __alltraps
c0101f18:	e9 63 ff ff ff       	jmp    c0101e80 <__alltraps>

c0101f1d <vector15>:
.globl vector15
vector15:
  pushl $0
c0101f1d:	6a 00                	push   $0x0
  pushl $15
c0101f1f:	6a 0f                	push   $0xf
  jmp __alltraps
c0101f21:	e9 5a ff ff ff       	jmp    c0101e80 <__alltraps>

c0101f26 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101f26:	6a 00                	push   $0x0
  pushl $16
c0101f28:	6a 10                	push   $0x10
  jmp __alltraps
c0101f2a:	e9 51 ff ff ff       	jmp    c0101e80 <__alltraps>

c0101f2f <vector17>:
.globl vector17
vector17:
  pushl $17
c0101f2f:	6a 11                	push   $0x11
  jmp __alltraps
c0101f31:	e9 4a ff ff ff       	jmp    c0101e80 <__alltraps>

c0101f36 <vector18>:
.globl vector18
vector18:
  pushl $0
c0101f36:	6a 00                	push   $0x0
  pushl $18
c0101f38:	6a 12                	push   $0x12
  jmp __alltraps
c0101f3a:	e9 41 ff ff ff       	jmp    c0101e80 <__alltraps>

c0101f3f <vector19>:
.globl vector19
vector19:
  pushl $0
c0101f3f:	6a 00                	push   $0x0
  pushl $19
c0101f41:	6a 13                	push   $0x13
  jmp __alltraps
c0101f43:	e9 38 ff ff ff       	jmp    c0101e80 <__alltraps>

c0101f48 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101f48:	6a 00                	push   $0x0
  pushl $20
c0101f4a:	6a 14                	push   $0x14
  jmp __alltraps
c0101f4c:	e9 2f ff ff ff       	jmp    c0101e80 <__alltraps>

c0101f51 <vector21>:
.globl vector21
vector21:
  pushl $0
c0101f51:	6a 00                	push   $0x0
  pushl $21
c0101f53:	6a 15                	push   $0x15
  jmp __alltraps
c0101f55:	e9 26 ff ff ff       	jmp    c0101e80 <__alltraps>

c0101f5a <vector22>:
.globl vector22
vector22:
  pushl $0
c0101f5a:	6a 00                	push   $0x0
  pushl $22
c0101f5c:	6a 16                	push   $0x16
  jmp __alltraps
c0101f5e:	e9 1d ff ff ff       	jmp    c0101e80 <__alltraps>

c0101f63 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101f63:	6a 00                	push   $0x0
  pushl $23
c0101f65:	6a 17                	push   $0x17
  jmp __alltraps
c0101f67:	e9 14 ff ff ff       	jmp    c0101e80 <__alltraps>

c0101f6c <vector24>:
.globl vector24
vector24:
  pushl $0
c0101f6c:	6a 00                	push   $0x0
  pushl $24
c0101f6e:	6a 18                	push   $0x18
  jmp __alltraps
c0101f70:	e9 0b ff ff ff       	jmp    c0101e80 <__alltraps>

c0101f75 <vector25>:
.globl vector25
vector25:
  pushl $0
c0101f75:	6a 00                	push   $0x0
  pushl $25
c0101f77:	6a 19                	push   $0x19
  jmp __alltraps
c0101f79:	e9 02 ff ff ff       	jmp    c0101e80 <__alltraps>

c0101f7e <vector26>:
.globl vector26
vector26:
  pushl $0
c0101f7e:	6a 00                	push   $0x0
  pushl $26
c0101f80:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101f82:	e9 f9 fe ff ff       	jmp    c0101e80 <__alltraps>

c0101f87 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101f87:	6a 00                	push   $0x0
  pushl $27
c0101f89:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101f8b:	e9 f0 fe ff ff       	jmp    c0101e80 <__alltraps>

c0101f90 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101f90:	6a 00                	push   $0x0
  pushl $28
c0101f92:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101f94:	e9 e7 fe ff ff       	jmp    c0101e80 <__alltraps>

c0101f99 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101f99:	6a 00                	push   $0x0
  pushl $29
c0101f9b:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101f9d:	e9 de fe ff ff       	jmp    c0101e80 <__alltraps>

c0101fa2 <vector30>:
.globl vector30
vector30:
  pushl $0
c0101fa2:	6a 00                	push   $0x0
  pushl $30
c0101fa4:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101fa6:	e9 d5 fe ff ff       	jmp    c0101e80 <__alltraps>

c0101fab <vector31>:
.globl vector31
vector31:
  pushl $0
c0101fab:	6a 00                	push   $0x0
  pushl $31
c0101fad:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101faf:	e9 cc fe ff ff       	jmp    c0101e80 <__alltraps>

c0101fb4 <vector32>:
.globl vector32
vector32:
  pushl $0
c0101fb4:	6a 00                	push   $0x0
  pushl $32
c0101fb6:	6a 20                	push   $0x20
  jmp __alltraps
c0101fb8:	e9 c3 fe ff ff       	jmp    c0101e80 <__alltraps>

c0101fbd <vector33>:
.globl vector33
vector33:
  pushl $0
c0101fbd:	6a 00                	push   $0x0
  pushl $33
c0101fbf:	6a 21                	push   $0x21
  jmp __alltraps
c0101fc1:	e9 ba fe ff ff       	jmp    c0101e80 <__alltraps>

c0101fc6 <vector34>:
.globl vector34
vector34:
  pushl $0
c0101fc6:	6a 00                	push   $0x0
  pushl $34
c0101fc8:	6a 22                	push   $0x22
  jmp __alltraps
c0101fca:	e9 b1 fe ff ff       	jmp    c0101e80 <__alltraps>

c0101fcf <vector35>:
.globl vector35
vector35:
  pushl $0
c0101fcf:	6a 00                	push   $0x0
  pushl $35
c0101fd1:	6a 23                	push   $0x23
  jmp __alltraps
c0101fd3:	e9 a8 fe ff ff       	jmp    c0101e80 <__alltraps>

c0101fd8 <vector36>:
.globl vector36
vector36:
  pushl $0
c0101fd8:	6a 00                	push   $0x0
  pushl $36
c0101fda:	6a 24                	push   $0x24
  jmp __alltraps
c0101fdc:	e9 9f fe ff ff       	jmp    c0101e80 <__alltraps>

c0101fe1 <vector37>:
.globl vector37
vector37:
  pushl $0
c0101fe1:	6a 00                	push   $0x0
  pushl $37
c0101fe3:	6a 25                	push   $0x25
  jmp __alltraps
c0101fe5:	e9 96 fe ff ff       	jmp    c0101e80 <__alltraps>

c0101fea <vector38>:
.globl vector38
vector38:
  pushl $0
c0101fea:	6a 00                	push   $0x0
  pushl $38
c0101fec:	6a 26                	push   $0x26
  jmp __alltraps
c0101fee:	e9 8d fe ff ff       	jmp    c0101e80 <__alltraps>

c0101ff3 <vector39>:
.globl vector39
vector39:
  pushl $0
c0101ff3:	6a 00                	push   $0x0
  pushl $39
c0101ff5:	6a 27                	push   $0x27
  jmp __alltraps
c0101ff7:	e9 84 fe ff ff       	jmp    c0101e80 <__alltraps>

c0101ffc <vector40>:
.globl vector40
vector40:
  pushl $0
c0101ffc:	6a 00                	push   $0x0
  pushl $40
c0101ffe:	6a 28                	push   $0x28
  jmp __alltraps
c0102000:	e9 7b fe ff ff       	jmp    c0101e80 <__alltraps>

c0102005 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102005:	6a 00                	push   $0x0
  pushl $41
c0102007:	6a 29                	push   $0x29
  jmp __alltraps
c0102009:	e9 72 fe ff ff       	jmp    c0101e80 <__alltraps>

c010200e <vector42>:
.globl vector42
vector42:
  pushl $0
c010200e:	6a 00                	push   $0x0
  pushl $42
c0102010:	6a 2a                	push   $0x2a
  jmp __alltraps
c0102012:	e9 69 fe ff ff       	jmp    c0101e80 <__alltraps>

c0102017 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102017:	6a 00                	push   $0x0
  pushl $43
c0102019:	6a 2b                	push   $0x2b
  jmp __alltraps
c010201b:	e9 60 fe ff ff       	jmp    c0101e80 <__alltraps>

c0102020 <vector44>:
.globl vector44
vector44:
  pushl $0
c0102020:	6a 00                	push   $0x0
  pushl $44
c0102022:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102024:	e9 57 fe ff ff       	jmp    c0101e80 <__alltraps>

c0102029 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102029:	6a 00                	push   $0x0
  pushl $45
c010202b:	6a 2d                	push   $0x2d
  jmp __alltraps
c010202d:	e9 4e fe ff ff       	jmp    c0101e80 <__alltraps>

c0102032 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102032:	6a 00                	push   $0x0
  pushl $46
c0102034:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102036:	e9 45 fe ff ff       	jmp    c0101e80 <__alltraps>

c010203b <vector47>:
.globl vector47
vector47:
  pushl $0
c010203b:	6a 00                	push   $0x0
  pushl $47
c010203d:	6a 2f                	push   $0x2f
  jmp __alltraps
c010203f:	e9 3c fe ff ff       	jmp    c0101e80 <__alltraps>

c0102044 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102044:	6a 00                	push   $0x0
  pushl $48
c0102046:	6a 30                	push   $0x30
  jmp __alltraps
c0102048:	e9 33 fe ff ff       	jmp    c0101e80 <__alltraps>

c010204d <vector49>:
.globl vector49
vector49:
  pushl $0
c010204d:	6a 00                	push   $0x0
  pushl $49
c010204f:	6a 31                	push   $0x31
  jmp __alltraps
c0102051:	e9 2a fe ff ff       	jmp    c0101e80 <__alltraps>

c0102056 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102056:	6a 00                	push   $0x0
  pushl $50
c0102058:	6a 32                	push   $0x32
  jmp __alltraps
c010205a:	e9 21 fe ff ff       	jmp    c0101e80 <__alltraps>

c010205f <vector51>:
.globl vector51
vector51:
  pushl $0
c010205f:	6a 00                	push   $0x0
  pushl $51
c0102061:	6a 33                	push   $0x33
  jmp __alltraps
c0102063:	e9 18 fe ff ff       	jmp    c0101e80 <__alltraps>

c0102068 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102068:	6a 00                	push   $0x0
  pushl $52
c010206a:	6a 34                	push   $0x34
  jmp __alltraps
c010206c:	e9 0f fe ff ff       	jmp    c0101e80 <__alltraps>

c0102071 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102071:	6a 00                	push   $0x0
  pushl $53
c0102073:	6a 35                	push   $0x35
  jmp __alltraps
c0102075:	e9 06 fe ff ff       	jmp    c0101e80 <__alltraps>

c010207a <vector54>:
.globl vector54
vector54:
  pushl $0
c010207a:	6a 00                	push   $0x0
  pushl $54
c010207c:	6a 36                	push   $0x36
  jmp __alltraps
c010207e:	e9 fd fd ff ff       	jmp    c0101e80 <__alltraps>

c0102083 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102083:	6a 00                	push   $0x0
  pushl $55
c0102085:	6a 37                	push   $0x37
  jmp __alltraps
c0102087:	e9 f4 fd ff ff       	jmp    c0101e80 <__alltraps>

c010208c <vector56>:
.globl vector56
vector56:
  pushl $0
c010208c:	6a 00                	push   $0x0
  pushl $56
c010208e:	6a 38                	push   $0x38
  jmp __alltraps
c0102090:	e9 eb fd ff ff       	jmp    c0101e80 <__alltraps>

c0102095 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102095:	6a 00                	push   $0x0
  pushl $57
c0102097:	6a 39                	push   $0x39
  jmp __alltraps
c0102099:	e9 e2 fd ff ff       	jmp    c0101e80 <__alltraps>

c010209e <vector58>:
.globl vector58
vector58:
  pushl $0
c010209e:	6a 00                	push   $0x0
  pushl $58
c01020a0:	6a 3a                	push   $0x3a
  jmp __alltraps
c01020a2:	e9 d9 fd ff ff       	jmp    c0101e80 <__alltraps>

c01020a7 <vector59>:
.globl vector59
vector59:
  pushl $0
c01020a7:	6a 00                	push   $0x0
  pushl $59
c01020a9:	6a 3b                	push   $0x3b
  jmp __alltraps
c01020ab:	e9 d0 fd ff ff       	jmp    c0101e80 <__alltraps>

c01020b0 <vector60>:
.globl vector60
vector60:
  pushl $0
c01020b0:	6a 00                	push   $0x0
  pushl $60
c01020b2:	6a 3c                	push   $0x3c
  jmp __alltraps
c01020b4:	e9 c7 fd ff ff       	jmp    c0101e80 <__alltraps>

c01020b9 <vector61>:
.globl vector61
vector61:
  pushl $0
c01020b9:	6a 00                	push   $0x0
  pushl $61
c01020bb:	6a 3d                	push   $0x3d
  jmp __alltraps
c01020bd:	e9 be fd ff ff       	jmp    c0101e80 <__alltraps>

c01020c2 <vector62>:
.globl vector62
vector62:
  pushl $0
c01020c2:	6a 00                	push   $0x0
  pushl $62
c01020c4:	6a 3e                	push   $0x3e
  jmp __alltraps
c01020c6:	e9 b5 fd ff ff       	jmp    c0101e80 <__alltraps>

c01020cb <vector63>:
.globl vector63
vector63:
  pushl $0
c01020cb:	6a 00                	push   $0x0
  pushl $63
c01020cd:	6a 3f                	push   $0x3f
  jmp __alltraps
c01020cf:	e9 ac fd ff ff       	jmp    c0101e80 <__alltraps>

c01020d4 <vector64>:
.globl vector64
vector64:
  pushl $0
c01020d4:	6a 00                	push   $0x0
  pushl $64
c01020d6:	6a 40                	push   $0x40
  jmp __alltraps
c01020d8:	e9 a3 fd ff ff       	jmp    c0101e80 <__alltraps>

c01020dd <vector65>:
.globl vector65
vector65:
  pushl $0
c01020dd:	6a 00                	push   $0x0
  pushl $65
c01020df:	6a 41                	push   $0x41
  jmp __alltraps
c01020e1:	e9 9a fd ff ff       	jmp    c0101e80 <__alltraps>

c01020e6 <vector66>:
.globl vector66
vector66:
  pushl $0
c01020e6:	6a 00                	push   $0x0
  pushl $66
c01020e8:	6a 42                	push   $0x42
  jmp __alltraps
c01020ea:	e9 91 fd ff ff       	jmp    c0101e80 <__alltraps>

c01020ef <vector67>:
.globl vector67
vector67:
  pushl $0
c01020ef:	6a 00                	push   $0x0
  pushl $67
c01020f1:	6a 43                	push   $0x43
  jmp __alltraps
c01020f3:	e9 88 fd ff ff       	jmp    c0101e80 <__alltraps>

c01020f8 <vector68>:
.globl vector68
vector68:
  pushl $0
c01020f8:	6a 00                	push   $0x0
  pushl $68
c01020fa:	6a 44                	push   $0x44
  jmp __alltraps
c01020fc:	e9 7f fd ff ff       	jmp    c0101e80 <__alltraps>

c0102101 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102101:	6a 00                	push   $0x0
  pushl $69
c0102103:	6a 45                	push   $0x45
  jmp __alltraps
c0102105:	e9 76 fd ff ff       	jmp    c0101e80 <__alltraps>

c010210a <vector70>:
.globl vector70
vector70:
  pushl $0
c010210a:	6a 00                	push   $0x0
  pushl $70
c010210c:	6a 46                	push   $0x46
  jmp __alltraps
c010210e:	e9 6d fd ff ff       	jmp    c0101e80 <__alltraps>

c0102113 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102113:	6a 00                	push   $0x0
  pushl $71
c0102115:	6a 47                	push   $0x47
  jmp __alltraps
c0102117:	e9 64 fd ff ff       	jmp    c0101e80 <__alltraps>

c010211c <vector72>:
.globl vector72
vector72:
  pushl $0
c010211c:	6a 00                	push   $0x0
  pushl $72
c010211e:	6a 48                	push   $0x48
  jmp __alltraps
c0102120:	e9 5b fd ff ff       	jmp    c0101e80 <__alltraps>

c0102125 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102125:	6a 00                	push   $0x0
  pushl $73
c0102127:	6a 49                	push   $0x49
  jmp __alltraps
c0102129:	e9 52 fd ff ff       	jmp    c0101e80 <__alltraps>

c010212e <vector74>:
.globl vector74
vector74:
  pushl $0
c010212e:	6a 00                	push   $0x0
  pushl $74
c0102130:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102132:	e9 49 fd ff ff       	jmp    c0101e80 <__alltraps>

c0102137 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102137:	6a 00                	push   $0x0
  pushl $75
c0102139:	6a 4b                	push   $0x4b
  jmp __alltraps
c010213b:	e9 40 fd ff ff       	jmp    c0101e80 <__alltraps>

c0102140 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102140:	6a 00                	push   $0x0
  pushl $76
c0102142:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102144:	e9 37 fd ff ff       	jmp    c0101e80 <__alltraps>

c0102149 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102149:	6a 00                	push   $0x0
  pushl $77
c010214b:	6a 4d                	push   $0x4d
  jmp __alltraps
c010214d:	e9 2e fd ff ff       	jmp    c0101e80 <__alltraps>

c0102152 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102152:	6a 00                	push   $0x0
  pushl $78
c0102154:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102156:	e9 25 fd ff ff       	jmp    c0101e80 <__alltraps>

c010215b <vector79>:
.globl vector79
vector79:
  pushl $0
c010215b:	6a 00                	push   $0x0
  pushl $79
c010215d:	6a 4f                	push   $0x4f
  jmp __alltraps
c010215f:	e9 1c fd ff ff       	jmp    c0101e80 <__alltraps>

c0102164 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102164:	6a 00                	push   $0x0
  pushl $80
c0102166:	6a 50                	push   $0x50
  jmp __alltraps
c0102168:	e9 13 fd ff ff       	jmp    c0101e80 <__alltraps>

c010216d <vector81>:
.globl vector81
vector81:
  pushl $0
c010216d:	6a 00                	push   $0x0
  pushl $81
c010216f:	6a 51                	push   $0x51
  jmp __alltraps
c0102171:	e9 0a fd ff ff       	jmp    c0101e80 <__alltraps>

c0102176 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102176:	6a 00                	push   $0x0
  pushl $82
c0102178:	6a 52                	push   $0x52
  jmp __alltraps
c010217a:	e9 01 fd ff ff       	jmp    c0101e80 <__alltraps>

c010217f <vector83>:
.globl vector83
vector83:
  pushl $0
c010217f:	6a 00                	push   $0x0
  pushl $83
c0102181:	6a 53                	push   $0x53
  jmp __alltraps
c0102183:	e9 f8 fc ff ff       	jmp    c0101e80 <__alltraps>

c0102188 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102188:	6a 00                	push   $0x0
  pushl $84
c010218a:	6a 54                	push   $0x54
  jmp __alltraps
c010218c:	e9 ef fc ff ff       	jmp    c0101e80 <__alltraps>

c0102191 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102191:	6a 00                	push   $0x0
  pushl $85
c0102193:	6a 55                	push   $0x55
  jmp __alltraps
c0102195:	e9 e6 fc ff ff       	jmp    c0101e80 <__alltraps>

c010219a <vector86>:
.globl vector86
vector86:
  pushl $0
c010219a:	6a 00                	push   $0x0
  pushl $86
c010219c:	6a 56                	push   $0x56
  jmp __alltraps
c010219e:	e9 dd fc ff ff       	jmp    c0101e80 <__alltraps>

c01021a3 <vector87>:
.globl vector87
vector87:
  pushl $0
c01021a3:	6a 00                	push   $0x0
  pushl $87
c01021a5:	6a 57                	push   $0x57
  jmp __alltraps
c01021a7:	e9 d4 fc ff ff       	jmp    c0101e80 <__alltraps>

c01021ac <vector88>:
.globl vector88
vector88:
  pushl $0
c01021ac:	6a 00                	push   $0x0
  pushl $88
c01021ae:	6a 58                	push   $0x58
  jmp __alltraps
c01021b0:	e9 cb fc ff ff       	jmp    c0101e80 <__alltraps>

c01021b5 <vector89>:
.globl vector89
vector89:
  pushl $0
c01021b5:	6a 00                	push   $0x0
  pushl $89
c01021b7:	6a 59                	push   $0x59
  jmp __alltraps
c01021b9:	e9 c2 fc ff ff       	jmp    c0101e80 <__alltraps>

c01021be <vector90>:
.globl vector90
vector90:
  pushl $0
c01021be:	6a 00                	push   $0x0
  pushl $90
c01021c0:	6a 5a                	push   $0x5a
  jmp __alltraps
c01021c2:	e9 b9 fc ff ff       	jmp    c0101e80 <__alltraps>

c01021c7 <vector91>:
.globl vector91
vector91:
  pushl $0
c01021c7:	6a 00                	push   $0x0
  pushl $91
c01021c9:	6a 5b                	push   $0x5b
  jmp __alltraps
c01021cb:	e9 b0 fc ff ff       	jmp    c0101e80 <__alltraps>

c01021d0 <vector92>:
.globl vector92
vector92:
  pushl $0
c01021d0:	6a 00                	push   $0x0
  pushl $92
c01021d2:	6a 5c                	push   $0x5c
  jmp __alltraps
c01021d4:	e9 a7 fc ff ff       	jmp    c0101e80 <__alltraps>

c01021d9 <vector93>:
.globl vector93
vector93:
  pushl $0
c01021d9:	6a 00                	push   $0x0
  pushl $93
c01021db:	6a 5d                	push   $0x5d
  jmp __alltraps
c01021dd:	e9 9e fc ff ff       	jmp    c0101e80 <__alltraps>

c01021e2 <vector94>:
.globl vector94
vector94:
  pushl $0
c01021e2:	6a 00                	push   $0x0
  pushl $94
c01021e4:	6a 5e                	push   $0x5e
  jmp __alltraps
c01021e6:	e9 95 fc ff ff       	jmp    c0101e80 <__alltraps>

c01021eb <vector95>:
.globl vector95
vector95:
  pushl $0
c01021eb:	6a 00                	push   $0x0
  pushl $95
c01021ed:	6a 5f                	push   $0x5f
  jmp __alltraps
c01021ef:	e9 8c fc ff ff       	jmp    c0101e80 <__alltraps>

c01021f4 <vector96>:
.globl vector96
vector96:
  pushl $0
c01021f4:	6a 00                	push   $0x0
  pushl $96
c01021f6:	6a 60                	push   $0x60
  jmp __alltraps
c01021f8:	e9 83 fc ff ff       	jmp    c0101e80 <__alltraps>

c01021fd <vector97>:
.globl vector97
vector97:
  pushl $0
c01021fd:	6a 00                	push   $0x0
  pushl $97
c01021ff:	6a 61                	push   $0x61
  jmp __alltraps
c0102201:	e9 7a fc ff ff       	jmp    c0101e80 <__alltraps>

c0102206 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102206:	6a 00                	push   $0x0
  pushl $98
c0102208:	6a 62                	push   $0x62
  jmp __alltraps
c010220a:	e9 71 fc ff ff       	jmp    c0101e80 <__alltraps>

c010220f <vector99>:
.globl vector99
vector99:
  pushl $0
c010220f:	6a 00                	push   $0x0
  pushl $99
c0102211:	6a 63                	push   $0x63
  jmp __alltraps
c0102213:	e9 68 fc ff ff       	jmp    c0101e80 <__alltraps>

c0102218 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102218:	6a 00                	push   $0x0
  pushl $100
c010221a:	6a 64                	push   $0x64
  jmp __alltraps
c010221c:	e9 5f fc ff ff       	jmp    c0101e80 <__alltraps>

c0102221 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102221:	6a 00                	push   $0x0
  pushl $101
c0102223:	6a 65                	push   $0x65
  jmp __alltraps
c0102225:	e9 56 fc ff ff       	jmp    c0101e80 <__alltraps>

c010222a <vector102>:
.globl vector102
vector102:
  pushl $0
c010222a:	6a 00                	push   $0x0
  pushl $102
c010222c:	6a 66                	push   $0x66
  jmp __alltraps
c010222e:	e9 4d fc ff ff       	jmp    c0101e80 <__alltraps>

c0102233 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102233:	6a 00                	push   $0x0
  pushl $103
c0102235:	6a 67                	push   $0x67
  jmp __alltraps
c0102237:	e9 44 fc ff ff       	jmp    c0101e80 <__alltraps>

c010223c <vector104>:
.globl vector104
vector104:
  pushl $0
c010223c:	6a 00                	push   $0x0
  pushl $104
c010223e:	6a 68                	push   $0x68
  jmp __alltraps
c0102240:	e9 3b fc ff ff       	jmp    c0101e80 <__alltraps>

c0102245 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102245:	6a 00                	push   $0x0
  pushl $105
c0102247:	6a 69                	push   $0x69
  jmp __alltraps
c0102249:	e9 32 fc ff ff       	jmp    c0101e80 <__alltraps>

c010224e <vector106>:
.globl vector106
vector106:
  pushl $0
c010224e:	6a 00                	push   $0x0
  pushl $106
c0102250:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102252:	e9 29 fc ff ff       	jmp    c0101e80 <__alltraps>

c0102257 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102257:	6a 00                	push   $0x0
  pushl $107
c0102259:	6a 6b                	push   $0x6b
  jmp __alltraps
c010225b:	e9 20 fc ff ff       	jmp    c0101e80 <__alltraps>

c0102260 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102260:	6a 00                	push   $0x0
  pushl $108
c0102262:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102264:	e9 17 fc ff ff       	jmp    c0101e80 <__alltraps>

c0102269 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102269:	6a 00                	push   $0x0
  pushl $109
c010226b:	6a 6d                	push   $0x6d
  jmp __alltraps
c010226d:	e9 0e fc ff ff       	jmp    c0101e80 <__alltraps>

c0102272 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102272:	6a 00                	push   $0x0
  pushl $110
c0102274:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102276:	e9 05 fc ff ff       	jmp    c0101e80 <__alltraps>

c010227b <vector111>:
.globl vector111
vector111:
  pushl $0
c010227b:	6a 00                	push   $0x0
  pushl $111
c010227d:	6a 6f                	push   $0x6f
  jmp __alltraps
c010227f:	e9 fc fb ff ff       	jmp    c0101e80 <__alltraps>

c0102284 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102284:	6a 00                	push   $0x0
  pushl $112
c0102286:	6a 70                	push   $0x70
  jmp __alltraps
c0102288:	e9 f3 fb ff ff       	jmp    c0101e80 <__alltraps>

c010228d <vector113>:
.globl vector113
vector113:
  pushl $0
c010228d:	6a 00                	push   $0x0
  pushl $113
c010228f:	6a 71                	push   $0x71
  jmp __alltraps
c0102291:	e9 ea fb ff ff       	jmp    c0101e80 <__alltraps>

c0102296 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102296:	6a 00                	push   $0x0
  pushl $114
c0102298:	6a 72                	push   $0x72
  jmp __alltraps
c010229a:	e9 e1 fb ff ff       	jmp    c0101e80 <__alltraps>

c010229f <vector115>:
.globl vector115
vector115:
  pushl $0
c010229f:	6a 00                	push   $0x0
  pushl $115
c01022a1:	6a 73                	push   $0x73
  jmp __alltraps
c01022a3:	e9 d8 fb ff ff       	jmp    c0101e80 <__alltraps>

c01022a8 <vector116>:
.globl vector116
vector116:
  pushl $0
c01022a8:	6a 00                	push   $0x0
  pushl $116
c01022aa:	6a 74                	push   $0x74
  jmp __alltraps
c01022ac:	e9 cf fb ff ff       	jmp    c0101e80 <__alltraps>

c01022b1 <vector117>:
.globl vector117
vector117:
  pushl $0
c01022b1:	6a 00                	push   $0x0
  pushl $117
c01022b3:	6a 75                	push   $0x75
  jmp __alltraps
c01022b5:	e9 c6 fb ff ff       	jmp    c0101e80 <__alltraps>

c01022ba <vector118>:
.globl vector118
vector118:
  pushl $0
c01022ba:	6a 00                	push   $0x0
  pushl $118
c01022bc:	6a 76                	push   $0x76
  jmp __alltraps
c01022be:	e9 bd fb ff ff       	jmp    c0101e80 <__alltraps>

c01022c3 <vector119>:
.globl vector119
vector119:
  pushl $0
c01022c3:	6a 00                	push   $0x0
  pushl $119
c01022c5:	6a 77                	push   $0x77
  jmp __alltraps
c01022c7:	e9 b4 fb ff ff       	jmp    c0101e80 <__alltraps>

c01022cc <vector120>:
.globl vector120
vector120:
  pushl $0
c01022cc:	6a 00                	push   $0x0
  pushl $120
c01022ce:	6a 78                	push   $0x78
  jmp __alltraps
c01022d0:	e9 ab fb ff ff       	jmp    c0101e80 <__alltraps>

c01022d5 <vector121>:
.globl vector121
vector121:
  pushl $0
c01022d5:	6a 00                	push   $0x0
  pushl $121
c01022d7:	6a 79                	push   $0x79
  jmp __alltraps
c01022d9:	e9 a2 fb ff ff       	jmp    c0101e80 <__alltraps>

c01022de <vector122>:
.globl vector122
vector122:
  pushl $0
c01022de:	6a 00                	push   $0x0
  pushl $122
c01022e0:	6a 7a                	push   $0x7a
  jmp __alltraps
c01022e2:	e9 99 fb ff ff       	jmp    c0101e80 <__alltraps>

c01022e7 <vector123>:
.globl vector123
vector123:
  pushl $0
c01022e7:	6a 00                	push   $0x0
  pushl $123
c01022e9:	6a 7b                	push   $0x7b
  jmp __alltraps
c01022eb:	e9 90 fb ff ff       	jmp    c0101e80 <__alltraps>

c01022f0 <vector124>:
.globl vector124
vector124:
  pushl $0
c01022f0:	6a 00                	push   $0x0
  pushl $124
c01022f2:	6a 7c                	push   $0x7c
  jmp __alltraps
c01022f4:	e9 87 fb ff ff       	jmp    c0101e80 <__alltraps>

c01022f9 <vector125>:
.globl vector125
vector125:
  pushl $0
c01022f9:	6a 00                	push   $0x0
  pushl $125
c01022fb:	6a 7d                	push   $0x7d
  jmp __alltraps
c01022fd:	e9 7e fb ff ff       	jmp    c0101e80 <__alltraps>

c0102302 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102302:	6a 00                	push   $0x0
  pushl $126
c0102304:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102306:	e9 75 fb ff ff       	jmp    c0101e80 <__alltraps>

c010230b <vector127>:
.globl vector127
vector127:
  pushl $0
c010230b:	6a 00                	push   $0x0
  pushl $127
c010230d:	6a 7f                	push   $0x7f
  jmp __alltraps
c010230f:	e9 6c fb ff ff       	jmp    c0101e80 <__alltraps>

c0102314 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102314:	6a 00                	push   $0x0
  pushl $128
c0102316:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c010231b:	e9 60 fb ff ff       	jmp    c0101e80 <__alltraps>

c0102320 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102320:	6a 00                	push   $0x0
  pushl $129
c0102322:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102327:	e9 54 fb ff ff       	jmp    c0101e80 <__alltraps>

c010232c <vector130>:
.globl vector130
vector130:
  pushl $0
c010232c:	6a 00                	push   $0x0
  pushl $130
c010232e:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102333:	e9 48 fb ff ff       	jmp    c0101e80 <__alltraps>

c0102338 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102338:	6a 00                	push   $0x0
  pushl $131
c010233a:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c010233f:	e9 3c fb ff ff       	jmp    c0101e80 <__alltraps>

c0102344 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102344:	6a 00                	push   $0x0
  pushl $132
c0102346:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c010234b:	e9 30 fb ff ff       	jmp    c0101e80 <__alltraps>

c0102350 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102350:	6a 00                	push   $0x0
  pushl $133
c0102352:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102357:	e9 24 fb ff ff       	jmp    c0101e80 <__alltraps>

c010235c <vector134>:
.globl vector134
vector134:
  pushl $0
c010235c:	6a 00                	push   $0x0
  pushl $134
c010235e:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102363:	e9 18 fb ff ff       	jmp    c0101e80 <__alltraps>

c0102368 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102368:	6a 00                	push   $0x0
  pushl $135
c010236a:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c010236f:	e9 0c fb ff ff       	jmp    c0101e80 <__alltraps>

c0102374 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102374:	6a 00                	push   $0x0
  pushl $136
c0102376:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c010237b:	e9 00 fb ff ff       	jmp    c0101e80 <__alltraps>

c0102380 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102380:	6a 00                	push   $0x0
  pushl $137
c0102382:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102387:	e9 f4 fa ff ff       	jmp    c0101e80 <__alltraps>

c010238c <vector138>:
.globl vector138
vector138:
  pushl $0
c010238c:	6a 00                	push   $0x0
  pushl $138
c010238e:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102393:	e9 e8 fa ff ff       	jmp    c0101e80 <__alltraps>

c0102398 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102398:	6a 00                	push   $0x0
  pushl $139
c010239a:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c010239f:	e9 dc fa ff ff       	jmp    c0101e80 <__alltraps>

c01023a4 <vector140>:
.globl vector140
vector140:
  pushl $0
c01023a4:	6a 00                	push   $0x0
  pushl $140
c01023a6:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c01023ab:	e9 d0 fa ff ff       	jmp    c0101e80 <__alltraps>

c01023b0 <vector141>:
.globl vector141
vector141:
  pushl $0
c01023b0:	6a 00                	push   $0x0
  pushl $141
c01023b2:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c01023b7:	e9 c4 fa ff ff       	jmp    c0101e80 <__alltraps>

c01023bc <vector142>:
.globl vector142
vector142:
  pushl $0
c01023bc:	6a 00                	push   $0x0
  pushl $142
c01023be:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01023c3:	e9 b8 fa ff ff       	jmp    c0101e80 <__alltraps>

c01023c8 <vector143>:
.globl vector143
vector143:
  pushl $0
c01023c8:	6a 00                	push   $0x0
  pushl $143
c01023ca:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01023cf:	e9 ac fa ff ff       	jmp    c0101e80 <__alltraps>

c01023d4 <vector144>:
.globl vector144
vector144:
  pushl $0
c01023d4:	6a 00                	push   $0x0
  pushl $144
c01023d6:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01023db:	e9 a0 fa ff ff       	jmp    c0101e80 <__alltraps>

c01023e0 <vector145>:
.globl vector145
vector145:
  pushl $0
c01023e0:	6a 00                	push   $0x0
  pushl $145
c01023e2:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c01023e7:	e9 94 fa ff ff       	jmp    c0101e80 <__alltraps>

c01023ec <vector146>:
.globl vector146
vector146:
  pushl $0
c01023ec:	6a 00                	push   $0x0
  pushl $146
c01023ee:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c01023f3:	e9 88 fa ff ff       	jmp    c0101e80 <__alltraps>

c01023f8 <vector147>:
.globl vector147
vector147:
  pushl $0
c01023f8:	6a 00                	push   $0x0
  pushl $147
c01023fa:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c01023ff:	e9 7c fa ff ff       	jmp    c0101e80 <__alltraps>

c0102404 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102404:	6a 00                	push   $0x0
  pushl $148
c0102406:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c010240b:	e9 70 fa ff ff       	jmp    c0101e80 <__alltraps>

c0102410 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102410:	6a 00                	push   $0x0
  pushl $149
c0102412:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102417:	e9 64 fa ff ff       	jmp    c0101e80 <__alltraps>

c010241c <vector150>:
.globl vector150
vector150:
  pushl $0
c010241c:	6a 00                	push   $0x0
  pushl $150
c010241e:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102423:	e9 58 fa ff ff       	jmp    c0101e80 <__alltraps>

c0102428 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102428:	6a 00                	push   $0x0
  pushl $151
c010242a:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c010242f:	e9 4c fa ff ff       	jmp    c0101e80 <__alltraps>

c0102434 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102434:	6a 00                	push   $0x0
  pushl $152
c0102436:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c010243b:	e9 40 fa ff ff       	jmp    c0101e80 <__alltraps>

c0102440 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102440:	6a 00                	push   $0x0
  pushl $153
c0102442:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102447:	e9 34 fa ff ff       	jmp    c0101e80 <__alltraps>

c010244c <vector154>:
.globl vector154
vector154:
  pushl $0
c010244c:	6a 00                	push   $0x0
  pushl $154
c010244e:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102453:	e9 28 fa ff ff       	jmp    c0101e80 <__alltraps>

c0102458 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102458:	6a 00                	push   $0x0
  pushl $155
c010245a:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c010245f:	e9 1c fa ff ff       	jmp    c0101e80 <__alltraps>

c0102464 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102464:	6a 00                	push   $0x0
  pushl $156
c0102466:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c010246b:	e9 10 fa ff ff       	jmp    c0101e80 <__alltraps>

c0102470 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102470:	6a 00                	push   $0x0
  pushl $157
c0102472:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102477:	e9 04 fa ff ff       	jmp    c0101e80 <__alltraps>

c010247c <vector158>:
.globl vector158
vector158:
  pushl $0
c010247c:	6a 00                	push   $0x0
  pushl $158
c010247e:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102483:	e9 f8 f9 ff ff       	jmp    c0101e80 <__alltraps>

c0102488 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102488:	6a 00                	push   $0x0
  pushl $159
c010248a:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c010248f:	e9 ec f9 ff ff       	jmp    c0101e80 <__alltraps>

c0102494 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102494:	6a 00                	push   $0x0
  pushl $160
c0102496:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c010249b:	e9 e0 f9 ff ff       	jmp    c0101e80 <__alltraps>

c01024a0 <vector161>:
.globl vector161
vector161:
  pushl $0
c01024a0:	6a 00                	push   $0x0
  pushl $161
c01024a2:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c01024a7:	e9 d4 f9 ff ff       	jmp    c0101e80 <__alltraps>

c01024ac <vector162>:
.globl vector162
vector162:
  pushl $0
c01024ac:	6a 00                	push   $0x0
  pushl $162
c01024ae:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c01024b3:	e9 c8 f9 ff ff       	jmp    c0101e80 <__alltraps>

c01024b8 <vector163>:
.globl vector163
vector163:
  pushl $0
c01024b8:	6a 00                	push   $0x0
  pushl $163
c01024ba:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01024bf:	e9 bc f9 ff ff       	jmp    c0101e80 <__alltraps>

c01024c4 <vector164>:
.globl vector164
vector164:
  pushl $0
c01024c4:	6a 00                	push   $0x0
  pushl $164
c01024c6:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01024cb:	e9 b0 f9 ff ff       	jmp    c0101e80 <__alltraps>

c01024d0 <vector165>:
.globl vector165
vector165:
  pushl $0
c01024d0:	6a 00                	push   $0x0
  pushl $165
c01024d2:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01024d7:	e9 a4 f9 ff ff       	jmp    c0101e80 <__alltraps>

c01024dc <vector166>:
.globl vector166
vector166:
  pushl $0
c01024dc:	6a 00                	push   $0x0
  pushl $166
c01024de:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c01024e3:	e9 98 f9 ff ff       	jmp    c0101e80 <__alltraps>

c01024e8 <vector167>:
.globl vector167
vector167:
  pushl $0
c01024e8:	6a 00                	push   $0x0
  pushl $167
c01024ea:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01024ef:	e9 8c f9 ff ff       	jmp    c0101e80 <__alltraps>

c01024f4 <vector168>:
.globl vector168
vector168:
  pushl $0
c01024f4:	6a 00                	push   $0x0
  pushl $168
c01024f6:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c01024fb:	e9 80 f9 ff ff       	jmp    c0101e80 <__alltraps>

c0102500 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102500:	6a 00                	push   $0x0
  pushl $169
c0102502:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102507:	e9 74 f9 ff ff       	jmp    c0101e80 <__alltraps>

c010250c <vector170>:
.globl vector170
vector170:
  pushl $0
c010250c:	6a 00                	push   $0x0
  pushl $170
c010250e:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102513:	e9 68 f9 ff ff       	jmp    c0101e80 <__alltraps>

c0102518 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102518:	6a 00                	push   $0x0
  pushl $171
c010251a:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c010251f:	e9 5c f9 ff ff       	jmp    c0101e80 <__alltraps>

c0102524 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102524:	6a 00                	push   $0x0
  pushl $172
c0102526:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c010252b:	e9 50 f9 ff ff       	jmp    c0101e80 <__alltraps>

c0102530 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102530:	6a 00                	push   $0x0
  pushl $173
c0102532:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102537:	e9 44 f9 ff ff       	jmp    c0101e80 <__alltraps>

c010253c <vector174>:
.globl vector174
vector174:
  pushl $0
c010253c:	6a 00                	push   $0x0
  pushl $174
c010253e:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102543:	e9 38 f9 ff ff       	jmp    c0101e80 <__alltraps>

c0102548 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102548:	6a 00                	push   $0x0
  pushl $175
c010254a:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c010254f:	e9 2c f9 ff ff       	jmp    c0101e80 <__alltraps>

c0102554 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102554:	6a 00                	push   $0x0
  pushl $176
c0102556:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c010255b:	e9 20 f9 ff ff       	jmp    c0101e80 <__alltraps>

c0102560 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102560:	6a 00                	push   $0x0
  pushl $177
c0102562:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102567:	e9 14 f9 ff ff       	jmp    c0101e80 <__alltraps>

c010256c <vector178>:
.globl vector178
vector178:
  pushl $0
c010256c:	6a 00                	push   $0x0
  pushl $178
c010256e:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102573:	e9 08 f9 ff ff       	jmp    c0101e80 <__alltraps>

c0102578 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102578:	6a 00                	push   $0x0
  pushl $179
c010257a:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c010257f:	e9 fc f8 ff ff       	jmp    c0101e80 <__alltraps>

c0102584 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102584:	6a 00                	push   $0x0
  pushl $180
c0102586:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c010258b:	e9 f0 f8 ff ff       	jmp    c0101e80 <__alltraps>

c0102590 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102590:	6a 00                	push   $0x0
  pushl $181
c0102592:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102597:	e9 e4 f8 ff ff       	jmp    c0101e80 <__alltraps>

c010259c <vector182>:
.globl vector182
vector182:
  pushl $0
c010259c:	6a 00                	push   $0x0
  pushl $182
c010259e:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c01025a3:	e9 d8 f8 ff ff       	jmp    c0101e80 <__alltraps>

c01025a8 <vector183>:
.globl vector183
vector183:
  pushl $0
c01025a8:	6a 00                	push   $0x0
  pushl $183
c01025aa:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c01025af:	e9 cc f8 ff ff       	jmp    c0101e80 <__alltraps>

c01025b4 <vector184>:
.globl vector184
vector184:
  pushl $0
c01025b4:	6a 00                	push   $0x0
  pushl $184
c01025b6:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c01025bb:	e9 c0 f8 ff ff       	jmp    c0101e80 <__alltraps>

c01025c0 <vector185>:
.globl vector185
vector185:
  pushl $0
c01025c0:	6a 00                	push   $0x0
  pushl $185
c01025c2:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01025c7:	e9 b4 f8 ff ff       	jmp    c0101e80 <__alltraps>

c01025cc <vector186>:
.globl vector186
vector186:
  pushl $0
c01025cc:	6a 00                	push   $0x0
  pushl $186
c01025ce:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01025d3:	e9 a8 f8 ff ff       	jmp    c0101e80 <__alltraps>

c01025d8 <vector187>:
.globl vector187
vector187:
  pushl $0
c01025d8:	6a 00                	push   $0x0
  pushl $187
c01025da:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01025df:	e9 9c f8 ff ff       	jmp    c0101e80 <__alltraps>

c01025e4 <vector188>:
.globl vector188
vector188:
  pushl $0
c01025e4:	6a 00                	push   $0x0
  pushl $188
c01025e6:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01025eb:	e9 90 f8 ff ff       	jmp    c0101e80 <__alltraps>

c01025f0 <vector189>:
.globl vector189
vector189:
  pushl $0
c01025f0:	6a 00                	push   $0x0
  pushl $189
c01025f2:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01025f7:	e9 84 f8 ff ff       	jmp    c0101e80 <__alltraps>

c01025fc <vector190>:
.globl vector190
vector190:
  pushl $0
c01025fc:	6a 00                	push   $0x0
  pushl $190
c01025fe:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102603:	e9 78 f8 ff ff       	jmp    c0101e80 <__alltraps>

c0102608 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102608:	6a 00                	push   $0x0
  pushl $191
c010260a:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c010260f:	e9 6c f8 ff ff       	jmp    c0101e80 <__alltraps>

c0102614 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102614:	6a 00                	push   $0x0
  pushl $192
c0102616:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c010261b:	e9 60 f8 ff ff       	jmp    c0101e80 <__alltraps>

c0102620 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102620:	6a 00                	push   $0x0
  pushl $193
c0102622:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102627:	e9 54 f8 ff ff       	jmp    c0101e80 <__alltraps>

c010262c <vector194>:
.globl vector194
vector194:
  pushl $0
c010262c:	6a 00                	push   $0x0
  pushl $194
c010262e:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102633:	e9 48 f8 ff ff       	jmp    c0101e80 <__alltraps>

c0102638 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102638:	6a 00                	push   $0x0
  pushl $195
c010263a:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c010263f:	e9 3c f8 ff ff       	jmp    c0101e80 <__alltraps>

c0102644 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102644:	6a 00                	push   $0x0
  pushl $196
c0102646:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c010264b:	e9 30 f8 ff ff       	jmp    c0101e80 <__alltraps>

c0102650 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102650:	6a 00                	push   $0x0
  pushl $197
c0102652:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102657:	e9 24 f8 ff ff       	jmp    c0101e80 <__alltraps>

c010265c <vector198>:
.globl vector198
vector198:
  pushl $0
c010265c:	6a 00                	push   $0x0
  pushl $198
c010265e:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102663:	e9 18 f8 ff ff       	jmp    c0101e80 <__alltraps>

c0102668 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102668:	6a 00                	push   $0x0
  pushl $199
c010266a:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c010266f:	e9 0c f8 ff ff       	jmp    c0101e80 <__alltraps>

c0102674 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102674:	6a 00                	push   $0x0
  pushl $200
c0102676:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c010267b:	e9 00 f8 ff ff       	jmp    c0101e80 <__alltraps>

c0102680 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102680:	6a 00                	push   $0x0
  pushl $201
c0102682:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102687:	e9 f4 f7 ff ff       	jmp    c0101e80 <__alltraps>

c010268c <vector202>:
.globl vector202
vector202:
  pushl $0
c010268c:	6a 00                	push   $0x0
  pushl $202
c010268e:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102693:	e9 e8 f7 ff ff       	jmp    c0101e80 <__alltraps>

c0102698 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102698:	6a 00                	push   $0x0
  pushl $203
c010269a:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c010269f:	e9 dc f7 ff ff       	jmp    c0101e80 <__alltraps>

c01026a4 <vector204>:
.globl vector204
vector204:
  pushl $0
c01026a4:	6a 00                	push   $0x0
  pushl $204
c01026a6:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c01026ab:	e9 d0 f7 ff ff       	jmp    c0101e80 <__alltraps>

c01026b0 <vector205>:
.globl vector205
vector205:
  pushl $0
c01026b0:	6a 00                	push   $0x0
  pushl $205
c01026b2:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c01026b7:	e9 c4 f7 ff ff       	jmp    c0101e80 <__alltraps>

c01026bc <vector206>:
.globl vector206
vector206:
  pushl $0
c01026bc:	6a 00                	push   $0x0
  pushl $206
c01026be:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01026c3:	e9 b8 f7 ff ff       	jmp    c0101e80 <__alltraps>

c01026c8 <vector207>:
.globl vector207
vector207:
  pushl $0
c01026c8:	6a 00                	push   $0x0
  pushl $207
c01026ca:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01026cf:	e9 ac f7 ff ff       	jmp    c0101e80 <__alltraps>

c01026d4 <vector208>:
.globl vector208
vector208:
  pushl $0
c01026d4:	6a 00                	push   $0x0
  pushl $208
c01026d6:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01026db:	e9 a0 f7 ff ff       	jmp    c0101e80 <__alltraps>

c01026e0 <vector209>:
.globl vector209
vector209:
  pushl $0
c01026e0:	6a 00                	push   $0x0
  pushl $209
c01026e2:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c01026e7:	e9 94 f7 ff ff       	jmp    c0101e80 <__alltraps>

c01026ec <vector210>:
.globl vector210
vector210:
  pushl $0
c01026ec:	6a 00                	push   $0x0
  pushl $210
c01026ee:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01026f3:	e9 88 f7 ff ff       	jmp    c0101e80 <__alltraps>

c01026f8 <vector211>:
.globl vector211
vector211:
  pushl $0
c01026f8:	6a 00                	push   $0x0
  pushl $211
c01026fa:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01026ff:	e9 7c f7 ff ff       	jmp    c0101e80 <__alltraps>

c0102704 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102704:	6a 00                	push   $0x0
  pushl $212
c0102706:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c010270b:	e9 70 f7 ff ff       	jmp    c0101e80 <__alltraps>

c0102710 <vector213>:
.globl vector213
vector213:
  pushl $0
c0102710:	6a 00                	push   $0x0
  pushl $213
c0102712:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102717:	e9 64 f7 ff ff       	jmp    c0101e80 <__alltraps>

c010271c <vector214>:
.globl vector214
vector214:
  pushl $0
c010271c:	6a 00                	push   $0x0
  pushl $214
c010271e:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102723:	e9 58 f7 ff ff       	jmp    c0101e80 <__alltraps>

c0102728 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102728:	6a 00                	push   $0x0
  pushl $215
c010272a:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c010272f:	e9 4c f7 ff ff       	jmp    c0101e80 <__alltraps>

c0102734 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102734:	6a 00                	push   $0x0
  pushl $216
c0102736:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c010273b:	e9 40 f7 ff ff       	jmp    c0101e80 <__alltraps>

c0102740 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102740:	6a 00                	push   $0x0
  pushl $217
c0102742:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102747:	e9 34 f7 ff ff       	jmp    c0101e80 <__alltraps>

c010274c <vector218>:
.globl vector218
vector218:
  pushl $0
c010274c:	6a 00                	push   $0x0
  pushl $218
c010274e:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102753:	e9 28 f7 ff ff       	jmp    c0101e80 <__alltraps>

c0102758 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102758:	6a 00                	push   $0x0
  pushl $219
c010275a:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010275f:	e9 1c f7 ff ff       	jmp    c0101e80 <__alltraps>

c0102764 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102764:	6a 00                	push   $0x0
  pushl $220
c0102766:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c010276b:	e9 10 f7 ff ff       	jmp    c0101e80 <__alltraps>

c0102770 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102770:	6a 00                	push   $0x0
  pushl $221
c0102772:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102777:	e9 04 f7 ff ff       	jmp    c0101e80 <__alltraps>

c010277c <vector222>:
.globl vector222
vector222:
  pushl $0
c010277c:	6a 00                	push   $0x0
  pushl $222
c010277e:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102783:	e9 f8 f6 ff ff       	jmp    c0101e80 <__alltraps>

c0102788 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102788:	6a 00                	push   $0x0
  pushl $223
c010278a:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c010278f:	e9 ec f6 ff ff       	jmp    c0101e80 <__alltraps>

c0102794 <vector224>:
.globl vector224
vector224:
  pushl $0
c0102794:	6a 00                	push   $0x0
  pushl $224
c0102796:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c010279b:	e9 e0 f6 ff ff       	jmp    c0101e80 <__alltraps>

c01027a0 <vector225>:
.globl vector225
vector225:
  pushl $0
c01027a0:	6a 00                	push   $0x0
  pushl $225
c01027a2:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01027a7:	e9 d4 f6 ff ff       	jmp    c0101e80 <__alltraps>

c01027ac <vector226>:
.globl vector226
vector226:
  pushl $0
c01027ac:	6a 00                	push   $0x0
  pushl $226
c01027ae:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01027b3:	e9 c8 f6 ff ff       	jmp    c0101e80 <__alltraps>

c01027b8 <vector227>:
.globl vector227
vector227:
  pushl $0
c01027b8:	6a 00                	push   $0x0
  pushl $227
c01027ba:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01027bf:	e9 bc f6 ff ff       	jmp    c0101e80 <__alltraps>

c01027c4 <vector228>:
.globl vector228
vector228:
  pushl $0
c01027c4:	6a 00                	push   $0x0
  pushl $228
c01027c6:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01027cb:	e9 b0 f6 ff ff       	jmp    c0101e80 <__alltraps>

c01027d0 <vector229>:
.globl vector229
vector229:
  pushl $0
c01027d0:	6a 00                	push   $0x0
  pushl $229
c01027d2:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01027d7:	e9 a4 f6 ff ff       	jmp    c0101e80 <__alltraps>

c01027dc <vector230>:
.globl vector230
vector230:
  pushl $0
c01027dc:	6a 00                	push   $0x0
  pushl $230
c01027de:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01027e3:	e9 98 f6 ff ff       	jmp    c0101e80 <__alltraps>

c01027e8 <vector231>:
.globl vector231
vector231:
  pushl $0
c01027e8:	6a 00                	push   $0x0
  pushl $231
c01027ea:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01027ef:	e9 8c f6 ff ff       	jmp    c0101e80 <__alltraps>

c01027f4 <vector232>:
.globl vector232
vector232:
  pushl $0
c01027f4:	6a 00                	push   $0x0
  pushl $232
c01027f6:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01027fb:	e9 80 f6 ff ff       	jmp    c0101e80 <__alltraps>

c0102800 <vector233>:
.globl vector233
vector233:
  pushl $0
c0102800:	6a 00                	push   $0x0
  pushl $233
c0102802:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102807:	e9 74 f6 ff ff       	jmp    c0101e80 <__alltraps>

c010280c <vector234>:
.globl vector234
vector234:
  pushl $0
c010280c:	6a 00                	push   $0x0
  pushl $234
c010280e:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102813:	e9 68 f6 ff ff       	jmp    c0101e80 <__alltraps>

c0102818 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102818:	6a 00                	push   $0x0
  pushl $235
c010281a:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c010281f:	e9 5c f6 ff ff       	jmp    c0101e80 <__alltraps>

c0102824 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102824:	6a 00                	push   $0x0
  pushl $236
c0102826:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c010282b:	e9 50 f6 ff ff       	jmp    c0101e80 <__alltraps>

c0102830 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102830:	6a 00                	push   $0x0
  pushl $237
c0102832:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102837:	e9 44 f6 ff ff       	jmp    c0101e80 <__alltraps>

c010283c <vector238>:
.globl vector238
vector238:
  pushl $0
c010283c:	6a 00                	push   $0x0
  pushl $238
c010283e:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102843:	e9 38 f6 ff ff       	jmp    c0101e80 <__alltraps>

c0102848 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102848:	6a 00                	push   $0x0
  pushl $239
c010284a:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c010284f:	e9 2c f6 ff ff       	jmp    c0101e80 <__alltraps>

c0102854 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102854:	6a 00                	push   $0x0
  pushl $240
c0102856:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c010285b:	e9 20 f6 ff ff       	jmp    c0101e80 <__alltraps>

c0102860 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102860:	6a 00                	push   $0x0
  pushl $241
c0102862:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102867:	e9 14 f6 ff ff       	jmp    c0101e80 <__alltraps>

c010286c <vector242>:
.globl vector242
vector242:
  pushl $0
c010286c:	6a 00                	push   $0x0
  pushl $242
c010286e:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102873:	e9 08 f6 ff ff       	jmp    c0101e80 <__alltraps>

c0102878 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102878:	6a 00                	push   $0x0
  pushl $243
c010287a:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c010287f:	e9 fc f5 ff ff       	jmp    c0101e80 <__alltraps>

c0102884 <vector244>:
.globl vector244
vector244:
  pushl $0
c0102884:	6a 00                	push   $0x0
  pushl $244
c0102886:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c010288b:	e9 f0 f5 ff ff       	jmp    c0101e80 <__alltraps>

c0102890 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102890:	6a 00                	push   $0x0
  pushl $245
c0102892:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102897:	e9 e4 f5 ff ff       	jmp    c0101e80 <__alltraps>

c010289c <vector246>:
.globl vector246
vector246:
  pushl $0
c010289c:	6a 00                	push   $0x0
  pushl $246
c010289e:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01028a3:	e9 d8 f5 ff ff       	jmp    c0101e80 <__alltraps>

c01028a8 <vector247>:
.globl vector247
vector247:
  pushl $0
c01028a8:	6a 00                	push   $0x0
  pushl $247
c01028aa:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01028af:	e9 cc f5 ff ff       	jmp    c0101e80 <__alltraps>

c01028b4 <vector248>:
.globl vector248
vector248:
  pushl $0
c01028b4:	6a 00                	push   $0x0
  pushl $248
c01028b6:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01028bb:	e9 c0 f5 ff ff       	jmp    c0101e80 <__alltraps>

c01028c0 <vector249>:
.globl vector249
vector249:
  pushl $0
c01028c0:	6a 00                	push   $0x0
  pushl $249
c01028c2:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01028c7:	e9 b4 f5 ff ff       	jmp    c0101e80 <__alltraps>

c01028cc <vector250>:
.globl vector250
vector250:
  pushl $0
c01028cc:	6a 00                	push   $0x0
  pushl $250
c01028ce:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01028d3:	e9 a8 f5 ff ff       	jmp    c0101e80 <__alltraps>

c01028d8 <vector251>:
.globl vector251
vector251:
  pushl $0
c01028d8:	6a 00                	push   $0x0
  pushl $251
c01028da:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01028df:	e9 9c f5 ff ff       	jmp    c0101e80 <__alltraps>

c01028e4 <vector252>:
.globl vector252
vector252:
  pushl $0
c01028e4:	6a 00                	push   $0x0
  pushl $252
c01028e6:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01028eb:	e9 90 f5 ff ff       	jmp    c0101e80 <__alltraps>

c01028f0 <vector253>:
.globl vector253
vector253:
  pushl $0
c01028f0:	6a 00                	push   $0x0
  pushl $253
c01028f2:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01028f7:	e9 84 f5 ff ff       	jmp    c0101e80 <__alltraps>

c01028fc <vector254>:
.globl vector254
vector254:
  pushl $0
c01028fc:	6a 00                	push   $0x0
  pushl $254
c01028fe:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102903:	e9 78 f5 ff ff       	jmp    c0101e80 <__alltraps>

c0102908 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102908:	6a 00                	push   $0x0
  pushl $255
c010290a:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c010290f:	e9 6c f5 ff ff       	jmp    c0101e80 <__alltraps>

c0102914 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102914:	55                   	push   %ebp
c0102915:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102917:	8b 55 08             	mov    0x8(%ebp),%edx
c010291a:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c010291f:	89 d1                	mov    %edx,%ecx
c0102921:	29 c1                	sub    %eax,%ecx
c0102923:	89 c8                	mov    %ecx,%eax
c0102925:	c1 f8 02             	sar    $0x2,%eax
c0102928:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c010292e:	5d                   	pop    %ebp
c010292f:	c3                   	ret    

c0102930 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102930:	55                   	push   %ebp
c0102931:	89 e5                	mov    %esp,%ebp
c0102933:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0102936:	8b 45 08             	mov    0x8(%ebp),%eax
c0102939:	89 04 24             	mov    %eax,(%esp)
c010293c:	e8 d3 ff ff ff       	call   c0102914 <page2ppn>
c0102941:	c1 e0 0c             	shl    $0xc,%eax
}
c0102944:	c9                   	leave  
c0102945:	c3                   	ret    

c0102946 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0102946:	55                   	push   %ebp
c0102947:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102949:	8b 45 08             	mov    0x8(%ebp),%eax
c010294c:	8b 00                	mov    (%eax),%eax
}
c010294e:	5d                   	pop    %ebp
c010294f:	c3                   	ret    

c0102950 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102950:	55                   	push   %ebp
c0102951:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102953:	8b 45 08             	mov    0x8(%ebp),%eax
c0102956:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102959:	89 10                	mov    %edx,(%eax)
}
c010295b:	5d                   	pop    %ebp
c010295c:	c3                   	ret    

c010295d <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c010295d:	55                   	push   %ebp
c010295e:	89 e5                	mov    %esp,%ebp
c0102960:	83 ec 10             	sub    $0x10,%esp
c0102963:	c7 45 fc 50 89 11 c0 	movl   $0xc0118950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010296a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010296d:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102970:	89 50 04             	mov    %edx,0x4(%eax)
c0102973:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102976:	8b 50 04             	mov    0x4(%eax),%edx
c0102979:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010297c:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c010297e:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c0102985:	00 00 00 
}
c0102988:	c9                   	leave  
c0102989:	c3                   	ret    

c010298a <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c010298a:	55                   	push   %ebp
c010298b:	89 e5                	mov    %esp,%ebp
c010298d:	53                   	push   %ebx
c010298e:	83 ec 54             	sub    $0x54,%esp
    assert(n > 0);
c0102991:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102995:	75 24                	jne    c01029bb <default_init_memmap+0x31>
c0102997:	c7 44 24 0c d0 67 10 	movl   $0xc01067d0,0xc(%esp)
c010299e:	c0 
c010299f:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c01029a6:	c0 
c01029a7:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c01029ae:	00 
c01029af:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c01029b6:	e8 e1 e2 ff ff       	call   c0100c9c <__panic>
    struct Page *p = base;
c01029bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01029be:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01029c1:	eb 7d                	jmp    c0102a40 <default_init_memmap+0xb6>
        assert(PageReserved(p));
c01029c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029c6:	83 c0 04             	add    $0x4,%eax
c01029c9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01029d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01029d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01029d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01029d9:	0f a3 10             	bt     %edx,(%eax)
c01029dc:	19 db                	sbb    %ebx,%ebx
c01029de:	89 5d e8             	mov    %ebx,-0x18(%ebp)
    return oldbit != 0;
c01029e1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01029e5:	0f 95 c0             	setne  %al
c01029e8:	0f b6 c0             	movzbl %al,%eax
c01029eb:	85 c0                	test   %eax,%eax
c01029ed:	75 24                	jne    c0102a13 <default_init_memmap+0x89>
c01029ef:	c7 44 24 0c 01 68 10 	movl   $0xc0106801,0xc(%esp)
c01029f6:	c0 
c01029f7:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c01029fe:	c0 
c01029ff:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c0102a06:	00 
c0102a07:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c0102a0e:	e8 89 e2 ff ff       	call   c0100c9c <__panic>
        p->flags = p->property = 0;
c0102a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a16:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0102a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a20:	8b 50 08             	mov    0x8(%eax),%edx
c0102a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a26:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c0102a29:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102a30:	00 
c0102a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a34:	89 04 24             	mov    %eax,(%esp)
c0102a37:	e8 14 ff ff ff       	call   c0102950 <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0102a3c:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102a40:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a43:	89 d0                	mov    %edx,%eax
c0102a45:	c1 e0 02             	shl    $0x2,%eax
c0102a48:	01 d0                	add    %edx,%eax
c0102a4a:	c1 e0 02             	shl    $0x2,%eax
c0102a4d:	03 45 08             	add    0x8(%ebp),%eax
c0102a50:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102a53:	0f 85 6a ff ff ff    	jne    c01029c3 <default_init_memmap+0x39>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0102a59:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a5c:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a5f:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102a62:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a65:	83 c0 04             	add    $0x4,%eax
c0102a68:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0102a6f:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102a72:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102a75:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102a78:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c0102a7b:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102a80:	03 45 0c             	add    0xc(%ebp),%eax
c0102a83:	a3 58 89 11 c0       	mov    %eax,0xc0118958
    list_add(&free_list, &(base->page_link));
c0102a88:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a8b:	83 c0 0c             	add    $0xc,%eax
c0102a8e:	c7 45 dc 50 89 11 c0 	movl   $0xc0118950,-0x24(%ebp)
c0102a95:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0102a98:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102a9b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0102a9e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102aa1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102aa4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102aa7:	8b 40 04             	mov    0x4(%eax),%eax
c0102aaa:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102aad:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0102ab0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102ab3:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0102ab6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102ab9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102abc:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102abf:	89 10                	mov    %edx,(%eax)
c0102ac1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102ac4:	8b 10                	mov    (%eax),%edx
c0102ac6:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102ac9:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102acc:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102acf:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102ad2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102ad5:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102ad8:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102adb:	89 10                	mov    %edx,(%eax)
}
c0102add:	83 c4 54             	add    $0x54,%esp
c0102ae0:	5b                   	pop    %ebx
c0102ae1:	5d                   	pop    %ebp
c0102ae2:	c3                   	ret    

c0102ae3 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0102ae3:	55                   	push   %ebp
c0102ae4:	89 e5                	mov    %esp,%ebp
c0102ae6:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0102ae9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102aed:	75 24                	jne    c0102b13 <default_alloc_pages+0x30>
c0102aef:	c7 44 24 0c d0 67 10 	movl   $0xc01067d0,0xc(%esp)
c0102af6:	c0 
c0102af7:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c0102afe:	c0 
c0102aff:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
c0102b06:	00 
c0102b07:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c0102b0e:	e8 89 e1 ff ff       	call   c0100c9c <__panic>
    if (n > nr_free) {
c0102b13:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102b18:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102b1b:	73 0a                	jae    c0102b27 <default_alloc_pages+0x44>
        return NULL;
c0102b1d:	b8 00 00 00 00       	mov    $0x0,%eax
c0102b22:	e9 26 01 00 00       	jmp    c0102c4d <default_alloc_pages+0x16a>
    }
    struct Page *page = NULL;
c0102b27:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0102b2e:	c7 45 f0 50 89 11 c0 	movl   $0xc0118950,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0102b35:	eb 1c                	jmp    c0102b53 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c0102b37:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102b3a:	83 e8 0c             	sub    $0xc,%eax
c0102b3d:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c0102b40:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102b43:	8b 40 08             	mov    0x8(%eax),%eax
c0102b46:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102b49:	72 08                	jb     c0102b53 <default_alloc_pages+0x70>
            page = p;
c0102b4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102b4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0102b51:	eb 18                	jmp    c0102b6b <default_alloc_pages+0x88>
c0102b53:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102b56:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102b59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102b5c:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0102b5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102b62:	81 7d f0 50 89 11 c0 	cmpl   $0xc0118950,-0x10(%ebp)
c0102b69:	75 cc                	jne    c0102b37 <default_alloc_pages+0x54>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
c0102b6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102b6f:	0f 84 d5 00 00 00    	je     c0102c4a <default_alloc_pages+0x167>
        list_del(&(page->page_link));
c0102b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b78:	83 c0 0c             	add    $0xc,%eax
c0102b7b:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102b7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102b81:	8b 40 04             	mov    0x4(%eax),%eax
c0102b84:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102b87:	8b 12                	mov    (%edx),%edx
c0102b89:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0102b8c:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102b8f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102b92:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102b95:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102b98:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102b9b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102b9e:	89 10                	mov    %edx,(%eax)
        if (page->property > n) {
c0102ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ba3:	8b 40 08             	mov    0x8(%eax),%eax
c0102ba6:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102ba9:	76 79                	jbe    c0102c24 <default_alloc_pages+0x141>
            struct Page *p = page + n;
c0102bab:	8b 55 08             	mov    0x8(%ebp),%edx
c0102bae:	89 d0                	mov    %edx,%eax
c0102bb0:	c1 e0 02             	shl    $0x2,%eax
c0102bb3:	01 d0                	add    %edx,%eax
c0102bb5:	c1 e0 02             	shl    $0x2,%eax
c0102bb8:	03 45 f4             	add    -0xc(%ebp),%eax
c0102bbb:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c0102bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bc1:	8b 40 08             	mov    0x8(%eax),%eax
c0102bc4:	89 c2                	mov    %eax,%edx
c0102bc6:	2b 55 08             	sub    0x8(%ebp),%edx
c0102bc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102bcc:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&free_list, &(p->page_link));
c0102bcf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102bd2:	83 c0 0c             	add    $0xc,%eax
c0102bd5:	c7 45 d4 50 89 11 c0 	movl   $0xc0118950,-0x2c(%ebp)
c0102bdc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102bdf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102be2:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0102be5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102be8:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102beb:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102bee:	8b 40 04             	mov    0x4(%eax),%eax
c0102bf1:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102bf4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0102bf7:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102bfa:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0102bfd:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102c00:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102c03:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102c06:	89 10                	mov    %edx,(%eax)
c0102c08:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102c0b:	8b 10                	mov    (%eax),%edx
c0102c0d:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102c10:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102c13:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102c16:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102c19:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102c1c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102c1f:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102c22:	89 10                	mov    %edx,(%eax)
    }
        nr_free -= n;
c0102c24:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102c29:	2b 45 08             	sub    0x8(%ebp),%eax
c0102c2c:	a3 58 89 11 c0       	mov    %eax,0xc0118958
        ClearPageProperty(page);
c0102c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c34:	83 c0 04             	add    $0x4,%eax
c0102c37:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0102c3e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102c41:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102c44:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102c47:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c0102c4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102c4d:	c9                   	leave  
c0102c4e:	c3                   	ret    

c0102c4f <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102c4f:	55                   	push   %ebp
c0102c50:	89 e5                	mov    %esp,%ebp
c0102c52:	53                   	push   %ebx
c0102c53:	81 ec 84 00 00 00    	sub    $0x84,%esp
    assert(n > 0);
c0102c59:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102c5d:	75 24                	jne    c0102c83 <default_free_pages+0x34>
c0102c5f:	c7 44 24 0c d0 67 10 	movl   $0xc01067d0,0xc(%esp)
c0102c66:	c0 
c0102c67:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c0102c6e:	c0 
c0102c6f:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c0102c76:	00 
c0102c77:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c0102c7e:	e8 19 e0 ff ff       	call   c0100c9c <__panic>
    struct Page *p = base;
c0102c83:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c86:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102c89:	e9 9d 00 00 00       	jmp    c0102d2b <default_free_pages+0xdc>
        assert(!PageReserved(p) && !PageProperty(p));
c0102c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c91:	83 c0 04             	add    $0x4,%eax
c0102c94:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102c9b:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102c9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102ca1:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102ca4:	0f a3 10             	bt     %edx,(%eax)
c0102ca7:	19 db                	sbb    %ebx,%ebx
c0102ca9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
    return oldbit != 0;
c0102cac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102cb0:	0f 95 c0             	setne  %al
c0102cb3:	0f b6 c0             	movzbl %al,%eax
c0102cb6:	85 c0                	test   %eax,%eax
c0102cb8:	75 2c                	jne    c0102ce6 <default_free_pages+0x97>
c0102cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cbd:	83 c0 04             	add    $0x4,%eax
c0102cc0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0102cc7:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102cca:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102ccd:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102cd0:	0f a3 10             	bt     %edx,(%eax)
c0102cd3:	19 db                	sbb    %ebx,%ebx
c0102cd5:	89 5d d8             	mov    %ebx,-0x28(%ebp)
    return oldbit != 0;
c0102cd8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0102cdc:	0f 95 c0             	setne  %al
c0102cdf:	0f b6 c0             	movzbl %al,%eax
c0102ce2:	85 c0                	test   %eax,%eax
c0102ce4:	74 24                	je     c0102d0a <default_free_pages+0xbb>
c0102ce6:	c7 44 24 0c 14 68 10 	movl   $0xc0106814,0xc(%esp)
c0102ced:	c0 
c0102cee:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c0102cf5:	c0 
c0102cf6:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
c0102cfd:	00 
c0102cfe:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c0102d05:	e8 92 df ff ff       	call   c0100c9c <__panic>
        p->flags = 0;
c0102d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d0d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0102d14:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102d1b:	00 
c0102d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d1f:	89 04 24             	mov    %eax,(%esp)
c0102d22:	e8 29 fc ff ff       	call   c0102950 <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0102d27:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102d2b:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d2e:	89 d0                	mov    %edx,%eax
c0102d30:	c1 e0 02             	shl    $0x2,%eax
c0102d33:	01 d0                	add    %edx,%eax
c0102d35:	c1 e0 02             	shl    $0x2,%eax
c0102d38:	03 45 08             	add    0x8(%ebp),%eax
c0102d3b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102d3e:	0f 85 4a ff ff ff    	jne    c0102c8e <default_free_pages+0x3f>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0102d44:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d47:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d4a:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102d4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d50:	83 c0 04             	add    $0x4,%eax
c0102d53:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0102d5a:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102d5d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102d60:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102d63:	0f ab 10             	bts    %edx,(%eax)
c0102d66:	c7 45 cc 50 89 11 c0 	movl   $0xc0118950,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102d6d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102d70:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0102d73:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0102d76:	e9 00 01 00 00       	jmp    c0102e7b <default_free_pages+0x22c>
        p = le2page(le, page_link);
c0102d7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d7e:	83 e8 0c             	sub    $0xc,%eax
c0102d81:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102d84:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d87:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102d8a:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102d8d:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0102d90:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
c0102d93:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d96:	8b 50 08             	mov    0x8(%eax),%edx
c0102d99:	89 d0                	mov    %edx,%eax
c0102d9b:	c1 e0 02             	shl    $0x2,%eax
c0102d9e:	01 d0                	add    %edx,%eax
c0102da0:	c1 e0 02             	shl    $0x2,%eax
c0102da3:	03 45 08             	add    0x8(%ebp),%eax
c0102da6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102da9:	75 5a                	jne    c0102e05 <default_free_pages+0x1b6>
            base->property += p->property;
c0102dab:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dae:	8b 50 08             	mov    0x8(%eax),%edx
c0102db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102db4:	8b 40 08             	mov    0x8(%eax),%eax
c0102db7:	01 c2                	add    %eax,%edx
c0102db9:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dbc:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0102dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dc2:	83 c0 04             	add    $0x4,%eax
c0102dc5:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0102dcc:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102dcf:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102dd2:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102dd5:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c0102dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ddb:	83 c0 0c             	add    $0xc,%eax
c0102dde:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102de1:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102de4:	8b 40 04             	mov    0x4(%eax),%eax
c0102de7:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102dea:	8b 12                	mov    (%edx),%edx
c0102dec:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0102def:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102df2:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102df5:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102df8:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102dfb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102dfe:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102e01:	89 10                	mov    %edx,(%eax)
c0102e03:	eb 76                	jmp    c0102e7b <default_free_pages+0x22c>
        }
        else if (p + p->property == base) {
c0102e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e08:	8b 50 08             	mov    0x8(%eax),%edx
c0102e0b:	89 d0                	mov    %edx,%eax
c0102e0d:	c1 e0 02             	shl    $0x2,%eax
c0102e10:	01 d0                	add    %edx,%eax
c0102e12:	c1 e0 02             	shl    $0x2,%eax
c0102e15:	03 45 f4             	add    -0xc(%ebp),%eax
c0102e18:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102e1b:	75 5e                	jne    c0102e7b <default_free_pages+0x22c>
            p->property += base->property;
c0102e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e20:	8b 50 08             	mov    0x8(%eax),%edx
c0102e23:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e26:	8b 40 08             	mov    0x8(%eax),%eax
c0102e29:	01 c2                	add    %eax,%edx
c0102e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e2e:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0102e31:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e34:	83 c0 04             	add    $0x4,%eax
c0102e37:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0102e3e:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0102e41:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102e44:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102e47:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c0102e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e4d:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0102e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e53:	83 c0 0c             	add    $0xc,%eax
c0102e56:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102e59:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102e5c:	8b 40 04             	mov    0x4(%eax),%eax
c0102e5f:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102e62:	8b 12                	mov    (%edx),%edx
c0102e64:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0102e67:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102e6a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102e6d:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0102e70:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102e73:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102e76:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102e79:	89 10                	mov    %edx,(%eax)
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
c0102e7b:	81 7d f0 50 89 11 c0 	cmpl   $0xc0118950,-0x10(%ebp)
c0102e82:	0f 85 f3 fe ff ff    	jne    c0102d7b <default_free_pages+0x12c>
            ClearPageProperty(base);
            base = p;
            list_del(&(p->page_link));
        }
    }
    nr_free += n;
c0102e88:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102e8d:	03 45 0c             	add    0xc(%ebp),%eax
c0102e90:	a3 58 89 11 c0       	mov    %eax,0xc0118958
    list_add_before(&free_list, &(base->page_link));
c0102e95:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e98:	83 c0 0c             	add    $0xc,%eax
c0102e9b:	c7 45 9c 50 89 11 c0 	movl   $0xc0118950,-0x64(%ebp)
c0102ea2:	89 45 98             	mov    %eax,-0x68(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102ea5:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102ea8:	8b 00                	mov    (%eax),%eax
c0102eaa:	8b 55 98             	mov    -0x68(%ebp),%edx
c0102ead:	89 55 94             	mov    %edx,-0x6c(%ebp)
c0102eb0:	89 45 90             	mov    %eax,-0x70(%ebp)
c0102eb3:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102eb6:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102eb9:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102ebc:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0102ebf:	89 10                	mov    %edx,(%eax)
c0102ec1:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102ec4:	8b 10                	mov    (%eax),%edx
c0102ec6:	8b 45 90             	mov    -0x70(%ebp),%eax
c0102ec9:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102ecc:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102ecf:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0102ed2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102ed5:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102ed8:	8b 55 90             	mov    -0x70(%ebp),%edx
c0102edb:	89 10                	mov    %edx,(%eax)
}
c0102edd:	81 c4 84 00 00 00    	add    $0x84,%esp
c0102ee3:	5b                   	pop    %ebx
c0102ee4:	5d                   	pop    %ebp
c0102ee5:	c3                   	ret    

c0102ee6 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0102ee6:	55                   	push   %ebp
c0102ee7:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102ee9:	a1 58 89 11 c0       	mov    0xc0118958,%eax
}
c0102eee:	5d                   	pop    %ebp
c0102eef:	c3                   	ret    

c0102ef0 <basic_check>:

static void
basic_check(void) {
c0102ef0:	55                   	push   %ebp
c0102ef1:	89 e5                	mov    %esp,%ebp
c0102ef3:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102ef6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f00:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102f03:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f06:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102f09:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102f10:	e8 90 0e 00 00       	call   c0103da5 <alloc_pages>
c0102f15:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102f18:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102f1c:	75 24                	jne    c0102f42 <basic_check+0x52>
c0102f1e:	c7 44 24 0c 39 68 10 	movl   $0xc0106839,0xc(%esp)
c0102f25:	c0 
c0102f26:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c0102f2d:	c0 
c0102f2e:	c7 44 24 04 97 00 00 	movl   $0x97,0x4(%esp)
c0102f35:	00 
c0102f36:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c0102f3d:	e8 5a dd ff ff       	call   c0100c9c <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102f42:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102f49:	e8 57 0e 00 00       	call   c0103da5 <alloc_pages>
c0102f4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102f51:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102f55:	75 24                	jne    c0102f7b <basic_check+0x8b>
c0102f57:	c7 44 24 0c 55 68 10 	movl   $0xc0106855,0xc(%esp)
c0102f5e:	c0 
c0102f5f:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c0102f66:	c0 
c0102f67:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c0102f6e:	00 
c0102f6f:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c0102f76:	e8 21 dd ff ff       	call   c0100c9c <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102f7b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102f82:	e8 1e 0e 00 00       	call   c0103da5 <alloc_pages>
c0102f87:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102f8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102f8e:	75 24                	jne    c0102fb4 <basic_check+0xc4>
c0102f90:	c7 44 24 0c 71 68 10 	movl   $0xc0106871,0xc(%esp)
c0102f97:	c0 
c0102f98:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c0102f9f:	c0 
c0102fa0:	c7 44 24 04 99 00 00 	movl   $0x99,0x4(%esp)
c0102fa7:	00 
c0102fa8:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c0102faf:	e8 e8 dc ff ff       	call   c0100c9c <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0102fb4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102fb7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102fba:	74 10                	je     c0102fcc <basic_check+0xdc>
c0102fbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102fbf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102fc2:	74 08                	je     c0102fcc <basic_check+0xdc>
c0102fc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102fc7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102fca:	75 24                	jne    c0102ff0 <basic_check+0x100>
c0102fcc:	c7 44 24 0c 90 68 10 	movl   $0xc0106890,0xc(%esp)
c0102fd3:	c0 
c0102fd4:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c0102fdb:	c0 
c0102fdc:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
c0102fe3:	00 
c0102fe4:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c0102feb:	e8 ac dc ff ff       	call   c0100c9c <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0102ff0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ff3:	89 04 24             	mov    %eax,(%esp)
c0102ff6:	e8 4b f9 ff ff       	call   c0102946 <page_ref>
c0102ffb:	85 c0                	test   %eax,%eax
c0102ffd:	75 1e                	jne    c010301d <basic_check+0x12d>
c0102fff:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103002:	89 04 24             	mov    %eax,(%esp)
c0103005:	e8 3c f9 ff ff       	call   c0102946 <page_ref>
c010300a:	85 c0                	test   %eax,%eax
c010300c:	75 0f                	jne    c010301d <basic_check+0x12d>
c010300e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103011:	89 04 24             	mov    %eax,(%esp)
c0103014:	e8 2d f9 ff ff       	call   c0102946 <page_ref>
c0103019:	85 c0                	test   %eax,%eax
c010301b:	74 24                	je     c0103041 <basic_check+0x151>
c010301d:	c7 44 24 0c b4 68 10 	movl   $0xc01068b4,0xc(%esp)
c0103024:	c0 
c0103025:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c010302c:	c0 
c010302d:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c0103034:	00 
c0103035:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c010303c:	e8 5b dc ff ff       	call   c0100c9c <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0103041:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103044:	89 04 24             	mov    %eax,(%esp)
c0103047:	e8 e4 f8 ff ff       	call   c0102930 <page2pa>
c010304c:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0103052:	c1 e2 0c             	shl    $0xc,%edx
c0103055:	39 d0                	cmp    %edx,%eax
c0103057:	72 24                	jb     c010307d <basic_check+0x18d>
c0103059:	c7 44 24 0c f0 68 10 	movl   $0xc01068f0,0xc(%esp)
c0103060:	c0 
c0103061:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c0103068:	c0 
c0103069:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c0103070:	00 
c0103071:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c0103078:	e8 1f dc ff ff       	call   c0100c9c <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c010307d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103080:	89 04 24             	mov    %eax,(%esp)
c0103083:	e8 a8 f8 ff ff       	call   c0102930 <page2pa>
c0103088:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c010308e:	c1 e2 0c             	shl    $0xc,%edx
c0103091:	39 d0                	cmp    %edx,%eax
c0103093:	72 24                	jb     c01030b9 <basic_check+0x1c9>
c0103095:	c7 44 24 0c 0d 69 10 	movl   $0xc010690d,0xc(%esp)
c010309c:	c0 
c010309d:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c01030a4:	c0 
c01030a5:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c01030ac:	00 
c01030ad:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c01030b4:	e8 e3 db ff ff       	call   c0100c9c <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c01030b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01030bc:	89 04 24             	mov    %eax,(%esp)
c01030bf:	e8 6c f8 ff ff       	call   c0102930 <page2pa>
c01030c4:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c01030ca:	c1 e2 0c             	shl    $0xc,%edx
c01030cd:	39 d0                	cmp    %edx,%eax
c01030cf:	72 24                	jb     c01030f5 <basic_check+0x205>
c01030d1:	c7 44 24 0c 2a 69 10 	movl   $0xc010692a,0xc(%esp)
c01030d8:	c0 
c01030d9:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c01030e0:	c0 
c01030e1:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c01030e8:	00 
c01030e9:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c01030f0:	e8 a7 db ff ff       	call   c0100c9c <__panic>

    list_entry_t free_list_store = free_list;
c01030f5:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c01030fa:	8b 15 54 89 11 c0    	mov    0xc0118954,%edx
c0103100:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103103:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103106:	c7 45 e0 50 89 11 c0 	movl   $0xc0118950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010310d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103110:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103113:	89 50 04             	mov    %edx,0x4(%eax)
c0103116:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103119:	8b 50 04             	mov    0x4(%eax),%edx
c010311c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010311f:	89 10                	mov    %edx,(%eax)
c0103121:	c7 45 dc 50 89 11 c0 	movl   $0xc0118950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103128:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010312b:	8b 40 04             	mov    0x4(%eax),%eax
c010312e:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103131:	0f 94 c0             	sete   %al
c0103134:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103137:	85 c0                	test   %eax,%eax
c0103139:	75 24                	jne    c010315f <basic_check+0x26f>
c010313b:	c7 44 24 0c 47 69 10 	movl   $0xc0106947,0xc(%esp)
c0103142:	c0 
c0103143:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c010314a:	c0 
c010314b:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
c0103152:	00 
c0103153:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c010315a:	e8 3d db ff ff       	call   c0100c9c <__panic>

    unsigned int nr_free_store = nr_free;
c010315f:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103164:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103167:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c010316e:	00 00 00 

    assert(alloc_page() == NULL);
c0103171:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103178:	e8 28 0c 00 00       	call   c0103da5 <alloc_pages>
c010317d:	85 c0                	test   %eax,%eax
c010317f:	74 24                	je     c01031a5 <basic_check+0x2b5>
c0103181:	c7 44 24 0c 5e 69 10 	movl   $0xc010695e,0xc(%esp)
c0103188:	c0 
c0103189:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c0103190:	c0 
c0103191:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
c0103198:	00 
c0103199:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c01031a0:	e8 f7 da ff ff       	call   c0100c9c <__panic>

    free_page(p0);
c01031a5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01031ac:	00 
c01031ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01031b0:	89 04 24             	mov    %eax,(%esp)
c01031b3:	e8 25 0c 00 00       	call   c0103ddd <free_pages>
    free_page(p1);
c01031b8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01031bf:	00 
c01031c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01031c3:	89 04 24             	mov    %eax,(%esp)
c01031c6:	e8 12 0c 00 00       	call   c0103ddd <free_pages>
    free_page(p2);
c01031cb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01031d2:	00 
c01031d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01031d6:	89 04 24             	mov    %eax,(%esp)
c01031d9:	e8 ff 0b 00 00       	call   c0103ddd <free_pages>
    assert(nr_free == 3);
c01031de:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c01031e3:	83 f8 03             	cmp    $0x3,%eax
c01031e6:	74 24                	je     c010320c <basic_check+0x31c>
c01031e8:	c7 44 24 0c 73 69 10 	movl   $0xc0106973,0xc(%esp)
c01031ef:	c0 
c01031f0:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c01031f7:	c0 
c01031f8:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
c01031ff:	00 
c0103200:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c0103207:	e8 90 da ff ff       	call   c0100c9c <__panic>

    assert((p0 = alloc_page()) != NULL);
c010320c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103213:	e8 8d 0b 00 00       	call   c0103da5 <alloc_pages>
c0103218:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010321b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010321f:	75 24                	jne    c0103245 <basic_check+0x355>
c0103221:	c7 44 24 0c 39 68 10 	movl   $0xc0106839,0xc(%esp)
c0103228:	c0 
c0103229:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c0103230:	c0 
c0103231:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
c0103238:	00 
c0103239:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c0103240:	e8 57 da ff ff       	call   c0100c9c <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103245:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010324c:	e8 54 0b 00 00       	call   c0103da5 <alloc_pages>
c0103251:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103254:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103258:	75 24                	jne    c010327e <basic_check+0x38e>
c010325a:	c7 44 24 0c 55 68 10 	movl   $0xc0106855,0xc(%esp)
c0103261:	c0 
c0103262:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c0103269:	c0 
c010326a:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
c0103271:	00 
c0103272:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c0103279:	e8 1e da ff ff       	call   c0100c9c <__panic>
    assert((p2 = alloc_page()) != NULL);
c010327e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103285:	e8 1b 0b 00 00       	call   c0103da5 <alloc_pages>
c010328a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010328d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103291:	75 24                	jne    c01032b7 <basic_check+0x3c7>
c0103293:	c7 44 24 0c 71 68 10 	movl   $0xc0106871,0xc(%esp)
c010329a:	c0 
c010329b:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c01032a2:	c0 
c01032a3:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c01032aa:	00 
c01032ab:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c01032b2:	e8 e5 d9 ff ff       	call   c0100c9c <__panic>

    assert(alloc_page() == NULL);
c01032b7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032be:	e8 e2 0a 00 00       	call   c0103da5 <alloc_pages>
c01032c3:	85 c0                	test   %eax,%eax
c01032c5:	74 24                	je     c01032eb <basic_check+0x3fb>
c01032c7:	c7 44 24 0c 5e 69 10 	movl   $0xc010695e,0xc(%esp)
c01032ce:	c0 
c01032cf:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c01032d6:	c0 
c01032d7:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
c01032de:	00 
c01032df:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c01032e6:	e8 b1 d9 ff ff       	call   c0100c9c <__panic>

    free_page(p0);
c01032eb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01032f2:	00 
c01032f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01032f6:	89 04 24             	mov    %eax,(%esp)
c01032f9:	e8 df 0a 00 00       	call   c0103ddd <free_pages>
c01032fe:	c7 45 d8 50 89 11 c0 	movl   $0xc0118950,-0x28(%ebp)
c0103305:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103308:	8b 40 04             	mov    0x4(%eax),%eax
c010330b:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c010330e:	0f 94 c0             	sete   %al
c0103311:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103314:	85 c0                	test   %eax,%eax
c0103316:	74 24                	je     c010333c <basic_check+0x44c>
c0103318:	c7 44 24 0c 80 69 10 	movl   $0xc0106980,0xc(%esp)
c010331f:	c0 
c0103320:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c0103327:	c0 
c0103328:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
c010332f:	00 
c0103330:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c0103337:	e8 60 d9 ff ff       	call   c0100c9c <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c010333c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103343:	e8 5d 0a 00 00       	call   c0103da5 <alloc_pages>
c0103348:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010334b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010334e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103351:	74 24                	je     c0103377 <basic_check+0x487>
c0103353:	c7 44 24 0c 98 69 10 	movl   $0xc0106998,0xc(%esp)
c010335a:	c0 
c010335b:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c0103362:	c0 
c0103363:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c010336a:	00 
c010336b:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c0103372:	e8 25 d9 ff ff       	call   c0100c9c <__panic>
    assert(alloc_page() == NULL);
c0103377:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010337e:	e8 22 0a 00 00       	call   c0103da5 <alloc_pages>
c0103383:	85 c0                	test   %eax,%eax
c0103385:	74 24                	je     c01033ab <basic_check+0x4bb>
c0103387:	c7 44 24 0c 5e 69 10 	movl   $0xc010695e,0xc(%esp)
c010338e:	c0 
c010338f:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c0103396:	c0 
c0103397:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
c010339e:	00 
c010339f:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c01033a6:	e8 f1 d8 ff ff       	call   c0100c9c <__panic>

    assert(nr_free == 0);
c01033ab:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c01033b0:	85 c0                	test   %eax,%eax
c01033b2:	74 24                	je     c01033d8 <basic_check+0x4e8>
c01033b4:	c7 44 24 0c b1 69 10 	movl   $0xc01069b1,0xc(%esp)
c01033bb:	c0 
c01033bc:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c01033c3:	c0 
c01033c4:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c01033cb:	00 
c01033cc:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c01033d3:	e8 c4 d8 ff ff       	call   c0100c9c <__panic>
    free_list = free_list_store;
c01033d8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01033db:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01033de:	a3 50 89 11 c0       	mov    %eax,0xc0118950
c01033e3:	89 15 54 89 11 c0    	mov    %edx,0xc0118954
    nr_free = nr_free_store;
c01033e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033ec:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    free_page(p);
c01033f1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01033f8:	00 
c01033f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01033fc:	89 04 24             	mov    %eax,(%esp)
c01033ff:	e8 d9 09 00 00       	call   c0103ddd <free_pages>
    free_page(p1);
c0103404:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010340b:	00 
c010340c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010340f:	89 04 24             	mov    %eax,(%esp)
c0103412:	e8 c6 09 00 00       	call   c0103ddd <free_pages>
    free_page(p2);
c0103417:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010341e:	00 
c010341f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103422:	89 04 24             	mov    %eax,(%esp)
c0103425:	e8 b3 09 00 00       	call   c0103ddd <free_pages>
}
c010342a:	c9                   	leave  
c010342b:	c3                   	ret    

c010342c <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c010342c:	55                   	push   %ebp
c010342d:	89 e5                	mov    %esp,%ebp
c010342f:	53                   	push   %ebx
c0103430:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0103436:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010343d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103444:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010344b:	eb 6b                	jmp    c01034b8 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c010344d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103450:	83 e8 0c             	sub    $0xc,%eax
c0103453:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103456:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103459:	83 c0 04             	add    $0x4,%eax
c010345c:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103463:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103466:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103469:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010346c:	0f a3 10             	bt     %edx,(%eax)
c010346f:	19 db                	sbb    %ebx,%ebx
c0103471:	89 5d c8             	mov    %ebx,-0x38(%ebp)
    return oldbit != 0;
c0103474:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103478:	0f 95 c0             	setne  %al
c010347b:	0f b6 c0             	movzbl %al,%eax
c010347e:	85 c0                	test   %eax,%eax
c0103480:	75 24                	jne    c01034a6 <default_check+0x7a>
c0103482:	c7 44 24 0c be 69 10 	movl   $0xc01069be,0xc(%esp)
c0103489:	c0 
c010348a:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c0103491:	c0 
c0103492:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0103499:	00 
c010349a:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c01034a1:	e8 f6 d7 ff ff       	call   c0100c9c <__panic>
        count ++, total += p->property;
c01034a6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01034aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01034ad:	8b 50 08             	mov    0x8(%eax),%edx
c01034b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01034b3:	01 d0                	add    %edx,%eax
c01034b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01034b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034bb:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01034be:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01034c1:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01034c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01034c7:	81 7d ec 50 89 11 c0 	cmpl   $0xc0118950,-0x14(%ebp)
c01034ce:	0f 85 79 ff ff ff    	jne    c010344d <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c01034d4:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c01034d7:	e8 33 09 00 00       	call   c0103e0f <nr_free_pages>
c01034dc:	39 c3                	cmp    %eax,%ebx
c01034de:	74 24                	je     c0103504 <default_check+0xd8>
c01034e0:	c7 44 24 0c ce 69 10 	movl   $0xc01069ce,0xc(%esp)
c01034e7:	c0 
c01034e8:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c01034ef:	c0 
c01034f0:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c01034f7:	00 
c01034f8:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c01034ff:	e8 98 d7 ff ff       	call   c0100c9c <__panic>

    basic_check();
c0103504:	e8 e7 f9 ff ff       	call   c0102ef0 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103509:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103510:	e8 90 08 00 00       	call   c0103da5 <alloc_pages>
c0103515:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0103518:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010351c:	75 24                	jne    c0103542 <default_check+0x116>
c010351e:	c7 44 24 0c e7 69 10 	movl   $0xc01069e7,0xc(%esp)
c0103525:	c0 
c0103526:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c010352d:	c0 
c010352e:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c0103535:	00 
c0103536:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c010353d:	e8 5a d7 ff ff       	call   c0100c9c <__panic>
    assert(!PageProperty(p0));
c0103542:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103545:	83 c0 04             	add    $0x4,%eax
c0103548:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c010354f:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103552:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103555:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103558:	0f a3 10             	bt     %edx,(%eax)
c010355b:	19 db                	sbb    %ebx,%ebx
c010355d:	89 5d b8             	mov    %ebx,-0x48(%ebp)
    return oldbit != 0;
c0103560:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103564:	0f 95 c0             	setne  %al
c0103567:	0f b6 c0             	movzbl %al,%eax
c010356a:	85 c0                	test   %eax,%eax
c010356c:	74 24                	je     c0103592 <default_check+0x166>
c010356e:	c7 44 24 0c f2 69 10 	movl   $0xc01069f2,0xc(%esp)
c0103575:	c0 
c0103576:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c010357d:	c0 
c010357e:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0103585:	00 
c0103586:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c010358d:	e8 0a d7 ff ff       	call   c0100c9c <__panic>

    list_entry_t free_list_store = free_list;
c0103592:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0103597:	8b 15 54 89 11 c0    	mov    0xc0118954,%edx
c010359d:	89 45 80             	mov    %eax,-0x80(%ebp)
c01035a0:	89 55 84             	mov    %edx,-0x7c(%ebp)
c01035a3:	c7 45 b4 50 89 11 c0 	movl   $0xc0118950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01035aa:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01035ad:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01035b0:	89 50 04             	mov    %edx,0x4(%eax)
c01035b3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01035b6:	8b 50 04             	mov    0x4(%eax),%edx
c01035b9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01035bc:	89 10                	mov    %edx,(%eax)
c01035be:	c7 45 b0 50 89 11 c0 	movl   $0xc0118950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01035c5:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01035c8:	8b 40 04             	mov    0x4(%eax),%eax
c01035cb:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c01035ce:	0f 94 c0             	sete   %al
c01035d1:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01035d4:	85 c0                	test   %eax,%eax
c01035d6:	75 24                	jne    c01035fc <default_check+0x1d0>
c01035d8:	c7 44 24 0c 47 69 10 	movl   $0xc0106947,0xc(%esp)
c01035df:	c0 
c01035e0:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c01035e7:	c0 
c01035e8:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c01035ef:	00 
c01035f0:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c01035f7:	e8 a0 d6 ff ff       	call   c0100c9c <__panic>
    assert(alloc_page() == NULL);
c01035fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103603:	e8 9d 07 00 00       	call   c0103da5 <alloc_pages>
c0103608:	85 c0                	test   %eax,%eax
c010360a:	74 24                	je     c0103630 <default_check+0x204>
c010360c:	c7 44 24 0c 5e 69 10 	movl   $0xc010695e,0xc(%esp)
c0103613:	c0 
c0103614:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c010361b:	c0 
c010361c:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0103623:	00 
c0103624:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c010362b:	e8 6c d6 ff ff       	call   c0100c9c <__panic>

    unsigned int nr_free_store = nr_free;
c0103630:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103635:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0103638:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c010363f:	00 00 00 

    free_pages(p0 + 2, 3);
c0103642:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103645:	83 c0 28             	add    $0x28,%eax
c0103648:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c010364f:	00 
c0103650:	89 04 24             	mov    %eax,(%esp)
c0103653:	e8 85 07 00 00       	call   c0103ddd <free_pages>
    assert(alloc_pages(4) == NULL);
c0103658:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010365f:	e8 41 07 00 00       	call   c0103da5 <alloc_pages>
c0103664:	85 c0                	test   %eax,%eax
c0103666:	74 24                	je     c010368c <default_check+0x260>
c0103668:	c7 44 24 0c 04 6a 10 	movl   $0xc0106a04,0xc(%esp)
c010366f:	c0 
c0103670:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c0103677:	c0 
c0103678:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c010367f:	00 
c0103680:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c0103687:	e8 10 d6 ff ff       	call   c0100c9c <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c010368c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010368f:	83 c0 28             	add    $0x28,%eax
c0103692:	83 c0 04             	add    $0x4,%eax
c0103695:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c010369c:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010369f:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01036a2:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01036a5:	0f a3 10             	bt     %edx,(%eax)
c01036a8:	19 db                	sbb    %ebx,%ebx
c01036aa:	89 5d a4             	mov    %ebx,-0x5c(%ebp)
    return oldbit != 0;
c01036ad:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c01036b1:	0f 95 c0             	setne  %al
c01036b4:	0f b6 c0             	movzbl %al,%eax
c01036b7:	85 c0                	test   %eax,%eax
c01036b9:	74 0e                	je     c01036c9 <default_check+0x29d>
c01036bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036be:	83 c0 28             	add    $0x28,%eax
c01036c1:	8b 40 08             	mov    0x8(%eax),%eax
c01036c4:	83 f8 03             	cmp    $0x3,%eax
c01036c7:	74 24                	je     c01036ed <default_check+0x2c1>
c01036c9:	c7 44 24 0c 1c 6a 10 	movl   $0xc0106a1c,0xc(%esp)
c01036d0:	c0 
c01036d1:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c01036d8:	c0 
c01036d9:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c01036e0:	00 
c01036e1:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c01036e8:	e8 af d5 ff ff       	call   c0100c9c <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c01036ed:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c01036f4:	e8 ac 06 00 00       	call   c0103da5 <alloc_pages>
c01036f9:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01036fc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103700:	75 24                	jne    c0103726 <default_check+0x2fa>
c0103702:	c7 44 24 0c 48 6a 10 	movl   $0xc0106a48,0xc(%esp)
c0103709:	c0 
c010370a:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c0103711:	c0 
c0103712:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c0103719:	00 
c010371a:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c0103721:	e8 76 d5 ff ff       	call   c0100c9c <__panic>
    assert(alloc_page() == NULL);
c0103726:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010372d:	e8 73 06 00 00       	call   c0103da5 <alloc_pages>
c0103732:	85 c0                	test   %eax,%eax
c0103734:	74 24                	je     c010375a <default_check+0x32e>
c0103736:	c7 44 24 0c 5e 69 10 	movl   $0xc010695e,0xc(%esp)
c010373d:	c0 
c010373e:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c0103745:	c0 
c0103746:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
c010374d:	00 
c010374e:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c0103755:	e8 42 d5 ff ff       	call   c0100c9c <__panic>
    assert(p0 + 2 == p1);
c010375a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010375d:	83 c0 28             	add    $0x28,%eax
c0103760:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103763:	74 24                	je     c0103789 <default_check+0x35d>
c0103765:	c7 44 24 0c 66 6a 10 	movl   $0xc0106a66,0xc(%esp)
c010376c:	c0 
c010376d:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c0103774:	c0 
c0103775:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
c010377c:	00 
c010377d:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c0103784:	e8 13 d5 ff ff       	call   c0100c9c <__panic>

    p2 = p0 + 1;
c0103789:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010378c:	83 c0 14             	add    $0x14,%eax
c010378f:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c0103792:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103799:	00 
c010379a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010379d:	89 04 24             	mov    %eax,(%esp)
c01037a0:	e8 38 06 00 00       	call   c0103ddd <free_pages>
    free_pages(p1, 3);
c01037a5:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01037ac:	00 
c01037ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01037b0:	89 04 24             	mov    %eax,(%esp)
c01037b3:	e8 25 06 00 00       	call   c0103ddd <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c01037b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01037bb:	83 c0 04             	add    $0x4,%eax
c01037be:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c01037c5:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01037c8:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01037cb:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01037ce:	0f a3 10             	bt     %edx,(%eax)
c01037d1:	19 db                	sbb    %ebx,%ebx
c01037d3:	89 5d 98             	mov    %ebx,-0x68(%ebp)
    return oldbit != 0;
c01037d6:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c01037da:	0f 95 c0             	setne  %al
c01037dd:	0f b6 c0             	movzbl %al,%eax
c01037e0:	85 c0                	test   %eax,%eax
c01037e2:	74 0b                	je     c01037ef <default_check+0x3c3>
c01037e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01037e7:	8b 40 08             	mov    0x8(%eax),%eax
c01037ea:	83 f8 01             	cmp    $0x1,%eax
c01037ed:	74 24                	je     c0103813 <default_check+0x3e7>
c01037ef:	c7 44 24 0c 74 6a 10 	movl   $0xc0106a74,0xc(%esp)
c01037f6:	c0 
c01037f7:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c01037fe:	c0 
c01037ff:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c0103806:	00 
c0103807:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c010380e:	e8 89 d4 ff ff       	call   c0100c9c <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0103813:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103816:	83 c0 04             	add    $0x4,%eax
c0103819:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0103820:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103823:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103826:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103829:	0f a3 10             	bt     %edx,(%eax)
c010382c:	19 db                	sbb    %ebx,%ebx
c010382e:	89 5d 8c             	mov    %ebx,-0x74(%ebp)
    return oldbit != 0;
c0103831:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0103835:	0f 95 c0             	setne  %al
c0103838:	0f b6 c0             	movzbl %al,%eax
c010383b:	85 c0                	test   %eax,%eax
c010383d:	74 0b                	je     c010384a <default_check+0x41e>
c010383f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103842:	8b 40 08             	mov    0x8(%eax),%eax
c0103845:	83 f8 03             	cmp    $0x3,%eax
c0103848:	74 24                	je     c010386e <default_check+0x442>
c010384a:	c7 44 24 0c 9c 6a 10 	movl   $0xc0106a9c,0xc(%esp)
c0103851:	c0 
c0103852:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c0103859:	c0 
c010385a:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c0103861:	00 
c0103862:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c0103869:	e8 2e d4 ff ff       	call   c0100c9c <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c010386e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103875:	e8 2b 05 00 00       	call   c0103da5 <alloc_pages>
c010387a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010387d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103880:	83 e8 14             	sub    $0x14,%eax
c0103883:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103886:	74 24                	je     c01038ac <default_check+0x480>
c0103888:	c7 44 24 0c c2 6a 10 	movl   $0xc0106ac2,0xc(%esp)
c010388f:	c0 
c0103890:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c0103897:	c0 
c0103898:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c010389f:	00 
c01038a0:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c01038a7:	e8 f0 d3 ff ff       	call   c0100c9c <__panic>
    free_page(p0);
c01038ac:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01038b3:	00 
c01038b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01038b7:	89 04 24             	mov    %eax,(%esp)
c01038ba:	e8 1e 05 00 00       	call   c0103ddd <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01038bf:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01038c6:	e8 da 04 00 00       	call   c0103da5 <alloc_pages>
c01038cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01038ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01038d1:	83 c0 14             	add    $0x14,%eax
c01038d4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01038d7:	74 24                	je     c01038fd <default_check+0x4d1>
c01038d9:	c7 44 24 0c e0 6a 10 	movl   $0xc0106ae0,0xc(%esp)
c01038e0:	c0 
c01038e1:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c01038e8:	c0 
c01038e9:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c01038f0:	00 
c01038f1:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c01038f8:	e8 9f d3 ff ff       	call   c0100c9c <__panic>

    free_pages(p0, 2);
c01038fd:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0103904:	00 
c0103905:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103908:	89 04 24             	mov    %eax,(%esp)
c010390b:	e8 cd 04 00 00       	call   c0103ddd <free_pages>
    free_page(p2);
c0103910:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103917:	00 
c0103918:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010391b:	89 04 24             	mov    %eax,(%esp)
c010391e:	e8 ba 04 00 00       	call   c0103ddd <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0103923:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010392a:	e8 76 04 00 00       	call   c0103da5 <alloc_pages>
c010392f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103932:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103936:	75 24                	jne    c010395c <default_check+0x530>
c0103938:	c7 44 24 0c 00 6b 10 	movl   $0xc0106b00,0xc(%esp)
c010393f:	c0 
c0103940:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c0103947:	c0 
c0103948:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c010394f:	00 
c0103950:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c0103957:	e8 40 d3 ff ff       	call   c0100c9c <__panic>
    assert(alloc_page() == NULL);
c010395c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103963:	e8 3d 04 00 00       	call   c0103da5 <alloc_pages>
c0103968:	85 c0                	test   %eax,%eax
c010396a:	74 24                	je     c0103990 <default_check+0x564>
c010396c:	c7 44 24 0c 5e 69 10 	movl   $0xc010695e,0xc(%esp)
c0103973:	c0 
c0103974:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c010397b:	c0 
c010397c:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
c0103983:	00 
c0103984:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c010398b:	e8 0c d3 ff ff       	call   c0100c9c <__panic>

    assert(nr_free == 0);
c0103990:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103995:	85 c0                	test   %eax,%eax
c0103997:	74 24                	je     c01039bd <default_check+0x591>
c0103999:	c7 44 24 0c b1 69 10 	movl   $0xc01069b1,0xc(%esp)
c01039a0:	c0 
c01039a1:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c01039a8:	c0 
c01039a9:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c01039b0:	00 
c01039b1:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c01039b8:	e8 df d2 ff ff       	call   c0100c9c <__panic>
    nr_free = nr_free_store;
c01039bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01039c0:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    free_list = free_list_store;
c01039c5:	8b 45 80             	mov    -0x80(%ebp),%eax
c01039c8:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01039cb:	a3 50 89 11 c0       	mov    %eax,0xc0118950
c01039d0:	89 15 54 89 11 c0    	mov    %edx,0xc0118954
    free_pages(p0, 5);
c01039d6:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c01039dd:	00 
c01039de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01039e1:	89 04 24             	mov    %eax,(%esp)
c01039e4:	e8 f4 03 00 00       	call   c0103ddd <free_pages>

    le = &free_list;
c01039e9:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01039f0:	eb 1f                	jmp    c0103a11 <default_check+0x5e5>
        struct Page *p = le2page(le, page_link);
c01039f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039f5:	83 e8 0c             	sub    $0xc,%eax
c01039f8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c01039fb:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01039ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103a02:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103a05:	8b 40 08             	mov    0x8(%eax),%eax
c0103a08:	89 d1                	mov    %edx,%ecx
c0103a0a:	29 c1                	sub    %eax,%ecx
c0103a0c:	89 c8                	mov    %ecx,%eax
c0103a0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a11:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103a14:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103a17:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103a1a:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103a1d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103a20:	81 7d ec 50 89 11 c0 	cmpl   $0xc0118950,-0x14(%ebp)
c0103a27:	75 c9                	jne    c01039f2 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0103a29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103a2d:	74 24                	je     c0103a53 <default_check+0x627>
c0103a2f:	c7 44 24 0c 1e 6b 10 	movl   $0xc0106b1e,0xc(%esp)
c0103a36:	c0 
c0103a37:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c0103a3e:	c0 
c0103a3f:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c0103a46:	00 
c0103a47:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c0103a4e:	e8 49 d2 ff ff       	call   c0100c9c <__panic>
    assert(total == 0);
c0103a53:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103a57:	74 24                	je     c0103a7d <default_check+0x651>
c0103a59:	c7 44 24 0c 29 6b 10 	movl   $0xc0106b29,0xc(%esp)
c0103a60:	c0 
c0103a61:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c0103a68:	c0 
c0103a69:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c0103a70:	00 
c0103a71:	c7 04 24 eb 67 10 c0 	movl   $0xc01067eb,(%esp)
c0103a78:	e8 1f d2 ff ff       	call   c0100c9c <__panic>
}
c0103a7d:	81 c4 94 00 00 00    	add    $0x94,%esp
c0103a83:	5b                   	pop    %ebx
c0103a84:	5d                   	pop    %ebp
c0103a85:	c3                   	ret    
	...

c0103a88 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103a88:	55                   	push   %ebp
c0103a89:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103a8b:	8b 55 08             	mov    0x8(%ebp),%edx
c0103a8e:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0103a93:	89 d1                	mov    %edx,%ecx
c0103a95:	29 c1                	sub    %eax,%ecx
c0103a97:	89 c8                	mov    %ecx,%eax
c0103a99:	c1 f8 02             	sar    $0x2,%eax
c0103a9c:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103aa2:	5d                   	pop    %ebp
c0103aa3:	c3                   	ret    

c0103aa4 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103aa4:	55                   	push   %ebp
c0103aa5:	89 e5                	mov    %esp,%ebp
c0103aa7:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103aaa:	8b 45 08             	mov    0x8(%ebp),%eax
c0103aad:	89 04 24             	mov    %eax,(%esp)
c0103ab0:	e8 d3 ff ff ff       	call   c0103a88 <page2ppn>
c0103ab5:	c1 e0 0c             	shl    $0xc,%eax
}
c0103ab8:	c9                   	leave  
c0103ab9:	c3                   	ret    

c0103aba <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0103aba:	55                   	push   %ebp
c0103abb:	89 e5                	mov    %esp,%ebp
c0103abd:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103ac0:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ac3:	89 c2                	mov    %eax,%edx
c0103ac5:	c1 ea 0c             	shr    $0xc,%edx
c0103ac8:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103acd:	39 c2                	cmp    %eax,%edx
c0103acf:	72 1c                	jb     c0103aed <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103ad1:	c7 44 24 08 64 6b 10 	movl   $0xc0106b64,0x8(%esp)
c0103ad8:	c0 
c0103ad9:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0103ae0:	00 
c0103ae1:	c7 04 24 83 6b 10 c0 	movl   $0xc0106b83,(%esp)
c0103ae8:	e8 af d1 ff ff       	call   c0100c9c <__panic>
    }
    return &pages[PPN(pa)];
c0103aed:	8b 0d 64 89 11 c0    	mov    0xc0118964,%ecx
c0103af3:	8b 45 08             	mov    0x8(%ebp),%eax
c0103af6:	89 c2                	mov    %eax,%edx
c0103af8:	c1 ea 0c             	shr    $0xc,%edx
c0103afb:	89 d0                	mov    %edx,%eax
c0103afd:	c1 e0 02             	shl    $0x2,%eax
c0103b00:	01 d0                	add    %edx,%eax
c0103b02:	c1 e0 02             	shl    $0x2,%eax
c0103b05:	01 c8                	add    %ecx,%eax
}
c0103b07:	c9                   	leave  
c0103b08:	c3                   	ret    

c0103b09 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0103b09:	55                   	push   %ebp
c0103b0a:	89 e5                	mov    %esp,%ebp
c0103b0c:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103b0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b12:	89 04 24             	mov    %eax,(%esp)
c0103b15:	e8 8a ff ff ff       	call   c0103aa4 <page2pa>
c0103b1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b20:	c1 e8 0c             	shr    $0xc,%eax
c0103b23:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103b26:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103b2b:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103b2e:	72 23                	jb     c0103b53 <page2kva+0x4a>
c0103b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b33:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103b37:	c7 44 24 08 94 6b 10 	movl   $0xc0106b94,0x8(%esp)
c0103b3e:	c0 
c0103b3f:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103b46:	00 
c0103b47:	c7 04 24 83 6b 10 c0 	movl   $0xc0106b83,(%esp)
c0103b4e:	e8 49 d1 ff ff       	call   c0100c9c <__panic>
c0103b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b56:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103b5b:	c9                   	leave  
c0103b5c:	c3                   	ret    

c0103b5d <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0103b5d:	55                   	push   %ebp
c0103b5e:	89 e5                	mov    %esp,%ebp
c0103b60:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103b63:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b66:	83 e0 01             	and    $0x1,%eax
c0103b69:	85 c0                	test   %eax,%eax
c0103b6b:	75 1c                	jne    c0103b89 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103b6d:	c7 44 24 08 b8 6b 10 	movl   $0xc0106bb8,0x8(%esp)
c0103b74:	c0 
c0103b75:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103b7c:	00 
c0103b7d:	c7 04 24 83 6b 10 c0 	movl   $0xc0106b83,(%esp)
c0103b84:	e8 13 d1 ff ff       	call   c0100c9c <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0103b89:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b8c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103b91:	89 04 24             	mov    %eax,(%esp)
c0103b94:	e8 21 ff ff ff       	call   c0103aba <pa2page>
}
c0103b99:	c9                   	leave  
c0103b9a:	c3                   	ret    

c0103b9b <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0103b9b:	55                   	push   %ebp
c0103b9c:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103b9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ba1:	8b 00                	mov    (%eax),%eax
}
c0103ba3:	5d                   	pop    %ebp
c0103ba4:	c3                   	ret    

c0103ba5 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103ba5:	55                   	push   %ebp
c0103ba6:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103ba8:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bab:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103bae:	89 10                	mov    %edx,(%eax)
}
c0103bb0:	5d                   	pop    %ebp
c0103bb1:	c3                   	ret    

c0103bb2 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0103bb2:	55                   	push   %ebp
c0103bb3:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103bb5:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bb8:	8b 00                	mov    (%eax),%eax
c0103bba:	8d 50 01             	lea    0x1(%eax),%edx
c0103bbd:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bc0:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103bc2:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bc5:	8b 00                	mov    (%eax),%eax
}
c0103bc7:	5d                   	pop    %ebp
c0103bc8:	c3                   	ret    

c0103bc9 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103bc9:	55                   	push   %ebp
c0103bca:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103bcc:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bcf:	8b 00                	mov    (%eax),%eax
c0103bd1:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103bd4:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bd7:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103bd9:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bdc:	8b 00                	mov    (%eax),%eax
}
c0103bde:	5d                   	pop    %ebp
c0103bdf:	c3                   	ret    

c0103be0 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0103be0:	55                   	push   %ebp
c0103be1:	89 e5                	mov    %esp,%ebp
c0103be3:	53                   	push   %ebx
c0103be4:	83 ec 14             	sub    $0x14,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103be7:	9c                   	pushf  
c0103be8:	5b                   	pop    %ebx
c0103be9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return eflags;
c0103bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103bef:	25 00 02 00 00       	and    $0x200,%eax
c0103bf4:	85 c0                	test   %eax,%eax
c0103bf6:	74 0c                	je     c0103c04 <__intr_save+0x24>
        intr_disable();
c0103bf8:	e8 31 db ff ff       	call   c010172e <intr_disable>
        return 1;
c0103bfd:	b8 01 00 00 00       	mov    $0x1,%eax
c0103c02:	eb 05                	jmp    c0103c09 <__intr_save+0x29>
    }
    return 0;
c0103c04:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103c09:	83 c4 14             	add    $0x14,%esp
c0103c0c:	5b                   	pop    %ebx
c0103c0d:	5d                   	pop    %ebp
c0103c0e:	c3                   	ret    

c0103c0f <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0103c0f:	55                   	push   %ebp
c0103c10:	89 e5                	mov    %esp,%ebp
c0103c12:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103c15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103c19:	74 05                	je     c0103c20 <__intr_restore+0x11>
        intr_enable();
c0103c1b:	e8 08 db ff ff       	call   c0101728 <intr_enable>
    }
}
c0103c20:	c9                   	leave  
c0103c21:	c3                   	ret    

c0103c22 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103c22:	55                   	push   %ebp
c0103c23:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103c25:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c28:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103c2b:	b8 23 00 00 00       	mov    $0x23,%eax
c0103c30:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103c32:	b8 23 00 00 00       	mov    $0x23,%eax
c0103c37:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103c39:	b8 10 00 00 00       	mov    $0x10,%eax
c0103c3e:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103c40:	b8 10 00 00 00       	mov    $0x10,%eax
c0103c45:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103c47:	b8 10 00 00 00       	mov    $0x10,%eax
c0103c4c:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103c4e:	ea 55 3c 10 c0 08 00 	ljmp   $0x8,$0xc0103c55
}
c0103c55:	5d                   	pop    %ebp
c0103c56:	c3                   	ret    

c0103c57 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103c57:	55                   	push   %ebp
c0103c58:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103c5a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c5d:	a3 e4 88 11 c0       	mov    %eax,0xc01188e4
}
c0103c62:	5d                   	pop    %ebp
c0103c63:	c3                   	ret    

c0103c64 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103c64:	55                   	push   %ebp
c0103c65:	89 e5                	mov    %esp,%ebp
c0103c67:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103c6a:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0103c6f:	89 04 24             	mov    %eax,(%esp)
c0103c72:	e8 e0 ff ff ff       	call   c0103c57 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103c77:	66 c7 05 e8 88 11 c0 	movw   $0x10,0xc01188e8
c0103c7e:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103c80:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0103c87:	68 00 
c0103c89:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103c8e:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0103c94:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103c99:	c1 e8 10             	shr    $0x10,%eax
c0103c9c:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0103ca1:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103ca8:	83 e0 f0             	and    $0xfffffff0,%eax
c0103cab:	83 c8 09             	or     $0x9,%eax
c0103cae:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103cb3:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103cba:	83 e0 ef             	and    $0xffffffef,%eax
c0103cbd:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103cc2:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103cc9:	83 e0 9f             	and    $0xffffff9f,%eax
c0103ccc:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103cd1:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103cd8:	83 c8 80             	or     $0xffffff80,%eax
c0103cdb:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103ce0:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103ce7:	83 e0 f0             	and    $0xfffffff0,%eax
c0103cea:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103cef:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103cf6:	83 e0 ef             	and    $0xffffffef,%eax
c0103cf9:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103cfe:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103d05:	83 e0 df             	and    $0xffffffdf,%eax
c0103d08:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103d0d:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103d14:	83 c8 40             	or     $0x40,%eax
c0103d17:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103d1c:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103d23:	83 e0 7f             	and    $0x7f,%eax
c0103d26:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103d2b:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103d30:	c1 e8 18             	shr    $0x18,%eax
c0103d33:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103d38:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c0103d3f:	e8 de fe ff ff       	call   c0103c22 <lgdt>
c0103d44:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103d4a:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103d4e:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103d51:	c9                   	leave  
c0103d52:	c3                   	ret    

c0103d53 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103d53:	55                   	push   %ebp
c0103d54:	89 e5                	mov    %esp,%ebp
c0103d56:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103d59:	c7 05 5c 89 11 c0 48 	movl   $0xc0106b48,0xc011895c
c0103d60:	6b 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103d63:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d68:	8b 00                	mov    (%eax),%eax
c0103d6a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103d6e:	c7 04 24 e4 6b 10 c0 	movl   $0xc0106be4,(%esp)
c0103d75:	e8 cd c5 ff ff       	call   c0100347 <cprintf>
    pmm_manager->init();
c0103d7a:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d7f:	8b 40 04             	mov    0x4(%eax),%eax
c0103d82:	ff d0                	call   *%eax
}
c0103d84:	c9                   	leave  
c0103d85:	c3                   	ret    

c0103d86 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103d86:	55                   	push   %ebp
c0103d87:	89 e5                	mov    %esp,%ebp
c0103d89:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103d8c:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d91:	8b 50 08             	mov    0x8(%eax),%edx
c0103d94:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103d97:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103d9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d9e:	89 04 24             	mov    %eax,(%esp)
c0103da1:	ff d2                	call   *%edx
}
c0103da3:	c9                   	leave  
c0103da4:	c3                   	ret    

c0103da5 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103da5:	55                   	push   %ebp
c0103da6:	89 e5                	mov    %esp,%ebp
c0103da8:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103dab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103db2:	e8 29 fe ff ff       	call   c0103be0 <__intr_save>
c0103db7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103dba:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103dbf:	8b 50 0c             	mov    0xc(%eax),%edx
c0103dc2:	8b 45 08             	mov    0x8(%ebp),%eax
c0103dc5:	89 04 24             	mov    %eax,(%esp)
c0103dc8:	ff d2                	call   *%edx
c0103dca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103dd0:	89 04 24             	mov    %eax,(%esp)
c0103dd3:	e8 37 fe ff ff       	call   c0103c0f <__intr_restore>
    return page;
c0103dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103ddb:	c9                   	leave  
c0103ddc:	c3                   	ret    

c0103ddd <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103ddd:	55                   	push   %ebp
c0103dde:	89 e5                	mov    %esp,%ebp
c0103de0:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103de3:	e8 f8 fd ff ff       	call   c0103be0 <__intr_save>
c0103de8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103deb:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103df0:	8b 50 10             	mov    0x10(%eax),%edx
c0103df3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103df6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103dfa:	8b 45 08             	mov    0x8(%ebp),%eax
c0103dfd:	89 04 24             	mov    %eax,(%esp)
c0103e00:	ff d2                	call   *%edx
    }
    local_intr_restore(intr_flag);
c0103e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e05:	89 04 24             	mov    %eax,(%esp)
c0103e08:	e8 02 fe ff ff       	call   c0103c0f <__intr_restore>
}
c0103e0d:	c9                   	leave  
c0103e0e:	c3                   	ret    

c0103e0f <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103e0f:	55                   	push   %ebp
c0103e10:	89 e5                	mov    %esp,%ebp
c0103e12:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103e15:	e8 c6 fd ff ff       	call   c0103be0 <__intr_save>
c0103e1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103e1d:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103e22:	8b 40 14             	mov    0x14(%eax),%eax
c0103e25:	ff d0                	call   *%eax
c0103e27:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103e2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e2d:	89 04 24             	mov    %eax,(%esp)
c0103e30:	e8 da fd ff ff       	call   c0103c0f <__intr_restore>
    return ret;
c0103e35:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103e38:	c9                   	leave  
c0103e39:	c3                   	ret    

c0103e3a <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103e3a:	55                   	push   %ebp
c0103e3b:	89 e5                	mov    %esp,%ebp
c0103e3d:	57                   	push   %edi
c0103e3e:	56                   	push   %esi
c0103e3f:	53                   	push   %ebx
c0103e40:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103e46:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103e4d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103e54:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103e5b:	c7 04 24 fb 6b 10 c0 	movl   $0xc0106bfb,(%esp)
c0103e62:	e8 e0 c4 ff ff       	call   c0100347 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103e67:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103e6e:	e9 0b 01 00 00       	jmp    c0103f7e <page_init+0x144>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103e73:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e76:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e79:	89 d0                	mov    %edx,%eax
c0103e7b:	c1 e0 02             	shl    $0x2,%eax
c0103e7e:	01 d0                	add    %edx,%eax
c0103e80:	c1 e0 02             	shl    $0x2,%eax
c0103e83:	01 c8                	add    %ecx,%eax
c0103e85:	8b 50 08             	mov    0x8(%eax),%edx
c0103e88:	8b 40 04             	mov    0x4(%eax),%eax
c0103e8b:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103e8e:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103e91:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e94:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e97:	89 d0                	mov    %edx,%eax
c0103e99:	c1 e0 02             	shl    $0x2,%eax
c0103e9c:	01 d0                	add    %edx,%eax
c0103e9e:	c1 e0 02             	shl    $0x2,%eax
c0103ea1:	01 c8                	add    %ecx,%eax
c0103ea3:	8b 50 10             	mov    0x10(%eax),%edx
c0103ea6:	8b 40 0c             	mov    0xc(%eax),%eax
c0103ea9:	03 45 b8             	add    -0x48(%ebp),%eax
c0103eac:	13 55 bc             	adc    -0x44(%ebp),%edx
c0103eaf:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103eb2:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
c0103eb5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103eb8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ebb:	89 d0                	mov    %edx,%eax
c0103ebd:	c1 e0 02             	shl    $0x2,%eax
c0103ec0:	01 d0                	add    %edx,%eax
c0103ec2:	c1 e0 02             	shl    $0x2,%eax
c0103ec5:	01 c8                	add    %ecx,%eax
c0103ec7:	83 c0 14             	add    $0x14,%eax
c0103eca:	8b 00                	mov    (%eax),%eax
c0103ecc:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0103ecf:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103ed2:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103ed5:	89 c6                	mov    %eax,%esi
c0103ed7:	89 d7                	mov    %edx,%edi
c0103ed9:	83 c6 ff             	add    $0xffffffff,%esi
c0103edc:	83 d7 ff             	adc    $0xffffffff,%edi
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
c0103edf:	8b 4d c4             	mov    -0x3c(%ebp),%ecx

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103ee2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ee5:	89 d0                	mov    %edx,%eax
c0103ee7:	c1 e0 02             	shl    $0x2,%eax
c0103eea:	01 d0                	add    %edx,%eax
c0103eec:	c1 e0 02             	shl    $0x2,%eax
c0103eef:	01 c8                	add    %ecx,%eax
c0103ef1:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103ef4:	8b 58 10             	mov    0x10(%eax),%ebx
c0103ef7:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0103efa:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0103efe:	89 74 24 14          	mov    %esi,0x14(%esp)
c0103f02:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0103f06:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103f09:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103f0c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103f10:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103f14:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103f18:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0103f1c:	c7 04 24 08 6c 10 c0 	movl   $0xc0106c08,(%esp)
c0103f23:	e8 1f c4 ff ff       	call   c0100347 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103f28:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103f2b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f2e:	89 d0                	mov    %edx,%eax
c0103f30:	c1 e0 02             	shl    $0x2,%eax
c0103f33:	01 d0                	add    %edx,%eax
c0103f35:	c1 e0 02             	shl    $0x2,%eax
c0103f38:	01 c8                	add    %ecx,%eax
c0103f3a:	83 c0 14             	add    $0x14,%eax
c0103f3d:	8b 00                	mov    (%eax),%eax
c0103f3f:	83 f8 01             	cmp    $0x1,%eax
c0103f42:	75 36                	jne    c0103f7a <page_init+0x140>
            if (maxpa < end && begin < KMEMSIZE) {
c0103f44:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103f47:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103f4a:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103f4d:	77 2b                	ja     c0103f7a <page_init+0x140>
c0103f4f:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103f52:	72 05                	jb     c0103f59 <page_init+0x11f>
c0103f54:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0103f57:	73 21                	jae    c0103f7a <page_init+0x140>
c0103f59:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103f5d:	77 1b                	ja     c0103f7a <page_init+0x140>
c0103f5f:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103f63:	72 09                	jb     c0103f6e <page_init+0x134>
c0103f65:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0103f6c:	77 0c                	ja     c0103f7a <page_init+0x140>
                maxpa = end;
c0103f6e:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103f71:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103f74:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103f77:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103f7a:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103f7e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103f81:	8b 00                	mov    (%eax),%eax
c0103f83:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103f86:	0f 8f e7 fe ff ff    	jg     c0103e73 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0103f8c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103f90:	72 1d                	jb     c0103faf <page_init+0x175>
c0103f92:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103f96:	77 09                	ja     c0103fa1 <page_init+0x167>
c0103f98:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0103f9f:	76 0e                	jbe    c0103faf <page_init+0x175>
        maxpa = KMEMSIZE;
c0103fa1:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0103fa8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0103faf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103fb2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103fb5:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103fb9:	c1 ea 0c             	shr    $0xc,%edx
c0103fbc:	a3 c0 88 11 c0       	mov    %eax,0xc01188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0103fc1:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0103fc8:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c0103fcd:	83 e8 01             	sub    $0x1,%eax
c0103fd0:	03 45 ac             	add    -0x54(%ebp),%eax
c0103fd3:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103fd6:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103fd9:	ba 00 00 00 00       	mov    $0x0,%edx
c0103fde:	f7 75 ac             	divl   -0x54(%ebp)
c0103fe1:	89 d0                	mov    %edx,%eax
c0103fe3:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0103fe6:	89 d1                	mov    %edx,%ecx
c0103fe8:	29 c1                	sub    %eax,%ecx
c0103fea:	89 c8                	mov    %ecx,%eax
c0103fec:	a3 64 89 11 c0       	mov    %eax,0xc0118964

    for (i = 0; i < npage; i ++) {
c0103ff1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103ff8:	eb 2f                	jmp    c0104029 <page_init+0x1ef>
        SetPageReserved(pages + i);
c0103ffa:	8b 0d 64 89 11 c0    	mov    0xc0118964,%ecx
c0104000:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104003:	89 d0                	mov    %edx,%eax
c0104005:	c1 e0 02             	shl    $0x2,%eax
c0104008:	01 d0                	add    %edx,%eax
c010400a:	c1 e0 02             	shl    $0x2,%eax
c010400d:	01 c8                	add    %ecx,%eax
c010400f:	83 c0 04             	add    $0x4,%eax
c0104012:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0104019:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010401c:	8b 45 8c             	mov    -0x74(%ebp),%eax
c010401f:	8b 55 90             	mov    -0x70(%ebp),%edx
c0104022:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0104025:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104029:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010402c:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104031:	39 c2                	cmp    %eax,%edx
c0104033:	72 c5                	jb     c0103ffa <page_init+0x1c0>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0104035:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c010403b:	89 d0                	mov    %edx,%eax
c010403d:	c1 e0 02             	shl    $0x2,%eax
c0104040:	01 d0                	add    %edx,%eax
c0104042:	c1 e0 02             	shl    $0x2,%eax
c0104045:	89 c2                	mov    %eax,%edx
c0104047:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c010404c:	01 d0                	add    %edx,%eax
c010404e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0104051:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0104058:	77 23                	ja     c010407d <page_init+0x243>
c010405a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010405d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104061:	c7 44 24 08 38 6c 10 	movl   $0xc0106c38,0x8(%esp)
c0104068:	c0 
c0104069:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0104070:	00 
c0104071:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c0104078:	e8 1f cc ff ff       	call   c0100c9c <__panic>
c010407d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104080:	05 00 00 00 40       	add    $0x40000000,%eax
c0104085:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0104088:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010408f:	e9 7c 01 00 00       	jmp    c0104210 <page_init+0x3d6>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104094:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104097:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010409a:	89 d0                	mov    %edx,%eax
c010409c:	c1 e0 02             	shl    $0x2,%eax
c010409f:	01 d0                	add    %edx,%eax
c01040a1:	c1 e0 02             	shl    $0x2,%eax
c01040a4:	01 c8                	add    %ecx,%eax
c01040a6:	8b 50 08             	mov    0x8(%eax),%edx
c01040a9:	8b 40 04             	mov    0x4(%eax),%eax
c01040ac:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01040af:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01040b2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01040b5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01040b8:	89 d0                	mov    %edx,%eax
c01040ba:	c1 e0 02             	shl    $0x2,%eax
c01040bd:	01 d0                	add    %edx,%eax
c01040bf:	c1 e0 02             	shl    $0x2,%eax
c01040c2:	01 c8                	add    %ecx,%eax
c01040c4:	8b 50 10             	mov    0x10(%eax),%edx
c01040c7:	8b 40 0c             	mov    0xc(%eax),%eax
c01040ca:	03 45 d0             	add    -0x30(%ebp),%eax
c01040cd:	13 55 d4             	adc    -0x2c(%ebp),%edx
c01040d0:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01040d3:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c01040d6:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01040d9:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01040dc:	89 d0                	mov    %edx,%eax
c01040de:	c1 e0 02             	shl    $0x2,%eax
c01040e1:	01 d0                	add    %edx,%eax
c01040e3:	c1 e0 02             	shl    $0x2,%eax
c01040e6:	01 c8                	add    %ecx,%eax
c01040e8:	83 c0 14             	add    $0x14,%eax
c01040eb:	8b 00                	mov    (%eax),%eax
c01040ed:	83 f8 01             	cmp    $0x1,%eax
c01040f0:	0f 85 16 01 00 00    	jne    c010420c <page_init+0x3d2>
            if (begin < freemem) {
c01040f6:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01040f9:	ba 00 00 00 00       	mov    $0x0,%edx
c01040fe:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104101:	72 17                	jb     c010411a <page_init+0x2e0>
c0104103:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104106:	77 05                	ja     c010410d <page_init+0x2d3>
c0104108:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c010410b:	76 0d                	jbe    c010411a <page_init+0x2e0>
                begin = freemem;
c010410d:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104110:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104113:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c010411a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010411e:	72 1d                	jb     c010413d <page_init+0x303>
c0104120:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104124:	77 09                	ja     c010412f <page_init+0x2f5>
c0104126:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c010412d:	76 0e                	jbe    c010413d <page_init+0x303>
                end = KMEMSIZE;
c010412f:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0104136:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c010413d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104140:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104143:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104146:	0f 87 c0 00 00 00    	ja     c010420c <page_init+0x3d2>
c010414c:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010414f:	72 09                	jb     c010415a <page_init+0x320>
c0104151:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104154:	0f 83 b2 00 00 00    	jae    c010420c <page_init+0x3d2>
                begin = ROUNDUP(begin, PGSIZE);
c010415a:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0104161:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104164:	03 45 9c             	add    -0x64(%ebp),%eax
c0104167:	83 e8 01             	sub    $0x1,%eax
c010416a:	89 45 98             	mov    %eax,-0x68(%ebp)
c010416d:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104170:	ba 00 00 00 00       	mov    $0x0,%edx
c0104175:	f7 75 9c             	divl   -0x64(%ebp)
c0104178:	89 d0                	mov    %edx,%eax
c010417a:	8b 55 98             	mov    -0x68(%ebp),%edx
c010417d:	89 d1                	mov    %edx,%ecx
c010417f:	29 c1                	sub    %eax,%ecx
c0104181:	89 c8                	mov    %ecx,%eax
c0104183:	ba 00 00 00 00       	mov    $0x0,%edx
c0104188:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010418b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c010418e:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104191:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0104194:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104197:	ba 00 00 00 00       	mov    $0x0,%edx
c010419c:	89 c1                	mov    %eax,%ecx
c010419e:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
c01041a4:	89 8d 78 ff ff ff    	mov    %ecx,-0x88(%ebp)
c01041aa:	89 d1                	mov    %edx,%ecx
c01041ac:	83 e1 00             	and    $0x0,%ecx
c01041af:	89 8d 7c ff ff ff    	mov    %ecx,-0x84(%ebp)
c01041b5:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c01041bb:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c01041c1:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01041c4:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c01041c7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01041ca:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01041cd:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01041d0:	77 3a                	ja     c010420c <page_init+0x3d2>
c01041d2:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01041d5:	72 05                	jb     c01041dc <page_init+0x3a2>
c01041d7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01041da:	73 30                	jae    c010420c <page_init+0x3d2>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01041dc:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c01041df:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c01041e2:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01041e5:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01041e8:	29 c8                	sub    %ecx,%eax
c01041ea:	19 da                	sbb    %ebx,%edx
c01041ec:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01041f0:	c1 ea 0c             	shr    $0xc,%edx
c01041f3:	89 c3                	mov    %eax,%ebx
c01041f5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01041f8:	89 04 24             	mov    %eax,(%esp)
c01041fb:	e8 ba f8 ff ff       	call   c0103aba <pa2page>
c0104200:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104204:	89 04 24             	mov    %eax,(%esp)
c0104207:	e8 7a fb ff ff       	call   c0103d86 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c010420c:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104210:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104213:	8b 00                	mov    (%eax),%eax
c0104215:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104218:	0f 8f 76 fe ff ff    	jg     c0104094 <page_init+0x25a>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c010421e:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0104224:	5b                   	pop    %ebx
c0104225:	5e                   	pop    %esi
c0104226:	5f                   	pop    %edi
c0104227:	5d                   	pop    %ebp
c0104228:	c3                   	ret    

c0104229 <enable_paging>:

static void
enable_paging(void) {
c0104229:	55                   	push   %ebp
c010422a:	89 e5                	mov    %esp,%ebp
c010422c:	53                   	push   %ebx
c010422d:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c0104230:	a1 60 89 11 c0       	mov    0xc0118960,%eax
c0104235:	89 45 f4             	mov    %eax,-0xc(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0104238:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010423b:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c010423e:	0f 20 c3             	mov    %cr0,%ebx
c0104241:	89 5d f0             	mov    %ebx,-0x10(%ebp)
    return cr0;
c0104244:	8b 45 f0             	mov    -0x10(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0104247:	89 45 f8             	mov    %eax,-0x8(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c010424a:	81 4d f8 2f 00 05 80 	orl    $0x8005002f,-0x8(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c0104251:	83 65 f8 f3          	andl   $0xfffffff3,-0x8(%ebp)
c0104255:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0104258:	89 45 ec             	mov    %eax,-0x14(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c010425b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010425e:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c0104261:	83 c4 10             	add    $0x10,%esp
c0104264:	5b                   	pop    %ebx
c0104265:	5d                   	pop    %ebp
c0104266:	c3                   	ret    

c0104267 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0104267:	55                   	push   %ebp
c0104268:	89 e5                	mov    %esp,%ebp
c010426a:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c010426d:	8b 45 14             	mov    0x14(%ebp),%eax
c0104270:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104273:	31 d0                	xor    %edx,%eax
c0104275:	25 ff 0f 00 00       	and    $0xfff,%eax
c010427a:	85 c0                	test   %eax,%eax
c010427c:	74 24                	je     c01042a2 <boot_map_segment+0x3b>
c010427e:	c7 44 24 0c 6a 6c 10 	movl   $0xc0106c6a,0xc(%esp)
c0104285:	c0 
c0104286:	c7 44 24 08 81 6c 10 	movl   $0xc0106c81,0x8(%esp)
c010428d:	c0 
c010428e:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c0104295:	00 
c0104296:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c010429d:	e8 fa c9 ff ff       	call   c0100c9c <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01042a2:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01042a9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01042ac:	25 ff 0f 00 00       	and    $0xfff,%eax
c01042b1:	03 45 10             	add    0x10(%ebp),%eax
c01042b4:	03 45 f0             	add    -0x10(%ebp),%eax
c01042b7:	83 e8 01             	sub    $0x1,%eax
c01042ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01042bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01042c0:	ba 00 00 00 00       	mov    $0x0,%edx
c01042c5:	f7 75 f0             	divl   -0x10(%ebp)
c01042c8:	89 d0                	mov    %edx,%eax
c01042ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01042cd:	89 d1                	mov    %edx,%ecx
c01042cf:	29 c1                	sub    %eax,%ecx
c01042d1:	89 c8                	mov    %ecx,%eax
c01042d3:	c1 e8 0c             	shr    $0xc,%eax
c01042d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01042d9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01042dc:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01042df:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01042e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01042e7:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01042ea:	8b 45 14             	mov    0x14(%ebp),%eax
c01042ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01042f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01042f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01042f8:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01042fb:	eb 6b                	jmp    c0104368 <boot_map_segment+0x101>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01042fd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104304:	00 
c0104305:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104308:	89 44 24 04          	mov    %eax,0x4(%esp)
c010430c:	8b 45 08             	mov    0x8(%ebp),%eax
c010430f:	89 04 24             	mov    %eax,(%esp)
c0104312:	e8 cc 01 00 00       	call   c01044e3 <get_pte>
c0104317:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c010431a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010431e:	75 24                	jne    c0104344 <boot_map_segment+0xdd>
c0104320:	c7 44 24 0c 96 6c 10 	movl   $0xc0106c96,0xc(%esp)
c0104327:	c0 
c0104328:	c7 44 24 08 81 6c 10 	movl   $0xc0106c81,0x8(%esp)
c010432f:	c0 
c0104330:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0104337:	00 
c0104338:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c010433f:	e8 58 c9 ff ff       	call   c0100c9c <__panic>
        *ptep = pa | PTE_P | perm;
c0104344:	8b 45 18             	mov    0x18(%ebp),%eax
c0104347:	8b 55 14             	mov    0x14(%ebp),%edx
c010434a:	09 d0                	or     %edx,%eax
c010434c:	89 c2                	mov    %eax,%edx
c010434e:	83 ca 01             	or     $0x1,%edx
c0104351:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104354:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104356:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010435a:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0104361:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0104368:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010436c:	75 8f                	jne    c01042fd <boot_map_segment+0x96>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c010436e:	c9                   	leave  
c010436f:	c3                   	ret    

c0104370 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0104370:	55                   	push   %ebp
c0104371:	89 e5                	mov    %esp,%ebp
c0104373:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0104376:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010437d:	e8 23 fa ff ff       	call   c0103da5 <alloc_pages>
c0104382:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0104385:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104389:	75 1c                	jne    c01043a7 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c010438b:	c7 44 24 08 a3 6c 10 	movl   $0xc0106ca3,0x8(%esp)
c0104392:	c0 
c0104393:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c010439a:	00 
c010439b:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c01043a2:	e8 f5 c8 ff ff       	call   c0100c9c <__panic>
    }
    return page2kva(p);
c01043a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043aa:	89 04 24             	mov    %eax,(%esp)
c01043ad:	e8 57 f7 ff ff       	call   c0103b09 <page2kva>
}
c01043b2:	c9                   	leave  
c01043b3:	c3                   	ret    

c01043b4 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01043b4:	55                   	push   %ebp
c01043b5:	89 e5                	mov    %esp,%ebp
c01043b7:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c01043ba:	e8 94 f9 ff ff       	call   c0103d53 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c01043bf:	e8 76 fa ff ff       	call   c0103e3a <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01043c4:	e8 68 04 00 00       	call   c0104831 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c01043c9:	e8 a2 ff ff ff       	call   c0104370 <boot_alloc_page>
c01043ce:	a3 c4 88 11 c0       	mov    %eax,0xc01188c4
    memset(boot_pgdir, 0, PGSIZE);
c01043d3:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01043d8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01043df:	00 
c01043e0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01043e7:	00 
c01043e8:	89 04 24             	mov    %eax,(%esp)
c01043eb:	e8 fb 1a 00 00       	call   c0105eeb <memset>
    boot_cr3 = PADDR(boot_pgdir);
c01043f0:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01043f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01043f8:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01043ff:	77 23                	ja     c0104424 <pmm_init+0x70>
c0104401:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104404:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104408:	c7 44 24 08 38 6c 10 	movl   $0xc0106c38,0x8(%esp)
c010440f:	c0 
c0104410:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c0104417:	00 
c0104418:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c010441f:	e8 78 c8 ff ff       	call   c0100c9c <__panic>
c0104424:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104427:	05 00 00 00 40       	add    $0x40000000,%eax
c010442c:	a3 60 89 11 c0       	mov    %eax,0xc0118960

    check_pgdir();
c0104431:	e8 19 04 00 00       	call   c010484f <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0104436:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010443b:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0104441:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104446:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104449:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104450:	77 23                	ja     c0104475 <pmm_init+0xc1>
c0104452:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104455:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104459:	c7 44 24 08 38 6c 10 	movl   $0xc0106c38,0x8(%esp)
c0104460:	c0 
c0104461:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c0104468:	00 
c0104469:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c0104470:	e8 27 c8 ff ff       	call   c0100c9c <__panic>
c0104475:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104478:	05 00 00 00 40       	add    $0x40000000,%eax
c010447d:	83 c8 03             	or     $0x3,%eax
c0104480:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0104482:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104487:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c010448e:	00 
c010448f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104496:	00 
c0104497:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c010449e:	38 
c010449f:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c01044a6:	c0 
c01044a7:	89 04 24             	mov    %eax,(%esp)
c01044aa:	e8 b8 fd ff ff       	call   c0104267 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c01044af:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01044b4:	8b 15 c4 88 11 c0    	mov    0xc01188c4,%edx
c01044ba:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c01044c0:	89 10                	mov    %edx,(%eax)

    enable_paging();
c01044c2:	e8 62 fd ff ff       	call   c0104229 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01044c7:	e8 98 f7 ff ff       	call   c0103c64 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c01044cc:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01044d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01044d7:	e8 0e 0a 00 00       	call   c0104eea <check_boot_pgdir>

    print_pgdir();
c01044dc:	e8 87 0e 00 00       	call   c0105368 <print_pgdir>

}
c01044e1:	c9                   	leave  
c01044e2:	c3                   	ret    

c01044e3 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01044e3:	55                   	push   %ebp
c01044e4:	89 e5                	mov    %esp,%ebp
c01044e6:	83 ec 38             	sub    $0x38,%esp
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     *   PTE_W           0x002                   // page table/directory entry flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry flags bit : User can access
     */

	pde_t *pdep = &pgdir[PDX(la)];      // (1) find page directory entry
c01044e9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044ec:	c1 e8 16             	shr    $0x16,%eax
c01044ef:	c1 e0 02             	shl    $0x2,%eax
c01044f2:	03 45 08             	add    0x8(%ebp),%eax
c01044f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	if (!(*pdep & PTE_P)) {                        // (2) check if entry is not present
c01044f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044fb:	8b 00                	mov    (%eax),%eax
c01044fd:	83 e0 01             	and    $0x1,%eax
c0104500:	85 c0                	test   %eax,%eax
c0104502:	0f 85 af 00 00 00    	jne    c01045b7 <get_pte+0xd4>
            struct Page *page; 
            if (!create || (page = alloc_page()) == NULL) {// (3) check if creating is needed, then alloc page for page table
c0104508:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010450c:	74 15                	je     c0104523 <get_pte+0x40>
c010450e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104515:	e8 8b f8 ff ff       	call   c0103da5 <alloc_pages>
c010451a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010451d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104521:	75 0a                	jne    c010452d <get_pte+0x4a>
            return NULL;
c0104523:	b8 00 00 00 00       	mov    $0x0,%eax
c0104528:	e9 e6 00 00 00       	jmp    c0104613 <get_pte+0x130>
        }
        set_page_ref(page, 1);             // (4) set page reference
c010452d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104534:	00 
c0104535:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104538:	89 04 24             	mov    %eax,(%esp)
c010453b:	e8 65 f6 ff ff       	call   c0103ba5 <set_page_ref>
        uintptr_t pa = page2pa(page);     // (5) get linear address of page
c0104540:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104543:	89 04 24             	mov    %eax,(%esp)
c0104546:	e8 59 f5 ff ff       	call   c0103aa4 <page2pa>
c010454b:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE); // (6) clear page content using memset
c010454e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104551:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104554:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104557:	c1 e8 0c             	shr    $0xc,%eax
c010455a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010455d:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104562:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104565:	72 23                	jb     c010458a <get_pte+0xa7>
c0104567:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010456a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010456e:	c7 44 24 08 94 6b 10 	movl   $0xc0106b94,0x8(%esp)
c0104575:	c0 
c0104576:	c7 44 24 04 7c 01 00 	movl   $0x17c,0x4(%esp)
c010457d:	00 
c010457e:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c0104585:	e8 12 c7 ff ff       	call   c0100c9c <__panic>
c010458a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010458d:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104592:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104599:	00 
c010459a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01045a1:	00 
c01045a2:	89 04 24             	mov    %eax,(%esp)
c01045a5:	e8 41 19 00 00       	call   c0105eeb <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;   // (7) set page directory entry's permission
c01045aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01045ad:	89 c2                	mov    %eax,%edx
c01045af:	83 ca 07             	or     $0x7,%edx
c01045b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045b5:	89 10                	mov    %edx,(%eax)
   	 }
   	 return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];      // (8) return page table entry
c01045b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045ba:	8b 00                	mov    (%eax),%eax
c01045bc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01045c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01045c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01045c7:	c1 e8 0c             	shr    $0xc,%eax
c01045ca:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01045cd:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01045d2:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01045d5:	72 23                	jb     c01045fa <get_pte+0x117>
c01045d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01045da:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01045de:	c7 44 24 08 94 6b 10 	movl   $0xc0106b94,0x8(%esp)
c01045e5:	c0 
c01045e6:	c7 44 24 04 7f 01 00 	movl   $0x17f,0x4(%esp)
c01045ed:	00 
c01045ee:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c01045f5:	e8 a2 c6 ff ff       	call   c0100c9c <__panic>
c01045fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01045fd:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104602:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104605:	c1 ea 0c             	shr    $0xc,%edx
c0104608:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c010460e:	c1 e2 02             	shl    $0x2,%edx
c0104611:	01 d0                	add    %edx,%eax
}
c0104613:	c9                   	leave  
c0104614:	c3                   	ret    

c0104615 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0104615:	55                   	push   %ebp
c0104616:	89 e5                	mov    %esp,%ebp
c0104618:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010461b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104622:	00 
c0104623:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104626:	89 44 24 04          	mov    %eax,0x4(%esp)
c010462a:	8b 45 08             	mov    0x8(%ebp),%eax
c010462d:	89 04 24             	mov    %eax,(%esp)
c0104630:	e8 ae fe ff ff       	call   c01044e3 <get_pte>
c0104635:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0104638:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010463c:	74 08                	je     c0104646 <get_page+0x31>
        *ptep_store = ptep;
c010463e:	8b 45 10             	mov    0x10(%ebp),%eax
c0104641:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104644:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0104646:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010464a:	74 1b                	je     c0104667 <get_page+0x52>
c010464c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010464f:	8b 00                	mov    (%eax),%eax
c0104651:	83 e0 01             	and    $0x1,%eax
c0104654:	84 c0                	test   %al,%al
c0104656:	74 0f                	je     c0104667 <get_page+0x52>
        return pa2page(*ptep);
c0104658:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010465b:	8b 00                	mov    (%eax),%eax
c010465d:	89 04 24             	mov    %eax,(%esp)
c0104660:	e8 55 f4 ff ff       	call   c0103aba <pa2page>
c0104665:	eb 05                	jmp    c010466c <get_page+0x57>
    }
    return NULL;
c0104667:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010466c:	c9                   	leave  
c010466d:	c3                   	ret    

c010466e <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c010466e:	55                   	push   %ebp
c010466f:	89 e5                	mov    %esp,%ebp
c0104671:	83 ec 28             	sub    $0x28,%esp
     *                        edited are the ones currently in use by the processor.
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     */
	
	if (!(*ptep & PTE_P))  /* page not present */
c0104674:	8b 45 10             	mov    0x10(%ebp),%eax
c0104677:	8b 00                	mov    (%eax),%eax
c0104679:	83 e0 01             	and    $0x1,%eax
c010467c:	85 c0                	test   %eax,%eax
c010467e:	74 4f                	je     c01046cf <page_remove_pte+0x61>
		return;
	struct Page *p = pte2page(*ptep);
c0104680:	8b 45 10             	mov    0x10(%ebp),%eax
c0104683:	8b 00                	mov    (%eax),%eax
c0104685:	89 04 24             	mov    %eax,(%esp)
c0104688:	e8 d0 f4 ff ff       	call   c0103b5d <pte2page>
c010468d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (page_ref_dec (p) == 0)
c0104690:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104693:	89 04 24             	mov    %eax,(%esp)
c0104696:	e8 2e f5 ff ff       	call   c0103bc9 <page_ref_dec>
c010469b:	85 c0                	test   %eax,%eax
c010469d:	75 13                	jne    c01046b2 <page_remove_pte+0x44>
		free_page (p);
c010469f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01046a6:	00 
c01046a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046aa:	89 04 24             	mov    %eax,(%esp)
c01046ad:	e8 2b f7 ff ff       	call   c0103ddd <free_pages>
	*ptep = 0;
c01046b2:	8b 45 10             	mov    0x10(%ebp),%eax
c01046b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	tlb_invalidate(pgdir, la);          
c01046bb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046be:	89 44 24 04          	mov    %eax,0x4(%esp)
c01046c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01046c5:	89 04 24             	mov    %eax,(%esp)
c01046c8:	e8 02 01 00 00       	call   c01047cf <tlb_invalidate>
c01046cd:	eb 01                	jmp    c01046d0 <page_remove_pte+0x62>
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     */
	
	if (!(*ptep & PTE_P))  /* page not present */
		return;
c01046cf:	90                   	nop
	if (page_ref_dec (p) == 0)
		free_page (p);
	*ptep = 0;
	tlb_invalidate(pgdir, la);          
	
}
c01046d0:	c9                   	leave  
c01046d1:	c3                   	ret    

c01046d2 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01046d2:	55                   	push   %ebp
c01046d3:	89 e5                	mov    %esp,%ebp
c01046d5:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01046d8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01046df:	00 
c01046e0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046e3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01046e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01046ea:	89 04 24             	mov    %eax,(%esp)
c01046ed:	e8 f1 fd ff ff       	call   c01044e3 <get_pte>
c01046f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c01046f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01046f9:	74 19                	je     c0104714 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c01046fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046fe:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104702:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104705:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104709:	8b 45 08             	mov    0x8(%ebp),%eax
c010470c:	89 04 24             	mov    %eax,(%esp)
c010470f:	e8 5a ff ff ff       	call   c010466e <page_remove_pte>
    }
}  
c0104714:	c9                   	leave  
c0104715:	c3                   	ret    

c0104716 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0104716:	55                   	push   %ebp
c0104717:	89 e5                	mov    %esp,%ebp
c0104719:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c010471c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104723:	00 
c0104724:	8b 45 10             	mov    0x10(%ebp),%eax
c0104727:	89 44 24 04          	mov    %eax,0x4(%esp)
c010472b:	8b 45 08             	mov    0x8(%ebp),%eax
c010472e:	89 04 24             	mov    %eax,(%esp)
c0104731:	e8 ad fd ff ff       	call   c01044e3 <get_pte>
c0104736:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0104739:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010473d:	75 0a                	jne    c0104749 <page_insert+0x33>
        return -E_NO_MEM;
c010473f:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0104744:	e9 84 00 00 00       	jmp    c01047cd <page_insert+0xb7>
    }
    page_ref_inc(page);
c0104749:	8b 45 0c             	mov    0xc(%ebp),%eax
c010474c:	89 04 24             	mov    %eax,(%esp)
c010474f:	e8 5e f4 ff ff       	call   c0103bb2 <page_ref_inc>
    if (*ptep & PTE_P) {
c0104754:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104757:	8b 00                	mov    (%eax),%eax
c0104759:	83 e0 01             	and    $0x1,%eax
c010475c:	84 c0                	test   %al,%al
c010475e:	74 3e                	je     c010479e <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0104760:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104763:	8b 00                	mov    (%eax),%eax
c0104765:	89 04 24             	mov    %eax,(%esp)
c0104768:	e8 f0 f3 ff ff       	call   c0103b5d <pte2page>
c010476d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0104770:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104773:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104776:	75 0d                	jne    c0104785 <page_insert+0x6f>
            page_ref_dec(page);
c0104778:	8b 45 0c             	mov    0xc(%ebp),%eax
c010477b:	89 04 24             	mov    %eax,(%esp)
c010477e:	e8 46 f4 ff ff       	call   c0103bc9 <page_ref_dec>
c0104783:	eb 19                	jmp    c010479e <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0104785:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104788:	89 44 24 08          	mov    %eax,0x8(%esp)
c010478c:	8b 45 10             	mov    0x10(%ebp),%eax
c010478f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104793:	8b 45 08             	mov    0x8(%ebp),%eax
c0104796:	89 04 24             	mov    %eax,(%esp)
c0104799:	e8 d0 fe ff ff       	call   c010466e <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c010479e:	8b 45 0c             	mov    0xc(%ebp),%eax
c01047a1:	89 04 24             	mov    %eax,(%esp)
c01047a4:	e8 fb f2 ff ff       	call   c0103aa4 <page2pa>
c01047a9:	0b 45 14             	or     0x14(%ebp),%eax
c01047ac:	89 c2                	mov    %eax,%edx
c01047ae:	83 ca 01             	or     $0x1,%edx
c01047b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047b4:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01047b6:	8b 45 10             	mov    0x10(%ebp),%eax
c01047b9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01047bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01047c0:	89 04 24             	mov    %eax,(%esp)
c01047c3:	e8 07 00 00 00       	call   c01047cf <tlb_invalidate>
    return 0;
c01047c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01047cd:	c9                   	leave  
c01047ce:	c3                   	ret    

c01047cf <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01047cf:	55                   	push   %ebp
c01047d0:	89 e5                	mov    %esp,%ebp
c01047d2:	53                   	push   %ebx
c01047d3:	83 ec 24             	sub    $0x24,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01047d6:	0f 20 db             	mov    %cr3,%ebx
c01047d9:	89 5d f0             	mov    %ebx,-0x10(%ebp)
    return cr3;
c01047dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c01047df:	89 c2                	mov    %eax,%edx
c01047e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01047e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01047e7:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01047ee:	77 23                	ja     c0104813 <tlb_invalidate+0x44>
c01047f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01047f7:	c7 44 24 08 38 6c 10 	movl   $0xc0106c38,0x8(%esp)
c01047fe:	c0 
c01047ff:	c7 44 24 04 d9 01 00 	movl   $0x1d9,0x4(%esp)
c0104806:	00 
c0104807:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c010480e:	e8 89 c4 ff ff       	call   c0100c9c <__panic>
c0104813:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104816:	05 00 00 00 40       	add    $0x40000000,%eax
c010481b:	39 c2                	cmp    %eax,%edx
c010481d:	75 0c                	jne    c010482b <tlb_invalidate+0x5c>
        invlpg((void *)la);
c010481f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104822:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0104825:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104828:	0f 01 38             	invlpg (%eax)
    }
}
c010482b:	83 c4 24             	add    $0x24,%esp
c010482e:	5b                   	pop    %ebx
c010482f:	5d                   	pop    %ebp
c0104830:	c3                   	ret    

c0104831 <check_alloc_page>:

static void
check_alloc_page(void) {
c0104831:	55                   	push   %ebp
c0104832:	89 e5                	mov    %esp,%ebp
c0104834:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0104837:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c010483c:	8b 40 18             	mov    0x18(%eax),%eax
c010483f:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0104841:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c0104848:	e8 fa ba ff ff       	call   c0100347 <cprintf>
}
c010484d:	c9                   	leave  
c010484e:	c3                   	ret    

c010484f <check_pgdir>:

static void
check_pgdir(void) {
c010484f:	55                   	push   %ebp
c0104850:	89 e5                	mov    %esp,%ebp
c0104852:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0104855:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c010485a:	3d 00 80 03 00       	cmp    $0x38000,%eax
c010485f:	76 24                	jbe    c0104885 <check_pgdir+0x36>
c0104861:	c7 44 24 0c db 6c 10 	movl   $0xc0106cdb,0xc(%esp)
c0104868:	c0 
c0104869:	c7 44 24 08 81 6c 10 	movl   $0xc0106c81,0x8(%esp)
c0104870:	c0 
c0104871:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
c0104878:	00 
c0104879:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c0104880:	e8 17 c4 ff ff       	call   c0100c9c <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0104885:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010488a:	85 c0                	test   %eax,%eax
c010488c:	74 0e                	je     c010489c <check_pgdir+0x4d>
c010488e:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104893:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104898:	85 c0                	test   %eax,%eax
c010489a:	74 24                	je     c01048c0 <check_pgdir+0x71>
c010489c:	c7 44 24 0c f8 6c 10 	movl   $0xc0106cf8,0xc(%esp)
c01048a3:	c0 
c01048a4:	c7 44 24 08 81 6c 10 	movl   $0xc0106c81,0x8(%esp)
c01048ab:	c0 
c01048ac:	c7 44 24 04 e7 01 00 	movl   $0x1e7,0x4(%esp)
c01048b3:	00 
c01048b4:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c01048bb:	e8 dc c3 ff ff       	call   c0100c9c <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01048c0:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01048c5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01048cc:	00 
c01048cd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01048d4:	00 
c01048d5:	89 04 24             	mov    %eax,(%esp)
c01048d8:	e8 38 fd ff ff       	call   c0104615 <get_page>
c01048dd:	85 c0                	test   %eax,%eax
c01048df:	74 24                	je     c0104905 <check_pgdir+0xb6>
c01048e1:	c7 44 24 0c 30 6d 10 	movl   $0xc0106d30,0xc(%esp)
c01048e8:	c0 
c01048e9:	c7 44 24 08 81 6c 10 	movl   $0xc0106c81,0x8(%esp)
c01048f0:	c0 
c01048f1:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
c01048f8:	00 
c01048f9:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c0104900:	e8 97 c3 ff ff       	call   c0100c9c <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0104905:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010490c:	e8 94 f4 ff ff       	call   c0103da5 <alloc_pages>
c0104911:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0104914:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104919:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104920:	00 
c0104921:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104928:	00 
c0104929:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010492c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104930:	89 04 24             	mov    %eax,(%esp)
c0104933:	e8 de fd ff ff       	call   c0104716 <page_insert>
c0104938:	85 c0                	test   %eax,%eax
c010493a:	74 24                	je     c0104960 <check_pgdir+0x111>
c010493c:	c7 44 24 0c 58 6d 10 	movl   $0xc0106d58,0xc(%esp)
c0104943:	c0 
c0104944:	c7 44 24 08 81 6c 10 	movl   $0xc0106c81,0x8(%esp)
c010494b:	c0 
c010494c:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
c0104953:	00 
c0104954:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c010495b:	e8 3c c3 ff ff       	call   c0100c9c <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0104960:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104965:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010496c:	00 
c010496d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104974:	00 
c0104975:	89 04 24             	mov    %eax,(%esp)
c0104978:	e8 66 fb ff ff       	call   c01044e3 <get_pte>
c010497d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104980:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104984:	75 24                	jne    c01049aa <check_pgdir+0x15b>
c0104986:	c7 44 24 0c 84 6d 10 	movl   $0xc0106d84,0xc(%esp)
c010498d:	c0 
c010498e:	c7 44 24 08 81 6c 10 	movl   $0xc0106c81,0x8(%esp)
c0104995:	c0 
c0104996:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
c010499d:	00 
c010499e:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c01049a5:	e8 f2 c2 ff ff       	call   c0100c9c <__panic>
    assert(pa2page(*ptep) == p1);
c01049aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049ad:	8b 00                	mov    (%eax),%eax
c01049af:	89 04 24             	mov    %eax,(%esp)
c01049b2:	e8 03 f1 ff ff       	call   c0103aba <pa2page>
c01049b7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01049ba:	74 24                	je     c01049e0 <check_pgdir+0x191>
c01049bc:	c7 44 24 0c b1 6d 10 	movl   $0xc0106db1,0xc(%esp)
c01049c3:	c0 
c01049c4:	c7 44 24 08 81 6c 10 	movl   $0xc0106c81,0x8(%esp)
c01049cb:	c0 
c01049cc:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
c01049d3:	00 
c01049d4:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c01049db:	e8 bc c2 ff ff       	call   c0100c9c <__panic>
    assert(page_ref(p1) == 1);
c01049e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049e3:	89 04 24             	mov    %eax,(%esp)
c01049e6:	e8 b0 f1 ff ff       	call   c0103b9b <page_ref>
c01049eb:	83 f8 01             	cmp    $0x1,%eax
c01049ee:	74 24                	je     c0104a14 <check_pgdir+0x1c5>
c01049f0:	c7 44 24 0c c6 6d 10 	movl   $0xc0106dc6,0xc(%esp)
c01049f7:	c0 
c01049f8:	c7 44 24 08 81 6c 10 	movl   $0xc0106c81,0x8(%esp)
c01049ff:	c0 
c0104a00:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
c0104a07:	00 
c0104a08:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c0104a0f:	e8 88 c2 ff ff       	call   c0100c9c <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0104a14:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104a19:	8b 00                	mov    (%eax),%eax
c0104a1b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104a20:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104a23:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a26:	c1 e8 0c             	shr    $0xc,%eax
c0104a29:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104a2c:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104a31:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104a34:	72 23                	jb     c0104a59 <check_pgdir+0x20a>
c0104a36:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a39:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104a3d:	c7 44 24 08 94 6b 10 	movl   $0xc0106b94,0x8(%esp)
c0104a44:	c0 
c0104a45:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
c0104a4c:	00 
c0104a4d:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c0104a54:	e8 43 c2 ff ff       	call   c0100c9c <__panic>
c0104a59:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a5c:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104a61:	83 c0 04             	add    $0x4,%eax
c0104a64:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0104a67:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104a6c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a73:	00 
c0104a74:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104a7b:	00 
c0104a7c:	89 04 24             	mov    %eax,(%esp)
c0104a7f:	e8 5f fa ff ff       	call   c01044e3 <get_pte>
c0104a84:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104a87:	74 24                	je     c0104aad <check_pgdir+0x25e>
c0104a89:	c7 44 24 0c d8 6d 10 	movl   $0xc0106dd8,0xc(%esp)
c0104a90:	c0 
c0104a91:	c7 44 24 08 81 6c 10 	movl   $0xc0106c81,0x8(%esp)
c0104a98:	c0 
c0104a99:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
c0104aa0:	00 
c0104aa1:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c0104aa8:	e8 ef c1 ff ff       	call   c0100c9c <__panic>

    p2 = alloc_page();
c0104aad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104ab4:	e8 ec f2 ff ff       	call   c0103da5 <alloc_pages>
c0104ab9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0104abc:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104ac1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0104ac8:	00 
c0104ac9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104ad0:	00 
c0104ad1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104ad4:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104ad8:	89 04 24             	mov    %eax,(%esp)
c0104adb:	e8 36 fc ff ff       	call   c0104716 <page_insert>
c0104ae0:	85 c0                	test   %eax,%eax
c0104ae2:	74 24                	je     c0104b08 <check_pgdir+0x2b9>
c0104ae4:	c7 44 24 0c 00 6e 10 	movl   $0xc0106e00,0xc(%esp)
c0104aeb:	c0 
c0104aec:	c7 44 24 08 81 6c 10 	movl   $0xc0106c81,0x8(%esp)
c0104af3:	c0 
c0104af4:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c0104afb:	00 
c0104afc:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c0104b03:	e8 94 c1 ff ff       	call   c0100c9c <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104b08:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104b0d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104b14:	00 
c0104b15:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104b1c:	00 
c0104b1d:	89 04 24             	mov    %eax,(%esp)
c0104b20:	e8 be f9 ff ff       	call   c01044e3 <get_pte>
c0104b25:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104b28:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104b2c:	75 24                	jne    c0104b52 <check_pgdir+0x303>
c0104b2e:	c7 44 24 0c 38 6e 10 	movl   $0xc0106e38,0xc(%esp)
c0104b35:	c0 
c0104b36:	c7 44 24 08 81 6c 10 	movl   $0xc0106c81,0x8(%esp)
c0104b3d:	c0 
c0104b3e:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
c0104b45:	00 
c0104b46:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c0104b4d:	e8 4a c1 ff ff       	call   c0100c9c <__panic>
    assert(*ptep & PTE_U);
c0104b52:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b55:	8b 00                	mov    (%eax),%eax
c0104b57:	83 e0 04             	and    $0x4,%eax
c0104b5a:	85 c0                	test   %eax,%eax
c0104b5c:	75 24                	jne    c0104b82 <check_pgdir+0x333>
c0104b5e:	c7 44 24 0c 68 6e 10 	movl   $0xc0106e68,0xc(%esp)
c0104b65:	c0 
c0104b66:	c7 44 24 08 81 6c 10 	movl   $0xc0106c81,0x8(%esp)
c0104b6d:	c0 
c0104b6e:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
c0104b75:	00 
c0104b76:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c0104b7d:	e8 1a c1 ff ff       	call   c0100c9c <__panic>
    assert(*ptep & PTE_W);
c0104b82:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b85:	8b 00                	mov    (%eax),%eax
c0104b87:	83 e0 02             	and    $0x2,%eax
c0104b8a:	85 c0                	test   %eax,%eax
c0104b8c:	75 24                	jne    c0104bb2 <check_pgdir+0x363>
c0104b8e:	c7 44 24 0c 76 6e 10 	movl   $0xc0106e76,0xc(%esp)
c0104b95:	c0 
c0104b96:	c7 44 24 08 81 6c 10 	movl   $0xc0106c81,0x8(%esp)
c0104b9d:	c0 
c0104b9e:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
c0104ba5:	00 
c0104ba6:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c0104bad:	e8 ea c0 ff ff       	call   c0100c9c <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104bb2:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104bb7:	8b 00                	mov    (%eax),%eax
c0104bb9:	83 e0 04             	and    $0x4,%eax
c0104bbc:	85 c0                	test   %eax,%eax
c0104bbe:	75 24                	jne    c0104be4 <check_pgdir+0x395>
c0104bc0:	c7 44 24 0c 84 6e 10 	movl   $0xc0106e84,0xc(%esp)
c0104bc7:	c0 
c0104bc8:	c7 44 24 08 81 6c 10 	movl   $0xc0106c81,0x8(%esp)
c0104bcf:	c0 
c0104bd0:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
c0104bd7:	00 
c0104bd8:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c0104bdf:	e8 b8 c0 ff ff       	call   c0100c9c <__panic>
    assert(page_ref(p2) == 1);
c0104be4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104be7:	89 04 24             	mov    %eax,(%esp)
c0104bea:	e8 ac ef ff ff       	call   c0103b9b <page_ref>
c0104bef:	83 f8 01             	cmp    $0x1,%eax
c0104bf2:	74 24                	je     c0104c18 <check_pgdir+0x3c9>
c0104bf4:	c7 44 24 0c 9a 6e 10 	movl   $0xc0106e9a,0xc(%esp)
c0104bfb:	c0 
c0104bfc:	c7 44 24 08 81 6c 10 	movl   $0xc0106c81,0x8(%esp)
c0104c03:	c0 
c0104c04:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
c0104c0b:	00 
c0104c0c:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c0104c13:	e8 84 c0 ff ff       	call   c0100c9c <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104c18:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104c1d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104c24:	00 
c0104c25:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104c2c:	00 
c0104c2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104c30:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104c34:	89 04 24             	mov    %eax,(%esp)
c0104c37:	e8 da fa ff ff       	call   c0104716 <page_insert>
c0104c3c:	85 c0                	test   %eax,%eax
c0104c3e:	74 24                	je     c0104c64 <check_pgdir+0x415>
c0104c40:	c7 44 24 0c ac 6e 10 	movl   $0xc0106eac,0xc(%esp)
c0104c47:	c0 
c0104c48:	c7 44 24 08 81 6c 10 	movl   $0xc0106c81,0x8(%esp)
c0104c4f:	c0 
c0104c50:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
c0104c57:	00 
c0104c58:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c0104c5f:	e8 38 c0 ff ff       	call   c0100c9c <__panic>
    assert(page_ref(p1) == 2);
c0104c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c67:	89 04 24             	mov    %eax,(%esp)
c0104c6a:	e8 2c ef ff ff       	call   c0103b9b <page_ref>
c0104c6f:	83 f8 02             	cmp    $0x2,%eax
c0104c72:	74 24                	je     c0104c98 <check_pgdir+0x449>
c0104c74:	c7 44 24 0c d8 6e 10 	movl   $0xc0106ed8,0xc(%esp)
c0104c7b:	c0 
c0104c7c:	c7 44 24 08 81 6c 10 	movl   $0xc0106c81,0x8(%esp)
c0104c83:	c0 
c0104c84:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c0104c8b:	00 
c0104c8c:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c0104c93:	e8 04 c0 ff ff       	call   c0100c9c <__panic>
    assert(page_ref(p2) == 0);
c0104c98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c9b:	89 04 24             	mov    %eax,(%esp)
c0104c9e:	e8 f8 ee ff ff       	call   c0103b9b <page_ref>
c0104ca3:	85 c0                	test   %eax,%eax
c0104ca5:	74 24                	je     c0104ccb <check_pgdir+0x47c>
c0104ca7:	c7 44 24 0c ea 6e 10 	movl   $0xc0106eea,0xc(%esp)
c0104cae:	c0 
c0104caf:	c7 44 24 08 81 6c 10 	movl   $0xc0106c81,0x8(%esp)
c0104cb6:	c0 
c0104cb7:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c0104cbe:	00 
c0104cbf:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c0104cc6:	e8 d1 bf ff ff       	call   c0100c9c <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104ccb:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104cd0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104cd7:	00 
c0104cd8:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104cdf:	00 
c0104ce0:	89 04 24             	mov    %eax,(%esp)
c0104ce3:	e8 fb f7 ff ff       	call   c01044e3 <get_pte>
c0104ce8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ceb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104cef:	75 24                	jne    c0104d15 <check_pgdir+0x4c6>
c0104cf1:	c7 44 24 0c 38 6e 10 	movl   $0xc0106e38,0xc(%esp)
c0104cf8:	c0 
c0104cf9:	c7 44 24 08 81 6c 10 	movl   $0xc0106c81,0x8(%esp)
c0104d00:	c0 
c0104d01:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
c0104d08:	00 
c0104d09:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c0104d10:	e8 87 bf ff ff       	call   c0100c9c <__panic>
    assert(pa2page(*ptep) == p1);
c0104d15:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d18:	8b 00                	mov    (%eax),%eax
c0104d1a:	89 04 24             	mov    %eax,(%esp)
c0104d1d:	e8 98 ed ff ff       	call   c0103aba <pa2page>
c0104d22:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104d25:	74 24                	je     c0104d4b <check_pgdir+0x4fc>
c0104d27:	c7 44 24 0c b1 6d 10 	movl   $0xc0106db1,0xc(%esp)
c0104d2e:	c0 
c0104d2f:	c7 44 24 08 81 6c 10 	movl   $0xc0106c81,0x8(%esp)
c0104d36:	c0 
c0104d37:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
c0104d3e:	00 
c0104d3f:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c0104d46:	e8 51 bf ff ff       	call   c0100c9c <__panic>
    assert((*ptep & PTE_U) == 0);
c0104d4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d4e:	8b 00                	mov    (%eax),%eax
c0104d50:	83 e0 04             	and    $0x4,%eax
c0104d53:	85 c0                	test   %eax,%eax
c0104d55:	74 24                	je     c0104d7b <check_pgdir+0x52c>
c0104d57:	c7 44 24 0c fc 6e 10 	movl   $0xc0106efc,0xc(%esp)
c0104d5e:	c0 
c0104d5f:	c7 44 24 08 81 6c 10 	movl   $0xc0106c81,0x8(%esp)
c0104d66:	c0 
c0104d67:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0104d6e:	00 
c0104d6f:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c0104d76:	e8 21 bf ff ff       	call   c0100c9c <__panic>

    page_remove(boot_pgdir, 0x0);
c0104d7b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104d80:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104d87:	00 
c0104d88:	89 04 24             	mov    %eax,(%esp)
c0104d8b:	e8 42 f9 ff ff       	call   c01046d2 <page_remove>
    assert(page_ref(p1) == 1);
c0104d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d93:	89 04 24             	mov    %eax,(%esp)
c0104d96:	e8 00 ee ff ff       	call   c0103b9b <page_ref>
c0104d9b:	83 f8 01             	cmp    $0x1,%eax
c0104d9e:	74 24                	je     c0104dc4 <check_pgdir+0x575>
c0104da0:	c7 44 24 0c c6 6d 10 	movl   $0xc0106dc6,0xc(%esp)
c0104da7:	c0 
c0104da8:	c7 44 24 08 81 6c 10 	movl   $0xc0106c81,0x8(%esp)
c0104daf:	c0 
c0104db0:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
c0104db7:	00 
c0104db8:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c0104dbf:	e8 d8 be ff ff       	call   c0100c9c <__panic>
    assert(page_ref(p2) == 0);
c0104dc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104dc7:	89 04 24             	mov    %eax,(%esp)
c0104dca:	e8 cc ed ff ff       	call   c0103b9b <page_ref>
c0104dcf:	85 c0                	test   %eax,%eax
c0104dd1:	74 24                	je     c0104df7 <check_pgdir+0x5a8>
c0104dd3:	c7 44 24 0c ea 6e 10 	movl   $0xc0106eea,0xc(%esp)
c0104dda:	c0 
c0104ddb:	c7 44 24 08 81 6c 10 	movl   $0xc0106c81,0x8(%esp)
c0104de2:	c0 
c0104de3:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0104dea:	00 
c0104deb:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c0104df2:	e8 a5 be ff ff       	call   c0100c9c <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104df7:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104dfc:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104e03:	00 
c0104e04:	89 04 24             	mov    %eax,(%esp)
c0104e07:	e8 c6 f8 ff ff       	call   c01046d2 <page_remove>
    assert(page_ref(p1) == 0);
c0104e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e0f:	89 04 24             	mov    %eax,(%esp)
c0104e12:	e8 84 ed ff ff       	call   c0103b9b <page_ref>
c0104e17:	85 c0                	test   %eax,%eax
c0104e19:	74 24                	je     c0104e3f <check_pgdir+0x5f0>
c0104e1b:	c7 44 24 0c 11 6f 10 	movl   $0xc0106f11,0xc(%esp)
c0104e22:	c0 
c0104e23:	c7 44 24 08 81 6c 10 	movl   $0xc0106c81,0x8(%esp)
c0104e2a:	c0 
c0104e2b:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c0104e32:	00 
c0104e33:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c0104e3a:	e8 5d be ff ff       	call   c0100c9c <__panic>
    assert(page_ref(p2) == 0);
c0104e3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e42:	89 04 24             	mov    %eax,(%esp)
c0104e45:	e8 51 ed ff ff       	call   c0103b9b <page_ref>
c0104e4a:	85 c0                	test   %eax,%eax
c0104e4c:	74 24                	je     c0104e72 <check_pgdir+0x623>
c0104e4e:	c7 44 24 0c ea 6e 10 	movl   $0xc0106eea,0xc(%esp)
c0104e55:	c0 
c0104e56:	c7 44 24 08 81 6c 10 	movl   $0xc0106c81,0x8(%esp)
c0104e5d:	c0 
c0104e5e:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c0104e65:	00 
c0104e66:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c0104e6d:	e8 2a be ff ff       	call   c0100c9c <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c0104e72:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104e77:	8b 00                	mov    (%eax),%eax
c0104e79:	89 04 24             	mov    %eax,(%esp)
c0104e7c:	e8 39 ec ff ff       	call   c0103aba <pa2page>
c0104e81:	89 04 24             	mov    %eax,(%esp)
c0104e84:	e8 12 ed ff ff       	call   c0103b9b <page_ref>
c0104e89:	83 f8 01             	cmp    $0x1,%eax
c0104e8c:	74 24                	je     c0104eb2 <check_pgdir+0x663>
c0104e8e:	c7 44 24 0c 24 6f 10 	movl   $0xc0106f24,0xc(%esp)
c0104e95:	c0 
c0104e96:	c7 44 24 08 81 6c 10 	movl   $0xc0106c81,0x8(%esp)
c0104e9d:	c0 
c0104e9e:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0104ea5:	00 
c0104ea6:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c0104ead:	e8 ea bd ff ff       	call   c0100c9c <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0104eb2:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104eb7:	8b 00                	mov    (%eax),%eax
c0104eb9:	89 04 24             	mov    %eax,(%esp)
c0104ebc:	e8 f9 eb ff ff       	call   c0103aba <pa2page>
c0104ec1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104ec8:	00 
c0104ec9:	89 04 24             	mov    %eax,(%esp)
c0104ecc:	e8 0c ef ff ff       	call   c0103ddd <free_pages>
    boot_pgdir[0] = 0;
c0104ed1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104ed6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104edc:	c7 04 24 4a 6f 10 c0 	movl   $0xc0106f4a,(%esp)
c0104ee3:	e8 5f b4 ff ff       	call   c0100347 <cprintf>
}
c0104ee8:	c9                   	leave  
c0104ee9:	c3                   	ret    

c0104eea <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104eea:	55                   	push   %ebp
c0104eeb:	89 e5                	mov    %esp,%ebp
c0104eed:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104ef0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104ef7:	e9 cb 00 00 00       	jmp    c0104fc7 <check_boot_pgdir+0xdd>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104eff:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104f02:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f05:	c1 e8 0c             	shr    $0xc,%eax
c0104f08:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104f0b:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104f10:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104f13:	72 23                	jb     c0104f38 <check_boot_pgdir+0x4e>
c0104f15:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f18:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104f1c:	c7 44 24 08 94 6b 10 	movl   $0xc0106b94,0x8(%esp)
c0104f23:	c0 
c0104f24:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c0104f2b:	00 
c0104f2c:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c0104f33:	e8 64 bd ff ff       	call   c0100c9c <__panic>
c0104f38:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f3b:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104f40:	89 c2                	mov    %eax,%edx
c0104f42:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104f47:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104f4e:	00 
c0104f4f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104f53:	89 04 24             	mov    %eax,(%esp)
c0104f56:	e8 88 f5 ff ff       	call   c01044e3 <get_pte>
c0104f5b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104f5e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104f62:	75 24                	jne    c0104f88 <check_boot_pgdir+0x9e>
c0104f64:	c7 44 24 0c 64 6f 10 	movl   $0xc0106f64,0xc(%esp)
c0104f6b:	c0 
c0104f6c:	c7 44 24 08 81 6c 10 	movl   $0xc0106c81,0x8(%esp)
c0104f73:	c0 
c0104f74:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c0104f7b:	00 
c0104f7c:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c0104f83:	e8 14 bd ff ff       	call   c0100c9c <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104f88:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104f8b:	8b 00                	mov    (%eax),%eax
c0104f8d:	89 c2                	mov    %eax,%edx
c0104f8f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
c0104f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f98:	39 c2                	cmp    %eax,%edx
c0104f9a:	74 24                	je     c0104fc0 <check_boot_pgdir+0xd6>
c0104f9c:	c7 44 24 0c a1 6f 10 	movl   $0xc0106fa1,0xc(%esp)
c0104fa3:	c0 
c0104fa4:	c7 44 24 08 81 6c 10 	movl   $0xc0106c81,0x8(%esp)
c0104fab:	c0 
c0104fac:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
c0104fb3:	00 
c0104fb4:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c0104fbb:	e8 dc bc ff ff       	call   c0100c9c <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104fc0:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104fc7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104fca:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104fcf:	39 c2                	cmp    %eax,%edx
c0104fd1:	0f 82 25 ff ff ff    	jb     c0104efc <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104fd7:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104fdc:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104fe1:	8b 00                	mov    (%eax),%eax
c0104fe3:	89 c2                	mov    %eax,%edx
c0104fe5:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
c0104feb:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104ff0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104ff3:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0104ffa:	77 23                	ja     c010501f <check_boot_pgdir+0x135>
c0104ffc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104fff:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105003:	c7 44 24 08 38 6c 10 	movl   $0xc0106c38,0x8(%esp)
c010500a:	c0 
c010500b:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c0105012:	00 
c0105013:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c010501a:	e8 7d bc ff ff       	call   c0100c9c <__panic>
c010501f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105022:	05 00 00 00 40       	add    $0x40000000,%eax
c0105027:	39 c2                	cmp    %eax,%edx
c0105029:	74 24                	je     c010504f <check_boot_pgdir+0x165>
c010502b:	c7 44 24 0c b8 6f 10 	movl   $0xc0106fb8,0xc(%esp)
c0105032:	c0 
c0105033:	c7 44 24 08 81 6c 10 	movl   $0xc0106c81,0x8(%esp)
c010503a:	c0 
c010503b:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c0105042:	00 
c0105043:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c010504a:	e8 4d bc ff ff       	call   c0100c9c <__panic>

    assert(boot_pgdir[0] == 0);
c010504f:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105054:	8b 00                	mov    (%eax),%eax
c0105056:	85 c0                	test   %eax,%eax
c0105058:	74 24                	je     c010507e <check_boot_pgdir+0x194>
c010505a:	c7 44 24 0c ec 6f 10 	movl   $0xc0106fec,0xc(%esp)
c0105061:	c0 
c0105062:	c7 44 24 08 81 6c 10 	movl   $0xc0106c81,0x8(%esp)
c0105069:	c0 
c010506a:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
c0105071:	00 
c0105072:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c0105079:	e8 1e bc ff ff       	call   c0100c9c <__panic>

    struct Page *p;
    p = alloc_page();
c010507e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105085:	e8 1b ed ff ff       	call   c0103da5 <alloc_pages>
c010508a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c010508d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105092:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105099:	00 
c010509a:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c01050a1:	00 
c01050a2:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01050a5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01050a9:	89 04 24             	mov    %eax,(%esp)
c01050ac:	e8 65 f6 ff ff       	call   c0104716 <page_insert>
c01050b1:	85 c0                	test   %eax,%eax
c01050b3:	74 24                	je     c01050d9 <check_boot_pgdir+0x1ef>
c01050b5:	c7 44 24 0c 00 70 10 	movl   $0xc0107000,0xc(%esp)
c01050bc:	c0 
c01050bd:	c7 44 24 08 81 6c 10 	movl   $0xc0106c81,0x8(%esp)
c01050c4:	c0 
c01050c5:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c01050cc:	00 
c01050cd:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c01050d4:	e8 c3 bb ff ff       	call   c0100c9c <__panic>
    assert(page_ref(p) == 1);
c01050d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01050dc:	89 04 24             	mov    %eax,(%esp)
c01050df:	e8 b7 ea ff ff       	call   c0103b9b <page_ref>
c01050e4:	83 f8 01             	cmp    $0x1,%eax
c01050e7:	74 24                	je     c010510d <check_boot_pgdir+0x223>
c01050e9:	c7 44 24 0c 2e 70 10 	movl   $0xc010702e,0xc(%esp)
c01050f0:	c0 
c01050f1:	c7 44 24 08 81 6c 10 	movl   $0xc0106c81,0x8(%esp)
c01050f8:	c0 
c01050f9:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c0105100:	00 
c0105101:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c0105108:	e8 8f bb ff ff       	call   c0100c9c <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c010510d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105112:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105119:	00 
c010511a:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0105121:	00 
c0105122:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105125:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105129:	89 04 24             	mov    %eax,(%esp)
c010512c:	e8 e5 f5 ff ff       	call   c0104716 <page_insert>
c0105131:	85 c0                	test   %eax,%eax
c0105133:	74 24                	je     c0105159 <check_boot_pgdir+0x26f>
c0105135:	c7 44 24 0c 40 70 10 	movl   $0xc0107040,0xc(%esp)
c010513c:	c0 
c010513d:	c7 44 24 08 81 6c 10 	movl   $0xc0106c81,0x8(%esp)
c0105144:	c0 
c0105145:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
c010514c:	00 
c010514d:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c0105154:	e8 43 bb ff ff       	call   c0100c9c <__panic>
    assert(page_ref(p) == 2);
c0105159:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010515c:	89 04 24             	mov    %eax,(%esp)
c010515f:	e8 37 ea ff ff       	call   c0103b9b <page_ref>
c0105164:	83 f8 02             	cmp    $0x2,%eax
c0105167:	74 24                	je     c010518d <check_boot_pgdir+0x2a3>
c0105169:	c7 44 24 0c 77 70 10 	movl   $0xc0107077,0xc(%esp)
c0105170:	c0 
c0105171:	c7 44 24 08 81 6c 10 	movl   $0xc0106c81,0x8(%esp)
c0105178:	c0 
c0105179:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
c0105180:	00 
c0105181:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c0105188:	e8 0f bb ff ff       	call   c0100c9c <__panic>

    const char *str = "ucore: Hello world!!";
c010518d:	c7 45 dc 88 70 10 c0 	movl   $0xc0107088,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0105194:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105197:	89 44 24 04          	mov    %eax,0x4(%esp)
c010519b:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01051a2:	e8 67 0a 00 00       	call   c0105c0e <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c01051a7:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c01051ae:	00 
c01051af:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01051b6:	e8 d0 0a 00 00       	call   c0105c8b <strcmp>
c01051bb:	85 c0                	test   %eax,%eax
c01051bd:	74 24                	je     c01051e3 <check_boot_pgdir+0x2f9>
c01051bf:	c7 44 24 0c a0 70 10 	movl   $0xc01070a0,0xc(%esp)
c01051c6:	c0 
c01051c7:	c7 44 24 08 81 6c 10 	movl   $0xc0106c81,0x8(%esp)
c01051ce:	c0 
c01051cf:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
c01051d6:	00 
c01051d7:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c01051de:	e8 b9 ba ff ff       	call   c0100c9c <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c01051e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01051e6:	89 04 24             	mov    %eax,(%esp)
c01051e9:	e8 1b e9 ff ff       	call   c0103b09 <page2kva>
c01051ee:	05 00 01 00 00       	add    $0x100,%eax
c01051f3:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c01051f6:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01051fd:	e8 ae 09 00 00       	call   c0105bb0 <strlen>
c0105202:	85 c0                	test   %eax,%eax
c0105204:	74 24                	je     c010522a <check_boot_pgdir+0x340>
c0105206:	c7 44 24 0c d8 70 10 	movl   $0xc01070d8,0xc(%esp)
c010520d:	c0 
c010520e:	c7 44 24 08 81 6c 10 	movl   $0xc0106c81,0x8(%esp)
c0105215:	c0 
c0105216:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c010521d:	00 
c010521e:	c7 04 24 5c 6c 10 c0 	movl   $0xc0106c5c,(%esp)
c0105225:	e8 72 ba ff ff       	call   c0100c9c <__panic>

    free_page(p);
c010522a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105231:	00 
c0105232:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105235:	89 04 24             	mov    %eax,(%esp)
c0105238:	e8 a0 eb ff ff       	call   c0103ddd <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c010523d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105242:	8b 00                	mov    (%eax),%eax
c0105244:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105249:	89 04 24             	mov    %eax,(%esp)
c010524c:	e8 69 e8 ff ff       	call   c0103aba <pa2page>
c0105251:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105258:	00 
c0105259:	89 04 24             	mov    %eax,(%esp)
c010525c:	e8 7c eb ff ff       	call   c0103ddd <free_pages>
    boot_pgdir[0] = 0;
c0105261:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105266:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c010526c:	c7 04 24 fc 70 10 c0 	movl   $0xc01070fc,(%esp)
c0105273:	e8 cf b0 ff ff       	call   c0100347 <cprintf>
}
c0105278:	c9                   	leave  
c0105279:	c3                   	ret    

c010527a <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c010527a:	55                   	push   %ebp
c010527b:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c010527d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105280:	83 e0 04             	and    $0x4,%eax
c0105283:	85 c0                	test   %eax,%eax
c0105285:	74 07                	je     c010528e <perm2str+0x14>
c0105287:	b8 75 00 00 00       	mov    $0x75,%eax
c010528c:	eb 05                	jmp    c0105293 <perm2str+0x19>
c010528e:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105293:	a2 48 89 11 c0       	mov    %al,0xc0118948
    str[1] = 'r';
c0105298:	c6 05 49 89 11 c0 72 	movb   $0x72,0xc0118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c010529f:	8b 45 08             	mov    0x8(%ebp),%eax
c01052a2:	83 e0 02             	and    $0x2,%eax
c01052a5:	85 c0                	test   %eax,%eax
c01052a7:	74 07                	je     c01052b0 <perm2str+0x36>
c01052a9:	b8 77 00 00 00       	mov    $0x77,%eax
c01052ae:	eb 05                	jmp    c01052b5 <perm2str+0x3b>
c01052b0:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01052b5:	a2 4a 89 11 c0       	mov    %al,0xc011894a
    str[3] = '\0';
c01052ba:	c6 05 4b 89 11 c0 00 	movb   $0x0,0xc011894b
    return str;
c01052c1:	b8 48 89 11 c0       	mov    $0xc0118948,%eax
}
c01052c6:	5d                   	pop    %ebp
c01052c7:	c3                   	ret    

c01052c8 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c01052c8:	55                   	push   %ebp
c01052c9:	89 e5                	mov    %esp,%ebp
c01052cb:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c01052ce:	8b 45 10             	mov    0x10(%ebp),%eax
c01052d1:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01052d4:	72 0e                	jb     c01052e4 <get_pgtable_items+0x1c>
        return 0;
c01052d6:	b8 00 00 00 00       	mov    $0x0,%eax
c01052db:	e9 86 00 00 00       	jmp    c0105366 <get_pgtable_items+0x9e>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c01052e0:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c01052e4:	8b 45 10             	mov    0x10(%ebp),%eax
c01052e7:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01052ea:	73 12                	jae    c01052fe <get_pgtable_items+0x36>
c01052ec:	8b 45 10             	mov    0x10(%ebp),%eax
c01052ef:	c1 e0 02             	shl    $0x2,%eax
c01052f2:	03 45 14             	add    0x14(%ebp),%eax
c01052f5:	8b 00                	mov    (%eax),%eax
c01052f7:	83 e0 01             	and    $0x1,%eax
c01052fa:	85 c0                	test   %eax,%eax
c01052fc:	74 e2                	je     c01052e0 <get_pgtable_items+0x18>
        start ++;
    }
    if (start < right) {
c01052fe:	8b 45 10             	mov    0x10(%ebp),%eax
c0105301:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105304:	73 5b                	jae    c0105361 <get_pgtable_items+0x99>
        if (left_store != NULL) {
c0105306:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c010530a:	74 08                	je     c0105314 <get_pgtable_items+0x4c>
            *left_store = start;
c010530c:	8b 45 18             	mov    0x18(%ebp),%eax
c010530f:	8b 55 10             	mov    0x10(%ebp),%edx
c0105312:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0105314:	8b 45 10             	mov    0x10(%ebp),%eax
c0105317:	c1 e0 02             	shl    $0x2,%eax
c010531a:	03 45 14             	add    0x14(%ebp),%eax
c010531d:	8b 00                	mov    (%eax),%eax
c010531f:	83 e0 07             	and    $0x7,%eax
c0105322:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0105325:	83 45 10 01          	addl   $0x1,0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105329:	eb 04                	jmp    c010532f <get_pgtable_items+0x67>
            start ++;
c010532b:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c010532f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105332:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105335:	73 17                	jae    c010534e <get_pgtable_items+0x86>
c0105337:	8b 45 10             	mov    0x10(%ebp),%eax
c010533a:	c1 e0 02             	shl    $0x2,%eax
c010533d:	03 45 14             	add    0x14(%ebp),%eax
c0105340:	8b 00                	mov    (%eax),%eax
c0105342:	89 c2                	mov    %eax,%edx
c0105344:	83 e2 07             	and    $0x7,%edx
c0105347:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010534a:	39 c2                	cmp    %eax,%edx
c010534c:	74 dd                	je     c010532b <get_pgtable_items+0x63>
            start ++;
        }
        if (right_store != NULL) {
c010534e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105352:	74 08                	je     c010535c <get_pgtable_items+0x94>
            *right_store = start;
c0105354:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105357:	8b 55 10             	mov    0x10(%ebp),%edx
c010535a:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c010535c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010535f:	eb 05                	jmp    c0105366 <get_pgtable_items+0x9e>
    }
    return 0;
c0105361:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105366:	c9                   	leave  
c0105367:	c3                   	ret    

c0105368 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0105368:	55                   	push   %ebp
c0105369:	89 e5                	mov    %esp,%ebp
c010536b:	57                   	push   %edi
c010536c:	56                   	push   %esi
c010536d:	53                   	push   %ebx
c010536e:	83 ec 5c             	sub    $0x5c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0105371:	c7 04 24 1c 71 10 c0 	movl   $0xc010711c,(%esp)
c0105378:	e8 ca af ff ff       	call   c0100347 <cprintf>
    size_t left, right = 0, perm;
c010537d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105384:	e9 0b 01 00 00       	jmp    c0105494 <print_pgdir+0x12c>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105389:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010538c:	89 04 24             	mov    %eax,(%esp)
c010538f:	e8 e6 fe ff ff       	call   c010527a <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0105394:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105397:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010539a:	89 cb                	mov    %ecx,%ebx
c010539c:	29 d3                	sub    %edx,%ebx
c010539e:	89 da                	mov    %ebx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01053a0:	89 d6                	mov    %edx,%esi
c01053a2:	c1 e6 16             	shl    $0x16,%esi
c01053a5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01053a8:	89 d3                	mov    %edx,%ebx
c01053aa:	c1 e3 16             	shl    $0x16,%ebx
c01053ad:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01053b0:	89 d1                	mov    %edx,%ecx
c01053b2:	c1 e1 16             	shl    $0x16,%ecx
c01053b5:	8b 7d dc             	mov    -0x24(%ebp),%edi
c01053b8:	89 7d c4             	mov    %edi,-0x3c(%ebp)
c01053bb:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01053be:	8b 7d c4             	mov    -0x3c(%ebp),%edi
c01053c1:	29 d7                	sub    %edx,%edi
c01053c3:	89 fa                	mov    %edi,%edx
c01053c5:	89 44 24 14          	mov    %eax,0x14(%esp)
c01053c9:	89 74 24 10          	mov    %esi,0x10(%esp)
c01053cd:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01053d1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01053d5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01053d9:	c7 04 24 4d 71 10 c0 	movl   $0xc010714d,(%esp)
c01053e0:	e8 62 af ff ff       	call   c0100347 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c01053e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01053e8:	c1 e0 0a             	shl    $0xa,%eax
c01053eb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01053ee:	eb 5c                	jmp    c010544c <print_pgdir+0xe4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01053f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01053f3:	89 04 24             	mov    %eax,(%esp)
c01053f6:	e8 7f fe ff ff       	call   c010527a <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c01053fb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01053fe:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105401:	89 cb                	mov    %ecx,%ebx
c0105403:	29 d3                	sub    %edx,%ebx
c0105405:	89 da                	mov    %ebx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105407:	89 d6                	mov    %edx,%esi
c0105409:	c1 e6 0c             	shl    $0xc,%esi
c010540c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010540f:	89 d3                	mov    %edx,%ebx
c0105411:	c1 e3 0c             	shl    $0xc,%ebx
c0105414:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105417:	89 d1                	mov    %edx,%ecx
c0105419:	c1 e1 0c             	shl    $0xc,%ecx
c010541c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c010541f:	89 7d c4             	mov    %edi,-0x3c(%ebp)
c0105422:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105425:	8b 7d c4             	mov    -0x3c(%ebp),%edi
c0105428:	29 d7                	sub    %edx,%edi
c010542a:	89 fa                	mov    %edi,%edx
c010542c:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105430:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105434:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105438:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010543c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105440:	c7 04 24 6c 71 10 c0 	movl   $0xc010716c,(%esp)
c0105447:	e8 fb ae ff ff       	call   c0100347 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010544c:	8b 15 dc 6b 10 c0    	mov    0xc0106bdc,%edx
c0105452:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105455:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105458:	89 ce                	mov    %ecx,%esi
c010545a:	c1 e6 0a             	shl    $0xa,%esi
c010545d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0105460:	89 cb                	mov    %ecx,%ebx
c0105462:	c1 e3 0a             	shl    $0xa,%ebx
c0105465:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0105468:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c010546c:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c010546f:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105473:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105477:	89 44 24 08          	mov    %eax,0x8(%esp)
c010547b:	89 74 24 04          	mov    %esi,0x4(%esp)
c010547f:	89 1c 24             	mov    %ebx,(%esp)
c0105482:	e8 41 fe ff ff       	call   c01052c8 <get_pgtable_items>
c0105487:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010548a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010548e:	0f 85 5c ff ff ff    	jne    c01053f0 <print_pgdir+0x88>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105494:	8b 15 e0 6b 10 c0    	mov    0xc0106be0,%edx
c010549a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010549d:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c01054a0:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01054a4:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c01054a7:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01054ab:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01054af:	89 44 24 08          	mov    %eax,0x8(%esp)
c01054b3:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c01054ba:	00 
c01054bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01054c2:	e8 01 fe ff ff       	call   c01052c8 <get_pgtable_items>
c01054c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01054ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01054ce:	0f 85 b5 fe ff ff    	jne    c0105389 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01054d4:	c7 04 24 90 71 10 c0 	movl   $0xc0107190,(%esp)
c01054db:	e8 67 ae ff ff       	call   c0100347 <cprintf>
}
c01054e0:	83 c4 5c             	add    $0x5c,%esp
c01054e3:	5b                   	pop    %ebx
c01054e4:	5e                   	pop    %esi
c01054e5:	5f                   	pop    %edi
c01054e6:	5d                   	pop    %ebp
c01054e7:	c3                   	ret    

c01054e8 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01054e8:	55                   	push   %ebp
c01054e9:	89 e5                	mov    %esp,%ebp
c01054eb:	56                   	push   %esi
c01054ec:	53                   	push   %ebx
c01054ed:	83 ec 60             	sub    $0x60,%esp
c01054f0:	8b 45 10             	mov    0x10(%ebp),%eax
c01054f3:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01054f6:	8b 45 14             	mov    0x14(%ebp),%eax
c01054f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c01054fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01054ff:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105502:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105505:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0105508:	8b 45 18             	mov    0x18(%ebp),%eax
c010550b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010550e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105511:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105514:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0105517:	89 55 cc             	mov    %edx,-0x34(%ebp)
c010551a:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010551d:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0105520:	89 d3                	mov    %edx,%ebx
c0105522:	89 c6                	mov    %eax,%esi
c0105524:	89 75 e0             	mov    %esi,-0x20(%ebp)
c0105527:	89 5d f0             	mov    %ebx,-0x10(%ebp)
c010552a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010552d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105530:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105534:	74 1c                	je     c0105552 <printnum+0x6a>
c0105536:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105539:	ba 00 00 00 00       	mov    $0x0,%edx
c010553e:	f7 75 e4             	divl   -0x1c(%ebp)
c0105541:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105544:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105547:	ba 00 00 00 00       	mov    $0x0,%edx
c010554c:	f7 75 e4             	divl   -0x1c(%ebp)
c010554f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105552:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105555:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105558:	89 d6                	mov    %edx,%esi
c010555a:	89 c3                	mov    %eax,%ebx
c010555c:	89 f0                	mov    %esi,%eax
c010555e:	89 da                	mov    %ebx,%edx
c0105560:	f7 75 e4             	divl   -0x1c(%ebp)
c0105563:	89 d3                	mov    %edx,%ebx
c0105565:	89 c6                	mov    %eax,%esi
c0105567:	89 75 e0             	mov    %esi,-0x20(%ebp)
c010556a:	89 5d dc             	mov    %ebx,-0x24(%ebp)
c010556d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105570:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0105573:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105576:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0105579:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010557c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010557f:	89 c3                	mov    %eax,%ebx
c0105581:	89 d6                	mov    %edx,%esi
c0105583:	89 5d e8             	mov    %ebx,-0x18(%ebp)
c0105586:	89 75 ec             	mov    %esi,-0x14(%ebp)
c0105589:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010558c:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c010558f:	8b 45 18             	mov    0x18(%ebp),%eax
c0105592:	ba 00 00 00 00       	mov    $0x0,%edx
c0105597:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010559a:	77 56                	ja     c01055f2 <printnum+0x10a>
c010559c:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010559f:	72 05                	jb     c01055a6 <printnum+0xbe>
c01055a1:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01055a4:	77 4c                	ja     c01055f2 <printnum+0x10a>
        printnum(putch, putdat, result, base, width - 1, padc);
c01055a6:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01055a9:	8d 50 ff             	lea    -0x1(%eax),%edx
c01055ac:	8b 45 20             	mov    0x20(%ebp),%eax
c01055af:	89 44 24 18          	mov    %eax,0x18(%esp)
c01055b3:	89 54 24 14          	mov    %edx,0x14(%esp)
c01055b7:	8b 45 18             	mov    0x18(%ebp),%eax
c01055ba:	89 44 24 10          	mov    %eax,0x10(%esp)
c01055be:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01055c1:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01055c4:	89 44 24 08          	mov    %eax,0x8(%esp)
c01055c8:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01055cc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055cf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01055d6:	89 04 24             	mov    %eax,(%esp)
c01055d9:	e8 0a ff ff ff       	call   c01054e8 <printnum>
c01055de:	eb 1c                	jmp    c01055fc <printnum+0x114>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01055e0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055e3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055e7:	8b 45 20             	mov    0x20(%ebp),%eax
c01055ea:	89 04 24             	mov    %eax,(%esp)
c01055ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01055f0:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c01055f2:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c01055f6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01055fa:	7f e4                	jg     c01055e0 <printnum+0xf8>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01055fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01055ff:	05 44 72 10 c0       	add    $0xc0107244,%eax
c0105604:	0f b6 00             	movzbl (%eax),%eax
c0105607:	0f be c0             	movsbl %al,%eax
c010560a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010560d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105611:	89 04 24             	mov    %eax,(%esp)
c0105614:	8b 45 08             	mov    0x8(%ebp),%eax
c0105617:	ff d0                	call   *%eax
}
c0105619:	83 c4 60             	add    $0x60,%esp
c010561c:	5b                   	pop    %ebx
c010561d:	5e                   	pop    %esi
c010561e:	5d                   	pop    %ebp
c010561f:	c3                   	ret    

c0105620 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105620:	55                   	push   %ebp
c0105621:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105623:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105627:	7e 14                	jle    c010563d <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0105629:	8b 45 08             	mov    0x8(%ebp),%eax
c010562c:	8b 00                	mov    (%eax),%eax
c010562e:	8d 48 08             	lea    0x8(%eax),%ecx
c0105631:	8b 55 08             	mov    0x8(%ebp),%edx
c0105634:	89 0a                	mov    %ecx,(%edx)
c0105636:	8b 50 04             	mov    0x4(%eax),%edx
c0105639:	8b 00                	mov    (%eax),%eax
c010563b:	eb 30                	jmp    c010566d <getuint+0x4d>
    }
    else if (lflag) {
c010563d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105641:	74 16                	je     c0105659 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0105643:	8b 45 08             	mov    0x8(%ebp),%eax
c0105646:	8b 00                	mov    (%eax),%eax
c0105648:	8d 48 04             	lea    0x4(%eax),%ecx
c010564b:	8b 55 08             	mov    0x8(%ebp),%edx
c010564e:	89 0a                	mov    %ecx,(%edx)
c0105650:	8b 00                	mov    (%eax),%eax
c0105652:	ba 00 00 00 00       	mov    $0x0,%edx
c0105657:	eb 14                	jmp    c010566d <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105659:	8b 45 08             	mov    0x8(%ebp),%eax
c010565c:	8b 00                	mov    (%eax),%eax
c010565e:	8d 48 04             	lea    0x4(%eax),%ecx
c0105661:	8b 55 08             	mov    0x8(%ebp),%edx
c0105664:	89 0a                	mov    %ecx,(%edx)
c0105666:	8b 00                	mov    (%eax),%eax
c0105668:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c010566d:	5d                   	pop    %ebp
c010566e:	c3                   	ret    

c010566f <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c010566f:	55                   	push   %ebp
c0105670:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105672:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105676:	7e 14                	jle    c010568c <getint+0x1d>
        return va_arg(*ap, long long);
c0105678:	8b 45 08             	mov    0x8(%ebp),%eax
c010567b:	8b 00                	mov    (%eax),%eax
c010567d:	8d 48 08             	lea    0x8(%eax),%ecx
c0105680:	8b 55 08             	mov    0x8(%ebp),%edx
c0105683:	89 0a                	mov    %ecx,(%edx)
c0105685:	8b 50 04             	mov    0x4(%eax),%edx
c0105688:	8b 00                	mov    (%eax),%eax
c010568a:	eb 30                	jmp    c01056bc <getint+0x4d>
    }
    else if (lflag) {
c010568c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105690:	74 16                	je     c01056a8 <getint+0x39>
        return va_arg(*ap, long);
c0105692:	8b 45 08             	mov    0x8(%ebp),%eax
c0105695:	8b 00                	mov    (%eax),%eax
c0105697:	8d 48 04             	lea    0x4(%eax),%ecx
c010569a:	8b 55 08             	mov    0x8(%ebp),%edx
c010569d:	89 0a                	mov    %ecx,(%edx)
c010569f:	8b 00                	mov    (%eax),%eax
c01056a1:	89 c2                	mov    %eax,%edx
c01056a3:	c1 fa 1f             	sar    $0x1f,%edx
c01056a6:	eb 14                	jmp    c01056bc <getint+0x4d>
    }
    else {
        return va_arg(*ap, int);
c01056a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01056ab:	8b 00                	mov    (%eax),%eax
c01056ad:	8d 48 04             	lea    0x4(%eax),%ecx
c01056b0:	8b 55 08             	mov    0x8(%ebp),%edx
c01056b3:	89 0a                	mov    %ecx,(%edx)
c01056b5:	8b 00                	mov    (%eax),%eax
c01056b7:	89 c2                	mov    %eax,%edx
c01056b9:	c1 fa 1f             	sar    $0x1f,%edx
    }
}
c01056bc:	5d                   	pop    %ebp
c01056bd:	c3                   	ret    

c01056be <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01056be:	55                   	push   %ebp
c01056bf:	89 e5                	mov    %esp,%ebp
c01056c1:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c01056c4:	8d 55 14             	lea    0x14(%ebp),%edx
c01056c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
c01056ca:	89 10                	mov    %edx,(%eax)
    vprintfmt(putch, putdat, fmt, ap);
c01056cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01056d3:	8b 45 10             	mov    0x10(%ebp),%eax
c01056d6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01056da:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01056e4:	89 04 24             	mov    %eax,(%esp)
c01056e7:	e8 02 00 00 00       	call   c01056ee <vprintfmt>
    va_end(ap);
}
c01056ec:	c9                   	leave  
c01056ed:	c3                   	ret    

c01056ee <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01056ee:	55                   	push   %ebp
c01056ef:	89 e5                	mov    %esp,%ebp
c01056f1:	56                   	push   %esi
c01056f2:	53                   	push   %ebx
c01056f3:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01056f6:	eb 17                	jmp    c010570f <vprintfmt+0x21>
            if (ch == '\0') {
c01056f8:	85 db                	test   %ebx,%ebx
c01056fa:	0f 84 db 03 00 00    	je     c0105adb <vprintfmt+0x3ed>
                return;
            }
            putch(ch, putdat);
c0105700:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105703:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105707:	89 1c 24             	mov    %ebx,(%esp)
c010570a:	8b 45 08             	mov    0x8(%ebp),%eax
c010570d:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010570f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105712:	0f b6 00             	movzbl (%eax),%eax
c0105715:	0f b6 d8             	movzbl %al,%ebx
c0105718:	83 fb 25             	cmp    $0x25,%ebx
c010571b:	0f 95 c0             	setne  %al
c010571e:	83 45 10 01          	addl   $0x1,0x10(%ebp)
c0105722:	84 c0                	test   %al,%al
c0105724:	75 d2                	jne    c01056f8 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105726:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c010572a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0105731:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105734:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105737:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010573e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105741:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105744:	eb 04                	jmp    c010574a <vprintfmt+0x5c>
            goto process_precision;

        case '.':
            if (width < 0)
                width = 0;
            goto reswitch;
c0105746:	90                   	nop
c0105747:	eb 01                	jmp    c010574a <vprintfmt+0x5c>
            goto reswitch;

        process_precision:
            if (width < 0)
                width = precision, precision = -1;
            goto reswitch;
c0105749:	90                   	nop
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c010574a:	8b 45 10             	mov    0x10(%ebp),%eax
c010574d:	0f b6 00             	movzbl (%eax),%eax
c0105750:	0f b6 d8             	movzbl %al,%ebx
c0105753:	89 d8                	mov    %ebx,%eax
c0105755:	83 45 10 01          	addl   $0x1,0x10(%ebp)
c0105759:	83 e8 23             	sub    $0x23,%eax
c010575c:	83 f8 55             	cmp    $0x55,%eax
c010575f:	0f 87 45 03 00 00    	ja     c0105aaa <vprintfmt+0x3bc>
c0105765:	8b 04 85 68 72 10 c0 	mov    -0x3fef8d98(,%eax,4),%eax
c010576c:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c010576e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105772:	eb d6                	jmp    c010574a <vprintfmt+0x5c>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105774:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105778:	eb d0                	jmp    c010574a <vprintfmt+0x5c>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010577a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105781:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105784:	89 d0                	mov    %edx,%eax
c0105786:	c1 e0 02             	shl    $0x2,%eax
c0105789:	01 d0                	add    %edx,%eax
c010578b:	01 c0                	add    %eax,%eax
c010578d:	01 d8                	add    %ebx,%eax
c010578f:	83 e8 30             	sub    $0x30,%eax
c0105792:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105795:	8b 45 10             	mov    0x10(%ebp),%eax
c0105798:	0f b6 00             	movzbl (%eax),%eax
c010579b:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c010579e:	83 fb 2f             	cmp    $0x2f,%ebx
c01057a1:	7e 39                	jle    c01057dc <vprintfmt+0xee>
c01057a3:	83 fb 39             	cmp    $0x39,%ebx
c01057a6:	7f 34                	jg     c01057dc <vprintfmt+0xee>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01057a8:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c01057ac:	eb d3                	jmp    c0105781 <vprintfmt+0x93>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c01057ae:	8b 45 14             	mov    0x14(%ebp),%eax
c01057b1:	8d 50 04             	lea    0x4(%eax),%edx
c01057b4:	89 55 14             	mov    %edx,0x14(%ebp)
c01057b7:	8b 00                	mov    (%eax),%eax
c01057b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01057bc:	eb 1f                	jmp    c01057dd <vprintfmt+0xef>

        case '.':
            if (width < 0)
c01057be:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01057c2:	79 82                	jns    c0105746 <vprintfmt+0x58>
                width = 0;
c01057c4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01057cb:	e9 76 ff ff ff       	jmp    c0105746 <vprintfmt+0x58>

        case '#':
            altflag = 1;
c01057d0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01057d7:	e9 6e ff ff ff       	jmp    c010574a <vprintfmt+0x5c>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
c01057dc:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
c01057dd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01057e1:	0f 89 62 ff ff ff    	jns    c0105749 <vprintfmt+0x5b>
                width = precision, precision = -1;
c01057e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01057ea:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01057ed:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c01057f4:	e9 50 ff ff ff       	jmp    c0105749 <vprintfmt+0x5b>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01057f9:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c01057fd:	e9 48 ff ff ff       	jmp    c010574a <vprintfmt+0x5c>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0105802:	8b 45 14             	mov    0x14(%ebp),%eax
c0105805:	8d 50 04             	lea    0x4(%eax),%edx
c0105808:	89 55 14             	mov    %edx,0x14(%ebp)
c010580b:	8b 00                	mov    (%eax),%eax
c010580d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105810:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105814:	89 04 24             	mov    %eax,(%esp)
c0105817:	8b 45 08             	mov    0x8(%ebp),%eax
c010581a:	ff d0                	call   *%eax
            break;
c010581c:	e9 b4 02 00 00       	jmp    c0105ad5 <vprintfmt+0x3e7>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0105821:	8b 45 14             	mov    0x14(%ebp),%eax
c0105824:	8d 50 04             	lea    0x4(%eax),%edx
c0105827:	89 55 14             	mov    %edx,0x14(%ebp)
c010582a:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c010582c:	85 db                	test   %ebx,%ebx
c010582e:	79 02                	jns    c0105832 <vprintfmt+0x144>
                err = -err;
c0105830:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0105832:	83 fb 06             	cmp    $0x6,%ebx
c0105835:	7f 0b                	jg     c0105842 <vprintfmt+0x154>
c0105837:	8b 34 9d 28 72 10 c0 	mov    -0x3fef8dd8(,%ebx,4),%esi
c010583e:	85 f6                	test   %esi,%esi
c0105840:	75 23                	jne    c0105865 <vprintfmt+0x177>
                printfmt(putch, putdat, "error %d", err);
c0105842:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105846:	c7 44 24 08 55 72 10 	movl   $0xc0107255,0x8(%esp)
c010584d:	c0 
c010584e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105851:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105855:	8b 45 08             	mov    0x8(%ebp),%eax
c0105858:	89 04 24             	mov    %eax,(%esp)
c010585b:	e8 5e fe ff ff       	call   c01056be <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105860:	e9 70 02 00 00       	jmp    c0105ad5 <vprintfmt+0x3e7>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0105865:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105869:	c7 44 24 08 5e 72 10 	movl   $0xc010725e,0x8(%esp)
c0105870:	c0 
c0105871:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105874:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105878:	8b 45 08             	mov    0x8(%ebp),%eax
c010587b:	89 04 24             	mov    %eax,(%esp)
c010587e:	e8 3b fe ff ff       	call   c01056be <printfmt>
            }
            break;
c0105883:	e9 4d 02 00 00       	jmp    c0105ad5 <vprintfmt+0x3e7>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105888:	8b 45 14             	mov    0x14(%ebp),%eax
c010588b:	8d 50 04             	lea    0x4(%eax),%edx
c010588e:	89 55 14             	mov    %edx,0x14(%ebp)
c0105891:	8b 30                	mov    (%eax),%esi
c0105893:	85 f6                	test   %esi,%esi
c0105895:	75 05                	jne    c010589c <vprintfmt+0x1ae>
                p = "(null)";
c0105897:	be 61 72 10 c0       	mov    $0xc0107261,%esi
            }
            if (width > 0 && padc != '-') {
c010589c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01058a0:	7e 7c                	jle    c010591e <vprintfmt+0x230>
c01058a2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c01058a6:	74 76                	je     c010591e <vprintfmt+0x230>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01058a8:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c01058ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01058ae:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058b2:	89 34 24             	mov    %esi,(%esp)
c01058b5:	e8 21 03 00 00       	call   c0105bdb <strnlen>
c01058ba:	89 da                	mov    %ebx,%edx
c01058bc:	29 c2                	sub    %eax,%edx
c01058be:	89 d0                	mov    %edx,%eax
c01058c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01058c3:	eb 17                	jmp    c01058dc <vprintfmt+0x1ee>
                    putch(padc, putdat);
c01058c5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01058c9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01058cc:	89 54 24 04          	mov    %edx,0x4(%esp)
c01058d0:	89 04 24             	mov    %eax,(%esp)
c01058d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01058d6:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c01058d8:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01058dc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01058e0:	7f e3                	jg     c01058c5 <vprintfmt+0x1d7>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01058e2:	eb 3a                	jmp    c010591e <vprintfmt+0x230>
                if (altflag && (ch < ' ' || ch > '~')) {
c01058e4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01058e8:	74 1f                	je     c0105909 <vprintfmt+0x21b>
c01058ea:	83 fb 1f             	cmp    $0x1f,%ebx
c01058ed:	7e 05                	jle    c01058f4 <vprintfmt+0x206>
c01058ef:	83 fb 7e             	cmp    $0x7e,%ebx
c01058f2:	7e 15                	jle    c0105909 <vprintfmt+0x21b>
                    putch('?', putdat);
c01058f4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058f7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058fb:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0105902:	8b 45 08             	mov    0x8(%ebp),%eax
c0105905:	ff d0                	call   *%eax
c0105907:	eb 0f                	jmp    c0105918 <vprintfmt+0x22a>
                }
                else {
                    putch(ch, putdat);
c0105909:	8b 45 0c             	mov    0xc(%ebp),%eax
c010590c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105910:	89 1c 24             	mov    %ebx,(%esp)
c0105913:	8b 45 08             	mov    0x8(%ebp),%eax
c0105916:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105918:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010591c:	eb 01                	jmp    c010591f <vprintfmt+0x231>
c010591e:	90                   	nop
c010591f:	0f b6 06             	movzbl (%esi),%eax
c0105922:	0f be d8             	movsbl %al,%ebx
c0105925:	85 db                	test   %ebx,%ebx
c0105927:	0f 95 c0             	setne  %al
c010592a:	83 c6 01             	add    $0x1,%esi
c010592d:	84 c0                	test   %al,%al
c010592f:	74 29                	je     c010595a <vprintfmt+0x26c>
c0105931:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105935:	78 ad                	js     c01058e4 <vprintfmt+0x1f6>
c0105937:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c010593b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010593f:	79 a3                	jns    c01058e4 <vprintfmt+0x1f6>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105941:	eb 17                	jmp    c010595a <vprintfmt+0x26c>
                putch(' ', putdat);
c0105943:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105946:	89 44 24 04          	mov    %eax,0x4(%esp)
c010594a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0105951:	8b 45 08             	mov    0x8(%ebp),%eax
c0105954:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105956:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010595a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010595e:	7f e3                	jg     c0105943 <vprintfmt+0x255>
                putch(' ', putdat);
            }
            break;
c0105960:	e9 70 01 00 00       	jmp    c0105ad5 <vprintfmt+0x3e7>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105965:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105968:	89 44 24 04          	mov    %eax,0x4(%esp)
c010596c:	8d 45 14             	lea    0x14(%ebp),%eax
c010596f:	89 04 24             	mov    %eax,(%esp)
c0105972:	e8 f8 fc ff ff       	call   c010566f <getint>
c0105977:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010597a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c010597d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105980:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105983:	85 d2                	test   %edx,%edx
c0105985:	79 26                	jns    c01059ad <vprintfmt+0x2bf>
                putch('-', putdat);
c0105987:	8b 45 0c             	mov    0xc(%ebp),%eax
c010598a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010598e:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105995:	8b 45 08             	mov    0x8(%ebp),%eax
c0105998:	ff d0                	call   *%eax
                num = -(long long)num;
c010599a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010599d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01059a0:	f7 d8                	neg    %eax
c01059a2:	83 d2 00             	adc    $0x0,%edx
c01059a5:	f7 da                	neg    %edx
c01059a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01059aa:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01059ad:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01059b4:	e9 a8 00 00 00       	jmp    c0105a61 <vprintfmt+0x373>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01059b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01059bc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059c0:	8d 45 14             	lea    0x14(%ebp),%eax
c01059c3:	89 04 24             	mov    %eax,(%esp)
c01059c6:	e8 55 fc ff ff       	call   c0105620 <getuint>
c01059cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01059ce:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01059d1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01059d8:	e9 84 00 00 00       	jmp    c0105a61 <vprintfmt+0x373>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c01059dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01059e0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059e4:	8d 45 14             	lea    0x14(%ebp),%eax
c01059e7:	89 04 24             	mov    %eax,(%esp)
c01059ea:	e8 31 fc ff ff       	call   c0105620 <getuint>
c01059ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01059f2:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c01059f5:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c01059fc:	eb 63                	jmp    c0105a61 <vprintfmt+0x373>

        // pointer
        case 'p':
            putch('0', putdat);
c01059fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a01:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a05:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105a0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a0f:	ff d0                	call   *%eax
            putch('x', putdat);
c0105a11:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a14:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a18:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0105a1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a22:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105a24:	8b 45 14             	mov    0x14(%ebp),%eax
c0105a27:	8d 50 04             	lea    0x4(%eax),%edx
c0105a2a:	89 55 14             	mov    %edx,0x14(%ebp)
c0105a2d:	8b 00                	mov    (%eax),%eax
c0105a2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a32:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105a39:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105a40:	eb 1f                	jmp    c0105a61 <vprintfmt+0x373>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105a42:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105a45:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a49:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a4c:	89 04 24             	mov    %eax,(%esp)
c0105a4f:	e8 cc fb ff ff       	call   c0105620 <getuint>
c0105a54:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a57:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105a5a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105a61:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105a65:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105a68:	89 54 24 18          	mov    %edx,0x18(%esp)
c0105a6c:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105a6f:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105a73:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105a77:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a7d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a81:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105a85:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a88:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a8f:	89 04 24             	mov    %eax,(%esp)
c0105a92:	e8 51 fa ff ff       	call   c01054e8 <printnum>
            break;
c0105a97:	eb 3c                	jmp    c0105ad5 <vprintfmt+0x3e7>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105a99:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a9c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105aa0:	89 1c 24             	mov    %ebx,(%esp)
c0105aa3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aa6:	ff d0                	call   *%eax
            break;
c0105aa8:	eb 2b                	jmp    c0105ad5 <vprintfmt+0x3e7>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105aaa:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105aad:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ab1:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0105ab8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105abb:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105abd:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105ac1:	eb 04                	jmp    c0105ac7 <vprintfmt+0x3d9>
c0105ac3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105ac7:	8b 45 10             	mov    0x10(%ebp),%eax
c0105aca:	83 e8 01             	sub    $0x1,%eax
c0105acd:	0f b6 00             	movzbl (%eax),%eax
c0105ad0:	3c 25                	cmp    $0x25,%al
c0105ad2:	75 ef                	jne    c0105ac3 <vprintfmt+0x3d5>
                /* do nothing */;
            break;
c0105ad4:	90                   	nop
        }
    }
c0105ad5:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105ad6:	e9 34 fc ff ff       	jmp    c010570f <vprintfmt+0x21>
            if (ch == '\0') {
                return;
c0105adb:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0105adc:	83 c4 40             	add    $0x40,%esp
c0105adf:	5b                   	pop    %ebx
c0105ae0:	5e                   	pop    %esi
c0105ae1:	5d                   	pop    %ebp
c0105ae2:	c3                   	ret    

c0105ae3 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105ae3:	55                   	push   %ebp
c0105ae4:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105ae6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ae9:	8b 40 08             	mov    0x8(%eax),%eax
c0105aec:	8d 50 01             	lea    0x1(%eax),%edx
c0105aef:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105af2:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105af5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105af8:	8b 10                	mov    (%eax),%edx
c0105afa:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105afd:	8b 40 04             	mov    0x4(%eax),%eax
c0105b00:	39 c2                	cmp    %eax,%edx
c0105b02:	73 12                	jae    c0105b16 <sprintputch+0x33>
        *b->buf ++ = ch;
c0105b04:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b07:	8b 00                	mov    (%eax),%eax
c0105b09:	8b 55 08             	mov    0x8(%ebp),%edx
c0105b0c:	88 10                	mov    %dl,(%eax)
c0105b0e:	8d 50 01             	lea    0x1(%eax),%edx
c0105b11:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b14:	89 10                	mov    %edx,(%eax)
    }
}
c0105b16:	5d                   	pop    %ebp
c0105b17:	c3                   	ret    

c0105b18 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105b18:	55                   	push   %ebp
c0105b19:	89 e5                	mov    %esp,%ebp
c0105b1b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105b1e:	8d 55 14             	lea    0x14(%ebp),%edx
c0105b21:	8d 45 f0             	lea    -0x10(%ebp),%eax
c0105b24:	89 10                	mov    %edx,(%eax)
    cnt = vsnprintf(str, size, fmt, ap);
c0105b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b29:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105b2d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b30:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105b34:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b37:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b3e:	89 04 24             	mov    %eax,(%esp)
c0105b41:	e8 08 00 00 00       	call   c0105b4e <vsnprintf>
c0105b46:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105b4c:	c9                   	leave  
c0105b4d:	c3                   	ret    

c0105b4e <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105b4e:	55                   	push   %ebp
c0105b4f:	89 e5                	mov    %esp,%ebp
c0105b51:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105b54:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b57:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105b5a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b5d:	83 e8 01             	sub    $0x1,%eax
c0105b60:	03 45 08             	add    0x8(%ebp),%eax
c0105b63:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105b6d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105b71:	74 0a                	je     c0105b7d <vsnprintf+0x2f>
c0105b73:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105b76:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b79:	39 c2                	cmp    %eax,%edx
c0105b7b:	76 07                	jbe    c0105b84 <vsnprintf+0x36>
        return -E_INVAL;
c0105b7d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105b82:	eb 2a                	jmp    c0105bae <vsnprintf+0x60>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105b84:	8b 45 14             	mov    0x14(%ebp),%eax
c0105b87:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105b8b:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b8e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105b92:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105b95:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b99:	c7 04 24 e3 5a 10 c0 	movl   $0xc0105ae3,(%esp)
c0105ba0:	e8 49 fb ff ff       	call   c01056ee <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105ba5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ba8:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105bae:	c9                   	leave  
c0105baf:	c3                   	ret    

c0105bb0 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105bb0:	55                   	push   %ebp
c0105bb1:	89 e5                	mov    %esp,%ebp
c0105bb3:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105bb6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105bbd:	eb 04                	jmp    c0105bc3 <strlen+0x13>
        cnt ++;
c0105bbf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0105bc3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bc6:	0f b6 00             	movzbl (%eax),%eax
c0105bc9:	84 c0                	test   %al,%al
c0105bcb:	0f 95 c0             	setne  %al
c0105bce:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105bd2:	84 c0                	test   %al,%al
c0105bd4:	75 e9                	jne    c0105bbf <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0105bd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105bd9:	c9                   	leave  
c0105bda:	c3                   	ret    

c0105bdb <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105bdb:	55                   	push   %ebp
c0105bdc:	89 e5                	mov    %esp,%ebp
c0105bde:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105be1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105be8:	eb 04                	jmp    c0105bee <strnlen+0x13>
        cnt ++;
c0105bea:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0105bee:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105bf1:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105bf4:	73 13                	jae    c0105c09 <strnlen+0x2e>
c0105bf6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bf9:	0f b6 00             	movzbl (%eax),%eax
c0105bfc:	84 c0                	test   %al,%al
c0105bfe:	0f 95 c0             	setne  %al
c0105c01:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105c05:	84 c0                	test   %al,%al
c0105c07:	75 e1                	jne    c0105bea <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0105c09:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105c0c:	c9                   	leave  
c0105c0d:	c3                   	ret    

c0105c0e <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105c0e:	55                   	push   %ebp
c0105c0f:	89 e5                	mov    %esp,%ebp
c0105c11:	57                   	push   %edi
c0105c12:	56                   	push   %esi
c0105c13:	53                   	push   %ebx
c0105c14:	83 ec 24             	sub    $0x24,%esp
c0105c17:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105c1d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c20:	89 45 ec             	mov    %eax,-0x14(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105c23:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105c26:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c29:	89 d6                	mov    %edx,%esi
c0105c2b:	89 c3                	mov    %eax,%ebx
c0105c2d:	89 df                	mov    %ebx,%edi
c0105c2f:	ac                   	lods   %ds:(%esi),%al
c0105c30:	aa                   	stos   %al,%es:(%edi)
c0105c31:	84 c0                	test   %al,%al
c0105c33:	75 fa                	jne    c0105c2f <strcpy+0x21>
c0105c35:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105c38:	89 fb                	mov    %edi,%ebx
c0105c3a:	89 75 e8             	mov    %esi,-0x18(%ebp)
c0105c3d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
c0105c40:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105c43:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105c49:	83 c4 24             	add    $0x24,%esp
c0105c4c:	5b                   	pop    %ebx
c0105c4d:	5e                   	pop    %esi
c0105c4e:	5f                   	pop    %edi
c0105c4f:	5d                   	pop    %ebp
c0105c50:	c3                   	ret    

c0105c51 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105c51:	55                   	push   %ebp
c0105c52:	89 e5                	mov    %esp,%ebp
c0105c54:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105c57:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c5a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105c5d:	eb 21                	jmp    c0105c80 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105c5f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c62:	0f b6 10             	movzbl (%eax),%edx
c0105c65:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105c68:	88 10                	mov    %dl,(%eax)
c0105c6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105c6d:	0f b6 00             	movzbl (%eax),%eax
c0105c70:	84 c0                	test   %al,%al
c0105c72:	74 04                	je     c0105c78 <strncpy+0x27>
            src ++;
c0105c74:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105c78:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105c7c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0105c80:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c84:	75 d9                	jne    c0105c5f <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105c86:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105c89:	c9                   	leave  
c0105c8a:	c3                   	ret    

c0105c8b <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105c8b:	55                   	push   %ebp
c0105c8c:	89 e5                	mov    %esp,%ebp
c0105c8e:	57                   	push   %edi
c0105c8f:	56                   	push   %esi
c0105c90:	53                   	push   %ebx
c0105c91:	83 ec 24             	sub    $0x24,%esp
c0105c94:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c97:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105c9a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c9d:	89 45 ec             	mov    %eax,-0x14(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0105ca0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105ca3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ca6:	89 d6                	mov    %edx,%esi
c0105ca8:	89 c3                	mov    %eax,%ebx
c0105caa:	89 df                	mov    %ebx,%edi
c0105cac:	ac                   	lods   %ds:(%esi),%al
c0105cad:	ae                   	scas   %es:(%edi),%al
c0105cae:	75 08                	jne    c0105cb8 <strcmp+0x2d>
c0105cb0:	84 c0                	test   %al,%al
c0105cb2:	75 f8                	jne    c0105cac <strcmp+0x21>
c0105cb4:	31 c0                	xor    %eax,%eax
c0105cb6:	eb 04                	jmp    c0105cbc <strcmp+0x31>
c0105cb8:	19 c0                	sbb    %eax,%eax
c0105cba:	0c 01                	or     $0x1,%al
c0105cbc:	89 fb                	mov    %edi,%ebx
c0105cbe:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105cc1:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105cc4:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105cc7:	89 75 e4             	mov    %esi,-0x1c(%ebp)
c0105cca:	89 5d e0             	mov    %ebx,-0x20(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105ccd:	8b 45 e8             	mov    -0x18(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105cd0:	83 c4 24             	add    $0x24,%esp
c0105cd3:	5b                   	pop    %ebx
c0105cd4:	5e                   	pop    %esi
c0105cd5:	5f                   	pop    %edi
c0105cd6:	5d                   	pop    %ebp
c0105cd7:	c3                   	ret    

c0105cd8 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105cd8:	55                   	push   %ebp
c0105cd9:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105cdb:	eb 0c                	jmp    c0105ce9 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105cdd:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105ce1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105ce5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105ce9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105ced:	74 1a                	je     c0105d09 <strncmp+0x31>
c0105cef:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cf2:	0f b6 00             	movzbl (%eax),%eax
c0105cf5:	84 c0                	test   %al,%al
c0105cf7:	74 10                	je     c0105d09 <strncmp+0x31>
c0105cf9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cfc:	0f b6 10             	movzbl (%eax),%edx
c0105cff:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d02:	0f b6 00             	movzbl (%eax),%eax
c0105d05:	38 c2                	cmp    %al,%dl
c0105d07:	74 d4                	je     c0105cdd <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105d09:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d0d:	74 1a                	je     c0105d29 <strncmp+0x51>
c0105d0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d12:	0f b6 00             	movzbl (%eax),%eax
c0105d15:	0f b6 d0             	movzbl %al,%edx
c0105d18:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d1b:	0f b6 00             	movzbl (%eax),%eax
c0105d1e:	0f b6 c0             	movzbl %al,%eax
c0105d21:	89 d1                	mov    %edx,%ecx
c0105d23:	29 c1                	sub    %eax,%ecx
c0105d25:	89 c8                	mov    %ecx,%eax
c0105d27:	eb 05                	jmp    c0105d2e <strncmp+0x56>
c0105d29:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105d2e:	5d                   	pop    %ebp
c0105d2f:	c3                   	ret    

c0105d30 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105d30:	55                   	push   %ebp
c0105d31:	89 e5                	mov    %esp,%ebp
c0105d33:	83 ec 04             	sub    $0x4,%esp
c0105d36:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d39:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105d3c:	eb 14                	jmp    c0105d52 <strchr+0x22>
        if (*s == c) {
c0105d3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d41:	0f b6 00             	movzbl (%eax),%eax
c0105d44:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105d47:	75 05                	jne    c0105d4e <strchr+0x1e>
            return (char *)s;
c0105d49:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d4c:	eb 13                	jmp    c0105d61 <strchr+0x31>
        }
        s ++;
c0105d4e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105d52:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d55:	0f b6 00             	movzbl (%eax),%eax
c0105d58:	84 c0                	test   %al,%al
c0105d5a:	75 e2                	jne    c0105d3e <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105d5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105d61:	c9                   	leave  
c0105d62:	c3                   	ret    

c0105d63 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105d63:	55                   	push   %ebp
c0105d64:	89 e5                	mov    %esp,%ebp
c0105d66:	83 ec 04             	sub    $0x4,%esp
c0105d69:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d6c:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105d6f:	eb 0f                	jmp    c0105d80 <strfind+0x1d>
        if (*s == c) {
c0105d71:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d74:	0f b6 00             	movzbl (%eax),%eax
c0105d77:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105d7a:	74 10                	je     c0105d8c <strfind+0x29>
            break;
        }
        s ++;
c0105d7c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105d80:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d83:	0f b6 00             	movzbl (%eax),%eax
c0105d86:	84 c0                	test   %al,%al
c0105d88:	75 e7                	jne    c0105d71 <strfind+0xe>
c0105d8a:	eb 01                	jmp    c0105d8d <strfind+0x2a>
        if (*s == c) {
            break;
c0105d8c:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
c0105d8d:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105d90:	c9                   	leave  
c0105d91:	c3                   	ret    

c0105d92 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105d92:	55                   	push   %ebp
c0105d93:	89 e5                	mov    %esp,%ebp
c0105d95:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105d98:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105d9f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105da6:	eb 04                	jmp    c0105dac <strtol+0x1a>
        s ++;
c0105da8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105dac:	8b 45 08             	mov    0x8(%ebp),%eax
c0105daf:	0f b6 00             	movzbl (%eax),%eax
c0105db2:	3c 20                	cmp    $0x20,%al
c0105db4:	74 f2                	je     c0105da8 <strtol+0x16>
c0105db6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105db9:	0f b6 00             	movzbl (%eax),%eax
c0105dbc:	3c 09                	cmp    $0x9,%al
c0105dbe:	74 e8                	je     c0105da8 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105dc0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dc3:	0f b6 00             	movzbl (%eax),%eax
c0105dc6:	3c 2b                	cmp    $0x2b,%al
c0105dc8:	75 06                	jne    c0105dd0 <strtol+0x3e>
        s ++;
c0105dca:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105dce:	eb 15                	jmp    c0105de5 <strtol+0x53>
    }
    else if (*s == '-') {
c0105dd0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dd3:	0f b6 00             	movzbl (%eax),%eax
c0105dd6:	3c 2d                	cmp    $0x2d,%al
c0105dd8:	75 0b                	jne    c0105de5 <strtol+0x53>
        s ++, neg = 1;
c0105dda:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105dde:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105de5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105de9:	74 06                	je     c0105df1 <strtol+0x5f>
c0105deb:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105def:	75 24                	jne    c0105e15 <strtol+0x83>
c0105df1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105df4:	0f b6 00             	movzbl (%eax),%eax
c0105df7:	3c 30                	cmp    $0x30,%al
c0105df9:	75 1a                	jne    c0105e15 <strtol+0x83>
c0105dfb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dfe:	83 c0 01             	add    $0x1,%eax
c0105e01:	0f b6 00             	movzbl (%eax),%eax
c0105e04:	3c 78                	cmp    $0x78,%al
c0105e06:	75 0d                	jne    c0105e15 <strtol+0x83>
        s += 2, base = 16;
c0105e08:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105e0c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105e13:	eb 2a                	jmp    c0105e3f <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105e15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105e19:	75 17                	jne    c0105e32 <strtol+0xa0>
c0105e1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e1e:	0f b6 00             	movzbl (%eax),%eax
c0105e21:	3c 30                	cmp    $0x30,%al
c0105e23:	75 0d                	jne    c0105e32 <strtol+0xa0>
        s ++, base = 8;
c0105e25:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105e29:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105e30:	eb 0d                	jmp    c0105e3f <strtol+0xad>
    }
    else if (base == 0) {
c0105e32:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105e36:	75 07                	jne    c0105e3f <strtol+0xad>
        base = 10;
c0105e38:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105e3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e42:	0f b6 00             	movzbl (%eax),%eax
c0105e45:	3c 2f                	cmp    $0x2f,%al
c0105e47:	7e 1b                	jle    c0105e64 <strtol+0xd2>
c0105e49:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e4c:	0f b6 00             	movzbl (%eax),%eax
c0105e4f:	3c 39                	cmp    $0x39,%al
c0105e51:	7f 11                	jg     c0105e64 <strtol+0xd2>
            dig = *s - '0';
c0105e53:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e56:	0f b6 00             	movzbl (%eax),%eax
c0105e59:	0f be c0             	movsbl %al,%eax
c0105e5c:	83 e8 30             	sub    $0x30,%eax
c0105e5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105e62:	eb 48                	jmp    c0105eac <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105e64:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e67:	0f b6 00             	movzbl (%eax),%eax
c0105e6a:	3c 60                	cmp    $0x60,%al
c0105e6c:	7e 1b                	jle    c0105e89 <strtol+0xf7>
c0105e6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e71:	0f b6 00             	movzbl (%eax),%eax
c0105e74:	3c 7a                	cmp    $0x7a,%al
c0105e76:	7f 11                	jg     c0105e89 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105e78:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e7b:	0f b6 00             	movzbl (%eax),%eax
c0105e7e:	0f be c0             	movsbl %al,%eax
c0105e81:	83 e8 57             	sub    $0x57,%eax
c0105e84:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105e87:	eb 23                	jmp    c0105eac <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105e89:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e8c:	0f b6 00             	movzbl (%eax),%eax
c0105e8f:	3c 40                	cmp    $0x40,%al
c0105e91:	7e 38                	jle    c0105ecb <strtol+0x139>
c0105e93:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e96:	0f b6 00             	movzbl (%eax),%eax
c0105e99:	3c 5a                	cmp    $0x5a,%al
c0105e9b:	7f 2e                	jg     c0105ecb <strtol+0x139>
            dig = *s - 'A' + 10;
c0105e9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ea0:	0f b6 00             	movzbl (%eax),%eax
c0105ea3:	0f be c0             	movsbl %al,%eax
c0105ea6:	83 e8 37             	sub    $0x37,%eax
c0105ea9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105eaf:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105eb2:	7d 16                	jge    c0105eca <strtol+0x138>
            break;
        }
        s ++, val = (val * base) + dig;
c0105eb4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105eb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105ebb:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105ebf:	03 45 f4             	add    -0xc(%ebp),%eax
c0105ec2:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0105ec5:	e9 75 ff ff ff       	jmp    c0105e3f <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
c0105eca:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
c0105ecb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105ecf:	74 08                	je     c0105ed9 <strtol+0x147>
        *endptr = (char *) s;
c0105ed1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ed4:	8b 55 08             	mov    0x8(%ebp),%edx
c0105ed7:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105ed9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105edd:	74 07                	je     c0105ee6 <strtol+0x154>
c0105edf:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105ee2:	f7 d8                	neg    %eax
c0105ee4:	eb 03                	jmp    c0105ee9 <strtol+0x157>
c0105ee6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105ee9:	c9                   	leave  
c0105eea:	c3                   	ret    

c0105eeb <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105eeb:	55                   	push   %ebp
c0105eec:	89 e5                	mov    %esp,%ebp
c0105eee:	57                   	push   %edi
c0105eef:	56                   	push   %esi
c0105ef0:	53                   	push   %ebx
c0105ef1:	83 ec 24             	sub    $0x24,%esp
c0105ef4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ef7:	88 45 d0             	mov    %al,-0x30(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105efa:	0f be 45 d0          	movsbl -0x30(%ebp),%eax
c0105efe:	8b 55 08             	mov    0x8(%ebp),%edx
c0105f01:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0105f04:	88 45 ef             	mov    %al,-0x11(%ebp)
c0105f07:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f0a:	89 45 e8             	mov    %eax,-0x18(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105f0d:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0105f10:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c0105f14:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105f17:	89 ce                	mov    %ecx,%esi
c0105f19:	89 d3                	mov    %edx,%ebx
c0105f1b:	89 f1                	mov    %esi,%ecx
c0105f1d:	89 df                	mov    %ebx,%edi
c0105f1f:	f3 aa                	rep stos %al,%es:(%edi)
c0105f21:	89 fb                	mov    %edi,%ebx
c0105f23:	89 ce                	mov    %ecx,%esi
c0105f25:	89 75 e4             	mov    %esi,-0x1c(%ebp)
c0105f28:	89 5d e0             	mov    %ebx,-0x20(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105f2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105f2e:	83 c4 24             	add    $0x24,%esp
c0105f31:	5b                   	pop    %ebx
c0105f32:	5e                   	pop    %esi
c0105f33:	5f                   	pop    %edi
c0105f34:	5d                   	pop    %ebp
c0105f35:	c3                   	ret    

c0105f36 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105f36:	55                   	push   %ebp
c0105f37:	89 e5                	mov    %esp,%ebp
c0105f39:	57                   	push   %edi
c0105f3a:	56                   	push   %esi
c0105f3b:	53                   	push   %ebx
c0105f3c:	83 ec 38             	sub    $0x38,%esp
c0105f3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f42:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105f45:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f48:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105f4b:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f4e:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105f51:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f54:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105f57:	73 4e                	jae    c0105fa7 <memmove+0x71>
c0105f59:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f5c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105f5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105f62:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105f65:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105f68:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105f6b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105f6e:	89 c1                	mov    %eax,%ecx
c0105f70:	c1 e9 02             	shr    $0x2,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105f73:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105f76:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105f79:	89 4d c0             	mov    %ecx,-0x40(%ebp)
c0105f7c:	89 d7                	mov    %edx,%edi
c0105f7e:	89 c3                	mov    %eax,%ebx
c0105f80:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c0105f83:	89 de                	mov    %ebx,%esi
c0105f85:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105f87:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105f8a:	83 e1 03             	and    $0x3,%ecx
c0105f8d:	74 02                	je     c0105f91 <memmove+0x5b>
c0105f8f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105f91:	89 f3                	mov    %esi,%ebx
c0105f93:	89 4d c0             	mov    %ecx,-0x40(%ebp)
c0105f96:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c0105f99:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105f9c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
c0105f9f:	89 5d d0             	mov    %ebx,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105fa2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105fa5:	eb 3b                	jmp    c0105fe2 <memmove+0xac>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105fa7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105faa:	83 e8 01             	sub    $0x1,%eax
c0105fad:	89 c2                	mov    %eax,%edx
c0105faf:	03 55 ec             	add    -0x14(%ebp),%edx
c0105fb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105fb5:	83 e8 01             	sub    $0x1,%eax
c0105fb8:	03 45 f0             	add    -0x10(%ebp),%eax
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0105fbb:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0105fbe:	89 4d bc             	mov    %ecx,-0x44(%ebp)
c0105fc1:	89 d6                	mov    %edx,%esi
c0105fc3:	89 c3                	mov    %eax,%ebx
c0105fc5:	8b 4d bc             	mov    -0x44(%ebp),%ecx
c0105fc8:	89 df                	mov    %ebx,%edi
c0105fca:	fd                   	std    
c0105fcb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105fcd:	fc                   	cld    
c0105fce:	89 fb                	mov    %edi,%ebx
c0105fd0:	89 4d bc             	mov    %ecx,-0x44(%ebp)
c0105fd3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
c0105fd6:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105fd9:	89 75 c8             	mov    %esi,-0x38(%ebp)
c0105fdc:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0105fdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105fe2:	83 c4 38             	add    $0x38,%esp
c0105fe5:	5b                   	pop    %ebx
c0105fe6:	5e                   	pop    %esi
c0105fe7:	5f                   	pop    %edi
c0105fe8:	5d                   	pop    %ebp
c0105fe9:	c3                   	ret    

c0105fea <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105fea:	55                   	push   %ebp
c0105feb:	89 e5                	mov    %esp,%ebp
c0105fed:	57                   	push   %edi
c0105fee:	56                   	push   %esi
c0105fef:	53                   	push   %ebx
c0105ff0:	83 ec 24             	sub    $0x24,%esp
c0105ff3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ff6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ff9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ffc:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105fff:	8b 45 10             	mov    0x10(%ebp),%eax
c0106002:	89 45 e8             	mov    %eax,-0x18(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0106005:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106008:	89 c1                	mov    %eax,%ecx
c010600a:	c1 e9 02             	shr    $0x2,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c010600d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106010:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106013:	89 4d d0             	mov    %ecx,-0x30(%ebp)
c0106016:	89 d7                	mov    %edx,%edi
c0106018:	89 c3                	mov    %eax,%ebx
c010601a:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c010601d:	89 de                	mov    %ebx,%esi
c010601f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0106021:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0106024:	83 e1 03             	and    $0x3,%ecx
c0106027:	74 02                	je     c010602b <memcpy+0x41>
c0106029:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010602b:	89 f3                	mov    %esi,%ebx
c010602d:	89 4d d0             	mov    %ecx,-0x30(%ebp)
c0106030:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0106033:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
c0106036:	89 7d e0             	mov    %edi,-0x20(%ebp)
c0106039:	89 5d dc             	mov    %ebx,-0x24(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c010603c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c010603f:	83 c4 24             	add    $0x24,%esp
c0106042:	5b                   	pop    %ebx
c0106043:	5e                   	pop    %esi
c0106044:	5f                   	pop    %edi
c0106045:	5d                   	pop    %ebp
c0106046:	c3                   	ret    

c0106047 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0106047:	55                   	push   %ebp
c0106048:	89 e5                	mov    %esp,%ebp
c010604a:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c010604d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106050:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0106053:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106056:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0106059:	eb 32                	jmp    c010608d <memcmp+0x46>
        if (*s1 != *s2) {
c010605b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010605e:	0f b6 10             	movzbl (%eax),%edx
c0106061:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0106064:	0f b6 00             	movzbl (%eax),%eax
c0106067:	38 c2                	cmp    %al,%dl
c0106069:	74 1a                	je     c0106085 <memcmp+0x3e>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c010606b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010606e:	0f b6 00             	movzbl (%eax),%eax
c0106071:	0f b6 d0             	movzbl %al,%edx
c0106074:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0106077:	0f b6 00             	movzbl (%eax),%eax
c010607a:	0f b6 c0             	movzbl %al,%eax
c010607d:	89 d1                	mov    %edx,%ecx
c010607f:	29 c1                	sub    %eax,%ecx
c0106081:	89 c8                	mov    %ecx,%eax
c0106083:	eb 1c                	jmp    c01060a1 <memcmp+0x5a>
        }
        s1 ++, s2 ++;
c0106085:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0106089:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c010608d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106091:	0f 95 c0             	setne  %al
c0106094:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0106098:	84 c0                	test   %al,%al
c010609a:	75 bf                	jne    c010605b <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c010609c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01060a1:	c9                   	leave  
c01060a2:	c3                   	ret    
