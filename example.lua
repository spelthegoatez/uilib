
-- example

local library = "https://raw.githubusercontent.com/spelthegoatez/uilib/refs/heads/main/library.lua"; -- library

local Library = loadstring(game:HttpGet(library))();
if not Library then
    error("ui failed to load.", 0); -- errors if the repo is gone, or github is down or if it just fails to load in general.
end;

local Players     = game:GetService("Players");
local RunService  = game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait();


-- window

local Win = Library:Window("spel.script", UDim2.fromOffset(560, 620));

-- tab

local Combat = Win:AddTab("Combat");

local Aiming = Combat:AddSection("Aiming", "Left");

local Aimbot = Aiming:AddToggle("aimbot", false, function(on)
    print("aimbot:", on);
end, { Tooltip = "Master switch" });
Aimbot:AddKeybind(Enum.KeyCode.E, { Mode = "Toggle" });

local FovEnabled = Aiming:AddToggle("fov enabled", false, function(on) end);
FovEnabled:DependsOn(Aimbot, true);

local FovSlider = Aiming:AddSlider("fov", 0, 360, 90, function(v)
    print("fov:", v);
end);
FovSlider:DependsOn(FovEnabled, true);

local Smoothing = Aiming:AddSlider("smoothing", 0, 1, 0.25, function(v) end);
Smoothing:DependsOn(Aimbot, true);

Aiming:AddDropdown("Hitbox", { "Head", "Torso", "Left Arm", "Right Arm", "Closest" }, "Head", function(v)
    print("hitbox:", v);
end):DependsOn(Aimbot, true);

Aiming:AddDropdown("Priority", { "Distance", "Health", "Crosshair", "FOV" }, "Distance", function(v)
    print("priority:", v);
end):DependsOn(Aimbot, true);

local AimColor = Aiming:AddColorpicker("FOV color", Color3.fromRGB(198, 199, 221), 1, function(c, a)
    print("fov color:", c, a);
end);

local AimKey = Aiming:AddToggle("aim key mode", true, function(on) end, { Tooltip = "Toggle/Hold picker via right-click" });
AimKey:AddKeybind(Enum.KeyCode.E, { Mode = "Hold" });

local Trigger = Combat:AddSection("Triggerbot", "Right");

Trigger:AddToggle("enable", false, function(on) end);
Trigger:AddSlider("delay (ms)", 0, 500, 100, function(v) end);
Trigger:AddSlider("hit chance", 0, 100, 100, function(v) end, { Tooltip = "Random chance per shot" });
Trigger:AddButton("Apply", function() print("apply"); end):AddButton("Reset", function() print("reset"); end);
Trigger:AddToggle("randomize delay", true, function(on) end);
Trigger:AddToggle("team check", false, function(on) end);
Trigger:AddToggle("visible check", true, function(on) end);

local Target = Combat:AddSection("Target", "Left");

Target:AddDropdown("whitelist", { "Friends", "Enemies", "Everyone" }, "Everyone", function(v) end, { Multi = true });
Target:AddToggle("ignore friendlies", true);
Target:AddToggle("ignore crouching", false);
Target:AddTextbox("tag filter", "", "player tag...", function(text, enter)
    print("tag filter:", text, enter);
end);
Target:AddParagraph("About target", "Filters determine who the aimbot can and cannot lock onto. Whitelist mode uses the Players tab tags.");

-- tab

local PlayersTab = Win:AddTab("Players");

local Filters = PlayersTab:AddSection("Filters", "Left");
Filters:AddToggle("Team check", false);
Filters:AddDropdown("Sort by", { "Name", "Distance", "Team" }, "Name", function(v) end);
Filters:AddToggle("Show hidden", false);
Filters:AddToggle("Highlight target", true);

PlayersTab:PlayerList();

-- tab

local Visuals = Win:AddTab("Visuals");

-- subtabs

local VisPlayer  = Visuals:AddSubTab("Player");
local VisWorld   = Visuals:AddSubTab("World");

-- subtab

local EspSec = VisPlayer:AddSection("ESP", "Left");
EspSec:AddToggle("enabled", true, function(on) end);

-- toggle with attached colorpicker

local EspBoxes = EspSec:AddToggle("boxes", true);
EspBoxes:AddColorpicker("Box color", Color3.fromRGB(198, 199, 221), 1, function(c, a) end);

EspSec:AddToggle("names", true);
EspSec:AddToggle("health bar", true);
EspSec:AddToggle("distance", true);
EspSec:AddToggle("head dot", false);
EspSec:AddToggle("skeleton", false);
EspSec:AddColorpicker("box color", Color3.fromRGB(198, 199, 221), 1, function(c, a) end);
EspSec:AddColorpicker("name color", Color3.fromRGB(255, 255, 255), 1, function(c, a) end);
EspSec:AddSlider("max distance", 0, 2000, 800);
EspSec:AddSlider("thickness", 1, 5, 1);

