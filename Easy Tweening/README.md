# Easy Tweening Documentation

## Methods

### TweenModuleNew:CreateTween
#### Arguments
*- Object > Instance* <br/>
*- TweenInformation > TweenInfo* <br/>
*- Goals > { any }* <br/>

```lua
local Module = require(path.to.module)

local TweenModuleNew = Module:new("Tween1"):CreateTween(Object, TweenInformation, Goals)
```

*Returns > metatable { methods }*

### CreateTween:play
#### Arguments
*- DelayTime > Number* <br />

```lua
local Module = require(path.to.module)

local TweenModuleNew = Module:new("Tween1"):CreateTween(Object, TweenInformation, Goals)
  :play(3) -- Wait's 3 seconds before running the tween ( If NIL then will wait 0 seconds)
```

*Returns > metatable { methods }*

### CreateTween:begin
#### Arguments
*- DelayTime > Number* <br />

**WARNING: ALWAYS PUT BEFORE :play() IF YOU PLAN ON USING IT**
```lua
local Module = require(path.to.module)

local TweenModuleNew = Module:new("Tween1"):CreateTween(Object, TweenInformation, Goals)
  :begin(function(Playback)
    print("Tween Loaded")
  end):play(3) -- Wait's 3 seconds after tween started and then stops it ( If NIL then will wait 0 seconds)
```

*Returns > metatable { methods }*

### CreateTween:play
#### Arguments
*- DelayTime > Number* <br />

```lua
local Module = require(path.to.module)

local TweenModuleNew = Module:new("Tween1"):CreateTween(Object, TweenInformation, Goals)
  :play(3) -- Wait's 3 seconds before running the tween ( If NIL then will wait 0 seconds)
```

### play:started()
#### Arguments
*- Callback > Function* <br />
*- ... > Any* <br />

```lua
local Module = require(path.to.module)

local TweenModuleNew = Module:new("Tween1"):CreateTween(Object, TweenInformation, Goals)
  :play(3):started(function(Args)
    print(Args) -- Prints "Hello"
  end, "Hello") -- Invokes when tween was started via :Play()
```

*Returns > metatable { methods }*

### play:completed()
#### Arguments
*- Callback > Function* <br />
*- ... > Any* <br />

```lua
local Module = require(path.to.module)

local TweenModuleNew = Module:new("Tween1"):CreateTween(Object, TweenInformation, Goals)
  :play(3):completed(function(Playback, Arg1, Arg2)
    print(Playback, Arg1, Arg2) -- Prints "Enum.PlaybackState.Completed 5 Completed"
  end, 5, "Completed") -- Invokes when tween was completed
```

*Returns > metatable { methods }*

### play:paused()
#### Arguments
*- Callback > Function* <br />
*- ... > Any* <br />

```lua
local Module = require(path.to.module)

local TweenModuleNew = Module:new("Tween1"):CreateTween(Object, TweenInformation, Goals)
  :play(3):paused(function(Playback, Args)
    local ArgsO = ""
    for _, v in pairs(Args) do
      ArgsO ..= v .. " "
    end
    
    print(ArgsO) -- Prints Hello World !"
  end, {"Hello", "World", "!"}) -- Invokes when tween was paused via Tween:Pause()
```

*Returns > metatable { methods }*

### play:playing()
#### Arguments
*- Callback > Function* <br />
*- ... > Any* <br />

```lua
local Module = require(path.to.module)

local TweenModuleNew = Module:new("Tween1"):CreateTween(Object, TweenInformation, Goals)
  :play(3):playing(function(Playback)
    print("Is Playing")
  end) -- Keeps invoking while tween is playing
```

*Returns > metatable { methods }*

### play:delayed()
#### Arguments
*- Callback > Function* <br />
*- ... > Any* <br />

```lua
local Module = require(path.to.module)

local TweenModuleNew = Module:new("Tween1"):CreateTween(Object, TweenInformation, Goals)
  :play(3):delayed(fucntion(Playback, Arg1)
    print(Arg1) -- Prints "Delayed"
  end, "Delayed") -- Invokes while tween is delayed (when the last TweenInfo option is running and the tween hasn't started)
```

*Returns > metatable { methods }*

### play:cancelled()
#### Arguments
*- Callback > Function* <br />
*- ... > Any* <br />

```lua
local Module = require(path.to.module)

local TweenModuleNew = Module:new("Tween1"):CreateTween(Object, TweenInformation, Goals)
  :play(3):cancelled(function(Playback)
    print("Cancelled") -- Prints "Cancelled"
  end) -- Invoked when tween gets cancelled via :stop
```

*Returns > metatable { methods }*

### play:getTween()
#### Arguments
*- Callback > Function* <br />
*- ... > Any* <br />

```lua
local Module = require(path.to.module)

local TweenModuleNew = Module:new("Tween1")
local Tween = TweenModuleNew:CreateTween(Object, TweenInformation, Goals)
  :play(3):getTween() -- Returns the tween created from ":CreateTween"
  
print(Tween.Instance) -- Prints the Object you passed via :CreateTween
```

*Returns > Tween*

### Module.GetThreads

```lua
local Module = require(path.to.module)

local Threads = Module.GetThreads()

for Index, Data in pairs(Threads) do
  for DataIndex, Info in pairs(Data)
    print(DataIndex, Info)
  end
end
```

*Returns > Table { Table }*

### Module.GetThreadData
#### Arguments
*- ThreadName > String*

```lua
local Module = require(path.to.module)

local Thread = Module.GetThreadData("Tween1") -- Throws error if Thread Name doesn't exist

for Index, Data in pairs(Thread) do
  print(Index, Data)

https://user-images.githubusercontent.com/130311879/230796480-fee89249-6b1b-4426-bfaa-6a68d4919905.mp4


end
```

*Returns > Table { any }*
