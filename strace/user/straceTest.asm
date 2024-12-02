
user/_straceTest:     file format elf32-i386


Disassembly of section .text:

00000000 <forktest>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user.h"
#include "kernel/trace.h"

void forktest() {
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	83 ec 18             	sub    $0x18,%esp
    int fr = fork();
   a:	e8 ff 02 00 00       	call   30e <fork>
   f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(fr == 0) {
  12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  16:	75 23                	jne    3b <forktest+0x3b>
        close(open("README.md", 0));
  18:	83 ec 08             	sub    $0x8,%esp
  1b:	6a 00                	push   $0x0
  1d:	68 81 08 00 00       	push   $0x881
  22:	e8 2f 03 00 00       	call   356 <open>
  27:	83 c4 10             	add    $0x10,%esp
  2a:	83 ec 0c             	sub    $0xc,%esp
  2d:	50                   	push   %eax
  2e:	e8 0b 03 00 00       	call   33e <close>
  33:	83 c4 10             	add    $0x10,%esp
        exit();
  36:	e8 db 02 00 00       	call   316 <exit>
    } 
    else {
        wait();
  3b:	e8 de 02 00 00       	call   31e <wait>
    }
}
  40:	90                   	nop
  41:	c9                   	leave  
  42:	c3                   	ret    

00000043 <main>:

