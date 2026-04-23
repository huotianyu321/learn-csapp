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

### 符号扩展（特殊转换指令）

| 指令 | 效果 |
|------|------|
| `cbtw` | `%al` 符号扩展 → `%ax` |
| `cwtl` | `%ax` 符号扩展 → `%eax` |
| `cltq` | `%eax` 符号扩展 → `%rax` |
| `cwtd` | `%ax` 符号扩展 → `%dx:%ax` |
| `cltd` | `%eax` 符号扩展 → `%edx:%eax` |
| `cqto` | `%rax` 符号扩展 → `%rdx:%rax` |

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
