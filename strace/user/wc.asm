
user/_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:
#include "kernel/stat.h"
#include "user.h"

char buf[512];

void wc(int fd, char *name) {
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	83 ec 28             	sub    $0x28,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
   a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  14:	89 45 ec             	mov    %eax,-0x14(%ebp)
  17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
  1d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while ((n = read(fd, buf, sizeof(buf))) > 0) {
  24:	eb 69                	jmp    8f <wc+0x8f>
    for (i = 0; i < n; i++) {
  26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  2d:	eb 58                	jmp    87 <wc+0x87>
      c++;
  2f:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
      if (buf[i] == '\n')
  33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  36:	05 a0 0c 00 00       	add    $0xca0,%eax
  3b:	0f b6 00             	movzbl (%eax),%eax
  3e:	3c 0a                	cmp    $0xa,%al
  40:	75 04                	jne    46 <wc+0x46>
        l++;
  42:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if (strchr(" \r\t\n\v", buf[i]))
  46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  49:	05 a0 0c 00 00       	add    $0xca0,%eax
  4e:	0f b6 00             	movzbl (%eax),%eax
  51:	0f be c0             	movsbl %al,%eax
  54:	83 ec 08             	sub    $0x8,%esp
  57:	50                   	push   %eax
  58:	68 ab 09 00 00       	push   $0x9ab
  5d:	e8 49 02 00 00       	call   2ab <strchr>
  62:	83 c4 10             	add    $0x10,%esp
  65:	85 c0                	test   %eax,%eax
  67:	74 09                	je     72 <wc+0x72>
        inword = 0;
  69:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  70:	eb 11                	jmp    83 <wc+0x83>
      else if (!inword) {
  72:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  76:	75 0b                	jne    83 <wc+0x83>
        w++;
  78:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
        inword = 1;
  7c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
    for (i = 0; i < n; i++) {
  83:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8d:	7c a0                	jl     2f <wc+0x2f>
  while ((n = read(fd, buf, sizeof(buf))) > 0) {
  8f:	83 ec 04             	sub    $0x4,%esp
  92:	68 00 02 00 00       	push   $0x200
  97:	68 a0 0c 00 00       	push   $0xca0
  9c:	ff 75 08             	pushl  0x8(%ebp)
  9f:	e8 b4 03 00 00       	call   458 <read>
  a4:	83 c4 10             	add    $0x10,%esp
  a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  aa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  ae:	0f 8f 72 ff ff ff    	jg     26 <wc+0x26>
      }
    }
  }
  if (n < 0) {
  b4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  b8:	79 17                	jns    d1 <wc+0xd1>
    printf(1, "wc: read error\n");
  ba:	83 ec 08             	sub    $0x8,%esp
  bd:	68 b1 09 00 00       	push   $0x9b1
  c2:	6a 01                	push   $0x1
  c4:	e8 1b 05 00 00       	call   5e4 <printf>
  c9:	83 c4 10             	add    $0x10,%esp
    exit();
  cc:	e8 6f 03 00 00       	call   440 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  d1:	83 ec 08             	sub    $0x8,%esp
  d4:	ff 75 0c             	pushl  0xc(%ebp)
  d7:	ff 75 e8             	pushl  -0x18(%ebp)
  da:	ff 75 ec             	pushl  -0x14(%ebp)
  dd:	ff 75 f0             	pushl  -0x10(%ebp)
  e0:	68 c1 09 00 00       	push   $0x9c1
  e5:	6a 01                	push   $0x1
  e7:	e8 f8 04 00 00       	call   5e4 <printf>
  ec:	83 c4 20             	add    $0x20,%esp
}
  ef:	90                   	nop
  f0:	c9                   	leave  
  f1:	c3                   	ret    

000000f2 <main>:

int main(int argc, char *argv[]) {
  f2:	f3 0f 1e fb          	endbr32 
  f6:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  fa:	83 e4 f0             	and    $0xfffffff0,%esp
  fd:	ff 71 fc             	pushl  -0x4(%ecx)
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	53                   	push   %ebx
 104:	51                   	push   %ecx
 105:	83 ec 10             	sub    $0x10,%esp
 108:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if (argc <= 1) {
 10a:	83 3b 01             	cmpl   $0x1,(%ebx)
 10d:	7f 17                	jg     126 <main+0x34>
    wc(0, "");
 10f:	83 ec 08             	sub    $0x8,%esp
 112:	68 ce 09 00 00       	push   $0x9ce
 117:	6a 00                	push   $0x0
 119:	e8 e2 fe ff ff       	call   0 <wc>
 11e:	83 c4 10             	add    $0x10,%esp
    exit();
 121:	e8 1a 03 00 00       	call   440 <exit>
  }

  for (i = 1; i < argc; i++) {
 126:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 12d:	e9 83 00 00 00       	jmp    1b5 <main+0xc3>
    if ((fd = open(argv[i], 0)) < 0) {
 132:	8b 45 f4             	mov    -0xc(%ebp),%eax
 135:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 13c:	8b 43 04             	mov    0x4(%ebx),%eax
 13f:	01 d0                	add    %edx,%eax
 141:	8b 00                	mov    (%eax),%eax
 143:	83 ec 08             	sub    $0x8,%esp
 146:	6a 00                	push   $0x0
 148:	50                   	push   %eax
 149:	e8 32 03 00 00       	call   480 <open>
 14e:	83 c4 10             	add    $0x10,%esp
 151:	89 45 f0             	mov    %eax,-0x10(%ebp)
 154:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 158:	79 29                	jns    183 <main+0x91>
      printf(1, "wc: cannot open %s\n", argv[i]);
 15a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 15d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 164:	8b 43 04             	mov    0x4(%ebx),%eax
 167:	01 d0                	add    %edx,%eax
 169:	8b 00                	mov    (%eax),%eax
 16b:	83 ec 04             	sub    $0x4,%esp
 16e:	50                   	push   %eax
 16f:	68 cf 09 00 00       	push   $0x9cf
 174:	6a 01                	push   $0x1
 176:	e8 69 04 00 00       	call   5e4 <printf>
 17b:	83 c4 10             	add    $0x10,%esp
      exit();
 17e:	e8 bd 02 00 00       	call   440 <exit>
    }
    wc(fd, argv[i]);
 183:	8b 45 f4             	mov    -0xc(%ebp),%eax
 186:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 18d:	8b 43 04             	mov    0x4(%ebx),%eax
 190:	01 d0                	add    %edx,%eax
 192:	8b 00                	mov    (%eax),%eax
 194:	83 ec 08             	sub    $0x8,%esp
 197:	50                   	push   %eax
 198:	ff 75 f0             	pushl  -0x10(%ebp)
 19b:	e8 60 fe ff ff       	call   0 <wc>
 1a0:	83 c4 10             	add    $0x10,%esp
    close(fd);
 1a3:	83 ec 0c             	sub    $0xc,%esp
 1a6:	ff 75 f0             	pushl  -0x10(%ebp)
 1a9:	e8 ba 02 00 00       	call   468 <close>
 1ae:	83 c4 10             	add    $0x10,%esp
  for (i = 1; i < argc; i++) {
 1b1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b8:	3b 03                	cmp    (%ebx),%eax
 1ba:	0f 8c 72 ff ff ff    	jl     132 <main+0x40>
  }
  exit();
 1c0:	e8 7b 02 00 00       	call   440 <exit>

000001c5 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1c5:	55                   	push   %ebp
 1c6:	89 e5                	mov    %esp,%ebp
 1c8:	57                   	push   %edi
 1c9:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1cd:	8b 55 10             	mov    0x10(%ebp),%edx
 1d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d3:	89 cb                	mov    %ecx,%ebx
 1d5:	89 df                	mov    %ebx,%edi
 1d7:	89 d1                	mov    %edx,%ecx
 1d9:	fc                   	cld    
 1da:	f3 aa                	rep stos %al,%es:(%edi)
 1dc:	89 ca                	mov    %ecx,%edx
 1de:	89 fb                	mov    %edi,%ebx
 1e0:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1e3:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1e6:	90                   	nop
 1e7:	5b                   	pop    %ebx
 1e8:	5f                   	pop    %edi
 1e9:	5d                   	pop    %ebp
 1ea:	c3                   	ret    

000001eb <strcpy>:
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user.h"
#include "kernel/x86.h"

char *strcpy(char *s, char *t) {
 1eb:	f3 0f 1e fb          	endbr32 
 1ef:	55                   	push   %ebp
 1f0:	89 e5                	mov    %esp,%ebp
 1f2:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1f5:	8b 45 08             	mov    0x8(%ebp),%eax
 1f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while ((*s++ = *t++) != 0)
 1fb:	90                   	nop
 1fc:	8b 55 0c             	mov    0xc(%ebp),%edx
 1ff:	8d 42 01             	lea    0x1(%edx),%eax
 202:	89 45 0c             	mov    %eax,0xc(%ebp)
 205:	8b 45 08             	mov    0x8(%ebp),%eax
 208:	8d 48 01             	lea    0x1(%eax),%ecx
 20b:	89 4d 08             	mov    %ecx,0x8(%ebp)
 20e:	0f b6 12             	movzbl (%edx),%edx
 211:	88 10                	mov    %dl,(%eax)
 213:	0f b6 00             	movzbl (%eax),%eax
 216:	84 c0                	test   %al,%al
 218:	75 e2                	jne    1fc <strcpy+0x11>
    ;
  return os;
 21a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 21d:	c9                   	leave  
 21e:	c3                   	ret    

0000021f <strcmp>:

int strcmp(const char *p, const char *q) {
 21f:	f3 0f 1e fb          	endbr32 
 223:	55                   	push   %ebp
 224:	89 e5                	mov    %esp,%ebp
  while (*p && *p == *q)
 226:	eb 08                	jmp    230 <strcmp+0x11>
    p++, q++;
 228:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 22c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while (*p && *p == *q)
 230:	8b 45 08             	mov    0x8(%ebp),%eax
 233:	0f b6 00             	movzbl (%eax),%eax
 236:	84 c0                	test   %al,%al
 238:	74 10                	je     24a <strcmp+0x2b>
 23a:	8b 45 08             	mov    0x8(%ebp),%eax
 23d:	0f b6 10             	movzbl (%eax),%edx
 240:	8b 45 0c             	mov    0xc(%ebp),%eax
 243:	0f b6 00             	movzbl (%eax),%eax
 246:	38 c2                	cmp    %al,%dl
 248:	74 de                	je     228 <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
 24a:	8b 45 08             	mov    0x8(%ebp),%eax
 24d:	0f b6 00             	movzbl (%eax),%eax
 250:	0f b6 d0             	movzbl %al,%edx
 253:	8b 45 0c             	mov    0xc(%ebp),%eax
 256:	0f b6 00             	movzbl (%eax),%eax
 259:	0f b6 c0             	movzbl %al,%eax
 25c:	29 c2                	sub    %eax,%edx
 25e:	89 d0                	mov    %edx,%eax
}
 260:	5d                   	pop    %ebp
 261:	c3                   	ret    

00000262 <strlen>:

uint strlen(char *s) {
 262:	f3 0f 1e fb          	endbr32 
 266:	55                   	push   %ebp
 267:	89 e5                	mov    %esp,%ebp
 269:	83 ec 10             	sub    $0x10,%esp
  int n;

  for (n = 0; s[n]; n++)
 26c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 273:	eb 04                	jmp    279 <strlen+0x17>
 275:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 279:	8b 55 fc             	mov    -0x4(%ebp),%edx
 27c:	8b 45 08             	mov    0x8(%ebp),%eax
 27f:	01 d0                	add    %edx,%eax
 281:	0f b6 00             	movzbl (%eax),%eax
 284:	84 c0                	test   %al,%al
 286:	75 ed                	jne    275 <strlen+0x13>
    ;
  return n;
 288:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 28b:	c9                   	leave  
 28c:	c3                   	ret    

0000028d <memset>:

void *memset(void *dst, int c, uint n) {
 28d:	f3 0f 1e fb          	endbr32 
 291:	55                   	push   %ebp
 292:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 294:	8b 45 10             	mov    0x10(%ebp),%eax
 297:	50                   	push   %eax
 298:	ff 75 0c             	pushl  0xc(%ebp)
 29b:	ff 75 08             	pushl  0x8(%ebp)
 29e:	e8 22 ff ff ff       	call   1c5 <stosb>
 2a3:	83 c4 0c             	add    $0xc,%esp
  return dst;
 2a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a9:	c9                   	leave  
 2aa:	c3                   	ret    

000002ab <strchr>:

char *strchr(const char *s, char c) {
 2ab:	f3 0f 1e fb          	endbr32 
 2af:	55                   	push   %ebp
 2b0:	89 e5                	mov    %esp,%ebp
 2b2:	83 ec 04             	sub    $0x4,%esp
 2b5:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b8:	88 45 fc             	mov    %al,-0x4(%ebp)
  for (; *s; s++)
 2bb:	eb 14                	jmp    2d1 <strchr+0x26>
    if (*s == c)
 2bd:	8b 45 08             	mov    0x8(%ebp),%eax
 2c0:	0f b6 00             	movzbl (%eax),%eax
 2c3:	38 45 fc             	cmp    %al,-0x4(%ebp)
 2c6:	75 05                	jne    2cd <strchr+0x22>
      return (char *)s;
 2c8:	8b 45 08             	mov    0x8(%ebp),%eax
 2cb:	eb 13                	jmp    2e0 <strchr+0x35>
  for (; *s; s++)
 2cd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2d1:	8b 45 08             	mov    0x8(%ebp),%eax
 2d4:	0f b6 00             	movzbl (%eax),%eax
 2d7:	84 c0                	test   %al,%al
 2d9:	75 e2                	jne    2bd <strchr+0x12>
  return 0;
 2db:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2e0:	c9                   	leave  
 2e1:	c3                   	ret    

000002e2 <gets>:

char *gets(char *buf, int max) {
 2e2:	f3 0f 1e fb          	endbr32 
 2e6:	55                   	push   %ebp
 2e7:	89 e5                	mov    %esp,%ebp
 2e9:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 2ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2f3:	eb 42                	jmp    337 <gets+0x55>
    cc = read(0, &c, 1);
 2f5:	83 ec 04             	sub    $0x4,%esp
 2f8:	6a 01                	push   $0x1
 2fa:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2fd:	50                   	push   %eax
 2fe:	6a 00                	push   $0x0
 300:	e8 53 01 00 00       	call   458 <read>
 305:	83 c4 10             	add    $0x10,%esp
 308:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (cc < 1)
 30b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 30f:	7e 33                	jle    344 <gets+0x62>
      break;
    buf[i++] = c;
 311:	8b 45 f4             	mov    -0xc(%ebp),%eax
 314:	8d 50 01             	lea    0x1(%eax),%edx
 317:	89 55 f4             	mov    %edx,-0xc(%ebp)
 31a:	89 c2                	mov    %eax,%edx
 31c:	8b 45 08             	mov    0x8(%ebp),%eax
 31f:	01 c2                	add    %eax,%edx
 321:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 325:	88 02                	mov    %al,(%edx)
    if (c == '\n' || c == '\r')
 327:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 32b:	3c 0a                	cmp    $0xa,%al
 32d:	74 16                	je     345 <gets+0x63>
 32f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 333:	3c 0d                	cmp    $0xd,%al
 335:	74 0e                	je     345 <gets+0x63>
  for (i = 0; i + 1 < max;) {
 337:	8b 45 f4             	mov    -0xc(%ebp),%eax
 33a:	83 c0 01             	add    $0x1,%eax
 33d:	39 45 0c             	cmp    %eax,0xc(%ebp)
 340:	7f b3                	jg     2f5 <gets+0x13>
 342:	eb 01                	jmp    345 <gets+0x63>
      break;
 344:	90                   	nop
      break;
  }
  buf[i] = '\0';
 345:	8b 55 f4             	mov    -0xc(%ebp),%edx
 348:	8b 45 08             	mov    0x8(%ebp),%eax
 34b:	01 d0                	add    %edx,%eax
 34d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 350:	8b 45 08             	mov    0x8(%ebp),%eax
}
 353:	c9                   	leave  
 354:	c3                   	ret    

00000355 <stat>:

int stat(char *n, struct stat *st) {
 355:	f3 0f 1e fb          	endbr32 
 359:	55                   	push   %ebp
 35a:	89 e5                	mov    %esp,%ebp
 35c:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 35f:	83 ec 08             	sub    $0x8,%esp
 362:	6a 00                	push   $0x0
 364:	ff 75 08             	pushl  0x8(%ebp)
 367:	e8 14 01 00 00       	call   480 <open>
 36c:	83 c4 10             	add    $0x10,%esp
 36f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (fd < 0)
 372:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 376:	79 07                	jns    37f <stat+0x2a>
    return -1;
 378:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 37d:	eb 25                	jmp    3a4 <stat+0x4f>
  r = fstat(fd, st);
 37f:	83 ec 08             	sub    $0x8,%esp
 382:	ff 75 0c             	pushl  0xc(%ebp)
 385:	ff 75 f4             	pushl  -0xc(%ebp)
 388:	e8 0b 01 00 00       	call   498 <fstat>
 38d:	83 c4 10             	add    $0x10,%esp
 390:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 393:	83 ec 0c             	sub    $0xc,%esp
 396:	ff 75 f4             	pushl  -0xc(%ebp)
 399:	e8 ca 00 00 00       	call   468 <close>
 39e:	83 c4 10             	add    $0x10,%esp
  return r;
 3a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3a4:	c9                   	leave  
 3a5:	c3                   	ret    

000003a6 <atoi>:

int atoi(const char *s) {
 3a6:	f3 0f 1e fb          	endbr32 
 3aa:	55                   	push   %ebp
 3ab:	89 e5                	mov    %esp,%ebp
 3ad:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 3b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while ('0' <= *s && *s <= '9')
 3b7:	eb 25                	jmp    3de <atoi+0x38>
    n = n * 10 + *s++ - '0';
 3b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3bc:	89 d0                	mov    %edx,%eax
 3be:	c1 e0 02             	shl    $0x2,%eax
 3c1:	01 d0                	add    %edx,%eax
 3c3:	01 c0                	add    %eax,%eax
 3c5:	89 c1                	mov    %eax,%ecx
 3c7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ca:	8d 50 01             	lea    0x1(%eax),%edx
 3cd:	89 55 08             	mov    %edx,0x8(%ebp)
 3d0:	0f b6 00             	movzbl (%eax),%eax
 3d3:	0f be c0             	movsbl %al,%eax
 3d6:	01 c8                	add    %ecx,%eax
 3d8:	83 e8 30             	sub    $0x30,%eax
 3db:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while ('0' <= *s && *s <= '9')
 3de:	8b 45 08             	mov    0x8(%ebp),%eax
 3e1:	0f b6 00             	movzbl (%eax),%eax
 3e4:	3c 2f                	cmp    $0x2f,%al
 3e6:	7e 0a                	jle    3f2 <atoi+0x4c>
 3e8:	8b 45 08             	mov    0x8(%ebp),%eax
 3eb:	0f b6 00             	movzbl (%eax),%eax
 3ee:	3c 39                	cmp    $0x39,%al
 3f0:	7e c7                	jle    3b9 <atoi+0x13>
  return n;
 3f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3f5:	c9                   	leave  
 3f6:	c3                   	ret    

000003f7 <memmove>:

void *memmove(void *vdst, void *vsrc, int n) {
 3f7:	f3 0f 1e fb          	endbr32 
 3fb:	55                   	push   %ebp
 3fc:	89 e5                	mov    %esp,%ebp
 3fe:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 401:	8b 45 08             	mov    0x8(%ebp),%eax
 404:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 407:	8b 45 0c             	mov    0xc(%ebp),%eax
 40a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while (n-- > 0)
 40d:	eb 17                	jmp    426 <memmove+0x2f>
    *dst++ = *src++;
 40f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 412:	8d 42 01             	lea    0x1(%edx),%eax
 415:	89 45 f8             	mov    %eax,-0x8(%ebp)
 418:	8b 45 fc             	mov    -0x4(%ebp),%eax
 41b:	8d 48 01             	lea    0x1(%eax),%ecx
 41e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 421:	0f b6 12             	movzbl (%edx),%edx
 424:	88 10                	mov    %dl,(%eax)
  while (n-- > 0)
 426:	8b 45 10             	mov    0x10(%ebp),%eax
 429:	8d 50 ff             	lea    -0x1(%eax),%edx
 42c:	89 55 10             	mov    %edx,0x10(%ebp)
 42f:	85 c0                	test   %eax,%eax
 431:	7f dc                	jg     40f <memmove+0x18>
  return vdst;
 433:	8b 45 08             	mov    0x8(%ebp),%eax
}
 436:	c9                   	leave  
 437:	c3                   	ret    

00000438 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 438:	b8 01 00 00 00       	mov    $0x1,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <exit>:
SYSCALL(exit)
 440:	b8 02 00 00 00       	mov    $0x2,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <wait>:
SYSCALL(wait)
 448:	b8 03 00 00 00       	mov    $0x3,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <pipe>:
SYSCALL(pipe)
 450:	b8 04 00 00 00       	mov    $0x4,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <read>:
SYSCALL(read)
 458:	b8 05 00 00 00       	mov    $0x5,%eax
 45d:	cd 40                	int    $0x40
 45f:	c3                   	ret    

00000460 <write>:
SYSCALL(write)
 460:	b8 10 00 00 00       	mov    $0x10,%eax
 465:	cd 40                	int    $0x40
 467:	c3                   	ret    

00000468 <close>:
SYSCALL(close)
 468:	b8 15 00 00 00       	mov    $0x15,%eax
 46d:	cd 40                	int    $0x40
 46f:	c3                   	ret    

00000470 <kill>:
SYSCALL(kill)
 470:	b8 06 00 00 00       	mov    $0x6,%eax
 475:	cd 40                	int    $0x40
 477:	c3                   	ret    

00000478 <exec>:
SYSCALL(exec)
 478:	b8 07 00 00 00       	mov    $0x7,%eax
 47d:	cd 40                	int    $0x40
 47f:	c3                   	ret    

00000480 <open>:
SYSCALL(open)
 480:	b8 0f 00 00 00       	mov    $0xf,%eax
 485:	cd 40                	int    $0x40
 487:	c3                   	ret    

00000488 <mknod>:
SYSCALL(mknod)
 488:	b8 11 00 00 00       	mov    $0x11,%eax
 48d:	cd 40                	int    $0x40
 48f:	c3                   	ret    

00000490 <unlink>:
SYSCALL(unlink)
 490:	b8 12 00 00 00       	mov    $0x12,%eax
 495:	cd 40                	int    $0x40
 497:	c3                   	ret    

00000498 <fstat>:
SYSCALL(fstat)
 498:	b8 08 00 00 00       	mov    $0x8,%eax
 49d:	cd 40                	int    $0x40
 49f:	c3                   	ret    

000004a0 <link>:
SYSCALL(link)
 4a0:	b8 13 00 00 00       	mov    $0x13,%eax
 4a5:	cd 40                	int    $0x40
 4a7:	c3                   	ret    

000004a8 <mkdir>:
SYSCALL(mkdir)
 4a8:	b8 14 00 00 00       	mov    $0x14,%eax
 4ad:	cd 40                	int    $0x40
 4af:	c3                   	ret    

000004b0 <chdir>:
SYSCALL(chdir)
 4b0:	b8 09 00 00 00       	mov    $0x9,%eax
 4b5:	cd 40                	int    $0x40
 4b7:	c3                   	ret    

000004b8 <dup>:
SYSCALL(dup)
 4b8:	b8 0a 00 00 00       	mov    $0xa,%eax
 4bd:	cd 40                	int    $0x40
 4bf:	c3                   	ret    

000004c0 <getpid>:
SYSCALL(getpid)
 4c0:	b8 0b 00 00 00       	mov    $0xb,%eax
 4c5:	cd 40                	int    $0x40
 4c7:	c3                   	ret    

000004c8 <sbrk>:
SYSCALL(sbrk)
 4c8:	b8 0c 00 00 00       	mov    $0xc,%eax
 4cd:	cd 40                	int    $0x40
 4cf:	c3                   	ret    

000004d0 <sleep>:
SYSCALL(sleep)
 4d0:	b8 0d 00 00 00       	mov    $0xd,%eax
 4d5:	cd 40                	int    $0x40
 4d7:	c3                   	ret    

000004d8 <uptime>:
SYSCALL(uptime)
 4d8:	b8 0e 00 00 00       	mov    $0xe,%eax
 4dd:	cd 40                	int    $0x40
 4df:	c3                   	ret    

000004e0 <trace>:
SYSCALL(trace)
 4e0:	b8 16 00 00 00       	mov    $0x16,%eax
 4e5:	cd 40                	int    $0x40
 4e7:	c3                   	ret    

000004e8 <setEFlag>:
SYSCALL(setEFlag)
 4e8:	b8 17 00 00 00       	mov    $0x17,%eax
 4ed:	cd 40                	int    $0x40
 4ef:	c3                   	ret    

000004f0 <setSFlag>:
SYSCALL(setSFlag)
 4f0:	b8 18 00 00 00       	mov    $0x18,%eax
 4f5:	cd 40                	int    $0x40
 4f7:	c3                   	ret    

000004f8 <setFFlag>:
SYSCALL(setFFlag)
 4f8:	b8 19 00 00 00       	mov    $0x19,%eax
 4fd:	cd 40                	int    $0x40
 4ff:	c3                   	ret    

00000500 <dump>:
 500:	b8 1a 00 00 00       	mov    $0x1a,%eax
 505:	cd 40                	int    $0x40
 507:	c3                   	ret    

00000508 <putc>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user.h"

static void putc(int fd, char c) { write(fd, &c, 1); }
 508:	f3 0f 1e fb          	endbr32 
 50c:	55                   	push   %ebp
 50d:	89 e5                	mov    %esp,%ebp
 50f:	83 ec 18             	sub    $0x18,%esp
 512:	8b 45 0c             	mov    0xc(%ebp),%eax
 515:	88 45 f4             	mov    %al,-0xc(%ebp)
 518:	83 ec 04             	sub    $0x4,%esp
 51b:	6a 01                	push   $0x1
 51d:	8d 45 f4             	lea    -0xc(%ebp),%eax
 520:	50                   	push   %eax
 521:	ff 75 08             	pushl  0x8(%ebp)
 524:	e8 37 ff ff ff       	call   460 <write>
 529:	83 c4 10             	add    $0x10,%esp
 52c:	90                   	nop
 52d:	c9                   	leave  
 52e:	c3                   	ret    

0000052f <printint>:

static void printint(int fd, int xx, int base, int sgn) {
 52f:	f3 0f 1e fb          	endbr32 
 533:	55                   	push   %ebp
 534:	89 e5                	mov    %esp,%ebp
 536:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 539:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if (sgn && xx < 0) {
 540:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 544:	74 17                	je     55d <printint+0x2e>
 546:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 54a:	79 11                	jns    55d <printint+0x2e>
    neg = 1;
 54c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 553:	8b 45 0c             	mov    0xc(%ebp),%eax
 556:	f7 d8                	neg    %eax
 558:	89 45 ec             	mov    %eax,-0x14(%ebp)
 55b:	eb 06                	jmp    563 <printint+0x34>
  } else {
    x = xx;
 55d:	8b 45 0c             	mov    0xc(%ebp),%eax
 560:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 563:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do {
    buf[i++] = digits[x % base];
 56a:	8b 4d 10             	mov    0x10(%ebp),%ecx
 56d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 570:	ba 00 00 00 00       	mov    $0x0,%edx
 575:	f7 f1                	div    %ecx
 577:	89 d1                	mov    %edx,%ecx
 579:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57c:	8d 50 01             	lea    0x1(%eax),%edx
 57f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 582:	0f b6 91 54 0c 00 00 	movzbl 0xc54(%ecx),%edx
 589:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  } while ((x /= base) != 0);
 58d:	8b 4d 10             	mov    0x10(%ebp),%ecx
 590:	8b 45 ec             	mov    -0x14(%ebp),%eax
 593:	ba 00 00 00 00       	mov    $0x0,%edx
 598:	f7 f1                	div    %ecx
 59a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 59d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5a1:	75 c7                	jne    56a <printint+0x3b>
  if (neg)
 5a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5a7:	74 2d                	je     5d6 <printint+0xa7>
    buf[i++] = '-';
 5a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ac:	8d 50 01             	lea    0x1(%eax),%edx
 5af:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5b2:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while (--i >= 0)
 5b7:	eb 1d                	jmp    5d6 <printint+0xa7>
    putc(fd, buf[i]);
 5b9:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5bf:	01 d0                	add    %edx,%eax
 5c1:	0f b6 00             	movzbl (%eax),%eax
 5c4:	0f be c0             	movsbl %al,%eax
 5c7:	83 ec 08             	sub    $0x8,%esp
 5ca:	50                   	push   %eax
 5cb:	ff 75 08             	pushl  0x8(%ebp)
 5ce:	e8 35 ff ff ff       	call   508 <putc>
 5d3:	83 c4 10             	add    $0x10,%esp
  while (--i >= 0)
 5d6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5de:	79 d9                	jns    5b9 <printint+0x8a>
}
 5e0:	90                   	nop
 5e1:	90                   	nop
 5e2:	c9                   	leave  
 5e3:	c3                   	ret    

000005e4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void printf(int fd, char *fmt, ...) {
 5e4:	f3 0f 1e fb          	endbr32 
 5e8:	55                   	push   %ebp
 5e9:	89 e5                	mov    %esp,%ebp
 5eb:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5ee:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint *)(void *)&fmt + 1;
 5f5:	8d 45 0c             	lea    0xc(%ebp),%eax
 5f8:	83 c0 04             	add    $0x4,%eax
 5fb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for (i = 0; fmt[i]; i++) {
 5fe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 605:	e9 59 01 00 00       	jmp    763 <printf+0x17f>
    c = fmt[i] & 0xff;
 60a:	8b 55 0c             	mov    0xc(%ebp),%edx
 60d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 610:	01 d0                	add    %edx,%eax
 612:	0f b6 00             	movzbl (%eax),%eax
 615:	0f be c0             	movsbl %al,%eax
 618:	25 ff 00 00 00       	and    $0xff,%eax
 61d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (state == 0) {
 620:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 624:	75 2c                	jne    652 <printf+0x6e>
      if (c == '%') {
 626:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 62a:	75 0c                	jne    638 <printf+0x54>
        state = '%';
 62c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 633:	e9 27 01 00 00       	jmp    75f <printf+0x17b>
      } else {
        putc(fd, c);
 638:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 63b:	0f be c0             	movsbl %al,%eax
 63e:	83 ec 08             	sub    $0x8,%esp
 641:	50                   	push   %eax
 642:	ff 75 08             	pushl  0x8(%ebp)
 645:	e8 be fe ff ff       	call   508 <putc>
 64a:	83 c4 10             	add    $0x10,%esp
 64d:	e9 0d 01 00 00       	jmp    75f <printf+0x17b>
      }
    } else if (state == '%') {
 652:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 656:	0f 85 03 01 00 00    	jne    75f <printf+0x17b>
      if (c == 'd') {
 65c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 660:	75 1e                	jne    680 <printf+0x9c>
        printint(fd, *ap, 10, 1);
 662:	8b 45 e8             	mov    -0x18(%ebp),%eax
 665:	8b 00                	mov    (%eax),%eax
 667:	6a 01                	push   $0x1
 669:	6a 0a                	push   $0xa
 66b:	50                   	push   %eax
 66c:	ff 75 08             	pushl  0x8(%ebp)
 66f:	e8 bb fe ff ff       	call   52f <printint>
 674:	83 c4 10             	add    $0x10,%esp
        ap++;
 677:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 67b:	e9 d8 00 00 00       	jmp    758 <printf+0x174>
      } else if (c == 'x' || c == 'p') {
 680:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 684:	74 06                	je     68c <printf+0xa8>
 686:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 68a:	75 1e                	jne    6aa <printf+0xc6>
        printint(fd, *ap, 16, 0);
 68c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 68f:	8b 00                	mov    (%eax),%eax
 691:	6a 00                	push   $0x0
 693:	6a 10                	push   $0x10
 695:	50                   	push   %eax
 696:	ff 75 08             	pushl  0x8(%ebp)
 699:	e8 91 fe ff ff       	call   52f <printint>
 69e:	83 c4 10             	add    $0x10,%esp
        ap++;
 6a1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6a5:	e9 ae 00 00 00       	jmp    758 <printf+0x174>
      } else if (c == 's') {
 6aa:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6ae:	75 43                	jne    6f3 <printf+0x10f>
        s = (char *)*ap;
 6b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6b3:	8b 00                	mov    (%eax),%eax
 6b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6b8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if (s == 0)
 6bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6c0:	75 25                	jne    6e7 <printf+0x103>
          s = "(null)";
 6c2:	c7 45 f4 e3 09 00 00 	movl   $0x9e3,-0xc(%ebp)
        while (*s != 0) {
 6c9:	eb 1c                	jmp    6e7 <printf+0x103>
          putc(fd, *s);
 6cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ce:	0f b6 00             	movzbl (%eax),%eax
 6d1:	0f be c0             	movsbl %al,%eax
 6d4:	83 ec 08             	sub    $0x8,%esp
 6d7:	50                   	push   %eax
 6d8:	ff 75 08             	pushl  0x8(%ebp)
 6db:	e8 28 fe ff ff       	call   508 <putc>
 6e0:	83 c4 10             	add    $0x10,%esp
          s++;
 6e3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while (*s != 0) {
 6e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ea:	0f b6 00             	movzbl (%eax),%eax
 6ed:	84 c0                	test   %al,%al
 6ef:	75 da                	jne    6cb <printf+0xe7>
 6f1:	eb 65                	jmp    758 <printf+0x174>
        }
      } else if (c == 'c') {
 6f3:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6f7:	75 1d                	jne    716 <printf+0x132>
        putc(fd, *ap);
 6f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6fc:	8b 00                	mov    (%eax),%eax
 6fe:	0f be c0             	movsbl %al,%eax
 701:	83 ec 08             	sub    $0x8,%esp
 704:	50                   	push   %eax
 705:	ff 75 08             	pushl  0x8(%ebp)
 708:	e8 fb fd ff ff       	call   508 <putc>
 70d:	83 c4 10             	add    $0x10,%esp
        ap++;
 710:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 714:	eb 42                	jmp    758 <printf+0x174>
      } else if (c == '%') {
 716:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 71a:	75 17                	jne    733 <printf+0x14f>
        putc(fd, c);
 71c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 71f:	0f be c0             	movsbl %al,%eax
 722:	83 ec 08             	sub    $0x8,%esp
 725:	50                   	push   %eax
 726:	ff 75 08             	pushl  0x8(%ebp)
 729:	e8 da fd ff ff       	call   508 <putc>
 72e:	83 c4 10             	add    $0x10,%esp
 731:	eb 25                	jmp    758 <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 733:	83 ec 08             	sub    $0x8,%esp
 736:	6a 25                	push   $0x25
 738:	ff 75 08             	pushl  0x8(%ebp)
 73b:	e8 c8 fd ff ff       	call   508 <putc>
 740:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 743:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 746:	0f be c0             	movsbl %al,%eax
 749:	83 ec 08             	sub    $0x8,%esp
 74c:	50                   	push   %eax
 74d:	ff 75 08             	pushl  0x8(%ebp)
 750:	e8 b3 fd ff ff       	call   508 <putc>
 755:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 758:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for (i = 0; fmt[i]; i++) {
 75f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 763:	8b 55 0c             	mov    0xc(%ebp),%edx
 766:	8b 45 f0             	mov    -0x10(%ebp),%eax
 769:	01 d0                	add    %edx,%eax
 76b:	0f b6 00             	movzbl (%eax),%eax
 76e:	84 c0                	test   %al,%al
 770:	0f 85 94 fe ff ff    	jne    60a <printf+0x26>
    }
  }
}
 776:	90                   	nop
 777:	90                   	nop
 778:	c9                   	leave  
 779:	c3                   	ret    

0000077a <free>:
typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
 77a:	f3 0f 1e fb          	endbr32 
 77e:	55                   	push   %ebp
 77f:	89 e5                	mov    %esp,%ebp
 781:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header *)ap - 1;
 784:	8b 45 08             	mov    0x8(%ebp),%eax
 787:	83 e8 08             	sub    $0x8,%eax
 78a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78d:	a1 88 0c 00 00       	mov    0xc88,%eax
 792:	89 45 fc             	mov    %eax,-0x4(%ebp)
 795:	eb 24                	jmp    7bb <free+0x41>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 797:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79a:	8b 00                	mov    (%eax),%eax
 79c:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 79f:	72 12                	jb     7b3 <free+0x39>
 7a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7a7:	77 24                	ja     7cd <free+0x53>
 7a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ac:	8b 00                	mov    (%eax),%eax
 7ae:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 7b1:	72 1a                	jb     7cd <free+0x53>
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b6:	8b 00                	mov    (%eax),%eax
 7b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7be:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7c1:	76 d4                	jbe    797 <free+0x1d>
 7c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c6:	8b 00                	mov    (%eax),%eax
 7c8:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 7cb:	73 ca                	jae    797 <free+0x1d>
      break;
  if (bp + bp->s.size == p->s.ptr) {
 7cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d0:	8b 40 04             	mov    0x4(%eax),%eax
 7d3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7da:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7dd:	01 c2                	add    %eax,%edx
 7df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e2:	8b 00                	mov    (%eax),%eax
 7e4:	39 c2                	cmp    %eax,%edx
 7e6:	75 24                	jne    80c <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 7e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7eb:	8b 50 04             	mov    0x4(%eax),%edx
 7ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f1:	8b 00                	mov    (%eax),%eax
 7f3:	8b 40 04             	mov    0x4(%eax),%eax
 7f6:	01 c2                	add    %eax,%edx
 7f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fb:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 801:	8b 00                	mov    (%eax),%eax
 803:	8b 10                	mov    (%eax),%edx
 805:	8b 45 f8             	mov    -0x8(%ebp),%eax
 808:	89 10                	mov    %edx,(%eax)
 80a:	eb 0a                	jmp    816 <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 80c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80f:	8b 10                	mov    (%eax),%edx
 811:	8b 45 f8             	mov    -0x8(%ebp),%eax
 814:	89 10                	mov    %edx,(%eax)
  if (p + p->s.size == bp) {
 816:	8b 45 fc             	mov    -0x4(%ebp),%eax
 819:	8b 40 04             	mov    0x4(%eax),%eax
 81c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 823:	8b 45 fc             	mov    -0x4(%ebp),%eax
 826:	01 d0                	add    %edx,%eax
 828:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 82b:	75 20                	jne    84d <free+0xd3>
    p->s.size += bp->s.size;
 82d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 830:	8b 50 04             	mov    0x4(%eax),%edx
 833:	8b 45 f8             	mov    -0x8(%ebp),%eax
 836:	8b 40 04             	mov    0x4(%eax),%eax
 839:	01 c2                	add    %eax,%edx
 83b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 841:	8b 45 f8             	mov    -0x8(%ebp),%eax
 844:	8b 10                	mov    (%eax),%edx
 846:	8b 45 fc             	mov    -0x4(%ebp),%eax
 849:	89 10                	mov    %edx,(%eax)
 84b:	eb 08                	jmp    855 <free+0xdb>
  } else
    p->s.ptr = bp;
 84d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 850:	8b 55 f8             	mov    -0x8(%ebp),%edx
 853:	89 10                	mov    %edx,(%eax)
  freep = p;
 855:	8b 45 fc             	mov    -0x4(%ebp),%eax
 858:	a3 88 0c 00 00       	mov    %eax,0xc88
}
 85d:	90                   	nop
 85e:	c9                   	leave  
 85f:	c3                   	ret    

00000860 <morecore>:

static Header *morecore(uint nu) {
 860:	f3 0f 1e fb          	endbr32 
 864:	55                   	push   %ebp
 865:	89 e5                	mov    %esp,%ebp
 867:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if (nu < 4096)
 86a:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 871:	77 07                	ja     87a <morecore+0x1a>
    nu = 4096;
 873:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 87a:	8b 45 08             	mov    0x8(%ebp),%eax
 87d:	c1 e0 03             	shl    $0x3,%eax
 880:	83 ec 0c             	sub    $0xc,%esp
 883:	50                   	push   %eax
 884:	e8 3f fc ff ff       	call   4c8 <sbrk>
 889:	83 c4 10             	add    $0x10,%esp
 88c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (p == (char *)-1)
 88f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 893:	75 07                	jne    89c <morecore+0x3c>
    return 0;
 895:	b8 00 00 00 00       	mov    $0x0,%eax
 89a:	eb 26                	jmp    8c2 <morecore+0x62>
  hp = (Header *)p;
 89c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a5:	8b 55 08             	mov    0x8(%ebp),%edx
 8a8:	89 50 04             	mov    %edx,0x4(%eax)
  free((void *)(hp + 1));
 8ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ae:	83 c0 08             	add    $0x8,%eax
 8b1:	83 ec 0c             	sub    $0xc,%esp
 8b4:	50                   	push   %eax
 8b5:	e8 c0 fe ff ff       	call   77a <free>
 8ba:	83 c4 10             	add    $0x10,%esp
  return freep;
 8bd:	a1 88 0c 00 00       	mov    0xc88,%eax
}
 8c2:	c9                   	leave  
 8c3:	c3                   	ret    

000008c4 <malloc>:

void *malloc(uint nbytes) {
 8c4:	f3 0f 1e fb          	endbr32 
 8c8:	55                   	push   %ebp
 8c9:	89 e5                	mov    %esp,%ebp
 8cb:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 8ce:	8b 45 08             	mov    0x8(%ebp),%eax
 8d1:	83 c0 07             	add    $0x7,%eax
 8d4:	c1 e8 03             	shr    $0x3,%eax
 8d7:	83 c0 01             	add    $0x1,%eax
 8da:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if ((prevp = freep) == 0) {
 8dd:	a1 88 0c 00 00       	mov    0xc88,%eax
 8e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8e9:	75 23                	jne    90e <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 8eb:	c7 45 f0 80 0c 00 00 	movl   $0xc80,-0x10(%ebp)
 8f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f5:	a3 88 0c 00 00       	mov    %eax,0xc88
 8fa:	a1 88 0c 00 00       	mov    0xc88,%eax
 8ff:	a3 80 0c 00 00       	mov    %eax,0xc80
    base.s.size = 0;
 904:	c7 05 84 0c 00 00 00 	movl   $0x0,0xc84
 90b:	00 00 00 
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 90e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 911:	8b 00                	mov    (%eax),%eax
 913:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p->s.size >= nunits) {
 916:	8b 45 f4             	mov    -0xc(%ebp),%eax
 919:	8b 40 04             	mov    0x4(%eax),%eax
 91c:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 91f:	77 4d                	ja     96e <malloc+0xaa>
      if (p->s.size == nunits)
 921:	8b 45 f4             	mov    -0xc(%ebp),%eax
 924:	8b 40 04             	mov    0x4(%eax),%eax
 927:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 92a:	75 0c                	jne    938 <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 92c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92f:	8b 10                	mov    (%eax),%edx
 931:	8b 45 f0             	mov    -0x10(%ebp),%eax
 934:	89 10                	mov    %edx,(%eax)
 936:	eb 26                	jmp    95e <malloc+0x9a>
      else {
        p->s.size -= nunits;
 938:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93b:	8b 40 04             	mov    0x4(%eax),%eax
 93e:	2b 45 ec             	sub    -0x14(%ebp),%eax
 941:	89 c2                	mov    %eax,%edx
 943:	8b 45 f4             	mov    -0xc(%ebp),%eax
 946:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 949:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94c:	8b 40 04             	mov    0x4(%eax),%eax
 94f:	c1 e0 03             	shl    $0x3,%eax
 952:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 955:	8b 45 f4             	mov    -0xc(%ebp),%eax
 958:	8b 55 ec             	mov    -0x14(%ebp),%edx
 95b:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 95e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 961:	a3 88 0c 00 00       	mov    %eax,0xc88
      return (void *)(p + 1);
 966:	8b 45 f4             	mov    -0xc(%ebp),%eax
 969:	83 c0 08             	add    $0x8,%eax
 96c:	eb 3b                	jmp    9a9 <malloc+0xe5>
    }
    if (p == freep)
 96e:	a1 88 0c 00 00       	mov    0xc88,%eax
 973:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 976:	75 1e                	jne    996 <malloc+0xd2>
      if ((p = morecore(nunits)) == 0)
 978:	83 ec 0c             	sub    $0xc,%esp
 97b:	ff 75 ec             	pushl  -0x14(%ebp)
 97e:	e8 dd fe ff ff       	call   860 <morecore>
 983:	83 c4 10             	add    $0x10,%esp
 986:	89 45 f4             	mov    %eax,-0xc(%ebp)
 989:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 98d:	75 07                	jne    996 <malloc+0xd2>
        return 0;
 98f:	b8 00 00 00 00       	mov    $0x0,%eax
 994:	eb 13                	jmp    9a9 <malloc+0xe5>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 996:	8b 45 f4             	mov    -0xc(%ebp),%eax
 999:	89 45 f0             	mov    %eax,-0x10(%ebp)
 99c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99f:	8b 00                	mov    (%eax),%eax
 9a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p->s.size >= nunits) {
 9a4:	e9 6d ff ff ff       	jmp    916 <malloc+0x52>
  }
}
 9a9:	c9                   	leave  
 9aa:	c3                   	ret    
