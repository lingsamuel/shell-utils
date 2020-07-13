
# Shell 工具集

持续进化中……

- 日志相关函数：着色用。没有颜色的 log 是没有灵魂的。
- 数组相关函数
- 栈
- 杂七杂八的函数

## 引入方法

```bash
source ./shell-utils.sh
```

## 栈

栈的用法：

```bash
new_stack stack 200 # 新建一个名为 stack 的栈，大小为 200（默认为 100）
push stack 1
push stack 2
pop stack
echo $stack_POP # 返回值储存在 <stack_name>_POP 变量里
push stack 3
pop stack
echo $stack_POP
pop stack
echo $stack_POP
pop stack
echo $stack_POP # 空栈的返回值也是空（<stack_name>_POP 被 unset 了）
pop stack
echo $stack_POP
```

之所以 `pop` 的用法这么奇怪（更符合直觉的用法应该是 `VAL=$(pop stack)`），是因为这个栈实现是依赖环境变量的：它将 StackPointer 的信息存储在名为 `<stack_name>_SP` 的环境变量里。而 Subshell 的环境变量修改不影响父 Shell，所以不能通过 `$()` 语法来获取返回值。最简单的做法就是新建一个变量储存返回值了（实话说，我没想到别的解决方法）。

另外，此实现访问数据只依赖 StackPointer，因此实际上 `stack` 这个数组里的数据在 `pop` 后是不会被删除的，最多会在 `push` 时被覆盖。

使用 `print_stack <stack_name>` 来打印栈信息，输出格式为：  
`<stack_name> <stack_pointer>/<max_size> <values>`。

运行结果（在每次 `push` 和 `pop` 后添加了 `print_stack`）：

![](/page/shell-utils/stack.png)

可以看到 `pop` 并不会删除数据，只会修改 StackPointer。只有再次 `push`，才会将数据覆盖。

### 实现原理

由于需要支持动态的栈变量名，所以主要依靠 Variable Indirection Expansion 来动态展开变量。

其中，`new_stack` 依靠 `declare -a` 实现，`push` 则是将表达式拼成字符串然后 `eval`，`pop` 比较简单，利用 Indirection Expansion 直接取的值。

## 保存 ShellOpts

实现栈主要就是为了这个功能。

有时候，脚本需要 `set -eo pipefail` 来保证某个命令失败的时候，脚本能退出，而不会在错误的状态下继续执行。

但是，有的命令例如 `grep` 的 `exitcode!=0` 时也不一定是异常，这种行为可能是符合预期的。因此需要临时 `set +eo pipefail`。

那么，后续是否要启用 `-e` 和 `pipefail`？这是不一定的。因为外部可能根本没打开这个选项，如果盲目启用，反而可能会导致外部脚本执行错误。

`store_shell_opts` 和 `restore_shell_opts` 就是为了这个场景实现的。

范例：

```bash
#!/bin/bash
store_shell_opts # 保存最初始的 ShellOpts
set_must_success # set -eo pipefail
# do something must success...

func() {
  store_shell_opts # 保存上级 ShellOpts
  set_could_fail # set +eo pipefail
  # do something could fail, such as grep...
  restore_shell_opts # 恢复上级 ShellOpts
}
func

# do something must success...
restore_shell_opts
```

原本这个函数的实现是 `export` 一个固定名称的环境变量，不支持嵌套。栈使得嵌套成为可能。

## （有颜色的）日志

人生已经如此艰难，写个 Shell 脚本的 log 还不带颜色，debug 起来眼睛不会瞎吗？

### 基本颜色

```bash
gray "gray"
red "red"
green "green"
yellow "yellow"
blue "blue"
magenta "magenta"
cyan "cyan"
light_gray "light gray"
black "black"
dark_red "dark red"
dark_green "dark green"
dark_yellow "dark yellow"
dark_blue "dark blue"
dark_magenta "dark magenta"
dark_cyan "dark cyan"
white "white"
light_purple "light purple"
light_blue "light blue"
```

实际显示效果与 shell 配置有关。

![](/page/shell-utils/base-color.png)

### 脚本执行进程日志

```bash
e_header "System Installation"
e_success "Install success"
e_error "Install failed"
e_warning "Missing dependencies"
e_underline "Underline text"
e_bold "Bold"
e_note "Start with Note:"
e_step "1. Auto increment step note"
e_step "2. Auto increment step note"
e_reset_step
e_step "1. Resetted"
```

习惯了有颜色的脚本日志之后，根本看不懂没格式的日志了……

![](/page/shell-utils/process-log.png)

## Join 数组

```bash
arr=(a b c)
join_array ',' ${arr[@]}
join_array ' ' ${arr[@]}
join_array '-' ${arr[@]}
```

运行结果：

![](/page/shell-utils/join-array.png)