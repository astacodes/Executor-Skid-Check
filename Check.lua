local passes, fails = 0, 0

function pass(text)
    passes += 1
    print("✅ "..text)
end

function warn_(text)
    warn("⚠️ "..text)
end

function fail(text, lol)
    fails += 1
    if not lol then
        print("⛔ "..text)
    else
        print("⛔ "..text.." ("..lol..")")
    end
end

function test(func)
    func()
end

print("\n")
print("Skid Environment Check")
print("✅ - Pass, ⛔ - Fail")
print("\n")

warn_("Loading tests... please wait")
test(function()
    task.spawn(function()
        game.CoreGui.ChildAdded:Connect(function(v)
            if v:IsA("ScreenGui") then
                if v.Name == "Window" or v.Name == "MainMenu" or v.Name == "ScreenGui" or v.Name == "Intro" then
                    v.Enabled = false
                end
            end
        end)

        while wait() do
            for _, v in pairs(game.CoreGui:GetChildren()) do
                if v:IsA("ScreenGui") then
                    if v.Name == "Window" or v.Name == "MainMenu" or v.Name == "ScreenGui" or v.Name == "Intro" then
                        v.Enabled = false
                    end
                end
            end
        end
    end)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()

    local Timeout = 5
    local ElapsedTime = 0
    local StartTime = os.time()

    repeat
        wait(0.1)
        ElapsedTime = os.time() - StartTime
    until game.CoreGui:FindFirstChild("Window") or ElapsedTime >= Timeout

    if not game.CoreGui:FindFirstChild("Window") then
        fail("Dex was not located or took too long to load")
        return
    end

    local FoundElement = nil
    for i, v in pairs(game:GetDescendants()) do
        pcall(function()
            if v.Text == "StarterGui" then
                FoundElement = v
            end
        end)
    end

    if not FoundElement then
        fail("Dex was not able to find children of Game (Xeno Bug)", "nil instances moment 🤑")
    else
        pass("Dex loaded all objects successfully!")
    end

    warn_("Unloading Dex..")
    repeat wait() until not game.CoreGui:FindFirstChild("Intro")

    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v:IsA("ScreenGui") then
            if v.Name == "Window" or v.Name == "MainMenu" or v.Name == "ScreenGui" or v.Name == "Intro" then
                v:Destroy()
            end
        end
    end
end)

test(function()
    local p, e = pcall(function()
        local scriptname = getfenv().script.name
        if string.len(scriptname) == 36 then
            error("Skidded")
        end
    end)

    if p then
        pass("Fake Environment script name was not generated the same way as Xeno")
    else
        fail("Fake Environment script name was generated with HttpService:GenerateGUID()")
    end
end)

test(function()
    local p, e = pcall(function()
        local scriptpath = getfenv().script:GetFullName()
        if string.find(scriptpath, "RobloxReplicatedStorage") then
            error("Skidded")
        end
    end)

    if p then
        pass("Fake Environment script is not located in RobloxReplicatedStorage")
    else
        fail("Fake Environment script is located in RobloxReplicatedStorage")
    end
end)

test(function()
    if about and about.__name and about.__version and about.__publisher then
        fail("About table exists and is 1:1 to Xeno", "did "..about._publisher.." really make this 🤔")
        return
    elseif about and about.__publisher then
        fail("About table exists and is 1:1 to Xeno", "did "..about._publisher.." really make this 🤔")
        return
    elseif about then
        local name, idc = identifyexecutor()
        fail("About table exists and is 1:1 to Xeno", "did "..name.." devs really make this 🤔")
        return
    else
        pass("About table is original")
        return
    end
end)

test(function()
    local p, e = pcall(function()
        local test = game:GetService("LinkingService"):OpenUrl()
        if test == true then
            fail("LinkingService RCE not patched (Common in Xeno 1.0.4)", "vulnerable ✅✅✅")
            return
        end
    end)

    if e and string.find(e, "Attempt to call a blocked function: OpenUrl") then
        fail("Blocked function message is 1:1 to Xeno")
        return
    end

    pass("Blocked function patch is original")
end)

test(function()
    local p, e = pcall(function()
        local execname, execvers = identifyexecutor()
        local exectable = nil

        function GrabExecTable()
            local env = getgenv()
        
            for key, value in pairs(env) do
                if type(value) == "table" and (
                    value.PID or
                    value.GUID or
                    type(value.get_real_address) == "function" or
                    type(value.spoof_instance) == "function" or
                    type(value.GetGlobal) == "function" or
                    type(value.SetGlobal) == "function" or
                    type(value.HttpSpy) == "function" or
                    type(value.Compile) == "function"
                ) then
                    return key, value
                end
            end
        
            return nil, nil
        end
        
        local tname, ttable = GrabExecTable()

        if ttable then
            local name = execname
            local exectable = ttable

            if exectable["GUID"] then
                fail("GUID variable exists in the global "..tname.." table")
            else
                pass("Default Xeno variable GUID does not exist in the environment for "..name)
            end

            if exectable["PID"] then
                fail("PID variable exists in the global "..tname.." table")
            else
                pass("Default Xeno variable PID does not exist in the environment for "..name)
            end

            if exectable["get_real_address"] then
                fail("get_real_address function exists in the global "..tname.." table")
            else
                pass("Default Xeno function get_real_address does not exist in the environment for "..name)
            end

            if exectable["spoof_instance"] then
                fail("spoof_instance function exists in the global "..tname.." table")
            else
                pass("Default Xeno function spoof_instance does not exist in the environment for "..name)
            end

            if exectable["GetGlobal"] then
                fail("GetGlobal function exists in the global "..tname.." table")
            else
                pass("Default Xeno function GetGlobal does not exist in the environment for "..name, "xeno what is the point of this")
            end

            if exectable["SetGlobal"] then
                fail("SetGlobal function exists in the global "..tname.." table")
            else
                pass("Default Xeno function SetGlobal does not exist in the environment for "..name, "xeno what is the point of this v2")
            end

            if exectable["Compile"] then
                fail("Compile function exists in the global "..tname.." table", "global compile function 😎💯")
            else
                pass("Default Xeno function Compile does not exist in the environment for "..name)
            end

            if exectable["HttpSpy"] then
                fail("HttpSpy function exists in the global "..tname.." table", "luarmorK 🤑✅")
            else
                pass("Default Xeno function HttpSpy does not exist in the environment for "..name)
            end

            return
        end

        pass("Default Xeno variable GUID does not exist in the environment")
        pass("Default Xeno variable PID does not exist in the environment")
        pass("Default Xeno function get_real_address does not exist in the environment")
        pass("Default Xeno function spoof_instance does not exist in the environment")
        pass("Default Xeno function GetGlobal does not exist in the environment")
        pass("Default Xeno function SetGlobal does not exist in the environment")
        pass("Default Xeno function Compile does not exist in the environment")
        pass("Default Xeno function HttpSpy does not exist in the environment")
    end)
end)

local rate = math.round(passes / (passes + fails) * 100)
local outOf = passes .. " out of " .. (passes + fails)

print("\n")

print("Skid Summary")
print("✅ Tested with a " .. rate .. "% success rate (" .. outOf .. ")")
print("⛔ " .. fails .. " tests failed")

if rate < 51 then
    local executorname, version = identifyexecutor()
    warn("⚠️ Your executor (AKA "..executorname..") is probably skidded, please stop using it")
end
