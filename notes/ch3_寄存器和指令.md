# CSAPP 第三章 汇编寄存器与指令总览

---

## 一、寄存器

### 通用寄存器（64位）

| 64位 | 32位 | 16位 | 8位 | 用途 |
|------|------|------|-----|------|
| `%rax` | `%eax` | `%ax` | `%al` | 返回值 |
| `%rbx` | `%ebx` | `%bx` | `%bl` | 被调用者保存 |
| `%rcx` | `%ecx` | `%cx` | `%cl` | 第4个参数 |
| `%rdx` | `%edx` | `%dx` | `%dl` | 第3个参数 |
| `%rsi` | `%esi` | `%si` | `%sil` | 第2个参数 |
| `%rdi` | `%edi` | `%di` | `%dil` | 第1个参数 |
| `%rbp` | `%ebp` | `%bp` | `%bpl` | 被调用者保存 |
| `%rsp` | `%esp` | `%sp` | `%spl` | 栈指针 |
| `%r8` | `%r8d` | `%r8w` | `%r8b` | 第5个参数 |
| `%r9` | `%r9d` | `%r9w` | `%r9b` | 第6个参数 |
| `%r10` | `%r10d` | `%r10w` | `%r10b` | 调用者保存 |
| `%r11` | `%r11d` | `%r11w` | `%r11b` | 调用者保存 |
| `%r12` | `%r12d` | `%r12w` | `%r12b` | 被调用者保存 |
| `%r13` | `%r13d` | `%r13w` | `%r13b` | 被调用者保存 |
| `%r14` | `%r14d` | `%r14w` | `%r14b` | 被调用者保存 |
| `%r15` | `%r15d` | `%r15w` | `%r15b` | 被调用者保存 |

### 特殊寄存器

| 寄存器 | 用途 |
|--------|------|
| `%rip` | 程序计数器（指令指针） |
| `%rflags` | 条件码寄存器 |

---

## 二、指令

### 数据传送

| 指令 | 效果 |
|------|------|
| `movb/w/l/q` | 传送 byte/word/long/quad |
| `movabsq` | 传送64位立即数到寄存器 |
| `movsbw/sbl/sbq` | 符号扩展 byte→word/long/quad |
| `movswl/swq` | 符号扩展 word→long/quad |
| `movslq` | 符号扩展 long→quad |
| `movzbw/zbl/zbq` | 零扩展 byte→word/long/quad |
| `movzwl/zwq` | 零扩展 word→long/quad |
| `pushq` | 压栈（%rsp -= 8，写入内存） |
| `popq` | 弹栈（读取内存，%rsp += 8） |
- 注:因为为32位寄存器生成值的操作会将高位寄存器清零,所有movl可以实现movzlq的功能

### 算术与逻辑

| 指令 | 效果 |
|------|------|
| `leaq` | 加载有效地址（不访问内存） |
| `incb/w/l/q` | 加1 |
| `decb/w/l/q` | 减1 |
| `negb/w/l/q` | 取负（算术取反） |
| `notb/w/l/q` | 按位取反 |
| `addb/w/l/q` | 加法 |
| `subb/w/l/q` | 减法 |
| `imulb/w/l/q` | 有符号乘法（双操作数） |
| `mulq` | 无符号64位乘法，结果在 %rdx:%rax |
| `imulq` | 有符号64位乘法（单操作数），结果在 %rdx:%rax |
| `xorb/w/l/q` | 按位异或 |
| `orb/w/l/q` | 按位或 |
| `andb/w/l/q` | 按位与 |
| `salb/w/l/q` | 算术左移（同 shl） |
| `shlb/w/l/q` | 逻辑左移（同 sal） |
| `sarb/w/l/q` | 算术右移（高位补符号位） |
| `shrb/w/l/q` | 逻辑右移（高位补0） |
| `idivq` | 有符号除法，被除数 %rdx:%rax，商→%rax，余数→%rdx |
| `divq` | 无符号除法，被除数 %rdx:%rax，商→%rax，余数→%rdx |
- 注: leaq 4(%rax,%rbx,3), %rdx -> rdx = 4+rax+rbx*3
- 只有有符号乘法有双操作数版本
- mulq/imulq, divq/idivq均有b w l对应的版本

### 符号扩展（特殊转换指令）

