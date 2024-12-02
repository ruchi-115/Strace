
user/_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "kernel/fcntl.h"

char *argv[] = {"sh", 0};

int main(void) {
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	51                   	push   %ecx
  12:	83 ec 14             	sub    $0x14,%esp
  int pid, wpid;
  printf(1, "init: HERE\n");
  15:	83 ec 08             	sub    $0x8,%esp
  18:	68 00 09 00 00       	push   $0x900
  1d:	6a 01                	push   $0x1
  1f:	e8 12 05 00 00       	call   536 <printf>
  24:	83 c4 10             	add    $0x10,%esp

  if (open("console", O_RDWR) < 0) {
  27:	83 ec 08             	sub    $0x8,%esp
  2a:	6a 02                	push   $0x2
  2c:	68 0c 09 00 00       	push   $0x90c
  31:	e8 9c 03 00 00       	call   3d2 <open>
  36:	83 c4 10             	add    $0x10,%esp
  39:	85 c0                	test   %eax,%eax
  3b:	79 26                	jns    63 <main+0x63>
    mknod("console", 1, 1);
  3d:	83 ec 04             	sub    $0x4,%esp
  40:	6a 01                	push   $0x1
  42:	6a 01                	push   $0x1
  44:	68 0c 09 00 00       	push   $0x90c
  49:	e8 8c 03 00 00       	call   3da <mknod>
  4e:	83 c4 10             	add    $0x10,%esp
    open("console", O_RDWR);
  51:	83 ec 08             	sub    $0x8,%esp
  54:	6a 02                	push   $0x2
  56:	68 0c 09 00 00       	push   $0x90c
  5b:	e8 72 03 00 00       	call   3d2 <open>
  60:	83 c4 10             	add    $0x10,%esp
  }
  dup(0); // stdout
  63:	83 ec 0c             	sub    $0xc,%esp
  66:	6a 00                	push   $0x0
  68:	e8 9d 03 00 00       	call   40a <dup>
  6d:	83 c4 10             	add    $0x10,%esp
  dup(0); // stderr
  70:	83 ec 0c             	sub    $0xc,%esp
  73:	6a 00                	push   $0x0
  75:	e8 90 03 00 00       	call   40a <dup>
  7a:	83 c4 10             	add    $0x10,%esp

  for (;;) {
    printf(1, "init: starting sh\n");
  7d:	83 ec 08             	sub    $0x8,%esp
  80:	68 14 09 00 00       	push   $0x914
  85:	6a 01                	push   $0x1
  87:	e8 aa 04 00 00       	call   536 <printf>
  8c:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  8f:	e8 f6 02 00 00       	call   38a <fork>
  94:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (pid < 0) {
  97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  9b:	79 17                	jns    b4 <main+0xb4>
      printf(1, "init: fork failed\n");
  9d:	83 ec 08             	sub    $0x8,%esp
  a0:	68 27 09 00 00       	push   $0x927
  a5:	6a 01                	push   $0x1
  a7:	e8 8a 04 00 00       	call   536 <printf>
  ac:	83 c4 10             	add    $0x10,%esp
      exit();
  af:	e8 de 02 00 00       	call   392 <exit>
    }
    if (pid == 0) {
  b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  b8:	75 3e                	jne    f8 <main+0xf8>
      exec("sh", argv);
  ba:	83 ec 08             	sub    $0x8,%esp
  bd:	68 a4 0b 00 00       	push   $0xba4
  c2:	68 fd 08 00 00       	push   $0x8fd
  c7:	e8 fe 02 00 00       	call   3ca <exec>
  cc:	83 c4 10             	add    $0x10,%esp
      printf(1, "init: exec sh failed\n");
  cf:	83 ec 08             	sub    $0x8,%esp
  d2:	68 3a 09 00 00       	push   $0x93a
  d7:	6a 01                	push   $0x1
  d9:	e8 58 04 00 00       	call   536 <printf>
  de:	83 c4 10             	add    $0x10,%esp
      exit();
  e1:	e8 ac 02 00 00       	call   392 <exit>
    }
    while ((wpid = wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  e6:	83 ec 08             	sub    $0x8,%esp
  e9:	68 50 09 00 00       	push   $0x950
  ee:	6a 01                	push   $0x1
  f0:	e8 41 04 00 00       	call   536 <printf>
  f5:	83 c4 10             	add    $0x10,%esp
    while ((wpid = wait()) >= 0 && wpid != pid)
  f8:	e8 9d 02 00 00       	call   39a <wait>
  fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 100:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 104:	0f 88 73 ff ff ff    	js     7d <main+0x7d>
 10a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 10d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 110:	75 d4                	jne    e6 <main+0xe6>
    printf(1, "init: starting sh\n");
 112:	e9 66 ff ff ff       	jmp    7d <main+0x7d>

00000117 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 117:	55                   	push   %ebp
 118:	89 e5                	mov    %esp,%ebp
 11a:	57                   	push   %edi
 11b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 11c:	8b 4d 08             	mov    0x8(%ebp),%ecx
 11f:	8b 55 10             	mov    0x10(%ebp),%edx
 122:	8b 45 0c             	mov    0xc(%ebp),%eax
 125:	89 cb                	mov    %ecx,%ebx
 127:	89 df                	mov    %ebx,%edi
 129:	89 d1                	mov    %edx,%ecx
 12b:	fc                   	cld    
 12c:	f3 aa                	rep stos %al,%es:(%edi)
 12e:	89 ca                	mov    %ecx,%edx
 130:	89 fb                	mov    %edi,%ebx
 132:	89 5d 08             	mov    %ebx,0x8(%ebp)
 135:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 138:	90                   	nop
 139:	5b                   	pop    %ebx
 13a:	5f                   	pop    %edi
 13b:	5d                   	pop    %ebp
 13c:	c3                   	ret    

0000013d <strcpy>:
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user.h"
#include "kernel/x86.h"

char *strcpy(char *s, char *t) {
 13d:	f3 0f 1e fb          	endbr32 
 141:	55                   	push   %ebp
 142:	89 e5                	mov    %esp,%ebp
 144:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 147:	8b 45 08             	mov    0x8(%ebp),%eax
 14a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while ((*s++ = *t++) != 0)
 14d:	90                   	nop
 14e:	8b 55 0c             	mov    0xc(%ebp),%edx
 151:	8d 42 01             	lea    0x1(%edx),%eax
 154:	89 45 0c             	mov    %eax,0xc(%ebp)
 157:	8b 45 08             	mov    0x8(%ebp),%eax
 15a:	8d 48 01             	lea    0x1(%eax),%ecx
 15d:	89 4d 08             	mov    %ecx,0x8(%ebp)
 160:	0f b6 12             	movzbl (%edx),%edx
 163:	88 10                	mov    %dl,(%eax)
 165:	0f b6 00             	movzbl (%eax),%eax
 168:	84 c0                	test   %al,%al
 16a:	75 e2                	jne    14e <strcpy+0x11>
    ;
  return os;
 16c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 16f:	c9                   	leave  
 170:	c3                   	ret    

00000171 <strcmp>:

int strcmp(const char *p, const char *q) {
 171:	f3 0f 1e fb          	endbr32 
 175:	55                   	push   %ebp
 176:	89 e5                	mov    %esp,%ebp
  while (*p && *p == *q)
 178:	eb 08                	jmp    182 <strcmp+0x11>
    p++, q++;
 17a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 17e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while (*p && *p == *q)
 182:	8b 45 08             	mov    0x8(%ebp),%eax
 185:	0f b6 00             	movzbl (%eax),%eax
 188:	84 c0                	test   %al,%al
 18a:	74 10                	je     19c <strcmp+0x2b>
 18c:	8b 45 08             	mov    0x8(%ebp),%eax
 18f:	0f b6 10             	movzbl (%eax),%edx
 192:	8b 45 0c             	mov    0xc(%ebp),%eax
 195:	0f b6 00             	movzbl (%eax),%eax
 198:	38 c2                	cmp    %al,%dl
 19a:	74 de                	je     17a <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
 19c:	8b 45 08             	mov    0x8(%ebp),%eax
 19f:	0f b6 00             	movzbl (%eax),%eax
 1a2:	0f b6 d0             	movzbl %al,%edx
 1a5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a8:	0f b6 00             	movzbl (%eax),%eax
 1ab:	0f b6 c0             	movzbl %al,%eax
 1ae:	29 c2                	sub    %eax,%edx
 1b0:	89 d0                	mov    %edx,%eax
}
 1b2:	5d                   	pop    %ebp
 1b3:	c3                   	ret    

000001b4 <strlen>:

uint strlen(char *s) {
 1b4:	f3 0f 1e fb          	endbr32 
 1b8:	55                   	push   %ebp
 1b9:	89 e5                	mov    %esp,%ebp
 1bb:	83 ec 10             	sub    $0x10,%esp
  int n;

  for (n = 0; s[n]; n++)
 1be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1c5:	eb 04                	jmp    1cb <strlen+0x17>
 1c7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ce:	8b 45 08             	mov    0x8(%ebp),%eax
 1d1:	01 d0                	add    %edx,%eax
 1d3:	0f b6 00             	movzbl (%eax),%eax
 1d6:	84 c0                	test   %al,%al
 1d8:	75 ed                	jne    1c7 <strlen+0x13>
    ;
  return n;
 1da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1dd:	c9                   	leave  
 1de:	c3                   	ret    

000001df <memset>:

void *memset(void *dst, int c, uint n) {
 1df:	f3 0f 1e fb          	endbr32 
 1e3:	55                   	push   %ebp
 1e4:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1e6:	8b 45 10             	mov    0x10(%ebp),%eax
 1e9:	50                   	push   %eax
 1ea:	ff 75 0c             	pushl  0xc(%ebp)
 1ed:	ff 75 08             	pushl  0x8(%ebp)
 1f0:	e8 22 ff ff ff       	call   117 <stosb>
 1f5:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1f8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1fb:	c9                   	leave  
 1fc:	c3                   	ret    

000001fd <strchr>:

char *strchr(const char *s, char c) {
 1fd:	f3 0f 1e fb          	endbr32 
 201:	55                   	push   %ebp
 202:	89 e5                	mov    %esp,%ebp
 204:	83 ec 04             	sub    $0x4,%esp
 207:	8b 45 0c             	mov    0xc(%ebp),%eax
 20a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for (; *s; s++)
 20d:	eb 14                	jmp    223 <strchr+0x26>
    if (*s == c)
 20f:	8b 45 08             	mov    0x8(%ebp),%eax
 212:	0f b6 00             	movzbl (%eax),%eax
 215:	38 45 fc             	cmp    %al,-0x4(%ebp)
 218:	75 05                	jne    21f <strchr+0x22>
      return (char *)s;
 21a:	8b 45 08             	mov    0x8(%ebp),%eax
 21d:	eb 13                	jmp    232 <strchr+0x35>
  for (; *s; s++)
 21f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	0f b6 00             	movzbl (%eax),%eax
 229:	84 c0                	test   %al,%al
 22b:	75 e2                	jne    20f <strchr+0x12>
  return 0;
 22d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 232:	c9                   	leave  
 233:	c3                   	ret    

00000234 <gets>:

char *gets(char *buf, int max) {
 234:	f3 0f 1e fb          	endbr32 
 238:	55                   	push   %ebp
 239:	89 e5                	mov    %esp,%ebp
 23b:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 23e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 245:	eb 42                	jmp    289 <gets+0x55>
    cc = read(0, &c, 1);
 247:	83 ec 04             	sub    $0x4,%esp
 24a:	6a 01                	push   $0x1
 24c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 24f:	50                   	push   %eax
 250:	6a 00                	push   $0x0
 252:	e8 53 01 00 00       	call   3aa <read>
 257:	83 c4 10             	add    $0x10,%esp
 25a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (cc < 1)
 25d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 261:	7e 33                	jle    296 <gets+0x62>
      break;
    buf[i++] = c;
 263:	8b 45 f4             	mov    -0xc(%ebp),%eax
 266:	8d 50 01             	lea    0x1(%eax),%edx
 269:	89 55 f4             	mov    %edx,-0xc(%ebp)
 26c:	89 c2                	mov    %eax,%edx
 26e:	8b 45 08             	mov    0x8(%ebp),%eax
 271:	01 c2                	add    %eax,%edx
 273:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 277:	88 02                	mov    %al,(%edx)
    if (c == '\n' || c == '\r')
 279:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 27d:	3c 0a                	cmp    $0xa,%al
 27f:	74 16                	je     297 <gets+0x63>
 281:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 285:	3c 0d                	cmp    $0xd,%al
 287:	74 0e                	je     297 <gets+0x63>
  for (i = 0; i + 1 < max;) {
 289:	8b 45 f4             	mov    -0xc(%ebp),%eax
 28c:	83 c0 01             	add    $0x1,%eax
 28f:	39 45 0c             	cmp    %eax,0xc(%ebp)
 292:	7f b3                	jg     247 <gets+0x13>
 294:	eb 01                	jmp    297 <gets+0x63>
      break;
 296:	90                   	nop
      break;
  }
  buf[i] = '\0';
 297:	8b 55 f4             	mov    -0xc(%ebp),%edx
 29a:	8b 45 08             	mov    0x8(%ebp),%eax
 29d:	01 d0                	add    %edx,%eax
 29f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2a2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a5:	c9                   	leave  
 2a6:	c3                   	ret    

000002a7 <stat>:

int stat(char *n, struct stat *st) {
 2a7:	f3 0f 1e fb          	endbr32 
 2ab:	55                   	push   %ebp
 2ac:	89 e5                	mov    %esp,%ebp
 2ae:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2b1:	83 ec 08             	sub    $0x8,%esp
 2b4:	6a 00                	push   $0x0
 2b6:	ff 75 08             	pushl  0x8(%ebp)
 2b9:	e8 14 01 00 00       	call   3d2 <open>
 2be:	83 c4 10             	add    $0x10,%esp
 2c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (fd < 0)
 2c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2c8:	79 07                	jns    2d1 <stat+0x2a>
    return -1;
 2ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2cf:	eb 25                	jmp    2f6 <stat+0x4f>
  r = fstat(fd, st);
 2d1:	83 ec 08             	sub    $0x8,%esp
 2d4:	ff 75 0c             	pushl  0xc(%ebp)
 2d7:	ff 75 f4             	pushl  -0xc(%ebp)
 2da:	e8 0b 01 00 00       	call   3ea <fstat>
 2df:	83 c4 10             	add    $0x10,%esp
 2e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2e5:	83 ec 0c             	sub    $0xc,%esp
 2e8:	ff 75 f4             	pushl  -0xc(%ebp)
 2eb:	e8 ca 00 00 00       	call   3ba <close>
 2f0:	83 c4 10             	add    $0x10,%esp
  return r;
 2f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2f6:	c9                   	leave  
 2f7:	c3                   	ret    

000002f8 <atoi>:

int atoi(const char *s) {
 2f8:	f3 0f 1e fb          	endbr32 
 2fc:	55                   	push   %ebp
 2fd:	89 e5                	mov    %esp,%ebp
 2ff:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 302:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while ('0' <= *s && *s <= '9')
 309:	eb 25                	jmp    330 <atoi+0x38>
    n = n * 10 + *s++ - '0';
 30b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 30e:	89 d0                	mov    %edx,%eax
 310:	c1 e0 02             	shl    $0x2,%eax
 313:	01 d0                	add    %edx,%eax
 315:	01 c0                	add    %eax,%eax
 317:	89 c1                	mov    %eax,%ecx
 319:	8b 45 08             	mov    0x8(%ebp),%eax
 31c:	8d 50 01             	lea    0x1(%eax),%edx
 31f:	89 55 08             	mov    %edx,0x8(%ebp)
 322:	0f b6 00             	movzbl (%eax),%eax
 325:	0f be c0             	movsbl %al,%eax
 328:	01 c8                	add    %ecx,%eax
 32a:	83 e8 30             	sub    $0x30,%eax
 32d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while ('0' <= *s && *s <= '9')
 330:	8b 45 08             	mov    0x8(%ebp),%eax
 333:	0f b6 00             	movzbl (%eax),%eax
 336:	3c 2f                	cmp    $0x2f,%al
 338:	7e 0a                	jle    344 <atoi+0x4c>
 33a:	8b 45 08             	mov    0x8(%ebp),%eax
 33d:	0f b6 00             	movzbl (%eax),%eax
 340:	3c 39                	cmp    $0x39,%al
 342:	7e c7                	jle    30b <atoi+0x13>
  return n;
 344:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 347:	c9                   	leave  
 348:	c3                   	ret    

00000349 <memmove>:

void *memmove(void *vdst, void *vsrc, int n) {
 349:	f3 0f 1e fb          	endbr32 
 34d:	55                   	push   %ebp
 34e:	89 e5                	mov    %esp,%ebp
 350:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 353:	8b 45 08             	mov    0x8(%ebp),%eax
 356:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 359:	8b 45 0c             	mov    0xc(%ebp),%eax
 35c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while (n-- > 0)
 35f:	eb 17                	jmp    378 <memmove+0x2f>
    *dst++ = *src++;
 361:	8b 55 f8             	mov    -0x8(%ebp),%edx
 364:	8d 42 01             	lea    0x1(%edx),%eax
 367:	89 45 f8             	mov    %eax,-0x8(%ebp)
 36a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 36d:	8d 48 01             	lea    0x1(%eax),%ecx
 370:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 373:	0f b6 12             	movzbl (%edx),%edx
 376:	88 10                	mov    %dl,(%eax)
  while (n-- > 0)
 378:	8b 45 10             	mov    0x10(%ebp),%eax
 37b:	8d 50 ff             	lea    -0x1(%eax),%edx
 37e:	89 55 10             	mov    %edx,0x10(%ebp)
 381:	85 c0                	test   %eax,%eax
 383:	7f dc                	jg     361 <memmove+0x18>
  return vdst;
 385:	8b 45 08             	mov    0x8(%ebp),%eax
}
 388:	c9                   	leave  
 389:	c3                   	ret    

0000038a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 38a:	b8 01 00 00 00       	mov    $0x1,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <exit>:
SYSCALL(exit)
 392:	b8 02 00 00 00       	mov    $0x2,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <wait>:
SYSCALL(wait)
 39a:	b8 03 00 00 00       	mov    $0x3,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <pipe>:
SYSCALL(pipe)
 3a2:	b8 04 00 00 00       	mov    $0x4,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <read>:
SYSCALL(read)
 3aa:	b8 05 00 00 00       	mov    $0x5,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <write>:
SYSCALL(write)
 3b2:	b8 10 00 00 00       	mov    $0x10,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <close>:
SYSCALL(close)
 3ba:	b8 15 00 00 00       	mov    $0x15,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <kill>:
SYSCALL(kill)
 3c2:	b8 06 00 00 00       	mov    $0x6,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <exec>:
SYSCALL(exec)
 3ca:	b8 07 00 00 00       	mov    $0x7,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <open>:
SYSCALL(open)
 3d2:	b8 0f 00 00 00       	mov    $0xf,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <mknod>:
SYSCALL(mknod)
 3da:	b8 11 00 00 00       	mov    $0x11,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <unlink>:
SYSCALL(unlink)
 3e2:	b8 12 00 00 00       	mov    $0x12,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <fstat>:
SYSCALL(fstat)
 3ea:	b8 08 00 00 00       	mov    $0x8,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <link>:
SYSCALL(link)
 3f2:	b8 13 00 00 00       	mov    $0x13,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <mkdir>:
SYSCALL(mkdir)
 3fa:	b8 14 00 00 00       	mov    $0x14,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <chdir>:
SYSCALL(chdir)
 402:	b8 09 00 00 00       	mov    $0x9,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <dup>:
SYSCALL(dup)
 40a:	b8 0a 00 00 00       	mov    $0xa,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <getpid>:
SYSCALL(getpid)
 412:	b8 0b 00 00 00       	mov    $0xb,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <sbrk>:
SYSCALL(sbrk)
 41a:	b8 0c 00 00 00       	mov    $0xc,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <sleep>:
SYSCALL(sleep)
 422:	b8 0d 00 00 00       	mov    $0xd,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <uptime>:
SYSCALL(uptime)
 42a:	b8 0e 00 00 00       	mov    $0xe,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <trace>:
SYSCALL(trace)
 432:	b8 16 00 00 00       	mov    $0x16,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <setEFlag>:
SYSCALL(setEFlag)
 43a:	b8 17 00 00 00       	mov    $0x17,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <setSFlag>:
SYSCALL(setSFlag)
 442:	b8 18 00 00 00       	mov    $0x18,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <setFFlag>:
SYSCALL(setFFlag)
 44a:	b8 19 00 00 00       	mov    $0x19,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <dump>:
 452:	b8 1a 00 00 00       	mov    $0x1a,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <putc>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user.h"

static void putc(int fd, char c) { write(fd, &c, 1); }
 45a:	f3 0f 1e fb          	endbr32 
 45e:	55                   	push   %ebp
 45f:	89 e5                	mov    %esp,%ebp
 461:	83 ec 18             	sub    $0x18,%esp
 464:	8b 45 0c             	mov    0xc(%ebp),%eax
 467:	88 45 f4             	mov    %al,-0xc(%ebp)
 46a:	83 ec 04             	sub    $0x4,%esp
 46d:	6a 01                	push   $0x1
 46f:	8d 45 f4             	lea    -0xc(%ebp),%eax
 472:	50                   	push   %eax
 473:	ff 75 08             	pushl  0x8(%ebp)
 476:	e8 37 ff ff ff       	call   3b2 <write>
 47b:	83 c4 10             	add    $0x10,%esp
 47e:	90                   	nop
 47f:	c9                   	leave  
 480:	c3                   	ret    

00000481 <printint>:

static void printint(int fd, int xx, int base, int sgn) {
 481:	f3 0f 1e fb          	endbr32 
 485:	55                   	push   %ebp
 486:	89 e5                	mov    %esp,%ebp
 488:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 48b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if (sgn && xx < 0) {
 492:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 496:	74 17                	je     4af <printint+0x2e>
 498:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 49c:	79 11                	jns    4af <printint+0x2e>
    neg = 1;
 49e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4a5:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a8:	f7 d8                	neg    %eax
 4aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4ad:	eb 06                	jmp    4b5 <printint+0x34>
  } else {
    x = xx;
 4af:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do {
    buf[i++] = digits[x % base];
 4bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4c2:	ba 00 00 00 00       	mov    $0x0,%edx
 4c7:	f7 f1                	div    %ecx
 4c9:	89 d1                	mov    %edx,%ecx
 4cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ce:	8d 50 01             	lea    0x1(%eax),%edx
 4d1:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4d4:	0f b6 91 ac 0b 00 00 	movzbl 0xbac(%ecx),%edx
 4db:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  } while ((x /= base) != 0);
 4df:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4e5:	ba 00 00 00 00       	mov    $0x0,%edx
 4ea:	f7 f1                	div    %ecx
 4ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4f3:	75 c7                	jne    4bc <printint+0x3b>
  if (neg)
 4f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4f9:	74 2d                	je     528 <printint+0xa7>
    buf[i++] = '-';
 4fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4fe:	8d 50 01             	lea    0x1(%eax),%edx
 501:	89 55 f4             	mov    %edx,-0xc(%ebp)
 504:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while (--i >= 0)
 509:	eb 1d                	jmp    528 <printint+0xa7>
    putc(fd, buf[i]);
 50b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 50e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 511:	01 d0                	add    %edx,%eax
 513:	0f b6 00             	movzbl (%eax),%eax
 516:	0f be c0             	movsbl %al,%eax
 519:	83 ec 08             	sub    $0x8,%esp
 51c:	50                   	push   %eax
 51d:	ff 75 08             	pushl  0x8(%ebp)
 520:	e8 35 ff ff ff       	call   45a <putc>
 525:	83 c4 10             	add    $0x10,%esp
  while (--i >= 0)
 528:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 52c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 530:	79 d9                	jns    50b <printint+0x8a>
}
 532:	90                   	nop
 533:	90                   	nop
 534:	c9                   	leave  
 535:	c3                   	ret    

00000536 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void printf(int fd, char *fmt, ...) {
 536:	f3 0f 1e fb          	endbr32 
 53a:	55                   	push   %ebp
 53b:	89 e5                	mov    %esp,%ebp
 53d:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 540:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint *)(void *)&fmt + 1;
 547:	8d 45 0c             	lea    0xc(%ebp),%eax
 54a:	83 c0 04             	add    $0x4,%eax
 54d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for (i = 0; fmt[i]; i++) {
 550:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 557:	e9 59 01 00 00       	jmp    6b5 <printf+0x17f>
    c = fmt[i] & 0xff;
 55c:	8b 55 0c             	mov    0xc(%ebp),%edx
 55f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 562:	01 d0                	add    %edx,%eax
 564:	0f b6 00             	movzbl (%eax),%eax
 567:	0f be c0             	movsbl %al,%eax
 56a:	25 ff 00 00 00       	and    $0xff,%eax
 56f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (state == 0) {
 572:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 576:	75 2c                	jne    5a4 <printf+0x6e>
      if (c == '%') {
 578:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 57c:	75 0c                	jne    58a <printf+0x54>
        state = '%';
 57e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 585:	e9 27 01 00 00       	jmp    6b1 <printf+0x17b>
      } else {
        putc(fd, c);
 58a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 58d:	0f be c0             	movsbl %al,%eax
 590:	83 ec 08             	sub    $0x8,%esp
 593:	50                   	push   %eax
 594:	ff 75 08             	pushl  0x8(%ebp)
 597:	e8 be fe ff ff       	call   45a <putc>
 59c:	83 c4 10             	add    $0x10,%esp
 59f:	e9 0d 01 00 00       	jmp    6b1 <printf+0x17b>
      }
    } else if (state == '%') {
 5a4:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5a8:	0f 85 03 01 00 00    	jne    6b1 <printf+0x17b>
      if (c == 'd') {
 5ae:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5b2:	75 1e                	jne    5d2 <printf+0x9c>
        printint(fd, *ap, 10, 1);
 5b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b7:	8b 00                	mov    (%eax),%eax
 5b9:	6a 01                	push   $0x1
 5bb:	6a 0a                	push   $0xa
 5bd:	50                   	push   %eax
 5be:	ff 75 08             	pushl  0x8(%ebp)
 5c1:	e8 bb fe ff ff       	call   481 <printint>
 5c6:	83 c4 10             	add    $0x10,%esp
        ap++;
 5c9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5cd:	e9 d8 00 00 00       	jmp    6aa <printf+0x174>
      } else if (c == 'x' || c == 'p') {
 5d2:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5d6:	74 06                	je     5de <printf+0xa8>
 5d8:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5dc:	75 1e                	jne    5fc <printf+0xc6>
        printint(fd, *ap, 16, 0);
 5de:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e1:	8b 00                	mov    (%eax),%eax
 5e3:	6a 00                	push   $0x0
 5e5:	6a 10                	push   $0x10
 5e7:	50                   	push   %eax
 5e8:	ff 75 08             	pushl  0x8(%ebp)
 5eb:	e8 91 fe ff ff       	call   481 <printint>
 5f0:	83 c4 10             	add    $0x10,%esp
        ap++;
 5f3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5f7:	e9 ae 00 00 00       	jmp    6aa <printf+0x174>
      } else if (c == 's') {
 5fc:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 600:	75 43                	jne    645 <printf+0x10f>
        s = (char *)*ap;
 602:	8b 45 e8             	mov    -0x18(%ebp),%eax
 605:	8b 00                	mov    (%eax),%eax
 607:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 60a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if (s == 0)
 60e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 612:	75 25                	jne    639 <printf+0x103>
          s = "(null)";
 614:	c7 45 f4 59 09 00 00 	movl   $0x959,-0xc(%ebp)
        while (*s != 0) {
 61b:	eb 1c                	jmp    639 <printf+0x103>
          putc(fd, *s);
 61d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 620:	0f b6 00             	movzbl (%eax),%eax
 623:	0f be c0             	movsbl %al,%eax
 626:	83 ec 08             	sub    $0x8,%esp
 629:	50                   	push   %eax
 62a:	ff 75 08             	pushl  0x8(%ebp)
 62d:	e8 28 fe ff ff       	call   45a <putc>
 632:	83 c4 10             	add    $0x10,%esp
          s++;
 635:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while (*s != 0) {
 639:	8b 45 f4             	mov    -0xc(%ebp),%eax
 63c:	0f b6 00             	movzbl (%eax),%eax
 63f:	84 c0                	test   %al,%al
 641:	75 da                	jne    61d <printf+0xe7>
 643:	eb 65                	jmp    6aa <printf+0x174>
        }
      } else if (c == 'c') {
 645:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 649:	75 1d                	jne    668 <printf+0x132>
        putc(fd, *ap);
 64b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 64e:	8b 00                	mov    (%eax),%eax
 650:	0f be c0             	movsbl %al,%eax
 653:	83 ec 08             	sub    $0x8,%esp
 656:	50                   	push   %eax
 657:	ff 75 08             	pushl  0x8(%ebp)
 65a:	e8 fb fd ff ff       	call   45a <putc>
 65f:	83 c4 10             	add    $0x10,%esp
        ap++;
 662:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 666:	eb 42                	jmp    6aa <printf+0x174>
      } else if (c == '%') {
 668:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 66c:	75 17                	jne    685 <printf+0x14f>
        putc(fd, c);
 66e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 671:	0f be c0             	movsbl %al,%eax
 674:	83 ec 08             	sub    $0x8,%esp
 677:	50                   	push   %eax
 678:	ff 75 08             	pushl  0x8(%ebp)
 67b:	e8 da fd ff ff       	call   45a <putc>
 680:	83 c4 10             	add    $0x10,%esp
 683:	eb 25                	jmp    6aa <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 685:	83 ec 08             	sub    $0x8,%esp
 688:	6a 25                	push   $0x25
 68a:	ff 75 08             	pushl  0x8(%ebp)
 68d:	e8 c8 fd ff ff       	call   45a <putc>
 692:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 695:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 698:	0f be c0             	movsbl %al,%eax
 69b:	83 ec 08             	sub    $0x8,%esp
 69e:	50                   	push   %eax
 69f:	ff 75 08             	pushl  0x8(%ebp)
 6a2:	e8 b3 fd ff ff       	call   45a <putc>
 6a7:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6aa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for (i = 0; fmt[i]; i++) {
 6b1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6b5:	8b 55 0c             	mov    0xc(%ebp),%edx
 6b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6bb:	01 d0                	add    %edx,%eax
 6bd:	0f b6 00             	movzbl (%eax),%eax
 6c0:	84 c0                	test   %al,%al
 6c2:	0f 85 94 fe ff ff    	jne    55c <printf+0x26>
    }
  }
}
 6c8:	90                   	nop
 6c9:	90                   	nop
 6ca:	c9                   	leave  
 6cb:	c3                   	ret    

000006cc <free>:
typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
 6cc:	f3 0f 1e fb          	endbr32 
 6d0:	55                   	push   %ebp
 6d1:	89 e5                	mov    %esp,%ebp
 6d3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header *)ap - 1;
 6d6:	8b 45 08             	mov    0x8(%ebp),%eax
 6d9:	83 e8 08             	sub    $0x8,%eax
 6dc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6df:	a1 c8 0b 00 00       	mov    0xbc8,%eax
 6e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6e7:	eb 24                	jmp    70d <free+0x41>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ec:	8b 00                	mov    (%eax),%eax
 6ee:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 6f1:	72 12                	jb     705 <free+0x39>
 6f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f9:	77 24                	ja     71f <free+0x53>
 6fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fe:	8b 00                	mov    (%eax),%eax
 700:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 703:	72 1a                	jb     71f <free+0x53>
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 705:	8b 45 fc             	mov    -0x4(%ebp),%eax
 708:	8b 00                	mov    (%eax),%eax
 70a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 70d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 710:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 713:	76 d4                	jbe    6e9 <free+0x1d>
 715:	8b 45 fc             	mov    -0x4(%ebp),%eax
 718:	8b 00                	mov    (%eax),%eax
 71a:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 71d:	73 ca                	jae    6e9 <free+0x1d>
      break;
  if (bp + bp->s.size == p->s.ptr) {
 71f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 722:	8b 40 04             	mov    0x4(%eax),%eax
 725:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 72c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72f:	01 c2                	add    %eax,%edx
 731:	8b 45 fc             	mov    -0x4(%ebp),%eax
 734:	8b 00                	mov    (%eax),%eax
 736:	39 c2                	cmp    %eax,%edx
 738:	75 24                	jne    75e <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 73a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73d:	8b 50 04             	mov    0x4(%eax),%edx
 740:	8b 45 fc             	mov    -0x4(%ebp),%eax
 743:	8b 00                	mov    (%eax),%eax
 745:	8b 40 04             	mov    0x4(%eax),%eax
 748:	01 c2                	add    %eax,%edx
 74a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 750:	8b 45 fc             	mov    -0x4(%ebp),%eax
 753:	8b 00                	mov    (%eax),%eax
 755:	8b 10                	mov    (%eax),%edx
 757:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75a:	89 10                	mov    %edx,(%eax)
 75c:	eb 0a                	jmp    768 <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 75e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 761:	8b 10                	mov    (%eax),%edx
 763:	8b 45 f8             	mov    -0x8(%ebp),%eax
 766:	89 10                	mov    %edx,(%eax)
  if (p + p->s.size == bp) {
 768:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76b:	8b 40 04             	mov    0x4(%eax),%eax
 76e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 775:	8b 45 fc             	mov    -0x4(%ebp),%eax
 778:	01 d0                	add    %edx,%eax
 77a:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 77d:	75 20                	jne    79f <free+0xd3>
    p->s.size += bp->s.size;
 77f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 782:	8b 50 04             	mov    0x4(%eax),%edx
 785:	8b 45 f8             	mov    -0x8(%ebp),%eax
 788:	8b 40 04             	mov    0x4(%eax),%eax
 78b:	01 c2                	add    %eax,%edx
 78d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 790:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 793:	8b 45 f8             	mov    -0x8(%ebp),%eax
 796:	8b 10                	mov    (%eax),%edx
 798:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79b:	89 10                	mov    %edx,(%eax)
 79d:	eb 08                	jmp    7a7 <free+0xdb>
  } else
    p->s.ptr = bp;
 79f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7a5:	89 10                	mov    %edx,(%eax)
  freep = p;
 7a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7aa:	a3 c8 0b 00 00       	mov    %eax,0xbc8
}
 7af:	90                   	nop
 7b0:	c9                   	leave  
 7b1:	c3                   	ret    

000007b2 <morecore>:

static Header *morecore(uint nu) {
 7b2:	f3 0f 1e fb          	endbr32 
 7b6:	55                   	push   %ebp
 7b7:	89 e5                	mov    %esp,%ebp
 7b9:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if (nu < 4096)
 7bc:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7c3:	77 07                	ja     7cc <morecore+0x1a>
    nu = 4096;
 7c5:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7cc:	8b 45 08             	mov    0x8(%ebp),%eax
 7cf:	c1 e0 03             	shl    $0x3,%eax
 7d2:	83 ec 0c             	sub    $0xc,%esp
 7d5:	50                   	push   %eax
 7d6:	e8 3f fc ff ff       	call   41a <sbrk>
 7db:	83 c4 10             	add    $0x10,%esp
 7de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (p == (char *)-1)
 7e1:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7e5:	75 07                	jne    7ee <morecore+0x3c>
    return 0;
 7e7:	b8 00 00 00 00       	mov    $0x0,%eax
 7ec:	eb 26                	jmp    814 <morecore+0x62>
  hp = (Header *)p;
 7ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f7:	8b 55 08             	mov    0x8(%ebp),%edx
 7fa:	89 50 04             	mov    %edx,0x4(%eax)
  free((void *)(hp + 1));
 7fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 800:	83 c0 08             	add    $0x8,%eax
 803:	83 ec 0c             	sub    $0xc,%esp
 806:	50                   	push   %eax
 807:	e8 c0 fe ff ff       	call   6cc <free>
 80c:	83 c4 10             	add    $0x10,%esp
  return freep;
 80f:	a1 c8 0b 00 00       	mov    0xbc8,%eax
}
 814:	c9                   	leave  
 815:	c3                   	ret    

00000816 <malloc>:

void *malloc(uint nbytes) {
 816:	f3 0f 1e fb          	endbr32 
 81a:	55                   	push   %ebp
 81b:	89 e5                	mov    %esp,%ebp
 81d:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 820:	8b 45 08             	mov    0x8(%ebp),%eax
 823:	83 c0 07             	add    $0x7,%eax
 826:	c1 e8 03             	shr    $0x3,%eax
 829:	83 c0 01             	add    $0x1,%eax
 82c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if ((prevp = freep) == 0) {
 82f:	a1 c8 0b 00 00       	mov    0xbc8,%eax
 834:	89 45 f0             	mov    %eax,-0x10(%ebp)
 837:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 83b:	75 23                	jne    860 <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 83d:	c7 45 f0 c0 0b 00 00 	movl   $0xbc0,-0x10(%ebp)
 844:	8b 45 f0             	mov    -0x10(%ebp),%eax
 847:	a3 c8 0b 00 00       	mov    %eax,0xbc8
 84c:	a1 c8 0b 00 00       	mov    0xbc8,%eax
 851:	a3 c0 0b 00 00       	mov    %eax,0xbc0
    base.s.size = 0;
 856:	c7 05 c4 0b 00 00 00 	movl   $0x0,0xbc4
 85d:	00 00 00 
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 860:	8b 45 f0             	mov    -0x10(%ebp),%eax
 863:	8b 00                	mov    (%eax),%eax
 865:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p->s.size >= nunits) {
 868:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86b:	8b 40 04             	mov    0x4(%eax),%eax
 86e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 871:	77 4d                	ja     8c0 <malloc+0xaa>
      if (p->s.size == nunits)
 873:	8b 45 f4             	mov    -0xc(%ebp),%eax
 876:	8b 40 04             	mov    0x4(%eax),%eax
 879:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 87c:	75 0c                	jne    88a <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 87e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 881:	8b 10                	mov    (%eax),%edx
 883:	8b 45 f0             	mov    -0x10(%ebp),%eax
 886:	89 10                	mov    %edx,(%eax)
 888:	eb 26                	jmp    8b0 <malloc+0x9a>
      else {
        p->s.size -= nunits;
 88a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88d:	8b 40 04             	mov    0x4(%eax),%eax
 890:	2b 45 ec             	sub    -0x14(%ebp),%eax
 893:	89 c2                	mov    %eax,%edx
 895:	8b 45 f4             	mov    -0xc(%ebp),%eax
 898:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 89b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89e:	8b 40 04             	mov    0x4(%eax),%eax
 8a1:	c1 e0 03             	shl    $0x3,%eax
 8a4:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8ad:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b3:	a3 c8 0b 00 00       	mov    %eax,0xbc8
      return (void *)(p + 1);
 8b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bb:	83 c0 08             	add    $0x8,%eax
 8be:	eb 3b                	jmp    8fb <malloc+0xe5>
    }
    if (p == freep)
 8c0:	a1 c8 0b 00 00       	mov    0xbc8,%eax
 8c5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8c8:	75 1e                	jne    8e8 <malloc+0xd2>
      if ((p = morecore(nunits)) == 0)
 8ca:	83 ec 0c             	sub    $0xc,%esp
 8cd:	ff 75 ec             	pushl  -0x14(%ebp)
 8d0:	e8 dd fe ff ff       	call   7b2 <morecore>
 8d5:	83 c4 10             	add    $0x10,%esp
 8d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8df:	75 07                	jne    8e8 <malloc+0xd2>
        return 0;
 8e1:	b8 00 00 00 00       	mov    $0x0,%eax
 8e6:	eb 13                	jmp    8fb <malloc+0xe5>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f1:	8b 00                	mov    (%eax),%eax
 8f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p->s.size >= nunits) {
 8f6:	e9 6d ff ff ff       	jmp    868 <malloc+0x52>
  }
}
 8fb:	c9                   	leave  
 8fc:	c3                   	ret    