local ChamsSec = VisPlayer:AddSection("Chams", "Right");
ChamsSec:AddToggle("enabled", false);
ChamsSec:AddColorpicker("fill color", Color3.fromRGB(198, 199, 221), 0.5);
ChamsSec:AddColorpicker("outline color", Color3.fromRGB(255, 255, 255), 1);
ChamsSec:AddDropdown("material", { "Plastic", "Neon", "ForceField", "Glass" }, "Plastic");

-- preview of player

local PreviewSec = VisPlayer:AddSection("Preview", "Right");
PreviewSec:AddPreview({ Height = 230 });

-- subtab

local WorldSec = VisWorld:AddSection("World", "Left");
WorldSec:AddToggle("fullbright", true);
WorldSec:AddSlider("ambient", 0, 10, 2);
WorldSec:AddSlider("clock time", 0, 24, 12);
WorldSec:AddToggle("remove fog", false);
WorldSec:AddColorpicker("sky tint", Color3.fromRGB(135, 206, 235), 1);

local SkySec = VisWorld:AddSection("Skybox", "Right");
SkySec:AddDropdown("preset", { "Default", "Night", "Space", "Sunset", "Storm" }, "Default");
SkySec:AddToggle("custom", false);
SkySec:AddTextbox("asset id", "", "rbxassetid://", function(t, e) end);

-- tab

local Misc = Win:AddTab("Misc");

local MoveSec = Misc:AddSection("Movement", "Left");
local Fly = MoveSec:AddToggle("fly", false, function(on) end);
Fly:AddKeybind(Enum.KeyCode.F, { Mode = "Hold" });
local FlySpeed = MoveSec:AddSlider("fly speed", 1, 250, 50, function(v) end);
FlySpeed:DependsOn(Fly, true);
MoveSec:AddToggle("noclip", false, function(on) end):AddKeybind(Enum.KeyCode.N, { Mode = "Toggle" });
MoveSec:AddToggle("infinite jump", true);
MoveSec:AddSlider("walk speed", 16, 200, 16);
MoveSec:AddSlider("jump power", 50, 300, 50);

local WorldMisc = Misc:AddSection("World", "Left");
WorldMisc:AddToggle("remove texture", false);
WorldMisc:AddToggle("remove detail", false);
WorldMisc:AddToggle("low graphics", false);
WorldMisc:AddSlider("render distance", 1, 10, 5);
WorldMisc:AddButton("Clear terrain", function() end, { Confirm = true });

local DangerSec = Misc:AddSection("Advanced", "Right");
DangerSec:AddToggle("experimental", false, nil, { risky = true, Tooltip = "May crash the game" });
DangerSec:AddToggle("unsafe mode", false, nil, { danger = true, Tooltip = "Requires rejoin to undo" });
DangerSec:AddDropdown("log level", { "Info", "Warn", "Error", "Debug" }, "Info");
DangerSec:AddDropdown("log filters", { "Info", "Warn", "Error", "Debug", "Trace" }, { "Warn", "Error" }, function(list)
    print("filters:", table.concat(list, ", "));
end, { Multi = true });
DangerSec:AddTextbox("custom command", "", "run...", function(text, enter) end);
DangerSec:AddButton("Apply", function() end):AddButton("Reset", function() end, { Confirm = true });

local ModList = DangerSec:AddList("Modules", {
    "Aimbot", "ESP", "Chams", "Radar", "Fly", "Speed", "Noclip", "Fullbright", "Fullbright+", "Freecam"
}, {
    Multi = true;
    Height = 120;
    Default = { "ESP", "Fullbright" };
    Callback = function(list) print("modules:", table.concat(list, ", ")); end;
});

local InfoSec = Misc:AddSection("Info", "Right");
InfoSec:AddLabel("Made with spel.script");
InfoSec:AddParagraph("About", "spel.script is a lightweight UI framework that runs on top of the odd.gg library. Every control here is fully interactive.");
InfoSec:AddButton("Copy discord", function() end):AddButton("Copy link", function() end);

-- notification button

InfoSec:AddButton("Test notification", function()
    Library:Notify({
        Text = 'noti<font color="#C6C7DD">fication</font> from spel.script';
        Lifetime = math.random(3, 6);
    });
end);

-- multi section

local MSCombat, MSMove, MSRender = Misc:AddMultiSection({ "Combat", "Movement", "Render" }, "Right");
MSCombat:AddToggle("auto parry", true);
MSCombat:AddSlider("reaction (ms)", 0, 200, 60);
MSMove:AddToggle("sprint", false);
MSMove:AddSlider("walkspeed", 16, 100, 16);
MSRender:AddToggle("fullbright", true);
MSRender:AddDropdown("skybox", { "Day", "Night", "Space" }, "Day");

-- tab settings

local Settings = Win:AddTab("Settings");

-- section