| 指令 | 效果 |
|------|------|
| `cbtw` | `%al` 符号扩展 → `%ax` |
| `cwtl` | `%ax` 符号扩展 → `%eax` |
| `cltq` | `%eax` 符号扩展 → `%rax` |
| `cwtd` | `%ax` 符号扩展 → `%dx:%ax` |
| `cltd` | `%eax` 符号扩展 → `%edx:%eax` |
| `cqto` | `%rax` 符号扩展 → `%rdx:%rax` |
- 不需要操作数

### 条件码设置指令

| 指令 | 效果 |
|------|------|
| `cmpb/w/l/q src, dst` | 计算 dst-src，只设置条件码，不保存结果 |
| `testb/w/l/q src, dst` | 计算 dst&src，只设置条件码，不保存结果 |

### 条件码寄存器标志位

| 标志 | 名称 | 含义 |
|------|------|------|
| `CF` | 进位标志 | 最高位产生进位（无符号溢出） |
| `ZF` | 零标志 | 结果为零 |
| `SF` | 符号标志 | 结果为负 |
| `OF` | 溢出标志 | 补码溢出 |

### SET 指令（根据条件码设置单字节）

| 指令 | 同义名 | 条件 | 描述 |
|------|--------|------|------|
| `sete` | `setz` | ZF | 相等/零 |
| `setne` | `setnz` | ~ZF | 不等/非零 |
| `sets` | | SF | 负数 |
| `setns` | | ~SF | 非负数 |
| `setg` | `setnle` | ~(SF^OF)&~ZF | 有符号大于 |
| `setge` | `setnl` | ~(SF^OF) | 有符号大于等于 |
| `setl` | `setnge` | SF^OF | 有符号小于 |
| `setle` | `setng` | (SF^OF)\|ZF | 有符号小于等于 |
| `seta` | `setnbe` | ~CF&~ZF | 无符号大于 |
| `setae` | `setnb` | ~CF | 无符号大于等于 |
| `setb` | `setnae` | CF | 无符号小于 |
| `setbe` | `setna` | CF\|ZF | 无符号小于等于 |

### 跳转指令

| 指令 | 同义名 | 条件 | 描述 |
|------|--------|------|------|
| `jmp` | | 1 | 无条件跳转 |
| `je` | `jz` | ZF | 相等/零 |
| `jne` | `jnz` | ~ZF | 不等/非零 |
| `js` | | SF | 负数 |
| `jns` | | ~SF | 非负数 |
| `jg` | `jnle` | ~(SF^OF)&~ZF | 有符号大于 |
| `jge` | `jnl` | ~(SF^OF) | 有符号大于等于 |
| `jl` | `jnge` | SF^OF | 有符号小于 |
| `jle` | `jng` | (SF^OF)\|ZF | 有符号小于等于 |
| `ja` | `jnbe` | ~CF&~ZF | 无符号大于 |
| `jae` | `jnb` | ~CF | 无符号大于等于 |
| `jb` | `jnae` | CF | 无符号小于 |
| `jbe` | `jna` | CF\|ZF | 无符号小于等于 |

### 条件传送指令（cmov）

| 指令 | 同义名 | 条件 | 描述 |
|------|--------|------|------|
| `cmove` | `cmovz` | ZF | 相等/零 |
| `cmovne` | `cmovnz` | ~ZF | 不等/非零 |
| `cmovs` | | SF | 负数 |
| `cmovns` | | ~SF | 非负数 |
| `cmovg` | `cmovnle` | ~(SF^OF)&~ZF | 有符号大于 |
| `cmovge` | `cmovnl` | ~(SF^OF) | 有符号大于等于 |
| `cmovl` | `cmovnge` | SF^OF | 有符号小于 |
| `cmovle` | `cmovng` | (SF^OF)\|ZF | 有符号小于等于 |
| `cmova` | `cmovnbe` | ~CF&~ZF | 无符号大于 |
| `cmovae` | `cmovnb` | ~CF | 无符号大于等于 |
| `cmovb` | `cmovnae` | CF | 无符号小于 |
| `cmovbe` | `cmovna` | CF\|ZF | 无符号小于等于 |

### 过程调用指令

| 指令 | 效果 |
|------|------|
| `call label` | 压入返回地址，跳转到label |
| `ret` | 弹出返回地址，跳转返回 |
| `leave` | 等效于 `movq %rbp,%rsp` + `popq %rbp` |

---

## 三、寻址模式

