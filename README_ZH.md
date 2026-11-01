# evolved.lua

> 面向 Lua 的 Evolved ECS（实体-组件-系统）

[![lua5.1.5][badge.lua5.1.5]][lua5.1.5]
[![lua5.2.4][badge.lua5.2.4]][lua5.2.4]
[![lua5.3.6][badge.lua5.3.6]][lua5.3.6]
[![lua5.4.8][badge.lua5.4.8]][lua5.4.8]
[![lua5.5.0][badge.lua5.5.0]][lua5.5.0]
[![luajit2.1][badge.luajit2.1]][luajit2.1]
[![license][badge.license]][license]

[badge.lua5.1.5]: https://img.shields.io/github/actions/workflow/status/BlackMATov/evolved.lua/.github/workflows/lua5.1.5.yml?label=Lua%205.1
[badge.lua5.2.4]: https://img.shields.io/github/actions/workflow/status/BlackMATov/evolved.lua/.github/workflows/lua5.2.4.yml?label=Lua%205.2
[badge.lua5.3.6]: https://img.shields.io/github/actions/workflow/status/BlackMATov/evolved.lua/.github/workflows/lua5.3.6.yml?label=Lua%205.3
[badge.lua5.4.8]: https://img.shields.io/github/actions/workflow/status/BlackMATov/evolved.lua/.github/workflows/lua5.4.8.yml?label=Lua%205.4
[badge.lua5.5.0]: https://img.shields.io/github/actions/workflow/status/BlackMATov/evolved.lua/.github/workflows/lua5.5.0.yml?label=Lua%205.5
[badge.luajit2.1]: https://img.shields.io/github/actions/workflow/status/BlackMATov/evolved.lua/.github/workflows/luajit2.1.yml?label=LuaJIT%202.1
[badge.license]: https://img.shields.io/badge/license-MIT-blue

[lua5.1.5]: https://github.com/BlackMATov/evolved.lua/actions?query=workflow%3Alua5.1.5
[lua5.2.4]: https://github.com/BlackMATov/evolved.lua/actions?query=workflow%3Alua5.2.4
[lua5.3.6]: https://github.com/BlackMATov/evolved.lua/actions?query=workflow%3Alua5.3.6
[lua5.4.8]: https://github.com/BlackMATov/evolved.lua/actions?query=workflow%3Alua5.4.8
[lua5.5.0]: https://github.com/BlackMATov/evolved.lua/actions?query=workflow%3Alua5.5.0
[luajit2.1]: https://github.com/BlackMATov/evolved.lua/actions?query=workflow%3Aluajit2.1
[license]: https://en.wikipedia.org/wiki/MIT_License

[evolved]: https://github.com/BlackMATov/evolved.lua

> 中文翻译版，对应本目录下的 [README.md](README.md)。如与英文原文有出入，以英文原文为准。

