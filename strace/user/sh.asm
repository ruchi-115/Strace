
user/_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <streq>:

char trace_cmd[] = "strace on\n";
char untrace_cmd[] = "strace off\n";
char trace_dump[] = "strace dump\n";

int streq(char* a, char* b) {
       0:	f3 0f 1e fb          	endbr32 
       4:	55                   	push   %ebp
       5:	89 e5                	mov    %esp,%ebp
    while(1) {
        if(*a != *b) {
       7:	8b 45 08             	mov    0x8(%ebp),%eax
       a:	0f b6 10             	movzbl (%eax),%edx
       d:	8b 45 0c             	mov    0xc(%ebp),%eax
      10:	0f b6 00             	movzbl (%eax),%eax
      13:	38 c2                	cmp    %al,%dl
      15:	74 07                	je     1e <streq+0x1e>
            return 0;
      17:	b8 00 00 00 00       	mov    $0x0,%eax
      1c:	eb 1b                	jmp    39 <streq+0x39>
        }
        if(*a == '\n') {
      1e:	8b 45 08             	mov    0x8(%ebp),%eax
      21:	0f b6 00             	movzbl (%eax),%eax
      24:	3c 0a                	cmp    $0xa,%al
      26:	75 07                	jne    2f <streq+0x2f>
            return 1;
      28:	b8 01 00 00 00       	mov    $0x1,%eax
      2d:	eb 0a                	jmp    39 <streq+0x39>
        }
        a += 1;
      2f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        b += 1;
      33:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        if(*a != *b) {
      37:	eb ce                	jmp    7 <streq+0x7>
    }
}
      39:	5d                   	pop    %ebp
      3a:	c3                   	ret    

0000003b <runcmd>:
int fork1(void); // Fork but panics on failure.
void panic(char *);
struct cmd *parsecmd(char *);

// Execute cmd.  Never returns.
void runcmd(struct cmd *cmd) {
      3b:	f3 0f 1e fb          	endbr32 
      3f:	55                   	push   %ebp
      40:	89 e5                	mov    %esp,%ebp
      42:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if (cmd == 0)
      45:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
      49:	75 05                	jne    50 <runcmd+0x15>
    exit();
      4b:	e8 93 16 00 00       	call   16e3 <exit>

  switch (cmd->type) {
      50:	8b 45 08             	mov    0x8(%ebp),%eax
      53:	8b 00                	mov    (%eax),%eax
      55:	83 f8 05             	cmp    $0x5,%eax
      58:	77 0a                	ja     64 <runcmd+0x29>
      5a:	8b 04 85 f4 1c 00 00 	mov    0x1cf4(,%eax,4),%eax
      61:	3e ff e0             	notrack jmp *%eax
  default:
    panic("runcmd");
      64:	83 ec 0c             	sub    $0xc,%esp
      67:	68 cb 1c 00 00       	push   $0x1ccb
      6c:	e8 d1 0a 00 00       	call   b42 <panic>
      71:	83 c4 10             	add    $0x10,%esp

  case EXEC:
    ecmd = (struct execcmd *)cmd;
      74:	8b 45 08             	mov    0x8(%ebp),%eax
      77:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (ecmd->argv[0] == 0)
      7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      7d:	8b 40 04             	mov    0x4(%eax),%eax
      80:	85 c0                	test   %eax,%eax
      82:	75 05                	jne    89 <runcmd+0x4e>
      exit();
      84:	e8 5a 16 00 00       	call   16e3 <exit>
    if (tracing) {
      89:	a1 20 23 00 00       	mov    0x2320,%eax
      8e:	85 c0                	test   %eax,%eax
      90:	74 0d                	je     9f <runcmd+0x64>
        trace(T_TRACE | T_ONFORK);
      92:	83 ec 0c             	sub    $0xc,%esp
      95:	6a 03                	push   $0x3
      97:	e8 e7 16 00 00       	call   1783 <trace>
      9c:	83 c4 10             	add    $0x10,%esp
    }
    exec(ecmd->argv[0], ecmd->argv);
      9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      a2:	8d 50 04             	lea    0x4(%eax),%edx
      a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      a8:	8b 40 04             	mov    0x4(%eax),%eax
      ab:	83 ec 08             	sub    $0x8,%esp
      ae:	52                   	push   %edx
      af:	50                   	push   %eax
      b0:	e8 66 16 00 00       	call   171b <exec>
      b5:	83 c4 10             	add    $0x10,%esp
    printf(2, "exec %s failed\n", ecmd->argv[0]);
      b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      bb:	8b 40 04             	mov    0x4(%eax),%eax
      be:	83 ec 04             	sub    $0x4,%esp
      c1:	50                   	push   %eax
      c2:	68 d2 1c 00 00       	push   $0x1cd2
      c7:	6a 02                	push   $0x2
      c9:	e8 b9 17 00 00       	call   1887 <printf>
      ce:	83 c4 10             	add    $0x10,%esp
    break;
      d1:	e9 c6 01 00 00       	jmp    29c <runcmd+0x261>

  case REDIR:
    rcmd = (struct redircmd *)cmd;
      d6:	8b 45 08             	mov    0x8(%ebp),%eax
      d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    close(rcmd->fd);
      dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
      df:	8b 40 14             	mov    0x14(%eax),%eax
      e2:	83 ec 0c             	sub    $0xc,%esp
      e5:	50                   	push   %eax
      e6:	e8 20 16 00 00       	call   170b <close>
      eb:	83 c4 10             	add    $0x10,%esp
    if (open(rcmd->file, rcmd->mode) < 0) {
      ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
      f1:	8b 50 10             	mov    0x10(%eax),%edx
      f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
      f7:	8b 40 08             	mov    0x8(%eax),%eax
      fa:	83 ec 08             	sub    $0x8,%esp
      fd:	52                   	push   %edx
      fe:	50                   	push   %eax
      ff:	e8 1f 16 00 00       	call   1723 <open>
     104:	83 c4 10             	add    $0x10,%esp
     107:	85 c0                	test   %eax,%eax
     109:	79 1e                	jns    129 <runcmd+0xee>
      printf(2, "open %s failed\n", rcmd->file);
     10b:	8b 45 e8             	mov    -0x18(%ebp),%eax
     10e:	8b 40 08             	mov    0x8(%eax),%eax
     111:	83 ec 04             	sub    $0x4,%esp
     114:	50                   	push   %eax
     115:	68 e2 1c 00 00       	push   $0x1ce2
     11a:	6a 02                	push   $0x2
     11c:	e8 66 17 00 00       	call   1887 <printf>
     121:	83 c4 10             	add    $0x10,%esp
      exit();
     124:	e8 ba 15 00 00       	call   16e3 <exit>
    }
    runcmd(rcmd->cmd);
     129:	8b 45 e8             	mov    -0x18(%ebp),%eax
     12c:	8b 40 04             	mov    0x4(%eax),%eax
     12f:	83 ec 0c             	sub    $0xc,%esp
     132:	50                   	push   %eax
     133:	e8 03 ff ff ff       	call   3b <runcmd>
     138:	83 c4 10             	add    $0x10,%esp
    break;
     13b:	e9 5c 01 00 00       	jmp    29c <runcmd+0x261>

  case LIST:
    lcmd = (struct listcmd *)cmd;
     140:	8b 45 08             	mov    0x8(%ebp),%eax
     143:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (fork1() == 0)
     146:	e8 1b 0a 00 00       	call   b66 <fork1>
     14b:	85 c0                	test   %eax,%eax
     14d:	75 12                	jne    161 <runcmd+0x126>
      runcmd(lcmd->left);
     14f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     152:	8b 40 04             	mov    0x4(%eax),%eax
     155:	83 ec 0c             	sub    $0xc,%esp
     158:	50                   	push   %eax
     159:	e8 dd fe ff ff       	call   3b <runcmd>
     15e:	83 c4 10             	add    $0x10,%esp
    wait();
     161:	e8 85 15 00 00       	call   16eb <wait>
    runcmd(lcmd->right);
     166:	8b 45 f0             	mov    -0x10(%ebp),%eax
     169:	8b 40 08             	mov    0x8(%eax),%eax
     16c:	83 ec 0c             	sub    $0xc,%esp
     16f:	50                   	push   %eax
     170:	e8 c6 fe ff ff       	call   3b <runcmd>
     175:	83 c4 10             	add    $0x10,%esp
    break;
     178:	e9 1f 01 00 00       	jmp    29c <runcmd+0x261>

  case PIPE:
    pcmd = (struct pipecmd *)cmd;
     17d:	8b 45 08             	mov    0x8(%ebp),%eax
     180:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (pipe(p) < 0)
     183:	83 ec 0c             	sub    $0xc,%esp
     186:	8d 45 dc             	lea    -0x24(%ebp),%eax
     189:	50                   	push   %eax
     18a:	e8 64 15 00 00       	call   16f3 <pipe>
     18f:	83 c4 10             	add    $0x10,%esp
     192:	85 c0                	test   %eax,%eax
     194:	79 10                	jns    1a6 <runcmd+0x16b>
      panic("pipe");
     196:	83 ec 0c             	sub    $0xc,%esp
     199:	68 5f 1c 00 00       	push   $0x1c5f
     19e:	e8 9f 09 00 00       	call   b42 <panic>
     1a3:	83 c4 10             	add    $0x10,%esp
    if (fork1() == 0) {
     1a6:	e8 bb 09 00 00       	call   b66 <fork1>
     1ab:	85 c0                	test   %eax,%eax
     1ad:	75 4c                	jne    1fb <runcmd+0x1c0>
      close(1);
     1af:	83 ec 0c             	sub    $0xc,%esp
     1b2:	6a 01                	push   $0x1
     1b4:	e8 52 15 00 00       	call   170b <close>
     1b9:	83 c4 10             	add    $0x10,%esp
      dup(p[1]);
     1bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1bf:	83 ec 0c             	sub    $0xc,%esp
     1c2:	50                   	push   %eax
     1c3:	e8 93 15 00 00       	call   175b <dup>
     1c8:	83 c4 10             	add    $0x10,%esp
      close(p[0]);
     1cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1ce:	83 ec 0c             	sub    $0xc,%esp
     1d1:	50                   	push   %eax
     1d2:	e8 34 15 00 00       	call   170b <close>
     1d7:	83 c4 10             	add    $0x10,%esp
      close(p[1]);
     1da:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1dd:	83 ec 0c             	sub    $0xc,%esp
     1e0:	50                   	push   %eax
     1e1:	e8 25 15 00 00       	call   170b <close>
     1e6:	83 c4 10             	add    $0x10,%esp
      runcmd(pcmd->left);
     1e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
     1ec:	8b 40 04             	mov    0x4(%eax),%eax
     1ef:	83 ec 0c             	sub    $0xc,%esp
     1f2:	50                   	push   %eax
     1f3:	e8 43 fe ff ff       	call   3b <runcmd>
     1f8:	83 c4 10             	add    $0x10,%esp
    }
    if (fork1() == 0) {
     1fb:	e8 66 09 00 00       	call   b66 <fork1>
     200:	85 c0                	test   %eax,%eax
     202:	75 4c                	jne    250 <runcmd+0x215>
      close(0);
     204:	83 ec 0c             	sub    $0xc,%esp
     207:	6a 00                	push   $0x0
     209:	e8 fd 14 00 00       	call   170b <close>
     20e:	83 c4 10             	add    $0x10,%esp
      dup(p[0]);
     211:	8b 45 dc             	mov    -0x24(%ebp),%eax
     214:	83 ec 0c             	sub    $0xc,%esp
     217:	50                   	push   %eax
     218:	e8 3e 15 00 00       	call   175b <dup>
     21d:	83 c4 10             	add    $0x10,%esp
      close(p[0]);
     220:	8b 45 dc             	mov    -0x24(%ebp),%eax
     223:	83 ec 0c             	sub    $0xc,%esp
     226:	50                   	push   %eax
     227:	e8 df 14 00 00       	call   170b <close>
     22c:	83 c4 10             	add    $0x10,%esp
      close(p[1]);
     22f:	8b 45 e0             	mov    -0x20(%ebp),%eax
     232:	83 ec 0c             	sub    $0xc,%esp
     235:	50                   	push   %eax
     236:	e8 d0 14 00 00       	call   170b <close>
     23b:	83 c4 10             	add    $0x10,%esp
      runcmd(pcmd->right);
     23e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     241:	8b 40 08             	mov    0x8(%eax),%eax
     244:	83 ec 0c             	sub    $0xc,%esp
     247:	50                   	push   %eax
     248:	e8 ee fd ff ff       	call   3b <runcmd>
     24d:	83 c4 10             	add    $0x10,%esp
    }
    close(p[0]);
     250:	8b 45 dc             	mov    -0x24(%ebp),%eax
     253:	83 ec 0c             	sub    $0xc,%esp
     256:	50                   	push   %eax
     257:	e8 af 14 00 00       	call   170b <close>
     25c:	83 c4 10             	add    $0x10,%esp
    close(p[1]);
     25f:	8b 45 e0             	mov    -0x20(%ebp),%eax
     262:	83 ec 0c             	sub    $0xc,%esp
     265:	50                   	push   %eax
     266:	e8 a0 14 00 00       	call   170b <close>
     26b:	83 c4 10             	add    $0x10,%esp
    wait();
     26e:	e8 78 14 00 00       	call   16eb <wait>
    wait();
     273:	e8 73 14 00 00       	call   16eb <wait>
    break;
     278:	eb 22                	jmp    29c <runcmd+0x261>

  case BACK:
    bcmd = (struct backcmd *)cmd;
     27a:	8b 45 08             	mov    0x8(%ebp),%eax
     27d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (fork1() == 0)
     280:	e8 e1 08 00 00       	call   b66 <fork1>
     285:	85 c0                	test   %eax,%eax
     287:	75 12                	jne    29b <runcmd+0x260>
      runcmd(bcmd->cmd);
     289:	8b 45 f4             	mov    -0xc(%ebp),%eax
     28c:	8b 40 04             	mov    0x4(%eax),%eax
     28f:	83 ec 0c             	sub    $0xc,%esp
     292:	50                   	push   %eax
     293:	e8 a3 fd ff ff       	call   3b <runcmd>
     298:	83 c4 10             	add    $0x10,%esp
    break;
     29b:	90                   	nop
  }
  exit();
     29c:	e8 42 14 00 00       	call   16e3 <exit>

000002a1 <getcmd>:
}

int getcmd(char *buf, int nbuf) {
     2a1:	f3 0f 1e fb          	endbr32 
     2a5:	55                   	push   %ebp
     2a6:	89 e5                	mov    %esp,%ebp
     2a8:	83 ec 08             	sub    $0x8,%esp
  printf(2, "$ ");
     2ab:	83 ec 08             	sub    $0x8,%esp
     2ae:	68 0c 1d 00 00       	push   $0x1d0c
     2b3:	6a 02                	push   $0x2
     2b5:	e8 cd 15 00 00       	call   1887 <printf>
     2ba:	83 c4 10             	add    $0x10,%esp
  memset(buf, 0, nbuf);
     2bd:	8b 45 0c             	mov    0xc(%ebp),%eax
     2c0:	83 ec 04             	sub    $0x4,%esp
     2c3:	50                   	push   %eax
     2c4:	6a 00                	push   $0x0
     2c6:	ff 75 08             	pushl  0x8(%ebp)
     2c9:	e8 62 12 00 00       	call   1530 <memset>
     2ce:	83 c4 10             	add    $0x10,%esp
  gets(buf, nbuf);
     2d1:	83 ec 08             	sub    $0x8,%esp
     2d4:	ff 75 0c             	pushl  0xc(%ebp)
     2d7:	ff 75 08             	pushl  0x8(%ebp)
     2da:	e8 a6 12 00 00       	call   1585 <gets>
     2df:	83 c4 10             	add    $0x10,%esp
  if (buf[0] == 0) // EOF
     2e2:	8b 45 08             	mov    0x8(%ebp),%eax
     2e5:	0f b6 00             	movzbl (%eax),%eax
     2e8:	84 c0                	test   %al,%al
     2ea:	75 07                	jne    2f3 <getcmd+0x52>
    return -1;
     2ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     2f1:	eb 05                	jmp    2f8 <getcmd+0x57>
  return 0;
     2f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
     2f8:	c9                   	leave  
     2f9:	c3                   	ret    

000002fa <main>:

int main(void) {
     2fa:	f3 0f 1e fb          	endbr32 
     2fe:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     302:	83 e4 f0             	and    $0xfffffff0,%esp
     305:	ff 71 fc             	pushl  -0x4(%ecx)
     308:	55                   	push   %ebp
     309:	89 e5                	mov    %esp,%ebp
     30b:	51                   	push   %ecx
     30c:	81 ec 84 00 00 00    	sub    $0x84,%esp
  static char buf[100];
  int fd;

  // Assumes three file descriptors open.
  while ((fd = open("console", O_RDWR)) >= 0) {
     312:	eb 16                	jmp    32a <main+0x30>
    if (fd >= 3) {
     314:	83 7d bc 02          	cmpl   $0x2,-0x44(%ebp)
     318:	7e 10                	jle    32a <main+0x30>
      close(fd);
     31a:	83 ec 0c             	sub    $0xc,%esp
     31d:	ff 75 bc             	pushl  -0x44(%ebp)
     320:	e8 e6 13 00 00       	call   170b <close>
     325:	83 c4 10             	add    $0x10,%esp
      break;
     328:	eb 1b                	jmp    345 <main+0x4b>
  while ((fd = open("console", O_RDWR)) >= 0) {
     32a:	83 ec 08             	sub    $0x8,%esp
     32d:	6a 02                	push   $0x2
     32f:	68 0f 1d 00 00       	push   $0x1d0f
     334:	e8 ea 13 00 00       	call   1723 <open>
     339:	83 c4 10             	add    $0x10,%esp
     33c:	89 45 bc             	mov    %eax,-0x44(%ebp)
     33f:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
     343:	79 cf                	jns    314 <main+0x1a>
    }
  }

  int straceRunCalled = 0;
     345:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  int straceFlagCalled = 0;
     34c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  // Read and run input commands.
  while (getcmd(buf, sizeof(buf)) >= 0) {
     353:	e9 cb 07 00 00       	jmp    b23 <main+0x829>
    if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ') {
     358:	0f b6 05 40 23 00 00 	movzbl 0x2340,%eax
     35f:	3c 63                	cmp    $0x63,%al
     361:	75 66                	jne    3c9 <main+0xcf>
     363:	0f b6 05 41 23 00 00 	movzbl 0x2341,%eax
     36a:	3c 64                	cmp    $0x64,%al
     36c:	75 5b                	jne    3c9 <main+0xcf>
     36e:	0f b6 05 42 23 00 00 	movzbl 0x2342,%eax
     375:	3c 20                	cmp    $0x20,%al
     377:	75 50                	jne    3c9 <main+0xcf>
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf) - 1] = 0; // chop \n
     379:	83 ec 0c             	sub    $0xc,%esp
     37c:	68 40 23 00 00       	push   $0x2340
     381:	e8 7f 11 00 00       	call   1505 <strlen>
     386:	83 c4 10             	add    $0x10,%esp
     389:	83 e8 01             	sub    $0x1,%eax
     38c:	c6 80 40 23 00 00 00 	movb   $0x0,0x2340(%eax)
      if (chdir(buf + 3) < 0)
     393:	b8 43 23 00 00       	mov    $0x2343,%eax
     398:	83 ec 0c             	sub    $0xc,%esp
     39b:	50                   	push   %eax
     39c:	e8 b2 13 00 00       	call   1753 <chdir>
     3a1:	83 c4 10             	add    $0x10,%esp
     3a4:	85 c0                	test   %eax,%eax
     3a6:	0f 89 77 07 00 00    	jns    b23 <main+0x829>
        printf(2, "cannot cd %s\n", buf + 3);
     3ac:	b8 43 23 00 00       	mov    $0x2343,%eax
     3b1:	83 ec 04             	sub    $0x4,%esp
     3b4:	50                   	push   %eax
     3b5:	68 17 1d 00 00       	push   $0x1d17
     3ba:	6a 02                	push   $0x2
     3bc:	e8 c6 14 00 00       	call   1887 <printf>
     3c1:	83 c4 10             	add    $0x10,%esp
      continue;
     3c4:	e9 5a 07 00 00       	jmp    b23 <main+0x829>
    }
    else if(streq(buf, trace_cmd)) {
     3c9:	83 ec 08             	sub    $0x8,%esp
     3cc:	68 b8 22 00 00       	push   $0x22b8
     3d1:	68 40 23 00 00       	push   $0x2340
     3d6:	e8 25 fc ff ff       	call   0 <streq>
     3db:	83 c4 10             	add    $0x10,%esp
     3de:	85 c0                	test   %eax,%eax
     3e0:	74 0f                	je     3f1 <main+0xf7>
        tracing = 1;
     3e2:	c7 05 20 23 00 00 01 	movl   $0x1,0x2320
     3e9:	00 00 00 
        continue;
     3ec:	e9 32 07 00 00       	jmp    b23 <main+0x829>
    }
    else if(streq(buf, untrace_cmd)) {
     3f1:	83 ec 08             	sub    $0x8,%esp
     3f4:	68 c4 22 00 00       	push   $0x22c4
     3f9:	68 40 23 00 00       	push   $0x2340
     3fe:	e8 fd fb ff ff       	call   0 <streq>
     403:	83 c4 10             	add    $0x10,%esp
     406:	85 c0                	test   %eax,%eax
     408:	74 0f                	je     419 <main+0x11f>
        tracing = 0;
     40a:	c7 05 20 23 00 00 00 	movl   $0x0,0x2320
     411:	00 00 00 
        continue;
     414:	e9 0a 07 00 00       	jmp    b23 <main+0x829>
    }
    else if((dumping == 1) || streq(buf,trace_dump)) {
     419:	a1 24 23 00 00       	mov    0x2324,%eax
     41e:	83 f8 01             	cmp    $0x1,%eax
     421:	74 19                	je     43c <main+0x142>
     423:	83 ec 08             	sub    $0x8,%esp
     426:	68 d0 22 00 00       	push   $0x22d0
     42b:	68 40 23 00 00       	push   $0x2340
     430:	e8 cb fb ff ff       	call   0 <streq>
     435:	83 c4 10             	add    $0x10,%esp
     438:	85 c0                	test   %eax,%eax
     43a:	74 44                	je     480 <main+0x186>
        dumping = 1;
     43c:	c7 05 24 23 00 00 01 	movl   $0x1,0x2324
     443:	00 00 00 
        if(fork1()==0) {
     446:	e8 1b 07 00 00       	call   b66 <fork1>
     44b:	85 c0                	test   %eax,%eax
     44d:	75 1d                	jne    46c <main+0x172>
            runcmd(parsecmd(buf+7));
     44f:	b8 47 23 00 00       	mov    $0x2347,%eax
     454:	83 ec 0c             	sub    $0xc,%esp
     457:	50                   	push   %eax
     458:	e8 80 0a 00 00       	call   edd <parsecmd>
     45d:	83 c4 10             	add    $0x10,%esp
     460:	83 ec 0c             	sub    $0xc,%esp
     463:	50                   	push   %eax
     464:	e8 d2 fb ff ff       	call   3b <runcmd>
     469:	83 c4 10             	add    $0x10,%esp
        }
        wait();
     46c:	e8 7a 12 00 00       	call   16eb <wait>
        dumping = 0;
     471:	c7 05 24 23 00 00 00 	movl   $0x0,0x2324
     478:	00 00 00 
        continue;
     47b:	e9 a3 06 00 00       	jmp    b23 <main+0x829>
    }
    else if(buf[0] == 's' && buf[1] == 't' && buf[2] == 'r' && buf[3] == 'a' && buf[4] == 'c' && buf[5] == 'e' && buf[6] == ' ' && buf[7] == '-' && buf[8] == 'e' && buf[9] == ' ') {
     480:	0f b6 05 40 23 00 00 	movzbl 0x2340,%eax
     487:	3c 73                	cmp    $0x73,%al
     489:	0f 85 43 01 00 00    	jne    5d2 <main+0x2d8>
     48f:	0f b6 05 41 23 00 00 	movzbl 0x2341,%eax
     496:	3c 74                	cmp    $0x74,%al
     498:	0f 85 34 01 00 00    	jne    5d2 <main+0x2d8>
     49e:	0f b6 05 42 23 00 00 	movzbl 0x2342,%eax
     4a5:	3c 72                	cmp    $0x72,%al
     4a7:	0f 85 25 01 00 00    	jne    5d2 <main+0x2d8>
     4ad:	0f b6 05 43 23 00 00 	movzbl 0x2343,%eax
     4b4:	3c 61                	cmp    $0x61,%al
     4b6:	0f 85 16 01 00 00    	jne    5d2 <main+0x2d8>
     4bc:	0f b6 05 44 23 00 00 	movzbl 0x2344,%eax
     4c3:	3c 63                	cmp    $0x63,%al
     4c5:	0f 85 07 01 00 00    	jne    5d2 <main+0x2d8>
     4cb:	0f b6 05 45 23 00 00 	movzbl 0x2345,%eax
     4d2:	3c 65                	cmp    $0x65,%al
     4d4:	0f 85 f8 00 00 00    	jne    5d2 <main+0x2d8>
     4da:	0f b6 05 46 23 00 00 	movzbl 0x2346,%eax
     4e1:	3c 20                	cmp    $0x20,%al
     4e3:	0f 85 e9 00 00 00    	jne    5d2 <main+0x2d8>
     4e9:	0f b6 05 47 23 00 00 	movzbl 0x2347,%eax
     4f0:	3c 2d                	cmp    $0x2d,%al
     4f2:	0f 85 da 00 00 00    	jne    5d2 <main+0x2d8>
     4f8:	0f b6 05 48 23 00 00 	movzbl 0x2348,%eax
     4ff:	3c 65                	cmp    $0x65,%al
     501:	0f 85 cb 00 00 00    	jne    5d2 <main+0x2d8>
     507:	0f b6 05 49 23 00 00 	movzbl 0x2349,%eax
     50e:	3c 20                	cmp    $0x20,%al
     510:	0f 85 bc 00 00 00    	jne    5d2 <main+0x2d8>
        char flagcommand[20];
        for(int i = 0; i < 20; i++)
     516:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     51d:	eb 0f                	jmp    52e <main+0x234>
            flagcommand[i] = '\0';
     51f:	8d 55 a8             	lea    -0x58(%ebp),%edx
     522:	8b 45 ec             	mov    -0x14(%ebp),%eax
     525:	01 d0                	add    %edx,%eax
     527:	c6 00 00             	movb   $0x0,(%eax)
        for(int i = 0; i < 20; i++)
     52a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
     52e:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
     532:	7e eb                	jle    51f <main+0x225>
        for(int i = 10; i < strlen(buf)-1; i++)
     534:	c7 45 e8 0a 00 00 00 	movl   $0xa,-0x18(%ebp)
     53b:	eb 19                	jmp    556 <main+0x25c>
            flagcommand[i-10] = buf[i];
     53d:	8b 45 e8             	mov    -0x18(%ebp),%eax
     540:	8d 50 f6             	lea    -0xa(%eax),%edx
     543:	8b 45 e8             	mov    -0x18(%ebp),%eax
     546:	05 40 23 00 00       	add    $0x2340,%eax
     54b:	0f b6 00             	movzbl (%eax),%eax
     54e:	88 44 15 a8          	mov    %al,-0x58(%ebp,%edx,1)
        for(int i = 10; i < strlen(buf)-1; i++)
     552:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
     556:	83 ec 0c             	sub    $0xc,%esp
     559:	68 40 23 00 00       	push   $0x2340
     55e:	e8 a2 0f 00 00       	call   1505 <strlen>
     563:	83 c4 10             	add    $0x10,%esp
     566:	8d 50 ff             	lea    -0x1(%eax),%edx
     569:	8b 45 e8             	mov    -0x18(%ebp),%eax
     56c:	39 c2                	cmp    %eax,%edx
     56e:	77 cd                	ja     53d <main+0x243>
        int arrloc = -1;
     570:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
        for(int i = 0; i<22; i++) {
     577:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
     57e:	eb 28                	jmp    5a8 <main+0x2ae>
            if(strcmp(flagcommand, syscallNames[i]) == 0) {
     580:	8b 45 e0             	mov    -0x20(%ebp),%eax
     583:	8b 04 85 60 22 00 00 	mov    0x2260(,%eax,4),%eax
     58a:	83 ec 08             	sub    $0x8,%esp
     58d:	50                   	push   %eax
     58e:	8d 45 a8             	lea    -0x58(%ebp),%eax
     591:	50                   	push   %eax
     592:	e8 2b 0f 00 00       	call   14c2 <strcmp>
     597:	83 c4 10             	add    $0x10,%esp
     59a:	85 c0                	test   %eax,%eax
     59c:	75 06                	jne    5a4 <main+0x2aa>
                arrloc = i;
     59e:	8b 45 e0             	mov    -0x20(%ebp),%eax
     5a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for(int i = 0; i<22; i++) {
     5a4:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
     5a8:	83 7d e0 15          	cmpl   $0x15,-0x20(%ebp)
     5ac:	7e d2                	jle    580 <main+0x286>
            }
        }
        
        tracing = 1;
     5ae:	c7 05 20 23 00 00 01 	movl   $0x1,0x2320
     5b5:	00 00 00 
        straceFlagCalled = 1;
     5b8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
        setEFlag(arrloc);
     5bf:	83 ec 0c             	sub    $0xc,%esp
     5c2:	ff 75 e4             	pushl  -0x1c(%ebp)
     5c5:	e8 c1 11 00 00       	call   178b <setEFlag>
     5ca:	83 c4 10             	add    $0x10,%esp
     5cd:	e9 51 05 00 00       	jmp    b23 <main+0x829>
        continue;
    }
    else if(buf[0] == 's' && buf[1] == 't' && buf[2] == 'r' && buf[3] == 'a' && buf[4] == 'c' && buf[5] == 'e' && buf[6] == ' ' && buf[7] == '-' && buf[8] == 's' && buf[9] == ' ' && buf[10] == '-' && buf[11] == 'e' && buf[12] == ' ') {
     5d2:	0f b6 05 40 23 00 00 	movzbl 0x2340,%eax
     5d9:	3c 73                	cmp    $0x73,%al
     5db:	0f 85 7d 01 00 00    	jne    75e <main+0x464>
     5e1:	0f b6 05 41 23 00 00 	movzbl 0x2341,%eax
     5e8:	3c 74                	cmp    $0x74,%al
     5ea:	0f 85 6e 01 00 00    	jne    75e <main+0x464>
     5f0:	0f b6 05 42 23 00 00 	movzbl 0x2342,%eax
     5f7:	3c 72                	cmp    $0x72,%al
     5f9:	0f 85 5f 01 00 00    	jne    75e <main+0x464>
     5ff:	0f b6 05 43 23 00 00 	movzbl 0x2343,%eax
     606:	3c 61                	cmp    $0x61,%al
     608:	0f 85 50 01 00 00    	jne    75e <main+0x464>
     60e:	0f b6 05 44 23 00 00 	movzbl 0x2344,%eax
     615:	3c 63                	cmp    $0x63,%al
     617:	0f 85 41 01 00 00    	jne    75e <main+0x464>
     61d:	0f b6 05 45 23 00 00 	movzbl 0x2345,%eax
     624:	3c 65                	cmp    $0x65,%al
     626:	0f 85 32 01 00 00    	jne    75e <main+0x464>
     62c:	0f b6 05 46 23 00 00 	movzbl 0x2346,%eax
     633:	3c 20                	cmp    $0x20,%al
     635:	0f 85 23 01 00 00    	jne    75e <main+0x464>
     63b:	0f b6 05 47 23 00 00 	movzbl 0x2347,%eax
     642:	3c 2d                	cmp    $0x2d,%al
     644:	0f 85 14 01 00 00    	jne    75e <main+0x464>
     64a:	0f b6 05 48 23 00 00 	movzbl 0x2348,%eax
     651:	3c 73                	cmp    $0x73,%al
     653:	0f 85 05 01 00 00    	jne    75e <main+0x464>
     659:	0f b6 05 49 23 00 00 	movzbl 0x2349,%eax
     660:	3c 20                	cmp    $0x20,%al
     662:	0f 85 f6 00 00 00    	jne    75e <main+0x464>
     668:	0f b6 05 4a 23 00 00 	movzbl 0x234a,%eax
     66f:	3c 2d                	cmp    $0x2d,%al
     671:	0f 85 e7 00 00 00    	jne    75e <main+0x464>
     677:	0f b6 05 4b 23 00 00 	movzbl 0x234b,%eax
     67e:	3c 65                	cmp    $0x65,%al
     680:	0f 85 d8 00 00 00    	jne    75e <main+0x464>
     686:	0f b6 05 4c 23 00 00 	movzbl 0x234c,%eax
     68d:	3c 20                	cmp    $0x20,%al
     68f:	0f 85 c9 00 00 00    	jne    75e <main+0x464>
        char flagcommand[20];
        for(int i = 0; i < 20; i++)
     695:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
     69c:	eb 0f                	jmp    6ad <main+0x3b3>
            flagcommand[i] = '\0';
     69e:	8d 55 94             	lea    -0x6c(%ebp),%edx
     6a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
     6a4:	01 d0                	add    %edx,%eax
     6a6:	c6 00 00             	movb   $0x0,(%eax)
        for(int i = 0; i < 20; i++)
     6a9:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
     6ad:	83 7d dc 13          	cmpl   $0x13,-0x24(%ebp)
     6b1:	7e eb                	jle    69e <main+0x3a4>
        for(int i = 13; i < strlen(buf)-1; i++)
     6b3:	c7 45 d8 0d 00 00 00 	movl   $0xd,-0x28(%ebp)
     6ba:	eb 19                	jmp    6d5 <main+0x3db>
            flagcommand[i-13] = buf[i];
     6bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
     6bf:	8d 50 f3             	lea    -0xd(%eax),%edx
     6c2:	8b 45 d8             	mov    -0x28(%ebp),%eax
     6c5:	05 40 23 00 00       	add    $0x2340,%eax
     6ca:	0f b6 00             	movzbl (%eax),%eax
     6cd:	88 44 15 94          	mov    %al,-0x6c(%ebp,%edx,1)
        for(int i = 13; i < strlen(buf)-1; i++)
     6d1:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
     6d5:	83 ec 0c             	sub    $0xc,%esp
     6d8:	68 40 23 00 00       	push   $0x2340
     6dd:	e8 23 0e 00 00       	call   1505 <strlen>
     6e2:	83 c4 10             	add    $0x10,%esp
     6e5:	8d 50 ff             	lea    -0x1(%eax),%edx
     6e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
     6eb:	39 c2                	cmp    %eax,%edx
     6ed:	77 cd                	ja     6bc <main+0x3c2>
        int arrloc = -1;
     6ef:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
        for(int i = 0; i<22; i++) {
     6f6:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
     6fd:	eb 28                	jmp    727 <main+0x42d>
            if(strcmp(flagcommand, syscallNames[i]) == 0) {
     6ff:	8b 45 d0             	mov    -0x30(%ebp),%eax
     702:	8b 04 85 60 22 00 00 	mov    0x2260(,%eax,4),%eax
     709:	83 ec 08             	sub    $0x8,%esp
     70c:	50                   	push   %eax
     70d:	8d 45 94             	lea    -0x6c(%ebp),%eax
     710:	50                   	push   %eax
     711:	e8 ac 0d 00 00       	call   14c2 <strcmp>
     716:	83 c4 10             	add    $0x10,%esp
     719:	85 c0                	test   %eax,%eax
     71b:	75 06                	jne    723 <main+0x429>
                arrloc = i;
     71d:	8b 45 d0             	mov    -0x30(%ebp),%eax
     720:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        for(int i = 0; i<22; i++) {
     723:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
     727:	83 7d d0 15          	cmpl   $0x15,-0x30(%ebp)
     72b:	7e d2                	jle    6ff <main+0x405>
            }
        }

        tracing = 1;
     72d:	c7 05 20 23 00 00 01 	movl   $0x1,0x2320
     734:	00 00 00 
        straceFlagCalled = 1;
     737:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
        setSFlag(1);
     73e:	83 ec 0c             	sub    $0xc,%esp
     741:	6a 01                	push   $0x1
     743:	e8 4b 10 00 00       	call   1793 <setSFlag>
     748:	83 c4 10             	add    $0x10,%esp
        setEFlag(arrloc);
     74b:	83 ec 0c             	sub    $0xc,%esp
     74e:	ff 75 d4             	pushl  -0x2c(%ebp)
     751:	e8 35 10 00 00       	call   178b <setEFlag>
     756:	83 c4 10             	add    $0x10,%esp
     759:	e9 c5 03 00 00       	jmp    b23 <main+0x829>
        continue;
    }
    else if(buf[0] == 's' && buf[1] == 't' && buf[2] == 'r' && buf[3] == 'a' && buf[4] == 'c' && buf[5] == 'e' && buf[6] == ' ' && buf[7] == '-' && buf[8] == 'f' && buf[9] == ' ' && buf[10] == '-' && buf[11] == 'e' && buf[12] == ' ') {
     75e:	0f b6 05 40 23 00 00 	movzbl 0x2340,%eax
     765:	3c 73                	cmp    $0x73,%al
     767:	0f 85 7d 01 00 00    	jne    8ea <main+0x5f0>
     76d:	0f b6 05 41 23 00 00 	movzbl 0x2341,%eax
     774:	3c 74                	cmp    $0x74,%al
     776:	0f 85 6e 01 00 00    	jne    8ea <main+0x5f0>
     77c:	0f b6 05 42 23 00 00 	movzbl 0x2342,%eax
     783:	3c 72                	cmp    $0x72,%al
     785:	0f 85 5f 01 00 00    	jne    8ea <main+0x5f0>
     78b:	0f b6 05 43 23 00 00 	movzbl 0x2343,%eax
     792:	3c 61                	cmp    $0x61,%al
     794:	0f 85 50 01 00 00    	jne    8ea <main+0x5f0>
     79a:	0f b6 05 44 23 00 00 	movzbl 0x2344,%eax
     7a1:	3c 63                	cmp    $0x63,%al
     7a3:	0f 85 41 01 00 00    	jne    8ea <main+0x5f0>
     7a9:	0f b6 05 45 23 00 00 	movzbl 0x2345,%eax
     7b0:	3c 65                	cmp    $0x65,%al
     7b2:	0f 85 32 01 00 00    	jne    8ea <main+0x5f0>
     7b8:	0f b6 05 46 23 00 00 	movzbl 0x2346,%eax
     7bf:	3c 20                	cmp    $0x20,%al
     7c1:	0f 85 23 01 00 00    	jne    8ea <main+0x5f0>
     7c7:	0f b6 05 47 23 00 00 	movzbl 0x2347,%eax
     7ce:	3c 2d                	cmp    $0x2d,%al
     7d0:	0f 85 14 01 00 00    	jne    8ea <main+0x5f0>
     7d6:	0f b6 05 48 23 00 00 	movzbl 0x2348,%eax
     7dd:	3c 66                	cmp    $0x66,%al
     7df:	0f 85 05 01 00 00    	jne    8ea <main+0x5f0>
     7e5:	0f b6 05 49 23 00 00 	movzbl 0x2349,%eax
     7ec:	3c 20                	cmp    $0x20,%al
     7ee:	0f 85 f6 00 00 00    	jne    8ea <main+0x5f0>
     7f4:	0f b6 05 4a 23 00 00 	movzbl 0x234a,%eax
     7fb:	3c 2d                	cmp    $0x2d,%al
     7fd:	0f 85 e7 00 00 00    	jne    8ea <main+0x5f0>
     803:	0f b6 05 4b 23 00 00 	movzbl 0x234b,%eax
     80a:	3c 65                	cmp    $0x65,%al
     80c:	0f 85 d8 00 00 00    	jne    8ea <main+0x5f0>
     812:	0f b6 05 4c 23 00 00 	movzbl 0x234c,%eax
     819:	3c 20                	cmp    $0x20,%al
     81b:	0f 85 c9 00 00 00    	jne    8ea <main+0x5f0>
        char flagcommand[20];
        for(int i = 0; i < 20; i++)
     821:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
     828:	eb 0f                	jmp    839 <main+0x53f>
            flagcommand[i] = '\0';
     82a:	8d 55 80             	lea    -0x80(%ebp),%edx
     82d:	8b 45 cc             	mov    -0x34(%ebp),%eax
     830:	01 d0                	add    %edx,%eax
     832:	c6 00 00             	movb   $0x0,(%eax)
        for(int i = 0; i < 20; i++)
     835:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
     839:	83 7d cc 13          	cmpl   $0x13,-0x34(%ebp)
     83d:	7e eb                	jle    82a <main+0x530>
        for(int i = 13; i < strlen(buf)-1; i++)
     83f:	c7 45 c8 0d 00 00 00 	movl   $0xd,-0x38(%ebp)
     846:	eb 19                	jmp    861 <main+0x567>
            flagcommand[i-13] = buf[i];
     848:	8b 45 c8             	mov    -0x38(%ebp),%eax
     84b:	8d 50 f3             	lea    -0xd(%eax),%edx
     84e:	8b 45 c8             	mov    -0x38(%ebp),%eax
     851:	05 40 23 00 00       	add    $0x2340,%eax
     856:	0f b6 00             	movzbl (%eax),%eax
     859:	88 44 15 80          	mov    %al,-0x80(%ebp,%edx,1)
        for(int i = 13; i < strlen(buf)-1; i++)
     85d:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
     861:	83 ec 0c             	sub    $0xc,%esp
     864:	68 40 23 00 00       	push   $0x2340
     869:	e8 97 0c 00 00       	call   1505 <strlen>
     86e:	83 c4 10             	add    $0x10,%esp
     871:	8d 50 ff             	lea    -0x1(%eax),%edx
     874:	8b 45 c8             	mov    -0x38(%ebp),%eax
     877:	39 c2                	cmp    %eax,%edx
     879:	77 cd                	ja     848 <main+0x54e>
        int arrloc = -1;
     87b:	c7 45 c4 ff ff ff ff 	movl   $0xffffffff,-0x3c(%ebp)
        for(int i = 0; i<22; i++) {
     882:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
     889:	eb 28                	jmp    8b3 <main+0x5b9>
            if(strcmp(flagcommand, syscallNames[i]) == 0) {
     88b:	8b 45 c0             	mov    -0x40(%ebp),%eax
     88e:	8b 04 85 60 22 00 00 	mov    0x2260(,%eax,4),%eax
     895:	83 ec 08             	sub    $0x8,%esp
     898:	50                   	push   %eax
     899:	8d 45 80             	lea    -0x80(%ebp),%eax
     89c:	50                   	push   %eax
     89d:	e8 20 0c 00 00       	call   14c2 <strcmp>
     8a2:	83 c4 10             	add    $0x10,%esp
     8a5:	85 c0                	test   %eax,%eax
     8a7:	75 06                	jne    8af <main+0x5b5>
                arrloc = i;
     8a9:	8b 45 c0             	mov    -0x40(%ebp),%eax
     8ac:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        for(int i = 0; i<22; i++) {
     8af:	83 45 c0 01          	addl   $0x1,-0x40(%ebp)
     8b3:	83 7d c0 15          	cmpl   $0x15,-0x40(%ebp)
     8b7:	7e d2                	jle    88b <main+0x591>
            }
        }
        
        tracing = 1;
     8b9:	c7 05 20 23 00 00 01 	movl   $0x1,0x2320
     8c0:	00 00 00 
        straceFlagCalled = 1;
     8c3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
        setFFlag(1);
     8ca:	83 ec 0c             	sub    $0xc,%esp
     8cd:	6a 01                	push   $0x1
     8cf:	e8 c7 0e 00 00       	call   179b <setFFlag>
     8d4:	83 c4 10             	add    $0x10,%esp
        setEFlag(arrloc);
     8d7:	83 ec 0c             	sub    $0xc,%esp
     8da:	ff 75 c4             	pushl  -0x3c(%ebp)
     8dd:	e8 a9 0e 00 00       	call   178b <setEFlag>
     8e2:	83 c4 10             	add    $0x10,%esp
     8e5:	e9 39 02 00 00       	jmp    b23 <main+0x829>
        continue;
    }
    else if(buf[0] == 's' && buf[1] == 't' && buf[2] == 'r' && buf[3] == 'a' && buf[4] == 'c' && buf[5] == 'e' && buf[6] == ' ' && buf[7] == '-' && buf[8] == 's') {
     8ea:	0f b6 05 40 23 00 00 	movzbl 0x2340,%eax
     8f1:	3c 73                	cmp    $0x73,%al
     8f3:	75 7b                	jne    970 <main+0x676>
     8f5:	0f b6 05 41 23 00 00 	movzbl 0x2341,%eax
     8fc:	3c 74                	cmp    $0x74,%al
     8fe:	75 70                	jne    970 <main+0x676>
     900:	0f b6 05 42 23 00 00 	movzbl 0x2342,%eax
     907:	3c 72                	cmp    $0x72,%al
     909:	75 65                	jne    970 <main+0x676>
     90b:	0f b6 05 43 23 00 00 	movzbl 0x2343,%eax
     912:	3c 61                	cmp    $0x61,%al
     914:	75 5a                	jne    970 <main+0x676>
     916:	0f b6 05 44 23 00 00 	movzbl 0x2344,%eax
     91d:	3c 63                	cmp    $0x63,%al
     91f:	75 4f                	jne    970 <main+0x676>
     921:	0f b6 05 45 23 00 00 	movzbl 0x2345,%eax
     928:	3c 65                	cmp    $0x65,%al
     92a:	75 44                	jne    970 <main+0x676>
     92c:	0f b6 05 46 23 00 00 	movzbl 0x2346,%eax
     933:	3c 20                	cmp    $0x20,%al
     935:	75 39                	jne    970 <main+0x676>
     937:	0f b6 05 47 23 00 00 	movzbl 0x2347,%eax
     93e:	3c 2d                	cmp    $0x2d,%al
     940:	75 2e                	jne    970 <main+0x676>
     942:	0f b6 05 48 23 00 00 	movzbl 0x2348,%eax
     949:	3c 73                	cmp    $0x73,%al
     94b:	75 23                	jne    970 <main+0x676>
        tracing = 1;
     94d:	c7 05 20 23 00 00 01 	movl   $0x1,0x2320
     954:	00 00 00 
        straceFlagCalled = 1;
     957:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
        setSFlag(1);
     95e:	83 ec 0c             	sub    $0xc,%esp
     961:	6a 01                	push   $0x1
     963:	e8 2b 0e 00 00       	call   1793 <setSFlag>
     968:	83 c4 10             	add    $0x10,%esp
        continue;
     96b:	e9 b3 01 00 00       	jmp    b23 <main+0x829>
    }
    else if(buf[0] == 's' && buf[1] == 't' && buf[2] == 'r' && buf[3] == 'a' && buf[4] == 'c' && buf[5] == 'e' && buf[6] == ' ' && buf[7] == '-' && buf[8] == 'f') {
     970:	0f b6 05 40 23 00 00 	movzbl 0x2340,%eax
     977:	3c 73                	cmp    $0x73,%al
     979:	75 7b                	jne    9f6 <main+0x6fc>
     97b:	0f b6 05 41 23 00 00 	movzbl 0x2341,%eax
     982:	3c 74                	cmp    $0x74,%al
     984:	75 70                	jne    9f6 <main+0x6fc>
     986:	0f b6 05 42 23 00 00 	movzbl 0x2342,%eax
     98d:	3c 72                	cmp    $0x72,%al
     98f:	75 65                	jne    9f6 <main+0x6fc>
     991:	0f b6 05 43 23 00 00 	movzbl 0x2343,%eax
     998:	3c 61                	cmp    $0x61,%al
     99a:	75 5a                	jne    9f6 <main+0x6fc>
     99c:	0f b6 05 44 23 00 00 	movzbl 0x2344,%eax
     9a3:	3c 63                	cmp    $0x63,%al
     9a5:	75 4f                	jne    9f6 <main+0x6fc>
     9a7:	0f b6 05 45 23 00 00 	movzbl 0x2345,%eax
     9ae:	3c 65                	cmp    $0x65,%al
     9b0:	75 44                	jne    9f6 <main+0x6fc>
     9b2:	0f b6 05 46 23 00 00 	movzbl 0x2346,%eax
     9b9:	3c 20                	cmp    $0x20,%al
     9bb:	75 39                	jne    9f6 <main+0x6fc>
     9bd:	0f b6 05 47 23 00 00 	movzbl 0x2347,%eax
     9c4:	3c 2d                	cmp    $0x2d,%al
     9c6:	75 2e                	jne    9f6 <main+0x6fc>
     9c8:	0f b6 05 48 23 00 00 	movzbl 0x2348,%eax
     9cf:	3c 66                	cmp    $0x66,%al
     9d1:	75 23                	jne    9f6 <main+0x6fc>
        tracing = 1;
     9d3:	c7 05 20 23 00 00 01 	movl   $0x1,0x2320
     9da:	00 00 00 
        straceFlagCalled = 1;
     9dd:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
        setFFlag(1);
     9e4:	83 ec 0c             	sub    $0xc,%esp
     9e7:	6a 01                	push   $0x1
     9e9:	e8 ad 0d 00 00       	call   179b <setFFlag>
     9ee:	83 c4 10             	add    $0x10,%esp
        continue;
     9f1:	e9 2d 01 00 00       	jmp    b23 <main+0x829>
    }
    else if(straceRunCalled == 1 || (buf[0] == 's' && buf[1] == 't' && buf[2] == 'r' && buf[3] == 'a' && buf[4] == 'c' && buf[5] == 'e' && buf[6] == ' ' && buf[7] == 'r' && buf[8] == 'u' && buf[9] == 'n' && buf[10] == ' ')) {
     9f6:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
     9fa:	0f 84 89 00 00 00    	je     a89 <main+0x78f>
     a00:	0f b6 05 40 23 00 00 	movzbl 0x2340,%eax
     a07:	3c 73                	cmp    $0x73,%al
     a09:	0f 85 b6 00 00 00    	jne    ac5 <main+0x7cb>
     a0f:	0f b6 05 41 23 00 00 	movzbl 0x2341,%eax
     a16:	3c 74                	cmp    $0x74,%al
     a18:	0f 85 a7 00 00 00    	jne    ac5 <main+0x7cb>
     a1e:	0f b6 05 42 23 00 00 	movzbl 0x2342,%eax
     a25:	3c 72                	cmp    $0x72,%al
     a27:	0f 85 98 00 00 00    	jne    ac5 <main+0x7cb>
     a2d:	0f b6 05 43 23 00 00 	movzbl 0x2343,%eax
     a34:	3c 61                	cmp    $0x61,%al
     a36:	0f 85 89 00 00 00    	jne    ac5 <main+0x7cb>
     a3c:	0f b6 05 44 23 00 00 	movzbl 0x2344,%eax
     a43:	3c 63                	cmp    $0x63,%al
     a45:	75 7e                	jne    ac5 <main+0x7cb>
     a47:	0f b6 05 45 23 00 00 	movzbl 0x2345,%eax
     a4e:	3c 65                	cmp    $0x65,%al
     a50:	75 73                	jne    ac5 <main+0x7cb>
     a52:	0f b6 05 46 23 00 00 	movzbl 0x2346,%eax
     a59:	3c 20                	cmp    $0x20,%al
     a5b:	75 68                	jne    ac5 <main+0x7cb>
     a5d:	0f b6 05 47 23 00 00 	movzbl 0x2347,%eax
     a64:	3c 72                	cmp    $0x72,%al
     a66:	75 5d                	jne    ac5 <main+0x7cb>
     a68:	0f b6 05 48 23 00 00 	movzbl 0x2348,%eax
     a6f:	3c 75                	cmp    $0x75,%al
     a71:	75 52                	jne    ac5 <main+0x7cb>
     a73:	0f b6 05 49 23 00 00 	movzbl 0x2349,%eax
     a7a:	3c 6e                	cmp    $0x6e,%al
     a7c:	75 47                	jne    ac5 <main+0x7cb>
     a7e:	0f b6 05 4a 23 00 00 	movzbl 0x234a,%eax
     a85:	3c 20                	cmp    $0x20,%al
     a87:	75 3c                	jne    ac5 <main+0x7cb>
        tracing = 1;
     a89:	c7 05 20 23 00 00 01 	movl   $0x1,0x2320
     a90:	00 00 00 
        straceRunCalled = 1;
     a93:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        
        if(fork1() == 0)
     a9a:	e8 c7 00 00 00       	call   b66 <fork1>
     a9f:	85 c0                	test   %eax,%eax
     aa1:	75 1d                	jne    ac0 <main+0x7c6>
            runcmd(parsecmd(buf+11));
     aa3:	b8 4b 23 00 00       	mov    $0x234b,%eax
     aa8:	83 ec 0c             	sub    $0xc,%esp
     aab:	50                   	push   %eax
     aac:	e8 2c 04 00 00       	call   edd <parsecmd>
     ab1:	83 c4 10             	add    $0x10,%esp
     ab4:	83 ec 0c             	sub    $0xc,%esp
     ab7:	50                   	push   %eax
     ab8:	e8 7e f5 ff ff       	call   3b <runcmd>
     abd:	83 c4 10             	add    $0x10,%esp
        wait();
     ac0:	e8 26 0c 00 00       	call   16eb <wait>
    }
    if(straceRunCalled == 0 && fork1() == 0) 
     ac5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     ac9:	75 25                	jne    af0 <main+0x7f6>
     acb:	e8 96 00 00 00       	call   b66 <fork1>
     ad0:	85 c0                	test   %eax,%eax
     ad2:	75 1c                	jne    af0 <main+0x7f6>
        runcmd(parsecmd(buf));
     ad4:	83 ec 0c             	sub    $0xc,%esp
     ad7:	68 40 23 00 00       	push   $0x2340
     adc:	e8 fc 03 00 00       	call   edd <parsecmd>
     ae1:	83 c4 10             	add    $0x10,%esp
     ae4:	83 ec 0c             	sub    $0xc,%esp
     ae7:	50                   	push   %eax
     ae8:	e8 4e f5 ff ff       	call   3b <runcmd>
     aed:	83 c4 10             	add    $0x10,%esp
    wait();
     af0:	e8 f6 0b 00 00       	call   16eb <wait>

    if(straceFlagCalled == 1)
     af5:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
     af9:	75 0a                	jne    b05 <main+0x80b>
        tracing = 0;
     afb:	c7 05 20 23 00 00 00 	movl   $0x0,0x2320
     b02:	00 00 00 
    straceFlagCalled = 0;
     b05:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    if(straceRunCalled == 1)
     b0c:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
     b10:	75 0a                	jne    b1c <main+0x822>
        tracing = 0;
     b12:	c7 05 20 23 00 00 00 	movl   $0x0,0x2320
     b19:	00 00 00 
    straceRunCalled = 0;
     b1c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while (getcmd(buf, sizeof(buf)) >= 0) {
     b23:	83 ec 08             	sub    $0x8,%esp
     b26:	6a 64                	push   $0x64
     b28:	68 40 23 00 00       	push   $0x2340
     b2d:	e8 6f f7 ff ff       	call   2a1 <getcmd>
     b32:	83 c4 10             	add    $0x10,%esp
     b35:	85 c0                	test   %eax,%eax
     b37:	0f 89 1b f8 ff ff    	jns    358 <main+0x5e>
  }
  exit();
     b3d:	e8 a1 0b 00 00       	call   16e3 <exit>

00000b42 <panic>:
}

void panic(char *s) {
     b42:	f3 0f 1e fb          	endbr32 
     b46:	55                   	push   %ebp
     b47:	89 e5                	mov    %esp,%ebp
     b49:	83 ec 08             	sub    $0x8,%esp
  printf(2, "%s\n", s);
     b4c:	83 ec 04             	sub    $0x4,%esp
     b4f:	ff 75 08             	pushl  0x8(%ebp)
     b52:	68 25 1d 00 00       	push   $0x1d25
     b57:	6a 02                	push   $0x2
     b59:	e8 29 0d 00 00       	call   1887 <printf>
     b5e:	83 c4 10             	add    $0x10,%esp
  exit();
     b61:	e8 7d 0b 00 00       	call   16e3 <exit>

00000b66 <fork1>:
}

int fork1(void) {
     b66:	f3 0f 1e fb          	endbr32 
     b6a:	55                   	push   %ebp
     b6b:	89 e5                	mov    %esp,%ebp
     b6d:	83 ec 18             	sub    $0x18,%esp
  int pid;

  pid = fork();
     b70:	e8 66 0b 00 00       	call   16db <fork>
     b75:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (pid == -1)
     b78:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     b7c:	75 10                	jne    b8e <fork1+0x28>
    panic("fork");
     b7e:	83 ec 0c             	sub    $0xc,%esp
     b81:	68 50 1c 00 00       	push   $0x1c50
     b86:	e8 b7 ff ff ff       	call   b42 <panic>
     b8b:	83 c4 10             	add    $0x10,%esp
  return pid;
     b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     b91:	c9                   	leave  
     b92:	c3                   	ret    

00000b93 <execcmd>:

// PAGEBREAK!
// Constructors

struct cmd *execcmd(void) {
     b93:	f3 0f 1e fb          	endbr32 
     b97:	55                   	push   %ebp
     b98:	89 e5                	mov    %esp,%ebp
     b9a:	83 ec 18             	sub    $0x18,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     b9d:	83 ec 0c             	sub    $0xc,%esp
     ba0:	6a 54                	push   $0x54
     ba2:	e8 c0 0f 00 00       	call   1b67 <malloc>
     ba7:	83 c4 10             	add    $0x10,%esp
     baa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     bad:	83 ec 04             	sub    $0x4,%esp
     bb0:	6a 54                	push   $0x54
     bb2:	6a 00                	push   $0x0
     bb4:	ff 75 f4             	pushl  -0xc(%ebp)
     bb7:	e8 74 09 00 00       	call   1530 <memset>
     bbc:	83 c4 10             	add    $0x10,%esp
  cmd->type = EXEC;
     bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     bc2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  return (struct cmd *)cmd;
     bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     bcb:	c9                   	leave  
     bcc:	c3                   	ret    

00000bcd <redircmd>:

struct cmd *redircmd(struct cmd *subcmd, char *file, char *efile, int mode,
                     int fd) {
     bcd:	f3 0f 1e fb          	endbr32 
     bd1:	55                   	push   %ebp
     bd2:	89 e5                	mov    %esp,%ebp
     bd4:	83 ec 18             	sub    $0x18,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     bd7:	83 ec 0c             	sub    $0xc,%esp
     bda:	6a 18                	push   $0x18
     bdc:	e8 86 0f 00 00       	call   1b67 <malloc>
     be1:	83 c4 10             	add    $0x10,%esp
     be4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     be7:	83 ec 04             	sub    $0x4,%esp
     bea:	6a 18                	push   $0x18
     bec:	6a 00                	push   $0x0
     bee:	ff 75 f4             	pushl  -0xc(%ebp)
     bf1:	e8 3a 09 00 00       	call   1530 <memset>
     bf6:	83 c4 10             	add    $0x10,%esp
  cmd->type = REDIR;
     bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     bfc:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  cmd->cmd = subcmd;
     c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c05:	8b 55 08             	mov    0x8(%ebp),%edx
     c08:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->file = file;
     c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c0e:	8b 55 0c             	mov    0xc(%ebp),%edx
     c11:	89 50 08             	mov    %edx,0x8(%eax)
  cmd->efile = efile;
     c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c17:	8b 55 10             	mov    0x10(%ebp),%edx
     c1a:	89 50 0c             	mov    %edx,0xc(%eax)
  cmd->mode = mode;
     c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c20:	8b 55 14             	mov    0x14(%ebp),%edx
     c23:	89 50 10             	mov    %edx,0x10(%eax)
  cmd->fd = fd;
     c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c29:	8b 55 18             	mov    0x18(%ebp),%edx
     c2c:	89 50 14             	mov    %edx,0x14(%eax)
  return (struct cmd *)cmd;
     c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     c32:	c9                   	leave  
     c33:	c3                   	ret    

00000c34 <pipecmd>:

struct cmd *pipecmd(struct cmd *left, struct cmd *right) {
     c34:	f3 0f 1e fb          	endbr32 
     c38:	55                   	push   %ebp
     c39:	89 e5                	mov    %esp,%ebp
     c3b:	83 ec 18             	sub    $0x18,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     c3e:	83 ec 0c             	sub    $0xc,%esp
     c41:	6a 0c                	push   $0xc
     c43:	e8 1f 0f 00 00       	call   1b67 <malloc>
     c48:	83 c4 10             	add    $0x10,%esp
     c4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     c4e:	83 ec 04             	sub    $0x4,%esp
     c51:	6a 0c                	push   $0xc
     c53:	6a 00                	push   $0x0
     c55:	ff 75 f4             	pushl  -0xc(%ebp)
     c58:	e8 d3 08 00 00       	call   1530 <memset>
     c5d:	83 c4 10             	add    $0x10,%esp
  cmd->type = PIPE;
     c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c63:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
  cmd->left = left;
     c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c6c:	8b 55 08             	mov    0x8(%ebp),%edx
     c6f:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c75:	8b 55 0c             	mov    0xc(%ebp),%edx
     c78:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd *)cmd;
     c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     c7e:	c9                   	leave  
     c7f:	c3                   	ret    

00000c80 <listcmd>:

struct cmd *listcmd(struct cmd *left, struct cmd *right) {
     c80:	f3 0f 1e fb          	endbr32 
     c84:	55                   	push   %ebp
     c85:	89 e5                	mov    %esp,%ebp
     c87:	83 ec 18             	sub    $0x18,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     c8a:	83 ec 0c             	sub    $0xc,%esp
     c8d:	6a 0c                	push   $0xc
     c8f:	e8 d3 0e 00 00       	call   1b67 <malloc>
     c94:	83 c4 10             	add    $0x10,%esp
     c97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     c9a:	83 ec 04             	sub    $0x4,%esp
     c9d:	6a 0c                	push   $0xc
     c9f:	6a 00                	push   $0x0
     ca1:	ff 75 f4             	pushl  -0xc(%ebp)
     ca4:	e8 87 08 00 00       	call   1530 <memset>
     ca9:	83 c4 10             	add    $0x10,%esp
  cmd->type = LIST;
     cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
     caf:	c7 00 04 00 00 00    	movl   $0x4,(%eax)
  cmd->left = left;
     cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cb8:	8b 55 08             	mov    0x8(%ebp),%edx
     cbb:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cc1:	8b 55 0c             	mov    0xc(%ebp),%edx
     cc4:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd *)cmd;
     cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     cca:	c9                   	leave  
     ccb:	c3                   	ret    

00000ccc <backcmd>:

struct cmd *backcmd(struct cmd *subcmd) {
     ccc:	f3 0f 1e fb          	endbr32 
     cd0:	55                   	push   %ebp
     cd1:	89 e5                	mov    %esp,%ebp
     cd3:	83 ec 18             	sub    $0x18,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     cd6:	83 ec 0c             	sub    $0xc,%esp
     cd9:	6a 08                	push   $0x8
     cdb:	e8 87 0e 00 00       	call   1b67 <malloc>
     ce0:	83 c4 10             	add    $0x10,%esp
     ce3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     ce6:	83 ec 04             	sub    $0x4,%esp
     ce9:	6a 08                	push   $0x8
     ceb:	6a 00                	push   $0x0
     ced:	ff 75 f4             	pushl  -0xc(%ebp)
     cf0:	e8 3b 08 00 00       	call   1530 <memset>
     cf5:	83 c4 10             	add    $0x10,%esp
  cmd->type = BACK;
     cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cfb:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
  cmd->cmd = subcmd;
     d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d04:	8b 55 08             	mov    0x8(%ebp),%edx
     d07:	89 50 04             	mov    %edx,0x4(%eax)
  return (struct cmd *)cmd;
     d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     d0d:	c9                   	leave  
     d0e:	c3                   	ret    

00000d0f <gettoken>:
// Parsing

char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int gettoken(char **ps, char *es, char **q, char **eq) {
     d0f:	f3 0f 1e fb          	endbr32 
     d13:	55                   	push   %ebp
     d14:	89 e5                	mov    %esp,%ebp
     d16:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int ret;

  s = *ps;
     d19:	8b 45 08             	mov    0x8(%ebp),%eax
     d1c:	8b 00                	mov    (%eax),%eax
     d1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (s < es && strchr(whitespace, *s))
     d21:	eb 04                	jmp    d27 <gettoken+0x18>
    s++;
     d23:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  while (s < es && strchr(whitespace, *s))
     d27:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d2a:	3b 45 0c             	cmp    0xc(%ebp),%eax
     d2d:	73 1e                	jae    d4d <gettoken+0x3e>
     d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d32:	0f b6 00             	movzbl (%eax),%eax
     d35:	0f be c0             	movsbl %al,%eax
     d38:	83 ec 08             	sub    $0x8,%esp
     d3b:	50                   	push   %eax
     d3c:	68 e0 22 00 00       	push   $0x22e0
     d41:	e8 08 08 00 00       	call   154e <strchr>
     d46:	83 c4 10             	add    $0x10,%esp
     d49:	85 c0                	test   %eax,%eax
     d4b:	75 d6                	jne    d23 <gettoken+0x14>
  if (q)
     d4d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     d51:	74 08                	je     d5b <gettoken+0x4c>
    *q = s;
     d53:	8b 45 10             	mov    0x10(%ebp),%eax
     d56:	8b 55 f4             	mov    -0xc(%ebp),%edx
     d59:	89 10                	mov    %edx,(%eax)
  ret = *s;
     d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d5e:	0f b6 00             	movzbl (%eax),%eax
     d61:	0f be c0             	movsbl %al,%eax
     d64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  switch (*s) {
     d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d6a:	0f b6 00             	movzbl (%eax),%eax
     d6d:	0f be c0             	movsbl %al,%eax
     d70:	83 f8 7c             	cmp    $0x7c,%eax
     d73:	74 2c                	je     da1 <gettoken+0x92>
     d75:	83 f8 7c             	cmp    $0x7c,%eax
     d78:	7f 48                	jg     dc2 <gettoken+0xb3>
     d7a:	83 f8 3e             	cmp    $0x3e,%eax
     d7d:	74 28                	je     da7 <gettoken+0x98>
     d7f:	83 f8 3e             	cmp    $0x3e,%eax
     d82:	7f 3e                	jg     dc2 <gettoken+0xb3>
     d84:	83 f8 3c             	cmp    $0x3c,%eax
     d87:	7f 39                	jg     dc2 <gettoken+0xb3>
     d89:	83 f8 3b             	cmp    $0x3b,%eax
     d8c:	7d 13                	jge    da1 <gettoken+0x92>
     d8e:	83 f8 29             	cmp    $0x29,%eax
     d91:	7f 2f                	jg     dc2 <gettoken+0xb3>
     d93:	83 f8 28             	cmp    $0x28,%eax
     d96:	7d 09                	jge    da1 <gettoken+0x92>
     d98:	85 c0                	test   %eax,%eax
     d9a:	74 79                	je     e15 <gettoken+0x106>
     d9c:	83 f8 26             	cmp    $0x26,%eax
     d9f:	75 21                	jne    dc2 <gettoken+0xb3>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     da1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
     da5:	eb 75                	jmp    e1c <gettoken+0x10d>
  case '>':
    s++;
     da7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if (*s == '>') {
     dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
     dae:	0f b6 00             	movzbl (%eax),%eax
     db1:	3c 3e                	cmp    $0x3e,%al
     db3:	75 63                	jne    e18 <gettoken+0x109>
      ret = '+';
     db5:	c7 45 f0 2b 00 00 00 	movl   $0x2b,-0x10(%ebp)
      s++;
     dbc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    }
    break;
     dc0:	eb 56                	jmp    e18 <gettoken+0x109>
  default:
    ret = 'a';
     dc2:	c7 45 f0 61 00 00 00 	movl   $0x61,-0x10(%ebp)
    while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     dc9:	eb 04                	jmp    dcf <gettoken+0xc0>
      s++;
     dcb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     dd2:	3b 45 0c             	cmp    0xc(%ebp),%eax
     dd5:	73 44                	jae    e1b <gettoken+0x10c>
     dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     dda:	0f b6 00             	movzbl (%eax),%eax
     ddd:	0f be c0             	movsbl %al,%eax
     de0:	83 ec 08             	sub    $0x8,%esp
     de3:	50                   	push   %eax
     de4:	68 e0 22 00 00       	push   $0x22e0
     de9:	e8 60 07 00 00       	call   154e <strchr>
     dee:	83 c4 10             	add    $0x10,%esp
     df1:	85 c0                	test   %eax,%eax
     df3:	75 26                	jne    e1b <gettoken+0x10c>
     df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     df8:	0f b6 00             	movzbl (%eax),%eax
     dfb:	0f be c0             	movsbl %al,%eax
     dfe:	83 ec 08             	sub    $0x8,%esp
     e01:	50                   	push   %eax
     e02:	68 e8 22 00 00       	push   $0x22e8
     e07:	e8 42 07 00 00       	call   154e <strchr>
     e0c:	83 c4 10             	add    $0x10,%esp
     e0f:	85 c0                	test   %eax,%eax
     e11:	74 b8                	je     dcb <gettoken+0xbc>
    break;
     e13:	eb 06                	jmp    e1b <gettoken+0x10c>
    break;
     e15:	90                   	nop
     e16:	eb 04                	jmp    e1c <gettoken+0x10d>
    break;
     e18:	90                   	nop
     e19:	eb 01                	jmp    e1c <gettoken+0x10d>
    break;
     e1b:	90                   	nop
  }
  if (eq)
     e1c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     e20:	74 0e                	je     e30 <gettoken+0x121>
    *eq = s;
     e22:	8b 45 14             	mov    0x14(%ebp),%eax
     e25:	8b 55 f4             	mov    -0xc(%ebp),%edx
     e28:	89 10                	mov    %edx,(%eax)

  while (s < es && strchr(whitespace, *s))
     e2a:	eb 04                	jmp    e30 <gettoken+0x121>
    s++;
     e2c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  while (s < es && strchr(whitespace, *s))
     e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e33:	3b 45 0c             	cmp    0xc(%ebp),%eax
     e36:	73 1e                	jae    e56 <gettoken+0x147>
     e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e3b:	0f b6 00             	movzbl (%eax),%eax
     e3e:	0f be c0             	movsbl %al,%eax
     e41:	83 ec 08             	sub    $0x8,%esp
     e44:	50                   	push   %eax
     e45:	68 e0 22 00 00       	push   $0x22e0
     e4a:	e8 ff 06 00 00       	call   154e <strchr>
     e4f:	83 c4 10             	add    $0x10,%esp
     e52:	85 c0                	test   %eax,%eax
     e54:	75 d6                	jne    e2c <gettoken+0x11d>
  *ps = s;
     e56:	8b 45 08             	mov    0x8(%ebp),%eax
     e59:	8b 55 f4             	mov    -0xc(%ebp),%edx
     e5c:	89 10                	mov    %edx,(%eax)
  return ret;
     e5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     e61:	c9                   	leave  
     e62:	c3                   	ret    

00000e63 <peek>:

int peek(char **ps, char *es, char *toks) {
     e63:	f3 0f 1e fb          	endbr32 
     e67:	55                   	push   %ebp
     e68:	89 e5                	mov    %esp,%ebp
     e6a:	83 ec 18             	sub    $0x18,%esp
  char *s;

  s = *ps;
     e6d:	8b 45 08             	mov    0x8(%ebp),%eax
     e70:	8b 00                	mov    (%eax),%eax
     e72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (s < es && strchr(whitespace, *s))
     e75:	eb 04                	jmp    e7b <peek+0x18>
    s++;
     e77:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  while (s < es && strchr(whitespace, *s))
     e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e7e:	3b 45 0c             	cmp    0xc(%ebp),%eax
     e81:	73 1e                	jae    ea1 <peek+0x3e>
     e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e86:	0f b6 00             	movzbl (%eax),%eax
     e89:	0f be c0             	movsbl %al,%eax
     e8c:	83 ec 08             	sub    $0x8,%esp
     e8f:	50                   	push   %eax
     e90:	68 e0 22 00 00       	push   $0x22e0
     e95:	e8 b4 06 00 00       	call   154e <strchr>
     e9a:	83 c4 10             	add    $0x10,%esp
     e9d:	85 c0                	test   %eax,%eax
     e9f:	75 d6                	jne    e77 <peek+0x14>
  *ps = s;
     ea1:	8b 45 08             	mov    0x8(%ebp),%eax
     ea4:	8b 55 f4             	mov    -0xc(%ebp),%edx
     ea7:	89 10                	mov    %edx,(%eax)
  return *s && strchr(toks, *s);
     ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     eac:	0f b6 00             	movzbl (%eax),%eax
     eaf:	84 c0                	test   %al,%al
     eb1:	74 23                	je     ed6 <peek+0x73>
     eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     eb6:	0f b6 00             	movzbl (%eax),%eax
     eb9:	0f be c0             	movsbl %al,%eax
     ebc:	83 ec 08             	sub    $0x8,%esp
     ebf:	50                   	push   %eax
     ec0:	ff 75 10             	pushl  0x10(%ebp)
     ec3:	e8 86 06 00 00       	call   154e <strchr>
     ec8:	83 c4 10             	add    $0x10,%esp
     ecb:	85 c0                	test   %eax,%eax
     ecd:	74 07                	je     ed6 <peek+0x73>
     ecf:	b8 01 00 00 00       	mov    $0x1,%eax
     ed4:	eb 05                	jmp    edb <peek+0x78>
     ed6:	b8 00 00 00 00       	mov    $0x0,%eax
}
     edb:	c9                   	leave  
     edc:	c3                   	ret    

00000edd <parsecmd>:
struct cmd *parseline(char **, char *);
struct cmd *parsepipe(char **, char *);
struct cmd *parseexec(char **, char *);
struct cmd *nulterminate(struct cmd *);

struct cmd *parsecmd(char *s) {
     edd:	f3 0f 1e fb          	endbr32 
     ee1:	55                   	push   %ebp
     ee2:	89 e5                	mov    %esp,%ebp
     ee4:	53                   	push   %ebx
     ee5:	83 ec 14             	sub    $0x14,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     ee8:	8b 5d 08             	mov    0x8(%ebp),%ebx
     eeb:	8b 45 08             	mov    0x8(%ebp),%eax
     eee:	83 ec 0c             	sub    $0xc,%esp
     ef1:	50                   	push   %eax
     ef2:	e8 0e 06 00 00       	call   1505 <strlen>
     ef7:	83 c4 10             	add    $0x10,%esp
     efa:	01 d8                	add    %ebx,%eax
     efc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cmd = parseline(&s, es);
     eff:	83 ec 08             	sub    $0x8,%esp
     f02:	ff 75 f4             	pushl  -0xc(%ebp)
     f05:	8d 45 08             	lea    0x8(%ebp),%eax
     f08:	50                   	push   %eax
     f09:	e8 61 00 00 00       	call   f6f <parseline>
     f0e:	83 c4 10             	add    $0x10,%esp
     f11:	89 45 f0             	mov    %eax,-0x10(%ebp)
  peek(&s, es, "");
     f14:	83 ec 04             	sub    $0x4,%esp
     f17:	68 29 1d 00 00       	push   $0x1d29
     f1c:	ff 75 f4             	pushl  -0xc(%ebp)
     f1f:	8d 45 08             	lea    0x8(%ebp),%eax
     f22:	50                   	push   %eax
     f23:	e8 3b ff ff ff       	call   e63 <peek>
     f28:	83 c4 10             	add    $0x10,%esp
  if (s != es) {
     f2b:	8b 45 08             	mov    0x8(%ebp),%eax
     f2e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     f31:	74 26                	je     f59 <parsecmd+0x7c>
    printf(2, "leftovers: %s\n", s);
     f33:	8b 45 08             	mov    0x8(%ebp),%eax
     f36:	83 ec 04             	sub    $0x4,%esp
     f39:	50                   	push   %eax
     f3a:	68 2a 1d 00 00       	push   $0x1d2a
     f3f:	6a 02                	push   $0x2
     f41:	e8 41 09 00 00       	call   1887 <printf>
     f46:	83 c4 10             	add    $0x10,%esp
    panic("syntax");
     f49:	83 ec 0c             	sub    $0xc,%esp
     f4c:	68 39 1d 00 00       	push   $0x1d39
     f51:	e8 ec fb ff ff       	call   b42 <panic>
     f56:	83 c4 10             	add    $0x10,%esp
  }
  nulterminate(cmd);
     f59:	83 ec 0c             	sub    $0xc,%esp
     f5c:	ff 75 f0             	pushl  -0x10(%ebp)
     f5f:	e8 03 04 00 00       	call   1367 <nulterminate>
     f64:	83 c4 10             	add    $0x10,%esp
  return cmd;
     f67:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     f6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     f6d:	c9                   	leave  
     f6e:	c3                   	ret    

00000f6f <parseline>:

struct cmd *parseline(char **ps, char *es) {
     f6f:	f3 0f 1e fb          	endbr32 
     f73:	55                   	push   %ebp
     f74:	89 e5                	mov    %esp,%ebp
     f76:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     f79:	83 ec 08             	sub    $0x8,%esp
     f7c:	ff 75 0c             	pushl  0xc(%ebp)
     f7f:	ff 75 08             	pushl  0x8(%ebp)
     f82:	e8 99 00 00 00       	call   1020 <parsepipe>
     f87:	83 c4 10             	add    $0x10,%esp
     f8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (peek(ps, es, "&")) {
     f8d:	eb 23                	jmp    fb2 <parseline+0x43>
    gettoken(ps, es, 0, 0);
     f8f:	6a 00                	push   $0x0
     f91:	6a 00                	push   $0x0
     f93:	ff 75 0c             	pushl  0xc(%ebp)
     f96:	ff 75 08             	pushl  0x8(%ebp)
     f99:	e8 71 fd ff ff       	call   d0f <gettoken>
     f9e:	83 c4 10             	add    $0x10,%esp
    cmd = backcmd(cmd);
     fa1:	83 ec 0c             	sub    $0xc,%esp
     fa4:	ff 75 f4             	pushl  -0xc(%ebp)
     fa7:	e8 20 fd ff ff       	call   ccc <backcmd>
     fac:	83 c4 10             	add    $0x10,%esp
     faf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (peek(ps, es, "&")) {
     fb2:	83 ec 04             	sub    $0x4,%esp
     fb5:	68 40 1d 00 00       	push   $0x1d40
     fba:	ff 75 0c             	pushl  0xc(%ebp)
     fbd:	ff 75 08             	pushl  0x8(%ebp)
     fc0:	e8 9e fe ff ff       	call   e63 <peek>
     fc5:	83 c4 10             	add    $0x10,%esp
     fc8:	85 c0                	test   %eax,%eax
     fca:	75 c3                	jne    f8f <parseline+0x20>
  }
  if (peek(ps, es, ";")) {
     fcc:	83 ec 04             	sub    $0x4,%esp
     fcf:	68 42 1d 00 00       	push   $0x1d42
     fd4:	ff 75 0c             	pushl  0xc(%ebp)
     fd7:	ff 75 08             	pushl  0x8(%ebp)
     fda:	e8 84 fe ff ff       	call   e63 <peek>
     fdf:	83 c4 10             	add    $0x10,%esp
     fe2:	85 c0                	test   %eax,%eax
     fe4:	74 35                	je     101b <parseline+0xac>
    gettoken(ps, es, 0, 0);
     fe6:	6a 00                	push   $0x0
     fe8:	6a 00                	push   $0x0
     fea:	ff 75 0c             	pushl  0xc(%ebp)
     fed:	ff 75 08             	pushl  0x8(%ebp)
     ff0:	e8 1a fd ff ff       	call   d0f <gettoken>
     ff5:	83 c4 10             	add    $0x10,%esp
    cmd = listcmd(cmd, parseline(ps, es));
     ff8:	83 ec 08             	sub    $0x8,%esp
     ffb:	ff 75 0c             	pushl  0xc(%ebp)
     ffe:	ff 75 08             	pushl  0x8(%ebp)
    1001:	e8 69 ff ff ff       	call   f6f <parseline>
    1006:	83 c4 10             	add    $0x10,%esp
    1009:	83 ec 08             	sub    $0x8,%esp
    100c:	50                   	push   %eax
    100d:	ff 75 f4             	pushl  -0xc(%ebp)
    1010:	e8 6b fc ff ff       	call   c80 <listcmd>
    1015:	83 c4 10             	add    $0x10,%esp
    1018:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
    101b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    101e:	c9                   	leave  
    101f:	c3                   	ret    

00001020 <parsepipe>:

struct cmd *parsepipe(char **ps, char *es) {
    1020:	f3 0f 1e fb          	endbr32 
    1024:	55                   	push   %ebp
    1025:	89 e5                	mov    %esp,%ebp
    1027:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
    102a:	83 ec 08             	sub    $0x8,%esp
    102d:	ff 75 0c             	pushl  0xc(%ebp)
    1030:	ff 75 08             	pushl  0x8(%ebp)
    1033:	e8 f8 01 00 00       	call   1230 <parseexec>
    1038:	83 c4 10             	add    $0x10,%esp
    103b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (peek(ps, es, "|")) {
    103e:	83 ec 04             	sub    $0x4,%esp
    1041:	68 44 1d 00 00       	push   $0x1d44
    1046:	ff 75 0c             	pushl  0xc(%ebp)
    1049:	ff 75 08             	pushl  0x8(%ebp)
    104c:	e8 12 fe ff ff       	call   e63 <peek>
    1051:	83 c4 10             	add    $0x10,%esp
    1054:	85 c0                	test   %eax,%eax
    1056:	74 35                	je     108d <parsepipe+0x6d>
    gettoken(ps, es, 0, 0);
    1058:	6a 00                	push   $0x0
    105a:	6a 00                	push   $0x0
    105c:	ff 75 0c             	pushl  0xc(%ebp)
    105f:	ff 75 08             	pushl  0x8(%ebp)
    1062:	e8 a8 fc ff ff       	call   d0f <gettoken>
    1067:	83 c4 10             	add    $0x10,%esp
    cmd = pipecmd(cmd, parsepipe(ps, es));
    106a:	83 ec 08             	sub    $0x8,%esp
    106d:	ff 75 0c             	pushl  0xc(%ebp)
    1070:	ff 75 08             	pushl  0x8(%ebp)
    1073:	e8 a8 ff ff ff       	call   1020 <parsepipe>
    1078:	83 c4 10             	add    $0x10,%esp
    107b:	83 ec 08             	sub    $0x8,%esp
    107e:	50                   	push   %eax
    107f:	ff 75 f4             	pushl  -0xc(%ebp)
    1082:	e8 ad fb ff ff       	call   c34 <pipecmd>
    1087:	83 c4 10             	add    $0x10,%esp
    108a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
    108d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    1090:	c9                   	leave  
    1091:	c3                   	ret    

00001092 <parseredirs>:

struct cmd *parseredirs(struct cmd *cmd, char **ps, char *es) {
    1092:	f3 0f 1e fb          	endbr32 
    1096:	55                   	push   %ebp
    1097:	89 e5                	mov    %esp,%ebp
    1099:	83 ec 18             	sub    $0x18,%esp
  int tok;
  char *q, *eq;

  while (peek(ps, es, "<>")) {
    109c:	e9 ba 00 00 00       	jmp    115b <parseredirs+0xc9>
    tok = gettoken(ps, es, 0, 0);
    10a1:	6a 00                	push   $0x0
    10a3:	6a 00                	push   $0x0
    10a5:	ff 75 10             	pushl  0x10(%ebp)
    10a8:	ff 75 0c             	pushl  0xc(%ebp)
    10ab:	e8 5f fc ff ff       	call   d0f <gettoken>
    10b0:	83 c4 10             	add    $0x10,%esp
    10b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (gettoken(ps, es, &q, &eq) != 'a')
    10b6:	8d 45 ec             	lea    -0x14(%ebp),%eax
    10b9:	50                   	push   %eax
    10ba:	8d 45 f0             	lea    -0x10(%ebp),%eax
    10bd:	50                   	push   %eax
    10be:	ff 75 10             	pushl  0x10(%ebp)
    10c1:	ff 75 0c             	pushl  0xc(%ebp)
    10c4:	e8 46 fc ff ff       	call   d0f <gettoken>
    10c9:	83 c4 10             	add    $0x10,%esp
    10cc:	83 f8 61             	cmp    $0x61,%eax
    10cf:	74 10                	je     10e1 <parseredirs+0x4f>
      panic("missing file for redirection");
    10d1:	83 ec 0c             	sub    $0xc,%esp
    10d4:	68 46 1d 00 00       	push   $0x1d46
    10d9:	e8 64 fa ff ff       	call   b42 <panic>
    10de:	83 c4 10             	add    $0x10,%esp
    switch (tok) {
    10e1:	83 7d f4 3e          	cmpl   $0x3e,-0xc(%ebp)
    10e5:	74 31                	je     1118 <parseredirs+0x86>
    10e7:	83 7d f4 3e          	cmpl   $0x3e,-0xc(%ebp)
    10eb:	7f 6e                	jg     115b <parseredirs+0xc9>
    10ed:	83 7d f4 2b          	cmpl   $0x2b,-0xc(%ebp)
    10f1:	74 47                	je     113a <parseredirs+0xa8>
    10f3:	83 7d f4 3c          	cmpl   $0x3c,-0xc(%ebp)
    10f7:	75 62                	jne    115b <parseredirs+0xc9>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
    10f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
    10fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10ff:	83 ec 0c             	sub    $0xc,%esp
    1102:	6a 00                	push   $0x0
    1104:	6a 00                	push   $0x0
    1106:	52                   	push   %edx
    1107:	50                   	push   %eax
    1108:	ff 75 08             	pushl  0x8(%ebp)
    110b:	e8 bd fa ff ff       	call   bcd <redircmd>
    1110:	83 c4 20             	add    $0x20,%esp
    1113:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
    1116:	eb 43                	jmp    115b <parseredirs+0xc9>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE, 1);
    1118:	8b 55 ec             	mov    -0x14(%ebp),%edx
    111b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    111e:	83 ec 0c             	sub    $0xc,%esp
    1121:	6a 01                	push   $0x1
    1123:	68 01 02 00 00       	push   $0x201
    1128:	52                   	push   %edx
    1129:	50                   	push   %eax
    112a:	ff 75 08             	pushl  0x8(%ebp)
    112d:	e8 9b fa ff ff       	call   bcd <redircmd>
    1132:	83 c4 20             	add    $0x20,%esp
    1135:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
    1138:	eb 21                	jmp    115b <parseredirs+0xc9>
    case '+': // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE, 1);
    113a:	8b 55 ec             	mov    -0x14(%ebp),%edx
    113d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1140:	83 ec 0c             	sub    $0xc,%esp
    1143:	6a 01                	push   $0x1
    1145:	68 01 02 00 00       	push   $0x201
    114a:	52                   	push   %edx
    114b:	50                   	push   %eax
    114c:	ff 75 08             	pushl  0x8(%ebp)
    114f:	e8 79 fa ff ff       	call   bcd <redircmd>
    1154:	83 c4 20             	add    $0x20,%esp
    1157:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
    115a:	90                   	nop
  while (peek(ps, es, "<>")) {
    115b:	83 ec 04             	sub    $0x4,%esp
    115e:	68 63 1d 00 00       	push   $0x1d63
    1163:	ff 75 10             	pushl  0x10(%ebp)
    1166:	ff 75 0c             	pushl  0xc(%ebp)
    1169:	e8 f5 fc ff ff       	call   e63 <peek>
    116e:	83 c4 10             	add    $0x10,%esp
    1171:	85 c0                	test   %eax,%eax
    1173:	0f 85 28 ff ff ff    	jne    10a1 <parseredirs+0xf>
    }
  }
  return cmd;
    1179:	8b 45 08             	mov    0x8(%ebp),%eax
}
    117c:	c9                   	leave  
    117d:	c3                   	ret    

0000117e <parseblock>:

struct cmd *parseblock(char **ps, char *es) {
    117e:	f3 0f 1e fb          	endbr32 
    1182:	55                   	push   %ebp
    1183:	89 e5                	mov    %esp,%ebp
    1185:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  if (!peek(ps, es, "("))
    1188:	83 ec 04             	sub    $0x4,%esp
    118b:	68 66 1d 00 00       	push   $0x1d66
    1190:	ff 75 0c             	pushl  0xc(%ebp)
    1193:	ff 75 08             	pushl  0x8(%ebp)
    1196:	e8 c8 fc ff ff       	call   e63 <peek>
    119b:	83 c4 10             	add    $0x10,%esp
    119e:	85 c0                	test   %eax,%eax
    11a0:	75 10                	jne    11b2 <parseblock+0x34>
    panic("parseblock");
    11a2:	83 ec 0c             	sub    $0xc,%esp
    11a5:	68 68 1d 00 00       	push   $0x1d68
    11aa:	e8 93 f9 ff ff       	call   b42 <panic>
    11af:	83 c4 10             	add    $0x10,%esp
  gettoken(ps, es, 0, 0);
    11b2:	6a 00                	push   $0x0
    11b4:	6a 00                	push   $0x0
    11b6:	ff 75 0c             	pushl  0xc(%ebp)
    11b9:	ff 75 08             	pushl  0x8(%ebp)
    11bc:	e8 4e fb ff ff       	call   d0f <gettoken>
    11c1:	83 c4 10             	add    $0x10,%esp
  cmd = parseline(ps, es);
    11c4:	83 ec 08             	sub    $0x8,%esp
    11c7:	ff 75 0c             	pushl  0xc(%ebp)
    11ca:	ff 75 08             	pushl  0x8(%ebp)
    11cd:	e8 9d fd ff ff       	call   f6f <parseline>
    11d2:	83 c4 10             	add    $0x10,%esp
    11d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (!peek(ps, es, ")"))
    11d8:	83 ec 04             	sub    $0x4,%esp
    11db:	68 73 1d 00 00       	push   $0x1d73
    11e0:	ff 75 0c             	pushl  0xc(%ebp)
    11e3:	ff 75 08             	pushl  0x8(%ebp)
    11e6:	e8 78 fc ff ff       	call   e63 <peek>
    11eb:	83 c4 10             	add    $0x10,%esp
    11ee:	85 c0                	test   %eax,%eax
    11f0:	75 10                	jne    1202 <parseblock+0x84>
    panic("syntax - missing )");
    11f2:	83 ec 0c             	sub    $0xc,%esp
    11f5:	68 75 1d 00 00       	push   $0x1d75
    11fa:	e8 43 f9 ff ff       	call   b42 <panic>
    11ff:	83 c4 10             	add    $0x10,%esp
  gettoken(ps, es, 0, 0);
    1202:	6a 00                	push   $0x0
    1204:	6a 00                	push   $0x0
    1206:	ff 75 0c             	pushl  0xc(%ebp)
    1209:	ff 75 08             	pushl  0x8(%ebp)
    120c:	e8 fe fa ff ff       	call   d0f <gettoken>
    1211:	83 c4 10             	add    $0x10,%esp
  cmd = parseredirs(cmd, ps, es);
    1214:	83 ec 04             	sub    $0x4,%esp
    1217:	ff 75 0c             	pushl  0xc(%ebp)
    121a:	ff 75 08             	pushl  0x8(%ebp)
    121d:	ff 75 f4             	pushl  -0xc(%ebp)
    1220:	e8 6d fe ff ff       	call   1092 <parseredirs>
    1225:	83 c4 10             	add    $0x10,%esp
    1228:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return cmd;
    122b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    122e:	c9                   	leave  
    122f:	c3                   	ret    

00001230 <parseexec>:

struct cmd *parseexec(char **ps, char *es) {
    1230:	f3 0f 1e fb          	endbr32 
    1234:	55                   	push   %ebp
    1235:	89 e5                	mov    %esp,%ebp
    1237:	83 ec 28             	sub    $0x28,%esp
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if (peek(ps, es, "("))
    123a:	83 ec 04             	sub    $0x4,%esp
    123d:	68 66 1d 00 00       	push   $0x1d66
    1242:	ff 75 0c             	pushl  0xc(%ebp)
    1245:	ff 75 08             	pushl  0x8(%ebp)
    1248:	e8 16 fc ff ff       	call   e63 <peek>
    124d:	83 c4 10             	add    $0x10,%esp
    1250:	85 c0                	test   %eax,%eax
    1252:	74 16                	je     126a <parseexec+0x3a>
    return parseblock(ps, es);
    1254:	83 ec 08             	sub    $0x8,%esp
    1257:	ff 75 0c             	pushl  0xc(%ebp)
    125a:	ff 75 08             	pushl  0x8(%ebp)
    125d:	e8 1c ff ff ff       	call   117e <parseblock>
    1262:	83 c4 10             	add    $0x10,%esp
    1265:	e9 fb 00 00 00       	jmp    1365 <parseexec+0x135>

  ret = execcmd();
    126a:	e8 24 f9 ff ff       	call   b93 <execcmd>
    126f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  cmd = (struct execcmd *)ret;
    1272:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1275:	89 45 ec             	mov    %eax,-0x14(%ebp)

  argc = 0;
    1278:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  ret = parseredirs(ret, ps, es);
    127f:	83 ec 04             	sub    $0x4,%esp
    1282:	ff 75 0c             	pushl  0xc(%ebp)
    1285:	ff 75 08             	pushl  0x8(%ebp)
    1288:	ff 75 f0             	pushl  -0x10(%ebp)
    128b:	e8 02 fe ff ff       	call   1092 <parseredirs>
    1290:	83 c4 10             	add    $0x10,%esp
    1293:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while (!peek(ps, es, "|)&;")) {
    1296:	e9 87 00 00 00       	jmp    1322 <parseexec+0xf2>
    if ((tok = gettoken(ps, es, &q, &eq)) == 0)
    129b:	8d 45 e0             	lea    -0x20(%ebp),%eax
    129e:	50                   	push   %eax
    129f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    12a2:	50                   	push   %eax
    12a3:	ff 75 0c             	pushl  0xc(%ebp)
    12a6:	ff 75 08             	pushl  0x8(%ebp)
    12a9:	e8 61 fa ff ff       	call   d0f <gettoken>
    12ae:	83 c4 10             	add    $0x10,%esp
    12b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    12b4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    12b8:	0f 84 84 00 00 00    	je     1342 <parseexec+0x112>
      break;
    if (tok != 'a')
    12be:	83 7d e8 61          	cmpl   $0x61,-0x18(%ebp)
    12c2:	74 10                	je     12d4 <parseexec+0xa4>
      panic("syntax");
    12c4:	83 ec 0c             	sub    $0xc,%esp
    12c7:	68 39 1d 00 00       	push   $0x1d39
    12cc:	e8 71 f8 ff ff       	call   b42 <panic>
    12d1:	83 c4 10             	add    $0x10,%esp
    cmd->argv[argc] = q;
    12d4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    12d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
    12da:	8b 55 f4             	mov    -0xc(%ebp),%edx
    12dd:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
    cmd->eargv[argc] = eq;
    12e1:	8b 55 e0             	mov    -0x20(%ebp),%edx
    12e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
    12e7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    12ea:	83 c1 08             	add    $0x8,%ecx
    12ed:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    argc++;
    12f1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if (argc >= MAXARGS)
    12f5:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    12f9:	7e 10                	jle    130b <parseexec+0xdb>
      panic("too many args");
    12fb:	83 ec 0c             	sub    $0xc,%esp
    12fe:	68 88 1d 00 00       	push   $0x1d88
    1303:	e8 3a f8 ff ff       	call   b42 <panic>
    1308:	83 c4 10             	add    $0x10,%esp
    ret = parseredirs(ret, ps, es);
    130b:	83 ec 04             	sub    $0x4,%esp
    130e:	ff 75 0c             	pushl  0xc(%ebp)
    1311:	ff 75 08             	pushl  0x8(%ebp)
    1314:	ff 75 f0             	pushl  -0x10(%ebp)
    1317:	e8 76 fd ff ff       	call   1092 <parseredirs>
    131c:	83 c4 10             	add    $0x10,%esp
    131f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while (!peek(ps, es, "|)&;")) {
    1322:	83 ec 04             	sub    $0x4,%esp
    1325:	68 96 1d 00 00       	push   $0x1d96
    132a:	ff 75 0c             	pushl  0xc(%ebp)
    132d:	ff 75 08             	pushl  0x8(%ebp)
    1330:	e8 2e fb ff ff       	call   e63 <peek>
    1335:	83 c4 10             	add    $0x10,%esp
    1338:	85 c0                	test   %eax,%eax
    133a:	0f 84 5b ff ff ff    	je     129b <parseexec+0x6b>
    1340:	eb 01                	jmp    1343 <parseexec+0x113>
      break;
    1342:	90                   	nop
  }
  cmd->argv[argc] = 0;
    1343:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1346:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1349:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
    1350:	00 
  cmd->eargv[argc] = 0;
    1351:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1354:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1357:	83 c2 08             	add    $0x8,%edx
    135a:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
    1361:	00 
  return ret;
    1362:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1365:	c9                   	leave  
    1366:	c3                   	ret    

00001367 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd *nulterminate(struct cmd *cmd) {
    1367:	f3 0f 1e fb          	endbr32 
    136b:	55                   	push   %ebp
    136c:	89 e5                	mov    %esp,%ebp
    136e:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if (cmd == 0)
    1371:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1375:	75 0a                	jne    1381 <nulterminate+0x1a>
    return 0;
    1377:	b8 00 00 00 00       	mov    $0x0,%eax
    137c:	e9 e5 00 00 00       	jmp    1466 <nulterminate+0xff>

  switch (cmd->type) {
    1381:	8b 45 08             	mov    0x8(%ebp),%eax
    1384:	8b 00                	mov    (%eax),%eax
    1386:	83 f8 05             	cmp    $0x5,%eax
    1389:	0f 87 d4 00 00 00    	ja     1463 <nulterminate+0xfc>
    138f:	8b 04 85 9c 1d 00 00 	mov    0x1d9c(,%eax,4),%eax
    1396:	3e ff e0             	notrack jmp *%eax
  case EXEC:
    ecmd = (struct execcmd *)cmd;
    1399:	8b 45 08             	mov    0x8(%ebp),%eax
    139c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for (i = 0; ecmd->argv[i]; i++)
    139f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    13a6:	eb 14                	jmp    13bc <nulterminate+0x55>
      *ecmd->eargv[i] = 0;
    13a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
    13ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
    13ae:	83 c2 08             	add    $0x8,%edx
    13b1:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
    13b5:	c6 00 00             	movb   $0x0,(%eax)
    for (i = 0; ecmd->argv[i]; i++)
    13b8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    13bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
    13bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
    13c2:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
    13c6:	85 c0                	test   %eax,%eax
    13c8:	75 de                	jne    13a8 <nulterminate+0x41>
    break;
    13ca:	e9 94 00 00 00       	jmp    1463 <nulterminate+0xfc>

  case REDIR:
    rcmd = (struct redircmd *)cmd;
    13cf:	8b 45 08             	mov    0x8(%ebp),%eax
    13d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nulterminate(rcmd->cmd);
    13d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    13d8:	8b 40 04             	mov    0x4(%eax),%eax
    13db:	83 ec 0c             	sub    $0xc,%esp
    13de:	50                   	push   %eax
    13df:	e8 83 ff ff ff       	call   1367 <nulterminate>
    13e4:	83 c4 10             	add    $0x10,%esp
    *rcmd->efile = 0;
    13e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    13ea:	8b 40 0c             	mov    0xc(%eax),%eax
    13ed:	c6 00 00             	movb   $0x0,(%eax)
    break;
    13f0:	eb 71                	jmp    1463 <nulterminate+0xfc>

  case PIPE:
    pcmd = (struct pipecmd *)cmd;
    13f2:	8b 45 08             	mov    0x8(%ebp),%eax
    13f5:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nulterminate(pcmd->left);
    13f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
    13fb:	8b 40 04             	mov    0x4(%eax),%eax
    13fe:	83 ec 0c             	sub    $0xc,%esp
    1401:	50                   	push   %eax
    1402:	e8 60 ff ff ff       	call   1367 <nulterminate>
    1407:	83 c4 10             	add    $0x10,%esp
    nulterminate(pcmd->right);
    140a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    140d:	8b 40 08             	mov    0x8(%eax),%eax
    1410:	83 ec 0c             	sub    $0xc,%esp
    1413:	50                   	push   %eax
    1414:	e8 4e ff ff ff       	call   1367 <nulterminate>
    1419:	83 c4 10             	add    $0x10,%esp
    break;
    141c:	eb 45                	jmp    1463 <nulterminate+0xfc>

  case LIST:
    lcmd = (struct listcmd *)cmd;
    141e:	8b 45 08             	mov    0x8(%ebp),%eax
    1421:	89 45 ec             	mov    %eax,-0x14(%ebp)
    nulterminate(lcmd->left);
    1424:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1427:	8b 40 04             	mov    0x4(%eax),%eax
    142a:	83 ec 0c             	sub    $0xc,%esp
    142d:	50                   	push   %eax
    142e:	e8 34 ff ff ff       	call   1367 <nulterminate>
    1433:	83 c4 10             	add    $0x10,%esp
    nulterminate(lcmd->right);
    1436:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1439:	8b 40 08             	mov    0x8(%eax),%eax
    143c:	83 ec 0c             	sub    $0xc,%esp
    143f:	50                   	push   %eax
    1440:	e8 22 ff ff ff       	call   1367 <nulterminate>
    1445:	83 c4 10             	add    $0x10,%esp
    break;
    1448:	eb 19                	jmp    1463 <nulterminate+0xfc>

  case BACK:
    bcmd = (struct backcmd *)cmd;
    144a:	8b 45 08             	mov    0x8(%ebp),%eax
    144d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    nulterminate(bcmd->cmd);
    1450:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1453:	8b 40 04             	mov    0x4(%eax),%eax
    1456:	83 ec 0c             	sub    $0xc,%esp
    1459:	50                   	push   %eax
    145a:	e8 08 ff ff ff       	call   1367 <nulterminate>
    145f:	83 c4 10             	add    $0x10,%esp
    break;
    1462:	90                   	nop
  }
  return cmd;
    1463:	8b 45 08             	mov    0x8(%ebp),%eax
    1466:	c9                   	leave  
    1467:	c3                   	ret    

00001468 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1468:	55                   	push   %ebp
    1469:	89 e5                	mov    %esp,%ebp
    146b:	57                   	push   %edi
    146c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    146d:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1470:	8b 55 10             	mov    0x10(%ebp),%edx
    1473:	8b 45 0c             	mov    0xc(%ebp),%eax
    1476:	89 cb                	mov    %ecx,%ebx
    1478:	89 df                	mov    %ebx,%edi
    147a:	89 d1                	mov    %edx,%ecx
    147c:	fc                   	cld    
    147d:	f3 aa                	rep stos %al,%es:(%edi)
    147f:	89 ca                	mov    %ecx,%edx
    1481:	89 fb                	mov    %edi,%ebx
    1483:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1486:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1489:	90                   	nop
    148a:	5b                   	pop    %ebx
    148b:	5f                   	pop    %edi
    148c:	5d                   	pop    %ebp
    148d:	c3                   	ret    

0000148e <strcpy>:
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user.h"
#include "kernel/x86.h"

char *strcpy(char *s, char *t) {
    148e:	f3 0f 1e fb          	endbr32 
    1492:	55                   	push   %ebp
    1493:	89 e5                	mov    %esp,%ebp
    1495:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1498:	8b 45 08             	mov    0x8(%ebp),%eax
    149b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while ((*s++ = *t++) != 0)
    149e:	90                   	nop
    149f:	8b 55 0c             	mov    0xc(%ebp),%edx
    14a2:	8d 42 01             	lea    0x1(%edx),%eax
    14a5:	89 45 0c             	mov    %eax,0xc(%ebp)
    14a8:	8b 45 08             	mov    0x8(%ebp),%eax
    14ab:	8d 48 01             	lea    0x1(%eax),%ecx
    14ae:	89 4d 08             	mov    %ecx,0x8(%ebp)
    14b1:	0f b6 12             	movzbl (%edx),%edx
    14b4:	88 10                	mov    %dl,(%eax)
    14b6:	0f b6 00             	movzbl (%eax),%eax
    14b9:	84 c0                	test   %al,%al
    14bb:	75 e2                	jne    149f <strcpy+0x11>
    ;
  return os;
    14bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    14c0:	c9                   	leave  
    14c1:	c3                   	ret    

000014c2 <strcmp>:

int strcmp(const char *p, const char *q) {
    14c2:	f3 0f 1e fb          	endbr32 
    14c6:	55                   	push   %ebp
    14c7:	89 e5                	mov    %esp,%ebp
  while (*p && *p == *q)
    14c9:	eb 08                	jmp    14d3 <strcmp+0x11>
    p++, q++;
    14cb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    14cf:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while (*p && *p == *q)
    14d3:	8b 45 08             	mov    0x8(%ebp),%eax
    14d6:	0f b6 00             	movzbl (%eax),%eax
    14d9:	84 c0                	test   %al,%al
    14db:	74 10                	je     14ed <strcmp+0x2b>
    14dd:	8b 45 08             	mov    0x8(%ebp),%eax
    14e0:	0f b6 10             	movzbl (%eax),%edx
    14e3:	8b 45 0c             	mov    0xc(%ebp),%eax
    14e6:	0f b6 00             	movzbl (%eax),%eax
    14e9:	38 c2                	cmp    %al,%dl
    14eb:	74 de                	je     14cb <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
    14ed:	8b 45 08             	mov    0x8(%ebp),%eax
    14f0:	0f b6 00             	movzbl (%eax),%eax
    14f3:	0f b6 d0             	movzbl %al,%edx
    14f6:	8b 45 0c             	mov    0xc(%ebp),%eax
    14f9:	0f b6 00             	movzbl (%eax),%eax
    14fc:	0f b6 c0             	movzbl %al,%eax
    14ff:	29 c2                	sub    %eax,%edx
    1501:	89 d0                	mov    %edx,%eax
}
    1503:	5d                   	pop    %ebp
    1504:	c3                   	ret    

00001505 <strlen>:

uint strlen(char *s) {
    1505:	f3 0f 1e fb          	endbr32 
    1509:	55                   	push   %ebp
    150a:	89 e5                	mov    %esp,%ebp
    150c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for (n = 0; s[n]; n++)
    150f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1516:	eb 04                	jmp    151c <strlen+0x17>
    1518:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    151c:	8b 55 fc             	mov    -0x4(%ebp),%edx
    151f:	8b 45 08             	mov    0x8(%ebp),%eax
    1522:	01 d0                	add    %edx,%eax
    1524:	0f b6 00             	movzbl (%eax),%eax
    1527:	84 c0                	test   %al,%al
    1529:	75 ed                	jne    1518 <strlen+0x13>
    ;
  return n;
    152b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    152e:	c9                   	leave  
    152f:	c3                   	ret    

00001530 <memset>:

void *memset(void *dst, int c, uint n) {
    1530:	f3 0f 1e fb          	endbr32 
    1534:	55                   	push   %ebp
    1535:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
    1537:	8b 45 10             	mov    0x10(%ebp),%eax
    153a:	50                   	push   %eax
    153b:	ff 75 0c             	pushl  0xc(%ebp)
    153e:	ff 75 08             	pushl  0x8(%ebp)
    1541:	e8 22 ff ff ff       	call   1468 <stosb>
    1546:	83 c4 0c             	add    $0xc,%esp
  return dst;
    1549:	8b 45 08             	mov    0x8(%ebp),%eax
}
    154c:	c9                   	leave  
    154d:	c3                   	ret    

0000154e <strchr>:

char *strchr(const char *s, char c) {
    154e:	f3 0f 1e fb          	endbr32 
    1552:	55                   	push   %ebp
    1553:	89 e5                	mov    %esp,%ebp
    1555:	83 ec 04             	sub    $0x4,%esp
    1558:	8b 45 0c             	mov    0xc(%ebp),%eax
    155b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for (; *s; s++)
    155e:	eb 14                	jmp    1574 <strchr+0x26>
    if (*s == c)
    1560:	8b 45 08             	mov    0x8(%ebp),%eax
    1563:	0f b6 00             	movzbl (%eax),%eax
    1566:	38 45 fc             	cmp    %al,-0x4(%ebp)
    1569:	75 05                	jne    1570 <strchr+0x22>
      return (char *)s;
    156b:	8b 45 08             	mov    0x8(%ebp),%eax
    156e:	eb 13                	jmp    1583 <strchr+0x35>
  for (; *s; s++)
    1570:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1574:	8b 45 08             	mov    0x8(%ebp),%eax
    1577:	0f b6 00             	movzbl (%eax),%eax
    157a:	84 c0                	test   %al,%al
    157c:	75 e2                	jne    1560 <strchr+0x12>
  return 0;
    157e:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1583:	c9                   	leave  
    1584:	c3                   	ret    

00001585 <gets>:

char *gets(char *buf, int max) {
    1585:	f3 0f 1e fb          	endbr32 
    1589:	55                   	push   %ebp
    158a:	89 e5                	mov    %esp,%ebp
    158c:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
    158f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1596:	eb 42                	jmp    15da <gets+0x55>
    cc = read(0, &c, 1);
    1598:	83 ec 04             	sub    $0x4,%esp
    159b:	6a 01                	push   $0x1
    159d:	8d 45 ef             	lea    -0x11(%ebp),%eax
    15a0:	50                   	push   %eax
    15a1:	6a 00                	push   $0x0
    15a3:	e8 53 01 00 00       	call   16fb <read>
    15a8:	83 c4 10             	add    $0x10,%esp
    15ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (cc < 1)
    15ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    15b2:	7e 33                	jle    15e7 <gets+0x62>
      break;
    buf[i++] = c;
    15b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15b7:	8d 50 01             	lea    0x1(%eax),%edx
    15ba:	89 55 f4             	mov    %edx,-0xc(%ebp)
    15bd:	89 c2                	mov    %eax,%edx
    15bf:	8b 45 08             	mov    0x8(%ebp),%eax
    15c2:	01 c2                	add    %eax,%edx
    15c4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    15c8:	88 02                	mov    %al,(%edx)
    if (c == '\n' || c == '\r')
    15ca:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    15ce:	3c 0a                	cmp    $0xa,%al
    15d0:	74 16                	je     15e8 <gets+0x63>
    15d2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    15d6:	3c 0d                	cmp    $0xd,%al
    15d8:	74 0e                	je     15e8 <gets+0x63>
  for (i = 0; i + 1 < max;) {
    15da:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15dd:	83 c0 01             	add    $0x1,%eax
    15e0:	39 45 0c             	cmp    %eax,0xc(%ebp)
    15e3:	7f b3                	jg     1598 <gets+0x13>
    15e5:	eb 01                	jmp    15e8 <gets+0x63>
      break;
    15e7:	90                   	nop
      break;
  }
  buf[i] = '\0';
    15e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
    15eb:	8b 45 08             	mov    0x8(%ebp),%eax
    15ee:	01 d0                	add    %edx,%eax
    15f0:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    15f3:	8b 45 08             	mov    0x8(%ebp),%eax
}
    15f6:	c9                   	leave  
    15f7:	c3                   	ret    

000015f8 <stat>:

int stat(char *n, struct stat *st) {
    15f8:	f3 0f 1e fb          	endbr32 
    15fc:	55                   	push   %ebp
    15fd:	89 e5                	mov    %esp,%ebp
    15ff:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1602:	83 ec 08             	sub    $0x8,%esp
    1605:	6a 00                	push   $0x0
    1607:	ff 75 08             	pushl  0x8(%ebp)
    160a:	e8 14 01 00 00       	call   1723 <open>
    160f:	83 c4 10             	add    $0x10,%esp
    1612:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (fd < 0)
    1615:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1619:	79 07                	jns    1622 <stat+0x2a>
    return -1;
    161b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1620:	eb 25                	jmp    1647 <stat+0x4f>
  r = fstat(fd, st);
    1622:	83 ec 08             	sub    $0x8,%esp
    1625:	ff 75 0c             	pushl  0xc(%ebp)
    1628:	ff 75 f4             	pushl  -0xc(%ebp)
    162b:	e8 0b 01 00 00       	call   173b <fstat>
    1630:	83 c4 10             	add    $0x10,%esp
    1633:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1636:	83 ec 0c             	sub    $0xc,%esp
    1639:	ff 75 f4             	pushl  -0xc(%ebp)
    163c:	e8 ca 00 00 00       	call   170b <close>
    1641:	83 c4 10             	add    $0x10,%esp
  return r;
    1644:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1647:	c9                   	leave  
    1648:	c3                   	ret    

00001649 <atoi>:

int atoi(const char *s) {
    1649:	f3 0f 1e fb          	endbr32 
    164d:	55                   	push   %ebp
    164e:	89 e5                	mov    %esp,%ebp
    1650:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1653:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while ('0' <= *s && *s <= '9')
    165a:	eb 25                	jmp    1681 <atoi+0x38>
    n = n * 10 + *s++ - '0';
    165c:	8b 55 fc             	mov    -0x4(%ebp),%edx
    165f:	89 d0                	mov    %edx,%eax
    1661:	c1 e0 02             	shl    $0x2,%eax
    1664:	01 d0                	add    %edx,%eax
    1666:	01 c0                	add    %eax,%eax
    1668:	89 c1                	mov    %eax,%ecx
    166a:	8b 45 08             	mov    0x8(%ebp),%eax
    166d:	8d 50 01             	lea    0x1(%eax),%edx
    1670:	89 55 08             	mov    %edx,0x8(%ebp)
    1673:	0f b6 00             	movzbl (%eax),%eax
    1676:	0f be c0             	movsbl %al,%eax
    1679:	01 c8                	add    %ecx,%eax
    167b:	83 e8 30             	sub    $0x30,%eax
    167e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while ('0' <= *s && *s <= '9')
    1681:	8b 45 08             	mov    0x8(%ebp),%eax
    1684:	0f b6 00             	movzbl (%eax),%eax
    1687:	3c 2f                	cmp    $0x2f,%al
    1689:	7e 0a                	jle    1695 <atoi+0x4c>
    168b:	8b 45 08             	mov    0x8(%ebp),%eax
    168e:	0f b6 00             	movzbl (%eax),%eax
    1691:	3c 39                	cmp    $0x39,%al
    1693:	7e c7                	jle    165c <atoi+0x13>
  return n;
    1695:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1698:	c9                   	leave  
    1699:	c3                   	ret    

0000169a <memmove>:

void *memmove(void *vdst, void *vsrc, int n) {
    169a:	f3 0f 1e fb          	endbr32 
    169e:	55                   	push   %ebp
    169f:	89 e5                	mov    %esp,%ebp
    16a1:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
    16a4:	8b 45 08             	mov    0x8(%ebp),%eax
    16a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    16aa:	8b 45 0c             	mov    0xc(%ebp),%eax
    16ad:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while (n-- > 0)
    16b0:	eb 17                	jmp    16c9 <memmove+0x2f>
    *dst++ = *src++;
    16b2:	8b 55 f8             	mov    -0x8(%ebp),%edx
    16b5:	8d 42 01             	lea    0x1(%edx),%eax
    16b8:	89 45 f8             	mov    %eax,-0x8(%ebp)
    16bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16be:	8d 48 01             	lea    0x1(%eax),%ecx
    16c1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
    16c4:	0f b6 12             	movzbl (%edx),%edx
    16c7:	88 10                	mov    %dl,(%eax)
  while (n-- > 0)
    16c9:	8b 45 10             	mov    0x10(%ebp),%eax
    16cc:	8d 50 ff             	lea    -0x1(%eax),%edx
    16cf:	89 55 10             	mov    %edx,0x10(%ebp)
    16d2:	85 c0                	test   %eax,%eax
    16d4:	7f dc                	jg     16b2 <memmove+0x18>
  return vdst;
    16d6:	8b 45 08             	mov    0x8(%ebp),%eax
}
    16d9:	c9                   	leave  
    16da:	c3                   	ret    

000016db <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    16db:	b8 01 00 00 00       	mov    $0x1,%eax
    16e0:	cd 40                	int    $0x40
    16e2:	c3                   	ret    

000016e3 <exit>:
SYSCALL(exit)
    16e3:	b8 02 00 00 00       	mov    $0x2,%eax
    16e8:	cd 40                	int    $0x40
    16ea:	c3                   	ret    

000016eb <wait>:
SYSCALL(wait)
    16eb:	b8 03 00 00 00       	mov    $0x3,%eax
    16f0:	cd 40                	int    $0x40
    16f2:	c3                   	ret    

000016f3 <pipe>:
SYSCALL(pipe)
    16f3:	b8 04 00 00 00       	mov    $0x4,%eax
    16f8:	cd 40                	int    $0x40
    16fa:	c3                   	ret    

000016fb <read>:
SYSCALL(read)
    16fb:	b8 05 00 00 00       	mov    $0x5,%eax
    1700:	cd 40                	int    $0x40
    1702:	c3                   	ret    

00001703 <write>:
SYSCALL(write)
    1703:	b8 10 00 00 00       	mov    $0x10,%eax
    1708:	cd 40                	int    $0x40
    170a:	c3                   	ret    

0000170b <close>:
SYSCALL(close)
    170b:	b8 15 00 00 00       	mov    $0x15,%eax
    1710:	cd 40                	int    $0x40
    1712:	c3                   	ret    

00001713 <kill>:
SYSCALL(kill)
    1713:	b8 06 00 00 00       	mov    $0x6,%eax
    1718:	cd 40                	int    $0x40
    171a:	c3                   	ret    

0000171b <exec>:
SYSCALL(exec)
    171b:	b8 07 00 00 00       	mov    $0x7,%eax
    1720:	cd 40                	int    $0x40
    1722:	c3                   	ret    

00001723 <open>:
SYSCALL(open)
    1723:	b8 0f 00 00 00       	mov    $0xf,%eax
    1728:	cd 40                	int    $0x40
    172a:	c3                   	ret    

0000172b <mknod>:
SYSCALL(mknod)
    172b:	b8 11 00 00 00       	mov    $0x11,%eax
    1730:	cd 40                	int    $0x40
    1732:	c3                   	ret    

00001733 <unlink>:
SYSCALL(unlink)
    1733:	b8 12 00 00 00       	mov    $0x12,%eax
    1738:	cd 40                	int    $0x40
    173a:	c3                   	ret    

0000173b <fstat>:
SYSCALL(fstat)
    173b:	b8 08 00 00 00       	mov    $0x8,%eax
    1740:	cd 40                	int    $0x40
    1742:	c3                   	ret    

00001743 <link>:
SYSCALL(link)
    1743:	b8 13 00 00 00       	mov    $0x13,%eax
    1748:	cd 40                	int    $0x40
    174a:	c3                   	ret    

0000174b <mkdir>:
SYSCALL(mkdir)
    174b:	b8 14 00 00 00       	mov    $0x14,%eax
    1750:	cd 40                	int    $0x40
    1752:	c3                   	ret    

00001753 <chdir>:
SYSCALL(chdir)
    1753:	b8 09 00 00 00       	mov    $0x9,%eax
    1758:	cd 40                	int    $0x40
    175a:	c3                   	ret    

0000175b <dup>:
SYSCALL(dup)
    175b:	b8 0a 00 00 00       	mov    $0xa,%eax
    1760:	cd 40                	int    $0x40
    1762:	c3                   	ret    

00001763 <getpid>:
SYSCALL(getpid)
    1763:	b8 0b 00 00 00       	mov    $0xb,%eax
    1768:	cd 40                	int    $0x40
    176a:	c3                   	ret    

0000176b <sbrk>:
SYSCALL(sbrk)
    176b:	b8 0c 00 00 00       	mov    $0xc,%eax
    1770:	cd 40                	int    $0x40
    1772:	c3                   	ret    

00001773 <sleep>:
SYSCALL(sleep)
    1773:	b8 0d 00 00 00       	mov    $0xd,%eax
    1778:	cd 40                	int    $0x40
    177a:	c3                   	ret    

0000177b <uptime>:
SYSCALL(uptime)
    177b:	b8 0e 00 00 00       	mov    $0xe,%eax
    1780:	cd 40                	int    $0x40
    1782:	c3                   	ret    

00001783 <trace>:
SYSCALL(trace)
    1783:	b8 16 00 00 00       	mov    $0x16,%eax
    1788:	cd 40                	int    $0x40
    178a:	c3                   	ret    

0000178b <setEFlag>:
SYSCALL(setEFlag)
    178b:	b8 17 00 00 00       	mov    $0x17,%eax
    1790:	cd 40                	int    $0x40
    1792:	c3                   	ret    

00001793 <setSFlag>:
SYSCALL(setSFlag)
    1793:	b8 18 00 00 00       	mov    $0x18,%eax
    1798:	cd 40                	int    $0x40
    179a:	c3                   	ret    

0000179b <setFFlag>:
SYSCALL(setFFlag)
    179b:	b8 19 00 00 00       	mov    $0x19,%eax
    17a0:	cd 40                	int    $0x40
    17a2:	c3                   	ret    

000017a3 <dump>:
    17a3:	b8 1a 00 00 00       	mov    $0x1a,%eax
    17a8:	cd 40                	int    $0x40
    17aa:	c3                   	ret    

000017ab <putc>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user.h"

static void putc(int fd, char c) { write(fd, &c, 1); }
    17ab:	f3 0f 1e fb          	endbr32 
    17af:	55                   	push   %ebp
    17b0:	89 e5                	mov    %esp,%ebp
    17b2:	83 ec 18             	sub    $0x18,%esp
    17b5:	8b 45 0c             	mov    0xc(%ebp),%eax
    17b8:	88 45 f4             	mov    %al,-0xc(%ebp)
    17bb:	83 ec 04             	sub    $0x4,%esp
    17be:	6a 01                	push   $0x1
    17c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
    17c3:	50                   	push   %eax
    17c4:	ff 75 08             	pushl  0x8(%ebp)
    17c7:	e8 37 ff ff ff       	call   1703 <write>
    17cc:	83 c4 10             	add    $0x10,%esp
    17cf:	90                   	nop
    17d0:	c9                   	leave  
    17d1:	c3                   	ret    

000017d2 <printint>:

static void printint(int fd, int xx, int base, int sgn) {
    17d2:	f3 0f 1e fb          	endbr32 
    17d6:	55                   	push   %ebp
    17d7:	89 e5                	mov    %esp,%ebp
    17d9:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    17dc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if (sgn && xx < 0) {
    17e3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    17e7:	74 17                	je     1800 <printint+0x2e>
    17e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    17ed:	79 11                	jns    1800 <printint+0x2e>
    neg = 1;
    17ef:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    17f6:	8b 45 0c             	mov    0xc(%ebp),%eax
    17f9:	f7 d8                	neg    %eax
    17fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    17fe:	eb 06                	jmp    1806 <printint+0x34>
  } else {
    x = xx;
    1800:	8b 45 0c             	mov    0xc(%ebp),%eax
    1803:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1806:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do {
    buf[i++] = digits[x % base];
    180d:	8b 4d 10             	mov    0x10(%ebp),%ecx
    1810:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1813:	ba 00 00 00 00       	mov    $0x0,%edx
    1818:	f7 f1                	div    %ecx
    181a:	89 d1                	mov    %edx,%ecx
    181c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    181f:	8d 50 01             	lea    0x1(%eax),%edx
    1822:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1825:	0f b6 91 f0 22 00 00 	movzbl 0x22f0(%ecx),%edx
    182c:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  } while ((x /= base) != 0);
    1830:	8b 4d 10             	mov    0x10(%ebp),%ecx
    1833:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1836:	ba 00 00 00 00       	mov    $0x0,%edx
    183b:	f7 f1                	div    %ecx
    183d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1840:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1844:	75 c7                	jne    180d <printint+0x3b>
  if (neg)
    1846:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    184a:	74 2d                	je     1879 <printint+0xa7>
    buf[i++] = '-';
    184c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    184f:	8d 50 01             	lea    0x1(%eax),%edx
    1852:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1855:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while (--i >= 0)
    185a:	eb 1d                	jmp    1879 <printint+0xa7>
    putc(fd, buf[i]);
    185c:	8d 55 dc             	lea    -0x24(%ebp),%edx
    185f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1862:	01 d0                	add    %edx,%eax
    1864:	0f b6 00             	movzbl (%eax),%eax
    1867:	0f be c0             	movsbl %al,%eax
    186a:	83 ec 08             	sub    $0x8,%esp
    186d:	50                   	push   %eax
    186e:	ff 75 08             	pushl  0x8(%ebp)
    1871:	e8 35 ff ff ff       	call   17ab <putc>
    1876:	83 c4 10             	add    $0x10,%esp
  while (--i >= 0)
    1879:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    187d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1881:	79 d9                	jns    185c <printint+0x8a>
}
    1883:	90                   	nop
    1884:	90                   	nop
    1885:	c9                   	leave  
    1886:	c3                   	ret    

00001887 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void printf(int fd, char *fmt, ...) {
    1887:	f3 0f 1e fb          	endbr32 
    188b:	55                   	push   %ebp
    188c:	89 e5                	mov    %esp,%ebp
    188e:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1891:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint *)(void *)&fmt + 1;
    1898:	8d 45 0c             	lea    0xc(%ebp),%eax
    189b:	83 c0 04             	add    $0x4,%eax
    189e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for (i = 0; fmt[i]; i++) {
    18a1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    18a8:	e9 59 01 00 00       	jmp    1a06 <printf+0x17f>
    c = fmt[i] & 0xff;
    18ad:	8b 55 0c             	mov    0xc(%ebp),%edx
    18b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18b3:	01 d0                	add    %edx,%eax
    18b5:	0f b6 00             	movzbl (%eax),%eax
    18b8:	0f be c0             	movsbl %al,%eax
    18bb:	25 ff 00 00 00       	and    $0xff,%eax
    18c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (state == 0) {
    18c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    18c7:	75 2c                	jne    18f5 <printf+0x6e>
      if (c == '%') {
    18c9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    18cd:	75 0c                	jne    18db <printf+0x54>
        state = '%';
    18cf:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    18d6:	e9 27 01 00 00       	jmp    1a02 <printf+0x17b>
      } else {
        putc(fd, c);
    18db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    18de:	0f be c0             	movsbl %al,%eax
    18e1:	83 ec 08             	sub    $0x8,%esp
    18e4:	50                   	push   %eax
    18e5:	ff 75 08             	pushl  0x8(%ebp)
    18e8:	e8 be fe ff ff       	call   17ab <putc>
    18ed:	83 c4 10             	add    $0x10,%esp
    18f0:	e9 0d 01 00 00       	jmp    1a02 <printf+0x17b>
      }
    } else if (state == '%') {
    18f5:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    18f9:	0f 85 03 01 00 00    	jne    1a02 <printf+0x17b>
      if (c == 'd') {
    18ff:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1903:	75 1e                	jne    1923 <printf+0x9c>
        printint(fd, *ap, 10, 1);
    1905:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1908:	8b 00                	mov    (%eax),%eax
    190a:	6a 01                	push   $0x1
    190c:	6a 0a                	push   $0xa
    190e:	50                   	push   %eax
    190f:	ff 75 08             	pushl  0x8(%ebp)
    1912:	e8 bb fe ff ff       	call   17d2 <printint>
    1917:	83 c4 10             	add    $0x10,%esp
        ap++;
    191a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    191e:	e9 d8 00 00 00       	jmp    19fb <printf+0x174>
      } else if (c == 'x' || c == 'p') {
    1923:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1927:	74 06                	je     192f <printf+0xa8>
    1929:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    192d:	75 1e                	jne    194d <printf+0xc6>
        printint(fd, *ap, 16, 0);
    192f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1932:	8b 00                	mov    (%eax),%eax
    1934:	6a 00                	push   $0x0
    1936:	6a 10                	push   $0x10
    1938:	50                   	push   %eax
    1939:	ff 75 08             	pushl  0x8(%ebp)
    193c:	e8 91 fe ff ff       	call   17d2 <printint>
    1941:	83 c4 10             	add    $0x10,%esp
        ap++;
    1944:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1948:	e9 ae 00 00 00       	jmp    19fb <printf+0x174>
      } else if (c == 's') {
    194d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1951:	75 43                	jne    1996 <printf+0x10f>
        s = (char *)*ap;
    1953:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1956:	8b 00                	mov    (%eax),%eax
    1958:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    195b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if (s == 0)
    195f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1963:	75 25                	jne    198a <printf+0x103>
          s = "(null)";
    1965:	c7 45 f4 b4 1d 00 00 	movl   $0x1db4,-0xc(%ebp)
        while (*s != 0) {
    196c:	eb 1c                	jmp    198a <printf+0x103>
          putc(fd, *s);
    196e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1971:	0f b6 00             	movzbl (%eax),%eax
    1974:	0f be c0             	movsbl %al,%eax
    1977:	83 ec 08             	sub    $0x8,%esp
    197a:	50                   	push   %eax
    197b:	ff 75 08             	pushl  0x8(%ebp)
    197e:	e8 28 fe ff ff       	call   17ab <putc>
    1983:	83 c4 10             	add    $0x10,%esp
          s++;
    1986:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while (*s != 0) {
    198a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    198d:	0f b6 00             	movzbl (%eax),%eax
    1990:	84 c0                	test   %al,%al
    1992:	75 da                	jne    196e <printf+0xe7>
    1994:	eb 65                	jmp    19fb <printf+0x174>
        }
      } else if (c == 'c') {
    1996:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    199a:	75 1d                	jne    19b9 <printf+0x132>
        putc(fd, *ap);
    199c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    199f:	8b 00                	mov    (%eax),%eax
    19a1:	0f be c0             	movsbl %al,%eax
    19a4:	83 ec 08             	sub    $0x8,%esp
    19a7:	50                   	push   %eax
    19a8:	ff 75 08             	pushl  0x8(%ebp)
    19ab:	e8 fb fd ff ff       	call   17ab <putc>
    19b0:	83 c4 10             	add    $0x10,%esp
        ap++;
    19b3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    19b7:	eb 42                	jmp    19fb <printf+0x174>
      } else if (c == '%') {
    19b9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    19bd:	75 17                	jne    19d6 <printf+0x14f>
        putc(fd, c);
    19bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    19c2:	0f be c0             	movsbl %al,%eax
    19c5:	83 ec 08             	sub    $0x8,%esp
    19c8:	50                   	push   %eax
    19c9:	ff 75 08             	pushl  0x8(%ebp)
    19cc:	e8 da fd ff ff       	call   17ab <putc>
    19d1:	83 c4 10             	add    $0x10,%esp
    19d4:	eb 25                	jmp    19fb <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    19d6:	83 ec 08             	sub    $0x8,%esp
    19d9:	6a 25                	push   $0x25
    19db:	ff 75 08             	pushl  0x8(%ebp)
    19de:	e8 c8 fd ff ff       	call   17ab <putc>
    19e3:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    19e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    19e9:	0f be c0             	movsbl %al,%eax
    19ec:	83 ec 08             	sub    $0x8,%esp
    19ef:	50                   	push   %eax
    19f0:	ff 75 08             	pushl  0x8(%ebp)
    19f3:	e8 b3 fd ff ff       	call   17ab <putc>
    19f8:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    19fb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for (i = 0; fmt[i]; i++) {
    1a02:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1a06:	8b 55 0c             	mov    0xc(%ebp),%edx
    1a09:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a0c:	01 d0                	add    %edx,%eax
    1a0e:	0f b6 00             	movzbl (%eax),%eax
    1a11:	84 c0                	test   %al,%al
    1a13:	0f 85 94 fe ff ff    	jne    18ad <printf+0x26>
    }
  }
}
    1a19:	90                   	nop
    1a1a:	90                   	nop
    1a1b:	c9                   	leave  
    1a1c:	c3                   	ret    

00001a1d <free>:
typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
    1a1d:	f3 0f 1e fb          	endbr32 
    1a21:	55                   	push   %ebp
    1a22:	89 e5                	mov    %esp,%ebp
    1a24:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header *)ap - 1;
    1a27:	8b 45 08             	mov    0x8(%ebp),%eax
    1a2a:	83 e8 08             	sub    $0x8,%eax
    1a2d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1a30:	a1 ac 23 00 00       	mov    0x23ac,%eax
    1a35:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1a38:	eb 24                	jmp    1a5e <free+0x41>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1a3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a3d:	8b 00                	mov    (%eax),%eax
    1a3f:	39 45 fc             	cmp    %eax,-0x4(%ebp)
    1a42:	72 12                	jb     1a56 <free+0x39>
    1a44:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1a47:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1a4a:	77 24                	ja     1a70 <free+0x53>
    1a4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a4f:	8b 00                	mov    (%eax),%eax
    1a51:	39 45 f8             	cmp    %eax,-0x8(%ebp)
    1a54:	72 1a                	jb     1a70 <free+0x53>
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1a56:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a59:	8b 00                	mov    (%eax),%eax
    1a5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1a5e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1a61:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1a64:	76 d4                	jbe    1a3a <free+0x1d>
    1a66:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a69:	8b 00                	mov    (%eax),%eax
    1a6b:	39 45 f8             	cmp    %eax,-0x8(%ebp)
    1a6e:	73 ca                	jae    1a3a <free+0x1d>
      break;
  if (bp + bp->s.size == p->s.ptr) {
    1a70:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1a73:	8b 40 04             	mov    0x4(%eax),%eax
    1a76:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1a7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1a80:	01 c2                	add    %eax,%edx
    1a82:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a85:	8b 00                	mov    (%eax),%eax
    1a87:	39 c2                	cmp    %eax,%edx
    1a89:	75 24                	jne    1aaf <free+0x92>
    bp->s.size += p->s.ptr->s.size;
    1a8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1a8e:	8b 50 04             	mov    0x4(%eax),%edx
    1a91:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a94:	8b 00                	mov    (%eax),%eax
    1a96:	8b 40 04             	mov    0x4(%eax),%eax
    1a99:	01 c2                	add    %eax,%edx
    1a9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1a9e:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1aa1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1aa4:	8b 00                	mov    (%eax),%eax
    1aa6:	8b 10                	mov    (%eax),%edx
    1aa8:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1aab:	89 10                	mov    %edx,(%eax)
    1aad:	eb 0a                	jmp    1ab9 <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
    1aaf:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1ab2:	8b 10                	mov    (%eax),%edx
    1ab4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1ab7:	89 10                	mov    %edx,(%eax)
  if (p + p->s.size == bp) {
    1ab9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1abc:	8b 40 04             	mov    0x4(%eax),%eax
    1abf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1ac6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1ac9:	01 d0                	add    %edx,%eax
    1acb:	39 45 f8             	cmp    %eax,-0x8(%ebp)
    1ace:	75 20                	jne    1af0 <free+0xd3>
    p->s.size += bp->s.size;
    1ad0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1ad3:	8b 50 04             	mov    0x4(%eax),%edx
    1ad6:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1ad9:	8b 40 04             	mov    0x4(%eax),%eax
    1adc:	01 c2                	add    %eax,%edx
    1ade:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1ae1:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1ae4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1ae7:	8b 10                	mov    (%eax),%edx
    1ae9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1aec:	89 10                	mov    %edx,(%eax)
    1aee:	eb 08                	jmp    1af8 <free+0xdb>
  } else
    p->s.ptr = bp;
    1af0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1af3:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1af6:	89 10                	mov    %edx,(%eax)
  freep = p;
    1af8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1afb:	a3 ac 23 00 00       	mov    %eax,0x23ac
}
    1b00:	90                   	nop
    1b01:	c9                   	leave  
    1b02:	c3                   	ret    

00001b03 <morecore>:

static Header *morecore(uint nu) {
    1b03:	f3 0f 1e fb          	endbr32 
    1b07:	55                   	push   %ebp
    1b08:	89 e5                	mov    %esp,%ebp
    1b0a:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if (nu < 4096)
    1b0d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1b14:	77 07                	ja     1b1d <morecore+0x1a>
    nu = 4096;
    1b16:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1b1d:	8b 45 08             	mov    0x8(%ebp),%eax
    1b20:	c1 e0 03             	shl    $0x3,%eax
    1b23:	83 ec 0c             	sub    $0xc,%esp
    1b26:	50                   	push   %eax
    1b27:	e8 3f fc ff ff       	call   176b <sbrk>
    1b2c:	83 c4 10             	add    $0x10,%esp
    1b2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (p == (char *)-1)
    1b32:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1b36:	75 07                	jne    1b3f <morecore+0x3c>
    return 0;
    1b38:	b8 00 00 00 00       	mov    $0x0,%eax
    1b3d:	eb 26                	jmp    1b65 <morecore+0x62>
  hp = (Header *)p;
    1b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b42:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1b48:	8b 55 08             	mov    0x8(%ebp),%edx
    1b4b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void *)(hp + 1));
    1b4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1b51:	83 c0 08             	add    $0x8,%eax
    1b54:	83 ec 0c             	sub    $0xc,%esp
    1b57:	50                   	push   %eax
    1b58:	e8 c0 fe ff ff       	call   1a1d <free>
    1b5d:	83 c4 10             	add    $0x10,%esp
  return freep;
    1b60:	a1 ac 23 00 00       	mov    0x23ac,%eax
}
    1b65:	c9                   	leave  
    1b66:	c3                   	ret    

00001b67 <malloc>:

void *malloc(uint nbytes) {
    1b67:	f3 0f 1e fb          	endbr32 
    1b6b:	55                   	push   %ebp
    1b6c:	89 e5                	mov    %esp,%ebp
    1b6e:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
    1b71:	8b 45 08             	mov    0x8(%ebp),%eax
    1b74:	83 c0 07             	add    $0x7,%eax
    1b77:	c1 e8 03             	shr    $0x3,%eax
    1b7a:	83 c0 01             	add    $0x1,%eax
    1b7d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if ((prevp = freep) == 0) {
    1b80:	a1 ac 23 00 00       	mov    0x23ac,%eax
    1b85:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1b88:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1b8c:	75 23                	jne    1bb1 <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
    1b8e:	c7 45 f0 a4 23 00 00 	movl   $0x23a4,-0x10(%ebp)
    1b95:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1b98:	a3 ac 23 00 00       	mov    %eax,0x23ac
    1b9d:	a1 ac 23 00 00       	mov    0x23ac,%eax
    1ba2:	a3 a4 23 00 00       	mov    %eax,0x23a4
    base.s.size = 0;
    1ba7:	c7 05 a8 23 00 00 00 	movl   $0x0,0x23a8
    1bae:	00 00 00 
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    1bb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1bb4:	8b 00                	mov    (%eax),%eax
    1bb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p->s.size >= nunits) {
    1bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bbc:	8b 40 04             	mov    0x4(%eax),%eax
    1bbf:	39 45 ec             	cmp    %eax,-0x14(%ebp)
    1bc2:	77 4d                	ja     1c11 <malloc+0xaa>
      if (p->s.size == nunits)
    1bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bc7:	8b 40 04             	mov    0x4(%eax),%eax
    1bca:	39 45 ec             	cmp    %eax,-0x14(%ebp)
    1bcd:	75 0c                	jne    1bdb <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
    1bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bd2:	8b 10                	mov    (%eax),%edx
    1bd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1bd7:	89 10                	mov    %edx,(%eax)
    1bd9:	eb 26                	jmp    1c01 <malloc+0x9a>
      else {
        p->s.size -= nunits;
    1bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bde:	8b 40 04             	mov    0x4(%eax),%eax
    1be1:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1be4:	89 c2                	mov    %eax,%edx
    1be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1be9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bef:	8b 40 04             	mov    0x4(%eax),%eax
    1bf2:	c1 e0 03             	shl    $0x3,%eax
    1bf5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bfb:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1bfe:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1c01:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1c04:	a3 ac 23 00 00       	mov    %eax,0x23ac
      return (void *)(p + 1);
    1c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c0c:	83 c0 08             	add    $0x8,%eax
    1c0f:	eb 3b                	jmp    1c4c <malloc+0xe5>
    }
    if (p == freep)
    1c11:	a1 ac 23 00 00       	mov    0x23ac,%eax
    1c16:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1c19:	75 1e                	jne    1c39 <malloc+0xd2>
      if ((p = morecore(nunits)) == 0)
    1c1b:	83 ec 0c             	sub    $0xc,%esp
    1c1e:	ff 75 ec             	pushl  -0x14(%ebp)
    1c21:	e8 dd fe ff ff       	call   1b03 <morecore>
    1c26:	83 c4 10             	add    $0x10,%esp
    1c29:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1c2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1c30:	75 07                	jne    1c39 <malloc+0xd2>
        return 0;
    1c32:	b8 00 00 00 00       	mov    $0x0,%eax
    1c37:	eb 13                	jmp    1c4c <malloc+0xe5>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    1c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c42:	8b 00                	mov    (%eax),%eax
    1c44:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p->s.size >= nunits) {
    1c47:	e9 6d ff ff ff       	jmp    1bb9 <malloc+0x52>
  }
}
    1c4c:	c9                   	leave  
    1c4d:	c3                   	ret    
