
user/_dump:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "kernel/stat.h"
#include "user.h"
#include "kernel/fcntl.h"
#include "kernel/trace.h"

int main(int argc, char *argv[]) {
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	51                   	push   %ecx
  12:	83 ec 04             	sub    $0x4,%esp
      dump(0);
  15:	83 ec 0c             	sub    $0xc,%esp
  18:	6a 00                	push   $0x0
  1a:	e8 43 03 00 00       	call   362 <dump>
  1f:	83 c4 10             	add    $0x10,%esp
      exit();
  22:	e8 7b 02 00 00       	call   2a2 <exit>

00000027 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  27:	55                   	push   %ebp
  28:	89 e5                	mov    %esp,%ebp
  2a:	57                   	push   %edi
  2b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  2c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  2f:	8b 55 10             	mov    0x10(%ebp),%edx
  32:	8b 45 0c             	mov    0xc(%ebp),%eax
  35:	89 cb                	mov    %ecx,%ebx
  37:	89 df                	mov    %ebx,%edi
  39:	89 d1                	mov    %edx,%ecx
  3b:	fc                   	cld    
  3c:	f3 aa                	rep stos %al,%es:(%edi)
  3e:	89 ca                	mov    %ecx,%edx
  40:	89 fb                	mov    %edi,%ebx
  42:	89 5d 08             	mov    %ebx,0x8(%ebp)
  45:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  48:	90                   	nop
  49:	5b                   	pop    %ebx
  4a:	5f                   	pop    %edi
  4b:	5d                   	pop    %ebp
  4c:	c3                   	ret    

0000004d <strcpy>:
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user.h"
#include "kernel/x86.h"

char *strcpy(char *s, char *t) {
  4d:	f3 0f 1e fb          	endbr32 
  51:	55                   	push   %ebp
  52:	89 e5                	mov    %esp,%ebp
  54:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  57:	8b 45 08             	mov    0x8(%ebp),%eax
  5a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while ((*s++ = *t++) != 0)
  5d:	90                   	nop
  5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  61:	8d 42 01             	lea    0x1(%edx),%eax
  64:	89 45 0c             	mov    %eax,0xc(%ebp)
  67:	8b 45 08             	mov    0x8(%ebp),%eax
  6a:	8d 48 01             	lea    0x1(%eax),%ecx
  6d:	89 4d 08             	mov    %ecx,0x8(%ebp)
  70:	0f b6 12             	movzbl (%edx),%edx
  73:	88 10                	mov    %dl,(%eax)
  75:	0f b6 00             	movzbl (%eax),%eax
  78:	84 c0                	test   %al,%al
  7a:	75 e2                	jne    5e <strcpy+0x11>
    ;
  return os;
  7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  7f:	c9                   	leave  
  80:	c3                   	ret    

00000081 <strcmp>:

int strcmp(const char *p, const char *q) {
  81:	f3 0f 1e fb          	endbr32 
  85:	55                   	push   %ebp
  86:	89 e5                	mov    %esp,%ebp
  while (*p && *p == *q)
  88:	eb 08                	jmp    92 <strcmp+0x11>
    p++, q++;
  8a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while (*p && *p == *q)
  92:	8b 45 08             	mov    0x8(%ebp),%eax
  95:	0f b6 00             	movzbl (%eax),%eax
  98:	84 c0                	test   %al,%al
  9a:	74 10                	je     ac <strcmp+0x2b>
  9c:	8b 45 08             	mov    0x8(%ebp),%eax
  9f:	0f b6 10             	movzbl (%eax),%edx
  a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  a5:	0f b6 00             	movzbl (%eax),%eax
  a8:	38 c2                	cmp    %al,%dl
  aa:	74 de                	je     8a <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
  ac:	8b 45 08             	mov    0x8(%ebp),%eax
  af:	0f b6 00             	movzbl (%eax),%eax
  b2:	0f b6 d0             	movzbl %al,%edx
  b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  b8:	0f b6 00             	movzbl (%eax),%eax
  bb:	0f b6 c0             	movzbl %al,%eax
  be:	29 c2                	sub    %eax,%edx
  c0:	89 d0                	mov    %edx,%eax
}
  c2:	5d                   	pop    %ebp
  c3:	c3                   	ret    

000000c4 <strlen>:

uint strlen(char *s) {
  c4:	f3 0f 1e fb          	endbr32 
  c8:	55                   	push   %ebp
  c9:	89 e5                	mov    %esp,%ebp
  cb:	83 ec 10             	sub    $0x10,%esp
  int n;

  for (n = 0; s[n]; n++)
  ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  d5:	eb 04                	jmp    db <strlen+0x17>
  d7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  de:	8b 45 08             	mov    0x8(%ebp),%eax
  e1:	01 d0                	add    %edx,%eax
  e3:	0f b6 00             	movzbl (%eax),%eax
  e6:	84 c0                	test   %al,%al
  e8:	75 ed                	jne    d7 <strlen+0x13>
    ;
  return n;
  ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  ed:	c9                   	leave  
  ee:	c3                   	ret    

000000ef <memset>:

void *memset(void *dst, int c, uint n) {
  ef:	f3 0f 1e fb          	endbr32 
  f3:	55                   	push   %ebp
  f4:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  f6:	8b 45 10             	mov    0x10(%ebp),%eax
  f9:	50                   	push   %eax
  fa:	ff 75 0c             	pushl  0xc(%ebp)
  fd:	ff 75 08             	pushl  0x8(%ebp)
 100:	e8 22 ff ff ff       	call   27 <stosb>
 105:	83 c4 0c             	add    $0xc,%esp
  return dst;
 108:	8b 45 08             	mov    0x8(%ebp),%eax
}
 10b:	c9                   	leave  
 10c:	c3                   	ret    

0000010d <strchr>:

char *strchr(const char *s, char c) {
 10d:	f3 0f 1e fb          	endbr32 
 111:	55                   	push   %ebp
 112:	89 e5                	mov    %esp,%ebp
 114:	83 ec 04             	sub    $0x4,%esp
 117:	8b 45 0c             	mov    0xc(%ebp),%eax
 11a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for (; *s; s++)
 11d:	eb 14                	jmp    133 <strchr+0x26>
    if (*s == c)
 11f:	8b 45 08             	mov    0x8(%ebp),%eax
 122:	0f b6 00             	movzbl (%eax),%eax
 125:	38 45 fc             	cmp    %al,-0x4(%ebp)
 128:	75 05                	jne    12f <strchr+0x22>
      return (char *)s;
 12a:	8b 45 08             	mov    0x8(%ebp),%eax
 12d:	eb 13                	jmp    142 <strchr+0x35>
  for (; *s; s++)
 12f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 133:	8b 45 08             	mov    0x8(%ebp),%eax
 136:	0f b6 00             	movzbl (%eax),%eax
 139:	84 c0                	test   %al,%al
 13b:	75 e2                	jne    11f <strchr+0x12>
  return 0;
 13d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 142:	c9                   	leave  
 143:	c3                   	ret    

00000144 <gets>:

char *gets(char *buf, int max) {
 144:	f3 0f 1e fb          	endbr32 
 148:	55                   	push   %ebp
 149:	89 e5                	mov    %esp,%ebp
 14b:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 14e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 155:	eb 42                	jmp    199 <gets+0x55>
    cc = read(0, &c, 1);
 157:	83 ec 04             	sub    $0x4,%esp
 15a:	6a 01                	push   $0x1
 15c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 15f:	50                   	push   %eax
 160:	6a 00                	push   $0x0
 162:	e8 53 01 00 00       	call   2ba <read>
 167:	83 c4 10             	add    $0x10,%esp
 16a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (cc < 1)
 16d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 171:	7e 33                	jle    1a6 <gets+0x62>
      break;
    buf[i++] = c;
 173:	8b 45 f4             	mov    -0xc(%ebp),%eax
 176:	8d 50 01             	lea    0x1(%eax),%edx
 179:	89 55 f4             	mov    %edx,-0xc(%ebp)
 17c:	89 c2                	mov    %eax,%edx
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	01 c2                	add    %eax,%edx
 183:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 187:	88 02                	mov    %al,(%edx)
    if (c == '\n' || c == '\r')
 189:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 18d:	3c 0a                	cmp    $0xa,%al
 18f:	74 16                	je     1a7 <gets+0x63>
 191:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 195:	3c 0d                	cmp    $0xd,%al
 197:	74 0e                	je     1a7 <gets+0x63>
  for (i = 0; i + 1 < max;) {
 199:	8b 45 f4             	mov    -0xc(%ebp),%eax
 19c:	83 c0 01             	add    $0x1,%eax
 19f:	39 45 0c             	cmp    %eax,0xc(%ebp)
 1a2:	7f b3                	jg     157 <gets+0x13>
 1a4:	eb 01                	jmp    1a7 <gets+0x63>
      break;
 1a6:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1aa:	8b 45 08             	mov    0x8(%ebp),%eax
 1ad:	01 d0                	add    %edx,%eax
 1af:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1b2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1b5:	c9                   	leave  
 1b6:	c3                   	ret    

000001b7 <stat>:

int stat(char *n, struct stat *st) {
 1b7:	f3 0f 1e fb          	endbr32 
 1bb:	55                   	push   %ebp
 1bc:	89 e5                	mov    %esp,%ebp
 1be:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c1:	83 ec 08             	sub    $0x8,%esp
 1c4:	6a 00                	push   $0x0
 1c6:	ff 75 08             	pushl  0x8(%ebp)
 1c9:	e8 14 01 00 00       	call   2e2 <open>
 1ce:	83 c4 10             	add    $0x10,%esp
 1d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (fd < 0)
 1d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1d8:	79 07                	jns    1e1 <stat+0x2a>
    return -1;
 1da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1df:	eb 25                	jmp    206 <stat+0x4f>
  r = fstat(fd, st);
 1e1:	83 ec 08             	sub    $0x8,%esp
 1e4:	ff 75 0c             	pushl  0xc(%ebp)
 1e7:	ff 75 f4             	pushl  -0xc(%ebp)
 1ea:	e8 0b 01 00 00       	call   2fa <fstat>
 1ef:	83 c4 10             	add    $0x10,%esp
 1f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1f5:	83 ec 0c             	sub    $0xc,%esp
 1f8:	ff 75 f4             	pushl  -0xc(%ebp)
 1fb:	e8 ca 00 00 00       	call   2ca <close>
 200:	83 c4 10             	add    $0x10,%esp
  return r;
 203:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 206:	c9                   	leave  
 207:	c3                   	ret    

00000208 <atoi>:

int atoi(const char *s) {
 208:	f3 0f 1e fb          	endbr32 
 20c:	55                   	push   %ebp
 20d:	89 e5                	mov    %esp,%ebp
 20f:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 212:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while ('0' <= *s && *s <= '9')
 219:	eb 25                	jmp    240 <atoi+0x38>
    n = n * 10 + *s++ - '0';
 21b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 21e:	89 d0                	mov    %edx,%eax
 220:	c1 e0 02             	shl    $0x2,%eax
 223:	01 d0                	add    %edx,%eax
 225:	01 c0                	add    %eax,%eax
 227:	89 c1                	mov    %eax,%ecx
 229:	8b 45 08             	mov    0x8(%ebp),%eax
 22c:	8d 50 01             	lea    0x1(%eax),%edx
 22f:	89 55 08             	mov    %edx,0x8(%ebp)
 232:	0f b6 00             	movzbl (%eax),%eax
 235:	0f be c0             	movsbl %al,%eax
 238:	01 c8                	add    %ecx,%eax
 23a:	83 e8 30             	sub    $0x30,%eax
 23d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while ('0' <= *s && *s <= '9')
 240:	8b 45 08             	mov    0x8(%ebp),%eax
 243:	0f b6 00             	movzbl (%eax),%eax
 246:	3c 2f                	cmp    $0x2f,%al
 248:	7e 0a                	jle    254 <atoi+0x4c>
 24a:	8b 45 08             	mov    0x8(%ebp),%eax
 24d:	0f b6 00             	movzbl (%eax),%eax
 250:	3c 39                	cmp    $0x39,%al
 252:	7e c7                	jle    21b <atoi+0x13>
  return n;
 254:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 257:	c9                   	leave  
 258:	c3                   	ret    

00000259 <memmove>:

void *memmove(void *vdst, void *vsrc, int n) {
 259:	f3 0f 1e fb          	endbr32 
 25d:	55                   	push   %ebp
 25e:	89 e5                	mov    %esp,%ebp
 260:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 263:	8b 45 08             	mov    0x8(%ebp),%eax
 266:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 269:	8b 45 0c             	mov    0xc(%ebp),%eax
 26c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while (n-- > 0)
 26f:	eb 17                	jmp    288 <memmove+0x2f>
    *dst++ = *src++;
 271:	8b 55 f8             	mov    -0x8(%ebp),%edx
 274:	8d 42 01             	lea    0x1(%edx),%eax
 277:	89 45 f8             	mov    %eax,-0x8(%ebp)
 27a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 27d:	8d 48 01             	lea    0x1(%eax),%ecx
 280:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 283:	0f b6 12             	movzbl (%edx),%edx
 286:	88 10                	mov    %dl,(%eax)
  while (n-- > 0)
 288:	8b 45 10             	mov    0x10(%ebp),%eax
 28b:	8d 50 ff             	lea    -0x1(%eax),%edx
 28e:	89 55 10             	mov    %edx,0x10(%ebp)
 291:	85 c0                	test   %eax,%eax
 293:	7f dc                	jg     271 <memmove+0x18>
  return vdst;
 295:	8b 45 08             	mov    0x8(%ebp),%eax
}
 298:	c9                   	leave  
 299:	c3                   	ret    

0000029a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 29a:	b8 01 00 00 00       	mov    $0x1,%eax
 29f:	cd 40                	int    $0x40
 2a1:	c3                   	ret    

000002a2 <exit>:
SYSCALL(exit)
 2a2:	b8 02 00 00 00       	mov    $0x2,%eax
 2a7:	cd 40                	int    $0x40
 2a9:	c3                   	ret    

000002aa <wait>:
SYSCALL(wait)
 2aa:	b8 03 00 00 00       	mov    $0x3,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <pipe>:
SYSCALL(pipe)
 2b2:	b8 04 00 00 00       	mov    $0x4,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <read>:
SYSCALL(read)
 2ba:	b8 05 00 00 00       	mov    $0x5,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <write>:
SYSCALL(write)
 2c2:	b8 10 00 00 00       	mov    $0x10,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <close>:
SYSCALL(close)
 2ca:	b8 15 00 00 00       	mov    $0x15,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <kill>:
SYSCALL(kill)
 2d2:	b8 06 00 00 00       	mov    $0x6,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <exec>:
SYSCALL(exec)
 2da:	b8 07 00 00 00       	mov    $0x7,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <open>:
SYSCALL(open)
 2e2:	b8 0f 00 00 00       	mov    $0xf,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <mknod>:
SYSCALL(mknod)
 2ea:	b8 11 00 00 00       	mov    $0x11,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <unlink>:
SYSCALL(unlink)
 2f2:	b8 12 00 00 00       	mov    $0x12,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <fstat>:
SYSCALL(fstat)
 2fa:	b8 08 00 00 00       	mov    $0x8,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <link>:
SYSCALL(link)
 302:	b8 13 00 00 00       	mov    $0x13,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <mkdir>:
SYSCALL(mkdir)
 30a:	b8 14 00 00 00       	mov    $0x14,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <chdir>:
SYSCALL(chdir)
 312:	b8 09 00 00 00       	mov    $0x9,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <dup>:
SYSCALL(dup)
 31a:	b8 0a 00 00 00       	mov    $0xa,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <getpid>:
SYSCALL(getpid)
 322:	b8 0b 00 00 00       	mov    $0xb,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <sbrk>:
SYSCALL(sbrk)
 32a:	b8 0c 00 00 00       	mov    $0xc,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <sleep>:
SYSCALL(sleep)
 332:	b8 0d 00 00 00       	mov    $0xd,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <uptime>:
SYSCALL(uptime)
 33a:	b8 0e 00 00 00       	mov    $0xe,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <trace>:
SYSCALL(trace)
 342:	b8 16 00 00 00       	mov    $0x16,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <setEFlag>:
SYSCALL(setEFlag)
 34a:	b8 17 00 00 00       	mov    $0x17,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <setSFlag>:
SYSCALL(setSFlag)
 352:	b8 18 00 00 00       	mov    $0x18,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <setFFlag>:
SYSCALL(setFFlag)
 35a:	b8 19 00 00 00       	mov    $0x19,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <dump>:
 362:	b8 1a 00 00 00       	mov    $0x1a,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <putc>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user.h"

static void putc(int fd, char c) { write(fd, &c, 1); }
 36a:	f3 0f 1e fb          	endbr32 
 36e:	55                   	push   %ebp
 36f:	89 e5                	mov    %esp,%ebp
 371:	83 ec 18             	sub    $0x18,%esp
 374:	8b 45 0c             	mov    0xc(%ebp),%eax
 377:	88 45 f4             	mov    %al,-0xc(%ebp)
 37a:	83 ec 04             	sub    $0x4,%esp
 37d:	6a 01                	push   $0x1
 37f:	8d 45 f4             	lea    -0xc(%ebp),%eax
 382:	50                   	push   %eax
 383:	ff 75 08             	pushl  0x8(%ebp)
 386:	e8 37 ff ff ff       	call   2c2 <write>
 38b:	83 c4 10             	add    $0x10,%esp
 38e:	90                   	nop
 38f:	c9                   	leave  
 390:	c3                   	ret    

00000391 <printint>:

static void printint(int fd, int xx, int base, int sgn) {
 391:	f3 0f 1e fb          	endbr32 
 395:	55                   	push   %ebp
 396:	89 e5                	mov    %esp,%ebp
 398:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 39b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if (sgn && xx < 0) {
 3a2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3a6:	74 17                	je     3bf <printint+0x2e>
 3a8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3ac:	79 11                	jns    3bf <printint+0x2e>
    neg = 1;
 3ae:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3b5:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b8:	f7 d8                	neg    %eax
 3ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3bd:	eb 06                	jmp    3c5 <printint+0x34>
  } else {
    x = xx;
 3bf:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do {
    buf[i++] = digits[x % base];
 3cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3d2:	ba 00 00 00 00       	mov    $0x0,%edx
 3d7:	f7 f1                	div    %ecx
 3d9:	89 d1                	mov    %edx,%ecx
 3db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3de:	8d 50 01             	lea    0x1(%eax),%edx
 3e1:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3e4:	0f b6 91 58 0a 00 00 	movzbl 0xa58(%ecx),%edx
 3eb:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  } while ((x /= base) != 0);
 3ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3f5:	ba 00 00 00 00       	mov    $0x0,%edx
 3fa:	f7 f1                	div    %ecx
 3fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3ff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 403:	75 c7                	jne    3cc <printint+0x3b>
  if (neg)
 405:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 409:	74 2d                	je     438 <printint+0xa7>
    buf[i++] = '-';
 40b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 40e:	8d 50 01             	lea    0x1(%eax),%edx
 411:	89 55 f4             	mov    %edx,-0xc(%ebp)
 414:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while (--i >= 0)
 419:	eb 1d                	jmp    438 <printint+0xa7>
    putc(fd, buf[i]);
 41b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 41e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 421:	01 d0                	add    %edx,%eax
 423:	0f b6 00             	movzbl (%eax),%eax
 426:	0f be c0             	movsbl %al,%eax
 429:	83 ec 08             	sub    $0x8,%esp
 42c:	50                   	push   %eax
 42d:	ff 75 08             	pushl  0x8(%ebp)
 430:	e8 35 ff ff ff       	call   36a <putc>
 435:	83 c4 10             	add    $0x10,%esp
  while (--i >= 0)
 438:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 43c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 440:	79 d9                	jns    41b <printint+0x8a>
}
 442:	90                   	nop
 443:	90                   	nop
 444:	c9                   	leave  
 445:	c3                   	ret    

00000446 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void printf(int fd, char *fmt, ...) {
 446:	f3 0f 1e fb          	endbr32 
 44a:	55                   	push   %ebp
 44b:	89 e5                	mov    %esp,%ebp
 44d:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 450:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint *)(void *)&fmt + 1;
 457:	8d 45 0c             	lea    0xc(%ebp),%eax
 45a:	83 c0 04             	add    $0x4,%eax
 45d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for (i = 0; fmt[i]; i++) {
 460:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 467:	e9 59 01 00 00       	jmp    5c5 <printf+0x17f>
    c = fmt[i] & 0xff;
 46c:	8b 55 0c             	mov    0xc(%ebp),%edx
 46f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 472:	01 d0                	add    %edx,%eax
 474:	0f b6 00             	movzbl (%eax),%eax
 477:	0f be c0             	movsbl %al,%eax
 47a:	25 ff 00 00 00       	and    $0xff,%eax
 47f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (state == 0) {
 482:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 486:	75 2c                	jne    4b4 <printf+0x6e>
      if (c == '%') {
 488:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 48c:	75 0c                	jne    49a <printf+0x54>
        state = '%';
 48e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 495:	e9 27 01 00 00       	jmp    5c1 <printf+0x17b>
      } else {
        putc(fd, c);
 49a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 49d:	0f be c0             	movsbl %al,%eax
 4a0:	83 ec 08             	sub    $0x8,%esp
 4a3:	50                   	push   %eax
 4a4:	ff 75 08             	pushl  0x8(%ebp)
 4a7:	e8 be fe ff ff       	call   36a <putc>
 4ac:	83 c4 10             	add    $0x10,%esp
 4af:	e9 0d 01 00 00       	jmp    5c1 <printf+0x17b>
      }
    } else if (state == '%') {
 4b4:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4b8:	0f 85 03 01 00 00    	jne    5c1 <printf+0x17b>
      if (c == 'd') {
 4be:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4c2:	75 1e                	jne    4e2 <printf+0x9c>
        printint(fd, *ap, 10, 1);
 4c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4c7:	8b 00                	mov    (%eax),%eax
 4c9:	6a 01                	push   $0x1
 4cb:	6a 0a                	push   $0xa
 4cd:	50                   	push   %eax
 4ce:	ff 75 08             	pushl  0x8(%ebp)
 4d1:	e8 bb fe ff ff       	call   391 <printint>
 4d6:	83 c4 10             	add    $0x10,%esp
        ap++;
 4d9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4dd:	e9 d8 00 00 00       	jmp    5ba <printf+0x174>
      } else if (c == 'x' || c == 'p') {
 4e2:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4e6:	74 06                	je     4ee <printf+0xa8>
 4e8:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4ec:	75 1e                	jne    50c <printf+0xc6>
        printint(fd, *ap, 16, 0);
 4ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4f1:	8b 00                	mov    (%eax),%eax
 4f3:	6a 00                	push   $0x0
 4f5:	6a 10                	push   $0x10
 4f7:	50                   	push   %eax
 4f8:	ff 75 08             	pushl  0x8(%ebp)
 4fb:	e8 91 fe ff ff       	call   391 <printint>
 500:	83 c4 10             	add    $0x10,%esp
        ap++;
 503:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 507:	e9 ae 00 00 00       	jmp    5ba <printf+0x174>
      } else if (c == 's') {
 50c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 510:	75 43                	jne    555 <printf+0x10f>
        s = (char *)*ap;
 512:	8b 45 e8             	mov    -0x18(%ebp),%eax
 515:	8b 00                	mov    (%eax),%eax
 517:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 51a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if (s == 0)
 51e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 522:	75 25                	jne    549 <printf+0x103>
          s = "(null)";
 524:	c7 45 f4 0d 08 00 00 	movl   $0x80d,-0xc(%ebp)
        while (*s != 0) {
 52b:	eb 1c                	jmp    549 <printf+0x103>
          putc(fd, *s);
 52d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 530:	0f b6 00             	movzbl (%eax),%eax
 533:	0f be c0             	movsbl %al,%eax
 536:	83 ec 08             	sub    $0x8,%esp
 539:	50                   	push   %eax
 53a:	ff 75 08             	pushl  0x8(%ebp)
 53d:	e8 28 fe ff ff       	call   36a <putc>
 542:	83 c4 10             	add    $0x10,%esp
          s++;
 545:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while (*s != 0) {
 549:	8b 45 f4             	mov    -0xc(%ebp),%eax
 54c:	0f b6 00             	movzbl (%eax),%eax
 54f:	84 c0                	test   %al,%al
 551:	75 da                	jne    52d <printf+0xe7>
 553:	eb 65                	jmp    5ba <printf+0x174>
        }
      } else if (c == 'c') {
 555:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 559:	75 1d                	jne    578 <printf+0x132>
        putc(fd, *ap);
 55b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 55e:	8b 00                	mov    (%eax),%eax
 560:	0f be c0             	movsbl %al,%eax
 563:	83 ec 08             	sub    $0x8,%esp
 566:	50                   	push   %eax
 567:	ff 75 08             	pushl  0x8(%ebp)
 56a:	e8 fb fd ff ff       	call   36a <putc>
 56f:	83 c4 10             	add    $0x10,%esp
        ap++;
 572:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 576:	eb 42                	jmp    5ba <printf+0x174>
      } else if (c == '%') {
 578:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 57c:	75 17                	jne    595 <printf+0x14f>
        putc(fd, c);
 57e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 581:	0f be c0             	movsbl %al,%eax
 584:	83 ec 08             	sub    $0x8,%esp
 587:	50                   	push   %eax
 588:	ff 75 08             	pushl  0x8(%ebp)
 58b:	e8 da fd ff ff       	call   36a <putc>
 590:	83 c4 10             	add    $0x10,%esp
 593:	eb 25                	jmp    5ba <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 595:	83 ec 08             	sub    $0x8,%esp
 598:	6a 25                	push   $0x25
 59a:	ff 75 08             	pushl  0x8(%ebp)
 59d:	e8 c8 fd ff ff       	call   36a <putc>
 5a2:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5a8:	0f be c0             	movsbl %al,%eax
 5ab:	83 ec 08             	sub    $0x8,%esp
 5ae:	50                   	push   %eax
 5af:	ff 75 08             	pushl  0x8(%ebp)
 5b2:	e8 b3 fd ff ff       	call   36a <putc>
 5b7:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5ba:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for (i = 0; fmt[i]; i++) {
 5c1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5c5:	8b 55 0c             	mov    0xc(%ebp),%edx
 5c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5cb:	01 d0                	add    %edx,%eax
 5cd:	0f b6 00             	movzbl (%eax),%eax
 5d0:	84 c0                	test   %al,%al
 5d2:	0f 85 94 fe ff ff    	jne    46c <printf+0x26>
    }
  }
}
 5d8:	90                   	nop
 5d9:	90                   	nop
 5da:	c9                   	leave  
 5db:	c3                   	ret    

000005dc <free>:
typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
 5dc:	f3 0f 1e fb          	endbr32 
 5e0:	55                   	push   %ebp
 5e1:	89 e5                	mov    %esp,%ebp
 5e3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header *)ap - 1;
 5e6:	8b 45 08             	mov    0x8(%ebp),%eax
 5e9:	83 e8 08             	sub    $0x8,%eax
 5ec:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5ef:	a1 74 0a 00 00       	mov    0xa74,%eax
 5f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5f7:	eb 24                	jmp    61d <free+0x41>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5fc:	8b 00                	mov    (%eax),%eax
 5fe:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 601:	72 12                	jb     615 <free+0x39>
 603:	8b 45 f8             	mov    -0x8(%ebp),%eax
 606:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 609:	77 24                	ja     62f <free+0x53>
 60b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60e:	8b 00                	mov    (%eax),%eax
 610:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 613:	72 1a                	jb     62f <free+0x53>
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 615:	8b 45 fc             	mov    -0x4(%ebp),%eax
 618:	8b 00                	mov    (%eax),%eax
 61a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 61d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 620:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 623:	76 d4                	jbe    5f9 <free+0x1d>
 625:	8b 45 fc             	mov    -0x4(%ebp),%eax
 628:	8b 00                	mov    (%eax),%eax
 62a:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 62d:	73 ca                	jae    5f9 <free+0x1d>
      break;
  if (bp + bp->s.size == p->s.ptr) {
 62f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 632:	8b 40 04             	mov    0x4(%eax),%eax
 635:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 63c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63f:	01 c2                	add    %eax,%edx
 641:	8b 45 fc             	mov    -0x4(%ebp),%eax
 644:	8b 00                	mov    (%eax),%eax
 646:	39 c2                	cmp    %eax,%edx
 648:	75 24                	jne    66e <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 64a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64d:	8b 50 04             	mov    0x4(%eax),%edx
 650:	8b 45 fc             	mov    -0x4(%ebp),%eax
 653:	8b 00                	mov    (%eax),%eax
 655:	8b 40 04             	mov    0x4(%eax),%eax
 658:	01 c2                	add    %eax,%edx
 65a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 660:	8b 45 fc             	mov    -0x4(%ebp),%eax
 663:	8b 00                	mov    (%eax),%eax
 665:	8b 10                	mov    (%eax),%edx
 667:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66a:	89 10                	mov    %edx,(%eax)
 66c:	eb 0a                	jmp    678 <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 66e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 671:	8b 10                	mov    (%eax),%edx
 673:	8b 45 f8             	mov    -0x8(%ebp),%eax
 676:	89 10                	mov    %edx,(%eax)
  if (p + p->s.size == bp) {
 678:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67b:	8b 40 04             	mov    0x4(%eax),%eax
 67e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 685:	8b 45 fc             	mov    -0x4(%ebp),%eax
 688:	01 d0                	add    %edx,%eax
 68a:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 68d:	75 20                	jne    6af <free+0xd3>
    p->s.size += bp->s.size;
 68f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 692:	8b 50 04             	mov    0x4(%eax),%edx
 695:	8b 45 f8             	mov    -0x8(%ebp),%eax
 698:	8b 40 04             	mov    0x4(%eax),%eax
 69b:	01 c2                	add    %eax,%edx
 69d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a0:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a6:	8b 10                	mov    (%eax),%edx
 6a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ab:	89 10                	mov    %edx,(%eax)
 6ad:	eb 08                	jmp    6b7 <free+0xdb>
  } else
    p->s.ptr = bp;
 6af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6b5:	89 10                	mov    %edx,(%eax)
  freep = p;
 6b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ba:	a3 74 0a 00 00       	mov    %eax,0xa74
}
 6bf:	90                   	nop
 6c0:	c9                   	leave  
 6c1:	c3                   	ret    

000006c2 <morecore>:

static Header *morecore(uint nu) {
 6c2:	f3 0f 1e fb          	endbr32 
 6c6:	55                   	push   %ebp
 6c7:	89 e5                	mov    %esp,%ebp
 6c9:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if (nu < 4096)
 6cc:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6d3:	77 07                	ja     6dc <morecore+0x1a>
    nu = 4096;
 6d5:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6dc:	8b 45 08             	mov    0x8(%ebp),%eax
 6df:	c1 e0 03             	shl    $0x3,%eax
 6e2:	83 ec 0c             	sub    $0xc,%esp
 6e5:	50                   	push   %eax
 6e6:	e8 3f fc ff ff       	call   32a <sbrk>
 6eb:	83 c4 10             	add    $0x10,%esp
 6ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (p == (char *)-1)
 6f1:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6f5:	75 07                	jne    6fe <morecore+0x3c>
    return 0;
 6f7:	b8 00 00 00 00       	mov    $0x0,%eax
 6fc:	eb 26                	jmp    724 <morecore+0x62>
  hp = (Header *)p;
 6fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 701:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 704:	8b 45 f0             	mov    -0x10(%ebp),%eax
 707:	8b 55 08             	mov    0x8(%ebp),%edx
 70a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void *)(hp + 1));
 70d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 710:	83 c0 08             	add    $0x8,%eax
 713:	83 ec 0c             	sub    $0xc,%esp
 716:	50                   	push   %eax
 717:	e8 c0 fe ff ff       	call   5dc <free>
 71c:	83 c4 10             	add    $0x10,%esp
  return freep;
 71f:	a1 74 0a 00 00       	mov    0xa74,%eax
}
 724:	c9                   	leave  
 725:	c3                   	ret    

00000726 <malloc>:

void *malloc(uint nbytes) {
 726:	f3 0f 1e fb          	endbr32 
 72a:	55                   	push   %ebp
 72b:	89 e5                	mov    %esp,%ebp
 72d:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 730:	8b 45 08             	mov    0x8(%ebp),%eax
 733:	83 c0 07             	add    $0x7,%eax
 736:	c1 e8 03             	shr    $0x3,%eax
 739:	83 c0 01             	add    $0x1,%eax
 73c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if ((prevp = freep) == 0) {
 73f:	a1 74 0a 00 00       	mov    0xa74,%eax
 744:	89 45 f0             	mov    %eax,-0x10(%ebp)
 747:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 74b:	75 23                	jne    770 <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 74d:	c7 45 f0 6c 0a 00 00 	movl   $0xa6c,-0x10(%ebp)
 754:	8b 45 f0             	mov    -0x10(%ebp),%eax
 757:	a3 74 0a 00 00       	mov    %eax,0xa74
 75c:	a1 74 0a 00 00       	mov    0xa74,%eax
 761:	a3 6c 0a 00 00       	mov    %eax,0xa6c
    base.s.size = 0;
 766:	c7 05 70 0a 00 00 00 	movl   $0x0,0xa70
 76d:	00 00 00 
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 770:	8b 45 f0             	mov    -0x10(%ebp),%eax
 773:	8b 00                	mov    (%eax),%eax
 775:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p->s.size >= nunits) {
 778:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77b:	8b 40 04             	mov    0x4(%eax),%eax
 77e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 781:	77 4d                	ja     7d0 <malloc+0xaa>
      if (p->s.size == nunits)
 783:	8b 45 f4             	mov    -0xc(%ebp),%eax
 786:	8b 40 04             	mov    0x4(%eax),%eax
 789:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 78c:	75 0c                	jne    79a <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 78e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 791:	8b 10                	mov    (%eax),%edx
 793:	8b 45 f0             	mov    -0x10(%ebp),%eax
 796:	89 10                	mov    %edx,(%eax)
 798:	eb 26                	jmp    7c0 <malloc+0x9a>
      else {
        p->s.size -= nunits;
 79a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79d:	8b 40 04             	mov    0x4(%eax),%eax
 7a0:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7a3:	89 c2                	mov    %eax,%edx
 7a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a8:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ae:	8b 40 04             	mov    0x4(%eax),%eax
 7b1:	c1 e0 03             	shl    $0x3,%eax
 7b4:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7bd:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c3:	a3 74 0a 00 00       	mov    %eax,0xa74
      return (void *)(p + 1);
 7c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cb:	83 c0 08             	add    $0x8,%eax
 7ce:	eb 3b                	jmp    80b <malloc+0xe5>
    }
    if (p == freep)
 7d0:	a1 74 0a 00 00       	mov    0xa74,%eax
 7d5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7d8:	75 1e                	jne    7f8 <malloc+0xd2>
      if ((p = morecore(nunits)) == 0)
 7da:	83 ec 0c             	sub    $0xc,%esp
 7dd:	ff 75 ec             	pushl  -0x14(%ebp)
 7e0:	e8 dd fe ff ff       	call   6c2 <morecore>
 7e5:	83 c4 10             	add    $0x10,%esp
 7e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7ef:	75 07                	jne    7f8 <malloc+0xd2>
        return 0;
 7f1:	b8 00 00 00 00       	mov    $0x0,%eax
 7f6:	eb 13                	jmp    80b <malloc+0xe5>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 7f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 801:	8b 00                	mov    (%eax),%eax
 803:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p->s.size >= nunits) {
 806:	e9 6d ff ff ff       	jmp    778 <malloc+0x52>
  }
}
 80b:	c9                   	leave  
 80c:	c3                   	ret    