| 格式 | 计算地址 | 说明 |
|------|---------|------|
| `$imm` | imm | 立即数 |
| `%reg` | R[reg] | 寄存器 |
| `imm` | M[imm] | 绝对地址 |
| `(%reg)` | M[R[reg]] | 间接寻址 |
| `imm(%reg)` | M[R[reg]+imm] | 基址+偏移 |
| `(%r1,%r2)` | M[R[r1]+R[r2]] | 变址寻址 |
| `imm(%r1,%r2)` | M[R[r1]+R[r2]+imm] | 基址+变址+偏移 |
| `(,%r2,s)` | M[R[r2]*s] | 比例变址 |
| `imm(,%r2,s)` | M[R[r2]*s+imm] | 比例变址+偏移 |
| `imm(%r1,%r2,s)` | M[R[r1]+R[r2]*s+imm] | 完整形式，s∈{1,2,4,8} |

---

## 四、函数调用约定

### 参数传递寄存器顺序

| 参数序号 | 64位寄存器 | 32位 | 16位 | 8位 |
|---------|-----------|------|------|-----|
| 第1个 | `%rdi` | `%edi` | `%di` | `%dil` |
| 第2个 | `%rsi` | `%esi` | `%si` | `%sil` |
| 第3个 | `%rdx` | `%edx` | `%dx` | `%dl` |
| 第4个 | `%rcx` | `%ecx` | `%cx` | `%cl` |
| 第5个 | `%r8` | `%r8d` | `%r8w` | `%r8b` |
| 第6个 | `%r9` | `%r9d` | `%r9w` | `%r9b` |
| 第7个起 | 栈传递 | | | |

### 调用者保存 vs 被调用者保存

| 类型 | 寄存器 |
|------|--------|
| 调用者保存（caller-saved） | `%rax`, `%rcx`, `%rdx`, `%rsi`, `%rdi`, `%r8`~`%r11` |
| 被调用者保存（callee-saved） | `%rbx`, `%rbp`, `%r12`~`%r15` |
| 特殊 | `%rsp`（栈指针，需恢复） |


# CSAPP 第三章：浮点数寄存器与指令总结

## 一、浮点数寄存器（XMM 寄存器）

现代 x86-64 架构使用 **XMM 寄存器**处理浮点数运算，共有 **16 个**，命名为 `%xmm0` ~ `%xmm15`，每个寄存器 **128 位宽**。

| 寄存器名 | 位宽 | 用途说明 |
|---|---|---|
| `%xmm0` ~ `%xmm7` | 128 位 | 函数参数传递（前 8 个浮点参数）；`%xmm0` 同时用于返回值 |
| `%xmm8` ~ `%xmm15` | 128 位 | 临时寄存器（调用者保存） |

### 使用规则

- **参数传递**：浮点函数参数依次存入 `%xmm0` ~ `%xmm7`。
- **返回值**：浮点返回值存放在 `%xmm0`。
- **调用者保存（Caller-saved）**：所有 XMM 寄存器均由调用者负责保存，被调用函数可任意使用。
- **标量 vs 向量**：XMM 寄存器既可存储标量浮点数（单个 `float`/`double`），也可存储 SIMD 向量数据。

---

## 二、浮点数据传送指令

用于在内存与寄存器、寄存器与寄存器之间移动浮点数据。

| 指令 | 操作数类型 | 说明 |
|---|---|---|
| `vmovss` | 单精度（32位） | 标量单精度浮点数传送 |
| `vmovsd` | 双精度（64位） | 标量双精度浮点数传送 |
| `vmovaps` | 单精度对齐 | 对齐的单精度打包传送（寄存器间） |
| `vmovapd` | 双精度对齐 | 对齐的双精度打包传送（寄存器间） |

> **注意**：寄存器到寄存器的传送推荐使用 `vmovaps` / `vmovapd`，内存传送使用 `vmovss` / `vmovsd`。

---

## 三、浮点数转换指令

### 3.1 浮点数与整数之间的转换

| 指令 | 说明 |
|---|---|
| `vcvttss2si` | 单精度 → 整数（截断方式） |
| `vcvttsd2si` | 双精度 → 整数（截断方式） |
| `vcvttss2siq` | 单精度 → 64位整数（截断方式） |
| `vcvttsd2siq` | 双精度 → 64位整数（截断方式） |
| `vcvtsi2ss` | 整数 → 单精度 |
| `vcvtsi2sd` | 整数 → 双精度 |
| `vcvtsi2ssq` | 64位整数 → 单精度 |
| `vcvtsi2sdq` | 64位整数 → 双精度 |

