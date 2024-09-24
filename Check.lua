local passes, fails = 0, 0

function pass(text)
    passes += 1
    print("✅ "..text)
end

function warn_(text)
    warn("⚠️ "..text)
end

function fail(text)
    fails += 1
    print("⛔ "..text)
end

function test(func)
    func()
end

print("\n")
print("Skid Environment Check")
print("✅ - Pass, ⛔ - Fail")
print("\n")

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
    local p, e = pcall(function()
        local value = about
    end)

    local p2, e2 = pcall(function()
        local value = about
        local value2 = about._name
        local value3 = about._version
        local value4 = about._publisher
    end)

    if p2 then
        fail("About table exists and is 1:1 to Xeno")
        return
    end

    pass("About table is not 1:1 to Xeno")
end)

test(function()
    local p, e = pcall(function()
        local execname, execvers = identifyexecutor()
        local exectable = nil

        local variations = {
            execname,
            string.lower(execname),
            string.upper(execname),
            string.gsub(string.lower(execname), "^%l", string.upper),
            "Executor",
            "Exploit"
        }

        for _, name in ipairs(variations) do
            if getgenv()[name] or getfenv()[name] then
                exectable = getgenv()[name] and getgenv()[name] or getfenv()[name]
                warn_(execname.." table exists in the global environment, checking for functions")

                if exectable["GUID"] then
                    fail("Global GUID variable exists in the global "..name.." table")
                else
                    pass("Default Xeno variable GUID does not exist in the environment for "..name)
                end

                if exectable["PID"] then
                    fail("Global PID variable exists in the global "..name.." table")
                else
                    pass("Default Xeno variable PID does not exist in the environment for "..name)
                end

                if exectable["get_real_address"] then
                    fail("Global get_real_address function exists in the global "..name.." table")
                else
                    pass("Default Xeno function get_real_address does not exist in the environment for "..name)
                end

                if exectable["spoof_instance"] then
                    fail("Global spoof_instance function exists in the global "..name.." table")
                else
                    pass("Default Xeno function spoof_instance does not exist in the environment for "..name)
                end

                if exectable["GetGlobal"] then
                    fail("Global GetGlobal function exists in the global "..name.." table")
                else
                    pass("Default Xeno function GetGlobal does not exist in the environment for "..name)
                end

                if exectable["SetGlobal"] then
                    fail("Global SetGlobal function exists in the global "..name.." table")
                else
                    pass("Default Xeno function SetGlobal does not exist in the environment for "..name)
                end

                if exectable["Compile"] then
                    fail("Global Compile function exists in the global "..name.." table")
                else
                    pass("Default Xeno function Compile does not exist in the environment for "..name)
                end

                if exectable["HttpSpy"] then
                    fail("Global HttpSpy function exists in the global "..name.." table")
                else
                    pass("Default Xeno function HttpSpy does not exist in the environment for "..name)
                end

                return
            end
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

if rate < 26 then
    local executorname, version = identifyexecutor()
    warn("⚠️ Your executor (AKA "..executorname..") is probably skidded, please stop using it")
end
