
kernel/kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <binit>:
  // Linked list of all buffers, through prev/next.
  // head.next is most recently used.
  struct buf head;
} bcache;

void binit(void) {
80100000:	f3 0f 1e fb          	endbr32 
80100004:	55                   	push   %ebp
80100005:	89 e5                	mov    %esp,%ebp
80100007:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010000a:	83 ec 08             	sub    $0x8,%esp
8010000d:	68 04 9e 10 80       	push   $0x80109e04
80100012:	68 40 d7 10 80       	push   $0x8010d740
80100017:	e8 e6 51 00 00       	call   80105202 <initlock>
8010001c:	83 c4 10             	add    $0x10,%esp

  // PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010001f:	c7 05 50 16 11 80 44 	movl   $0x80111644,0x80111650
80100026:	16 11 80 
  bcache.head.next = &bcache.head;
80100029:	c7 05 54 16 11 80 44 	movl   $0x80111644,0x80111654
80100030:	16 11 80 
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
80100033:	c7 45 f4 74 d7 10 80 	movl   $0x8010d774,-0xc(%ebp)
8010003a:	eb 3a                	jmp    80100076 <binit+0x76>
    b->next = bcache.head.next;
8010003c:	8b 15 54 16 11 80    	mov    0x80111654,%edx
80100042:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100045:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100048:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010004b:	c7 40 0c 44 16 11 80 	movl   $0x80111644,0xc(%eax)
    b->dev = -1;
80100052:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100055:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010005c:	a1 54 16 11 80       	mov    0x80111654,%eax
80100061:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100064:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100067:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010006a:	a3 54 16 11 80       	mov    %eax,0x80111654
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
8010006f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
80100076:	b8 44 16 11 80       	mov    $0x80111644,%eax
8010007b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010007e:	72 bc                	jb     8010003c <binit+0x3c>
  }
}
80100080:	90                   	nop
80100081:	90                   	nop
80100082:	c9                   	leave  
80100083:	c3                   	ret    

80100084 <bget>:

// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf *bget(uint dev, uint blockno) {
80100084:	f3 0f 1e fb          	endbr32 
80100088:	55                   	push   %ebp
80100089:	89 e5                	mov    %esp,%ebp
8010008b:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
8010008e:	83 ec 0c             	sub    $0xc,%esp
80100091:	68 40 d7 10 80       	push   $0x8010d740
80100096:	e8 8d 51 00 00       	call   80105228 <acquire>
8010009b:	83 c4 10             	add    $0x10,%esp

loop:
  // Is the block already cached?
  for (b = bcache.head.next; b != &bcache.head; b = b->next) {
8010009e:	a1 54 16 11 80       	mov    0x80111654,%eax
801000a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000a6:	eb 67                	jmp    8010010f <bget+0x8b>
    if (b->dev == dev && b->blockno == blockno) {
801000a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ab:	8b 40 04             	mov    0x4(%eax),%eax
801000ae:	39 45 08             	cmp    %eax,0x8(%ebp)
801000b1:	75 53                	jne    80100106 <bget+0x82>
801000b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000b6:	8b 40 08             	mov    0x8(%eax),%eax
801000b9:	39 45 0c             	cmp    %eax,0xc(%ebp)
801000bc:	75 48                	jne    80100106 <bget+0x82>
      if (!(b->flags & B_BUSY)) {
801000be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000c1:	8b 00                	mov    (%eax),%eax
801000c3:	83 e0 01             	and    $0x1,%eax
801000c6:	85 c0                	test   %eax,%eax
801000c8:	75 27                	jne    801000f1 <bget+0x6d>
        b->flags |= B_BUSY;
801000ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000cd:	8b 00                	mov    (%eax),%eax
801000cf:	83 c8 01             	or     $0x1,%eax
801000d2:	89 c2                	mov    %eax,%edx
801000d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d7:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
801000d9:	83 ec 0c             	sub    $0xc,%esp
801000dc:	68 40 d7 10 80       	push   $0x8010d740
801000e1:	e8 ad 51 00 00       	call   80105293 <release>
801000e6:	83 c4 10             	add    $0x10,%esp
        return b;
801000e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ec:	e9 98 00 00 00       	jmp    80100189 <bget+0x105>
      }
      sleep(b, &bcache.lock);
801000f1:	83 ec 08             	sub    $0x8,%esp
801000f4:	68 40 d7 10 80       	push   $0x8010d740
801000f9:	ff 75 f4             	pushl  -0xc(%ebp)
801000fc:	e8 14 4e 00 00       	call   80104f15 <sleep>
80100101:	83 c4 10             	add    $0x10,%esp
      goto loop;
80100104:	eb 98                	jmp    8010009e <bget+0x1a>
  for (b = bcache.head.next; b != &bcache.head; b = b->next) {
80100106:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100109:	8b 40 10             	mov    0x10(%eax),%eax
8010010c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010010f:	81 7d f4 44 16 11 80 	cmpl   $0x80111644,-0xc(%ebp)
80100116:	75 90                	jne    801000a8 <bget+0x24>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
80100118:	a1 50 16 11 80       	mov    0x80111650,%eax
8010011d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100120:	eb 51                	jmp    80100173 <bget+0xef>
    if ((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0) {
80100122:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100125:	8b 00                	mov    (%eax),%eax
80100127:	83 e0 01             	and    $0x1,%eax
8010012a:	85 c0                	test   %eax,%eax
8010012c:	75 3c                	jne    8010016a <bget+0xe6>
8010012e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100131:	8b 00                	mov    (%eax),%eax
80100133:	83 e0 04             	and    $0x4,%eax
80100136:	85 c0                	test   %eax,%eax
80100138:	75 30                	jne    8010016a <bget+0xe6>
      b->dev = dev;
8010013a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010013d:	8b 55 08             	mov    0x8(%ebp),%edx
80100140:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
80100143:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100146:	8b 55 0c             	mov    0xc(%ebp),%edx
80100149:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
8010014c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010014f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100155:	83 ec 0c             	sub    $0xc,%esp
80100158:	68 40 d7 10 80       	push   $0x8010d740
8010015d:	e8 31 51 00 00       	call   80105293 <release>
80100162:	83 c4 10             	add    $0x10,%esp
      return b;
80100165:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100168:	eb 1f                	jmp    80100189 <bget+0x105>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
8010016a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016d:	8b 40 0c             	mov    0xc(%eax),%eax
80100170:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100173:	81 7d f4 44 16 11 80 	cmpl   $0x80111644,-0xc(%ebp)
8010017a:	75 a6                	jne    80100122 <bget+0x9e>
    }
  }
  panic("bget: no buffers");
8010017c:	83 ec 0c             	sub    $0xc,%esp
8010017f:	68 0b 9e 10 80       	push   $0x80109e0b
80100184:	e8 da 03 00 00       	call   80100563 <panic>
}
80100189:	c9                   	leave  
8010018a:	c3                   	ret    

8010018b <bread>:

// Return a B_BUSY buf with the contents of the indicated block.
struct buf *bread(uint dev, uint blockno) {
8010018b:	f3 0f 1e fb          	endbr32 
8010018f:	55                   	push   %ebp
80100190:	89 e5                	mov    %esp,%ebp
80100192:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
80100195:	83 ec 08             	sub    $0x8,%esp
80100198:	ff 75 0c             	pushl  0xc(%ebp)
8010019b:	ff 75 08             	pushl  0x8(%ebp)
8010019e:	e8 e1 fe ff ff       	call   80100084 <bget>
801001a3:	83 c4 10             	add    $0x10,%esp
801001a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (!(b->flags & B_VALID)) {
801001a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001ac:	8b 00                	mov    (%eax),%eax
801001ae:	83 e0 02             	and    $0x2,%eax
801001b1:	85 c0                	test   %eax,%eax
801001b3:	75 0e                	jne    801001c3 <bread+0x38>
    iderw(b);
801001b5:	83 ec 0c             	sub    $0xc,%esp
801001b8:	ff 75 f4             	pushl  -0xc(%ebp)
801001bb:	e8 05 28 00 00       	call   801029c5 <iderw>
801001c0:	83 c4 10             	add    $0x10,%esp
  }
  return b;
801001c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001c6:	c9                   	leave  
801001c7:	c3                   	ret    

801001c8 <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void bwrite(struct buf *b) {
801001c8:	f3 0f 1e fb          	endbr32 
801001cc:	55                   	push   %ebp
801001cd:	89 e5                	mov    %esp,%ebp
801001cf:	83 ec 08             	sub    $0x8,%esp
  if ((b->flags & B_BUSY) == 0)
801001d2:	8b 45 08             	mov    0x8(%ebp),%eax
801001d5:	8b 00                	mov    (%eax),%eax
801001d7:	83 e0 01             	and    $0x1,%eax
801001da:	85 c0                	test   %eax,%eax
801001dc:	75 0d                	jne    801001eb <bwrite+0x23>
    panic("bwrite");
801001de:	83 ec 0c             	sub    $0xc,%esp
801001e1:	68 1c 9e 10 80       	push   $0x80109e1c
801001e6:	e8 78 03 00 00       	call   80100563 <panic>
  b->flags |= B_DIRTY;
801001eb:	8b 45 08             	mov    0x8(%ebp),%eax
801001ee:	8b 00                	mov    (%eax),%eax
801001f0:	83 c8 04             	or     $0x4,%eax
801001f3:	89 c2                	mov    %eax,%edx
801001f5:	8b 45 08             	mov    0x8(%ebp),%eax
801001f8:	89 10                	mov    %edx,(%eax)
  iderw(b);
801001fa:	83 ec 0c             	sub    $0xc,%esp
801001fd:	ff 75 08             	pushl  0x8(%ebp)
80100200:	e8 c0 27 00 00       	call   801029c5 <iderw>
80100205:	83 c4 10             	add    $0x10,%esp
}
80100208:	90                   	nop
80100209:	c9                   	leave  
8010020a:	c3                   	ret    

8010020b <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void brelse(struct buf *b) {
8010020b:	f3 0f 1e fb          	endbr32 
8010020f:	55                   	push   %ebp
80100210:	89 e5                	mov    %esp,%ebp
80100212:	83 ec 08             	sub    $0x8,%esp
  if ((b->flags & B_BUSY) == 0)
80100215:	8b 45 08             	mov    0x8(%ebp),%eax
80100218:	8b 00                	mov    (%eax),%eax
8010021a:	83 e0 01             	and    $0x1,%eax
8010021d:	85 c0                	test   %eax,%eax
8010021f:	75 0d                	jne    8010022e <brelse+0x23>
    panic("brelse");
80100221:	83 ec 0c             	sub    $0xc,%esp
80100224:	68 23 9e 10 80       	push   $0x80109e23
80100229:	e8 35 03 00 00       	call   80100563 <panic>

  acquire(&bcache.lock);
8010022e:	83 ec 0c             	sub    $0xc,%esp
80100231:	68 40 d7 10 80       	push   $0x8010d740
80100236:	e8 ed 4f 00 00       	call   80105228 <acquire>
8010023b:	83 c4 10             	add    $0x10,%esp

  b->next->prev = b->prev;
8010023e:	8b 45 08             	mov    0x8(%ebp),%eax
80100241:	8b 40 10             	mov    0x10(%eax),%eax
80100244:	8b 55 08             	mov    0x8(%ebp),%edx
80100247:	8b 52 0c             	mov    0xc(%edx),%edx
8010024a:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
8010024d:	8b 45 08             	mov    0x8(%ebp),%eax
80100250:	8b 40 0c             	mov    0xc(%eax),%eax
80100253:	8b 55 08             	mov    0x8(%ebp),%edx
80100256:	8b 52 10             	mov    0x10(%edx),%edx
80100259:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010025c:	8b 15 54 16 11 80    	mov    0x80111654,%edx
80100262:	8b 45 08             	mov    0x8(%ebp),%eax
80100265:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100268:	8b 45 08             	mov    0x8(%ebp),%eax
8010026b:	c7 40 0c 44 16 11 80 	movl   $0x80111644,0xc(%eax)
  bcache.head.next->prev = b;
80100272:	a1 54 16 11 80       	mov    0x80111654,%eax
80100277:	8b 55 08             	mov    0x8(%ebp),%edx
8010027a:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
8010027d:	8b 45 08             	mov    0x8(%ebp),%eax
80100280:	a3 54 16 11 80       	mov    %eax,0x80111654

  b->flags &= ~B_BUSY;
80100285:	8b 45 08             	mov    0x8(%ebp),%eax
80100288:	8b 00                	mov    (%eax),%eax
8010028a:	83 e0 fe             	and    $0xfffffffe,%eax
8010028d:	89 c2                	mov    %eax,%edx
8010028f:	8b 45 08             	mov    0x8(%ebp),%eax
80100292:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80100294:	83 ec 0c             	sub    $0xc,%esp
80100297:	ff 75 08             	pushl  0x8(%ebp)
8010029a:	e8 6a 4d 00 00       	call   80105009 <wakeup>
8010029f:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002a2:	83 ec 0c             	sub    $0xc,%esp
801002a5:	68 40 d7 10 80       	push   $0x8010d740
801002aa:	e8 e4 4f 00 00       	call   80105293 <release>
801002af:	83 c4 10             	add    $0x10,%esp
}
801002b2:	90                   	nop
801002b3:	c9                   	leave  
801002b4:	c3                   	ret    

801002b5 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002b5:	55                   	push   %ebp
801002b6:	89 e5                	mov    %esp,%ebp
801002b8:	83 ec 14             	sub    $0x14,%esp
801002bb:	8b 45 08             	mov    0x8(%ebp),%eax
801002be:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002c2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002c6:	89 c2                	mov    %eax,%edx
801002c8:	ec                   	in     (%dx),%al
801002c9:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002cc:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002d0:	c9                   	leave  
801002d1:	c3                   	ret    

801002d2 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002d2:	55                   	push   %ebp
801002d3:	89 e5                	mov    %esp,%ebp
801002d5:	83 ec 08             	sub    $0x8,%esp
801002d8:	8b 45 08             	mov    0x8(%ebp),%eax
801002db:	8b 55 0c             	mov    0xc(%ebp),%edx
801002de:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801002e2:	89 d0                	mov    %edx,%eax
801002e4:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801002e7:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801002eb:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801002ef:	ee                   	out    %al,(%dx)
}
801002f0:	90                   	nop
801002f1:	c9                   	leave  
801002f2:	c3                   	ret    

801002f3 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801002f3:	55                   	push   %ebp
801002f4:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801002f6:	fa                   	cli    
}
801002f7:	90                   	nop
801002f8:	5d                   	pop    %ebp
801002f9:	c3                   	ret    

801002fa <printint>:
static struct {
  struct spinlock lock;
  int locking;
} cons;

static void printint(int xx, int base, int sign) {
801002fa:	f3 0f 1e fb          	endbr32 
801002fe:	55                   	push   %ebp
801002ff:	89 e5                	mov    %esp,%ebp
80100301:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if (sign && (sign = xx < 0))
80100304:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100308:	74 1c                	je     80100326 <printint+0x2c>
8010030a:	8b 45 08             	mov    0x8(%ebp),%eax
8010030d:	c1 e8 1f             	shr    $0x1f,%eax
80100310:	0f b6 c0             	movzbl %al,%eax
80100313:	89 45 10             	mov    %eax,0x10(%ebp)
80100316:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010031a:	74 0a                	je     80100326 <printint+0x2c>
    x = -xx;
8010031c:	8b 45 08             	mov    0x8(%ebp),%eax
8010031f:	f7 d8                	neg    %eax
80100321:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100324:	eb 06                	jmp    8010032c <printint+0x32>
  else
    x = xx;
80100326:	8b 45 08             	mov    0x8(%ebp),%eax
80100329:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
8010032c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do {
    buf[i++] = digits[x % base];
80100333:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100336:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100339:	ba 00 00 00 00       	mov    $0x0,%edx
8010033e:	f7 f1                	div    %ecx
80100340:	89 d1                	mov    %edx,%ecx
80100342:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100345:	8d 50 01             	lea    0x1(%eax),%edx
80100348:	89 55 f4             	mov    %edx,-0xc(%ebp)
8010034b:	0f b6 91 04 b0 10 80 	movzbl -0x7fef4ffc(%ecx),%edx
80100352:	88 54 05 e0          	mov    %dl,-0x20(%ebp,%eax,1)
  } while ((x /= base) != 0);
80100356:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100359:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010035c:	ba 00 00 00 00       	mov    $0x0,%edx
80100361:	f7 f1                	div    %ecx
80100363:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100366:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010036a:	75 c7                	jne    80100333 <printint+0x39>

  if (sign)
8010036c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100370:	74 2a                	je     8010039c <printint+0xa2>
    buf[i++] = '-';
80100372:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100375:	8d 50 01             	lea    0x1(%eax),%edx
80100378:	89 55 f4             	mov    %edx,-0xc(%ebp)
8010037b:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while (--i >= 0)
80100380:	eb 1a                	jmp    8010039c <printint+0xa2>
    consputc(buf[i]);
80100382:	8d 55 e0             	lea    -0x20(%ebp),%edx
80100385:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100388:	01 d0                	add    %edx,%eax
8010038a:	0f b6 00             	movzbl (%eax),%eax
8010038d:	0f be c0             	movsbl %al,%eax
80100390:	83 ec 0c             	sub    $0xc,%esp
80100393:	50                   	push   %eax
80100394:	e8 06 04 00 00       	call   8010079f <consputc>
80100399:	83 c4 10             	add    $0x10,%esp
  while (--i >= 0)
8010039c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003a4:	79 dc                	jns    80100382 <printint+0x88>
}
801003a6:	90                   	nop
801003a7:	90                   	nop
801003a8:	c9                   	leave  
801003a9:	c3                   	ret    

801003aa <cprintf>:
// PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void cprintf(char *fmt, ...) {
801003aa:	f3 0f 1e fb          	endbr32 
801003ae:	55                   	push   %ebp
801003af:	89 e5                	mov    %esp,%ebp
801003b1:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003b4:	a1 b4 d6 10 80       	mov    0x8010d6b4,%eax
801003b9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if (locking)
801003bc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003c0:	74 10                	je     801003d2 <cprintf+0x28>
    acquire(&cons.lock);
801003c2:	83 ec 0c             	sub    $0xc,%esp
801003c5:	68 80 d6 10 80       	push   $0x8010d680
801003ca:	e8 59 4e 00 00       	call   80105228 <acquire>
801003cf:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003d2:	8b 45 08             	mov    0x8(%ebp),%eax
801003d5:	85 c0                	test   %eax,%eax
801003d7:	75 0d                	jne    801003e6 <cprintf+0x3c>
    panic("null fmt");
801003d9:	83 ec 0c             	sub    $0xc,%esp
801003dc:	68 2a 9e 10 80       	push   $0x80109e2a
801003e1:	e8 7d 01 00 00       	call   80100563 <panic>

  argp = (uint *)(void *)(&fmt + 1);
801003e6:	8d 45 0c             	lea    0xc(%ebp),%eax
801003e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
801003ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801003f3:	e9 2f 01 00 00       	jmp    80100527 <cprintf+0x17d>
    if (c != '%') {
801003f8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801003fc:	74 13                	je     80100411 <cprintf+0x67>
      consputc(c);
801003fe:	83 ec 0c             	sub    $0xc,%esp
80100401:	ff 75 e4             	pushl  -0x1c(%ebp)
80100404:	e8 96 03 00 00       	call   8010079f <consputc>
80100409:	83 c4 10             	add    $0x10,%esp
      continue;
8010040c:	e9 12 01 00 00       	jmp    80100523 <cprintf+0x179>
    }
    c = fmt[++i] & 0xff;
80100411:	8b 55 08             	mov    0x8(%ebp),%edx
80100414:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100418:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010041b:	01 d0                	add    %edx,%eax
8010041d:	0f b6 00             	movzbl (%eax),%eax
80100420:	0f be c0             	movsbl %al,%eax
80100423:	25 ff 00 00 00       	and    $0xff,%eax
80100428:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (c == 0)
8010042b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010042f:	0f 84 14 01 00 00    	je     80100549 <cprintf+0x19f>
      break;
    switch (c) {
80100435:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
80100439:	74 5e                	je     80100499 <cprintf+0xef>
8010043b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
8010043f:	0f 8f c2 00 00 00    	jg     80100507 <cprintf+0x15d>
80100445:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
80100449:	74 6b                	je     801004b6 <cprintf+0x10c>
8010044b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
8010044f:	0f 8f b2 00 00 00    	jg     80100507 <cprintf+0x15d>
80100455:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
80100459:	74 3e                	je     80100499 <cprintf+0xef>
8010045b:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
8010045f:	0f 8f a2 00 00 00    	jg     80100507 <cprintf+0x15d>
80100465:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100469:	0f 84 89 00 00 00    	je     801004f8 <cprintf+0x14e>
8010046f:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
80100473:	0f 85 8e 00 00 00    	jne    80100507 <cprintf+0x15d>
    case 'd':
      printint(*argp++, 10, 1);
80100479:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047c:	8d 50 04             	lea    0x4(%eax),%edx
8010047f:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100482:	8b 00                	mov    (%eax),%eax
80100484:	83 ec 04             	sub    $0x4,%esp
80100487:	6a 01                	push   $0x1
80100489:	6a 0a                	push   $0xa
8010048b:	50                   	push   %eax
8010048c:	e8 69 fe ff ff       	call   801002fa <printint>
80100491:	83 c4 10             	add    $0x10,%esp
      break;
80100494:	e9 8a 00 00 00       	jmp    80100523 <cprintf+0x179>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100499:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010049c:	8d 50 04             	lea    0x4(%eax),%edx
8010049f:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a2:	8b 00                	mov    (%eax),%eax
801004a4:	83 ec 04             	sub    $0x4,%esp
801004a7:	6a 00                	push   $0x0
801004a9:	6a 10                	push   $0x10
801004ab:	50                   	push   %eax
801004ac:	e8 49 fe ff ff       	call   801002fa <printint>
801004b1:	83 c4 10             	add    $0x10,%esp
      break;
801004b4:	eb 6d                	jmp    80100523 <cprintf+0x179>
    case 's':
      if ((s = (char *)*argp++) == 0)
801004b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004b9:	8d 50 04             	lea    0x4(%eax),%edx
801004bc:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004bf:	8b 00                	mov    (%eax),%eax
801004c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004c8:	75 22                	jne    801004ec <cprintf+0x142>
        s = "(null)";
801004ca:	c7 45 ec 33 9e 10 80 	movl   $0x80109e33,-0x14(%ebp)
      for (; *s; s++)
801004d1:	eb 19                	jmp    801004ec <cprintf+0x142>
        consputc(*s);
801004d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d6:	0f b6 00             	movzbl (%eax),%eax
801004d9:	0f be c0             	movsbl %al,%eax
801004dc:	83 ec 0c             	sub    $0xc,%esp
801004df:	50                   	push   %eax
801004e0:	e8 ba 02 00 00       	call   8010079f <consputc>
801004e5:	83 c4 10             	add    $0x10,%esp
      for (; *s; s++)
801004e8:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004ef:	0f b6 00             	movzbl (%eax),%eax
801004f2:	84 c0                	test   %al,%al
801004f4:	75 dd                	jne    801004d3 <cprintf+0x129>
      break;
801004f6:	eb 2b                	jmp    80100523 <cprintf+0x179>
    case '%':
      consputc('%');
801004f8:	83 ec 0c             	sub    $0xc,%esp
801004fb:	6a 25                	push   $0x25
801004fd:	e8 9d 02 00 00       	call   8010079f <consputc>
80100502:	83 c4 10             	add    $0x10,%esp
      break;
80100505:	eb 1c                	jmp    80100523 <cprintf+0x179>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100507:	83 ec 0c             	sub    $0xc,%esp
8010050a:	6a 25                	push   $0x25
8010050c:	e8 8e 02 00 00       	call   8010079f <consputc>
80100511:	83 c4 10             	add    $0x10,%esp
      consputc(c);
80100514:	83 ec 0c             	sub    $0xc,%esp
80100517:	ff 75 e4             	pushl  -0x1c(%ebp)
8010051a:	e8 80 02 00 00       	call   8010079f <consputc>
8010051f:	83 c4 10             	add    $0x10,%esp
      break;
80100522:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
80100523:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100527:	8b 55 08             	mov    0x8(%ebp),%edx
8010052a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010052d:	01 d0                	add    %edx,%eax
8010052f:	0f b6 00             	movzbl (%eax),%eax
80100532:	0f be c0             	movsbl %al,%eax
80100535:	25 ff 00 00 00       	and    $0xff,%eax
8010053a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010053d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100541:	0f 85 b1 fe ff ff    	jne    801003f8 <cprintf+0x4e>
80100547:	eb 01                	jmp    8010054a <cprintf+0x1a0>
      break;
80100549:	90                   	nop
    }
  }

  if (locking)
8010054a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010054e:	74 10                	je     80100560 <cprintf+0x1b6>
    release(&cons.lock);
80100550:	83 ec 0c             	sub    $0xc,%esp
80100553:	68 80 d6 10 80       	push   $0x8010d680
80100558:	e8 36 4d 00 00       	call   80105293 <release>
8010055d:	83 c4 10             	add    $0x10,%esp
}
80100560:	90                   	nop
80100561:	c9                   	leave  
80100562:	c3                   	ret    

80100563 <panic>:

void panic(char *s) {
80100563:	f3 0f 1e fb          	endbr32 
80100567:	55                   	push   %ebp
80100568:	89 e5                	mov    %esp,%ebp
8010056a:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];

  cli();
8010056d:	e8 81 fd ff ff       	call   801002f3 <cli>
  cons.locking = 0;
80100572:	c7 05 b4 d6 10 80 00 	movl   $0x0,0x8010d6b4
80100579:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010057c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100582:	0f b6 00             	movzbl (%eax),%eax
80100585:	0f b6 c0             	movzbl %al,%eax
80100588:	83 ec 08             	sub    $0x8,%esp
8010058b:	50                   	push   %eax
8010058c:	68 3a 9e 10 80       	push   $0x80109e3a
80100591:	e8 14 fe ff ff       	call   801003aa <cprintf>
80100596:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
80100599:	8b 45 08             	mov    0x8(%ebp),%eax
8010059c:	83 ec 0c             	sub    $0xc,%esp
8010059f:	50                   	push   %eax
801005a0:	e8 05 fe ff ff       	call   801003aa <cprintf>
801005a5:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801005a8:	83 ec 0c             	sub    $0xc,%esp
801005ab:	68 49 9e 10 80       	push   $0x80109e49
801005b0:	e8 f5 fd ff ff       	call   801003aa <cprintf>
801005b5:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b8:	83 ec 08             	sub    $0x8,%esp
801005bb:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005be:	50                   	push   %eax
801005bf:	8d 45 08             	lea    0x8(%ebp),%eax
801005c2:	50                   	push   %eax
801005c3:	e8 21 4d 00 00       	call   801052e9 <getcallerpcs>
801005c8:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < 10; i++)
801005cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d2:	eb 1c                	jmp    801005f0 <panic+0x8d>
    cprintf(" %p", pcs[i]);
801005d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d7:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005db:	83 ec 08             	sub    $0x8,%esp
801005de:	50                   	push   %eax
801005df:	68 4b 9e 10 80       	push   $0x80109e4b
801005e4:	e8 c1 fd ff ff       	call   801003aa <cprintf>
801005e9:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < 10; i++)
801005ec:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005f0:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005f4:	7e de                	jle    801005d4 <panic+0x71>
  panicked = 1; // freeze other CPU
801005f6:	c7 05 60 d6 10 80 01 	movl   $0x1,0x8010d660
801005fd:	00 00 00 
  for (;;)
80100600:	eb fe                	jmp    80100600 <panic+0x9d>

80100602 <cgaputc>:
// PAGEBREAK: 50
#define BACKSPACE 0x100
#define CRTPORT 0x3d4
static ushort *crt = (ushort *)P2V(0xb8000); // CGA memory

static void cgaputc(int c) {
80100602:	f3 0f 1e fb          	endbr32 
80100606:	55                   	push   %ebp
80100607:	89 e5                	mov    %esp,%ebp
80100609:	53                   	push   %ebx
8010060a:	83 ec 14             	sub    $0x14,%esp
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
8010060d:	6a 0e                	push   $0xe
8010060f:	68 d4 03 00 00       	push   $0x3d4
80100614:	e8 b9 fc ff ff       	call   801002d2 <outb>
80100619:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT + 1) << 8;
8010061c:	68 d5 03 00 00       	push   $0x3d5
80100621:	e8 8f fc ff ff       	call   801002b5 <inb>
80100626:	83 c4 04             	add    $0x4,%esp
80100629:	0f b6 c0             	movzbl %al,%eax
8010062c:	c1 e0 08             	shl    $0x8,%eax
8010062f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
80100632:	6a 0f                	push   $0xf
80100634:	68 d4 03 00 00       	push   $0x3d4
80100639:	e8 94 fc ff ff       	call   801002d2 <outb>
8010063e:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT + 1);
80100641:	68 d5 03 00 00       	push   $0x3d5
80100646:	e8 6a fc ff ff       	call   801002b5 <inb>
8010064b:	83 c4 04             	add    $0x4,%esp
8010064e:	0f b6 c0             	movzbl %al,%eax
80100651:	09 45 f4             	or     %eax,-0xc(%ebp)

  if (c == '\n')
80100654:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100658:	75 30                	jne    8010068a <cgaputc+0x88>
    pos += 80 - pos % 80;
8010065a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010065d:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100662:	89 c8                	mov    %ecx,%eax
80100664:	f7 ea                	imul   %edx
80100666:	c1 fa 05             	sar    $0x5,%edx
80100669:	89 c8                	mov    %ecx,%eax
8010066b:	c1 f8 1f             	sar    $0x1f,%eax
8010066e:	29 c2                	sub    %eax,%edx
80100670:	89 d0                	mov    %edx,%eax
80100672:	c1 e0 02             	shl    $0x2,%eax
80100675:	01 d0                	add    %edx,%eax
80100677:	c1 e0 04             	shl    $0x4,%eax
8010067a:	29 c1                	sub    %eax,%ecx
8010067c:	89 ca                	mov    %ecx,%edx
8010067e:	b8 50 00 00 00       	mov    $0x50,%eax
80100683:	29 d0                	sub    %edx,%eax
80100685:	01 45 f4             	add    %eax,-0xc(%ebp)
80100688:	eb 38                	jmp    801006c2 <cgaputc+0xc0>
  else if (c == BACKSPACE) {
8010068a:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100691:	75 0c                	jne    8010069f <cgaputc+0x9d>
    if (pos > 0)
80100693:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100697:	7e 29                	jle    801006c2 <cgaputc+0xc0>
      --pos;
80100699:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
8010069d:	eb 23                	jmp    801006c2 <cgaputc+0xc0>
  } else
    crt[pos++] = (c & 0xff) | 0x0700; // black on white
8010069f:	8b 45 08             	mov    0x8(%ebp),%eax
801006a2:	0f b6 c0             	movzbl %al,%eax
801006a5:	80 cc 07             	or     $0x7,%ah
801006a8:	89 c3                	mov    %eax,%ebx
801006aa:	8b 0d 00 b0 10 80    	mov    0x8010b000,%ecx
801006b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006b3:	8d 50 01             	lea    0x1(%eax),%edx
801006b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
801006b9:	01 c0                	add    %eax,%eax
801006bb:	01 c8                	add    %ecx,%eax
801006bd:	89 da                	mov    %ebx,%edx
801006bf:	66 89 10             	mov    %dx,(%eax)

  if (pos < 0 || pos > 25 * 80)
801006c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006c6:	78 09                	js     801006d1 <cgaputc+0xcf>
801006c8:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
801006cf:	7e 0d                	jle    801006de <cgaputc+0xdc>
    panic("pos under/overflow");
801006d1:	83 ec 0c             	sub    $0xc,%esp
801006d4:	68 4f 9e 10 80       	push   $0x80109e4f
801006d9:	e8 85 fe ff ff       	call   80100563 <panic>

  if ((pos / 80) >= 24) { // Scroll up.
801006de:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006e5:	7e 4c                	jle    80100733 <cgaputc+0x131>
    memmove(crt, crt + 80, sizeof(crt[0]) * 23 * 80);
801006e7:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801006ec:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006f2:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801006f7:	83 ec 04             	sub    $0x4,%esp
801006fa:	68 60 0e 00 00       	push   $0xe60
801006ff:	52                   	push   %edx
80100700:	50                   	push   %eax
80100701:	e8 65 4e 00 00       	call   8010556b <memmove>
80100706:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
80100709:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt + pos, 0, sizeof(crt[0]) * (24 * 80 - pos));
8010070d:	b8 80 07 00 00       	mov    $0x780,%eax
80100712:	2b 45 f4             	sub    -0xc(%ebp),%eax
80100715:	8d 14 00             	lea    (%eax,%eax,1),%edx
80100718:	a1 00 b0 10 80       	mov    0x8010b000,%eax
8010071d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100720:	01 c9                	add    %ecx,%ecx
80100722:	01 c8                	add    %ecx,%eax
80100724:	83 ec 04             	sub    $0x4,%esp
80100727:	52                   	push   %edx
80100728:	6a 00                	push   $0x0
8010072a:	50                   	push   %eax
8010072b:	e8 74 4d 00 00       	call   801054a4 <memset>
80100730:	83 c4 10             	add    $0x10,%esp
  }

  outb(CRTPORT, 14);
80100733:	83 ec 08             	sub    $0x8,%esp
80100736:	6a 0e                	push   $0xe
80100738:	68 d4 03 00 00       	push   $0x3d4
8010073d:	e8 90 fb ff ff       	call   801002d2 <outb>
80100742:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT + 1, pos >> 8);
80100745:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100748:	c1 f8 08             	sar    $0x8,%eax
8010074b:	0f b6 c0             	movzbl %al,%eax
8010074e:	83 ec 08             	sub    $0x8,%esp
80100751:	50                   	push   %eax
80100752:	68 d5 03 00 00       	push   $0x3d5
80100757:	e8 76 fb ff ff       	call   801002d2 <outb>
8010075c:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
8010075f:	83 ec 08             	sub    $0x8,%esp
80100762:	6a 0f                	push   $0xf
80100764:	68 d4 03 00 00       	push   $0x3d4
80100769:	e8 64 fb ff ff       	call   801002d2 <outb>
8010076e:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT + 1, pos);
80100771:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100774:	0f b6 c0             	movzbl %al,%eax
80100777:	83 ec 08             	sub    $0x8,%esp
8010077a:	50                   	push   %eax
8010077b:	68 d5 03 00 00       	push   $0x3d5
80100780:	e8 4d fb ff ff       	call   801002d2 <outb>
80100785:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
80100788:	a1 00 b0 10 80       	mov    0x8010b000,%eax
8010078d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100790:	01 d2                	add    %edx,%edx
80100792:	01 d0                	add    %edx,%eax
80100794:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
80100799:	90                   	nop
8010079a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010079d:	c9                   	leave  
8010079e:	c3                   	ret    

8010079f <consputc>:

void consputc(int c) {
8010079f:	f3 0f 1e fb          	endbr32 
801007a3:	55                   	push   %ebp
801007a4:	89 e5                	mov    %esp,%ebp
801007a6:	83 ec 08             	sub    $0x8,%esp
  if (panicked) {
801007a9:	a1 60 d6 10 80       	mov    0x8010d660,%eax
801007ae:	85 c0                	test   %eax,%eax
801007b0:	74 07                	je     801007b9 <consputc+0x1a>
    cli();
801007b2:	e8 3c fb ff ff       	call   801002f3 <cli>
    for (;;)
801007b7:	eb fe                	jmp    801007b7 <consputc+0x18>
      ;
  }

  if (c == BACKSPACE) {
801007b9:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801007c0:	75 29                	jne    801007eb <consputc+0x4c>
    uartputc('\b');
801007c2:	83 ec 0c             	sub    $0xc,%esp
801007c5:	6a 08                	push   $0x8
801007c7:	e8 16 7c 00 00       	call   801083e2 <uartputc>
801007cc:	83 c4 10             	add    $0x10,%esp
    uartputc(' ');
801007cf:	83 ec 0c             	sub    $0xc,%esp
801007d2:	6a 20                	push   $0x20
801007d4:	e8 09 7c 00 00       	call   801083e2 <uartputc>
801007d9:	83 c4 10             	add    $0x10,%esp
    uartputc('\b');
801007dc:	83 ec 0c             	sub    $0xc,%esp
801007df:	6a 08                	push   $0x8
801007e1:	e8 fc 7b 00 00       	call   801083e2 <uartputc>
801007e6:	83 c4 10             	add    $0x10,%esp
801007e9:	eb 0e                	jmp    801007f9 <consputc+0x5a>
  } else
    uartputc(c);
801007eb:	83 ec 0c             	sub    $0xc,%esp
801007ee:	ff 75 08             	pushl  0x8(%ebp)
801007f1:	e8 ec 7b 00 00       	call   801083e2 <uartputc>
801007f6:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
801007f9:	83 ec 0c             	sub    $0xc,%esp
801007fc:	ff 75 08             	pushl  0x8(%ebp)
801007ff:	e8 fe fd ff ff       	call   80100602 <cgaputc>
80100804:	83 c4 10             	add    $0x10,%esp
}
80100807:	90                   	nop
80100808:	c9                   	leave  
80100809:	c3                   	ret    

8010080a <consoleintr>:
  uint e; // Edit index
} input;

#define C(x) ((x) - '@') // Control-x

void consoleintr(int (*getc)(void)) {
8010080a:	f3 0f 1e fb          	endbr32 
8010080e:	55                   	push   %ebp
8010080f:	89 e5                	mov    %esp,%ebp
80100811:	83 ec 18             	sub    $0x18,%esp
  int c, doprocdump = 0;
80100814:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&cons.lock);
8010081b:	83 ec 0c             	sub    $0xc,%esp
8010081e:	68 80 d6 10 80       	push   $0x8010d680
80100823:	e8 00 4a 00 00       	call   80105228 <acquire>
80100828:	83 c4 10             	add    $0x10,%esp
  while ((c = getc()) >= 0) {
8010082b:	e9 52 01 00 00       	jmp    80100982 <consoleintr+0x178>
    switch (c) {
80100830:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
80100834:	0f 84 81 00 00 00    	je     801008bb <consoleintr+0xb1>
8010083a:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
8010083e:	0f 8f ac 00 00 00    	jg     801008f0 <consoleintr+0xe6>
80100844:	83 7d f0 15          	cmpl   $0x15,-0x10(%ebp)
80100848:	74 43                	je     8010088d <consoleintr+0x83>
8010084a:	83 7d f0 15          	cmpl   $0x15,-0x10(%ebp)
8010084e:	0f 8f 9c 00 00 00    	jg     801008f0 <consoleintr+0xe6>
80100854:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
80100858:	74 61                	je     801008bb <consoleintr+0xb1>
8010085a:	83 7d f0 10          	cmpl   $0x10,-0x10(%ebp)
8010085e:	0f 85 8c 00 00 00    	jne    801008f0 <consoleintr+0xe6>
    case C('P'):      // Process listing.
      doprocdump = 1; // procdump() locks cons.lock indirectly; invoke later
80100864:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
8010086b:	e9 12 01 00 00       	jmp    80100982 <consoleintr+0x178>
    case C('U'): // Kill line.
      while (input.e != input.w &&
             input.buf[(input.e - 1) % INPUT_BUF] != '\n') {
        input.e--;
80100870:	a1 e8 18 11 80       	mov    0x801118e8,%eax
80100875:	83 e8 01             	sub    $0x1,%eax
80100878:	a3 e8 18 11 80       	mov    %eax,0x801118e8
        consputc(BACKSPACE);
8010087d:	83 ec 0c             	sub    $0xc,%esp
80100880:	68 00 01 00 00       	push   $0x100
80100885:	e8 15 ff ff ff       	call   8010079f <consputc>
8010088a:	83 c4 10             	add    $0x10,%esp
      while (input.e != input.w &&
8010088d:	8b 15 e8 18 11 80    	mov    0x801118e8,%edx
80100893:	a1 e4 18 11 80       	mov    0x801118e4,%eax
80100898:	39 c2                	cmp    %eax,%edx
8010089a:	0f 84 e2 00 00 00    	je     80100982 <consoleintr+0x178>
             input.buf[(input.e - 1) % INPUT_BUF] != '\n') {
801008a0:	a1 e8 18 11 80       	mov    0x801118e8,%eax
801008a5:	83 e8 01             	sub    $0x1,%eax
801008a8:	83 e0 7f             	and    $0x7f,%eax
801008ab:	0f b6 80 60 18 11 80 	movzbl -0x7feee7a0(%eax),%eax
      while (input.e != input.w &&
801008b2:	3c 0a                	cmp    $0xa,%al
801008b4:	75 ba                	jne    80100870 <consoleintr+0x66>
      }
      break;
801008b6:	e9 c7 00 00 00       	jmp    80100982 <consoleintr+0x178>
    case C('H'):
    case '\x7f': // Backspace
      if (input.e != input.w) {
801008bb:	8b 15 e8 18 11 80    	mov    0x801118e8,%edx
801008c1:	a1 e4 18 11 80       	mov    0x801118e4,%eax
801008c6:	39 c2                	cmp    %eax,%edx
801008c8:	0f 84 b4 00 00 00    	je     80100982 <consoleintr+0x178>
        input.e--;
801008ce:	a1 e8 18 11 80       	mov    0x801118e8,%eax
801008d3:	83 e8 01             	sub    $0x1,%eax
801008d6:	a3 e8 18 11 80       	mov    %eax,0x801118e8
        consputc(BACKSPACE);
801008db:	83 ec 0c             	sub    $0xc,%esp
801008de:	68 00 01 00 00       	push   $0x100
801008e3:	e8 b7 fe ff ff       	call   8010079f <consputc>
801008e8:	83 c4 10             	add    $0x10,%esp
      }
      break;
801008eb:	e9 92 00 00 00       	jmp    80100982 <consoleintr+0x178>
    default:
      if (c != 0 && input.e - input.r < INPUT_BUF) {
801008f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801008f4:	0f 84 87 00 00 00    	je     80100981 <consoleintr+0x177>
801008fa:	8b 15 e8 18 11 80    	mov    0x801118e8,%edx
80100900:	a1 e0 18 11 80       	mov    0x801118e0,%eax
80100905:	29 c2                	sub    %eax,%edx
80100907:	89 d0                	mov    %edx,%eax
80100909:	83 f8 7f             	cmp    $0x7f,%eax
8010090c:	77 73                	ja     80100981 <consoleintr+0x177>
        c = (c == '\r') ? '\n' : c;
8010090e:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80100912:	74 05                	je     80100919 <consoleintr+0x10f>
80100914:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100917:	eb 05                	jmp    8010091e <consoleintr+0x114>
80100919:	b8 0a 00 00 00       	mov    $0xa,%eax
8010091e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
80100921:	a1 e8 18 11 80       	mov    0x801118e8,%eax
80100926:	8d 50 01             	lea    0x1(%eax),%edx
80100929:	89 15 e8 18 11 80    	mov    %edx,0x801118e8
8010092f:	83 e0 7f             	and    $0x7f,%eax
80100932:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100935:	88 90 60 18 11 80    	mov    %dl,-0x7feee7a0(%eax)
        consputc(c);
8010093b:	83 ec 0c             	sub    $0xc,%esp
8010093e:	ff 75 f0             	pushl  -0x10(%ebp)
80100941:	e8 59 fe ff ff       	call   8010079f <consputc>
80100946:	83 c4 10             	add    $0x10,%esp
        if (c == '\n' || c == C('D') || input.e == input.r + INPUT_BUF) {
80100949:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
8010094d:	74 18                	je     80100967 <consoleintr+0x15d>
8010094f:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100953:	74 12                	je     80100967 <consoleintr+0x15d>
80100955:	a1 e8 18 11 80       	mov    0x801118e8,%eax
8010095a:	8b 15 e0 18 11 80    	mov    0x801118e0,%edx
80100960:	83 ea 80             	sub    $0xffffff80,%edx
80100963:	39 d0                	cmp    %edx,%eax
80100965:	75 1a                	jne    80100981 <consoleintr+0x177>
          input.w = input.e;
80100967:	a1 e8 18 11 80       	mov    0x801118e8,%eax
8010096c:	a3 e4 18 11 80       	mov    %eax,0x801118e4
          wakeup(&input.r);
80100971:	83 ec 0c             	sub    $0xc,%esp
80100974:	68 e0 18 11 80       	push   $0x801118e0
80100979:	e8 8b 46 00 00       	call   80105009 <wakeup>
8010097e:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
80100981:	90                   	nop
  while ((c = getc()) >= 0) {
80100982:	8b 45 08             	mov    0x8(%ebp),%eax
80100985:	ff d0                	call   *%eax
80100987:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010098a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010098e:	0f 89 9c fe ff ff    	jns    80100830 <consoleintr+0x26>
    }
  }
  release(&cons.lock);
80100994:	83 ec 0c             	sub    $0xc,%esp
80100997:	68 80 d6 10 80       	push   $0x8010d680
8010099c:	e8 f2 48 00 00       	call   80105293 <release>
801009a1:	83 c4 10             	add    $0x10,%esp
  if (doprocdump) {
801009a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801009a8:	74 05                	je     801009af <consoleintr+0x1a5>
    procdump(); // now call procdump() wo. cons.lock held
801009aa:	e8 1d 47 00 00       	call   801050cc <procdump>
  }
}
801009af:	90                   	nop
801009b0:	c9                   	leave  
801009b1:	c3                   	ret    

801009b2 <consoleread>:

int consoleread(struct inode *ip, char *dst, int n) {
801009b2:	f3 0f 1e fb          	endbr32 
801009b6:	55                   	push   %ebp
801009b7:	89 e5                	mov    %esp,%ebp
801009b9:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
801009bc:	83 ec 0c             	sub    $0xc,%esp
801009bf:	ff 75 08             	pushl  0x8(%ebp)
801009c2:	e8 78 11 00 00       	call   80101b3f <iunlock>
801009c7:	83 c4 10             	add    $0x10,%esp
  target = n;
801009ca:	8b 45 10             	mov    0x10(%ebp),%eax
801009cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
801009d0:	83 ec 0c             	sub    $0xc,%esp
801009d3:	68 80 d6 10 80       	push   $0x8010d680
801009d8:	e8 4b 48 00 00       	call   80105228 <acquire>
801009dd:	83 c4 10             	add    $0x10,%esp
  while (n > 0) {
801009e0:	e9 ac 00 00 00       	jmp    80100a91 <consoleread+0xdf>
    while (input.r == input.w) {
      if (proc->killed) {
801009e5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801009eb:	8b 40 24             	mov    0x24(%eax),%eax
801009ee:	85 c0                	test   %eax,%eax
801009f0:	74 28                	je     80100a1a <consoleread+0x68>
        release(&cons.lock);
801009f2:	83 ec 0c             	sub    $0xc,%esp
801009f5:	68 80 d6 10 80       	push   $0x8010d680
801009fa:	e8 94 48 00 00       	call   80105293 <release>
801009ff:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
80100a02:	83 ec 0c             	sub    $0xc,%esp
80100a05:	ff 75 08             	pushl  0x8(%ebp)
80100a08:	e8 d0 0f 00 00       	call   801019dd <ilock>
80100a0d:	83 c4 10             	add    $0x10,%esp
        return -1;
80100a10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a15:	e9 ab 00 00 00       	jmp    80100ac5 <consoleread+0x113>
      }
      sleep(&input.r, &cons.lock);
80100a1a:	83 ec 08             	sub    $0x8,%esp
80100a1d:	68 80 d6 10 80       	push   $0x8010d680
80100a22:	68 e0 18 11 80       	push   $0x801118e0
80100a27:	e8 e9 44 00 00       	call   80104f15 <sleep>
80100a2c:	83 c4 10             	add    $0x10,%esp
    while (input.r == input.w) {
80100a2f:	8b 15 e0 18 11 80    	mov    0x801118e0,%edx
80100a35:	a1 e4 18 11 80       	mov    0x801118e4,%eax
80100a3a:	39 c2                	cmp    %eax,%edx
80100a3c:	74 a7                	je     801009e5 <consoleread+0x33>
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100a3e:	a1 e0 18 11 80       	mov    0x801118e0,%eax
80100a43:	8d 50 01             	lea    0x1(%eax),%edx
80100a46:	89 15 e0 18 11 80    	mov    %edx,0x801118e0
80100a4c:	83 e0 7f             	and    $0x7f,%eax
80100a4f:	0f b6 80 60 18 11 80 	movzbl -0x7feee7a0(%eax),%eax
80100a56:	0f be c0             	movsbl %al,%eax
80100a59:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (c == C('D')) { // EOF
80100a5c:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a60:	75 17                	jne    80100a79 <consoleread+0xc7>
      if (n < target) {
80100a62:	8b 45 10             	mov    0x10(%ebp),%eax
80100a65:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80100a68:	76 2f                	jbe    80100a99 <consoleread+0xe7>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a6a:	a1 e0 18 11 80       	mov    0x801118e0,%eax
80100a6f:	83 e8 01             	sub    $0x1,%eax
80100a72:	a3 e0 18 11 80       	mov    %eax,0x801118e0
      }
      break;
80100a77:	eb 20                	jmp    80100a99 <consoleread+0xe7>
    }
    *dst++ = c;
80100a79:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a7c:	8d 50 01             	lea    0x1(%eax),%edx
80100a7f:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a82:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a85:	88 10                	mov    %dl,(%eax)
    --n;
80100a87:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if (c == '\n')
80100a8b:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a8f:	74 0b                	je     80100a9c <consoleread+0xea>
  while (n > 0) {
80100a91:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a95:	7f 98                	jg     80100a2f <consoleread+0x7d>
80100a97:	eb 04                	jmp    80100a9d <consoleread+0xeb>
      break;
80100a99:	90                   	nop
80100a9a:	eb 01                	jmp    80100a9d <consoleread+0xeb>
      break;
80100a9c:	90                   	nop
  }
  release(&cons.lock);
80100a9d:	83 ec 0c             	sub    $0xc,%esp
80100aa0:	68 80 d6 10 80       	push   $0x8010d680
80100aa5:	e8 e9 47 00 00       	call   80105293 <release>
80100aaa:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100aad:	83 ec 0c             	sub    $0xc,%esp
80100ab0:	ff 75 08             	pushl  0x8(%ebp)
80100ab3:	e8 25 0f 00 00       	call   801019dd <ilock>
80100ab8:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100abb:	8b 45 10             	mov    0x10(%ebp),%eax
80100abe:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100ac1:	29 c2                	sub    %eax,%edx
80100ac3:	89 d0                	mov    %edx,%eax
}
80100ac5:	c9                   	leave  
80100ac6:	c3                   	ret    

80100ac7 <consolewrite>:

int consolewrite(struct inode *ip, char *buf, int n) {
80100ac7:	f3 0f 1e fb          	endbr32 
80100acb:	55                   	push   %ebp
80100acc:	89 e5                	mov    %esp,%ebp
80100ace:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100ad1:	83 ec 0c             	sub    $0xc,%esp
80100ad4:	ff 75 08             	pushl  0x8(%ebp)
80100ad7:	e8 63 10 00 00       	call   80101b3f <iunlock>
80100adc:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100adf:	83 ec 0c             	sub    $0xc,%esp
80100ae2:	68 80 d6 10 80       	push   $0x8010d680
80100ae7:	e8 3c 47 00 00       	call   80105228 <acquire>
80100aec:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < n; i++)
80100aef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100af6:	eb 21                	jmp    80100b19 <consolewrite+0x52>
    consputc(buf[i] & 0xff);
80100af8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100afb:	8b 45 0c             	mov    0xc(%ebp),%eax
80100afe:	01 d0                	add    %edx,%eax
80100b00:	0f b6 00             	movzbl (%eax),%eax
80100b03:	0f be c0             	movsbl %al,%eax
80100b06:	0f b6 c0             	movzbl %al,%eax
80100b09:	83 ec 0c             	sub    $0xc,%esp
80100b0c:	50                   	push   %eax
80100b0d:	e8 8d fc ff ff       	call   8010079f <consputc>
80100b12:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < n; i++)
80100b15:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b1c:	3b 45 10             	cmp    0x10(%ebp),%eax
80100b1f:	7c d7                	jl     80100af8 <consolewrite+0x31>
  release(&cons.lock);
80100b21:	83 ec 0c             	sub    $0xc,%esp
80100b24:	68 80 d6 10 80       	push   $0x8010d680
80100b29:	e8 65 47 00 00       	call   80105293 <release>
80100b2e:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b31:	83 ec 0c             	sub    $0xc,%esp
80100b34:	ff 75 08             	pushl  0x8(%ebp)
80100b37:	e8 a1 0e 00 00       	call   801019dd <ilock>
80100b3c:	83 c4 10             	add    $0x10,%esp

  return n;
80100b3f:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100b42:	c9                   	leave  
80100b43:	c3                   	ret    

80100b44 <consoleinit>:

void consoleinit(void) {
80100b44:	f3 0f 1e fb          	endbr32 
80100b48:	55                   	push   %ebp
80100b49:	89 e5                	mov    %esp,%ebp
80100b4b:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100b4e:	83 ec 08             	sub    $0x8,%esp
80100b51:	68 62 9e 10 80       	push   $0x80109e62
80100b56:	68 80 d6 10 80       	push   $0x8010d680
80100b5b:	e8 a2 46 00 00       	call   80105202 <initlock>
80100b60:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b63:	c7 05 ac 22 11 80 c7 	movl   $0x80100ac7,0x801122ac
80100b6a:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b6d:	c7 05 a8 22 11 80 b2 	movl   $0x801009b2,0x801122a8
80100b74:	09 10 80 
  cons.locking = 1;
80100b77:	c7 05 b4 d6 10 80 01 	movl   $0x1,0x8010d6b4
80100b7e:	00 00 00 

  picenable(IRQ_KBD);
80100b81:	83 ec 0c             	sub    $0xc,%esp
80100b84:	6a 01                	push   $0x1
80100b86:	e8 1a 35 00 00       	call   801040a5 <picenable>
80100b8b:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100b8e:	83 ec 08             	sub    $0x8,%esp
80100b91:	6a 00                	push   $0x0
80100b93:	6a 01                	push   $0x1
80100b95:	e8 08 20 00 00       	call   80102ba2 <ioapicenable>
80100b9a:	83 c4 10             	add    $0x10,%esp
}
80100b9d:	90                   	nop
80100b9e:	c9                   	leave  
80100b9f:	c3                   	ret    

80100ba0 <exec>:
#include "kernel/proc.h"
#include "kernel/defs.h"
#include "kernel/x86.h"
#include "kernel/elf.h"

int exec(char *path, char **argv) {
80100ba0:	f3 0f 1e fb          	endbr32 
80100ba4:	55                   	push   %ebp
80100ba5:	89 e5                	mov    %esp,%ebp
80100ba7:	81 ec 18 01 00 00    	sub    $0x118,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100bad:	e8 b7 2a 00 00       	call   80103669 <begin_op>
  if ((ip = namei(path)) == 0) {
80100bb2:	83 ec 0c             	sub    $0xc,%esp
80100bb5:	ff 75 08             	pushl  0x8(%ebp)
80100bb8:	e8 09 1a 00 00       	call   801025c6 <namei>
80100bbd:	83 c4 10             	add    $0x10,%esp
80100bc0:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100bc3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100bc7:	75 0f                	jne    80100bd8 <exec+0x38>
    end_op();
80100bc9:	e8 2b 2b 00 00       	call   801036f9 <end_op>
    return -1;
80100bce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bd3:	e9 ce 03 00 00       	jmp    80100fa6 <exec+0x406>
  }
  ilock(ip);
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	ff 75 d8             	pushl  -0x28(%ebp)
80100bde:	e8 fa 0d 00 00       	call   801019dd <ilock>
80100be3:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100be6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if (readi(ip, (char *)&elf, 0, sizeof(elf)) < sizeof(elf))
80100bed:	6a 34                	push   $0x34
80100bef:	6a 00                	push   $0x0
80100bf1:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100bf7:	50                   	push   %eax
80100bf8:	ff 75 d8             	pushl  -0x28(%ebp)
80100bfb:	e8 62 13 00 00       	call   80101f62 <readi>
80100c00:	83 c4 10             	add    $0x10,%esp
80100c03:	83 f8 33             	cmp    $0x33,%eax
80100c06:	0f 86 49 03 00 00    	jbe    80100f55 <exec+0x3b5>
    goto bad;
  if (elf.magic != ELF_MAGIC)
80100c0c:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100c12:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100c17:	0f 85 3b 03 00 00    	jne    80100f58 <exec+0x3b8>
    goto bad;

  if ((pgdir = setupkvm()) == 0)
80100c1d:	e8 58 89 00 00       	call   8010957a <setupkvm>
80100c22:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100c25:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100c29:	0f 84 2c 03 00 00    	je     80100f5b <exec+0x3bb>
    goto bad;

  // Load program into memory.
  sz = 0;
80100c2f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
80100c36:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100c3d:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100c43:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c46:	e9 ab 00 00 00       	jmp    80100cf6 <exec+0x156>
    if (readi(ip, (char *)&ph, off, sizeof(ph)) != sizeof(ph))
80100c4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c4e:	6a 20                	push   $0x20
80100c50:	50                   	push   %eax
80100c51:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100c57:	50                   	push   %eax
80100c58:	ff 75 d8             	pushl  -0x28(%ebp)
80100c5b:	e8 02 13 00 00       	call   80101f62 <readi>
80100c60:	83 c4 10             	add    $0x10,%esp
80100c63:	83 f8 20             	cmp    $0x20,%eax
80100c66:	0f 85 f2 02 00 00    	jne    80100f5e <exec+0x3be>
      goto bad;
    if (ph.type != ELF_PROG_LOAD)
80100c6c:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100c72:	83 f8 01             	cmp    $0x1,%eax
80100c75:	75 71                	jne    80100ce8 <exec+0x148>
      continue;
    if (ph.memsz < ph.filesz)
80100c77:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100c7d:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c83:	39 c2                	cmp    %eax,%edx
80100c85:	0f 82 d6 02 00 00    	jb     80100f61 <exec+0x3c1>
      goto bad;
    if ((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c8b:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c91:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c97:	01 d0                	add    %edx,%eax
80100c99:	83 ec 04             	sub    $0x4,%esp
80100c9c:	50                   	push   %eax
80100c9d:	ff 75 e0             	pushl  -0x20(%ebp)
80100ca0:	ff 75 d4             	pushl  -0x2c(%ebp)
80100ca3:	e8 92 8c 00 00       	call   8010993a <allocuvm>
80100ca8:	83 c4 10             	add    $0x10,%esp
80100cab:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100cae:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100cb2:	0f 84 ac 02 00 00    	je     80100f64 <exec+0x3c4>
      goto bad;
    if (loaduvm(pgdir, (char *)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100cb8:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100cbe:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100cc4:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100cca:	83 ec 0c             	sub    $0xc,%esp
80100ccd:	52                   	push   %edx
80100cce:	50                   	push   %eax
80100ccf:	ff 75 d8             	pushl  -0x28(%ebp)
80100cd2:	51                   	push   %ecx
80100cd3:	ff 75 d4             	pushl  -0x2c(%ebp)
80100cd6:	e8 84 8b 00 00       	call   8010985f <loaduvm>
80100cdb:	83 c4 20             	add    $0x20,%esp
80100cde:	85 c0                	test   %eax,%eax
80100ce0:	0f 88 81 02 00 00    	js     80100f67 <exec+0x3c7>
80100ce6:	eb 01                	jmp    80100ce9 <exec+0x149>
      continue;
80100ce8:	90                   	nop
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
80100ce9:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100ced:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100cf0:	83 c0 20             	add    $0x20,%eax
80100cf3:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100cf6:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100cfd:	0f b7 c0             	movzwl %ax,%eax
80100d00:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80100d03:	0f 8c 42 ff ff ff    	jl     80100c4b <exec+0xab>
      goto bad;
  }
  iunlockput(ip);
80100d09:	83 ec 0c             	sub    $0xc,%esp
80100d0c:	ff 75 d8             	pushl  -0x28(%ebp)
80100d0f:	e8 95 0f 00 00       	call   80101ca9 <iunlockput>
80100d14:	83 c4 10             	add    $0x10,%esp
  end_op();
80100d17:	e8 dd 29 00 00       	call   801036f9 <end_op>
  ip = 0;
80100d1c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100d23:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d26:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d2b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100d30:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if ((sz = allocuvm(pgdir, sz, sz + 2 * PGSIZE)) == 0)
80100d33:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d36:	05 00 20 00 00       	add    $0x2000,%eax
80100d3b:	83 ec 04             	sub    $0x4,%esp
80100d3e:	50                   	push   %eax
80100d3f:	ff 75 e0             	pushl  -0x20(%ebp)
80100d42:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d45:	e8 f0 8b 00 00       	call   8010993a <allocuvm>
80100d4a:	83 c4 10             	add    $0x10,%esp
80100d4d:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d50:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d54:	0f 84 10 02 00 00    	je     80100f6a <exec+0x3ca>
    goto bad;
  clearpteu(pgdir, (char *)(sz - 2 * PGSIZE));
80100d5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d5d:	2d 00 20 00 00       	sub    $0x2000,%eax
80100d62:	83 ec 08             	sub    $0x8,%esp
80100d65:	50                   	push   %eax
80100d66:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d69:	e8 fc 8d 00 00       	call   80109b6a <clearpteu>
80100d6e:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100d71:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d74:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for (argc = 0; argv[argc]; argc++) {
80100d77:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d7e:	e9 96 00 00 00       	jmp    80100e19 <exec+0x279>
    if (argc >= MAXARG)
80100d83:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d87:	0f 87 e0 01 00 00    	ja     80100f6d <exec+0x3cd>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d90:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d97:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d9a:	01 d0                	add    %edx,%eax
80100d9c:	8b 00                	mov    (%eax),%eax
80100d9e:	83 ec 0c             	sub    $0xc,%esp
80100da1:	50                   	push   %eax
80100da2:	e8 66 49 00 00       	call   8010570d <strlen>
80100da7:	83 c4 10             	add    $0x10,%esp
80100daa:	89 c2                	mov    %eax,%edx
80100dac:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100daf:	29 d0                	sub    %edx,%eax
80100db1:	83 e8 01             	sub    $0x1,%eax
80100db4:	83 e0 fc             	and    $0xfffffffc,%eax
80100db7:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100dba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dbd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dc7:	01 d0                	add    %edx,%eax
80100dc9:	8b 00                	mov    (%eax),%eax
80100dcb:	83 ec 0c             	sub    $0xc,%esp
80100dce:	50                   	push   %eax
80100dcf:	e8 39 49 00 00       	call   8010570d <strlen>
80100dd4:	83 c4 10             	add    $0x10,%esp
80100dd7:	83 c0 01             	add    $0x1,%eax
80100dda:	89 c1                	mov    %eax,%ecx
80100ddc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ddf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100de6:	8b 45 0c             	mov    0xc(%ebp),%eax
80100de9:	01 d0                	add    %edx,%eax
80100deb:	8b 00                	mov    (%eax),%eax
80100ded:	51                   	push   %ecx
80100dee:	50                   	push   %eax
80100def:	ff 75 dc             	pushl  -0x24(%ebp)
80100df2:	ff 75 d4             	pushl  -0x2c(%ebp)
80100df5:	e8 32 8f 00 00       	call   80109d2c <copyout>
80100dfa:	83 c4 10             	add    $0x10,%esp
80100dfd:	85 c0                	test   %eax,%eax
80100dff:	0f 88 6b 01 00 00    	js     80100f70 <exec+0x3d0>
      goto bad;
    ustack[3 + argc] = sp;
80100e05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e08:	8d 50 03             	lea    0x3(%eax),%edx
80100e0b:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e0e:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
  for (argc = 0; argv[argc]; argc++) {
80100e15:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100e19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e1c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e23:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e26:	01 d0                	add    %edx,%eax
80100e28:	8b 00                	mov    (%eax),%eax
80100e2a:	85 c0                	test   %eax,%eax
80100e2c:	0f 85 51 ff ff ff    	jne    80100d83 <exec+0x1e3>
  }
  ustack[3 + argc] = 0;
80100e32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e35:	83 c0 03             	add    $0x3,%eax
80100e38:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100e3f:	00 00 00 00 

  ustack[0] = 0xffffffff; // fake return PC
80100e43:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100e4a:	ff ff ff 
  ustack[1] = argc;
80100e4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e50:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc + 1) * 4; // argv pointer
80100e56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e59:	83 c0 01             	add    $0x1,%eax
80100e5c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e63:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e66:	29 d0                	sub    %edx,%eax
80100e68:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3 + argc + 1) * 4;
80100e6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e71:	83 c0 04             	add    $0x4,%eax
80100e74:	c1 e0 02             	shl    $0x2,%eax
80100e77:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0)
80100e7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e7d:	83 c0 04             	add    $0x4,%eax
80100e80:	c1 e0 02             	shl    $0x2,%eax
80100e83:	50                   	push   %eax
80100e84:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e8a:	50                   	push   %eax
80100e8b:	ff 75 dc             	pushl  -0x24(%ebp)
80100e8e:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e91:	e8 96 8e 00 00       	call   80109d2c <copyout>
80100e96:	83 c4 10             	add    $0x10,%esp
80100e99:	85 c0                	test   %eax,%eax
80100e9b:	0f 88 d2 00 00 00    	js     80100f73 <exec+0x3d3>
    goto bad;

  // Save program name for debugging.
  for (last = s = path; *s; s++)
80100ea1:	8b 45 08             	mov    0x8(%ebp),%eax
80100ea4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100eaa:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100ead:	eb 17                	jmp    80100ec6 <exec+0x326>
    if (*s == '/')
80100eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100eb2:	0f b6 00             	movzbl (%eax),%eax
80100eb5:	3c 2f                	cmp    $0x2f,%al
80100eb7:	75 09                	jne    80100ec2 <exec+0x322>
      last = s + 1;
80100eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ebc:	83 c0 01             	add    $0x1,%eax
80100ebf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for (last = s = path; *s; s++)
80100ec2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ec9:	0f b6 00             	movzbl (%eax),%eax
80100ecc:	84 c0                	test   %al,%al
80100ece:	75 df                	jne    80100eaf <exec+0x30f>
  safestrcpy(proc->name, last, sizeof(proc->name));
80100ed0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ed6:	83 c0 6c             	add    $0x6c,%eax
80100ed9:	83 ec 04             	sub    $0x4,%esp
80100edc:	6a 10                	push   $0x10
80100ede:	ff 75 f0             	pushl  -0x10(%ebp)
80100ee1:	50                   	push   %eax
80100ee2:	e8 d8 47 00 00       	call   801056bf <safestrcpy>
80100ee7:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100eea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ef0:	8b 40 04             	mov    0x4(%eax),%eax
80100ef3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100ef6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100efc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100eff:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100f02:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f08:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100f0b:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry; // main
80100f0d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f13:	8b 40 18             	mov    0x18(%eax),%eax
80100f16:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100f1c:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100f1f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f25:	8b 40 18             	mov    0x18(%eax),%eax
80100f28:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f2b:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100f2e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f34:	83 ec 0c             	sub    $0xc,%esp
80100f37:	50                   	push   %eax
80100f38:	e8 30 87 00 00       	call   8010966d <switchuvm>
80100f3d:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f40:	83 ec 0c             	sub    $0xc,%esp
80100f43:	ff 75 d0             	pushl  -0x30(%ebp)
80100f46:	e8 7b 8b 00 00       	call   80109ac6 <freevm>
80100f4b:	83 c4 10             	add    $0x10,%esp
  return 0;
80100f4e:	b8 00 00 00 00       	mov    $0x0,%eax
80100f53:	eb 51                	jmp    80100fa6 <exec+0x406>
    goto bad;
80100f55:	90                   	nop
80100f56:	eb 1c                	jmp    80100f74 <exec+0x3d4>
    goto bad;
80100f58:	90                   	nop
80100f59:	eb 19                	jmp    80100f74 <exec+0x3d4>
    goto bad;
80100f5b:	90                   	nop
80100f5c:	eb 16                	jmp    80100f74 <exec+0x3d4>
      goto bad;
80100f5e:	90                   	nop
80100f5f:	eb 13                	jmp    80100f74 <exec+0x3d4>
      goto bad;
80100f61:	90                   	nop
80100f62:	eb 10                	jmp    80100f74 <exec+0x3d4>
      goto bad;
80100f64:	90                   	nop
80100f65:	eb 0d                	jmp    80100f74 <exec+0x3d4>
      goto bad;
80100f67:	90                   	nop
80100f68:	eb 0a                	jmp    80100f74 <exec+0x3d4>
    goto bad;
80100f6a:	90                   	nop
80100f6b:	eb 07                	jmp    80100f74 <exec+0x3d4>
      goto bad;
80100f6d:	90                   	nop
80100f6e:	eb 04                	jmp    80100f74 <exec+0x3d4>
      goto bad;
80100f70:	90                   	nop
80100f71:	eb 01                	jmp    80100f74 <exec+0x3d4>
    goto bad;
80100f73:	90                   	nop

bad:
  if (pgdir)
80100f74:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f78:	74 0e                	je     80100f88 <exec+0x3e8>
    freevm(pgdir);
80100f7a:	83 ec 0c             	sub    $0xc,%esp
80100f7d:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f80:	e8 41 8b 00 00       	call   80109ac6 <freevm>
80100f85:	83 c4 10             	add    $0x10,%esp
  if (ip) {
80100f88:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f8c:	74 13                	je     80100fa1 <exec+0x401>
    iunlockput(ip);
80100f8e:	83 ec 0c             	sub    $0xc,%esp
80100f91:	ff 75 d8             	pushl  -0x28(%ebp)
80100f94:	e8 10 0d 00 00       	call   80101ca9 <iunlockput>
80100f99:	83 c4 10             	add    $0x10,%esp
    end_op();
80100f9c:	e8 58 27 00 00       	call   801036f9 <end_op>
  }
  return -1;
80100fa1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fa6:	c9                   	leave  
80100fa7:	c3                   	ret    

80100fa8 <fileinit>:
struct {
  struct spinlock lock;
  struct file file[NFILE];
} ftable;

void fileinit(void) { initlock(&ftable.lock, "ftable"); }
80100fa8:	f3 0f 1e fb          	endbr32 
80100fac:	55                   	push   %ebp
80100fad:	89 e5                	mov    %esp,%ebp
80100faf:	83 ec 08             	sub    $0x8,%esp
80100fb2:	83 ec 08             	sub    $0x8,%esp
80100fb5:	68 6a 9e 10 80       	push   $0x80109e6a
80100fba:	68 00 19 11 80       	push   $0x80111900
80100fbf:	e8 3e 42 00 00       	call   80105202 <initlock>
80100fc4:	83 c4 10             	add    $0x10,%esp
80100fc7:	90                   	nop
80100fc8:	c9                   	leave  
80100fc9:	c3                   	ret    

80100fca <filealloc>:

// Allocate a file structure.
struct file *filealloc(void) {
80100fca:	f3 0f 1e fb          	endbr32 
80100fce:	55                   	push   %ebp
80100fcf:	89 e5                	mov    %esp,%ebp
80100fd1:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80100fd4:	83 ec 0c             	sub    $0xc,%esp
80100fd7:	68 00 19 11 80       	push   $0x80111900
80100fdc:	e8 47 42 00 00       	call   80105228 <acquire>
80100fe1:	83 c4 10             	add    $0x10,%esp
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
80100fe4:	c7 45 f4 34 19 11 80 	movl   $0x80111934,-0xc(%ebp)
80100feb:	eb 2d                	jmp    8010101a <filealloc+0x50>
    if (f->ref == 0) {
80100fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ff0:	8b 40 04             	mov    0x4(%eax),%eax
80100ff3:	85 c0                	test   %eax,%eax
80100ff5:	75 1f                	jne    80101016 <filealloc+0x4c>
      f->ref = 1;
80100ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ffa:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80101001:	83 ec 0c             	sub    $0xc,%esp
80101004:	68 00 19 11 80       	push   $0x80111900
80101009:	e8 85 42 00 00       	call   80105293 <release>
8010100e:	83 c4 10             	add    $0x10,%esp
      return f;
80101011:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101014:	eb 23                	jmp    80101039 <filealloc+0x6f>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
80101016:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
8010101a:	b8 94 22 11 80       	mov    $0x80112294,%eax
8010101f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80101022:	72 c9                	jb     80100fed <filealloc+0x23>
    }
  }
  release(&ftable.lock);
80101024:	83 ec 0c             	sub    $0xc,%esp
80101027:	68 00 19 11 80       	push   $0x80111900
8010102c:	e8 62 42 00 00       	call   80105293 <release>
80101031:	83 c4 10             	add    $0x10,%esp
  return 0;
80101034:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101039:	c9                   	leave  
8010103a:	c3                   	ret    

8010103b <filedup>:

// Increment ref count for file f.
struct file *filedup(struct file *f) {
8010103b:	f3 0f 1e fb          	endbr32 
8010103f:	55                   	push   %ebp
80101040:	89 e5                	mov    %esp,%ebp
80101042:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80101045:	83 ec 0c             	sub    $0xc,%esp
80101048:	68 00 19 11 80       	push   $0x80111900
8010104d:	e8 d6 41 00 00       	call   80105228 <acquire>
80101052:	83 c4 10             	add    $0x10,%esp
  if (f->ref < 1)
80101055:	8b 45 08             	mov    0x8(%ebp),%eax
80101058:	8b 40 04             	mov    0x4(%eax),%eax
8010105b:	85 c0                	test   %eax,%eax
8010105d:	7f 0d                	jg     8010106c <filedup+0x31>
    panic("filedup");
8010105f:	83 ec 0c             	sub    $0xc,%esp
80101062:	68 71 9e 10 80       	push   $0x80109e71
80101067:	e8 f7 f4 ff ff       	call   80100563 <panic>
  f->ref++;
8010106c:	8b 45 08             	mov    0x8(%ebp),%eax
8010106f:	8b 40 04             	mov    0x4(%eax),%eax
80101072:	8d 50 01             	lea    0x1(%eax),%edx
80101075:	8b 45 08             	mov    0x8(%ebp),%eax
80101078:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	68 00 19 11 80       	push   $0x80111900
80101083:	e8 0b 42 00 00       	call   80105293 <release>
80101088:	83 c4 10             	add    $0x10,%esp
  return f;
8010108b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010108e:	c9                   	leave  
8010108f:	c3                   	ret    

80101090 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void fileclose(struct file *f) {
80101090:	f3 0f 1e fb          	endbr32 
80101094:	55                   	push   %ebp
80101095:	89 e5                	mov    %esp,%ebp
80101097:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
8010109a:	83 ec 0c             	sub    $0xc,%esp
8010109d:	68 00 19 11 80       	push   $0x80111900
801010a2:	e8 81 41 00 00       	call   80105228 <acquire>
801010a7:	83 c4 10             	add    $0x10,%esp
  if (f->ref < 1)
801010aa:	8b 45 08             	mov    0x8(%ebp),%eax
801010ad:	8b 40 04             	mov    0x4(%eax),%eax
801010b0:	85 c0                	test   %eax,%eax
801010b2:	7f 0d                	jg     801010c1 <fileclose+0x31>
    panic("fileclose");
801010b4:	83 ec 0c             	sub    $0xc,%esp
801010b7:	68 79 9e 10 80       	push   $0x80109e79
801010bc:	e8 a2 f4 ff ff       	call   80100563 <panic>
  if (--f->ref > 0) {
801010c1:	8b 45 08             	mov    0x8(%ebp),%eax
801010c4:	8b 40 04             	mov    0x4(%eax),%eax
801010c7:	8d 50 ff             	lea    -0x1(%eax),%edx
801010ca:	8b 45 08             	mov    0x8(%ebp),%eax
801010cd:	89 50 04             	mov    %edx,0x4(%eax)
801010d0:	8b 45 08             	mov    0x8(%ebp),%eax
801010d3:	8b 40 04             	mov    0x4(%eax),%eax
801010d6:	85 c0                	test   %eax,%eax
801010d8:	7e 15                	jle    801010ef <fileclose+0x5f>
    release(&ftable.lock);
801010da:	83 ec 0c             	sub    $0xc,%esp
801010dd:	68 00 19 11 80       	push   $0x80111900
801010e2:	e8 ac 41 00 00       	call   80105293 <release>
801010e7:	83 c4 10             	add    $0x10,%esp
801010ea:	e9 8b 00 00 00       	jmp    8010117a <fileclose+0xea>
    return;
  }
  ff = *f;
801010ef:	8b 45 08             	mov    0x8(%ebp),%eax
801010f2:	8b 10                	mov    (%eax),%edx
801010f4:	89 55 e0             	mov    %edx,-0x20(%ebp)
801010f7:	8b 50 04             	mov    0x4(%eax),%edx
801010fa:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801010fd:	8b 50 08             	mov    0x8(%eax),%edx
80101100:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101103:	8b 50 0c             	mov    0xc(%eax),%edx
80101106:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101109:	8b 50 10             	mov    0x10(%eax),%edx
8010110c:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010110f:	8b 40 14             	mov    0x14(%eax),%eax
80101112:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101115:	8b 45 08             	mov    0x8(%ebp),%eax
80101118:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
8010111f:	8b 45 08             	mov    0x8(%ebp),%eax
80101122:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101128:	83 ec 0c             	sub    $0xc,%esp
8010112b:	68 00 19 11 80       	push   $0x80111900
80101130:	e8 5e 41 00 00       	call   80105293 <release>
80101135:	83 c4 10             	add    $0x10,%esp

  if (ff.type == FD_PIPE)
80101138:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010113b:	83 f8 01             	cmp    $0x1,%eax
8010113e:	75 19                	jne    80101159 <fileclose+0xc9>
    pipeclose(ff.pipe, ff.writable);
80101140:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101144:	0f be d0             	movsbl %al,%edx
80101147:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010114a:	83 ec 08             	sub    $0x8,%esp
8010114d:	52                   	push   %edx
8010114e:	50                   	push   %eax
8010114f:	e8 c5 31 00 00       	call   80104319 <pipeclose>
80101154:	83 c4 10             	add    $0x10,%esp
80101157:	eb 21                	jmp    8010117a <fileclose+0xea>
  else if (ff.type == FD_INODE) {
80101159:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010115c:	83 f8 02             	cmp    $0x2,%eax
8010115f:	75 19                	jne    8010117a <fileclose+0xea>
    begin_op();
80101161:	e8 03 25 00 00       	call   80103669 <begin_op>
    iput(ff.ip);
80101166:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101169:	83 ec 0c             	sub    $0xc,%esp
8010116c:	50                   	push   %eax
8010116d:	e8 43 0a 00 00       	call   80101bb5 <iput>
80101172:	83 c4 10             	add    $0x10,%esp
    end_op();
80101175:	e8 7f 25 00 00       	call   801036f9 <end_op>
  }
}
8010117a:	c9                   	leave  
8010117b:	c3                   	ret    

8010117c <filestat>:

// Get metadata about file f.
int filestat(struct file *f, struct stat *st) {
8010117c:	f3 0f 1e fb          	endbr32 
80101180:	55                   	push   %ebp
80101181:	89 e5                	mov    %esp,%ebp
80101183:	83 ec 08             	sub    $0x8,%esp
  if (f->type == FD_INODE) {
80101186:	8b 45 08             	mov    0x8(%ebp),%eax
80101189:	8b 00                	mov    (%eax),%eax
8010118b:	83 f8 02             	cmp    $0x2,%eax
8010118e:	75 40                	jne    801011d0 <filestat+0x54>
    ilock(f->ip);
80101190:	8b 45 08             	mov    0x8(%ebp),%eax
80101193:	8b 40 10             	mov    0x10(%eax),%eax
80101196:	83 ec 0c             	sub    $0xc,%esp
80101199:	50                   	push   %eax
8010119a:	e8 3e 08 00 00       	call   801019dd <ilock>
8010119f:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
801011a2:	8b 45 08             	mov    0x8(%ebp),%eax
801011a5:	8b 40 10             	mov    0x10(%eax),%eax
801011a8:	83 ec 08             	sub    $0x8,%esp
801011ab:	ff 75 0c             	pushl  0xc(%ebp)
801011ae:	50                   	push   %eax
801011af:	e8 64 0d 00 00       	call   80101f18 <stati>
801011b4:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
801011b7:	8b 45 08             	mov    0x8(%ebp),%eax
801011ba:	8b 40 10             	mov    0x10(%eax),%eax
801011bd:	83 ec 0c             	sub    $0xc,%esp
801011c0:	50                   	push   %eax
801011c1:	e8 79 09 00 00       	call   80101b3f <iunlock>
801011c6:	83 c4 10             	add    $0x10,%esp
    return 0;
801011c9:	b8 00 00 00 00       	mov    $0x0,%eax
801011ce:	eb 05                	jmp    801011d5 <filestat+0x59>
  }
  return -1;
801011d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801011d5:	c9                   	leave  
801011d6:	c3                   	ret    

801011d7 <fileread>:

// Read from file f.
int fileread(struct file *f, char *addr, int n) {
801011d7:	f3 0f 1e fb          	endbr32 
801011db:	55                   	push   %ebp
801011dc:	89 e5                	mov    %esp,%ebp
801011de:	83 ec 18             	sub    $0x18,%esp
  int r;

  if (f->readable == 0)
801011e1:	8b 45 08             	mov    0x8(%ebp),%eax
801011e4:	0f b6 40 08          	movzbl 0x8(%eax),%eax
801011e8:	84 c0                	test   %al,%al
801011ea:	75 0a                	jne    801011f6 <fileread+0x1f>
    return -1;
801011ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011f1:	e9 9b 00 00 00       	jmp    80101291 <fileread+0xba>
  if (f->type == FD_PIPE)
801011f6:	8b 45 08             	mov    0x8(%ebp),%eax
801011f9:	8b 00                	mov    (%eax),%eax
801011fb:	83 f8 01             	cmp    $0x1,%eax
801011fe:	75 1a                	jne    8010121a <fileread+0x43>
    return piperead(f->pipe, addr, n);
80101200:	8b 45 08             	mov    0x8(%ebp),%eax
80101203:	8b 40 0c             	mov    0xc(%eax),%eax
80101206:	83 ec 04             	sub    $0x4,%esp
80101209:	ff 75 10             	pushl  0x10(%ebp)
8010120c:	ff 75 0c             	pushl  0xc(%ebp)
8010120f:	50                   	push   %eax
80101210:	e8 ba 32 00 00       	call   801044cf <piperead>
80101215:	83 c4 10             	add    $0x10,%esp
80101218:	eb 77                	jmp    80101291 <fileread+0xba>
  if (f->type == FD_INODE) {
8010121a:	8b 45 08             	mov    0x8(%ebp),%eax
8010121d:	8b 00                	mov    (%eax),%eax
8010121f:	83 f8 02             	cmp    $0x2,%eax
80101222:	75 60                	jne    80101284 <fileread+0xad>
    ilock(f->ip);
80101224:	8b 45 08             	mov    0x8(%ebp),%eax
80101227:	8b 40 10             	mov    0x10(%eax),%eax
8010122a:	83 ec 0c             	sub    $0xc,%esp
8010122d:	50                   	push   %eax
8010122e:	e8 aa 07 00 00       	call   801019dd <ilock>
80101233:	83 c4 10             	add    $0x10,%esp
    if ((r = readi(f->ip, addr, f->off, n)) > 0)
80101236:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101239:	8b 45 08             	mov    0x8(%ebp),%eax
8010123c:	8b 50 14             	mov    0x14(%eax),%edx
8010123f:	8b 45 08             	mov    0x8(%ebp),%eax
80101242:	8b 40 10             	mov    0x10(%eax),%eax
80101245:	51                   	push   %ecx
80101246:	52                   	push   %edx
80101247:	ff 75 0c             	pushl  0xc(%ebp)
8010124a:	50                   	push   %eax
8010124b:	e8 12 0d 00 00       	call   80101f62 <readi>
80101250:	83 c4 10             	add    $0x10,%esp
80101253:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101256:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010125a:	7e 11                	jle    8010126d <fileread+0x96>
      f->off += r;
8010125c:	8b 45 08             	mov    0x8(%ebp),%eax
8010125f:	8b 50 14             	mov    0x14(%eax),%edx
80101262:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101265:	01 c2                	add    %eax,%edx
80101267:	8b 45 08             	mov    0x8(%ebp),%eax
8010126a:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
8010126d:	8b 45 08             	mov    0x8(%ebp),%eax
80101270:	8b 40 10             	mov    0x10(%eax),%eax
80101273:	83 ec 0c             	sub    $0xc,%esp
80101276:	50                   	push   %eax
80101277:	e8 c3 08 00 00       	call   80101b3f <iunlock>
8010127c:	83 c4 10             	add    $0x10,%esp
    return r;
8010127f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101282:	eb 0d                	jmp    80101291 <fileread+0xba>
  }
  panic("fileread");
80101284:	83 ec 0c             	sub    $0xc,%esp
80101287:	68 83 9e 10 80       	push   $0x80109e83
8010128c:	e8 d2 f2 ff ff       	call   80100563 <panic>
}
80101291:	c9                   	leave  
80101292:	c3                   	ret    

80101293 <filewrite>:

// PAGEBREAK!
// Write to file f.
int filewrite(struct file *f, char *addr, int n) {
80101293:	f3 0f 1e fb          	endbr32 
80101297:	55                   	push   %ebp
80101298:	89 e5                	mov    %esp,%ebp
8010129a:	53                   	push   %ebx
8010129b:	83 ec 14             	sub    $0x14,%esp
  int r;

  if (f->writable == 0)
8010129e:	8b 45 08             	mov    0x8(%ebp),%eax
801012a1:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801012a5:	84 c0                	test   %al,%al
801012a7:	75 0a                	jne    801012b3 <filewrite+0x20>
    return -1;
801012a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012ae:	e9 1b 01 00 00       	jmp    801013ce <filewrite+0x13b>
  if (f->type == FD_PIPE)
801012b3:	8b 45 08             	mov    0x8(%ebp),%eax
801012b6:	8b 00                	mov    (%eax),%eax
801012b8:	83 f8 01             	cmp    $0x1,%eax
801012bb:	75 1d                	jne    801012da <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
801012bd:	8b 45 08             	mov    0x8(%ebp),%eax
801012c0:	8b 40 0c             	mov    0xc(%eax),%eax
801012c3:	83 ec 04             	sub    $0x4,%esp
801012c6:	ff 75 10             	pushl  0x10(%ebp)
801012c9:	ff 75 0c             	pushl  0xc(%ebp)
801012cc:	50                   	push   %eax
801012cd:	e8 f6 30 00 00       	call   801043c8 <pipewrite>
801012d2:	83 c4 10             	add    $0x10,%esp
801012d5:	e9 f4 00 00 00       	jmp    801013ce <filewrite+0x13b>
  if (f->type == FD_INODE) {
801012da:	8b 45 08             	mov    0x8(%ebp),%eax
801012dd:	8b 00                	mov    (%eax),%eax
801012df:	83 f8 02             	cmp    $0x2,%eax
801012e2:	0f 85 d9 00 00 00    	jne    801013c1 <filewrite+0x12e>
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.

    int max = ((LOGSIZE - 1 - 1 - 2) / 2) * 512;
801012e8:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
801012ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (i < n) {
801012f6:	e9 a3 00 00 00       	jmp    8010139e <filewrite+0x10b>
      int n1 = n - i;
801012fb:	8b 45 10             	mov    0x10(%ebp),%eax
801012fe:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101301:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if (n1 > max)
80101304:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101307:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010130a:	7e 06                	jle    80101312 <filewrite+0x7f>
        n1 = max;
8010130c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010130f:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101312:	e8 52 23 00 00       	call   80103669 <begin_op>
      ilock(f->ip);
80101317:	8b 45 08             	mov    0x8(%ebp),%eax
8010131a:	8b 40 10             	mov    0x10(%eax),%eax
8010131d:	83 ec 0c             	sub    $0xc,%esp
80101320:	50                   	push   %eax
80101321:	e8 b7 06 00 00       	call   801019dd <ilock>
80101326:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101329:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010132c:	8b 45 08             	mov    0x8(%ebp),%eax
8010132f:	8b 50 14             	mov    0x14(%eax),%edx
80101332:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101335:	8b 45 0c             	mov    0xc(%ebp),%eax
80101338:	01 c3                	add    %eax,%ebx
8010133a:	8b 45 08             	mov    0x8(%ebp),%eax
8010133d:	8b 40 10             	mov    0x10(%eax),%eax
80101340:	51                   	push   %ecx
80101341:	52                   	push   %edx
80101342:	53                   	push   %ebx
80101343:	50                   	push   %eax
80101344:	e8 72 0d 00 00       	call   801020bb <writei>
80101349:	83 c4 10             	add    $0x10,%esp
8010134c:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010134f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101353:	7e 11                	jle    80101366 <filewrite+0xd3>
        f->off += r;
80101355:	8b 45 08             	mov    0x8(%ebp),%eax
80101358:	8b 50 14             	mov    0x14(%eax),%edx
8010135b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010135e:	01 c2                	add    %eax,%edx
80101360:	8b 45 08             	mov    0x8(%ebp),%eax
80101363:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
80101366:	8b 45 08             	mov    0x8(%ebp),%eax
80101369:	8b 40 10             	mov    0x10(%eax),%eax
8010136c:	83 ec 0c             	sub    $0xc,%esp
8010136f:	50                   	push   %eax
80101370:	e8 ca 07 00 00       	call   80101b3f <iunlock>
80101375:	83 c4 10             	add    $0x10,%esp
      end_op();
80101378:	e8 7c 23 00 00       	call   801036f9 <end_op>

      if (r < 0)
8010137d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101381:	78 29                	js     801013ac <filewrite+0x119>
        break;
      if (r != n1)
80101383:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101386:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80101389:	74 0d                	je     80101398 <filewrite+0x105>
        panic("short filewrite");
8010138b:	83 ec 0c             	sub    $0xc,%esp
8010138e:	68 8c 9e 10 80       	push   $0x80109e8c
80101393:	e8 cb f1 ff ff       	call   80100563 <panic>
      i += r;
80101398:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010139b:	01 45 f4             	add    %eax,-0xc(%ebp)
    while (i < n) {
8010139e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013a1:	3b 45 10             	cmp    0x10(%ebp),%eax
801013a4:	0f 8c 51 ff ff ff    	jl     801012fb <filewrite+0x68>
801013aa:	eb 01                	jmp    801013ad <filewrite+0x11a>
        break;
801013ac:	90                   	nop
    }
    return i == n ? n : -1;
801013ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013b0:	3b 45 10             	cmp    0x10(%ebp),%eax
801013b3:	75 05                	jne    801013ba <filewrite+0x127>
801013b5:	8b 45 10             	mov    0x10(%ebp),%eax
801013b8:	eb 14                	jmp    801013ce <filewrite+0x13b>
801013ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801013bf:	eb 0d                	jmp    801013ce <filewrite+0x13b>
  }
  panic("filewrite");
801013c1:	83 ec 0c             	sub    $0xc,%esp
801013c4:	68 9c 9e 10 80       	push   $0x80109e9c
801013c9:	e8 95 f1 ff ff       	call   80100563 <panic>
}
801013ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801013d1:	c9                   	leave  
801013d2:	c3                   	ret    

801013d3 <readsb>:
#define min(a, b) ((a) < (b) ? (a) : (b))
static void itrunc(struct inode *);
struct superblock sb; // there should be one per dev, but we run with one dev

// Read the super block.
void readsb(int dev, struct superblock *sb) {
801013d3:	f3 0f 1e fb          	endbr32 
801013d7:	55                   	push   %ebp
801013d8:	89 e5                	mov    %esp,%ebp
801013da:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, 1);
801013dd:	8b 45 08             	mov    0x8(%ebp),%eax
801013e0:	83 ec 08             	sub    $0x8,%esp
801013e3:	6a 01                	push   $0x1
801013e5:	50                   	push   %eax
801013e6:	e8 a0 ed ff ff       	call   8010018b <bread>
801013eb:	83 c4 10             	add    $0x10,%esp
801013ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
801013f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013f4:	83 c0 18             	add    $0x18,%eax
801013f7:	83 ec 04             	sub    $0x4,%esp
801013fa:	6a 1c                	push   $0x1c
801013fc:	50                   	push   %eax
801013fd:	ff 75 0c             	pushl  0xc(%ebp)
80101400:	e8 66 41 00 00       	call   8010556b <memmove>
80101405:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101408:	83 ec 0c             	sub    $0xc,%esp
8010140b:	ff 75 f4             	pushl  -0xc(%ebp)
8010140e:	e8 f8 ed ff ff       	call   8010020b <brelse>
80101413:	83 c4 10             	add    $0x10,%esp
}
80101416:	90                   	nop
80101417:	c9                   	leave  
80101418:	c3                   	ret    

80101419 <bzero>:

// Zero a block.
static void bzero(int dev, int bno) {
80101419:	f3 0f 1e fb          	endbr32 
8010141d:	55                   	push   %ebp
8010141e:	89 e5                	mov    %esp,%ebp
80101420:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, bno);
80101423:	8b 55 0c             	mov    0xc(%ebp),%edx
80101426:	8b 45 08             	mov    0x8(%ebp),%eax
80101429:	83 ec 08             	sub    $0x8,%esp
8010142c:	52                   	push   %edx
8010142d:	50                   	push   %eax
8010142e:	e8 58 ed ff ff       	call   8010018b <bread>
80101433:	83 c4 10             	add    $0x10,%esp
80101436:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101439:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010143c:	83 c0 18             	add    $0x18,%eax
8010143f:	83 ec 04             	sub    $0x4,%esp
80101442:	68 00 02 00 00       	push   $0x200
80101447:	6a 00                	push   $0x0
80101449:	50                   	push   %eax
8010144a:	e8 55 40 00 00       	call   801054a4 <memset>
8010144f:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101452:	83 ec 0c             	sub    $0xc,%esp
80101455:	ff 75 f4             	pushl  -0xc(%ebp)
80101458:	e8 55 24 00 00       	call   801038b2 <log_write>
8010145d:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101460:	83 ec 0c             	sub    $0xc,%esp
80101463:	ff 75 f4             	pushl  -0xc(%ebp)
80101466:	e8 a0 ed ff ff       	call   8010020b <brelse>
8010146b:	83 c4 10             	add    $0x10,%esp
}
8010146e:	90                   	nop
8010146f:	c9                   	leave  
80101470:	c3                   	ret    

80101471 <balloc>:

// Blocks.

// Allocate a zeroed disk block.
static uint balloc(uint dev) {
80101471:	f3 0f 1e fb          	endbr32 
80101475:	55                   	push   %ebp
80101476:	89 e5                	mov    %esp,%ebp
80101478:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
8010147b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for (b = 0; b < sb.size; b += BPB) {
80101482:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101489:	e9 13 01 00 00       	jmp    801015a1 <balloc+0x130>
    bp = bread(dev, BBLOCK(b, sb));
8010148e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101491:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80101497:	85 c0                	test   %eax,%eax
80101499:	0f 48 c2             	cmovs  %edx,%eax
8010149c:	c1 f8 0c             	sar    $0xc,%eax
8010149f:	89 c2                	mov    %eax,%edx
801014a1:	a1 18 23 11 80       	mov    0x80112318,%eax
801014a6:	01 d0                	add    %edx,%eax
801014a8:	83 ec 08             	sub    $0x8,%esp
801014ab:	50                   	push   %eax
801014ac:	ff 75 08             	pushl  0x8(%ebp)
801014af:	e8 d7 ec ff ff       	call   8010018b <bread>
801014b4:	83 c4 10             	add    $0x10,%esp
801014b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
801014ba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801014c1:	e9 a6 00 00 00       	jmp    8010156c <balloc+0xfb>
      m = 1 << (bi % 8);
801014c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014c9:	99                   	cltd   
801014ca:	c1 ea 1d             	shr    $0x1d,%edx
801014cd:	01 d0                	add    %edx,%eax
801014cf:	83 e0 07             	and    $0x7,%eax
801014d2:	29 d0                	sub    %edx,%eax
801014d4:	ba 01 00 00 00       	mov    $0x1,%edx
801014d9:	89 c1                	mov    %eax,%ecx
801014db:	d3 e2                	shl    %cl,%edx
801014dd:	89 d0                	mov    %edx,%eax
801014df:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if ((bp->data[bi / 8] & m) == 0) { // Is block free?
801014e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014e5:	8d 50 07             	lea    0x7(%eax),%edx
801014e8:	85 c0                	test   %eax,%eax
801014ea:	0f 48 c2             	cmovs  %edx,%eax
801014ed:	c1 f8 03             	sar    $0x3,%eax
801014f0:	89 c2                	mov    %eax,%edx
801014f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014f5:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
801014fa:	0f b6 c0             	movzbl %al,%eax
801014fd:	23 45 e8             	and    -0x18(%ebp),%eax
80101500:	85 c0                	test   %eax,%eax
80101502:	75 64                	jne    80101568 <balloc+0xf7>
        bp->data[bi / 8] |= m;           // Mark block in use.
80101504:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101507:	8d 50 07             	lea    0x7(%eax),%edx
8010150a:	85 c0                	test   %eax,%eax
8010150c:	0f 48 c2             	cmovs  %edx,%eax
8010150f:	c1 f8 03             	sar    $0x3,%eax
80101512:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101515:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
8010151a:	89 d1                	mov    %edx,%ecx
8010151c:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010151f:	09 ca                	or     %ecx,%edx
80101521:	89 d1                	mov    %edx,%ecx
80101523:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101526:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
8010152a:	83 ec 0c             	sub    $0xc,%esp
8010152d:	ff 75 ec             	pushl  -0x14(%ebp)
80101530:	e8 7d 23 00 00       	call   801038b2 <log_write>
80101535:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
80101538:	83 ec 0c             	sub    $0xc,%esp
8010153b:	ff 75 ec             	pushl  -0x14(%ebp)
8010153e:	e8 c8 ec ff ff       	call   8010020b <brelse>
80101543:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
80101546:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101549:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010154c:	01 c2                	add    %eax,%edx
8010154e:	8b 45 08             	mov    0x8(%ebp),%eax
80101551:	83 ec 08             	sub    $0x8,%esp
80101554:	52                   	push   %edx
80101555:	50                   	push   %eax
80101556:	e8 be fe ff ff       	call   80101419 <bzero>
8010155b:	83 c4 10             	add    $0x10,%esp
        return b + bi;
8010155e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101561:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101564:	01 d0                	add    %edx,%eax
80101566:	eb 57                	jmp    801015bf <balloc+0x14e>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
80101568:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010156c:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80101573:	7f 17                	jg     8010158c <balloc+0x11b>
80101575:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101578:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010157b:	01 d0                	add    %edx,%eax
8010157d:	89 c2                	mov    %eax,%edx
8010157f:	a1 00 23 11 80       	mov    0x80112300,%eax
80101584:	39 c2                	cmp    %eax,%edx
80101586:	0f 82 3a ff ff ff    	jb     801014c6 <balloc+0x55>
      }
    }
    brelse(bp);
8010158c:	83 ec 0c             	sub    $0xc,%esp
8010158f:	ff 75 ec             	pushl  -0x14(%ebp)
80101592:	e8 74 ec ff ff       	call   8010020b <brelse>
80101597:	83 c4 10             	add    $0x10,%esp
  for (b = 0; b < sb.size; b += BPB) {
8010159a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801015a1:	8b 15 00 23 11 80    	mov    0x80112300,%edx
801015a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015aa:	39 c2                	cmp    %eax,%edx
801015ac:	0f 87 dc fe ff ff    	ja     8010148e <balloc+0x1d>
  }
  panic("balloc: out of blocks");
801015b2:	83 ec 0c             	sub    $0xc,%esp
801015b5:	68 a8 9e 10 80       	push   $0x80109ea8
801015ba:	e8 a4 ef ff ff       	call   80100563 <panic>
}
801015bf:	c9                   	leave  
801015c0:	c3                   	ret    

801015c1 <bfree>:

// Free a disk block.
static void bfree(int dev, uint b) {
801015c1:	f3 0f 1e fb          	endbr32 
801015c5:	55                   	push   %ebp
801015c6:	89 e5                	mov    %esp,%ebp
801015c8:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801015cb:	83 ec 08             	sub    $0x8,%esp
801015ce:	68 00 23 11 80       	push   $0x80112300
801015d3:	ff 75 08             	pushl  0x8(%ebp)
801015d6:	e8 f8 fd ff ff       	call   801013d3 <readsb>
801015db:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801015de:	8b 45 0c             	mov    0xc(%ebp),%eax
801015e1:	c1 e8 0c             	shr    $0xc,%eax
801015e4:	89 c2                	mov    %eax,%edx
801015e6:	a1 18 23 11 80       	mov    0x80112318,%eax
801015eb:	01 c2                	add    %eax,%edx
801015ed:	8b 45 08             	mov    0x8(%ebp),%eax
801015f0:	83 ec 08             	sub    $0x8,%esp
801015f3:	52                   	push   %edx
801015f4:	50                   	push   %eax
801015f5:	e8 91 eb ff ff       	call   8010018b <bread>
801015fa:	83 c4 10             	add    $0x10,%esp
801015fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101600:	8b 45 0c             	mov    0xc(%ebp),%eax
80101603:	25 ff 0f 00 00       	and    $0xfff,%eax
80101608:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
8010160b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010160e:	99                   	cltd   
8010160f:	c1 ea 1d             	shr    $0x1d,%edx
80101612:	01 d0                	add    %edx,%eax
80101614:	83 e0 07             	and    $0x7,%eax
80101617:	29 d0                	sub    %edx,%eax
80101619:	ba 01 00 00 00       	mov    $0x1,%edx
8010161e:	89 c1                	mov    %eax,%ecx
80101620:	d3 e2                	shl    %cl,%edx
80101622:	89 d0                	mov    %edx,%eax
80101624:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if ((bp->data[bi / 8] & m) == 0)
80101627:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010162a:	8d 50 07             	lea    0x7(%eax),%edx
8010162d:	85 c0                	test   %eax,%eax
8010162f:	0f 48 c2             	cmovs  %edx,%eax
80101632:	c1 f8 03             	sar    $0x3,%eax
80101635:	89 c2                	mov    %eax,%edx
80101637:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010163a:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
8010163f:	0f b6 c0             	movzbl %al,%eax
80101642:	23 45 ec             	and    -0x14(%ebp),%eax
80101645:	85 c0                	test   %eax,%eax
80101647:	75 0d                	jne    80101656 <bfree+0x95>
    panic("freeing free block");
80101649:	83 ec 0c             	sub    $0xc,%esp
8010164c:	68 be 9e 10 80       	push   $0x80109ebe
80101651:	e8 0d ef ff ff       	call   80100563 <panic>
  bp->data[bi / 8] &= ~m;
80101656:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101659:	8d 50 07             	lea    0x7(%eax),%edx
8010165c:	85 c0                	test   %eax,%eax
8010165e:	0f 48 c2             	cmovs  %edx,%eax
80101661:	c1 f8 03             	sar    $0x3,%eax
80101664:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101667:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
8010166c:	89 d1                	mov    %edx,%ecx
8010166e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101671:	f7 d2                	not    %edx
80101673:	21 ca                	and    %ecx,%edx
80101675:	89 d1                	mov    %edx,%ecx
80101677:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010167a:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
8010167e:	83 ec 0c             	sub    $0xc,%esp
80101681:	ff 75 f4             	pushl  -0xc(%ebp)
80101684:	e8 29 22 00 00       	call   801038b2 <log_write>
80101689:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010168c:	83 ec 0c             	sub    $0xc,%esp
8010168f:	ff 75 f4             	pushl  -0xc(%ebp)
80101692:	e8 74 eb ff ff       	call   8010020b <brelse>
80101697:	83 c4 10             	add    $0x10,%esp
}
8010169a:	90                   	nop
8010169b:	c9                   	leave  
8010169c:	c3                   	ret    

8010169d <iinit>:
struct {
  struct spinlock lock;
  struct inode inode[NINODE];
} icache;

void iinit(int dev) {
8010169d:	f3 0f 1e fb          	endbr32 
801016a1:	55                   	push   %ebp
801016a2:	89 e5                	mov    %esp,%ebp
801016a4:	57                   	push   %edi
801016a5:	56                   	push   %esi
801016a6:	53                   	push   %ebx
801016a7:	83 ec 1c             	sub    $0x1c,%esp
  initlock(&icache.lock, "icache");
801016aa:	83 ec 08             	sub    $0x8,%esp
801016ad:	68 d1 9e 10 80       	push   $0x80109ed1
801016b2:	68 20 23 11 80       	push   $0x80112320
801016b7:	e8 46 3b 00 00       	call   80105202 <initlock>
801016bc:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
801016bf:	83 ec 08             	sub    $0x8,%esp
801016c2:	68 00 23 11 80       	push   $0x80112300
801016c7:	ff 75 08             	pushl  0x8(%ebp)
801016ca:	e8 04 fd ff ff       	call   801013d3 <readsb>
801016cf:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d "
801016d2:	a1 18 23 11 80       	mov    0x80112318,%eax
801016d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801016da:	8b 3d 14 23 11 80    	mov    0x80112314,%edi
801016e0:	8b 35 10 23 11 80    	mov    0x80112310,%esi
801016e6:	8b 1d 0c 23 11 80    	mov    0x8011230c,%ebx
801016ec:	8b 0d 08 23 11 80    	mov    0x80112308,%ecx
801016f2:	8b 15 04 23 11 80    	mov    0x80112304,%edx
801016f8:	a1 00 23 11 80       	mov    0x80112300,%eax
801016fd:	ff 75 e4             	pushl  -0x1c(%ebp)
80101700:	57                   	push   %edi
80101701:	56                   	push   %esi
80101702:	53                   	push   %ebx
80101703:	51                   	push   %ecx
80101704:	52                   	push   %edx
80101705:	50                   	push   %eax
80101706:	68 d8 9e 10 80       	push   $0x80109ed8
8010170b:	e8 9a ec ff ff       	call   801003aa <cprintf>
80101710:	83 c4 20             	add    $0x20,%esp
          "bmap start %d\n",
          sb.size, sb.nblocks, sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
80101713:	90                   	nop
80101714:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101717:	5b                   	pop    %ebx
80101718:	5e                   	pop    %esi
80101719:	5f                   	pop    %edi
8010171a:	5d                   	pop    %ebp
8010171b:	c3                   	ret    

8010171c <ialloc>:
static struct inode *iget(uint dev, uint inum);

// PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode *ialloc(uint dev, short type) {
8010171c:	f3 0f 1e fb          	endbr32 
80101720:	55                   	push   %ebp
80101721:	89 e5                	mov    %esp,%ebp
80101723:	83 ec 28             	sub    $0x28,%esp
80101726:	8b 45 0c             	mov    0xc(%ebp),%eax
80101729:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for (inum = 1; inum < sb.ninodes; inum++) {
8010172d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101734:	e9 9e 00 00 00       	jmp    801017d7 <ialloc+0xbb>
    bp = bread(dev, IBLOCK(inum, sb));
80101739:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010173c:	c1 e8 03             	shr    $0x3,%eax
8010173f:	89 c2                	mov    %eax,%edx
80101741:	a1 14 23 11 80       	mov    0x80112314,%eax
80101746:	01 d0                	add    %edx,%eax
80101748:	83 ec 08             	sub    $0x8,%esp
8010174b:	50                   	push   %eax
8010174c:	ff 75 08             	pushl  0x8(%ebp)
8010174f:	e8 37 ea ff ff       	call   8010018b <bread>
80101754:	83 c4 10             	add    $0x10,%esp
80101757:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode *)bp->data + inum % IPB;
8010175a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010175d:	8d 50 18             	lea    0x18(%eax),%edx
80101760:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101763:	83 e0 07             	and    $0x7,%eax
80101766:	c1 e0 06             	shl    $0x6,%eax
80101769:	01 d0                	add    %edx,%eax
8010176b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (dip->type == 0) { // a free inode
8010176e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101771:	0f b7 00             	movzwl (%eax),%eax
80101774:	66 85 c0             	test   %ax,%ax
80101777:	75 4c                	jne    801017c5 <ialloc+0xa9>
      memset(dip, 0, sizeof(*dip));
80101779:	83 ec 04             	sub    $0x4,%esp
8010177c:	6a 40                	push   $0x40
8010177e:	6a 00                	push   $0x0
80101780:	ff 75 ec             	pushl  -0x14(%ebp)
80101783:	e8 1c 3d 00 00       	call   801054a4 <memset>
80101788:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
8010178b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010178e:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
80101792:	66 89 10             	mov    %dx,(%eax)
      log_write(bp); // mark it allocated on the disk
80101795:	83 ec 0c             	sub    $0xc,%esp
80101798:	ff 75 f0             	pushl  -0x10(%ebp)
8010179b:	e8 12 21 00 00       	call   801038b2 <log_write>
801017a0:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
801017a3:	83 ec 0c             	sub    $0xc,%esp
801017a6:	ff 75 f0             	pushl  -0x10(%ebp)
801017a9:	e8 5d ea ff ff       	call   8010020b <brelse>
801017ae:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
801017b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017b4:	83 ec 08             	sub    $0x8,%esp
801017b7:	50                   	push   %eax
801017b8:	ff 75 08             	pushl  0x8(%ebp)
801017bb:	e8 fc 00 00 00       	call   801018bc <iget>
801017c0:	83 c4 10             	add    $0x10,%esp
801017c3:	eb 30                	jmp    801017f5 <ialloc+0xd9>
    }
    brelse(bp);
801017c5:	83 ec 0c             	sub    $0xc,%esp
801017c8:	ff 75 f0             	pushl  -0x10(%ebp)
801017cb:	e8 3b ea ff ff       	call   8010020b <brelse>
801017d0:	83 c4 10             	add    $0x10,%esp
  for (inum = 1; inum < sb.ninodes; inum++) {
801017d3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801017d7:	8b 15 08 23 11 80    	mov    0x80112308,%edx
801017dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017e0:	39 c2                	cmp    %eax,%edx
801017e2:	0f 87 51 ff ff ff    	ja     80101739 <ialloc+0x1d>
  }
  panic("ialloc: no inodes");
801017e8:	83 ec 0c             	sub    $0xc,%esp
801017eb:	68 2b 9f 10 80       	push   $0x80109f2b
801017f0:	e8 6e ed ff ff       	call   80100563 <panic>
}
801017f5:	c9                   	leave  
801017f6:	c3                   	ret    

801017f7 <iupdate>:

// Copy a modified in-memory inode to disk.
void iupdate(struct inode *ip) {
801017f7:	f3 0f 1e fb          	endbr32 
801017fb:	55                   	push   %ebp
801017fc:	89 e5                	mov    %esp,%ebp
801017fe:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101801:	8b 45 08             	mov    0x8(%ebp),%eax
80101804:	8b 40 04             	mov    0x4(%eax),%eax
80101807:	c1 e8 03             	shr    $0x3,%eax
8010180a:	89 c2                	mov    %eax,%edx
8010180c:	a1 14 23 11 80       	mov    0x80112314,%eax
80101811:	01 c2                	add    %eax,%edx
80101813:	8b 45 08             	mov    0x8(%ebp),%eax
80101816:	8b 00                	mov    (%eax),%eax
80101818:	83 ec 08             	sub    $0x8,%esp
8010181b:	52                   	push   %edx
8010181c:	50                   	push   %eax
8010181d:	e8 69 e9 ff ff       	call   8010018b <bread>
80101822:	83 c4 10             	add    $0x10,%esp
80101825:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode *)bp->data + ip->inum % IPB;
80101828:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010182b:	8d 50 18             	lea    0x18(%eax),%edx
8010182e:	8b 45 08             	mov    0x8(%ebp),%eax
80101831:	8b 40 04             	mov    0x4(%eax),%eax
80101834:	83 e0 07             	and    $0x7,%eax
80101837:	c1 e0 06             	shl    $0x6,%eax
8010183a:	01 d0                	add    %edx,%eax
8010183c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
8010183f:	8b 45 08             	mov    0x8(%ebp),%eax
80101842:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101846:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101849:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010184c:	8b 45 08             	mov    0x8(%ebp),%eax
8010184f:	0f b7 50 12          	movzwl 0x12(%eax),%edx
80101853:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101856:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
8010185a:	8b 45 08             	mov    0x8(%ebp),%eax
8010185d:	0f b7 50 14          	movzwl 0x14(%eax),%edx
80101861:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101864:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101868:	8b 45 08             	mov    0x8(%ebp),%eax
8010186b:	0f b7 50 16          	movzwl 0x16(%eax),%edx
8010186f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101872:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101876:	8b 45 08             	mov    0x8(%ebp),%eax
80101879:	8b 50 18             	mov    0x18(%eax),%edx
8010187c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010187f:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101882:	8b 45 08             	mov    0x8(%ebp),%eax
80101885:	8d 50 1c             	lea    0x1c(%eax),%edx
80101888:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010188b:	83 c0 0c             	add    $0xc,%eax
8010188e:	83 ec 04             	sub    $0x4,%esp
80101891:	6a 34                	push   $0x34
80101893:	52                   	push   %edx
80101894:	50                   	push   %eax
80101895:	e8 d1 3c 00 00       	call   8010556b <memmove>
8010189a:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
8010189d:	83 ec 0c             	sub    $0xc,%esp
801018a0:	ff 75 f4             	pushl  -0xc(%ebp)
801018a3:	e8 0a 20 00 00       	call   801038b2 <log_write>
801018a8:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801018ab:	83 ec 0c             	sub    $0xc,%esp
801018ae:	ff 75 f4             	pushl  -0xc(%ebp)
801018b1:	e8 55 e9 ff ff       	call   8010020b <brelse>
801018b6:	83 c4 10             	add    $0x10,%esp
}
801018b9:	90                   	nop
801018ba:	c9                   	leave  
801018bb:	c3                   	ret    

801018bc <iget>:

// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode *iget(uint dev, uint inum) {
801018bc:	f3 0f 1e fb          	endbr32 
801018c0:	55                   	push   %ebp
801018c1:	89 e5                	mov    %esp,%ebp
801018c3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801018c6:	83 ec 0c             	sub    $0xc,%esp
801018c9:	68 20 23 11 80       	push   $0x80112320
801018ce:	e8 55 39 00 00       	call   80105228 <acquire>
801018d3:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
801018d6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
801018dd:	c7 45 f4 54 23 11 80 	movl   $0x80112354,-0xc(%ebp)
801018e4:	eb 5d                	jmp    80101943 <iget+0x87>
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
801018e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018e9:	8b 40 08             	mov    0x8(%eax),%eax
801018ec:	85 c0                	test   %eax,%eax
801018ee:	7e 39                	jle    80101929 <iget+0x6d>
801018f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018f3:	8b 00                	mov    (%eax),%eax
801018f5:	39 45 08             	cmp    %eax,0x8(%ebp)
801018f8:	75 2f                	jne    80101929 <iget+0x6d>
801018fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018fd:	8b 40 04             	mov    0x4(%eax),%eax
80101900:	39 45 0c             	cmp    %eax,0xc(%ebp)
80101903:	75 24                	jne    80101929 <iget+0x6d>
      ip->ref++;
80101905:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101908:	8b 40 08             	mov    0x8(%eax),%eax
8010190b:	8d 50 01             	lea    0x1(%eax),%edx
8010190e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101911:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101914:	83 ec 0c             	sub    $0xc,%esp
80101917:	68 20 23 11 80       	push   $0x80112320
8010191c:	e8 72 39 00 00       	call   80105293 <release>
80101921:	83 c4 10             	add    $0x10,%esp
      return ip;
80101924:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101927:	eb 74                	jmp    8010199d <iget+0xe1>
    }
    if (empty == 0 && ip->ref == 0) // Remember empty slot.
80101929:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010192d:	75 10                	jne    8010193f <iget+0x83>
8010192f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101932:	8b 40 08             	mov    0x8(%eax),%eax
80101935:	85 c0                	test   %eax,%eax
80101937:	75 06                	jne    8010193f <iget+0x83>
      empty = ip;
80101939:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010193c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
8010193f:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
80101943:	81 7d f4 f4 32 11 80 	cmpl   $0x801132f4,-0xc(%ebp)
8010194a:	72 9a                	jb     801018e6 <iget+0x2a>
  }

  // Recycle an inode cache entry.
  if (empty == 0)
8010194c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101950:	75 0d                	jne    8010195f <iget+0xa3>
    panic("iget: no inodes");
80101952:	83 ec 0c             	sub    $0xc,%esp
80101955:	68 3d 9f 10 80       	push   $0x80109f3d
8010195a:	e8 04 ec ff ff       	call   80100563 <panic>

  ip = empty;
8010195f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101962:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101965:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101968:	8b 55 08             	mov    0x8(%ebp),%edx
8010196b:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
8010196d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101970:	8b 55 0c             	mov    0xc(%ebp),%edx
80101973:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101976:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101979:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
80101980:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101983:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
8010198a:	83 ec 0c             	sub    $0xc,%esp
8010198d:	68 20 23 11 80       	push   $0x80112320
80101992:	e8 fc 38 00 00       	call   80105293 <release>
80101997:	83 c4 10             	add    $0x10,%esp

  return ip;
8010199a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010199d:	c9                   	leave  
8010199e:	c3                   	ret    

8010199f <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode *idup(struct inode *ip) {
8010199f:	f3 0f 1e fb          	endbr32 
801019a3:	55                   	push   %ebp
801019a4:	89 e5                	mov    %esp,%ebp
801019a6:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
801019a9:	83 ec 0c             	sub    $0xc,%esp
801019ac:	68 20 23 11 80       	push   $0x80112320
801019b1:	e8 72 38 00 00       	call   80105228 <acquire>
801019b6:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
801019b9:	8b 45 08             	mov    0x8(%ebp),%eax
801019bc:	8b 40 08             	mov    0x8(%eax),%eax
801019bf:	8d 50 01             	lea    0x1(%eax),%edx
801019c2:	8b 45 08             	mov    0x8(%ebp),%eax
801019c5:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801019c8:	83 ec 0c             	sub    $0xc,%esp
801019cb:	68 20 23 11 80       	push   $0x80112320
801019d0:	e8 be 38 00 00       	call   80105293 <release>
801019d5:	83 c4 10             	add    $0x10,%esp
  return ip;
801019d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
801019db:	c9                   	leave  
801019dc:	c3                   	ret    

801019dd <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void ilock(struct inode *ip) {
801019dd:	f3 0f 1e fb          	endbr32 
801019e1:	55                   	push   %ebp
801019e2:	89 e5                	mov    %esp,%ebp
801019e4:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if (ip == 0 || ip->ref < 1)
801019e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801019eb:	74 0a                	je     801019f7 <ilock+0x1a>
801019ed:	8b 45 08             	mov    0x8(%ebp),%eax
801019f0:	8b 40 08             	mov    0x8(%eax),%eax
801019f3:	85 c0                	test   %eax,%eax
801019f5:	7f 0d                	jg     80101a04 <ilock+0x27>
    panic("ilock");
801019f7:	83 ec 0c             	sub    $0xc,%esp
801019fa:	68 4d 9f 10 80       	push   $0x80109f4d
801019ff:	e8 5f eb ff ff       	call   80100563 <panic>

  acquire(&icache.lock);
80101a04:	83 ec 0c             	sub    $0xc,%esp
80101a07:	68 20 23 11 80       	push   $0x80112320
80101a0c:	e8 17 38 00 00       	call   80105228 <acquire>
80101a11:	83 c4 10             	add    $0x10,%esp
  while (ip->flags & I_BUSY)
80101a14:	eb 13                	jmp    80101a29 <ilock+0x4c>
    sleep(ip, &icache.lock);
80101a16:	83 ec 08             	sub    $0x8,%esp
80101a19:	68 20 23 11 80       	push   $0x80112320
80101a1e:	ff 75 08             	pushl  0x8(%ebp)
80101a21:	e8 ef 34 00 00       	call   80104f15 <sleep>
80101a26:	83 c4 10             	add    $0x10,%esp
  while (ip->flags & I_BUSY)
80101a29:	8b 45 08             	mov    0x8(%ebp),%eax
80101a2c:	8b 40 0c             	mov    0xc(%eax),%eax
80101a2f:	83 e0 01             	and    $0x1,%eax
80101a32:	85 c0                	test   %eax,%eax
80101a34:	75 e0                	jne    80101a16 <ilock+0x39>
  ip->flags |= I_BUSY;
80101a36:	8b 45 08             	mov    0x8(%ebp),%eax
80101a39:	8b 40 0c             	mov    0xc(%eax),%eax
80101a3c:	83 c8 01             	or     $0x1,%eax
80101a3f:	89 c2                	mov    %eax,%edx
80101a41:	8b 45 08             	mov    0x8(%ebp),%eax
80101a44:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101a47:	83 ec 0c             	sub    $0xc,%esp
80101a4a:	68 20 23 11 80       	push   $0x80112320
80101a4f:	e8 3f 38 00 00       	call   80105293 <release>
80101a54:	83 c4 10             	add    $0x10,%esp

  if (!(ip->flags & I_VALID)) {
80101a57:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5a:	8b 40 0c             	mov    0xc(%eax),%eax
80101a5d:	83 e0 02             	and    $0x2,%eax
80101a60:	85 c0                	test   %eax,%eax
80101a62:	0f 85 d4 00 00 00    	jne    80101b3c <ilock+0x15f>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a68:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6b:	8b 40 04             	mov    0x4(%eax),%eax
80101a6e:	c1 e8 03             	shr    $0x3,%eax
80101a71:	89 c2                	mov    %eax,%edx
80101a73:	a1 14 23 11 80       	mov    0x80112314,%eax
80101a78:	01 c2                	add    %eax,%edx
80101a7a:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7d:	8b 00                	mov    (%eax),%eax
80101a7f:	83 ec 08             	sub    $0x8,%esp
80101a82:	52                   	push   %edx
80101a83:	50                   	push   %eax
80101a84:	e8 02 e7 ff ff       	call   8010018b <bread>
80101a89:	83 c4 10             	add    $0x10,%esp
80101a8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode *)bp->data + ip->inum % IPB;
80101a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a92:	8d 50 18             	lea    0x18(%eax),%edx
80101a95:	8b 45 08             	mov    0x8(%ebp),%eax
80101a98:	8b 40 04             	mov    0x4(%eax),%eax
80101a9b:	83 e0 07             	and    $0x7,%eax
80101a9e:	c1 e0 06             	shl    $0x6,%eax
80101aa1:	01 d0                	add    %edx,%eax
80101aa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101aa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101aa9:	0f b7 10             	movzwl (%eax),%edx
80101aac:	8b 45 08             	mov    0x8(%ebp),%eax
80101aaf:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101ab3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ab6:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101aba:	8b 45 08             	mov    0x8(%ebp),%eax
80101abd:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101ac1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ac4:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101ac8:	8b 45 08             	mov    0x8(%ebp),%eax
80101acb:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101acf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ad2:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101ad6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad9:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101add:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ae0:	8b 50 08             	mov    0x8(%eax),%edx
80101ae3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae6:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101ae9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101aec:	8d 50 0c             	lea    0xc(%eax),%edx
80101aef:	8b 45 08             	mov    0x8(%ebp),%eax
80101af2:	83 c0 1c             	add    $0x1c,%eax
80101af5:	83 ec 04             	sub    $0x4,%esp
80101af8:	6a 34                	push   $0x34
80101afa:	52                   	push   %edx
80101afb:	50                   	push   %eax
80101afc:	e8 6a 3a 00 00       	call   8010556b <memmove>
80101b01:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101b04:	83 ec 0c             	sub    $0xc,%esp
80101b07:	ff 75 f4             	pushl  -0xc(%ebp)
80101b0a:	e8 fc e6 ff ff       	call   8010020b <brelse>
80101b0f:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101b12:	8b 45 08             	mov    0x8(%ebp),%eax
80101b15:	8b 40 0c             	mov    0xc(%eax),%eax
80101b18:	83 c8 02             	or     $0x2,%eax
80101b1b:	89 c2                	mov    %eax,%edx
80101b1d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b20:	89 50 0c             	mov    %edx,0xc(%eax)
    if (ip->type == 0)
80101b23:	8b 45 08             	mov    0x8(%ebp),%eax
80101b26:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101b2a:	66 85 c0             	test   %ax,%ax
80101b2d:	75 0d                	jne    80101b3c <ilock+0x15f>
      panic("ilock: no type");
80101b2f:	83 ec 0c             	sub    $0xc,%esp
80101b32:	68 53 9f 10 80       	push   $0x80109f53
80101b37:	e8 27 ea ff ff       	call   80100563 <panic>
  }
}
80101b3c:	90                   	nop
80101b3d:	c9                   	leave  
80101b3e:	c3                   	ret    

80101b3f <iunlock>:

// Unlock the given inode.
void iunlock(struct inode *ip) {
80101b3f:	f3 0f 1e fb          	endbr32 
80101b43:	55                   	push   %ebp
80101b44:	89 e5                	mov    %esp,%ebp
80101b46:	83 ec 08             	sub    $0x8,%esp
  if (ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101b49:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101b4d:	74 17                	je     80101b66 <iunlock+0x27>
80101b4f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b52:	8b 40 0c             	mov    0xc(%eax),%eax
80101b55:	83 e0 01             	and    $0x1,%eax
80101b58:	85 c0                	test   %eax,%eax
80101b5a:	74 0a                	je     80101b66 <iunlock+0x27>
80101b5c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b5f:	8b 40 08             	mov    0x8(%eax),%eax
80101b62:	85 c0                	test   %eax,%eax
80101b64:	7f 0d                	jg     80101b73 <iunlock+0x34>
    panic("iunlock");
80101b66:	83 ec 0c             	sub    $0xc,%esp
80101b69:	68 62 9f 10 80       	push   $0x80109f62
80101b6e:	e8 f0 e9 ff ff       	call   80100563 <panic>

  acquire(&icache.lock);
80101b73:	83 ec 0c             	sub    $0xc,%esp
80101b76:	68 20 23 11 80       	push   $0x80112320
80101b7b:	e8 a8 36 00 00       	call   80105228 <acquire>
80101b80:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101b83:	8b 45 08             	mov    0x8(%ebp),%eax
80101b86:	8b 40 0c             	mov    0xc(%eax),%eax
80101b89:	83 e0 fe             	and    $0xfffffffe,%eax
80101b8c:	89 c2                	mov    %eax,%edx
80101b8e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b91:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101b94:	83 ec 0c             	sub    $0xc,%esp
80101b97:	ff 75 08             	pushl  0x8(%ebp)
80101b9a:	e8 6a 34 00 00       	call   80105009 <wakeup>
80101b9f:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101ba2:	83 ec 0c             	sub    $0xc,%esp
80101ba5:	68 20 23 11 80       	push   $0x80112320
80101baa:	e8 e4 36 00 00       	call   80105293 <release>
80101baf:	83 c4 10             	add    $0x10,%esp
}
80101bb2:	90                   	nop
80101bb3:	c9                   	leave  
80101bb4:	c3                   	ret    

80101bb5 <iput>:
// be recycled.
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void iput(struct inode *ip) {
80101bb5:	f3 0f 1e fb          	endbr32 
80101bb9:	55                   	push   %ebp
80101bba:	89 e5                	mov    %esp,%ebp
80101bbc:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101bbf:	83 ec 0c             	sub    $0xc,%esp
80101bc2:	68 20 23 11 80       	push   $0x80112320
80101bc7:	e8 5c 36 00 00       	call   80105228 <acquire>
80101bcc:	83 c4 10             	add    $0x10,%esp
  if (ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0) {
80101bcf:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd2:	8b 40 08             	mov    0x8(%eax),%eax
80101bd5:	83 f8 01             	cmp    $0x1,%eax
80101bd8:	0f 85 a9 00 00 00    	jne    80101c87 <iput+0xd2>
80101bde:	8b 45 08             	mov    0x8(%ebp),%eax
80101be1:	8b 40 0c             	mov    0xc(%eax),%eax
80101be4:	83 e0 02             	and    $0x2,%eax
80101be7:	85 c0                	test   %eax,%eax
80101be9:	0f 84 98 00 00 00    	je     80101c87 <iput+0xd2>
80101bef:	8b 45 08             	mov    0x8(%ebp),%eax
80101bf2:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101bf6:	66 85 c0             	test   %ax,%ax
80101bf9:	0f 85 88 00 00 00    	jne    80101c87 <iput+0xd2>
    // inode has no links and no other references: truncate and free.
    if (ip->flags & I_BUSY)
80101bff:	8b 45 08             	mov    0x8(%ebp),%eax
80101c02:	8b 40 0c             	mov    0xc(%eax),%eax
80101c05:	83 e0 01             	and    $0x1,%eax
80101c08:	85 c0                	test   %eax,%eax
80101c0a:	74 0d                	je     80101c19 <iput+0x64>
      panic("iput busy");
80101c0c:	83 ec 0c             	sub    $0xc,%esp
80101c0f:	68 6a 9f 10 80       	push   $0x80109f6a
80101c14:	e8 4a e9 ff ff       	call   80100563 <panic>
    ip->flags |= I_BUSY;
80101c19:	8b 45 08             	mov    0x8(%ebp),%eax
80101c1c:	8b 40 0c             	mov    0xc(%eax),%eax
80101c1f:	83 c8 01             	or     $0x1,%eax
80101c22:	89 c2                	mov    %eax,%edx
80101c24:	8b 45 08             	mov    0x8(%ebp),%eax
80101c27:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101c2a:	83 ec 0c             	sub    $0xc,%esp
80101c2d:	68 20 23 11 80       	push   $0x80112320
80101c32:	e8 5c 36 00 00       	call   80105293 <release>
80101c37:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101c3a:	83 ec 0c             	sub    $0xc,%esp
80101c3d:	ff 75 08             	pushl  0x8(%ebp)
80101c40:	e8 ab 01 00 00       	call   80101df0 <itrunc>
80101c45:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101c48:	8b 45 08             	mov    0x8(%ebp),%eax
80101c4b:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101c51:	83 ec 0c             	sub    $0xc,%esp
80101c54:	ff 75 08             	pushl  0x8(%ebp)
80101c57:	e8 9b fb ff ff       	call   801017f7 <iupdate>
80101c5c:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101c5f:	83 ec 0c             	sub    $0xc,%esp
80101c62:	68 20 23 11 80       	push   $0x80112320
80101c67:	e8 bc 35 00 00       	call   80105228 <acquire>
80101c6c:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101c6f:	8b 45 08             	mov    0x8(%ebp),%eax
80101c72:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101c79:	83 ec 0c             	sub    $0xc,%esp
80101c7c:	ff 75 08             	pushl  0x8(%ebp)
80101c7f:	e8 85 33 00 00       	call   80105009 <wakeup>
80101c84:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101c87:	8b 45 08             	mov    0x8(%ebp),%eax
80101c8a:	8b 40 08             	mov    0x8(%eax),%eax
80101c8d:	8d 50 ff             	lea    -0x1(%eax),%edx
80101c90:	8b 45 08             	mov    0x8(%ebp),%eax
80101c93:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101c96:	83 ec 0c             	sub    $0xc,%esp
80101c99:	68 20 23 11 80       	push   $0x80112320
80101c9e:	e8 f0 35 00 00       	call   80105293 <release>
80101ca3:	83 c4 10             	add    $0x10,%esp
}
80101ca6:	90                   	nop
80101ca7:	c9                   	leave  
80101ca8:	c3                   	ret    

80101ca9 <iunlockput>:

// Common idiom: unlock, then put.
void iunlockput(struct inode *ip) {
80101ca9:	f3 0f 1e fb          	endbr32 
80101cad:	55                   	push   %ebp
80101cae:	89 e5                	mov    %esp,%ebp
80101cb0:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101cb3:	83 ec 0c             	sub    $0xc,%esp
80101cb6:	ff 75 08             	pushl  0x8(%ebp)
80101cb9:	e8 81 fe ff ff       	call   80101b3f <iunlock>
80101cbe:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101cc1:	83 ec 0c             	sub    $0xc,%esp
80101cc4:	ff 75 08             	pushl  0x8(%ebp)
80101cc7:	e8 e9 fe ff ff       	call   80101bb5 <iput>
80101ccc:	83 c4 10             	add    $0x10,%esp
}
80101ccf:	90                   	nop
80101cd0:	c9                   	leave  
80101cd1:	c3                   	ret    

80101cd2 <bmap>:
// are listed in ip->addrs[].  The next NINDIRECT blocks are
// listed in block ip->addrs[NDIRECT].

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint bmap(struct inode *ip, uint bn) {
80101cd2:	f3 0f 1e fb          	endbr32 
80101cd6:	55                   	push   %ebp
80101cd7:	89 e5                	mov    %esp,%ebp
80101cd9:	83 ec 18             	sub    $0x18,%esp
  uint addr, *a;
  struct buf *bp;

  if (bn < NDIRECT) {
80101cdc:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101ce0:	77 42                	ja     80101d24 <bmap+0x52>
    if ((addr = ip->addrs[bn]) == 0)
80101ce2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ce5:	8b 55 0c             	mov    0xc(%ebp),%edx
80101ce8:	83 c2 04             	add    $0x4,%edx
80101ceb:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101cef:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cf2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101cf6:	75 24                	jne    80101d1c <bmap+0x4a>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101cf8:	8b 45 08             	mov    0x8(%ebp),%eax
80101cfb:	8b 00                	mov    (%eax),%eax
80101cfd:	83 ec 0c             	sub    $0xc,%esp
80101d00:	50                   	push   %eax
80101d01:	e8 6b f7 ff ff       	call   80101471 <balloc>
80101d06:	83 c4 10             	add    $0x10,%esp
80101d09:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d0c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d0f:	8b 55 0c             	mov    0xc(%ebp),%edx
80101d12:	8d 4a 04             	lea    0x4(%edx),%ecx
80101d15:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d18:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d1f:	e9 ca 00 00 00       	jmp    80101dee <bmap+0x11c>
  }
  bn -= NDIRECT;
80101d24:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if (bn < NINDIRECT) {
80101d28:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101d2c:	0f 87 af 00 00 00    	ja     80101de1 <bmap+0x10f>
    // Load indirect block, allocating if necessary.
    if ((addr = ip->addrs[NDIRECT]) == 0)
80101d32:	8b 45 08             	mov    0x8(%ebp),%eax
80101d35:	8b 40 4c             	mov    0x4c(%eax),%eax
80101d38:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d3f:	75 1d                	jne    80101d5e <bmap+0x8c>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101d41:	8b 45 08             	mov    0x8(%ebp),%eax
80101d44:	8b 00                	mov    (%eax),%eax
80101d46:	83 ec 0c             	sub    $0xc,%esp
80101d49:	50                   	push   %eax
80101d4a:	e8 22 f7 ff ff       	call   80101471 <balloc>
80101d4f:	83 c4 10             	add    $0x10,%esp
80101d52:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d55:	8b 45 08             	mov    0x8(%ebp),%eax
80101d58:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d5b:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101d5e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d61:	8b 00                	mov    (%eax),%eax
80101d63:	83 ec 08             	sub    $0x8,%esp
80101d66:	ff 75 f4             	pushl  -0xc(%ebp)
80101d69:	50                   	push   %eax
80101d6a:	e8 1c e4 ff ff       	call   8010018b <bread>
80101d6f:	83 c4 10             	add    $0x10,%esp
80101d72:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint *)bp->data;
80101d75:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d78:	83 c0 18             	add    $0x18,%eax
80101d7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if ((addr = a[bn]) == 0) {
80101d7e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d81:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d88:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d8b:	01 d0                	add    %edx,%eax
80101d8d:	8b 00                	mov    (%eax),%eax
80101d8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d96:	75 36                	jne    80101dce <bmap+0xfc>
      a[bn] = addr = balloc(ip->dev);
80101d98:	8b 45 08             	mov    0x8(%ebp),%eax
80101d9b:	8b 00                	mov    (%eax),%eax
80101d9d:	83 ec 0c             	sub    $0xc,%esp
80101da0:	50                   	push   %eax
80101da1:	e8 cb f6 ff ff       	call   80101471 <balloc>
80101da6:	83 c4 10             	add    $0x10,%esp
80101da9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101dac:	8b 45 0c             	mov    0xc(%ebp),%eax
80101daf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101db6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101db9:	01 c2                	add    %eax,%edx
80101dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101dbe:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101dc0:	83 ec 0c             	sub    $0xc,%esp
80101dc3:	ff 75 f0             	pushl  -0x10(%ebp)
80101dc6:	e8 e7 1a 00 00       	call   801038b2 <log_write>
80101dcb:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101dce:	83 ec 0c             	sub    $0xc,%esp
80101dd1:	ff 75 f0             	pushl  -0x10(%ebp)
80101dd4:	e8 32 e4 ff ff       	call   8010020b <brelse>
80101dd9:	83 c4 10             	add    $0x10,%esp
    return addr;
80101ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ddf:	eb 0d                	jmp    80101dee <bmap+0x11c>
  }

  panic("bmap: out of range");
80101de1:	83 ec 0c             	sub    $0xc,%esp
80101de4:	68 74 9f 10 80       	push   $0x80109f74
80101de9:	e8 75 e7 ff ff       	call   80100563 <panic>
}
80101dee:	c9                   	leave  
80101def:	c3                   	ret    

80101df0 <itrunc>:
// Truncate inode (discard contents).
// Only called when the inode has no links
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void itrunc(struct inode *ip) {
80101df0:	f3 0f 1e fb          	endbr32 
80101df4:	55                   	push   %ebp
80101df5:	89 e5                	mov    %esp,%ebp
80101df7:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for (i = 0; i < NDIRECT; i++) {
80101dfa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101e01:	eb 45                	jmp    80101e48 <itrunc+0x58>
    if (ip->addrs[i]) {
80101e03:	8b 45 08             	mov    0x8(%ebp),%eax
80101e06:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e09:	83 c2 04             	add    $0x4,%edx
80101e0c:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101e10:	85 c0                	test   %eax,%eax
80101e12:	74 30                	je     80101e44 <itrunc+0x54>
      bfree(ip->dev, ip->addrs[i]);
80101e14:	8b 45 08             	mov    0x8(%ebp),%eax
80101e17:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e1a:	83 c2 04             	add    $0x4,%edx
80101e1d:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101e21:	8b 55 08             	mov    0x8(%ebp),%edx
80101e24:	8b 12                	mov    (%edx),%edx
80101e26:	83 ec 08             	sub    $0x8,%esp
80101e29:	50                   	push   %eax
80101e2a:	52                   	push   %edx
80101e2b:	e8 91 f7 ff ff       	call   801015c1 <bfree>
80101e30:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101e33:	8b 45 08             	mov    0x8(%ebp),%eax
80101e36:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e39:	83 c2 04             	add    $0x4,%edx
80101e3c:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101e43:	00 
  for (i = 0; i < NDIRECT; i++) {
80101e44:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101e48:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101e4c:	7e b5                	jle    80101e03 <itrunc+0x13>
    }
  }

  if (ip->addrs[NDIRECT]) {
80101e4e:	8b 45 08             	mov    0x8(%ebp),%eax
80101e51:	8b 40 4c             	mov    0x4c(%eax),%eax
80101e54:	85 c0                	test   %eax,%eax
80101e56:	0f 84 a1 00 00 00    	je     80101efd <itrunc+0x10d>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101e5c:	8b 45 08             	mov    0x8(%ebp),%eax
80101e5f:	8b 50 4c             	mov    0x4c(%eax),%edx
80101e62:	8b 45 08             	mov    0x8(%ebp),%eax
80101e65:	8b 00                	mov    (%eax),%eax
80101e67:	83 ec 08             	sub    $0x8,%esp
80101e6a:	52                   	push   %edx
80101e6b:	50                   	push   %eax
80101e6c:	e8 1a e3 ff ff       	call   8010018b <bread>
80101e71:	83 c4 10             	add    $0x10,%esp
80101e74:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint *)bp->data;
80101e77:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e7a:	83 c0 18             	add    $0x18,%eax
80101e7d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for (j = 0; j < NINDIRECT; j++) {
80101e80:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101e87:	eb 3c                	jmp    80101ec5 <itrunc+0xd5>
      if (a[j])
80101e89:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e8c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e93:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e96:	01 d0                	add    %edx,%eax
80101e98:	8b 00                	mov    (%eax),%eax
80101e9a:	85 c0                	test   %eax,%eax
80101e9c:	74 23                	je     80101ec1 <itrunc+0xd1>
        bfree(ip->dev, a[j]);
80101e9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ea1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101ea8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101eab:	01 d0                	add    %edx,%eax
80101ead:	8b 00                	mov    (%eax),%eax
80101eaf:	8b 55 08             	mov    0x8(%ebp),%edx
80101eb2:	8b 12                	mov    (%edx),%edx
80101eb4:	83 ec 08             	sub    $0x8,%esp
80101eb7:	50                   	push   %eax
80101eb8:	52                   	push   %edx
80101eb9:	e8 03 f7 ff ff       	call   801015c1 <bfree>
80101ebe:	83 c4 10             	add    $0x10,%esp
    for (j = 0; j < NINDIRECT; j++) {
80101ec1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101ec5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ec8:	83 f8 7f             	cmp    $0x7f,%eax
80101ecb:	76 bc                	jbe    80101e89 <itrunc+0x99>
    }
    brelse(bp);
80101ecd:	83 ec 0c             	sub    $0xc,%esp
80101ed0:	ff 75 ec             	pushl  -0x14(%ebp)
80101ed3:	e8 33 e3 ff ff       	call   8010020b <brelse>
80101ed8:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101edb:	8b 45 08             	mov    0x8(%ebp),%eax
80101ede:	8b 40 4c             	mov    0x4c(%eax),%eax
80101ee1:	8b 55 08             	mov    0x8(%ebp),%edx
80101ee4:	8b 12                	mov    (%edx),%edx
80101ee6:	83 ec 08             	sub    $0x8,%esp
80101ee9:	50                   	push   %eax
80101eea:	52                   	push   %edx
80101eeb:	e8 d1 f6 ff ff       	call   801015c1 <bfree>
80101ef0:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101ef3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef6:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101efd:	8b 45 08             	mov    0x8(%ebp),%eax
80101f00:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101f07:	83 ec 0c             	sub    $0xc,%esp
80101f0a:	ff 75 08             	pushl  0x8(%ebp)
80101f0d:	e8 e5 f8 ff ff       	call   801017f7 <iupdate>
80101f12:	83 c4 10             	add    $0x10,%esp
}
80101f15:	90                   	nop
80101f16:	c9                   	leave  
80101f17:	c3                   	ret    

80101f18 <stati>:

// Copy stat information from inode.
void stati(struct inode *ip, struct stat *st) {
80101f18:	f3 0f 1e fb          	endbr32 
80101f1c:	55                   	push   %ebp
80101f1d:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101f1f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f22:	8b 00                	mov    (%eax),%eax
80101f24:	89 c2                	mov    %eax,%edx
80101f26:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f29:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101f2c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2f:	8b 50 04             	mov    0x4(%eax),%edx
80101f32:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f35:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101f38:	8b 45 08             	mov    0x8(%ebp),%eax
80101f3b:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101f3f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f42:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101f45:	8b 45 08             	mov    0x8(%ebp),%eax
80101f48:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101f4c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f4f:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101f53:	8b 45 08             	mov    0x8(%ebp),%eax
80101f56:	8b 50 18             	mov    0x18(%eax),%edx
80101f59:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f5c:	89 50 10             	mov    %edx,0x10(%eax)
}
80101f5f:	90                   	nop
80101f60:	5d                   	pop    %ebp
80101f61:	c3                   	ret    

80101f62 <readi>:

// PAGEBREAK!
// Read data from inode.
int readi(struct inode *ip, char *dst, uint off, uint n) {
80101f62:	f3 0f 1e fb          	endbr32 
80101f66:	55                   	push   %ebp
80101f67:	89 e5                	mov    %esp,%ebp
80101f69:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if (ip->type == T_DEV) {
80101f6c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f6f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101f73:	66 83 f8 03          	cmp    $0x3,%ax
80101f77:	75 5c                	jne    80101fd5 <readi+0x73>
    if (ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101f79:	8b 45 08             	mov    0x8(%ebp),%eax
80101f7c:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f80:	66 85 c0             	test   %ax,%ax
80101f83:	78 20                	js     80101fa5 <readi+0x43>
80101f85:	8b 45 08             	mov    0x8(%ebp),%eax
80101f88:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f8c:	66 83 f8 09          	cmp    $0x9,%ax
80101f90:	7f 13                	jg     80101fa5 <readi+0x43>
80101f92:	8b 45 08             	mov    0x8(%ebp),%eax
80101f95:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f99:	98                   	cwtl   
80101f9a:	8b 04 c5 a0 22 11 80 	mov    -0x7feedd60(,%eax,8),%eax
80101fa1:	85 c0                	test   %eax,%eax
80101fa3:	75 0a                	jne    80101faf <readi+0x4d>
      return -1;
80101fa5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101faa:	e9 0a 01 00 00       	jmp    801020b9 <readi+0x157>
    return devsw[ip->major].read(ip, dst, n);
80101faf:	8b 45 08             	mov    0x8(%ebp),%eax
80101fb2:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fb6:	98                   	cwtl   
80101fb7:	8b 04 c5 a0 22 11 80 	mov    -0x7feedd60(,%eax,8),%eax
80101fbe:	8b 55 14             	mov    0x14(%ebp),%edx
80101fc1:	83 ec 04             	sub    $0x4,%esp
80101fc4:	52                   	push   %edx
80101fc5:	ff 75 0c             	pushl  0xc(%ebp)
80101fc8:	ff 75 08             	pushl  0x8(%ebp)
80101fcb:	ff d0                	call   *%eax
80101fcd:	83 c4 10             	add    $0x10,%esp
80101fd0:	e9 e4 00 00 00       	jmp    801020b9 <readi+0x157>
  }

  if (off > ip->size || off + n < off)
80101fd5:	8b 45 08             	mov    0x8(%ebp),%eax
80101fd8:	8b 40 18             	mov    0x18(%eax),%eax
80101fdb:	39 45 10             	cmp    %eax,0x10(%ebp)
80101fde:	77 0d                	ja     80101fed <readi+0x8b>
80101fe0:	8b 55 10             	mov    0x10(%ebp),%edx
80101fe3:	8b 45 14             	mov    0x14(%ebp),%eax
80101fe6:	01 d0                	add    %edx,%eax
80101fe8:	39 45 10             	cmp    %eax,0x10(%ebp)
80101feb:	76 0a                	jbe    80101ff7 <readi+0x95>
    return -1;
80101fed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ff2:	e9 c2 00 00 00       	jmp    801020b9 <readi+0x157>
  if (off + n > ip->size)
80101ff7:	8b 55 10             	mov    0x10(%ebp),%edx
80101ffa:	8b 45 14             	mov    0x14(%ebp),%eax
80101ffd:	01 c2                	add    %eax,%edx
80101fff:	8b 45 08             	mov    0x8(%ebp),%eax
80102002:	8b 40 18             	mov    0x18(%eax),%eax
80102005:	39 c2                	cmp    %eax,%edx
80102007:	76 0c                	jbe    80102015 <readi+0xb3>
    n = ip->size - off;
80102009:	8b 45 08             	mov    0x8(%ebp),%eax
8010200c:	8b 40 18             	mov    0x18(%eax),%eax
8010200f:	2b 45 10             	sub    0x10(%ebp),%eax
80102012:	89 45 14             	mov    %eax,0x14(%ebp)

  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
80102015:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010201c:	e9 89 00 00 00       	jmp    801020aa <readi+0x148>
    bp = bread(ip->dev, bmap(ip, off / BSIZE));
80102021:	8b 45 10             	mov    0x10(%ebp),%eax
80102024:	c1 e8 09             	shr    $0x9,%eax
80102027:	83 ec 08             	sub    $0x8,%esp
8010202a:	50                   	push   %eax
8010202b:	ff 75 08             	pushl  0x8(%ebp)
8010202e:	e8 9f fc ff ff       	call   80101cd2 <bmap>
80102033:	83 c4 10             	add    $0x10,%esp
80102036:	8b 55 08             	mov    0x8(%ebp),%edx
80102039:	8b 12                	mov    (%edx),%edx
8010203b:	83 ec 08             	sub    $0x8,%esp
8010203e:	50                   	push   %eax
8010203f:	52                   	push   %edx
80102040:	e8 46 e1 ff ff       	call   8010018b <bread>
80102045:	83 c4 10             	add    $0x10,%esp
80102048:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off % BSIZE);
8010204b:	8b 45 10             	mov    0x10(%ebp),%eax
8010204e:	25 ff 01 00 00       	and    $0x1ff,%eax
80102053:	ba 00 02 00 00       	mov    $0x200,%edx
80102058:	29 c2                	sub    %eax,%edx
8010205a:	8b 45 14             	mov    0x14(%ebp),%eax
8010205d:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102060:	39 c2                	cmp    %eax,%edx
80102062:	0f 46 c2             	cmovbe %edx,%eax
80102065:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off % BSIZE, m);
80102068:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010206b:	8d 50 18             	lea    0x18(%eax),%edx
8010206e:	8b 45 10             	mov    0x10(%ebp),%eax
80102071:	25 ff 01 00 00       	and    $0x1ff,%eax
80102076:	01 d0                	add    %edx,%eax
80102078:	83 ec 04             	sub    $0x4,%esp
8010207b:	ff 75 ec             	pushl  -0x14(%ebp)
8010207e:	50                   	push   %eax
8010207f:	ff 75 0c             	pushl  0xc(%ebp)
80102082:	e8 e4 34 00 00       	call   8010556b <memmove>
80102087:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
8010208a:	83 ec 0c             	sub    $0xc,%esp
8010208d:	ff 75 f0             	pushl  -0x10(%ebp)
80102090:	e8 76 e1 ff ff       	call   8010020b <brelse>
80102095:	83 c4 10             	add    $0x10,%esp
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
80102098:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010209b:	01 45 f4             	add    %eax,-0xc(%ebp)
8010209e:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020a1:	01 45 10             	add    %eax,0x10(%ebp)
801020a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020a7:	01 45 0c             	add    %eax,0xc(%ebp)
801020aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020ad:	3b 45 14             	cmp    0x14(%ebp),%eax
801020b0:	0f 82 6b ff ff ff    	jb     80102021 <readi+0xbf>
  }
  return n;
801020b6:	8b 45 14             	mov    0x14(%ebp),%eax
}
801020b9:	c9                   	leave  
801020ba:	c3                   	ret    

801020bb <writei>:
//     ip->size = off;
//     iupdate(ip);
//   }
//   return n;
// }
int writei(struct inode *ip, char *src, uint off, uint n) {
801020bb:	f3 0f 1e fb          	endbr32 
801020bf:	55                   	push   %ebp
801020c0:	89 e5                	mov    %esp,%ebp
801020c2:	83 ec 18             	sub    $0x18,%esp
    uint tot, m;
    struct buf *bp;

    if (ip->type == T_DEV) {
801020c5:	8b 45 08             	mov    0x8(%ebp),%eax
801020c8:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801020cc:	66 83 f8 03          	cmp    $0x3,%ax
801020d0:	75 5c                	jne    8010212e <writei+0x73>
        if (ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801020d2:	8b 45 08             	mov    0x8(%ebp),%eax
801020d5:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020d9:	66 85 c0             	test   %ax,%ax
801020dc:	78 20                	js     801020fe <writei+0x43>
801020de:	8b 45 08             	mov    0x8(%ebp),%eax
801020e1:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020e5:	66 83 f8 09          	cmp    $0x9,%ax
801020e9:	7f 13                	jg     801020fe <writei+0x43>
801020eb:	8b 45 08             	mov    0x8(%ebp),%eax
801020ee:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020f2:	98                   	cwtl   
801020f3:	8b 04 c5 a4 22 11 80 	mov    -0x7feedd5c(,%eax,8),%eax
801020fa:	85 c0                	test   %eax,%eax
801020fc:	75 0a                	jne    80102108 <writei+0x4d>
            return -1;
801020fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102103:	e9 3b 01 00 00       	jmp    80102243 <writei+0x188>

        // Always write device output regardless of tracing
        return devsw[ip->major].write(ip, src, n);
80102108:	8b 45 08             	mov    0x8(%ebp),%eax
8010210b:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010210f:	98                   	cwtl   
80102110:	8b 04 c5 a4 22 11 80 	mov    -0x7feedd5c(,%eax,8),%eax
80102117:	8b 55 14             	mov    0x14(%ebp),%edx
8010211a:	83 ec 04             	sub    $0x4,%esp
8010211d:	52                   	push   %edx
8010211e:	ff 75 0c             	pushl  0xc(%ebp)
80102121:	ff 75 08             	pushl  0x8(%ebp)
80102124:	ff d0                	call   *%eax
80102126:	83 c4 10             	add    $0x10,%esp
80102129:	e9 15 01 00 00       	jmp    80102243 <writei+0x188>
    }

    if (off > ip->size || off + n < off)
8010212e:	8b 45 08             	mov    0x8(%ebp),%eax
80102131:	8b 40 18             	mov    0x18(%eax),%eax
80102134:	39 45 10             	cmp    %eax,0x10(%ebp)
80102137:	77 0d                	ja     80102146 <writei+0x8b>
80102139:	8b 55 10             	mov    0x10(%ebp),%edx
8010213c:	8b 45 14             	mov    0x14(%ebp),%eax
8010213f:	01 d0                	add    %edx,%eax
80102141:	39 45 10             	cmp    %eax,0x10(%ebp)
80102144:	76 0a                	jbe    80102150 <writei+0x95>
        return -1;
80102146:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010214b:	e9 f3 00 00 00       	jmp    80102243 <writei+0x188>
    if (off + n > MAXFILE * BSIZE)
80102150:	8b 55 10             	mov    0x10(%ebp),%edx
80102153:	8b 45 14             	mov    0x14(%ebp),%eax
80102156:	01 d0                	add    %edx,%eax
80102158:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010215d:	76 0a                	jbe    80102169 <writei+0xae>
        return -1;
8010215f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102164:	e9 da 00 00 00       	jmp    80102243 <writei+0x188>

    for (tot = 0; tot < n; tot += m, off += m, src += m) {
80102169:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102170:	e9 97 00 00 00       	jmp    8010220c <writei+0x151>
        bp = bread(ip->dev, bmap(ip, off / BSIZE));
80102175:	8b 45 10             	mov    0x10(%ebp),%eax
80102178:	c1 e8 09             	shr    $0x9,%eax
8010217b:	83 ec 08             	sub    $0x8,%esp
8010217e:	50                   	push   %eax
8010217f:	ff 75 08             	pushl  0x8(%ebp)
80102182:	e8 4b fb ff ff       	call   80101cd2 <bmap>
80102187:	83 c4 10             	add    $0x10,%esp
8010218a:	8b 55 08             	mov    0x8(%ebp),%edx
8010218d:	8b 12                	mov    (%edx),%edx
8010218f:	83 ec 08             	sub    $0x8,%esp
80102192:	50                   	push   %eax
80102193:	52                   	push   %edx
80102194:	e8 f2 df ff ff       	call   8010018b <bread>
80102199:	83 c4 10             	add    $0x10,%esp
8010219c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        m = min(n - tot, BSIZE - off % BSIZE);
8010219f:	8b 45 10             	mov    0x10(%ebp),%eax
801021a2:	25 ff 01 00 00       	and    $0x1ff,%eax
801021a7:	ba 00 02 00 00       	mov    $0x200,%edx
801021ac:	29 c2                	sub    %eax,%edx
801021ae:	8b 45 14             	mov    0x14(%ebp),%eax
801021b1:	2b 45 f4             	sub    -0xc(%ebp),%eax
801021b4:	39 c2                	cmp    %eax,%edx
801021b6:	0f 46 c2             	cmovbe %edx,%eax
801021b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memmove(bp->data + off % BSIZE, src, m);
801021bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801021bf:	8d 50 18             	lea    0x18(%eax),%edx
801021c2:	8b 45 10             	mov    0x10(%ebp),%eax
801021c5:	25 ff 01 00 00       	and    $0x1ff,%eax
801021ca:	01 d0                	add    %edx,%eax
801021cc:	83 ec 04             	sub    $0x4,%esp
801021cf:	ff 75 ec             	pushl  -0x14(%ebp)
801021d2:	ff 75 0c             	pushl  0xc(%ebp)
801021d5:	50                   	push   %eax
801021d6:	e8 90 33 00 00       	call   8010556b <memmove>
801021db:	83 c4 10             	add    $0x10,%esp
        log_write(bp);
801021de:	83 ec 0c             	sub    $0xc,%esp
801021e1:	ff 75 f0             	pushl  -0x10(%ebp)
801021e4:	e8 c9 16 00 00       	call   801038b2 <log_write>
801021e9:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
801021ec:	83 ec 0c             	sub    $0xc,%esp
801021ef:	ff 75 f0             	pushl  -0x10(%ebp)
801021f2:	e8 14 e0 ff ff       	call   8010020b <brelse>
801021f7:	83 c4 10             	add    $0x10,%esp
    for (tot = 0; tot < n; tot += m, off += m, src += m) {
801021fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021fd:	01 45 f4             	add    %eax,-0xc(%ebp)
80102200:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102203:	01 45 10             	add    %eax,0x10(%ebp)
80102206:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102209:	01 45 0c             	add    %eax,0xc(%ebp)
8010220c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010220f:	3b 45 14             	cmp    0x14(%ebp),%eax
80102212:	0f 82 5d ff ff ff    	jb     80102175 <writei+0xba>
    }

    if (n > 0 && off > ip->size) {
80102218:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010221c:	74 22                	je     80102240 <writei+0x185>
8010221e:	8b 45 08             	mov    0x8(%ebp),%eax
80102221:	8b 40 18             	mov    0x18(%eax),%eax
80102224:	39 45 10             	cmp    %eax,0x10(%ebp)
80102227:	76 17                	jbe    80102240 <writei+0x185>
        ip->size = off;
80102229:	8b 45 08             	mov    0x8(%ebp),%eax
8010222c:	8b 55 10             	mov    0x10(%ebp),%edx
8010222f:	89 50 18             	mov    %edx,0x18(%eax)
        iupdate(ip);
80102232:	83 ec 0c             	sub    $0xc,%esp
80102235:	ff 75 08             	pushl  0x8(%ebp)
80102238:	e8 ba f5 ff ff       	call   801017f7 <iupdate>
8010223d:	83 c4 10             	add    $0x10,%esp
    }

    return n; // Always return the number of bytes written
80102240:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102243:	c9                   	leave  
80102244:	c3                   	ret    

80102245 <namecmp>:

// PAGEBREAK!
// Directories

int namecmp(const char *s, const char *t) { return strncmp(s, t, DIRSIZ); }
80102245:	f3 0f 1e fb          	endbr32 
80102249:	55                   	push   %ebp
8010224a:	89 e5                	mov    %esp,%ebp
8010224c:	83 ec 08             	sub    $0x8,%esp
8010224f:	83 ec 04             	sub    $0x4,%esp
80102252:	6a 0e                	push   $0xe
80102254:	ff 75 0c             	pushl  0xc(%ebp)
80102257:	ff 75 08             	pushl  0x8(%ebp)
8010225a:	e8 aa 33 00 00       	call   80105609 <strncmp>
8010225f:	83 c4 10             	add    $0x10,%esp
80102262:	c9                   	leave  
80102263:	c3                   	ret    

80102264 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *dirlookup(struct inode *dp, char *name, uint *poff) {
80102264:	f3 0f 1e fb          	endbr32 
80102268:	55                   	push   %ebp
80102269:	89 e5                	mov    %esp,%ebp
8010226b:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if (dp->type != T_DIR)
8010226e:	8b 45 08             	mov    0x8(%ebp),%eax
80102271:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102275:	66 83 f8 01          	cmp    $0x1,%ax
80102279:	74 0d                	je     80102288 <dirlookup+0x24>
    panic("dirlookup not DIR");
8010227b:	83 ec 0c             	sub    $0xc,%esp
8010227e:	68 87 9f 10 80       	push   $0x80109f87
80102283:	e8 db e2 ff ff       	call   80100563 <panic>

  for (off = 0; off < dp->size; off += sizeof(de)) {
80102288:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010228f:	eb 7b                	jmp    8010230c <dirlookup+0xa8>
    if (readi(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
80102291:	6a 10                	push   $0x10
80102293:	ff 75 f4             	pushl  -0xc(%ebp)
80102296:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102299:	50                   	push   %eax
8010229a:	ff 75 08             	pushl  0x8(%ebp)
8010229d:	e8 c0 fc ff ff       	call   80101f62 <readi>
801022a2:	83 c4 10             	add    $0x10,%esp
801022a5:	83 f8 10             	cmp    $0x10,%eax
801022a8:	74 0d                	je     801022b7 <dirlookup+0x53>
      panic("dirlink read");
801022aa:	83 ec 0c             	sub    $0xc,%esp
801022ad:	68 99 9f 10 80       	push   $0x80109f99
801022b2:	e8 ac e2 ff ff       	call   80100563 <panic>
    if (de.inum == 0)
801022b7:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801022bb:	66 85 c0             	test   %ax,%ax
801022be:	74 47                	je     80102307 <dirlookup+0xa3>
      continue;
    if (namecmp(name, de.name) == 0) {
801022c0:	83 ec 08             	sub    $0x8,%esp
801022c3:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022c6:	83 c0 02             	add    $0x2,%eax
801022c9:	50                   	push   %eax
801022ca:	ff 75 0c             	pushl  0xc(%ebp)
801022cd:	e8 73 ff ff ff       	call   80102245 <namecmp>
801022d2:	83 c4 10             	add    $0x10,%esp
801022d5:	85 c0                	test   %eax,%eax
801022d7:	75 2f                	jne    80102308 <dirlookup+0xa4>
      // entry matches path element
      if (poff)
801022d9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801022dd:	74 08                	je     801022e7 <dirlookup+0x83>
        *poff = off;
801022df:	8b 45 10             	mov    0x10(%ebp),%eax
801022e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801022e5:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
801022e7:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801022eb:	0f b7 c0             	movzwl %ax,%eax
801022ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
801022f1:	8b 45 08             	mov    0x8(%ebp),%eax
801022f4:	8b 00                	mov    (%eax),%eax
801022f6:	83 ec 08             	sub    $0x8,%esp
801022f9:	ff 75 f0             	pushl  -0x10(%ebp)
801022fc:	50                   	push   %eax
801022fd:	e8 ba f5 ff ff       	call   801018bc <iget>
80102302:	83 c4 10             	add    $0x10,%esp
80102305:	eb 19                	jmp    80102320 <dirlookup+0xbc>
      continue;
80102307:	90                   	nop
  for (off = 0; off < dp->size; off += sizeof(de)) {
80102308:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010230c:	8b 45 08             	mov    0x8(%ebp),%eax
8010230f:	8b 40 18             	mov    0x18(%eax),%eax
80102312:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80102315:	0f 82 76 ff ff ff    	jb     80102291 <dirlookup+0x2d>
    }
  }

  return 0;
8010231b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102320:	c9                   	leave  
80102321:	c3                   	ret    

80102322 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int dirlink(struct inode *dp, char *name, uint inum) {
80102322:	f3 0f 1e fb          	endbr32 
80102326:	55                   	push   %ebp
80102327:	89 e5                	mov    %esp,%ebp
80102329:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if ((ip = dirlookup(dp, name, 0)) != 0) {
8010232c:	83 ec 04             	sub    $0x4,%esp
8010232f:	6a 00                	push   $0x0
80102331:	ff 75 0c             	pushl  0xc(%ebp)
80102334:	ff 75 08             	pushl  0x8(%ebp)
80102337:	e8 28 ff ff ff       	call   80102264 <dirlookup>
8010233c:	83 c4 10             	add    $0x10,%esp
8010233f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102342:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102346:	74 18                	je     80102360 <dirlink+0x3e>
    iput(ip);
80102348:	83 ec 0c             	sub    $0xc,%esp
8010234b:	ff 75 f0             	pushl  -0x10(%ebp)
8010234e:	e8 62 f8 ff ff       	call   80101bb5 <iput>
80102353:	83 c4 10             	add    $0x10,%esp
    return -1;
80102356:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010235b:	e9 9c 00 00 00       	jmp    801023fc <dirlink+0xda>
  }

  // Look for an empty dirent.
  for (off = 0; off < dp->size; off += sizeof(de)) {
80102360:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102367:	eb 39                	jmp    801023a2 <dirlink+0x80>
    if (readi(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
80102369:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010236c:	6a 10                	push   $0x10
8010236e:	50                   	push   %eax
8010236f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102372:	50                   	push   %eax
80102373:	ff 75 08             	pushl  0x8(%ebp)
80102376:	e8 e7 fb ff ff       	call   80101f62 <readi>
8010237b:	83 c4 10             	add    $0x10,%esp
8010237e:	83 f8 10             	cmp    $0x10,%eax
80102381:	74 0d                	je     80102390 <dirlink+0x6e>
      panic("dirlink read");
80102383:	83 ec 0c             	sub    $0xc,%esp
80102386:	68 99 9f 10 80       	push   $0x80109f99
8010238b:	e8 d3 e1 ff ff       	call   80100563 <panic>
    if (de.inum == 0)
80102390:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102394:	66 85 c0             	test   %ax,%ax
80102397:	74 18                	je     801023b1 <dirlink+0x8f>
  for (off = 0; off < dp->size; off += sizeof(de)) {
80102399:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010239c:	83 c0 10             	add    $0x10,%eax
8010239f:	89 45 f4             	mov    %eax,-0xc(%ebp)
801023a2:	8b 45 08             	mov    0x8(%ebp),%eax
801023a5:	8b 50 18             	mov    0x18(%eax),%edx
801023a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023ab:	39 c2                	cmp    %eax,%edx
801023ad:	77 ba                	ja     80102369 <dirlink+0x47>
801023af:	eb 01                	jmp    801023b2 <dirlink+0x90>
      break;
801023b1:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
801023b2:	83 ec 04             	sub    $0x4,%esp
801023b5:	6a 0e                	push   $0xe
801023b7:	ff 75 0c             	pushl  0xc(%ebp)
801023ba:	8d 45 e0             	lea    -0x20(%ebp),%eax
801023bd:	83 c0 02             	add    $0x2,%eax
801023c0:	50                   	push   %eax
801023c1:	e8 9d 32 00 00       	call   80105663 <strncpy>
801023c6:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
801023c9:	8b 45 10             	mov    0x10(%ebp),%eax
801023cc:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if (writei(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
801023d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023d3:	6a 10                	push   $0x10
801023d5:	50                   	push   %eax
801023d6:	8d 45 e0             	lea    -0x20(%ebp),%eax
801023d9:	50                   	push   %eax
801023da:	ff 75 08             	pushl  0x8(%ebp)
801023dd:	e8 d9 fc ff ff       	call   801020bb <writei>
801023e2:	83 c4 10             	add    $0x10,%esp
801023e5:	83 f8 10             	cmp    $0x10,%eax
801023e8:	74 0d                	je     801023f7 <dirlink+0xd5>
    panic("dirlink");
801023ea:	83 ec 0c             	sub    $0xc,%esp
801023ed:	68 a6 9f 10 80       	push   $0x80109fa6
801023f2:	e8 6c e1 ff ff       	call   80100563 <panic>

  return 0;
801023f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801023fc:	c9                   	leave  
801023fd:	c3                   	ret    

801023fe <skipelem>:
//   skipelem("a/bb/c", name) = "bb/c", setting name = "a"
//   skipelem("///a//bb", name) = "bb", setting name = "a"
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char *skipelem(char *path, char *name) {
801023fe:	f3 0f 1e fb          	endbr32 
80102402:	55                   	push   %ebp
80102403:	89 e5                	mov    %esp,%ebp
80102405:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while (*path == '/')
80102408:	eb 04                	jmp    8010240e <skipelem+0x10>
    path++;
8010240a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while (*path == '/')
8010240e:	8b 45 08             	mov    0x8(%ebp),%eax
80102411:	0f b6 00             	movzbl (%eax),%eax
80102414:	3c 2f                	cmp    $0x2f,%al
80102416:	74 f2                	je     8010240a <skipelem+0xc>
  if (*path == 0)
80102418:	8b 45 08             	mov    0x8(%ebp),%eax
8010241b:	0f b6 00             	movzbl (%eax),%eax
8010241e:	84 c0                	test   %al,%al
80102420:	75 07                	jne    80102429 <skipelem+0x2b>
    return 0;
80102422:	b8 00 00 00 00       	mov    $0x0,%eax
80102427:	eb 77                	jmp    801024a0 <skipelem+0xa2>
  s = path;
80102429:	8b 45 08             	mov    0x8(%ebp),%eax
8010242c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (*path != '/' && *path != 0)
8010242f:	eb 04                	jmp    80102435 <skipelem+0x37>
    path++;
80102431:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while (*path != '/' && *path != 0)
80102435:	8b 45 08             	mov    0x8(%ebp),%eax
80102438:	0f b6 00             	movzbl (%eax),%eax
8010243b:	3c 2f                	cmp    $0x2f,%al
8010243d:	74 0a                	je     80102449 <skipelem+0x4b>
8010243f:	8b 45 08             	mov    0x8(%ebp),%eax
80102442:	0f b6 00             	movzbl (%eax),%eax
80102445:	84 c0                	test   %al,%al
80102447:	75 e8                	jne    80102431 <skipelem+0x33>
  len = path - s;
80102449:	8b 45 08             	mov    0x8(%ebp),%eax
8010244c:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010244f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if (len >= DIRSIZ)
80102452:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80102456:	7e 15                	jle    8010246d <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
80102458:	83 ec 04             	sub    $0x4,%esp
8010245b:	6a 0e                	push   $0xe
8010245d:	ff 75 f4             	pushl  -0xc(%ebp)
80102460:	ff 75 0c             	pushl  0xc(%ebp)
80102463:	e8 03 31 00 00       	call   8010556b <memmove>
80102468:	83 c4 10             	add    $0x10,%esp
8010246b:	eb 26                	jmp    80102493 <skipelem+0x95>
  else {
    memmove(name, s, len);
8010246d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102470:	83 ec 04             	sub    $0x4,%esp
80102473:	50                   	push   %eax
80102474:	ff 75 f4             	pushl  -0xc(%ebp)
80102477:	ff 75 0c             	pushl  0xc(%ebp)
8010247a:	e8 ec 30 00 00       	call   8010556b <memmove>
8010247f:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
80102482:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102485:	8b 45 0c             	mov    0xc(%ebp),%eax
80102488:	01 d0                	add    %edx,%eax
8010248a:	c6 00 00             	movb   $0x0,(%eax)
  }
  while (*path == '/')
8010248d:	eb 04                	jmp    80102493 <skipelem+0x95>
    path++;
8010248f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while (*path == '/')
80102493:	8b 45 08             	mov    0x8(%ebp),%eax
80102496:	0f b6 00             	movzbl (%eax),%eax
80102499:	3c 2f                	cmp    $0x2f,%al
8010249b:	74 f2                	je     8010248f <skipelem+0x91>
  return path;
8010249d:	8b 45 08             	mov    0x8(%ebp),%eax
}
801024a0:	c9                   	leave  
801024a1:	c3                   	ret    

801024a2 <namex>:

// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *namex(char *path, int nameiparent, char *name) {
801024a2:	f3 0f 1e fb          	endbr32 
801024a6:	55                   	push   %ebp
801024a7:	89 e5                	mov    %esp,%ebp
801024a9:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if (*path == '/')
801024ac:	8b 45 08             	mov    0x8(%ebp),%eax
801024af:	0f b6 00             	movzbl (%eax),%eax
801024b2:	3c 2f                	cmp    $0x2f,%al
801024b4:	75 17                	jne    801024cd <namex+0x2b>
    ip = iget(ROOTDEV, ROOTINO);
801024b6:	83 ec 08             	sub    $0x8,%esp
801024b9:	6a 01                	push   $0x1
801024bb:	6a 01                	push   $0x1
801024bd:	e8 fa f3 ff ff       	call   801018bc <iget>
801024c2:	83 c4 10             	add    $0x10,%esp
801024c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801024c8:	e9 bb 00 00 00       	jmp    80102588 <namex+0xe6>
  else
    ip = idup(proc->cwd);
801024cd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801024d3:	8b 40 68             	mov    0x68(%eax),%eax
801024d6:	83 ec 0c             	sub    $0xc,%esp
801024d9:	50                   	push   %eax
801024da:	e8 c0 f4 ff ff       	call   8010199f <idup>
801024df:	83 c4 10             	add    $0x10,%esp
801024e2:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while ((path = skipelem(path, name)) != 0) {
801024e5:	e9 9e 00 00 00       	jmp    80102588 <namex+0xe6>
    ilock(ip);
801024ea:	83 ec 0c             	sub    $0xc,%esp
801024ed:	ff 75 f4             	pushl  -0xc(%ebp)
801024f0:	e8 e8 f4 ff ff       	call   801019dd <ilock>
801024f5:	83 c4 10             	add    $0x10,%esp
    if (ip->type != T_DIR) {
801024f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024fb:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801024ff:	66 83 f8 01          	cmp    $0x1,%ax
80102503:	74 18                	je     8010251d <namex+0x7b>
      iunlockput(ip);
80102505:	83 ec 0c             	sub    $0xc,%esp
80102508:	ff 75 f4             	pushl  -0xc(%ebp)
8010250b:	e8 99 f7 ff ff       	call   80101ca9 <iunlockput>
80102510:	83 c4 10             	add    $0x10,%esp
      return 0;
80102513:	b8 00 00 00 00       	mov    $0x0,%eax
80102518:	e9 a7 00 00 00       	jmp    801025c4 <namex+0x122>
    }
    if (nameiparent && *path == '\0') {
8010251d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102521:	74 20                	je     80102543 <namex+0xa1>
80102523:	8b 45 08             	mov    0x8(%ebp),%eax
80102526:	0f b6 00             	movzbl (%eax),%eax
80102529:	84 c0                	test   %al,%al
8010252b:	75 16                	jne    80102543 <namex+0xa1>
      // Stop one level early.
      iunlock(ip);
8010252d:	83 ec 0c             	sub    $0xc,%esp
80102530:	ff 75 f4             	pushl  -0xc(%ebp)
80102533:	e8 07 f6 ff ff       	call   80101b3f <iunlock>
80102538:	83 c4 10             	add    $0x10,%esp
      return ip;
8010253b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010253e:	e9 81 00 00 00       	jmp    801025c4 <namex+0x122>
    }
    if ((next = dirlookup(ip, name, 0)) == 0) {
80102543:	83 ec 04             	sub    $0x4,%esp
80102546:	6a 00                	push   $0x0
80102548:	ff 75 10             	pushl  0x10(%ebp)
8010254b:	ff 75 f4             	pushl  -0xc(%ebp)
8010254e:	e8 11 fd ff ff       	call   80102264 <dirlookup>
80102553:	83 c4 10             	add    $0x10,%esp
80102556:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102559:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010255d:	75 15                	jne    80102574 <namex+0xd2>
      iunlockput(ip);
8010255f:	83 ec 0c             	sub    $0xc,%esp
80102562:	ff 75 f4             	pushl  -0xc(%ebp)
80102565:	e8 3f f7 ff ff       	call   80101ca9 <iunlockput>
8010256a:	83 c4 10             	add    $0x10,%esp
      return 0;
8010256d:	b8 00 00 00 00       	mov    $0x0,%eax
80102572:	eb 50                	jmp    801025c4 <namex+0x122>
    }
    iunlockput(ip);
80102574:	83 ec 0c             	sub    $0xc,%esp
80102577:	ff 75 f4             	pushl  -0xc(%ebp)
8010257a:	e8 2a f7 ff ff       	call   80101ca9 <iunlockput>
8010257f:	83 c4 10             	add    $0x10,%esp
    ip = next;
80102582:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102585:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while ((path = skipelem(path, name)) != 0) {
80102588:	83 ec 08             	sub    $0x8,%esp
8010258b:	ff 75 10             	pushl  0x10(%ebp)
8010258e:	ff 75 08             	pushl  0x8(%ebp)
80102591:	e8 68 fe ff ff       	call   801023fe <skipelem>
80102596:	83 c4 10             	add    $0x10,%esp
80102599:	89 45 08             	mov    %eax,0x8(%ebp)
8010259c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025a0:	0f 85 44 ff ff ff    	jne    801024ea <namex+0x48>
  }
  if (nameiparent) {
801025a6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801025aa:	74 15                	je     801025c1 <namex+0x11f>
    iput(ip);
801025ac:	83 ec 0c             	sub    $0xc,%esp
801025af:	ff 75 f4             	pushl  -0xc(%ebp)
801025b2:	e8 fe f5 ff ff       	call   80101bb5 <iput>
801025b7:	83 c4 10             	add    $0x10,%esp
    return 0;
801025ba:	b8 00 00 00 00       	mov    $0x0,%eax
801025bf:	eb 03                	jmp    801025c4 <namex+0x122>
  }
  return ip;
801025c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801025c4:	c9                   	leave  
801025c5:	c3                   	ret    

801025c6 <namei>:

struct inode *namei(char *path) {
801025c6:	f3 0f 1e fb          	endbr32 
801025ca:	55                   	push   %ebp
801025cb:	89 e5                	mov    %esp,%ebp
801025cd:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801025d0:	83 ec 04             	sub    $0x4,%esp
801025d3:	8d 45 ea             	lea    -0x16(%ebp),%eax
801025d6:	50                   	push   %eax
801025d7:	6a 00                	push   $0x0
801025d9:	ff 75 08             	pushl  0x8(%ebp)
801025dc:	e8 c1 fe ff ff       	call   801024a2 <namex>
801025e1:	83 c4 10             	add    $0x10,%esp
}
801025e4:	c9                   	leave  
801025e5:	c3                   	ret    

801025e6 <nameiparent>:

struct inode *nameiparent(char *path, char *name) {
801025e6:	f3 0f 1e fb          	endbr32 
801025ea:	55                   	push   %ebp
801025eb:	89 e5                	mov    %esp,%ebp
801025ed:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
801025f0:	83 ec 04             	sub    $0x4,%esp
801025f3:	ff 75 0c             	pushl  0xc(%ebp)
801025f6:	6a 01                	push   $0x1
801025f8:	ff 75 08             	pushl  0x8(%ebp)
801025fb:	e8 a2 fe ff ff       	call   801024a2 <namex>
80102600:	83 c4 10             	add    $0x10,%esp
}
80102603:	c9                   	leave  
80102604:	c3                   	ret    

80102605 <inb>:
{
80102605:	55                   	push   %ebp
80102606:	89 e5                	mov    %esp,%ebp
80102608:	83 ec 14             	sub    $0x14,%esp
8010260b:	8b 45 08             	mov    0x8(%ebp),%eax
8010260e:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102612:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102616:	89 c2                	mov    %eax,%edx
80102618:	ec                   	in     (%dx),%al
80102619:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010261c:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102620:	c9                   	leave  
80102621:	c3                   	ret    

80102622 <insl>:
{
80102622:	55                   	push   %ebp
80102623:	89 e5                	mov    %esp,%ebp
80102625:	57                   	push   %edi
80102626:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
80102627:	8b 55 08             	mov    0x8(%ebp),%edx
8010262a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010262d:	8b 45 10             	mov    0x10(%ebp),%eax
80102630:	89 cb                	mov    %ecx,%ebx
80102632:	89 df                	mov    %ebx,%edi
80102634:	89 c1                	mov    %eax,%ecx
80102636:	fc                   	cld    
80102637:	f3 6d                	rep insl (%dx),%es:(%edi)
80102639:	89 c8                	mov    %ecx,%eax
8010263b:	89 fb                	mov    %edi,%ebx
8010263d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102640:	89 45 10             	mov    %eax,0x10(%ebp)
}
80102643:	90                   	nop
80102644:	5b                   	pop    %ebx
80102645:	5f                   	pop    %edi
80102646:	5d                   	pop    %ebp
80102647:	c3                   	ret    

80102648 <outb>:
{
80102648:	55                   	push   %ebp
80102649:	89 e5                	mov    %esp,%ebp
8010264b:	83 ec 08             	sub    $0x8,%esp
8010264e:	8b 45 08             	mov    0x8(%ebp),%eax
80102651:	8b 55 0c             	mov    0xc(%ebp),%edx
80102654:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80102658:	89 d0                	mov    %edx,%eax
8010265a:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010265d:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102661:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102665:	ee                   	out    %al,(%dx)
}
80102666:	90                   	nop
80102667:	c9                   	leave  
80102668:	c3                   	ret    

80102669 <outsl>:
{
80102669:	55                   	push   %ebp
8010266a:	89 e5                	mov    %esp,%ebp
8010266c:	56                   	push   %esi
8010266d:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
8010266e:	8b 55 08             	mov    0x8(%ebp),%edx
80102671:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102674:	8b 45 10             	mov    0x10(%ebp),%eax
80102677:	89 cb                	mov    %ecx,%ebx
80102679:	89 de                	mov    %ebx,%esi
8010267b:	89 c1                	mov    %eax,%ecx
8010267d:	fc                   	cld    
8010267e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102680:	89 c8                	mov    %ecx,%eax
80102682:	89 f3                	mov    %esi,%ebx
80102684:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102687:	89 45 10             	mov    %eax,0x10(%ebp)
}
8010268a:	90                   	nop
8010268b:	5b                   	pop    %ebx
8010268c:	5e                   	pop    %esi
8010268d:	5d                   	pop    %ebp
8010268e:	c3                   	ret    

8010268f <idewait>:

static int havedisk1;
static void idestart(struct buf *);

// Wait for IDE disk to become ready.
static int idewait(int checkerr) {
8010268f:	f3 0f 1e fb          	endbr32 
80102693:	55                   	push   %ebp
80102694:	89 e5                	mov    %esp,%ebp
80102696:	83 ec 10             	sub    $0x10,%esp
  int r;

  while (((r = inb(0x1f7)) & (IDE_BSY | IDE_DRDY)) != IDE_DRDY)
80102699:	90                   	nop
8010269a:	68 f7 01 00 00       	push   $0x1f7
8010269f:	e8 61 ff ff ff       	call   80102605 <inb>
801026a4:	83 c4 04             	add    $0x4,%esp
801026a7:	0f b6 c0             	movzbl %al,%eax
801026aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
801026ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
801026b0:	25 c0 00 00 00       	and    $0xc0,%eax
801026b5:	83 f8 40             	cmp    $0x40,%eax
801026b8:	75 e0                	jne    8010269a <idewait+0xb>
    ;
  if (checkerr && (r & (IDE_DF | IDE_ERR)) != 0)
801026ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801026be:	74 11                	je     801026d1 <idewait+0x42>
801026c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801026c3:	83 e0 21             	and    $0x21,%eax
801026c6:	85 c0                	test   %eax,%eax
801026c8:	74 07                	je     801026d1 <idewait+0x42>
    return -1;
801026ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801026cf:	eb 05                	jmp    801026d6 <idewait+0x47>
  return 0;
801026d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801026d6:	c9                   	leave  
801026d7:	c3                   	ret    

801026d8 <ideinit>:

void ideinit(void) {
801026d8:	f3 0f 1e fb          	endbr32 
801026dc:	55                   	push   %ebp
801026dd:	89 e5                	mov    %esp,%ebp
801026df:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
801026e2:	83 ec 08             	sub    $0x8,%esp
801026e5:	68 ae 9f 10 80       	push   $0x80109fae
801026ea:	68 c0 d6 10 80       	push   $0x8010d6c0
801026ef:	e8 0e 2b 00 00       	call   80105202 <initlock>
801026f4:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
801026f7:	83 ec 0c             	sub    $0xc,%esp
801026fa:	6a 0e                	push   $0xe
801026fc:	e8 a4 19 00 00       	call   801040a5 <picenable>
80102701:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
80102704:	a1 20 3a 11 80       	mov    0x80113a20,%eax
80102709:	83 e8 01             	sub    $0x1,%eax
8010270c:	83 ec 08             	sub    $0x8,%esp
8010270f:	50                   	push   %eax
80102710:	6a 0e                	push   $0xe
80102712:	e8 8b 04 00 00       	call   80102ba2 <ioapicenable>
80102717:	83 c4 10             	add    $0x10,%esp
  idewait(0);
8010271a:	83 ec 0c             	sub    $0xc,%esp
8010271d:	6a 00                	push   $0x0
8010271f:	e8 6b ff ff ff       	call   8010268f <idewait>
80102724:	83 c4 10             	add    $0x10,%esp

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1 << 4));
80102727:	83 ec 08             	sub    $0x8,%esp
8010272a:	68 f0 00 00 00       	push   $0xf0
8010272f:	68 f6 01 00 00       	push   $0x1f6
80102734:	e8 0f ff ff ff       	call   80102648 <outb>
80102739:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < 1000; i++) {
8010273c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102743:	eb 24                	jmp    80102769 <ideinit+0x91>
    if (inb(0x1f7) != 0) {
80102745:	83 ec 0c             	sub    $0xc,%esp
80102748:	68 f7 01 00 00       	push   $0x1f7
8010274d:	e8 b3 fe ff ff       	call   80102605 <inb>
80102752:	83 c4 10             	add    $0x10,%esp
80102755:	84 c0                	test   %al,%al
80102757:	74 0c                	je     80102765 <ideinit+0x8d>
      havedisk1 = 1;
80102759:	c7 05 f8 d6 10 80 01 	movl   $0x1,0x8010d6f8
80102760:	00 00 00 
      break;
80102763:	eb 0d                	jmp    80102772 <ideinit+0x9a>
  for (i = 0; i < 1000; i++) {
80102765:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102769:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102770:	7e d3                	jle    80102745 <ideinit+0x6d>
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0 << 4));
80102772:	83 ec 08             	sub    $0x8,%esp
80102775:	68 e0 00 00 00       	push   $0xe0
8010277a:	68 f6 01 00 00       	push   $0x1f6
8010277f:	e8 c4 fe ff ff       	call   80102648 <outb>
80102784:	83 c4 10             	add    $0x10,%esp
}
80102787:	90                   	nop
80102788:	c9                   	leave  
80102789:	c3                   	ret    

8010278a <idestart>:

// Start the request for b.  Caller must hold idelock.
static void idestart(struct buf *b) {
8010278a:	f3 0f 1e fb          	endbr32 
8010278e:	55                   	push   %ebp
8010278f:	89 e5                	mov    %esp,%ebp
80102791:	83 ec 18             	sub    $0x18,%esp
  if (b == 0)
80102794:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102798:	75 0d                	jne    801027a7 <idestart+0x1d>
    panic("idestart");
8010279a:	83 ec 0c             	sub    $0xc,%esp
8010279d:	68 b2 9f 10 80       	push   $0x80109fb2
801027a2:	e8 bc dd ff ff       	call   80100563 <panic>
  if (b->blockno >= FSSIZE)
801027a7:	8b 45 08             	mov    0x8(%ebp),%eax
801027aa:	8b 40 08             	mov    0x8(%eax),%eax
801027ad:	3d e7 03 00 00       	cmp    $0x3e7,%eax
801027b2:	76 0d                	jbe    801027c1 <idestart+0x37>
    panic("incorrect blockno");
801027b4:	83 ec 0c             	sub    $0xc,%esp
801027b7:	68 bb 9f 10 80       	push   $0x80109fbb
801027bc:	e8 a2 dd ff ff       	call   80100563 <panic>
  int sector_per_block = BSIZE / SECTOR_SIZE;
801027c1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
801027c8:	8b 45 08             	mov    0x8(%ebp),%eax
801027cb:	8b 50 08             	mov    0x8(%eax),%edx
801027ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027d1:	0f af c2             	imul   %edx,%eax
801027d4:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (sector_per_block > 7)
801027d7:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
801027db:	7e 0d                	jle    801027ea <idestart+0x60>
    panic("idestart");
801027dd:	83 ec 0c             	sub    $0xc,%esp
801027e0:	68 b2 9f 10 80       	push   $0x80109fb2
801027e5:	e8 79 dd ff ff       	call   80100563 <panic>

  idewait(0);
801027ea:	83 ec 0c             	sub    $0xc,%esp
801027ed:	6a 00                	push   $0x0
801027ef:	e8 9b fe ff ff       	call   8010268f <idewait>
801027f4:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);                // generate interrupt
801027f7:	83 ec 08             	sub    $0x8,%esp
801027fa:	6a 00                	push   $0x0
801027fc:	68 f6 03 00 00       	push   $0x3f6
80102801:	e8 42 fe ff ff       	call   80102648 <outb>
80102806:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block); // number of sectors
80102809:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010280c:	0f b6 c0             	movzbl %al,%eax
8010280f:	83 ec 08             	sub    $0x8,%esp
80102812:	50                   	push   %eax
80102813:	68 f2 01 00 00       	push   $0x1f2
80102818:	e8 2b fe ff ff       	call   80102648 <outb>
8010281d:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
80102820:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102823:	0f b6 c0             	movzbl %al,%eax
80102826:	83 ec 08             	sub    $0x8,%esp
80102829:	50                   	push   %eax
8010282a:	68 f3 01 00 00       	push   $0x1f3
8010282f:	e8 14 fe ff ff       	call   80102648 <outb>
80102834:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
80102837:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010283a:	c1 f8 08             	sar    $0x8,%eax
8010283d:	0f b6 c0             	movzbl %al,%eax
80102840:	83 ec 08             	sub    $0x8,%esp
80102843:	50                   	push   %eax
80102844:	68 f4 01 00 00       	push   $0x1f4
80102849:	e8 fa fd ff ff       	call   80102648 <outb>
8010284e:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
80102851:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102854:	c1 f8 10             	sar    $0x10,%eax
80102857:	0f b6 c0             	movzbl %al,%eax
8010285a:	83 ec 08             	sub    $0x8,%esp
8010285d:	50                   	push   %eax
8010285e:	68 f5 01 00 00       	push   $0x1f5
80102863:	e8 e0 fd ff ff       	call   80102648 <outb>
80102868:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev & 1) << 4) | ((sector >> 24) & 0x0f));
8010286b:	8b 45 08             	mov    0x8(%ebp),%eax
8010286e:	8b 40 04             	mov    0x4(%eax),%eax
80102871:	c1 e0 04             	shl    $0x4,%eax
80102874:	83 e0 10             	and    $0x10,%eax
80102877:	89 c2                	mov    %eax,%edx
80102879:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010287c:	c1 f8 18             	sar    $0x18,%eax
8010287f:	83 e0 0f             	and    $0xf,%eax
80102882:	09 d0                	or     %edx,%eax
80102884:	83 c8 e0             	or     $0xffffffe0,%eax
80102887:	0f b6 c0             	movzbl %al,%eax
8010288a:	83 ec 08             	sub    $0x8,%esp
8010288d:	50                   	push   %eax
8010288e:	68 f6 01 00 00       	push   $0x1f6
80102893:	e8 b0 fd ff ff       	call   80102648 <outb>
80102898:	83 c4 10             	add    $0x10,%esp
  if (b->flags & B_DIRTY) {
8010289b:	8b 45 08             	mov    0x8(%ebp),%eax
8010289e:	8b 00                	mov    (%eax),%eax
801028a0:	83 e0 04             	and    $0x4,%eax
801028a3:	85 c0                	test   %eax,%eax
801028a5:	74 30                	je     801028d7 <idestart+0x14d>
    outb(0x1f7, IDE_CMD_WRITE);
801028a7:	83 ec 08             	sub    $0x8,%esp
801028aa:	6a 30                	push   $0x30
801028ac:	68 f7 01 00 00       	push   $0x1f7
801028b1:	e8 92 fd ff ff       	call   80102648 <outb>
801028b6:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE / 4);
801028b9:	8b 45 08             	mov    0x8(%ebp),%eax
801028bc:	83 c0 18             	add    $0x18,%eax
801028bf:	83 ec 04             	sub    $0x4,%esp
801028c2:	68 80 00 00 00       	push   $0x80
801028c7:	50                   	push   %eax
801028c8:	68 f0 01 00 00       	push   $0x1f0
801028cd:	e8 97 fd ff ff       	call   80102669 <outsl>
801028d2:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
801028d5:	eb 12                	jmp    801028e9 <idestart+0x15f>
    outb(0x1f7, IDE_CMD_READ);
801028d7:	83 ec 08             	sub    $0x8,%esp
801028da:	6a 20                	push   $0x20
801028dc:	68 f7 01 00 00       	push   $0x1f7
801028e1:	e8 62 fd ff ff       	call   80102648 <outb>
801028e6:	83 c4 10             	add    $0x10,%esp
}
801028e9:	90                   	nop
801028ea:	c9                   	leave  
801028eb:	c3                   	ret    

801028ec <ideintr>:

// Interrupt handler.
void ideintr(void) {
801028ec:	f3 0f 1e fb          	endbr32 
801028f0:	55                   	push   %ebp
801028f1:	89 e5                	mov    %esp,%ebp
801028f3:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801028f6:	83 ec 0c             	sub    $0xc,%esp
801028f9:	68 c0 d6 10 80       	push   $0x8010d6c0
801028fe:	e8 25 29 00 00       	call   80105228 <acquire>
80102903:	83 c4 10             	add    $0x10,%esp
  if ((b = idequeue) == 0) {
80102906:	a1 f4 d6 10 80       	mov    0x8010d6f4,%eax
8010290b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010290e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102912:	75 15                	jne    80102929 <ideintr+0x3d>
    release(&idelock);
80102914:	83 ec 0c             	sub    $0xc,%esp
80102917:	68 c0 d6 10 80       	push   $0x8010d6c0
8010291c:	e8 72 29 00 00       	call   80105293 <release>
80102921:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
80102924:	e9 9a 00 00 00       	jmp    801029c3 <ideintr+0xd7>
  }
  idequeue = b->qnext;
80102929:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010292c:	8b 40 14             	mov    0x14(%eax),%eax
8010292f:	a3 f4 d6 10 80       	mov    %eax,0x8010d6f4

  // Read data if needed.
  if (!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102934:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102937:	8b 00                	mov    (%eax),%eax
80102939:	83 e0 04             	and    $0x4,%eax
8010293c:	85 c0                	test   %eax,%eax
8010293e:	75 2d                	jne    8010296d <ideintr+0x81>
80102940:	83 ec 0c             	sub    $0xc,%esp
80102943:	6a 01                	push   $0x1
80102945:	e8 45 fd ff ff       	call   8010268f <idewait>
8010294a:	83 c4 10             	add    $0x10,%esp
8010294d:	85 c0                	test   %eax,%eax
8010294f:	78 1c                	js     8010296d <ideintr+0x81>
    insl(0x1f0, b->data, BSIZE / 4);
80102951:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102954:	83 c0 18             	add    $0x18,%eax
80102957:	83 ec 04             	sub    $0x4,%esp
8010295a:	68 80 00 00 00       	push   $0x80
8010295f:	50                   	push   %eax
80102960:	68 f0 01 00 00       	push   $0x1f0
80102965:	e8 b8 fc ff ff       	call   80102622 <insl>
8010296a:	83 c4 10             	add    $0x10,%esp

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010296d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102970:	8b 00                	mov    (%eax),%eax
80102972:	83 c8 02             	or     $0x2,%eax
80102975:	89 c2                	mov    %eax,%edx
80102977:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010297a:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
8010297c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010297f:	8b 00                	mov    (%eax),%eax
80102981:	83 e0 fb             	and    $0xfffffffb,%eax
80102984:	89 c2                	mov    %eax,%edx
80102986:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102989:	89 10                	mov    %edx,(%eax)
  wakeup(b);
8010298b:	83 ec 0c             	sub    $0xc,%esp
8010298e:	ff 75 f4             	pushl  -0xc(%ebp)
80102991:	e8 73 26 00 00       	call   80105009 <wakeup>
80102996:	83 c4 10             	add    $0x10,%esp

  // Start disk on next buf in queue.
  if (idequeue != 0)
80102999:	a1 f4 d6 10 80       	mov    0x8010d6f4,%eax
8010299e:	85 c0                	test   %eax,%eax
801029a0:	74 11                	je     801029b3 <ideintr+0xc7>
    idestart(idequeue);
801029a2:	a1 f4 d6 10 80       	mov    0x8010d6f4,%eax
801029a7:	83 ec 0c             	sub    $0xc,%esp
801029aa:	50                   	push   %eax
801029ab:	e8 da fd ff ff       	call   8010278a <idestart>
801029b0:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
801029b3:	83 ec 0c             	sub    $0xc,%esp
801029b6:	68 c0 d6 10 80       	push   $0x8010d6c0
801029bb:	e8 d3 28 00 00       	call   80105293 <release>
801029c0:	83 c4 10             	add    $0x10,%esp
}
801029c3:	c9                   	leave  
801029c4:	c3                   	ret    

801029c5 <iderw>:

// PAGEBREAK!
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void iderw(struct buf *b) {
801029c5:	f3 0f 1e fb          	endbr32 
801029c9:	55                   	push   %ebp
801029ca:	89 e5                	mov    %esp,%ebp
801029cc:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if (!(b->flags & B_BUSY))
801029cf:	8b 45 08             	mov    0x8(%ebp),%eax
801029d2:	8b 00                	mov    (%eax),%eax
801029d4:	83 e0 01             	and    $0x1,%eax
801029d7:	85 c0                	test   %eax,%eax
801029d9:	75 0d                	jne    801029e8 <iderw+0x23>
    panic("iderw: buf not busy");
801029db:	83 ec 0c             	sub    $0xc,%esp
801029de:	68 cd 9f 10 80       	push   $0x80109fcd
801029e3:	e8 7b db ff ff       	call   80100563 <panic>
  if ((b->flags & (B_VALID | B_DIRTY)) == B_VALID)
801029e8:	8b 45 08             	mov    0x8(%ebp),%eax
801029eb:	8b 00                	mov    (%eax),%eax
801029ed:	83 e0 06             	and    $0x6,%eax
801029f0:	83 f8 02             	cmp    $0x2,%eax
801029f3:	75 0d                	jne    80102a02 <iderw+0x3d>
    panic("iderw: nothing to do");
801029f5:	83 ec 0c             	sub    $0xc,%esp
801029f8:	68 e1 9f 10 80       	push   $0x80109fe1
801029fd:	e8 61 db ff ff       	call   80100563 <panic>
  if (b->dev != 0 && !havedisk1)
80102a02:	8b 45 08             	mov    0x8(%ebp),%eax
80102a05:	8b 40 04             	mov    0x4(%eax),%eax
80102a08:	85 c0                	test   %eax,%eax
80102a0a:	74 16                	je     80102a22 <iderw+0x5d>
80102a0c:	a1 f8 d6 10 80       	mov    0x8010d6f8,%eax
80102a11:	85 c0                	test   %eax,%eax
80102a13:	75 0d                	jne    80102a22 <iderw+0x5d>
    panic("iderw: ide disk 1 not present");
80102a15:	83 ec 0c             	sub    $0xc,%esp
80102a18:	68 f6 9f 10 80       	push   $0x80109ff6
80102a1d:	e8 41 db ff ff       	call   80100563 <panic>

  acquire(&idelock); // DOC:acquire-lock
80102a22:	83 ec 0c             	sub    $0xc,%esp
80102a25:	68 c0 d6 10 80       	push   $0x8010d6c0
80102a2a:	e8 f9 27 00 00       	call   80105228 <acquire>
80102a2f:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
80102a32:	8b 45 08             	mov    0x8(%ebp),%eax
80102a35:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for (pp = &idequeue; *pp; pp = &(*pp)->qnext) // DOC:insert-queue
80102a3c:	c7 45 f4 f4 d6 10 80 	movl   $0x8010d6f4,-0xc(%ebp)
80102a43:	eb 0b                	jmp    80102a50 <iderw+0x8b>
80102a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a48:	8b 00                	mov    (%eax),%eax
80102a4a:	83 c0 14             	add    $0x14,%eax
80102a4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a53:	8b 00                	mov    (%eax),%eax
80102a55:	85 c0                	test   %eax,%eax
80102a57:	75 ec                	jne    80102a45 <iderw+0x80>
    ;
  *pp = b;
80102a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a5c:	8b 55 08             	mov    0x8(%ebp),%edx
80102a5f:	89 10                	mov    %edx,(%eax)

  // Start disk if necessary.
  if (idequeue == b)
80102a61:	a1 f4 d6 10 80       	mov    0x8010d6f4,%eax
80102a66:	39 45 08             	cmp    %eax,0x8(%ebp)
80102a69:	75 23                	jne    80102a8e <iderw+0xc9>
    idestart(b);
80102a6b:	83 ec 0c             	sub    $0xc,%esp
80102a6e:	ff 75 08             	pushl  0x8(%ebp)
80102a71:	e8 14 fd ff ff       	call   8010278a <idestart>
80102a76:	83 c4 10             	add    $0x10,%esp

  // Wait for request to finish.
  while ((b->flags & (B_VALID | B_DIRTY)) != B_VALID) {
80102a79:	eb 13                	jmp    80102a8e <iderw+0xc9>
    sleep(b, &idelock);
80102a7b:	83 ec 08             	sub    $0x8,%esp
80102a7e:	68 c0 d6 10 80       	push   $0x8010d6c0
80102a83:	ff 75 08             	pushl  0x8(%ebp)
80102a86:	e8 8a 24 00 00       	call   80104f15 <sleep>
80102a8b:	83 c4 10             	add    $0x10,%esp
  while ((b->flags & (B_VALID | B_DIRTY)) != B_VALID) {
80102a8e:	8b 45 08             	mov    0x8(%ebp),%eax
80102a91:	8b 00                	mov    (%eax),%eax
80102a93:	83 e0 06             	and    $0x6,%eax
80102a96:	83 f8 02             	cmp    $0x2,%eax
80102a99:	75 e0                	jne    80102a7b <iderw+0xb6>
  }

  release(&idelock);
80102a9b:	83 ec 0c             	sub    $0xc,%esp
80102a9e:	68 c0 d6 10 80       	push   $0x8010d6c0
80102aa3:	e8 eb 27 00 00       	call   80105293 <release>
80102aa8:	83 c4 10             	add    $0x10,%esp
}
80102aab:	90                   	nop
80102aac:	c9                   	leave  
80102aad:	c3                   	ret    

80102aae <ioapicread>:
  uint reg;
  uint pad[3];
  uint data;
};

static uint ioapicread(int reg) {
80102aae:	f3 0f 1e fb          	endbr32 
80102ab2:	55                   	push   %ebp
80102ab3:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102ab5:	a1 f4 32 11 80       	mov    0x801132f4,%eax
80102aba:	8b 55 08             	mov    0x8(%ebp),%edx
80102abd:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102abf:	a1 f4 32 11 80       	mov    0x801132f4,%eax
80102ac4:	8b 40 10             	mov    0x10(%eax),%eax
}
80102ac7:	5d                   	pop    %ebp
80102ac8:	c3                   	ret    

80102ac9 <ioapicwrite>:

static void ioapicwrite(int reg, uint data) {
80102ac9:	f3 0f 1e fb          	endbr32 
80102acd:	55                   	push   %ebp
80102ace:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102ad0:	a1 f4 32 11 80       	mov    0x801132f4,%eax
80102ad5:	8b 55 08             	mov    0x8(%ebp),%edx
80102ad8:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102ada:	a1 f4 32 11 80       	mov    0x801132f4,%eax
80102adf:	8b 55 0c             	mov    0xc(%ebp),%edx
80102ae2:	89 50 10             	mov    %edx,0x10(%eax)
}
80102ae5:	90                   	nop
80102ae6:	5d                   	pop    %ebp
80102ae7:	c3                   	ret    

80102ae8 <ioapicinit>:

void ioapicinit(void) {
80102ae8:	f3 0f 1e fb          	endbr32 
80102aec:	55                   	push   %ebp
80102aed:	89 e5                	mov    %esp,%ebp
80102aef:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if (!ismp)
80102af2:	a1 24 34 11 80       	mov    0x80113424,%eax
80102af7:	85 c0                	test   %eax,%eax
80102af9:	0f 84 a0 00 00 00    	je     80102b9f <ioapicinit+0xb7>
    return;

  ioapic = (volatile struct ioapic *)IOAPIC;
80102aff:	c7 05 f4 32 11 80 00 	movl   $0xfec00000,0x801132f4
80102b06:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102b09:	6a 01                	push   $0x1
80102b0b:	e8 9e ff ff ff       	call   80102aae <ioapicread>
80102b10:	83 c4 04             	add    $0x4,%esp
80102b13:	c1 e8 10             	shr    $0x10,%eax
80102b16:	25 ff 00 00 00       	and    $0xff,%eax
80102b1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102b1e:	6a 00                	push   $0x0
80102b20:	e8 89 ff ff ff       	call   80102aae <ioapicread>
80102b25:	83 c4 04             	add    $0x4,%esp
80102b28:	c1 e8 18             	shr    $0x18,%eax
80102b2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if (id != ioapicid)
80102b2e:	0f b6 05 20 34 11 80 	movzbl 0x80113420,%eax
80102b35:	0f b6 c0             	movzbl %al,%eax
80102b38:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80102b3b:	74 10                	je     80102b4d <ioapicinit+0x65>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102b3d:	83 ec 0c             	sub    $0xc,%esp
80102b40:	68 14 a0 10 80       	push   $0x8010a014
80102b45:	e8 60 d8 ff ff       	call   801003aa <cprintf>
80102b4a:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for (i = 0; i <= maxintr; i++) {
80102b4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102b54:	eb 3f                	jmp    80102b95 <ioapicinit+0xad>
    ioapicwrite(REG_TABLE + 2 * i, INT_DISABLED | (T_IRQ0 + i));
80102b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b59:	83 c0 20             	add    $0x20,%eax
80102b5c:	0d 00 00 01 00       	or     $0x10000,%eax
80102b61:	89 c2                	mov    %eax,%edx
80102b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b66:	83 c0 08             	add    $0x8,%eax
80102b69:	01 c0                	add    %eax,%eax
80102b6b:	83 ec 08             	sub    $0x8,%esp
80102b6e:	52                   	push   %edx
80102b6f:	50                   	push   %eax
80102b70:	e8 54 ff ff ff       	call   80102ac9 <ioapicwrite>
80102b75:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE + 2 * i + 1, 0);
80102b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b7b:	83 c0 08             	add    $0x8,%eax
80102b7e:	01 c0                	add    %eax,%eax
80102b80:	83 c0 01             	add    $0x1,%eax
80102b83:	83 ec 08             	sub    $0x8,%esp
80102b86:	6a 00                	push   $0x0
80102b88:	50                   	push   %eax
80102b89:	e8 3b ff ff ff       	call   80102ac9 <ioapicwrite>
80102b8e:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i <= maxintr; i++) {
80102b91:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b98:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102b9b:	7e b9                	jle    80102b56 <ioapicinit+0x6e>
80102b9d:	eb 01                	jmp    80102ba0 <ioapicinit+0xb8>
    return;
80102b9f:	90                   	nop
  }
}
80102ba0:	c9                   	leave  
80102ba1:	c3                   	ret    

80102ba2 <ioapicenable>:

void ioapicenable(int irq, int cpunum) {
80102ba2:	f3 0f 1e fb          	endbr32 
80102ba6:	55                   	push   %ebp
80102ba7:	89 e5                	mov    %esp,%ebp
  if (!ismp)
80102ba9:	a1 24 34 11 80       	mov    0x80113424,%eax
80102bae:	85 c0                	test   %eax,%eax
80102bb0:	74 39                	je     80102beb <ioapicenable+0x49>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE + 2 * irq, T_IRQ0 + irq);
80102bb2:	8b 45 08             	mov    0x8(%ebp),%eax
80102bb5:	83 c0 20             	add    $0x20,%eax
80102bb8:	89 c2                	mov    %eax,%edx
80102bba:	8b 45 08             	mov    0x8(%ebp),%eax
80102bbd:	83 c0 08             	add    $0x8,%eax
80102bc0:	01 c0                	add    %eax,%eax
80102bc2:	52                   	push   %edx
80102bc3:	50                   	push   %eax
80102bc4:	e8 00 ff ff ff       	call   80102ac9 <ioapicwrite>
80102bc9:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE + 2 * irq + 1, cpunum << 24);
80102bcc:	8b 45 0c             	mov    0xc(%ebp),%eax
80102bcf:	c1 e0 18             	shl    $0x18,%eax
80102bd2:	89 c2                	mov    %eax,%edx
80102bd4:	8b 45 08             	mov    0x8(%ebp),%eax
80102bd7:	83 c0 08             	add    $0x8,%eax
80102bda:	01 c0                	add    %eax,%eax
80102bdc:	83 c0 01             	add    $0x1,%eax
80102bdf:	52                   	push   %edx
80102be0:	50                   	push   %eax
80102be1:	e8 e3 fe ff ff       	call   80102ac9 <ioapicwrite>
80102be6:	83 c4 08             	add    $0x8,%esp
80102be9:	eb 01                	jmp    80102bec <ioapicenable+0x4a>
    return;
80102beb:	90                   	nop
}
80102bec:	c9                   	leave  
80102bed:	c3                   	ret    

80102bee <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102bee:	55                   	push   %ebp
80102bef:	89 e5                	mov    %esp,%ebp
80102bf1:	8b 45 08             	mov    0x8(%ebp),%eax
80102bf4:	05 00 00 00 80       	add    $0x80000000,%eax
80102bf9:	5d                   	pop    %ebp
80102bfa:	c3                   	ret    

80102bfb <kinit1>:
// Initialization happens in two phases.
// 1. main() calls kinit1() while still using entrypgdir to place just
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void kinit1(void *vstart, void *vend) {
80102bfb:	f3 0f 1e fb          	endbr32 
80102bff:	55                   	push   %ebp
80102c00:	89 e5                	mov    %esp,%ebp
80102c02:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102c05:	83 ec 08             	sub    $0x8,%esp
80102c08:	68 46 a0 10 80       	push   $0x8010a046
80102c0d:	68 00 33 11 80       	push   $0x80113300
80102c12:	e8 eb 25 00 00       	call   80105202 <initlock>
80102c17:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102c1a:	c7 05 34 33 11 80 00 	movl   $0x0,0x80113334
80102c21:	00 00 00 
  freerange(vstart, vend);
80102c24:	83 ec 08             	sub    $0x8,%esp
80102c27:	ff 75 0c             	pushl  0xc(%ebp)
80102c2a:	ff 75 08             	pushl  0x8(%ebp)
80102c2d:	e8 2e 00 00 00       	call   80102c60 <freerange>
80102c32:	83 c4 10             	add    $0x10,%esp
}
80102c35:	90                   	nop
80102c36:	c9                   	leave  
80102c37:	c3                   	ret    

80102c38 <kinit2>:

void kinit2(void *vstart, void *vend) {
80102c38:	f3 0f 1e fb          	endbr32 
80102c3c:	55                   	push   %ebp
80102c3d:	89 e5                	mov    %esp,%ebp
80102c3f:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102c42:	83 ec 08             	sub    $0x8,%esp
80102c45:	ff 75 0c             	pushl  0xc(%ebp)
80102c48:	ff 75 08             	pushl  0x8(%ebp)
80102c4b:	e8 10 00 00 00       	call   80102c60 <freerange>
80102c50:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102c53:	c7 05 34 33 11 80 01 	movl   $0x1,0x80113334
80102c5a:	00 00 00 
}
80102c5d:	90                   	nop
80102c5e:	c9                   	leave  
80102c5f:	c3                   	ret    

80102c60 <freerange>:

void freerange(void *vstart, void *vend) {
80102c60:	f3 0f 1e fb          	endbr32 
80102c64:	55                   	push   %ebp
80102c65:	89 e5                	mov    %esp,%ebp
80102c67:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char *)PGROUNDUP((uint)vstart);
80102c6a:	8b 45 08             	mov    0x8(%ebp),%eax
80102c6d:	05 ff 0f 00 00       	add    $0xfff,%eax
80102c72:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102c77:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
80102c7a:	eb 15                	jmp    80102c91 <freerange+0x31>
    kfree(p);
80102c7c:	83 ec 0c             	sub    $0xc,%esp
80102c7f:	ff 75 f4             	pushl  -0xc(%ebp)
80102c82:	e8 1b 00 00 00       	call   80102ca2 <kfree>
80102c87:	83 c4 10             	add    $0x10,%esp
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
80102c8a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c94:	05 00 10 00 00       	add    $0x1000,%eax
80102c99:	39 45 0c             	cmp    %eax,0xc(%ebp)
80102c9c:	73 de                	jae    80102c7c <freerange+0x1c>
}
80102c9e:	90                   	nop
80102c9f:	90                   	nop
80102ca0:	c9                   	leave  
80102ca1:	c3                   	ret    

80102ca2 <kfree>:
// PAGEBREAK: 21
// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(char *v) {
80102ca2:	f3 0f 1e fb          	endbr32 
80102ca6:	55                   	push   %ebp
80102ca7:	89 e5                	mov    %esp,%ebp
80102ca9:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if ((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102cac:	8b 45 08             	mov    0x8(%ebp),%eax
80102caf:	25 ff 0f 00 00       	and    $0xfff,%eax
80102cb4:	85 c0                	test   %eax,%eax
80102cb6:	75 1b                	jne    80102cd3 <kfree+0x31>
80102cb8:	81 7d 08 20 75 11 80 	cmpl   $0x80117520,0x8(%ebp)
80102cbf:	72 12                	jb     80102cd3 <kfree+0x31>
80102cc1:	ff 75 08             	pushl  0x8(%ebp)
80102cc4:	e8 25 ff ff ff       	call   80102bee <v2p>
80102cc9:	83 c4 04             	add    $0x4,%esp
80102ccc:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102cd1:	76 0d                	jbe    80102ce0 <kfree+0x3e>
    panic("kfree");
80102cd3:	83 ec 0c             	sub    $0xc,%esp
80102cd6:	68 4b a0 10 80       	push   $0x8010a04b
80102cdb:	e8 83 d8 ff ff       	call   80100563 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102ce0:	83 ec 04             	sub    $0x4,%esp
80102ce3:	68 00 10 00 00       	push   $0x1000
80102ce8:	6a 01                	push   $0x1
80102cea:	ff 75 08             	pushl  0x8(%ebp)
80102ced:	e8 b2 27 00 00       	call   801054a4 <memset>
80102cf2:	83 c4 10             	add    $0x10,%esp

  if (kmem.use_lock)
80102cf5:	a1 34 33 11 80       	mov    0x80113334,%eax
80102cfa:	85 c0                	test   %eax,%eax
80102cfc:	74 10                	je     80102d0e <kfree+0x6c>
    acquire(&kmem.lock);
80102cfe:	83 ec 0c             	sub    $0xc,%esp
80102d01:	68 00 33 11 80       	push   $0x80113300
80102d06:	e8 1d 25 00 00       	call   80105228 <acquire>
80102d0b:	83 c4 10             	add    $0x10,%esp
  r = (struct run *)v;
80102d0e:	8b 45 08             	mov    0x8(%ebp),%eax
80102d11:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102d14:	8b 15 38 33 11 80    	mov    0x80113338,%edx
80102d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d1d:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d22:	a3 38 33 11 80       	mov    %eax,0x80113338
  if (kmem.use_lock)
80102d27:	a1 34 33 11 80       	mov    0x80113334,%eax
80102d2c:	85 c0                	test   %eax,%eax
80102d2e:	74 10                	je     80102d40 <kfree+0x9e>
    release(&kmem.lock);
80102d30:	83 ec 0c             	sub    $0xc,%esp
80102d33:	68 00 33 11 80       	push   $0x80113300
80102d38:	e8 56 25 00 00       	call   80105293 <release>
80102d3d:	83 c4 10             	add    $0x10,%esp
}
80102d40:	90                   	nop
80102d41:	c9                   	leave  
80102d42:	c3                   	ret    

80102d43 <kalloc>:

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char *kalloc(void) {
80102d43:	f3 0f 1e fb          	endbr32 
80102d47:	55                   	push   %ebp
80102d48:	89 e5                	mov    %esp,%ebp
80102d4a:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if (kmem.use_lock)
80102d4d:	a1 34 33 11 80       	mov    0x80113334,%eax
80102d52:	85 c0                	test   %eax,%eax
80102d54:	74 10                	je     80102d66 <kalloc+0x23>
    acquire(&kmem.lock);
80102d56:	83 ec 0c             	sub    $0xc,%esp
80102d59:	68 00 33 11 80       	push   $0x80113300
80102d5e:	e8 c5 24 00 00       	call   80105228 <acquire>
80102d63:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102d66:	a1 38 33 11 80       	mov    0x80113338,%eax
80102d6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (r)
80102d6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102d72:	74 0a                	je     80102d7e <kalloc+0x3b>
    kmem.freelist = r->next;
80102d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d77:	8b 00                	mov    (%eax),%eax
80102d79:	a3 38 33 11 80       	mov    %eax,0x80113338
  if (kmem.use_lock)
80102d7e:	a1 34 33 11 80       	mov    0x80113334,%eax
80102d83:	85 c0                	test   %eax,%eax
80102d85:	74 10                	je     80102d97 <kalloc+0x54>
    release(&kmem.lock);
80102d87:	83 ec 0c             	sub    $0xc,%esp
80102d8a:	68 00 33 11 80       	push   $0x80113300
80102d8f:	e8 ff 24 00 00       	call   80105293 <release>
80102d94:	83 c4 10             	add    $0x10,%esp
  return (char *)r;
80102d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102d9a:	c9                   	leave  
80102d9b:	c3                   	ret    

80102d9c <inb>:
{
80102d9c:	55                   	push   %ebp
80102d9d:	89 e5                	mov    %esp,%ebp
80102d9f:	83 ec 14             	sub    $0x14,%esp
80102da2:	8b 45 08             	mov    0x8(%ebp),%eax
80102da5:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102da9:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102dad:	89 c2                	mov    %eax,%edx
80102daf:	ec                   	in     (%dx),%al
80102db0:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102db3:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102db7:	c9                   	leave  
80102db8:	c3                   	ret    

80102db9 <kbdgetc>:
#include "kernel/types.h"
#include "kernel/x86.h"
#include "kernel/defs.h"
#include "kernel/kbd.h"

int kbdgetc(void) {
80102db9:	f3 0f 1e fb          	endbr32 
80102dbd:	55                   	push   %ebp
80102dbe:	89 e5                	mov    %esp,%ebp
80102dc0:	83 ec 10             	sub    $0x10,%esp
  static uint shift;
  static uchar *charcode[4] = {normalmap, shiftmap, ctlmap, ctlmap};
  uint st, data, c;

  st = inb(KBSTATP);
80102dc3:	6a 64                	push   $0x64
80102dc5:	e8 d2 ff ff ff       	call   80102d9c <inb>
80102dca:	83 c4 04             	add    $0x4,%esp
80102dcd:	0f b6 c0             	movzbl %al,%eax
80102dd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if ((st & KBS_DIB) == 0)
80102dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102dd6:	83 e0 01             	and    $0x1,%eax
80102dd9:	85 c0                	test   %eax,%eax
80102ddb:	75 0a                	jne    80102de7 <kbdgetc+0x2e>
    return -1;
80102ddd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102de2:	e9 23 01 00 00       	jmp    80102f0a <kbdgetc+0x151>
  data = inb(KBDATAP);
80102de7:	6a 60                	push   $0x60
80102de9:	e8 ae ff ff ff       	call   80102d9c <inb>
80102dee:	83 c4 04             	add    $0x4,%esp
80102df1:	0f b6 c0             	movzbl %al,%eax
80102df4:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if (data == 0xE0) {
80102df7:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102dfe:	75 17                	jne    80102e17 <kbdgetc+0x5e>
    shift |= E0ESC;
80102e00:	a1 fc d6 10 80       	mov    0x8010d6fc,%eax
80102e05:	83 c8 40             	or     $0x40,%eax
80102e08:	a3 fc d6 10 80       	mov    %eax,0x8010d6fc
    return 0;
80102e0d:	b8 00 00 00 00       	mov    $0x0,%eax
80102e12:	e9 f3 00 00 00       	jmp    80102f0a <kbdgetc+0x151>
  } else if (data & 0x80) {
80102e17:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e1a:	25 80 00 00 00       	and    $0x80,%eax
80102e1f:	85 c0                	test   %eax,%eax
80102e21:	74 45                	je     80102e68 <kbdgetc+0xaf>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102e23:	a1 fc d6 10 80       	mov    0x8010d6fc,%eax
80102e28:	83 e0 40             	and    $0x40,%eax
80102e2b:	85 c0                	test   %eax,%eax
80102e2d:	75 08                	jne    80102e37 <kbdgetc+0x7e>
80102e2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e32:	83 e0 7f             	and    $0x7f,%eax
80102e35:	eb 03                	jmp    80102e3a <kbdgetc+0x81>
80102e37:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102e3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e40:	05 20 b0 10 80       	add    $0x8010b020,%eax
80102e45:	0f b6 00             	movzbl (%eax),%eax
80102e48:	83 c8 40             	or     $0x40,%eax
80102e4b:	0f b6 c0             	movzbl %al,%eax
80102e4e:	f7 d0                	not    %eax
80102e50:	89 c2                	mov    %eax,%edx
80102e52:	a1 fc d6 10 80       	mov    0x8010d6fc,%eax
80102e57:	21 d0                	and    %edx,%eax
80102e59:	a3 fc d6 10 80       	mov    %eax,0x8010d6fc
    return 0;
80102e5e:	b8 00 00 00 00       	mov    $0x0,%eax
80102e63:	e9 a2 00 00 00       	jmp    80102f0a <kbdgetc+0x151>
  } else if (shift & E0ESC) {
80102e68:	a1 fc d6 10 80       	mov    0x8010d6fc,%eax
80102e6d:	83 e0 40             	and    $0x40,%eax
80102e70:	85 c0                	test   %eax,%eax
80102e72:	74 14                	je     80102e88 <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102e74:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102e7b:	a1 fc d6 10 80       	mov    0x8010d6fc,%eax
80102e80:	83 e0 bf             	and    $0xffffffbf,%eax
80102e83:	a3 fc d6 10 80       	mov    %eax,0x8010d6fc
  }

  shift |= shiftcode[data];
80102e88:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e8b:	05 20 b0 10 80       	add    $0x8010b020,%eax
80102e90:	0f b6 00             	movzbl (%eax),%eax
80102e93:	0f b6 d0             	movzbl %al,%edx
80102e96:	a1 fc d6 10 80       	mov    0x8010d6fc,%eax
80102e9b:	09 d0                	or     %edx,%eax
80102e9d:	a3 fc d6 10 80       	mov    %eax,0x8010d6fc
  shift ^= togglecode[data];
80102ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ea5:	05 20 b1 10 80       	add    $0x8010b120,%eax
80102eaa:	0f b6 00             	movzbl (%eax),%eax
80102ead:	0f b6 d0             	movzbl %al,%edx
80102eb0:	a1 fc d6 10 80       	mov    0x8010d6fc,%eax
80102eb5:	31 d0                	xor    %edx,%eax
80102eb7:	a3 fc d6 10 80       	mov    %eax,0x8010d6fc
  c = charcode[shift & (CTL | SHIFT)][data];
80102ebc:	a1 fc d6 10 80       	mov    0x8010d6fc,%eax
80102ec1:	83 e0 03             	and    $0x3,%eax
80102ec4:	8b 14 85 20 b5 10 80 	mov    -0x7fef4ae0(,%eax,4),%edx
80102ecb:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ece:	01 d0                	add    %edx,%eax
80102ed0:	0f b6 00             	movzbl (%eax),%eax
80102ed3:	0f b6 c0             	movzbl %al,%eax
80102ed6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (shift & CAPSLOCK) {
80102ed9:	a1 fc d6 10 80       	mov    0x8010d6fc,%eax
80102ede:	83 e0 08             	and    $0x8,%eax
80102ee1:	85 c0                	test   %eax,%eax
80102ee3:	74 22                	je     80102f07 <kbdgetc+0x14e>
    if ('a' <= c && c <= 'z')
80102ee5:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102ee9:	76 0c                	jbe    80102ef7 <kbdgetc+0x13e>
80102eeb:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102eef:	77 06                	ja     80102ef7 <kbdgetc+0x13e>
      c += 'A' - 'a';
80102ef1:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102ef5:	eb 10                	jmp    80102f07 <kbdgetc+0x14e>
    else if ('A' <= c && c <= 'Z')
80102ef7:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102efb:	76 0a                	jbe    80102f07 <kbdgetc+0x14e>
80102efd:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102f01:	77 04                	ja     80102f07 <kbdgetc+0x14e>
      c += 'a' - 'A';
80102f03:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102f07:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102f0a:	c9                   	leave  
80102f0b:	c3                   	ret    

80102f0c <kbdintr>:

void kbdintr(void) { consoleintr(kbdgetc); }
80102f0c:	f3 0f 1e fb          	endbr32 
80102f10:	55                   	push   %ebp
80102f11:	89 e5                	mov    %esp,%ebp
80102f13:	83 ec 08             	sub    $0x8,%esp
80102f16:	83 ec 0c             	sub    $0xc,%esp
80102f19:	68 b9 2d 10 80       	push   $0x80102db9
80102f1e:	e8 e7 d8 ff ff       	call   8010080a <consoleintr>
80102f23:	83 c4 10             	add    $0x10,%esp
80102f26:	90                   	nop
80102f27:	c9                   	leave  
80102f28:	c3                   	ret    

80102f29 <inb>:
{
80102f29:	55                   	push   %ebp
80102f2a:	89 e5                	mov    %esp,%ebp
80102f2c:	83 ec 14             	sub    $0x14,%esp
80102f2f:	8b 45 08             	mov    0x8(%ebp),%eax
80102f32:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f36:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102f3a:	89 c2                	mov    %eax,%edx
80102f3c:	ec                   	in     (%dx),%al
80102f3d:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102f40:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102f44:	c9                   	leave  
80102f45:	c3                   	ret    

80102f46 <outb>:
{
80102f46:	55                   	push   %ebp
80102f47:	89 e5                	mov    %esp,%ebp
80102f49:	83 ec 08             	sub    $0x8,%esp
80102f4c:	8b 45 08             	mov    0x8(%ebp),%eax
80102f4f:	8b 55 0c             	mov    0xc(%ebp),%edx
80102f52:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80102f56:	89 d0                	mov    %edx,%eax
80102f58:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f5b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102f5f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102f63:	ee                   	out    %al,(%dx)
}
80102f64:	90                   	nop
80102f65:	c9                   	leave  
80102f66:	c3                   	ret    

80102f67 <readeflags>:
{
80102f67:	55                   	push   %ebp
80102f68:	89 e5                	mov    %esp,%ebp
80102f6a:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102f6d:	9c                   	pushf  
80102f6e:	58                   	pop    %eax
80102f6f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102f72:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102f75:	c9                   	leave  
80102f76:	c3                   	ret    

80102f77 <lapicw>:
#define TCCR (0x0390 / 4)   // Timer Current Count
#define TDCR (0x03E0 / 4)   // Timer Divide Configuration

volatile uint *lapic; // Initialized in mp.c

static void lapicw(int index, int value) {
80102f77:	f3 0f 1e fb          	endbr32 
80102f7b:	55                   	push   %ebp
80102f7c:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102f7e:	a1 3c 33 11 80       	mov    0x8011333c,%eax
80102f83:	8b 55 08             	mov    0x8(%ebp),%edx
80102f86:	c1 e2 02             	shl    $0x2,%edx
80102f89:	01 c2                	add    %eax,%edx
80102f8b:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f8e:	89 02                	mov    %eax,(%edx)
  lapic[ID]; // wait for write to finish, by reading
80102f90:	a1 3c 33 11 80       	mov    0x8011333c,%eax
80102f95:	83 c0 20             	add    $0x20,%eax
80102f98:	8b 00                	mov    (%eax),%eax
}
80102f9a:	90                   	nop
80102f9b:	5d                   	pop    %ebp
80102f9c:	c3                   	ret    

80102f9d <lapicinit>:
// PAGEBREAK!

void lapicinit(void) {
80102f9d:	f3 0f 1e fb          	endbr32 
80102fa1:	55                   	push   %ebp
80102fa2:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102fa4:	a1 3c 33 11 80       	mov    0x8011333c,%eax
80102fa9:	85 c0                	test   %eax,%eax
80102fab:	0f 84 0c 01 00 00    	je     801030bd <lapicinit+0x120>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102fb1:	68 3f 01 00 00       	push   $0x13f
80102fb6:	6a 3c                	push   $0x3c
80102fb8:	e8 ba ff ff ff       	call   80102f77 <lapicw>
80102fbd:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102fc0:	6a 0b                	push   $0xb
80102fc2:	68 f8 00 00 00       	push   $0xf8
80102fc7:	e8 ab ff ff ff       	call   80102f77 <lapicw>
80102fcc:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102fcf:	68 20 00 02 00       	push   $0x20020
80102fd4:	68 c8 00 00 00       	push   $0xc8
80102fd9:	e8 99 ff ff ff       	call   80102f77 <lapicw>
80102fde:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000);
80102fe1:	68 80 96 98 00       	push   $0x989680
80102fe6:	68 e0 00 00 00       	push   $0xe0
80102feb:	e8 87 ff ff ff       	call   80102f77 <lapicw>
80102ff0:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102ff3:	68 00 00 01 00       	push   $0x10000
80102ff8:	68 d4 00 00 00       	push   $0xd4
80102ffd:	e8 75 ff ff ff       	call   80102f77 <lapicw>
80103002:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80103005:	68 00 00 01 00       	push   $0x10000
8010300a:	68 d8 00 00 00       	push   $0xd8
8010300f:	e8 63 ff ff ff       	call   80102f77 <lapicw>
80103014:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if (((lapic[VER] >> 16) & 0xFF) >= 4)
80103017:	a1 3c 33 11 80       	mov    0x8011333c,%eax
8010301c:	83 c0 30             	add    $0x30,%eax
8010301f:	8b 00                	mov    (%eax),%eax
80103021:	c1 e8 10             	shr    $0x10,%eax
80103024:	25 fc 00 00 00       	and    $0xfc,%eax
80103029:	85 c0                	test   %eax,%eax
8010302b:	74 12                	je     8010303f <lapicinit+0xa2>
    lapicw(PCINT, MASKED);
8010302d:	68 00 00 01 00       	push   $0x10000
80103032:	68 d0 00 00 00       	push   $0xd0
80103037:	e8 3b ff ff ff       	call   80102f77 <lapicw>
8010303c:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
8010303f:	6a 33                	push   $0x33
80103041:	68 dc 00 00 00       	push   $0xdc
80103046:	e8 2c ff ff ff       	call   80102f77 <lapicw>
8010304b:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
8010304e:	6a 00                	push   $0x0
80103050:	68 a0 00 00 00       	push   $0xa0
80103055:	e8 1d ff ff ff       	call   80102f77 <lapicw>
8010305a:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
8010305d:	6a 00                	push   $0x0
8010305f:	68 a0 00 00 00       	push   $0xa0
80103064:	e8 0e ff ff ff       	call   80102f77 <lapicw>
80103069:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
8010306c:	6a 00                	push   $0x0
8010306e:	6a 2c                	push   $0x2c
80103070:	e8 02 ff ff ff       	call   80102f77 <lapicw>
80103075:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80103078:	6a 00                	push   $0x0
8010307a:	68 c4 00 00 00       	push   $0xc4
8010307f:	e8 f3 fe ff ff       	call   80102f77 <lapicw>
80103084:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80103087:	68 00 85 08 00       	push   $0x88500
8010308c:	68 c0 00 00 00       	push   $0xc0
80103091:	e8 e1 fe ff ff       	call   80102f77 <lapicw>
80103096:	83 c4 08             	add    $0x8,%esp
  while (lapic[ICRLO] & DELIVS)
80103099:	90                   	nop
8010309a:	a1 3c 33 11 80       	mov    0x8011333c,%eax
8010309f:	05 00 03 00 00       	add    $0x300,%eax
801030a4:	8b 00                	mov    (%eax),%eax
801030a6:	25 00 10 00 00       	and    $0x1000,%eax
801030ab:	85 c0                	test   %eax,%eax
801030ad:	75 eb                	jne    8010309a <lapicinit+0xfd>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
801030af:	6a 00                	push   $0x0
801030b1:	6a 20                	push   $0x20
801030b3:	e8 bf fe ff ff       	call   80102f77 <lapicw>
801030b8:	83 c4 08             	add    $0x8,%esp
801030bb:	eb 01                	jmp    801030be <lapicinit+0x121>
    return;
801030bd:	90                   	nop
}
801030be:	c9                   	leave  
801030bf:	c3                   	ret    

801030c0 <cpunum>:

int cpunum(void) {
801030c0:	f3 0f 1e fb          	endbr32 
801030c4:	55                   	push   %ebp
801030c5:	89 e5                	mov    %esp,%ebp
801030c7:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if (readeflags() & FL_IF) {
801030ca:	e8 98 fe ff ff       	call   80102f67 <readeflags>
801030cf:	25 00 02 00 00       	and    $0x200,%eax
801030d4:	85 c0                	test   %eax,%eax
801030d6:	74 26                	je     801030fe <cpunum+0x3e>
    static int n;
    if (n++ == 0)
801030d8:	a1 00 d7 10 80       	mov    0x8010d700,%eax
801030dd:	8d 50 01             	lea    0x1(%eax),%edx
801030e0:	89 15 00 d7 10 80    	mov    %edx,0x8010d700
801030e6:	85 c0                	test   %eax,%eax
801030e8:	75 14                	jne    801030fe <cpunum+0x3e>
      cprintf("cpu called from %x with interrupts enabled\n",
801030ea:	8b 45 04             	mov    0x4(%ebp),%eax
801030ed:	83 ec 08             	sub    $0x8,%esp
801030f0:	50                   	push   %eax
801030f1:	68 54 a0 10 80       	push   $0x8010a054
801030f6:	e8 af d2 ff ff       	call   801003aa <cprintf>
801030fb:	83 c4 10             	add    $0x10,%esp
              __builtin_return_address(0));
  }

  if (lapic)
801030fe:	a1 3c 33 11 80       	mov    0x8011333c,%eax
80103103:	85 c0                	test   %eax,%eax
80103105:	74 0f                	je     80103116 <cpunum+0x56>
    return lapic[ID] >> 24;
80103107:	a1 3c 33 11 80       	mov    0x8011333c,%eax
8010310c:	83 c0 20             	add    $0x20,%eax
8010310f:	8b 00                	mov    (%eax),%eax
80103111:	c1 e8 18             	shr    $0x18,%eax
80103114:	eb 05                	jmp    8010311b <cpunum+0x5b>
  return 0;
80103116:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010311b:	c9                   	leave  
8010311c:	c3                   	ret    

8010311d <lapiceoi>:

// Acknowledge interrupt.
void lapiceoi(void) {
8010311d:	f3 0f 1e fb          	endbr32 
80103121:	55                   	push   %ebp
80103122:	89 e5                	mov    %esp,%ebp
  if (lapic)
80103124:	a1 3c 33 11 80       	mov    0x8011333c,%eax
80103129:	85 c0                	test   %eax,%eax
8010312b:	74 0c                	je     80103139 <lapiceoi+0x1c>
    lapicw(EOI, 0);
8010312d:	6a 00                	push   $0x0
8010312f:	6a 2c                	push   $0x2c
80103131:	e8 41 fe ff ff       	call   80102f77 <lapicw>
80103136:	83 c4 08             	add    $0x8,%esp
}
80103139:	90                   	nop
8010313a:	c9                   	leave  
8010313b:	c3                   	ret    

8010313c <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void microdelay(int us) {}
8010313c:	f3 0f 1e fb          	endbr32 
80103140:	55                   	push   %ebp
80103141:	89 e5                	mov    %esp,%ebp
80103143:	90                   	nop
80103144:	5d                   	pop    %ebp
80103145:	c3                   	ret    

80103146 <lapicstartap>:
#define CMOS_PORT 0x70
#define CMOS_RETURN 0x71

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void lapicstartap(uchar apicid, uint addr) {
80103146:	f3 0f 1e fb          	endbr32 
8010314a:	55                   	push   %ebp
8010314b:	89 e5                	mov    %esp,%ebp
8010314d:	83 ec 14             	sub    $0x14,%esp
80103150:	8b 45 08             	mov    0x8(%ebp),%eax
80103153:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF); // offset 0xF is shutdown code
80103156:	6a 0f                	push   $0xf
80103158:	6a 70                	push   $0x70
8010315a:	e8 e7 fd ff ff       	call   80102f46 <outb>
8010315f:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT + 1, 0x0A);
80103162:	6a 0a                	push   $0xa
80103164:	6a 71                	push   $0x71
80103166:	e8 db fd ff ff       	call   80102f46 <outb>
8010316b:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort *)P2V((0x40 << 4 | 0x67)); // Warm reset vector
8010316e:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80103175:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103178:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
8010317d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103180:	c1 e8 04             	shr    $0x4,%eax
80103183:	89 c2                	mov    %eax,%edx
80103185:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103188:	83 c0 02             	add    $0x2,%eax
8010318b:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid << 24);
8010318e:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103192:	c1 e0 18             	shl    $0x18,%eax
80103195:	50                   	push   %eax
80103196:	68 c4 00 00 00       	push   $0xc4
8010319b:	e8 d7 fd ff ff       	call   80102f77 <lapicw>
801031a0:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
801031a3:	68 00 c5 00 00       	push   $0xc500
801031a8:	68 c0 00 00 00       	push   $0xc0
801031ad:	e8 c5 fd ff ff       	call   80102f77 <lapicw>
801031b2:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
801031b5:	68 c8 00 00 00       	push   $0xc8
801031ba:	e8 7d ff ff ff       	call   8010313c <microdelay>
801031bf:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
801031c2:	68 00 85 00 00       	push   $0x8500
801031c7:	68 c0 00 00 00       	push   $0xc0
801031cc:	e8 a6 fd ff ff       	call   80102f77 <lapicw>
801031d1:	83 c4 08             	add    $0x8,%esp
  microdelay(100); // should be 10ms, but too slow in Bochs!
801031d4:	6a 64                	push   $0x64
801031d6:	e8 61 ff ff ff       	call   8010313c <microdelay>
801031db:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for (i = 0; i < 2; i++) {
801031de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801031e5:	eb 3d                	jmp    80103224 <lapicstartap+0xde>
    lapicw(ICRHI, apicid << 24);
801031e7:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801031eb:	c1 e0 18             	shl    $0x18,%eax
801031ee:	50                   	push   %eax
801031ef:	68 c4 00 00 00       	push   $0xc4
801031f4:	e8 7e fd ff ff       	call   80102f77 <lapicw>
801031f9:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr >> 12));
801031fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801031ff:	c1 e8 0c             	shr    $0xc,%eax
80103202:	80 cc 06             	or     $0x6,%ah
80103205:	50                   	push   %eax
80103206:	68 c0 00 00 00       	push   $0xc0
8010320b:	e8 67 fd ff ff       	call   80102f77 <lapicw>
80103210:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
80103213:	68 c8 00 00 00       	push   $0xc8
80103218:	e8 1f ff ff ff       	call   8010313c <microdelay>
8010321d:	83 c4 04             	add    $0x4,%esp
  for (i = 0; i < 2; i++) {
80103220:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103224:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103228:	7e bd                	jle    801031e7 <lapicstartap+0xa1>
  }
}
8010322a:	90                   	nop
8010322b:	90                   	nop
8010322c:	c9                   	leave  
8010322d:	c3                   	ret    

8010322e <cmos_read>:
#define HOURS 0x04
#define DAY 0x07
#define MONTH 0x08
#define YEAR 0x09

static uint cmos_read(uint reg) {
8010322e:	f3 0f 1e fb          	endbr32 
80103232:	55                   	push   %ebp
80103233:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT, reg);
80103235:	8b 45 08             	mov    0x8(%ebp),%eax
80103238:	0f b6 c0             	movzbl %al,%eax
8010323b:	50                   	push   %eax
8010323c:	6a 70                	push   $0x70
8010323e:	e8 03 fd ff ff       	call   80102f46 <outb>
80103243:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103246:	68 c8 00 00 00       	push   $0xc8
8010324b:	e8 ec fe ff ff       	call   8010313c <microdelay>
80103250:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
80103253:	6a 71                	push   $0x71
80103255:	e8 cf fc ff ff       	call   80102f29 <inb>
8010325a:	83 c4 04             	add    $0x4,%esp
8010325d:	0f b6 c0             	movzbl %al,%eax
}
80103260:	c9                   	leave  
80103261:	c3                   	ret    

80103262 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r) {
80103262:	f3 0f 1e fb          	endbr32 
80103266:	55                   	push   %ebp
80103267:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
80103269:	6a 00                	push   $0x0
8010326b:	e8 be ff ff ff       	call   8010322e <cmos_read>
80103270:	83 c4 04             	add    $0x4,%esp
80103273:	8b 55 08             	mov    0x8(%ebp),%edx
80103276:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
80103278:	6a 02                	push   $0x2
8010327a:	e8 af ff ff ff       	call   8010322e <cmos_read>
8010327f:	83 c4 04             	add    $0x4,%esp
80103282:	8b 55 08             	mov    0x8(%ebp),%edx
80103285:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour = cmos_read(HOURS);
80103288:	6a 04                	push   $0x4
8010328a:	e8 9f ff ff ff       	call   8010322e <cmos_read>
8010328f:	83 c4 04             	add    $0x4,%esp
80103292:	8b 55 08             	mov    0x8(%ebp),%edx
80103295:	89 42 08             	mov    %eax,0x8(%edx)
  r->day = cmos_read(DAY);
80103298:	6a 07                	push   $0x7
8010329a:	e8 8f ff ff ff       	call   8010322e <cmos_read>
8010329f:	83 c4 04             	add    $0x4,%esp
801032a2:	8b 55 08             	mov    0x8(%ebp),%edx
801032a5:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month = cmos_read(MONTH);
801032a8:	6a 08                	push   $0x8
801032aa:	e8 7f ff ff ff       	call   8010322e <cmos_read>
801032af:	83 c4 04             	add    $0x4,%esp
801032b2:	8b 55 08             	mov    0x8(%ebp),%edx
801032b5:	89 42 10             	mov    %eax,0x10(%edx)
  r->year = cmos_read(YEAR);
801032b8:	6a 09                	push   $0x9
801032ba:	e8 6f ff ff ff       	call   8010322e <cmos_read>
801032bf:	83 c4 04             	add    $0x4,%esp
801032c2:	8b 55 08             	mov    0x8(%ebp),%edx
801032c5:	89 42 14             	mov    %eax,0x14(%edx)
}
801032c8:	90                   	nop
801032c9:	c9                   	leave  
801032ca:	c3                   	ret    

801032cb <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r) {
801032cb:	f3 0f 1e fb          	endbr32 
801032cf:	55                   	push   %ebp
801032d0:	89 e5                	mov    %esp,%ebp
801032d2:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801032d5:	6a 0b                	push   $0xb
801032d7:	e8 52 ff ff ff       	call   8010322e <cmos_read>
801032dc:	83 c4 04             	add    $0x4,%esp
801032df:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
801032e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032e5:	83 e0 04             	and    $0x4,%eax
801032e8:	85 c0                	test   %eax,%eax
801032ea:	0f 94 c0             	sete   %al
801032ed:	0f b6 c0             	movzbl %al,%eax
801032f0:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
801032f3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801032f6:	50                   	push   %eax
801032f7:	e8 66 ff ff ff       	call   80103262 <fill_rtcdate>
801032fc:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
801032ff:	6a 0a                	push   $0xa
80103301:	e8 28 ff ff ff       	call   8010322e <cmos_read>
80103306:	83 c4 04             	add    $0x4,%esp
80103309:	25 80 00 00 00       	and    $0x80,%eax
8010330e:	85 c0                	test   %eax,%eax
80103310:	75 27                	jne    80103339 <cmostime+0x6e>
      continue;
    fill_rtcdate(&t2);
80103312:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103315:	50                   	push   %eax
80103316:	e8 47 ff ff ff       	call   80103262 <fill_rtcdate>
8010331b:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
8010331e:	83 ec 04             	sub    $0x4,%esp
80103321:	6a 18                	push   $0x18
80103323:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103326:	50                   	push   %eax
80103327:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010332a:	50                   	push   %eax
8010332b:	e8 df 21 00 00       	call   8010550f <memcmp>
80103330:	83 c4 10             	add    $0x10,%esp
80103333:	85 c0                	test   %eax,%eax
80103335:	74 05                	je     8010333c <cmostime+0x71>
80103337:	eb ba                	jmp    801032f3 <cmostime+0x28>
      continue;
80103339:	90                   	nop
    fill_rtcdate(&t1);
8010333a:	eb b7                	jmp    801032f3 <cmostime+0x28>
      break;
8010333c:	90                   	nop
  }

  // convert
  if (bcd) {
8010333d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103341:	0f 84 b4 00 00 00    	je     801033fb <cmostime+0x130>
#define CONV(x) (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103347:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010334a:	c1 e8 04             	shr    $0x4,%eax
8010334d:	89 c2                	mov    %eax,%edx
8010334f:	89 d0                	mov    %edx,%eax
80103351:	c1 e0 02             	shl    $0x2,%eax
80103354:	01 d0                	add    %edx,%eax
80103356:	01 c0                	add    %eax,%eax
80103358:	89 c2                	mov    %eax,%edx
8010335a:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010335d:	83 e0 0f             	and    $0xf,%eax
80103360:	01 d0                	add    %edx,%eax
80103362:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80103365:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103368:	c1 e8 04             	shr    $0x4,%eax
8010336b:	89 c2                	mov    %eax,%edx
8010336d:	89 d0                	mov    %edx,%eax
8010336f:	c1 e0 02             	shl    $0x2,%eax
80103372:	01 d0                	add    %edx,%eax
80103374:	01 c0                	add    %eax,%eax
80103376:	89 c2                	mov    %eax,%edx
80103378:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010337b:	83 e0 0f             	and    $0xf,%eax
8010337e:	01 d0                	add    %edx,%eax
80103380:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour);
80103383:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103386:	c1 e8 04             	shr    $0x4,%eax
80103389:	89 c2                	mov    %eax,%edx
8010338b:	89 d0                	mov    %edx,%eax
8010338d:	c1 e0 02             	shl    $0x2,%eax
80103390:	01 d0                	add    %edx,%eax
80103392:	01 c0                	add    %eax,%eax
80103394:	89 c2                	mov    %eax,%edx
80103396:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103399:	83 e0 0f             	and    $0xf,%eax
8010339c:	01 d0                	add    %edx,%eax
8010339e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day);
801033a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801033a4:	c1 e8 04             	shr    $0x4,%eax
801033a7:	89 c2                	mov    %eax,%edx
801033a9:	89 d0                	mov    %edx,%eax
801033ab:	c1 e0 02             	shl    $0x2,%eax
801033ae:	01 d0                	add    %edx,%eax
801033b0:	01 c0                	add    %eax,%eax
801033b2:	89 c2                	mov    %eax,%edx
801033b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801033b7:	83 e0 0f             	and    $0xf,%eax
801033ba:	01 d0                	add    %edx,%eax
801033bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month);
801033bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
801033c2:	c1 e8 04             	shr    $0x4,%eax
801033c5:	89 c2                	mov    %eax,%edx
801033c7:	89 d0                	mov    %edx,%eax
801033c9:	c1 e0 02             	shl    $0x2,%eax
801033cc:	01 d0                	add    %edx,%eax
801033ce:	01 c0                	add    %eax,%eax
801033d0:	89 c2                	mov    %eax,%edx
801033d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801033d5:	83 e0 0f             	and    $0xf,%eax
801033d8:	01 d0                	add    %edx,%eax
801033da:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year);
801033dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033e0:	c1 e8 04             	shr    $0x4,%eax
801033e3:	89 c2                	mov    %eax,%edx
801033e5:	89 d0                	mov    %edx,%eax
801033e7:	c1 e0 02             	shl    $0x2,%eax
801033ea:	01 d0                	add    %edx,%eax
801033ec:	01 c0                	add    %eax,%eax
801033ee:	89 c2                	mov    %eax,%edx
801033f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033f3:	83 e0 0f             	and    $0xf,%eax
801033f6:	01 d0                	add    %edx,%eax
801033f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef CONV
  }

  *r = t1;
801033fb:	8b 45 08             	mov    0x8(%ebp),%eax
801033fe:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103401:	89 10                	mov    %edx,(%eax)
80103403:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103406:	89 50 04             	mov    %edx,0x4(%eax)
80103409:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010340c:	89 50 08             	mov    %edx,0x8(%eax)
8010340f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103412:	89 50 0c             	mov    %edx,0xc(%eax)
80103415:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103418:	89 50 10             	mov    %edx,0x10(%eax)
8010341b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010341e:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
80103421:	8b 45 08             	mov    0x8(%ebp),%eax
80103424:	8b 40 14             	mov    0x14(%eax),%eax
80103427:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
8010342d:	8b 45 08             	mov    0x8(%ebp),%eax
80103430:	89 50 14             	mov    %edx,0x14(%eax)
}
80103433:	90                   	nop
80103434:	c9                   	leave  
80103435:	c3                   	ret    

80103436 <initlog>:
struct log log;

static void recover_from_log(void);
static void commit();

void initlog(int dev) {
80103436:	f3 0f 1e fb          	endbr32 
8010343a:	55                   	push   %ebp
8010343b:	89 e5                	mov    %esp,%ebp
8010343d:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80103440:	83 ec 08             	sub    $0x8,%esp
80103443:	68 80 a0 10 80       	push   $0x8010a080
80103448:	68 40 33 11 80       	push   $0x80113340
8010344d:	e8 b0 1d 00 00       	call   80105202 <initlock>
80103452:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80103455:	83 ec 08             	sub    $0x8,%esp
80103458:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010345b:	50                   	push   %eax
8010345c:	ff 75 08             	pushl  0x8(%ebp)
8010345f:	e8 6f df ff ff       	call   801013d3 <readsb>
80103464:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
80103467:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010346a:	a3 74 33 11 80       	mov    %eax,0x80113374
  log.size = sb.nlog;
8010346f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103472:	a3 78 33 11 80       	mov    %eax,0x80113378
  log.dev = dev;
80103477:	8b 45 08             	mov    0x8(%ebp),%eax
8010347a:	a3 84 33 11 80       	mov    %eax,0x80113384
  recover_from_log();
8010347f:	e8 bf 01 00 00       	call   80103643 <recover_from_log>
}
80103484:	90                   	nop
80103485:	c9                   	leave  
80103486:	c3                   	ret    

80103487 <install_trans>:

// Copy committed blocks from log to their home location
static void install_trans(void) {
80103487:	f3 0f 1e fb          	endbr32 
8010348b:	55                   	push   %ebp
8010348c:	89 e5                	mov    %esp,%ebp
8010348e:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103491:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103498:	e9 95 00 00 00       	jmp    80103532 <install_trans+0xab>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
8010349d:	8b 15 74 33 11 80    	mov    0x80113374,%edx
801034a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801034a6:	01 d0                	add    %edx,%eax
801034a8:	83 c0 01             	add    $0x1,%eax
801034ab:	89 c2                	mov    %eax,%edx
801034ad:	a1 84 33 11 80       	mov    0x80113384,%eax
801034b2:	83 ec 08             	sub    $0x8,%esp
801034b5:	52                   	push   %edx
801034b6:	50                   	push   %eax
801034b7:	e8 cf cc ff ff       	call   8010018b <bread>
801034bc:	83 c4 10             	add    $0x10,%esp
801034bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]);   // read dst
801034c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801034c5:	83 c0 10             	add    $0x10,%eax
801034c8:	8b 04 85 4c 33 11 80 	mov    -0x7feeccb4(,%eax,4),%eax
801034cf:	89 c2                	mov    %eax,%edx
801034d1:	a1 84 33 11 80       	mov    0x80113384,%eax
801034d6:	83 ec 08             	sub    $0x8,%esp
801034d9:	52                   	push   %edx
801034da:	50                   	push   %eax
801034db:	e8 ab cc ff ff       	call   8010018b <bread>
801034e0:	83 c4 10             	add    $0x10,%esp
801034e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE); // copy block to dst
801034e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034e9:	8d 50 18             	lea    0x18(%eax),%edx
801034ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034ef:	83 c0 18             	add    $0x18,%eax
801034f2:	83 ec 04             	sub    $0x4,%esp
801034f5:	68 00 02 00 00       	push   $0x200
801034fa:	52                   	push   %edx
801034fb:	50                   	push   %eax
801034fc:	e8 6a 20 00 00       	call   8010556b <memmove>
80103501:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);                           // write dst to disk
80103504:	83 ec 0c             	sub    $0xc,%esp
80103507:	ff 75 ec             	pushl  -0x14(%ebp)
8010350a:	e8 b9 cc ff ff       	call   801001c8 <bwrite>
8010350f:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf);
80103512:	83 ec 0c             	sub    $0xc,%esp
80103515:	ff 75 f0             	pushl  -0x10(%ebp)
80103518:	e8 ee cc ff ff       	call   8010020b <brelse>
8010351d:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
80103520:	83 ec 0c             	sub    $0xc,%esp
80103523:	ff 75 ec             	pushl  -0x14(%ebp)
80103526:	e8 e0 cc ff ff       	call   8010020b <brelse>
8010352b:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
8010352e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103532:	a1 88 33 11 80       	mov    0x80113388,%eax
80103537:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010353a:	0f 8c 5d ff ff ff    	jl     8010349d <install_trans+0x16>
  }
}
80103540:	90                   	nop
80103541:	90                   	nop
80103542:	c9                   	leave  
80103543:	c3                   	ret    

80103544 <read_head>:

// Read the log header from disk into the in-memory log header
static void read_head(void) {
80103544:	f3 0f 1e fb          	endbr32 
80103548:	55                   	push   %ebp
80103549:	89 e5                	mov    %esp,%ebp
8010354b:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
8010354e:	a1 74 33 11 80       	mov    0x80113374,%eax
80103553:	89 c2                	mov    %eax,%edx
80103555:	a1 84 33 11 80       	mov    0x80113384,%eax
8010355a:	83 ec 08             	sub    $0x8,%esp
8010355d:	52                   	push   %edx
8010355e:	50                   	push   %eax
8010355f:	e8 27 cc ff ff       	call   8010018b <bread>
80103564:	83 c4 10             	add    $0x10,%esp
80103567:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *)(buf->data);
8010356a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010356d:	83 c0 18             	add    $0x18,%eax
80103570:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103573:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103576:	8b 00                	mov    (%eax),%eax
80103578:	a3 88 33 11 80       	mov    %eax,0x80113388
  for (i = 0; i < log.lh.n; i++) {
8010357d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103584:	eb 1b                	jmp    801035a1 <read_head+0x5d>
    log.lh.block[i] = lh->block[i];
80103586:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103589:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010358c:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103590:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103593:	83 c2 10             	add    $0x10,%edx
80103596:	89 04 95 4c 33 11 80 	mov    %eax,-0x7feeccb4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010359d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801035a1:	a1 88 33 11 80       	mov    0x80113388,%eax
801035a6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801035a9:	7c db                	jl     80103586 <read_head+0x42>
  }
  brelse(buf);
801035ab:	83 ec 0c             	sub    $0xc,%esp
801035ae:	ff 75 f0             	pushl  -0x10(%ebp)
801035b1:	e8 55 cc ff ff       	call   8010020b <brelse>
801035b6:	83 c4 10             	add    $0x10,%esp
}
801035b9:	90                   	nop
801035ba:	c9                   	leave  
801035bb:	c3                   	ret    

801035bc <write_head>:

// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void write_head(void) {
801035bc:	f3 0f 1e fb          	endbr32 
801035c0:	55                   	push   %ebp
801035c1:	89 e5                	mov    %esp,%ebp
801035c3:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801035c6:	a1 74 33 11 80       	mov    0x80113374,%eax
801035cb:	89 c2                	mov    %eax,%edx
801035cd:	a1 84 33 11 80       	mov    0x80113384,%eax
801035d2:	83 ec 08             	sub    $0x8,%esp
801035d5:	52                   	push   %edx
801035d6:	50                   	push   %eax
801035d7:	e8 af cb ff ff       	call   8010018b <bread>
801035dc:	83 c4 10             	add    $0x10,%esp
801035df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *)(buf->data);
801035e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035e5:	83 c0 18             	add    $0x18,%eax
801035e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801035eb:	8b 15 88 33 11 80    	mov    0x80113388,%edx
801035f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035f4:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801035f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801035fd:	eb 1b                	jmp    8010361a <write_head+0x5e>
    hb->block[i] = log.lh.block[i];
801035ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103602:	83 c0 10             	add    $0x10,%eax
80103605:	8b 0c 85 4c 33 11 80 	mov    -0x7feeccb4(,%eax,4),%ecx
8010360c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010360f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103612:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80103616:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010361a:	a1 88 33 11 80       	mov    0x80113388,%eax
8010361f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103622:	7c db                	jl     801035ff <write_head+0x43>
  }
  bwrite(buf);
80103624:	83 ec 0c             	sub    $0xc,%esp
80103627:	ff 75 f0             	pushl  -0x10(%ebp)
8010362a:	e8 99 cb ff ff       	call   801001c8 <bwrite>
8010362f:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
80103632:	83 ec 0c             	sub    $0xc,%esp
80103635:	ff 75 f0             	pushl  -0x10(%ebp)
80103638:	e8 ce cb ff ff       	call   8010020b <brelse>
8010363d:	83 c4 10             	add    $0x10,%esp
}
80103640:	90                   	nop
80103641:	c9                   	leave  
80103642:	c3                   	ret    

80103643 <recover_from_log>:

static void recover_from_log(void) {
80103643:	f3 0f 1e fb          	endbr32 
80103647:	55                   	push   %ebp
80103648:	89 e5                	mov    %esp,%ebp
8010364a:	83 ec 08             	sub    $0x8,%esp
  read_head();
8010364d:	e8 f2 fe ff ff       	call   80103544 <read_head>
  install_trans(); // if committed, copy from log to disk
80103652:	e8 30 fe ff ff       	call   80103487 <install_trans>
  log.lh.n = 0;
80103657:	c7 05 88 33 11 80 00 	movl   $0x0,0x80113388
8010365e:	00 00 00 
  write_head(); // clear the log
80103661:	e8 56 ff ff ff       	call   801035bc <write_head>
}
80103666:	90                   	nop
80103667:	c9                   	leave  
80103668:	c3                   	ret    

80103669 <begin_op>:

// called at the start of each FS system call.
void begin_op(void) {
80103669:	f3 0f 1e fb          	endbr32 
8010366d:	55                   	push   %ebp
8010366e:	89 e5                	mov    %esp,%ebp
80103670:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
80103673:	83 ec 0c             	sub    $0xc,%esp
80103676:	68 40 33 11 80       	push   $0x80113340
8010367b:	e8 a8 1b 00 00       	call   80105228 <acquire>
80103680:	83 c4 10             	add    $0x10,%esp
  while (1) {
    if (log.committing) {
80103683:	a1 80 33 11 80       	mov    0x80113380,%eax
80103688:	85 c0                	test   %eax,%eax
8010368a:	74 17                	je     801036a3 <begin_op+0x3a>
      sleep(&log, &log.lock);
8010368c:	83 ec 08             	sub    $0x8,%esp
8010368f:	68 40 33 11 80       	push   $0x80113340
80103694:	68 40 33 11 80       	push   $0x80113340
80103699:	e8 77 18 00 00       	call   80104f15 <sleep>
8010369e:	83 c4 10             	add    $0x10,%esp
801036a1:	eb e0                	jmp    80103683 <begin_op+0x1a>
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGSIZE) {
801036a3:	8b 0d 88 33 11 80    	mov    0x80113388,%ecx
801036a9:	a1 7c 33 11 80       	mov    0x8011337c,%eax
801036ae:	8d 50 01             	lea    0x1(%eax),%edx
801036b1:	89 d0                	mov    %edx,%eax
801036b3:	c1 e0 02             	shl    $0x2,%eax
801036b6:	01 d0                	add    %edx,%eax
801036b8:	01 c0                	add    %eax,%eax
801036ba:	01 c8                	add    %ecx,%eax
801036bc:	83 f8 1e             	cmp    $0x1e,%eax
801036bf:	7e 17                	jle    801036d8 <begin_op+0x6f>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
801036c1:	83 ec 08             	sub    $0x8,%esp
801036c4:	68 40 33 11 80       	push   $0x80113340
801036c9:	68 40 33 11 80       	push   $0x80113340
801036ce:	e8 42 18 00 00       	call   80104f15 <sleep>
801036d3:	83 c4 10             	add    $0x10,%esp
801036d6:	eb ab                	jmp    80103683 <begin_op+0x1a>
    } else {
      log.outstanding += 1;
801036d8:	a1 7c 33 11 80       	mov    0x8011337c,%eax
801036dd:	83 c0 01             	add    $0x1,%eax
801036e0:	a3 7c 33 11 80       	mov    %eax,0x8011337c
      release(&log.lock);
801036e5:	83 ec 0c             	sub    $0xc,%esp
801036e8:	68 40 33 11 80       	push   $0x80113340
801036ed:	e8 a1 1b 00 00       	call   80105293 <release>
801036f2:	83 c4 10             	add    $0x10,%esp
      break;
801036f5:	90                   	nop
    }
  }
}
801036f6:	90                   	nop
801036f7:	c9                   	leave  
801036f8:	c3                   	ret    

801036f9 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void end_op(void) {
801036f9:	f3 0f 1e fb          	endbr32 
801036fd:	55                   	push   %ebp
801036fe:	89 e5                	mov    %esp,%ebp
80103700:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
80103703:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
8010370a:	83 ec 0c             	sub    $0xc,%esp
8010370d:	68 40 33 11 80       	push   $0x80113340
80103712:	e8 11 1b 00 00       	call   80105228 <acquire>
80103717:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
8010371a:	a1 7c 33 11 80       	mov    0x8011337c,%eax
8010371f:	83 e8 01             	sub    $0x1,%eax
80103722:	a3 7c 33 11 80       	mov    %eax,0x8011337c
  if (log.committing)
80103727:	a1 80 33 11 80       	mov    0x80113380,%eax
8010372c:	85 c0                	test   %eax,%eax
8010372e:	74 0d                	je     8010373d <end_op+0x44>
    panic("log.committing");
80103730:	83 ec 0c             	sub    $0xc,%esp
80103733:	68 84 a0 10 80       	push   $0x8010a084
80103738:	e8 26 ce ff ff       	call   80100563 <panic>
  if (log.outstanding == 0) {
8010373d:	a1 7c 33 11 80       	mov    0x8011337c,%eax
80103742:	85 c0                	test   %eax,%eax
80103744:	75 13                	jne    80103759 <end_op+0x60>
    do_commit = 1;
80103746:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
8010374d:	c7 05 80 33 11 80 01 	movl   $0x1,0x80113380
80103754:	00 00 00 
80103757:	eb 10                	jmp    80103769 <end_op+0x70>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
80103759:	83 ec 0c             	sub    $0xc,%esp
8010375c:	68 40 33 11 80       	push   $0x80113340
80103761:	e8 a3 18 00 00       	call   80105009 <wakeup>
80103766:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
80103769:	83 ec 0c             	sub    $0xc,%esp
8010376c:	68 40 33 11 80       	push   $0x80113340
80103771:	e8 1d 1b 00 00       	call   80105293 <release>
80103776:	83 c4 10             	add    $0x10,%esp

  if (do_commit) {
80103779:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010377d:	74 3f                	je     801037be <end_op+0xc5>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
8010377f:	e8 fa 00 00 00       	call   8010387e <commit>
    acquire(&log.lock);
80103784:	83 ec 0c             	sub    $0xc,%esp
80103787:	68 40 33 11 80       	push   $0x80113340
8010378c:	e8 97 1a 00 00       	call   80105228 <acquire>
80103791:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103794:	c7 05 80 33 11 80 00 	movl   $0x0,0x80113380
8010379b:	00 00 00 
    wakeup(&log);
8010379e:	83 ec 0c             	sub    $0xc,%esp
801037a1:	68 40 33 11 80       	push   $0x80113340
801037a6:	e8 5e 18 00 00       	call   80105009 <wakeup>
801037ab:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
801037ae:	83 ec 0c             	sub    $0xc,%esp
801037b1:	68 40 33 11 80       	push   $0x80113340
801037b6:	e8 d8 1a 00 00       	call   80105293 <release>
801037bb:	83 c4 10             	add    $0x10,%esp
  }
}
801037be:	90                   	nop
801037bf:	c9                   	leave  
801037c0:	c3                   	ret    

801037c1 <write_log>:

// Copy modified blocks from cache to log.
static void write_log(void) {
801037c1:	f3 0f 1e fb          	endbr32 
801037c5:	55                   	push   %ebp
801037c6:	89 e5                	mov    %esp,%ebp
801037c8:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801037cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801037d2:	e9 95 00 00 00       	jmp    8010386c <write_log+0xab>
    struct buf *to = bread(log.dev, log.start + tail + 1); // log block
801037d7:	8b 15 74 33 11 80    	mov    0x80113374,%edx
801037dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037e0:	01 d0                	add    %edx,%eax
801037e2:	83 c0 01             	add    $0x1,%eax
801037e5:	89 c2                	mov    %eax,%edx
801037e7:	a1 84 33 11 80       	mov    0x80113384,%eax
801037ec:	83 ec 08             	sub    $0x8,%esp
801037ef:	52                   	push   %edx
801037f0:	50                   	push   %eax
801037f1:	e8 95 c9 ff ff       	call   8010018b <bread>
801037f6:	83 c4 10             	add    $0x10,%esp
801037f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801037fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037ff:	83 c0 10             	add    $0x10,%eax
80103802:	8b 04 85 4c 33 11 80 	mov    -0x7feeccb4(,%eax,4),%eax
80103809:	89 c2                	mov    %eax,%edx
8010380b:	a1 84 33 11 80       	mov    0x80113384,%eax
80103810:	83 ec 08             	sub    $0x8,%esp
80103813:	52                   	push   %edx
80103814:	50                   	push   %eax
80103815:	e8 71 c9 ff ff       	call   8010018b <bread>
8010381a:	83 c4 10             	add    $0x10,%esp
8010381d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
80103820:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103823:	8d 50 18             	lea    0x18(%eax),%edx
80103826:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103829:	83 c0 18             	add    $0x18,%eax
8010382c:	83 ec 04             	sub    $0x4,%esp
8010382f:	68 00 02 00 00       	push   $0x200
80103834:	52                   	push   %edx
80103835:	50                   	push   %eax
80103836:	e8 30 1d 00 00       	call   8010556b <memmove>
8010383b:	83 c4 10             	add    $0x10,%esp
    bwrite(to); // write the log
8010383e:	83 ec 0c             	sub    $0xc,%esp
80103841:	ff 75 f0             	pushl  -0x10(%ebp)
80103844:	e8 7f c9 ff ff       	call   801001c8 <bwrite>
80103849:	83 c4 10             	add    $0x10,%esp
    brelse(from);
8010384c:	83 ec 0c             	sub    $0xc,%esp
8010384f:	ff 75 ec             	pushl  -0x14(%ebp)
80103852:	e8 b4 c9 ff ff       	call   8010020b <brelse>
80103857:	83 c4 10             	add    $0x10,%esp
    brelse(to);
8010385a:	83 ec 0c             	sub    $0xc,%esp
8010385d:	ff 75 f0             	pushl  -0x10(%ebp)
80103860:	e8 a6 c9 ff ff       	call   8010020b <brelse>
80103865:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80103868:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010386c:	a1 88 33 11 80       	mov    0x80113388,%eax
80103871:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103874:	0f 8c 5d ff ff ff    	jl     801037d7 <write_log+0x16>
  }
}
8010387a:	90                   	nop
8010387b:	90                   	nop
8010387c:	c9                   	leave  
8010387d:	c3                   	ret    

8010387e <commit>:

static void commit() {
8010387e:	f3 0f 1e fb          	endbr32 
80103882:	55                   	push   %ebp
80103883:	89 e5                	mov    %esp,%ebp
80103885:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103888:	a1 88 33 11 80       	mov    0x80113388,%eax
8010388d:	85 c0                	test   %eax,%eax
8010388f:	7e 1e                	jle    801038af <commit+0x31>
    write_log();     // Write modified blocks from cache to log
80103891:	e8 2b ff ff ff       	call   801037c1 <write_log>
    write_head();    // Write header to disk -- the real commit
80103896:	e8 21 fd ff ff       	call   801035bc <write_head>
    install_trans(); // Now install writes to home locations
8010389b:	e8 e7 fb ff ff       	call   80103487 <install_trans>
    log.lh.n = 0;
801038a0:	c7 05 88 33 11 80 00 	movl   $0x0,0x80113388
801038a7:	00 00 00 
    write_head(); // Erase the transaction from the log
801038aa:	e8 0d fd ff ff       	call   801035bc <write_head>
  }
}
801038af:	90                   	nop
801038b0:	c9                   	leave  
801038b1:	c3                   	ret    

801038b2 <log_write>:
// log_write() replaces bwrite(); a typical use is:
//   bp = bread(...)
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void log_write(struct buf *b) {
801038b2:	f3 0f 1e fb          	endbr32 
801038b6:	55                   	push   %ebp
801038b7:	89 e5                	mov    %esp,%ebp
801038b9:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801038bc:	a1 88 33 11 80       	mov    0x80113388,%eax
801038c1:	83 f8 1d             	cmp    $0x1d,%eax
801038c4:	7f 12                	jg     801038d8 <log_write+0x26>
801038c6:	a1 88 33 11 80       	mov    0x80113388,%eax
801038cb:	8b 15 78 33 11 80    	mov    0x80113378,%edx
801038d1:	83 ea 01             	sub    $0x1,%edx
801038d4:	39 d0                	cmp    %edx,%eax
801038d6:	7c 0d                	jl     801038e5 <log_write+0x33>
    panic("too big a transaction");
801038d8:	83 ec 0c             	sub    $0xc,%esp
801038db:	68 93 a0 10 80       	push   $0x8010a093
801038e0:	e8 7e cc ff ff       	call   80100563 <panic>
  if (log.outstanding < 1)
801038e5:	a1 7c 33 11 80       	mov    0x8011337c,%eax
801038ea:	85 c0                	test   %eax,%eax
801038ec:	7f 0d                	jg     801038fb <log_write+0x49>
    panic("log_write outside of trans");
801038ee:	83 ec 0c             	sub    $0xc,%esp
801038f1:	68 a9 a0 10 80       	push   $0x8010a0a9
801038f6:	e8 68 cc ff ff       	call   80100563 <panic>

  acquire(&log.lock);
801038fb:	83 ec 0c             	sub    $0xc,%esp
801038fe:	68 40 33 11 80       	push   $0x80113340
80103903:	e8 20 19 00 00       	call   80105228 <acquire>
80103908:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
8010390b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103912:	eb 1d                	jmp    80103931 <log_write+0x7f>
    if (log.lh.block[i] == b->blockno) // log absorbtion
80103914:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103917:	83 c0 10             	add    $0x10,%eax
8010391a:	8b 04 85 4c 33 11 80 	mov    -0x7feeccb4(,%eax,4),%eax
80103921:	89 c2                	mov    %eax,%edx
80103923:	8b 45 08             	mov    0x8(%ebp),%eax
80103926:	8b 40 08             	mov    0x8(%eax),%eax
80103929:	39 c2                	cmp    %eax,%edx
8010392b:	74 10                	je     8010393d <log_write+0x8b>
  for (i = 0; i < log.lh.n; i++) {
8010392d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103931:	a1 88 33 11 80       	mov    0x80113388,%eax
80103936:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103939:	7c d9                	jl     80103914 <log_write+0x62>
8010393b:	eb 01                	jmp    8010393e <log_write+0x8c>
      break;
8010393d:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
8010393e:	8b 45 08             	mov    0x8(%ebp),%eax
80103941:	8b 40 08             	mov    0x8(%eax),%eax
80103944:	89 c2                	mov    %eax,%edx
80103946:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103949:	83 c0 10             	add    $0x10,%eax
8010394c:	89 14 85 4c 33 11 80 	mov    %edx,-0x7feeccb4(,%eax,4)
  if (i == log.lh.n)
80103953:	a1 88 33 11 80       	mov    0x80113388,%eax
80103958:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010395b:	75 0d                	jne    8010396a <log_write+0xb8>
    log.lh.n++;
8010395d:	a1 88 33 11 80       	mov    0x80113388,%eax
80103962:	83 c0 01             	add    $0x1,%eax
80103965:	a3 88 33 11 80       	mov    %eax,0x80113388
  b->flags |= B_DIRTY; // prevent eviction
8010396a:	8b 45 08             	mov    0x8(%ebp),%eax
8010396d:	8b 00                	mov    (%eax),%eax
8010396f:	83 c8 04             	or     $0x4,%eax
80103972:	89 c2                	mov    %eax,%edx
80103974:	8b 45 08             	mov    0x8(%ebp),%eax
80103977:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
80103979:	83 ec 0c             	sub    $0xc,%esp
8010397c:	68 40 33 11 80       	push   $0x80113340
80103981:	e8 0d 19 00 00       	call   80105293 <release>
80103986:	83 c4 10             	add    $0x10,%esp
}
80103989:	90                   	nop
8010398a:	c9                   	leave  
8010398b:	c3                   	ret    

8010398c <v2p>:
8010398c:	55                   	push   %ebp
8010398d:	89 e5                	mov    %esp,%ebp
8010398f:	8b 45 08             	mov    0x8(%ebp),%eax
80103992:	05 00 00 00 80       	add    $0x80000000,%eax
80103997:	5d                   	pop    %ebp
80103998:	c3                   	ret    

80103999 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103999:	55                   	push   %ebp
8010399a:	89 e5                	mov    %esp,%ebp
8010399c:	8b 45 08             	mov    0x8(%ebp),%eax
8010399f:	05 00 00 00 80       	add    $0x80000000,%eax
801039a4:	5d                   	pop    %ebp
801039a5:	c3                   	ret    

801039a6 <xchg>:
  asm volatile("hlt");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
801039a6:	55                   	push   %ebp
801039a7:	89 e5                	mov    %esp,%ebp
801039a9:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801039ac:	8b 55 08             	mov    0x8(%ebp),%edx
801039af:	8b 45 0c             	mov    0xc(%ebp),%eax
801039b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
801039b5:	f0 87 02             	lock xchg %eax,(%edx)
801039b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801039bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801039be:	c9                   	leave  
801039bf:	c3                   	ret    

801039c0 <main>:
extern char end[]; // first address after kernel loaded from ELF file

// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int main(void) {
801039c0:	f3 0f 1e fb          	endbr32 
801039c4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801039c8:	83 e4 f0             	and    $0xfffffff0,%esp
801039cb:	ff 71 fc             	pushl  -0x4(%ecx)
801039ce:	55                   	push   %ebp
801039cf:	89 e5                	mov    %esp,%ebp
801039d1:	51                   	push   %ecx
801039d2:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4 * 1024 * 1024)); // phys page allocator
801039d5:	83 ec 08             	sub    $0x8,%esp
801039d8:	68 00 00 40 80       	push   $0x80400000
801039dd:	68 20 75 11 80       	push   $0x80117520
801039e2:	e8 14 f2 ff ff       	call   80102bfb <kinit1>
801039e7:	83 c4 10             	add    $0x10,%esp
  kvmalloc();                        // kernel page table
801039ea:	e8 41 5c 00 00       	call   80109630 <kvmalloc>
  mpinit();                          // collect info about this machine
801039ef:	e8 5a 04 00 00       	call   80103e4e <mpinit>
  lapicinit();
801039f4:	e8 a4 f5 ff ff       	call   80102f9d <lapicinit>
  seginit(); // set up segments
801039f9:	e8 cb 55 00 00       	call   80108fc9 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
801039fe:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103a04:	0f b6 00             	movzbl (%eax),%eax
80103a07:	0f b6 c0             	movzbl %al,%eax
80103a0a:	83 ec 08             	sub    $0x8,%esp
80103a0d:	50                   	push   %eax
80103a0e:	68 c4 a0 10 80       	push   $0x8010a0c4
80103a13:	e8 92 c9 ff ff       	call   801003aa <cprintf>
80103a18:	83 c4 10             	add    $0x10,%esp
  picinit();     // interrupt controller
80103a1b:	e8 b6 06 00 00       	call   801040d6 <picinit>
  ioapicinit();  // another interrupt controller
80103a20:	e8 c3 f0 ff ff       	call   80102ae8 <ioapicinit>
  consoleinit(); // I/O devices & their interrupts
80103a25:	e8 1a d1 ff ff       	call   80100b44 <consoleinit>
  uartinit();    // serial port
80103a2a:	e8 bb 48 00 00       	call   801082ea <uartinit>
  pinit();       // process table
80103a2f:	e8 ba 0b 00 00       	call   801045ee <pinit>
  tvinit();      // trap vectors
80103a34:	e8 6b 44 00 00       	call   80107ea4 <tvinit>
  binit();       // buffer cache
80103a39:	e8 c2 c5 ff ff       	call   80100000 <binit>
  fileinit();    // file table
80103a3e:	e8 65 d5 ff ff       	call   80100fa8 <fileinit>
  ideinit();     // disk
80103a43:	e8 90 ec ff ff       	call   801026d8 <ideinit>
  if (!ismp)
80103a48:	a1 24 34 11 80       	mov    0x80113424,%eax
80103a4d:	85 c0                	test   %eax,%eax
80103a4f:	75 05                	jne    80103a56 <main+0x96>
    timerinit();                              // uniprocessor timer
80103a51:	e8 d2 43 00 00       	call   80107e28 <timerinit>
  startothers();                              // start other processors
80103a56:	e8 87 00 00 00       	call   80103ae2 <startothers>
  kinit2(P2V(4 * 1024 * 1024), P2V(PHYSTOP)); // must come after startothers()
80103a5b:	83 ec 08             	sub    $0x8,%esp
80103a5e:	68 00 00 00 8e       	push   $0x8e000000
80103a63:	68 00 00 40 80       	push   $0x80400000
80103a68:	e8 cb f1 ff ff       	call   80102c38 <kinit2>
80103a6d:	83 c4 10             	add    $0x10,%esp
  userinit();                                 // first user process
80103a70:	e8 b1 0c 00 00       	call   80104726 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80103a75:	e8 1e 00 00 00       	call   80103a98 <mpmain>

80103a7a <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void mpenter(void) {
80103a7a:	f3 0f 1e fb          	endbr32 
80103a7e:	55                   	push   %ebp
80103a7f:	89 e5                	mov    %esp,%ebp
80103a81:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103a84:	e8 c3 5b 00 00       	call   8010964c <switchkvm>
  seginit();
80103a89:	e8 3b 55 00 00       	call   80108fc9 <seginit>
  lapicinit();
80103a8e:	e8 0a f5 ff ff       	call   80102f9d <lapicinit>
  mpmain();
80103a93:	e8 00 00 00 00       	call   80103a98 <mpmain>

80103a98 <mpmain>:
}

// Common CPU setup code.
static void mpmain(void) {
80103a98:	f3 0f 1e fb          	endbr32 
80103a9c:	55                   	push   %ebp
80103a9d:	89 e5                	mov    %esp,%ebp
80103a9f:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
80103aa2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103aa8:	0f b6 00             	movzbl (%eax),%eax
80103aab:	0f b6 c0             	movzbl %al,%eax
80103aae:	83 ec 08             	sub    $0x8,%esp
80103ab1:	50                   	push   %eax
80103ab2:	68 db a0 10 80       	push   $0x8010a0db
80103ab7:	e8 ee c8 ff ff       	call   801003aa <cprintf>
80103abc:	83 c4 10             	add    $0x10,%esp
  idtinit();              // load idt register
80103abf:	e8 5a 45 00 00       	call   8010801e <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103ac4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103aca:	05 a8 00 00 00       	add    $0xa8,%eax
80103acf:	83 ec 08             	sub    $0x8,%esp
80103ad2:	6a 01                	push   $0x1
80103ad4:	50                   	push   %eax
80103ad5:	e8 cc fe ff ff       	call   801039a6 <xchg>
80103ada:	83 c4 10             	add    $0x10,%esp
  scheduler();            // start running processes
80103add:	e8 21 12 00 00       	call   80104d03 <scheduler>

80103ae2 <startothers>:
}

pde_t entrypgdir[]; // For entry.S

// Start the non-boot (AP) processors.
static void startothers(void) {
80103ae2:	f3 0f 1e fb          	endbr32 
80103ae6:	55                   	push   %ebp
80103ae7:	89 e5                	mov    %esp,%ebp
80103ae9:	83 ec 18             	sub    $0x18,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103aec:	68 00 70 00 00       	push   $0x7000
80103af1:	e8 a3 fe ff ff       	call   80103999 <p2v>
80103af6:	83 c4 04             	add    $0x4,%esp
80103af9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_kernel_entryother_start, (uint)_binary_kernel_entryother_size);
80103afc:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103b01:	83 ec 04             	sub    $0x4,%esp
80103b04:	50                   	push   %eax
80103b05:	68 cc d5 10 80       	push   $0x8010d5cc
80103b0a:	ff 75 f0             	pushl  -0x10(%ebp)
80103b0d:	e8 59 1a 00 00       	call   8010556b <memmove>
80103b12:	83 c4 10             	add    $0x10,%esp

  for (c = cpus; c < cpus + ncpu; c++) {
80103b15:	c7 45 f4 40 34 11 80 	movl   $0x80113440,-0xc(%ebp)
80103b1c:	e9 8e 00 00 00       	jmp    80103baf <startothers+0xcd>
    if (c == cpus + cpunum()) // We've started already.
80103b21:	e8 9a f5 ff ff       	call   801030c0 <cpunum>
80103b26:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103b2c:	05 40 34 11 80       	add    $0x80113440,%eax
80103b31:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103b34:	74 71                	je     80103ba7 <startothers+0xc5>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103b36:	e8 08 f2 ff ff       	call   80102d43 <kalloc>
80103b3b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void **)(code - 4) = stack + KSTACKSIZE;
80103b3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b41:	83 e8 04             	sub    $0x4,%eax
80103b44:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103b47:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103b4d:	89 10                	mov    %edx,(%eax)
    *(void **)(code - 8) = mpenter;
80103b4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b52:	83 e8 08             	sub    $0x8,%eax
80103b55:	c7 00 7a 3a 10 80    	movl   $0x80103a7a,(%eax)
    *(int **)(code - 12) = (void *)v2p(entrypgdir);
80103b5b:	83 ec 0c             	sub    $0xc,%esp
80103b5e:	68 00 c0 10 80       	push   $0x8010c000
80103b63:	e8 24 fe ff ff       	call   8010398c <v2p>
80103b68:	83 c4 10             	add    $0x10,%esp
80103b6b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103b6e:	83 ea 0c             	sub    $0xc,%edx
80103b71:	89 02                	mov    %eax,(%edx)

    lapicstartap(c->id, v2p(code));
80103b73:	83 ec 0c             	sub    $0xc,%esp
80103b76:	ff 75 f0             	pushl  -0x10(%ebp)
80103b79:	e8 0e fe ff ff       	call   8010398c <v2p>
80103b7e:	83 c4 10             	add    $0x10,%esp
80103b81:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103b84:	0f b6 12             	movzbl (%edx),%edx
80103b87:	0f b6 d2             	movzbl %dl,%edx
80103b8a:	83 ec 08             	sub    $0x8,%esp
80103b8d:	50                   	push   %eax
80103b8e:	52                   	push   %edx
80103b8f:	e8 b2 f5 ff ff       	call   80103146 <lapicstartap>
80103b94:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while (c->started == 0)
80103b97:	90                   	nop
80103b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b9b:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103ba1:	85 c0                	test   %eax,%eax
80103ba3:	74 f3                	je     80103b98 <startothers+0xb6>
80103ba5:	eb 01                	jmp    80103ba8 <startothers+0xc6>
      continue;
80103ba7:	90                   	nop
  for (c = cpus; c < cpus + ncpu; c++) {
80103ba8:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103baf:	a1 20 3a 11 80       	mov    0x80113a20,%eax
80103bb4:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103bba:	05 40 34 11 80       	add    $0x80113440,%eax
80103bbf:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103bc2:	0f 82 59 ff ff ff    	jb     80103b21 <startothers+0x3f>
      ;
  }
}
80103bc8:	90                   	nop
80103bc9:	90                   	nop
80103bca:	c9                   	leave  
80103bcb:	c3                   	ret    

80103bcc <p2v>:
80103bcc:	55                   	push   %ebp
80103bcd:	89 e5                	mov    %esp,%ebp
80103bcf:	8b 45 08             	mov    0x8(%ebp),%eax
80103bd2:	05 00 00 00 80       	add    $0x80000000,%eax
80103bd7:	5d                   	pop    %ebp
80103bd8:	c3                   	ret    

80103bd9 <inb>:
{
80103bd9:	55                   	push   %ebp
80103bda:	89 e5                	mov    %esp,%ebp
80103bdc:	83 ec 14             	sub    $0x14,%esp
80103bdf:	8b 45 08             	mov    0x8(%ebp),%eax
80103be2:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103be6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103bea:	89 c2                	mov    %eax,%edx
80103bec:	ec                   	in     (%dx),%al
80103bed:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103bf0:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103bf4:	c9                   	leave  
80103bf5:	c3                   	ret    

80103bf6 <outb>:
{
80103bf6:	55                   	push   %ebp
80103bf7:	89 e5                	mov    %esp,%ebp
80103bf9:	83 ec 08             	sub    $0x8,%esp
80103bfc:	8b 45 08             	mov    0x8(%ebp),%eax
80103bff:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c02:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103c06:	89 d0                	mov    %edx,%eax
80103c08:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103c0b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103c0f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103c13:	ee                   	out    %al,(%dx)
}
80103c14:	90                   	nop
80103c15:	c9                   	leave  
80103c16:	c3                   	ret    

80103c17 <mpbcpu>:
static struct cpu *bcpu;
int ismp;
int ncpu;
uchar ioapicid;

int mpbcpu(void) { return bcpu - cpus; }
80103c17:	f3 0f 1e fb          	endbr32 
80103c1b:	55                   	push   %ebp
80103c1c:	89 e5                	mov    %esp,%ebp
80103c1e:	a1 04 d7 10 80       	mov    0x8010d704,%eax
80103c23:	2d 40 34 11 80       	sub    $0x80113440,%eax
80103c28:	c1 f8 02             	sar    $0x2,%eax
80103c2b:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
80103c31:	5d                   	pop    %ebp
80103c32:	c3                   	ret    

80103c33 <sum>:

static uchar sum(uchar *addr, int len) {
80103c33:	f3 0f 1e fb          	endbr32 
80103c37:	55                   	push   %ebp
80103c38:	89 e5                	mov    %esp,%ebp
80103c3a:	83 ec 10             	sub    $0x10,%esp
  int i, sum;

  sum = 0;
80103c3d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for (i = 0; i < len; i++)
80103c44:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103c4b:	eb 15                	jmp    80103c62 <sum+0x2f>
    sum += addr[i];
80103c4d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103c50:	8b 45 08             	mov    0x8(%ebp),%eax
80103c53:	01 d0                	add    %edx,%eax
80103c55:	0f b6 00             	movzbl (%eax),%eax
80103c58:	0f b6 c0             	movzbl %al,%eax
80103c5b:	01 45 f8             	add    %eax,-0x8(%ebp)
  for (i = 0; i < len; i++)
80103c5e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103c62:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103c65:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103c68:	7c e3                	jl     80103c4d <sum+0x1a>
  return sum;
80103c6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103c6d:	c9                   	leave  
80103c6e:	c3                   	ret    

80103c6f <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp *mpsearch1(uint a, int len) {
80103c6f:	f3 0f 1e fb          	endbr32 
80103c73:	55                   	push   %ebp
80103c74:	89 e5                	mov    %esp,%ebp
80103c76:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103c79:	ff 75 08             	pushl  0x8(%ebp)
80103c7c:	e8 4b ff ff ff       	call   80103bcc <p2v>
80103c81:	83 c4 04             	add    $0x4,%esp
80103c84:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr + len;
80103c87:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c8d:	01 d0                	add    %edx,%eax
80103c8f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for (p = addr; p < e; p += sizeof(struct mp))
80103c92:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c95:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c98:	eb 36                	jmp    80103cd0 <mpsearch1+0x61>
    if (memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103c9a:	83 ec 04             	sub    $0x4,%esp
80103c9d:	6a 04                	push   $0x4
80103c9f:	68 ec a0 10 80       	push   $0x8010a0ec
80103ca4:	ff 75 f4             	pushl  -0xc(%ebp)
80103ca7:	e8 63 18 00 00       	call   8010550f <memcmp>
80103cac:	83 c4 10             	add    $0x10,%esp
80103caf:	85 c0                	test   %eax,%eax
80103cb1:	75 19                	jne    80103ccc <mpsearch1+0x5d>
80103cb3:	83 ec 08             	sub    $0x8,%esp
80103cb6:	6a 10                	push   $0x10
80103cb8:	ff 75 f4             	pushl  -0xc(%ebp)
80103cbb:	e8 73 ff ff ff       	call   80103c33 <sum>
80103cc0:	83 c4 10             	add    $0x10,%esp
80103cc3:	84 c0                	test   %al,%al
80103cc5:	75 05                	jne    80103ccc <mpsearch1+0x5d>
      return (struct mp *)p;
80103cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cca:	eb 11                	jmp    80103cdd <mpsearch1+0x6e>
  for (p = addr; p < e; p += sizeof(struct mp))
80103ccc:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cd3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103cd6:	72 c2                	jb     80103c9a <mpsearch1+0x2b>
  return 0;
80103cd8:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103cdd:	c9                   	leave  
80103cde:	c3                   	ret    

80103cdf <mpsearch>:
// Search for the MP Floating Pointer Structure, which according to the
// spec is in one of the following three locations:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp *mpsearch(void) {
80103cdf:	f3 0f 1e fb          	endbr32 
80103ce3:	55                   	push   %ebp
80103ce4:	89 e5                	mov    %esp,%ebp
80103ce6:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *)P2V(0x400);
80103ce9:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if ((p = ((bda[0x0F] << 8) | bda[0x0E]) << 4)) {
80103cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cf3:	83 c0 0f             	add    $0xf,%eax
80103cf6:	0f b6 00             	movzbl (%eax),%eax
80103cf9:	0f b6 c0             	movzbl %al,%eax
80103cfc:	c1 e0 08             	shl    $0x8,%eax
80103cff:	89 c2                	mov    %eax,%edx
80103d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d04:	83 c0 0e             	add    $0xe,%eax
80103d07:	0f b6 00             	movzbl (%eax),%eax
80103d0a:	0f b6 c0             	movzbl %al,%eax
80103d0d:	09 d0                	or     %edx,%eax
80103d0f:	c1 e0 04             	shl    $0x4,%eax
80103d12:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103d15:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103d19:	74 21                	je     80103d3c <mpsearch+0x5d>
    if ((mp = mpsearch1(p, 1024)))
80103d1b:	83 ec 08             	sub    $0x8,%esp
80103d1e:	68 00 04 00 00       	push   $0x400
80103d23:	ff 75 f0             	pushl  -0x10(%ebp)
80103d26:	e8 44 ff ff ff       	call   80103c6f <mpsearch1>
80103d2b:	83 c4 10             	add    $0x10,%esp
80103d2e:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103d31:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103d35:	74 51                	je     80103d88 <mpsearch+0xa9>
      return mp;
80103d37:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103d3a:	eb 61                	jmp    80103d9d <mpsearch+0xbe>
  } else {
    p = ((bda[0x14] << 8) | bda[0x13]) * 1024;
80103d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d3f:	83 c0 14             	add    $0x14,%eax
80103d42:	0f b6 00             	movzbl (%eax),%eax
80103d45:	0f b6 c0             	movzbl %al,%eax
80103d48:	c1 e0 08             	shl    $0x8,%eax
80103d4b:	89 c2                	mov    %eax,%edx
80103d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d50:	83 c0 13             	add    $0x13,%eax
80103d53:	0f b6 00             	movzbl (%eax),%eax
80103d56:	0f b6 c0             	movzbl %al,%eax
80103d59:	09 d0                	or     %edx,%eax
80103d5b:	c1 e0 0a             	shl    $0xa,%eax
80103d5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if ((mp = mpsearch1(p - 1024, 1024)))
80103d61:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d64:	2d 00 04 00 00       	sub    $0x400,%eax
80103d69:	83 ec 08             	sub    $0x8,%esp
80103d6c:	68 00 04 00 00       	push   $0x400
80103d71:	50                   	push   %eax
80103d72:	e8 f8 fe ff ff       	call   80103c6f <mpsearch1>
80103d77:	83 c4 10             	add    $0x10,%esp
80103d7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103d7d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103d81:	74 05                	je     80103d88 <mpsearch+0xa9>
      return mp;
80103d83:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103d86:	eb 15                	jmp    80103d9d <mpsearch+0xbe>
  }
  return mpsearch1(0xF0000, 0x10000);
80103d88:	83 ec 08             	sub    $0x8,%esp
80103d8b:	68 00 00 01 00       	push   $0x10000
80103d90:	68 00 00 0f 00       	push   $0xf0000
80103d95:	e8 d5 fe ff ff       	call   80103c6f <mpsearch1>
80103d9a:	83 c4 10             	add    $0x10,%esp
}
80103d9d:	c9                   	leave  
80103d9e:	c3                   	ret    

80103d9f <mpconfig>:
// Search for an MP configuration table.  For now,
// don't accept the default configurations (physaddr == 0).
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf *mpconfig(struct mp **pmp) {
80103d9f:	f3 0f 1e fb          	endbr32 
80103da3:	55                   	push   %ebp
80103da4:	89 e5                	mov    %esp,%ebp
80103da6:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if ((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103da9:	e8 31 ff ff ff       	call   80103cdf <mpsearch>
80103dae:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103db1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103db5:	74 0a                	je     80103dc1 <mpconfig+0x22>
80103db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dba:	8b 40 04             	mov    0x4(%eax),%eax
80103dbd:	85 c0                	test   %eax,%eax
80103dbf:	75 0a                	jne    80103dcb <mpconfig+0x2c>
    return 0;
80103dc1:	b8 00 00 00 00       	mov    $0x0,%eax
80103dc6:	e9 81 00 00 00       	jmp    80103e4c <mpconfig+0xad>
  conf = (struct mpconf *)p2v((uint)mp->physaddr);
80103dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dce:	8b 40 04             	mov    0x4(%eax),%eax
80103dd1:	83 ec 0c             	sub    $0xc,%esp
80103dd4:	50                   	push   %eax
80103dd5:	e8 f2 fd ff ff       	call   80103bcc <p2v>
80103dda:	83 c4 10             	add    $0x10,%esp
80103ddd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if (memcmp(conf, "PCMP", 4) != 0)
80103de0:	83 ec 04             	sub    $0x4,%esp
80103de3:	6a 04                	push   $0x4
80103de5:	68 f1 a0 10 80       	push   $0x8010a0f1
80103dea:	ff 75 f0             	pushl  -0x10(%ebp)
80103ded:	e8 1d 17 00 00       	call   8010550f <memcmp>
80103df2:	83 c4 10             	add    $0x10,%esp
80103df5:	85 c0                	test   %eax,%eax
80103df7:	74 07                	je     80103e00 <mpconfig+0x61>
    return 0;
80103df9:	b8 00 00 00 00       	mov    $0x0,%eax
80103dfe:	eb 4c                	jmp    80103e4c <mpconfig+0xad>
  if (conf->version != 1 && conf->version != 4)
80103e00:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e03:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103e07:	3c 01                	cmp    $0x1,%al
80103e09:	74 12                	je     80103e1d <mpconfig+0x7e>
80103e0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e0e:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103e12:	3c 04                	cmp    $0x4,%al
80103e14:	74 07                	je     80103e1d <mpconfig+0x7e>
    return 0;
80103e16:	b8 00 00 00 00       	mov    $0x0,%eax
80103e1b:	eb 2f                	jmp    80103e4c <mpconfig+0xad>
  if (sum((uchar *)conf, conf->length) != 0)
80103e1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e20:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103e24:	0f b7 c0             	movzwl %ax,%eax
80103e27:	83 ec 08             	sub    $0x8,%esp
80103e2a:	50                   	push   %eax
80103e2b:	ff 75 f0             	pushl  -0x10(%ebp)
80103e2e:	e8 00 fe ff ff       	call   80103c33 <sum>
80103e33:	83 c4 10             	add    $0x10,%esp
80103e36:	84 c0                	test   %al,%al
80103e38:	74 07                	je     80103e41 <mpconfig+0xa2>
    return 0;
80103e3a:	b8 00 00 00 00       	mov    $0x0,%eax
80103e3f:	eb 0b                	jmp    80103e4c <mpconfig+0xad>
  *pmp = mp;
80103e41:	8b 45 08             	mov    0x8(%ebp),%eax
80103e44:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103e47:	89 10                	mov    %edx,(%eax)
  return conf;
80103e49:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103e4c:	c9                   	leave  
80103e4d:	c3                   	ret    

80103e4e <mpinit>:

void mpinit(void) {
80103e4e:	f3 0f 1e fb          	endbr32 
80103e52:	55                   	push   %ebp
80103e53:	89 e5                	mov    %esp,%ebp
80103e55:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103e58:	c7 05 04 d7 10 80 40 	movl   $0x80113440,0x8010d704
80103e5f:	34 11 80 
  if ((conf = mpconfig(&mp)) == 0)
80103e62:	83 ec 0c             	sub    $0xc,%esp
80103e65:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103e68:	50                   	push   %eax
80103e69:	e8 31 ff ff ff       	call   80103d9f <mpconfig>
80103e6e:	83 c4 10             	add    $0x10,%esp
80103e71:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103e74:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103e78:	0f 84 ba 01 00 00    	je     80104038 <mpinit+0x1ea>
    return;
  ismp = 1;
80103e7e:	c7 05 24 34 11 80 01 	movl   $0x1,0x80113424
80103e85:	00 00 00 
  lapic = (uint *)conf->lapicaddr;
80103e88:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e8b:	8b 40 24             	mov    0x24(%eax),%eax
80103e8e:	a3 3c 33 11 80       	mov    %eax,0x8011333c
  for (p = (uchar *)(conf + 1), e = (uchar *)conf + conf->length; p < e;) {
80103e93:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e96:	83 c0 2c             	add    $0x2c,%eax
80103e99:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103e9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e9f:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103ea3:	0f b7 d0             	movzwl %ax,%edx
80103ea6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ea9:	01 d0                	add    %edx,%eax
80103eab:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103eae:	e9 16 01 00 00       	jmp    80103fc9 <mpinit+0x17b>
    switch (*p) {
80103eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103eb6:	0f b6 00             	movzbl (%eax),%eax
80103eb9:	0f b6 c0             	movzbl %al,%eax
80103ebc:	83 f8 04             	cmp    $0x4,%eax
80103ebf:	0f 8f e0 00 00 00    	jg     80103fa5 <mpinit+0x157>
80103ec5:	83 f8 03             	cmp    $0x3,%eax
80103ec8:	0f 8d d1 00 00 00    	jge    80103f9f <mpinit+0x151>
80103ece:	83 f8 02             	cmp    $0x2,%eax
80103ed1:	0f 84 b0 00 00 00    	je     80103f87 <mpinit+0x139>
80103ed7:	83 f8 02             	cmp    $0x2,%eax
80103eda:	0f 8f c5 00 00 00    	jg     80103fa5 <mpinit+0x157>
80103ee0:	85 c0                	test   %eax,%eax
80103ee2:	74 0e                	je     80103ef2 <mpinit+0xa4>
80103ee4:	83 f8 01             	cmp    $0x1,%eax
80103ee7:	0f 84 b2 00 00 00    	je     80103f9f <mpinit+0x151>
80103eed:	e9 b3 00 00 00       	jmp    80103fa5 <mpinit+0x157>
    case MPPROC:
      proc = (struct mpproc *)p;
80103ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ef5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if (ncpu != proc->apicid) {
80103ef8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103efb:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103eff:	0f b6 d0             	movzbl %al,%edx
80103f02:	a1 20 3a 11 80       	mov    0x80113a20,%eax
80103f07:	39 c2                	cmp    %eax,%edx
80103f09:	74 2b                	je     80103f36 <mpinit+0xe8>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103f0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103f0e:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103f12:	0f b6 d0             	movzbl %al,%edx
80103f15:	a1 20 3a 11 80       	mov    0x80113a20,%eax
80103f1a:	83 ec 04             	sub    $0x4,%esp
80103f1d:	52                   	push   %edx
80103f1e:	50                   	push   %eax
80103f1f:	68 f6 a0 10 80       	push   $0x8010a0f6
80103f24:	e8 81 c4 ff ff       	call   801003aa <cprintf>
80103f29:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103f2c:	c7 05 24 34 11 80 00 	movl   $0x0,0x80113424
80103f33:	00 00 00 
      }
      if (proc->flags & MPBOOT)
80103f36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103f39:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103f3d:	0f b6 c0             	movzbl %al,%eax
80103f40:	83 e0 02             	and    $0x2,%eax
80103f43:	85 c0                	test   %eax,%eax
80103f45:	74 15                	je     80103f5c <mpinit+0x10e>
        bcpu = &cpus[ncpu];
80103f47:	a1 20 3a 11 80       	mov    0x80113a20,%eax
80103f4c:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103f52:	05 40 34 11 80       	add    $0x80113440,%eax
80103f57:	a3 04 d7 10 80       	mov    %eax,0x8010d704
      cpus[ncpu].id = ncpu;
80103f5c:	8b 15 20 3a 11 80    	mov    0x80113a20,%edx
80103f62:	a1 20 3a 11 80       	mov    0x80113a20,%eax
80103f67:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103f6d:	05 40 34 11 80       	add    $0x80113440,%eax
80103f72:	88 10                	mov    %dl,(%eax)
      ncpu++;
80103f74:	a1 20 3a 11 80       	mov    0x80113a20,%eax
80103f79:	83 c0 01             	add    $0x1,%eax
80103f7c:	a3 20 3a 11 80       	mov    %eax,0x80113a20
      p += sizeof(struct mpproc);
80103f81:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103f85:	eb 42                	jmp    80103fc9 <mpinit+0x17b>
    case MPIOAPIC:
      ioapic = (struct mpioapic *)p;
80103f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f8a:	89 45 e8             	mov    %eax,-0x18(%ebp)
      ioapicid = ioapic->apicno;
80103f8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103f90:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103f94:	a2 20 34 11 80       	mov    %al,0x80113420
      p += sizeof(struct mpioapic);
80103f99:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103f9d:	eb 2a                	jmp    80103fc9 <mpinit+0x17b>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103f9f:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103fa3:	eb 24                	jmp    80103fc9 <mpinit+0x17b>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fa8:	0f b6 00             	movzbl (%eax),%eax
80103fab:	0f b6 c0             	movzbl %al,%eax
80103fae:	83 ec 08             	sub    $0x8,%esp
80103fb1:	50                   	push   %eax
80103fb2:	68 14 a1 10 80       	push   $0x8010a114
80103fb7:	e8 ee c3 ff ff       	call   801003aa <cprintf>
80103fbc:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80103fbf:	c7 05 24 34 11 80 00 	movl   $0x0,0x80113424
80103fc6:	00 00 00 
  for (p = (uchar *)(conf + 1), e = (uchar *)conf + conf->length; p < e;) {
80103fc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fcc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103fcf:	0f 82 de fe ff ff    	jb     80103eb3 <mpinit+0x65>
    }
  }
  if (!ismp) {
80103fd5:	a1 24 34 11 80       	mov    0x80113424,%eax
80103fda:	85 c0                	test   %eax,%eax
80103fdc:	75 1d                	jne    80103ffb <mpinit+0x1ad>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103fde:	c7 05 20 3a 11 80 01 	movl   $0x1,0x80113a20
80103fe5:	00 00 00 
    lapic = 0;
80103fe8:	c7 05 3c 33 11 80 00 	movl   $0x0,0x8011333c
80103fef:	00 00 00 
    ioapicid = 0;
80103ff2:	c6 05 20 34 11 80 00 	movb   $0x0,0x80113420
    return;
80103ff9:	eb 3e                	jmp    80104039 <mpinit+0x1eb>
  }

  if (mp->imcrp) {
80103ffb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103ffe:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80104002:	84 c0                	test   %al,%al
80104004:	74 33                	je     80104039 <mpinit+0x1eb>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);          // Select IMCR
80104006:	83 ec 08             	sub    $0x8,%esp
80104009:	6a 70                	push   $0x70
8010400b:	6a 22                	push   $0x22
8010400d:	e8 e4 fb ff ff       	call   80103bf6 <outb>
80104012:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1); // Mask external interrupts.
80104015:	83 ec 0c             	sub    $0xc,%esp
80104018:	6a 23                	push   $0x23
8010401a:	e8 ba fb ff ff       	call   80103bd9 <inb>
8010401f:	83 c4 10             	add    $0x10,%esp
80104022:	83 c8 01             	or     $0x1,%eax
80104025:	0f b6 c0             	movzbl %al,%eax
80104028:	83 ec 08             	sub    $0x8,%esp
8010402b:	50                   	push   %eax
8010402c:	6a 23                	push   $0x23
8010402e:	e8 c3 fb ff ff       	call   80103bf6 <outb>
80104033:	83 c4 10             	add    $0x10,%esp
80104036:	eb 01                	jmp    80104039 <mpinit+0x1eb>
    return;
80104038:	90                   	nop
  }
}
80104039:	c9                   	leave  
8010403a:	c3                   	ret    

8010403b <outb>:
{
8010403b:	55                   	push   %ebp
8010403c:	89 e5                	mov    %esp,%ebp
8010403e:	83 ec 08             	sub    $0x8,%esp
80104041:	8b 45 08             	mov    0x8(%ebp),%eax
80104044:	8b 55 0c             	mov    0xc(%ebp),%edx
80104047:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
8010404b:	89 d0                	mov    %edx,%eax
8010404d:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104050:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80104054:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80104058:	ee                   	out    %al,(%dx)
}
80104059:	90                   	nop
8010405a:	c9                   	leave  
8010405b:	c3                   	ret    

8010405c <picsetmask>:

// Current IRQ mask.
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1 << IRQ_SLAVE);

static void picsetmask(ushort mask) {
8010405c:	f3 0f 1e fb          	endbr32 
80104060:	55                   	push   %ebp
80104061:	89 e5                	mov    %esp,%ebp
80104063:	83 ec 04             	sub    $0x4,%esp
80104066:	8b 45 08             	mov    0x8(%ebp),%eax
80104069:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
8010406d:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80104071:	66 a3 00 d0 10 80    	mov    %ax,0x8010d000
  outb(IO_PIC1 + 1, mask);
80104077:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010407b:	0f b6 c0             	movzbl %al,%eax
8010407e:	50                   	push   %eax
8010407f:	6a 21                	push   $0x21
80104081:	e8 b5 ff ff ff       	call   8010403b <outb>
80104086:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2 + 1, mask >> 8);
80104089:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010408d:	66 c1 e8 08          	shr    $0x8,%ax
80104091:	0f b6 c0             	movzbl %al,%eax
80104094:	50                   	push   %eax
80104095:	68 a1 00 00 00       	push   $0xa1
8010409a:	e8 9c ff ff ff       	call   8010403b <outb>
8010409f:	83 c4 08             	add    $0x8,%esp
}
801040a2:	90                   	nop
801040a3:	c9                   	leave  
801040a4:	c3                   	ret    

801040a5 <picenable>:

void picenable(int irq) { picsetmask(irqmask & ~(1 << irq)); }
801040a5:	f3 0f 1e fb          	endbr32 
801040a9:	55                   	push   %ebp
801040aa:	89 e5                	mov    %esp,%ebp
801040ac:	8b 45 08             	mov    0x8(%ebp),%eax
801040af:	ba 01 00 00 00       	mov    $0x1,%edx
801040b4:	89 c1                	mov    %eax,%ecx
801040b6:	d3 e2                	shl    %cl,%edx
801040b8:	89 d0                	mov    %edx,%eax
801040ba:	f7 d0                	not    %eax
801040bc:	89 c2                	mov    %eax,%edx
801040be:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
801040c5:	21 d0                	and    %edx,%eax
801040c7:	0f b7 c0             	movzwl %ax,%eax
801040ca:	50                   	push   %eax
801040cb:	e8 8c ff ff ff       	call   8010405c <picsetmask>
801040d0:	83 c4 04             	add    $0x4,%esp
801040d3:	90                   	nop
801040d4:	c9                   	leave  
801040d5:	c3                   	ret    

801040d6 <picinit>:

// Initialize the 8259A interrupt controllers.
void picinit(void) {
801040d6:	f3 0f 1e fb          	endbr32 
801040da:	55                   	push   %ebp
801040db:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1 + 1, 0xFF);
801040dd:	68 ff 00 00 00       	push   $0xff
801040e2:	6a 21                	push   $0x21
801040e4:	e8 52 ff ff ff       	call   8010403b <outb>
801040e9:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2 + 1, 0xFF);
801040ec:	68 ff 00 00 00       	push   $0xff
801040f1:	68 a1 00 00 00       	push   $0xa1
801040f6:	e8 40 ff ff ff       	call   8010403b <outb>
801040fb:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
801040fe:	6a 11                	push   $0x11
80104100:	6a 20                	push   $0x20
80104102:	e8 34 ff ff ff       	call   8010403b <outb>
80104107:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1 + 1, T_IRQ0);
8010410a:	6a 20                	push   $0x20
8010410c:	6a 21                	push   $0x21
8010410e:	e8 28 ff ff ff       	call   8010403b <outb>
80104113:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1 + 1, 1 << IRQ_SLAVE);
80104116:	6a 04                	push   $0x4
80104118:	6a 21                	push   $0x21
8010411a:	e8 1c ff ff ff       	call   8010403b <outb>
8010411f:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1 + 1, 0x3);
80104122:	6a 03                	push   $0x3
80104124:	6a 21                	push   $0x21
80104126:	e8 10 ff ff ff       	call   8010403b <outb>
8010412b:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);           // ICW1
8010412e:	6a 11                	push   $0x11
80104130:	68 a0 00 00 00       	push   $0xa0
80104135:	e8 01 ff ff ff       	call   8010403b <outb>
8010413a:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2 + 1, T_IRQ0 + 8); // ICW2
8010413d:	6a 28                	push   $0x28
8010413f:	68 a1 00 00 00       	push   $0xa1
80104144:	e8 f2 fe ff ff       	call   8010403b <outb>
80104149:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2 + 1, IRQ_SLAVE);  // ICW3
8010414c:	6a 02                	push   $0x2
8010414e:	68 a1 00 00 00       	push   $0xa1
80104153:	e8 e3 fe ff ff       	call   8010403b <outb>
80104158:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2 + 1, 0x3); // ICW4
8010415b:	6a 03                	push   $0x3
8010415d:	68 a1 00 00 00       	push   $0xa1
80104162:	e8 d4 fe ff ff       	call   8010403b <outb>
80104167:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68); // clear specific mask
8010416a:	6a 68                	push   $0x68
8010416c:	6a 20                	push   $0x20
8010416e:	e8 c8 fe ff ff       	call   8010403b <outb>
80104173:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a); // read IRR by default
80104176:	6a 0a                	push   $0xa
80104178:	6a 20                	push   $0x20
8010417a:	e8 bc fe ff ff       	call   8010403b <outb>
8010417f:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68); // OCW3
80104182:	6a 68                	push   $0x68
80104184:	68 a0 00 00 00       	push   $0xa0
80104189:	e8 ad fe ff ff       	call   8010403b <outb>
8010418e:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a); // OCW3
80104191:	6a 0a                	push   $0xa
80104193:	68 a0 00 00 00       	push   $0xa0
80104198:	e8 9e fe ff ff       	call   8010403b <outb>
8010419d:	83 c4 08             	add    $0x8,%esp

  if (irqmask != 0xFFFF)
801041a0:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
801041a7:	66 83 f8 ff          	cmp    $0xffff,%ax
801041ab:	74 13                	je     801041c0 <picinit+0xea>
    picsetmask(irqmask);
801041ad:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
801041b4:	0f b7 c0             	movzwl %ax,%eax
801041b7:	50                   	push   %eax
801041b8:	e8 9f fe ff ff       	call   8010405c <picsetmask>
801041bd:	83 c4 04             	add    $0x4,%esp
}
801041c0:	90                   	nop
801041c1:	c9                   	leave  
801041c2:	c3                   	ret    

801041c3 <pipealloc>:
  uint nwrite;   // number of bytes written
  int readopen;  // read fd is still open
  int writeopen; // write fd is still open
};

int pipealloc(struct file **f0, struct file **f1) {
801041c3:	f3 0f 1e fb          	endbr32 
801041c7:	55                   	push   %ebp
801041c8:	89 e5                	mov    %esp,%ebp
801041ca:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
801041cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
801041d4:	8b 45 0c             	mov    0xc(%ebp),%eax
801041d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801041dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801041e0:	8b 10                	mov    (%eax),%edx
801041e2:	8b 45 08             	mov    0x8(%ebp),%eax
801041e5:	89 10                	mov    %edx,(%eax)
  if ((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801041e7:	e8 de cd ff ff       	call   80100fca <filealloc>
801041ec:	8b 55 08             	mov    0x8(%ebp),%edx
801041ef:	89 02                	mov    %eax,(%edx)
801041f1:	8b 45 08             	mov    0x8(%ebp),%eax
801041f4:	8b 00                	mov    (%eax),%eax
801041f6:	85 c0                	test   %eax,%eax
801041f8:	0f 84 c8 00 00 00    	je     801042c6 <pipealloc+0x103>
801041fe:	e8 c7 cd ff ff       	call   80100fca <filealloc>
80104203:	8b 55 0c             	mov    0xc(%ebp),%edx
80104206:	89 02                	mov    %eax,(%edx)
80104208:	8b 45 0c             	mov    0xc(%ebp),%eax
8010420b:	8b 00                	mov    (%eax),%eax
8010420d:	85 c0                	test   %eax,%eax
8010420f:	0f 84 b1 00 00 00    	je     801042c6 <pipealloc+0x103>
    goto bad;
  if ((p = (struct pipe *)kalloc()) == 0)
80104215:	e8 29 eb ff ff       	call   80102d43 <kalloc>
8010421a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010421d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104221:	0f 84 a2 00 00 00    	je     801042c9 <pipealloc+0x106>
    goto bad;
  p->readopen = 1;
80104227:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010422a:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80104231:	00 00 00 
  p->writeopen = 1;
80104234:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104237:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010423e:	00 00 00 
  p->nwrite = 0;
80104241:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104244:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010424b:	00 00 00 
  p->nread = 0;
8010424e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104251:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104258:	00 00 00 
  initlock(&p->lock, "pipe");
8010425b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010425e:	83 ec 08             	sub    $0x8,%esp
80104261:	68 34 a1 10 80       	push   $0x8010a134
80104266:	50                   	push   %eax
80104267:	e8 96 0f 00 00       	call   80105202 <initlock>
8010426c:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010426f:	8b 45 08             	mov    0x8(%ebp),%eax
80104272:	8b 00                	mov    (%eax),%eax
80104274:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010427a:	8b 45 08             	mov    0x8(%ebp),%eax
8010427d:	8b 00                	mov    (%eax),%eax
8010427f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80104283:	8b 45 08             	mov    0x8(%ebp),%eax
80104286:	8b 00                	mov    (%eax),%eax
80104288:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010428c:	8b 45 08             	mov    0x8(%ebp),%eax
8010428f:	8b 00                	mov    (%eax),%eax
80104291:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104294:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80104297:	8b 45 0c             	mov    0xc(%ebp),%eax
8010429a:	8b 00                	mov    (%eax),%eax
8010429c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801042a2:	8b 45 0c             	mov    0xc(%ebp),%eax
801042a5:	8b 00                	mov    (%eax),%eax
801042a7:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801042ab:	8b 45 0c             	mov    0xc(%ebp),%eax
801042ae:	8b 00                	mov    (%eax),%eax
801042b0:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801042b4:	8b 45 0c             	mov    0xc(%ebp),%eax
801042b7:	8b 00                	mov    (%eax),%eax
801042b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042bc:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
801042bf:	b8 00 00 00 00       	mov    $0x0,%eax
801042c4:	eb 51                	jmp    80104317 <pipealloc+0x154>
    goto bad;
801042c6:	90                   	nop
801042c7:	eb 01                	jmp    801042ca <pipealloc+0x107>
    goto bad;
801042c9:	90                   	nop

  // PAGEBREAK: 20
bad:
  if (p)
801042ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801042ce:	74 0e                	je     801042de <pipealloc+0x11b>
    kfree((char *)p);
801042d0:	83 ec 0c             	sub    $0xc,%esp
801042d3:	ff 75 f4             	pushl  -0xc(%ebp)
801042d6:	e8 c7 e9 ff ff       	call   80102ca2 <kfree>
801042db:	83 c4 10             	add    $0x10,%esp
  if (*f0)
801042de:	8b 45 08             	mov    0x8(%ebp),%eax
801042e1:	8b 00                	mov    (%eax),%eax
801042e3:	85 c0                	test   %eax,%eax
801042e5:	74 11                	je     801042f8 <pipealloc+0x135>
    fileclose(*f0);
801042e7:	8b 45 08             	mov    0x8(%ebp),%eax
801042ea:	8b 00                	mov    (%eax),%eax
801042ec:	83 ec 0c             	sub    $0xc,%esp
801042ef:	50                   	push   %eax
801042f0:	e8 9b cd ff ff       	call   80101090 <fileclose>
801042f5:	83 c4 10             	add    $0x10,%esp
  if (*f1)
801042f8:	8b 45 0c             	mov    0xc(%ebp),%eax
801042fb:	8b 00                	mov    (%eax),%eax
801042fd:	85 c0                	test   %eax,%eax
801042ff:	74 11                	je     80104312 <pipealloc+0x14f>
    fileclose(*f1);
80104301:	8b 45 0c             	mov    0xc(%ebp),%eax
80104304:	8b 00                	mov    (%eax),%eax
80104306:	83 ec 0c             	sub    $0xc,%esp
80104309:	50                   	push   %eax
8010430a:	e8 81 cd ff ff       	call   80101090 <fileclose>
8010430f:	83 c4 10             	add    $0x10,%esp
  return -1;
80104312:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104317:	c9                   	leave  
80104318:	c3                   	ret    

80104319 <pipeclose>:

void pipeclose(struct pipe *p, int writable) {
80104319:	f3 0f 1e fb          	endbr32 
8010431d:	55                   	push   %ebp
8010431e:	89 e5                	mov    %esp,%ebp
80104320:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
80104323:	8b 45 08             	mov    0x8(%ebp),%eax
80104326:	83 ec 0c             	sub    $0xc,%esp
80104329:	50                   	push   %eax
8010432a:	e8 f9 0e 00 00       	call   80105228 <acquire>
8010432f:	83 c4 10             	add    $0x10,%esp
  if (writable) {
80104332:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104336:	74 23                	je     8010435b <pipeclose+0x42>
    p->writeopen = 0;
80104338:	8b 45 08             	mov    0x8(%ebp),%eax
8010433b:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80104342:	00 00 00 
    wakeup(&p->nread);
80104345:	8b 45 08             	mov    0x8(%ebp),%eax
80104348:	05 34 02 00 00       	add    $0x234,%eax
8010434d:	83 ec 0c             	sub    $0xc,%esp
80104350:	50                   	push   %eax
80104351:	e8 b3 0c 00 00       	call   80105009 <wakeup>
80104356:	83 c4 10             	add    $0x10,%esp
80104359:	eb 21                	jmp    8010437c <pipeclose+0x63>
  } else {
    p->readopen = 0;
8010435b:	8b 45 08             	mov    0x8(%ebp),%eax
8010435e:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80104365:	00 00 00 
    wakeup(&p->nwrite);
80104368:	8b 45 08             	mov    0x8(%ebp),%eax
8010436b:	05 38 02 00 00       	add    $0x238,%eax
80104370:	83 ec 0c             	sub    $0xc,%esp
80104373:	50                   	push   %eax
80104374:	e8 90 0c 00 00       	call   80105009 <wakeup>
80104379:	83 c4 10             	add    $0x10,%esp
  }
  if (p->readopen == 0 && p->writeopen == 0) {
8010437c:	8b 45 08             	mov    0x8(%ebp),%eax
8010437f:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104385:	85 c0                	test   %eax,%eax
80104387:	75 2c                	jne    801043b5 <pipeclose+0x9c>
80104389:	8b 45 08             	mov    0x8(%ebp),%eax
8010438c:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104392:	85 c0                	test   %eax,%eax
80104394:	75 1f                	jne    801043b5 <pipeclose+0x9c>
    release(&p->lock);
80104396:	8b 45 08             	mov    0x8(%ebp),%eax
80104399:	83 ec 0c             	sub    $0xc,%esp
8010439c:	50                   	push   %eax
8010439d:	e8 f1 0e 00 00       	call   80105293 <release>
801043a2:	83 c4 10             	add    $0x10,%esp
    kfree((char *)p);
801043a5:	83 ec 0c             	sub    $0xc,%esp
801043a8:	ff 75 08             	pushl  0x8(%ebp)
801043ab:	e8 f2 e8 ff ff       	call   80102ca2 <kfree>
801043b0:	83 c4 10             	add    $0x10,%esp
801043b3:	eb 10                	jmp    801043c5 <pipeclose+0xac>
  } else
    release(&p->lock);
801043b5:	8b 45 08             	mov    0x8(%ebp),%eax
801043b8:	83 ec 0c             	sub    $0xc,%esp
801043bb:	50                   	push   %eax
801043bc:	e8 d2 0e 00 00       	call   80105293 <release>
801043c1:	83 c4 10             	add    $0x10,%esp
}
801043c4:	90                   	nop
801043c5:	90                   	nop
801043c6:	c9                   	leave  
801043c7:	c3                   	ret    

801043c8 <pipewrite>:

// PAGEBREAK: 40
int pipewrite(struct pipe *p, char *addr, int n) {
801043c8:	f3 0f 1e fb          	endbr32 
801043cc:	55                   	push   %ebp
801043cd:	89 e5                	mov    %esp,%ebp
801043cf:	53                   	push   %ebx
801043d0:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
801043d3:	8b 45 08             	mov    0x8(%ebp),%eax
801043d6:	83 ec 0c             	sub    $0xc,%esp
801043d9:	50                   	push   %eax
801043da:	e8 49 0e 00 00       	call   80105228 <acquire>
801043df:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < n; i++) {
801043e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801043e9:	e9 ae 00 00 00       	jmp    8010449c <pipewrite+0xd4>
    while (p->nwrite == p->nread + PIPESIZE) { // DOC: pipewrite-full
      if (p->readopen == 0 || proc->killed) {
801043ee:	8b 45 08             	mov    0x8(%ebp),%eax
801043f1:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801043f7:	85 c0                	test   %eax,%eax
801043f9:	74 0d                	je     80104408 <pipewrite+0x40>
801043fb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104401:	8b 40 24             	mov    0x24(%eax),%eax
80104404:	85 c0                	test   %eax,%eax
80104406:	74 19                	je     80104421 <pipewrite+0x59>
        release(&p->lock);
80104408:	8b 45 08             	mov    0x8(%ebp),%eax
8010440b:	83 ec 0c             	sub    $0xc,%esp
8010440e:	50                   	push   %eax
8010440f:	e8 7f 0e 00 00       	call   80105293 <release>
80104414:	83 c4 10             	add    $0x10,%esp
        return -1;
80104417:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010441c:	e9 a9 00 00 00       	jmp    801044ca <pipewrite+0x102>
      }
      wakeup(&p->nread);
80104421:	8b 45 08             	mov    0x8(%ebp),%eax
80104424:	05 34 02 00 00       	add    $0x234,%eax
80104429:	83 ec 0c             	sub    $0xc,%esp
8010442c:	50                   	push   %eax
8010442d:	e8 d7 0b 00 00       	call   80105009 <wakeup>
80104432:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock); // DOC: pipewrite-sleep
80104435:	8b 45 08             	mov    0x8(%ebp),%eax
80104438:	8b 55 08             	mov    0x8(%ebp),%edx
8010443b:	81 c2 38 02 00 00    	add    $0x238,%edx
80104441:	83 ec 08             	sub    $0x8,%esp
80104444:	50                   	push   %eax
80104445:	52                   	push   %edx
80104446:	e8 ca 0a 00 00       	call   80104f15 <sleep>
8010444b:	83 c4 10             	add    $0x10,%esp
    while (p->nwrite == p->nread + PIPESIZE) { // DOC: pipewrite-full
8010444e:	8b 45 08             	mov    0x8(%ebp),%eax
80104451:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104457:	8b 45 08             	mov    0x8(%ebp),%eax
8010445a:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104460:	05 00 02 00 00       	add    $0x200,%eax
80104465:	39 c2                	cmp    %eax,%edx
80104467:	74 85                	je     801043ee <pipewrite+0x26>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104469:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010446c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010446f:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80104472:	8b 45 08             	mov    0x8(%ebp),%eax
80104475:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010447b:	8d 48 01             	lea    0x1(%eax),%ecx
8010447e:	8b 55 08             	mov    0x8(%ebp),%edx
80104481:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80104487:	25 ff 01 00 00       	and    $0x1ff,%eax
8010448c:	89 c1                	mov    %eax,%ecx
8010448e:	0f b6 13             	movzbl (%ebx),%edx
80104491:	8b 45 08             	mov    0x8(%ebp),%eax
80104494:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
  for (i = 0; i < n; i++) {
80104498:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010449c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010449f:	3b 45 10             	cmp    0x10(%ebp),%eax
801044a2:	7c aa                	jl     8010444e <pipewrite+0x86>
  }
  wakeup(&p->nread); // DOC: pipewrite-wakeup1
801044a4:	8b 45 08             	mov    0x8(%ebp),%eax
801044a7:	05 34 02 00 00       	add    $0x234,%eax
801044ac:	83 ec 0c             	sub    $0xc,%esp
801044af:	50                   	push   %eax
801044b0:	e8 54 0b 00 00       	call   80105009 <wakeup>
801044b5:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801044b8:	8b 45 08             	mov    0x8(%ebp),%eax
801044bb:	83 ec 0c             	sub    $0xc,%esp
801044be:	50                   	push   %eax
801044bf:	e8 cf 0d 00 00       	call   80105293 <release>
801044c4:	83 c4 10             	add    $0x10,%esp
  return n;
801044c7:	8b 45 10             	mov    0x10(%ebp),%eax
}
801044ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044cd:	c9                   	leave  
801044ce:	c3                   	ret    

801044cf <piperead>:

int piperead(struct pipe *p, char *addr, int n) {
801044cf:	f3 0f 1e fb          	endbr32 
801044d3:	55                   	push   %ebp
801044d4:	89 e5                	mov    %esp,%ebp
801044d6:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
801044d9:	8b 45 08             	mov    0x8(%ebp),%eax
801044dc:	83 ec 0c             	sub    $0xc,%esp
801044df:	50                   	push   %eax
801044e0:	e8 43 0d 00 00       	call   80105228 <acquire>
801044e5:	83 c4 10             	add    $0x10,%esp
  while (p->nread == p->nwrite && p->writeopen) { // DOC: pipe-empty
801044e8:	eb 3f                	jmp    80104529 <piperead+0x5a>
    if (proc->killed) {
801044ea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044f0:	8b 40 24             	mov    0x24(%eax),%eax
801044f3:	85 c0                	test   %eax,%eax
801044f5:	74 19                	je     80104510 <piperead+0x41>
      release(&p->lock);
801044f7:	8b 45 08             	mov    0x8(%ebp),%eax
801044fa:	83 ec 0c             	sub    $0xc,%esp
801044fd:	50                   	push   %eax
801044fe:	e8 90 0d 00 00       	call   80105293 <release>
80104503:	83 c4 10             	add    $0x10,%esp
      return -1;
80104506:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010450b:	e9 be 00 00 00       	jmp    801045ce <piperead+0xff>
    }
    sleep(&p->nread, &p->lock); // DOC: piperead-sleep
80104510:	8b 45 08             	mov    0x8(%ebp),%eax
80104513:	8b 55 08             	mov    0x8(%ebp),%edx
80104516:	81 c2 34 02 00 00    	add    $0x234,%edx
8010451c:	83 ec 08             	sub    $0x8,%esp
8010451f:	50                   	push   %eax
80104520:	52                   	push   %edx
80104521:	e8 ef 09 00 00       	call   80104f15 <sleep>
80104526:	83 c4 10             	add    $0x10,%esp
  while (p->nread == p->nwrite && p->writeopen) { // DOC: pipe-empty
80104529:	8b 45 08             	mov    0x8(%ebp),%eax
8010452c:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104532:	8b 45 08             	mov    0x8(%ebp),%eax
80104535:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010453b:	39 c2                	cmp    %eax,%edx
8010453d:	75 0d                	jne    8010454c <piperead+0x7d>
8010453f:	8b 45 08             	mov    0x8(%ebp),%eax
80104542:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104548:	85 c0                	test   %eax,%eax
8010454a:	75 9e                	jne    801044ea <piperead+0x1b>
  }
  for (i = 0; i < n; i++) { // DOC: piperead-copy
8010454c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104553:	eb 48                	jmp    8010459d <piperead+0xce>
    if (p->nread == p->nwrite)
80104555:	8b 45 08             	mov    0x8(%ebp),%eax
80104558:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010455e:	8b 45 08             	mov    0x8(%ebp),%eax
80104561:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104567:	39 c2                	cmp    %eax,%edx
80104569:	74 3c                	je     801045a7 <piperead+0xd8>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010456b:	8b 45 08             	mov    0x8(%ebp),%eax
8010456e:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104574:	8d 48 01             	lea    0x1(%eax),%ecx
80104577:	8b 55 08             	mov    0x8(%ebp),%edx
8010457a:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80104580:	25 ff 01 00 00       	and    $0x1ff,%eax
80104585:	89 c1                	mov    %eax,%ecx
80104587:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010458a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010458d:	01 c2                	add    %eax,%edx
8010458f:	8b 45 08             	mov    0x8(%ebp),%eax
80104592:	0f b6 44 08 34       	movzbl 0x34(%eax,%ecx,1),%eax
80104597:	88 02                	mov    %al,(%edx)
  for (i = 0; i < n; i++) { // DOC: piperead-copy
80104599:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010459d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045a0:	3b 45 10             	cmp    0x10(%ebp),%eax
801045a3:	7c b0                	jl     80104555 <piperead+0x86>
801045a5:	eb 01                	jmp    801045a8 <piperead+0xd9>
      break;
801045a7:	90                   	nop
  }
  wakeup(&p->nwrite); // DOC: piperead-wakeup
801045a8:	8b 45 08             	mov    0x8(%ebp),%eax
801045ab:	05 38 02 00 00       	add    $0x238,%eax
801045b0:	83 ec 0c             	sub    $0xc,%esp
801045b3:	50                   	push   %eax
801045b4:	e8 50 0a 00 00       	call   80105009 <wakeup>
801045b9:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801045bc:	8b 45 08             	mov    0x8(%ebp),%eax
801045bf:	83 ec 0c             	sub    $0xc,%esp
801045c2:	50                   	push   %eax
801045c3:	e8 cb 0c 00 00       	call   80105293 <release>
801045c8:	83 c4 10             	add    $0x10,%esp
  return i;
801045cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801045ce:	c9                   	leave  
801045cf:	c3                   	ret    

801045d0 <readeflags>:
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801045d6:	9c                   	pushf  
801045d7:	58                   	pop    %eax
801045d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801045db:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801045de:	c9                   	leave  
801045df:	c3                   	ret    

801045e0 <sti>:
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801045e3:	fb                   	sti    
}
801045e4:	90                   	nop
801045e5:	5d                   	pop    %ebp
801045e6:	c3                   	ret    

801045e7 <hlt>:
{
801045e7:	55                   	push   %ebp
801045e8:	89 e5                	mov    %esp,%ebp
  asm volatile("hlt");
801045ea:	f4                   	hlt    
}
801045eb:	90                   	nop
801045ec:	5d                   	pop    %ebp
801045ed:	c3                   	ret    

801045ee <pinit>:
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void pinit(void) { initlock(&ptable.lock, "ptable"); }
801045ee:	f3 0f 1e fb          	endbr32 
801045f2:	55                   	push   %ebp
801045f3:	89 e5                	mov    %esp,%ebp
801045f5:	83 ec 08             	sub    $0x8,%esp
801045f8:	83 ec 08             	sub    $0x8,%esp
801045fb:	68 39 a1 10 80       	push   $0x8010a139
80104600:	68 40 3a 11 80       	push   $0x80113a40
80104605:	e8 f8 0b 00 00       	call   80105202 <initlock>
8010460a:	83 c4 10             	add    $0x10,%esp
8010460d:	90                   	nop
8010460e:	c9                   	leave  
8010460f:	c3                   	ret    

80104610 <allocproc>:
// PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc *allocproc(void) {
80104610:	f3 0f 1e fb          	endbr32 
80104614:	55                   	push   %ebp
80104615:	89 e5                	mov    %esp,%ebp
80104617:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010461a:	83 ec 0c             	sub    $0xc,%esp
8010461d:	68 40 3a 11 80       	push   $0x80113a40
80104622:	e8 01 0c 00 00       	call   80105228 <acquire>
80104627:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010462a:	c7 45 f4 74 3a 11 80 	movl   $0x80113a74,-0xc(%ebp)
80104631:	eb 0e                	jmp    80104641 <allocproc+0x31>
    if (p->state == UNUSED)
80104633:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104636:	8b 40 0c             	mov    0xc(%eax),%eax
80104639:	85 c0                	test   %eax,%eax
8010463b:	74 27                	je     80104664 <allocproc+0x54>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010463d:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104641:	81 7d f4 74 5a 11 80 	cmpl   $0x80115a74,-0xc(%ebp)
80104648:	72 e9                	jb     80104633 <allocproc+0x23>
      goto found;
  release(&ptable.lock);
8010464a:	83 ec 0c             	sub    $0xc,%esp
8010464d:	68 40 3a 11 80       	push   $0x80113a40
80104652:	e8 3c 0c 00 00       	call   80105293 <release>
80104657:	83 c4 10             	add    $0x10,%esp
  return 0;
8010465a:	b8 00 00 00 00       	mov    $0x0,%eax
8010465f:	e9 c0 00 00 00       	jmp    80104724 <allocproc+0x114>
      goto found;
80104664:	90                   	nop
80104665:	f3 0f 1e fb          	endbr32 

found:
  p->state = EMBRYO;
80104669:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010466c:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80104673:	a1 04 d0 10 80       	mov    0x8010d004,%eax
80104678:	8d 50 01             	lea    0x1(%eax),%edx
8010467b:	89 15 04 d0 10 80    	mov    %edx,0x8010d004
80104681:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104684:	89 42 10             	mov    %eax,0x10(%edx)
  p->traced = T_UNTRACE;
80104687:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010468a:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
  release(&ptable.lock);
80104691:	83 ec 0c             	sub    $0xc,%esp
80104694:	68 40 3a 11 80       	push   $0x80113a40
80104699:	e8 f5 0b 00 00       	call   80105293 <release>
8010469e:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if ((p->kstack = kalloc()) == 0) {
801046a1:	e8 9d e6 ff ff       	call   80102d43 <kalloc>
801046a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046a9:	89 42 08             	mov    %eax,0x8(%edx)
801046ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046af:	8b 40 08             	mov    0x8(%eax),%eax
801046b2:	85 c0                	test   %eax,%eax
801046b4:	75 11                	jne    801046c7 <allocproc+0xb7>
    p->state = UNUSED;
801046b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046b9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
801046c0:	b8 00 00 00 00       	mov    $0x0,%eax
801046c5:	eb 5d                	jmp    80104724 <allocproc+0x114>
  }
  sp = p->kstack + KSTACKSIZE;
801046c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046ca:	8b 40 08             	mov    0x8(%eax),%eax
801046cd:	05 00 10 00 00       	add    $0x1000,%eax
801046d2:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801046d5:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe *)sp;
801046d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
801046df:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
801046e2:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint *)sp = (uint)trapret;
801046e6:	ba 41 8f 10 80       	mov    $0x80108f41,%edx
801046eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801046ee:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
801046f0:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context *)sp;
801046f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
801046fa:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801046fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104700:	8b 40 1c             	mov    0x1c(%eax),%eax
80104703:	83 ec 04             	sub    $0x4,%esp
80104706:	6a 14                	push   $0x14
80104708:	6a 00                	push   $0x0
8010470a:	50                   	push   %eax
8010470b:	e8 94 0d 00 00       	call   801054a4 <memset>
80104710:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104713:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104716:	8b 40 1c             	mov    0x1c(%eax),%eax
80104719:	ba cb 4e 10 80       	mov    $0x80104ecb,%edx
8010471e:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
80104721:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104724:	c9                   	leave  
80104725:	c3                   	ret    

80104726 <userinit>:

// PAGEBREAK: 32
// Set up first user process.
void userinit(void) {
80104726:	f3 0f 1e fb          	endbr32 
8010472a:	55                   	push   %ebp
8010472b:	89 e5                	mov    %esp,%ebp
8010472d:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_user_initcode_start[], _binary_user_initcode_size[];

  p = allocproc();
80104730:	e8 db fe ff ff       	call   80104610 <allocproc>
80104735:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
80104738:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010473b:	a3 08 d7 10 80       	mov    %eax,0x8010d708
  if ((p->pgdir = setupkvm()) == 0)
80104740:	e8 35 4e 00 00       	call   8010957a <setupkvm>
80104745:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104748:	89 42 04             	mov    %eax,0x4(%edx)
8010474b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010474e:	8b 40 04             	mov    0x4(%eax),%eax
80104751:	85 c0                	test   %eax,%eax
80104753:	75 0d                	jne    80104762 <userinit+0x3c>
    panic("userinit: out of memory?");
80104755:	83 ec 0c             	sub    $0xc,%esp
80104758:	68 40 a1 10 80       	push   $0x8010a140
8010475d:	e8 01 be ff ff       	call   80100563 <panic>
  inituvm(p->pgdir, _binary_user_initcode_start, (int)_binary_user_initcode_size);
80104762:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104767:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010476a:	8b 40 04             	mov    0x4(%eax),%eax
8010476d:	83 ec 04             	sub    $0x4,%esp
80104770:	52                   	push   %edx
80104771:	68 a0 d5 10 80       	push   $0x8010d5a0
80104776:	50                   	push   %eax
80104777:	e8 69 50 00 00       	call   801097e5 <inituvm>
8010477c:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
8010477f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104782:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104788:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010478b:	8b 40 18             	mov    0x18(%eax),%eax
8010478e:	83 ec 04             	sub    $0x4,%esp
80104791:	6a 4c                	push   $0x4c
80104793:	6a 00                	push   $0x0
80104795:	50                   	push   %eax
80104796:	e8 09 0d 00 00       	call   801054a4 <memset>
8010479b:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010479e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047a1:	8b 40 18             	mov    0x18(%eax),%eax
801047a4:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801047aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047ad:	8b 40 18             	mov    0x18(%eax),%eax
801047b0:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
801047b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047b9:	8b 50 18             	mov    0x18(%eax),%edx
801047bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047bf:	8b 40 18             	mov    0x18(%eax),%eax
801047c2:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801047c6:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801047ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047cd:	8b 50 18             	mov    0x18(%eax),%edx
801047d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047d3:	8b 40 18             	mov    0x18(%eax),%eax
801047d6:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801047da:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801047de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047e1:	8b 40 18             	mov    0x18(%eax),%eax
801047e4:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801047eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047ee:	8b 40 18             	mov    0x18(%eax),%eax
801047f1:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0; // beginning of initcode.S
801047f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047fb:	8b 40 18             	mov    0x18(%eax),%eax
801047fe:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104805:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104808:	83 c0 6c             	add    $0x6c,%eax
8010480b:	83 ec 04             	sub    $0x4,%esp
8010480e:	6a 10                	push   $0x10
80104810:	68 59 a1 10 80       	push   $0x8010a159
80104815:	50                   	push   %eax
80104816:	e8 a4 0e 00 00       	call   801056bf <safestrcpy>
8010481b:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
8010481e:	83 ec 0c             	sub    $0xc,%esp
80104821:	68 62 a1 10 80       	push   $0x8010a162
80104826:	e8 9b dd ff ff       	call   801025c6 <namei>
8010482b:	83 c4 10             	add    $0x10,%esp
8010482e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104831:	89 42 68             	mov    %eax,0x68(%edx)

  p->state = RUNNABLE;
80104834:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104837:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
8010483e:	90                   	nop
8010483f:	c9                   	leave  
80104840:	c3                   	ret    

80104841 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int growproc(int n) {
80104841:	f3 0f 1e fb          	endbr32 
80104845:	55                   	push   %ebp
80104846:	89 e5                	mov    %esp,%ebp
80104848:	83 ec 18             	sub    $0x18,%esp
  uint sz;

  sz = proc->sz;
8010484b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104851:	8b 00                	mov    (%eax),%eax
80104853:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (n > 0) {
80104856:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010485a:	7e 31                	jle    8010488d <growproc+0x4c>
    if ((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
8010485c:	8b 55 08             	mov    0x8(%ebp),%edx
8010485f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104862:	01 c2                	add    %eax,%edx
80104864:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010486a:	8b 40 04             	mov    0x4(%eax),%eax
8010486d:	83 ec 04             	sub    $0x4,%esp
80104870:	52                   	push   %edx
80104871:	ff 75 f4             	pushl  -0xc(%ebp)
80104874:	50                   	push   %eax
80104875:	e8 c0 50 00 00       	call   8010993a <allocuvm>
8010487a:	83 c4 10             	add    $0x10,%esp
8010487d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104880:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104884:	75 3e                	jne    801048c4 <growproc+0x83>
      return -1;
80104886:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010488b:	eb 59                	jmp    801048e6 <growproc+0xa5>
  } else if (n < 0) {
8010488d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104891:	79 31                	jns    801048c4 <growproc+0x83>
    if ((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104893:	8b 55 08             	mov    0x8(%ebp),%edx
80104896:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104899:	01 c2                	add    %eax,%edx
8010489b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048a1:	8b 40 04             	mov    0x4(%eax),%eax
801048a4:	83 ec 04             	sub    $0x4,%esp
801048a7:	52                   	push   %edx
801048a8:	ff 75 f4             	pushl  -0xc(%ebp)
801048ab:	50                   	push   %eax
801048ac:	e8 54 51 00 00       	call   80109a05 <deallocuvm>
801048b1:	83 c4 10             	add    $0x10,%esp
801048b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801048b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801048bb:	75 07                	jne    801048c4 <growproc+0x83>
      return -1;
801048bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048c2:	eb 22                	jmp    801048e6 <growproc+0xa5>
  }
  proc->sz = sz;
801048c4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048cd:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
801048cf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048d5:	83 ec 0c             	sub    $0xc,%esp
801048d8:	50                   	push   %eax
801048d9:	e8 8f 4d 00 00       	call   8010966d <switchuvm>
801048de:	83 c4 10             	add    $0x10,%esp
  return 0;
801048e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801048e6:	c9                   	leave  
801048e7:	c3                   	ret    

801048e8 <fork>:

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int fork(void) {
801048e8:	f3 0f 1e fb          	endbr32 
801048ec:	55                   	push   %ebp
801048ed:	89 e5                	mov    %esp,%ebp
801048ef:	57                   	push   %edi
801048f0:	56                   	push   %esi
801048f1:	53                   	push   %ebx
801048f2:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if ((np = allocproc()) == 0)
801048f5:	e8 16 fd ff ff       	call   80104610 <allocproc>
801048fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
801048fd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104901:	75 0a                	jne    8010490d <fork+0x25>
    return -1;
80104903:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104908:	e9 8a 01 00 00       	jmp    80104a97 <fork+0x1af>

  // Copy process state from p.
  if ((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0) {
8010490d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104913:	8b 10                	mov    (%eax),%edx
80104915:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010491b:	8b 40 04             	mov    0x4(%eax),%eax
8010491e:	83 ec 08             	sub    $0x8,%esp
80104921:	52                   	push   %edx
80104922:	50                   	push   %eax
80104923:	e8 87 52 00 00       	call   80109baf <copyuvm>
80104928:	83 c4 10             	add    $0x10,%esp
8010492b:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010492e:	89 42 04             	mov    %eax,0x4(%edx)
80104931:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104934:	8b 40 04             	mov    0x4(%eax),%eax
80104937:	85 c0                	test   %eax,%eax
80104939:	75 30                	jne    8010496b <fork+0x83>
    kfree(np->kstack);
8010493b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010493e:	8b 40 08             	mov    0x8(%eax),%eax
80104941:	83 ec 0c             	sub    $0xc,%esp
80104944:	50                   	push   %eax
80104945:	e8 58 e3 ff ff       	call   80102ca2 <kfree>
8010494a:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
8010494d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104950:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104957:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010495a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104961:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104966:	e9 2c 01 00 00       	jmp    80104a97 <fork+0x1af>
  }
  np->traced = (proc->traced & T_ONFORK) ? proc->traced: T_UNTRACE;
8010496b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104971:	8b 40 7c             	mov    0x7c(%eax),%eax
80104974:	83 e0 02             	and    $0x2,%eax
80104977:	85 c0                	test   %eax,%eax
80104979:	74 0b                	je     80104986 <fork+0x9e>
8010497b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104981:	8b 40 7c             	mov    0x7c(%eax),%eax
80104984:	eb 05                	jmp    8010498b <fork+0xa3>
80104986:	b8 00 00 00 00       	mov    $0x0,%eax
8010498b:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010498e:	89 42 7c             	mov    %eax,0x7c(%edx)
  np->sz = proc->sz;
80104991:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104997:	8b 10                	mov    (%eax),%edx
80104999:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010499c:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
8010499e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801049a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049a8:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
801049ab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049b1:	8b 48 18             	mov    0x18(%eax),%ecx
801049b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049b7:	8b 40 18             	mov    0x18(%eax),%eax
801049ba:	89 c2                	mov    %eax,%edx
801049bc:	89 cb                	mov    %ecx,%ebx
801049be:	b8 13 00 00 00       	mov    $0x13,%eax
801049c3:	89 d7                	mov    %edx,%edi
801049c5:	89 de                	mov    %ebx,%esi
801049c7:	89 c1                	mov    %eax,%ecx
801049c9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801049cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049ce:	8b 40 18             	mov    0x18(%eax),%eax
801049d1:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for (i = 0; i < NOFILE; i++)
801049d8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801049df:	eb 41                	jmp    80104a22 <fork+0x13a>
    if (proc->ofile[i])
801049e1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801049ea:	83 c2 08             	add    $0x8,%edx
801049ed:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801049f1:	85 c0                	test   %eax,%eax
801049f3:	74 29                	je     80104a1e <fork+0x136>
      np->ofile[i] = filedup(proc->ofile[i]);
801049f5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049fb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801049fe:	83 c2 08             	add    $0x8,%edx
80104a01:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a05:	83 ec 0c             	sub    $0xc,%esp
80104a08:	50                   	push   %eax
80104a09:	e8 2d c6 ff ff       	call   8010103b <filedup>
80104a0e:	83 c4 10             	add    $0x10,%esp
80104a11:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104a14:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104a17:	83 c1 08             	add    $0x8,%ecx
80104a1a:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  for (i = 0; i < NOFILE; i++)
80104a1e:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104a22:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104a26:	7e b9                	jle    801049e1 <fork+0xf9>
  np->cwd = idup(proc->cwd);
80104a28:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a2e:	8b 40 68             	mov    0x68(%eax),%eax
80104a31:	83 ec 0c             	sub    $0xc,%esp
80104a34:	50                   	push   %eax
80104a35:	e8 65 cf ff ff       	call   8010199f <idup>
80104a3a:	83 c4 10             	add    $0x10,%esp
80104a3d:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104a40:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104a43:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a49:	8d 50 6c             	lea    0x6c(%eax),%edx
80104a4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a4f:	83 c0 6c             	add    $0x6c,%eax
80104a52:	83 ec 04             	sub    $0x4,%esp
80104a55:	6a 10                	push   $0x10
80104a57:	52                   	push   %edx
80104a58:	50                   	push   %eax
80104a59:	e8 61 0c 00 00       	call   801056bf <safestrcpy>
80104a5e:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
80104a61:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a64:	8b 40 10             	mov    0x10(%eax),%eax
80104a67:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
80104a6a:	83 ec 0c             	sub    $0xc,%esp
80104a6d:	68 40 3a 11 80       	push   $0x80113a40
80104a72:	e8 b1 07 00 00       	call   80105228 <acquire>
80104a77:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
80104a7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a7d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
80104a84:	83 ec 0c             	sub    $0xc,%esp
80104a87:	68 40 3a 11 80       	push   $0x80113a40
80104a8c:	e8 02 08 00 00       	call   80105293 <release>
80104a91:	83 c4 10             	add    $0x10,%esp

  return pid;
80104a94:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104a97:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a9a:	5b                   	pop    %ebx
80104a9b:	5e                   	pop    %esi
80104a9c:	5f                   	pop    %edi
80104a9d:	5d                   	pop    %ebp
80104a9e:	c3                   	ret    

80104a9f <exit>:

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void exit(void) {
80104a9f:	f3 0f 1e fb          	endbr32 
80104aa3:	55                   	push   %ebp
80104aa4:	89 e5                	mov    %esp,%ebp
80104aa6:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if (proc == initproc)
80104aa9:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104ab0:	a1 08 d7 10 80       	mov    0x8010d708,%eax
80104ab5:	39 c2                	cmp    %eax,%edx
80104ab7:	75 0d                	jne    80104ac6 <exit+0x27>
    panic("init exiting");
80104ab9:	83 ec 0c             	sub    $0xc,%esp
80104abc:	68 64 a1 10 80       	push   $0x8010a164
80104ac1:	e8 9d ba ff ff       	call   80100563 <panic>

  // Close all open files.
  for (fd = 0; fd < NOFILE; fd++) {
80104ac6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104acd:	eb 48                	jmp    80104b17 <exit+0x78>
    if (proc->ofile[fd]) {
80104acf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ad5:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104ad8:	83 c2 08             	add    $0x8,%edx
80104adb:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104adf:	85 c0                	test   %eax,%eax
80104ae1:	74 30                	je     80104b13 <exit+0x74>
      fileclose(proc->ofile[fd]);
80104ae3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ae9:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104aec:	83 c2 08             	add    $0x8,%edx
80104aef:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104af3:	83 ec 0c             	sub    $0xc,%esp
80104af6:	50                   	push   %eax
80104af7:	e8 94 c5 ff ff       	call   80101090 <fileclose>
80104afc:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80104aff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b05:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104b08:	83 c2 08             	add    $0x8,%edx
80104b0b:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104b12:	00 
  for (fd = 0; fd < NOFILE; fd++) {
80104b13:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104b17:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104b1b:	7e b2                	jle    80104acf <exit+0x30>
    }
  }

  begin_op();
80104b1d:	e8 47 eb ff ff       	call   80103669 <begin_op>
  iput(proc->cwd);
80104b22:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b28:	8b 40 68             	mov    0x68(%eax),%eax
80104b2b:	83 ec 0c             	sub    $0xc,%esp
80104b2e:	50                   	push   %eax
80104b2f:	e8 81 d0 ff ff       	call   80101bb5 <iput>
80104b34:	83 c4 10             	add    $0x10,%esp
  end_op();
80104b37:	e8 bd eb ff ff       	call   801036f9 <end_op>
  proc->cwd = 0;
80104b3c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b42:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104b49:	83 ec 0c             	sub    $0xc,%esp
80104b4c:	68 40 3a 11 80       	push   $0x80113a40
80104b51:	e8 d2 06 00 00       	call   80105228 <acquire>
80104b56:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104b59:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b5f:	8b 40 14             	mov    0x14(%eax),%eax
80104b62:	83 ec 0c             	sub    $0xc,%esp
80104b65:	50                   	push   %eax
80104b66:	e8 5a 04 00 00       	call   80104fc5 <wakeup1>
80104b6b:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104b6e:	c7 45 f4 74 3a 11 80 	movl   $0x80113a74,-0xc(%ebp)
80104b75:	eb 3c                	jmp    80104bb3 <exit+0x114>
    if (p->parent == proc) {
80104b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b7a:	8b 50 14             	mov    0x14(%eax),%edx
80104b7d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b83:	39 c2                	cmp    %eax,%edx
80104b85:	75 28                	jne    80104baf <exit+0x110>
      p->parent = initproc;
80104b87:	8b 15 08 d7 10 80    	mov    0x8010d708,%edx
80104b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b90:	89 50 14             	mov    %edx,0x14(%eax)
      if (p->state == ZOMBIE)
80104b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b96:	8b 40 0c             	mov    0xc(%eax),%eax
80104b99:	83 f8 05             	cmp    $0x5,%eax
80104b9c:	75 11                	jne    80104baf <exit+0x110>
        wakeup1(initproc);
80104b9e:	a1 08 d7 10 80       	mov    0x8010d708,%eax
80104ba3:	83 ec 0c             	sub    $0xc,%esp
80104ba6:	50                   	push   %eax
80104ba7:	e8 19 04 00 00       	call   80104fc5 <wakeup1>
80104bac:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104baf:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104bb3:	81 7d f4 74 5a 11 80 	cmpl   $0x80115a74,-0xc(%ebp)
80104bba:	72 bb                	jb     80104b77 <exit+0xd8>
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104bbc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bc2:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104bc9:	e8 fe 01 00 00       	call   80104dcc <sched>
  panic("zombie exit");
80104bce:	83 ec 0c             	sub    $0xc,%esp
80104bd1:	68 71 a1 10 80       	push   $0x8010a171
80104bd6:	e8 88 b9 ff ff       	call   80100563 <panic>

80104bdb <wait>:
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int wait(void) {
80104bdb:	f3 0f 1e fb          	endbr32 
80104bdf:	55                   	push   %ebp
80104be0:	89 e5                	mov    %esp,%ebp
80104be2:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104be5:	83 ec 0c             	sub    $0xc,%esp
80104be8:	68 40 3a 11 80       	push   $0x80113a40
80104bed:	e8 36 06 00 00       	call   80105228 <acquire>
80104bf2:	83 c4 10             	add    $0x10,%esp
  for (;;) {
    // Scan through table looking for zombie children.
    havekids = 0;
80104bf5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104bfc:	c7 45 f4 74 3a 11 80 	movl   $0x80113a74,-0xc(%ebp)
80104c03:	e9 a6 00 00 00       	jmp    80104cae <wait+0xd3>
      if (p->parent != proc)
80104c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c0b:	8b 50 14             	mov    0x14(%eax),%edx
80104c0e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c14:	39 c2                	cmp    %eax,%edx
80104c16:	0f 85 8d 00 00 00    	jne    80104ca9 <wait+0xce>
        continue;
      havekids = 1;
80104c1c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if (p->state == ZOMBIE) {
80104c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c26:	8b 40 0c             	mov    0xc(%eax),%eax
80104c29:	83 f8 05             	cmp    $0x5,%eax
80104c2c:	75 7c                	jne    80104caa <wait+0xcf>
        // Found one.
        pid = p->pid;
80104c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c31:	8b 40 10             	mov    0x10(%eax),%eax
80104c34:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c3a:	8b 40 08             	mov    0x8(%eax),%eax
80104c3d:	83 ec 0c             	sub    $0xc,%esp
80104c40:	50                   	push   %eax
80104c41:	e8 5c e0 ff ff       	call   80102ca2 <kfree>
80104c46:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c4c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c56:	8b 40 04             	mov    0x4(%eax),%eax
80104c59:	83 ec 0c             	sub    $0xc,%esp
80104c5c:	50                   	push   %eax
80104c5d:	e8 64 4e 00 00       	call   80109ac6 <freevm>
80104c62:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c68:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c72:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c7c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c86:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c8d:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104c94:	83 ec 0c             	sub    $0xc,%esp
80104c97:	68 40 3a 11 80       	push   $0x80113a40
80104c9c:	e8 f2 05 00 00       	call   80105293 <release>
80104ca1:	83 c4 10             	add    $0x10,%esp
        return pid;
80104ca4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104ca7:	eb 58                	jmp    80104d01 <wait+0x126>
        continue;
80104ca9:	90                   	nop
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104caa:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104cae:	81 7d f4 74 5a 11 80 	cmpl   $0x80115a74,-0xc(%ebp)
80104cb5:	0f 82 4d ff ff ff    	jb     80104c08 <wait+0x2d>
      }
    }

    // No point waiting if we don't have any children.
    if (!havekids || proc->killed) {
80104cbb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104cbf:	74 0d                	je     80104cce <wait+0xf3>
80104cc1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cc7:	8b 40 24             	mov    0x24(%eax),%eax
80104cca:	85 c0                	test   %eax,%eax
80104ccc:	74 17                	je     80104ce5 <wait+0x10a>
      release(&ptable.lock);
80104cce:	83 ec 0c             	sub    $0xc,%esp
80104cd1:	68 40 3a 11 80       	push   $0x80113a40
80104cd6:	e8 b8 05 00 00       	call   80105293 <release>
80104cdb:	83 c4 10             	add    $0x10,%esp
      return -1;
80104cde:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ce3:	eb 1c                	jmp    80104d01 <wait+0x126>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock); // DOC: wait-sleep
80104ce5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ceb:	83 ec 08             	sub    $0x8,%esp
80104cee:	68 40 3a 11 80       	push   $0x80113a40
80104cf3:	50                   	push   %eax
80104cf4:	e8 1c 02 00 00       	call   80104f15 <sleep>
80104cf9:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104cfc:	e9 f4 fe ff ff       	jmp    80104bf5 <wait+0x1a>
  }
}
80104d01:	c9                   	leave  
80104d02:	c3                   	ret    

80104d03 <scheduler>:
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void scheduler(void) {
80104d03:	f3 0f 1e fb          	endbr32 
80104d07:	55                   	push   %ebp
80104d08:	89 e5                	mov    %esp,%ebp
80104d0a:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int foundproc = 1;
80104d0d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

  for (;;) {
    // Enable interrupts on this processor.
    sti();
80104d14:	e8 c7 f8 ff ff       	call   801045e0 <sti>

    if (!foundproc)
80104d19:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104d1d:	75 05                	jne    80104d24 <scheduler+0x21>
      hlt();
80104d1f:	e8 c3 f8 ff ff       	call   801045e7 <hlt>

    foundproc = 0;
80104d24:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104d2b:	83 ec 0c             	sub    $0xc,%esp
80104d2e:	68 40 3a 11 80       	push   $0x80113a40
80104d33:	e8 f0 04 00 00       	call   80105228 <acquire>
80104d38:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104d3b:	c7 45 f4 74 3a 11 80 	movl   $0x80113a74,-0xc(%ebp)
80104d42:	eb 6a                	jmp    80104dae <scheduler+0xab>
      if (p->state != RUNNABLE)
80104d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d47:	8b 40 0c             	mov    0xc(%eax),%eax
80104d4a:	83 f8 03             	cmp    $0x3,%eax
80104d4d:	75 5a                	jne    80104da9 <scheduler+0xa6>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      foundproc = 1;
80104d4f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      proc = p;
80104d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d59:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104d5f:	83 ec 0c             	sub    $0xc,%esp
80104d62:	ff 75 f4             	pushl  -0xc(%ebp)
80104d65:	e8 03 49 00 00       	call   8010966d <switchuvm>
80104d6a:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d70:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
80104d77:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d7d:	8b 40 1c             	mov    0x1c(%eax),%eax
80104d80:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104d87:	83 c2 04             	add    $0x4,%edx
80104d8a:	83 ec 08             	sub    $0x8,%esp
80104d8d:	50                   	push   %eax
80104d8e:	52                   	push   %edx
80104d8f:	e8 a4 09 00 00       	call   80105738 <swtch>
80104d94:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104d97:	e8 b0 48 00 00       	call   8010964c <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104d9c:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104da3:	00 00 00 00 
80104da7:	eb 01                	jmp    80104daa <scheduler+0xa7>
        continue;
80104da9:	90                   	nop
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104daa:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104dae:	81 7d f4 74 5a 11 80 	cmpl   $0x80115a74,-0xc(%ebp)
80104db5:	72 8d                	jb     80104d44 <scheduler+0x41>
    }
    release(&ptable.lock);
80104db7:	83 ec 0c             	sub    $0xc,%esp
80104dba:	68 40 3a 11 80       	push   $0x80113a40
80104dbf:	e8 cf 04 00 00       	call   80105293 <release>
80104dc4:	83 c4 10             	add    $0x10,%esp
    sti();
80104dc7:	e9 48 ff ff ff       	jmp    80104d14 <scheduler+0x11>

80104dcc <sched>:
  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void sched(void) {
80104dcc:	f3 0f 1e fb          	endbr32 
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	83 ec 18             	sub    $0x18,%esp
  int intena;

  if (!holding(&ptable.lock))
80104dd6:	83 ec 0c             	sub    $0xc,%esp
80104dd9:	68 40 3a 11 80       	push   $0x80113a40
80104dde:	e8 85 05 00 00       	call   80105368 <holding>
80104de3:	83 c4 10             	add    $0x10,%esp
80104de6:	85 c0                	test   %eax,%eax
80104de8:	75 0d                	jne    80104df7 <sched+0x2b>
    panic("sched ptable.lock");
80104dea:	83 ec 0c             	sub    $0xc,%esp
80104ded:	68 7d a1 10 80       	push   $0x8010a17d
80104df2:	e8 6c b7 ff ff       	call   80100563 <panic>
  if (cpu->ncli != 1)
80104df7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104dfd:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104e03:	83 f8 01             	cmp    $0x1,%eax
80104e06:	74 0d                	je     80104e15 <sched+0x49>
    panic("sched locks");
80104e08:	83 ec 0c             	sub    $0xc,%esp
80104e0b:	68 8f a1 10 80       	push   $0x8010a18f
80104e10:	e8 4e b7 ff ff       	call   80100563 <panic>
  if (proc->state == RUNNING)
80104e15:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e1b:	8b 40 0c             	mov    0xc(%eax),%eax
80104e1e:	83 f8 04             	cmp    $0x4,%eax
80104e21:	75 0d                	jne    80104e30 <sched+0x64>
    panic("sched running");
80104e23:	83 ec 0c             	sub    $0xc,%esp
80104e26:	68 9b a1 10 80       	push   $0x8010a19b
80104e2b:	e8 33 b7 ff ff       	call   80100563 <panic>
  if (readeflags() & FL_IF)
80104e30:	e8 9b f7 ff ff       	call   801045d0 <readeflags>
80104e35:	25 00 02 00 00       	and    $0x200,%eax
80104e3a:	85 c0                	test   %eax,%eax
80104e3c:	74 0d                	je     80104e4b <sched+0x7f>
    panic("sched interruptible");
80104e3e:	83 ec 0c             	sub    $0xc,%esp
80104e41:	68 a9 a1 10 80       	push   $0x8010a1a9
80104e46:	e8 18 b7 ff ff       	call   80100563 <panic>
  intena = cpu->intena;
80104e4b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e51:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104e57:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104e5a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e60:	8b 40 04             	mov    0x4(%eax),%eax
80104e63:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104e6a:	83 c2 1c             	add    $0x1c,%edx
80104e6d:	83 ec 08             	sub    $0x8,%esp
80104e70:	50                   	push   %eax
80104e71:	52                   	push   %edx
80104e72:	e8 c1 08 00 00       	call   80105738 <swtch>
80104e77:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80104e7a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e80:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e83:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104e89:	90                   	nop
80104e8a:	c9                   	leave  
80104e8b:	c3                   	ret    

80104e8c <yield>:

// Give up the CPU for one scheduling round.
void yield(void) {
80104e8c:	f3 0f 1e fb          	endbr32 
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
80104e93:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock); // DOC: yieldlock
80104e96:	83 ec 0c             	sub    $0xc,%esp
80104e99:	68 40 3a 11 80       	push   $0x80113a40
80104e9e:	e8 85 03 00 00       	call   80105228 <acquire>
80104ea3:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
80104ea6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104eac:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104eb3:	e8 14 ff ff ff       	call   80104dcc <sched>
  release(&ptable.lock);
80104eb8:	83 ec 0c             	sub    $0xc,%esp
80104ebb:	68 40 3a 11 80       	push   $0x80113a40
80104ec0:	e8 ce 03 00 00       	call   80105293 <release>
80104ec5:	83 c4 10             	add    $0x10,%esp
}
80104ec8:	90                   	nop
80104ec9:	c9                   	leave  
80104eca:	c3                   	ret    

80104ecb <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void) {
80104ecb:	f3 0f 1e fb          	endbr32 
80104ecf:	55                   	push   %ebp
80104ed0:	89 e5                	mov    %esp,%ebp
80104ed2:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104ed5:	83 ec 0c             	sub    $0xc,%esp
80104ed8:	68 40 3a 11 80       	push   $0x80113a40
80104edd:	e8 b1 03 00 00       	call   80105293 <release>
80104ee2:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104ee5:	a1 08 d0 10 80       	mov    0x8010d008,%eax
80104eea:	85 c0                	test   %eax,%eax
80104eec:	74 24                	je     80104f12 <forkret+0x47>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80104eee:	c7 05 08 d0 10 80 00 	movl   $0x0,0x8010d008
80104ef5:	00 00 00 
    iinit(ROOTDEV);
80104ef8:	83 ec 0c             	sub    $0xc,%esp
80104efb:	6a 01                	push   $0x1
80104efd:	e8 9b c7 ff ff       	call   8010169d <iinit>
80104f02:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80104f05:	83 ec 0c             	sub    $0xc,%esp
80104f08:	6a 01                	push   $0x1
80104f0a:	e8 27 e5 ff ff       	call   80103436 <initlog>
80104f0f:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104f12:	90                   	nop
80104f13:	c9                   	leave  
80104f14:	c3                   	ret    

80104f15 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk) {
80104f15:	f3 0f 1e fb          	endbr32 
80104f19:	55                   	push   %ebp
80104f1a:	89 e5                	mov    %esp,%ebp
80104f1c:	83 ec 08             	sub    $0x8,%esp
  if (proc == 0)
80104f1f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f25:	85 c0                	test   %eax,%eax
80104f27:	75 0d                	jne    80104f36 <sleep+0x21>
    panic("sleep");
80104f29:	83 ec 0c             	sub    $0xc,%esp
80104f2c:	68 bd a1 10 80       	push   $0x8010a1bd
80104f31:	e8 2d b6 ff ff       	call   80100563 <panic>

  if (lk == 0)
80104f36:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104f3a:	75 0d                	jne    80104f49 <sleep+0x34>
    panic("sleep without lk");
80104f3c:	83 ec 0c             	sub    $0xc,%esp
80104f3f:	68 c3 a1 10 80       	push   $0x8010a1c3
80104f44:	e8 1a b6 ff ff       	call   80100563 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if (lk != &ptable.lock) { // DOC: sleeplock0
80104f49:	81 7d 0c 40 3a 11 80 	cmpl   $0x80113a40,0xc(%ebp)
80104f50:	74 1e                	je     80104f70 <sleep+0x5b>
    acquire(&ptable.lock);  // DOC: sleeplock1
80104f52:	83 ec 0c             	sub    $0xc,%esp
80104f55:	68 40 3a 11 80       	push   $0x80113a40
80104f5a:	e8 c9 02 00 00       	call   80105228 <acquire>
80104f5f:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104f62:	83 ec 0c             	sub    $0xc,%esp
80104f65:	ff 75 0c             	pushl  0xc(%ebp)
80104f68:	e8 26 03 00 00       	call   80105293 <release>
80104f6d:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
80104f70:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f76:	8b 55 08             	mov    0x8(%ebp),%edx
80104f79:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104f7c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f82:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104f89:	e8 3e fe ff ff       	call   80104dcc <sched>

  // Tidy up.
  proc->chan = 0;
80104f8e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f94:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if (lk != &ptable.lock) { // DOC: sleeplock2
80104f9b:	81 7d 0c 40 3a 11 80 	cmpl   $0x80113a40,0xc(%ebp)
80104fa2:	74 1e                	je     80104fc2 <sleep+0xad>
    release(&ptable.lock);
80104fa4:	83 ec 0c             	sub    $0xc,%esp
80104fa7:	68 40 3a 11 80       	push   $0x80113a40
80104fac:	e8 e2 02 00 00       	call   80105293 <release>
80104fb1:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104fb4:	83 ec 0c             	sub    $0xc,%esp
80104fb7:	ff 75 0c             	pushl  0xc(%ebp)
80104fba:	e8 69 02 00 00       	call   80105228 <acquire>
80104fbf:	83 c4 10             	add    $0x10,%esp
  }
}
80104fc2:	90                   	nop
80104fc3:	c9                   	leave  
80104fc4:	c3                   	ret    

80104fc5 <wakeup1>:

// PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void wakeup1(void *chan) {
80104fc5:	f3 0f 1e fb          	endbr32 
80104fc9:	55                   	push   %ebp
80104fca:	89 e5                	mov    %esp,%ebp
80104fcc:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104fcf:	c7 45 fc 74 3a 11 80 	movl   $0x80113a74,-0x4(%ebp)
80104fd6:	eb 24                	jmp    80104ffc <wakeup1+0x37>
    if (p->state == SLEEPING && p->chan == chan)
80104fd8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104fdb:	8b 40 0c             	mov    0xc(%eax),%eax
80104fde:	83 f8 02             	cmp    $0x2,%eax
80104fe1:	75 15                	jne    80104ff8 <wakeup1+0x33>
80104fe3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104fe6:	8b 40 20             	mov    0x20(%eax),%eax
80104fe9:	39 45 08             	cmp    %eax,0x8(%ebp)
80104fec:	75 0a                	jne    80104ff8 <wakeup1+0x33>
      p->state = RUNNABLE;
80104fee:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ff1:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ff8:	83 6d fc 80          	subl   $0xffffff80,-0x4(%ebp)
80104ffc:	81 7d fc 74 5a 11 80 	cmpl   $0x80115a74,-0x4(%ebp)
80105003:	72 d3                	jb     80104fd8 <wakeup1+0x13>
}
80105005:	90                   	nop
80105006:	90                   	nop
80105007:	c9                   	leave  
80105008:	c3                   	ret    

80105009 <wakeup>:

// Wake up all processes sleeping on chan.
void wakeup(void *chan) {
80105009:	f3 0f 1e fb          	endbr32 
8010500d:	55                   	push   %ebp
8010500e:	89 e5                	mov    %esp,%ebp
80105010:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80105013:	83 ec 0c             	sub    $0xc,%esp
80105016:	68 40 3a 11 80       	push   $0x80113a40
8010501b:	e8 08 02 00 00       	call   80105228 <acquire>
80105020:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80105023:	83 ec 0c             	sub    $0xc,%esp
80105026:	ff 75 08             	pushl  0x8(%ebp)
80105029:	e8 97 ff ff ff       	call   80104fc5 <wakeup1>
8010502e:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80105031:	83 ec 0c             	sub    $0xc,%esp
80105034:	68 40 3a 11 80       	push   $0x80113a40
80105039:	e8 55 02 00 00       	call   80105293 <release>
8010503e:	83 c4 10             	add    $0x10,%esp
}
80105041:	90                   	nop
80105042:	c9                   	leave  
80105043:	c3                   	ret    

80105044 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid) {
80105044:	f3 0f 1e fb          	endbr32 
80105048:	55                   	push   %ebp
80105049:	89 e5                	mov    %esp,%ebp
8010504b:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
8010504e:	83 ec 0c             	sub    $0xc,%esp
80105051:	68 40 3a 11 80       	push   $0x80113a40
80105056:	e8 cd 01 00 00       	call   80105228 <acquire>
8010505b:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010505e:	c7 45 f4 74 3a 11 80 	movl   $0x80113a74,-0xc(%ebp)
80105065:	eb 45                	jmp    801050ac <kill+0x68>
    if (p->pid == pid) {
80105067:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010506a:	8b 40 10             	mov    0x10(%eax),%eax
8010506d:	39 45 08             	cmp    %eax,0x8(%ebp)
80105070:	75 36                	jne    801050a8 <kill+0x64>
      p->killed = 1;
80105072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105075:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if (p->state == SLEEPING)
8010507c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010507f:	8b 40 0c             	mov    0xc(%eax),%eax
80105082:	83 f8 02             	cmp    $0x2,%eax
80105085:	75 0a                	jne    80105091 <kill+0x4d>
        p->state = RUNNABLE;
80105087:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010508a:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80105091:	83 ec 0c             	sub    $0xc,%esp
80105094:	68 40 3a 11 80       	push   $0x80113a40
80105099:	e8 f5 01 00 00       	call   80105293 <release>
8010509e:	83 c4 10             	add    $0x10,%esp
      return 0;
801050a1:	b8 00 00 00 00       	mov    $0x0,%eax
801050a6:	eb 22                	jmp    801050ca <kill+0x86>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801050a8:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
801050ac:	81 7d f4 74 5a 11 80 	cmpl   $0x80115a74,-0xc(%ebp)
801050b3:	72 b2                	jb     80105067 <kill+0x23>
    }
  }
  release(&ptable.lock);
801050b5:	83 ec 0c             	sub    $0xc,%esp
801050b8:	68 40 3a 11 80       	push   $0x80113a40
801050bd:	e8 d1 01 00 00       	call   80105293 <release>
801050c2:	83 c4 10             	add    $0x10,%esp
  return -1;
801050c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050ca:	c9                   	leave  
801050cb:	c3                   	ret    

801050cc <procdump>:

// PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void) {
801050cc:	f3 0f 1e fb          	endbr32 
801050d0:	55                   	push   %ebp
801050d1:	89 e5                	mov    %esp,%ebp
801050d3:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801050d6:	c7 45 f0 74 3a 11 80 	movl   $0x80113a74,-0x10(%ebp)
801050dd:	e9 d7 00 00 00       	jmp    801051b9 <procdump+0xed>
    if (p->state == UNUSED)
801050e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050e5:	8b 40 0c             	mov    0xc(%eax),%eax
801050e8:	85 c0                	test   %eax,%eax
801050ea:	0f 84 c4 00 00 00    	je     801051b4 <procdump+0xe8>
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
801050f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050f3:	8b 40 0c             	mov    0xc(%eax),%eax
801050f6:	83 f8 05             	cmp    $0x5,%eax
801050f9:	77 23                	ja     8010511e <procdump+0x52>
801050fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050fe:	8b 40 0c             	mov    0xc(%eax),%eax
80105101:	8b 04 85 0c d0 10 80 	mov    -0x7fef2ff4(,%eax,4),%eax
80105108:	85 c0                	test   %eax,%eax
8010510a:	74 12                	je     8010511e <procdump+0x52>
      state = states[p->state];
8010510c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010510f:	8b 40 0c             	mov    0xc(%eax),%eax
80105112:	8b 04 85 0c d0 10 80 	mov    -0x7fef2ff4(,%eax,4),%eax
80105119:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010511c:	eb 07                	jmp    80105125 <procdump+0x59>
    else
      state = "???";
8010511e:	c7 45 ec d4 a1 10 80 	movl   $0x8010a1d4,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80105125:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105128:	8d 50 6c             	lea    0x6c(%eax),%edx
8010512b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010512e:	8b 40 10             	mov    0x10(%eax),%eax
80105131:	52                   	push   %edx
80105132:	ff 75 ec             	pushl  -0x14(%ebp)
80105135:	50                   	push   %eax
80105136:	68 d8 a1 10 80       	push   $0x8010a1d8
8010513b:	e8 6a b2 ff ff       	call   801003aa <cprintf>
80105140:	83 c4 10             	add    $0x10,%esp
    if (p->state == SLEEPING) {
80105143:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105146:	8b 40 0c             	mov    0xc(%eax),%eax
80105149:	83 f8 02             	cmp    $0x2,%eax
8010514c:	75 54                	jne    801051a2 <procdump+0xd6>
      getcallerpcs((uint *)p->context->ebp + 2, pc);
8010514e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105151:	8b 40 1c             	mov    0x1c(%eax),%eax
80105154:	8b 40 0c             	mov    0xc(%eax),%eax
80105157:	83 c0 08             	add    $0x8,%eax
8010515a:	89 c2                	mov    %eax,%edx
8010515c:	83 ec 08             	sub    $0x8,%esp
8010515f:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105162:	50                   	push   %eax
80105163:	52                   	push   %edx
80105164:	e8 80 01 00 00       	call   801052e9 <getcallerpcs>
80105169:	83 c4 10             	add    $0x10,%esp
      for (i = 0; i < 10 && pc[i] != 0; i++)
8010516c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105173:	eb 1c                	jmp    80105191 <procdump+0xc5>
        cprintf(" %p", pc[i]);
80105175:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105178:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
8010517c:	83 ec 08             	sub    $0x8,%esp
8010517f:	50                   	push   %eax
80105180:	68 e1 a1 10 80       	push   $0x8010a1e1
80105185:	e8 20 b2 ff ff       	call   801003aa <cprintf>
8010518a:	83 c4 10             	add    $0x10,%esp
      for (i = 0; i < 10 && pc[i] != 0; i++)
8010518d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105191:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80105195:	7f 0b                	jg     801051a2 <procdump+0xd6>
80105197:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010519a:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
8010519e:	85 c0                	test   %eax,%eax
801051a0:	75 d3                	jne    80105175 <procdump+0xa9>
    }
    cprintf("\n");
801051a2:	83 ec 0c             	sub    $0xc,%esp
801051a5:	68 e5 a1 10 80       	push   $0x8010a1e5
801051aa:	e8 fb b1 ff ff       	call   801003aa <cprintf>
801051af:	83 c4 10             	add    $0x10,%esp
801051b2:	eb 01                	jmp    801051b5 <procdump+0xe9>
      continue;
801051b4:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801051b5:	83 6d f0 80          	subl   $0xffffff80,-0x10(%ebp)
801051b9:	81 7d f0 74 5a 11 80 	cmpl   $0x80115a74,-0x10(%ebp)
801051c0:	0f 82 1c ff ff ff    	jb     801050e2 <procdump+0x16>
  }
}
801051c6:	90                   	nop
801051c7:	90                   	nop
801051c8:	c9                   	leave  
801051c9:	c3                   	ret    

801051ca <readeflags>:
{
801051ca:	55                   	push   %ebp
801051cb:	89 e5                	mov    %esp,%ebp
801051cd:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801051d0:	9c                   	pushf  
801051d1:	58                   	pop    %eax
801051d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801051d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801051d8:	c9                   	leave  
801051d9:	c3                   	ret    

801051da <cli>:
{
801051da:	55                   	push   %ebp
801051db:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801051dd:	fa                   	cli    
}
801051de:	90                   	nop
801051df:	5d                   	pop    %ebp
801051e0:	c3                   	ret    

801051e1 <sti>:
{
801051e1:	55                   	push   %ebp
801051e2:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801051e4:	fb                   	sti    
}
801051e5:	90                   	nop
801051e6:	5d                   	pop    %ebp
801051e7:	c3                   	ret    

801051e8 <xchg>:
{
801051e8:	55                   	push   %ebp
801051e9:	89 e5                	mov    %esp,%ebp
801051eb:	83 ec 10             	sub    $0x10,%esp
  asm volatile("lock; xchgl %0, %1" :
801051ee:	8b 55 08             	mov    0x8(%ebp),%edx
801051f1:	8b 45 0c             	mov    0xc(%ebp),%eax
801051f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
801051f7:	f0 87 02             	lock xchg %eax,(%edx)
801051fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return result;
801051fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105200:	c9                   	leave  
80105201:	c3                   	ret    

80105202 <initlock>:
#include "kernel/memlayout.h"
#include "kernel/mmu.h"
#include "kernel/proc.h"
#include "kernel/spinlock.h"

void initlock(struct spinlock *lk, char *name) {
80105202:	f3 0f 1e fb          	endbr32 
80105206:	55                   	push   %ebp
80105207:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80105209:	8b 45 08             	mov    0x8(%ebp),%eax
8010520c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010520f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80105212:	8b 45 08             	mov    0x8(%ebp),%eax
80105215:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
8010521b:	8b 45 08             	mov    0x8(%ebp),%eax
8010521e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105225:	90                   	nop
80105226:	5d                   	pop    %ebp
80105227:	c3                   	ret    

80105228 <acquire>:

// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire(struct spinlock *lk) {
80105228:	f3 0f 1e fb          	endbr32 
8010522c:	55                   	push   %ebp
8010522d:	89 e5                	mov    %esp,%ebp
8010522f:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105232:	e8 5f 01 00 00       	call   80105396 <pushcli>
  if (holding(lk))
80105237:	8b 45 08             	mov    0x8(%ebp),%eax
8010523a:	83 ec 0c             	sub    $0xc,%esp
8010523d:	50                   	push   %eax
8010523e:	e8 25 01 00 00       	call   80105368 <holding>
80105243:	83 c4 10             	add    $0x10,%esp
80105246:	85 c0                	test   %eax,%eax
80105248:	74 0d                	je     80105257 <acquire+0x2f>
    panic("acquire");
8010524a:	83 ec 0c             	sub    $0xc,%esp
8010524d:	68 11 a2 10 80       	push   $0x8010a211
80105252:	e8 0c b3 ff ff       	call   80100563 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it.
  while (xchg(&lk->locked, 1) != 0)
80105257:	90                   	nop
80105258:	8b 45 08             	mov    0x8(%ebp),%eax
8010525b:	83 ec 08             	sub    $0x8,%esp
8010525e:	6a 01                	push   $0x1
80105260:	50                   	push   %eax
80105261:	e8 82 ff ff ff       	call   801051e8 <xchg>
80105266:	83 c4 10             	add    $0x10,%esp
80105269:	85 c0                	test   %eax,%eax
8010526b:	75 eb                	jne    80105258 <acquire+0x30>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
8010526d:	8b 45 08             	mov    0x8(%ebp),%eax
80105270:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105277:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
8010527a:	8b 45 08             	mov    0x8(%ebp),%eax
8010527d:	83 c0 0c             	add    $0xc,%eax
80105280:	83 ec 08             	sub    $0x8,%esp
80105283:	50                   	push   %eax
80105284:	8d 45 08             	lea    0x8(%ebp),%eax
80105287:	50                   	push   %eax
80105288:	e8 5c 00 00 00       	call   801052e9 <getcallerpcs>
8010528d:	83 c4 10             	add    $0x10,%esp
}
80105290:	90                   	nop
80105291:	c9                   	leave  
80105292:	c3                   	ret    

80105293 <release>:

// Release the lock.
void release(struct spinlock *lk) {
80105293:	f3 0f 1e fb          	endbr32 
80105297:	55                   	push   %ebp
80105298:	89 e5                	mov    %esp,%ebp
8010529a:	83 ec 08             	sub    $0x8,%esp
  if (!holding(lk))
8010529d:	83 ec 0c             	sub    $0xc,%esp
801052a0:	ff 75 08             	pushl  0x8(%ebp)
801052a3:	e8 c0 00 00 00       	call   80105368 <holding>
801052a8:	83 c4 10             	add    $0x10,%esp
801052ab:	85 c0                	test   %eax,%eax
801052ad:	75 0d                	jne    801052bc <release+0x29>
    panic("release");
801052af:	83 ec 0c             	sub    $0xc,%esp
801052b2:	68 19 a2 10 80       	push   $0x8010a219
801052b7:	e8 a7 b2 ff ff       	call   80100563 <panic>

  lk->pcs[0] = 0;
801052bc:	8b 45 08             	mov    0x8(%ebp),%eax
801052bf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801052c6:	8b 45 08             	mov    0x8(%ebp),%eax
801052c9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
801052d0:	8b 45 08             	mov    0x8(%ebp),%eax
801052d3:	83 ec 08             	sub    $0x8,%esp
801052d6:	6a 00                	push   $0x0
801052d8:	50                   	push   %eax
801052d9:	e8 0a ff ff ff       	call   801051e8 <xchg>
801052de:	83 c4 10             	add    $0x10,%esp

  popcli();
801052e1:	e8 f9 00 00 00       	call   801053df <popcli>
}
801052e6:	90                   	nop
801052e7:	c9                   	leave  
801052e8:	c3                   	ret    

801052e9 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void getcallerpcs(void *v, uint pcs[]) {
801052e9:	f3 0f 1e fb          	endbr32 
801052ed:	55                   	push   %ebp
801052ee:	89 e5                	mov    %esp,%ebp
801052f0:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint *)v - 2;
801052f3:	8b 45 08             	mov    0x8(%ebp),%eax
801052f6:	83 e8 08             	sub    $0x8,%eax
801052f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for (i = 0; i < 10; i++) {
801052fc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105303:	eb 38                	jmp    8010533d <getcallerpcs+0x54>
    if (ebp == 0 || ebp < (uint *)KERNBASE || ebp == (uint *)0xffffffff)
80105305:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105309:	74 53                	je     8010535e <getcallerpcs+0x75>
8010530b:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105312:	76 4a                	jbe    8010535e <getcallerpcs+0x75>
80105314:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105318:	74 44                	je     8010535e <getcallerpcs+0x75>
      break;
    pcs[i] = ebp[1];      // saved %eip
8010531a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010531d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105324:	8b 45 0c             	mov    0xc(%ebp),%eax
80105327:	01 c2                	add    %eax,%edx
80105329:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010532c:	8b 40 04             	mov    0x4(%eax),%eax
8010532f:	89 02                	mov    %eax,(%edx)
    ebp = (uint *)ebp[0]; // saved %ebp
80105331:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105334:	8b 00                	mov    (%eax),%eax
80105336:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for (i = 0; i < 10; i++) {
80105339:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010533d:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105341:	7e c2                	jle    80105305 <getcallerpcs+0x1c>
  }
  for (; i < 10; i++)
80105343:	eb 19                	jmp    8010535e <getcallerpcs+0x75>
    pcs[i] = 0;
80105345:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105348:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010534f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105352:	01 d0                	add    %edx,%eax
80105354:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for (; i < 10; i++)
8010535a:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010535e:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105362:	7e e1                	jle    80105345 <getcallerpcs+0x5c>
}
80105364:	90                   	nop
80105365:	90                   	nop
80105366:	c9                   	leave  
80105367:	c3                   	ret    

80105368 <holding>:

// Check whether this cpu is holding the lock.
int holding(struct spinlock *lock) { return lock->locked && lock->cpu == cpu; }
80105368:	f3 0f 1e fb          	endbr32 
8010536c:	55                   	push   %ebp
8010536d:	89 e5                	mov    %esp,%ebp
8010536f:	8b 45 08             	mov    0x8(%ebp),%eax
80105372:	8b 00                	mov    (%eax),%eax
80105374:	85 c0                	test   %eax,%eax
80105376:	74 17                	je     8010538f <holding+0x27>
80105378:	8b 45 08             	mov    0x8(%ebp),%eax
8010537b:	8b 50 08             	mov    0x8(%eax),%edx
8010537e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105384:	39 c2                	cmp    %eax,%edx
80105386:	75 07                	jne    8010538f <holding+0x27>
80105388:	b8 01 00 00 00       	mov    $0x1,%eax
8010538d:	eb 05                	jmp    80105394 <holding+0x2c>
8010538f:	b8 00 00 00 00       	mov    $0x0,%eax
80105394:	5d                   	pop    %ebp
80105395:	c3                   	ret    

80105396 <pushcli>:

// Pushcli/popcli are like cli/sti except that they are matched:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void pushcli(void) {
80105396:	f3 0f 1e fb          	endbr32 
8010539a:	55                   	push   %ebp
8010539b:	89 e5                	mov    %esp,%ebp
8010539d:	83 ec 10             	sub    $0x10,%esp
  int eflags;

  eflags = readeflags();
801053a0:	e8 25 fe ff ff       	call   801051ca <readeflags>
801053a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
801053a8:	e8 2d fe ff ff       	call   801051da <cli>
  if (cpu->ncli++ == 0)
801053ad:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801053b4:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
801053ba:	8d 48 01             	lea    0x1(%eax),%ecx
801053bd:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
801053c3:	85 c0                	test   %eax,%eax
801053c5:	75 15                	jne    801053dc <pushcli+0x46>
    cpu->intena = eflags & FL_IF;
801053c7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801053cd:	8b 55 fc             	mov    -0x4(%ebp),%edx
801053d0:	81 e2 00 02 00 00    	and    $0x200,%edx
801053d6:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801053dc:	90                   	nop
801053dd:	c9                   	leave  
801053de:	c3                   	ret    

801053df <popcli>:

void popcli(void) {
801053df:	f3 0f 1e fb          	endbr32 
801053e3:	55                   	push   %ebp
801053e4:	89 e5                	mov    %esp,%ebp
801053e6:	83 ec 08             	sub    $0x8,%esp
  if (readeflags() & FL_IF)
801053e9:	e8 dc fd ff ff       	call   801051ca <readeflags>
801053ee:	25 00 02 00 00       	and    $0x200,%eax
801053f3:	85 c0                	test   %eax,%eax
801053f5:	74 0d                	je     80105404 <popcli+0x25>
    panic("popcli - interruptible");
801053f7:	83 ec 0c             	sub    $0xc,%esp
801053fa:	68 21 a2 10 80       	push   $0x8010a221
801053ff:	e8 5f b1 ff ff       	call   80100563 <panic>
  if (--cpu->ncli < 0)
80105404:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010540a:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105410:	83 ea 01             	sub    $0x1,%edx
80105413:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80105419:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010541f:	85 c0                	test   %eax,%eax
80105421:	79 0d                	jns    80105430 <popcli+0x51>
    panic("popcli");
80105423:	83 ec 0c             	sub    $0xc,%esp
80105426:	68 38 a2 10 80       	push   $0x8010a238
8010542b:	e8 33 b1 ff ff       	call   80100563 <panic>
  if (cpu->ncli == 0 && cpu->intena)
80105430:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105436:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010543c:	85 c0                	test   %eax,%eax
8010543e:	75 15                	jne    80105455 <popcli+0x76>
80105440:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105446:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010544c:	85 c0                	test   %eax,%eax
8010544e:	74 05                	je     80105455 <popcli+0x76>
    sti();
80105450:	e8 8c fd ff ff       	call   801051e1 <sti>
}
80105455:	90                   	nop
80105456:	c9                   	leave  
80105457:	c3                   	ret    

80105458 <stosb>:
{
80105458:	55                   	push   %ebp
80105459:	89 e5                	mov    %esp,%ebp
8010545b:	57                   	push   %edi
8010545c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
8010545d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105460:	8b 55 10             	mov    0x10(%ebp),%edx
80105463:	8b 45 0c             	mov    0xc(%ebp),%eax
80105466:	89 cb                	mov    %ecx,%ebx
80105468:	89 df                	mov    %ebx,%edi
8010546a:	89 d1                	mov    %edx,%ecx
8010546c:	fc                   	cld    
8010546d:	f3 aa                	rep stos %al,%es:(%edi)
8010546f:	89 ca                	mov    %ecx,%edx
80105471:	89 fb                	mov    %edi,%ebx
80105473:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105476:	89 55 10             	mov    %edx,0x10(%ebp)
}
80105479:	90                   	nop
8010547a:	5b                   	pop    %ebx
8010547b:	5f                   	pop    %edi
8010547c:	5d                   	pop    %ebp
8010547d:	c3                   	ret    

8010547e <stosl>:
{
8010547e:	55                   	push   %ebp
8010547f:	89 e5                	mov    %esp,%ebp
80105481:	57                   	push   %edi
80105482:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105483:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105486:	8b 55 10             	mov    0x10(%ebp),%edx
80105489:	8b 45 0c             	mov    0xc(%ebp),%eax
8010548c:	89 cb                	mov    %ecx,%ebx
8010548e:	89 df                	mov    %ebx,%edi
80105490:	89 d1                	mov    %edx,%ecx
80105492:	fc                   	cld    
80105493:	f3 ab                	rep stos %eax,%es:(%edi)
80105495:	89 ca                	mov    %ecx,%edx
80105497:	89 fb                	mov    %edi,%ebx
80105499:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010549c:	89 55 10             	mov    %edx,0x10(%ebp)
}
8010549f:	90                   	nop
801054a0:	5b                   	pop    %ebx
801054a1:	5f                   	pop    %edi
801054a2:	5d                   	pop    %ebp
801054a3:	c3                   	ret    

801054a4 <memset>:
#include "kernel/types.h"
#include "kernel/x86.h"

void *memset(void *dst, int c, uint n) {
801054a4:	f3 0f 1e fb          	endbr32 
801054a8:	55                   	push   %ebp
801054a9:	89 e5                	mov    %esp,%ebp
  if ((int)dst % 4 == 0 && n % 4 == 0) {
801054ab:	8b 45 08             	mov    0x8(%ebp),%eax
801054ae:	83 e0 03             	and    $0x3,%eax
801054b1:	85 c0                	test   %eax,%eax
801054b3:	75 43                	jne    801054f8 <memset+0x54>
801054b5:	8b 45 10             	mov    0x10(%ebp),%eax
801054b8:	83 e0 03             	and    $0x3,%eax
801054bb:	85 c0                	test   %eax,%eax
801054bd:	75 39                	jne    801054f8 <memset+0x54>
    c &= 0xFF;
801054bf:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c << 24) | (c << 16) | (c << 8) | c, n / 4);
801054c6:	8b 45 10             	mov    0x10(%ebp),%eax
801054c9:	c1 e8 02             	shr    $0x2,%eax
801054cc:	89 c1                	mov    %eax,%ecx
801054ce:	8b 45 0c             	mov    0xc(%ebp),%eax
801054d1:	c1 e0 18             	shl    $0x18,%eax
801054d4:	89 c2                	mov    %eax,%edx
801054d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801054d9:	c1 e0 10             	shl    $0x10,%eax
801054dc:	09 c2                	or     %eax,%edx
801054de:	8b 45 0c             	mov    0xc(%ebp),%eax
801054e1:	c1 e0 08             	shl    $0x8,%eax
801054e4:	09 d0                	or     %edx,%eax
801054e6:	0b 45 0c             	or     0xc(%ebp),%eax
801054e9:	51                   	push   %ecx
801054ea:	50                   	push   %eax
801054eb:	ff 75 08             	pushl  0x8(%ebp)
801054ee:	e8 8b ff ff ff       	call   8010547e <stosl>
801054f3:	83 c4 0c             	add    $0xc,%esp
801054f6:	eb 12                	jmp    8010550a <memset+0x66>
  } else
    stosb(dst, c, n);
801054f8:	8b 45 10             	mov    0x10(%ebp),%eax
801054fb:	50                   	push   %eax
801054fc:	ff 75 0c             	pushl  0xc(%ebp)
801054ff:	ff 75 08             	pushl  0x8(%ebp)
80105502:	e8 51 ff ff ff       	call   80105458 <stosb>
80105507:	83 c4 0c             	add    $0xc,%esp
  return dst;
8010550a:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010550d:	c9                   	leave  
8010550e:	c3                   	ret    

8010550f <memcmp>:

int memcmp(const void *v1, const void *v2, uint n) {
8010550f:	f3 0f 1e fb          	endbr32 
80105513:	55                   	push   %ebp
80105514:	89 e5                	mov    %esp,%ebp
80105516:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;

  s1 = v1;
80105519:	8b 45 08             	mov    0x8(%ebp),%eax
8010551c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
8010551f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105522:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while (n-- > 0) {
80105525:	eb 30                	jmp    80105557 <memcmp+0x48>
    if (*s1 != *s2)
80105527:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010552a:	0f b6 10             	movzbl (%eax),%edx
8010552d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105530:	0f b6 00             	movzbl (%eax),%eax
80105533:	38 c2                	cmp    %al,%dl
80105535:	74 18                	je     8010554f <memcmp+0x40>
      return *s1 - *s2;
80105537:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010553a:	0f b6 00             	movzbl (%eax),%eax
8010553d:	0f b6 d0             	movzbl %al,%edx
80105540:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105543:	0f b6 00             	movzbl (%eax),%eax
80105546:	0f b6 c0             	movzbl %al,%eax
80105549:	29 c2                	sub    %eax,%edx
8010554b:	89 d0                	mov    %edx,%eax
8010554d:	eb 1a                	jmp    80105569 <memcmp+0x5a>
    s1++, s2++;
8010554f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105553:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  while (n-- > 0) {
80105557:	8b 45 10             	mov    0x10(%ebp),%eax
8010555a:	8d 50 ff             	lea    -0x1(%eax),%edx
8010555d:	89 55 10             	mov    %edx,0x10(%ebp)
80105560:	85 c0                	test   %eax,%eax
80105562:	75 c3                	jne    80105527 <memcmp+0x18>
  }

  return 0;
80105564:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105569:	c9                   	leave  
8010556a:	c3                   	ret    

8010556b <memmove>:

void *memmove(void *dst, const void *src, uint n) {
8010556b:	f3 0f 1e fb          	endbr32 
8010556f:	55                   	push   %ebp
80105570:	89 e5                	mov    %esp,%ebp
80105572:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105575:	8b 45 0c             	mov    0xc(%ebp),%eax
80105578:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
8010557b:	8b 45 08             	mov    0x8(%ebp),%eax
8010557e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (s < d && s + n > d) {
80105581:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105584:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105587:	73 54                	jae    801055dd <memmove+0x72>
80105589:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010558c:	8b 45 10             	mov    0x10(%ebp),%eax
8010558f:	01 d0                	add    %edx,%eax
80105591:	39 45 f8             	cmp    %eax,-0x8(%ebp)
80105594:	73 47                	jae    801055dd <memmove+0x72>
    s += n;
80105596:	8b 45 10             	mov    0x10(%ebp),%eax
80105599:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
8010559c:	8b 45 10             	mov    0x10(%ebp),%eax
8010559f:	01 45 f8             	add    %eax,-0x8(%ebp)
    while (n-- > 0)
801055a2:	eb 13                	jmp    801055b7 <memmove+0x4c>
      *--d = *--s;
801055a4:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
801055a8:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
801055ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055af:	0f b6 10             	movzbl (%eax),%edx
801055b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
801055b5:	88 10                	mov    %dl,(%eax)
    while (n-- > 0)
801055b7:	8b 45 10             	mov    0x10(%ebp),%eax
801055ba:	8d 50 ff             	lea    -0x1(%eax),%edx
801055bd:	89 55 10             	mov    %edx,0x10(%ebp)
801055c0:	85 c0                	test   %eax,%eax
801055c2:	75 e0                	jne    801055a4 <memmove+0x39>
  if (s < d && s + n > d) {
801055c4:	eb 24                	jmp    801055ea <memmove+0x7f>
  } else
    while (n-- > 0)
      *d++ = *s++;
801055c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
801055c9:	8d 42 01             	lea    0x1(%edx),%eax
801055cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
801055cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
801055d2:	8d 48 01             	lea    0x1(%eax),%ecx
801055d5:	89 4d f8             	mov    %ecx,-0x8(%ebp)
801055d8:	0f b6 12             	movzbl (%edx),%edx
801055db:	88 10                	mov    %dl,(%eax)
    while (n-- > 0)
801055dd:	8b 45 10             	mov    0x10(%ebp),%eax
801055e0:	8d 50 ff             	lea    -0x1(%eax),%edx
801055e3:	89 55 10             	mov    %edx,0x10(%ebp)
801055e6:	85 c0                	test   %eax,%eax
801055e8:	75 dc                	jne    801055c6 <memmove+0x5b>

  return dst;
801055ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
801055ed:	c9                   	leave  
801055ee:	c3                   	ret    

801055ef <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *memcpy(void *dst, const void *src, uint n) {
801055ef:	f3 0f 1e fb          	endbr32 
801055f3:	55                   	push   %ebp
801055f4:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
801055f6:	ff 75 10             	pushl  0x10(%ebp)
801055f9:	ff 75 0c             	pushl  0xc(%ebp)
801055fc:	ff 75 08             	pushl  0x8(%ebp)
801055ff:	e8 67 ff ff ff       	call   8010556b <memmove>
80105604:	83 c4 0c             	add    $0xc,%esp
}
80105607:	c9                   	leave  
80105608:	c3                   	ret    

80105609 <strncmp>:

int strncmp(const char *p, const char *q, uint n) {
80105609:	f3 0f 1e fb          	endbr32 
8010560d:	55                   	push   %ebp
8010560e:	89 e5                	mov    %esp,%ebp
  while (n > 0 && *p && *p == *q)
80105610:	eb 0c                	jmp    8010561e <strncmp+0x15>
    n--, p++, q++;
80105612:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105616:	83 45 08 01          	addl   $0x1,0x8(%ebp)
8010561a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while (n > 0 && *p && *p == *q)
8010561e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105622:	74 1a                	je     8010563e <strncmp+0x35>
80105624:	8b 45 08             	mov    0x8(%ebp),%eax
80105627:	0f b6 00             	movzbl (%eax),%eax
8010562a:	84 c0                	test   %al,%al
8010562c:	74 10                	je     8010563e <strncmp+0x35>
8010562e:	8b 45 08             	mov    0x8(%ebp),%eax
80105631:	0f b6 10             	movzbl (%eax),%edx
80105634:	8b 45 0c             	mov    0xc(%ebp),%eax
80105637:	0f b6 00             	movzbl (%eax),%eax
8010563a:	38 c2                	cmp    %al,%dl
8010563c:	74 d4                	je     80105612 <strncmp+0x9>
  if (n == 0)
8010563e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105642:	75 07                	jne    8010564b <strncmp+0x42>
    return 0;
80105644:	b8 00 00 00 00       	mov    $0x0,%eax
80105649:	eb 16                	jmp    80105661 <strncmp+0x58>
  return (uchar)*p - (uchar)*q;
8010564b:	8b 45 08             	mov    0x8(%ebp),%eax
8010564e:	0f b6 00             	movzbl (%eax),%eax
80105651:	0f b6 d0             	movzbl %al,%edx
80105654:	8b 45 0c             	mov    0xc(%ebp),%eax
80105657:	0f b6 00             	movzbl (%eax),%eax
8010565a:	0f b6 c0             	movzbl %al,%eax
8010565d:	29 c2                	sub    %eax,%edx
8010565f:	89 d0                	mov    %edx,%eax
}
80105661:	5d                   	pop    %ebp
80105662:	c3                   	ret    

80105663 <strncpy>:

char *strncpy(char *s, const char *t, int n) {
80105663:	f3 0f 1e fb          	endbr32 
80105667:	55                   	push   %ebp
80105668:	89 e5                	mov    %esp,%ebp
8010566a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
8010566d:	8b 45 08             	mov    0x8(%ebp),%eax
80105670:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while (n-- > 0 && (*s++ = *t++) != 0)
80105673:	90                   	nop
80105674:	8b 45 10             	mov    0x10(%ebp),%eax
80105677:	8d 50 ff             	lea    -0x1(%eax),%edx
8010567a:	89 55 10             	mov    %edx,0x10(%ebp)
8010567d:	85 c0                	test   %eax,%eax
8010567f:	7e 2c                	jle    801056ad <strncpy+0x4a>
80105681:	8b 55 0c             	mov    0xc(%ebp),%edx
80105684:	8d 42 01             	lea    0x1(%edx),%eax
80105687:	89 45 0c             	mov    %eax,0xc(%ebp)
8010568a:	8b 45 08             	mov    0x8(%ebp),%eax
8010568d:	8d 48 01             	lea    0x1(%eax),%ecx
80105690:	89 4d 08             	mov    %ecx,0x8(%ebp)
80105693:	0f b6 12             	movzbl (%edx),%edx
80105696:	88 10                	mov    %dl,(%eax)
80105698:	0f b6 00             	movzbl (%eax),%eax
8010569b:	84 c0                	test   %al,%al
8010569d:	75 d5                	jne    80105674 <strncpy+0x11>
    ;
  while (n-- > 0)
8010569f:	eb 0c                	jmp    801056ad <strncpy+0x4a>
    *s++ = 0;
801056a1:	8b 45 08             	mov    0x8(%ebp),%eax
801056a4:	8d 50 01             	lea    0x1(%eax),%edx
801056a7:	89 55 08             	mov    %edx,0x8(%ebp)
801056aa:	c6 00 00             	movb   $0x0,(%eax)
  while (n-- > 0)
801056ad:	8b 45 10             	mov    0x10(%ebp),%eax
801056b0:	8d 50 ff             	lea    -0x1(%eax),%edx
801056b3:	89 55 10             	mov    %edx,0x10(%ebp)
801056b6:	85 c0                	test   %eax,%eax
801056b8:	7f e7                	jg     801056a1 <strncpy+0x3e>
  return os;
801056ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801056bd:	c9                   	leave  
801056be:	c3                   	ret    

801056bf <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *safestrcpy(char *s, const char *t, int n) {
801056bf:	f3 0f 1e fb          	endbr32 
801056c3:	55                   	push   %ebp
801056c4:	89 e5                	mov    %esp,%ebp
801056c6:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
801056c9:	8b 45 08             	mov    0x8(%ebp),%eax
801056cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if (n <= 0)
801056cf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801056d3:	7f 05                	jg     801056da <safestrcpy+0x1b>
    return os;
801056d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056d8:	eb 31                	jmp    8010570b <safestrcpy+0x4c>
  while (--n > 0 && (*s++ = *t++) != 0)
801056da:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801056de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801056e2:	7e 1e                	jle    80105702 <safestrcpy+0x43>
801056e4:	8b 55 0c             	mov    0xc(%ebp),%edx
801056e7:	8d 42 01             	lea    0x1(%edx),%eax
801056ea:	89 45 0c             	mov    %eax,0xc(%ebp)
801056ed:	8b 45 08             	mov    0x8(%ebp),%eax
801056f0:	8d 48 01             	lea    0x1(%eax),%ecx
801056f3:	89 4d 08             	mov    %ecx,0x8(%ebp)
801056f6:	0f b6 12             	movzbl (%edx),%edx
801056f9:	88 10                	mov    %dl,(%eax)
801056fb:	0f b6 00             	movzbl (%eax),%eax
801056fe:	84 c0                	test   %al,%al
80105700:	75 d8                	jne    801056da <safestrcpy+0x1b>
    ;
  *s = 0;
80105702:	8b 45 08             	mov    0x8(%ebp),%eax
80105705:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105708:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010570b:	c9                   	leave  
8010570c:	c3                   	ret    

8010570d <strlen>:

int strlen(const char *s) {
8010570d:	f3 0f 1e fb          	endbr32 
80105711:	55                   	push   %ebp
80105712:	89 e5                	mov    %esp,%ebp
80105714:	83 ec 10             	sub    $0x10,%esp
  int n;

  for (n = 0; s[n]; n++)
80105717:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010571e:	eb 04                	jmp    80105724 <strlen+0x17>
80105720:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105724:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105727:	8b 45 08             	mov    0x8(%ebp),%eax
8010572a:	01 d0                	add    %edx,%eax
8010572c:	0f b6 00             	movzbl (%eax),%eax
8010572f:	84 c0                	test   %al,%al
80105731:	75 ed                	jne    80105720 <strlen+0x13>
    ;
  return n;
80105733:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105736:	c9                   	leave  
80105737:	c3                   	ret    

80105738 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105738:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010573c:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105740:	55                   	push   %ebp
  pushl %ebx
80105741:	53                   	push   %ebx
  pushl %esi
80105742:	56                   	push   %esi
  pushl %edi
80105743:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105744:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105746:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105748:	5f                   	pop    %edi
  popl %esi
80105749:	5e                   	pop    %esi
  popl %ebx
8010574a:	5b                   	pop    %ebx
  popl %ebp
8010574b:	5d                   	pop    %ebp
  ret
8010574c:	c3                   	ret    

8010574d <fetchint>:
// Arguments on the stack, from the user call to the C
// library system call function. The saved user %esp points
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int fetchint(uint addr, int *ip) {
8010574d:	f3 0f 1e fb          	endbr32 
80105751:	55                   	push   %ebp
80105752:	89 e5                	mov    %esp,%ebp
  if (addr >= proc->sz || addr + 4 > proc->sz)
80105754:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010575a:	8b 00                	mov    (%eax),%eax
8010575c:	39 45 08             	cmp    %eax,0x8(%ebp)
8010575f:	73 12                	jae    80105773 <fetchint+0x26>
80105761:	8b 45 08             	mov    0x8(%ebp),%eax
80105764:	8d 50 04             	lea    0x4(%eax),%edx
80105767:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010576d:	8b 00                	mov    (%eax),%eax
8010576f:	39 c2                	cmp    %eax,%edx
80105771:	76 07                	jbe    8010577a <fetchint+0x2d>
    return -1;
80105773:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105778:	eb 0f                	jmp    80105789 <fetchint+0x3c>
  *ip = *(int *)(addr);
8010577a:	8b 45 08             	mov    0x8(%ebp),%eax
8010577d:	8b 10                	mov    (%eax),%edx
8010577f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105782:	89 10                	mov    %edx,(%eax)
  return 0;
80105784:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105789:	5d                   	pop    %ebp
8010578a:	c3                   	ret    

8010578b <fetchstr>:

// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int fetchstr(uint addr, char **pp) {
8010578b:	f3 0f 1e fb          	endbr32 
8010578f:	55                   	push   %ebp
80105790:	89 e5                	mov    %esp,%ebp
80105792:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if (addr >= proc->sz)
80105795:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010579b:	8b 00                	mov    (%eax),%eax
8010579d:	39 45 08             	cmp    %eax,0x8(%ebp)
801057a0:	72 07                	jb     801057a9 <fetchstr+0x1e>
    return -1;
801057a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057a7:	eb 46                	jmp    801057ef <fetchstr+0x64>
  *pp = (char *)addr;
801057a9:	8b 55 08             	mov    0x8(%ebp),%edx
801057ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801057af:	89 10                	mov    %edx,(%eax)
  ep = (char *)proc->sz;
801057b1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057b7:	8b 00                	mov    (%eax),%eax
801057b9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for (s = *pp; s < ep; s++)
801057bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801057bf:	8b 00                	mov    (%eax),%eax
801057c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
801057c4:	eb 1c                	jmp    801057e2 <fetchstr+0x57>
    if (*s == 0)
801057c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801057c9:	0f b6 00             	movzbl (%eax),%eax
801057cc:	84 c0                	test   %al,%al
801057ce:	75 0e                	jne    801057de <fetchstr+0x53>
      return s - *pp;
801057d0:	8b 45 0c             	mov    0xc(%ebp),%eax
801057d3:	8b 00                	mov    (%eax),%eax
801057d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
801057d8:	29 c2                	sub    %eax,%edx
801057da:	89 d0                	mov    %edx,%eax
801057dc:	eb 11                	jmp    801057ef <fetchstr+0x64>
  for (s = *pp; s < ep; s++)
801057de:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801057e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801057e5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801057e8:	72 dc                	jb     801057c6 <fetchstr+0x3b>
  return -1;
801057ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057ef:	c9                   	leave  
801057f0:	c3                   	ret    

801057f1 <argint>:

// Fetch the nth 32-bit system call argument.
int argint(int n, int *ip) { return fetchint(proc->tf->esp + 4 + 4 * n, ip); }
801057f1:	f3 0f 1e fb          	endbr32 
801057f5:	55                   	push   %ebp
801057f6:	89 e5                	mov    %esp,%ebp
801057f8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057fe:	8b 40 18             	mov    0x18(%eax),%eax
80105801:	8b 40 44             	mov    0x44(%eax),%eax
80105804:	8b 55 08             	mov    0x8(%ebp),%edx
80105807:	c1 e2 02             	shl    $0x2,%edx
8010580a:	01 d0                	add    %edx,%eax
8010580c:	83 c0 04             	add    $0x4,%eax
8010580f:	ff 75 0c             	pushl  0xc(%ebp)
80105812:	50                   	push   %eax
80105813:	e8 35 ff ff ff       	call   8010574d <fetchint>
80105818:	83 c4 08             	add    $0x8,%esp
8010581b:	c9                   	leave  
8010581c:	c3                   	ret    

8010581d <argptr>:

// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int argptr(int n, char **pp, int size) {
8010581d:	f3 0f 1e fb          	endbr32 
80105821:	55                   	push   %ebp
80105822:	89 e5                	mov    %esp,%ebp
80105824:	83 ec 10             	sub    $0x10,%esp
  int i;

  if (argint(n, &i) < 0)
80105827:	8d 45 fc             	lea    -0x4(%ebp),%eax
8010582a:	50                   	push   %eax
8010582b:	ff 75 08             	pushl  0x8(%ebp)
8010582e:	e8 be ff ff ff       	call   801057f1 <argint>
80105833:	83 c4 08             	add    $0x8,%esp
80105836:	85 c0                	test   %eax,%eax
80105838:	79 07                	jns    80105841 <argptr+0x24>
    return -1;
8010583a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010583f:	eb 3b                	jmp    8010587c <argptr+0x5f>
  if ((uint)i >= proc->sz || (uint)i + size > proc->sz)
80105841:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105847:	8b 00                	mov    (%eax),%eax
80105849:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010584c:	39 d0                	cmp    %edx,%eax
8010584e:	76 16                	jbe    80105866 <argptr+0x49>
80105850:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105853:	89 c2                	mov    %eax,%edx
80105855:	8b 45 10             	mov    0x10(%ebp),%eax
80105858:	01 c2                	add    %eax,%edx
8010585a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105860:	8b 00                	mov    (%eax),%eax
80105862:	39 c2                	cmp    %eax,%edx
80105864:	76 07                	jbe    8010586d <argptr+0x50>
    return -1;
80105866:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010586b:	eb 0f                	jmp    8010587c <argptr+0x5f>
  *pp = (char *)i;
8010586d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105870:	89 c2                	mov    %eax,%edx
80105872:	8b 45 0c             	mov    0xc(%ebp),%eax
80105875:	89 10                	mov    %edx,(%eax)
  return 0;
80105877:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010587c:	c9                   	leave  
8010587d:	c3                   	ret    

8010587e <argstr>:

// Fetch the nth word-sized system call argument as a string pointer.
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int argstr(int n, char **pp) {
8010587e:	f3 0f 1e fb          	endbr32 
80105882:	55                   	push   %ebp
80105883:	89 e5                	mov    %esp,%ebp
80105885:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if (argint(n, &addr) < 0)
80105888:	8d 45 fc             	lea    -0x4(%ebp),%eax
8010588b:	50                   	push   %eax
8010588c:	ff 75 08             	pushl  0x8(%ebp)
8010588f:	e8 5d ff ff ff       	call   801057f1 <argint>
80105894:	83 c4 08             	add    $0x8,%esp
80105897:	85 c0                	test   %eax,%eax
80105899:	79 07                	jns    801058a2 <argstr+0x24>
    return -1;
8010589b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058a0:	eb 0f                	jmp    801058b1 <argstr+0x33>
  return fetchstr(addr, pp);
801058a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058a5:	ff 75 0c             	pushl  0xc(%ebp)
801058a8:	50                   	push   %eax
801058a9:	e8 dd fe ff ff       	call   8010578b <fetchstr>
801058ae:	83 c4 08             	add    $0x8,%esp
}
801058b1:	c9                   	leave  
801058b2:	c3                   	ret    

801058b3 <sys_trace>:
    [SYS_close] "close",
    [SYS_trace] "trace",
    [SYS_dump] "dump",
};

int sys_trace(void) {
801058b3:	f3 0f 1e fb          	endbr32 
801058b7:	55                   	push   %ebp
801058b8:	89 e5                	mov    %esp,%ebp
801058ba:	83 ec 10             	sub    $0x10,%esp
    int n;
    argint(0, &n);
801058bd:	8d 45 fc             	lea    -0x4(%ebp),%eax
801058c0:	50                   	push   %eax
801058c1:	6a 00                	push   $0x0
801058c3:	e8 29 ff ff ff       	call   801057f1 <argint>
801058c8:	83 c4 08             	add    $0x8,%esp
    proc->traced = (n & T_TRACE) ? n:0;
801058cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058ce:	83 e0 01             	and    $0x1,%eax
801058d1:	85 c0                	test   %eax,%eax
801058d3:	74 05                	je     801058da <sys_trace+0x27>
801058d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058d8:	eb 05                	jmp    801058df <sys_trace+0x2c>
801058da:	b8 00 00 00 00       	mov    $0x0,%eax
801058df:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801058e6:	89 42 7c             	mov    %eax,0x7c(%edx)
    return 0;
801058e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801058ee:	c9                   	leave  
801058ef:	c3                   	ret    

801058f0 <strcompare>:

int strcompare(char str1[], char str2[]) {
801058f0:	f3 0f 1e fb          	endbr32 
801058f4:	55                   	push   %ebp
801058f5:	89 e5                	mov    %esp,%ebp
801058f7:	83 ec 10             	sub    $0x10,%esp
    int ctr = 0;
801058fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(str1[ctr] == str2[ctr]) {
80105901:	eb 22                	jmp    80105925 <strcompare+0x35>
        if(str1[ctr]=='\0'||str2[ctr]=='\0')
80105903:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105906:	8b 45 08             	mov    0x8(%ebp),%eax
80105909:	01 d0                	add    %edx,%eax
8010590b:	0f b6 00             	movzbl (%eax),%eax
8010590e:	84 c0                	test   %al,%al
80105910:	74 2d                	je     8010593f <strcompare+0x4f>
80105912:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105915:	8b 45 0c             	mov    0xc(%ebp),%eax
80105918:	01 d0                	add    %edx,%eax
8010591a:	0f b6 00             	movzbl (%eax),%eax
8010591d:	84 c0                	test   %al,%al
8010591f:	74 1e                	je     8010593f <strcompare+0x4f>
        break;
        ctr++;
80105921:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while(str1[ctr] == str2[ctr]) {
80105925:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105928:	8b 45 08             	mov    0x8(%ebp),%eax
8010592b:	01 d0                	add    %edx,%eax
8010592d:	0f b6 10             	movzbl (%eax),%edx
80105930:	8b 4d fc             	mov    -0x4(%ebp),%ecx
80105933:	8b 45 0c             	mov    0xc(%ebp),%eax
80105936:	01 c8                	add    %ecx,%eax
80105938:	0f b6 00             	movzbl (%eax),%eax
8010593b:	38 c2                	cmp    %al,%dl
8010593d:	74 c4                	je     80105903 <strcompare+0x13>
    }
    if(str1[ctr]=='\0' && str2[ctr]=='\0')
8010593f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105942:	8b 45 08             	mov    0x8(%ebp),%eax
80105945:	01 d0                	add    %edx,%eax
80105947:	0f b6 00             	movzbl (%eax),%eax
8010594a:	84 c0                	test   %al,%al
8010594c:	75 16                	jne    80105964 <strcompare+0x74>
8010594e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105951:	8b 45 0c             	mov    0xc(%ebp),%eax
80105954:	01 d0                	add    %edx,%eax
80105956:	0f b6 00             	movzbl (%eax),%eax
80105959:	84 c0                	test   %al,%al
8010595b:	75 07                	jne    80105964 <strcompare+0x74>
        return 0;
8010595d:	b8 00 00 00 00       	mov    $0x0,%eax
80105962:	eb 05                	jmp    80105969 <strcompare+0x79>
    else
        return -1;
80105964:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105969:	c9                   	leave  
8010596a:	c3                   	ret    

8010596b <sys_setEFlag>:

int sys_setEFlag(void) {
8010596b:	f3 0f 1e fb          	endbr32 
8010596f:	55                   	push   %ebp
80105970:	89 e5                	mov    %esp,%ebp
    argint(0, &e_flag);
80105972:	68 40 d0 10 80       	push   $0x8010d040
80105977:	6a 00                	push   $0x0
80105979:	e8 73 fe ff ff       	call   801057f1 <argint>
8010597e:	83 c4 08             	add    $0x8,%esp
    return 0;
80105981:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105986:	c9                   	leave  
80105987:	c3                   	ret    

80105988 <sys_setSFlag>:

int sys_setSFlag(void) {
80105988:	f3 0f 1e fb          	endbr32 
8010598c:	55                   	push   %ebp
8010598d:	89 e5                	mov    %esp,%ebp
    argint(0, &s_flag);
8010598f:	68 0c d7 10 80       	push   $0x8010d70c
80105994:	6a 00                	push   $0x0
80105996:	e8 56 fe ff ff       	call   801057f1 <argint>
8010599b:	83 c4 08             	add    $0x8,%esp
    return 0;
8010599e:	b8 00 00 00 00       	mov    $0x0,%eax
}
801059a3:	c9                   	leave  
801059a4:	c3                   	ret    

801059a5 <sys_setFFlag>:

int sys_setFFlag(void) {
801059a5:	f3 0f 1e fb          	endbr32 
801059a9:	55                   	push   %ebp
801059aa:	89 e5                	mov    %esp,%ebp
    argint(0, &f_flag);
801059ac:	68 10 d7 10 80       	push   $0x8010d710
801059b1:	6a 00                	push   $0x0
801059b3:	e8 39 fe ff ff       	call   801057f1 <argint>
801059b8:	83 c4 08             	add    $0x8,%esp
    return 0;
801059bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
801059c0:	c9                   	leave  
801059c1:	c3                   	ret    

801059c2 <addToBuff>:
int tailIndex=0;
int* tailptr = &tailIndex;
int passedZero =0;
int* passedZeroptr = &passedZero;

void addToBuff(char* event) {
801059c2:	f3 0f 1e fb          	endbr32 
801059c6:	55                   	push   %ebp
801059c7:	89 e5                	mov    %esp,%ebp
801059c9:	83 ec 18             	sub    $0x18,%esp
    int head = *headptr;
801059cc:	a1 4c d1 10 80       	mov    0x8010d14c,%eax
801059d1:	8b 00                	mov    (%eax),%eax
801059d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int tail = *tailptr;
801059d6:	a1 50 d1 10 80       	mov    0x8010d150,%eax
801059db:	8b 00                	mov    (%eax),%eax
801059dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int s=0;
801059e0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    int passedZeroFunc = *passedZeroptr;
801059e7:	a1 54 d1 10 80       	mov    0x8010d154,%eax
801059ec:	8b 00                	mov    (%eax),%eax
801059ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(head == tail && passedZero) {
801059f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801059f4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801059f7:	0f 85 92 00 00 00    	jne    80105a8f <addToBuff+0xcd>
801059fd:	a1 1c d7 10 80       	mov    0x8010d71c,%eax
80105a02:	85 c0                	test   %eax,%eax
80105a04:	0f 84 85 00 00 00    	je     80105a8f <addToBuff+0xcd>
         memset(dumpBuff[tail],0,strlen(dumpBuff[tail]));
80105a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a0d:	6b c0 64             	imul   $0x64,%eax,%eax
80105a10:	05 80 5a 11 80       	add    $0x80115a80,%eax
80105a15:	83 ec 0c             	sub    $0xc,%esp
80105a18:	50                   	push   %eax
80105a19:	e8 ef fc ff ff       	call   8010570d <strlen>
80105a1e:	83 c4 10             	add    $0x10,%esp
80105a21:	89 c2                	mov    %eax,%edx
80105a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a26:	6b c0 64             	imul   $0x64,%eax,%eax
80105a29:	05 80 5a 11 80       	add    $0x80115a80,%eax
80105a2e:	83 ec 04             	sub    $0x4,%esp
80105a31:	52                   	push   %edx
80105a32:	6a 00                	push   $0x0
80105a34:	50                   	push   %eax
80105a35:	e8 6a fa ff ff       	call   801054a4 <memset>
80105a3a:	83 c4 10             	add    $0x10,%esp
         tail = (tail+1)%N;
80105a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a40:	8d 48 01             	lea    0x1(%eax),%ecx
80105a43:	ba 67 66 66 66       	mov    $0x66666667,%edx
80105a48:	89 c8                	mov    %ecx,%eax
80105a4a:	f7 ea                	imul   %edx
80105a4c:	d1 fa                	sar    %edx
80105a4e:	89 c8                	mov    %ecx,%eax
80105a50:	c1 f8 1f             	sar    $0x1f,%eax
80105a53:	29 c2                	sub    %eax,%edx
80105a55:	89 d0                	mov    %edx,%eax
80105a57:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a5d:	89 d0                	mov    %edx,%eax
80105a5f:	c1 e0 02             	shl    $0x2,%eax
80105a62:	01 d0                	add    %edx,%eax
80105a64:	29 c1                	sub    %eax,%ecx
80105a66:	89 c8                	mov    %ecx,%eax
80105a68:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    while(event[s] != '\0') {
80105a6b:	eb 22                	jmp    80105a8f <addToBuff+0xcd>
          dumpBuff[head][s] = event[s];
80105a6d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105a70:	8b 45 08             	mov    0x8(%ebp),%eax
80105a73:	01 d0                	add    %edx,%eax
80105a75:	0f b6 00             	movzbl (%eax),%eax
80105a78:	8b 55 e8             	mov    -0x18(%ebp),%edx
80105a7b:	6b ca 64             	imul   $0x64,%edx,%ecx
80105a7e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105a81:	01 ca                	add    %ecx,%edx
80105a83:	81 c2 80 5a 11 80    	add    $0x80115a80,%edx
80105a89:	88 02                	mov    %al,(%edx)
          s+=1;
80105a8b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    while(event[s] != '\0') {
80105a8f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105a92:	8b 45 08             	mov    0x8(%ebp),%eax
80105a95:	01 d0                	add    %edx,%eax
80105a97:	0f b6 00             	movzbl (%eax),%eax
80105a9a:	84 c0                	test   %al,%al
80105a9c:	75 cf                	jne    80105a6d <addToBuff+0xab>
    }
    head= (head+1)%N;
80105a9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105aa1:	8d 48 01             	lea    0x1(%eax),%ecx
80105aa4:	ba 67 66 66 66       	mov    $0x66666667,%edx
80105aa9:	89 c8                	mov    %ecx,%eax
80105aab:	f7 ea                	imul   %edx
80105aad:	d1 fa                	sar    %edx
80105aaf:	89 c8                	mov    %ecx,%eax
80105ab1:	c1 f8 1f             	sar    $0x1f,%eax
80105ab4:	29 c2                	sub    %eax,%edx
80105ab6:	89 d0                	mov    %edx,%eax
80105ab8:	89 45 e8             	mov    %eax,-0x18(%ebp)
80105abb:	8b 55 e8             	mov    -0x18(%ebp),%edx
80105abe:	89 d0                	mov    %edx,%eax
80105ac0:	c1 e0 02             	shl    $0x2,%eax
80105ac3:	01 d0                	add    %edx,%eax
80105ac5:	29 c1                	sub    %eax,%ecx
80105ac7:	89 c8                	mov    %ecx,%eax
80105ac9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(head==0) {
80105acc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80105ad0:	75 07                	jne    80105ad9 <addToBuff+0x117>
        passedZeroFunc =1;
80105ad2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
    }
    *headptr = head;
80105ad9:	a1 4c d1 10 80       	mov    0x8010d14c,%eax
80105ade:	8b 55 e8             	mov    -0x18(%ebp),%edx
80105ae1:	89 10                	mov    %edx,(%eax)
    *tailptr = tail;
80105ae3:	a1 50 d1 10 80       	mov    0x8010d150,%eax
80105ae8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105aeb:	89 10                	mov    %edx,(%eax)
    *passedZeroptr = passedZeroFunc;
80105aed:	a1 54 d1 10 80       	mov    0x8010d154,%eax
80105af2:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105af5:	89 10                	mov    %edx,(%eax)
}
80105af7:	90                   	nop
80105af8:	c9                   	leave  
80105af9:	c3                   	ret    

80105afa <sys_dump>:

int sys_dump(void) {
80105afa:	f3 0f 1e fb          	endbr32 
80105afe:	55                   	push   %ebp
80105aff:	89 e5                	mov    %esp,%ebp
80105b01:	83 ec 18             	sub    $0x18,%esp
    for(int i=0; i<N && dumpBuff[i]!=0; i+=1) {
80105b04:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105b0b:	eb 20                	jmp    80105b2d <sys_dump+0x33>
        cprintf("%s\n", dumpBuff[i]);
80105b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b10:	6b c0 64             	imul   $0x64,%eax,%eax
80105b13:	05 80 5a 11 80       	add    $0x80115a80,%eax
80105b18:	83 ec 08             	sub    $0x8,%esp
80105b1b:	50                   	push   %eax
80105b1c:	68 c0 a2 10 80       	push   $0x8010a2c0
80105b21:	e8 84 a8 ff ff       	call   801003aa <cprintf>
80105b26:	83 c4 10             	add    $0x10,%esp
    for(int i=0; i<N && dumpBuff[i]!=0; i+=1) {
80105b29:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105b2d:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
80105b31:	7e da                	jle    80105b0d <sys_dump+0x13>
    }
    return 0;
80105b33:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b38:	c9                   	leave  
80105b39:	c3                   	ret    

80105b3a <syscall>:

void syscall(void) {
80105b3a:	f3 0f 1e fb          	endbr32 
80105b3e:	55                   	push   %ebp
80105b3f:	89 e5                	mov    %esp,%ebp
80105b41:	53                   	push   %ebx
80105b42:	81 ec b4 01 00 00    	sub    $0x1b4,%esp
    int num, i, num2;
    int is_traced = (proc->traced & T_TRACE);
80105b48:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b4e:	8b 40 7c             	mov    0x7c(%eax),%eax
80105b51:	83 e0 01             	and    $0x1,%eax
80105b54:	89 45 ac             	mov    %eax,-0x54(%ebp)
    int procNameSize = 0;
80105b57:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for(int j = 0; proc->name[j] != 0; j += 1) {
80105b5e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80105b65:	eb 08                	jmp    80105b6f <syscall+0x35>
        procNameSize += 1;
80105b67:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    for(int j = 0; proc->name[j] != 0; j += 1) {
80105b6b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80105b6f:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105b76:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b79:	01 d0                	add    %edx,%eax
80105b7b:	83 c0 6c             	add    $0x6c,%eax
80105b7e:	0f b6 00             	movzbl (%eax),%eax
80105b81:	84 c0                	test   %al,%al
80105b83:	75 e2                	jne    80105b67 <syscall+0x2d>
    }
    char procname[procNameSize];
80105b85:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105b88:	89 e2                	mov    %esp,%edx
80105b8a:	89 d3                	mov    %edx,%ebx
80105b8c:	8d 50 ff             	lea    -0x1(%eax),%edx
80105b8f:	89 55 a8             	mov    %edx,-0x58(%ebp)
80105b92:	89 c2                	mov    %eax,%edx
80105b94:	b8 10 00 00 00       	mov    $0x10,%eax
80105b99:	83 e8 01             	sub    $0x1,%eax
80105b9c:	01 d0                	add    %edx,%eax
80105b9e:	b9 10 00 00 00       	mov    $0x10,%ecx
80105ba3:	ba 00 00 00 00       	mov    $0x0,%edx
80105ba8:	f7 f1                	div    %ecx
80105baa:	6b c0 10             	imul   $0x10,%eax,%eax
80105bad:	89 c2                	mov    %eax,%edx
80105baf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80105bb5:	89 e1                	mov    %esp,%ecx
80105bb7:	29 d1                	sub    %edx,%ecx
80105bb9:	89 ca                	mov    %ecx,%edx
80105bbb:	39 d4                	cmp    %edx,%esp
80105bbd:	74 10                	je     80105bcf <syscall+0x95>
80105bbf:	81 ec 00 10 00 00    	sub    $0x1000,%esp
80105bc5:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
80105bcc:	00 
80105bcd:	eb ec                	jmp    80105bbb <syscall+0x81>
80105bcf:	89 c2                	mov    %eax,%edx
80105bd1:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
80105bd7:	29 d4                	sub    %edx,%esp
80105bd9:	89 c2                	mov    %eax,%edx
80105bdb:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
80105be1:	85 d2                	test   %edx,%edx
80105be3:	74 0d                	je     80105bf2 <syscall+0xb8>
80105be5:	25 ff 0f 00 00       	and    $0xfff,%eax
80105bea:	83 e8 04             	sub    $0x4,%eax
80105bed:	01 e0                	add    %esp,%eax
80105bef:	83 08 00             	orl    $0x0,(%eax)
80105bf2:	89 e0                	mov    %esp,%eax
80105bf4:	83 c0 00             	add    $0x0,%eax
80105bf7:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    for(i = 0; proc->name[i] != 0; i += 1) {
80105bfa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
80105c01:	eb 20                	jmp    80105c23 <syscall+0xe9>
        procname[i] = proc->name[i];
80105c03:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105c0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105c0d:	01 d0                	add    %edx,%eax
80105c0f:	83 c0 6c             	add    $0x6c,%eax
80105c12:	0f b6 00             	movzbl (%eax),%eax
80105c15:	8b 4d a4             	mov    -0x5c(%ebp),%ecx
80105c18:	8b 55 e8             	mov    -0x18(%ebp),%edx
80105c1b:	01 ca                	add    %ecx,%edx
80105c1d:	88 02                	mov    %al,(%edx)
    for(i = 0; proc->name[i] != 0; i += 1) {
80105c1f:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
80105c23:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105c2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105c2d:	01 d0                	add    %edx,%eax
80105c2f:	83 c0 6c             	add    $0x6c,%eax
80105c32:	0f b6 00             	movzbl (%eax),%eax
80105c35:	84 c0                	test   %al,%al
80105c37:	75 ca                	jne    80105c03 <syscall+0xc9>
    }
    procname[i] = proc->name[i];
80105c39:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105c40:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105c43:	01 d0                	add    %edx,%eax
80105c45:	83 c0 6c             	add    $0x6c,%eax
80105c48:	0f b6 00             	movzbl (%eax),%eax
80105c4b:	8b 4d a4             	mov    -0x5c(%ebp),%ecx
80105c4e:	8b 55 e8             	mov    -0x18(%ebp),%edx
80105c51:	01 ca                	add    %ecx,%edx
80105c53:	88 02                	mov    %al,(%edx)
    num = proc->tf->eax;
80105c55:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c5b:	8b 40 18             	mov    0x18(%eax),%eax
80105c5e:	8b 40 1c             	mov    0x1c(%eax),%eax
80105c61:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    num2 = proc->tf->eax;
80105c64:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c6a:	8b 40 18             	mov    0x18(%eax),%eax
80105c6d:	8b 40 1c             	mov    0x1c(%eax),%eax
80105c70:	89 45 a0             	mov    %eax,-0x60(%ebp)

    if(num == SYS_exit && is_traced) {
80105c73:	83 7d e4 02          	cmpl   $0x2,-0x1c(%ebp)
80105c77:	0f 85 c9 04 00 00    	jne    80106146 <syscall+0x60c>
80105c7d:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
80105c81:	0f 84 bf 04 00 00    	je     80106146 <syscall+0x60c>
        //char pid = proc->pid + '0';
        char s1[50] = "TRACE: pid = ";
80105c87:	c7 85 7a fe ff ff 54 	movl   $0x43415254,-0x186(%ebp)
80105c8e:	52 41 43 
80105c91:	c7 85 7e fe ff ff 45 	movl   $0x70203a45,-0x182(%ebp)
80105c98:	3a 20 70 
80105c9b:	c7 85 82 fe ff ff 69 	movl   $0x3d206469,-0x17e(%ebp)
80105ca2:	64 20 3d 
80105ca5:	c7 85 86 fe ff ff 20 	movl   $0x20,-0x17a(%ebp)
80105cac:	00 00 00 
80105caf:	c7 85 8a fe ff ff 00 	movl   $0x0,-0x176(%ebp)
80105cb6:	00 00 00 
80105cb9:	c7 85 8e fe ff ff 00 	movl   $0x0,-0x172(%ebp)
80105cc0:	00 00 00 
80105cc3:	c7 85 92 fe ff ff 00 	movl   $0x0,-0x16e(%ebp)
80105cca:	00 00 00 
80105ccd:	c7 85 96 fe ff ff 00 	movl   $0x0,-0x16a(%ebp)
80105cd4:	00 00 00 
80105cd7:	c7 85 9a fe ff ff 00 	movl   $0x0,-0x166(%ebp)
80105cde:	00 00 00 
80105ce1:	c7 85 9e fe ff ff 00 	movl   $0x0,-0x162(%ebp)
80105ce8:	00 00 00 
80105ceb:	c7 85 a2 fe ff ff 00 	movl   $0x0,-0x15e(%ebp)
80105cf2:	00 00 00 
80105cf5:	c7 85 a6 fe ff ff 00 	movl   $0x0,-0x15a(%ebp)
80105cfc:	00 00 00 
80105cff:	66 c7 85 aa fe ff ff 	movw   $0x0,-0x156(%ebp)
80105d06:	00 00 
        //char s2[50] = " | process name = ";
        char s2[50] = " | command name = ";
80105d08:	c7 85 ac fe ff ff 20 	movl   $0x63207c20,-0x154(%ebp)
80105d0f:	7c 20 63 
80105d12:	c7 85 b0 fe ff ff 6f 	movl   $0x616d6d6f,-0x150(%ebp)
80105d19:	6d 6d 61 
80105d1c:	c7 85 b4 fe ff ff 6e 	movl   $0x6e20646e,-0x14c(%ebp)
80105d23:	64 20 6e 
80105d26:	c7 85 b8 fe ff ff 61 	movl   $0x20656d61,-0x148(%ebp)
80105d2d:	6d 65 20 
80105d30:	c7 85 bc fe ff ff 3d 	movl   $0x203d,-0x144(%ebp)
80105d37:	20 00 00 
80105d3a:	c7 85 c0 fe ff ff 00 	movl   $0x0,-0x140(%ebp)
80105d41:	00 00 00 
80105d44:	c7 85 c4 fe ff ff 00 	movl   $0x0,-0x13c(%ebp)
80105d4b:	00 00 00 
80105d4e:	c7 85 c8 fe ff ff 00 	movl   $0x0,-0x138(%ebp)
80105d55:	00 00 00 
80105d58:	c7 85 cc fe ff ff 00 	movl   $0x0,-0x134(%ebp)
80105d5f:	00 00 00 
80105d62:	c7 85 d0 fe ff ff 00 	movl   $0x0,-0x130(%ebp)
80105d69:	00 00 00 
80105d6c:	c7 85 d4 fe ff ff 00 	movl   $0x0,-0x12c(%ebp)
80105d73:	00 00 00 
80105d76:	c7 85 d8 fe ff ff 00 	movl   $0x0,-0x128(%ebp)
80105d7d:	00 00 00 
80105d80:	66 c7 85 dc fe ff ff 	movw   $0x0,-0x124(%ebp)
80105d87:	00 00 
        char s3[50] = " | syscall = ";
80105d89:	c7 85 de fe ff ff 20 	movl   $0x73207c20,-0x122(%ebp)
80105d90:	7c 20 73 
80105d93:	c7 85 e2 fe ff ff 79 	movl   $0x61637379,-0x11e(%ebp)
80105d9a:	73 63 61 
80105d9d:	c7 85 e6 fe ff ff 6c 	movl   $0x3d206c6c,-0x11a(%ebp)
80105da4:	6c 20 3d 
80105da7:	c7 85 ea fe ff ff 20 	movl   $0x20,-0x116(%ebp)
80105dae:	00 00 00 
80105db1:	c7 85 ee fe ff ff 00 	movl   $0x0,-0x112(%ebp)
80105db8:	00 00 00 
80105dbb:	c7 85 f2 fe ff ff 00 	movl   $0x0,-0x10e(%ebp)
80105dc2:	00 00 00 
80105dc5:	c7 85 f6 fe ff ff 00 	movl   $0x0,-0x10a(%ebp)
80105dcc:	00 00 00 
80105dcf:	c7 85 fa fe ff ff 00 	movl   $0x0,-0x106(%ebp)
80105dd6:	00 00 00 
80105dd9:	c7 85 fe fe ff ff 00 	movl   $0x0,-0x102(%ebp)
80105de0:	00 00 00 
80105de3:	c7 85 02 ff ff ff 00 	movl   $0x0,-0xfe(%ebp)
80105dea:	00 00 00 
80105ded:	c7 85 06 ff ff ff 00 	movl   $0x0,-0xfa(%ebp)
80105df4:	00 00 00 
80105df7:	c7 85 0a ff ff ff 00 	movl   $0x0,-0xf6(%ebp)
80105dfe:	00 00 00 
80105e01:	66 c7 85 0e ff ff ff 	movw   $0x0,-0xf2(%ebp)
80105e08:	00 00 
        int k =0, j=0;
80105e0a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105e11:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
        char event[100];
        while(s1[k] != '\0') {
80105e18:	eb 23                	jmp    80105e3d <syscall+0x303>
            event[j] = s1[k];
80105e1a:	8d 95 7a fe ff ff    	lea    -0x186(%ebp),%edx
80105e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e23:	01 d0                	add    %edx,%eax
80105e25:	0f b6 00             	movzbl (%eax),%eax
80105e28:	8d 8d 10 ff ff ff    	lea    -0xf0(%ebp),%ecx
80105e2e:	8b 55 e0             	mov    -0x20(%ebp),%edx
80105e31:	01 ca                	add    %ecx,%edx
80105e33:	88 02                	mov    %al,(%edx)
            k+=1;
80105e35:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
            j+=1;
80105e39:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
        while(s1[k] != '\0') {
80105e3d:	8d 95 7a fe ff ff    	lea    -0x186(%ebp),%edx
80105e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e46:	01 d0                	add    %edx,%eax
80105e48:	0f b6 00             	movzbl (%eax),%eax
80105e4b:	84 c0                	test   %al,%al
80105e4d:	75 cb                	jne    80105e1a <syscall+0x2e0>
        }
        int pid = proc->pid;
80105e4f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e55:	8b 40 10             	mov    0x10(%eax),%eax
80105e58:	89 45 dc             	mov    %eax,-0x24(%ebp)
                // event[j] = pid;
                char temp1[5];
                    int counter1 =0;
80105e5b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
                    while(pid!=0){
80105e62:	eb 57                	jmp    80105ebb <syscall+0x381>
                        int k = pid%10;
80105e64:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80105e67:	ba 67 66 66 66       	mov    $0x66666667,%edx
80105e6c:	89 c8                	mov    %ecx,%eax
80105e6e:	f7 ea                	imul   %edx
80105e70:	c1 fa 02             	sar    $0x2,%edx
80105e73:	89 c8                	mov    %ecx,%eax
80105e75:	c1 f8 1f             	sar    $0x1f,%eax
80105e78:	29 c2                	sub    %eax,%edx
80105e7a:	89 d0                	mov    %edx,%eax
80105e7c:	c1 e0 02             	shl    $0x2,%eax
80105e7f:	01 d0                	add    %edx,%eax
80105e81:	01 c0                	add    %eax,%eax
80105e83:	29 c1                	sub    %eax,%ecx
80105e85:	89 c8                	mov    %ecx,%eax
80105e87:	89 45 9c             	mov    %eax,-0x64(%ebp)
                        temp1[counter1] = k+'0';
80105e8a:	8b 45 9c             	mov    -0x64(%ebp),%eax
80105e8d:	83 c0 30             	add    $0x30,%eax
80105e90:	89 c1                	mov    %eax,%ecx
80105e92:	8d 55 83             	lea    -0x7d(%ebp),%edx
80105e95:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105e98:	01 d0                	add    %edx,%eax
80105e9a:	88 08                	mov    %cl,(%eax)
                        counter1 +=1;
80105e9c:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
                        pid /=10;
80105ea0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80105ea3:	ba 67 66 66 66       	mov    $0x66666667,%edx
80105ea8:	89 c8                	mov    %ecx,%eax
80105eaa:	f7 ea                	imul   %edx
80105eac:	c1 fa 02             	sar    $0x2,%edx
80105eaf:	89 c8                	mov    %ecx,%eax
80105eb1:	c1 f8 1f             	sar    $0x1f,%eax
80105eb4:	29 c2                	sub    %eax,%edx
80105eb6:	89 d0                	mov    %edx,%eax
80105eb8:	89 45 dc             	mov    %eax,-0x24(%ebp)
                    while(pid!=0){
80105ebb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80105ebf:	75 a3                	jne    80105e64 <syscall+0x32a>
                    }
                    counter1 -=1;
80105ec1:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
                    while(counter1>=0){
80105ec5:	eb 20                	jmp    80105ee7 <syscall+0x3ad>
                    event[j] = temp1[counter1];
80105ec7:	8d 55 83             	lea    -0x7d(%ebp),%edx
80105eca:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105ecd:	01 d0                	add    %edx,%eax
80105ecf:	0f b6 00             	movzbl (%eax),%eax
80105ed2:	8d 8d 10 ff ff ff    	lea    -0xf0(%ebp),%ecx
80105ed8:	8b 55 e0             	mov    -0x20(%ebp),%edx
80105edb:	01 ca                	add    %ecx,%edx
80105edd:	88 02                	mov    %al,(%edx)
                    j+=1;
80105edf:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
                    counter1-=1;
80105ee3:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
                    while(counter1>=0){
80105ee7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80105eeb:	79 da                	jns    80105ec7 <syscall+0x38d>
                    }
        j+=1;
80105eed:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
        k =0;
80105ef1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
        while(s2[k] != '\0') {
80105ef8:	eb 23                	jmp    80105f1d <syscall+0x3e3>
            event[j] = s2[k];
80105efa:	8d 95 ac fe ff ff    	lea    -0x154(%ebp),%edx
80105f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f03:	01 d0                	add    %edx,%eax
80105f05:	0f b6 00             	movzbl (%eax),%eax
80105f08:	8d 8d 10 ff ff ff    	lea    -0xf0(%ebp),%ecx
80105f0e:	8b 55 e0             	mov    -0x20(%ebp),%edx
80105f11:	01 ca                	add    %ecx,%edx
80105f13:	88 02                	mov    %al,(%edx)
            k+=1;
80105f15:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
            j+=1;
80105f19:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
        while(s2[k] != '\0') {
80105f1d:	8d 95 ac fe ff ff    	lea    -0x154(%ebp),%edx
80105f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f26:	01 d0                	add    %edx,%eax
80105f28:	0f b6 00             	movzbl (%eax),%eax
80105f2b:	84 c0                	test   %al,%al
80105f2d:	75 cb                	jne    80105efa <syscall+0x3c0>
        }
        k=0;
80105f2f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
        event[j] = ' ';
80105f36:	8d 95 10 ff ff ff    	lea    -0xf0(%ebp),%edx
80105f3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105f3f:	01 d0                	add    %edx,%eax
80105f41:	c6 00 20             	movb   $0x20,(%eax)
        j+=1;
80105f44:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
        while(procname[k] != '\0') {
80105f48:	eb 20                	jmp    80105f6a <syscall+0x430>
            event[j] = procname[k];
80105f4a:	8b 55 a4             	mov    -0x5c(%ebp),%edx
80105f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f50:	01 d0                	add    %edx,%eax
80105f52:	0f b6 00             	movzbl (%eax),%eax
80105f55:	8d 8d 10 ff ff ff    	lea    -0xf0(%ebp),%ecx
80105f5b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80105f5e:	01 ca                	add    %ecx,%edx
80105f60:	88 02                	mov    %al,(%edx)
            k+=1;
80105f62:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
            j+=1;
80105f66:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
        while(procname[k] != '\0') {
80105f6a:	8b 55 a4             	mov    -0x5c(%ebp),%edx
80105f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f70:	01 d0                	add    %edx,%eax
80105f72:	0f b6 00             	movzbl (%eax),%eax
80105f75:	84 c0                	test   %al,%al
80105f77:	75 d1                	jne    80105f4a <syscall+0x410>
        }
        k =0;
80105f79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
        event[j] = ' ';
80105f80:	8d 95 10 ff ff ff    	lea    -0xf0(%ebp),%edx
80105f86:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105f89:	01 d0                	add    %edx,%eax
80105f8b:	c6 00 20             	movb   $0x20,(%eax)
        j+=1;
80105f8e:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
        while(s3[k] != '\0') {
80105f92:	eb 23                	jmp    80105fb7 <syscall+0x47d>
            event[j] = s3[k];
80105f94:	8d 95 de fe ff ff    	lea    -0x122(%ebp),%edx
80105f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f9d:	01 d0                	add    %edx,%eax
80105f9f:	0f b6 00             	movzbl (%eax),%eax
80105fa2:	8d 8d 10 ff ff ff    	lea    -0xf0(%ebp),%ecx
80105fa8:	8b 55 e0             	mov    -0x20(%ebp),%edx
80105fab:	01 ca                	add    %ecx,%edx
80105fad:	88 02                	mov    %al,(%edx)
            k+=1;
80105faf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
            j+=1;
80105fb3:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
        while(s3[k] != '\0') {
80105fb7:	8d 95 de fe ff ff    	lea    -0x122(%ebp),%edx
80105fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fc0:	01 d0                	add    %edx,%eax
80105fc2:	0f b6 00             	movzbl (%eax),%eax
80105fc5:	84 c0                	test   %al,%al
80105fc7:	75 cb                	jne    80105f94 <syscall+0x45a>
        } 
        event[j] = ' ';
80105fc9:	8d 95 10 ff ff ff    	lea    -0xf0(%ebp),%edx
80105fcf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105fd2:	01 d0                	add    %edx,%eax
80105fd4:	c6 00 20             	movb   $0x20,(%eax)
        j+=1;
80105fd7:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
        k=0;
80105fdb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
        num = proc->tf->eax;
80105fe2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105fe8:	8b 40 18             	mov    0x18(%eax),%eax
80105feb:	8b 40 1c             	mov    0x1c(%eax),%eax
80105fee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        while(syscall_names[num][k] != '\0') {
80105ff1:	eb 27                	jmp    8010601a <syscall+0x4e0>
            event[j] = syscall_names[num][k];
80105ff3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ff6:	8b 14 85 e0 d0 10 80 	mov    -0x7fef2f20(,%eax,4),%edx
80105ffd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106000:	01 d0                	add    %edx,%eax
80106002:	0f b6 00             	movzbl (%eax),%eax
80106005:	8d 8d 10 ff ff ff    	lea    -0xf0(%ebp),%ecx
8010600b:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010600e:	01 ca                	add    %ecx,%edx
80106010:	88 02                	mov    %al,(%edx)
            k+=1;
80106012:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
            j+=1;
80106016:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
        while(syscall_names[num][k] != '\0') {
8010601a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010601d:	8b 14 85 e0 d0 10 80 	mov    -0x7fef2f20(,%eax,4),%edx
80106024:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106027:	01 d0                	add    %edx,%eax
80106029:	0f b6 00             	movzbl (%eax),%eax
8010602c:	84 c0                	test   %al,%al
8010602e:	75 c3                	jne    80105ff3 <syscall+0x4b9>
        }
        event[j] = '\0';
80106030:	8d 95 10 ff ff ff    	lea    -0xf0(%ebp),%edx
80106036:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106039:	01 d0                	add    %edx,%eax
8010603b:	c6 00 00             	movb   $0x0,(%eax)
        addToBuff(event);
8010603e:	83 ec 0c             	sub    $0xc,%esp
80106041:	8d 85 10 ff ff ff    	lea    -0xf0(%ebp),%eax
80106047:	50                   	push   %eax
80106048:	e8 75 f9 ff ff       	call   801059c2 <addToBuff>
8010604d:	83 c4 10             	add    $0x10,%esp

        if(e_flag == -1 && s_flag == 0 && f_flag == 0)
80106050:	a1 40 d0 10 80       	mov    0x8010d040,%eax
80106055:	83 f8 ff             	cmp    $0xffffffff,%eax
80106058:	75 3c                	jne    80106096 <syscall+0x55c>
8010605a:	a1 0c d7 10 80       	mov    0x8010d70c,%eax
8010605f:	85 c0                	test   %eax,%eax
80106061:	75 33                	jne    80106096 <syscall+0x55c>
80106063:	a1 10 d7 10 80       	mov    0x8010d710,%eax
80106068:	85 c0                	test   %eax,%eax
8010606a:	75 2a                	jne    80106096 <syscall+0x55c>
            cprintf("TRACE: pid = %d | command name = %s | syscall = %s\n", proc->pid, procname, syscall_names[num2]);
8010606c:	8b 45 a0             	mov    -0x60(%ebp),%eax
8010606f:	8b 14 85 e0 d0 10 80 	mov    -0x7fef2f20(,%eax,4),%edx
80106076:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010607c:	8b 40 10             	mov    0x10(%eax),%eax
8010607f:	52                   	push   %edx
80106080:	ff 75 a4             	pushl  -0x5c(%ebp)
80106083:	50                   	push   %eax
80106084:	68 c4 a2 10 80       	push   $0x8010a2c4
80106089:	e8 1c a3 ff ff       	call   801003aa <cprintf>
8010608e:	83 c4 10             	add    $0x10,%esp
80106091:	e9 b0 00 00 00       	jmp    80106146 <syscall+0x60c>
        else {
            if(e_flag != -1) {
80106096:	a1 40 d0 10 80       	mov    0x8010d040,%eax
8010609b:	83 f8 ff             	cmp    $0xffffffff,%eax
8010609e:	74 5a                	je     801060fa <syscall+0x5c0>
                if(strcompare(syscall_names[e_flag+1], syscall_names[num2]) == 0) {
801060a0:	8b 45 a0             	mov    -0x60(%ebp),%eax
801060a3:	8b 14 85 e0 d0 10 80 	mov    -0x7fef2f20(,%eax,4),%edx
801060aa:	a1 40 d0 10 80       	mov    0x8010d040,%eax
801060af:	83 c0 01             	add    $0x1,%eax
801060b2:	8b 04 85 e0 d0 10 80 	mov    -0x7fef2f20(,%eax,4),%eax
801060b9:	83 ec 08             	sub    $0x8,%esp
801060bc:	52                   	push   %edx
801060bd:	50                   	push   %eax
801060be:	e8 2d f8 ff ff       	call   801058f0 <strcompare>
801060c3:	83 c4 10             	add    $0x10,%esp
801060c6:	85 c0                	test   %eax,%eax
801060c8:	75 5e                	jne    80106128 <syscall+0x5ee>
                    if(f_flag == 0)
801060ca:	a1 10 d7 10 80       	mov    0x8010d710,%eax
801060cf:	85 c0                	test   %eax,%eax
801060d1:	75 55                	jne    80106128 <syscall+0x5ee>
                        cprintf("TRACE: pid = %d | command name = %s | syscall = %s\n", proc->pid, procname, syscall_names[num2]);
801060d3:	8b 45 a0             	mov    -0x60(%ebp),%eax
801060d6:	8b 14 85 e0 d0 10 80 	mov    -0x7fef2f20(,%eax,4),%edx
801060dd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801060e3:	8b 40 10             	mov    0x10(%eax),%eax
801060e6:	52                   	push   %edx
801060e7:	ff 75 a4             	pushl  -0x5c(%ebp)
801060ea:	50                   	push   %eax
801060eb:	68 c4 a2 10 80       	push   $0x8010a2c4
801060f0:	e8 b5 a2 ff ff       	call   801003aa <cprintf>
801060f5:	83 c4 10             	add    $0x10,%esp
801060f8:	eb 2e                	jmp    80106128 <syscall+0x5ee>
                }
            }
            else if(f_flag == 0)
801060fa:	a1 10 d7 10 80       	mov    0x8010d710,%eax
801060ff:	85 c0                	test   %eax,%eax
80106101:	75 25                	jne    80106128 <syscall+0x5ee>
                cprintf("TRACE: pid = %d | command name = %s | syscall = %s\n", proc->pid, procname, syscall_names[num2]);
80106103:	8b 45 a0             	mov    -0x60(%ebp),%eax
80106106:	8b 14 85 e0 d0 10 80 	mov    -0x7fef2f20(,%eax,4),%edx
8010610d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106113:	8b 40 10             	mov    0x10(%eax),%eax
80106116:	52                   	push   %edx
80106117:	ff 75 a4             	pushl  -0x5c(%ebp)
8010611a:	50                   	push   %eax
8010611b:	68 c4 a2 10 80       	push   $0x8010a2c4
80106120:	e8 85 a2 ff ff       	call   801003aa <cprintf>
80106125:	83 c4 10             	add    $0x10,%esp
            
            e_flag = -1;
80106128:	c7 05 40 d0 10 80 ff 	movl   $0xffffffff,0x8010d040
8010612f:	ff ff ff 
            s_flag = 0;
80106132:	c7 05 0c d7 10 80 00 	movl   $0x0,0x8010d70c
80106139:	00 00 00 
            f_flag = 0;
8010613c:	c7 05 10 d7 10 80 00 	movl   $0x0,0x8010d710
80106143:	00 00 00 
        }
    }
    if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80106146:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010614a:	0f 8e 14 0d 00 00    	jle    80106e64 <syscall+0x132a>
80106150:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106153:	83 f8 1a             	cmp    $0x1a,%eax
80106156:	0f 87 08 0d 00 00    	ja     80106e64 <syscall+0x132a>
8010615c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010615f:	8b 04 85 60 d0 10 80 	mov    -0x7fef2fa0(,%eax,4),%eax
80106166:	85 c0                	test   %eax,%eax
80106168:	0f 84 f6 0c 00 00    	je     80106e64 <syscall+0x132a>
        proc->tf->eax = syscalls[num]();
8010616e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106171:	8b 04 85 60 d0 10 80 	mov    -0x7fef2fa0(,%eax,4),%eax
80106178:	ff d0                	call   *%eax
8010617a:	89 c2                	mov    %eax,%edx
8010617c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106182:	8b 40 18             	mov    0x18(%eax),%eax
80106185:	89 50 1c             	mov    %edx,0x1c(%eax)

        if(is_traced) {
80106188:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
8010618c:	0f 84 08 0d 00 00    	je     80106e9a <syscall+0x1360>
            if(num == SYS_exec && proc->tf->eax == 0) {
80106192:	83 7d e4 07          	cmpl   $0x7,-0x1c(%ebp)
80106196:	0f 85 48 05 00 00    	jne    801066e4 <syscall+0xbaa>
8010619c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801061a2:	8b 40 18             	mov    0x18(%eax),%eax
801061a5:	8b 40 1c             	mov    0x1c(%eax),%eax
801061a8:	85 c0                	test   %eax,%eax
801061aa:	0f 85 34 05 00 00    	jne    801066e4 <syscall+0xbaa>
                //char pid = proc->pid + '0';
                char s1[50] = "TRACE: pid = ";
801061b0:	c7 85 7a fe ff ff 54 	movl   $0x43415254,-0x186(%ebp)
801061b7:	52 41 43 
801061ba:	c7 85 7e fe ff ff 45 	movl   $0x70203a45,-0x182(%ebp)
801061c1:	3a 20 70 
801061c4:	c7 85 82 fe ff ff 69 	movl   $0x3d206469,-0x17e(%ebp)
801061cb:	64 20 3d 
801061ce:	c7 85 86 fe ff ff 20 	movl   $0x20,-0x17a(%ebp)
801061d5:	00 00 00 
801061d8:	c7 85 8a fe ff ff 00 	movl   $0x0,-0x176(%ebp)
801061df:	00 00 00 
801061e2:	c7 85 8e fe ff ff 00 	movl   $0x0,-0x172(%ebp)
801061e9:	00 00 00 
801061ec:	c7 85 92 fe ff ff 00 	movl   $0x0,-0x16e(%ebp)
801061f3:	00 00 00 
801061f6:	c7 85 96 fe ff ff 00 	movl   $0x0,-0x16a(%ebp)
801061fd:	00 00 00 
80106200:	c7 85 9a fe ff ff 00 	movl   $0x0,-0x166(%ebp)
80106207:	00 00 00 
8010620a:	c7 85 9e fe ff ff 00 	movl   $0x0,-0x162(%ebp)
80106211:	00 00 00 
80106214:	c7 85 a2 fe ff ff 00 	movl   $0x0,-0x15e(%ebp)
8010621b:	00 00 00 
8010621e:	c7 85 a6 fe ff ff 00 	movl   $0x0,-0x15a(%ebp)
80106225:	00 00 00 
80106228:	66 c7 85 aa fe ff ff 	movw   $0x0,-0x156(%ebp)
8010622f:	00 00 
                //char s2[50] = " | process name = ";
                char s2[50] = " | command name = ";
80106231:	c7 85 ac fe ff ff 20 	movl   $0x63207c20,-0x154(%ebp)
80106238:	7c 20 63 
8010623b:	c7 85 b0 fe ff ff 6f 	movl   $0x616d6d6f,-0x150(%ebp)
80106242:	6d 6d 61 
80106245:	c7 85 b4 fe ff ff 6e 	movl   $0x6e20646e,-0x14c(%ebp)
8010624c:	64 20 6e 
8010624f:	c7 85 b8 fe ff ff 61 	movl   $0x20656d61,-0x148(%ebp)
80106256:	6d 65 20 
80106259:	c7 85 bc fe ff ff 3d 	movl   $0x203d,-0x144(%ebp)
80106260:	20 00 00 
80106263:	c7 85 c0 fe ff ff 00 	movl   $0x0,-0x140(%ebp)
8010626a:	00 00 00 
8010626d:	c7 85 c4 fe ff ff 00 	movl   $0x0,-0x13c(%ebp)
80106274:	00 00 00 
80106277:	c7 85 c8 fe ff ff 00 	movl   $0x0,-0x138(%ebp)
8010627e:	00 00 00 
80106281:	c7 85 cc fe ff ff 00 	movl   $0x0,-0x134(%ebp)
80106288:	00 00 00 
8010628b:	c7 85 d0 fe ff ff 00 	movl   $0x0,-0x130(%ebp)
80106292:	00 00 00 
80106295:	c7 85 d4 fe ff ff 00 	movl   $0x0,-0x12c(%ebp)
8010629c:	00 00 00 
8010629f:	c7 85 d8 fe ff ff 00 	movl   $0x0,-0x128(%ebp)
801062a6:	00 00 00 
801062a9:	66 c7 85 dc fe ff ff 	movw   $0x0,-0x124(%ebp)
801062b0:	00 00 
                char s3[50] = " | syscall = ";
801062b2:	c7 85 de fe ff ff 20 	movl   $0x73207c20,-0x122(%ebp)
801062b9:	7c 20 73 
801062bc:	c7 85 e2 fe ff ff 79 	movl   $0x61637379,-0x11e(%ebp)
801062c3:	73 63 61 
801062c6:	c7 85 e6 fe ff ff 6c 	movl   $0x3d206c6c,-0x11a(%ebp)
801062cd:	6c 20 3d 
801062d0:	c7 85 ea fe ff ff 20 	movl   $0x20,-0x116(%ebp)
801062d7:	00 00 00 
801062da:	c7 85 ee fe ff ff 00 	movl   $0x0,-0x112(%ebp)
801062e1:	00 00 00 
801062e4:	c7 85 f2 fe ff ff 00 	movl   $0x0,-0x10e(%ebp)
801062eb:	00 00 00 
801062ee:	c7 85 f6 fe ff ff 00 	movl   $0x0,-0x10a(%ebp)
801062f5:	00 00 00 
801062f8:	c7 85 fa fe ff ff 00 	movl   $0x0,-0x106(%ebp)
801062ff:	00 00 00 
80106302:	c7 85 fe fe ff ff 00 	movl   $0x0,-0x102(%ebp)
80106309:	00 00 00 
8010630c:	c7 85 02 ff ff ff 00 	movl   $0x0,-0xfe(%ebp)
80106313:	00 00 00 
80106316:	c7 85 06 ff ff ff 00 	movl   $0x0,-0xfa(%ebp)
8010631d:	00 00 00 
80106320:	c7 85 0a ff ff ff 00 	movl   $0x0,-0xf6(%ebp)
80106327:	00 00 00 
8010632a:	66 c7 85 0e ff ff ff 	movw   $0x0,-0xf2(%ebp)
80106331:	00 00 
                int k =0, j=0;
80106333:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
8010633a:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
                char event[100];
                while(s1[k] != '\0'){
80106341:	eb 23                	jmp    80106366 <syscall+0x82c>
                    event[j] = s1[k];
80106343:	8d 95 7a fe ff ff    	lea    -0x186(%ebp),%edx
80106349:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010634c:	01 d0                	add    %edx,%eax
8010634e:	0f b6 00             	movzbl (%eax),%eax
80106351:	8d 8d 10 ff ff ff    	lea    -0xf0(%ebp),%ecx
80106357:	8b 55 d0             	mov    -0x30(%ebp),%edx
8010635a:	01 ca                	add    %ecx,%edx
8010635c:	88 02                	mov    %al,(%edx)
                    k+=1;
8010635e:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
                    j+=1;
80106362:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
                while(s1[k] != '\0'){
80106366:	8d 95 7a fe ff ff    	lea    -0x186(%ebp),%edx
8010636c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010636f:	01 d0                	add    %edx,%eax
80106371:	0f b6 00             	movzbl (%eax),%eax
80106374:	84 c0                	test   %al,%al
80106376:	75 cb                	jne    80106343 <syscall+0x809>
                }
                int pid = proc->pid;
80106378:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010637e:	8b 40 10             	mov    0x10(%eax),%eax
80106381:	89 45 cc             	mov    %eax,-0x34(%ebp)
                // event[j] = pid;
                char temp1[5];
                    int counter1 =0;
80106384:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
                    while(pid!=0){
8010638b:	eb 5a                	jmp    801063e7 <syscall+0x8ad>
                        int k = pid%10;
8010638d:	8b 4d cc             	mov    -0x34(%ebp),%ecx
80106390:	ba 67 66 66 66       	mov    $0x66666667,%edx
80106395:	89 c8                	mov    %ecx,%eax
80106397:	f7 ea                	imul   %edx
80106399:	c1 fa 02             	sar    $0x2,%edx
8010639c:	89 c8                	mov    %ecx,%eax
8010639e:	c1 f8 1f             	sar    $0x1f,%eax
801063a1:	29 c2                	sub    %eax,%edx
801063a3:	89 d0                	mov    %edx,%eax
801063a5:	c1 e0 02             	shl    $0x2,%eax
801063a8:	01 d0                	add    %edx,%eax
801063aa:	01 c0                	add    %eax,%eax
801063ac:	29 c1                	sub    %eax,%ecx
801063ae:	89 c8                	mov    %ecx,%eax
801063b0:	89 45 94             	mov    %eax,-0x6c(%ebp)
                        temp1[counter1] = k+'0';
801063b3:	8b 45 94             	mov    -0x6c(%ebp),%eax
801063b6:	83 c0 30             	add    $0x30,%eax
801063b9:	89 c1                	mov    %eax,%ecx
801063bb:	8d 95 7e ff ff ff    	lea    -0x82(%ebp),%edx
801063c1:	8b 45 c8             	mov    -0x38(%ebp),%eax
801063c4:	01 d0                	add    %edx,%eax
801063c6:	88 08                	mov    %cl,(%eax)
                        counter1 +=1;
801063c8:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
                        pid /=10;
801063cc:	8b 4d cc             	mov    -0x34(%ebp),%ecx
801063cf:	ba 67 66 66 66       	mov    $0x66666667,%edx
801063d4:	89 c8                	mov    %ecx,%eax
801063d6:	f7 ea                	imul   %edx
801063d8:	c1 fa 02             	sar    $0x2,%edx
801063db:	89 c8                	mov    %ecx,%eax
801063dd:	c1 f8 1f             	sar    $0x1f,%eax
801063e0:	29 c2                	sub    %eax,%edx
801063e2:	89 d0                	mov    %edx,%eax
801063e4:	89 45 cc             	mov    %eax,-0x34(%ebp)
                    while(pid!=0){
801063e7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
801063eb:	75 a0                	jne    8010638d <syscall+0x853>
                    }
                    counter1 -=1;
801063ed:	83 6d c8 01          	subl   $0x1,-0x38(%ebp)
                    while(counter1>=0){
801063f1:	eb 23                	jmp    80106416 <syscall+0x8dc>
                    event[j] = temp1[counter1];
801063f3:	8d 95 7e ff ff ff    	lea    -0x82(%ebp),%edx
801063f9:	8b 45 c8             	mov    -0x38(%ebp),%eax
801063fc:	01 d0                	add    %edx,%eax
801063fe:	0f b6 00             	movzbl (%eax),%eax
80106401:	8d 8d 10 ff ff ff    	lea    -0xf0(%ebp),%ecx
80106407:	8b 55 d0             	mov    -0x30(%ebp),%edx
8010640a:	01 ca                	add    %ecx,%edx
8010640c:	88 02                	mov    %al,(%edx)
                    j+=1;
8010640e:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
                    counter1-=1;
80106412:	83 6d c8 01          	subl   $0x1,-0x38(%ebp)
                    while(counter1>=0){
80106416:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
8010641a:	79 d7                	jns    801063f3 <syscall+0x8b9>
                    }
                j+=1;
8010641c:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
                k =0;
80106420:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
                while(s2[k] != '\0'){
80106427:	eb 23                	jmp    8010644c <syscall+0x912>
                    event[j] = s2[k];
80106429:	8d 95 ac fe ff ff    	lea    -0x154(%ebp),%edx
8010642f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80106432:	01 d0                	add    %edx,%eax
80106434:	0f b6 00             	movzbl (%eax),%eax
80106437:	8d 8d 10 ff ff ff    	lea    -0xf0(%ebp),%ecx
8010643d:	8b 55 d0             	mov    -0x30(%ebp),%edx
80106440:	01 ca                	add    %ecx,%edx
80106442:	88 02                	mov    %al,(%edx)
                    k+=1;
80106444:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
                    j+=1;
80106448:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
                while(s2[k] != '\0'){
8010644c:	8d 95 ac fe ff ff    	lea    -0x154(%ebp),%edx
80106452:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80106455:	01 d0                	add    %edx,%eax
80106457:	0f b6 00             	movzbl (%eax),%eax
8010645a:	84 c0                	test   %al,%al
8010645c:	75 cb                	jne    80106429 <syscall+0x8ef>
                }
                k=0;
8010645e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
                event[j] = ' ';
80106465:	8d 95 10 ff ff ff    	lea    -0xf0(%ebp),%edx
8010646b:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010646e:	01 d0                	add    %edx,%eax
80106470:	c6 00 20             	movb   $0x20,(%eax)
                j+=1;
80106473:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
                while(procname[k] != '\0'){
80106477:	eb 20                	jmp    80106499 <syscall+0x95f>
                    event[j] = procname[k];
80106479:	8b 55 a4             	mov    -0x5c(%ebp),%edx
8010647c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010647f:	01 d0                	add    %edx,%eax
80106481:	0f b6 00             	movzbl (%eax),%eax
80106484:	8d 8d 10 ff ff ff    	lea    -0xf0(%ebp),%ecx
8010648a:	8b 55 d0             	mov    -0x30(%ebp),%edx
8010648d:	01 ca                	add    %ecx,%edx
8010648f:	88 02                	mov    %al,(%edx)
                    k+=1;
80106491:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
                    j+=1;
80106495:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
                while(procname[k] != '\0'){
80106499:	8b 55 a4             	mov    -0x5c(%ebp),%edx
8010649c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010649f:	01 d0                	add    %edx,%eax
801064a1:	0f b6 00             	movzbl (%eax),%eax
801064a4:	84 c0                	test   %al,%al
801064a6:	75 d1                	jne    80106479 <syscall+0x93f>
                }
                k =0;
801064a8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
                event[j] = ' ';
801064af:	8d 95 10 ff ff ff    	lea    -0xf0(%ebp),%edx
801064b5:	8b 45 d0             	mov    -0x30(%ebp),%eax
801064b8:	01 d0                	add    %edx,%eax
801064ba:	c6 00 20             	movb   $0x20,(%eax)
                j+=1;
801064bd:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
                while(s3[k] != '\0'){
801064c1:	eb 23                	jmp    801064e6 <syscall+0x9ac>
                    event[j] = s3[k];
801064c3:	8d 95 de fe ff ff    	lea    -0x122(%ebp),%edx
801064c9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801064cc:	01 d0                	add    %edx,%eax
801064ce:	0f b6 00             	movzbl (%eax),%eax
801064d1:	8d 8d 10 ff ff ff    	lea    -0xf0(%ebp),%ecx
801064d7:	8b 55 d0             	mov    -0x30(%ebp),%edx
801064da:	01 ca                	add    %ecx,%edx
801064dc:	88 02                	mov    %al,(%edx)
                    k+=1;
801064de:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
                    j+=1;
801064e2:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
                while(s3[k] != '\0'){
801064e6:	8d 95 de fe ff ff    	lea    -0x122(%ebp),%edx
801064ec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801064ef:	01 d0                	add    %edx,%eax
801064f1:	0f b6 00             	movzbl (%eax),%eax
801064f4:	84 c0                	test   %al,%al
801064f6:	75 cb                	jne    801064c3 <syscall+0x989>
                } 
                event[j] = ' ';
801064f8:	8d 95 10 ff ff ff    	lea    -0xf0(%ebp),%edx
801064fe:	8b 45 d0             	mov    -0x30(%ebp),%eax
80106501:	01 d0                	add    %edx,%eax
80106503:	c6 00 20             	movb   $0x20,(%eax)
                j+=1;
80106506:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
                k=0;
8010650a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
                while(syscall_names[num][k] != '\0'){
80106511:	eb 27                	jmp    8010653a <syscall+0xa00>
                    event[j] = syscall_names[num][k];
80106513:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106516:	8b 14 85 e0 d0 10 80 	mov    -0x7fef2f20(,%eax,4),%edx
8010651d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80106520:	01 d0                	add    %edx,%eax
80106522:	0f b6 00             	movzbl (%eax),%eax
80106525:	8d 8d 10 ff ff ff    	lea    -0xf0(%ebp),%ecx
8010652b:	8b 55 d0             	mov    -0x30(%ebp),%edx
8010652e:	01 ca                	add    %ecx,%edx
80106530:	88 02                	mov    %al,(%edx)
                    k+=1;
80106532:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
                    j+=1;
80106536:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
                while(syscall_names[num][k] != '\0'){
8010653a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010653d:	8b 14 85 e0 d0 10 80 	mov    -0x7fef2f20(,%eax,4),%edx
80106544:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80106547:	01 d0                	add    %edx,%eax
80106549:	0f b6 00             	movzbl (%eax),%eax
8010654c:	84 c0                	test   %al,%al
8010654e:	75 c3                	jne    80106513 <syscall+0x9d9>
                }
                event[j] = '\0';
80106550:	8d 95 10 ff ff ff    	lea    -0xf0(%ebp),%edx
80106556:	8b 45 d0             	mov    -0x30(%ebp),%eax
80106559:	01 d0                	add    %edx,%eax
8010655b:	c6 00 00             	movb   $0x0,(%eax)
                addToBuff(event);
8010655e:	83 ec 0c             	sub    $0xc,%esp
80106561:	8d 85 10 ff ff ff    	lea    -0xf0(%ebp),%eax
80106567:	50                   	push   %eax
80106568:	e8 55 f4 ff ff       	call   801059c2 <addToBuff>
8010656d:	83 c4 10             	add    $0x10,%esp

                if(e_flag == -1 && s_flag == 0 && f_flag == 0) {
80106570:	a1 40 d0 10 80       	mov    0x8010d040,%eax
80106575:	83 f8 ff             	cmp    $0xffffffff,%eax
80106578:	75 56                	jne    801065d0 <syscall+0xa96>
8010657a:	a1 0c d7 10 80       	mov    0x8010d70c,%eax
8010657f:	85 c0                	test   %eax,%eax
80106581:	75 4d                	jne    801065d0 <syscall+0xa96>
80106583:	a1 10 d7 10 80       	mov    0x8010d710,%eax
80106588:	85 c0                	test   %eax,%eax
8010658a:	75 44                	jne    801065d0 <syscall+0xa96>
                    cprintf("TRACE: pid = %d | command name = sh | syscall = trace | return value = 0\n", proc->pid);
8010658c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106592:	8b 40 10             	mov    0x10(%eax),%eax
80106595:	83 ec 08             	sub    $0x8,%esp
80106598:	50                   	push   %eax
80106599:	68 f8 a2 10 80       	push   $0x8010a2f8
8010659e:	e8 07 9e ff ff       	call   801003aa <cprintf>
801065a3:	83 c4 10             	add    $0x10,%esp
                    cprintf("TRACE: pid = %d | command name = %s | syscall = %s\n", proc->pid, procname, syscall_names[num2]);
801065a6:	8b 45 a0             	mov    -0x60(%ebp),%eax
801065a9:	8b 14 85 e0 d0 10 80 	mov    -0x7fef2f20(,%eax,4),%edx
801065b0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801065b6:	8b 40 10             	mov    0x10(%eax),%eax
801065b9:	52                   	push   %edx
801065ba:	ff 75 a4             	pushl  -0x5c(%ebp)
801065bd:	50                   	push   %eax
801065be:	68 c4 a2 10 80       	push   $0x8010a2c4
801065c3:	e8 e2 9d ff ff       	call   801003aa <cprintf>
801065c8:	83 c4 10             	add    $0x10,%esp
            if(num == SYS_exec && proc->tf->eax == 0) {
801065cb:	e9 91 08 00 00       	jmp    80106e61 <syscall+0x1327>
                }
                else {
                    if(e_flag != -1) {
801065d0:	a1 40 d0 10 80       	mov    0x8010d040,%eax
801065d5:	83 f8 ff             	cmp    $0xffffffff,%eax
801065d8:	74 65                	je     8010663f <syscall+0xb05>
                        if(strcompare(syscall_names[e_flag+1], syscall_names[num2]) == 0) {
801065da:	8b 45 a0             	mov    -0x60(%ebp),%eax
801065dd:	8b 14 85 e0 d0 10 80 	mov    -0x7fef2f20(,%eax,4),%edx
801065e4:	a1 40 d0 10 80       	mov    0x8010d040,%eax
801065e9:	83 c0 01             	add    $0x1,%eax
801065ec:	8b 04 85 e0 d0 10 80 	mov    -0x7fef2f20(,%eax,4),%eax
801065f3:	83 ec 08             	sub    $0x8,%esp
801065f6:	52                   	push   %edx
801065f7:	50                   	push   %eax
801065f8:	e8 f3 f2 ff ff       	call   801058f0 <strcompare>
801065fd:	83 c4 10             	add    $0x10,%esp
80106600:	85 c0                	test   %eax,%eax
80106602:	0f 85 59 08 00 00    	jne    80106e61 <syscall+0x1327>
                            if(f_flag == 0)
80106608:	a1 10 d7 10 80       	mov    0x8010d710,%eax
8010660d:	85 c0                	test   %eax,%eax
8010660f:	0f 85 4c 08 00 00    	jne    80106e61 <syscall+0x1327>
                                cprintf("TRACE: pid = %d | command name = %s | syscall = %s\n", proc->pid, procname, syscall_names[num2]);
80106615:	8b 45 a0             	mov    -0x60(%ebp),%eax
80106618:	8b 14 85 e0 d0 10 80 	mov    -0x7fef2f20(,%eax,4),%edx
8010661f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106625:	8b 40 10             	mov    0x10(%eax),%eax
80106628:	52                   	push   %edx
80106629:	ff 75 a4             	pushl  -0x5c(%ebp)
8010662c:	50                   	push   %eax
8010662d:	68 c4 a2 10 80       	push   $0x8010a2c4
80106632:	e8 73 9d ff ff       	call   801003aa <cprintf>
80106637:	83 c4 10             	add    $0x10,%esp
            if(num == SYS_exec && proc->tf->eax == 0) {
8010663a:	e9 22 08 00 00       	jmp    80106e61 <syscall+0x1327>
                        }
                    }
                    else if(s_flag == 1) {
8010663f:	a1 0c d7 10 80       	mov    0x8010d70c,%eax
80106644:	83 f8 01             	cmp    $0x1,%eax
80106647:	75 44                	jne    8010668d <syscall+0xb53>
                        cprintf("TRACE: pid = %d | command name = sh | syscall = trace | return value = 0\n", proc->pid);
80106649:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010664f:	8b 40 10             	mov    0x10(%eax),%eax
80106652:	83 ec 08             	sub    $0x8,%esp
80106655:	50                   	push   %eax
80106656:	68 f8 a2 10 80       	push   $0x8010a2f8
8010665b:	e8 4a 9d ff ff       	call   801003aa <cprintf>
80106660:	83 c4 10             	add    $0x10,%esp
                        cprintf("TRACE: pid = %d | command name = %s | syscall = %s\n", proc->pid, procname, syscall_names[num2]);
80106663:	8b 45 a0             	mov    -0x60(%ebp),%eax
80106666:	8b 14 85 e0 d0 10 80 	mov    -0x7fef2f20(,%eax,4),%edx
8010666d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106673:	8b 40 10             	mov    0x10(%eax),%eax
80106676:	52                   	push   %edx
80106677:	ff 75 a4             	pushl  -0x5c(%ebp)
8010667a:	50                   	push   %eax
8010667b:	68 c4 a2 10 80       	push   $0x8010a2c4
80106680:	e8 25 9d ff ff       	call   801003aa <cprintf>
80106685:	83 c4 10             	add    $0x10,%esp
            if(num == SYS_exec && proc->tf->eax == 0) {
80106688:	e9 d4 07 00 00       	jmp    80106e61 <syscall+0x1327>
                    }
                    else if(f_flag == 1) { 
8010668d:	a1 10 d7 10 80       	mov    0x8010d710,%eax
80106692:	83 f8 01             	cmp    $0x1,%eax
80106695:	0f 85 c6 07 00 00    	jne    80106e61 <syscall+0x1327>
                        // add f flag logs
                        int returnval = proc->tf->eax; // The return value of the system call
8010669b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801066a1:	8b 40 18             	mov    0x18(%eax),%eax
801066a4:	8b 40 1c             	mov    0x1c(%eax),%eax
801066a7:	89 45 98             	mov    %eax,-0x68(%ebp)
                        if (returnval == -1) {
801066aa:	83 7d 98 ff          	cmpl   $0xffffffff,-0x68(%ebp)
801066ae:	0f 85 ad 07 00 00    	jne    80106e61 <syscall+0x1327>
                            // Construct the trace log for failed system calls
                            cprintf("TRACE11: pid = %d | command name = %s | syscall = %s | return value = %d (FAILED)\n",
801066b4:	8b 45 a0             	mov    -0x60(%ebp),%eax
801066b7:	8b 14 85 e0 d0 10 80 	mov    -0x7fef2f20(,%eax,4),%edx
                                    proc->pid, procname, syscall_names[num2], returnval);
801066be:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
                            cprintf("TRACE11: pid = %d | command name = %s | syscall = %s | return value = %d (FAILED)\n",
801066c4:	8b 40 10             	mov    0x10(%eax),%eax
801066c7:	83 ec 0c             	sub    $0xc,%esp
801066ca:	ff 75 98             	pushl  -0x68(%ebp)
801066cd:	52                   	push   %edx
801066ce:	ff 75 a4             	pushl  -0x5c(%ebp)
801066d1:	50                   	push   %eax
801066d2:	68 44 a3 10 80       	push   $0x8010a344
801066d7:	e8 ce 9c ff ff       	call   801003aa <cprintf>
801066dc:	83 c4 20             	add    $0x20,%esp
            if(num == SYS_exec && proc->tf->eax == 0) {
801066df:	e9 7d 07 00 00       	jmp    80106e61 <syscall+0x1327>
                    }
                }
            }
            else {
                //int pid = proc->pid;
                char s1[50] = "TRACE: pid = ";
801066e4:	c7 85 48 fe ff ff 54 	movl   $0x43415254,-0x1b8(%ebp)
801066eb:	52 41 43 
801066ee:	c7 85 4c fe ff ff 45 	movl   $0x70203a45,-0x1b4(%ebp)
801066f5:	3a 20 70 
801066f8:	c7 85 50 fe ff ff 69 	movl   $0x3d206469,-0x1b0(%ebp)
801066ff:	64 20 3d 
80106702:	c7 85 54 fe ff ff 20 	movl   $0x20,-0x1ac(%ebp)
80106709:	00 00 00 
8010670c:	c7 85 58 fe ff ff 00 	movl   $0x0,-0x1a8(%ebp)
80106713:	00 00 00 
80106716:	c7 85 5c fe ff ff 00 	movl   $0x0,-0x1a4(%ebp)
8010671d:	00 00 00 
80106720:	c7 85 60 fe ff ff 00 	movl   $0x0,-0x1a0(%ebp)
80106727:	00 00 00 
8010672a:	c7 85 64 fe ff ff 00 	movl   $0x0,-0x19c(%ebp)
80106731:	00 00 00 
80106734:	c7 85 68 fe ff ff 00 	movl   $0x0,-0x198(%ebp)
8010673b:	00 00 00 
8010673e:	c7 85 6c fe ff ff 00 	movl   $0x0,-0x194(%ebp)
80106745:	00 00 00 
80106748:	c7 85 70 fe ff ff 00 	movl   $0x0,-0x190(%ebp)
8010674f:	00 00 00 
80106752:	c7 85 74 fe ff ff 00 	movl   $0x0,-0x18c(%ebp)
80106759:	00 00 00 
8010675c:	66 c7 85 78 fe ff ff 	movw   $0x0,-0x188(%ebp)
80106763:	00 00 
                //char s2[50] = " | process name = ";
                char s2[50] = " | command name = ";
80106765:	c7 85 7a fe ff ff 20 	movl   $0x63207c20,-0x186(%ebp)
8010676c:	7c 20 63 
8010676f:	c7 85 7e fe ff ff 6f 	movl   $0x616d6d6f,-0x182(%ebp)
80106776:	6d 6d 61 
80106779:	c7 85 82 fe ff ff 6e 	movl   $0x6e20646e,-0x17e(%ebp)
80106780:	64 20 6e 
80106783:	c7 85 86 fe ff ff 61 	movl   $0x20656d61,-0x17a(%ebp)
8010678a:	6d 65 20 
8010678d:	c7 85 8a fe ff ff 3d 	movl   $0x203d,-0x176(%ebp)
80106794:	20 00 00 
80106797:	c7 85 8e fe ff ff 00 	movl   $0x0,-0x172(%ebp)
8010679e:	00 00 00 
801067a1:	c7 85 92 fe ff ff 00 	movl   $0x0,-0x16e(%ebp)
801067a8:	00 00 00 
801067ab:	c7 85 96 fe ff ff 00 	movl   $0x0,-0x16a(%ebp)
801067b2:	00 00 00 
801067b5:	c7 85 9a fe ff ff 00 	movl   $0x0,-0x166(%ebp)
801067bc:	00 00 00 
801067bf:	c7 85 9e fe ff ff 00 	movl   $0x0,-0x162(%ebp)
801067c6:	00 00 00 
801067c9:	c7 85 a2 fe ff ff 00 	movl   $0x0,-0x15e(%ebp)
801067d0:	00 00 00 
801067d3:	c7 85 a6 fe ff ff 00 	movl   $0x0,-0x15a(%ebp)
801067da:	00 00 00 
801067dd:	66 c7 85 aa fe ff ff 	movw   $0x0,-0x156(%ebp)
801067e4:	00 00 
                char s3[50] = " | syscall = ";
801067e6:	c7 85 ac fe ff ff 20 	movl   $0x73207c20,-0x154(%ebp)
801067ed:	7c 20 73 
801067f0:	c7 85 b0 fe ff ff 79 	movl   $0x61637379,-0x150(%ebp)
801067f7:	73 63 61 
801067fa:	c7 85 b4 fe ff ff 6c 	movl   $0x3d206c6c,-0x14c(%ebp)
80106801:	6c 20 3d 
80106804:	c7 85 b8 fe ff ff 20 	movl   $0x20,-0x148(%ebp)
8010680b:	00 00 00 
8010680e:	c7 85 bc fe ff ff 00 	movl   $0x0,-0x144(%ebp)
80106815:	00 00 00 
80106818:	c7 85 c0 fe ff ff 00 	movl   $0x0,-0x140(%ebp)
8010681f:	00 00 00 
80106822:	c7 85 c4 fe ff ff 00 	movl   $0x0,-0x13c(%ebp)
80106829:	00 00 00 
8010682c:	c7 85 c8 fe ff ff 00 	movl   $0x0,-0x138(%ebp)
80106833:	00 00 00 
80106836:	c7 85 cc fe ff ff 00 	movl   $0x0,-0x134(%ebp)
8010683d:	00 00 00 
80106840:	c7 85 d0 fe ff ff 00 	movl   $0x0,-0x130(%ebp)
80106847:	00 00 00 
8010684a:	c7 85 d4 fe ff ff 00 	movl   $0x0,-0x12c(%ebp)
80106851:	00 00 00 
80106854:	c7 85 d8 fe ff ff 00 	movl   $0x0,-0x128(%ebp)
8010685b:	00 00 00 
8010685e:	66 c7 85 dc fe ff ff 	movw   $0x0,-0x124(%ebp)
80106865:	00 00 
                char s5[50] = " | return value = ";
80106867:	c7 85 de fe ff ff 20 	movl   $0x72207c20,-0x122(%ebp)
8010686e:	7c 20 72 
80106871:	c7 85 e2 fe ff ff 65 	movl   $0x72757465,-0x11e(%ebp)
80106878:	74 75 72 
8010687b:	c7 85 e6 fe ff ff 6e 	movl   $0x6176206e,-0x11a(%ebp)
80106882:	20 76 61 
80106885:	c7 85 ea fe ff ff 6c 	movl   $0x2065756c,-0x116(%ebp)
8010688c:	75 65 20 
8010688f:	c7 85 ee fe ff ff 3d 	movl   $0x203d,-0x112(%ebp)
80106896:	20 00 00 
80106899:	c7 85 f2 fe ff ff 00 	movl   $0x0,-0x10e(%ebp)
801068a0:	00 00 00 
801068a3:	c7 85 f6 fe ff ff 00 	movl   $0x0,-0x10a(%ebp)
801068aa:	00 00 00 
801068ad:	c7 85 fa fe ff ff 00 	movl   $0x0,-0x106(%ebp)
801068b4:	00 00 00 
801068b7:	c7 85 fe fe ff ff 00 	movl   $0x0,-0x102(%ebp)
801068be:	00 00 00 
801068c1:	c7 85 02 ff ff ff 00 	movl   $0x0,-0xfe(%ebp)
801068c8:	00 00 00 
801068cb:	c7 85 06 ff ff ff 00 	movl   $0x0,-0xfa(%ebp)
801068d2:	00 00 00 
801068d5:	c7 85 0a ff ff ff 00 	movl   $0x0,-0xf6(%ebp)
801068dc:	00 00 00 
801068df:	66 c7 85 0e ff ff ff 	movw   $0x0,-0xf2(%ebp)
801068e6:	00 00 
                int k =0, j=0;
801068e8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
801068ef:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
                char event[100];
                while(s1[k] != '\0'){
801068f6:	eb 23                	jmp    8010691b <syscall+0xde1>
                    event[j] = s1[k];
801068f8:	8d 95 48 fe ff ff    	lea    -0x1b8(%ebp),%edx
801068fe:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80106901:	01 d0                	add    %edx,%eax
80106903:	0f b6 00             	movzbl (%eax),%eax
80106906:	8d 8d 10 ff ff ff    	lea    -0xf0(%ebp),%ecx
8010690c:	8b 55 c0             	mov    -0x40(%ebp),%edx
8010690f:	01 ca                	add    %ecx,%edx
80106911:	88 02                	mov    %al,(%edx)
                    k+=1;
80106913:	83 45 c4 01          	addl   $0x1,-0x3c(%ebp)
                    j+=1;
80106917:	83 45 c0 01          	addl   $0x1,-0x40(%ebp)
                while(s1[k] != '\0'){
8010691b:	8d 95 48 fe ff ff    	lea    -0x1b8(%ebp),%edx
80106921:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80106924:	01 d0                	add    %edx,%eax
80106926:	0f b6 00             	movzbl (%eax),%eax
80106929:	84 c0                	test   %al,%al
8010692b:	75 cb                	jne    801068f8 <syscall+0xdbe>
                }
                int pid = proc->pid;
8010692d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106933:	8b 40 10             	mov    0x10(%eax),%eax
80106936:	89 45 bc             	mov    %eax,-0x44(%ebp)
                // event[j] = pid;
                char temp1[5];
                    int counter1 =0;
80106939:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
                    while(pid!=0){
80106940:	eb 5a                	jmp    8010699c <syscall+0xe62>
                        int k = pid%10;
80106942:	8b 4d bc             	mov    -0x44(%ebp),%ecx
80106945:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010694a:	89 c8                	mov    %ecx,%eax
8010694c:	f7 ea                	imul   %edx
8010694e:	c1 fa 02             	sar    $0x2,%edx
80106951:	89 c8                	mov    %ecx,%eax
80106953:	c1 f8 1f             	sar    $0x1f,%eax
80106956:	29 c2                	sub    %eax,%edx
80106958:	89 d0                	mov    %edx,%eax
8010695a:	c1 e0 02             	shl    $0x2,%eax
8010695d:	01 d0                	add    %edx,%eax
8010695f:	01 c0                	add    %eax,%eax
80106961:	29 c1                	sub    %eax,%ecx
80106963:	89 c8                	mov    %ecx,%eax
80106965:	89 45 88             	mov    %eax,-0x78(%ebp)
                        temp1[counter1] = k+'0';
80106968:	8b 45 88             	mov    -0x78(%ebp),%eax
8010696b:	83 c0 30             	add    $0x30,%eax
8010696e:	89 c1                	mov    %eax,%ecx
80106970:	8d 95 79 ff ff ff    	lea    -0x87(%ebp),%edx
80106976:	8b 45 b8             	mov    -0x48(%ebp),%eax
80106979:	01 d0                	add    %edx,%eax
8010697b:	88 08                	mov    %cl,(%eax)
                        counter1 +=1;
8010697d:	83 45 b8 01          	addl   $0x1,-0x48(%ebp)
                        pid /=10;
80106981:	8b 4d bc             	mov    -0x44(%ebp),%ecx
80106984:	ba 67 66 66 66       	mov    $0x66666667,%edx
80106989:	89 c8                	mov    %ecx,%eax
8010698b:	f7 ea                	imul   %edx
8010698d:	c1 fa 02             	sar    $0x2,%edx
80106990:	89 c8                	mov    %ecx,%eax
80106992:	c1 f8 1f             	sar    $0x1f,%eax
80106995:	29 c2                	sub    %eax,%edx
80106997:	89 d0                	mov    %edx,%eax
80106999:	89 45 bc             	mov    %eax,-0x44(%ebp)
                    while(pid!=0){
8010699c:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
801069a0:	75 a0                	jne    80106942 <syscall+0xe08>
                    }
                    counter1 -=1;
801069a2:	83 6d b8 01          	subl   $0x1,-0x48(%ebp)
                    while(counter1>=0){
801069a6:	eb 23                	jmp    801069cb <syscall+0xe91>
                    event[j] = temp1[counter1];
801069a8:	8d 95 79 ff ff ff    	lea    -0x87(%ebp),%edx
801069ae:	8b 45 b8             	mov    -0x48(%ebp),%eax
801069b1:	01 d0                	add    %edx,%eax
801069b3:	0f b6 00             	movzbl (%eax),%eax
801069b6:	8d 8d 10 ff ff ff    	lea    -0xf0(%ebp),%ecx
801069bc:	8b 55 c0             	mov    -0x40(%ebp),%edx
801069bf:	01 ca                	add    %ecx,%edx
801069c1:	88 02                	mov    %al,(%edx)
                    j+=1;
801069c3:	83 45 c0 01          	addl   $0x1,-0x40(%ebp)
                    counter1-=1;
801069c7:	83 6d b8 01          	subl   $0x1,-0x48(%ebp)
                    while(counter1>=0){
801069cb:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
801069cf:	79 d7                	jns    801069a8 <syscall+0xe6e>
                    }
                j+=1;
801069d1:	83 45 c0 01          	addl   $0x1,-0x40(%ebp)
                k =0;
801069d5:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
                while(s2[k] != '\0'){
801069dc:	eb 23                	jmp    80106a01 <syscall+0xec7>
                    event[j] = s2[k];
801069de:	8d 95 7a fe ff ff    	lea    -0x186(%ebp),%edx
801069e4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801069e7:	01 d0                	add    %edx,%eax
801069e9:	0f b6 00             	movzbl (%eax),%eax
801069ec:	8d 8d 10 ff ff ff    	lea    -0xf0(%ebp),%ecx
801069f2:	8b 55 c0             	mov    -0x40(%ebp),%edx
801069f5:	01 ca                	add    %ecx,%edx
801069f7:	88 02                	mov    %al,(%edx)
                    k+=1;
801069f9:	83 45 c4 01          	addl   $0x1,-0x3c(%ebp)
                    j+=1;
801069fd:	83 45 c0 01          	addl   $0x1,-0x40(%ebp)
                while(s2[k] != '\0'){
80106a01:	8d 95 7a fe ff ff    	lea    -0x186(%ebp),%edx
80106a07:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80106a0a:	01 d0                	add    %edx,%eax
80106a0c:	0f b6 00             	movzbl (%eax),%eax
80106a0f:	84 c0                	test   %al,%al
80106a11:	75 cb                	jne    801069de <syscall+0xea4>
                }
                k=0;
80106a13:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
                event[j] = ' ';
80106a1a:	8d 95 10 ff ff ff    	lea    -0xf0(%ebp),%edx
80106a20:	8b 45 c0             	mov    -0x40(%ebp),%eax
80106a23:	01 d0                	add    %edx,%eax
80106a25:	c6 00 20             	movb   $0x20,(%eax)
                j+=1;
80106a28:	83 45 c0 01          	addl   $0x1,-0x40(%ebp)
                while(procname[k] != '\0'){
80106a2c:	eb 20                	jmp    80106a4e <syscall+0xf14>
                    event[j] = procname[k];
80106a2e:	8b 55 a4             	mov    -0x5c(%ebp),%edx
80106a31:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80106a34:	01 d0                	add    %edx,%eax
80106a36:	0f b6 00             	movzbl (%eax),%eax
80106a39:	8d 8d 10 ff ff ff    	lea    -0xf0(%ebp),%ecx
80106a3f:	8b 55 c0             	mov    -0x40(%ebp),%edx
80106a42:	01 ca                	add    %ecx,%edx
80106a44:	88 02                	mov    %al,(%edx)
                    k+=1;
80106a46:	83 45 c4 01          	addl   $0x1,-0x3c(%ebp)
                    j+=1;
80106a4a:	83 45 c0 01          	addl   $0x1,-0x40(%ebp)
                while(procname[k] != '\0'){
80106a4e:	8b 55 a4             	mov    -0x5c(%ebp),%edx
80106a51:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80106a54:	01 d0                	add    %edx,%eax
80106a56:	0f b6 00             	movzbl (%eax),%eax
80106a59:	84 c0                	test   %al,%al
80106a5b:	75 d1                	jne    80106a2e <syscall+0xef4>
                }
                k =0;
80106a5d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
                event[j] = ' ';
80106a64:	8d 95 10 ff ff ff    	lea    -0xf0(%ebp),%edx
80106a6a:	8b 45 c0             	mov    -0x40(%ebp),%eax
80106a6d:	01 d0                	add    %edx,%eax
80106a6f:	c6 00 20             	movb   $0x20,(%eax)
                j+=1;
80106a72:	83 45 c0 01          	addl   $0x1,-0x40(%ebp)
                while(s3[k] != '\0'){
80106a76:	eb 23                	jmp    80106a9b <syscall+0xf61>
                    event[j] = s3[k];
80106a78:	8d 95 ac fe ff ff    	lea    -0x154(%ebp),%edx
80106a7e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80106a81:	01 d0                	add    %edx,%eax
80106a83:	0f b6 00             	movzbl (%eax),%eax
80106a86:	8d 8d 10 ff ff ff    	lea    -0xf0(%ebp),%ecx
80106a8c:	8b 55 c0             	mov    -0x40(%ebp),%edx
80106a8f:	01 ca                	add    %ecx,%edx
80106a91:	88 02                	mov    %al,(%edx)
                    k+=1;
80106a93:	83 45 c4 01          	addl   $0x1,-0x3c(%ebp)
                    j+=1;
80106a97:	83 45 c0 01          	addl   $0x1,-0x40(%ebp)
                while(s3[k] != '\0'){
80106a9b:	8d 95 ac fe ff ff    	lea    -0x154(%ebp),%edx
80106aa1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80106aa4:	01 d0                	add    %edx,%eax
80106aa6:	0f b6 00             	movzbl (%eax),%eax
80106aa9:	84 c0                	test   %al,%al
80106aab:	75 cb                	jne    80106a78 <syscall+0xf3e>
                } 
                event[j] = ' ';
80106aad:	8d 95 10 ff ff ff    	lea    -0xf0(%ebp),%edx
80106ab3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80106ab6:	01 d0                	add    %edx,%eax
80106ab8:	c6 00 20             	movb   $0x20,(%eax)
                j+=1;
80106abb:	83 45 c0 01          	addl   $0x1,-0x40(%ebp)
                k=0;
80106abf:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
                while(syscall_names[num][k] != '\0'){
80106ac6:	eb 27                	jmp    80106aef <syscall+0xfb5>
                    event[j] = syscall_names[num][k];
80106ac8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106acb:	8b 14 85 e0 d0 10 80 	mov    -0x7fef2f20(,%eax,4),%edx
80106ad2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80106ad5:	01 d0                	add    %edx,%eax
80106ad7:	0f b6 00             	movzbl (%eax),%eax
80106ada:	8d 8d 10 ff ff ff    	lea    -0xf0(%ebp),%ecx
80106ae0:	8b 55 c0             	mov    -0x40(%ebp),%edx
80106ae3:	01 ca                	add    %ecx,%edx
80106ae5:	88 02                	mov    %al,(%edx)
                    k+=1;
80106ae7:	83 45 c4 01          	addl   $0x1,-0x3c(%ebp)
                    j+=1;
80106aeb:	83 45 c0 01          	addl   $0x1,-0x40(%ebp)
                while(syscall_names[num][k] != '\0'){
80106aef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106af2:	8b 14 85 e0 d0 10 80 	mov    -0x7fef2f20(,%eax,4),%edx
80106af9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80106afc:	01 d0                	add    %edx,%eax
80106afe:	0f b6 00             	movzbl (%eax),%eax
80106b01:	84 c0                	test   %al,%al
80106b03:	75 c3                	jne    80106ac8 <syscall+0xf8e>
                }
                k =0;
80106b05:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
                event[j] = ' ';
80106b0c:	8d 95 10 ff ff ff    	lea    -0xf0(%ebp),%edx
80106b12:	8b 45 c0             	mov    -0x40(%ebp),%eax
80106b15:	01 d0                	add    %edx,%eax
80106b17:	c6 00 20             	movb   $0x20,(%eax)
                j+=1;
80106b1a:	83 45 c0 01          	addl   $0x1,-0x40(%ebp)
                while(s5[k] != '\0'){
80106b1e:	eb 23                	jmp    80106b43 <syscall+0x1009>
                    event[j] = s5[k];
80106b20:	8d 95 de fe ff ff    	lea    -0x122(%ebp),%edx
80106b26:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80106b29:	01 d0                	add    %edx,%eax
80106b2b:	0f b6 00             	movzbl (%eax),%eax
80106b2e:	8d 8d 10 ff ff ff    	lea    -0xf0(%ebp),%ecx
80106b34:	8b 55 c0             	mov    -0x40(%ebp),%edx
80106b37:	01 ca                	add    %ecx,%edx
80106b39:	88 02                	mov    %al,(%edx)
                    k+=1;
80106b3b:	83 45 c4 01          	addl   $0x1,-0x3c(%ebp)
                    j+=1;
80106b3f:	83 45 c0 01          	addl   $0x1,-0x40(%ebp)
                while(s5[k] != '\0'){
80106b43:	8d 95 de fe ff ff    	lea    -0x122(%ebp),%edx
80106b49:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80106b4c:	01 d0                	add    %edx,%eax
80106b4e:	0f b6 00             	movzbl (%eax),%eax
80106b51:	84 c0                	test   %al,%al
80106b53:	75 cb                	jne    80106b20 <syscall+0xfe6>
                } 
                int num = proc->tf->eax;
80106b55:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b5b:	8b 40 18             	mov    0x18(%eax),%eax
80106b5e:	8b 40 1c             	mov    0x1c(%eax),%eax
80106b61:	89 45 b4             	mov    %eax,-0x4c(%ebp)
                if(num == 0){
80106b64:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
80106b68:	75 1a                	jne    80106b84 <syscall+0x104a>
                    event[j] = num +'0';
80106b6a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80106b6d:	83 c0 30             	add    $0x30,%eax
80106b70:	89 c1                	mov    %eax,%ecx
80106b72:	8d 95 10 ff ff ff    	lea    -0xf0(%ebp),%edx
80106b78:	8b 45 c0             	mov    -0x40(%ebp),%eax
80106b7b:	01 d0                	add    %edx,%eax
80106b7d:	88 08                	mov    %cl,(%eax)
80106b7f:	e9 98 00 00 00       	jmp    80106c1c <syscall+0x10e2>
                }
                else{
                    char temp[5];
                    int counter =0;
80106b84:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
                    while(num!=0){
80106b8b:	eb 5a                	jmp    80106be7 <syscall+0x10ad>
                        int k = num%10;
80106b8d:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
80106b90:	ba 67 66 66 66       	mov    $0x66666667,%edx
80106b95:	89 c8                	mov    %ecx,%eax
80106b97:	f7 ea                	imul   %edx
80106b99:	c1 fa 02             	sar    $0x2,%edx
80106b9c:	89 c8                	mov    %ecx,%eax
80106b9e:	c1 f8 1f             	sar    $0x1f,%eax
80106ba1:	29 c2                	sub    %eax,%edx
80106ba3:	89 d0                	mov    %edx,%eax
80106ba5:	c1 e0 02             	shl    $0x2,%eax
80106ba8:	01 d0                	add    %edx,%eax
80106baa:	01 c0                	add    %eax,%eax
80106bac:	29 c1                	sub    %eax,%ecx
80106bae:	89 c8                	mov    %ecx,%eax
80106bb0:	89 45 90             	mov    %eax,-0x70(%ebp)
                        temp[counter] = k+'0';
80106bb3:	8b 45 90             	mov    -0x70(%ebp),%eax
80106bb6:	83 c0 30             	add    $0x30,%eax
80106bb9:	89 c1                	mov    %eax,%ecx
80106bbb:	8d 95 74 ff ff ff    	lea    -0x8c(%ebp),%edx
80106bc1:	8b 45 b0             	mov    -0x50(%ebp),%eax
80106bc4:	01 d0                	add    %edx,%eax
80106bc6:	88 08                	mov    %cl,(%eax)
                        counter +=1;
80106bc8:	83 45 b0 01          	addl   $0x1,-0x50(%ebp)
                        num /=10;
80106bcc:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
80106bcf:	ba 67 66 66 66       	mov    $0x66666667,%edx
80106bd4:	89 c8                	mov    %ecx,%eax
80106bd6:	f7 ea                	imul   %edx
80106bd8:	c1 fa 02             	sar    $0x2,%edx
80106bdb:	89 c8                	mov    %ecx,%eax
80106bdd:	c1 f8 1f             	sar    $0x1f,%eax
80106be0:	29 c2                	sub    %eax,%edx
80106be2:	89 d0                	mov    %edx,%eax
80106be4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
                    while(num!=0){
80106be7:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
80106beb:	75 a0                	jne    80106b8d <syscall+0x1053>
                    }
                    counter -=1;
80106bed:	83 6d b0 01          	subl   $0x1,-0x50(%ebp)
                    while(counter>=0){
80106bf1:	eb 23                	jmp    80106c16 <syscall+0x10dc>
                    event[j] = temp[counter];
80106bf3:	8d 95 74 ff ff ff    	lea    -0x8c(%ebp),%edx
80106bf9:	8b 45 b0             	mov    -0x50(%ebp),%eax
80106bfc:	01 d0                	add    %edx,%eax
80106bfe:	0f b6 00             	movzbl (%eax),%eax
80106c01:	8d 8d 10 ff ff ff    	lea    -0xf0(%ebp),%ecx
80106c07:	8b 55 c0             	mov    -0x40(%ebp),%edx
80106c0a:	01 ca                	add    %ecx,%edx
80106c0c:	88 02                	mov    %al,(%edx)
                    j+=1;
80106c0e:	83 45 c0 01          	addl   $0x1,-0x40(%ebp)
                    counter-=1;
80106c12:	83 6d b0 01          	subl   $0x1,-0x50(%ebp)
                    while(counter>=0){
80106c16:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
80106c1a:	79 d7                	jns    80106bf3 <syscall+0x10b9>
                    }
                }
                event[j+1] = '\0';
80106c1c:	8b 45 c0             	mov    -0x40(%ebp),%eax
80106c1f:	83 c0 01             	add    $0x1,%eax
80106c22:	c6 84 05 10 ff ff ff 	movb   $0x0,-0xf0(%ebp,%eax,1)
80106c29:	00 
                addToBuff(event);
80106c2a:	83 ec 0c             	sub    $0xc,%esp
80106c2d:	8d 85 10 ff ff ff    	lea    -0xf0(%ebp),%eax
80106c33:	50                   	push   %eax
80106c34:	e8 89 ed ff ff       	call   801059c2 <addToBuff>
80106c39:	83 c4 10             	add    $0x10,%esp

                if(e_flag == -1 && s_flag == 0 && f_flag == 0)
80106c3c:	a1 40 d0 10 80       	mov    0x8010d040,%eax
80106c41:	83 f8 ff             	cmp    $0xffffffff,%eax
80106c44:	75 4c                	jne    80106c92 <syscall+0x1158>
80106c46:	a1 0c d7 10 80       	mov    0x8010d70c,%eax
80106c4b:	85 c0                	test   %eax,%eax
80106c4d:	75 43                	jne    80106c92 <syscall+0x1158>
80106c4f:	a1 10 d7 10 80       	mov    0x8010d710,%eax
80106c54:	85 c0                	test   %eax,%eax
80106c56:	75 3a                	jne    80106c92 <syscall+0x1158>
                    cprintf("TRACE: pid = %d | command name = %s | syscall = %s | return value = %d\n", proc->pid, procname, syscall_names[num2], proc->tf->eax);
80106c58:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c5e:	8b 40 18             	mov    0x18(%eax),%eax
80106c61:	8b 48 1c             	mov    0x1c(%eax),%ecx
80106c64:	8b 45 a0             	mov    -0x60(%ebp),%eax
80106c67:	8b 14 85 e0 d0 10 80 	mov    -0x7fef2f20(,%eax,4),%edx
80106c6e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c74:	8b 40 10             	mov    0x10(%eax),%eax
80106c77:	83 ec 0c             	sub    $0xc,%esp
80106c7a:	51                   	push   %ecx
80106c7b:	52                   	push   %edx
80106c7c:	ff 75 a4             	pushl  -0x5c(%ebp)
80106c7f:	50                   	push   %eax
80106c80:	68 98 a3 10 80       	push   $0x8010a398
80106c85:	e8 20 97 ff ff       	call   801003aa <cprintf>
80106c8a:	83 c4 20             	add    $0x20,%esp
80106c8d:	e9 d0 01 00 00       	jmp    80106e62 <syscall+0x1328>
                else {
                    int returnval = proc->tf->eax;
80106c92:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c98:	8b 40 18             	mov    0x18(%eax),%eax
80106c9b:	8b 40 1c             	mov    0x1c(%eax),%eax
80106c9e:	89 45 8c             	mov    %eax,-0x74(%ebp)
                    if(e_flag != -1) {
80106ca1:	a1 40 d0 10 80       	mov    0x8010d040,%eax
80106ca6:	83 f8 ff             	cmp    $0xffffffff,%eax
80106ca9:	0f 84 24 01 00 00    	je     80106dd3 <syscall+0x1299>
                        if(strcompare(syscall_names[e_flag+1], syscall_names[num2]) == 0) {
80106caf:	8b 45 a0             	mov    -0x60(%ebp),%eax
80106cb2:	8b 14 85 e0 d0 10 80 	mov    -0x7fef2f20(,%eax,4),%edx
80106cb9:	a1 40 d0 10 80       	mov    0x8010d040,%eax
80106cbe:	83 c0 01             	add    $0x1,%eax
80106cc1:	8b 04 85 e0 d0 10 80 	mov    -0x7fef2f20(,%eax,4),%eax
80106cc8:	83 ec 08             	sub    $0x8,%esp
80106ccb:	52                   	push   %edx
80106ccc:	50                   	push   %eax
80106ccd:	e8 1e ec ff ff       	call   801058f0 <strcompare>
80106cd2:	83 c4 10             	add    $0x10,%esp
80106cd5:	85 c0                	test   %eax,%eax
80106cd7:	0f 85 bd 01 00 00    	jne    80106e9a <syscall+0x1360>
                            if(s_flag == 1 && returnval >= 0) 
80106cdd:	a1 0c d7 10 80       	mov    0x8010d70c,%eax
80106ce2:	83 f8 01             	cmp    $0x1,%eax
80106ce5:	75 40                	jne    80106d27 <syscall+0x11ed>
80106ce7:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
80106ceb:	78 3a                	js     80106d27 <syscall+0x11ed>
                                cprintf("TRACE: pid = %d | command name = %s | syscall = %s | return value = %d\n", proc->pid, procname, syscall_names[num2], proc->tf->eax);
80106ced:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106cf3:	8b 40 18             	mov    0x18(%eax),%eax
80106cf6:	8b 48 1c             	mov    0x1c(%eax),%ecx
80106cf9:	8b 45 a0             	mov    -0x60(%ebp),%eax
80106cfc:	8b 14 85 e0 d0 10 80 	mov    -0x7fef2f20(,%eax,4),%edx
80106d03:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d09:	8b 40 10             	mov    0x10(%eax),%eax
80106d0c:	83 ec 0c             	sub    $0xc,%esp
80106d0f:	51                   	push   %ecx
80106d10:	52                   	push   %edx
80106d11:	ff 75 a4             	pushl  -0x5c(%ebp)
80106d14:	50                   	push   %eax
80106d15:	68 98 a3 10 80       	push   $0x8010a398
80106d1a:	e8 8b 96 ff ff       	call   801003aa <cprintf>
80106d1f:	83 c4 20             	add    $0x20,%esp
80106d22:	e9 3b 01 00 00       	jmp    80106e62 <syscall+0x1328>
                            else if(s_flag == 1 && returnval <= -1) { }
80106d27:	a1 0c d7 10 80       	mov    0x8010d70c,%eax
80106d2c:	83 f8 01             	cmp    $0x1,%eax
80106d2f:	75 0a                	jne    80106d3b <syscall+0x1201>
80106d31:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
80106d35:	0f 88 27 01 00 00    	js     80106e62 <syscall+0x1328>
                            else if(f_flag == 1 && returnval <= -1)
80106d3b:	a1 10 d7 10 80       	mov    0x8010d710,%eax
80106d40:	83 f8 01             	cmp    $0x1,%eax
80106d43:	75 40                	jne    80106d85 <syscall+0x124b>
80106d45:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
80106d49:	79 3a                	jns    80106d85 <syscall+0x124b>
                                cprintf("TRACE: pid = %d | command name = %s | syscall = %s | return value = %d\n", proc->pid, procname, syscall_names[num2], proc->tf->eax);
80106d4b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d51:	8b 40 18             	mov    0x18(%eax),%eax
80106d54:	8b 48 1c             	mov    0x1c(%eax),%ecx
80106d57:	8b 45 a0             	mov    -0x60(%ebp),%eax
80106d5a:	8b 14 85 e0 d0 10 80 	mov    -0x7fef2f20(,%eax,4),%edx
80106d61:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d67:	8b 40 10             	mov    0x10(%eax),%eax
80106d6a:	83 ec 0c             	sub    $0xc,%esp
80106d6d:	51                   	push   %ecx
80106d6e:	52                   	push   %edx
80106d6f:	ff 75 a4             	pushl  -0x5c(%ebp)
80106d72:	50                   	push   %eax
80106d73:	68 98 a3 10 80       	push   $0x8010a398
80106d78:	e8 2d 96 ff ff       	call   801003aa <cprintf>
80106d7d:	83 c4 20             	add    $0x20,%esp
80106d80:	e9 dd 00 00 00       	jmp    80106e62 <syscall+0x1328>
                            else if(f_flag == 1 && returnval >= 0) { }  
80106d85:	a1 10 d7 10 80       	mov    0x8010d710,%eax
80106d8a:	83 f8 01             	cmp    $0x1,%eax
80106d8d:	75 0a                	jne    80106d99 <syscall+0x125f>
80106d8f:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
80106d93:	0f 89 c9 00 00 00    	jns    80106e62 <syscall+0x1328>
                            else
                                cprintf("TRACE: pid = %d | command name = %s | syscall = %s | return value = %d\n", proc->pid, procname, syscall_names[num2], proc->tf->eax);
80106d99:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d9f:	8b 40 18             	mov    0x18(%eax),%eax
80106da2:	8b 48 1c             	mov    0x1c(%eax),%ecx
80106da5:	8b 45 a0             	mov    -0x60(%ebp),%eax
80106da8:	8b 14 85 e0 d0 10 80 	mov    -0x7fef2f20(,%eax,4),%edx
80106daf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106db5:	8b 40 10             	mov    0x10(%eax),%eax
80106db8:	83 ec 0c             	sub    $0xc,%esp
80106dbb:	51                   	push   %ecx
80106dbc:	52                   	push   %edx
80106dbd:	ff 75 a4             	pushl  -0x5c(%ebp)
80106dc0:	50                   	push   %eax
80106dc1:	68 98 a3 10 80       	push   $0x8010a398
80106dc6:	e8 df 95 ff ff       	call   801003aa <cprintf>
80106dcb:	83 c4 20             	add    $0x20,%esp
        if(is_traced) {
80106dce:	e9 c7 00 00 00       	jmp    80106e9a <syscall+0x1360>
                        }
                    }
                    else if(s_flag == 1 && returnval >= 0)
80106dd3:	a1 0c d7 10 80       	mov    0x8010d70c,%eax
80106dd8:	83 f8 01             	cmp    $0x1,%eax
80106ddb:	75 3d                	jne    80106e1a <syscall+0x12e0>
80106ddd:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
80106de1:	78 37                	js     80106e1a <syscall+0x12e0>
                        cprintf("TRACE: pid = %d | command name = %s | syscall = %s | return value = %d\n", proc->pid, procname, syscall_names[num2], proc->tf->eax);
80106de3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106de9:	8b 40 18             	mov    0x18(%eax),%eax
80106dec:	8b 48 1c             	mov    0x1c(%eax),%ecx
80106def:	8b 45 a0             	mov    -0x60(%ebp),%eax
80106df2:	8b 14 85 e0 d0 10 80 	mov    -0x7fef2f20(,%eax,4),%edx
80106df9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106dff:	8b 40 10             	mov    0x10(%eax),%eax
80106e02:	83 ec 0c             	sub    $0xc,%esp
80106e05:	51                   	push   %ecx
80106e06:	52                   	push   %edx
80106e07:	ff 75 a4             	pushl  -0x5c(%ebp)
80106e0a:	50                   	push   %eax
80106e0b:	68 98 a3 10 80       	push   $0x8010a398
80106e10:	e8 95 95 ff ff       	call   801003aa <cprintf>
80106e15:	83 c4 20             	add    $0x20,%esp
80106e18:	eb 48                	jmp    80106e62 <syscall+0x1328>
                    else if(f_flag == 1 && returnval <= -1)
80106e1a:	a1 10 d7 10 80       	mov    0x8010d710,%eax
80106e1f:	83 f8 01             	cmp    $0x1,%eax
80106e22:	75 76                	jne    80106e9a <syscall+0x1360>
80106e24:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
80106e28:	79 70                	jns    80106e9a <syscall+0x1360>
                        cprintf("TRACE: pid = %d | command name = %s | syscall = %s | return value = %d (FAILED!!)\n", proc->pid, procname, syscall_names[num2], proc->tf->eax);
80106e2a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e30:	8b 40 18             	mov    0x18(%eax),%eax
80106e33:	8b 48 1c             	mov    0x1c(%eax),%ecx
80106e36:	8b 45 a0             	mov    -0x60(%ebp),%eax
80106e39:	8b 14 85 e0 d0 10 80 	mov    -0x7fef2f20(,%eax,4),%edx
80106e40:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e46:	8b 40 10             	mov    0x10(%eax),%eax
80106e49:	83 ec 0c             	sub    $0xc,%esp
80106e4c:	51                   	push   %ecx
80106e4d:	52                   	push   %edx
80106e4e:	ff 75 a4             	pushl  -0x5c(%ebp)
80106e51:	50                   	push   %eax
80106e52:	68 e0 a3 10 80       	push   $0x8010a3e0
80106e57:	e8 4e 95 ff ff       	call   801003aa <cprintf>
80106e5c:	83 c4 20             	add    $0x20,%esp
        if(is_traced) {
80106e5f:	eb 39                	jmp    80106e9a <syscall+0x1360>
            if(num == SYS_exec && proc->tf->eax == 0) {
80106e61:	90                   	nop
        if(is_traced) {
80106e62:	eb 36                	jmp    80106e9a <syscall+0x1360>
                }
            }
        }
    } 
    else {
        cprintf("%d %s: unknown sys call %d\n", proc->pid, proc->name, num); 
80106e64:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e6a:	8d 50 6c             	lea    0x6c(%eax),%edx
80106e6d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e73:	8b 40 10             	mov    0x10(%eax),%eax
80106e76:	ff 75 e4             	pushl  -0x1c(%ebp)
80106e79:	52                   	push   %edx
80106e7a:	50                   	push   %eax
80106e7b:	68 33 a4 10 80       	push   $0x8010a433
80106e80:	e8 25 95 ff ff       	call   801003aa <cprintf>
80106e85:	83 c4 10             	add    $0x10,%esp
        proc->tf->eax = -1;
80106e88:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e8e:	8b 40 18             	mov    0x18(%eax),%eax
80106e91:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
80106e98:	eb 01                	jmp    80106e9b <syscall+0x1361>
        if(is_traced) {
80106e9a:	90                   	nop
80106e9b:	89 dc                	mov    %ebx,%esp
    }
}
80106e9d:	90                   	nop
80106e9e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106ea1:	c9                   	leave  
80106ea2:	c3                   	ret    

80106ea3 <argfd>:
// #include "kernel/trace.h"


// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int argfd(int n, int *pfd, struct file **pf) {
80106ea3:	f3 0f 1e fb          	endbr32 
80106ea7:	55                   	push   %ebp
80106ea8:	89 e5                	mov    %esp,%ebp
80106eaa:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if (argint(n, &fd) < 0)
80106ead:	83 ec 08             	sub    $0x8,%esp
80106eb0:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106eb3:	50                   	push   %eax
80106eb4:	ff 75 08             	pushl  0x8(%ebp)
80106eb7:	e8 35 e9 ff ff       	call   801057f1 <argint>
80106ebc:	83 c4 10             	add    $0x10,%esp
80106ebf:	85 c0                	test   %eax,%eax
80106ec1:	79 07                	jns    80106eca <argfd+0x27>
    return -1;
80106ec3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ec8:	eb 50                	jmp    80106f1a <argfd+0x77>
  if (fd < 0 || fd >= NOFILE || (f = proc->ofile[fd]) == 0)
80106eca:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ecd:	85 c0                	test   %eax,%eax
80106ecf:	78 21                	js     80106ef2 <argfd+0x4f>
80106ed1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ed4:	83 f8 0f             	cmp    $0xf,%eax
80106ed7:	7f 19                	jg     80106ef2 <argfd+0x4f>
80106ed9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106edf:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106ee2:	83 c2 08             	add    $0x8,%edx
80106ee5:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106ee9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106eec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106ef0:	75 07                	jne    80106ef9 <argfd+0x56>
    return -1;
80106ef2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ef7:	eb 21                	jmp    80106f1a <argfd+0x77>
  if (pfd)
80106ef9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106efd:	74 08                	je     80106f07 <argfd+0x64>
    *pfd = fd;
80106eff:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106f02:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f05:	89 10                	mov    %edx,(%eax)
  if (pf)
80106f07:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106f0b:	74 08                	je     80106f15 <argfd+0x72>
    *pf = f;
80106f0d:	8b 45 10             	mov    0x10(%ebp),%eax
80106f10:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106f13:	89 10                	mov    %edx,(%eax)
  return 0;
80106f15:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106f1a:	c9                   	leave  
80106f1b:	c3                   	ret    

80106f1c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int fdalloc(struct file *f) {
80106f1c:	f3 0f 1e fb          	endbr32 
80106f20:	55                   	push   %ebp
80106f21:	89 e5                	mov    %esp,%ebp
80106f23:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for (fd = 0; fd < NOFILE; fd++) {
80106f26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80106f2d:	eb 30                	jmp    80106f5f <fdalloc+0x43>
    if (proc->ofile[fd] == 0) {
80106f2f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f35:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106f38:	83 c2 08             	add    $0x8,%edx
80106f3b:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106f3f:	85 c0                	test   %eax,%eax
80106f41:	75 18                	jne    80106f5b <fdalloc+0x3f>
      proc->ofile[fd] = f;
80106f43:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f49:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106f4c:	8d 4a 08             	lea    0x8(%edx),%ecx
80106f4f:	8b 55 08             	mov    0x8(%ebp),%edx
80106f52:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80106f56:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106f59:	eb 0f                	jmp    80106f6a <fdalloc+0x4e>
  for (fd = 0; fd < NOFILE; fd++) {
80106f5b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106f5f:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80106f63:	7e ca                	jle    80106f2f <fdalloc+0x13>
    }
  }
  return -1;
80106f65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f6a:	c9                   	leave  
80106f6b:	c3                   	ret    

80106f6c <sys_dup>:

int sys_dup(void) {
80106f6c:	f3 0f 1e fb          	endbr32 
80106f70:	55                   	push   %ebp
80106f71:	89 e5                	mov    %esp,%ebp
80106f73:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;

  if (argfd(0, 0, &f) < 0)
80106f76:	83 ec 04             	sub    $0x4,%esp
80106f79:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106f7c:	50                   	push   %eax
80106f7d:	6a 00                	push   $0x0
80106f7f:	6a 00                	push   $0x0
80106f81:	e8 1d ff ff ff       	call   80106ea3 <argfd>
80106f86:	83 c4 10             	add    $0x10,%esp
80106f89:	85 c0                	test   %eax,%eax
80106f8b:	79 07                	jns    80106f94 <sys_dup+0x28>
    return -1;
80106f8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f92:	eb 31                	jmp    80106fc5 <sys_dup+0x59>
  if ((fd = fdalloc(f)) < 0)
80106f94:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f97:	83 ec 0c             	sub    $0xc,%esp
80106f9a:	50                   	push   %eax
80106f9b:	e8 7c ff ff ff       	call   80106f1c <fdalloc>
80106fa0:	83 c4 10             	add    $0x10,%esp
80106fa3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106fa6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106faa:	79 07                	jns    80106fb3 <sys_dup+0x47>
    return -1;
80106fac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106fb1:	eb 12                	jmp    80106fc5 <sys_dup+0x59>
  filedup(f);
80106fb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106fb6:	83 ec 0c             	sub    $0xc,%esp
80106fb9:	50                   	push   %eax
80106fba:	e8 7c a0 ff ff       	call   8010103b <filedup>
80106fbf:	83 c4 10             	add    $0x10,%esp
  return fd;
80106fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106fc5:	c9                   	leave  
80106fc6:	c3                   	ret    

80106fc7 <sys_read>:

int sys_read(void) {
80106fc7:	f3 0f 1e fb          	endbr32 
80106fcb:	55                   	push   %ebp
80106fcc:	89 e5                	mov    %esp,%ebp
80106fce:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106fd1:	83 ec 04             	sub    $0x4,%esp
80106fd4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106fd7:	50                   	push   %eax
80106fd8:	6a 00                	push   $0x0
80106fda:	6a 00                	push   $0x0
80106fdc:	e8 c2 fe ff ff       	call   80106ea3 <argfd>
80106fe1:	83 c4 10             	add    $0x10,%esp
80106fe4:	85 c0                	test   %eax,%eax
80106fe6:	78 2e                	js     80107016 <sys_read+0x4f>
80106fe8:	83 ec 08             	sub    $0x8,%esp
80106feb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106fee:	50                   	push   %eax
80106fef:	6a 02                	push   $0x2
80106ff1:	e8 fb e7 ff ff       	call   801057f1 <argint>
80106ff6:	83 c4 10             	add    $0x10,%esp
80106ff9:	85 c0                	test   %eax,%eax
80106ffb:	78 19                	js     80107016 <sys_read+0x4f>
80106ffd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107000:	83 ec 04             	sub    $0x4,%esp
80107003:	50                   	push   %eax
80107004:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107007:	50                   	push   %eax
80107008:	6a 01                	push   $0x1
8010700a:	e8 0e e8 ff ff       	call   8010581d <argptr>
8010700f:	83 c4 10             	add    $0x10,%esp
80107012:	85 c0                	test   %eax,%eax
80107014:	79 07                	jns    8010701d <sys_read+0x56>
    return -1;
80107016:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010701b:	eb 17                	jmp    80107034 <sys_read+0x6d>
  return fileread(f, p, n);
8010701d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80107020:	8b 55 ec             	mov    -0x14(%ebp),%edx
80107023:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107026:	83 ec 04             	sub    $0x4,%esp
80107029:	51                   	push   %ecx
8010702a:	52                   	push   %edx
8010702b:	50                   	push   %eax
8010702c:	e8 a6 a1 ff ff       	call   801011d7 <fileread>
80107031:	83 c4 10             	add    $0x10,%esp
}
80107034:	c9                   	leave  
80107035:	c3                   	ret    

80107036 <sys_write>:

int sys_write(void) {
80107036:	f3 0f 1e fb          	endbr32 
8010703a:	55                   	push   %ebp
8010703b:	89 e5                	mov    %esp,%ebp
8010703d:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80107040:	83 ec 04             	sub    $0x4,%esp
80107043:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107046:	50                   	push   %eax
80107047:	6a 00                	push   $0x0
80107049:	6a 00                	push   $0x0
8010704b:	e8 53 fe ff ff       	call   80106ea3 <argfd>
80107050:	83 c4 10             	add    $0x10,%esp
80107053:	85 c0                	test   %eax,%eax
80107055:	78 2e                	js     80107085 <sys_write+0x4f>
80107057:	83 ec 08             	sub    $0x8,%esp
8010705a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010705d:	50                   	push   %eax
8010705e:	6a 02                	push   $0x2
80107060:	e8 8c e7 ff ff       	call   801057f1 <argint>
80107065:	83 c4 10             	add    $0x10,%esp
80107068:	85 c0                	test   %eax,%eax
8010706a:	78 19                	js     80107085 <sys_write+0x4f>
8010706c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010706f:	83 ec 04             	sub    $0x4,%esp
80107072:	50                   	push   %eax
80107073:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107076:	50                   	push   %eax
80107077:	6a 01                	push   $0x1
80107079:	e8 9f e7 ff ff       	call   8010581d <argptr>
8010707e:	83 c4 10             	add    $0x10,%esp
80107081:	85 c0                	test   %eax,%eax
80107083:	79 07                	jns    8010708c <sys_write+0x56>
    return -1;
80107085:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010708a:	eb 17                	jmp    801070a3 <sys_write+0x6d>
  return filewrite(f, p, n);
8010708c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010708f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80107092:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107095:	83 ec 04             	sub    $0x4,%esp
80107098:	51                   	push   %ecx
80107099:	52                   	push   %edx
8010709a:	50                   	push   %eax
8010709b:	e8 f3 a1 ff ff       	call   80101293 <filewrite>
801070a0:	83 c4 10             	add    $0x10,%esp
}
801070a3:	c9                   	leave  
801070a4:	c3                   	ret    

801070a5 <sys_close>:


int sys_close(void) {
801070a5:	f3 0f 1e fb          	endbr32 
801070a9:	55                   	push   %ebp
801070aa:	89 e5                	mov    %esp,%ebp
801070ac:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if (argfd(0, &fd, &f) < 0)
801070af:	83 ec 04             	sub    $0x4,%esp
801070b2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801070b5:	50                   	push   %eax
801070b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801070b9:	50                   	push   %eax
801070ba:	6a 00                	push   $0x0
801070bc:	e8 e2 fd ff ff       	call   80106ea3 <argfd>
801070c1:	83 c4 10             	add    $0x10,%esp
801070c4:	85 c0                	test   %eax,%eax
801070c6:	79 07                	jns    801070cf <sys_close+0x2a>
    return -1;
801070c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070cd:	eb 28                	jmp    801070f7 <sys_close+0x52>
  proc->ofile[fd] = 0;
801070cf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801070d8:	83 c2 08             	add    $0x8,%edx
801070db:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801070e2:	00 
  fileclose(f);
801070e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801070e6:	83 ec 0c             	sub    $0xc,%esp
801070e9:	50                   	push   %eax
801070ea:	e8 a1 9f ff ff       	call   80101090 <fileclose>
801070ef:	83 c4 10             	add    $0x10,%esp
  return 0;
801070f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801070f7:	c9                   	leave  
801070f8:	c3                   	ret    

801070f9 <sys_fstat>:

int sys_fstat(void) {
801070f9:	f3 0f 1e fb          	endbr32 
801070fd:	55                   	push   %ebp
801070fe:	89 e5                	mov    %esp,%ebp
80107100:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if (argfd(0, 0, &f) < 0 || argptr(1, (void *)&st, sizeof(*st)) < 0)
80107103:	83 ec 04             	sub    $0x4,%esp
80107106:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107109:	50                   	push   %eax
8010710a:	6a 00                	push   $0x0
8010710c:	6a 00                	push   $0x0
8010710e:	e8 90 fd ff ff       	call   80106ea3 <argfd>
80107113:	83 c4 10             	add    $0x10,%esp
80107116:	85 c0                	test   %eax,%eax
80107118:	78 17                	js     80107131 <sys_fstat+0x38>
8010711a:	83 ec 04             	sub    $0x4,%esp
8010711d:	6a 14                	push   $0x14
8010711f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107122:	50                   	push   %eax
80107123:	6a 01                	push   $0x1
80107125:	e8 f3 e6 ff ff       	call   8010581d <argptr>
8010712a:	83 c4 10             	add    $0x10,%esp
8010712d:	85 c0                	test   %eax,%eax
8010712f:	79 07                	jns    80107138 <sys_fstat+0x3f>
    return -1;
80107131:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107136:	eb 13                	jmp    8010714b <sys_fstat+0x52>
  return filestat(f, st);
80107138:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010713b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010713e:	83 ec 08             	sub    $0x8,%esp
80107141:	52                   	push   %edx
80107142:	50                   	push   %eax
80107143:	e8 34 a0 ff ff       	call   8010117c <filestat>
80107148:	83 c4 10             	add    $0x10,%esp
}
8010714b:	c9                   	leave  
8010714c:	c3                   	ret    

8010714d <sys_link>:

// Create the path new as a link to the same inode as old.
int sys_link(void) {
8010714d:	f3 0f 1e fb          	endbr32 
80107151:	55                   	push   %ebp
80107152:	89 e5                	mov    %esp,%ebp
80107154:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if (argstr(0, &old) < 0 || argstr(1, &new) < 0)
80107157:	83 ec 08             	sub    $0x8,%esp
8010715a:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010715d:	50                   	push   %eax
8010715e:	6a 00                	push   $0x0
80107160:	e8 19 e7 ff ff       	call   8010587e <argstr>
80107165:	83 c4 10             	add    $0x10,%esp
80107168:	85 c0                	test   %eax,%eax
8010716a:	78 15                	js     80107181 <sys_link+0x34>
8010716c:	83 ec 08             	sub    $0x8,%esp
8010716f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80107172:	50                   	push   %eax
80107173:	6a 01                	push   $0x1
80107175:	e8 04 e7 ff ff       	call   8010587e <argstr>
8010717a:	83 c4 10             	add    $0x10,%esp
8010717d:	85 c0                	test   %eax,%eax
8010717f:	79 0a                	jns    8010718b <sys_link+0x3e>
    return -1;
80107181:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107186:	e9 68 01 00 00       	jmp    801072f3 <sys_link+0x1a6>

  begin_op();
8010718b:	e8 d9 c4 ff ff       	call   80103669 <begin_op>
  if ((ip = namei(old)) == 0) {
80107190:	8b 45 d8             	mov    -0x28(%ebp),%eax
80107193:	83 ec 0c             	sub    $0xc,%esp
80107196:	50                   	push   %eax
80107197:	e8 2a b4 ff ff       	call   801025c6 <namei>
8010719c:	83 c4 10             	add    $0x10,%esp
8010719f:	89 45 f4             	mov    %eax,-0xc(%ebp)
801071a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801071a6:	75 0f                	jne    801071b7 <sys_link+0x6a>
    end_op();
801071a8:	e8 4c c5 ff ff       	call   801036f9 <end_op>
    return -1;
801071ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071b2:	e9 3c 01 00 00       	jmp    801072f3 <sys_link+0x1a6>
  }

  ilock(ip);
801071b7:	83 ec 0c             	sub    $0xc,%esp
801071ba:	ff 75 f4             	pushl  -0xc(%ebp)
801071bd:	e8 1b a8 ff ff       	call   801019dd <ilock>
801071c2:	83 c4 10             	add    $0x10,%esp
  if (ip->type == T_DIR) {
801071c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071c8:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801071cc:	66 83 f8 01          	cmp    $0x1,%ax
801071d0:	75 1d                	jne    801071ef <sys_link+0xa2>
    iunlockput(ip);
801071d2:	83 ec 0c             	sub    $0xc,%esp
801071d5:	ff 75 f4             	pushl  -0xc(%ebp)
801071d8:	e8 cc aa ff ff       	call   80101ca9 <iunlockput>
801071dd:	83 c4 10             	add    $0x10,%esp
    end_op();
801071e0:	e8 14 c5 ff ff       	call   801036f9 <end_op>
    return -1;
801071e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071ea:	e9 04 01 00 00       	jmp    801072f3 <sys_link+0x1a6>
  }

  ip->nlink++;
801071ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071f2:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801071f6:	83 c0 01             	add    $0x1,%eax
801071f9:	89 c2                	mov    %eax,%edx
801071fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071fe:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80107202:	83 ec 0c             	sub    $0xc,%esp
80107205:	ff 75 f4             	pushl  -0xc(%ebp)
80107208:	e8 ea a5 ff ff       	call   801017f7 <iupdate>
8010720d:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80107210:	83 ec 0c             	sub    $0xc,%esp
80107213:	ff 75 f4             	pushl  -0xc(%ebp)
80107216:	e8 24 a9 ff ff       	call   80101b3f <iunlock>
8010721b:	83 c4 10             	add    $0x10,%esp

  if ((dp = nameiparent(new, name)) == 0)
8010721e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107221:	83 ec 08             	sub    $0x8,%esp
80107224:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80107227:	52                   	push   %edx
80107228:	50                   	push   %eax
80107229:	e8 b8 b3 ff ff       	call   801025e6 <nameiparent>
8010722e:	83 c4 10             	add    $0x10,%esp
80107231:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107234:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107238:	74 71                	je     801072ab <sys_link+0x15e>
    goto bad;
  ilock(dp);
8010723a:	83 ec 0c             	sub    $0xc,%esp
8010723d:	ff 75 f0             	pushl  -0x10(%ebp)
80107240:	e8 98 a7 ff ff       	call   801019dd <ilock>
80107245:	83 c4 10             	add    $0x10,%esp
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
80107248:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010724b:	8b 10                	mov    (%eax),%edx
8010724d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107250:	8b 00                	mov    (%eax),%eax
80107252:	39 c2                	cmp    %eax,%edx
80107254:	75 1d                	jne    80107273 <sys_link+0x126>
80107256:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107259:	8b 40 04             	mov    0x4(%eax),%eax
8010725c:	83 ec 04             	sub    $0x4,%esp
8010725f:	50                   	push   %eax
80107260:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80107263:	50                   	push   %eax
80107264:	ff 75 f0             	pushl  -0x10(%ebp)
80107267:	e8 b6 b0 ff ff       	call   80102322 <dirlink>
8010726c:	83 c4 10             	add    $0x10,%esp
8010726f:	85 c0                	test   %eax,%eax
80107271:	79 10                	jns    80107283 <sys_link+0x136>
    iunlockput(dp);
80107273:	83 ec 0c             	sub    $0xc,%esp
80107276:	ff 75 f0             	pushl  -0x10(%ebp)
80107279:	e8 2b aa ff ff       	call   80101ca9 <iunlockput>
8010727e:	83 c4 10             	add    $0x10,%esp
    goto bad;
80107281:	eb 29                	jmp    801072ac <sys_link+0x15f>
  }
  iunlockput(dp);
80107283:	83 ec 0c             	sub    $0xc,%esp
80107286:	ff 75 f0             	pushl  -0x10(%ebp)
80107289:	e8 1b aa ff ff       	call   80101ca9 <iunlockput>
8010728e:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80107291:	83 ec 0c             	sub    $0xc,%esp
80107294:	ff 75 f4             	pushl  -0xc(%ebp)
80107297:	e8 19 a9 ff ff       	call   80101bb5 <iput>
8010729c:	83 c4 10             	add    $0x10,%esp

  end_op();
8010729f:	e8 55 c4 ff ff       	call   801036f9 <end_op>

  return 0;
801072a4:	b8 00 00 00 00       	mov    $0x0,%eax
801072a9:	eb 48                	jmp    801072f3 <sys_link+0x1a6>
    goto bad;
801072ab:	90                   	nop

bad:
  ilock(ip);
801072ac:	83 ec 0c             	sub    $0xc,%esp
801072af:	ff 75 f4             	pushl  -0xc(%ebp)
801072b2:	e8 26 a7 ff ff       	call   801019dd <ilock>
801072b7:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
801072ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072bd:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801072c1:	83 e8 01             	sub    $0x1,%eax
801072c4:	89 c2                	mov    %eax,%edx
801072c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072c9:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801072cd:	83 ec 0c             	sub    $0xc,%esp
801072d0:	ff 75 f4             	pushl  -0xc(%ebp)
801072d3:	e8 1f a5 ff ff       	call   801017f7 <iupdate>
801072d8:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
801072db:	83 ec 0c             	sub    $0xc,%esp
801072de:	ff 75 f4             	pushl  -0xc(%ebp)
801072e1:	e8 c3 a9 ff ff       	call   80101ca9 <iunlockput>
801072e6:	83 c4 10             	add    $0x10,%esp
  end_op();
801072e9:	e8 0b c4 ff ff       	call   801036f9 <end_op>
  return -1;
801072ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801072f3:	c9                   	leave  
801072f4:	c3                   	ret    

801072f5 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int isdirempty(struct inode *dp) {
801072f5:	f3 0f 1e fb          	endbr32 
801072f9:	55                   	push   %ebp
801072fa:	89 e5                	mov    %esp,%ebp
801072fc:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
801072ff:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80107306:	eb 40                	jmp    80107348 <isdirempty+0x53>
    if (readi(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
80107308:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010730b:	6a 10                	push   $0x10
8010730d:	50                   	push   %eax
8010730e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107311:	50                   	push   %eax
80107312:	ff 75 08             	pushl  0x8(%ebp)
80107315:	e8 48 ac ff ff       	call   80101f62 <readi>
8010731a:	83 c4 10             	add    $0x10,%esp
8010731d:	83 f8 10             	cmp    $0x10,%eax
80107320:	74 0d                	je     8010732f <isdirempty+0x3a>
      panic("isdirempty: readi");
80107322:	83 ec 0c             	sub    $0xc,%esp
80107325:	68 4f a4 10 80       	push   $0x8010a44f
8010732a:	e8 34 92 ff ff       	call   80100563 <panic>
    if (de.inum != 0)
8010732f:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80107333:	66 85 c0             	test   %ax,%ax
80107336:	74 07                	je     8010733f <isdirempty+0x4a>
      return 0;
80107338:	b8 00 00 00 00       	mov    $0x0,%eax
8010733d:	eb 1b                	jmp    8010735a <isdirempty+0x65>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
8010733f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107342:	83 c0 10             	add    $0x10,%eax
80107345:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107348:	8b 45 08             	mov    0x8(%ebp),%eax
8010734b:	8b 50 18             	mov    0x18(%eax),%edx
8010734e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107351:	39 c2                	cmp    %eax,%edx
80107353:	77 b3                	ja     80107308 <isdirempty+0x13>
  }
  return 1;
80107355:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010735a:	c9                   	leave  
8010735b:	c3                   	ret    

8010735c <sys_unlink>:

// PAGEBREAK!
int sys_unlink(void) {
8010735c:	f3 0f 1e fb          	endbr32 
80107360:	55                   	push   %ebp
80107361:	89 e5                	mov    %esp,%ebp
80107363:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if (argstr(0, &path) < 0)
80107366:	83 ec 08             	sub    $0x8,%esp
80107369:	8d 45 cc             	lea    -0x34(%ebp),%eax
8010736c:	50                   	push   %eax
8010736d:	6a 00                	push   $0x0
8010736f:	e8 0a e5 ff ff       	call   8010587e <argstr>
80107374:	83 c4 10             	add    $0x10,%esp
80107377:	85 c0                	test   %eax,%eax
80107379:	79 0a                	jns    80107385 <sys_unlink+0x29>
    return -1;
8010737b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107380:	e9 bf 01 00 00       	jmp    80107544 <sys_unlink+0x1e8>

  begin_op();
80107385:	e8 df c2 ff ff       	call   80103669 <begin_op>
  if ((dp = nameiparent(path, name)) == 0) {
8010738a:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010738d:	83 ec 08             	sub    $0x8,%esp
80107390:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80107393:	52                   	push   %edx
80107394:	50                   	push   %eax
80107395:	e8 4c b2 ff ff       	call   801025e6 <nameiparent>
8010739a:	83 c4 10             	add    $0x10,%esp
8010739d:	89 45 f4             	mov    %eax,-0xc(%ebp)
801073a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801073a4:	75 0f                	jne    801073b5 <sys_unlink+0x59>
    end_op();
801073a6:	e8 4e c3 ff ff       	call   801036f9 <end_op>
    return -1;
801073ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073b0:	e9 8f 01 00 00       	jmp    80107544 <sys_unlink+0x1e8>
  }

  ilock(dp);
801073b5:	83 ec 0c             	sub    $0xc,%esp
801073b8:	ff 75 f4             	pushl  -0xc(%ebp)
801073bb:	e8 1d a6 ff ff       	call   801019dd <ilock>
801073c0:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801073c3:	83 ec 08             	sub    $0x8,%esp
801073c6:	68 61 a4 10 80       	push   $0x8010a461
801073cb:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801073ce:	50                   	push   %eax
801073cf:	e8 71 ae ff ff       	call   80102245 <namecmp>
801073d4:	83 c4 10             	add    $0x10,%esp
801073d7:	85 c0                	test   %eax,%eax
801073d9:	0f 84 49 01 00 00    	je     80107528 <sys_unlink+0x1cc>
801073df:	83 ec 08             	sub    $0x8,%esp
801073e2:	68 63 a4 10 80       	push   $0x8010a463
801073e7:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801073ea:	50                   	push   %eax
801073eb:	e8 55 ae ff ff       	call   80102245 <namecmp>
801073f0:	83 c4 10             	add    $0x10,%esp
801073f3:	85 c0                	test   %eax,%eax
801073f5:	0f 84 2d 01 00 00    	je     80107528 <sys_unlink+0x1cc>
    goto bad;

  if ((ip = dirlookup(dp, name, &off)) == 0)
801073fb:	83 ec 04             	sub    $0x4,%esp
801073fe:	8d 45 c8             	lea    -0x38(%ebp),%eax
80107401:	50                   	push   %eax
80107402:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80107405:	50                   	push   %eax
80107406:	ff 75 f4             	pushl  -0xc(%ebp)
80107409:	e8 56 ae ff ff       	call   80102264 <dirlookup>
8010740e:	83 c4 10             	add    $0x10,%esp
80107411:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107414:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107418:	0f 84 0d 01 00 00    	je     8010752b <sys_unlink+0x1cf>
    goto bad;
  ilock(ip);
8010741e:	83 ec 0c             	sub    $0xc,%esp
80107421:	ff 75 f0             	pushl  -0x10(%ebp)
80107424:	e8 b4 a5 ff ff       	call   801019dd <ilock>
80107429:	83 c4 10             	add    $0x10,%esp

  if (ip->nlink < 1)
8010742c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010742f:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80107433:	66 85 c0             	test   %ax,%ax
80107436:	7f 0d                	jg     80107445 <sys_unlink+0xe9>
    panic("unlink: nlink < 1");
80107438:	83 ec 0c             	sub    $0xc,%esp
8010743b:	68 66 a4 10 80       	push   $0x8010a466
80107440:	e8 1e 91 ff ff       	call   80100563 <panic>
  if (ip->type == T_DIR && !isdirempty(ip)) {
80107445:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107448:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010744c:	66 83 f8 01          	cmp    $0x1,%ax
80107450:	75 25                	jne    80107477 <sys_unlink+0x11b>
80107452:	83 ec 0c             	sub    $0xc,%esp
80107455:	ff 75 f0             	pushl  -0x10(%ebp)
80107458:	e8 98 fe ff ff       	call   801072f5 <isdirempty>
8010745d:	83 c4 10             	add    $0x10,%esp
80107460:	85 c0                	test   %eax,%eax
80107462:	75 13                	jne    80107477 <sys_unlink+0x11b>
    iunlockput(ip);
80107464:	83 ec 0c             	sub    $0xc,%esp
80107467:	ff 75 f0             	pushl  -0x10(%ebp)
8010746a:	e8 3a a8 ff ff       	call   80101ca9 <iunlockput>
8010746f:	83 c4 10             	add    $0x10,%esp
    goto bad;
80107472:	e9 b5 00 00 00       	jmp    8010752c <sys_unlink+0x1d0>
  }

  memset(&de, 0, sizeof(de));
80107477:	83 ec 04             	sub    $0x4,%esp
8010747a:	6a 10                	push   $0x10
8010747c:	6a 00                	push   $0x0
8010747e:	8d 45 e0             	lea    -0x20(%ebp),%eax
80107481:	50                   	push   %eax
80107482:	e8 1d e0 ff ff       	call   801054a4 <memset>
80107487:	83 c4 10             	add    $0x10,%esp
  if (writei(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
8010748a:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010748d:	6a 10                	push   $0x10
8010748f:	50                   	push   %eax
80107490:	8d 45 e0             	lea    -0x20(%ebp),%eax
80107493:	50                   	push   %eax
80107494:	ff 75 f4             	pushl  -0xc(%ebp)
80107497:	e8 1f ac ff ff       	call   801020bb <writei>
8010749c:	83 c4 10             	add    $0x10,%esp
8010749f:	83 f8 10             	cmp    $0x10,%eax
801074a2:	74 0d                	je     801074b1 <sys_unlink+0x155>
    panic("unlink: writei");
801074a4:	83 ec 0c             	sub    $0xc,%esp
801074a7:	68 78 a4 10 80       	push   $0x8010a478
801074ac:	e8 b2 90 ff ff       	call   80100563 <panic>
  if (ip->type == T_DIR) {
801074b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801074b4:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801074b8:	66 83 f8 01          	cmp    $0x1,%ax
801074bc:	75 21                	jne    801074df <sys_unlink+0x183>
    dp->nlink--;
801074be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074c1:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801074c5:	83 e8 01             	sub    $0x1,%eax
801074c8:	89 c2                	mov    %eax,%edx
801074ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074cd:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801074d1:	83 ec 0c             	sub    $0xc,%esp
801074d4:	ff 75 f4             	pushl  -0xc(%ebp)
801074d7:	e8 1b a3 ff ff       	call   801017f7 <iupdate>
801074dc:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
801074df:	83 ec 0c             	sub    $0xc,%esp
801074e2:	ff 75 f4             	pushl  -0xc(%ebp)
801074e5:	e8 bf a7 ff ff       	call   80101ca9 <iunlockput>
801074ea:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
801074ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801074f0:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801074f4:	83 e8 01             	sub    $0x1,%eax
801074f7:	89 c2                	mov    %eax,%edx
801074f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801074fc:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80107500:	83 ec 0c             	sub    $0xc,%esp
80107503:	ff 75 f0             	pushl  -0x10(%ebp)
80107506:	e8 ec a2 ff ff       	call   801017f7 <iupdate>
8010750b:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
8010750e:	83 ec 0c             	sub    $0xc,%esp
80107511:	ff 75 f0             	pushl  -0x10(%ebp)
80107514:	e8 90 a7 ff ff       	call   80101ca9 <iunlockput>
80107519:	83 c4 10             	add    $0x10,%esp

  end_op();
8010751c:	e8 d8 c1 ff ff       	call   801036f9 <end_op>

  return 0;
80107521:	b8 00 00 00 00       	mov    $0x0,%eax
80107526:	eb 1c                	jmp    80107544 <sys_unlink+0x1e8>
    goto bad;
80107528:	90                   	nop
80107529:	eb 01                	jmp    8010752c <sys_unlink+0x1d0>
    goto bad;
8010752b:	90                   	nop

bad:
  iunlockput(dp);
8010752c:	83 ec 0c             	sub    $0xc,%esp
8010752f:	ff 75 f4             	pushl  -0xc(%ebp)
80107532:	e8 72 a7 ff ff       	call   80101ca9 <iunlockput>
80107537:	83 c4 10             	add    $0x10,%esp
  end_op();
8010753a:	e8 ba c1 ff ff       	call   801036f9 <end_op>
  return -1;
8010753f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107544:	c9                   	leave  
80107545:	c3                   	ret    

80107546 <create>:

static struct inode *create(char *path, short type, short major, short minor) {
80107546:	f3 0f 1e fb          	endbr32 
8010754a:	55                   	push   %ebp
8010754b:	89 e5                	mov    %esp,%ebp
8010754d:	83 ec 38             	sub    $0x38,%esp
80107550:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107553:	8b 55 10             	mov    0x10(%ebp),%edx
80107556:	8b 45 14             	mov    0x14(%ebp),%eax
80107559:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
8010755d:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80107561:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
80107565:	83 ec 08             	sub    $0x8,%esp
80107568:	8d 45 de             	lea    -0x22(%ebp),%eax
8010756b:	50                   	push   %eax
8010756c:	ff 75 08             	pushl  0x8(%ebp)
8010756f:	e8 72 b0 ff ff       	call   801025e6 <nameiparent>
80107574:	83 c4 10             	add    $0x10,%esp
80107577:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010757a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010757e:	75 0a                	jne    8010758a <create+0x44>
    return 0;
80107580:	b8 00 00 00 00       	mov    $0x0,%eax
80107585:	e9 90 01 00 00       	jmp    8010771a <create+0x1d4>
  ilock(dp);
8010758a:	83 ec 0c             	sub    $0xc,%esp
8010758d:	ff 75 f4             	pushl  -0xc(%ebp)
80107590:	e8 48 a4 ff ff       	call   801019dd <ilock>
80107595:	83 c4 10             	add    $0x10,%esp

  if ((ip = dirlookup(dp, name, &off)) != 0) {
80107598:	83 ec 04             	sub    $0x4,%esp
8010759b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010759e:	50                   	push   %eax
8010759f:	8d 45 de             	lea    -0x22(%ebp),%eax
801075a2:	50                   	push   %eax
801075a3:	ff 75 f4             	pushl  -0xc(%ebp)
801075a6:	e8 b9 ac ff ff       	call   80102264 <dirlookup>
801075ab:	83 c4 10             	add    $0x10,%esp
801075ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
801075b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801075b5:	74 50                	je     80107607 <create+0xc1>
    iunlockput(dp);
801075b7:	83 ec 0c             	sub    $0xc,%esp
801075ba:	ff 75 f4             	pushl  -0xc(%ebp)
801075bd:	e8 e7 a6 ff ff       	call   80101ca9 <iunlockput>
801075c2:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
801075c5:	83 ec 0c             	sub    $0xc,%esp
801075c8:	ff 75 f0             	pushl  -0x10(%ebp)
801075cb:	e8 0d a4 ff ff       	call   801019dd <ilock>
801075d0:	83 c4 10             	add    $0x10,%esp
    if (type == T_FILE && ip->type == T_FILE)
801075d3:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801075d8:	75 15                	jne    801075ef <create+0xa9>
801075da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801075dd:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801075e1:	66 83 f8 02          	cmp    $0x2,%ax
801075e5:	75 08                	jne    801075ef <create+0xa9>
      return ip;
801075e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801075ea:	e9 2b 01 00 00       	jmp    8010771a <create+0x1d4>
    iunlockput(ip);
801075ef:	83 ec 0c             	sub    $0xc,%esp
801075f2:	ff 75 f0             	pushl  -0x10(%ebp)
801075f5:	e8 af a6 ff ff       	call   80101ca9 <iunlockput>
801075fa:	83 c4 10             	add    $0x10,%esp
    return 0;
801075fd:	b8 00 00 00 00       	mov    $0x0,%eax
80107602:	e9 13 01 00 00       	jmp    8010771a <create+0x1d4>
  }

  if ((ip = ialloc(dp->dev, type)) == 0)
80107607:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
8010760b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010760e:	8b 00                	mov    (%eax),%eax
80107610:	83 ec 08             	sub    $0x8,%esp
80107613:	52                   	push   %edx
80107614:	50                   	push   %eax
80107615:	e8 02 a1 ff ff       	call   8010171c <ialloc>
8010761a:	83 c4 10             	add    $0x10,%esp
8010761d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107620:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107624:	75 0d                	jne    80107633 <create+0xed>
    panic("create: ialloc");
80107626:	83 ec 0c             	sub    $0xc,%esp
80107629:	68 87 a4 10 80       	push   $0x8010a487
8010762e:	e8 30 8f ff ff       	call   80100563 <panic>

  ilock(ip);
80107633:	83 ec 0c             	sub    $0xc,%esp
80107636:	ff 75 f0             	pushl  -0x10(%ebp)
80107639:	e8 9f a3 ff ff       	call   801019dd <ilock>
8010763e:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80107641:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107644:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80107648:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
8010764c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010764f:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80107653:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80107657:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010765a:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80107660:	83 ec 0c             	sub    $0xc,%esp
80107663:	ff 75 f0             	pushl  -0x10(%ebp)
80107666:	e8 8c a1 ff ff       	call   801017f7 <iupdate>
8010766b:	83 c4 10             	add    $0x10,%esp

  if (type == T_DIR) { // Create . and .. entries.
8010766e:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80107673:	75 6a                	jne    801076df <create+0x199>
    dp->nlink++;       // for ".."
80107675:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107678:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010767c:	83 c0 01             	add    $0x1,%eax
8010767f:	89 c2                	mov    %eax,%edx
80107681:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107684:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80107688:	83 ec 0c             	sub    $0xc,%esp
8010768b:	ff 75 f4             	pushl  -0xc(%ebp)
8010768e:	e8 64 a1 ff ff       	call   801017f7 <iupdate>
80107693:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80107696:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107699:	8b 40 04             	mov    0x4(%eax),%eax
8010769c:	83 ec 04             	sub    $0x4,%esp
8010769f:	50                   	push   %eax
801076a0:	68 61 a4 10 80       	push   $0x8010a461
801076a5:	ff 75 f0             	pushl  -0x10(%ebp)
801076a8:	e8 75 ac ff ff       	call   80102322 <dirlink>
801076ad:	83 c4 10             	add    $0x10,%esp
801076b0:	85 c0                	test   %eax,%eax
801076b2:	78 1e                	js     801076d2 <create+0x18c>
801076b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076b7:	8b 40 04             	mov    0x4(%eax),%eax
801076ba:	83 ec 04             	sub    $0x4,%esp
801076bd:	50                   	push   %eax
801076be:	68 63 a4 10 80       	push   $0x8010a463
801076c3:	ff 75 f0             	pushl  -0x10(%ebp)
801076c6:	e8 57 ac ff ff       	call   80102322 <dirlink>
801076cb:	83 c4 10             	add    $0x10,%esp
801076ce:	85 c0                	test   %eax,%eax
801076d0:	79 0d                	jns    801076df <create+0x199>
      panic("create dots");
801076d2:	83 ec 0c             	sub    $0xc,%esp
801076d5:	68 96 a4 10 80       	push   $0x8010a496
801076da:	e8 84 8e ff ff       	call   80100563 <panic>
  }

  if (dirlink(dp, name, ip->inum) < 0)
801076df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801076e2:	8b 40 04             	mov    0x4(%eax),%eax
801076e5:	83 ec 04             	sub    $0x4,%esp
801076e8:	50                   	push   %eax
801076e9:	8d 45 de             	lea    -0x22(%ebp),%eax
801076ec:	50                   	push   %eax
801076ed:	ff 75 f4             	pushl  -0xc(%ebp)
801076f0:	e8 2d ac ff ff       	call   80102322 <dirlink>
801076f5:	83 c4 10             	add    $0x10,%esp
801076f8:	85 c0                	test   %eax,%eax
801076fa:	79 0d                	jns    80107709 <create+0x1c3>
    panic("create: dirlink");
801076fc:	83 ec 0c             	sub    $0xc,%esp
801076ff:	68 a2 a4 10 80       	push   $0x8010a4a2
80107704:	e8 5a 8e ff ff       	call   80100563 <panic>

  iunlockput(dp);
80107709:	83 ec 0c             	sub    $0xc,%esp
8010770c:	ff 75 f4             	pushl  -0xc(%ebp)
8010770f:	e8 95 a5 ff ff       	call   80101ca9 <iunlockput>
80107714:	83 c4 10             	add    $0x10,%esp

  return ip;
80107717:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010771a:	c9                   	leave  
8010771b:	c3                   	ret    

8010771c <sys_open>:

int sys_open(void) {
8010771c:	f3 0f 1e fb          	endbr32 
80107720:	55                   	push   %ebp
80107721:	89 e5                	mov    %esp,%ebp
80107723:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if (argstr(0, &path) < 0 || argint(1, &omode) < 0)
80107726:	83 ec 08             	sub    $0x8,%esp
80107729:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010772c:	50                   	push   %eax
8010772d:	6a 00                	push   $0x0
8010772f:	e8 4a e1 ff ff       	call   8010587e <argstr>
80107734:	83 c4 10             	add    $0x10,%esp
80107737:	85 c0                	test   %eax,%eax
80107739:	78 15                	js     80107750 <sys_open+0x34>
8010773b:	83 ec 08             	sub    $0x8,%esp
8010773e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107741:	50                   	push   %eax
80107742:	6a 01                	push   $0x1
80107744:	e8 a8 e0 ff ff       	call   801057f1 <argint>
80107749:	83 c4 10             	add    $0x10,%esp
8010774c:	85 c0                	test   %eax,%eax
8010774e:	79 0a                	jns    8010775a <sys_open+0x3e>
    return -1;
80107750:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107755:	e9 61 01 00 00       	jmp    801078bb <sys_open+0x19f>

  begin_op();
8010775a:	e8 0a bf ff ff       	call   80103669 <begin_op>

  if (omode & O_CREATE) {
8010775f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107762:	25 00 02 00 00       	and    $0x200,%eax
80107767:	85 c0                	test   %eax,%eax
80107769:	74 2a                	je     80107795 <sys_open+0x79>
    ip = create(path, T_FILE, 0, 0);
8010776b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010776e:	6a 00                	push   $0x0
80107770:	6a 00                	push   $0x0
80107772:	6a 02                	push   $0x2
80107774:	50                   	push   %eax
80107775:	e8 cc fd ff ff       	call   80107546 <create>
8010777a:	83 c4 10             	add    $0x10,%esp
8010777d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ip == 0) {
80107780:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107784:	75 75                	jne    801077fb <sys_open+0xdf>
      end_op();
80107786:	e8 6e bf ff ff       	call   801036f9 <end_op>
      return -1;
8010778b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107790:	e9 26 01 00 00       	jmp    801078bb <sys_open+0x19f>
    }
  } else {
    if ((ip = namei(path)) == 0) {
80107795:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107798:	83 ec 0c             	sub    $0xc,%esp
8010779b:	50                   	push   %eax
8010779c:	e8 25 ae ff ff       	call   801025c6 <namei>
801077a1:	83 c4 10             	add    $0x10,%esp
801077a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801077a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801077ab:	75 0f                	jne    801077bc <sys_open+0xa0>
      end_op();
801077ad:	e8 47 bf ff ff       	call   801036f9 <end_op>
      return -1;
801077b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801077b7:	e9 ff 00 00 00       	jmp    801078bb <sys_open+0x19f>
    }
    ilock(ip);
801077bc:	83 ec 0c             	sub    $0xc,%esp
801077bf:	ff 75 f4             	pushl  -0xc(%ebp)
801077c2:	e8 16 a2 ff ff       	call   801019dd <ilock>
801077c7:	83 c4 10             	add    $0x10,%esp
    if (ip->type == T_DIR && omode != O_RDONLY) {
801077ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077cd:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801077d1:	66 83 f8 01          	cmp    $0x1,%ax
801077d5:	75 24                	jne    801077fb <sys_open+0xdf>
801077d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077da:	85 c0                	test   %eax,%eax
801077dc:	74 1d                	je     801077fb <sys_open+0xdf>
      iunlockput(ip);
801077de:	83 ec 0c             	sub    $0xc,%esp
801077e1:	ff 75 f4             	pushl  -0xc(%ebp)
801077e4:	e8 c0 a4 ff ff       	call   80101ca9 <iunlockput>
801077e9:	83 c4 10             	add    $0x10,%esp
      end_op();
801077ec:	e8 08 bf ff ff       	call   801036f9 <end_op>
      return -1;
801077f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801077f6:	e9 c0 00 00 00       	jmp    801078bb <sys_open+0x19f>
    }
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
801077fb:	e8 ca 97 ff ff       	call   80100fca <filealloc>
80107800:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107803:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107807:	74 17                	je     80107820 <sys_open+0x104>
80107809:	83 ec 0c             	sub    $0xc,%esp
8010780c:	ff 75 f0             	pushl  -0x10(%ebp)
8010780f:	e8 08 f7 ff ff       	call   80106f1c <fdalloc>
80107814:	83 c4 10             	add    $0x10,%esp
80107817:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010781a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010781e:	79 2e                	jns    8010784e <sys_open+0x132>
    if (f)
80107820:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107824:	74 0e                	je     80107834 <sys_open+0x118>
      fileclose(f);
80107826:	83 ec 0c             	sub    $0xc,%esp
80107829:	ff 75 f0             	pushl  -0x10(%ebp)
8010782c:	e8 5f 98 ff ff       	call   80101090 <fileclose>
80107831:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80107834:	83 ec 0c             	sub    $0xc,%esp
80107837:	ff 75 f4             	pushl  -0xc(%ebp)
8010783a:	e8 6a a4 ff ff       	call   80101ca9 <iunlockput>
8010783f:	83 c4 10             	add    $0x10,%esp
    end_op();
80107842:	e8 b2 be ff ff       	call   801036f9 <end_op>
    return -1;
80107847:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010784c:	eb 6d                	jmp    801078bb <sys_open+0x19f>
  }
  iunlock(ip);
8010784e:	83 ec 0c             	sub    $0xc,%esp
80107851:	ff 75 f4             	pushl  -0xc(%ebp)
80107854:	e8 e6 a2 ff ff       	call   80101b3f <iunlock>
80107859:	83 c4 10             	add    $0x10,%esp
  end_op();
8010785c:	e8 98 be ff ff       	call   801036f9 <end_op>

  f->type = FD_INODE;
80107861:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107864:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
8010786a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010786d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107870:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80107873:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107876:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
8010787d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107880:	83 e0 01             	and    $0x1,%eax
80107883:	85 c0                	test   %eax,%eax
80107885:	0f 94 c0             	sete   %al
80107888:	89 c2                	mov    %eax,%edx
8010788a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010788d:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80107890:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107893:	83 e0 01             	and    $0x1,%eax
80107896:	85 c0                	test   %eax,%eax
80107898:	75 0a                	jne    801078a4 <sys_open+0x188>
8010789a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010789d:	83 e0 02             	and    $0x2,%eax
801078a0:	85 c0                	test   %eax,%eax
801078a2:	74 07                	je     801078ab <sys_open+0x18f>
801078a4:	b8 01 00 00 00       	mov    $0x1,%eax
801078a9:	eb 05                	jmp    801078b0 <sys_open+0x194>
801078ab:	b8 00 00 00 00       	mov    $0x0,%eax
801078b0:	89 c2                	mov    %eax,%edx
801078b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078b5:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801078b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801078bb:	c9                   	leave  
801078bc:	c3                   	ret    

801078bd <sys_mkdir>:

int sys_mkdir(void) {
801078bd:	f3 0f 1e fb          	endbr32 
801078c1:	55                   	push   %ebp
801078c2:	89 e5                	mov    %esp,%ebp
801078c4:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801078c7:	e8 9d bd ff ff       	call   80103669 <begin_op>
  if (argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
801078cc:	83 ec 08             	sub    $0x8,%esp
801078cf:	8d 45 f0             	lea    -0x10(%ebp),%eax
801078d2:	50                   	push   %eax
801078d3:	6a 00                	push   $0x0
801078d5:	e8 a4 df ff ff       	call   8010587e <argstr>
801078da:	83 c4 10             	add    $0x10,%esp
801078dd:	85 c0                	test   %eax,%eax
801078df:	78 1b                	js     801078fc <sys_mkdir+0x3f>
801078e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078e4:	6a 00                	push   $0x0
801078e6:	6a 00                	push   $0x0
801078e8:	6a 01                	push   $0x1
801078ea:	50                   	push   %eax
801078eb:	e8 56 fc ff ff       	call   80107546 <create>
801078f0:	83 c4 10             	add    $0x10,%esp
801078f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801078f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801078fa:	75 0c                	jne    80107908 <sys_mkdir+0x4b>
    end_op();
801078fc:	e8 f8 bd ff ff       	call   801036f9 <end_op>
    return -1;
80107901:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107906:	eb 18                	jmp    80107920 <sys_mkdir+0x63>
  }
  iunlockput(ip);
80107908:	83 ec 0c             	sub    $0xc,%esp
8010790b:	ff 75 f4             	pushl  -0xc(%ebp)
8010790e:	e8 96 a3 ff ff       	call   80101ca9 <iunlockput>
80107913:	83 c4 10             	add    $0x10,%esp
  end_op();
80107916:	e8 de bd ff ff       	call   801036f9 <end_op>
  return 0;
8010791b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107920:	c9                   	leave  
80107921:	c3                   	ret    

80107922 <sys_mknod>:

int sys_mknod(void) {
80107922:	f3 0f 1e fb          	endbr32 
80107926:	55                   	push   %ebp
80107927:	89 e5                	mov    %esp,%ebp
80107929:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;

  begin_op();
8010792c:	e8 38 bd ff ff       	call   80103669 <begin_op>
  if ((len = argstr(0, &path)) < 0 || argint(1, &major) < 0 ||
80107931:	83 ec 08             	sub    $0x8,%esp
80107934:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107937:	50                   	push   %eax
80107938:	6a 00                	push   $0x0
8010793a:	e8 3f df ff ff       	call   8010587e <argstr>
8010793f:	83 c4 10             	add    $0x10,%esp
80107942:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107945:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107949:	78 4f                	js     8010799a <sys_mknod+0x78>
8010794b:	83 ec 08             	sub    $0x8,%esp
8010794e:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107951:	50                   	push   %eax
80107952:	6a 01                	push   $0x1
80107954:	e8 98 de ff ff       	call   801057f1 <argint>
80107959:	83 c4 10             	add    $0x10,%esp
8010795c:	85 c0                	test   %eax,%eax
8010795e:	78 3a                	js     8010799a <sys_mknod+0x78>
      argint(2, &minor) < 0 || (ip = create(path, T_DEV, major, minor)) == 0) {
80107960:	83 ec 08             	sub    $0x8,%esp
80107963:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107966:	50                   	push   %eax
80107967:	6a 02                	push   $0x2
80107969:	e8 83 de ff ff       	call   801057f1 <argint>
8010796e:	83 c4 10             	add    $0x10,%esp
  if ((len = argstr(0, &path)) < 0 || argint(1, &major) < 0 ||
80107971:	85 c0                	test   %eax,%eax
80107973:	78 25                	js     8010799a <sys_mknod+0x78>
      argint(2, &minor) < 0 || (ip = create(path, T_DEV, major, minor)) == 0) {
80107975:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107978:	0f bf c8             	movswl %ax,%ecx
8010797b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010797e:	0f bf d0             	movswl %ax,%edx
80107981:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107984:	51                   	push   %ecx
80107985:	52                   	push   %edx
80107986:	6a 03                	push   $0x3
80107988:	50                   	push   %eax
80107989:	e8 b8 fb ff ff       	call   80107546 <create>
8010798e:	83 c4 10             	add    $0x10,%esp
80107991:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107994:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107998:	75 0c                	jne    801079a6 <sys_mknod+0x84>
    end_op();
8010799a:	e8 5a bd ff ff       	call   801036f9 <end_op>
    return -1;
8010799f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801079a4:	eb 18                	jmp    801079be <sys_mknod+0x9c>
  }
  iunlockput(ip);
801079a6:	83 ec 0c             	sub    $0xc,%esp
801079a9:	ff 75 f0             	pushl  -0x10(%ebp)
801079ac:	e8 f8 a2 ff ff       	call   80101ca9 <iunlockput>
801079b1:	83 c4 10             	add    $0x10,%esp
  end_op();
801079b4:	e8 40 bd ff ff       	call   801036f9 <end_op>
  return 0;
801079b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801079be:	c9                   	leave  
801079bf:	c3                   	ret    

801079c0 <sys_chdir>:

int sys_chdir(void) {
801079c0:	f3 0f 1e fb          	endbr32 
801079c4:	55                   	push   %ebp
801079c5:	89 e5                	mov    %esp,%ebp
801079c7:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801079ca:	e8 9a bc ff ff       	call   80103669 <begin_op>
  if (argstr(0, &path) < 0 || (ip = namei(path)) == 0) {
801079cf:	83 ec 08             	sub    $0x8,%esp
801079d2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801079d5:	50                   	push   %eax
801079d6:	6a 00                	push   $0x0
801079d8:	e8 a1 de ff ff       	call   8010587e <argstr>
801079dd:	83 c4 10             	add    $0x10,%esp
801079e0:	85 c0                	test   %eax,%eax
801079e2:	78 18                	js     801079fc <sys_chdir+0x3c>
801079e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801079e7:	83 ec 0c             	sub    $0xc,%esp
801079ea:	50                   	push   %eax
801079eb:	e8 d6 ab ff ff       	call   801025c6 <namei>
801079f0:	83 c4 10             	add    $0x10,%esp
801079f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801079f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801079fa:	75 0c                	jne    80107a08 <sys_chdir+0x48>
    end_op();
801079fc:	e8 f8 bc ff ff       	call   801036f9 <end_op>
    return -1;
80107a01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a06:	eb 6e                	jmp    80107a76 <sys_chdir+0xb6>
  }
  ilock(ip);
80107a08:	83 ec 0c             	sub    $0xc,%esp
80107a0b:	ff 75 f4             	pushl  -0xc(%ebp)
80107a0e:	e8 ca 9f ff ff       	call   801019dd <ilock>
80107a13:	83 c4 10             	add    $0x10,%esp
  if (ip->type != T_DIR) {
80107a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a19:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107a1d:	66 83 f8 01          	cmp    $0x1,%ax
80107a21:	74 1a                	je     80107a3d <sys_chdir+0x7d>
    iunlockput(ip);
80107a23:	83 ec 0c             	sub    $0xc,%esp
80107a26:	ff 75 f4             	pushl  -0xc(%ebp)
80107a29:	e8 7b a2 ff ff       	call   80101ca9 <iunlockput>
80107a2e:	83 c4 10             	add    $0x10,%esp
    end_op();
80107a31:	e8 c3 bc ff ff       	call   801036f9 <end_op>
    return -1;
80107a36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a3b:	eb 39                	jmp    80107a76 <sys_chdir+0xb6>
  }
  iunlock(ip);
80107a3d:	83 ec 0c             	sub    $0xc,%esp
80107a40:	ff 75 f4             	pushl  -0xc(%ebp)
80107a43:	e8 f7 a0 ff ff       	call   80101b3f <iunlock>
80107a48:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
80107a4b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107a51:	8b 40 68             	mov    0x68(%eax),%eax
80107a54:	83 ec 0c             	sub    $0xc,%esp
80107a57:	50                   	push   %eax
80107a58:	e8 58 a1 ff ff       	call   80101bb5 <iput>
80107a5d:	83 c4 10             	add    $0x10,%esp
  end_op();
80107a60:	e8 94 bc ff ff       	call   801036f9 <end_op>
  proc->cwd = ip;
80107a65:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107a6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107a6e:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80107a71:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107a76:	c9                   	leave  
80107a77:	c3                   	ret    

80107a78 <sys_exec>:

int sys_exec(void) {
80107a78:	f3 0f 1e fb          	endbr32 
80107a7c:	55                   	push   %ebp
80107a7d:	89 e5                	mov    %esp,%ebp
80107a7f:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if (argstr(0, &path) < 0 || argint(1, (int *)&uargv) < 0) {
80107a85:	83 ec 08             	sub    $0x8,%esp
80107a88:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107a8b:	50                   	push   %eax
80107a8c:	6a 00                	push   $0x0
80107a8e:	e8 eb dd ff ff       	call   8010587e <argstr>
80107a93:	83 c4 10             	add    $0x10,%esp
80107a96:	85 c0                	test   %eax,%eax
80107a98:	78 18                	js     80107ab2 <sys_exec+0x3a>
80107a9a:	83 ec 08             	sub    $0x8,%esp
80107a9d:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80107aa3:	50                   	push   %eax
80107aa4:	6a 01                	push   $0x1
80107aa6:	e8 46 dd ff ff       	call   801057f1 <argint>
80107aab:	83 c4 10             	add    $0x10,%esp
80107aae:	85 c0                	test   %eax,%eax
80107ab0:	79 0a                	jns    80107abc <sys_exec+0x44>
    return -1;
80107ab2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ab7:	e9 c6 00 00 00       	jmp    80107b82 <sys_exec+0x10a>
  }
  memset(argv, 0, sizeof(argv));
80107abc:	83 ec 04             	sub    $0x4,%esp
80107abf:	68 80 00 00 00       	push   $0x80
80107ac4:	6a 00                	push   $0x0
80107ac6:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80107acc:	50                   	push   %eax
80107acd:	e8 d2 d9 ff ff       	call   801054a4 <memset>
80107ad2:	83 c4 10             	add    $0x10,%esp
  for (i = 0;; i++) {
80107ad5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (i >= NELEM(argv))
80107adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107adf:	83 f8 1f             	cmp    $0x1f,%eax
80107ae2:	76 0a                	jbe    80107aee <sys_exec+0x76>
      return -1;
80107ae4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ae9:	e9 94 00 00 00       	jmp    80107b82 <sys_exec+0x10a>
    if (fetchint(uargv + 4 * i, (int *)&uarg) < 0)
80107aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107af1:	c1 e0 02             	shl    $0x2,%eax
80107af4:	89 c2                	mov    %eax,%edx
80107af6:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80107afc:	01 c2                	add    %eax,%edx
80107afe:	83 ec 08             	sub    $0x8,%esp
80107b01:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80107b07:	50                   	push   %eax
80107b08:	52                   	push   %edx
80107b09:	e8 3f dc ff ff       	call   8010574d <fetchint>
80107b0e:	83 c4 10             	add    $0x10,%esp
80107b11:	85 c0                	test   %eax,%eax
80107b13:	79 07                	jns    80107b1c <sys_exec+0xa4>
      return -1;
80107b15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b1a:	eb 66                	jmp    80107b82 <sys_exec+0x10a>
    if (uarg == 0) {
80107b1c:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80107b22:	85 c0                	test   %eax,%eax
80107b24:	75 27                	jne    80107b4d <sys_exec+0xd5>
      argv[i] = 0;
80107b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b29:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80107b30:	00 00 00 00 
      break;
80107b34:	90                   	nop
    }
    if (fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80107b35:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b38:	83 ec 08             	sub    $0x8,%esp
80107b3b:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80107b41:	52                   	push   %edx
80107b42:	50                   	push   %eax
80107b43:	e8 58 90 ff ff       	call   80100ba0 <exec>
80107b48:	83 c4 10             	add    $0x10,%esp
80107b4b:	eb 35                	jmp    80107b82 <sys_exec+0x10a>
    if (fetchstr(uarg, &argv[i]) < 0)
80107b4d:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80107b53:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107b56:	c1 e2 02             	shl    $0x2,%edx
80107b59:	01 c2                	add    %eax,%edx
80107b5b:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80107b61:	83 ec 08             	sub    $0x8,%esp
80107b64:	52                   	push   %edx
80107b65:	50                   	push   %eax
80107b66:	e8 20 dc ff ff       	call   8010578b <fetchstr>
80107b6b:	83 c4 10             	add    $0x10,%esp
80107b6e:	85 c0                	test   %eax,%eax
80107b70:	79 07                	jns    80107b79 <sys_exec+0x101>
      return -1;
80107b72:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b77:	eb 09                	jmp    80107b82 <sys_exec+0x10a>
  for (i = 0;; i++) {
80107b79:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if (i >= NELEM(argv))
80107b7d:	e9 5a ff ff ff       	jmp    80107adc <sys_exec+0x64>
}
80107b82:	c9                   	leave  
80107b83:	c3                   	ret    

80107b84 <sys_pipe>:

int sys_pipe(void) {
80107b84:	f3 0f 1e fb          	endbr32 
80107b88:	55                   	push   %ebp
80107b89:	89 e5                	mov    %esp,%ebp
80107b8b:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if (argptr(0, (void *)&fd, 2 * sizeof(fd[0])) < 0)
80107b8e:	83 ec 04             	sub    $0x4,%esp
80107b91:	6a 08                	push   $0x8
80107b93:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107b96:	50                   	push   %eax
80107b97:	6a 00                	push   $0x0
80107b99:	e8 7f dc ff ff       	call   8010581d <argptr>
80107b9e:	83 c4 10             	add    $0x10,%esp
80107ba1:	85 c0                	test   %eax,%eax
80107ba3:	79 0a                	jns    80107baf <sys_pipe+0x2b>
    return -1;
80107ba5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107baa:	e9 af 00 00 00       	jmp    80107c5e <sys_pipe+0xda>
  if (pipealloc(&rf, &wf) < 0)
80107baf:	83 ec 08             	sub    $0x8,%esp
80107bb2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107bb5:	50                   	push   %eax
80107bb6:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107bb9:	50                   	push   %eax
80107bba:	e8 04 c6 ff ff       	call   801041c3 <pipealloc>
80107bbf:	83 c4 10             	add    $0x10,%esp
80107bc2:	85 c0                	test   %eax,%eax
80107bc4:	79 0a                	jns    80107bd0 <sys_pipe+0x4c>
    return -1;
80107bc6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107bcb:	e9 8e 00 00 00       	jmp    80107c5e <sys_pipe+0xda>
  fd0 = -1;
80107bd0:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
80107bd7:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107bda:	83 ec 0c             	sub    $0xc,%esp
80107bdd:	50                   	push   %eax
80107bde:	e8 39 f3 ff ff       	call   80106f1c <fdalloc>
80107be3:	83 c4 10             	add    $0x10,%esp
80107be6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107be9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107bed:	78 18                	js     80107c07 <sys_pipe+0x83>
80107bef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107bf2:	83 ec 0c             	sub    $0xc,%esp
80107bf5:	50                   	push   %eax
80107bf6:	e8 21 f3 ff ff       	call   80106f1c <fdalloc>
80107bfb:	83 c4 10             	add    $0x10,%esp
80107bfe:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107c01:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107c05:	79 3f                	jns    80107c46 <sys_pipe+0xc2>
    if (fd0 >= 0)
80107c07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107c0b:	78 14                	js     80107c21 <sys_pipe+0x9d>
      proc->ofile[fd0] = 0;
80107c0d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107c13:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107c16:	83 c2 08             	add    $0x8,%edx
80107c19:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80107c20:	00 
    fileclose(rf);
80107c21:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107c24:	83 ec 0c             	sub    $0xc,%esp
80107c27:	50                   	push   %eax
80107c28:	e8 63 94 ff ff       	call   80101090 <fileclose>
80107c2d:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80107c30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107c33:	83 ec 0c             	sub    $0xc,%esp
80107c36:	50                   	push   %eax
80107c37:	e8 54 94 ff ff       	call   80101090 <fileclose>
80107c3c:	83 c4 10             	add    $0x10,%esp
    return -1;
80107c3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c44:	eb 18                	jmp    80107c5e <sys_pipe+0xda>
  }
  fd[0] = fd0;
80107c46:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c49:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107c4c:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80107c4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c51:	8d 50 04             	lea    0x4(%eax),%edx
80107c54:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c57:	89 02                	mov    %eax,(%edx)
  return 0;
80107c59:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107c5e:	c9                   	leave  
80107c5f:	c3                   	ret    

80107c60 <sys_fork>:
#include "kernel/param.h"
#include "kernel/memlayout.h"
#include "kernel/mmu.h"
#include "kernel/proc.h"

int sys_fork(void) { return fork(); }
80107c60:	f3 0f 1e fb          	endbr32 
80107c64:	55                   	push   %ebp
80107c65:	89 e5                	mov    %esp,%ebp
80107c67:	83 ec 08             	sub    $0x8,%esp
80107c6a:	e8 79 cc ff ff       	call   801048e8 <fork>
80107c6f:	c9                   	leave  
80107c70:	c3                   	ret    

80107c71 <sys_exit>:

int sys_exit(void) {
80107c71:	f3 0f 1e fb          	endbr32 
80107c75:	55                   	push   %ebp
80107c76:	89 e5                	mov    %esp,%ebp
80107c78:	83 ec 08             	sub    $0x8,%esp
  exit();
80107c7b:	e8 1f ce ff ff       	call   80104a9f <exit>
  return 0; // not reached
80107c80:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107c85:	c9                   	leave  
80107c86:	c3                   	ret    

80107c87 <sys_wait>:

int sys_wait(void) { return wait(); }
80107c87:	f3 0f 1e fb          	endbr32 
80107c8b:	55                   	push   %ebp
80107c8c:	89 e5                	mov    %esp,%ebp
80107c8e:	83 ec 08             	sub    $0x8,%esp
80107c91:	e8 45 cf ff ff       	call   80104bdb <wait>
80107c96:	c9                   	leave  
80107c97:	c3                   	ret    

80107c98 <sys_kill>:

int sys_kill(void) {
80107c98:	f3 0f 1e fb          	endbr32 
80107c9c:	55                   	push   %ebp
80107c9d:	89 e5                	mov    %esp,%ebp
80107c9f:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if (argint(0, &pid) < 0)
80107ca2:	83 ec 08             	sub    $0x8,%esp
80107ca5:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107ca8:	50                   	push   %eax
80107ca9:	6a 00                	push   $0x0
80107cab:	e8 41 db ff ff       	call   801057f1 <argint>
80107cb0:	83 c4 10             	add    $0x10,%esp
80107cb3:	85 c0                	test   %eax,%eax
80107cb5:	79 07                	jns    80107cbe <sys_kill+0x26>
    return -1;
80107cb7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107cbc:	eb 0f                	jmp    80107ccd <sys_kill+0x35>
  return kill(pid);
80107cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cc1:	83 ec 0c             	sub    $0xc,%esp
80107cc4:	50                   	push   %eax
80107cc5:	e8 7a d3 ff ff       	call   80105044 <kill>
80107cca:	83 c4 10             	add    $0x10,%esp
}
80107ccd:	c9                   	leave  
80107cce:	c3                   	ret    

80107ccf <sys_getpid>:

int sys_getpid(void) { return proc->pid; }
80107ccf:	f3 0f 1e fb          	endbr32 
80107cd3:	55                   	push   %ebp
80107cd4:	89 e5                	mov    %esp,%ebp
80107cd6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107cdc:	8b 40 10             	mov    0x10(%eax),%eax
80107cdf:	5d                   	pop    %ebp
80107ce0:	c3                   	ret    

80107ce1 <sys_sbrk>:

int sys_sbrk(void) {
80107ce1:	f3 0f 1e fb          	endbr32 
80107ce5:	55                   	push   %ebp
80107ce6:	89 e5                	mov    %esp,%ebp
80107ce8:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if (argint(0, &n) < 0)
80107ceb:	83 ec 08             	sub    $0x8,%esp
80107cee:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107cf1:	50                   	push   %eax
80107cf2:	6a 00                	push   $0x0
80107cf4:	e8 f8 da ff ff       	call   801057f1 <argint>
80107cf9:	83 c4 10             	add    $0x10,%esp
80107cfc:	85 c0                	test   %eax,%eax
80107cfe:	79 07                	jns    80107d07 <sys_sbrk+0x26>
    return -1;
80107d00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d05:	eb 28                	jmp    80107d2f <sys_sbrk+0x4e>
  addr = proc->sz;
80107d07:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107d0d:	8b 00                	mov    (%eax),%eax
80107d0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (growproc(n) < 0)
80107d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d15:	83 ec 0c             	sub    $0xc,%esp
80107d18:	50                   	push   %eax
80107d19:	e8 23 cb ff ff       	call   80104841 <growproc>
80107d1e:	83 c4 10             	add    $0x10,%esp
80107d21:	85 c0                	test   %eax,%eax
80107d23:	79 07                	jns    80107d2c <sys_sbrk+0x4b>
    return -1;
80107d25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d2a:	eb 03                	jmp    80107d2f <sys_sbrk+0x4e>
  return addr;
80107d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80107d2f:	c9                   	leave  
80107d30:	c3                   	ret    

80107d31 <sys_sleep>:

int sys_sleep(void) {
80107d31:	f3 0f 1e fb          	endbr32 
80107d35:	55                   	push   %ebp
80107d36:	89 e5                	mov    %esp,%ebp
80107d38:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
80107d3b:	83 ec 08             	sub    $0x8,%esp
80107d3e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107d41:	50                   	push   %eax
80107d42:	6a 00                	push   $0x0
80107d44:	e8 a8 da ff ff       	call   801057f1 <argint>
80107d49:	83 c4 10             	add    $0x10,%esp
80107d4c:	85 c0                	test   %eax,%eax
80107d4e:	79 07                	jns    80107d57 <sys_sleep+0x26>
    return -1;
80107d50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d55:	eb 77                	jmp    80107dce <sys_sleep+0x9d>
  acquire(&tickslock);
80107d57:	83 ec 0c             	sub    $0xc,%esp
80107d5a:	68 80 5c 11 80       	push   $0x80115c80
80107d5f:	e8 c4 d4 ff ff       	call   80105228 <acquire>
80107d64:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80107d67:	a1 c0 64 11 80       	mov    0x801164c0,%eax
80107d6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (ticks - ticks0 < n) {
80107d6f:	eb 39                	jmp    80107daa <sys_sleep+0x79>
    if (proc->killed) {
80107d71:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107d77:	8b 40 24             	mov    0x24(%eax),%eax
80107d7a:	85 c0                	test   %eax,%eax
80107d7c:	74 17                	je     80107d95 <sys_sleep+0x64>
      release(&tickslock);
80107d7e:	83 ec 0c             	sub    $0xc,%esp
80107d81:	68 80 5c 11 80       	push   $0x80115c80
80107d86:	e8 08 d5 ff ff       	call   80105293 <release>
80107d8b:	83 c4 10             	add    $0x10,%esp
      return -1;
80107d8e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d93:	eb 39                	jmp    80107dce <sys_sleep+0x9d>
    }
    sleep(&ticks, &tickslock);
80107d95:	83 ec 08             	sub    $0x8,%esp
80107d98:	68 80 5c 11 80       	push   $0x80115c80
80107d9d:	68 c0 64 11 80       	push   $0x801164c0
80107da2:	e8 6e d1 ff ff       	call   80104f15 <sleep>
80107da7:	83 c4 10             	add    $0x10,%esp
  while (ticks - ticks0 < n) {
80107daa:	a1 c0 64 11 80       	mov    0x801164c0,%eax
80107daf:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107db2:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107db5:	39 d0                	cmp    %edx,%eax
80107db7:	72 b8                	jb     80107d71 <sys_sleep+0x40>
  }
  release(&tickslock);
80107db9:	83 ec 0c             	sub    $0xc,%esp
80107dbc:	68 80 5c 11 80       	push   $0x80115c80
80107dc1:	e8 cd d4 ff ff       	call   80105293 <release>
80107dc6:	83 c4 10             	add    $0x10,%esp
  return 0;
80107dc9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107dce:	c9                   	leave  
80107dcf:	c3                   	ret    

80107dd0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void) {
80107dd0:	f3 0f 1e fb          	endbr32 
80107dd4:	55                   	push   %ebp
80107dd5:	89 e5                	mov    %esp,%ebp
80107dd7:	83 ec 18             	sub    $0x18,%esp
  uint xticks;

  acquire(&tickslock);
80107dda:	83 ec 0c             	sub    $0xc,%esp
80107ddd:	68 80 5c 11 80       	push   $0x80115c80
80107de2:	e8 41 d4 ff ff       	call   80105228 <acquire>
80107de7:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
80107dea:	a1 c0 64 11 80       	mov    0x801164c0,%eax
80107def:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80107df2:	83 ec 0c             	sub    $0xc,%esp
80107df5:	68 80 5c 11 80       	push   $0x80115c80
80107dfa:	e8 94 d4 ff ff       	call   80105293 <release>
80107dff:	83 c4 10             	add    $0x10,%esp
  return xticks;
80107e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80107e05:	c9                   	leave  
80107e06:	c3                   	ret    

80107e07 <outb>:
{
80107e07:	55                   	push   %ebp
80107e08:	89 e5                	mov    %esp,%ebp
80107e0a:	83 ec 08             	sub    $0x8,%esp
80107e0d:	8b 45 08             	mov    0x8(%ebp),%eax
80107e10:	8b 55 0c             	mov    0xc(%ebp),%edx
80107e13:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80107e17:	89 d0                	mov    %edx,%eax
80107e19:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107e1c:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107e20:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107e24:	ee                   	out    %al,(%dx)
}
80107e25:	90                   	nop
80107e26:	c9                   	leave  
80107e27:	c3                   	ret    

80107e28 <timerinit>:
#define TIMER_MODE (IO_TIMER1 + 3) // timer mode port
#define TIMER_SEL0 0x00            // select counter 0
#define TIMER_RATEGEN 0x04         // mode 2, rate generator
#define TIMER_16BIT 0x30           // r/w counter 16 bits, LSB first

void timerinit(void) {
80107e28:	f3 0f 1e fb          	endbr32 
80107e2c:	55                   	push   %ebp
80107e2d:	89 e5                	mov    %esp,%ebp
80107e2f:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80107e32:	6a 34                	push   $0x34
80107e34:	6a 43                	push   $0x43
80107e36:	e8 cc ff ff ff       	call   80107e07 <outb>
80107e3b:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80107e3e:	68 9c 00 00 00       	push   $0x9c
80107e43:	6a 40                	push   $0x40
80107e45:	e8 bd ff ff ff       	call   80107e07 <outb>
80107e4a:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80107e4d:	6a 2e                	push   $0x2e
80107e4f:	6a 40                	push   $0x40
80107e51:	e8 b1 ff ff ff       	call   80107e07 <outb>
80107e56:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
80107e59:	83 ec 0c             	sub    $0xc,%esp
80107e5c:	6a 00                	push   $0x0
80107e5e:	e8 42 c2 ff ff       	call   801040a5 <picenable>
80107e63:	83 c4 10             	add    $0x10,%esp
}
80107e66:	90                   	nop
80107e67:	c9                   	leave  
80107e68:	c3                   	ret    

80107e69 <lidt>:
{
80107e69:	55                   	push   %ebp
80107e6a:	89 e5                	mov    %esp,%ebp
80107e6c:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80107e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e72:	83 e8 01             	sub    $0x1,%eax
80107e75:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107e79:	8b 45 08             	mov    0x8(%ebp),%eax
80107e7c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107e80:	8b 45 08             	mov    0x8(%ebp),%eax
80107e83:	c1 e8 10             	shr    $0x10,%eax
80107e86:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80107e8a:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107e8d:	0f 01 18             	lidtl  (%eax)
}
80107e90:	90                   	nop
80107e91:	c9                   	leave  
80107e92:	c3                   	ret    

80107e93 <rcr2>:

static inline uint
rcr2(void)
{
80107e93:	55                   	push   %ebp
80107e94:	89 e5                	mov    %esp,%ebp
80107e96:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107e99:	0f 20 d0             	mov    %cr2,%eax
80107e9c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80107e9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80107ea2:	c9                   	leave  
80107ea3:	c3                   	ret    

80107ea4 <tvinit>:
struct gatedesc idt[256];
extern uint vectors[]; // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void tvinit(void) {
80107ea4:	f3 0f 1e fb          	endbr32 
80107ea8:	55                   	push   %ebp
80107ea9:	89 e5                	mov    %esp,%ebp
80107eab:	83 ec 18             	sub    $0x18,%esp
  int i;

  for (i = 0; i < 256; i++)
80107eae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107eb5:	e9 c3 00 00 00       	jmp    80107f7d <tvinit+0xd9>
    SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
80107eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ebd:	8b 04 85 58 d1 10 80 	mov    -0x7fef2ea8(,%eax,4),%eax
80107ec4:	89 c2                	mov    %eax,%edx
80107ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ec9:	66 89 14 c5 c0 5c 11 	mov    %dx,-0x7feea340(,%eax,8)
80107ed0:	80 
80107ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ed4:	66 c7 04 c5 c2 5c 11 	movw   $0x8,-0x7feea33e(,%eax,8)
80107edb:	80 08 00 
80107ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ee1:	0f b6 14 c5 c4 5c 11 	movzbl -0x7feea33c(,%eax,8),%edx
80107ee8:	80 
80107ee9:	83 e2 e0             	and    $0xffffffe0,%edx
80107eec:	88 14 c5 c4 5c 11 80 	mov    %dl,-0x7feea33c(,%eax,8)
80107ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ef6:	0f b6 14 c5 c4 5c 11 	movzbl -0x7feea33c(,%eax,8),%edx
80107efd:	80 
80107efe:	83 e2 1f             	and    $0x1f,%edx
80107f01:	88 14 c5 c4 5c 11 80 	mov    %dl,-0x7feea33c(,%eax,8)
80107f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f0b:	0f b6 14 c5 c5 5c 11 	movzbl -0x7feea33b(,%eax,8),%edx
80107f12:	80 
80107f13:	83 e2 f0             	and    $0xfffffff0,%edx
80107f16:	83 ca 0e             	or     $0xe,%edx
80107f19:	88 14 c5 c5 5c 11 80 	mov    %dl,-0x7feea33b(,%eax,8)
80107f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f23:	0f b6 14 c5 c5 5c 11 	movzbl -0x7feea33b(,%eax,8),%edx
80107f2a:	80 
80107f2b:	83 e2 ef             	and    $0xffffffef,%edx
80107f2e:	88 14 c5 c5 5c 11 80 	mov    %dl,-0x7feea33b(,%eax,8)
80107f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f38:	0f b6 14 c5 c5 5c 11 	movzbl -0x7feea33b(,%eax,8),%edx
80107f3f:	80 
80107f40:	83 e2 9f             	and    $0xffffff9f,%edx
80107f43:	88 14 c5 c5 5c 11 80 	mov    %dl,-0x7feea33b(,%eax,8)
80107f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f4d:	0f b6 14 c5 c5 5c 11 	movzbl -0x7feea33b(,%eax,8),%edx
80107f54:	80 
80107f55:	83 ca 80             	or     $0xffffff80,%edx
80107f58:	88 14 c5 c5 5c 11 80 	mov    %dl,-0x7feea33b(,%eax,8)
80107f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f62:	8b 04 85 58 d1 10 80 	mov    -0x7fef2ea8(,%eax,4),%eax
80107f69:	c1 e8 10             	shr    $0x10,%eax
80107f6c:	89 c2                	mov    %eax,%edx
80107f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f71:	66 89 14 c5 c6 5c 11 	mov    %dx,-0x7feea33a(,%eax,8)
80107f78:	80 
  for (i = 0; i < 256; i++)
80107f79:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107f7d:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80107f84:	0f 8e 30 ff ff ff    	jle    80107eba <tvinit+0x16>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80107f8a:	a1 58 d2 10 80       	mov    0x8010d258,%eax
80107f8f:	66 a3 c0 5e 11 80    	mov    %ax,0x80115ec0
80107f95:	66 c7 05 c2 5e 11 80 	movw   $0x8,0x80115ec2
80107f9c:	08 00 
80107f9e:	0f b6 05 c4 5e 11 80 	movzbl 0x80115ec4,%eax
80107fa5:	83 e0 e0             	and    $0xffffffe0,%eax
80107fa8:	a2 c4 5e 11 80       	mov    %al,0x80115ec4
80107fad:	0f b6 05 c4 5e 11 80 	movzbl 0x80115ec4,%eax
80107fb4:	83 e0 1f             	and    $0x1f,%eax
80107fb7:	a2 c4 5e 11 80       	mov    %al,0x80115ec4
80107fbc:	0f b6 05 c5 5e 11 80 	movzbl 0x80115ec5,%eax
80107fc3:	83 c8 0f             	or     $0xf,%eax
80107fc6:	a2 c5 5e 11 80       	mov    %al,0x80115ec5
80107fcb:	0f b6 05 c5 5e 11 80 	movzbl 0x80115ec5,%eax
80107fd2:	83 e0 ef             	and    $0xffffffef,%eax
80107fd5:	a2 c5 5e 11 80       	mov    %al,0x80115ec5
80107fda:	0f b6 05 c5 5e 11 80 	movzbl 0x80115ec5,%eax
80107fe1:	83 c8 60             	or     $0x60,%eax
80107fe4:	a2 c5 5e 11 80       	mov    %al,0x80115ec5
80107fe9:	0f b6 05 c5 5e 11 80 	movzbl 0x80115ec5,%eax
80107ff0:	83 c8 80             	or     $0xffffff80,%eax
80107ff3:	a2 c5 5e 11 80       	mov    %al,0x80115ec5
80107ff8:	a1 58 d2 10 80       	mov    0x8010d258,%eax
80107ffd:	c1 e8 10             	shr    $0x10,%eax
80108000:	66 a3 c6 5e 11 80    	mov    %ax,0x80115ec6

  initlock(&tickslock, "time");
80108006:	83 ec 08             	sub    $0x8,%esp
80108009:	68 b4 a4 10 80       	push   $0x8010a4b4
8010800e:	68 80 5c 11 80       	push   $0x80115c80
80108013:	e8 ea d1 ff ff       	call   80105202 <initlock>
80108018:	83 c4 10             	add    $0x10,%esp
}
8010801b:	90                   	nop
8010801c:	c9                   	leave  
8010801d:	c3                   	ret    

8010801e <idtinit>:

void idtinit(void) { lidt(idt, sizeof(idt)); }
8010801e:	f3 0f 1e fb          	endbr32 
80108022:	55                   	push   %ebp
80108023:	89 e5                	mov    %esp,%ebp
80108025:	68 00 08 00 00       	push   $0x800
8010802a:	68 c0 5c 11 80       	push   $0x80115cc0
8010802f:	e8 35 fe ff ff       	call   80107e69 <lidt>
80108034:	83 c4 08             	add    $0x8,%esp
80108037:	90                   	nop
80108038:	c9                   	leave  
80108039:	c3                   	ret    

8010803a <trap>:

// PAGEBREAK: 41
void trap(struct trapframe *tf) {
8010803a:	f3 0f 1e fb          	endbr32 
8010803e:	55                   	push   %ebp
8010803f:	89 e5                	mov    %esp,%ebp
80108041:	57                   	push   %edi
80108042:	56                   	push   %esi
80108043:	53                   	push   %ebx
80108044:	83 ec 1c             	sub    $0x1c,%esp
  if (tf->trapno == T_SYSCALL) {
80108047:	8b 45 08             	mov    0x8(%ebp),%eax
8010804a:	8b 40 30             	mov    0x30(%eax),%eax
8010804d:	83 f8 40             	cmp    $0x40,%eax
80108050:	75 3e                	jne    80108090 <trap+0x56>
    if (proc->killed)
80108052:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108058:	8b 40 24             	mov    0x24(%eax),%eax
8010805b:	85 c0                	test   %eax,%eax
8010805d:	74 05                	je     80108064 <trap+0x2a>
      exit();
8010805f:	e8 3b ca ff ff       	call   80104a9f <exit>
    proc->tf = tf;
80108064:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010806a:	8b 55 08             	mov    0x8(%ebp),%edx
8010806d:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80108070:	e8 c5 da ff ff       	call   80105b3a <syscall>
    if (proc->killed)
80108075:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010807b:	8b 40 24             	mov    0x24(%eax),%eax
8010807e:	85 c0                	test   %eax,%eax
80108080:	0f 84 1d 02 00 00    	je     801082a3 <trap+0x269>
      exit();
80108086:	e8 14 ca ff ff       	call   80104a9f <exit>
    return;
8010808b:	e9 13 02 00 00       	jmp    801082a3 <trap+0x269>
  }

  switch (tf->trapno) {
80108090:	8b 45 08             	mov    0x8(%ebp),%eax
80108093:	8b 40 30             	mov    0x30(%eax),%eax
80108096:	83 e8 20             	sub    $0x20,%eax
80108099:	83 f8 1f             	cmp    $0x1f,%eax
8010809c:	0f 87 c1 00 00 00    	ja     80108163 <trap+0x129>
801080a2:	8b 04 85 5c a5 10 80 	mov    -0x7fef5aa4(,%eax,4),%eax
801080a9:	3e ff e0             	notrack jmp *%eax
  case T_IRQ0 + IRQ_TIMER:
    if (cpu->id == 0) {
801080ac:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801080b2:	0f b6 00             	movzbl (%eax),%eax
801080b5:	84 c0                	test   %al,%al
801080b7:	75 3d                	jne    801080f6 <trap+0xbc>
      acquire(&tickslock);
801080b9:	83 ec 0c             	sub    $0xc,%esp
801080bc:	68 80 5c 11 80       	push   $0x80115c80
801080c1:	e8 62 d1 ff ff       	call   80105228 <acquire>
801080c6:	83 c4 10             	add    $0x10,%esp
      ticks++;
801080c9:	a1 c0 64 11 80       	mov    0x801164c0,%eax
801080ce:	83 c0 01             	add    $0x1,%eax
801080d1:	a3 c0 64 11 80       	mov    %eax,0x801164c0
      wakeup(&ticks);
801080d6:	83 ec 0c             	sub    $0xc,%esp
801080d9:	68 c0 64 11 80       	push   $0x801164c0
801080de:	e8 26 cf ff ff       	call   80105009 <wakeup>
801080e3:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
801080e6:	83 ec 0c             	sub    $0xc,%esp
801080e9:	68 80 5c 11 80       	push   $0x80115c80
801080ee:	e8 a0 d1 ff ff       	call   80105293 <release>
801080f3:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
801080f6:	e8 22 b0 ff ff       	call   8010311d <lapiceoi>
    break;
801080fb:	e9 1d 01 00 00       	jmp    8010821d <trap+0x1e3>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80108100:	e8 e7 a7 ff ff       	call   801028ec <ideintr>
    lapiceoi();
80108105:	e8 13 b0 ff ff       	call   8010311d <lapiceoi>
    break;
8010810a:	e9 0e 01 00 00       	jmp    8010821d <trap+0x1e3>
  case T_IRQ0 + IRQ_IDE + 1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
8010810f:	e8 f8 ad ff ff       	call   80102f0c <kbdintr>
    lapiceoi();
80108114:	e8 04 b0 ff ff       	call   8010311d <lapiceoi>
    break;
80108119:	e9 ff 00 00 00       	jmp    8010821d <trap+0x1e3>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
8010811e:	e8 6f 03 00 00       	call   80108492 <uartintr>
    lapiceoi();
80108123:	e8 f5 af ff ff       	call   8010311d <lapiceoi>
    break;
80108128:	e9 f0 00 00 00       	jmp    8010821d <trap+0x1e3>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n", cpu->id, tf->cs, tf->eip);
8010812d:	8b 45 08             	mov    0x8(%ebp),%eax
80108130:	8b 48 38             	mov    0x38(%eax),%ecx
80108133:	8b 45 08             	mov    0x8(%ebp),%eax
80108136:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010813a:	0f b7 d0             	movzwl %ax,%edx
8010813d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108143:	0f b6 00             	movzbl (%eax),%eax
80108146:	0f b6 c0             	movzbl %al,%eax
80108149:	51                   	push   %ecx
8010814a:	52                   	push   %edx
8010814b:	50                   	push   %eax
8010814c:	68 bc a4 10 80       	push   $0x8010a4bc
80108151:	e8 54 82 ff ff       	call   801003aa <cprintf>
80108156:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80108159:	e8 bf af ff ff       	call   8010311d <lapiceoi>
    break;
8010815e:	e9 ba 00 00 00       	jmp    8010821d <trap+0x1e3>

  // PAGEBREAK: 13
  default:
    if (proc == 0 || (tf->cs & 3) == 0) {
80108163:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108169:	85 c0                	test   %eax,%eax
8010816b:	74 11                	je     8010817e <trap+0x144>
8010816d:	8b 45 08             	mov    0x8(%ebp),%eax
80108170:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80108174:	0f b7 c0             	movzwl %ax,%eax
80108177:	83 e0 03             	and    $0x3,%eax
8010817a:	85 c0                	test   %eax,%eax
8010817c:	75 3f                	jne    801081bd <trap+0x183>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n", tf->trapno,
8010817e:	e8 10 fd ff ff       	call   80107e93 <rcr2>
80108183:	8b 55 08             	mov    0x8(%ebp),%edx
80108186:	8b 5a 38             	mov    0x38(%edx),%ebx
              cpu->id, tf->eip, rcr2());
80108189:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108190:	0f b6 12             	movzbl (%edx),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n", tf->trapno,
80108193:	0f b6 ca             	movzbl %dl,%ecx
80108196:	8b 55 08             	mov    0x8(%ebp),%edx
80108199:	8b 52 30             	mov    0x30(%edx),%edx
8010819c:	83 ec 0c             	sub    $0xc,%esp
8010819f:	50                   	push   %eax
801081a0:	53                   	push   %ebx
801081a1:	51                   	push   %ecx
801081a2:	52                   	push   %edx
801081a3:	68 e0 a4 10 80       	push   $0x8010a4e0
801081a8:	e8 fd 81 ff ff       	call   801003aa <cprintf>
801081ad:	83 c4 20             	add    $0x20,%esp
      panic("trap");
801081b0:	83 ec 0c             	sub    $0xc,%esp
801081b3:	68 12 a5 10 80       	push   $0x8010a512
801081b8:	e8 a6 83 ff ff       	call   80100563 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801081bd:	e8 d1 fc ff ff       	call   80107e93 <rcr2>
801081c2:	89 c2                	mov    %eax,%edx
801081c4:	8b 45 08             	mov    0x8(%ebp),%eax
801081c7:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip,
801081ca:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801081d0:	0f b6 00             	movzbl (%eax),%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801081d3:	0f b6 f0             	movzbl %al,%esi
801081d6:	8b 45 08             	mov    0x8(%ebp),%eax
801081d9:	8b 58 34             	mov    0x34(%eax),%ebx
801081dc:	8b 45 08             	mov    0x8(%ebp),%eax
801081df:	8b 48 30             	mov    0x30(%eax),%ecx
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip,
801081e2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801081e8:	83 c0 6c             	add    $0x6c,%eax
801081eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801081ee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801081f4:	8b 40 10             	mov    0x10(%eax),%eax
801081f7:	52                   	push   %edx
801081f8:	57                   	push   %edi
801081f9:	56                   	push   %esi
801081fa:	53                   	push   %ebx
801081fb:	51                   	push   %ecx
801081fc:	ff 75 e4             	pushl  -0x1c(%ebp)
801081ff:	50                   	push   %eax
80108200:	68 18 a5 10 80       	push   $0x8010a518
80108205:	e8 a0 81 ff ff       	call   801003aa <cprintf>
8010820a:	83 c4 20             	add    $0x20,%esp
            rcr2());
    proc->killed = 1;
8010820d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108213:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010821a:	eb 01                	jmp    8010821d <trap+0x1e3>
    break;
8010821c:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if (proc && proc->killed && (tf->cs & 3) == DPL_USER)
8010821d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108223:	85 c0                	test   %eax,%eax
80108225:	74 24                	je     8010824b <trap+0x211>
80108227:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010822d:	8b 40 24             	mov    0x24(%eax),%eax
80108230:	85 c0                	test   %eax,%eax
80108232:	74 17                	je     8010824b <trap+0x211>
80108234:	8b 45 08             	mov    0x8(%ebp),%eax
80108237:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010823b:	0f b7 c0             	movzwl %ax,%eax
8010823e:	83 e0 03             	and    $0x3,%eax
80108241:	83 f8 03             	cmp    $0x3,%eax
80108244:	75 05                	jne    8010824b <trap+0x211>
    exit();
80108246:	e8 54 c8 ff ff       	call   80104a9f <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if (proc && proc->state == RUNNING && tf->trapno == T_IRQ0 + IRQ_TIMER)
8010824b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108251:	85 c0                	test   %eax,%eax
80108253:	74 1e                	je     80108273 <trap+0x239>
80108255:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010825b:	8b 40 0c             	mov    0xc(%eax),%eax
8010825e:	83 f8 04             	cmp    $0x4,%eax
80108261:	75 10                	jne    80108273 <trap+0x239>
80108263:	8b 45 08             	mov    0x8(%ebp),%eax
80108266:	8b 40 30             	mov    0x30(%eax),%eax
80108269:	83 f8 20             	cmp    $0x20,%eax
8010826c:	75 05                	jne    80108273 <trap+0x239>
    yield();
8010826e:	e8 19 cc ff ff       	call   80104e8c <yield>

  // Check if the process has been killed since we yielded
  if (proc && proc->killed && (tf->cs & 3) == DPL_USER)
80108273:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108279:	85 c0                	test   %eax,%eax
8010827b:	74 27                	je     801082a4 <trap+0x26a>
8010827d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108283:	8b 40 24             	mov    0x24(%eax),%eax
80108286:	85 c0                	test   %eax,%eax
80108288:	74 1a                	je     801082a4 <trap+0x26a>
8010828a:	8b 45 08             	mov    0x8(%ebp),%eax
8010828d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80108291:	0f b7 c0             	movzwl %ax,%eax
80108294:	83 e0 03             	and    $0x3,%eax
80108297:	83 f8 03             	cmp    $0x3,%eax
8010829a:	75 08                	jne    801082a4 <trap+0x26a>
    exit();
8010829c:	e8 fe c7 ff ff       	call   80104a9f <exit>
801082a1:	eb 01                	jmp    801082a4 <trap+0x26a>
    return;
801082a3:	90                   	nop
}
801082a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801082a7:	5b                   	pop    %ebx
801082a8:	5e                   	pop    %esi
801082a9:	5f                   	pop    %edi
801082aa:	5d                   	pop    %ebp
801082ab:	c3                   	ret    

801082ac <inb>:
{
801082ac:	55                   	push   %ebp
801082ad:	89 e5                	mov    %esp,%ebp
801082af:	83 ec 14             	sub    $0x14,%esp
801082b2:	8b 45 08             	mov    0x8(%ebp),%eax
801082b5:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801082b9:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801082bd:	89 c2                	mov    %eax,%edx
801082bf:	ec                   	in     (%dx),%al
801082c0:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801082c3:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801082c7:	c9                   	leave  
801082c8:	c3                   	ret    

801082c9 <outb>:
{
801082c9:	55                   	push   %ebp
801082ca:	89 e5                	mov    %esp,%ebp
801082cc:	83 ec 08             	sub    $0x8,%esp
801082cf:	8b 45 08             	mov    0x8(%ebp),%eax
801082d2:	8b 55 0c             	mov    0xc(%ebp),%edx
801082d5:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801082d9:	89 d0                	mov    %edx,%eax
801082db:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801082de:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801082e2:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801082e6:	ee                   	out    %al,(%dx)
}
801082e7:	90                   	nop
801082e8:	c9                   	leave  
801082e9:	c3                   	ret    

801082ea <uartinit>:

#define COM1 0x3f8

static int uart; // is there a uart?

void uartinit(void) {
801082ea:	f3 0f 1e fb          	endbr32 
801082ee:	55                   	push   %ebp
801082ef:	89 e5                	mov    %esp,%ebp
801082f1:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1 + 2, 0);
801082f4:	6a 00                	push   $0x0
801082f6:	68 fa 03 00 00       	push   $0x3fa
801082fb:	e8 c9 ff ff ff       	call   801082c9 <outb>
80108300:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1 + 3, 0x80); // Unlock divisor
80108303:	68 80 00 00 00       	push   $0x80
80108308:	68 fb 03 00 00       	push   $0x3fb
8010830d:	e8 b7 ff ff ff       	call   801082c9 <outb>
80108312:	83 c4 08             	add    $0x8,%esp
  outb(COM1 + 0, 115200 / 9600);
80108315:	6a 0c                	push   $0xc
80108317:	68 f8 03 00 00       	push   $0x3f8
8010831c:	e8 a8 ff ff ff       	call   801082c9 <outb>
80108321:	83 c4 08             	add    $0x8,%esp
  outb(COM1 + 1, 0);
80108324:	6a 00                	push   $0x0
80108326:	68 f9 03 00 00       	push   $0x3f9
8010832b:	e8 99 ff ff ff       	call   801082c9 <outb>
80108330:	83 c4 08             	add    $0x8,%esp
  outb(COM1 + 3, 0x03); // Lock divisor, 8 data bits.
80108333:	6a 03                	push   $0x3
80108335:	68 fb 03 00 00       	push   $0x3fb
8010833a:	e8 8a ff ff ff       	call   801082c9 <outb>
8010833f:	83 c4 08             	add    $0x8,%esp
  outb(COM1 + 4, 0);
80108342:	6a 00                	push   $0x0
80108344:	68 fc 03 00 00       	push   $0x3fc
80108349:	e8 7b ff ff ff       	call   801082c9 <outb>
8010834e:	83 c4 08             	add    $0x8,%esp
  outb(COM1 + 1, 0x01); // Enable receive interrupts.
80108351:	6a 01                	push   $0x1
80108353:	68 f9 03 00 00       	push   $0x3f9
80108358:	e8 6c ff ff ff       	call   801082c9 <outb>
8010835d:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if (inb(COM1 + 5) == 0xFF)
80108360:	68 fd 03 00 00       	push   $0x3fd
80108365:	e8 42 ff ff ff       	call   801082ac <inb>
8010836a:	83 c4 04             	add    $0x4,%esp
8010836d:	3c ff                	cmp    $0xff,%al
8010836f:	74 6e                	je     801083df <uartinit+0xf5>
    return;
  uart = 1;
80108371:	c7 05 20 d7 10 80 01 	movl   $0x1,0x8010d720
80108378:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1 + 2);
8010837b:	68 fa 03 00 00       	push   $0x3fa
80108380:	e8 27 ff ff ff       	call   801082ac <inb>
80108385:	83 c4 04             	add    $0x4,%esp
  inb(COM1 + 0);
80108388:	68 f8 03 00 00       	push   $0x3f8
8010838d:	e8 1a ff ff ff       	call   801082ac <inb>
80108392:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
80108395:	83 ec 0c             	sub    $0xc,%esp
80108398:	6a 04                	push   $0x4
8010839a:	e8 06 bd ff ff       	call   801040a5 <picenable>
8010839f:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
801083a2:	83 ec 08             	sub    $0x8,%esp
801083a5:	6a 00                	push   $0x0
801083a7:	6a 04                	push   $0x4
801083a9:	e8 f4 a7 ff ff       	call   80102ba2 <ioapicenable>
801083ae:	83 c4 10             	add    $0x10,%esp

  // Announce that we're here.
  for (p = "xv6...\n"; *p; p++)
801083b1:	c7 45 f4 dc a5 10 80 	movl   $0x8010a5dc,-0xc(%ebp)
801083b8:	eb 19                	jmp    801083d3 <uartinit+0xe9>
    uartputc(*p);
801083ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083bd:	0f b6 00             	movzbl (%eax),%eax
801083c0:	0f be c0             	movsbl %al,%eax
801083c3:	83 ec 0c             	sub    $0xc,%esp
801083c6:	50                   	push   %eax
801083c7:	e8 16 00 00 00       	call   801083e2 <uartputc>
801083cc:	83 c4 10             	add    $0x10,%esp
  for (p = "xv6...\n"; *p; p++)
801083cf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801083d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083d6:	0f b6 00             	movzbl (%eax),%eax
801083d9:	84 c0                	test   %al,%al
801083db:	75 dd                	jne    801083ba <uartinit+0xd0>
801083dd:	eb 01                	jmp    801083e0 <uartinit+0xf6>
    return;
801083df:	90                   	nop
}
801083e0:	c9                   	leave  
801083e1:	c3                   	ret    

801083e2 <uartputc>:

void uartputc(int c) {
801083e2:	f3 0f 1e fb          	endbr32 
801083e6:	55                   	push   %ebp
801083e7:	89 e5                	mov    %esp,%ebp
801083e9:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (!uart)
801083ec:	a1 20 d7 10 80       	mov    0x8010d720,%eax
801083f1:	85 c0                	test   %eax,%eax
801083f3:	74 53                	je     80108448 <uartputc+0x66>
    return;
  for (i = 0; i < 128 && !(inb(COM1 + 5) & 0x20); i++)
801083f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801083fc:	eb 11                	jmp    8010840f <uartputc+0x2d>
    microdelay(10);
801083fe:	83 ec 0c             	sub    $0xc,%esp
80108401:	6a 0a                	push   $0xa
80108403:	e8 34 ad ff ff       	call   8010313c <microdelay>
80108408:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < 128 && !(inb(COM1 + 5) & 0x20); i++)
8010840b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010840f:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80108413:	7f 1a                	jg     8010842f <uartputc+0x4d>
80108415:	83 ec 0c             	sub    $0xc,%esp
80108418:	68 fd 03 00 00       	push   $0x3fd
8010841d:	e8 8a fe ff ff       	call   801082ac <inb>
80108422:	83 c4 10             	add    $0x10,%esp
80108425:	0f b6 c0             	movzbl %al,%eax
80108428:	83 e0 20             	and    $0x20,%eax
8010842b:	85 c0                	test   %eax,%eax
8010842d:	74 cf                	je     801083fe <uartputc+0x1c>
  outb(COM1 + 0, c);
8010842f:	8b 45 08             	mov    0x8(%ebp),%eax
80108432:	0f b6 c0             	movzbl %al,%eax
80108435:	83 ec 08             	sub    $0x8,%esp
80108438:	50                   	push   %eax
80108439:	68 f8 03 00 00       	push   $0x3f8
8010843e:	e8 86 fe ff ff       	call   801082c9 <outb>
80108443:	83 c4 10             	add    $0x10,%esp
80108446:	eb 01                	jmp    80108449 <uartputc+0x67>
    return;
80108448:	90                   	nop
}
80108449:	c9                   	leave  
8010844a:	c3                   	ret    

8010844b <uartgetc>:

static int uartgetc(void) {
8010844b:	f3 0f 1e fb          	endbr32 
8010844f:	55                   	push   %ebp
80108450:	89 e5                	mov    %esp,%ebp
  if (!uart)
80108452:	a1 20 d7 10 80       	mov    0x8010d720,%eax
80108457:	85 c0                	test   %eax,%eax
80108459:	75 07                	jne    80108462 <uartgetc+0x17>
    return -1;
8010845b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108460:	eb 2e                	jmp    80108490 <uartgetc+0x45>
  if (!(inb(COM1 + 5) & 0x01))
80108462:	68 fd 03 00 00       	push   $0x3fd
80108467:	e8 40 fe ff ff       	call   801082ac <inb>
8010846c:	83 c4 04             	add    $0x4,%esp
8010846f:	0f b6 c0             	movzbl %al,%eax
80108472:	83 e0 01             	and    $0x1,%eax
80108475:	85 c0                	test   %eax,%eax
80108477:	75 07                	jne    80108480 <uartgetc+0x35>
    return -1;
80108479:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010847e:	eb 10                	jmp    80108490 <uartgetc+0x45>
  return inb(COM1 + 0);
80108480:	68 f8 03 00 00       	push   $0x3f8
80108485:	e8 22 fe ff ff       	call   801082ac <inb>
8010848a:	83 c4 04             	add    $0x4,%esp
8010848d:	0f b6 c0             	movzbl %al,%eax
}
80108490:	c9                   	leave  
80108491:	c3                   	ret    

80108492 <uartintr>:

void uartintr(void) { consoleintr(uartgetc); }
80108492:	f3 0f 1e fb          	endbr32 
80108496:	55                   	push   %ebp
80108497:	89 e5                	mov    %esp,%ebp
80108499:	83 ec 08             	sub    $0x8,%esp
8010849c:	83 ec 0c             	sub    $0xc,%esp
8010849f:	68 4b 84 10 80       	push   $0x8010844b
801084a4:	e8 61 83 ff ff       	call   8010080a <consoleintr>
801084a9:	83 c4 10             	add    $0x10,%esp
801084ac:	90                   	nop
801084ad:	c9                   	leave  
801084ae:	c3                   	ret    

801084af <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801084af:	6a 00                	push   $0x0
  pushl $0
801084b1:	6a 00                	push   $0x0
  jmp alltraps
801084b3:	e9 69 0a 00 00       	jmp    80108f21 <alltraps>

801084b8 <vector1>:
.globl vector1
vector1:
  pushl $0
801084b8:	6a 00                	push   $0x0
  pushl $1
801084ba:	6a 01                	push   $0x1
  jmp alltraps
801084bc:	e9 60 0a 00 00       	jmp    80108f21 <alltraps>

801084c1 <vector2>:
.globl vector2
vector2:
  pushl $0
801084c1:	6a 00                	push   $0x0
  pushl $2
801084c3:	6a 02                	push   $0x2
  jmp alltraps
801084c5:	e9 57 0a 00 00       	jmp    80108f21 <alltraps>

801084ca <vector3>:
.globl vector3
vector3:
  pushl $0
801084ca:	6a 00                	push   $0x0
  pushl $3
801084cc:	6a 03                	push   $0x3
  jmp alltraps
801084ce:	e9 4e 0a 00 00       	jmp    80108f21 <alltraps>

801084d3 <vector4>:
.globl vector4
vector4:
  pushl $0
801084d3:	6a 00                	push   $0x0
  pushl $4
801084d5:	6a 04                	push   $0x4
  jmp alltraps
801084d7:	e9 45 0a 00 00       	jmp    80108f21 <alltraps>

801084dc <vector5>:
.globl vector5
vector5:
  pushl $0
801084dc:	6a 00                	push   $0x0
  pushl $5
801084de:	6a 05                	push   $0x5
  jmp alltraps
801084e0:	e9 3c 0a 00 00       	jmp    80108f21 <alltraps>

801084e5 <vector6>:
.globl vector6
vector6:
  pushl $0
801084e5:	6a 00                	push   $0x0
  pushl $6
801084e7:	6a 06                	push   $0x6
  jmp alltraps
801084e9:	e9 33 0a 00 00       	jmp    80108f21 <alltraps>

801084ee <vector7>:
.globl vector7
vector7:
  pushl $0
801084ee:	6a 00                	push   $0x0
  pushl $7
801084f0:	6a 07                	push   $0x7
  jmp alltraps
801084f2:	e9 2a 0a 00 00       	jmp    80108f21 <alltraps>

801084f7 <vector8>:
.globl vector8
vector8:
  pushl $8
801084f7:	6a 08                	push   $0x8
  jmp alltraps
801084f9:	e9 23 0a 00 00       	jmp    80108f21 <alltraps>

801084fe <vector9>:
.globl vector9
vector9:
  pushl $0
801084fe:	6a 00                	push   $0x0
  pushl $9
80108500:	6a 09                	push   $0x9
  jmp alltraps
80108502:	e9 1a 0a 00 00       	jmp    80108f21 <alltraps>

80108507 <vector10>:
.globl vector10
vector10:
  pushl $10
80108507:	6a 0a                	push   $0xa
  jmp alltraps
80108509:	e9 13 0a 00 00       	jmp    80108f21 <alltraps>

8010850e <vector11>:
.globl vector11
vector11:
  pushl $11
8010850e:	6a 0b                	push   $0xb
  jmp alltraps
80108510:	e9 0c 0a 00 00       	jmp    80108f21 <alltraps>

80108515 <vector12>:
.globl vector12
vector12:
  pushl $12
80108515:	6a 0c                	push   $0xc
  jmp alltraps
80108517:	e9 05 0a 00 00       	jmp    80108f21 <alltraps>

8010851c <vector13>:
.globl vector13
vector13:
  pushl $13
8010851c:	6a 0d                	push   $0xd
  jmp alltraps
8010851e:	e9 fe 09 00 00       	jmp    80108f21 <alltraps>

80108523 <vector14>:
.globl vector14
vector14:
  pushl $14
80108523:	6a 0e                	push   $0xe
  jmp alltraps
80108525:	e9 f7 09 00 00       	jmp    80108f21 <alltraps>

8010852a <vector15>:
.globl vector15
vector15:
  pushl $0
8010852a:	6a 00                	push   $0x0
  pushl $15
8010852c:	6a 0f                	push   $0xf
  jmp alltraps
8010852e:	e9 ee 09 00 00       	jmp    80108f21 <alltraps>

80108533 <vector16>:
.globl vector16
vector16:
  pushl $0
80108533:	6a 00                	push   $0x0
  pushl $16
80108535:	6a 10                	push   $0x10
  jmp alltraps
80108537:	e9 e5 09 00 00       	jmp    80108f21 <alltraps>

8010853c <vector17>:
.globl vector17
vector17:
  pushl $17
8010853c:	6a 11                	push   $0x11
  jmp alltraps
8010853e:	e9 de 09 00 00       	jmp    80108f21 <alltraps>

80108543 <vector18>:
.globl vector18
vector18:
  pushl $0
80108543:	6a 00                	push   $0x0
  pushl $18
80108545:	6a 12                	push   $0x12
  jmp alltraps
80108547:	e9 d5 09 00 00       	jmp    80108f21 <alltraps>

8010854c <vector19>:
.globl vector19
vector19:
  pushl $0
8010854c:	6a 00                	push   $0x0
  pushl $19
8010854e:	6a 13                	push   $0x13
  jmp alltraps
80108550:	e9 cc 09 00 00       	jmp    80108f21 <alltraps>

80108555 <vector20>:
.globl vector20
vector20:
  pushl $0
80108555:	6a 00                	push   $0x0
  pushl $20
80108557:	6a 14                	push   $0x14
  jmp alltraps
80108559:	e9 c3 09 00 00       	jmp    80108f21 <alltraps>

8010855e <vector21>:
.globl vector21
vector21:
  pushl $0
8010855e:	6a 00                	push   $0x0
  pushl $21
80108560:	6a 15                	push   $0x15
  jmp alltraps
80108562:	e9 ba 09 00 00       	jmp    80108f21 <alltraps>

80108567 <vector22>:
.globl vector22
vector22:
  pushl $0
80108567:	6a 00                	push   $0x0
  pushl $22
80108569:	6a 16                	push   $0x16
  jmp alltraps
8010856b:	e9 b1 09 00 00       	jmp    80108f21 <alltraps>

80108570 <vector23>:
.globl vector23
vector23:
  pushl $0
80108570:	6a 00                	push   $0x0
  pushl $23
80108572:	6a 17                	push   $0x17
  jmp alltraps
80108574:	e9 a8 09 00 00       	jmp    80108f21 <alltraps>

80108579 <vector24>:
.globl vector24
vector24:
  pushl $0
80108579:	6a 00                	push   $0x0
  pushl $24
8010857b:	6a 18                	push   $0x18
  jmp alltraps
8010857d:	e9 9f 09 00 00       	jmp    80108f21 <alltraps>

80108582 <vector25>:
.globl vector25
vector25:
  pushl $0
80108582:	6a 00                	push   $0x0
  pushl $25
80108584:	6a 19                	push   $0x19
  jmp alltraps
80108586:	e9 96 09 00 00       	jmp    80108f21 <alltraps>

8010858b <vector26>:
.globl vector26
vector26:
  pushl $0
8010858b:	6a 00                	push   $0x0
  pushl $26
8010858d:	6a 1a                	push   $0x1a
  jmp alltraps
8010858f:	e9 8d 09 00 00       	jmp    80108f21 <alltraps>

80108594 <vector27>:
.globl vector27
vector27:
  pushl $0
80108594:	6a 00                	push   $0x0
  pushl $27
80108596:	6a 1b                	push   $0x1b
  jmp alltraps
80108598:	e9 84 09 00 00       	jmp    80108f21 <alltraps>

8010859d <vector28>:
.globl vector28
vector28:
  pushl $0
8010859d:	6a 00                	push   $0x0
  pushl $28
8010859f:	6a 1c                	push   $0x1c
  jmp alltraps
801085a1:	e9 7b 09 00 00       	jmp    80108f21 <alltraps>

801085a6 <vector29>:
.globl vector29
vector29:
  pushl $0
801085a6:	6a 00                	push   $0x0
  pushl $29
801085a8:	6a 1d                	push   $0x1d
  jmp alltraps
801085aa:	e9 72 09 00 00       	jmp    80108f21 <alltraps>

801085af <vector30>:
.globl vector30
vector30:
  pushl $0
801085af:	6a 00                	push   $0x0
  pushl $30
801085b1:	6a 1e                	push   $0x1e
  jmp alltraps
801085b3:	e9 69 09 00 00       	jmp    80108f21 <alltraps>

801085b8 <vector31>:
.globl vector31
vector31:
  pushl $0
801085b8:	6a 00                	push   $0x0
  pushl $31
801085ba:	6a 1f                	push   $0x1f
  jmp alltraps
801085bc:	e9 60 09 00 00       	jmp    80108f21 <alltraps>

801085c1 <vector32>:
.globl vector32
vector32:
  pushl $0
801085c1:	6a 00                	push   $0x0
  pushl $32
801085c3:	6a 20                	push   $0x20
  jmp alltraps
801085c5:	e9 57 09 00 00       	jmp    80108f21 <alltraps>

801085ca <vector33>:
.globl vector33
vector33:
  pushl $0
801085ca:	6a 00                	push   $0x0
  pushl $33
801085cc:	6a 21                	push   $0x21
  jmp alltraps
801085ce:	e9 4e 09 00 00       	jmp    80108f21 <alltraps>

801085d3 <vector34>:
.globl vector34
vector34:
  pushl $0
801085d3:	6a 00                	push   $0x0
  pushl $34
801085d5:	6a 22                	push   $0x22
  jmp alltraps
801085d7:	e9 45 09 00 00       	jmp    80108f21 <alltraps>

801085dc <vector35>:
.globl vector35
vector35:
  pushl $0
801085dc:	6a 00                	push   $0x0
  pushl $35
801085de:	6a 23                	push   $0x23
  jmp alltraps
801085e0:	e9 3c 09 00 00       	jmp    80108f21 <alltraps>

801085e5 <vector36>:
.globl vector36
vector36:
  pushl $0
801085e5:	6a 00                	push   $0x0
  pushl $36
801085e7:	6a 24                	push   $0x24
  jmp alltraps
801085e9:	e9 33 09 00 00       	jmp    80108f21 <alltraps>

801085ee <vector37>:
.globl vector37
vector37:
  pushl $0
801085ee:	6a 00                	push   $0x0
  pushl $37
801085f0:	6a 25                	push   $0x25
  jmp alltraps
801085f2:	e9 2a 09 00 00       	jmp    80108f21 <alltraps>

801085f7 <vector38>:
.globl vector38
vector38:
  pushl $0
801085f7:	6a 00                	push   $0x0
  pushl $38
801085f9:	6a 26                	push   $0x26
  jmp alltraps
801085fb:	e9 21 09 00 00       	jmp    80108f21 <alltraps>

80108600 <vector39>:
.globl vector39
vector39:
  pushl $0
80108600:	6a 00                	push   $0x0
  pushl $39
80108602:	6a 27                	push   $0x27
  jmp alltraps
80108604:	e9 18 09 00 00       	jmp    80108f21 <alltraps>

80108609 <vector40>:
.globl vector40
vector40:
  pushl $0
80108609:	6a 00                	push   $0x0
  pushl $40
8010860b:	6a 28                	push   $0x28
  jmp alltraps
8010860d:	e9 0f 09 00 00       	jmp    80108f21 <alltraps>

80108612 <vector41>:
.globl vector41
vector41:
  pushl $0
80108612:	6a 00                	push   $0x0
  pushl $41
80108614:	6a 29                	push   $0x29
  jmp alltraps
80108616:	e9 06 09 00 00       	jmp    80108f21 <alltraps>

8010861b <vector42>:
.globl vector42
vector42:
  pushl $0
8010861b:	6a 00                	push   $0x0
  pushl $42
8010861d:	6a 2a                	push   $0x2a
  jmp alltraps
8010861f:	e9 fd 08 00 00       	jmp    80108f21 <alltraps>

80108624 <vector43>:
.globl vector43
vector43:
  pushl $0
80108624:	6a 00                	push   $0x0
  pushl $43
80108626:	6a 2b                	push   $0x2b
  jmp alltraps
80108628:	e9 f4 08 00 00       	jmp    80108f21 <alltraps>

8010862d <vector44>:
.globl vector44
vector44:
  pushl $0
8010862d:	6a 00                	push   $0x0
  pushl $44
8010862f:	6a 2c                	push   $0x2c
  jmp alltraps
80108631:	e9 eb 08 00 00       	jmp    80108f21 <alltraps>

80108636 <vector45>:
.globl vector45
vector45:
  pushl $0
80108636:	6a 00                	push   $0x0
  pushl $45
80108638:	6a 2d                	push   $0x2d
  jmp alltraps
8010863a:	e9 e2 08 00 00       	jmp    80108f21 <alltraps>

8010863f <vector46>:
.globl vector46
vector46:
  pushl $0
8010863f:	6a 00                	push   $0x0
  pushl $46
80108641:	6a 2e                	push   $0x2e
  jmp alltraps
80108643:	e9 d9 08 00 00       	jmp    80108f21 <alltraps>

80108648 <vector47>:
.globl vector47
vector47:
  pushl $0
80108648:	6a 00                	push   $0x0
  pushl $47
8010864a:	6a 2f                	push   $0x2f
  jmp alltraps
8010864c:	e9 d0 08 00 00       	jmp    80108f21 <alltraps>

80108651 <vector48>:
.globl vector48
vector48:
  pushl $0
80108651:	6a 00                	push   $0x0
  pushl $48
80108653:	6a 30                	push   $0x30
  jmp alltraps
80108655:	e9 c7 08 00 00       	jmp    80108f21 <alltraps>

8010865a <vector49>:
.globl vector49
vector49:
  pushl $0
8010865a:	6a 00                	push   $0x0
  pushl $49
8010865c:	6a 31                	push   $0x31
  jmp alltraps
8010865e:	e9 be 08 00 00       	jmp    80108f21 <alltraps>

80108663 <vector50>:
.globl vector50
vector50:
  pushl $0
80108663:	6a 00                	push   $0x0
  pushl $50
80108665:	6a 32                	push   $0x32
  jmp alltraps
80108667:	e9 b5 08 00 00       	jmp    80108f21 <alltraps>

8010866c <vector51>:
.globl vector51
vector51:
  pushl $0
8010866c:	6a 00                	push   $0x0
  pushl $51
8010866e:	6a 33                	push   $0x33
  jmp alltraps
80108670:	e9 ac 08 00 00       	jmp    80108f21 <alltraps>

80108675 <vector52>:
.globl vector52
vector52:
  pushl $0
80108675:	6a 00                	push   $0x0
  pushl $52
80108677:	6a 34                	push   $0x34
  jmp alltraps
80108679:	e9 a3 08 00 00       	jmp    80108f21 <alltraps>

8010867e <vector53>:
.globl vector53
vector53:
  pushl $0
8010867e:	6a 00                	push   $0x0
  pushl $53
80108680:	6a 35                	push   $0x35
  jmp alltraps
80108682:	e9 9a 08 00 00       	jmp    80108f21 <alltraps>

80108687 <vector54>:
.globl vector54
vector54:
  pushl $0
80108687:	6a 00                	push   $0x0
  pushl $54
80108689:	6a 36                	push   $0x36
  jmp alltraps
8010868b:	e9 91 08 00 00       	jmp    80108f21 <alltraps>

80108690 <vector55>:
.globl vector55
vector55:
  pushl $0
80108690:	6a 00                	push   $0x0
  pushl $55
80108692:	6a 37                	push   $0x37
  jmp alltraps
80108694:	e9 88 08 00 00       	jmp    80108f21 <alltraps>

80108699 <vector56>:
.globl vector56
vector56:
  pushl $0
80108699:	6a 00                	push   $0x0
  pushl $56
8010869b:	6a 38                	push   $0x38
  jmp alltraps
8010869d:	e9 7f 08 00 00       	jmp    80108f21 <alltraps>

801086a2 <vector57>:
.globl vector57
vector57:
  pushl $0
801086a2:	6a 00                	push   $0x0
  pushl $57
801086a4:	6a 39                	push   $0x39
  jmp alltraps
801086a6:	e9 76 08 00 00       	jmp    80108f21 <alltraps>

801086ab <vector58>:
.globl vector58
vector58:
  pushl $0
801086ab:	6a 00                	push   $0x0
  pushl $58
801086ad:	6a 3a                	push   $0x3a
  jmp alltraps
801086af:	e9 6d 08 00 00       	jmp    80108f21 <alltraps>

801086b4 <vector59>:
.globl vector59
vector59:
  pushl $0
801086b4:	6a 00                	push   $0x0
  pushl $59
801086b6:	6a 3b                	push   $0x3b
  jmp alltraps
801086b8:	e9 64 08 00 00       	jmp    80108f21 <alltraps>

801086bd <vector60>:
.globl vector60
vector60:
  pushl $0
801086bd:	6a 00                	push   $0x0
  pushl $60
801086bf:	6a 3c                	push   $0x3c
  jmp alltraps
801086c1:	e9 5b 08 00 00       	jmp    80108f21 <alltraps>

801086c6 <vector61>:
.globl vector61
vector61:
  pushl $0
801086c6:	6a 00                	push   $0x0
  pushl $61
801086c8:	6a 3d                	push   $0x3d
  jmp alltraps
801086ca:	e9 52 08 00 00       	jmp    80108f21 <alltraps>

801086cf <vector62>:
.globl vector62
vector62:
  pushl $0
801086cf:	6a 00                	push   $0x0
  pushl $62
801086d1:	6a 3e                	push   $0x3e
  jmp alltraps
801086d3:	e9 49 08 00 00       	jmp    80108f21 <alltraps>

801086d8 <vector63>:
.globl vector63
vector63:
  pushl $0
801086d8:	6a 00                	push   $0x0
  pushl $63
801086da:	6a 3f                	push   $0x3f
  jmp alltraps
801086dc:	e9 40 08 00 00       	jmp    80108f21 <alltraps>

801086e1 <vector64>:
.globl vector64
vector64:
  pushl $0
801086e1:	6a 00                	push   $0x0
  pushl $64
801086e3:	6a 40                	push   $0x40
  jmp alltraps
801086e5:	e9 37 08 00 00       	jmp    80108f21 <alltraps>

801086ea <vector65>:
.globl vector65
vector65:
  pushl $0
801086ea:	6a 00                	push   $0x0
  pushl $65
801086ec:	6a 41                	push   $0x41
  jmp alltraps
801086ee:	e9 2e 08 00 00       	jmp    80108f21 <alltraps>

801086f3 <vector66>:
.globl vector66
vector66:
  pushl $0
801086f3:	6a 00                	push   $0x0
  pushl $66
801086f5:	6a 42                	push   $0x42
  jmp alltraps
801086f7:	e9 25 08 00 00       	jmp    80108f21 <alltraps>

801086fc <vector67>:
.globl vector67
vector67:
  pushl $0
801086fc:	6a 00                	push   $0x0
  pushl $67
801086fe:	6a 43                	push   $0x43
  jmp alltraps
80108700:	e9 1c 08 00 00       	jmp    80108f21 <alltraps>

80108705 <vector68>:
.globl vector68
vector68:
  pushl $0
80108705:	6a 00                	push   $0x0
  pushl $68
80108707:	6a 44                	push   $0x44
  jmp alltraps
80108709:	e9 13 08 00 00       	jmp    80108f21 <alltraps>

8010870e <vector69>:
.globl vector69
vector69:
  pushl $0
8010870e:	6a 00                	push   $0x0
  pushl $69
80108710:	6a 45                	push   $0x45
  jmp alltraps
80108712:	e9 0a 08 00 00       	jmp    80108f21 <alltraps>

80108717 <vector70>:
.globl vector70
vector70:
  pushl $0
80108717:	6a 00                	push   $0x0
  pushl $70
80108719:	6a 46                	push   $0x46
  jmp alltraps
8010871b:	e9 01 08 00 00       	jmp    80108f21 <alltraps>

80108720 <vector71>:
.globl vector71
vector71:
  pushl $0
80108720:	6a 00                	push   $0x0
  pushl $71
80108722:	6a 47                	push   $0x47
  jmp alltraps
80108724:	e9 f8 07 00 00       	jmp    80108f21 <alltraps>

80108729 <vector72>:
.globl vector72
vector72:
  pushl $0
80108729:	6a 00                	push   $0x0
  pushl $72
8010872b:	6a 48                	push   $0x48
  jmp alltraps
8010872d:	e9 ef 07 00 00       	jmp    80108f21 <alltraps>

80108732 <vector73>:
.globl vector73
vector73:
  pushl $0
80108732:	6a 00                	push   $0x0
  pushl $73
80108734:	6a 49                	push   $0x49
  jmp alltraps
80108736:	e9 e6 07 00 00       	jmp    80108f21 <alltraps>

8010873b <vector74>:
.globl vector74
vector74:
  pushl $0
8010873b:	6a 00                	push   $0x0
  pushl $74
8010873d:	6a 4a                	push   $0x4a
  jmp alltraps
8010873f:	e9 dd 07 00 00       	jmp    80108f21 <alltraps>

80108744 <vector75>:
.globl vector75
vector75:
  pushl $0
80108744:	6a 00                	push   $0x0
  pushl $75
80108746:	6a 4b                	push   $0x4b
  jmp alltraps
80108748:	e9 d4 07 00 00       	jmp    80108f21 <alltraps>

8010874d <vector76>:
.globl vector76
vector76:
  pushl $0
8010874d:	6a 00                	push   $0x0
  pushl $76
8010874f:	6a 4c                	push   $0x4c
  jmp alltraps
80108751:	e9 cb 07 00 00       	jmp    80108f21 <alltraps>

80108756 <vector77>:
.globl vector77
vector77:
  pushl $0
80108756:	6a 00                	push   $0x0
  pushl $77
80108758:	6a 4d                	push   $0x4d
  jmp alltraps
8010875a:	e9 c2 07 00 00       	jmp    80108f21 <alltraps>

8010875f <vector78>:
.globl vector78
vector78:
  pushl $0
8010875f:	6a 00                	push   $0x0
  pushl $78
80108761:	6a 4e                	push   $0x4e
  jmp alltraps
80108763:	e9 b9 07 00 00       	jmp    80108f21 <alltraps>

80108768 <vector79>:
.globl vector79
vector79:
  pushl $0
80108768:	6a 00                	push   $0x0
  pushl $79
8010876a:	6a 4f                	push   $0x4f
  jmp alltraps
8010876c:	e9 b0 07 00 00       	jmp    80108f21 <alltraps>

80108771 <vector80>:
.globl vector80
vector80:
  pushl $0
80108771:	6a 00                	push   $0x0
  pushl $80
80108773:	6a 50                	push   $0x50
  jmp alltraps
80108775:	e9 a7 07 00 00       	jmp    80108f21 <alltraps>

8010877a <vector81>:
.globl vector81
vector81:
  pushl $0
8010877a:	6a 00                	push   $0x0
  pushl $81
8010877c:	6a 51                	push   $0x51
  jmp alltraps
8010877e:	e9 9e 07 00 00       	jmp    80108f21 <alltraps>

80108783 <vector82>:
.globl vector82
vector82:
  pushl $0
80108783:	6a 00                	push   $0x0
  pushl $82
80108785:	6a 52                	push   $0x52
  jmp alltraps
80108787:	e9 95 07 00 00       	jmp    80108f21 <alltraps>

8010878c <vector83>:
.globl vector83
vector83:
  pushl $0
8010878c:	6a 00                	push   $0x0
  pushl $83
8010878e:	6a 53                	push   $0x53
  jmp alltraps
80108790:	e9 8c 07 00 00       	jmp    80108f21 <alltraps>

80108795 <vector84>:
.globl vector84
vector84:
  pushl $0
80108795:	6a 00                	push   $0x0
  pushl $84
80108797:	6a 54                	push   $0x54
  jmp alltraps
80108799:	e9 83 07 00 00       	jmp    80108f21 <alltraps>

8010879e <vector85>:
.globl vector85
vector85:
  pushl $0
8010879e:	6a 00                	push   $0x0
  pushl $85
801087a0:	6a 55                	push   $0x55
  jmp alltraps
801087a2:	e9 7a 07 00 00       	jmp    80108f21 <alltraps>

801087a7 <vector86>:
.globl vector86
vector86:
  pushl $0
801087a7:	6a 00                	push   $0x0
  pushl $86
801087a9:	6a 56                	push   $0x56
  jmp alltraps
801087ab:	e9 71 07 00 00       	jmp    80108f21 <alltraps>

801087b0 <vector87>:
.globl vector87
vector87:
  pushl $0
801087b0:	6a 00                	push   $0x0
  pushl $87
801087b2:	6a 57                	push   $0x57
  jmp alltraps
801087b4:	e9 68 07 00 00       	jmp    80108f21 <alltraps>

801087b9 <vector88>:
.globl vector88
vector88:
  pushl $0
801087b9:	6a 00                	push   $0x0
  pushl $88
801087bb:	6a 58                	push   $0x58
  jmp alltraps
801087bd:	e9 5f 07 00 00       	jmp    80108f21 <alltraps>

801087c2 <vector89>:
.globl vector89
vector89:
  pushl $0
801087c2:	6a 00                	push   $0x0
  pushl $89
801087c4:	6a 59                	push   $0x59
  jmp alltraps
801087c6:	e9 56 07 00 00       	jmp    80108f21 <alltraps>

801087cb <vector90>:
.globl vector90
vector90:
  pushl $0
801087cb:	6a 00                	push   $0x0
  pushl $90
801087cd:	6a 5a                	push   $0x5a
  jmp alltraps
801087cf:	e9 4d 07 00 00       	jmp    80108f21 <alltraps>

801087d4 <vector91>:
.globl vector91
vector91:
  pushl $0
801087d4:	6a 00                	push   $0x0
  pushl $91
801087d6:	6a 5b                	push   $0x5b
  jmp alltraps
801087d8:	e9 44 07 00 00       	jmp    80108f21 <alltraps>

801087dd <vector92>:
.globl vector92
vector92:
  pushl $0
801087dd:	6a 00                	push   $0x0
  pushl $92
801087df:	6a 5c                	push   $0x5c
  jmp alltraps
801087e1:	e9 3b 07 00 00       	jmp    80108f21 <alltraps>

801087e6 <vector93>:
.globl vector93
vector93:
  pushl $0
801087e6:	6a 00                	push   $0x0
  pushl $93
801087e8:	6a 5d                	push   $0x5d
  jmp alltraps
801087ea:	e9 32 07 00 00       	jmp    80108f21 <alltraps>

801087ef <vector94>:
.globl vector94
vector94:
  pushl $0
801087ef:	6a 00                	push   $0x0
  pushl $94
801087f1:	6a 5e                	push   $0x5e
  jmp alltraps
801087f3:	e9 29 07 00 00       	jmp    80108f21 <alltraps>

801087f8 <vector95>:
.globl vector95
vector95:
  pushl $0
801087f8:	6a 00                	push   $0x0
  pushl $95
801087fa:	6a 5f                	push   $0x5f
  jmp alltraps
801087fc:	e9 20 07 00 00       	jmp    80108f21 <alltraps>

80108801 <vector96>:
.globl vector96
vector96:
  pushl $0
80108801:	6a 00                	push   $0x0
  pushl $96
80108803:	6a 60                	push   $0x60
  jmp alltraps
80108805:	e9 17 07 00 00       	jmp    80108f21 <alltraps>

8010880a <vector97>:
.globl vector97
vector97:
  pushl $0
8010880a:	6a 00                	push   $0x0
  pushl $97
8010880c:	6a 61                	push   $0x61
  jmp alltraps
8010880e:	e9 0e 07 00 00       	jmp    80108f21 <alltraps>

80108813 <vector98>:
.globl vector98
vector98:
  pushl $0
80108813:	6a 00                	push   $0x0
  pushl $98
80108815:	6a 62                	push   $0x62
  jmp alltraps
80108817:	e9 05 07 00 00       	jmp    80108f21 <alltraps>

8010881c <vector99>:
.globl vector99
vector99:
  pushl $0
8010881c:	6a 00                	push   $0x0
  pushl $99
8010881e:	6a 63                	push   $0x63
  jmp alltraps
80108820:	e9 fc 06 00 00       	jmp    80108f21 <alltraps>

80108825 <vector100>:
.globl vector100
vector100:
  pushl $0
80108825:	6a 00                	push   $0x0
  pushl $100
80108827:	6a 64                	push   $0x64
  jmp alltraps
80108829:	e9 f3 06 00 00       	jmp    80108f21 <alltraps>

8010882e <vector101>:
.globl vector101
vector101:
  pushl $0
8010882e:	6a 00                	push   $0x0
  pushl $101
80108830:	6a 65                	push   $0x65
  jmp alltraps
80108832:	e9 ea 06 00 00       	jmp    80108f21 <alltraps>

80108837 <vector102>:
.globl vector102
vector102:
  pushl $0
80108837:	6a 00                	push   $0x0
  pushl $102
80108839:	6a 66                	push   $0x66
  jmp alltraps
8010883b:	e9 e1 06 00 00       	jmp    80108f21 <alltraps>

80108840 <vector103>:
.globl vector103
vector103:
  pushl $0
80108840:	6a 00                	push   $0x0
  pushl $103
80108842:	6a 67                	push   $0x67
  jmp alltraps
80108844:	e9 d8 06 00 00       	jmp    80108f21 <alltraps>

80108849 <vector104>:
.globl vector104
vector104:
  pushl $0
80108849:	6a 00                	push   $0x0
  pushl $104
8010884b:	6a 68                	push   $0x68
  jmp alltraps
8010884d:	e9 cf 06 00 00       	jmp    80108f21 <alltraps>

80108852 <vector105>:
.globl vector105
vector105:
  pushl $0
80108852:	6a 00                	push   $0x0
  pushl $105
80108854:	6a 69                	push   $0x69
  jmp alltraps
80108856:	e9 c6 06 00 00       	jmp    80108f21 <alltraps>

8010885b <vector106>:
.globl vector106
vector106:
  pushl $0
8010885b:	6a 00                	push   $0x0
  pushl $106
8010885d:	6a 6a                	push   $0x6a
  jmp alltraps
8010885f:	e9 bd 06 00 00       	jmp    80108f21 <alltraps>

80108864 <vector107>:
.globl vector107
vector107:
  pushl $0
80108864:	6a 00                	push   $0x0
  pushl $107
80108866:	6a 6b                	push   $0x6b
  jmp alltraps
80108868:	e9 b4 06 00 00       	jmp    80108f21 <alltraps>

8010886d <vector108>:
.globl vector108
vector108:
  pushl $0
8010886d:	6a 00                	push   $0x0
  pushl $108
8010886f:	6a 6c                	push   $0x6c
  jmp alltraps
80108871:	e9 ab 06 00 00       	jmp    80108f21 <alltraps>

80108876 <vector109>:
.globl vector109
vector109:
  pushl $0
80108876:	6a 00                	push   $0x0
  pushl $109
80108878:	6a 6d                	push   $0x6d
  jmp alltraps
8010887a:	e9 a2 06 00 00       	jmp    80108f21 <alltraps>

8010887f <vector110>:
.globl vector110
vector110:
  pushl $0
8010887f:	6a 00                	push   $0x0
  pushl $110
80108881:	6a 6e                	push   $0x6e
  jmp alltraps
80108883:	e9 99 06 00 00       	jmp    80108f21 <alltraps>

80108888 <vector111>:
.globl vector111
vector111:
  pushl $0
80108888:	6a 00                	push   $0x0
  pushl $111
8010888a:	6a 6f                	push   $0x6f
  jmp alltraps
8010888c:	e9 90 06 00 00       	jmp    80108f21 <alltraps>

80108891 <vector112>:
.globl vector112
vector112:
  pushl $0
80108891:	6a 00                	push   $0x0
  pushl $112
80108893:	6a 70                	push   $0x70
  jmp alltraps
80108895:	e9 87 06 00 00       	jmp    80108f21 <alltraps>

8010889a <vector113>:
.globl vector113
vector113:
  pushl $0
8010889a:	6a 00                	push   $0x0
  pushl $113
8010889c:	6a 71                	push   $0x71
  jmp alltraps
8010889e:	e9 7e 06 00 00       	jmp    80108f21 <alltraps>

801088a3 <vector114>:
.globl vector114
vector114:
  pushl $0
801088a3:	6a 00                	push   $0x0
  pushl $114
801088a5:	6a 72                	push   $0x72
  jmp alltraps
801088a7:	e9 75 06 00 00       	jmp    80108f21 <alltraps>

801088ac <vector115>:
.globl vector115
vector115:
  pushl $0
801088ac:	6a 00                	push   $0x0
  pushl $115
801088ae:	6a 73                	push   $0x73
  jmp alltraps
801088b0:	e9 6c 06 00 00       	jmp    80108f21 <alltraps>

801088b5 <vector116>:
.globl vector116
vector116:
  pushl $0
801088b5:	6a 00                	push   $0x0
  pushl $116
801088b7:	6a 74                	push   $0x74
  jmp alltraps
801088b9:	e9 63 06 00 00       	jmp    80108f21 <alltraps>

801088be <vector117>:
.globl vector117
vector117:
  pushl $0
801088be:	6a 00                	push   $0x0
  pushl $117
801088c0:	6a 75                	push   $0x75
  jmp alltraps
801088c2:	e9 5a 06 00 00       	jmp    80108f21 <alltraps>

801088c7 <vector118>:
.globl vector118
vector118:
  pushl $0
801088c7:	6a 00                	push   $0x0
  pushl $118
801088c9:	6a 76                	push   $0x76
  jmp alltraps
801088cb:	e9 51 06 00 00       	jmp    80108f21 <alltraps>

801088d0 <vector119>:
.globl vector119
vector119:
  pushl $0
801088d0:	6a 00                	push   $0x0
  pushl $119
801088d2:	6a 77                	push   $0x77
  jmp alltraps
801088d4:	e9 48 06 00 00       	jmp    80108f21 <alltraps>

801088d9 <vector120>:
.globl vector120
vector120:
  pushl $0
801088d9:	6a 00                	push   $0x0
  pushl $120
801088db:	6a 78                	push   $0x78
  jmp alltraps
801088dd:	e9 3f 06 00 00       	jmp    80108f21 <alltraps>

801088e2 <vector121>:
.globl vector121
vector121:
  pushl $0
801088e2:	6a 00                	push   $0x0
  pushl $121
801088e4:	6a 79                	push   $0x79
  jmp alltraps
801088e6:	e9 36 06 00 00       	jmp    80108f21 <alltraps>

801088eb <vector122>:
.globl vector122
vector122:
  pushl $0
801088eb:	6a 00                	push   $0x0
  pushl $122
801088ed:	6a 7a                	push   $0x7a
  jmp alltraps
801088ef:	e9 2d 06 00 00       	jmp    80108f21 <alltraps>

801088f4 <vector123>:
.globl vector123
vector123:
  pushl $0
801088f4:	6a 00                	push   $0x0
  pushl $123
801088f6:	6a 7b                	push   $0x7b
  jmp alltraps
801088f8:	e9 24 06 00 00       	jmp    80108f21 <alltraps>

801088fd <vector124>:
.globl vector124
vector124:
  pushl $0
801088fd:	6a 00                	push   $0x0
  pushl $124
801088ff:	6a 7c                	push   $0x7c
  jmp alltraps
80108901:	e9 1b 06 00 00       	jmp    80108f21 <alltraps>

80108906 <vector125>:
.globl vector125
vector125:
  pushl $0
80108906:	6a 00                	push   $0x0
  pushl $125
80108908:	6a 7d                	push   $0x7d
  jmp alltraps
8010890a:	e9 12 06 00 00       	jmp    80108f21 <alltraps>

8010890f <vector126>:
.globl vector126
vector126:
  pushl $0
8010890f:	6a 00                	push   $0x0
  pushl $126
80108911:	6a 7e                	push   $0x7e
  jmp alltraps
80108913:	e9 09 06 00 00       	jmp    80108f21 <alltraps>

80108918 <vector127>:
.globl vector127
vector127:
  pushl $0
80108918:	6a 00                	push   $0x0
  pushl $127
8010891a:	6a 7f                	push   $0x7f
  jmp alltraps
8010891c:	e9 00 06 00 00       	jmp    80108f21 <alltraps>

80108921 <vector128>:
.globl vector128
vector128:
  pushl $0
80108921:	6a 00                	push   $0x0
  pushl $128
80108923:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80108928:	e9 f4 05 00 00       	jmp    80108f21 <alltraps>

8010892d <vector129>:
.globl vector129
vector129:
  pushl $0
8010892d:	6a 00                	push   $0x0
  pushl $129
8010892f:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80108934:	e9 e8 05 00 00       	jmp    80108f21 <alltraps>

80108939 <vector130>:
.globl vector130
vector130:
  pushl $0
80108939:	6a 00                	push   $0x0
  pushl $130
8010893b:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80108940:	e9 dc 05 00 00       	jmp    80108f21 <alltraps>

80108945 <vector131>:
.globl vector131
vector131:
  pushl $0
80108945:	6a 00                	push   $0x0
  pushl $131
80108947:	68 83 00 00 00       	push   $0x83
  jmp alltraps
8010894c:	e9 d0 05 00 00       	jmp    80108f21 <alltraps>

80108951 <vector132>:
.globl vector132
vector132:
  pushl $0
80108951:	6a 00                	push   $0x0
  pushl $132
80108953:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80108958:	e9 c4 05 00 00       	jmp    80108f21 <alltraps>

8010895d <vector133>:
.globl vector133
vector133:
  pushl $0
8010895d:	6a 00                	push   $0x0
  pushl $133
8010895f:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80108964:	e9 b8 05 00 00       	jmp    80108f21 <alltraps>

80108969 <vector134>:
.globl vector134
vector134:
  pushl $0
80108969:	6a 00                	push   $0x0
  pushl $134
8010896b:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80108970:	e9 ac 05 00 00       	jmp    80108f21 <alltraps>

80108975 <vector135>:
.globl vector135
vector135:
  pushl $0
80108975:	6a 00                	push   $0x0
  pushl $135
80108977:	68 87 00 00 00       	push   $0x87
  jmp alltraps
8010897c:	e9 a0 05 00 00       	jmp    80108f21 <alltraps>

80108981 <vector136>:
.globl vector136
vector136:
  pushl $0
80108981:	6a 00                	push   $0x0
  pushl $136
80108983:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80108988:	e9 94 05 00 00       	jmp    80108f21 <alltraps>

8010898d <vector137>:
.globl vector137
vector137:
  pushl $0
8010898d:	6a 00                	push   $0x0
  pushl $137
8010898f:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80108994:	e9 88 05 00 00       	jmp    80108f21 <alltraps>

80108999 <vector138>:
.globl vector138
vector138:
  pushl $0
80108999:	6a 00                	push   $0x0
  pushl $138
8010899b:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801089a0:	e9 7c 05 00 00       	jmp    80108f21 <alltraps>

801089a5 <vector139>:
.globl vector139
vector139:
  pushl $0
801089a5:	6a 00                	push   $0x0
  pushl $139
801089a7:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801089ac:	e9 70 05 00 00       	jmp    80108f21 <alltraps>

801089b1 <vector140>:
.globl vector140
vector140:
  pushl $0
801089b1:	6a 00                	push   $0x0
  pushl $140
801089b3:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801089b8:	e9 64 05 00 00       	jmp    80108f21 <alltraps>

801089bd <vector141>:
.globl vector141
vector141:
  pushl $0
801089bd:	6a 00                	push   $0x0
  pushl $141
801089bf:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801089c4:	e9 58 05 00 00       	jmp    80108f21 <alltraps>

801089c9 <vector142>:
.globl vector142
vector142:
  pushl $0
801089c9:	6a 00                	push   $0x0
  pushl $142
801089cb:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801089d0:	e9 4c 05 00 00       	jmp    80108f21 <alltraps>

801089d5 <vector143>:
.globl vector143
vector143:
  pushl $0
801089d5:	6a 00                	push   $0x0
  pushl $143
801089d7:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801089dc:	e9 40 05 00 00       	jmp    80108f21 <alltraps>

801089e1 <vector144>:
.globl vector144
vector144:
  pushl $0
801089e1:	6a 00                	push   $0x0
  pushl $144
801089e3:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801089e8:	e9 34 05 00 00       	jmp    80108f21 <alltraps>

801089ed <vector145>:
.globl vector145
vector145:
  pushl $0
801089ed:	6a 00                	push   $0x0
  pushl $145
801089ef:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801089f4:	e9 28 05 00 00       	jmp    80108f21 <alltraps>

801089f9 <vector146>:
.globl vector146
vector146:
  pushl $0
801089f9:	6a 00                	push   $0x0
  pushl $146
801089fb:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80108a00:	e9 1c 05 00 00       	jmp    80108f21 <alltraps>

80108a05 <vector147>:
.globl vector147
vector147:
  pushl $0
80108a05:	6a 00                	push   $0x0
  pushl $147
80108a07:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80108a0c:	e9 10 05 00 00       	jmp    80108f21 <alltraps>

80108a11 <vector148>:
.globl vector148
vector148:
  pushl $0
80108a11:	6a 00                	push   $0x0
  pushl $148
80108a13:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80108a18:	e9 04 05 00 00       	jmp    80108f21 <alltraps>

80108a1d <vector149>:
.globl vector149
vector149:
  pushl $0
80108a1d:	6a 00                	push   $0x0
  pushl $149
80108a1f:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80108a24:	e9 f8 04 00 00       	jmp    80108f21 <alltraps>

80108a29 <vector150>:
.globl vector150
vector150:
  pushl $0
80108a29:	6a 00                	push   $0x0
  pushl $150
80108a2b:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80108a30:	e9 ec 04 00 00       	jmp    80108f21 <alltraps>

80108a35 <vector151>:
.globl vector151
vector151:
  pushl $0
80108a35:	6a 00                	push   $0x0
  pushl $151
80108a37:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80108a3c:	e9 e0 04 00 00       	jmp    80108f21 <alltraps>

80108a41 <vector152>:
.globl vector152
vector152:
  pushl $0
80108a41:	6a 00                	push   $0x0
  pushl $152
80108a43:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80108a48:	e9 d4 04 00 00       	jmp    80108f21 <alltraps>

80108a4d <vector153>:
.globl vector153
vector153:
  pushl $0
80108a4d:	6a 00                	push   $0x0
  pushl $153
80108a4f:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80108a54:	e9 c8 04 00 00       	jmp    80108f21 <alltraps>

80108a59 <vector154>:
.globl vector154
vector154:
  pushl $0
80108a59:	6a 00                	push   $0x0
  pushl $154
80108a5b:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80108a60:	e9 bc 04 00 00       	jmp    80108f21 <alltraps>

80108a65 <vector155>:
.globl vector155
vector155:
  pushl $0
80108a65:	6a 00                	push   $0x0
  pushl $155
80108a67:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80108a6c:	e9 b0 04 00 00       	jmp    80108f21 <alltraps>

80108a71 <vector156>:
.globl vector156
vector156:
  pushl $0
80108a71:	6a 00                	push   $0x0
  pushl $156
80108a73:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80108a78:	e9 a4 04 00 00       	jmp    80108f21 <alltraps>

80108a7d <vector157>:
.globl vector157
vector157:
  pushl $0
80108a7d:	6a 00                	push   $0x0
  pushl $157
80108a7f:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80108a84:	e9 98 04 00 00       	jmp    80108f21 <alltraps>

80108a89 <vector158>:
.globl vector158
vector158:
  pushl $0
80108a89:	6a 00                	push   $0x0
  pushl $158
80108a8b:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80108a90:	e9 8c 04 00 00       	jmp    80108f21 <alltraps>

80108a95 <vector159>:
.globl vector159
vector159:
  pushl $0
80108a95:	6a 00                	push   $0x0
  pushl $159
80108a97:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80108a9c:	e9 80 04 00 00       	jmp    80108f21 <alltraps>

80108aa1 <vector160>:
.globl vector160
vector160:
  pushl $0
80108aa1:	6a 00                	push   $0x0
  pushl $160
80108aa3:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80108aa8:	e9 74 04 00 00       	jmp    80108f21 <alltraps>

80108aad <vector161>:
.globl vector161
vector161:
  pushl $0
80108aad:	6a 00                	push   $0x0
  pushl $161
80108aaf:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80108ab4:	e9 68 04 00 00       	jmp    80108f21 <alltraps>

80108ab9 <vector162>:
.globl vector162
vector162:
  pushl $0
80108ab9:	6a 00                	push   $0x0
  pushl $162
80108abb:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80108ac0:	e9 5c 04 00 00       	jmp    80108f21 <alltraps>

80108ac5 <vector163>:
.globl vector163
vector163:
  pushl $0
80108ac5:	6a 00                	push   $0x0
  pushl $163
80108ac7:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80108acc:	e9 50 04 00 00       	jmp    80108f21 <alltraps>

80108ad1 <vector164>:
.globl vector164
vector164:
  pushl $0
80108ad1:	6a 00                	push   $0x0
  pushl $164
80108ad3:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80108ad8:	e9 44 04 00 00       	jmp    80108f21 <alltraps>

80108add <vector165>:
.globl vector165
vector165:
  pushl $0
80108add:	6a 00                	push   $0x0
  pushl $165
80108adf:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80108ae4:	e9 38 04 00 00       	jmp    80108f21 <alltraps>

80108ae9 <vector166>:
.globl vector166
vector166:
  pushl $0
80108ae9:	6a 00                	push   $0x0
  pushl $166
80108aeb:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80108af0:	e9 2c 04 00 00       	jmp    80108f21 <alltraps>

80108af5 <vector167>:
.globl vector167
vector167:
  pushl $0
80108af5:	6a 00                	push   $0x0
  pushl $167
80108af7:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80108afc:	e9 20 04 00 00       	jmp    80108f21 <alltraps>

80108b01 <vector168>:
.globl vector168
vector168:
  pushl $0
80108b01:	6a 00                	push   $0x0
  pushl $168
80108b03:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80108b08:	e9 14 04 00 00       	jmp    80108f21 <alltraps>

80108b0d <vector169>:
.globl vector169
vector169:
  pushl $0
80108b0d:	6a 00                	push   $0x0
  pushl $169
80108b0f:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80108b14:	e9 08 04 00 00       	jmp    80108f21 <alltraps>

80108b19 <vector170>:
.globl vector170
vector170:
  pushl $0
80108b19:	6a 00                	push   $0x0
  pushl $170
80108b1b:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80108b20:	e9 fc 03 00 00       	jmp    80108f21 <alltraps>

80108b25 <vector171>:
.globl vector171
vector171:
  pushl $0
80108b25:	6a 00                	push   $0x0
  pushl $171
80108b27:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80108b2c:	e9 f0 03 00 00       	jmp    80108f21 <alltraps>

80108b31 <vector172>:
.globl vector172
vector172:
  pushl $0
80108b31:	6a 00                	push   $0x0
  pushl $172
80108b33:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80108b38:	e9 e4 03 00 00       	jmp    80108f21 <alltraps>

80108b3d <vector173>:
.globl vector173
vector173:
  pushl $0
80108b3d:	6a 00                	push   $0x0
  pushl $173
80108b3f:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80108b44:	e9 d8 03 00 00       	jmp    80108f21 <alltraps>

80108b49 <vector174>:
.globl vector174
vector174:
  pushl $0
80108b49:	6a 00                	push   $0x0
  pushl $174
80108b4b:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80108b50:	e9 cc 03 00 00       	jmp    80108f21 <alltraps>

80108b55 <vector175>:
.globl vector175
vector175:
  pushl $0
80108b55:	6a 00                	push   $0x0
  pushl $175
80108b57:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80108b5c:	e9 c0 03 00 00       	jmp    80108f21 <alltraps>

80108b61 <vector176>:
.globl vector176
vector176:
  pushl $0
80108b61:	6a 00                	push   $0x0
  pushl $176
80108b63:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80108b68:	e9 b4 03 00 00       	jmp    80108f21 <alltraps>

80108b6d <vector177>:
.globl vector177
vector177:
  pushl $0
80108b6d:	6a 00                	push   $0x0
  pushl $177
80108b6f:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80108b74:	e9 a8 03 00 00       	jmp    80108f21 <alltraps>

80108b79 <vector178>:
.globl vector178
vector178:
  pushl $0
80108b79:	6a 00                	push   $0x0
  pushl $178
80108b7b:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80108b80:	e9 9c 03 00 00       	jmp    80108f21 <alltraps>

80108b85 <vector179>:
.globl vector179
vector179:
  pushl $0
80108b85:	6a 00                	push   $0x0
  pushl $179
80108b87:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80108b8c:	e9 90 03 00 00       	jmp    80108f21 <alltraps>

80108b91 <vector180>:
.globl vector180
vector180:
  pushl $0
80108b91:	6a 00                	push   $0x0
  pushl $180
80108b93:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80108b98:	e9 84 03 00 00       	jmp    80108f21 <alltraps>

80108b9d <vector181>:
.globl vector181
vector181:
  pushl $0
80108b9d:	6a 00                	push   $0x0
  pushl $181
80108b9f:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80108ba4:	e9 78 03 00 00       	jmp    80108f21 <alltraps>

80108ba9 <vector182>:
.globl vector182
vector182:
  pushl $0
80108ba9:	6a 00                	push   $0x0
  pushl $182
80108bab:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80108bb0:	e9 6c 03 00 00       	jmp    80108f21 <alltraps>

80108bb5 <vector183>:
.globl vector183
vector183:
  pushl $0
80108bb5:	6a 00                	push   $0x0
  pushl $183
80108bb7:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80108bbc:	e9 60 03 00 00       	jmp    80108f21 <alltraps>

80108bc1 <vector184>:
.globl vector184
vector184:
  pushl $0
80108bc1:	6a 00                	push   $0x0
  pushl $184
80108bc3:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80108bc8:	e9 54 03 00 00       	jmp    80108f21 <alltraps>

80108bcd <vector185>:
.globl vector185
vector185:
  pushl $0
80108bcd:	6a 00                	push   $0x0
  pushl $185
80108bcf:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80108bd4:	e9 48 03 00 00       	jmp    80108f21 <alltraps>

80108bd9 <vector186>:
.globl vector186
vector186:
  pushl $0
80108bd9:	6a 00                	push   $0x0
  pushl $186
80108bdb:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80108be0:	e9 3c 03 00 00       	jmp    80108f21 <alltraps>

80108be5 <vector187>:
.globl vector187
vector187:
  pushl $0
80108be5:	6a 00                	push   $0x0
  pushl $187
80108be7:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80108bec:	e9 30 03 00 00       	jmp    80108f21 <alltraps>

80108bf1 <vector188>:
.globl vector188
vector188:
  pushl $0
80108bf1:	6a 00                	push   $0x0
  pushl $188
80108bf3:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80108bf8:	e9 24 03 00 00       	jmp    80108f21 <alltraps>

80108bfd <vector189>:
.globl vector189
vector189:
  pushl $0
80108bfd:	6a 00                	push   $0x0
  pushl $189
80108bff:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80108c04:	e9 18 03 00 00       	jmp    80108f21 <alltraps>

80108c09 <vector190>:
.globl vector190
vector190:
  pushl $0
80108c09:	6a 00                	push   $0x0
  pushl $190
80108c0b:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80108c10:	e9 0c 03 00 00       	jmp    80108f21 <alltraps>

80108c15 <vector191>:
.globl vector191
vector191:
  pushl $0
80108c15:	6a 00                	push   $0x0
  pushl $191
80108c17:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80108c1c:	e9 00 03 00 00       	jmp    80108f21 <alltraps>

80108c21 <vector192>:
.globl vector192
vector192:
  pushl $0
80108c21:	6a 00                	push   $0x0
  pushl $192
80108c23:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80108c28:	e9 f4 02 00 00       	jmp    80108f21 <alltraps>

80108c2d <vector193>:
.globl vector193
vector193:
  pushl $0
80108c2d:	6a 00                	push   $0x0
  pushl $193
80108c2f:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80108c34:	e9 e8 02 00 00       	jmp    80108f21 <alltraps>

80108c39 <vector194>:
.globl vector194
vector194:
  pushl $0
80108c39:	6a 00                	push   $0x0
  pushl $194
80108c3b:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80108c40:	e9 dc 02 00 00       	jmp    80108f21 <alltraps>

80108c45 <vector195>:
.globl vector195
vector195:
  pushl $0
80108c45:	6a 00                	push   $0x0
  pushl $195
80108c47:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80108c4c:	e9 d0 02 00 00       	jmp    80108f21 <alltraps>

80108c51 <vector196>:
.globl vector196
vector196:
  pushl $0
80108c51:	6a 00                	push   $0x0
  pushl $196
80108c53:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80108c58:	e9 c4 02 00 00       	jmp    80108f21 <alltraps>

80108c5d <vector197>:
.globl vector197
vector197:
  pushl $0
80108c5d:	6a 00                	push   $0x0
  pushl $197
80108c5f:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80108c64:	e9 b8 02 00 00       	jmp    80108f21 <alltraps>

80108c69 <vector198>:
.globl vector198
vector198:
  pushl $0
80108c69:	6a 00                	push   $0x0
  pushl $198
80108c6b:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80108c70:	e9 ac 02 00 00       	jmp    80108f21 <alltraps>

80108c75 <vector199>:
.globl vector199
vector199:
  pushl $0
80108c75:	6a 00                	push   $0x0
  pushl $199
80108c77:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80108c7c:	e9 a0 02 00 00       	jmp    80108f21 <alltraps>

80108c81 <vector200>:
.globl vector200
vector200:
  pushl $0
80108c81:	6a 00                	push   $0x0
  pushl $200
80108c83:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80108c88:	e9 94 02 00 00       	jmp    80108f21 <alltraps>

80108c8d <vector201>:
.globl vector201
vector201:
  pushl $0
80108c8d:	6a 00                	push   $0x0
  pushl $201
80108c8f:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80108c94:	e9 88 02 00 00       	jmp    80108f21 <alltraps>

80108c99 <vector202>:
.globl vector202
vector202:
  pushl $0
80108c99:	6a 00                	push   $0x0
  pushl $202
80108c9b:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80108ca0:	e9 7c 02 00 00       	jmp    80108f21 <alltraps>

80108ca5 <vector203>:
.globl vector203
vector203:
  pushl $0
80108ca5:	6a 00                	push   $0x0
  pushl $203
80108ca7:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80108cac:	e9 70 02 00 00       	jmp    80108f21 <alltraps>

80108cb1 <vector204>:
.globl vector204
vector204:
  pushl $0
80108cb1:	6a 00                	push   $0x0
  pushl $204
80108cb3:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80108cb8:	e9 64 02 00 00       	jmp    80108f21 <alltraps>

80108cbd <vector205>:
.globl vector205
vector205:
  pushl $0
80108cbd:	6a 00                	push   $0x0
  pushl $205
80108cbf:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80108cc4:	e9 58 02 00 00       	jmp    80108f21 <alltraps>

80108cc9 <vector206>:
.globl vector206
vector206:
  pushl $0
80108cc9:	6a 00                	push   $0x0
  pushl $206
80108ccb:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80108cd0:	e9 4c 02 00 00       	jmp    80108f21 <alltraps>

80108cd5 <vector207>:
.globl vector207
vector207:
  pushl $0
80108cd5:	6a 00                	push   $0x0
  pushl $207
80108cd7:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80108cdc:	e9 40 02 00 00       	jmp    80108f21 <alltraps>

80108ce1 <vector208>:
.globl vector208
vector208:
  pushl $0
80108ce1:	6a 00                	push   $0x0
  pushl $208
80108ce3:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80108ce8:	e9 34 02 00 00       	jmp    80108f21 <alltraps>

80108ced <vector209>:
.globl vector209
vector209:
  pushl $0
80108ced:	6a 00                	push   $0x0
  pushl $209
80108cef:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80108cf4:	e9 28 02 00 00       	jmp    80108f21 <alltraps>

80108cf9 <vector210>:
.globl vector210
vector210:
  pushl $0
80108cf9:	6a 00                	push   $0x0
  pushl $210
80108cfb:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80108d00:	e9 1c 02 00 00       	jmp    80108f21 <alltraps>

80108d05 <vector211>:
.globl vector211
vector211:
  pushl $0
80108d05:	6a 00                	push   $0x0
  pushl $211
80108d07:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80108d0c:	e9 10 02 00 00       	jmp    80108f21 <alltraps>

80108d11 <vector212>:
.globl vector212
vector212:
  pushl $0
80108d11:	6a 00                	push   $0x0
  pushl $212
80108d13:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80108d18:	e9 04 02 00 00       	jmp    80108f21 <alltraps>

80108d1d <vector213>:
.globl vector213
vector213:
  pushl $0
80108d1d:	6a 00                	push   $0x0
  pushl $213
80108d1f:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80108d24:	e9 f8 01 00 00       	jmp    80108f21 <alltraps>

80108d29 <vector214>:
.globl vector214
vector214:
  pushl $0
80108d29:	6a 00                	push   $0x0
  pushl $214
80108d2b:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80108d30:	e9 ec 01 00 00       	jmp    80108f21 <alltraps>

80108d35 <vector215>:
.globl vector215
vector215:
  pushl $0
80108d35:	6a 00                	push   $0x0
  pushl $215
80108d37:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80108d3c:	e9 e0 01 00 00       	jmp    80108f21 <alltraps>

80108d41 <vector216>:
.globl vector216
vector216:
  pushl $0
80108d41:	6a 00                	push   $0x0
  pushl $216
80108d43:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80108d48:	e9 d4 01 00 00       	jmp    80108f21 <alltraps>

80108d4d <vector217>:
.globl vector217
vector217:
  pushl $0
80108d4d:	6a 00                	push   $0x0
  pushl $217
80108d4f:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80108d54:	e9 c8 01 00 00       	jmp    80108f21 <alltraps>

80108d59 <vector218>:
.globl vector218
vector218:
  pushl $0
80108d59:	6a 00                	push   $0x0
  pushl $218
80108d5b:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80108d60:	e9 bc 01 00 00       	jmp    80108f21 <alltraps>

80108d65 <vector219>:
.globl vector219
vector219:
  pushl $0
80108d65:	6a 00                	push   $0x0
  pushl $219
80108d67:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80108d6c:	e9 b0 01 00 00       	jmp    80108f21 <alltraps>

80108d71 <vector220>:
.globl vector220
vector220:
  pushl $0
80108d71:	6a 00                	push   $0x0
  pushl $220
80108d73:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80108d78:	e9 a4 01 00 00       	jmp    80108f21 <alltraps>

80108d7d <vector221>:
.globl vector221
vector221:
  pushl $0
80108d7d:	6a 00                	push   $0x0
  pushl $221
80108d7f:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80108d84:	e9 98 01 00 00       	jmp    80108f21 <alltraps>

80108d89 <vector222>:
.globl vector222
vector222:
  pushl $0
80108d89:	6a 00                	push   $0x0
  pushl $222
80108d8b:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80108d90:	e9 8c 01 00 00       	jmp    80108f21 <alltraps>

80108d95 <vector223>:
.globl vector223
vector223:
  pushl $0
80108d95:	6a 00                	push   $0x0
  pushl $223
80108d97:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80108d9c:	e9 80 01 00 00       	jmp    80108f21 <alltraps>

80108da1 <vector224>:
.globl vector224
vector224:
  pushl $0
80108da1:	6a 00                	push   $0x0
  pushl $224
80108da3:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80108da8:	e9 74 01 00 00       	jmp    80108f21 <alltraps>

80108dad <vector225>:
.globl vector225
vector225:
  pushl $0
80108dad:	6a 00                	push   $0x0
  pushl $225
80108daf:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80108db4:	e9 68 01 00 00       	jmp    80108f21 <alltraps>

80108db9 <vector226>:
.globl vector226
vector226:
  pushl $0
80108db9:	6a 00                	push   $0x0
  pushl $226
80108dbb:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80108dc0:	e9 5c 01 00 00       	jmp    80108f21 <alltraps>

80108dc5 <vector227>:
.globl vector227
vector227:
  pushl $0
80108dc5:	6a 00                	push   $0x0
  pushl $227
80108dc7:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80108dcc:	e9 50 01 00 00       	jmp    80108f21 <alltraps>

80108dd1 <vector228>:
.globl vector228
vector228:
  pushl $0
80108dd1:	6a 00                	push   $0x0
  pushl $228
80108dd3:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80108dd8:	e9 44 01 00 00       	jmp    80108f21 <alltraps>

80108ddd <vector229>:
.globl vector229
vector229:
  pushl $0
80108ddd:	6a 00                	push   $0x0
  pushl $229
80108ddf:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80108de4:	e9 38 01 00 00       	jmp    80108f21 <alltraps>

80108de9 <vector230>:
.globl vector230
vector230:
  pushl $0
80108de9:	6a 00                	push   $0x0
  pushl $230
80108deb:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80108df0:	e9 2c 01 00 00       	jmp    80108f21 <alltraps>

80108df5 <vector231>:
.globl vector231
vector231:
  pushl $0
80108df5:	6a 00                	push   $0x0
  pushl $231
80108df7:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80108dfc:	e9 20 01 00 00       	jmp    80108f21 <alltraps>

80108e01 <vector232>:
.globl vector232
vector232:
  pushl $0
80108e01:	6a 00                	push   $0x0
  pushl $232
80108e03:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80108e08:	e9 14 01 00 00       	jmp    80108f21 <alltraps>

80108e0d <vector233>:
.globl vector233
vector233:
  pushl $0
80108e0d:	6a 00                	push   $0x0
  pushl $233
80108e0f:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80108e14:	e9 08 01 00 00       	jmp    80108f21 <alltraps>

80108e19 <vector234>:
.globl vector234
vector234:
  pushl $0
80108e19:	6a 00                	push   $0x0
  pushl $234
80108e1b:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80108e20:	e9 fc 00 00 00       	jmp    80108f21 <alltraps>

80108e25 <vector235>:
.globl vector235
vector235:
  pushl $0
80108e25:	6a 00                	push   $0x0
  pushl $235
80108e27:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80108e2c:	e9 f0 00 00 00       	jmp    80108f21 <alltraps>

80108e31 <vector236>:
.globl vector236
vector236:
  pushl $0
80108e31:	6a 00                	push   $0x0
  pushl $236
80108e33:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80108e38:	e9 e4 00 00 00       	jmp    80108f21 <alltraps>

80108e3d <vector237>:
.globl vector237
vector237:
  pushl $0
80108e3d:	6a 00                	push   $0x0
  pushl $237
80108e3f:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80108e44:	e9 d8 00 00 00       	jmp    80108f21 <alltraps>

80108e49 <vector238>:
.globl vector238
vector238:
  pushl $0
80108e49:	6a 00                	push   $0x0
  pushl $238
80108e4b:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80108e50:	e9 cc 00 00 00       	jmp    80108f21 <alltraps>

80108e55 <vector239>:
.globl vector239
vector239:
  pushl $0
80108e55:	6a 00                	push   $0x0
  pushl $239
80108e57:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80108e5c:	e9 c0 00 00 00       	jmp    80108f21 <alltraps>

80108e61 <vector240>:
.globl vector240
vector240:
  pushl $0
80108e61:	6a 00                	push   $0x0
  pushl $240
80108e63:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80108e68:	e9 b4 00 00 00       	jmp    80108f21 <alltraps>

80108e6d <vector241>:
.globl vector241
vector241:
  pushl $0
80108e6d:	6a 00                	push   $0x0
  pushl $241
80108e6f:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80108e74:	e9 a8 00 00 00       	jmp    80108f21 <alltraps>

80108e79 <vector242>:
.globl vector242
vector242:
  pushl $0
80108e79:	6a 00                	push   $0x0
  pushl $242
80108e7b:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80108e80:	e9 9c 00 00 00       	jmp    80108f21 <alltraps>

80108e85 <vector243>:
.globl vector243
vector243:
  pushl $0
80108e85:	6a 00                	push   $0x0
  pushl $243
80108e87:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80108e8c:	e9 90 00 00 00       	jmp    80108f21 <alltraps>

80108e91 <vector244>:
.globl vector244
vector244:
  pushl $0
80108e91:	6a 00                	push   $0x0
  pushl $244
80108e93:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80108e98:	e9 84 00 00 00       	jmp    80108f21 <alltraps>

80108e9d <vector245>:
.globl vector245
vector245:
  pushl $0
80108e9d:	6a 00                	push   $0x0
  pushl $245
80108e9f:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80108ea4:	e9 78 00 00 00       	jmp    80108f21 <alltraps>

80108ea9 <vector246>:
.globl vector246
vector246:
  pushl $0
80108ea9:	6a 00                	push   $0x0
  pushl $246
80108eab:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80108eb0:	e9 6c 00 00 00       	jmp    80108f21 <alltraps>

80108eb5 <vector247>:
.globl vector247
vector247:
  pushl $0
80108eb5:	6a 00                	push   $0x0
  pushl $247
80108eb7:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80108ebc:	e9 60 00 00 00       	jmp    80108f21 <alltraps>

80108ec1 <vector248>:
.globl vector248
vector248:
  pushl $0
80108ec1:	6a 00                	push   $0x0
  pushl $248
80108ec3:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80108ec8:	e9 54 00 00 00       	jmp    80108f21 <alltraps>

80108ecd <vector249>:
.globl vector249
vector249:
  pushl $0
80108ecd:	6a 00                	push   $0x0
  pushl $249
80108ecf:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80108ed4:	e9 48 00 00 00       	jmp    80108f21 <alltraps>

80108ed9 <vector250>:
.globl vector250
vector250:
  pushl $0
80108ed9:	6a 00                	push   $0x0
  pushl $250
80108edb:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80108ee0:	e9 3c 00 00 00       	jmp    80108f21 <alltraps>

80108ee5 <vector251>:
.globl vector251
vector251:
  pushl $0
80108ee5:	6a 00                	push   $0x0
  pushl $251
80108ee7:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80108eec:	e9 30 00 00 00       	jmp    80108f21 <alltraps>

80108ef1 <vector252>:
.globl vector252
vector252:
  pushl $0
80108ef1:	6a 00                	push   $0x0
  pushl $252
80108ef3:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80108ef8:	e9 24 00 00 00       	jmp    80108f21 <alltraps>

80108efd <vector253>:
.globl vector253
vector253:
  pushl $0
80108efd:	6a 00                	push   $0x0
  pushl $253
80108eff:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80108f04:	e9 18 00 00 00       	jmp    80108f21 <alltraps>

80108f09 <vector254>:
.globl vector254
vector254:
  pushl $0
80108f09:	6a 00                	push   $0x0
  pushl $254
80108f0b:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80108f10:	e9 0c 00 00 00       	jmp    80108f21 <alltraps>

80108f15 <vector255>:
.globl vector255
vector255:
  pushl $0
80108f15:	6a 00                	push   $0x0
  pushl $255
80108f17:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80108f1c:	e9 00 00 00 00       	jmp    80108f21 <alltraps>

80108f21 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80108f21:	1e                   	push   %ds
  pushl %es
80108f22:	06                   	push   %es
  pushl %fs
80108f23:	0f a0                	push   %fs
  pushl %gs
80108f25:	0f a8                	push   %gs
  pushal
80108f27:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80108f28:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80108f2c:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80108f2e:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80108f30:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80108f34:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80108f36:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80108f38:	54                   	push   %esp
  call trap
80108f39:	e8 fc f0 ff ff       	call   8010803a <trap>
  addl $4, %esp
80108f3e:	83 c4 04             	add    $0x4,%esp

80108f41 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80108f41:	61                   	popa   
  popl %gs
80108f42:	0f a9                	pop    %gs
  popl %fs
80108f44:	0f a1                	pop    %fs
  popl %es
80108f46:	07                   	pop    %es
  popl %ds
80108f47:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80108f48:	83 c4 08             	add    $0x8,%esp
  iret
80108f4b:	cf                   	iret   

80108f4c <lgdt>:
{
80108f4c:	55                   	push   %ebp
80108f4d:	89 e5                	mov    %esp,%ebp
80108f4f:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80108f52:	8b 45 0c             	mov    0xc(%ebp),%eax
80108f55:	83 e8 01             	sub    $0x1,%eax
80108f58:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80108f5c:	8b 45 08             	mov    0x8(%ebp),%eax
80108f5f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80108f63:	8b 45 08             	mov    0x8(%ebp),%eax
80108f66:	c1 e8 10             	shr    $0x10,%eax
80108f69:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80108f6d:	8d 45 fa             	lea    -0x6(%ebp),%eax
80108f70:	0f 01 10             	lgdtl  (%eax)
}
80108f73:	90                   	nop
80108f74:	c9                   	leave  
80108f75:	c3                   	ret    

80108f76 <ltr>:
{
80108f76:	55                   	push   %ebp
80108f77:	89 e5                	mov    %esp,%ebp
80108f79:	83 ec 04             	sub    $0x4,%esp
80108f7c:	8b 45 08             	mov    0x8(%ebp),%eax
80108f7f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80108f83:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80108f87:	0f 00 d8             	ltr    %ax
}
80108f8a:	90                   	nop
80108f8b:	c9                   	leave  
80108f8c:	c3                   	ret    

80108f8d <loadgs>:
{
80108f8d:	55                   	push   %ebp
80108f8e:	89 e5                	mov    %esp,%ebp
80108f90:	83 ec 04             	sub    $0x4,%esp
80108f93:	8b 45 08             	mov    0x8(%ebp),%eax
80108f96:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80108f9a:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80108f9e:	8e e8                	mov    %eax,%gs
}
80108fa0:	90                   	nop
80108fa1:	c9                   	leave  
80108fa2:	c3                   	ret    

80108fa3 <lcr3>:

static inline void
lcr3(uint val) 
{
80108fa3:	55                   	push   %ebp
80108fa4:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108fa6:	8b 45 08             	mov    0x8(%ebp),%eax
80108fa9:	0f 22 d8             	mov    %eax,%cr3
}
80108fac:	90                   	nop
80108fad:	5d                   	pop    %ebp
80108fae:	c3                   	ret    

80108faf <v2p>:
static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80108faf:	55                   	push   %ebp
80108fb0:	89 e5                	mov    %esp,%ebp
80108fb2:	8b 45 08             	mov    0x8(%ebp),%eax
80108fb5:	05 00 00 00 80       	add    $0x80000000,%eax
80108fba:	5d                   	pop    %ebp
80108fbb:	c3                   	ret    

80108fbc <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80108fbc:	55                   	push   %ebp
80108fbd:	89 e5                	mov    %esp,%ebp
80108fbf:	8b 45 08             	mov    0x8(%ebp),%eax
80108fc2:	05 00 00 00 80       	add    $0x80000000,%eax
80108fc7:	5d                   	pop    %ebp
80108fc8:	c3                   	ret    

80108fc9 <seginit>:
pde_t *kpgdir;      // for use in scheduler()
struct segdesc gdt[NSEGS];

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void seginit(void) {
80108fc9:	f3 0f 1e fb          	endbr32 
80108fcd:	55                   	push   %ebp
80108fce:	89 e5                	mov    %esp,%ebp
80108fd0:	53                   	push   %ebx
80108fd1:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80108fd4:	e8 e7 a0 ff ff       	call   801030c0 <cpunum>
80108fd9:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80108fdf:	05 40 34 11 80       	add    $0x80113440,%eax
80108fe4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, 0);
80108fe7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fea:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80108ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ff3:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80108ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ffc:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80109000:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109003:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80109007:	83 e2 f0             	and    $0xfffffff0,%edx
8010900a:	83 ca 0a             	or     $0xa,%edx
8010900d:	88 50 7d             	mov    %dl,0x7d(%eax)
80109010:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109013:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80109017:	83 ca 10             	or     $0x10,%edx
8010901a:	88 50 7d             	mov    %dl,0x7d(%eax)
8010901d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109020:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80109024:	83 e2 9f             	and    $0xffffff9f,%edx
80109027:	88 50 7d             	mov    %dl,0x7d(%eax)
8010902a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010902d:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80109031:	83 ca 80             	or     $0xffffff80,%edx
80109034:	88 50 7d             	mov    %dl,0x7d(%eax)
80109037:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010903a:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010903e:	83 ca 0f             	or     $0xf,%edx
80109041:	88 50 7e             	mov    %dl,0x7e(%eax)
80109044:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109047:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010904b:	83 e2 ef             	and    $0xffffffef,%edx
8010904e:	88 50 7e             	mov    %dl,0x7e(%eax)
80109051:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109054:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80109058:	83 e2 df             	and    $0xffffffdf,%edx
8010905b:	88 50 7e             	mov    %dl,0x7e(%eax)
8010905e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109061:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80109065:	83 ca 40             	or     $0x40,%edx
80109068:	88 50 7e             	mov    %dl,0x7e(%eax)
8010906b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010906e:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80109072:	83 ca 80             	or     $0xffffff80,%edx
80109075:	88 50 7e             	mov    %dl,0x7e(%eax)
80109078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010907b:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010907f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109082:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80109089:	ff ff 
8010908b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010908e:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80109095:	00 00 
80109097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010909a:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
801090a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090a4:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801090ab:	83 e2 f0             	and    $0xfffffff0,%edx
801090ae:	83 ca 02             	or     $0x2,%edx
801090b1:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801090b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090ba:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801090c1:	83 ca 10             	or     $0x10,%edx
801090c4:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801090ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090cd:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801090d4:	83 e2 9f             	and    $0xffffff9f,%edx
801090d7:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801090dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090e0:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801090e7:	83 ca 80             	or     $0xffffff80,%edx
801090ea:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801090f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090f3:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801090fa:	83 ca 0f             	or     $0xf,%edx
801090fd:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80109103:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109106:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010910d:	83 e2 ef             	and    $0xffffffef,%edx
80109110:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80109116:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109119:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80109120:	83 e2 df             	and    $0xffffffdf,%edx
80109123:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80109129:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010912c:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80109133:	83 ca 40             	or     $0x40,%edx
80109136:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010913c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010913f:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80109146:	83 ca 80             	or     $0xffffff80,%edx
80109149:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010914f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109152:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, DPL_USER);
80109159:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010915c:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80109163:	ff ff 
80109165:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109168:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
8010916f:	00 00 
80109171:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109174:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
8010917b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010917e:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80109185:	83 e2 f0             	and    $0xfffffff0,%edx
80109188:	83 ca 0a             	or     $0xa,%edx
8010918b:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80109191:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109194:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010919b:	83 ca 10             	or     $0x10,%edx
8010919e:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801091a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091a7:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801091ae:	83 ca 60             	or     $0x60,%edx
801091b1:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801091b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091ba:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801091c1:	83 ca 80             	or     $0xffffff80,%edx
801091c4:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801091ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091cd:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801091d4:	83 ca 0f             	or     $0xf,%edx
801091d7:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801091dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091e0:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801091e7:	83 e2 ef             	and    $0xffffffef,%edx
801091ea:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801091f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091f3:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801091fa:	83 e2 df             	and    $0xffffffdf,%edx
801091fd:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80109203:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109206:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010920d:	83 ca 40             	or     $0x40,%edx
80109210:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80109216:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109219:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80109220:	83 ca 80             	or     $0xffffff80,%edx
80109223:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80109229:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010922c:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80109233:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109236:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
8010923d:	ff ff 
8010923f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109242:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80109249:	00 00 
8010924b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010924e:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80109255:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109258:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010925f:	83 e2 f0             	and    $0xfffffff0,%edx
80109262:	83 ca 02             	or     $0x2,%edx
80109265:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010926b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010926e:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80109275:	83 ca 10             	or     $0x10,%edx
80109278:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010927e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109281:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80109288:	83 ca 60             	or     $0x60,%edx
8010928b:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80109291:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109294:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010929b:	83 ca 80             	or     $0xffffff80,%edx
8010929e:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801092a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092a7:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801092ae:	83 ca 0f             	or     $0xf,%edx
801092b1:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801092b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092ba:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801092c1:	83 e2 ef             	and    $0xffffffef,%edx
801092c4:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801092ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092cd:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801092d4:	83 e2 df             	and    $0xffffffdf,%edx
801092d7:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801092dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092e0:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801092e7:	83 ca 40             	or     $0x40,%edx
801092ea:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801092f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092f3:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801092fa:	83 ca 80             	or     $0xffffff80,%edx
801092fd:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80109303:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109306:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
8010930d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109310:	05 b4 00 00 00       	add    $0xb4,%eax
80109315:	89 c3                	mov    %eax,%ebx
80109317:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010931a:	05 b4 00 00 00       	add    $0xb4,%eax
8010931f:	c1 e8 10             	shr    $0x10,%eax
80109322:	89 c2                	mov    %eax,%edx
80109324:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109327:	05 b4 00 00 00       	add    $0xb4,%eax
8010932c:	c1 e8 18             	shr    $0x18,%eax
8010932f:	89 c1                	mov    %eax,%ecx
80109331:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109334:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
8010933b:	00 00 
8010933d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109340:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80109347:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010934a:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
80109350:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109353:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010935a:	83 e2 f0             	and    $0xfffffff0,%edx
8010935d:	83 ca 02             	or     $0x2,%edx
80109360:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80109366:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109369:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80109370:	83 ca 10             	or     $0x10,%edx
80109373:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80109379:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010937c:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80109383:	83 e2 9f             	and    $0xffffff9f,%edx
80109386:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010938c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010938f:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80109396:	83 ca 80             	or     $0xffffff80,%edx
80109399:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010939f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093a2:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801093a9:	83 e2 f0             	and    $0xfffffff0,%edx
801093ac:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801093b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093b5:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801093bc:	83 e2 ef             	and    $0xffffffef,%edx
801093bf:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801093c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093c8:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801093cf:	83 e2 df             	and    $0xffffffdf,%edx
801093d2:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801093d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093db:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801093e2:	83 ca 40             	or     $0x40,%edx
801093e5:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801093eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093ee:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801093f5:	83 ca 80             	or     $0xffffff80,%edx
801093f8:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801093fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109401:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80109407:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010940a:	83 c0 70             	add    $0x70,%eax
8010940d:	83 ec 08             	sub    $0x8,%esp
80109410:	6a 38                	push   $0x38
80109412:	50                   	push   %eax
80109413:	e8 34 fb ff ff       	call   80108f4c <lgdt>
80109418:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
8010941b:	83 ec 0c             	sub    $0xc,%esp
8010941e:	6a 18                	push   $0x18
80109420:	e8 68 fb ff ff       	call   80108f8d <loadgs>
80109425:	83 c4 10             	add    $0x10,%esp

  // Initialize cpu-local storage.
  cpu = c;
80109428:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010942b:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80109431:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80109438:	00 00 00 00 
}
8010943c:	90                   	nop
8010943d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109440:	c9                   	leave  
80109441:	c3                   	ret    

80109442 <walkpgdir>:

// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *walkpgdir(pde_t *pgdir, const void *va, int alloc) {
80109442:	f3 0f 1e fb          	endbr32 
80109446:	55                   	push   %ebp
80109447:	89 e5                	mov    %esp,%ebp
80109449:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010944c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010944f:	c1 e8 16             	shr    $0x16,%eax
80109452:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109459:	8b 45 08             	mov    0x8(%ebp),%eax
8010945c:	01 d0                	add    %edx,%eax
8010945e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if (*pde & PTE_P) {
80109461:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109464:	8b 00                	mov    (%eax),%eax
80109466:	83 e0 01             	and    $0x1,%eax
80109469:	85 c0                	test   %eax,%eax
8010946b:	74 18                	je     80109485 <walkpgdir+0x43>
    pgtab = (pte_t *)p2v(PTE_ADDR(*pde));
8010946d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109470:	8b 00                	mov    (%eax),%eax
80109472:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109477:	50                   	push   %eax
80109478:	e8 3f fb ff ff       	call   80108fbc <p2v>
8010947d:	83 c4 04             	add    $0x4,%esp
80109480:	89 45 f4             	mov    %eax,-0xc(%ebp)
80109483:	eb 48                	jmp    801094cd <walkpgdir+0x8b>
  } else {
    if (!alloc || (pgtab = (pte_t *)kalloc()) == 0)
80109485:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80109489:	74 0e                	je     80109499 <walkpgdir+0x57>
8010948b:	e8 b3 98 ff ff       	call   80102d43 <kalloc>
80109490:	89 45 f4             	mov    %eax,-0xc(%ebp)
80109493:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80109497:	75 07                	jne    801094a0 <walkpgdir+0x5e>
      return 0;
80109499:	b8 00 00 00 00       	mov    $0x0,%eax
8010949e:	eb 44                	jmp    801094e4 <walkpgdir+0xa2>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801094a0:	83 ec 04             	sub    $0x4,%esp
801094a3:	68 00 10 00 00       	push   $0x1000
801094a8:	6a 00                	push   $0x0
801094aa:	ff 75 f4             	pushl  -0xc(%ebp)
801094ad:	e8 f2 bf ff ff       	call   801054a4 <memset>
801094b2:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
801094b5:	83 ec 0c             	sub    $0xc,%esp
801094b8:	ff 75 f4             	pushl  -0xc(%ebp)
801094bb:	e8 ef fa ff ff       	call   80108faf <v2p>
801094c0:	83 c4 10             	add    $0x10,%esp
801094c3:	83 c8 07             	or     $0x7,%eax
801094c6:	89 c2                	mov    %eax,%edx
801094c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801094cb:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801094cd:	8b 45 0c             	mov    0xc(%ebp),%eax
801094d0:	c1 e8 0c             	shr    $0xc,%eax
801094d3:	25 ff 03 00 00       	and    $0x3ff,%eax
801094d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801094df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094e2:	01 d0                	add    %edx,%eax
}
801094e4:	c9                   	leave  
801094e5:	c3                   	ret    

801094e6 <mappages>:

// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm) {
801094e6:	f3 0f 1e fb          	endbr32 
801094ea:	55                   	push   %ebp
801094eb:	89 e5                	mov    %esp,%ebp
801094ed:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;

  a = (char *)PGROUNDDOWN((uint)va);
801094f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801094f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801094f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char *)PGROUNDDOWN(((uint)va) + size - 1);
801094fb:	8b 55 0c             	mov    0xc(%ebp),%edx
801094fe:	8b 45 10             	mov    0x10(%ebp),%eax
80109501:	01 d0                	add    %edx,%eax
80109503:	83 e8 01             	sub    $0x1,%eax
80109506:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010950b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for (;;) {
    if ((pte = walkpgdir(pgdir, a, 1)) == 0)
8010950e:	83 ec 04             	sub    $0x4,%esp
80109511:	6a 01                	push   $0x1
80109513:	ff 75 f4             	pushl  -0xc(%ebp)
80109516:	ff 75 08             	pushl  0x8(%ebp)
80109519:	e8 24 ff ff ff       	call   80109442 <walkpgdir>
8010951e:	83 c4 10             	add    $0x10,%esp
80109521:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109524:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109528:	75 07                	jne    80109531 <mappages+0x4b>
      return -1;
8010952a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010952f:	eb 47                	jmp    80109578 <mappages+0x92>
    if (*pte & PTE_P)
80109531:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109534:	8b 00                	mov    (%eax),%eax
80109536:	83 e0 01             	and    $0x1,%eax
80109539:	85 c0                	test   %eax,%eax
8010953b:	74 0d                	je     8010954a <mappages+0x64>
      panic("remap");
8010953d:	83 ec 0c             	sub    $0xc,%esp
80109540:	68 e4 a5 10 80       	push   $0x8010a5e4
80109545:	e8 19 70 ff ff       	call   80100563 <panic>
    *pte = pa | perm | PTE_P;
8010954a:	8b 45 18             	mov    0x18(%ebp),%eax
8010954d:	0b 45 14             	or     0x14(%ebp),%eax
80109550:	83 c8 01             	or     $0x1,%eax
80109553:	89 c2                	mov    %eax,%edx
80109555:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109558:	89 10                	mov    %edx,(%eax)
    if (a == last)
8010955a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010955d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80109560:	74 10                	je     80109572 <mappages+0x8c>
      break;
    a += PGSIZE;
80109562:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80109569:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
    if ((pte = walkpgdir(pgdir, a, 1)) == 0)
80109570:	eb 9c                	jmp    8010950e <mappages+0x28>
      break;
80109572:	90                   	nop
  }
  return 0;
80109573:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109578:	c9                   	leave  
80109579:	c3                   	ret    

8010957a <setupkvm>:
    {(void *)data, V2P(data), PHYSTOP, PTE_W},       // kern data+memory
    {(void *)DEVSPACE, DEVSPACE, 0, PTE_W},          // more devices
};

// Set up kernel part of a page table.
pde_t *setupkvm(void) {
8010957a:	f3 0f 1e fb          	endbr32 
8010957e:	55                   	push   %ebp
8010957f:	89 e5                	mov    %esp,%ebp
80109581:	53                   	push   %ebx
80109582:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if ((pgdir = (pde_t *)kalloc()) == 0)
80109585:	e8 b9 97 ff ff       	call   80102d43 <kalloc>
8010958a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010958d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109591:	75 0a                	jne    8010959d <setupkvm+0x23>
    return 0;
80109593:	b8 00 00 00 00       	mov    $0x0,%eax
80109598:	e9 8e 00 00 00       	jmp    8010962b <setupkvm+0xb1>
  memset(pgdir, 0, PGSIZE);
8010959d:	83 ec 04             	sub    $0x4,%esp
801095a0:	68 00 10 00 00       	push   $0x1000
801095a5:	6a 00                	push   $0x0
801095a7:	ff 75 f0             	pushl  -0x10(%ebp)
801095aa:	e8 f5 be ff ff       	call   801054a4 <memset>
801095af:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void *)DEVSPACE)
801095b2:	83 ec 0c             	sub    $0xc,%esp
801095b5:	68 00 00 00 0e       	push   $0xe000000
801095ba:	e8 fd f9 ff ff       	call   80108fbc <p2v>
801095bf:	83 c4 10             	add    $0x10,%esp
801095c2:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
801095c7:	76 0d                	jbe    801095d6 <setupkvm+0x5c>
    panic("PHYSTOP too high");
801095c9:	83 ec 0c             	sub    $0xc,%esp
801095cc:	68 ea a5 10 80       	push   $0x8010a5ea
801095d1:	e8 8d 6f ff ff       	call   80100563 <panic>
  for (k = kmap; k < &kmap[NELEM(kmap)]; k++)
801095d6:	c7 45 f4 60 d5 10 80 	movl   $0x8010d560,-0xc(%ebp)
801095dd:	eb 40                	jmp    8010961f <setupkvm+0xa5>
    if (mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801095df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095e2:	8b 48 0c             	mov    0xc(%eax),%ecx
                 (uint)k->phys_start, k->perm) < 0)
801095e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095e8:	8b 50 04             	mov    0x4(%eax),%edx
    if (mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801095eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095ee:	8b 58 08             	mov    0x8(%eax),%ebx
801095f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095f4:	8b 40 04             	mov    0x4(%eax),%eax
801095f7:	29 c3                	sub    %eax,%ebx
801095f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095fc:	8b 00                	mov    (%eax),%eax
801095fe:	83 ec 0c             	sub    $0xc,%esp
80109601:	51                   	push   %ecx
80109602:	52                   	push   %edx
80109603:	53                   	push   %ebx
80109604:	50                   	push   %eax
80109605:	ff 75 f0             	pushl  -0x10(%ebp)
80109608:	e8 d9 fe ff ff       	call   801094e6 <mappages>
8010960d:	83 c4 20             	add    $0x20,%esp
80109610:	85 c0                	test   %eax,%eax
80109612:	79 07                	jns    8010961b <setupkvm+0xa1>
      return 0;
80109614:	b8 00 00 00 00       	mov    $0x0,%eax
80109619:	eb 10                	jmp    8010962b <setupkvm+0xb1>
  for (k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010961b:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010961f:	81 7d f4 a0 d5 10 80 	cmpl   $0x8010d5a0,-0xc(%ebp)
80109626:	72 b7                	jb     801095df <setupkvm+0x65>
  return pgdir;
80109628:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010962b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010962e:	c9                   	leave  
8010962f:	c3                   	ret    

80109630 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void kvmalloc(void) {
80109630:	f3 0f 1e fb          	endbr32 
80109634:	55                   	push   %ebp
80109635:	89 e5                	mov    %esp,%ebp
80109637:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010963a:	e8 3b ff ff ff       	call   8010957a <setupkvm>
8010963f:	a3 18 65 11 80       	mov    %eax,0x80116518
  switchkvm();
80109644:	e8 03 00 00 00       	call   8010964c <switchkvm>
}
80109649:	90                   	nop
8010964a:	c9                   	leave  
8010964b:	c3                   	ret    

8010964c <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void switchkvm(void) {
8010964c:	f3 0f 1e fb          	endbr32 
80109650:	55                   	push   %ebp
80109651:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir)); // switch to the kernel page table
80109653:	a1 18 65 11 80       	mov    0x80116518,%eax
80109658:	50                   	push   %eax
80109659:	e8 51 f9 ff ff       	call   80108faf <v2p>
8010965e:	83 c4 04             	add    $0x4,%esp
80109661:	50                   	push   %eax
80109662:	e8 3c f9 ff ff       	call   80108fa3 <lcr3>
80109667:	83 c4 04             	add    $0x4,%esp
}
8010966a:	90                   	nop
8010966b:	c9                   	leave  
8010966c:	c3                   	ret    

8010966d <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void switchuvm(struct proc *p) {
8010966d:	f3 0f 1e fb          	endbr32 
80109671:	55                   	push   %ebp
80109672:	89 e5                	mov    %esp,%ebp
80109674:	56                   	push   %esi
80109675:	53                   	push   %ebx
  pushcli();
80109676:	e8 1b bd ff ff       	call   80105396 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts) - 1, 0);
8010967b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109681:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80109688:	83 c2 08             	add    $0x8,%edx
8010968b:	89 d6                	mov    %edx,%esi
8010968d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80109694:	83 c2 08             	add    $0x8,%edx
80109697:	c1 ea 10             	shr    $0x10,%edx
8010969a:	89 d3                	mov    %edx,%ebx
8010969c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801096a3:	83 c2 08             	add    $0x8,%edx
801096a6:	c1 ea 18             	shr    $0x18,%edx
801096a9:	89 d1                	mov    %edx,%ecx
801096ab:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
801096b2:	67 00 
801096b4:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
801096bb:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
801096c1:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801096c8:	83 e2 f0             	and    $0xfffffff0,%edx
801096cb:	83 ca 09             	or     $0x9,%edx
801096ce:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801096d4:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801096db:	83 ca 10             	or     $0x10,%edx
801096de:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801096e4:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801096eb:	83 e2 9f             	and    $0xffffff9f,%edx
801096ee:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801096f4:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801096fb:	83 ca 80             	or     $0xffffff80,%edx
801096fe:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80109704:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010970b:	83 e2 f0             	and    $0xfffffff0,%edx
8010970e:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109714:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010971b:	83 e2 ef             	and    $0xffffffef,%edx
8010971e:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109724:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010972b:	83 e2 df             	and    $0xffffffdf,%edx
8010972e:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109734:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010973b:	83 ca 40             	or     $0x40,%edx
8010973e:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109744:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010974b:	83 e2 7f             	and    $0x7f,%edx
8010974e:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109754:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
8010975a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109760:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109767:	83 e2 ef             	and    $0xffffffef,%edx
8010976a:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80109770:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109776:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
8010977c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80109782:	8b 40 08             	mov    0x8(%eax),%eax
80109785:	89 c2                	mov    %eax,%edx
80109787:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010978d:	81 c2 00 10 00 00    	add    $0x1000,%edx
80109793:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80109796:	83 ec 0c             	sub    $0xc,%esp
80109799:	6a 30                	push   $0x30
8010979b:	e8 d6 f7 ff ff       	call   80108f76 <ltr>
801097a0:	83 c4 10             	add    $0x10,%esp
  if (p->pgdir == 0)
801097a3:	8b 45 08             	mov    0x8(%ebp),%eax
801097a6:	8b 40 04             	mov    0x4(%eax),%eax
801097a9:	85 c0                	test   %eax,%eax
801097ab:	75 0d                	jne    801097ba <switchuvm+0x14d>
    panic("switchuvm: no pgdir");
801097ad:	83 ec 0c             	sub    $0xc,%esp
801097b0:	68 fb a5 10 80       	push   $0x8010a5fb
801097b5:	e8 a9 6d ff ff       	call   80100563 <panic>
  lcr3(v2p(p->pgdir)); // switch to new address space
801097ba:	8b 45 08             	mov    0x8(%ebp),%eax
801097bd:	8b 40 04             	mov    0x4(%eax),%eax
801097c0:	83 ec 0c             	sub    $0xc,%esp
801097c3:	50                   	push   %eax
801097c4:	e8 e6 f7 ff ff       	call   80108faf <v2p>
801097c9:	83 c4 10             	add    $0x10,%esp
801097cc:	83 ec 0c             	sub    $0xc,%esp
801097cf:	50                   	push   %eax
801097d0:	e8 ce f7 ff ff       	call   80108fa3 <lcr3>
801097d5:	83 c4 10             	add    $0x10,%esp
  popcli();
801097d8:	e8 02 bc ff ff       	call   801053df <popcli>
}
801097dd:	90                   	nop
801097de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801097e1:	5b                   	pop    %ebx
801097e2:	5e                   	pop    %esi
801097e3:	5d                   	pop    %ebp
801097e4:	c3                   	ret    

801097e5 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void inituvm(pde_t *pgdir, char *init, uint sz) {
801097e5:	f3 0f 1e fb          	endbr32 
801097e9:	55                   	push   %ebp
801097ea:	89 e5                	mov    %esp,%ebp
801097ec:	83 ec 18             	sub    $0x18,%esp
  char *mem;

  if (sz >= PGSIZE)
801097ef:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
801097f6:	76 0d                	jbe    80109805 <inituvm+0x20>
    panic("inituvm: more than a page");
801097f8:	83 ec 0c             	sub    $0xc,%esp
801097fb:	68 0f a6 10 80       	push   $0x8010a60f
80109800:	e8 5e 6d ff ff       	call   80100563 <panic>
  mem = kalloc();
80109805:	e8 39 95 ff ff       	call   80102d43 <kalloc>
8010980a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
8010980d:	83 ec 04             	sub    $0x4,%esp
80109810:	68 00 10 00 00       	push   $0x1000
80109815:	6a 00                	push   $0x0
80109817:	ff 75 f4             	pushl  -0xc(%ebp)
8010981a:	e8 85 bc ff ff       	call   801054a4 <memset>
8010981f:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W | PTE_U);
80109822:	83 ec 0c             	sub    $0xc,%esp
80109825:	ff 75 f4             	pushl  -0xc(%ebp)
80109828:	e8 82 f7 ff ff       	call   80108faf <v2p>
8010982d:	83 c4 10             	add    $0x10,%esp
80109830:	83 ec 0c             	sub    $0xc,%esp
80109833:	6a 06                	push   $0x6
80109835:	50                   	push   %eax
80109836:	68 00 10 00 00       	push   $0x1000
8010983b:	6a 00                	push   $0x0
8010983d:	ff 75 08             	pushl  0x8(%ebp)
80109840:	e8 a1 fc ff ff       	call   801094e6 <mappages>
80109845:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80109848:	83 ec 04             	sub    $0x4,%esp
8010984b:	ff 75 10             	pushl  0x10(%ebp)
8010984e:	ff 75 0c             	pushl  0xc(%ebp)
80109851:	ff 75 f4             	pushl  -0xc(%ebp)
80109854:	e8 12 bd ff ff       	call   8010556b <memmove>
80109859:	83 c4 10             	add    $0x10,%esp
}
8010985c:	90                   	nop
8010985d:	c9                   	leave  
8010985e:	c3                   	ret    

8010985f <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz) {
8010985f:	f3 0f 1e fb          	endbr32 
80109863:	55                   	push   %ebp
80109864:	89 e5                	mov    %esp,%ebp
80109866:	53                   	push   %ebx
80109867:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if ((uint)addr % PGSIZE != 0)
8010986a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010986d:	25 ff 0f 00 00       	and    $0xfff,%eax
80109872:	85 c0                	test   %eax,%eax
80109874:	74 0d                	je     80109883 <loaduvm+0x24>
    panic("loaduvm: addr must be page aligned");
80109876:	83 ec 0c             	sub    $0xc,%esp
80109879:	68 2c a6 10 80       	push   $0x8010a62c
8010987e:	e8 e0 6c ff ff       	call   80100563 <panic>
  for (i = 0; i < sz; i += PGSIZE) {
80109883:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010988a:	e9 95 00 00 00       	jmp    80109924 <loaduvm+0xc5>
    if ((pte = walkpgdir(pgdir, addr + i, 0)) == 0)
8010988f:	8b 55 0c             	mov    0xc(%ebp),%edx
80109892:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109895:	01 d0                	add    %edx,%eax
80109897:	83 ec 04             	sub    $0x4,%esp
8010989a:	6a 00                	push   $0x0
8010989c:	50                   	push   %eax
8010989d:	ff 75 08             	pushl  0x8(%ebp)
801098a0:	e8 9d fb ff ff       	call   80109442 <walkpgdir>
801098a5:	83 c4 10             	add    $0x10,%esp
801098a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
801098ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801098af:	75 0d                	jne    801098be <loaduvm+0x5f>
      panic("loaduvm: address should exist");
801098b1:	83 ec 0c             	sub    $0xc,%esp
801098b4:	68 4f a6 10 80       	push   $0x8010a64f
801098b9:	e8 a5 6c ff ff       	call   80100563 <panic>
    pa = PTE_ADDR(*pte);
801098be:	8b 45 ec             	mov    -0x14(%ebp),%eax
801098c1:	8b 00                	mov    (%eax),%eax
801098c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801098c8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if (sz - i < PGSIZE)
801098cb:	8b 45 18             	mov    0x18(%ebp),%eax
801098ce:	2b 45 f4             	sub    -0xc(%ebp),%eax
801098d1:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801098d6:	77 0b                	ja     801098e3 <loaduvm+0x84>
      n = sz - i;
801098d8:	8b 45 18             	mov    0x18(%ebp),%eax
801098db:	2b 45 f4             	sub    -0xc(%ebp),%eax
801098de:	89 45 f0             	mov    %eax,-0x10(%ebp)
801098e1:	eb 07                	jmp    801098ea <loaduvm+0x8b>
    else
      n = PGSIZE;
801098e3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if (readi(ip, p2v(pa), offset + i, n) != n)
801098ea:	8b 55 14             	mov    0x14(%ebp),%edx
801098ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098f0:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801098f3:	83 ec 0c             	sub    $0xc,%esp
801098f6:	ff 75 e8             	pushl  -0x18(%ebp)
801098f9:	e8 be f6 ff ff       	call   80108fbc <p2v>
801098fe:	83 c4 10             	add    $0x10,%esp
80109901:	ff 75 f0             	pushl  -0x10(%ebp)
80109904:	53                   	push   %ebx
80109905:	50                   	push   %eax
80109906:	ff 75 10             	pushl  0x10(%ebp)
80109909:	e8 54 86 ff ff       	call   80101f62 <readi>
8010990e:	83 c4 10             	add    $0x10,%esp
80109911:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80109914:	74 07                	je     8010991d <loaduvm+0xbe>
      return -1;
80109916:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010991b:	eb 18                	jmp    80109935 <loaduvm+0xd6>
  for (i = 0; i < sz; i += PGSIZE) {
8010991d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109924:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109927:	3b 45 18             	cmp    0x18(%ebp),%eax
8010992a:	0f 82 5f ff ff ff    	jb     8010988f <loaduvm+0x30>
  }
  return 0;
80109930:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109935:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109938:	c9                   	leave  
80109939:	c3                   	ret    

8010993a <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int allocuvm(pde_t *pgdir, uint oldsz, uint newsz) {
8010993a:	f3 0f 1e fb          	endbr32 
8010993e:	55                   	push   %ebp
8010993f:	89 e5                	mov    %esp,%ebp
80109941:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if (newsz >= KERNBASE)
80109944:	8b 45 10             	mov    0x10(%ebp),%eax
80109947:	85 c0                	test   %eax,%eax
80109949:	79 0a                	jns    80109955 <allocuvm+0x1b>
    return 0;
8010994b:	b8 00 00 00 00       	mov    $0x0,%eax
80109950:	e9 ae 00 00 00       	jmp    80109a03 <allocuvm+0xc9>
  if (newsz < oldsz)
80109955:	8b 45 10             	mov    0x10(%ebp),%eax
80109958:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010995b:	73 08                	jae    80109965 <allocuvm+0x2b>
    return oldsz;
8010995d:	8b 45 0c             	mov    0xc(%ebp),%eax
80109960:	e9 9e 00 00 00       	jmp    80109a03 <allocuvm+0xc9>

  a = PGROUNDUP(oldsz);
80109965:	8b 45 0c             	mov    0xc(%ebp),%eax
80109968:	05 ff 0f 00 00       	add    $0xfff,%eax
8010996d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109972:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for (; a < newsz; a += PGSIZE) {
80109975:	eb 7d                	jmp    801099f4 <allocuvm+0xba>
    mem = kalloc();
80109977:	e8 c7 93 ff ff       	call   80102d43 <kalloc>
8010997c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (mem == 0) {
8010997f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109983:	75 2b                	jne    801099b0 <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
80109985:	83 ec 0c             	sub    $0xc,%esp
80109988:	68 6d a6 10 80       	push   $0x8010a66d
8010998d:	e8 18 6a ff ff       	call   801003aa <cprintf>
80109992:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80109995:	83 ec 04             	sub    $0x4,%esp
80109998:	ff 75 0c             	pushl  0xc(%ebp)
8010999b:	ff 75 10             	pushl  0x10(%ebp)
8010999e:	ff 75 08             	pushl  0x8(%ebp)
801099a1:	e8 5f 00 00 00       	call   80109a05 <deallocuvm>
801099a6:	83 c4 10             	add    $0x10,%esp
      return 0;
801099a9:	b8 00 00 00 00       	mov    $0x0,%eax
801099ae:	eb 53                	jmp    80109a03 <allocuvm+0xc9>
    }
    memset(mem, 0, PGSIZE);
801099b0:	83 ec 04             	sub    $0x4,%esp
801099b3:	68 00 10 00 00       	push   $0x1000
801099b8:	6a 00                	push   $0x0
801099ba:	ff 75 f0             	pushl  -0x10(%ebp)
801099bd:	e8 e2 ba ff ff       	call   801054a4 <memset>
801099c2:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char *)a, PGSIZE, v2p(mem), PTE_W | PTE_U);
801099c5:	83 ec 0c             	sub    $0xc,%esp
801099c8:	ff 75 f0             	pushl  -0x10(%ebp)
801099cb:	e8 df f5 ff ff       	call   80108faf <v2p>
801099d0:	83 c4 10             	add    $0x10,%esp
801099d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801099d6:	83 ec 0c             	sub    $0xc,%esp
801099d9:	6a 06                	push   $0x6
801099db:	50                   	push   %eax
801099dc:	68 00 10 00 00       	push   $0x1000
801099e1:	52                   	push   %edx
801099e2:	ff 75 08             	pushl  0x8(%ebp)
801099e5:	e8 fc fa ff ff       	call   801094e6 <mappages>
801099ea:	83 c4 20             	add    $0x20,%esp
  for (; a < newsz; a += PGSIZE) {
801099ed:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801099f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801099f7:	3b 45 10             	cmp    0x10(%ebp),%eax
801099fa:	0f 82 77 ff ff ff    	jb     80109977 <allocuvm+0x3d>
  }
  return newsz;
80109a00:	8b 45 10             	mov    0x10(%ebp),%eax
}
80109a03:	c9                   	leave  
80109a04:	c3                   	ret    

80109a05 <deallocuvm>:

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int deallocuvm(pde_t *pgdir, uint oldsz, uint newsz) {
80109a05:	f3 0f 1e fb          	endbr32 
80109a09:	55                   	push   %ebp
80109a0a:	89 e5                	mov    %esp,%ebp
80109a0c:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if (newsz >= oldsz)
80109a0f:	8b 45 10             	mov    0x10(%ebp),%eax
80109a12:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109a15:	72 08                	jb     80109a1f <deallocuvm+0x1a>
    return oldsz;
80109a17:	8b 45 0c             	mov    0xc(%ebp),%eax
80109a1a:	e9 a5 00 00 00       	jmp    80109ac4 <deallocuvm+0xbf>

  a = PGROUNDUP(newsz);
80109a1f:	8b 45 10             	mov    0x10(%ebp),%eax
80109a22:	05 ff 0f 00 00       	add    $0xfff,%eax
80109a27:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109a2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for (; a < oldsz; a += PGSIZE) {
80109a2f:	e9 81 00 00 00       	jmp    80109ab5 <deallocuvm+0xb0>
    pte = walkpgdir(pgdir, (char *)a, 0);
80109a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a37:	83 ec 04             	sub    $0x4,%esp
80109a3a:	6a 00                	push   $0x0
80109a3c:	50                   	push   %eax
80109a3d:	ff 75 08             	pushl  0x8(%ebp)
80109a40:	e8 fd f9 ff ff       	call   80109442 <walkpgdir>
80109a45:	83 c4 10             	add    $0x10,%esp
80109a48:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (!pte)
80109a4b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109a4f:	75 09                	jne    80109a5a <deallocuvm+0x55>
      a += (NPTENTRIES - 1) * PGSIZE;
80109a51:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80109a58:	eb 54                	jmp    80109aae <deallocuvm+0xa9>
    else if ((*pte & PTE_P) != 0) {
80109a5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109a5d:	8b 00                	mov    (%eax),%eax
80109a5f:	83 e0 01             	and    $0x1,%eax
80109a62:	85 c0                	test   %eax,%eax
80109a64:	74 48                	je     80109aae <deallocuvm+0xa9>
      pa = PTE_ADDR(*pte);
80109a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109a69:	8b 00                	mov    (%eax),%eax
80109a6b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109a70:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if (pa == 0)
80109a73:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109a77:	75 0d                	jne    80109a86 <deallocuvm+0x81>
        panic("kfree");
80109a79:	83 ec 0c             	sub    $0xc,%esp
80109a7c:	68 85 a6 10 80       	push   $0x8010a685
80109a81:	e8 dd 6a ff ff       	call   80100563 <panic>
      char *v = p2v(pa);
80109a86:	83 ec 0c             	sub    $0xc,%esp
80109a89:	ff 75 ec             	pushl  -0x14(%ebp)
80109a8c:	e8 2b f5 ff ff       	call   80108fbc <p2v>
80109a91:	83 c4 10             	add    $0x10,%esp
80109a94:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80109a97:	83 ec 0c             	sub    $0xc,%esp
80109a9a:	ff 75 e8             	pushl  -0x18(%ebp)
80109a9d:	e8 00 92 ff ff       	call   80102ca2 <kfree>
80109aa2:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80109aa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109aa8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for (; a < oldsz; a += PGSIZE) {
80109aae:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ab8:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109abb:	0f 82 73 ff ff ff    	jb     80109a34 <deallocuvm+0x2f>
    }
  }
  return newsz;
80109ac1:	8b 45 10             	mov    0x10(%ebp),%eax
}
80109ac4:	c9                   	leave  
80109ac5:	c3                   	ret    

80109ac6 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void freevm(pde_t *pgdir) {
80109ac6:	f3 0f 1e fb          	endbr32 
80109aca:	55                   	push   %ebp
80109acb:	89 e5                	mov    %esp,%ebp
80109acd:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if (pgdir == 0)
80109ad0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80109ad4:	75 0d                	jne    80109ae3 <freevm+0x1d>
    panic("freevm: no pgdir");
80109ad6:	83 ec 0c             	sub    $0xc,%esp
80109ad9:	68 8b a6 10 80       	push   $0x8010a68b
80109ade:	e8 80 6a ff ff       	call   80100563 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80109ae3:	83 ec 04             	sub    $0x4,%esp
80109ae6:	6a 00                	push   $0x0
80109ae8:	68 00 00 00 80       	push   $0x80000000
80109aed:	ff 75 08             	pushl  0x8(%ebp)
80109af0:	e8 10 ff ff ff       	call   80109a05 <deallocuvm>
80109af5:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < NPDENTRIES; i++) {
80109af8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109aff:	eb 4f                	jmp    80109b50 <freevm+0x8a>
    if (pgdir[i] & PTE_P) {
80109b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b04:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109b0b:	8b 45 08             	mov    0x8(%ebp),%eax
80109b0e:	01 d0                	add    %edx,%eax
80109b10:	8b 00                	mov    (%eax),%eax
80109b12:	83 e0 01             	and    $0x1,%eax
80109b15:	85 c0                	test   %eax,%eax
80109b17:	74 33                	je     80109b4c <freevm+0x86>
      char *v = p2v(PTE_ADDR(pgdir[i]));
80109b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b1c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109b23:	8b 45 08             	mov    0x8(%ebp),%eax
80109b26:	01 d0                	add    %edx,%eax
80109b28:	8b 00                	mov    (%eax),%eax
80109b2a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109b2f:	83 ec 0c             	sub    $0xc,%esp
80109b32:	50                   	push   %eax
80109b33:	e8 84 f4 ff ff       	call   80108fbc <p2v>
80109b38:	83 c4 10             	add    $0x10,%esp
80109b3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80109b3e:	83 ec 0c             	sub    $0xc,%esp
80109b41:	ff 75 f0             	pushl  -0x10(%ebp)
80109b44:	e8 59 91 ff ff       	call   80102ca2 <kfree>
80109b49:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < NPDENTRIES; i++) {
80109b4c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80109b50:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80109b57:	76 a8                	jbe    80109b01 <freevm+0x3b>
    }
  }
  kfree((char *)pgdir);
80109b59:	83 ec 0c             	sub    $0xc,%esp
80109b5c:	ff 75 08             	pushl  0x8(%ebp)
80109b5f:	e8 3e 91 ff ff       	call   80102ca2 <kfree>
80109b64:	83 c4 10             	add    $0x10,%esp
}
80109b67:	90                   	nop
80109b68:	c9                   	leave  
80109b69:	c3                   	ret    

80109b6a <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void clearpteu(pde_t *pgdir, char *uva) {
80109b6a:	f3 0f 1e fb          	endbr32 
80109b6e:	55                   	push   %ebp
80109b6f:	89 e5                	mov    %esp,%ebp
80109b71:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80109b74:	83 ec 04             	sub    $0x4,%esp
80109b77:	6a 00                	push   $0x0
80109b79:	ff 75 0c             	pushl  0xc(%ebp)
80109b7c:	ff 75 08             	pushl  0x8(%ebp)
80109b7f:	e8 be f8 ff ff       	call   80109442 <walkpgdir>
80109b84:	83 c4 10             	add    $0x10,%esp
80109b87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (pte == 0)
80109b8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80109b8e:	75 0d                	jne    80109b9d <clearpteu+0x33>
    panic("clearpteu");
80109b90:	83 ec 0c             	sub    $0xc,%esp
80109b93:	68 9c a6 10 80       	push   $0x8010a69c
80109b98:	e8 c6 69 ff ff       	call   80100563 <panic>
  *pte &= ~PTE_U;
80109b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ba0:	8b 00                	mov    (%eax),%eax
80109ba2:	83 e0 fb             	and    $0xfffffffb,%eax
80109ba5:	89 c2                	mov    %eax,%edx
80109ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109baa:	89 10                	mov    %edx,(%eax)
}
80109bac:	90                   	nop
80109bad:	c9                   	leave  
80109bae:	c3                   	ret    

80109baf <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t *copyuvm(pde_t *pgdir, uint sz) {
80109baf:	f3 0f 1e fb          	endbr32 
80109bb3:	55                   	push   %ebp
80109bb4:	89 e5                	mov    %esp,%ebp
80109bb6:	53                   	push   %ebx
80109bb7:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if ((d = setupkvm()) == 0)
80109bba:	e8 bb f9 ff ff       	call   8010957a <setupkvm>
80109bbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109bc2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109bc6:	75 0a                	jne    80109bd2 <copyuvm+0x23>
    return 0;
80109bc8:	b8 00 00 00 00       	mov    $0x0,%eax
80109bcd:	e9 f6 00 00 00       	jmp    80109cc8 <copyuvm+0x119>
  for (i = 0; i < sz; i += PGSIZE) {
80109bd2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109bd9:	e9 c2 00 00 00       	jmp    80109ca0 <copyuvm+0xf1>
    if ((pte = walkpgdir(pgdir, (void *)i, 0)) == 0)
80109bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109be1:	83 ec 04             	sub    $0x4,%esp
80109be4:	6a 00                	push   $0x0
80109be6:	50                   	push   %eax
80109be7:	ff 75 08             	pushl  0x8(%ebp)
80109bea:	e8 53 f8 ff ff       	call   80109442 <walkpgdir>
80109bef:	83 c4 10             	add    $0x10,%esp
80109bf2:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109bf5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109bf9:	75 0d                	jne    80109c08 <copyuvm+0x59>
      panic("copyuvm: pte should exist");
80109bfb:	83 ec 0c             	sub    $0xc,%esp
80109bfe:	68 a6 a6 10 80       	push   $0x8010a6a6
80109c03:	e8 5b 69 ff ff       	call   80100563 <panic>
    if (!(*pte & PTE_P))
80109c08:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109c0b:	8b 00                	mov    (%eax),%eax
80109c0d:	83 e0 01             	and    $0x1,%eax
80109c10:	85 c0                	test   %eax,%eax
80109c12:	75 0d                	jne    80109c21 <copyuvm+0x72>
      panic("copyuvm: page not present");
80109c14:	83 ec 0c             	sub    $0xc,%esp
80109c17:	68 c0 a6 10 80       	push   $0x8010a6c0
80109c1c:	e8 42 69 ff ff       	call   80100563 <panic>
    pa = PTE_ADDR(*pte);
80109c21:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109c24:	8b 00                	mov    (%eax),%eax
80109c26:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109c2b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80109c2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109c31:	8b 00                	mov    (%eax),%eax
80109c33:	25 ff 0f 00 00       	and    $0xfff,%eax
80109c38:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if ((mem = kalloc()) == 0)
80109c3b:	e8 03 91 ff ff       	call   80102d43 <kalloc>
80109c40:	89 45 e0             	mov    %eax,-0x20(%ebp)
80109c43:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80109c47:	74 68                	je     80109cb1 <copyuvm+0x102>
      goto bad;
    memmove(mem, (char *)p2v(pa), PGSIZE);
80109c49:	83 ec 0c             	sub    $0xc,%esp
80109c4c:	ff 75 e8             	pushl  -0x18(%ebp)
80109c4f:	e8 68 f3 ff ff       	call   80108fbc <p2v>
80109c54:	83 c4 10             	add    $0x10,%esp
80109c57:	83 ec 04             	sub    $0x4,%esp
80109c5a:	68 00 10 00 00       	push   $0x1000
80109c5f:	50                   	push   %eax
80109c60:	ff 75 e0             	pushl  -0x20(%ebp)
80109c63:	e8 03 b9 ff ff       	call   8010556b <memmove>
80109c68:	83 c4 10             	add    $0x10,%esp
    if (mappages(d, (void *)i, PGSIZE, v2p(mem), flags) < 0)
80109c6b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80109c6e:	83 ec 0c             	sub    $0xc,%esp
80109c71:	ff 75 e0             	pushl  -0x20(%ebp)
80109c74:	e8 36 f3 ff ff       	call   80108faf <v2p>
80109c79:	83 c4 10             	add    $0x10,%esp
80109c7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109c7f:	83 ec 0c             	sub    $0xc,%esp
80109c82:	53                   	push   %ebx
80109c83:	50                   	push   %eax
80109c84:	68 00 10 00 00       	push   $0x1000
80109c89:	52                   	push   %edx
80109c8a:	ff 75 f0             	pushl  -0x10(%ebp)
80109c8d:	e8 54 f8 ff ff       	call   801094e6 <mappages>
80109c92:	83 c4 20             	add    $0x20,%esp
80109c95:	85 c0                	test   %eax,%eax
80109c97:	78 1b                	js     80109cb4 <copyuvm+0x105>
  for (i = 0; i < sz; i += PGSIZE) {
80109c99:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ca3:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109ca6:	0f 82 32 ff ff ff    	jb     80109bde <copyuvm+0x2f>
      goto bad;
  }
  return d;
80109cac:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109caf:	eb 17                	jmp    80109cc8 <copyuvm+0x119>
      goto bad;
80109cb1:	90                   	nop
80109cb2:	eb 01                	jmp    80109cb5 <copyuvm+0x106>
      goto bad;
80109cb4:	90                   	nop

bad:
  freevm(d);
80109cb5:	83 ec 0c             	sub    $0xc,%esp
80109cb8:	ff 75 f0             	pushl  -0x10(%ebp)
80109cbb:	e8 06 fe ff ff       	call   80109ac6 <freevm>
80109cc0:	83 c4 10             	add    $0x10,%esp
  return 0;
80109cc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109cc8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109ccb:	c9                   	leave  
80109ccc:	c3                   	ret    

80109ccd <uva2ka>:

// PAGEBREAK!
// Map user virtual address to kernel address.
char *uva2ka(pde_t *pgdir, char *uva) {
80109ccd:	f3 0f 1e fb          	endbr32 
80109cd1:	55                   	push   %ebp
80109cd2:	89 e5                	mov    %esp,%ebp
80109cd4:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80109cd7:	83 ec 04             	sub    $0x4,%esp
80109cda:	6a 00                	push   $0x0
80109cdc:	ff 75 0c             	pushl  0xc(%ebp)
80109cdf:	ff 75 08             	pushl  0x8(%ebp)
80109ce2:	e8 5b f7 ff ff       	call   80109442 <walkpgdir>
80109ce7:	83 c4 10             	add    $0x10,%esp
80109cea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if ((*pte & PTE_P) == 0)
80109ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109cf0:	8b 00                	mov    (%eax),%eax
80109cf2:	83 e0 01             	and    $0x1,%eax
80109cf5:	85 c0                	test   %eax,%eax
80109cf7:	75 07                	jne    80109d00 <uva2ka+0x33>
    return 0;
80109cf9:	b8 00 00 00 00       	mov    $0x0,%eax
80109cfe:	eb 2a                	jmp    80109d2a <uva2ka+0x5d>
  if ((*pte & PTE_U) == 0)
80109d00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109d03:	8b 00                	mov    (%eax),%eax
80109d05:	83 e0 04             	and    $0x4,%eax
80109d08:	85 c0                	test   %eax,%eax
80109d0a:	75 07                	jne    80109d13 <uva2ka+0x46>
    return 0;
80109d0c:	b8 00 00 00 00       	mov    $0x0,%eax
80109d11:	eb 17                	jmp    80109d2a <uva2ka+0x5d>
  return (char *)p2v(PTE_ADDR(*pte));
80109d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109d16:	8b 00                	mov    (%eax),%eax
80109d18:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109d1d:	83 ec 0c             	sub    $0xc,%esp
80109d20:	50                   	push   %eax
80109d21:	e8 96 f2 ff ff       	call   80108fbc <p2v>
80109d26:	83 c4 10             	add    $0x10,%esp
80109d29:	90                   	nop
}
80109d2a:	c9                   	leave  
80109d2b:	c3                   	ret    

80109d2c <copyout>:

// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int copyout(pde_t *pgdir, uint va, void *p, uint len) {
80109d2c:	f3 0f 1e fb          	endbr32 
80109d30:	55                   	push   %ebp
80109d31:	89 e5                	mov    %esp,%ebp
80109d33:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char *)p;
80109d36:	8b 45 10             	mov    0x10(%ebp),%eax
80109d39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (len > 0) {
80109d3c:	eb 7f                	jmp    80109dbd <copyout+0x91>
    va0 = (uint)PGROUNDDOWN(va);
80109d3e:	8b 45 0c             	mov    0xc(%ebp),%eax
80109d41:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109d46:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char *)va0);
80109d49:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109d4c:	83 ec 08             	sub    $0x8,%esp
80109d4f:	50                   	push   %eax
80109d50:	ff 75 08             	pushl  0x8(%ebp)
80109d53:	e8 75 ff ff ff       	call   80109ccd <uva2ka>
80109d58:	83 c4 10             	add    $0x10,%esp
80109d5b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if (pa0 == 0)
80109d5e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80109d62:	75 07                	jne    80109d6b <copyout+0x3f>
      return -1;
80109d64:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109d69:	eb 61                	jmp    80109dcc <copyout+0xa0>
    n = PGSIZE - (va - va0);
80109d6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109d6e:	2b 45 0c             	sub    0xc(%ebp),%eax
80109d71:	05 00 10 00 00       	add    $0x1000,%eax
80109d76:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (n > len)
80109d79:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109d7c:	3b 45 14             	cmp    0x14(%ebp),%eax
80109d7f:	76 06                	jbe    80109d87 <copyout+0x5b>
      n = len;
80109d81:	8b 45 14             	mov    0x14(%ebp),%eax
80109d84:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80109d87:	8b 45 0c             	mov    0xc(%ebp),%eax
80109d8a:	2b 45 ec             	sub    -0x14(%ebp),%eax
80109d8d:	89 c2                	mov    %eax,%edx
80109d8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109d92:	01 d0                	add    %edx,%eax
80109d94:	83 ec 04             	sub    $0x4,%esp
80109d97:	ff 75 f0             	pushl  -0x10(%ebp)
80109d9a:	ff 75 f4             	pushl  -0xc(%ebp)
80109d9d:	50                   	push   %eax
80109d9e:	e8 c8 b7 ff ff       	call   8010556b <memmove>
80109da3:	83 c4 10             	add    $0x10,%esp
    len -= n;
80109da6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109da9:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80109dac:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109daf:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80109db2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109db5:	05 00 10 00 00       	add    $0x1000,%eax
80109dba:	89 45 0c             	mov    %eax,0xc(%ebp)
  while (len > 0) {
80109dbd:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80109dc1:	0f 85 77 ff ff ff    	jne    80109d3e <copyout+0x12>
  }
  return 0;
80109dc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109dcc:	c9                   	leave  
80109dcd:	c3                   	ret    
80109dce:	66 90                	xchg   %ax,%ax

80109dd0 <multiboot_header>:
80109dd0:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80109dd6:	00 00                	add    %al,(%eax)
80109dd8:	fe 4f 52             	decb   0x52(%edi)
80109ddb:	e4                   	.byte 0xe4

80109ddc <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
80109ddc:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
80109ddf:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80109de2:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80109de5:	b8 00 c0 10 00       	mov    $0x10c000,%eax
  movl    %eax, %cr3
80109dea:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
80109ded:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80109df0:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80109df5:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80109df8:	bc 20 75 11 80       	mov    $0x80117520,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
80109dfd:	b8 c0 39 10 80       	mov    $0x801039c0,%eax
  jmp *%eax
80109e02:	ff e0                	jmp    *%eax