int main() {
  43:	f3 0f 1e fb          	endbr32 
  47:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  4b:	83 e4 f0             	and    $0xfffffff0,%esp
  4e:	ff 71 fc             	pushl  -0x4(%ecx)
  51:	55                   	push   %ebp
  52:	89 e5                	mov    %esp,%ebp
  54:	51                   	push   %ecx
  55:	83 ec 04             	sub    $0x4,%esp
    trace(T_TRACE);
  58:	83 ec 0c             	sub    $0xc,%esp
  5b:	6a 01                	push   $0x1
  5d:	e8 54 03 00 00       	call   3b6 <trace>
  62:	83 c4 10             	add    $0x10,%esp
    forktest();
  65:	e8 96 ff ff ff       	call   0 <forktest>
    trace(T_UNTRACE);
  6a:	83 ec 0c             	sub    $0xc,%esp
  6d:	6a 00                	push   $0x0
  6f:	e8 42 03 00 00       	call   3b6 <trace>
  74:	83 c4 10             	add    $0x10,%esp

    trace(T_TRACE | T_ONFORK);
  77:	83 ec 0c             	sub    $0xc,%esp
  7a:	6a 03                	push   $0x3
  7c:	e8 35 03 00 00       	call   3b6 <trace>
  81:	83 c4 10             	add    $0x10,%esp
    forktest();
  84:	e8 77 ff ff ff       	call   0 <forktest>

    trace(T_UNTRACE);
  89:	83 ec 0c             	sub    $0xc,%esp
  8c:	6a 00                	push   $0x0
  8e:	e8 23 03 00 00       	call   3b6 <trace>
  93:	83 c4 10             	add    $0x10,%esp

    exit();
  96:	e8 7b 02 00 00       	call   316 <exit>

0000009b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  9b:	55                   	push   %ebp
  9c:	89 e5                	mov    %esp,%ebp
  9e:	57                   	push   %edi
  9f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  a3:	8b 55 10             	mov    0x10(%ebp),%edx
  a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  a9:	89 cb                	mov    %ecx,%ebx
  ab:	89 df                	mov    %ebx,%edi
  ad:	89 d1                	mov    %edx,%ecx
  af:	fc                   	cld    
  b0:	f3 aa                	rep stos %al,%es:(%edi)
  b2:	89 ca                	mov    %ecx,%edx
  b4:	89 fb                	mov    %edi,%ebx
  b6:	89 5d 08             	mov    %ebx,0x8(%ebp)
  b9:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  bc:	90                   	nop
  bd:	5b                   	pop    %ebx
  be:	5f                   	pop    %edi
  bf:	5d                   	pop    %ebp
  c0:	c3                   	ret    

000000c1 <strcpy>:
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user.h"
#include "kernel/x86.h"

char *strcpy(char *s, char *t) {
  c1:	f3 0f 1e fb          	endbr32 
  c5:	55                   	push   %ebp
  c6:	89 e5                	mov    %esp,%ebp
  c8:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  cb:	8b 45 08             	mov    0x8(%ebp),%eax
  ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while ((*s++ = *t++) != 0)
  d1:	90                   	nop
  d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  d5:	8d 42 01             	lea    0x1(%edx),%eax
  d8:	89 45 0c             	mov    %eax,0xc(%ebp)
  db:	8b 45 08             	mov    0x8(%ebp),%eax
  de:	8d 48 01             	lea    0x1(%eax),%ecx
  e1:	89 4d 08             	mov    %ecx,0x8(%ebp)
  e4:	0f b6 12             	movzbl (%edx),%edx
  e7:	88 10                	mov    %dl,(%eax)
  e9:	0f b6 00             	movzbl (%eax),%eax
  ec:	84 c0                	test   %al,%al
  ee:	75 e2                	jne    d2 <strcpy+0x11>
    ;
  return os;
  f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  f3:	c9                   	leave  
  f4:	c3                   	ret    

000000f5 <strcmp>:

int strcmp(const char *p, const char *q) {
  f5:	f3 0f 1e fb          	endbr32 
  f9:	55                   	push   %ebp
  fa:	89 e5                	mov    %esp,%ebp
  while (*p && *p == *q)
  fc:	eb 08                	jmp    106 <strcmp+0x11>
    p++, q++;
  fe:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 102:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while (*p && *p == *q)
 106:	8b 45 08             	mov    0x8(%ebp),%eax
 109:	0f b6 00             	movzbl (%eax),%eax
 10c:	84 c0                	test   %al,%al
 10e:	74 10                	je     120 <strcmp+0x2b>
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	0f b6 10             	movzbl (%eax),%edx
 116:	8b 45 0c             	mov    0xc(%ebp),%eax
 119:	0f b6 00             	movzbl (%eax),%eax
 11c:	38 c2                	cmp    %al,%dl
 11e:	74 de                	je     fe <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
 120:	8b 45 08             	mov    0x8(%ebp),%eax
 123:	0f b6 00             	movzbl (%eax),%eax
 126:	0f b6 d0             	movzbl %al,%edx
 129:	8b 45 0c             	mov    0xc(%ebp),%eax
 12c:	0f b6 00             	movzbl (%eax),%eax
 12f:	0f b6 c0             	movzbl %al,%eax
 132:	29 c2                	sub    %eax,%edx
 134:	89 d0                	mov    %edx,%eax
}
 136:	5d                   	pop    %ebp
 137:	c3                   	ret    

00000138 <strlen>:

uint strlen(char *s) {
 138:	f3 0f 1e fb          	endbr32 
 13c:	55                   	push   %ebp
 13d:	89 e5                	mov    %esp,%ebp
 13f:	83 ec 10             	sub    $0x10,%esp
  int n;

  for (n = 0; s[n]; n++)
 142:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 149:	eb 04                	jmp    14f <strlen+0x17>
 14b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 14f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 152:	8b 45 08             	mov    0x8(%ebp),%eax
 155:	01 d0                	add    %edx,%eax
 157:	0f b6 00             	movzbl (%eax),%eax
 15a:	84 c0                	test   %al,%al
 15c:	75 ed                	jne    14b <strlen+0x13>
    ;
  return n;
 15e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 161:	c9                   	leave  
 162:	c3                   	ret    

00000163 <memset>:

void *memset(void *dst, int c, uint n) {
 163:	f3 0f 1e fb          	endbr32 
 167:	55                   	push   %ebp
 168:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 16a:	8b 45 10             	mov    0x10(%ebp),%eax
 16d:	50                   	push   %eax
 16e:	ff 75 0c             	pushl  0xc(%ebp)
 171:	ff 75 08             	pushl  0x8(%ebp)
 174:	e8 22 ff ff ff       	call   9b <stosb>
 179:	83 c4 0c             	add    $0xc,%esp
  return dst;
 17c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 17f:	c9                   	leave  
 180:	c3                   	ret    

00000181 <strchr>:

char *strchr(const char *s, char c) {
 181:	f3 0f 1e fb          	endbr32 
 185:	55                   	push   %ebp
 186:	89 e5                	mov    %esp,%ebp
 188:	83 ec 04             	sub    $0x4,%esp
 18b:	8b 45 0c             	mov    0xc(%ebp),%eax
 18e:	88 45 fc             	mov    %al,-0x4(%ebp)
  for (; *s; s++)
 191:	eb 14                	jmp    1a7 <strchr+0x26>
    if (*s == c)
 193:	8b 45 08             	mov    0x8(%ebp),%eax
 196:	0f b6 00             	movzbl (%eax),%eax
 199:	38 45 fc             	cmp    %al,-0x4(%ebp)
 19c:	75 05                	jne    1a3 <strchr+0x22>
      return (char *)s;
 19e:	8b 45 08             	mov    0x8(%ebp),%eax
 1a1:	eb 13                	jmp    1b6 <strchr+0x35>
  for (; *s; s++)
 1a3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1a7:	8b 45 08             	mov    0x8(%ebp),%eax
 1aa:	0f b6 00             	movzbl (%eax),%eax
 1ad:	84 c0                	test   %al,%al
 1af:	75 e2                	jne    193 <strchr+0x12>
  return 0;
 1b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1b6:	c9                   	leave  
 1b7:	c3                   	ret    

000001b8 <gets>:

char *gets(char *buf, int max) {
 1b8:	f3 0f 1e fb          	endbr32 
 1bc:	55                   	push   %ebp
 1bd:	89 e5                	mov    %esp,%ebp
 1bf:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 1c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1c9:	eb 42                	jmp    20d <gets+0x55>
    cc = read(0, &c, 1);
 1cb:	83 ec 04             	sub    $0x4,%esp
 1ce:	6a 01                	push   $0x1
 1d0:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1d3:	50                   	push   %eax
 1d4:	6a 00                	push   $0x0
 1d6:	e8 53 01 00 00       	call   32e <read>
 1db:	83 c4 10             	add    $0x10,%esp
 1de:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (cc < 1)
 1e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1e5:	7e 33                	jle    21a <gets+0x62>
      break;
    buf[i++] = c;
 1e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ea:	8d 50 01             	lea    0x1(%eax),%edx
 1ed:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1f0:	89 c2                	mov    %eax,%edx
 1f2:	8b 45 08             	mov    0x8(%ebp),%eax
 1f5:	01 c2                	add    %eax,%edx
 1f7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1fb:	88 02                	mov    %al,(%edx)
    if (c == '\n' || c == '\r')
 1fd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 201:	3c 0a                	cmp    $0xa,%al
 203:	74 16                	je     21b <gets+0x63>
 205:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 209:	3c 0d                	cmp    $0xd,%al
 20b:	74 0e                	je     21b <gets+0x63>
  for (i = 0; i + 1 < max;) {
 20d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 210:	83 c0 01             	add    $0x1,%eax
 213:	39 45 0c             	cmp    %eax,0xc(%ebp)
 216:	7f b3                	jg     1cb <gets+0x13>
 218:	eb 01                	jmp    21b <gets+0x63>
      break;
 21a:	90                   	nop
      break;
  }
  buf[i] = '\0';
 21b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 21e:	8b 45 08             	mov    0x8(%ebp),%eax
 221:	01 d0                	add    %edx,%eax
 223:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 226:	8b 45 08             	mov    0x8(%ebp),%eax
}
 229:	c9                   	leave  
 22a:	c3                   	ret    

0000022b <stat>:

int stat(char *n, struct stat *st) {
 22b:	f3 0f 1e fb          	endbr32 
 22f:	55                   	push   %ebp
 230:	89 e5                	mov    %esp,%ebp
 232:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 235:	83 ec 08             	sub    $0x8,%esp
 238:	6a 00                	push   $0x0
 23a:	ff 75 08             	pushl  0x8(%ebp)
 23d:	e8 14 01 00 00       	call   356 <open>
 242:	83 c4 10             	add    $0x10,%esp
 245:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (fd < 0)
 248:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 24c:	79 07                	jns    255 <stat+0x2a>
    return -1;
 24e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 253:	eb 25                	jmp    27a <stat+0x4f>
  r = fstat(fd, st);
 255:	83 ec 08             	sub    $0x8,%esp
 258:	ff 75 0c             	pushl  0xc(%ebp)
 25b:	ff 75 f4             	pushl  -0xc(%ebp)
 25e:	e8 0b 01 00 00       	call   36e <fstat>
 263:	83 c4 10             	add    $0x10,%esp
 266:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 269:	83 ec 0c             	sub    $0xc,%esp
 26c:	ff 75 f4             	pushl  -0xc(%ebp)
 26f:	e8 ca 00 00 00       	call   33e <close>
 274:	83 c4 10             	add    $0x10,%esp
  return r;
 277:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 27a:	c9                   	leave  
 27b:	c3                   	ret    

0000027c <atoi>:

int atoi(const char *s) {
 27c:	f3 0f 1e fb          	endbr32 
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 286:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while ('0' <= *s && *s <= '9')
 28d:	eb 25                	jmp    2b4 <atoi+0x38>
    n = n * 10 + *s++ - '0';
 28f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 292:	89 d0                	mov    %edx,%eax
 294:	c1 e0 02             	shl    $0x2,%eax
 297:	01 d0                	add    %edx,%eax
 299:	01 c0                	add    %eax,%eax
 29b:	89 c1                	mov    %eax,%ecx
 29d:	8b 45 08             	mov    0x8(%ebp),%eax
 2a0:	8d 50 01             	lea    0x1(%eax),%edx
 2a3:	89 55 08             	mov    %edx,0x8(%ebp)
 2a6:	0f b6 00             	movzbl (%eax),%eax
 2a9:	0f be c0             	movsbl %al,%eax
 2ac:	01 c8                	add    %ecx,%eax
 2ae:	83 e8 30             	sub    $0x30,%eax
 2b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while ('0' <= *s && *s <= '9')
 2b4:	8b 45 08             	mov    0x8(%ebp),%eax
 2b7:	0f b6 00             	movzbl (%eax),%eax
 2ba:	3c 2f                	cmp    $0x2f,%al
 2bc:	7e 0a                	jle    2c8 <atoi+0x4c>
 2be:	8b 45 08             	mov    0x8(%ebp),%eax
 2c1:	0f b6 00             	movzbl (%eax),%eax
 2c4:	3c 39                	cmp    $0x39,%al
 2c6:	7e c7                	jle    28f <atoi+0x13>
  return n;
 2c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2cb:	c9                   	leave  
 2cc:	c3                   	ret    

000002cd <memmove>:

void *memmove(void *vdst, void *vsrc, int n) {
 2cd:	f3 0f 1e fb          	endbr32 
 2d1:	55                   	push   %ebp
 2d2:	89 e5                	mov    %esp,%ebp
 2d4:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 2d7:	8b 45 08             	mov    0x8(%ebp),%eax
 2da:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while (n-- > 0)
 2e3:	eb 17                	jmp    2fc <memmove+0x2f>
    *dst++ = *src++;
 2e5:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2e8:	8d 42 01             	lea    0x1(%edx),%eax
 2eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
 2ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2f1:	8d 48 01             	lea    0x1(%eax),%ecx
 2f4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 2f7:	0f b6 12             	movzbl (%edx),%edx
 2fa:	88 10                	mov    %dl,(%eax)
  while (n-- > 0)
 2fc:	8b 45 10             	mov    0x10(%ebp),%eax
 2ff:	8d 50 ff             	lea    -0x1(%eax),%edx
 302:	89 55 10             	mov    %edx,0x10(%ebp)
 305:	85 c0                	test   %eax,%eax
 307:	7f dc                	jg     2e5 <memmove+0x18>
  return vdst;
 309:	8b 45 08             	mov    0x8(%ebp),%eax
}
 30c:	c9                   	leave  
 30d:	c3                   	ret    

0000030e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 30e:	b8 01 00 00 00       	mov    $0x1,%eax
 313:	cd 40                	int    $0x40
 315:	c3                   	ret    

00000316 <exit>:
SYSCALL(exit)
 316:	b8 02 00 00 00       	mov    $0x2,%eax
 31b:	cd 40                	int    $0x40
 31d:	c3                   	ret    

0000031e <wait>:
SYSCALL(wait)
 31e:	b8 03 00 00 00       	mov    $0x3,%eax
 323:	cd 40                	int    $0x40
 325:	c3                   	ret    

00000326 <pipe>:
SYSCALL(pipe)
 326:	b8 04 00 00 00       	mov    $0x4,%eax
 32b:	cd 40                	int    $0x40
 32d:	c3                   	ret    

0000032e <read>:
SYSCALL(read)
 32e:	b8 05 00 00 00       	mov    $0x5,%eax
 333:	cd 40                	int    $0x40
 335:	c3                   	ret    

00000336 <write>:
SYSCALL(write)
 336:	b8 10 00 00 00       	mov    $0x10,%eax
 33b:	cd 40                	int    $0x40
 33d:	c3                   	ret    

0000033e <close>:
SYSCALL(close)
 33e:	b8 15 00 00 00       	mov    $0x15,%eax
 343:	cd 40                	int    $0x40
 345:	c3                   	ret    

00000346 <kill>:
SYSCALL(kill)
 346:	b8 06 00 00 00       	mov    $0x6,%eax
 34b:	cd 40                	int    $0x40
 34d:	c3                   	ret    

0000034e <exec>:
SYSCALL(exec)
 34e:	b8 07 00 00 00       	mov    $0x7,%eax
 353:	cd 40                	int    $0x40
 355:	c3                   	ret    

00000356 <open>:
SYSCALL(open)
 356:	b8 0f 00 00 00       	mov    $0xf,%eax
 35b:	cd 40                	int    $0x40
 35d:	c3                   	ret    

0000035e <mknod>:
SYSCALL(mknod)
 35e:	b8 11 00 00 00       	mov    $0x11,%eax
 363:	cd 40                	int    $0x40
 365:	c3                   	ret    

00000366 <unlink>:
SYSCALL(unlink)
 366:	b8 12 00 00 00       	mov    $0x12,%eax
 36b:	cd 40                	int    $0x40
 36d:	c3                   	ret    

0000036e <fstat>:
SYSCALL(fstat)
 36e:	b8 08 00 00 00       	mov    $0x8,%eax
 373:	cd 40                	int    $0x40
 375:	c3                   	ret    

00000376 <link>:
SYSCALL(link)
 376:	b8 13 00 00 00       	mov    $0x13,%eax
 37b:	cd 40                	int    $0x40
 37d:	c3                   	ret    

0000037e <mkdir>:
SYSCALL(mkdir)
 37e:	b8 14 00 00 00       	mov    $0x14,%eax
 383:	cd 40                	int    $0x40
 385:	c3                   	ret    

00000386 <chdir>:
SYSCALL(chdir)
 386:	b8 09 00 00 00       	mov    $0x9,%eax
 38b:	cd 40                	int    $0x40
 38d:	c3                   	ret    

0000038e <dup>:
SYSCALL(dup)
 38e:	b8 0a 00 00 00       	mov    $0xa,%eax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret    

00000396 <getpid>:
SYSCALL(getpid)
 396:	b8 0b 00 00 00       	mov    $0xb,%eax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret    

0000039e <sbrk>:
SYSCALL(sbrk)
 39e:	b8 0c 00 00 00       	mov    $0xc,%eax
 3a3:	cd 40                	int    $0x40
 3a5:	c3                   	ret    

000003a6 <sleep>:
SYSCALL(sleep)
 3a6:	b8 0d 00 00 00       	mov    $0xd,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret    

000003ae <uptime>:
SYSCALL(uptime)
 3ae:	b8 0e 00 00 00       	mov    $0xe,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret    

000003b6 <trace>:
SYSCALL(trace)
 3b6:	b8 16 00 00 00       	mov    $0x16,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret    

000003be <setEFlag>:
SYSCALL(setEFlag)
 3be:	b8 17 00 00 00       	mov    $0x17,%eax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret    

000003c6 <setSFlag>:
SYSCALL(setSFlag)
 3c6:	b8 18 00 00 00       	mov    $0x18,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret    

000003ce <setFFlag>:
SYSCALL(setFFlag)
 3ce:	b8 19 00 00 00       	mov    $0x19,%eax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret    

000003d6 <dump>:
 3d6:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret    

000003de <putc>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user.h"

static void putc(int fd, char c) { write(fd, &c, 1); }
 3de:	f3 0f 1e fb          	endbr32 
 3e2:	55                   	push   %ebp
 3e3:	89 e5                	mov    %esp,%ebp
 3e5:	83 ec 18             	sub    $0x18,%esp
 3e8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3eb:	88 45 f4             	mov    %al,-0xc(%ebp)
 3ee:	83 ec 04             	sub    $0x4,%esp
 3f1:	6a 01                	push   $0x1
 3f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3f6:	50                   	push   %eax
 3f7:	ff 75 08             	pushl  0x8(%ebp)
 3fa:	e8 37 ff ff ff       	call   336 <write>
 3ff:	83 c4 10             	add    $0x10,%esp
 402:	90                   	nop
 403:	c9                   	leave  
 404:	c3                   	ret    

00000405 <printint>:

static void printint(int fd, int xx, int base, int sgn) {
 405:	f3 0f 1e fb          	endbr32 
 409:	55                   	push   %ebp
 40a:	89 e5                	mov    %esp,%ebp
 40c:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 40f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if (sgn && xx < 0) {
 416:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 41a:	74 17                	je     433 <printint+0x2e>
 41c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 420:	79 11                	jns    433 <printint+0x2e>
    neg = 1;
 422:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 429:	8b 45 0c             	mov    0xc(%ebp),%eax
 42c:	f7 d8                	neg    %eax
 42e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 431:	eb 06                	jmp    439 <printint+0x34>
  } else {
    x = xx;
 433:	8b 45 0c             	mov    0xc(%ebp),%eax
 436:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 439:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do {
    buf[i++] = digits[x % base];
 440:	8b 4d 10             	mov    0x10(%ebp),%ecx
 443:	8b 45 ec             	mov    -0x14(%ebp),%eax
 446:	ba 00 00 00 00       	mov    $0x0,%edx
 44b:	f7 f1                	div    %ecx
 44d:	89 d1                	mov    %edx,%ecx
 44f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 452:	8d 50 01             	lea    0x1(%eax),%edx
 455:	89 55 f4             	mov    %edx,-0xc(%ebp)
 458:	0f b6 91 f8 0a 00 00 	movzbl 0xaf8(%ecx),%edx
 45f:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  } while ((x /= base) != 0);
 463:	8b 4d 10             	mov    0x10(%ebp),%ecx
 466:	8b 45 ec             	mov    -0x14(%ebp),%eax
 469:	ba 00 00 00 00       	mov    $0x0,%edx
 46e:	f7 f1                	div    %ecx
 470:	89 45 ec             	mov    %eax,-0x14(%ebp)
 473:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 477:	75 c7                	jne    440 <printint+0x3b>
  if (neg)
 479:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 47d:	74 2d                	je     4ac <printint+0xa7>
    buf[i++] = '-';
 47f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 482:	8d 50 01             	lea    0x1(%eax),%edx
 485:	89 55 f4             	mov    %edx,-0xc(%ebp)
 488:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while (--i >= 0)
 48d:	eb 1d                	jmp    4ac <printint+0xa7>
    putc(fd, buf[i]);
 48f:	8d 55 dc             	lea    -0x24(%ebp),%edx
 492:	8b 45 f4             	mov    -0xc(%ebp),%eax
 495:	01 d0                	add    %edx,%eax
 497:	0f b6 00             	movzbl (%eax),%eax
 49a:	0f be c0             	movsbl %al,%eax
 49d:	83 ec 08             	sub    $0x8,%esp
 4a0:	50                   	push   %eax
 4a1:	ff 75 08             	pushl  0x8(%ebp)
 4a4:	e8 35 ff ff ff       	call   3de <putc>
 4a9:	83 c4 10             	add    $0x10,%esp
  while (--i >= 0)
 4ac:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4b4:	79 d9                	jns    48f <printint+0x8a>
}
 4b6:	90                   	nop
 4b7:	90                   	nop
 4b8:	c9                   	leave  
 4b9:	c3                   	ret    

000004ba <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void printf(int fd, char *fmt, ...) {
 4ba:	f3 0f 1e fb          	endbr32 
 4be:	55                   	push   %ebp
 4bf:	89 e5                	mov    %esp,%ebp
 4c1:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4c4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint *)(void *)&fmt + 1;
 4cb:	8d 45 0c             	lea    0xc(%ebp),%eax
 4ce:	83 c0 04             	add    $0x4,%eax
 4d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for (i = 0; fmt[i]; i++) {
 4d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4db:	e9 59 01 00 00       	jmp    639 <printf+0x17f>
    c = fmt[i] & 0xff;
 4e0:	8b 55 0c             	mov    0xc(%ebp),%edx
 4e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4e6:	01 d0                	add    %edx,%eax
 4e8:	0f b6 00             	movzbl (%eax),%eax
 4eb:	0f be c0             	movsbl %al,%eax
 4ee:	25 ff 00 00 00       	and    $0xff,%eax
 4f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (state == 0) {
 4f6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4fa:	75 2c                	jne    528 <printf+0x6e>
      if (c == '%') {
 4fc:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 500:	75 0c                	jne    50e <printf+0x54>
        state = '%';
 502:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 509:	e9 27 01 00 00       	jmp    635 <printf+0x17b>
      } else {
        putc(fd, c);
 50e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 511:	0f be c0             	movsbl %al,%eax
 514:	83 ec 08             	sub    $0x8,%esp
 517:	50                   	push   %eax
 518:	ff 75 08             	pushl  0x8(%ebp)
 51b:	e8 be fe ff ff       	call   3de <putc>
 520:	83 c4 10             	add    $0x10,%esp
 523:	e9 0d 01 00 00       	jmp    635 <printf+0x17b>
      }
    } else if (state == '%') {
 528:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 52c:	0f 85 03 01 00 00    	jne    635 <printf+0x17b>
      if (c == 'd') {
 532:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 536:	75 1e                	jne    556 <printf+0x9c>
        printint(fd, *ap, 10, 1);
 538:	8b 45 e8             	mov    -0x18(%ebp),%eax
 53b:	8b 00                	mov    (%eax),%eax
 53d:	6a 01                	push   $0x1
 53f:	6a 0a                	push   $0xa
 541:	50                   	push   %eax
 542:	ff 75 08             	pushl  0x8(%ebp)
 545:	e8 bb fe ff ff       	call   405 <printint>
 54a:	83 c4 10             	add    $0x10,%esp
        ap++;
 54d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 551:	e9 d8 00 00 00       	jmp    62e <printf+0x174>
      } else if (c == 'x' || c == 'p') {
 556:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 55a:	74 06                	je     562 <printf+0xa8>
 55c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 560:	75 1e                	jne    580 <printf+0xc6>
        printint(fd, *ap, 16, 0);
 562:	8b 45 e8             	mov    -0x18(%ebp),%eax
 565:	8b 00                	mov    (%eax),%eax
 567:	6a 00                	push   $0x0
 569:	6a 10                	push   $0x10
 56b:	50                   	push   %eax
 56c:	ff 75 08             	pushl  0x8(%ebp)
 56f:	e8 91 fe ff ff       	call   405 <printint>
 574:	83 c4 10             	add    $0x10,%esp
        ap++;
 577:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 57b:	e9 ae 00 00 00       	jmp    62e <printf+0x174>
      } else if (c == 's') {
 580:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 584:	75 43                	jne    5c9 <printf+0x10f>
        s = (char *)*ap;
 586:	8b 45 e8             	mov    -0x18(%ebp),%eax
 589:	8b 00                	mov    (%eax),%eax
 58b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 58e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if (s == 0)
 592:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 596:	75 25                	jne    5bd <printf+0x103>
          s = "(null)";
 598:	c7 45 f4 8b 08 00 00 	movl   $0x88b,-0xc(%ebp)
        while (*s != 0) {
 59f:	eb 1c                	jmp    5bd <printf+0x103>
          putc(fd, *s);
 5a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a4:	0f b6 00             	movzbl (%eax),%eax
 5a7:	0f be c0             	movsbl %al,%eax
 5aa:	83 ec 08             	sub    $0x8,%esp
 5ad:	50                   	push   %eax
 5ae:	ff 75 08             	pushl  0x8(%ebp)
 5b1:	e8 28 fe ff ff       	call   3de <putc>
 5b6:	83 c4 10             	add    $0x10,%esp
          s++;
 5b9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while (*s != 0) {
 5bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5c0:	0f b6 00             	movzbl (%eax),%eax
 5c3:	84 c0                	test   %al,%al
 5c5:	75 da                	jne    5a1 <printf+0xe7>
 5c7:	eb 65                	jmp    62e <printf+0x174>
        }
      } else if (c == 'c') {
 5c9:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5cd:	75 1d                	jne    5ec <printf+0x132>
        putc(fd, *ap);
 5cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d2:	8b 00                	mov    (%eax),%eax
 5d4:	0f be c0             	movsbl %al,%eax
 5d7:	83 ec 08             	sub    $0x8,%esp
 5da:	50                   	push   %eax
 5db:	ff 75 08             	pushl  0x8(%ebp)
 5de:	e8 fb fd ff ff       	call   3de <putc>
 5e3:	83 c4 10             	add    $0x10,%esp
        ap++;
 5e6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ea:	eb 42                	jmp    62e <printf+0x174>
      } else if (c == '%') {
 5ec:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5f0:	75 17                	jne    609 <printf+0x14f>
        putc(fd, c);
 5f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f5:	0f be c0             	movsbl %al,%eax
 5f8:	83 ec 08             	sub    $0x8,%esp
 5fb:	50                   	push   %eax
 5fc:	ff 75 08             	pushl  0x8(%ebp)
 5ff:	e8 da fd ff ff       	call   3de <putc>
 604:	83 c4 10             	add    $0x10,%esp
 607:	eb 25                	jmp    62e <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 609:	83 ec 08             	sub    $0x8,%esp
 60c:	6a 25                	push   $0x25
 60e:	ff 75 08             	pushl  0x8(%ebp)
 611:	e8 c8 fd ff ff       	call   3de <putc>
 616:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 619:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 61c:	0f be c0             	movsbl %al,%eax
 61f:	83 ec 08             	sub    $0x8,%esp
 622:	50                   	push   %eax
 623:	ff 75 08             	pushl  0x8(%ebp)
 626:	e8 b3 fd ff ff       	call   3de <putc>
 62b:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 62e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for (i = 0; fmt[i]; i++) {
 635:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 639:	8b 55 0c             	mov    0xc(%ebp),%edx
 63c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 63f:	01 d0                	add    %edx,%eax
 641:	0f b6 00             	movzbl (%eax),%eax
 644:	84 c0                	test   %al,%al
 646:	0f 85 94 fe ff ff    	jne    4e0 <printf+0x26>
    }
  }
}
 64c:	90                   	nop
 64d:	90                   	nop
 64e:	c9                   	leave  
 64f:	c3                   	ret    

00000650 <free>:
typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
 650:	f3 0f 1e fb          	endbr32 
 654:	55                   	push   %ebp
 655:	89 e5                	mov    %esp,%ebp
 657:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header *)ap - 1;
 65a:	8b 45 08             	mov    0x8(%ebp),%eax
 65d:	83 e8 08             	sub    $0x8,%eax
 660:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 663:	a1 14 0b 00 00       	mov    0xb14,%eax
 668:	89 45 fc             	mov    %eax,-0x4(%ebp)
 66b:	eb 24                	jmp    691 <free+0x41>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 66d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 670:	8b 00                	mov    (%eax),%eax
 672:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 675:	72 12                	jb     689 <free+0x39>
 677:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 67d:	77 24                	ja     6a3 <free+0x53>
 67f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 682:	8b 00                	mov    (%eax),%eax
 684:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 687:	72 1a                	jb     6a3 <free+0x53>
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 689:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68c:	8b 00                	mov    (%eax),%eax
 68e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 691:	8b 45 f8             	mov    -0x8(%ebp),%eax
 694:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 697:	76 d4                	jbe    66d <free+0x1d>
 699:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69c:	8b 00                	mov    (%eax),%eax
 69e:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6a1:	73 ca                	jae    66d <free+0x1d>
      break;
  if (bp + bp->s.size == p->s.ptr) {
 6a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a6:	8b 40 04             	mov    0x4(%eax),%eax
 6a9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b3:	01 c2                	add    %eax,%edx
 6b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b8:	8b 00                	mov    (%eax),%eax
 6ba:	39 c2                	cmp    %eax,%edx
 6bc:	75 24                	jne    6e2 <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 6be:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c1:	8b 50 04             	mov    0x4(%eax),%edx
 6c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c7:	8b 00                	mov    (%eax),%eax
 6c9:	8b 40 04             	mov    0x4(%eax),%eax
 6cc:	01 c2                	add    %eax,%edx
 6ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d7:	8b 00                	mov    (%eax),%eax
 6d9:	8b 10                	mov    (%eax),%edx
 6db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6de:	89 10                	mov    %edx,(%eax)
 6e0:	eb 0a                	jmp    6ec <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 6e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e5:	8b 10                	mov    (%eax),%edx
 6e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ea:	89 10                	mov    %edx,(%eax)
  if (p + p->s.size == bp) {
 6ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ef:	8b 40 04             	mov    0x4(%eax),%eax
 6f2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fc:	01 d0                	add    %edx,%eax
 6fe:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 701:	75 20                	jne    723 <free+0xd3>
    p->s.size += bp->s.size;
 703:	8b 45 fc             	mov    -0x4(%ebp),%eax
 706:	8b 50 04             	mov    0x4(%eax),%edx
 709:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70c:	8b 40 04             	mov    0x4(%eax),%eax
 70f:	01 c2                	add    %eax,%edx
 711:	8b 45 fc             	mov    -0x4(%ebp),%eax
 714:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 717:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71a:	8b 10                	mov    (%eax),%edx
 71c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71f:	89 10                	mov    %edx,(%eax)
 721:	eb 08                	jmp    72b <free+0xdb>
  } else
    p->s.ptr = bp;
 723:	8b 45 fc             	mov    -0x4(%ebp),%eax
 726:	8b 55 f8             	mov    -0x8(%ebp),%edx
 729:	89 10                	mov    %edx,(%eax)
  freep = p;
 72b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72e:	a3 14 0b 00 00       	mov    %eax,0xb14
}
 733:	90                   	nop
 734:	c9                   	leave  
 735:	c3                   	ret    

00000736 <morecore>:

static Header *morecore(uint nu) {
 736:	f3 0f 1e fb          	endbr32 
 73a:	55                   	push   %ebp
 73b:	89 e5                	mov    %esp,%ebp
 73d:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if (nu < 4096)
 740:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 747:	77 07                	ja     750 <morecore+0x1a>
    nu = 4096;
 749:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 750:	8b 45 08             	mov    0x8(%ebp),%eax
 753:	c1 e0 03             	shl    $0x3,%eax
 756:	83 ec 0c             	sub    $0xc,%esp
 759:	50                   	push   %eax
 75a:	e8 3f fc ff ff       	call   39e <sbrk>
 75f:	83 c4 10             	add    $0x10,%esp
 762:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (p == (char *)-1)
 765:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 769:	75 07                	jne    772 <morecore+0x3c>
    return 0;
 76b:	b8 00 00 00 00       	mov    $0x0,%eax
 770:	eb 26                	jmp    798 <morecore+0x62>
  hp = (Header *)p;
 772:	8b 45 f4             	mov    -0xc(%ebp),%eax
 775:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 778:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77b:	8b 55 08             	mov    0x8(%ebp),%edx
 77e:	89 50 04             	mov    %edx,0x4(%eax)
  free((void *)(hp + 1));
 781:	8b 45 f0             	mov    -0x10(%ebp),%eax
 784:	83 c0 08             	add    $0x8,%eax
 787:	83 ec 0c             	sub    $0xc,%esp
 78a:	50                   	push   %eax
 78b:	e8 c0 fe ff ff       	call   650 <free>
 790:	83 c4 10             	add    $0x10,%esp
  return freep;
 793:	a1 14 0b 00 00       	mov    0xb14,%eax
}
 798:	c9                   	leave  
 799:	c3                   	ret    

0000079a <malloc>:

void *malloc(uint nbytes) {
 79a:	f3 0f 1e fb          	endbr32 
 79e:	55                   	push   %ebp
 79f:	89 e5                	mov    %esp,%ebp
 7a1:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 7a4:	8b 45 08             	mov    0x8(%ebp),%eax
 7a7:	83 c0 07             	add    $0x7,%eax
 7aa:	c1 e8 03             	shr    $0x3,%eax
 7ad:	83 c0 01             	add    $0x1,%eax
 7b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if ((prevp = freep) == 0) {
 7b3:	a1 14 0b 00 00       	mov    0xb14,%eax
 7b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7bf:	75 23                	jne    7e4 <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 7c1:	c7 45 f0 0c 0b 00 00 	movl   $0xb0c,-0x10(%ebp)
 7c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7cb:	a3 14 0b 00 00       	mov    %eax,0xb14
 7d0:	a1 14 0b 00 00       	mov    0xb14,%eax
 7d5:	a3 0c 0b 00 00       	mov    %eax,0xb0c
    base.s.size = 0;
 7da:	c7 05 10 0b 00 00 00 	movl   $0x0,0xb10
 7e1:	00 00 00 
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 7e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e7:	8b 00                	mov    (%eax),%eax
 7e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p->s.size >= nunits) {
 7ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ef:	8b 40 04             	mov    0x4(%eax),%eax
 7f2:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7f5:	77 4d                	ja     844 <malloc+0xaa>
      if (p->s.size == nunits)
 7f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fa:	8b 40 04             	mov    0x4(%eax),%eax
 7fd:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 800:	75 0c                	jne    80e <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 802:	8b 45 f4             	mov    -0xc(%ebp),%eax
 805:	8b 10                	mov    (%eax),%edx
 807:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80a:	89 10                	mov    %edx,(%eax)
 80c:	eb 26                	jmp    834 <malloc+0x9a>
      else {
        p->s.size -= nunits;
 80e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 811:	8b 40 04             	mov    0x4(%eax),%eax
 814:	2b 45 ec             	sub    -0x14(%ebp),%eax
 817:	89 c2                	mov    %eax,%edx
 819:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 81f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 822:	8b 40 04             	mov    0x4(%eax),%eax
 825:	c1 e0 03             	shl    $0x3,%eax
 828:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 82b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82e:	8b 55 ec             	mov    -0x14(%ebp),%edx
 831:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 834:	8b 45 f0             	mov    -0x10(%ebp),%eax
 837:	a3 14 0b 00 00       	mov    %eax,0xb14
      return (void *)(p + 1);
 83c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83f:	83 c0 08             	add    $0x8,%eax
 842:	eb 3b                	jmp    87f <malloc+0xe5>
    }
    if (p == freep)
 844:	a1 14 0b 00 00       	mov    0xb14,%eax
 849:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 84c:	75 1e                	jne    86c <malloc+0xd2>
      if ((p = morecore(nunits)) == 0)
 84e:	83 ec 0c             	sub    $0xc,%esp
 851:	ff 75 ec             	pushl  -0x14(%ebp)
 854:	e8 dd fe ff ff       	call   736 <morecore>
 859:	83 c4 10             	add    $0x10,%esp
 85c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 85f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 863:	75 07                	jne    86c <malloc+0xd2>
        return 0;
 865:	b8 00 00 00 00       	mov    $0x0,%eax
 86a:	eb 13                	jmp    87f <malloc+0xe5>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 86c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 872:	8b 45 f4             	mov    -0xc(%ebp),%eax
 875:	8b 00                	mov    (%eax),%eax
 877:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p->s.size >= nunits) {
 87a:	e9 6d ff ff ff       	jmp    7ec <malloc+0x52>
  }
}
 87f:	c9                   	leave  
 880:	c3                   	ret    
