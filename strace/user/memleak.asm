
user/_memleak:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user.h"
#include "kernel/trace.h"

int main() {
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	51                   	push   %ecx
  12:	83 ec 14             	sub    $0x14,%esp
    trace(T_TRACE);
  15:	83 ec 0c             	sub    $0xc,%esp
  18:	6a 01                	push   $0x1
  1a:	e8 45 03 00 00       	call   364 <trace>
  1f:	83 c4 10             	add    $0x10,%esp
    int *data;
    int data_size = sizeof(int) * 10000000;
  22:	c7 45 f4 00 5a 62 02 	movl   $0x2625a00,-0xc(%ebp)

    while(1) {
        data = malloc(data_size);
  29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2c:	83 ec 0c             	sub    $0xc,%esp
  2f:	50                   	push   %eax
  30:	e8 13 07 00 00       	call   748 <malloc>
  35:	83 c4 10             	add    $0x10,%esp
  38:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if(data == 0) break;
  3b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  3f:	74 02                	je     43 <main+0x43>
        data = malloc(data_size);
  41:	eb e6                	jmp    29 <main+0x29>
        if(data == 0) break;
  43:	90                   	nop
    }
    exit();
  44:	e8 7b 02 00 00       	call   2c4 <exit>

00000049 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  49:	55                   	push   %ebp
  4a:	89 e5                	mov    %esp,%ebp
  4c:	57                   	push   %edi
  4d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  4e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  51:	8b 55 10             	mov    0x10(%ebp),%edx
  54:	8b 45 0c             	mov    0xc(%ebp),%eax
  57:	89 cb                	mov    %ecx,%ebx
  59:	89 df                	mov    %ebx,%edi
  5b:	89 d1                	mov    %edx,%ecx
  5d:	fc                   	cld    
  5e:	f3 aa                	rep stos %al,%es:(%edi)
  60:	89 ca                	mov    %ecx,%edx
  62:	89 fb                	mov    %edi,%ebx
  64:	89 5d 08             	mov    %ebx,0x8(%ebp)
  67:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  6a:	90                   	nop
  6b:	5b                   	pop    %ebx
  6c:	5f                   	pop    %edi
  6d:	5d                   	pop    %ebp
  6e:	c3                   	ret    

0000006f <strcpy>:
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user.h"
#include "kernel/x86.h"

char *strcpy(char *s, char *t) {
  6f:	f3 0f 1e fb          	endbr32 
  73:	55                   	push   %ebp
  74:	89 e5                	mov    %esp,%ebp
  76:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  79:	8b 45 08             	mov    0x8(%ebp),%eax
  7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while ((*s++ = *t++) != 0)
  7f:	90                   	nop
  80:	8b 55 0c             	mov    0xc(%ebp),%edx
  83:	8d 42 01             	lea    0x1(%edx),%eax
  86:	89 45 0c             	mov    %eax,0xc(%ebp)
  89:	8b 45 08             	mov    0x8(%ebp),%eax
  8c:	8d 48 01             	lea    0x1(%eax),%ecx
  8f:	89 4d 08             	mov    %ecx,0x8(%ebp)
  92:	0f b6 12             	movzbl (%edx),%edx
  95:	88 10                	mov    %dl,(%eax)
  97:	0f b6 00             	movzbl (%eax),%eax
  9a:	84 c0                	test   %al,%al
  9c:	75 e2                	jne    80 <strcpy+0x11>
    ;
  return os;
  9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  a1:	c9                   	leave  
  a2:	c3                   	ret    

000000a3 <strcmp>:

int strcmp(const char *p, const char *q) {
  a3:	f3 0f 1e fb          	endbr32 
  a7:	55                   	push   %ebp
  a8:	89 e5                	mov    %esp,%ebp
  while (*p && *p == *q)
  aa:	eb 08                	jmp    b4 <strcmp+0x11>
    p++, q++;
  ac:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  b0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while (*p && *p == *q)
  b4:	8b 45 08             	mov    0x8(%ebp),%eax
  b7:	0f b6 00             	movzbl (%eax),%eax
  ba:	84 c0                	test   %al,%al
  bc:	74 10                	je     ce <strcmp+0x2b>
  be:	8b 45 08             	mov    0x8(%ebp),%eax
  c1:	0f b6 10             	movzbl (%eax),%edx
  c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  c7:	0f b6 00             	movzbl (%eax),%eax
  ca:	38 c2                	cmp    %al,%dl
  cc:	74 de                	je     ac <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
  ce:	8b 45 08             	mov    0x8(%ebp),%eax
  d1:	0f b6 00             	movzbl (%eax),%eax
  d4:	0f b6 d0             	movzbl %al,%edx
  d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  da:	0f b6 00             	movzbl (%eax),%eax
  dd:	0f b6 c0             	movzbl %al,%eax
  e0:	29 c2                	sub    %eax,%edx
  e2:	89 d0                	mov    %edx,%eax
}
  e4:	5d                   	pop    %ebp
  e5:	c3                   	ret    

000000e6 <strlen>:

uint strlen(char *s) {
  e6:	f3 0f 1e fb          	endbr32 
  ea:	55                   	push   %ebp
  eb:	89 e5                	mov    %esp,%ebp
  ed:	83 ec 10             	sub    $0x10,%esp
  int n;

  for (n = 0; s[n]; n++)
  f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  f7:	eb 04                	jmp    fd <strlen+0x17>
  f9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
 100:	8b 45 08             	mov    0x8(%ebp),%eax
 103:	01 d0                	add    %edx,%eax
 105:	0f b6 00             	movzbl (%eax),%eax
 108:	84 c0                	test   %al,%al
 10a:	75 ed                	jne    f9 <strlen+0x13>
    ;
  return n;
 10c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 10f:	c9                   	leave  
 110:	c3                   	ret    

00000111 <memset>:

void *memset(void *dst, int c, uint n) {
 111:	f3 0f 1e fb          	endbr32 
 115:	55                   	push   %ebp
 116:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 118:	8b 45 10             	mov    0x10(%ebp),%eax
 11b:	50                   	push   %eax
 11c:	ff 75 0c             	pushl  0xc(%ebp)
 11f:	ff 75 08             	pushl  0x8(%ebp)
 122:	e8 22 ff ff ff       	call   49 <stosb>
 127:	83 c4 0c             	add    $0xc,%esp
  return dst;
 12a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 12d:	c9                   	leave  
 12e:	c3                   	ret    

0000012f <strchr>:

char *strchr(const char *s, char c) {
 12f:	f3 0f 1e fb          	endbr32 
 133:	55                   	push   %ebp
 134:	89 e5                	mov    %esp,%ebp
 136:	83 ec 04             	sub    $0x4,%esp
 139:	8b 45 0c             	mov    0xc(%ebp),%eax
 13c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for (; *s; s++)
 13f:	eb 14                	jmp    155 <strchr+0x26>
    if (*s == c)
 141:	8b 45 08             	mov    0x8(%ebp),%eax
 144:	0f b6 00             	movzbl (%eax),%eax
 147:	38 45 fc             	cmp    %al,-0x4(%ebp)
 14a:	75 05                	jne    151 <strchr+0x22>
      return (char *)s;
 14c:	8b 45 08             	mov    0x8(%ebp),%eax
 14f:	eb 13                	jmp    164 <strchr+0x35>
  for (; *s; s++)
 151:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 155:	8b 45 08             	mov    0x8(%ebp),%eax
 158:	0f b6 00             	movzbl (%eax),%eax
 15b:	84 c0                	test   %al,%al
 15d:	75 e2                	jne    141 <strchr+0x12>
  return 0;
 15f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 164:	c9                   	leave  
 165:	c3                   	ret    

00000166 <gets>:

char *gets(char *buf, int max) {
 166:	f3 0f 1e fb          	endbr32 
 16a:	55                   	push   %ebp
 16b:	89 e5                	mov    %esp,%ebp
 16d:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 170:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 177:	eb 42                	jmp    1bb <gets+0x55>
    cc = read(0, &c, 1);
 179:	83 ec 04             	sub    $0x4,%esp
 17c:	6a 01                	push   $0x1
 17e:	8d 45 ef             	lea    -0x11(%ebp),%eax
 181:	50                   	push   %eax
 182:	6a 00                	push   $0x0
 184:	e8 53 01 00 00       	call   2dc <read>
 189:	83 c4 10             	add    $0x10,%esp
 18c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (cc < 1)
 18f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 193:	7e 33                	jle    1c8 <gets+0x62>
      break;
    buf[i++] = c;
 195:	8b 45 f4             	mov    -0xc(%ebp),%eax
 198:	8d 50 01             	lea    0x1(%eax),%edx
 19b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 19e:	89 c2                	mov    %eax,%edx
 1a0:	8b 45 08             	mov    0x8(%ebp),%eax
 1a3:	01 c2                	add    %eax,%edx
 1a5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1a9:	88 02                	mov    %al,(%edx)
    if (c == '\n' || c == '\r')
 1ab:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1af:	3c 0a                	cmp    $0xa,%al
 1b1:	74 16                	je     1c9 <gets+0x63>
 1b3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1b7:	3c 0d                	cmp    $0xd,%al
 1b9:	74 0e                	je     1c9 <gets+0x63>
  for (i = 0; i + 1 < max;) {
 1bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1be:	83 c0 01             	add    $0x1,%eax
 1c1:	39 45 0c             	cmp    %eax,0xc(%ebp)
 1c4:	7f b3                	jg     179 <gets+0x13>
 1c6:	eb 01                	jmp    1c9 <gets+0x63>
      break;
 1c8:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1cc:	8b 45 08             	mov    0x8(%ebp),%eax
 1cf:	01 d0                	add    %edx,%eax
 1d1:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1d4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1d7:	c9                   	leave  
 1d8:	c3                   	ret    

000001d9 <stat>:

int stat(char *n, struct stat *st) {
 1d9:	f3 0f 1e fb          	endbr32 
 1dd:	55                   	push   %ebp
 1de:	89 e5                	mov    %esp,%ebp
 1e0:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e3:	83 ec 08             	sub    $0x8,%esp
 1e6:	6a 00                	push   $0x0
 1e8:	ff 75 08             	pushl  0x8(%ebp)
 1eb:	e8 14 01 00 00       	call   304 <open>
 1f0:	83 c4 10             	add    $0x10,%esp
 1f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (fd < 0)
 1f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1fa:	79 07                	jns    203 <stat+0x2a>
    return -1;
 1fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 201:	eb 25                	jmp    228 <stat+0x4f>
  r = fstat(fd, st);
 203:	83 ec 08             	sub    $0x8,%esp
 206:	ff 75 0c             	pushl  0xc(%ebp)
 209:	ff 75 f4             	pushl  -0xc(%ebp)
 20c:	e8 0b 01 00 00       	call   31c <fstat>
 211:	83 c4 10             	add    $0x10,%esp
 214:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 217:	83 ec 0c             	sub    $0xc,%esp
 21a:	ff 75 f4             	pushl  -0xc(%ebp)
 21d:	e8 ca 00 00 00       	call   2ec <close>
 222:	83 c4 10             	add    $0x10,%esp
  return r;
 225:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 228:	c9                   	leave  
 229:	c3                   	ret    

0000022a <atoi>:

int atoi(const char *s) {
 22a:	f3 0f 1e fb          	endbr32 
 22e:	55                   	push   %ebp
 22f:	89 e5                	mov    %esp,%ebp
 231:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 234:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while ('0' <= *s && *s <= '9')
 23b:	eb 25                	jmp    262 <atoi+0x38>
    n = n * 10 + *s++ - '0';
 23d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 240:	89 d0                	mov    %edx,%eax
 242:	c1 e0 02             	shl    $0x2,%eax
 245:	01 d0                	add    %edx,%eax
 247:	01 c0                	add    %eax,%eax
 249:	89 c1                	mov    %eax,%ecx
 24b:	8b 45 08             	mov    0x8(%ebp),%eax
 24e:	8d 50 01             	lea    0x1(%eax),%edx
 251:	89 55 08             	mov    %edx,0x8(%ebp)
 254:	0f b6 00             	movzbl (%eax),%eax
 257:	0f be c0             	movsbl %al,%eax
 25a:	01 c8                	add    %ecx,%eax
 25c:	83 e8 30             	sub    $0x30,%eax
 25f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while ('0' <= *s && *s <= '9')
 262:	8b 45 08             	mov    0x8(%ebp),%eax
 265:	0f b6 00             	movzbl (%eax),%eax
 268:	3c 2f                	cmp    $0x2f,%al
 26a:	7e 0a                	jle    276 <atoi+0x4c>
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
 26f:	0f b6 00             	movzbl (%eax),%eax
 272:	3c 39                	cmp    $0x39,%al
 274:	7e c7                	jle    23d <atoi+0x13>
  return n;
 276:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 279:	c9                   	leave  
 27a:	c3                   	ret    

0000027b <memmove>:

void *memmove(void *vdst, void *vsrc, int n) {
 27b:	f3 0f 1e fb          	endbr32 
 27f:	55                   	push   %ebp
 280:	89 e5                	mov    %esp,%ebp
 282:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 285:	8b 45 08             	mov    0x8(%ebp),%eax
 288:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 28b:	8b 45 0c             	mov    0xc(%ebp),%eax
 28e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while (n-- > 0)
 291:	eb 17                	jmp    2aa <memmove+0x2f>
    *dst++ = *src++;
 293:	8b 55 f8             	mov    -0x8(%ebp),%edx
 296:	8d 42 01             	lea    0x1(%edx),%eax
 299:	89 45 f8             	mov    %eax,-0x8(%ebp)
 29c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 29f:	8d 48 01             	lea    0x1(%eax),%ecx
 2a2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 2a5:	0f b6 12             	movzbl (%edx),%edx
 2a8:	88 10                	mov    %dl,(%eax)
  while (n-- > 0)
 2aa:	8b 45 10             	mov    0x10(%ebp),%eax
 2ad:	8d 50 ff             	lea    -0x1(%eax),%edx
 2b0:	89 55 10             	mov    %edx,0x10(%ebp)
 2b3:	85 c0                	test   %eax,%eax
 2b5:	7f dc                	jg     293 <memmove+0x18>
  return vdst;
 2b7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2ba:	c9                   	leave  
 2bb:	c3                   	ret    

000002bc <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2bc:	b8 01 00 00 00       	mov    $0x1,%eax
 2c1:	cd 40                	int    $0x40
 2c3:	c3                   	ret    

000002c4 <exit>:
SYSCALL(exit)
 2c4:	b8 02 00 00 00       	mov    $0x2,%eax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	ret    

000002cc <wait>:
SYSCALL(wait)
 2cc:	b8 03 00 00 00       	mov    $0x3,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <pipe>:
SYSCALL(pipe)
 2d4:	b8 04 00 00 00       	mov    $0x4,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <read>:
SYSCALL(read)
 2dc:	b8 05 00 00 00       	mov    $0x5,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <write>:
SYSCALL(write)
 2e4:	b8 10 00 00 00       	mov    $0x10,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <close>:
SYSCALL(close)
 2ec:	b8 15 00 00 00       	mov    $0x15,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <kill>:
SYSCALL(kill)
 2f4:	b8 06 00 00 00       	mov    $0x6,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <exec>:
SYSCALL(exec)
 2fc:	b8 07 00 00 00       	mov    $0x7,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <open>:
SYSCALL(open)
 304:	b8 0f 00 00 00       	mov    $0xf,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <mknod>:
SYSCALL(mknod)
 30c:	b8 11 00 00 00       	mov    $0x11,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <unlink>:
SYSCALL(unlink)
 314:	b8 12 00 00 00       	mov    $0x12,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <fstat>:
SYSCALL(fstat)
 31c:	b8 08 00 00 00       	mov    $0x8,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <link>:
SYSCALL(link)
 324:	b8 13 00 00 00       	mov    $0x13,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <mkdir>:
SYSCALL(mkdir)
 32c:	b8 14 00 00 00       	mov    $0x14,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <chdir>:
SYSCALL(chdir)
 334:	b8 09 00 00 00       	mov    $0x9,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <dup>:
SYSCALL(dup)
 33c:	b8 0a 00 00 00       	mov    $0xa,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <getpid>:
SYSCALL(getpid)
 344:	b8 0b 00 00 00       	mov    $0xb,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <sbrk>:
SYSCALL(sbrk)
 34c:	b8 0c 00 00 00       	mov    $0xc,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <sleep>:
SYSCALL(sleep)
 354:	b8 0d 00 00 00       	mov    $0xd,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <uptime>:
SYSCALL(uptime)
 35c:	b8 0e 00 00 00       	mov    $0xe,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <trace>:
SYSCALL(trace)
 364:	b8 16 00 00 00       	mov    $0x16,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <setEFlag>:
SYSCALL(setEFlag)
 36c:	b8 17 00 00 00       	mov    $0x17,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <setSFlag>:
SYSCALL(setSFlag)
 374:	b8 18 00 00 00       	mov    $0x18,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <setFFlag>:
SYSCALL(setFFlag)
 37c:	b8 19 00 00 00       	mov    $0x19,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <dump>:
 384:	b8 1a 00 00 00       	mov    $0x1a,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <putc>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user.h"

static void putc(int fd, char c) { write(fd, &c, 1); }
 38c:	f3 0f 1e fb          	endbr32 
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	83 ec 18             	sub    $0x18,%esp
 396:	8b 45 0c             	mov    0xc(%ebp),%eax
 399:	88 45 f4             	mov    %al,-0xc(%ebp)
 39c:	83 ec 04             	sub    $0x4,%esp
 39f:	6a 01                	push   $0x1
 3a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3a4:	50                   	push   %eax
 3a5:	ff 75 08             	pushl  0x8(%ebp)
 3a8:	e8 37 ff ff ff       	call   2e4 <write>
 3ad:	83 c4 10             	add    $0x10,%esp
 3b0:	90                   	nop
 3b1:	c9                   	leave  
 3b2:	c3                   	ret    

000003b3 <printint>:

static void printint(int fd, int xx, int base, int sgn) {
 3b3:	f3 0f 1e fb          	endbr32 
 3b7:	55                   	push   %ebp
 3b8:	89 e5                	mov    %esp,%ebp
 3ba:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3bd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if (sgn && xx < 0) {
 3c4:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3c8:	74 17                	je     3e1 <printint+0x2e>
 3ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3ce:	79 11                	jns    3e1 <printint+0x2e>
    neg = 1;
 3d0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3d7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3da:	f7 d8                	neg    %eax
 3dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3df:	eb 06                	jmp    3e7 <printint+0x34>
  } else {
    x = xx;
 3e1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do {
    buf[i++] = digits[x % base];
 3ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3f4:	ba 00 00 00 00       	mov    $0x0,%edx
 3f9:	f7 f1                	div    %ecx
 3fb:	89 d1                	mov    %edx,%ecx
 3fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 400:	8d 50 01             	lea    0x1(%eax),%edx
 403:	89 55 f4             	mov    %edx,-0xc(%ebp)
 406:	0f b6 91 7c 0a 00 00 	movzbl 0xa7c(%ecx),%edx
 40d:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  } while ((x /= base) != 0);
 411:	8b 4d 10             	mov    0x10(%ebp),%ecx
 414:	8b 45 ec             	mov    -0x14(%ebp),%eax
 417:	ba 00 00 00 00       	mov    $0x0,%edx
 41c:	f7 f1                	div    %ecx
 41e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 421:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 425:	75 c7                	jne    3ee <printint+0x3b>
  if (neg)
 427:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 42b:	74 2d                	je     45a <printint+0xa7>
    buf[i++] = '-';
 42d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 430:	8d 50 01             	lea    0x1(%eax),%edx
 433:	89 55 f4             	mov    %edx,-0xc(%ebp)
 436:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while (--i >= 0)
 43b:	eb 1d                	jmp    45a <printint+0xa7>
    putc(fd, buf[i]);
 43d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 440:	8b 45 f4             	mov    -0xc(%ebp),%eax
 443:	01 d0                	add    %edx,%eax
 445:	0f b6 00             	movzbl (%eax),%eax
 448:	0f be c0             	movsbl %al,%eax
 44b:	83 ec 08             	sub    $0x8,%esp
 44e:	50                   	push   %eax
 44f:	ff 75 08             	pushl  0x8(%ebp)
 452:	e8 35 ff ff ff       	call   38c <putc>
 457:	83 c4 10             	add    $0x10,%esp
  while (--i >= 0)
 45a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 45e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 462:	79 d9                	jns    43d <printint+0x8a>
}
 464:	90                   	nop
 465:	90                   	nop
 466:	c9                   	leave  
 467:	c3                   	ret    

00000468 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void printf(int fd, char *fmt, ...) {
 468:	f3 0f 1e fb          	endbr32 
 46c:	55                   	push   %ebp
 46d:	89 e5                	mov    %esp,%ebp
 46f:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 472:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint *)(void *)&fmt + 1;
 479:	8d 45 0c             	lea    0xc(%ebp),%eax
 47c:	83 c0 04             	add    $0x4,%eax
 47f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for (i = 0; fmt[i]; i++) {
 482:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 489:	e9 59 01 00 00       	jmp    5e7 <printf+0x17f>
    c = fmt[i] & 0xff;
 48e:	8b 55 0c             	mov    0xc(%ebp),%edx
 491:	8b 45 f0             	mov    -0x10(%ebp),%eax
 494:	01 d0                	add    %edx,%eax
 496:	0f b6 00             	movzbl (%eax),%eax
 499:	0f be c0             	movsbl %al,%eax
 49c:	25 ff 00 00 00       	and    $0xff,%eax
 4a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (state == 0) {
 4a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4a8:	75 2c                	jne    4d6 <printf+0x6e>
      if (c == '%') {
 4aa:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4ae:	75 0c                	jne    4bc <printf+0x54>
        state = '%';
 4b0:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4b7:	e9 27 01 00 00       	jmp    5e3 <printf+0x17b>
      } else {
        putc(fd, c);
 4bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4bf:	0f be c0             	movsbl %al,%eax
 4c2:	83 ec 08             	sub    $0x8,%esp
 4c5:	50                   	push   %eax
 4c6:	ff 75 08             	pushl  0x8(%ebp)
 4c9:	e8 be fe ff ff       	call   38c <putc>
 4ce:	83 c4 10             	add    $0x10,%esp
 4d1:	e9 0d 01 00 00       	jmp    5e3 <printf+0x17b>
      }
    } else if (state == '%') {
 4d6:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4da:	0f 85 03 01 00 00    	jne    5e3 <printf+0x17b>
      if (c == 'd') {
 4e0:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4e4:	75 1e                	jne    504 <printf+0x9c>
        printint(fd, *ap, 10, 1);
 4e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4e9:	8b 00                	mov    (%eax),%eax
 4eb:	6a 01                	push   $0x1
 4ed:	6a 0a                	push   $0xa
 4ef:	50                   	push   %eax
 4f0:	ff 75 08             	pushl  0x8(%ebp)
 4f3:	e8 bb fe ff ff       	call   3b3 <printint>
 4f8:	83 c4 10             	add    $0x10,%esp
        ap++;
 4fb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4ff:	e9 d8 00 00 00       	jmp    5dc <printf+0x174>
      } else if (c == 'x' || c == 'p') {
 504:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 508:	74 06                	je     510 <printf+0xa8>
 50a:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 50e:	75 1e                	jne    52e <printf+0xc6>
        printint(fd, *ap, 16, 0);
 510:	8b 45 e8             	mov    -0x18(%ebp),%eax
 513:	8b 00                	mov    (%eax),%eax
 515:	6a 00                	push   $0x0
 517:	6a 10                	push   $0x10
 519:	50                   	push   %eax
 51a:	ff 75 08             	pushl  0x8(%ebp)
 51d:	e8 91 fe ff ff       	call   3b3 <printint>
 522:	83 c4 10             	add    $0x10,%esp
        ap++;
 525:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 529:	e9 ae 00 00 00       	jmp    5dc <printf+0x174>
      } else if (c == 's') {
 52e:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 532:	75 43                	jne    577 <printf+0x10f>
        s = (char *)*ap;
 534:	8b 45 e8             	mov    -0x18(%ebp),%eax
 537:	8b 00                	mov    (%eax),%eax
 539:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 53c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if (s == 0)
 540:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 544:	75 25                	jne    56b <printf+0x103>
          s = "(null)";
 546:	c7 45 f4 2f 08 00 00 	movl   $0x82f,-0xc(%ebp)
        while (*s != 0) {
 54d:	eb 1c                	jmp    56b <printf+0x103>
          putc(fd, *s);
 54f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 552:	0f b6 00             	movzbl (%eax),%eax
 555:	0f be c0             	movsbl %al,%eax
 558:	83 ec 08             	sub    $0x8,%esp
 55b:	50                   	push   %eax
 55c:	ff 75 08             	pushl  0x8(%ebp)
 55f:	e8 28 fe ff ff       	call   38c <putc>
 564:	83 c4 10             	add    $0x10,%esp
          s++;
 567:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while (*s != 0) {
 56b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 56e:	0f b6 00             	movzbl (%eax),%eax
 571:	84 c0                	test   %al,%al
 573:	75 da                	jne    54f <printf+0xe7>
 575:	eb 65                	jmp    5dc <printf+0x174>
        }
      } else if (c == 'c') {
 577:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 57b:	75 1d                	jne    59a <printf+0x132>
        putc(fd, *ap);
 57d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 580:	8b 00                	mov    (%eax),%eax
 582:	0f be c0             	movsbl %al,%eax
 585:	83 ec 08             	sub    $0x8,%esp
 588:	50                   	push   %eax
 589:	ff 75 08             	pushl  0x8(%ebp)
 58c:	e8 fb fd ff ff       	call   38c <putc>
 591:	83 c4 10             	add    $0x10,%esp
        ap++;
 594:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 598:	eb 42                	jmp    5dc <printf+0x174>
      } else if (c == '%') {
 59a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 59e:	75 17                	jne    5b7 <printf+0x14f>
        putc(fd, c);
 5a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5a3:	0f be c0             	movsbl %al,%eax
 5a6:	83 ec 08             	sub    $0x8,%esp
 5a9:	50                   	push   %eax
 5aa:	ff 75 08             	pushl  0x8(%ebp)
 5ad:	e8 da fd ff ff       	call   38c <putc>
 5b2:	83 c4 10             	add    $0x10,%esp
 5b5:	eb 25                	jmp    5dc <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5b7:	83 ec 08             	sub    $0x8,%esp
 5ba:	6a 25                	push   $0x25
 5bc:	ff 75 08             	pushl  0x8(%ebp)
 5bf:	e8 c8 fd ff ff       	call   38c <putc>
 5c4:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ca:	0f be c0             	movsbl %al,%eax
 5cd:	83 ec 08             	sub    $0x8,%esp
 5d0:	50                   	push   %eax
 5d1:	ff 75 08             	pushl  0x8(%ebp)
 5d4:	e8 b3 fd ff ff       	call   38c <putc>
 5d9:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5dc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for (i = 0; fmt[i]; i++) {
 5e3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5e7:	8b 55 0c             	mov    0xc(%ebp),%edx
 5ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5ed:	01 d0                	add    %edx,%eax
 5ef:	0f b6 00             	movzbl (%eax),%eax
 5f2:	84 c0                	test   %al,%al
 5f4:	0f 85 94 fe ff ff    	jne    48e <printf+0x26>
    }
  }
}
 5fa:	90                   	nop
 5fb:	90                   	nop
 5fc:	c9                   	leave  
 5fd:	c3                   	ret    

000005fe <free>:
typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
 5fe:	f3 0f 1e fb          	endbr32 
 602:	55                   	push   %ebp
 603:	89 e5                	mov    %esp,%ebp
 605:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header *)ap - 1;
 608:	8b 45 08             	mov    0x8(%ebp),%eax
 60b:	83 e8 08             	sub    $0x8,%eax
 60e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 611:	a1 98 0a 00 00       	mov    0xa98,%eax
 616:	89 45 fc             	mov    %eax,-0x4(%ebp)
 619:	eb 24                	jmp    63f <free+0x41>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 61b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61e:	8b 00                	mov    (%eax),%eax
 620:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 623:	72 12                	jb     637 <free+0x39>
 625:	8b 45 f8             	mov    -0x8(%ebp),%eax
 628:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 62b:	77 24                	ja     651 <free+0x53>
 62d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 630:	8b 00                	mov    (%eax),%eax
 632:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 635:	72 1a                	jb     651 <free+0x53>
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 637:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63a:	8b 00                	mov    (%eax),%eax
 63c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 63f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 642:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 645:	76 d4                	jbe    61b <free+0x1d>
 647:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64a:	8b 00                	mov    (%eax),%eax
 64c:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 64f:	73 ca                	jae    61b <free+0x1d>
      break;
  if (bp + bp->s.size == p->s.ptr) {
 651:	8b 45 f8             	mov    -0x8(%ebp),%eax
 654:	8b 40 04             	mov    0x4(%eax),%eax
 657:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 65e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 661:	01 c2                	add    %eax,%edx
 663:	8b 45 fc             	mov    -0x4(%ebp),%eax
 666:	8b 00                	mov    (%eax),%eax
 668:	39 c2                	cmp    %eax,%edx
 66a:	75 24                	jne    690 <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 66c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66f:	8b 50 04             	mov    0x4(%eax),%edx
 672:	8b 45 fc             	mov    -0x4(%ebp),%eax
 675:	8b 00                	mov    (%eax),%eax
 677:	8b 40 04             	mov    0x4(%eax),%eax
 67a:	01 c2                	add    %eax,%edx
 67c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67f:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 682:	8b 45 fc             	mov    -0x4(%ebp),%eax
 685:	8b 00                	mov    (%eax),%eax
 687:	8b 10                	mov    (%eax),%edx
 689:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68c:	89 10                	mov    %edx,(%eax)
 68e:	eb 0a                	jmp    69a <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 690:	8b 45 fc             	mov    -0x4(%ebp),%eax
 693:	8b 10                	mov    (%eax),%edx
 695:	8b 45 f8             	mov    -0x8(%ebp),%eax
 698:	89 10                	mov    %edx,(%eax)
  if (p + p->s.size == bp) {
 69a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69d:	8b 40 04             	mov    0x4(%eax),%eax
 6a0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6aa:	01 d0                	add    %edx,%eax
 6ac:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6af:	75 20                	jne    6d1 <free+0xd3>
    p->s.size += bp->s.size;
 6b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b4:	8b 50 04             	mov    0x4(%eax),%edx
 6b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ba:	8b 40 04             	mov    0x4(%eax),%eax
 6bd:	01 c2                	add    %eax,%edx
 6bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c8:	8b 10                	mov    (%eax),%edx
 6ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cd:	89 10                	mov    %edx,(%eax)
 6cf:	eb 08                	jmp    6d9 <free+0xdb>
  } else
    p->s.ptr = bp;
 6d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6d7:	89 10                	mov    %edx,(%eax)
  freep = p;
 6d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dc:	a3 98 0a 00 00       	mov    %eax,0xa98
}
 6e1:	90                   	nop
 6e2:	c9                   	leave  
 6e3:	c3                   	ret    

000006e4 <morecore>:

static Header *morecore(uint nu) {
 6e4:	f3 0f 1e fb          	endbr32 
 6e8:	55                   	push   %ebp
 6e9:	89 e5                	mov    %esp,%ebp
 6eb:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if (nu < 4096)
 6ee:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6f5:	77 07                	ja     6fe <morecore+0x1a>
    nu = 4096;
 6f7:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6fe:	8b 45 08             	mov    0x8(%ebp),%eax
 701:	c1 e0 03             	shl    $0x3,%eax
 704:	83 ec 0c             	sub    $0xc,%esp
 707:	50                   	push   %eax
 708:	e8 3f fc ff ff       	call   34c <sbrk>
 70d:	83 c4 10             	add    $0x10,%esp
 710:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (p == (char *)-1)
 713:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 717:	75 07                	jne    720 <morecore+0x3c>
    return 0;
 719:	b8 00 00 00 00       	mov    $0x0,%eax
 71e:	eb 26                	jmp    746 <morecore+0x62>
  hp = (Header *)p;
 720:	8b 45 f4             	mov    -0xc(%ebp),%eax
 723:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 726:	8b 45 f0             	mov    -0x10(%ebp),%eax
 729:	8b 55 08             	mov    0x8(%ebp),%edx
 72c:	89 50 04             	mov    %edx,0x4(%eax)
  free((void *)(hp + 1));
 72f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 732:	83 c0 08             	add    $0x8,%eax
 735:	83 ec 0c             	sub    $0xc,%esp
 738:	50                   	push   %eax
 739:	e8 c0 fe ff ff       	call   5fe <free>
 73e:	83 c4 10             	add    $0x10,%esp
  return freep;
 741:	a1 98 0a 00 00       	mov    0xa98,%eax
}
 746:	c9                   	leave  
 747:	c3                   	ret    

00000748 <malloc>:

void *malloc(uint nbytes) {
 748:	f3 0f 1e fb          	endbr32 
 74c:	55                   	push   %ebp
 74d:	89 e5                	mov    %esp,%ebp
 74f:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 752:	8b 45 08             	mov    0x8(%ebp),%eax
 755:	83 c0 07             	add    $0x7,%eax
 758:	c1 e8 03             	shr    $0x3,%eax
 75b:	83 c0 01             	add    $0x1,%eax
 75e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if ((prevp = freep) == 0) {
 761:	a1 98 0a 00 00       	mov    0xa98,%eax
 766:	89 45 f0             	mov    %eax,-0x10(%ebp)
 769:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 76d:	75 23                	jne    792 <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 76f:	c7 45 f0 90 0a 00 00 	movl   $0xa90,-0x10(%ebp)
 776:	8b 45 f0             	mov    -0x10(%ebp),%eax
 779:	a3 98 0a 00 00       	mov    %eax,0xa98
 77e:	a1 98 0a 00 00       	mov    0xa98,%eax
 783:	a3 90 0a 00 00       	mov    %eax,0xa90
    base.s.size = 0;
 788:	c7 05 94 0a 00 00 00 	movl   $0x0,0xa94
 78f:	00 00 00 
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 792:	8b 45 f0             	mov    -0x10(%ebp),%eax
 795:	8b 00                	mov    (%eax),%eax
 797:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p->s.size >= nunits) {
 79a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79d:	8b 40 04             	mov    0x4(%eax),%eax
 7a0:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7a3:	77 4d                	ja     7f2 <malloc+0xaa>
      if (p->s.size == nunits)
 7a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a8:	8b 40 04             	mov    0x4(%eax),%eax
 7ab:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7ae:	75 0c                	jne    7bc <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 7b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b3:	8b 10                	mov    (%eax),%edx
 7b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b8:	89 10                	mov    %edx,(%eax)
 7ba:	eb 26                	jmp    7e2 <malloc+0x9a>
      else {
        p->s.size -= nunits;
 7bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bf:	8b 40 04             	mov    0x4(%eax),%eax
 7c2:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7c5:	89 c2                	mov    %eax,%edx
 7c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ca:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d0:	8b 40 04             	mov    0x4(%eax),%eax
 7d3:	c1 e0 03             	shl    $0x3,%eax
 7d6:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7df:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e5:	a3 98 0a 00 00       	mov    %eax,0xa98
      return (void *)(p + 1);
 7ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ed:	83 c0 08             	add    $0x8,%eax
 7f0:	eb 3b                	jmp    82d <malloc+0xe5>
    }
    if (p == freep)
 7f2:	a1 98 0a 00 00       	mov    0xa98,%eax
 7f7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7fa:	75 1e                	jne    81a <malloc+0xd2>
      if ((p = morecore(nunits)) == 0)
 7fc:	83 ec 0c             	sub    $0xc,%esp
 7ff:	ff 75 ec             	pushl  -0x14(%ebp)
 802:	e8 dd fe ff ff       	call   6e4 <morecore>
 807:	83 c4 10             	add    $0x10,%esp
 80a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 80d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 811:	75 07                	jne    81a <malloc+0xd2>
        return 0;
 813:	b8 00 00 00 00       	mov    $0x0,%eax
 818:	eb 13                	jmp    82d <malloc+0xe5>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 81a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 820:	8b 45 f4             	mov    -0xc(%ebp),%eax
 823:	8b 00                	mov    (%eax),%eax
 825:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p->s.size >= nunits) {
 828:	e9 6d ff ff ff       	jmp    79a <malloc+0x52>
  }
}
 82d:	c9                   	leave  
 82e:	c3                   	ret    
