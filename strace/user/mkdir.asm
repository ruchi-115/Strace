
user/_mkdir:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user.h"

int main(int argc, char *argv[]) {
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	53                   	push   %ebx
  12:	51                   	push   %ecx
  13:	83 ec 10             	sub    $0x10,%esp
  16:	89 cb                	mov    %ecx,%ebx
  int i;

  if (argc < 2) {
  18:	83 3b 01             	cmpl   $0x1,(%ebx)
  1b:	7f 17                	jg     34 <main+0x34>
    printf(2, "Usage: mkdir files...\n");
  1d:	83 ec 08             	sub    $0x8,%esp
  20:	68 7a 08 00 00       	push   $0x87a
  25:	6a 02                	push   $0x2
  27:	e8 87 04 00 00       	call   4b3 <printf>
  2c:	83 c4 10             	add    $0x10,%esp
    exit();
  2f:	e8 db 02 00 00       	call   30f <exit>
  }

  for (i = 1; i < argc; i++) {
  34:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  3b:	eb 4b                	jmp    88 <main+0x88>
    if (mkdir(argv[i]) < 0) {
  3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  40:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  47:	8b 43 04             	mov    0x4(%ebx),%eax
  4a:	01 d0                	add    %edx,%eax
  4c:	8b 00                	mov    (%eax),%eax
  4e:	83 ec 0c             	sub    $0xc,%esp
  51:	50                   	push   %eax
  52:	e8 20 03 00 00       	call   377 <mkdir>
  57:	83 c4 10             	add    $0x10,%esp
  5a:	85 c0                	test   %eax,%eax
  5c:	79 26                	jns    84 <main+0x84>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
  5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  61:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  68:	8b 43 04             	mov    0x4(%ebx),%eax
  6b:	01 d0                	add    %edx,%eax
  6d:	8b 00                	mov    (%eax),%eax
  6f:	83 ec 04             	sub    $0x4,%esp
  72:	50                   	push   %eax
  73:	68 91 08 00 00       	push   $0x891
  78:	6a 02                	push   $0x2
  7a:	e8 34 04 00 00       	call   4b3 <printf>
  7f:	83 c4 10             	add    $0x10,%esp
      break;
  82:	eb 0b                	jmp    8f <main+0x8f>
  for (i = 1; i < argc; i++) {
  84:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8b:	3b 03                	cmp    (%ebx),%eax
  8d:	7c ae                	jl     3d <main+0x3d>
    }
  }

  exit();
  8f:	e8 7b 02 00 00       	call   30f <exit>

00000094 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  94:	55                   	push   %ebp
  95:	89 e5                	mov    %esp,%ebp
  97:	57                   	push   %edi
  98:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  99:	8b 4d 08             	mov    0x8(%ebp),%ecx
  9c:	8b 55 10             	mov    0x10(%ebp),%edx
  9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  a2:	89 cb                	mov    %ecx,%ebx
  a4:	89 df                	mov    %ebx,%edi
  a6:	89 d1                	mov    %edx,%ecx
  a8:	fc                   	cld    
  a9:	f3 aa                	rep stos %al,%es:(%edi)
  ab:	89 ca                	mov    %ecx,%edx
  ad:	89 fb                	mov    %edi,%ebx
  af:	89 5d 08             	mov    %ebx,0x8(%ebp)
  b2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  b5:	90                   	nop
  b6:	5b                   	pop    %ebx
  b7:	5f                   	pop    %edi
  b8:	5d                   	pop    %ebp
  b9:	c3                   	ret    

000000ba <strcpy>:
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user.h"
#include "kernel/x86.h"

char *strcpy(char *s, char *t) {
  ba:	f3 0f 1e fb          	endbr32 
  be:	55                   	push   %ebp
  bf:	89 e5                	mov    %esp,%ebp
  c1:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  c4:	8b 45 08             	mov    0x8(%ebp),%eax
  c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while ((*s++ = *t++) != 0)
  ca:	90                   	nop
  cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  ce:	8d 42 01             	lea    0x1(%edx),%eax
  d1:	89 45 0c             	mov    %eax,0xc(%ebp)
  d4:	8b 45 08             	mov    0x8(%ebp),%eax
  d7:	8d 48 01             	lea    0x1(%eax),%ecx
  da:	89 4d 08             	mov    %ecx,0x8(%ebp)
  dd:	0f b6 12             	movzbl (%edx),%edx
  e0:	88 10                	mov    %dl,(%eax)
  e2:	0f b6 00             	movzbl (%eax),%eax
  e5:	84 c0                	test   %al,%al
  e7:	75 e2                	jne    cb <strcpy+0x11>
    ;
  return os;
  e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  ec:	c9                   	leave  
  ed:	c3                   	ret    

000000ee <strcmp>:

int strcmp(const char *p, const char *q) {
  ee:	f3 0f 1e fb          	endbr32 
  f2:	55                   	push   %ebp
  f3:	89 e5                	mov    %esp,%ebp
  while (*p && *p == *q)
  f5:	eb 08                	jmp    ff <strcmp+0x11>
    p++, q++;
  f7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  fb:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while (*p && *p == *q)
  ff:	8b 45 08             	mov    0x8(%ebp),%eax
 102:	0f b6 00             	movzbl (%eax),%eax
 105:	84 c0                	test   %al,%al
 107:	74 10                	je     119 <strcmp+0x2b>
 109:	8b 45 08             	mov    0x8(%ebp),%eax
 10c:	0f b6 10             	movzbl (%eax),%edx
 10f:	8b 45 0c             	mov    0xc(%ebp),%eax
 112:	0f b6 00             	movzbl (%eax),%eax
 115:	38 c2                	cmp    %al,%dl
 117:	74 de                	je     f7 <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
 119:	8b 45 08             	mov    0x8(%ebp),%eax
 11c:	0f b6 00             	movzbl (%eax),%eax
 11f:	0f b6 d0             	movzbl %al,%edx
 122:	8b 45 0c             	mov    0xc(%ebp),%eax
 125:	0f b6 00             	movzbl (%eax),%eax
 128:	0f b6 c0             	movzbl %al,%eax
 12b:	29 c2                	sub    %eax,%edx
 12d:	89 d0                	mov    %edx,%eax
}
 12f:	5d                   	pop    %ebp
 130:	c3                   	ret    

00000131 <strlen>:

uint strlen(char *s) {
 131:	f3 0f 1e fb          	endbr32 
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 10             	sub    $0x10,%esp
  int n;

  for (n = 0; s[n]; n++)
 13b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 142:	eb 04                	jmp    148 <strlen+0x17>
 144:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 148:	8b 55 fc             	mov    -0x4(%ebp),%edx
 14b:	8b 45 08             	mov    0x8(%ebp),%eax
 14e:	01 d0                	add    %edx,%eax
 150:	0f b6 00             	movzbl (%eax),%eax
 153:	84 c0                	test   %al,%al
 155:	75 ed                	jne    144 <strlen+0x13>
    ;
  return n;
 157:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 15a:	c9                   	leave  
 15b:	c3                   	ret    

0000015c <memset>:

void *memset(void *dst, int c, uint n) {
 15c:	f3 0f 1e fb          	endbr32 
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 163:	8b 45 10             	mov    0x10(%ebp),%eax
 166:	50                   	push   %eax
 167:	ff 75 0c             	pushl  0xc(%ebp)
 16a:	ff 75 08             	pushl  0x8(%ebp)
 16d:	e8 22 ff ff ff       	call   94 <stosb>
 172:	83 c4 0c             	add    $0xc,%esp
  return dst;
 175:	8b 45 08             	mov    0x8(%ebp),%eax
}
 178:	c9                   	leave  
 179:	c3                   	ret    

0000017a <strchr>:

char *strchr(const char *s, char c) {
 17a:	f3 0f 1e fb          	endbr32 
 17e:	55                   	push   %ebp
 17f:	89 e5                	mov    %esp,%ebp
 181:	83 ec 04             	sub    $0x4,%esp
 184:	8b 45 0c             	mov    0xc(%ebp),%eax
 187:	88 45 fc             	mov    %al,-0x4(%ebp)
  for (; *s; s++)
 18a:	eb 14                	jmp    1a0 <strchr+0x26>
    if (*s == c)
 18c:	8b 45 08             	mov    0x8(%ebp),%eax
 18f:	0f b6 00             	movzbl (%eax),%eax
 192:	38 45 fc             	cmp    %al,-0x4(%ebp)
 195:	75 05                	jne    19c <strchr+0x22>
      return (char *)s;
 197:	8b 45 08             	mov    0x8(%ebp),%eax
 19a:	eb 13                	jmp    1af <strchr+0x35>
  for (; *s; s++)
 19c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1a0:	8b 45 08             	mov    0x8(%ebp),%eax
 1a3:	0f b6 00             	movzbl (%eax),%eax
 1a6:	84 c0                	test   %al,%al
 1a8:	75 e2                	jne    18c <strchr+0x12>
  return 0;
 1aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1af:	c9                   	leave  
 1b0:	c3                   	ret    

000001b1 <gets>:

char *gets(char *buf, int max) {
 1b1:	f3 0f 1e fb          	endbr32 
 1b5:	55                   	push   %ebp
 1b6:	89 e5                	mov    %esp,%ebp
 1b8:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 1bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1c2:	eb 42                	jmp    206 <gets+0x55>
    cc = read(0, &c, 1);
 1c4:	83 ec 04             	sub    $0x4,%esp
 1c7:	6a 01                	push   $0x1
 1c9:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1cc:	50                   	push   %eax
 1cd:	6a 00                	push   $0x0
 1cf:	e8 53 01 00 00       	call   327 <read>
 1d4:	83 c4 10             	add    $0x10,%esp
 1d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (cc < 1)
 1da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1de:	7e 33                	jle    213 <gets+0x62>
      break;
    buf[i++] = c;
 1e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1e3:	8d 50 01             	lea    0x1(%eax),%edx
 1e6:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1e9:	89 c2                	mov    %eax,%edx
 1eb:	8b 45 08             	mov    0x8(%ebp),%eax
 1ee:	01 c2                	add    %eax,%edx
 1f0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1f4:	88 02                	mov    %al,(%edx)
    if (c == '\n' || c == '\r')
 1f6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1fa:	3c 0a                	cmp    $0xa,%al
 1fc:	74 16                	je     214 <gets+0x63>
 1fe:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 202:	3c 0d                	cmp    $0xd,%al
 204:	74 0e                	je     214 <gets+0x63>
  for (i = 0; i + 1 < max;) {
 206:	8b 45 f4             	mov    -0xc(%ebp),%eax
 209:	83 c0 01             	add    $0x1,%eax
 20c:	39 45 0c             	cmp    %eax,0xc(%ebp)
 20f:	7f b3                	jg     1c4 <gets+0x13>
 211:	eb 01                	jmp    214 <gets+0x63>
      break;
 213:	90                   	nop
      break;
  }
  buf[i] = '\0';
 214:	8b 55 f4             	mov    -0xc(%ebp),%edx
 217:	8b 45 08             	mov    0x8(%ebp),%eax
 21a:	01 d0                	add    %edx,%eax
 21c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 21f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 222:	c9                   	leave  
 223:	c3                   	ret    

00000224 <stat>:

int stat(char *n, struct stat *st) {
 224:	f3 0f 1e fb          	endbr32 
 228:	55                   	push   %ebp
 229:	89 e5                	mov    %esp,%ebp
 22b:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 22e:	83 ec 08             	sub    $0x8,%esp
 231:	6a 00                	push   $0x0
 233:	ff 75 08             	pushl  0x8(%ebp)
 236:	e8 14 01 00 00       	call   34f <open>
 23b:	83 c4 10             	add    $0x10,%esp
 23e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (fd < 0)
 241:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 245:	79 07                	jns    24e <stat+0x2a>
    return -1;
 247:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 24c:	eb 25                	jmp    273 <stat+0x4f>
  r = fstat(fd, st);
 24e:	83 ec 08             	sub    $0x8,%esp
 251:	ff 75 0c             	pushl  0xc(%ebp)
 254:	ff 75 f4             	pushl  -0xc(%ebp)
 257:	e8 0b 01 00 00       	call   367 <fstat>
 25c:	83 c4 10             	add    $0x10,%esp
 25f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 262:	83 ec 0c             	sub    $0xc,%esp
 265:	ff 75 f4             	pushl  -0xc(%ebp)
 268:	e8 ca 00 00 00       	call   337 <close>
 26d:	83 c4 10             	add    $0x10,%esp
  return r;
 270:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 273:	c9                   	leave  
 274:	c3                   	ret    

00000275 <atoi>:

int atoi(const char *s) {
 275:	f3 0f 1e fb          	endbr32 
 279:	55                   	push   %ebp
 27a:	89 e5                	mov    %esp,%ebp
 27c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 27f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while ('0' <= *s && *s <= '9')
 286:	eb 25                	jmp    2ad <atoi+0x38>
    n = n * 10 + *s++ - '0';
 288:	8b 55 fc             	mov    -0x4(%ebp),%edx
 28b:	89 d0                	mov    %edx,%eax
 28d:	c1 e0 02             	shl    $0x2,%eax
 290:	01 d0                	add    %edx,%eax
 292:	01 c0                	add    %eax,%eax
 294:	89 c1                	mov    %eax,%ecx
 296:	8b 45 08             	mov    0x8(%ebp),%eax
 299:	8d 50 01             	lea    0x1(%eax),%edx
 29c:	89 55 08             	mov    %edx,0x8(%ebp)
 29f:	0f b6 00             	movzbl (%eax),%eax
 2a2:	0f be c0             	movsbl %al,%eax
 2a5:	01 c8                	add    %ecx,%eax
 2a7:	83 e8 30             	sub    $0x30,%eax
 2aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while ('0' <= *s && *s <= '9')
 2ad:	8b 45 08             	mov    0x8(%ebp),%eax
 2b0:	0f b6 00             	movzbl (%eax),%eax
 2b3:	3c 2f                	cmp    $0x2f,%al
 2b5:	7e 0a                	jle    2c1 <atoi+0x4c>
 2b7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ba:	0f b6 00             	movzbl (%eax),%eax
 2bd:	3c 39                	cmp    $0x39,%al
 2bf:	7e c7                	jle    288 <atoi+0x13>
  return n;
 2c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2c4:	c9                   	leave  
 2c5:	c3                   	ret    

000002c6 <memmove>:

void *memmove(void *vdst, void *vsrc, int n) {
 2c6:	f3 0f 1e fb          	endbr32 
 2ca:	55                   	push   %ebp
 2cb:	89 e5                	mov    %esp,%ebp
 2cd:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 2d0:	8b 45 08             	mov    0x8(%ebp),%eax
 2d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2d6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while (n-- > 0)
 2dc:	eb 17                	jmp    2f5 <memmove+0x2f>
    *dst++ = *src++;
 2de:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2e1:	8d 42 01             	lea    0x1(%edx),%eax
 2e4:	89 45 f8             	mov    %eax,-0x8(%ebp)
 2e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2ea:	8d 48 01             	lea    0x1(%eax),%ecx
 2ed:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 2f0:	0f b6 12             	movzbl (%edx),%edx
 2f3:	88 10                	mov    %dl,(%eax)
  while (n-- > 0)
 2f5:	8b 45 10             	mov    0x10(%ebp),%eax
 2f8:	8d 50 ff             	lea    -0x1(%eax),%edx
 2fb:	89 55 10             	mov    %edx,0x10(%ebp)
 2fe:	85 c0                	test   %eax,%eax
 300:	7f dc                	jg     2de <memmove+0x18>
  return vdst;
 302:	8b 45 08             	mov    0x8(%ebp),%eax
}
 305:	c9                   	leave  
 306:	c3                   	ret    

00000307 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 307:	b8 01 00 00 00       	mov    $0x1,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret    

0000030f <exit>:
SYSCALL(exit)
 30f:	b8 02 00 00 00       	mov    $0x2,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    

00000317 <wait>:
SYSCALL(wait)
 317:	b8 03 00 00 00       	mov    $0x3,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <pipe>:
SYSCALL(pipe)
 31f:	b8 04 00 00 00       	mov    $0x4,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <read>:
SYSCALL(read)
 327:	b8 05 00 00 00       	mov    $0x5,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <write>:
SYSCALL(write)
 32f:	b8 10 00 00 00       	mov    $0x10,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <close>:
SYSCALL(close)
 337:	b8 15 00 00 00       	mov    $0x15,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <kill>:
SYSCALL(kill)
 33f:	b8 06 00 00 00       	mov    $0x6,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <exec>:
SYSCALL(exec)
 347:	b8 07 00 00 00       	mov    $0x7,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <open>:
SYSCALL(open)
 34f:	b8 0f 00 00 00       	mov    $0xf,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <mknod>:
SYSCALL(mknod)
 357:	b8 11 00 00 00       	mov    $0x11,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <unlink>:
SYSCALL(unlink)
 35f:	b8 12 00 00 00       	mov    $0x12,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <fstat>:
SYSCALL(fstat)
 367:	b8 08 00 00 00       	mov    $0x8,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <link>:
SYSCALL(link)
 36f:	b8 13 00 00 00       	mov    $0x13,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <mkdir>:
SYSCALL(mkdir)
 377:	b8 14 00 00 00       	mov    $0x14,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <chdir>:
SYSCALL(chdir)
 37f:	b8 09 00 00 00       	mov    $0x9,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <dup>:
SYSCALL(dup)
 387:	b8 0a 00 00 00       	mov    $0xa,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <getpid>:
SYSCALL(getpid)
 38f:	b8 0b 00 00 00       	mov    $0xb,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <sbrk>:
SYSCALL(sbrk)
 397:	b8 0c 00 00 00       	mov    $0xc,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <sleep>:
SYSCALL(sleep)
 39f:	b8 0d 00 00 00       	mov    $0xd,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret    

000003a7 <uptime>:
SYSCALL(uptime)
 3a7:	b8 0e 00 00 00       	mov    $0xe,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret    

000003af <trace>:
SYSCALL(trace)
 3af:	b8 16 00 00 00       	mov    $0x16,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret    

000003b7 <setEFlag>:
SYSCALL(setEFlag)
 3b7:	b8 17 00 00 00       	mov    $0x17,%eax
 3bc:	cd 40                	int    $0x40
 3be:	c3                   	ret    

000003bf <setSFlag>:
SYSCALL(setSFlag)
 3bf:	b8 18 00 00 00       	mov    $0x18,%eax
 3c4:	cd 40                	int    $0x40
 3c6:	c3                   	ret    

000003c7 <setFFlag>:
SYSCALL(setFFlag)
 3c7:	b8 19 00 00 00       	mov    $0x19,%eax
 3cc:	cd 40                	int    $0x40
 3ce:	c3                   	ret    

000003cf <dump>:
 3cf:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3d4:	cd 40                	int    $0x40
 3d6:	c3                   	ret    

000003d7 <putc>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user.h"

static void putc(int fd, char c) { write(fd, &c, 1); }
 3d7:	f3 0f 1e fb          	endbr32 
 3db:	55                   	push   %ebp
 3dc:	89 e5                	mov    %esp,%ebp
 3de:	83 ec 18             	sub    $0x18,%esp
 3e1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e4:	88 45 f4             	mov    %al,-0xc(%ebp)
 3e7:	83 ec 04             	sub    $0x4,%esp
 3ea:	6a 01                	push   $0x1
 3ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3ef:	50                   	push   %eax
 3f0:	ff 75 08             	pushl  0x8(%ebp)
 3f3:	e8 37 ff ff ff       	call   32f <write>
 3f8:	83 c4 10             	add    $0x10,%esp
 3fb:	90                   	nop
 3fc:	c9                   	leave  
 3fd:	c3                   	ret    

000003fe <printint>:

static void printint(int fd, int xx, int base, int sgn) {
 3fe:	f3 0f 1e fb          	endbr32 
 402:	55                   	push   %ebp
 403:	89 e5                	mov    %esp,%ebp
 405:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 408:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if (sgn && xx < 0) {
 40f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 413:	74 17                	je     42c <printint+0x2e>
 415:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 419:	79 11                	jns    42c <printint+0x2e>
    neg = 1;
 41b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 422:	8b 45 0c             	mov    0xc(%ebp),%eax
 425:	f7 d8                	neg    %eax
 427:	89 45 ec             	mov    %eax,-0x14(%ebp)
 42a:	eb 06                	jmp    432 <printint+0x34>
  } else {
    x = xx;
 42c:	8b 45 0c             	mov    0xc(%ebp),%eax
 42f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 432:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do {
    buf[i++] = digits[x % base];
 439:	8b 4d 10             	mov    0x10(%ebp),%ecx
 43c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 43f:	ba 00 00 00 00       	mov    $0x0,%edx
 444:	f7 f1                	div    %ecx
 446:	89 d1                	mov    %edx,%ecx
 448:	8b 45 f4             	mov    -0xc(%ebp),%eax
 44b:	8d 50 01             	lea    0x1(%eax),%edx
 44e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 451:	0f b6 91 fc 0a 00 00 	movzbl 0xafc(%ecx),%edx
 458:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  } while ((x /= base) != 0);
 45c:	8b 4d 10             	mov    0x10(%ebp),%ecx
 45f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 462:	ba 00 00 00 00       	mov    $0x0,%edx
 467:	f7 f1                	div    %ecx
 469:	89 45 ec             	mov    %eax,-0x14(%ebp)
 46c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 470:	75 c7                	jne    439 <printint+0x3b>
  if (neg)
 472:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 476:	74 2d                	je     4a5 <printint+0xa7>
    buf[i++] = '-';
 478:	8b 45 f4             	mov    -0xc(%ebp),%eax
 47b:	8d 50 01             	lea    0x1(%eax),%edx
 47e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 481:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while (--i >= 0)
 486:	eb 1d                	jmp    4a5 <printint+0xa7>
    putc(fd, buf[i]);
 488:	8d 55 dc             	lea    -0x24(%ebp),%edx
 48b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 48e:	01 d0                	add    %edx,%eax
 490:	0f b6 00             	movzbl (%eax),%eax
 493:	0f be c0             	movsbl %al,%eax
 496:	83 ec 08             	sub    $0x8,%esp
 499:	50                   	push   %eax
 49a:	ff 75 08             	pushl  0x8(%ebp)
 49d:	e8 35 ff ff ff       	call   3d7 <putc>
 4a2:	83 c4 10             	add    $0x10,%esp
  while (--i >= 0)
 4a5:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4ad:	79 d9                	jns    488 <printint+0x8a>
}
 4af:	90                   	nop
 4b0:	90                   	nop
 4b1:	c9                   	leave  
 4b2:	c3                   	ret    

000004b3 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void printf(int fd, char *fmt, ...) {
 4b3:	f3 0f 1e fb          	endbr32 
 4b7:	55                   	push   %ebp
 4b8:	89 e5                	mov    %esp,%ebp
 4ba:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4bd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint *)(void *)&fmt + 1;
 4c4:	8d 45 0c             	lea    0xc(%ebp),%eax
 4c7:	83 c0 04             	add    $0x4,%eax
 4ca:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for (i = 0; fmt[i]; i++) {
 4cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4d4:	e9 59 01 00 00       	jmp    632 <printf+0x17f>
    c = fmt[i] & 0xff;
 4d9:	8b 55 0c             	mov    0xc(%ebp),%edx
 4dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4df:	01 d0                	add    %edx,%eax
 4e1:	0f b6 00             	movzbl (%eax),%eax
 4e4:	0f be c0             	movsbl %al,%eax
 4e7:	25 ff 00 00 00       	and    $0xff,%eax
 4ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (state == 0) {
 4ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4f3:	75 2c                	jne    521 <printf+0x6e>
      if (c == '%') {
 4f5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4f9:	75 0c                	jne    507 <printf+0x54>
        state = '%';
 4fb:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 502:	e9 27 01 00 00       	jmp    62e <printf+0x17b>
      } else {
        putc(fd, c);
 507:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 50a:	0f be c0             	movsbl %al,%eax
 50d:	83 ec 08             	sub    $0x8,%esp
 510:	50                   	push   %eax
 511:	ff 75 08             	pushl  0x8(%ebp)
 514:	e8 be fe ff ff       	call   3d7 <putc>
 519:	83 c4 10             	add    $0x10,%esp
 51c:	e9 0d 01 00 00       	jmp    62e <printf+0x17b>
      }
    } else if (state == '%') {
 521:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 525:	0f 85 03 01 00 00    	jne    62e <printf+0x17b>
      if (c == 'd') {
 52b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 52f:	75 1e                	jne    54f <printf+0x9c>
        printint(fd, *ap, 10, 1);
 531:	8b 45 e8             	mov    -0x18(%ebp),%eax
 534:	8b 00                	mov    (%eax),%eax
 536:	6a 01                	push   $0x1
 538:	6a 0a                	push   $0xa
 53a:	50                   	push   %eax
 53b:	ff 75 08             	pushl  0x8(%ebp)
 53e:	e8 bb fe ff ff       	call   3fe <printint>
 543:	83 c4 10             	add    $0x10,%esp
        ap++;
 546:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 54a:	e9 d8 00 00 00       	jmp    627 <printf+0x174>
      } else if (c == 'x' || c == 'p') {
 54f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 553:	74 06                	je     55b <printf+0xa8>
 555:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 559:	75 1e                	jne    579 <printf+0xc6>
        printint(fd, *ap, 16, 0);
 55b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 55e:	8b 00                	mov    (%eax),%eax
 560:	6a 00                	push   $0x0
 562:	6a 10                	push   $0x10
 564:	50                   	push   %eax
 565:	ff 75 08             	pushl  0x8(%ebp)
 568:	e8 91 fe ff ff       	call   3fe <printint>
 56d:	83 c4 10             	add    $0x10,%esp
        ap++;
 570:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 574:	e9 ae 00 00 00       	jmp    627 <printf+0x174>
      } else if (c == 's') {
 579:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 57d:	75 43                	jne    5c2 <printf+0x10f>
        s = (char *)*ap;
 57f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 582:	8b 00                	mov    (%eax),%eax
 584:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 587:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if (s == 0)
 58b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 58f:	75 25                	jne    5b6 <printf+0x103>
          s = "(null)";
 591:	c7 45 f4 ad 08 00 00 	movl   $0x8ad,-0xc(%ebp)
        while (*s != 0) {
 598:	eb 1c                	jmp    5b6 <printf+0x103>
          putc(fd, *s);
 59a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 59d:	0f b6 00             	movzbl (%eax),%eax
 5a0:	0f be c0             	movsbl %al,%eax
 5a3:	83 ec 08             	sub    $0x8,%esp
 5a6:	50                   	push   %eax
 5a7:	ff 75 08             	pushl  0x8(%ebp)
 5aa:	e8 28 fe ff ff       	call   3d7 <putc>
 5af:	83 c4 10             	add    $0x10,%esp
          s++;
 5b2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while (*s != 0) {
 5b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b9:	0f b6 00             	movzbl (%eax),%eax
 5bc:	84 c0                	test   %al,%al
 5be:	75 da                	jne    59a <printf+0xe7>
 5c0:	eb 65                	jmp    627 <printf+0x174>
        }
      } else if (c == 'c') {
 5c2:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5c6:	75 1d                	jne    5e5 <printf+0x132>
        putc(fd, *ap);
 5c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5cb:	8b 00                	mov    (%eax),%eax
 5cd:	0f be c0             	movsbl %al,%eax
 5d0:	83 ec 08             	sub    $0x8,%esp
 5d3:	50                   	push   %eax
 5d4:	ff 75 08             	pushl  0x8(%ebp)
 5d7:	e8 fb fd ff ff       	call   3d7 <putc>
 5dc:	83 c4 10             	add    $0x10,%esp
        ap++;
 5df:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5e3:	eb 42                	jmp    627 <printf+0x174>
      } else if (c == '%') {
 5e5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5e9:	75 17                	jne    602 <printf+0x14f>
        putc(fd, c);
 5eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ee:	0f be c0             	movsbl %al,%eax
 5f1:	83 ec 08             	sub    $0x8,%esp
 5f4:	50                   	push   %eax
 5f5:	ff 75 08             	pushl  0x8(%ebp)
 5f8:	e8 da fd ff ff       	call   3d7 <putc>
 5fd:	83 c4 10             	add    $0x10,%esp
 600:	eb 25                	jmp    627 <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 602:	83 ec 08             	sub    $0x8,%esp
 605:	6a 25                	push   $0x25
 607:	ff 75 08             	pushl  0x8(%ebp)
 60a:	e8 c8 fd ff ff       	call   3d7 <putc>
 60f:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 612:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 615:	0f be c0             	movsbl %al,%eax
 618:	83 ec 08             	sub    $0x8,%esp
 61b:	50                   	push   %eax
 61c:	ff 75 08             	pushl  0x8(%ebp)
 61f:	e8 b3 fd ff ff       	call   3d7 <putc>
 624:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 627:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for (i = 0; fmt[i]; i++) {
 62e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 632:	8b 55 0c             	mov    0xc(%ebp),%edx
 635:	8b 45 f0             	mov    -0x10(%ebp),%eax
 638:	01 d0                	add    %edx,%eax
 63a:	0f b6 00             	movzbl (%eax),%eax
 63d:	84 c0                	test   %al,%al
 63f:	0f 85 94 fe ff ff    	jne    4d9 <printf+0x26>
    }
  }
}
 645:	90                   	nop
 646:	90                   	nop
 647:	c9                   	leave  
 648:	c3                   	ret    

00000649 <free>:
typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
 649:	f3 0f 1e fb          	endbr32 
 64d:	55                   	push   %ebp
 64e:	89 e5                	mov    %esp,%ebp
 650:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header *)ap - 1;
 653:	8b 45 08             	mov    0x8(%ebp),%eax
 656:	83 e8 08             	sub    $0x8,%eax
 659:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 65c:	a1 18 0b 00 00       	mov    0xb18,%eax
 661:	89 45 fc             	mov    %eax,-0x4(%ebp)
 664:	eb 24                	jmp    68a <free+0x41>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 666:	8b 45 fc             	mov    -0x4(%ebp),%eax
 669:	8b 00                	mov    (%eax),%eax
 66b:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 66e:	72 12                	jb     682 <free+0x39>
 670:	8b 45 f8             	mov    -0x8(%ebp),%eax
 673:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 676:	77 24                	ja     69c <free+0x53>
 678:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67b:	8b 00                	mov    (%eax),%eax
 67d:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 680:	72 1a                	jb     69c <free+0x53>
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 682:	8b 45 fc             	mov    -0x4(%ebp),%eax
 685:	8b 00                	mov    (%eax),%eax
 687:	89 45 fc             	mov    %eax,-0x4(%ebp)
 68a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 690:	76 d4                	jbe    666 <free+0x1d>
 692:	8b 45 fc             	mov    -0x4(%ebp),%eax
 695:	8b 00                	mov    (%eax),%eax
 697:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 69a:	73 ca                	jae    666 <free+0x1d>
      break;
  if (bp + bp->s.size == p->s.ptr) {
 69c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69f:	8b 40 04             	mov    0x4(%eax),%eax
 6a2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ac:	01 c2                	add    %eax,%edx
 6ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b1:	8b 00                	mov    (%eax),%eax
 6b3:	39 c2                	cmp    %eax,%edx
 6b5:	75 24                	jne    6db <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 6b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ba:	8b 50 04             	mov    0x4(%eax),%edx
 6bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c0:	8b 00                	mov    (%eax),%eax
 6c2:	8b 40 04             	mov    0x4(%eax),%eax
 6c5:	01 c2                	add    %eax,%edx
 6c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ca:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d0:	8b 00                	mov    (%eax),%eax
 6d2:	8b 10                	mov    (%eax),%edx
 6d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d7:	89 10                	mov    %edx,(%eax)
 6d9:	eb 0a                	jmp    6e5 <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 6db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6de:	8b 10                	mov    (%eax),%edx
 6e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e3:	89 10                	mov    %edx,(%eax)
  if (p + p->s.size == bp) {
 6e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e8:	8b 40 04             	mov    0x4(%eax),%eax
 6eb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f5:	01 d0                	add    %edx,%eax
 6f7:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6fa:	75 20                	jne    71c <free+0xd3>
    p->s.size += bp->s.size;
 6fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ff:	8b 50 04             	mov    0x4(%eax),%edx
 702:	8b 45 f8             	mov    -0x8(%ebp),%eax
 705:	8b 40 04             	mov    0x4(%eax),%eax
 708:	01 c2                	add    %eax,%edx
 70a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 710:	8b 45 f8             	mov    -0x8(%ebp),%eax
 713:	8b 10                	mov    (%eax),%edx
 715:	8b 45 fc             	mov    -0x4(%ebp),%eax
 718:	89 10                	mov    %edx,(%eax)
 71a:	eb 08                	jmp    724 <free+0xdb>
  } else
    p->s.ptr = bp;
 71c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 722:	89 10                	mov    %edx,(%eax)
  freep = p;
 724:	8b 45 fc             	mov    -0x4(%ebp),%eax
 727:	a3 18 0b 00 00       	mov    %eax,0xb18
}
 72c:	90                   	nop
 72d:	c9                   	leave  
 72e:	c3                   	ret    

0000072f <morecore>:

static Header *morecore(uint nu) {
 72f:	f3 0f 1e fb          	endbr32 
 733:	55                   	push   %ebp
 734:	89 e5                	mov    %esp,%ebp
 736:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if (nu < 4096)
 739:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 740:	77 07                	ja     749 <morecore+0x1a>
    nu = 4096;
 742:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 749:	8b 45 08             	mov    0x8(%ebp),%eax
 74c:	c1 e0 03             	shl    $0x3,%eax
 74f:	83 ec 0c             	sub    $0xc,%esp
 752:	50                   	push   %eax
 753:	e8 3f fc ff ff       	call   397 <sbrk>
 758:	83 c4 10             	add    $0x10,%esp
 75b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (p == (char *)-1)
 75e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 762:	75 07                	jne    76b <morecore+0x3c>
    return 0;
 764:	b8 00 00 00 00       	mov    $0x0,%eax
 769:	eb 26                	jmp    791 <morecore+0x62>
  hp = (Header *)p;
 76b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 771:	8b 45 f0             	mov    -0x10(%ebp),%eax
 774:	8b 55 08             	mov    0x8(%ebp),%edx
 777:	89 50 04             	mov    %edx,0x4(%eax)
  free((void *)(hp + 1));
 77a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77d:	83 c0 08             	add    $0x8,%eax
 780:	83 ec 0c             	sub    $0xc,%esp
 783:	50                   	push   %eax
 784:	e8 c0 fe ff ff       	call   649 <free>
 789:	83 c4 10             	add    $0x10,%esp
  return freep;
 78c:	a1 18 0b 00 00       	mov    0xb18,%eax
}
 791:	c9                   	leave  
 792:	c3                   	ret    

00000793 <malloc>:

void *malloc(uint nbytes) {
 793:	f3 0f 1e fb          	endbr32 
 797:	55                   	push   %ebp
 798:	89 e5                	mov    %esp,%ebp
 79a:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 79d:	8b 45 08             	mov    0x8(%ebp),%eax
 7a0:	83 c0 07             	add    $0x7,%eax
 7a3:	c1 e8 03             	shr    $0x3,%eax
 7a6:	83 c0 01             	add    $0x1,%eax
 7a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if ((prevp = freep) == 0) {
 7ac:	a1 18 0b 00 00       	mov    0xb18,%eax
 7b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7b8:	75 23                	jne    7dd <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 7ba:	c7 45 f0 10 0b 00 00 	movl   $0xb10,-0x10(%ebp)
 7c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c4:	a3 18 0b 00 00       	mov    %eax,0xb18
 7c9:	a1 18 0b 00 00       	mov    0xb18,%eax
 7ce:	a3 10 0b 00 00       	mov    %eax,0xb10
    base.s.size = 0;
 7d3:	c7 05 14 0b 00 00 00 	movl   $0x0,0xb14
 7da:	00 00 00 
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 7dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e0:	8b 00                	mov    (%eax),%eax
 7e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p->s.size >= nunits) {
 7e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e8:	8b 40 04             	mov    0x4(%eax),%eax
 7eb:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7ee:	77 4d                	ja     83d <malloc+0xaa>
      if (p->s.size == nunits)
 7f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f3:	8b 40 04             	mov    0x4(%eax),%eax
 7f6:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7f9:	75 0c                	jne    807 <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 7fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fe:	8b 10                	mov    (%eax),%edx
 800:	8b 45 f0             	mov    -0x10(%ebp),%eax
 803:	89 10                	mov    %edx,(%eax)
 805:	eb 26                	jmp    82d <malloc+0x9a>
      else {
        p->s.size -= nunits;
 807:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80a:	8b 40 04             	mov    0x4(%eax),%eax
 80d:	2b 45 ec             	sub    -0x14(%ebp),%eax
 810:	89 c2                	mov    %eax,%edx
 812:	8b 45 f4             	mov    -0xc(%ebp),%eax
 815:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 818:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81b:	8b 40 04             	mov    0x4(%eax),%eax
 81e:	c1 e0 03             	shl    $0x3,%eax
 821:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 824:	8b 45 f4             	mov    -0xc(%ebp),%eax
 827:	8b 55 ec             	mov    -0x14(%ebp),%edx
 82a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 82d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 830:	a3 18 0b 00 00       	mov    %eax,0xb18
      return (void *)(p + 1);
 835:	8b 45 f4             	mov    -0xc(%ebp),%eax
 838:	83 c0 08             	add    $0x8,%eax
 83b:	eb 3b                	jmp    878 <malloc+0xe5>
    }
    if (p == freep)
 83d:	a1 18 0b 00 00       	mov    0xb18,%eax
 842:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 845:	75 1e                	jne    865 <malloc+0xd2>
      if ((p = morecore(nunits)) == 0)
 847:	83 ec 0c             	sub    $0xc,%esp
 84a:	ff 75 ec             	pushl  -0x14(%ebp)
 84d:	e8 dd fe ff ff       	call   72f <morecore>
 852:	83 c4 10             	add    $0x10,%esp
 855:	89 45 f4             	mov    %eax,-0xc(%ebp)
 858:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 85c:	75 07                	jne    865 <malloc+0xd2>
        return 0;
 85e:	b8 00 00 00 00       	mov    $0x0,%eax
 863:	eb 13                	jmp    878 <malloc+0xe5>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 865:	8b 45 f4             	mov    -0xc(%ebp),%eax
 868:	89 45 f0             	mov    %eax,-0x10(%ebp)
 86b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86e:	8b 00                	mov    (%eax),%eax
 870:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p->s.size >= nunits) {
 873:	e9 6d ff ff ff       	jmp    7e5 <malloc+0x52>
  }
}
 878:	c9                   	leave  
 879:	c3                   	ret    