### 3.2 单精度与双精度之间的转换

| 指令 | 说明 |
|---|---|
| `vcvtss2sd` | 单精度 → 双精度 |
| `vcvtsd2ss` | 双精度 → 单精度 |

---
- 双精度转单精度实际会使用指令:
```
vmovddup %xmm0, %xmm0
vcvtpd2psx %xmm0, %xmm0
```
- 单精度转双精度实际会使用指令:
```
vunpcklps %xmm0, %xmm0, %xmm0
vcvtps2pd %xmm0, %xmm0
```


## 四、浮点算术指令

以下指令对**标量**浮点数执行算术运算（`s` 结尾为单精度，`d` 结尾为双精度）。

| 指令 | 说明 |
|---|---|
| `vaddss` / `vaddsd` | 加法 |
| `vsubss` / `vsubsd` | 减法 |
| `vmulss` / `vmulsd` | 乘法 |
| `vdivss` / `vdivsd` | 除法 |
| `vmaxss` / `vmaxsd` | 取较大值 |
| `vminss` / `vminsd` | 取较小值 |
| `vsqrtss` / `vsqrtsd` | 平方根 |

**指令格式**（三操作数）：

```
vaddsd  %xmm1(Source1), %xmm0(Source2), %xmm0(Dest)    # %xmm0 = %xmm0 + %xmm1
```

---

## 五、浮点位运算指令

用于对浮点数的位模式进行操作（常用于取反、取绝对值等）。

| 指令 | 说明 |
|---|---|
| `vxorps` / `vxorpd` | 按位异或（单/双精度） |
| `vandps` / `vandpd` | 按位与（单/双精度） |

**常见用法**：
```asm
; 对双精度浮点数取负（翻转符号位）
vxorpd  %xmm1, %xmm0, %xmm0 # 在%xmm1中存放10000000000...
```

---

## 六、浮点数比较指令

| 指令 | 说明 |
|---|---|
| `vucomiss` | 比较两个单精度浮点数（无序比较） |
| `vucomisd` | 比较两个双精度浮点数（无序比较） |

比较结果设置以下标志位：

| 条件 | ZF | PF | CF |
|---|---|---|---|
| 无序（任一为 NaN） | 1 | 1 | 1 |
| `S2 < S1` | 0 | 0 | 1 |
| `S2 > S1` | 0 | 0 | 0 |
| `S2 = S1` | 1 | 0 | 0 |

**注意**：浮点比较会设置 **奇偶标志位 PF**（整数运算通常不使用），处理 NaN 时需额外检查 PF。

常见跳转指令搭配：

| 条件 | 跳转指令 |
|---|---|
| 等于 | `je` |
| 不等于 | `jne` |
| 小于（有序） | `jb` |
| 小于等于（有序） | `jbe` |
| NaN | `jp`（奇偶跳转） |

---

## 七、综合示例

### C 代码
```c
double funct(double a, float x, double b, int i) {
    return a * x - b / i;
}
```

### 编译后汇编（示意）
```asm
; 参数：a -> %xmm0, x -> %xmm1, b -> %xmm2, i -> %edi
funct:
    vcvtss2sd   %xmm1, %xmm1, %xmm1     ; float x -> double
    vmulsd      %xmm1, %xmm0, %xmm0     ; a * x
    vcvtsi2sd   %edi,  %xmm1, %xmm1     ; int i -> double
    vdivsd      %xmm1, %xmm2, %xmm2     ; b / i
    vsubsd      %xmm2, %xmm0, %xmm0     ; a*x - b/i
    ret                                  ; 返回值在 %xmm0
```

---

## 八、关键要点总结

| 要点 | 说明 |
|---|---|
| 寄存器数量 | 16 个 XMM 寄存器（`%xmm0`~`%xmm15`） |
| 参数寄存器 | `%xmm0`~`%xmm7` 传递浮点参数 |
| 返回值寄存器 | `%xmm0` |
| 保存责任 | 全部由**调用者**保存 |
| 指令前缀 | AVX 指令以 `v` 开头（如 `vmovsd`） |
| 精度后缀 | `ss`=标量单精度，`sd`=标量双精度 |
| 比较特殊性 | 使用 `vucomiss`/`vucomisd`，需关注 PF（NaN 检测） |