- [简介](#introduction)
  - [性能](#performance)
    - [基准测试](#benchmarks)
  - [简洁](#simplicity)
  - [灵活](#flexibility)
- [安装](#installation)
- [快速开始](#quick-start)
- [总览](#overview)
  - [标识符](#identifiers)
  - [实体、片段与组件](#entities-fragments-and-components)
    - [特征（Trait）](#traits)
    - [单例（Singleton）](#singletons)
  - [Chunk（数据块）](#chunks)
    - [实体位置](#entity-location)
  - [结构性变更](#structural-changes)
    - [生成实体](#spawning-entities)
    - [实体构建器](#entity-builders)
    - [批量生成实体](#multi-entity-spawning)
  - [访问操作](#access-operations)
  - [遍历片段](#iterating-over-fragments)
  - [修改操作](#modifying-operations)
  - [调试模式](#debug-mode)
  - [查询](#queries)
    - [延迟操作](#deferred-operations)
    - [批量操作](#batch-operations)
  - [系统](#systems)
    - [处理载荷](#processing-payloads)
  - [预定义片段](#predefined-fragments)
    - [实体名称](#entity-names)
    - [片段标签](#fragment-tags)
    - [片段钩子](#fragment-hooks)
    - [索引片段](#indexed-fragments)
    - [唯一片段](#unique-fragments)
    - [显式片段](#explicit-fragments)
    - [内部片段](#internal-fragments)
    - [共享组件](#shared-components)
    - [片段依赖](#fragment-requirements)
    - [销毁策略](#destruction-policies)
    - [自定义组件存储](#custom-component-storages)
  - [错误处理](#error-handling)
  - [垃圾回收](#garbage-collection)
- [速查表](#cheat-sheet)
  - [别名](#aliases)
  - [预定义](#predefs)
  - [函数](#functions)
  - [类](#classes)
    - [Chunk](#chunk)
    - [Builder](#builder)
- [更新日志](#changelog)
  - [v1.12.0](#v1120)
  - [v1.11.1](#v1111)
  - [v1.11.0](#v1110)
  - [v1.10.0](#v1100)
  - [v1.9.0](#v190)
  - [v1.8.0](#v180)
  - [v1.7.0](#v170)
  - [v1.6.0](#v160)
  - [v1.5.0](#v150)
  - [v1.4.0](#v140)
  - [v1.3.0](#v130)
  - [v1.2.0](#v120)
  - [v1.1.0](#v110)
  - [v1.0.0](#v100)
- [许可证](#license)

<a id="introduction"></a>
## 简介

`evolved.lua` 是一个快速而灵活的 Lua ECS（实体-组件-系统）库。它的设计目标是简单易用，同时提供创建复杂系统所需的一切功能，并带来极快的性能。在开始探索这个库之前，我们先看看使用 `evolved.lua` 的主要优势：

<a id="performance"></a>
### 性能

这个库的设计目标是快，为此采用了许多技术。它使用基于原型（archetype）的方式来存储实体及其组件。组件以 SoA（Structure of Arrays，结构数组）方式存放在连续数组中，从而支持快速的遍历与处理。chunk 用于把拥有一组相同组件的实体归拢到一起，使查询能够高效过滤。此外，所有操作都旨在降低 GC（垃圾回收器）压力，并避免不必要的内存分配。我尽量考虑了原版 Lua 和 LuaJIT 中所有与性能相关的坑。

我想要的优化还没有全部实现，但我会继续做。不过现在就可以说，这个库对大多数用例来说已经足够快了。

<a id="benchmarks"></a>
#### 基准测试

库里在 [develop/benchmarks](./develop/benchmarks/) 目录中包含一些供内部使用的微基准测试，但它们并不全面，也不打算用于和其他 ECS 库比较。我不喜欢跨库基准测试，因为它们往往带有偏差，并不能代表真实场景下的性能。不过，你可以看看独立第三方作者做的基准测试，例如 [@jeffzi](https://github.com/jeffzi) 的[这些](https://github.com/jeffzi/lua-ecs-benchmark)很不错的基准测试，覆盖了大多数库，包括 `evolved.lua`。

<a id="simplicity"></a>
### 简洁

我尽量让 [API](#cheat-sheet) 保持简单直观，也控制着函数的数量。所有函数都从名字就能看出用途，容易上手。读完[总览](#overview)一节后，你应该就能顺利使用这个库了。

确实，这个库的核心有一些不太寻常的概念，但一旦上手，你会发现它非常好用。

<a id="flexibility"></a>
### 灵活

`evolved.lua` 不只是把组件放进实体。它是一个功能完整的 ECS 库，能让你构建复杂的[系统](#systems)与流程。你可以创建带过滤条件的[查询](#queries)，使用[延迟操作](#deferred-operations)和[批量操作](#batch-operations)。你也可以创建按特定顺序处理实体的系统。这个库被设计成灵活且可扩展，所以你可以轻松加入自己的特性与功能。像[片段钩子](#fragment-hooks)这样的特性，让你能以更灵活的方式管理组件，把它们与外部系统或库同步。这个库还提供了[实体构建器](#entity-builders)这类语法糖，用来创建实体、片段和系统，让你的日子更轻松。

另一方面，`evolved.lua` 也力求极简，不提供那些能在库外实现的功能。我试图在极简与可能性数量之间找到平衡，这迫使我在库的设计上做出灵活取舍。希望你会觉得这个平衡是可以接受的。

<a id="installation"></a>
## 安装

`evolved.lua` 是一个单文件的纯 Lua 库，不依赖任何外部库。它的设计目标是兼容 [Lua 5.1](https://www.lua.org/) 及更高版本、[LuaJIT](https://luajit.org/) 和 [Luau](https://luau.org/)（Roblox）。

开始使用这个库，你只需要 [evolved.lua](./evolved.lua) 源文件。你可以从[发布页](https://github.com/BlackMATov/evolved.lua/releases)下载，或者克隆[仓库](https://github.com/BlackMATov/evolved.lua)后把文件复制到你的项目中。

如果你使用 [LuaRocks](https://luarocks.org/)，可以用下面的命令安装：

```bash
luarocks install evolved.lua
```

<a id="quick-start"></a>
## 快速开始

要开始使用 `evolved.lua`，请阅读[总览](#overview)一节，了解基本概念以及如何使用这个库。之后可以看看[示例](example)，它们演示了这个库的复杂用法。最后，查阅[速查表](#cheat-sheet)，快速了解这个库提供的所有函数与类。

<a id="overview"></a>
## 总览

这个库的设计目标是简单且高性能。它使用基于原型（archetype）的方式来存储实体及其组件，这让你能非常高效地过滤和处理实体，尤其是在实体数量很多的时候。

如果你熟悉 ECS（实体-组件-系统）模式，会感觉非常亲切。如果不熟悉，我强烈建议先读一些相关介绍。这里有个不错的起点：[实体组件系统 FAQ](https://github.com/SanderMertens/ecs-faq)。

让我们开始吧！:godmode:

<a id="identifiers"></a>
### 标识符

标识符是一个打包后的 40 位整数。前 20 位表示索引，后 20 位表示版本。要创建新标识符，使用 [`evolved.id`](#evolvedid) 函数。

```lua
---@param count? integer
---@return evolved.id ... ids
function evolved.id(count) end
```

`count` 参数可选，默认为 `1`。函数会根据 `count` 返回一个或多个标识符。存活的标识符最多为 `2^20-1`（1048575）个。超过之后，函数会抛出错误：`| evolved.lua | id index overflow`。

标识符可以被回收。当某个标识符不再需要时，用 [`evolved.destroy`](#evolveddestroy) 函数销毁它，这样就能释放该标识符以供复用。

```lua
---@param ... evolved.id ids
function evolved.destroy(...) end
```

[`evolved.destroy`](#evolveddestroy) 函数接受一个或多个标识符作为参数。被销毁的标识符会加入回收器的空闲链表。对已经不存活的标识符调用 [`evolved.destroy`](#evolveddestroy) 是安全的，函数会直接忽略它们。

销毁一个标识符后，再次调用 [`evolved.id`](#evolvedid) 函数就能复用它。新标识符的索引与被销毁的相同，但版本不同。每次销毁标识符时版本都会递增。这个机制让我们既能复用索引，又能知道标识符是否存活。

可以用这组 [`evolved.alive`](#evolvedalive) 函数来检查标识符是否存活。

```lua
---@param id evolved.id
---@return boolean
function evolved.alive(id) end

---@param ... evolved.id ids
---@return boolean
function evolved.alive_all(...) end

---@param ... evolved.id ids
---@return boolean
function evolved.alive_any(...) end
```

有时（例如为了调试）需要从标识符中取出索引和版本，或者把它们重新打包成标识符。[`evolved.pack`](#evolvedpack) 和 [`evolved.unpack`](#evolvedunpack) 函数可以用于此目的。

```lua
---@param primary integer
---@param secondary integer
---@return evolved.id id
---@nodiscard
function evolved.pack(primary, secondary) end

---@param id evolved.id
---@return integer primary
---@return integer secondary
---@nodiscard
function evolved.unpack(id) end
```

下面是一个使用标识符的简短示例：

```lua
local evolved = require 'evolved'

local id = evolved.id() -- create a new identifier
assert(evolved.alive(id)) -- check that the identifier is alive

local index, version = evolved.unpack(id) -- unpack the identifier
assert(evolved.pack(index, version) == id) -- pack it back

evolved.destroy(id) -- destroy the identifier
assert(not evolved.alive(id)) -- check that the identifier is not alive now
```

<a id="entities-fragments-and-components"></a>
### 实体、片段与组件

首先，你需要明白实体和片段都只是标识符，它们之间的区别纯粹是语义上的。实体用于表示世界中的对象，而片段用于表示可以附加到实体上的组件类型。组件则是通过片段附加到实体上的任意数据。

```lua
---@alias evolved.entity evolved.id
---@alias evolved.fragment evolved.id
---@alias evolved.component any
```

下面是一个把组件附加到实体上的简单示例：

```lua
local evolved = require 'evolved'

local entity, fragment = evolved.id(2)

evolved.set(entity, fragment, 100)
assert(evolved.get(entity, fragment) == 100)
```

我知道这还不太容易理解，但别担心，我们慢慢来。在下一个例子里，我会给实体和片段起名字，这样就更容易看懂发生了什么。

```lua
local evolved = require 'evolved'

local player = evolved.id()

local health = evolved.id()
local stamina = evolved.id()

evolved.set(player, health, 100)
evolved.set(player, stamina, 50)

assert(evolved.get(player, health) == 100)
assert(evolved.get(player, stamina) == 50)
```

我们创建了一个名为 `player` 的实体，以及名为 `health` 和 `stamina` 的两个片段。我们通过这两个片段把组件 `100` 和 `50` 附加到实体上。之后，可以用 [`evolved.get`](#evolvedget) 函数取回这些组件。

我们会在后面[修改操作](#modifying-operations)一节更详细地介绍 [`evolved.set`](#evolvedset) 和 [`evolved.get`](#evolvedget) 函数。现在只需要知道，它们用于通过片段设置和获取实体上的组件。

这里要理解的重点是：你可以借助其他标识符，把任意数据附加到任意标识符上。

<a id="traits"></a>
#### 特征（Trait）

既然片段只是标识符，你也能把它们当作实体来用！片段的片段通常被称为 `traits`（特征）。这非常有用，例如可以用一些元数据来标记片段。

```lua
local evolved = require 'evolved'

local serializable = evolved.id()

local position = evolved.id()
evolved.set(position, serializable, true)

local velocity = evolved.id()
evolved.set(velocity, serializable, true)

local player = evolved.id()
evolved.set(player, position, {x = 0, y = 0})
evolved.set(player, velocity, {x = 0, y = 0})
```

在这个例子中，我们创建了一个名为 `serializable` 的特征，并把片段 `position` 和 `velocity` 标记为可序列化。之后你可以写一个序列化实体的函数，这个函数只会序列化被标记为可序列化的片段。这是这个库非常强大的特性，让你能构建非常灵活的系统。

<a id="singletons"></a>
#### 单例（Singleton）

片段甚至可以附加到它自己身上，这被称为单例。当你想存一些数据又不想单独建一个实体时，就可以这样用。例如，你可以用它保存全局数据，比如游戏状态或当前关卡。

```lua
local evolved = require 'evolved'

local gravity = evolved.id()
evolved.set(gravity, gravity, 10)

assert(evolved.get(gravity, gravity) == 10)
```

<a id="chunks"></a>
### Chunk（数据块）

接下来要理解的是：所有非空实体都存放在 chunk 中。chunk 就是把实体及其组件放在一起存储的表。每一种唯一的片段组合都存放在单独的 chunk 里。这意味着，如果有两个实体都带有 `health` 和 `stamina` 片段，它们会存放在 `<health, stamina>` chunk 中；如果还有一个实体带有 `health`、`stamina` 和 `mana` 片段，它就会存放在 `<health, stamina, mana>` chunk 中。这对性能非常有利，因为它让我们能把具有相同片段的实体放在一起，从而更容易遍历、过滤和处理它们。

```lua
local evolved = require 'evolved'

local health, stamina, mana = evolved.id(3)

local entity1 = evolved.id()
evolved.set(entity1, health, 100)
evolved.set(entity1, stamina, 50)

local entity2 = evolved.id()
evolved.set(entity2, health, 75)
evolved.set(entity2, stamina, 40)

local entity3 = evolved.id()
evolved.set(entity3, health, 50)
evolved.set(entity3, stamina, 30)
evolved.set(entity3, mana, 20)
```

上面的代码执行后，chunk 看起来会是这样：

| chunk   | health | stamina |
| ------- | :----: | :-----: |
| entity1 |  100   |   50    |
| entity2 |   75   |   40    |

| chunk   | health | stamina | mana  |
| ------- | :----: | :-----: | :---: |
| entity3 |   50   |   30    |  20   |

通常你不需要直接操作 chunk，但可以用 [`evolved.chunk`](#evolvedchunk) 函数获取特定的 chunk。

```lua
---@param fragment evolved.fragment
---@param ... evolved.fragment fragments
---@return evolved.chunk chunk
function evolved.chunk(fragment, ...) end
```

[`evolved.chunk`](#evolvedchunk) 函数接受一个或多个片段作为参数，返回这一组合对应的 chunk。之后，你可以使用 chunk 的方法获取其中的实体、片段和组件。

```lua
---@return evolved.entity[] entity_list
---@return integer entity_count
function chunk_mt:entities() end

---@return evolved.fragment[] fragment_list
---@return integer fragment_count
function chunk_mt:fragments() end

---@param ... evolved.fragment fragments
---@return evolved.storage ... storages
function chunk_mt:components(...)
```

完整示例：

```lua
local evolved = require 'evolved'

local health, stamina, mana = evolved.id(3)

local entity1 = evolved.id()
evolved.set(entity1, health, 100)
evolved.set(entity1, stamina, 50)

local entity2 = evolved.id()
evolved.set(entity2, health, 75)
evolved.set(entity2, stamina, 40)

local entity3 = evolved.id()
evolved.set(entity3, health, 50)
evolved.set(entity3, stamina, 30)
evolved.set(entity3, mana, 20)

-- get (or create if it doesn't exist) the chunk <health, stamina>
local chunk = evolved.chunk(health, stamina)

-- get the list of entities in the chunk and the number of them
local entity_list, entity_count = chunk:entities()

-- get the columns of components in the chunk
local health_components = chunk:components(health)
local stamina_components = chunk:components(stamina)

for i = 1, entity_count do
    local entity = entity_list[i]

    local entity_health = health_components[i]
    local entity_stamina = stamina_components[i]

    -- do something with the entity and its components
    print(string.format(
        'Entity: %d, Health: %d, Stamina: %d',
        entity, entity_health, entity_stamina))
end

-- Expected output:
-- Entity: 1048602, Health: 100, Stamina: 50
-- Entity: 1048603, Health: 75, Stamina: 40
```

<a id="entity-location"></a>
#### 实体位置

有时我们需要知道某个实体位于哪个 chunk，以及它在该 chunk 中的位置。[`evolved.locate`](#evolvedlocate) 函数提供了这些信息。

```lua
---@param entity evolved.entity
---@return evolved.chunk? chunk
---@return integer place
function evolved.locate(entity) end
```

这个函数接受一个实体，返回包含它的 chunk 以及该实体在 chunk 中的位置（索引）。如果实体不存活或者是空的，函数会返回 `nil` 作为 chunk、`0` 作为位置。

这是底层功能，你很少会用到。不过在某些特定场景下它很有用。例如，当你需要直接修改实体的组件，以避免不必要的[延迟操作](#deferred-operations)或[片段钩子](#fragment-hooks)，而不是使用 [`evolved.set`](#evolvedset) 这类更高层的函数时。

```lua
local evolved = require 'evolved'

local health, stamina = evolved.id(2)

local player = evolved.id()

evolved.set(player, health, 100)
evolved.set(player, stamina, 50)

local player_chunk, player_place = evolved.locate(player)

local health_components = player_chunk:components(health)
local stamina_components = player_chunk:components(stamina)

health_components[player_place] = 75
stamina_components[player_place] = 42
```

> [!WARNING]
> 除非你完全清楚自己在做什么，否则不要用 [`evolved.locate`](#evolvedlocate) 直接操作组件。因为它是底层功能，使用不当会导致数据不一致，它会绕过库的安全检查和钩子机制。只有在你确定安全且必要时才使用它。

<a id="structural-changes"></a>
### 结构性变更

每当我们向实体插入片段或从实体中移除片段时，实体都会被迁移到新的 chunk。当然，这一切由库自动完成。不过你应该对此有所了解，因为它会影响性能，尤其是当实体上挂了很多片段时。这就是所谓的结构性变更（`structural change`）。

你应当尽量避免结构性变更，尤其是在性能关键的代码中。例如，你可以在生成实体时就把之后会用到的所有片段都给它，从而在实体生命周期内避免再改动它们。覆盖已有组件不算结构性变更，因此你可以随意这么做。

<a id="spawning-entities"></a>
#### 生成实体

```lua
---@param component_table? table<evolved.fragment, evolved.component>
---@param component_mapper? fun(chunk: evolved.chunk, place: integer)
---@return evolved.entity
function evolved.spawn(component_table, component_mapper) end

---@param prefab evolved.entity
---@param component_table? table<evolved.fragment, evolved.component>
---@param component_mapper? fun(chunk: evolved.chunk, place: integer)
---@return evolved.entity
function evolved.clone(prefab, component_table, component_mapper) end
```

[`evolved.spawn`](#evolvedspawn) 函数允许你生成一个带有所有所需片段的实体。它接受一个组件表作为参数，其中键是片段、值是组件。顺便说，你不需要每次都创建这个 `component_table`；为了获得最高性能，可以考虑使用预先定义好的表。

你也可以用 [`evolved.clone`](#evolvedclone) 函数来克隆一个已存在的实体。当你需要创建与某个已存在实体具有相同片段、但组件不同的实体时，这很有用。

```lua
local evolved = require 'evolved'

local health, stamina = evolved.id(2)

-- spawn an entity with all the necessary fragments
local enemy1 = evolved.spawn {
    [health] = 100,
    [stamina] = 50,
}

-- spawn another entity with the same fragments,
-- but with a different component for some of them
local enemy2 = evolved.clone(enemy1, {
    [health] = 50,
})

-- there are no structural changes here,
-- we just override existing components
evolved.set(enemy1, health, 75)
evolved.set(enemy1, stamina, 42)
```

<a id="entity-builders"></a>
#### 实体构建器

生成实体时避免结构性变更的另一种方式是使用 [`evolved.builder`](#evolvedbuilder) 的流式接口。[`evolved.builder`](#evolvedbuilder) 函数返回一个构建器对象，让你可以在生成实体时指定一组特定的片段和组件，而无需用一次次结构性变更逐个设置。

```lua
local evolved = require 'evolved'

local health, stamina = evolved.id(2)

local enemy = evolved.builder()
    :set(health, 100)
    :set(stamina, 50)
    :build()
```

构建器可以复用，因此你可以创建一个包含特定片段和组件的构建器，然后用它生成多个拥有相同片段和组件的实体。

<a id="multi-entity-spawning"></a>
#### 批量生成实体

当你需要生成多个具有相同片段的实体时，用 `multi_spawn` 和 `multi_clone` 来优化性能、减少开销。

```lua
---@param entity_count integer
---@param component_table? evolved.component_table
---@param component_mapper? evolved.component_mapper
---@return evolved.entity[] entity_list
---@return integer entity_count
---@nodiscard
function evolved.multi_spawn(entity_count, component_table, component_mapper) end

---@param entity_count integer
---@param prefab evolved.entity
---@param component_table? evolved.component_table
---@param component_mapper? evolved.component_mapper
---@return evolved.entity[] entity_list
---@return integer entity_count
---@nodiscard
function evolved.multi_clone(entity_count, prefab, component_table, component_mapper) end
```

这些函数的行为与对应的单实体版本相似，但允许你在一次调用中生成或克隆多个实体。这种做法把重复函数调用和结构性变更的开销降到最低，在处理大量实体时能提升性能。

通常，批量生成的多个实体共享同一组片段，但它们的组件可以各不相同。你可以通过提供一个 `component_mapper` 函数来实现这一点，它会接收到 chunk 以及新生成实体所在位置的范围。这样就避免了生成之后再调用大量 `evolved.set`，而在创建大量实体时这些调用的代价很高。

下面是一个使用 `evolved.multi_spawn` 搭配 `component_mapper` 的小例子：

```lua
local evolved = require 'evolved'

local position_x, position_y = evolved.id(2)

evolved.multi_spawn(1000, {
    [position_x] = 0,
    [position_y] = 0,
}, function(chunk, b_place, e_place)
    local x_components = chunk:components(position_x)
    local y_components = chunk:components(position_y)

    for i = b_place, e_place do
        x_components[i] = math.random(-100, 100)
        y_components[i] = math.random(-100, 100)
    end
end)
```

当然，你也可以用同样的方式使用 `evolved.multi_clone`。构建器同样可用于批量生成和批量克隆，只需在构建器对象上调用相应方法。

另外，库为所有 `multi_` 函数都提供了 [`_nr`](#evolvedmulti_spawn_nr) 和 [`_to`](#evolvedmulti_spawn_to) 后缀变体，它们让你可以在执行这些操作时不返回生成的实体列表，或者把生成的实体复制到你自己的表中；后者更高效，因为它避免了分配和返回新表的开销。

```lua
local evolved = require 'evolved'

local position_x, position_y = evolved.id(2)

do
    -- we don't interest in the list of spawned entities,
    -- so we use the _nr variant of the multi_spawn function

    evolved.multi_spawn_nr(100, {
        [position_x] = 0,
        [position_y] = 0,
    })
end

do
    -- store spawned entities in our own table starting at index 1,
    -- so we use the _to variant of the multi_spawn function

    local entity_list = {}

    evolved.multi_spawn_to(entity_list, 1, 100, {
        [position_x] = 0,
        [position_y] = 0,
    })
end
```

<a id="access-operations"></a>
### 访问操作

库提供了访问实体及其组件所需的全部函数。这里我不会逐一介绍所有访问器函数，因为它们都很直白、一看就懂。你可以在 [API 参考](#api-reference) 中查看全部函数。以下是其中最重要的几个：

```lua
---@param entity evolved.entity
---@return boolean
function evolved.alive(entity) end

---@param entity evolved.entity
---@return boolean
function evolved.empty(entity) end

---@param entity evolved.entity
---@param fragment evolved.fragment
function evolved.has(entity, fragment) end

---@param entity evolved.entity
---@param ... evolved.fragment fragments
---@return evolved.component ... components
function evolved.get(entity, ...) end
```

[`evolved.alive`](#evolvedalive) 函数检查实体是否存活。[`evolved.empty`](#evolvedempty) 函数检查实体是否为空（不拥有任何片段）。[`evolved.has`](#evolvedhas) 函数检查实体是否拥有某个特定片段。[`evolved.get`](#evolvedget) 函数取出实体在指定片段上的组件。如果实体缺少其中某些片段，或者这些片段被标记为 [`evolved.TAG`](#evolvedtag)，该函数对应的返回值就是 `nil`。

所有这些函数都可以安全地作用于非存活实体和非存活片段。此外，它们不会引起任何结构性变更，因为它们不修改任何东西。

<a id="iterating-over-fragments"></a>
### 遍历片段

有时你可能需要遍历附着在实体上的所有片段。为此你可以使用 [`evolved.each`](#evolvedeach) 函数。

```lua
local evolved = require 'evolved'

local health = evolved.builder()
    :name('health')
    :build()

local stamina = evolved.builder()
    :name('stamina')
    :build()

local player = evolved.builder()
    :set(health, 100)
    :set(stamina, 50)
    :build()

for fragment, component in evolved.each(player) do
    print(string.format('Fragment (%s) has value %d',
        evolved.name(fragment), component))
end
```

> [!NOTE]
> 遍历过程中不允许进行[结构性变更](#structural-changes)。如果你想在遍历时生成新实体或插入/移除片段，请把这些操作推迟到遍历结束之后。更多细节见[延迟操作](#deferred-operations)一节。

<a id="modifying-operations"></a>
### 修改操作

库提供了一组经典的实体修改函数。这些函数用于向实体插入、覆盖和移除片段。

```lua
---@param entity evolved.entity
---@param fragment evolved.fragment
---@param component evolved.component
function evolved.set(entity, fragment, component) end

---@param entity evolved.entity
---@param ... evolved.fragment fragments
function evolved.remove(entity, ...)

---@param ... evolved.entity entities
function evolved.clear(...)

---@param ... evolved.entity entities
function evolved.destroy(...)
```

[`evolved.set`](#evolvedset) 函数用于在实体上设置组件。如果实体没有该片段，片段会被插入——当然，这会引起结构性变更。如果实体已有该片段，组件会被覆盖。不应在非存活实体上调用该函数，因为不可能在已销毁的实体上设置任何组件，忽视这一点可能导致错误。[调试模式](#debug-mode) 可以用来检查这类错误。

用 [`evolved.remove`](#evolvedremove) 函数从实体上移除片段。如果实体没有其中某些片段，这些片段会被忽略。当从一个实体上移除一个或多个片段时，实体将被迁移到新的 chunk，这就是一次结构性变更。当你想移除多个片段时，把它们全部作为参数传入。不要逐个移除片段，因为那会为每个片段各引起一次结构性变更。[`evolved.remove`](#evolvedremove) 函数会忽略非存活实体，因为后置条件已经满足（已销毁的实体没有任何片段，包括我们想移除的那些）。

要移除实体上的所有片段，使用 [`evolved.clear`](#evolvedclear) 函数。该函数会一次性移除所有片段，只引起一次结构性变更。[`evolved.clear`](#evolvedclear) 函数不会销毁实体，它只是移除实体上的所有片段。此操作之后实体变为空，但仍然存活。你可以把多个实体作为参数传入，一次性清空它们。该函数会忽略空实体和非存活实体。

要销毁实体，使用 [`evolved.destroy`](#evolveddestroy) 函数。该函数会移除实体上的所有片段，并释放实体的标识符以供复用。[`evolved.destroy`](#evolveddestroy) 函数会忽略非存活实体。要销毁多个实体，把它们作为参数传入。

<a id="debug-mode"></a>
### 调试模式

库有一个调试模式，可以通过 [`evolved.debug_mode`](#evolveddebug_mode) 函数启用。启用调试模式后，库会检查 API 是否被错误使用，一旦检测到就抛出错误。这对调试和开发非常有用，但会让性能稍有下降。

```lua
---@param yesno boolean
function evolved.debug_mode(yesno) end
```

调试模式默认关闭，因此你需要手动启用。我强烈建议在开发环境中启用它。你甚至可以在生产环境中保持启用，但前提是你确定性能在你的场景下可以接受。

```lua
local evolved = require 'evolved'

evolved.debug_mode(true)

local entity = evolved.id()

local fragment = evolved.id()
evolved.destroy(fragment)

-- try to use the destroyed fragment
evolved.set(entity, fragment, 42)

-- [error] | evolved.lua | the fragment ($1048599#23:1) is not alive and cannot be used
```

<a id="queries"></a>
### 查询

任何 ECS 库最重要的特性之一，就是能按过滤器或查询来处理实体。`evolved.lua` 提供了一种简单而高效的方式来做这件事。

首先，你需要创建一个查询，用来描述你想处理哪些实体。你可以指定要包含的片段，以及要排除的片段。查询其实就是带有特殊预定义片段的标识符：[`evolved.INCLUDES`](#evolvedincludes)、[`evolved.EXCLUDES`](#evolvedexcludes) 和 [`evolved.VARIANTS`](#evolvedvariants)。这些片段期望把片段列表作为自己的组件。

- [`evolved.INCLUDES`](#evolvedincludes) 用于指定实体中必须存在的片段；
- [`evolved.EXCLUDES`](#evolvedexcludes) 用于指定实体中必须不存在的片段；
- [`evolved.VARIANTS`](#evolvedvariants) 用于指定一组片段，其中至少有一个必须存在于实体中。

```lua
local evolved = require 'evolved'

local health, poisoned, resistant = evolved.id(3)
local alive, undead = evolved.id(2)

local query = evolved.id()
evolved.set(query, evolved.INCLUDES, { health, poisoned })
evolved.set(query, evolved.EXCLUDES, { resistant })
evolved.set(query, evolved.VARIANTS, { alive, undead })
```

构建器接口也可以用来创建查询。它用起来更方便，因为构建器提供了专门用于包含和排除片段的方法。下面是一个简单的例子：

```lua
local query = evolved.builder()
    :include(health, poisoned)
    :exclude(resistant)
    :variant(alive, undead)
    :build()
```

我们不必把 [`evolved.INCLUDES`](#evolvedincludes)、[`evolved.EXCLUDES`](#evolvedexcludes) 和 [`evolved.VARIANTS`](#evolvedvariants) 这三个片段都设置上；甚至可以完全不设过滤器，此时查询会匹配世界中的所有 chunk。

查询创建好之后，我们就可以处理经过它过滤的实体了。通过 [`evolved.execute`](#evolvedexecute) 函数即可做到。该函数接收一个查询作为参数，并返回一个迭代器，你可以用它遍历所有与查询匹配的 chunk。

```lua
---@param query evolved.query
---@return evolved.execute_iterator iterator
---@return evolved.execute_state? iterator_state
function evolved.execute(query) end
```

```lua
for chunk, entity_list, entity_count in evolved.execute(query) do
    ---@type number[]
    local health_components = chunk:components(health)

    for i = 1, entity_count do
        health_components[i] = math.max(
            health_components[i] - 1,
            0)
    end
end
```

如你所见，`evolved.execute_iterator` 会返回一个 chunk、该 chunk 中的实体列表，以及这个 chunk 里的实体数量。我们[已经知道](#chunks)如何使用 chunk，所以可以用 chunk 的方法取出 chunk 中实体的组件、修改它们，等等。

> [!NOTE]
> 不过还有一件重要的事我还没提：在任何遍历 chunk 的过程中都不允许[结构性变更](#structural-changes)。这意味着遍历时你不能给实体插入或移除片段。同样，你也不能销毁或生成实体，因为这同样会造成结构性变更。这样做是为了避免迭代过程出现不一致。如果这里允许结构性变更，我们可能会在迭代中跳过某些实体，或把同一个实体处理多次。[调试模式](#debug-mode)可以捕获这类错误。

<a id="deferred-operations"></a>
#### 延迟操作

现在我们知道遍历期间不允许结构性变更，但如果我们想在遍历结束后做结构性变更呢？例如，我们可能想在处理完实体后从它们身上移除一些片段，或者在处理已有实体时生成新实体。要完成这些，我们可以使用延迟操作。

```lua
---@return boolean started
function evolved.defer() end

---@return integer depth
---@nodiscard
function evolved.depth() end

---@return boolean committed
function evolved.commit() end

---@return boolean cancelled
function evolved.cancel() end
```

[`evolved.defer`](#evolveddefer) 函数会开启一个延迟作用域。这意味着在该作用域内做的所有变更都会被排队，并在离开作用域后应用。[`evolved.commit`](#evolvedcommit) 函数会关闭最近的延迟作用域并应用所有排队的变更。这些函数可以嵌套，所以你可以在已有的延迟作用域内再开启一个新的。[`evolved.commit`](#evolvedcommit) 只在最后一个延迟作用域关闭时才会应用所有排队的变更。[`evolved.depth`](#evolveddepth) 函数返回当前延迟作用域的深度。如果没有延迟作用域，它返回 `0`。

```lua
local evolved = require 'evolved'

local health, poisoned = evolved.id(2)

local player = evolved.builder()
    :set(health, 100)
    :set(poisoned, true)
    :build()

-- start a deferred scope
evolved.defer()

-- this removal will be queued, not applied immediately
evolved.remove(player, poisoned)

-- the player still has the poisoned fragment inside the deferred scope
assert(evolved.has(player, poisoned))

-- commit the deferred operations
evolved.commit()

-- now the poisoned fragment is removed
assert(not evolved.has(player, poisoned))
```

[`evolved.cancel`](#evolvedcancel) 函数用于取消当前延迟作用域中所有排队的变更。当你因为错误或其他情况，想丢弃作用域内做的所有变更并回到之前的状态时，这很有用。

```lua
local evolved = require 'evolved'

local health, poisoned = evolved.id(2)

local player = evolved.builder()
    :set(health, 100)
    :set(poisoned, true)
    :build()

-- start a deferred scope
evolved.defer()

-- this removal will be queued, not applied immediately
evolved.remove(player, poisoned)

-- the player still has the poisoned fragment inside the deferred scope
assert(evolved.has(player, poisoned))

-- cancel the deferred operations
evolved.cancel()

-- the poisoned fragment is still there
assert(evolved.has(player, poisoned))
```

<a id="batch-operations"></a>
#### 批量操作

库提供了一组用于批量操作的函数。这些函数用于一次对多个 chunk 执行修改操作。出于性能考虑，这非常有用。

```lua
---@param query evolved.query
---@param fragment evolved.fragment
---@param component evolved.component
function evolved.batch_set(query, fragment, component) end

---@param query evolved.query
---@param ... evolved.fragment fragments
function evolved.batch_remove(query, ...) end

---@param ... evolved.query queries
function evolved.batch_clear(...) end

---@param ... evolved.query queries
function evolved.batch_destroy(...) end
```

这些函数与常见的[修改操作](#modifying-operations)类似，只是它们接收查询而不是实体作为参数。下面是一个经典例子，用上之后性能会大幅提升。

```lua
local evolved = require 'evolved'

local destroying_mark = evolved.id()

local destroying_mark_query = evolved.builder()
    :include(destroying_mark)
    :build()

-- destroy all entities with the destroying_mark fragment
evolved.batch_destroy(destroying_mark_query)
```

> [!TIP]
> 当你需要对多个实体一次执行销毁或移除片段这类简单操作时，应始终优先选择批量操作，而不是常见的修改操作。批量操作不会逐个实体地应用，而是按 chunk 逐个应用。

在其他所有方面，批量操作的行为与我们前面讲过的常见修改操作相同。当然，它们也可以配合[延迟操作](#deferred-operations)使用。

<a id="systems"></a>
### 系统

通常，我们会把实体处理组织成系统，并按特定顺序执行。库用特殊的 [`evolved.QUERY`](#evolvedquery) 和 [`evolved.EXECUTE`](#evolvedexecute) 片段来做到这一点，它们用于指定系统的查询和执行回调。没错，系统就是带特殊片段的实体。

```lua
local evolved = require 'evolved'

local health, max_health = evolved.id(2)

local query = evolved.builder()
    :include(health, max_health)
    :build()

local system = evolved.builder()
    :query(query)
    :execute(function(chunk, entity_list, entity_count)
        local health_components = chunk:components(health)
        local max_health_components = chunk:components(max_health)

        for i = 1, entity_count do
            health_components[i] = math.min(
                health_components[i] + 1,
                max_health_components[i])
        end
    end):build()
```

[`evolved.process`](#evolvedprocess) 函数用于处理系统。它接收系统作为参数，并按传入顺序执行它们。

```lua
---@param ... evolved.system systems
function evolved.process(...) end
```

如果你不为系统指定查询，系统自身会被当作查询使用。这意味着系统可以包含 `evolved.INCLUDES`、`evolved.EXCLUDES` 和 `evolved.VARIANTS` 片段，并据此被处理。当你要创建查询独特、不需要在其他系统中复用的系统时，这很有用。

```lua
local evolved = require 'evolved'

local health = evolved.id()

local system = evolved.builder()
    :include(health)
    :execute(function(chunk, entity_list, entity_count)
        local health_components = chunk:components(health)

        for i = 1, entity_count do
            health_components[i] = math.max(
                health_components[i] - 1,
                0)
        end
    end):build()

evolved.process(system)
```

要把系统分组，可以使用 [`evolved.GROUP`](#evolvedgroup) 片段。指定了组的系统会在你以该组调用 [`evolved.process`](#evolvedprocess) 函数时被处理。例如，你可以把所有物理系统归为一组，并在一次 [`evolved.process`](#evolvedprocess) 调用中处理它们。

```lua
local evolved = require 'evolved'

local gravity_x = 0
local gravity_y = -9.81

local position_x, position_y = evolved.id(2)
local velocity_x, velocity_y = evolved.id(2)

local physical_body_query = evolved.builder()
    :include(position_x, position_y)
    :include(velocity_x, velocity_y)
    :build()

local physics_group = evolved.id()

evolved.builder()
    :group(physics_group)
    :query(physical_body_query)
    :execute(function(chunk, entity_list, entity_count)
        local vx = chunk:components(velocity_x)
        local vy = chunk:components(velocity_y)

        for i = 1, entity_count do
            vx[i] = vx[i] + gravity_x
            vy[i] = vy[i] + gravity_y
        end
    end):build()

evolved.builder()
    :group(physics_group)
    :query(physical_body_query)
    :execute(function(chunk, entity_list, entity_count)
        local px = chunk:components(position_x)
        local py = chunk:components(position_y)

        local vx = chunk:components(velocity_x)
        local vy = chunk:components(velocity_y)

        for i = 1, entity_count do
            px[i] = px[i] + vx[i]
            py[i] = py[i] + vy[i]
        end
    end):build()

evolved.process(physics_group)
```

系统和组还可以有 [`evolved.PROLOGUE`](#evolvedprologue) 和 [`evolved.EPILOGUE`](#evolvedepilogue) 片段。这些片段用于指定在系统或组被处理之前和之后执行的回调。这适合用来初始化与清理系统或组，或在主处理前后做一些额外的处理。

```lua
local evolved = require 'evolved'

local system = evolved.builder()
    :prologue(function()
        print('Prologue')
    end)
    :epilogue(function()
        print('Epilogue')
    end)
    :build()

evolved.process(system)
```

prologue 和 epilogue 片段不需要显式的查询。无论查询如何，它们都会在系统处理之前和之后执行。

> [!NOTE]
> 关于系统还有一点。执行回调是在[延迟作用域](#deferred-operations)中调用的，这意味着回调内的所有修改操作都会被排队，并在系统处理完所有 chunk 之后才应用。但 prologue 和 epilogue 回调不在延迟作用域中调用，所以它们内部的所有修改操作都会立即生效。这样做是为了避免混淆，并明确 prologue 和 epilogue 回调并不属于 chunk 处理的一部分。

<a id="processing-payloads"></a>
#### 处理载荷

此外，系统还可以带有载荷，它会被传给执行、prologue 和 epilogue 回调。这样就能在不使用全局变量或闭包的情况下把额外数据传给系统。

```lua
---@param system evolved.system
---@param ... any processing payload
function evolved.process_with(system, ...) end
```

[`evolved.process_with`](#evolvedprocess_with) 函数与 [`evolved.process`](#evolvedprocess) 函数类似，但它额外接收处理载荷作为参数。这些参数会被传给系统的回调。

```lua
local evolved = require 'evolved'

local position_x, position_y = evolved.id(2)
local velocity_x, velocity_y = evolved.id(2)

local physics_system = evolved.builder()
    :include(position_x, position_y)
    :include(velocity_x, velocity_y)
    :execute(function(chunk, entity_list, entity_count, delta_time)
        local px, py = chunk:components(position_x, position_y)
        local vx, vy = chunk:components(velocity_x, velocity_y)

        for i = 1, entity_count do
            px[i] = px[i] + vx[i] * delta_time
            py[i] = py[i] + vy[i] * delta_time
        end
    end):build()

local delta_time = 0.016
evolved.process_with(physics_system, delta_time)
```

这个例子里的 `delta_time` 作为处理载荷传给系统的执行回调。载荷可以是任意类型，也可以有多个值。此外，如果定义了 prologue 和 epilogue 回调，载荷也会传给它俩。当用 [`evolved.process_with`](#evolvedprocess_with) 处理某个组时，组内的每个子系统都会收到相同的载荷。

<a id="predefined-fragments"></a>
### 预定义片段

<a id="entity-names"></a>
#### 实体名称

库提供了一种使用 [`evolved.NAME`](#evolvedname) 片段为任意 id 分配名称的方法。这在调试和开发时很有用，因为它允许你通过名称而不是标识符来识别实体或片段。可以通过 [`evolved.name`](#evolvedname-1) 函数获取实体的名称。

```lua
local evolved = require 'evolved'

local player = evolved.builder()
    :name('Player')
    :build()

assert(evolved.name(player) == 'Player')
```

名称并不唯一，因此多个实体可以拥有相同的名称。此外，你可以随时把一个新名称当作普通组件，通过 [`evolved.NAME`](#evolvedname) 片段来更改实体的名称。

你可以使用 [`evolved.lookup`](#evolvedlookup) 和 [`evolved.multi_lookup`](#evolvedmulti_lookup) 函数按名称查找实体。[`evolved.lookup`](#evolvedlookup) 函数返回第一个具有指定名称的实体，而 [`evolved.multi_lookup`](#evolvedmulti_lookup) 函数返回所有具有指定名称的实体列表。

```lua
local evolved = require 'evolved'

local player1 = evolved.builder()
    :name('Player')
    :build()

local player2 = evolved.builder()
    :name('Player')
    :build()

assert(evolved.lookup('Player') == player1)

local player_list, player_count = evolved.multi_lookup('Player')
assert(player_count == 2 and player_list[1] == player1 and player_list[2] == player2)
```

在底层，[`evolved.NAME`](#evolvedname) 片段被标记了 [`evolved.INDEX`](#evolvedindex) 片段特征（trait），因此 [`evolved.lookup`](#evolvedlookup) 函数只是使用 [`evolved.NAME`](#evolvedname) 片段的 [`evolved.search`](#evolvedsearch) 函数的简写。更多细节参见[索引片段](#indexed-fragments)一节。

<a id="fragment-tags"></a>
#### 片段标签

有时你想要一个没有组件的片段。例如，你可能想用一些标记来把实体标记为需要处理。没有组件的片段称为 `tags`。这类片段占用更少内存，因为它们不需要存储任何组件。带标签的实体迁移更快，因为库不需要迁移组件，只需要迁移标签本身。要创建标签，用 [`evolved.TAG`](#evolvedtag) 片段标记该片段即可。

```lua
local evolved = require 'evolved'

local player_tag = evolved.id()
evolved.set(player_tag, evolved.TAG)

local player = evolved.id()
evolved.set(player, player_tag)

-- player has the player_tag fragment
assert(evolved.has(player, player_tag))

-- player_tag is a tag, so it doesn't have a component
assert(evolved.get(player, player_tag) == nil)
```

<a id="fragment-hooks"></a>
#### 片段钩子

库提供了一种在片段被设置、赋值、插入或从实体移除时执行回调的方法。这通过一些特殊片段实现：[`evolved.ON_SET`](#evolvedon_set)、[`evolved.ON_ASSIGN`](#evolvedon_assign)、[`evolved.ON_INSERT`](#evolvedon_insert) 和 [`evolved.ON_REMOVE`](#evolvedon_remove)。这些片段用于指定在对片段执行相应操作时要执行的回调。

```lua
local evolved = require 'evolved'

local health = evolved.builder()
    :on_set(function(entity, fragment, component)
        print('health set to ' .. component)
    end):build()

local player = evolved.id()
evolved.set(player, health, 100) -- prints "health set to 100"
evolved.set(player, health, 200) -- prints "health set to 200"
```

用 [`evolved.ON_SET`](#evolvedon_set) 处理片段插入或覆盖时的回调，用 [`evolved.ON_ASSIGN`](#evolvedon_assign) 处理覆盖，用 [`evolved.ON_INSERT`](#evolvedon_insert)/[`evolved.ON_REMOVE`](#evolvedon_remove) 处理插入或移除。

> [!NOTE]
> 由于被 [`evolved.TAG`](#evolvedtag) 标记的片段（也叫[片段标签](#fragment-tags)）没有组件，它们的 [`evolved.ON_SET`](#evolvedon_set) 钩子只在标签被插入时触发，而不会在覆盖时触发，因为没有东西可以覆盖。出于同样的原因，这类标签的 [`evolved.ON_ASSIGN`](#evolvedon_assign) 钩子永远不会被触发。

<a id="indexed-fragments"></a>
#### 索引片段

有时你需要的不只是按片段是否存在来查找实体，还要按片段组件的值来查找。例如，你可能想按网络标识符查找玩家，或查找某个队伍的所有单位。为了不遍历 chunk 就做到这一点，请用 [`evolved.INDEX`](#evolvedindex) 片段特征标记该片段。库会维护一个从组件值到实体的索引，你就可以使用 [`evolved.search`](#evolvedsearch)、[`evolved.multi_search`](#evolvedmulti_search) 和 [`evolved.multi_search_to`](#evolvedmulti_search_to) 函数找到这类实体。

```lua
local evolved = require 'evolved'

local team = evolved.builder()
    :index()
    :build()

local unit1 = evolved.builder()
    :set(team, 'red')
    :build()

local unit2 = evolved.builder()
    :set(team, 'blue')
    :build()

local unit3 = evolved.builder()
    :set(team, 'red')
    :build()

assert(evolved.search(team, 'blue') == unit2)

local red_list, red_count = evolved.multi_search(team, 'red')
assert(red_count == 2 and red_list[1] == unit1 and red_list[2] == unit3)
```

[`evolved.search`](#evolvedsearch) 函数返回第一个具有指定组件的实体，而 [`evolved.multi_search`](#evolvedmulti_search) 函数返回所有这类实体的列表。[`evolved.multi_search_to`](#evolvedmulti_search_to) 函数作用相同，但它会从指定索引开始把实体追加到提供的列表中，并且只返回找到的实体数量。

实体按它们获得组件的顺序被找到，并且在移除之后该顺序仍然保持。当实体改变其组件的值时，它会被移动到具有新值的实体末尾。无论具有相同值的实体有多少，插入和移除都只需常数时间。

```lua
local evolved = require 'evolved'

local team = evolved.builder()
    :index()
    :build()

local unit1 = evolved.builder()
    :set(team, 'red')
    :build()

local unit2 = evolved.builder()
    :set(team, 'red')
    :build()

local unit3 = evolved.builder()
    :set(team, 'red')
    :build()

evolved.destroy(unit1)

local red_list, red_count = evolved.multi_search(team, 'red')
assert(red_count == 2 and red_list[1] == unit2 and red_list[2] == unit3)

evolved.set(unit2, team, 'blue')
evolved.set(unit2, team, 'red')

red_list, red_count = evolved.multi_search(team, 'red')
assert(red_count == 2 and red_list[1] == unit3 and red_list[2] == unit2)
```

所有会改变被索引片段组件的操作都会自动更新索引，包括生成、克隆和设置。该特征可以随时添加或移除。当它被添加到一个已被某些实体使用的片段时，索引会按这些实体在 chunk 中的存储顺序从它们构建。[`evolved.NAME`](#evolvedname) 和 [`evolved.GROUP`](#evolvedgroup) 片段也被索引，因此你可以按名称搜索实体、按组搜索系统，并且组内[系统](#systems)的顺序会保持不变。

遍历过程中直接在 chunk 存储中修改的组件会绕过索引，因此在这类修改之后，你应该使用 [`evolved.reindex`](#evolvedreindex) 函数手动更新索引。它只更新组件已发生变化的实体，因此比重建整个索引便宜得多。

```lua
local evolved = require 'evolved'

local team = evolved.builder()
    :index()
    :build()

local unit = evolved.builder()
    :set(team, 'red')
    :build()

local all_units = evolved.builder()
    :include(team)
    :build()

for chunk, entity_list, entity_count in evolved.execute(all_units) do
    local teams = chunk:components(team)
    for i = 1, entity_count do
        teams[i] = 'blue'
    end
end

evolved.reindex(team)
assert(evolved.search(team, 'blue') == unit)
```

> [!NOTE]
> 用没有 [`evolved.INDEX`](#evolvedindex) 特征的片段进行搜索会报错。

> [!NOTE]
> 组件被用作索引中的键，因此表组件按引用建立索引，用另一个内容相同的表去搜索不会找到任何东西。此外，[片段标签](#fragment-tags)和 `NaN` 组件完全不会被索引。

> [!NOTE]
> 索引不是没有代价的。每个被索引的实体都会占用一些额外内存，而所有会改变被索引组件的操作，例如生成、克隆、设置、移除或销毁，都会变慢，因为它们还必须更新索引。因此只标记你确实要用来搜索的片段。

<a id="unique-fragments"></a>
#### 唯一片段

有些片段在克隆实体时不应该被克隆。例如，`evolved.lua` 有一个名为 `evolved.PREFAB` 的特殊片段，用来标记作为克隆来源的实体。这个片段不应该出现在被克隆的实体上。要防止片段被克隆，请使用 [`evolved.UNIQUE`](#evolvedunique) 片段特征把它标记为唯一。这能确保克隆实体时该片段不会被复制。

```lua
local evolved = require 'evolved'

local health, stamina = evolved.id(2)

local enemy_prefab = evolved.builder()
    :prefab()
    :set(health, 100)
    :set(stamina, 50)
    :build()

local enemy_clone = evolved.clone(enemy_prefab)

-- the enemy_prefab has the evolved.PREFAB fragment
assert(evolved.has(enemy_prefab, evolved.PREFAB))

-- but the enemy_clone doesn't have it, because it is marked as unique
assert(not evolved.has(enemy_clone, evolved.PREFAB))
```

<a id="explicit-fragments"></a>
#### 显式片段

在某些情况下，你可能希望默认把带特定片段的 chunk 从查询中隐藏。例如，库有一个名为 [`evolved.DISABLED`](#evolveddisabled) 的特殊片段就是这种行为的。这个片段被标记了 [`evolved.EXPLICIT`](#evolvedexplicit) 片段特征，意味着除非你显式包含它，否则它会从查询中隐藏。这对于用于内部或编辑器用途、默认不应暴露给查询的片段很有用。

此外，[`evolved.PREFAB`](#evolvedprefab) 片段也被标记了 [`evolved.EXPLICIT`](#evolvedexplicit) 片段特征。这可以防止预制体在运行时被查询处理。预制体只用于克隆实体，因此默认不应被处理。

```lua
local evolved = require 'evolved'

local enemy_tag = evolved.builder()
    :tag()
    :build()

local only_enabled_enemies = evolved.builder()
    :include(enemy_tag)
    :build()

local all_enemies_including_disabled = evolved.builder()
    :include(enemy_tag)
    :include(evolved.DISABLED)
    :build()
```

<a id="internal-fragments"></a>
#### 内部片段

库提供的所有预定义片段都用 [`evolved.INTERNAL`](#evolvedinternal) 特征标记为内部片段。由于 [`evolved.INTERNAL`](#evolvedinternal) 自身被标记为 [`evolved.EXPLICIT`](#evolvedexplicit)，这些片段默认会从查询中隐藏。这可以防止用户代码意外使用内部片段，并有助于把它们与用户定义的片段区分开。

<a id="shared-components"></a>
#### 共享组件

我们常常希望把组件存成表，而默认情况下这些表会在实体之间共享。这意味着如果你在一个实体中修改该表，所有共享该表的实体中的它也会被修改。有时这正是我们想要的，例如我们想在实体之间共享配置或某些资源时。但在其他情况下，我们希望每个实体都拥有自己的表副本。例如，如果我们想把实体的位置存成表，就不希望与其他实体共享这个表。是的，我们可以手动复制表，但库为此提供了一点语法糖。

```lua
local evolved = require 'evolved'

local initial_position = { x = 0, y = 0 }

local position = evolved.id()

local enemy1 = evolved.builder()
    :set(position, initial_position)
    :build()

local enemy2 = evolved.builder()
    :set(position, initial_position)
    :build()

-- the enemy1 and enemy2 share the same table,
-- and that's definitely not what we want in this case
assert(evolved.get(enemy1, position) == evolved.get(enemy2, position))
```

为避免这种情况，`evolved.lua` 提供了一个名为 [`evolved.DUPLICATE`](#evolvedduplicate) 的片段特征。该特征需要一个函数，在设置此片段的组件时会被调用。该函数应返回一个新表，用作该实体的组件。这样，每个实体都会拥有自己的表副本，修改一个实体不会影响其他实体。

为了让这个例子更清楚，我们还会使用 [`evolved.DEFAULT`](#evolveddefault) 片段特征。该特征用于为组件指定默认值。当组件没有被显式设置时，就会使用该默认值。

```lua
local evolved = require 'evolved'

local function vector2(x, y)
    return { x = x, y = y }
end

local function vector2_duplicate(v)
    return { x = v.x, y = v.y }
end

local position = evolved.builder()
    :default(vector2(0, 0))
    :duplicate(vector2_duplicate)
    :build()

local enemy1 = evolved.builder()
    :set(position)
    :build()

local enemy2 = evolved.builder()
    :set(position)
    :build()

-- the enemy1 and enemy2 have different tables now
assert(evolved.get(enemy1, position) ~= evolved.get(enemy2, position))
```

<a id="fragment-requirements"></a>
#### 片段依赖

有时你希望实体在获得某个特定片段时同时获得额外的片段。例如，你可能希望在给实体一个 `physical` 片段时，同时添加 `position` 和 `velocity` 片段。这可以用 [`evolved.REQUIRES`](#evolvedrequires) 片段特征来实现。该特征需要一个片段列表，当该片段被插入时，这些片段会被添加到实体上。

```lua
local evolved = require 'evolved'

local position = evolved.builder()
    :default(vector2(0, 0))
    :duplicate(vector2_duplicate)
    :build()

local velocity = evolved.builder()
    :default(vector2(0, 0))
    :duplicate(vector2_duplicate)
    :build()

local physical = evolved.builder()
    :tag()
    :require(position, velocity)
    :build()

local enemy = evolved.builder()
    :set(physical)
    :build()

assert(evolved.has_all(enemy, position, velocity))
```

<a id="destruction-policies"></a>
#### 销毁策略

通常，片段在整个程序生命周期内都保持存活。然而在某些情况下，你可能希望在片段不再需要时销毁它们。例如，你可以把一些运行时实体用作其他实体的片段。在这种情况下，你可能希望即使这些片段仍附着在其他实体上也要销毁它们。由于实体不能拥有已销毁的片段，必须应用一种销毁策略来解决这个问题。默认情况下，库会从所有拥有该片段的实体中移除被销毁的片段。

```lua
local evolved = require 'evolved'

local world = evolved.builder()
    :tag()
    :build()

local entity = evolved.builder()
    :set(world)
    :build()

-- destroy the world fragment that is attached to the entity
evolved.destroy(world)

-- the entity is still alive, but it no longer has the world fragment
assert(evolved.alive(entity) and not evolved.has(entity, world))
```

默认行为在大多数情况下都工作良好，但你可以使用 [`evolved.DESTRUCTION_POLICY`](#evolveddestruction_policy) 片段特征来改变它。该特征需要以下预定义标识符之一：

- [`evolved.DESTRUCTION_POLICY_DESTROY_ENTITY`](#evolveddestruction_policy_destroy_entity) 会销毁任何拥有被销毁片段的实体。这对于类似上面的情况很有用：当它们的世界被销毁时，你想销毁所有实体。

- [`evolved.DESTRUCTION_POLICY_REMOVE_FRAGMENT`](#evolveddestruction_policy_remove_fragment) 会从所有拥有该片段的实体中移除被销毁的片段。这是默认行为，因此你不必显式设置它，但如果愿意也可以设置。

```lua
local evolved = require 'evolved'

local world = evolved.builder()
    :tag()
    :destruction_policy(evolved.DESTRUCTION_POLICY_DESTROY_ENTITY)
    :build()

local entity = evolved.builder()
    :set(world)
    :build()

-- destroy the world fragment that is attached to the entity
evolved.destroy(world)

-- the entity is destroyed together with the world fragment now
assert(not evolved.alive(entity))
```

<a id="custom-component-storages"></a>
#### 自定义组件存储

在某些情况下，你可能希望为片段组件使用自定义存储。例如，出于性能原因，你可能想用专门的方式存储组件。库为此提供了两个片段特征：[`evolved.REALLOC`](#evolvedrealloc) 和 [`evolved.COMPMOVE`](#evolvedcompmove)。

[`evolved.REALLOC`](#evolvedrealloc) 特征需要一个函数，在片段存储需要重新分配时调用。[`evolved.COMPMOVE`](#evolvedcompmove) 特征需要一个函数，在组件需要从一个存储移动到另一个存储时调用。

使用自定义存储的典型示例是实现一个把组件存进由 FFI 支持的存储的片段，以便在 LuaJIT 中获得更好的处理性能。这是一个进阶话题，需要对 LuaJIT FFI 和内存管理有较好的理解。因此我不在这里详细展开，但下面有一个简单的例子，让你了解它是如何工作的。更多信息可以在 [LuaJIT](https://luajit.org/ext_ffi.html) 网站上找到。

```lua
local ffi = require 'ffi'
local evolved = require 'evolved'

--
--
-- Define FFI double storage realloc and compmove functions
--
--

local FFI_DOUBLE_TYPEOF = ffi.typeof('double')
local FFI_DOUBLE_SIZEOF = ffi.sizeof(FFI_DOUBLE_TYPEOF)
local FFI_DOUBLE_STORAGE_TYPEOF = ffi.typeof('double[?]')

---@param src ffi.cdata*?
---@param src_size integer
---@param dst_size integer
---@return ffi.cdata*?
local function FFI_DOUBLE_STORAGE_REALLOC(src, src_size, dst_size)
    if dst_size == 0 then
        -- freeing the src storage, just let the GC handle it
        return
    end

    -- to support 1-based indexing, allocate one extra element
    local dst = ffi.new(FFI_DOUBLE_STORAGE_TYPEOF, dst_size + 1)

    if src and src_size > 0 then
        -- handle both expanding and shrinking
        local min_size = math.min(src_size, dst_size)
        ffi.copy(dst + 1, src + 1, min_size * FFI_DOUBLE_SIZEOF)
    end

    return dst
end

---@param src ffi.cdata*
---@param f integer
---@param e integer
---@param t integer
---@param dst ffi.cdata*
local function FFI_DOUBLE_STORAGE_COMPMOVE(src, f, e, t, dst)
    ffi.copy(dst + t, src + f, (e - f + 1) * FFI_DOUBLE_SIZEOF)
end

--
--
-- Define fragments with our custom FFI storages
--
--

local POSITION_X = evolved.builder()
    :default(0)
    :realloc(FFI_DOUBLE_STORAGE_REALLOC)
    :compmove(FFI_DOUBLE_STORAGE_COMPMOVE)
    :build()

local POSITION_Y = evolved.builder()
    :default(0)
    :realloc(FFI_DOUBLE_STORAGE_REALLOC)
    :compmove(FFI_DOUBLE_STORAGE_COMPMOVE)
    :build()

local VELOCITY_X = evolved.builder()
    :default(0)
    :realloc(FFI_DOUBLE_STORAGE_REALLOC)
    :compmove(FFI_DOUBLE_STORAGE_COMPMOVE)
    :build()

local VELOCITY_Y = evolved.builder()
    :default(0)
    :realloc(FFI_DOUBLE_STORAGE_REALLOC)
    :compmove(FFI_DOUBLE_STORAGE_COMPMOVE)
    :build()

--
--
-- Define a movement system that uses these components
--
--

local MOVEMENT_SYSTEM = evolved.builder()
    :include(POSITION_X, POSITION_Y)
    :include(VELOCITY_X, VELOCITY_Y)
    :execute(function(chunk, entity_list, entity_count, delta_time)
        local position_xs, position_ys = chunk:components(POSITION_X, POSITION_Y)
        local velocity_xs, velocity_ys = chunk:components(VELOCITY_X, VELOCITY_Y)

        for i = 1, entity_count do
            local px, py = position_xs[i], position_ys[i]
            local vx, vy = velocity_xs[i], velocity_ys[i]

            px = px + vx * delta_time
            py = py + vy * delta_time

            position_xs[i], position_ys[i] = px, py
        end
    end):build()

--
--
-- Spawn some entities with these components
--
--

evolved.builder()
    :set(POSITION_X)
    :set(POSITION_Y)
    :set(VELOCITY_X)
    :set(VELOCITY_Y)
    :multi_spawn(10000, function(chunk, b_place, e_place)
        local position_xs, position_ys = chunk:components(POSITION_X, POSITION_Y)
        local velocity_xs, velocity_ys = chunk:components(VELOCITY_X, VELOCITY_Y)

        for place = b_place, e_place do
            position_xs[place] = math.random(0, 640)
            position_ys[place] = math.random(0, 480)
            velocity_xs[place] = math.random(-100, 100)
            velocity_ys[place] = math.random(-100, 100)
        end
    end)

--
--
-- Process the movement system with a delta time payload
--
--

evolved.process_with(MOVEMENT_SYSTEM, 0.016)
```

<a id="error-handling"></a>
### 错误处理

由于系统在延迟作用域中执行处理，处理期间发生的任何错误都可能让库处于不一致的状态。为此，库会对每个系统执行受保护的调用并捕获发生的任何错误。默认情况下，库会收集错误信息和当前堆栈回溯，并带上这些信息重新抛出错误。捕获错误是安全的，但配合调试器使用时可能不方便，因为调试器通常会在重新抛出的位置断下，而不是错误实际发生的位置。为了更便于调试系统中的错误，库提供了一种设置自定义错误处理器的方法，当系统处理过程中发生错误时它会被调用。例如，你可以设置一个会中断到调试器的错误处理器：

```lua
-- we use Local Lua Debugger in this example
local debugger = require 'lldebugger'
debugger.start()

local evolved = require 'evolved'
evolved.error_handler(function(message)
    debugger.requestBreak()
    return debug.traceback(message)
end)
```

这样一来，当系统处理过程中发生错误时，错误处理器会被调用，它会中断到调试器中，让你能够检查错误发生那一刻程序的状态。当你在调试器中继续执行后，错误会带着原始的错误信息和堆栈回溯被重新抛出。

<a id="garbage-collection"></a>
### 垃圾回收

在使用库的过程中，一些内部数据结构可能变得过时，应该被清理以释放内存。例如，不再包含实体的空 chunk 可以被移除。组件存储也可能有未使用的容量，可以收缩以节省内存。库提供了一个函数来控制这个垃圾回收过程。

```lua
---@param no_shrink? boolean
function evolved.collect_garbage(no_shrink) end
```

默认情况下，[`evolved.collect_garbage`](#evolvedcollect_garbage) 会清理过时的数据结构，并把组件存储收缩到适合当前大小。如果传入 `true`，它只清理过时的数据结构，跳过收缩。这可以避免调整存储大小带来的开销，因为那可能很昂贵。

定期调用此函数以控制内存占用。最好在关卡之间或加载界面、性能不关键的时候调用它。此外，之后调用 Lua 内置的垃圾回收器，确保所有未使用的内存都被释放。

```lua
evolved.collect_garbage()
collectgarbage('collect')
```

<a id="cheat-sheet"></a>
## 速查表

<a id="aliases"></a>
### 别名

```
id :: implementation-specific

entity :: id
fragment :: id
query :: id
system :: id

component :: any
storage :: component[]

component_table :: <fragment, component>
component_mapper :: {chunk, integer, integer}

default :: component
duplicate :: {component -> component}

realloc :: {storage?, integer, integer -> storage?}
compmove :: {storage, integer, integer, integer, storage}

execute :: {chunk, entity[], integer, any...}
prologue :: {any...}
epilogue :: {any...}

set_hook :: {entity, fragment, component, component}
assign_hook :: {entity, fragment, component, component}
insert_hook :: {entity, fragment, component}
remove_hook :: {entity, fragment, component}

each_state :: implementation-specific
execute_state :: implementation-specific

each_iterator :: {each_state? -> fragment?, component?}
execute_iterator :: {execute_state? -> chunk?, entity[]?, integer?}
```

<a id="predefs"></a>
### 预定义

```
TAG :: fragment
NAME :: fragment

INDEX :: fragment
UNIQUE :: fragment
EXPLICIT :: fragment
INTERNAL :: fragment

DEFAULT :: fragment
DUPLICATE :: fragment

REALLOC :: fragment
COMPMOVE :: fragment

PREFAB :: fragment
DISABLED :: fragment

INCLUDES :: fragment
EXCLUDES :: fragment
VARIANTS :: fragment
REQUIRES :: fragment

ON_SET :: fragment
ON_ASSIGN :: fragment
ON_INSERT :: fragment
ON_REMOVE :: fragment

GROUP :: fragment

QUERY :: fragment
EXECUTE :: fragment

PROLOGUE :: fragment
EPILOGUE :: fragment

DESTRUCTION_POLICY :: fragment
DESTRUCTION_POLICY_DESTROY_ENTITY :: id
DESTRUCTION_POLICY_REMOVE_FRAGMENT :: id
```

<a id="functions"></a>
### 函数

```
id :: integer? -> id...
name :: id... -> string...

pack :: integer, integer -> id
unpack :: id -> integer, integer

defer :: boolean
depth :: integer
commit :: boolean
cancel :: boolean

spawn :: component_table?, component_mapper? -> entity
multi_spawn :: integer, component_table?, component_mapper? -> entity[], integer
multi_spawn_nr :: integer, component_table?, component_mapper? -> ()
multi_spawn_to :: entity[], integer, integer, component_table?, component_mapper? -> ()

clone :: entity, component_table?, component_mapper? -> entity
multi_clone :: integer, entity, component_table?, component_mapper? -> entity[], integer
multi_clone_nr :: integer, entity, component_table?, component_mapper? -> ()
multi_clone_to :: entity[], integer, integer, entity, component_table?, component_mapper? -> ()

alive :: entity -> boolean
alive_all :: entity... -> boolean
alive_any :: entity... -> boolean

empty :: entity -> boolean
empty_all :: entity... -> boolean
empty_any :: entity... -> boolean

has :: entity, fragment -> boolean
has_all :: entity, fragment... -> boolean
has_any :: entity, fragment... -> boolean

get :: entity, fragment... -> component...

set :: entity, fragment, component -> ()
remove :: entity, fragment... -> ()
clear :: entity... -> ()
destroy :: entity... -> ()

batch_set :: query, fragment, component -> ()
batch_remove :: query, fragment... -> ()
batch_clear :: query... -> ()
batch_destroy :: query... -> ()

each :: entity -> {each_state? -> fragment?, component?}, each_state?
execute :: query -> {execute_state? -> chunk?, entity[]?, integer?}, execute_state?

locate :: entity -> chunk?, integer

lookup :: string -> entity?
multi_lookup :: string -> entity[], integer
multi_lookup_to :: entity[], integer, string -> integer

search :: fragment, component -> entity?
multi_search :: fragment, component -> entity[], integer
multi_search_to :: entity[], integer, fragment, component -> integer

reindex :: fragment... -> ()

process :: system... -> ()
process_with :: system, ... -> ()

debug_mode :: boolean -> ()
error_handler :: {string -> string}? -> ()
collect_garbage :: boolean? -> ()
```

<a id="classes"></a>
### 类

<a id="chunk"></a>
#### Chunk

```
chunk :: fragment, fragment... -> chunk, entity[], integer

chunk_mt:alive :: boolean
chunk_mt:empty :: boolean

chunk_mt:has :: fragment -> boolean
chunk_mt:has_all :: fragment... -> boolean
chunk_mt:has_any :: fragment... -> boolean

chunk_mt:entities :: entity[], integer
chunk_mt:fragments :: fragment[], integer
chunk_mt:components :: fragment... -> storage...
```

<a id="builder"></a>
#### Builder

```
builder :: builder

builder_mt:build :: entity?, component_mapper? -> entity
builder_mt:multi_build :: integer, entity?, component_mapper? -> entity[], integer
builder_mt:multi_build_nr :: integer, entity?, component_mapper? -> ()
builder_mt:multi_build_to :: entity[], integer, integer, entity?, component_mapper? -> ()

builder_mt:spawn :: component_mapper? -> entity
builder_mt:multi_spawn :: integer, component_mapper? -> entity[], integer
builder_mt:multi_spawn_nr :: integer, component_mapper? -> ()
builder_mt:multi_spawn_to :: entity[], integer, integer, component_mapper? -> ()

builder_mt:clone :: entity, component_mapper? -> entity
builder_mt:multi_clone :: integer, entity, component_mapper? -> entity[], integer
builder_mt:multi_clone_nr :: integer, entity, component_mapper? -> ()
builder_mt:multi_clone_to :: entity[], integer, integer, entity, component_mapper? -> ()

builder_mt:has :: fragment -> boolean
builder_mt:has_all :: fragment... -> boolean
builder_mt:has_any :: fragment... -> boolean

builder_mt:get :: fragment... -> component...

builder_mt:set :: fragment, component -> builder
builder_mt:remove :: fragment... -> builder
builder_mt:clear :: builder

builder_mt:tag :: builder
builder_mt:name :: string -> builder

builder_mt:index :: builder
builder_mt:unique :: builder
builder_mt:explicit :: builder
builder_mt:internal :: builder

builder_mt:default :: component -> builder
builder_mt:duplicate :: {component -> component} -> builder

builder_mt:realloc :: {storage?, integer, integer -> storage?} -> builder
builder_mt:compmove :: {storage, integer, integer, integer, storage} -> builder

builder_mt:prefab :: builder
builder_mt:disabled :: builder

builder_mt:include :: fragment... -> builder
builder_mt:exclude :: fragment... -> builder
builder_mt:variant :: fragment... -> builder
builder_mt:require :: fragment... -> builder

builder_mt:on_set :: {entity, fragment, component, component} -> builder
builder_mt:on_assign :: {entity, fragment, component, component} -> builder
builder_mt:on_insert :: {entity, fragment, component} -> builder
builder_mt:on_remove :: {entity, fragment, component} -> builder

builder_mt:group :: system -> builder

builder_mt:query :: query -> builder
builder_mt:execute :: {chunk, entity[], integer, any...} -> builder

builder_mt:prologue :: {any...} -> builder
builder_mt:epilogue :: {any...} -> builder

builder_mt:destruction_policy :: id -> builder
```

<a id="changelog"></a>
## 更新日志

<a id="v1120"></a>
### v1.12.0

- 查找现在可以通过名称找到内部片段：[#52](https://github.com/BlackMATov/evolved.lua/issues/52)
- 所有内部名称现在都带有双下划线前缀
- 新增 [`evolved.INDEX`](#evolvedindex) 片段特征及 [`evolved.(multi_)search(_to)`](#evolvedsearch) 和 [`evolved.reindex`](#evolvedreindex) 函数，可以按组件的值查找实体

<a id="v1111"></a>
### v1.11.1

- 小幅修正了注解

<a id="v1110"></a>
### v1.11.0

- 略微提升了带 [`ON_INSERT`](#evolvedon_insert) 与 [`ON_REMOVE`](#evolvedon_remove) 钩子的片段的修改操作性能
- 略微提升了带 [`EXPLICIT`](#evolvedexplicit) 片段的查询性能
- 新增 [`evolved.error_handler`](#evolvederror_handler) 函数，可以设置自定义错误处理器，改善系统处理的调试体验

<a id="v1100"></a>
### v1.10.0

- 新增 [`evolved.lookup`](#evolvedlookup) 和 [`evolved.multi_lookup`](#evolvedmulti_lookup) 函数，可以按名称查找标识符
- 新增 [`evolved.collect_garbage`](#evolvedcollect_garbage) 的非收缩版本，只回收垃圾而不收缩存储
- 新增 [`_nr`](#evolvedmulti_spawn_nr) 与 [`_to`](#evolvedmulti_spawn_to) 变体，用于 [`evolved.multi_spawn`](#evolvedmulti_spawn) 和 [`evolved.multi_clone`](#evolvedmulti_clone) 函数，在某些情况下提供更高效的实体生成或克隆方式

<a id="v190"></a>
### v1.9.0

- 提升了 [`evolved.destroy`](#evolveddestroy) 和 [`evolved.batch_destroy`](#evolvedbatch_destroy) 函数的性能
- 确保 chunk 顺序确定，以提升多次运行之间处理的一致性

<a id="v180"></a>
### v1.8.0

- 新增 [`evolved.REALLOC`](#evolvedrealloc) 和 [`evolved.COMPMOVE`](#evolvedcompmove) 片段特征，可以自定义组件存储
- 为生成和克隆函数新增 `component_mapper` 参数，可以在操作过程中填充 chunk 中的组件

<a id="v170"></a>
### v1.7.0

- 新增 [`evolved.VARIANTS`](#evolvedvariants) 查询片段，可以在查询中指定多个片段中的任意一个
- 新增 [`evolved.process_with`](#evolvedprocess_with) 函数，可以向处理系统传入载荷

<a id="v160"></a>
### v1.6.0

- 显著提升了 [`evolved.REQUIRES`](#evolvedrequires) 片段特征的性能
- 新增 [`evolved.depth`](#evolveddepth) 函数，返回当前延迟作用域的深度

<a id="v150"></a>
### v1.5.0

- 新增一个小型 [LÖVE](https://love2d.org) 示例
- 带默认值的生成与克隆操作得到显著优化
- 新增基础的 [Teal](https://github.com/teal-language) 类型定义，感谢 [@p0sel0k](https://github.com/p0sel0k)

<a id="v140"></a>
### v1.4.0

- 通过缓存部分内部计算提升了查询执行性能
- 新增通用的 [`builder.build`](#evolvedbuilder_mtbuild) 和 [`builder.multi_build`](#evolvedbuilder_mtmulti_build) 方法，可以根据方法参数生成或克隆实体
- [`evolved.ON_REMOVE`](#evolvedon_remove) 钩子现在会在片段实际从实体移除之前调用

<a id="v130"></a>
### v1.3.0

- 新增 [`evolved.cancel`](#evolvedcancel) 函数
- 新增 [`evolved.locate`](#evolvedlocate) 函数
- 内部垃圾回收器现在会回收更多垃圾
- 出错时提供堆栈跟踪，改善系统处理的调试体验
- 覆写操作中，标签不再触发 [`SET/ASSIGN hooks`](#fragment-hooks)
- 提升了克隆含大量 [`Unique Fragments`](#unique-fragments) 的预制体时的性能
- 提升了被多次用于生成实体的构建器的性能

<a id="v120"></a>
### v1.2.0

- 新增 [`evolved.name`](#evolvedname-1) 函数
- 新增 [`evolved.multi_spawn`](#evolvedmulti_spawn) 和 [`evolved.multi_clone`](#evolvedmulti_clone) 函数
- 新增 [`evolved.INTERNAL`](#evolvedinternal) 片段特征

<a id="v110"></a>
### v1.1.0

- [`Systems`](#systems) 现在自身也可以是查询
- 新增 [`evolved.REQUIRES`](#evolvedrequires) 片段特征

<a id="v100"></a>
### v1.0.0

- 首次发布

<a id="license"></a>
## 许可证

`evolved.lua` 以 [MIT 许可证][license] 授权。更多细节请见仓库中的 [LICENSE.md](./LICENSE.md) 文件。

<a id="api-reference"></a>
# API 参考

<a id="predefs-1"></a>
## 预定义

<a id="evolvedtag"></a>
### `evolved.TAG`

<a id="evolvedname"></a>
### `evolved.NAME`

<a id="evolvedindex"></a>
### `evolved.INDEX`

<a id="evolvedunique"></a>
### `evolved.UNIQUE`

<a id="evolvedexplicit"></a>
### `evolved.EXPLICIT`

<a id="evolvedinternal"></a>
### `evolved.INTERNAL`

<a id="evolveddefault"></a>
### `evolved.DEFAULT`

<a id="evolvedduplicate"></a>
### `evolved.DUPLICATE`

<a id="evolvedrealloc"></a>
### `evolved.REALLOC`

<a id="evolvedcompmove"></a>
### `evolved.COMPMOVE`

<a id="evolvedprefab"></a>
### `evolved.PREFAB`

<a id="evolveddisabled"></a>
### `evolved.DISABLED`

<a id="evolvedincludes"></a>
### `evolved.INCLUDES`

<a id="evolvedexcludes"></a>
### `evolved.EXCLUDES`

<a id="evolvedvariants"></a>
### `evolved.VARIANTS`

<a id="evolvedrequires"></a>
### `evolved.REQUIRES`

<a id="evolvedon_set"></a>
### `evolved.ON_SET`

<a id="evolvedon_assign"></a>
### `evolved.ON_ASSIGN`

<a id="evolvedon_insert"></a>
### `evolved.ON_INSERT`

<a id="evolvedon_remove"></a>
### `evolved.ON_REMOVE`

<a id="evolvedgroup"></a>
### `evolved.GROUP`

<a id="evolvedquery"></a>
### `evolved.QUERY`

<a id="evolvedexecute"></a>
### `evolved.EXECUTE`

<a id="evolvedprologue"></a>
### `evolved.PROLOGUE`

<a id="evolvedepilogue"></a>
### `evolved.EPILOGUE`

<a id="evolveddestruction_policy"></a>
### `evolved.DESTRUCTION_POLICY`

<a id="evolveddestruction_policy_destroy_entity"></a>
### `evolved.DESTRUCTION_POLICY_DESTROY_ENTITY`

<a id="evolveddestruction_policy_remove_fragment"></a>
### `evolved.DESTRUCTION_POLICY_REMOVE_FRAGMENT`

<a id="functions-1"></a>
## 函数

<a id="evolvedid"></a>
### `evolved.id`

```lua
---@param count? integer
---@return evolved.id ... ids
---@nodiscard
function evolved.id(count) end
```

<a id="evolvedname-1"></a>
### `evolved.name`

```lua
---@param ... evolved.id ids
---@return string ... names
---@nodiscard
function evolved.name(...) end
```

<a id="evolvedpack"></a>
### `evolved.pack`

```lua
---@param primary integer
---@param secondary integer
---@return evolved.id id
---@nodiscard
function evolved.pack(primary, secondary) end
```

<a id="evolvedunpack"></a>
### `evolved.unpack`

```lua
---@param id evolved.id
---@return integer primary
---@return integer secondary
---@nodiscard
function evolved.unpack(id) end
```

<a id="evolveddefer"></a>
### `evolved.defer`

```lua
---@return boolean started
function evolved.defer() end
```

<a id="evolveddepth"></a>
### `evolved.depth`

```lua
---@return integer depth
---@nodiscard
function evolved.depth() end
```

<a id="evolvedcommit"></a>
### `evolved.commit`

```lua
---@return boolean committed
function evolved.commit() end
```

<a id="evolvedcancel"></a>
### `evolved.cancel`

```lua
---@return boolean cancelled
function evolved.cancel() end
```

<a id="evolvedspawn"></a>
### `evolved.spawn`

```lua
---@param component_table? evolved.component_table
---@param component_mapper? evolved.component_mapper
---@return evolved.entity entity
function evolved.spawn(component_table, component_mapper) end
```

<a id="evolvedmulti_spawn"></a>
### `evolved.multi_spawn`

```lua
---@param entity_count integer
---@param component_table? evolved.component_table
---@param component_mapper? evolved.component_mapper
---@return evolved.entity[] entity_list
---@return integer entity_count
---@nodiscard
function evolved.multi_spawn(entity_count, component_table, component_mapper) end
```

<a id="evolvedmulti_spawn_nr"></a>
### `evolved.multi_spawn_nr`

```lua
---@param entity_count integer
---@param component_table? evolved.component_table
---@param component_mapper? evolved.component_mapper
function evolved.multi_spawn_nr(entity_count, component_table, component_mapper) end
```

<a id="evolvedmulti_spawn_to"></a>
### `evolved.multi_spawn_to`

```lua
---@param out_entity_list evolved.entity[]
---@param out_entity_first integer
---@param entity_count integer
---@param component_table? evolved.component_table
---@param component_mapper? evolved.component_mapper
function evolved.multi_spawn_to(out_entity_list, out_entity_first,
                                entity_count, component_table, component_mapper) end
```

<a id="evolvedclone"></a>
### `evolved.clone`

```lua
---@param prefab evolved.entity
---@param component_table? evolved.component_table
---@param component_mapper? evolved.component_mapper
---@return evolved.entity entity
function evolved.clone(prefab, component_table, component_mapper) end
```

<a id="evolvedmulti_clone"></a>
### `evolved.multi_clone`

```lua
---@param entity_count integer
---@param prefab evolved.entity
---@param component_table? evolved.component_table
---@param component_mapper? evolved.component_mapper
---@return evolved.entity[] entity_list
---@return integer entity_count
---@nodiscard
function evolved.multi_clone(entity_count, prefab, component_table, component_mapper) end
```

<a id="evolvedmulti_clone_nr"></a>
### `evolved.multi_clone_nr`

```lua
---@param entity_count integer
---@param prefab evolved.entity
---@param component_table? evolved.component_table
---@param component_mapper? evolved.component_mapper
function evolved.multi_clone_nr(entity_count, prefab, component_table, component_mapper) end
```

<a id="evolvedmulti_clone_to"></a>
### `evolved.multi_clone_to`

```lua
---@param out_entity_list evolved.entity[]
---@param out_entity_first integer
---@param entity_count integer
---@param prefab evolved.entity
---@param component_table? evolved.component_table
---@param component_mapper? evolved.component_mapper
function evolved.multi_clone_to(out_entity_list, out_entity_first,
                                entity_count, prefab, component_table, component_mapper) end
```

<a id="evolvedalive"></a>
### `evolved.alive`

```lua
---@param entity evolved.entity
---@return boolean
---@nodiscard
function evolved.alive(entity) end
```

<a id="evolvedalive_all"></a>
### `evolved.alive_all`

```lua
---@param ... evolved.entity entities
---@return boolean
---@nodiscard
function evolved.alive_all(...) end
```

<a id="evolvedalive_any"></a>
### `evolved.alive_any`

```lua
---@param ... evolved.entity entities
---@return boolean
---@nodiscard
function evolved.alive_any(...) end
```

<a id="evolvedempty"></a>
### `evolved.empty`

```lua
---@param entity evolved.entity
---@return boolean
---@nodiscard
function evolved.empty(entity) end
```

<a id="evolvedempty_all"></a>
### `evolved.empty_all`

```lua
---@param ... evolved.entity entities
---@return boolean
---@nodiscard
function evolved.empty_all(...) end
```

<a id="evolvedempty_any"></a>
### `evolved.empty_any`

```lua
---@param ... evolved.entity entities
---@return boolean
---@nodiscard
function evolved.empty_any(...) end
```

<a id="evolvedhas"></a>
### `evolved.has`

```lua
---@param entity evolved.entity
---@param fragment evolved.fragment
---@return boolean
---@nodiscard
function evolved.has(entity, fragment) end
```

<a id="evolvedhas_all"></a>
### `evolved.has_all`

```lua
---@param entity evolved.entity
---@param ... evolved.fragment fragments
---@return boolean
---@nodiscard
function evolved.has_all(entity, ...) end
```

<a id="evolvedhas_any"></a>
### `evolved.has_any`

```lua
---@param entity evolved.entity
---@param ... evolved.fragment fragments
---@return boolean
---@nodiscard
function evolved.has_any(entity, ...) end
```

<a id="evolvedget"></a>
### `evolved.get`

```lua
---@param entity evolved.entity
---@param ... evolved.fragment fragments
---@return evolved.component ... components
---@nodiscard
function evolved.get(entity, ...) end
```

<a id="evolvedset"></a>
### `evolved.set`

```lua
---@param entity evolved.entity
---@param fragment evolved.fragment
---@param component evolved.component
function evolved.set(entity, fragment, component) end
```

<a id="evolvedremove"></a>
### `evolved.remove`

```lua
---@param entity evolved.entity
---@param ... evolved.fragment fragments
function evolved.remove(entity, ...) end
```

<a id="evolvedclear"></a>
### `evolved.clear`

```lua
---@param ... evolved.entity entities
function evolved.clear(...) end
```

<a id="evolveddestroy"></a>
### `evolved.destroy`

```lua
---@param ... evolved.entity entities
function evolved.destroy(...) end
```

<a id="evolvedbatch_set"></a>
### `evolved.batch_set`

```lua
---@param query evolved.query
---@param fragment evolved.fragment
---@param component evolved.component
function evolved.batch_set(query, fragment, component) end
```

<a id="evolvedbatch_remove"></a>
### `evolved.batch_remove`

```lua
---@param query evolved.query
---@param ... evolved.fragment fragments
function evolved.batch_remove(query, ...) end
```

<a id="evolvedbatch_clear"></a>
### `evolved.batch_clear`

```lua
---@param ... evolved.query queries
function evolved.batch_clear(...) end
```

<a id="evolvedbatch_destroy"></a>
### `evolved.batch_destroy`

```lua
---@param ... evolved.query queries
function evolved.batch_destroy(...) end
```

<a id="evolvedeach"></a>
### `evolved.each`

```lua
---@param entity evolved.entity
---@return evolved.each_iterator iterator
---@return evolved.each_state? iterator_state
---@nodiscard
function evolved.each(entity) end
```

<a id="evolvedexecute-1"></a>
### `evolved.execute`

```lua
---@param query evolved.query
---@return evolved.execute_iterator iterator
---@return evolved.execute_state? iterator_state
---@nodiscard
function evolved.execute(query) end
```

<a id="evolvedlocate"></a>
### `evolved.locate`

```lua
---@param entity evolved.entity
---@return evolved.chunk? chunk
---@return integer place
---@nodiscard
function evolved.locate(entity) end
```

<a id="evolvedlookup"></a>
### `evolved.lookup`

```lua
---@param name string
---@return evolved.entity? entity
---@nodiscard
function evolved.lookup(name) end
```

<a id="evolvedmulti_lookup"></a>
### `evolved.multi_lookup`

```lua
---@param name string
---@return evolved.entity[] entity_list
---@return integer entity_count
---@nodiscard
function evolved.multi_lookup(name) end
```

<a id="evolvedmulti_lookup_to"></a>
### `evolved.multi_lookup_to`

```lua
---@param out_entity_list evolved.entity[]
---@param out_entity_first integer
---@param name string
---@return integer entity_count
function evolved.multi_lookup_to(out_entity_list, out_entity_first, name) end
```

<a id="evolvedsearch"></a>
### `evolved.search`

```lua
---@param fragment evolved.fragment
---@param component evolved.component
---@return evolved.entity? entity
---@nodiscard
function evolved.search(fragment, component) end
```

<a id="evolvedmulti_search"></a>
### `evolved.multi_search`

```lua
---@param fragment evolved.fragment
---@param component evolved.component
---@return evolved.entity[] entity_list
---@return integer entity_count
---@nodiscard
function evolved.multi_search(fragment, component) end
```

<a id="evolvedmulti_search_to"></a>
### `evolved.multi_search_to`

```lua
---@param out_entity_list evolved.entity[]
---@param out_entity_first integer
---@param fragment evolved.fragment
---@param component evolved.component
---@return integer entity_count
function evolved.multi_search_to(out_entity_list, out_entity_first, fragment, component) end
```

<a id="evolvedreindex"></a>
### `evolved.reindex`

```lua
---@param ... evolved.fragment fragments
function evolved.reindex(...) end
```

<a id="evolvedprocess"></a>
### `evolved.process`

```lua
---@param ... evolved.system systems
function evolved.process(...) end
```

<a id="evolvedprocess_with"></a>
### `evolved.process_with`

```lua
---@param system evolved.system
---@param ... any processing payload
function evolved.process_with(system, ...) end
```

<a id="evolveddebug_mode"></a>
### `evolved.debug_mode`

```lua
---@param yesno boolean
function evolved.debug_mode(yesno) end
```

<a id="evolvederror_handler"></a>
### `evolved.error_handler`

```lua
---@param handler? fun(message: string): string
function evolved.error_handler(handler) end
```

<a id="evolvedcollect_garbage"></a>
### `evolved.collect_garbage`

```lua
---@param no_shrink? boolean
function evolved.collect_garbage(no_shrink) end
```

<a id="classes-1"></a>
## 类

<a id="chunk-1"></a>
### Chunk

<a id="evolvedchunk"></a>
#### `evolved.chunk`

```lua
---@param fragment evolved.fragment
---@param ... evolved.fragment fragments
---@return evolved.chunk chunk
---@return evolved.entity[] entity_list
---@return integer entity_count
---@nodiscard
function evolved.chunk(fragment, ...) end
```

<a id="evolvedchunk_mtalive"></a>
#### `evolved.chunk_mt:alive`

```lua
---@return boolean
---@nodiscard
function evolved.chunk_mt:alive() end
```

<a id="evolvedchunk_mtempty"></a>
#### `evolved.chunk_mt:empty`

```lua
---@return boolean
---@nodiscard
function evolved.chunk_mt:empty() end
```

<a id="evolvedchunk_mthas"></a>
#### `evolved.chunk_mt:has`

```lua
---@param fragment evolved.fragment
---@return boolean
---@nodiscard
function evolved.chunk_mt:has(fragment) end
```

<a id="evolvedchunk_mthas_all"></a>
#### `evolved.chunk_mt:has_all`

```lua
---@param ... evolved.fragment fragments
---@return boolean
---@nodiscard
function evolved.chunk_mt:has_all(...) end
```

<a id="evolvedchunk_mthas_any"></a>
#### `evolved.chunk_mt:has_any`

```lua
---@param ... evolved.fragment fragments
---@return boolean
---@nodiscard
function evolved.chunk_mt:has_any(...) end
```

<a id="evolvedchunk_mtentities"></a>
#### `evolved.chunk_mt:entities`

```lua
---@return evolved.entity[] entity_list
---@return integer entity_count
---@nodiscard
function evolved.chunk_mt:entities() end
```

<a id="evolvedchunk_mtfragments"></a>
#### `evolved.chunk_mt:fragments`

```lua
---@return evolved.fragment[] fragment_list
---@return integer fragment_count
---@nodiscard
function evolved.chunk_mt:fragments() end
```

<a id="evolvedchunk_mtcomponents"></a>
#### `evolved.chunk_mt:components`

```lua
---@param ... evolved.fragment fragments
---@return evolved.storage ... storages
---@nodiscard
function evolved.chunk_mt:components(...) end
```

<a id="builder-1"></a>
### Builder

<a id="evolvedbuilder"></a>
#### `evolved.builder`

```lua
---@return evolved.builder builder
---@nodiscard
function evolved.builder() end
```

<a id="evolvedbuilder_mtbuild"></a>
#### `evolved.builder_mt:build`

```lua
---@param prefab? evolved.entity
---@param component_mapper? evolved.component_mapper
---@return evolved.entity entity
function evolved.builder_mt:build(prefab, component_mapper) end
```

<a id="evolvedbuilder_mtmulti_build"></a>
#### `evolved.builder_mt:multi_build`

```lua
---@param entity_count integer
---@param prefab? evolved.entity
---@param component_mapper? evolved.component_mapper
---@return evolved.entity[] entity_list
---@return integer entity_count
---@nodiscard
function evolved.builder_mt:multi_build(entity_count, prefab, component_mapper) end
```

<a id="evolvedbuilder_mtmulti_build_nr"></a>
#### `evolved.builder_mt:multi_build_nr`

```lua
---@param entity_count integer
---@param prefab? evolved.entity
---@param component_mapper? evolved.component_mapper
function evolved.builder_mt:multi_build_nr(entity_count, prefab, component_mapper) end
```

<a id="evolvedbuilder_mtmulti_build_to"></a>
#### `evolved.builder_mt:multi_build_to`

```lua
---@param out_entity_list evolved.entity[]
---@param out_entity_first integer
---@param entity_count integer
---@param prefab? evolved.entity
---@param component_mapper? evolved.component_mapper
function evolved.builder_mt:multi_build_to(out_entity_list, out_entity_first,
                                           entity_count, prefab, component_mapper) end
```

<a id="evolvedbuilder_mtspawn"></a>
#### `evolved.builder_mt:spawn`

```lua
---@param component_mapper? evolved.component_mapper
---@return evolved.entity entity
function evolved.builder_mt:spawn(component_mapper) end
```

<a id="evolvedbuilder_mtmulti_spawn"></a>
#### `evolved.builder_mt:multi_spawn`

```lua
---@param entity_count integer
---@param component_mapper? evolved.component_mapper
---@return evolved.entity[] entity_list
---@return integer entity_count
---@nodiscard
function evolved.builder_mt:multi_spawn(entity_count, component_mapper) end
```

<a id="evolvedbuilder_mtmulti_spawn_nr"></a>
#### `evolved.builder_mt:multi_spawn_nr`

```lua
---@param entity_count integer
---@param component_mapper? evolved.component_mapper
function evolved.builder_mt:multi_spawn_nr(entity_count, component_mapper) end
```

<a id="evolvedbuilder_mtmulti_spawn_to"></a>
#### `evolved.builder_mt:multi_spawn_to`

```lua
---@param out_entity_list evolved.entity[]
---@param out_entity_first integer
---@param entity_count integer
---@param component_mapper? evolved.component_mapper
function evolved.builder_mt:multi_spawn_to(out_entity_list, out_entity_first,
                                           entity_count, component_mapper) end
```

<a id="evolvedbuilder_mtclone"></a>
#### `evolved.builder_mt:clone`

```lua
---@param prefab evolved.entity
---@param component_mapper? evolved.component_mapper
---@return evolved.entity entity
function evolved.builder_mt:clone(prefab, component_mapper) end
```

<a id="evolvedbuilder_mtmulti_clone"></a>
#### `evolved.builder_mt:multi_clone`

```lua
---@param entity_count integer
---@param prefab evolved.entity
---@param component_mapper? evolved.component_mapper
---@return evolved.entity[] entity_list
---@return integer entity_count
---@nodiscard
function evolved.builder_mt:multi_clone(entity_count, prefab, component_mapper) end
```

<a id="evolvedbuilder_mtmulti_clone_nr"></a>
#### `evolved.builder_mt:multi_clone_nr`

```lua
---@param entity_count integer
---@param prefab evolved.entity
---@param component_mapper? evolved.component_mapper
function evolved.builder_mt:multi_clone_nr(entity_count, prefab, component_mapper) end
```

<a id="evolvedbuilder_mtmulti_clone_to"></a>
#### `evolved.builder_mt:multi_clone_to`

```lua
---@param out_entity_list evolved.entity[]
---@param out_entity_first integer
---@param entity_count integer
---@param prefab evolved.entity
---@param component_mapper? evolved.component_mapper
function evolved.builder_mt:multi_clone_to(out_entity_list, out_entity_first,
                                           entity_count, prefab, component_mapper) end
```

<a id="evolvedbuilder_mthas"></a>
#### `evolved.builder_mt:has`

```lua
---@param fragment evolved.fragment
---@return boolean
---@nodiscard
function evolved.builder_mt:has(fragment) end
```

<a id="evolvedbuilder_mthas_all"></a>
#### `evolved.builder_mt:has_all`

```lua
---@param ... evolved.fragment fragments
---@return boolean
---@nodiscard
function evolved.builder_mt:has_all(...) end
```

<a id="evolvedbuilder_mthas_any"></a>
#### `evolved.builder_mt:has_any`

```lua
---@param ... evolved.fragment fragments
---@return boolean
---@nodiscard
function evolved.builder_mt:has_any(...) end
```

<a id="evolvedbuilder_mtget"></a>
#### `evolved.builder_mt:get`

```lua
---@param ... evolved.fragment fragments
---@return evolved.component ... components
---@nodiscard
function evolved.builder_mt:get(...) end
```

<a id="evolvedbuilder_mtset"></a>
#### `evolved.builder_mt:set`

```lua
---@param fragment evolved.fragment
---@param component evolved.component
---@return evolved.builder builder
function evolved.builder_mt:set(fragment, component) end
```

<a id="evolvedbuilder_mtremove"></a>
#### `evolved.builder_mt:remove`

```lua
---@param ... evolved.fragment fragments
---@return evolved.builder builder
function evolved.builder_mt:remove(...) end
```

<a id="evolvedbuilder_mtclear"></a>
#### `evolved.builder_mt:clear`

```lua
---@return evolved.builder builder
function evolved.builder_mt:clear() end
```

<a id="evolvedbuilder_mttag"></a>
#### `evolved.builder_mt:tag`

```lua
---@return evolved.builder builder
function evolved.builder_mt:tag() end
```

<a id="evolvedbuilder_mtname"></a>
#### `evolved.builder_mt:name`

```lua
---@param name string
---@return evolved.builder builder
function evolved.builder_mt:name(name) end
```

<a id="evolvedbuilder_mtindex"></a>
#### `evolved.builder_mt:index`

```lua
---@return evolved.builder builder
function evolved.builder_mt:index() end
```

<a id="evolvedbuilder_mtunique"></a>
#### `evolved.builder_mt:unique`

```lua
---@return evolved.builder builder
function evolved.builder_mt:unique() end
```

<a id="evolvedbuilder_mtexplicit"></a>
#### `evolved.builder_mt:explicit`

```lua
---@return evolved.builder builder
function evolved.builder_mt:explicit() end
```

<a id="evolvedbuilder_mtinternal"></a>
#### `evolved.builder_mt:internal`

```lua
---@return evolved.builder builder
function evolved.builder_mt:internal() end
```

<a id="evolvedbuilder_mtdefault"></a>
#### `evolved.builder_mt:default`

```lua
---@param default evolved.default
---@return evolved.builder builder
function evolved.builder_mt:default(default) end
```

<a id="evolvedbuilder_mtduplicate"></a>
#### `evolved.builder_mt:duplicate`

```lua
---@param duplicate evolved.duplicate
---@return evolved.builder builder
function evolved.builder_mt:duplicate(duplicate) end
```

<a id="evolvedbuilder_mtrealloc"></a>
#### `evolved.builder_mt:realloc`

```lua
---@param realloc evolved.realloc
---@return evolved.builder builder
function evolved.builder_mt:realloc(realloc) end
```

<a id="evolvedbuilder_mtcompmove"></a>
#### `evolved.builder_mt:compmove`

```lua
---@param compmove evolved.compmove
---@return evolved.builder builder
function evolved.builder_mt:compmove(compmove) end
```

<a id="evolvedbuilder_mtprefab"></a>
#### `evolved.builder_mt:prefab`

```lua
---@return evolved.builder builder
function evolved.builder_mt:prefab() end
```

<a id="evolvedbuilder_mtdisabled"></a>
#### `evolved.builder_mt:disabled`

```lua
---@return evolved.builder builder
function evolved.builder_mt:disabled() end
```

<a id="evolvedbuilder_mtinclude"></a>
#### `evolved.builder_mt:include`

```lua
---@param ... evolved.fragment fragments
---@return evolved.builder builder
function evolved.builder_mt:include(...) end
```

<a id="evolvedbuilder_mtexclude"></a>
#### `evolved.builder_mt:exclude`

```lua
---@param ... evolved.fragment fragments
---@return evolved.builder builder
function evolved.builder_mt:exclude(...) end
```

<a id="evolvedbuilder_mtvariant"></a>
#### `evolved.builder_mt:variant`

```lua
---@param ... evolved.fragment fragments
---@return evolved.builder builder
function evolved.builder_mt:variant(...) end
```

<a id="evolvedbuilder_mtrequire"></a>
#### `evolved.builder_mt:require`

```lua
---@param ... evolved.fragment fragments
---@return evolved.builder builder
function evolved.builder_mt:require(...) end
```

<a id="evolvedbuilder_mton_set"></a>
#### `evolved.builder_mt:on_set`

```lua
---@param on_set evolved.set_hook
---@return evolved.builder builder
function evolved.builder_mt:on_set(on_set) end
```

<a id="evolvedbuilder_mton_assign"></a>
#### `evolved.builder_mt:on_assign`

```lua
---@param on_assign evolved.assign_hook
---@return evolved.builder builder
function evolved.builder_mt:on_assign(on_assign) end
```

<a id="evolvedbuilder_mton_insert"></a>
#### `evolved.builder_mt:on_insert`

```lua
---@param on_insert evolved.insert_hook
---@return evolved.builder builder
function evolved.builder_mt:on_insert(on_insert) end
```

<a id="evolvedbuilder_mton_remove"></a>
#### `evolved.builder_mt:on_remove`

```lua
---@param on_remove evolved.remove_hook
---@return evolved.builder builder
function evolved.builder_mt:on_remove(on_remove) end
```

<a id="evolvedbuilder_mtgroup"></a>
#### `evolved.builder_mt:group`

```lua
---@param group evolved.system
---@return evolved.builder builder
function evolved.builder_mt:group(group) end
```

<a id="evolvedbuilder_mtquery"></a>
#### `evolved.builder_mt:query`

```lua
---@param query evolved.query
---@return evolved.builder builder
function evolved.builder_mt:query(query) end
```

<a id="evolvedbuilder_mtexecute"></a>
#### `evolved.builder_mt:execute`

```lua
---@param execute evolved.execute
---@return evolved.builder builder
function evolved.builder_mt:execute(execute) end
```

<a id="evolvedbuilder_mtprologue"></a>
#### `evolved.builder_mt:prologue`

```lua
---@param prologue evolved.prologue
---@return evolved.builder builder
function evolved.builder_mt:prologue(prologue) end
```

<a id="evolvedbuilder_mtepilogue"></a>
#### `evolved.builder_mt:epilogue`

```lua
---@param epilogue evolved.epilogue
---@return evolved.builder builder
function evolved.builder_mt:epilogue(epilogue) end
```

<a id="evolvedbuilder_mtdestruction_policy"></a>
#### `evolved.builder_mt:destruction_policy`

```lua
---@param destruction_policy evolved.id
---@return evolved.builder builder
function evolved.builder_mt:destruction_policy(destruction_policy) end
```