local AppSec = Settings:AddSection("Appearance", "Left");
local ThemeNames = {};
for _, T in Library.AppearanceThemes do ThemeNames[#ThemeNames + 1] = T.Name end;
AppSec:AddDropdown("Theme", ThemeNames, "Default", function(name) Library:ApplyTheme(name) end);
AppSec:AddColorpicker("Accent",        Library.Palette.Default.Accent,       1, function(c) Library:AppApplyAccent(c) end);
AppSec:AddColorpicker("Background",    Library.Palette.Default.Top,          1, function(c) Library:AppApplyBackTop(c) end);
AppSec:AddColorpicker("Lowlight",      Library.Palette.Default.Bottom,       1, function(c) Library:AppApplyBackBottom(c) end);
AppSec:AddColorpicker("Outline",       Library.Palette.Default.Outline,      1, function(c) Library:AppApplyOutline(c) end);
AppSec:AddColorpicker("Inner outline", Library.Palette.Default.InnerOutline, 1, function(c) Library:AppApplyInnerOutline(c) end);
AppSec:AddColorpicker("Title color",   Library.Palette.Default.TitleBottom,  1, function(c) Library:AppApplyTitleColor(c) end);
AppSec:AddColorpicker("Shadow color",  Library.Palette.Default.Shadow,       1, function(c) Library:AppApplyShadow(c) end);
AppSec:AddSlider("Shadow size",   0,  40, Library.Palette.Default.ShadowSize,   function(v) Library:AppApplyShadowSize(v) end);
AppSec:AddSlider("Shadow offset", -20, 20, Library.Palette.Default.ShadowOffset, function(v) Library:AppApplyShadowOffset(v) end);

-- overlay section

local OverlaySec = Settings:AddSection("Overlay", "Left");
local MenuToggle = OverlaySec:AddToggle("Menu", true, function(v)
    if Win.Gui then Library:FadeGui(Win.Gui, v) end;
    if Library.SyncBlur then Library:SyncBlur() end;
end);
MenuToggle:AddKeybind(Enum.KeyCode.RightControl, { Mode = "Toggle" });
OverlaySec:AddToggle("Menu blur",    false, function(v) Library._MenuBlurOn = v; if Library.SyncBlur then Library:SyncBlur() end; end);
OverlaySec:AddToggle("Watermark",    true,  function(v) if Library.WatermarkState   then Library.WatermarkState:SetVisible(v)   end; end);
OverlaySec:AddToggle("Keybind list", true,  function(v) if Library.KeybindListState then Library.KeybindListState:SetVisible(v) end; end);
OverlaySec:AddToggle("Anonymous",    false, function(v) Library:AppApplyAnonymous(v) end);

-- configs

local CfgSec = Settings:AddSection("Configs", "Right");
local CfgName = CfgSec:AddTextbox("Config name", "", "Config name...");
local CfgList = CfgSec:AddList("Saved", Library:ListConfigs(), {
    Height = 96;
    Callback = function(v) if v and v ~= "" then CfgName:Set(v) end; end;
});
local function CfgCurrent() return (CfgName:Get():gsub("^%s+", ""):gsub("%s+$", "")); end;
local function CfgWrite(Name)
    if typeof(writefile) ~= "function" then return end;
    Library:EnsureConfigsFolder();
    local Json = Library:GetConfig();
    writefile(Library:ConfigPath(Name), (typeof(Json) == "string") and Json or "{}");
    CfgList:Refresh(Library:ListConfigs());
end;
CfgSec:AddButton("Create", function()
    local Name = CfgCurrent(); if Name == "" then return end;
    CfgWrite(Name);
end):AddButton("Save", function()
    local Name = CfgCurrent(); if Name == "" then return end;
    CfgWrite(Name);
end);
CfgSec:AddButton("Load", function()
    local Name = CfgCurrent(); if Name == "" then return end;
    if typeof(readfile) ~= "function" then return end;
    local Path = Library:ConfigPath(Name);
    if typeof(isfile) == "function" and not isfile(Path) then return end;
    local Data = readfile(Path);
    if typeof(Data) == "string" then Library:LoadConfig(Data) end;
end):AddButton("Delete", function()
    local Name = CfgCurrent(); if Name == "" then return end;
    if typeof(delfile) ~= "function" then return end;
    local Path = Library:ConfigPath(Name);
    if typeof(isfile) == "function" and not isfile(Path) then return end;
    delfile(Path);
    CfgList:Refresh(Library:ListConfigs());
end);

-- watermark and keybind list.

local Watermark = Library:Watermark({
    Segments = { "spel.script", LocalPlayer.Name, "0 fps" };
});
Library:KeybindList({ Title = "Keybinds" });

task.spawn(function()
    local Acc, Frames = 0, 0;
    while Watermark and Watermark.Gui and Watermark.Gui.Parent do
        local Dt = RunService.RenderStepped:Wait();
        Acc = Acc + Dt; Frames = Frames + 1;
        if Acc >= 0.25 then
            Watermark:SetSegment(3, tostring(math.floor(Frames / Acc + 0.5)) .. " fps");
            Acc = 0; Frames = 0;
        end;
    end;
end);

return Library;
