# C 语言内存分配方法总结

## 1. 栈分配（自动存储）

```c
void func() {
    int a = 10;          // 栈上
    char buf[256];       // 栈上，函数返回自动释放
    int arr[n];          // VLA，C99，运行时大小，也在栈上
}
```

- 速度最快，无需手动释放
- 空间有限（通常 1~8 MB），不能返回指向它的指针

---

## 2. 静态/全局存储

```c
static int count = 0;     // 静态局部，程序生命周期
int global_buf[1024];     // 全局，BSS 或 data 段
```

- 程序启动时分配，结束时释放
- 线程间共享，注意竞争

---

## 3. `malloc` — 基础堆分配

```c
#include <stdlib.h>

int *arr = malloc(100 * sizeof(int));  // 分配 100 个 int，内容未初始化
if (arr == NULL) {
    // 分配失败处理
}
free(arr);
```

- 最基础的堆分配函数，分配的内存**未初始化**（可能含垃圾值）
- 失败时返回 `NULL`，务必检查
- 必须调用 `free` 释放，否则内存泄漏

---

## 4. `calloc` — 分配并清零

```c
int *arr = calloc(100, sizeof(int));  // 分配 100 个 int，全部初始化为 0
free(arr);
```

- 等价于 `malloc` + `memset(0)`，但实现上可能更高效
- 适合需要零初始化的场景

---

## 5. `realloc` — 重新调整大小

```c
int *arr = malloc(10 * sizeof(int));
arr = realloc(arr, 20 * sizeof(int));  // 扩大到 20 个
free(arr);
```

- 可能原地扩展，也可能移动到新地址
- `realloc(NULL, size)` 等价于 `malloc(size)`
- `realloc(ptr, 0)` 行为实现定义，避免用于释放

---

## 6. `aligned_alloc` — 指定对齐（C11）

```c
// 分配 64 字节对齐的内存（SIMD 场景常用）
void *p = aligned_alloc(64, 1024);
free(p);
```

- `size` 必须是 `alignment` 的倍数

---

## 7. `alloca` — 栈上动态分配

```c
#include <alloca.h>

void func(int n) {
    char *buf = alloca(n);  // 在栈上分配，函数返回自动释放
    // 不需要 free！
}
```

- 非标准（POSIX），但几乎所有平台支持
- 无需 `free`，但栈溢出风险，不可返回该指针

---

## 8. `mmap` — 直接向 OS 申请页

```c
#include <sys/mman.h>

void *p = mmap(NULL, 4096,
               PROT_READ | PROT_WRITE,
               MAP_PRIVATE | MAP_ANONYMOUS,
               -1, 0);
munmap(p, 4096);  // 释放
```

- 绕过堆，直接分配内存页（4KB 对齐）
- 适合大块内存、共享内存、自定义内存池

---

## 9. 内存池 / 自定义分配器

```c
// 从大块内存中手动切分
static char pool[1024 * 1024];
static size_t offset = 0;

void *pool_alloc(size_t size) {
    void *p = pool + offset;
    offset += size;
    return p;
}
// 统一释放整个 pool，无需逐个 free
```

- 高性能场景（游戏、嵌入式、网络服务器）常用
- 可以做 arena allocator、slab allocator 等

---

## 对比总结

| 方法 | 位置 | 需要 free | 标准 | 适用场景 |
|------|------|-----------|------|----------|
| 局部变量 | 栈 | 否 | C89 | 小型临时数据 |
| 全局/静态 | data/BSS | 否 | C89 | 程序级状态 |
| `malloc` | 堆 | 是 | C89 | 通用堆分配 |
| `calloc` | 堆 | 是 | C89 | 需要清零的数组 |
| `realloc` | 堆 | 是 | C89 | 动态增长缓冲区 |
| `aligned_alloc` | 堆 | 是 | C11 | SIMD/硬件对齐 |
| `alloca` | 栈 | 否 | POSIX | 小型动态栈缓冲 |
| `mmap` | 页 | `munmap` | POSIX | 大块/共享内存 |
| 内存池 | 自定义 | 批量释放 | 无 | 高性能/嵌入式 |
