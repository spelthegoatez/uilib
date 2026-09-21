-- init shit
	if getgenv().Library and typeof(getgenv().Library.Unload) == "function" then
		getgenv().Library:Unload();
	end;

	local UserInputService = game:GetService("UserInputService");
	local Workspace = game:GetService("Workspace");
	local HttpService = game:GetService("HttpService");
	local GuiService = game:GetService("GuiService");
	local RunService = game:GetService("RunService");
	local CoreGui = game:GetService("CoreGui");
	local TweenService = game:GetService("TweenService");
	local Lighting = game:GetService("Lighting");

	local Camera = Workspace.CurrentCamera;
	local GuiInset = GuiService:GetGuiInset().Y;

	local ColorSeq = ColorSequence.new;
	local ColorKey = ColorSequenceKeypoint.new;
	local NumSeq = NumberSequence.new;
	local NumKey = NumberSequenceKeypoint.new;

	local Library = {
		Flags = {};
		Toggles = {};
		Options = {};
		Connections = {};
		Directory = "Odd";
		Folders = { "/Fonts", "/Configs" };
		CurrentlyOpen = nil;
		AnimationSpeed = 1;
		WatermarkState = nil;
		KeybindListState = nil;
		EspPreviewState = nil;
		AppearanceState = nil;
		ConfigsState = nil;
		PlayerListState = nil;
		ConfigFlags = {};
		_Anonymous = false;
		_KeybindSyncs = {};
		_MenuBlurOn = false;
		_MenuBlurSize = 18;
	};

	local Palette = {
		Default = {
			Top = Color3.fromHex("282A36");
			Bottom = Color3.fromHex("21222C");

			ContentTop = Color3.fromHex("323442");
			ContentBottom = Color3.fromHex("21222C");
			ContentBg = Color3.fromHex("21222C");

			FooterTop = Color3.fromHex("21222C");
			FooterBottom = Color3.fromHex("2D2F3C");

			Outline = Color3.fromHex("101016");
			InnerOutline = Color3.fromHex("44475A");

			TitleTop = Color3.fromHex("F8F8F2");
			TitleBottom = Color3.fromHex("BD93F9");

			TabActive = Color3.fromHex("BD93F9");
			Accent = Color3.fromHex("BD93F9");

			TabInactive = Color3.fromHex("9698A8");

			Shadow = Color3.fromHex("000000");
			ShadowSize = 10;
			ShadowOffset = 0;
		};
	};

-- Constants
	Library.Palette = Palette;

	Library.KeyNames = {
		[Enum.UserInputType.MouseButton1] = "MB1";
		[Enum.UserInputType.MouseButton2] = "MB2";
		[Enum.UserInputType.MouseButton3] = "MB3";

		[Enum.KeyCode.LeftShift] = "LS";
		[Enum.KeyCode.RightShift] = "RS";
		[Enum.KeyCode.LeftControl] = "LC";
		[Enum.KeyCode.RightControl] = "RC";
		[Enum.KeyCode.LeftAlt] = "LA";
		[Enum.KeyCode.RightAlt] = "RA";
		[Enum.KeyCode.CapsLock] = "CAPS";
		[Enum.KeyCode.Insert] = "INS";
		[Enum.KeyCode.Backspace] = "BS";
		[Enum.KeyCode.Return] = "Ent";
		[Enum.KeyCode.Escape] = "ESC";
		[Enum.KeyCode.Space] = "SPC";

		[Enum.KeyCode.Zero] = "0";
		[Enum.KeyCode.One] = "1";
		[Enum.KeyCode.Two] = "2";
		[Enum.KeyCode.Three] = "3";
		[Enum.KeyCode.Four] = "4";
		[Enum.KeyCode.Five] = "5";
		[Enum.KeyCode.Six] = "6";
		[Enum.KeyCode.Seven] = "7";
		[Enum.KeyCode.Eight] = "8";
		[Enum.KeyCode.Nine] = "9";

		[Enum.KeyCode.KeypadZero] = "Num0";
		[Enum.KeyCode.KeypadOne] = "Num1";
		[Enum.KeyCode.KeypadTwo] = "Num2";
		[Enum.KeyCode.KeypadThree] = "Num3";
		[Enum.KeyCode.KeypadFour] = "Num4";
		[Enum.KeyCode.KeypadFive] = "Num5";
		[Enum.KeyCode.KeypadSix] = "Num6";
		[Enum.KeyCode.KeypadSeven] = "Num7";
		[Enum.KeyCode.KeypadEight] = "Num8";
		[Enum.KeyCode.KeypadNine] = "Num9";

		[Enum.KeyCode.Minus] = "-";
		[Enum.KeyCode.Equals] = "=";
		[Enum.KeyCode.Tilde] = "~";
		[Enum.KeyCode.LeftBracket] = "[";
		[Enum.KeyCode.RightBracket] = "]";
		[Enum.KeyCode.LeftParenthesis] = "(";
		[Enum.KeyCode.RightParenthesis] = ")";
		[Enum.KeyCode.Semicolon] = ",";
		[Enum.KeyCode.Quote] = "'";
		[Enum.KeyCode.BackSlash] = "\\";
		[Enum.KeyCode.Comma] = ",";
		[Enum.KeyCode.Period] = ".";
		[Enum.KeyCode.Slash] = "/";
		[Enum.KeyCode.Asterisk] = "*";
		[Enum.KeyCode.Plus] = "+";
		[Enum.KeyCode.Backquote] = "`";
	};

-- Tween & Keys
	function Library:Tween(Inst, Info, Props)
		local Speed = self.AnimationSpeed or 1;
		if Speed < 0.05 then Speed = 0.05 end;
		local Scale = 1 / Speed;
		if Scale == 1 then
			return TweenService:Create(Inst, Info, Props);
		end;
		local Scaled = TweenInfo.new(Info.Time * Scale, Info.EasingStyle, Info.EasingDirection, Info.RepeatCount, Info.Reverses, Info.DelayTime);
		return TweenService:Create(Inst, Scaled, Props);
	end;

	function Library:KeyDisplayName(K)
		if K == nil then return "None" end;
		if self.KeyNames[K] then return self.KeyNames[K] end;
		if typeof(K) == "EnumItem" then return K.Name end;
		return tostring(K);
	end;

	function Library:ParseKeyName(N)
		if N == nil or N == "" or N == "None" then return nil end;
		for Key, Name in self.KeyNames do
			if Name == N then return Key end;
		end;
		for _, Item in Enum.KeyCode:GetEnumItems() do
			if Item.Name == N then return Item end;
		end;
		for _, Item in Enum.UserInputType:GetEnumItems() do
			if Item.Name == N then return Item end;
		end;
		return nil;
	end;

-- Init
	for _, FolderPath in Library.Folders do
		makefolder(Library.Directory .. FolderPath);
	end;

	getgenv().Library = Library;

	function Library:Connection(Signal, Callback)
		local Conn = Signal:Connect(Callback);
		table.insert(self.Connections, Conn);
		return Conn;
	end;

	function Library:AutoFlag(Hint)
		local Base = tostring(Hint or "flag"):gsub("[^%w_]", "_");
		if Base == "" then Base = "flag" end;
		if self.Flags[Base] == nil then return Base end;
		local I = 2;
		while self.Flags[Base .. "_" .. I] ~= nil do I = I + 1 end;
		return Base .. "_" .. I;
	end;

	function Library:RegisterFlag(Flag, Default, Setter)
		self.Flags[Flag] = Default;
		self.ConfigFlags[Flag] = Setter;
	end;

-- Gradient Titles
	local function TitleHexC(C)
		return string.format("#%02X%02X%02X",
			math.floor(C.R * 255 + 0.5),
			math.floor(C.G * 255 + 0.5),
			math.floor(C.B * 255 + 0.5));
	end;
	local function TitleEsc(Ch)
		if Ch == "<" then return "&lt;" end;
		if Ch == ">" then return "&gt;" end;
		if Ch == "&" then return "&amp;" end;
		return Ch;
	end;
	function Library:GradientTitle(Str)
		Str = tostring(Str or "");
		local N = #Str;
		if N == 0 then return "" end;
		local Stop = Palette.Default.TitleBottom;
		local eH, eS, eV = Stop:ToHSV();
		local Split = 0.35;
		local Vstart = 0.78;
		local Out = "";
		for I = 1, N do
			local T = (N <= 1) and 0 or (I - 1) / (N - 1);
			local S, V;
			if T < Split then
				S = 0;
				V = Vstart + (eV - Vstart) * (T / Split);
			else
				S = eS * ((T - Split) / (1 - Split));
				V = eV;
			end;
			local C = Color3.fromHSV(eH, S, V);
			Out = Out .. string.format('<font color="%s">%s</font>', TitleHexC(C), TitleEsc(Str:sub(I, I)));
		end;
		return Out;
	end;
	Library._GradientLabels = Library._GradientLabels or {};
	function Library:RegisterGradientTitle(Label, Text)
		table.insert(self._GradientLabels, { Label = Label, Text = tostring(Text or "") });
		Label.Text = self:GradientTitle(Text);
	end;
	function Library:RefreshGradientTitles()
		for I = #self._GradientLabels, 1, -1 do
			local E = self._GradientLabels[I];
			if not E.Label.Parent then
				table.remove(self._GradientLabels, I);
			else
				E.Label.Text = self:GradientTitle(E.Text);
			end;
		end;
	end;
	Library.TitleFont = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium);

-- Theme
	Library._Theme = { Reg = {}, Grads = {} };

	local function ThemeColorEq(A, B)
		if A == nil or B == nil then return false end;
		return math.abs(A.R - B.R) < 0.005
			and math.abs(A.G - B.G) < 0.005
			and math.abs(A.B - B.B) < 0.005;
	end;

	local function ThemeColorProps(Inst)
		if Inst:IsA("UIStroke") then return { "Color" } end;
		if Inst:IsA("ScrollingFrame") then return { "BackgroundColor3", "ScrollBarImageColor3" } end;
		if Inst:IsA("TextLabel") or Inst:IsA("TextButton") or Inst:IsA("TextBox") then return { "BackgroundColor3", "TextColor3" } end;
		if Inst:IsA("ImageLabel") or Inst:IsA("ImageButton") then return { "BackgroundColor3", "ImageColor3" } end;
		if Inst:IsA("GuiObject") then return { "BackgroundColor3" } end;
		return nil;
	end;

	function Library:ThemeRegister(Inst)
		if Inst:IsA("UIGradient") then
			local Kps = Inst.Color.Keypoints;
			for _, Kp in Kps do
				for _, V in Palette.Default do
					if typeof(V) == "Color3" and ThemeColorEq(Kp.Value, V) then
						self._Theme.Grads[Inst] = true;
						return;
					end;
				end;
			end;
			return;
		end;
		local Props = ThemeColorProps(Inst);
		if not Props then return end;
		for _, Prop in Props do
			local Val = Inst[Prop];
			if typeof(Val) == "Color3" then
				for K, V in Palette.Default do
					if typeof(V) == "Color3" and ThemeColorEq(Val, V) then
						local Bucket = self._Theme.Reg[K];
						if not Bucket then Bucket = {}; self._Theme.Reg[K] = Bucket end;
						Bucket[#Bucket + 1] = { Inst, Prop };
					end;
				end;
			end;
		end;
	end;

	function Library:Refresh(Key, Color)
		local Old = Palette.Default[Key];
		if typeof(Old) ~= "Color3" or typeof(Color) ~= "Color3" then return end;
		if ThemeColorEq(Old, Color) then return end;

		local Bucket = self._Theme.Reg[Key];
		if Bucket then
			for I = #Bucket, 1, -1 do
				local E = Bucket[I];
				local Inst, Prop = E[1], E[2];
				if ThemeColorEq(Inst[Prop], Old) then Inst[Prop] = Color end;
			end;
		end;

		for Grad in self._Theme.Grads do
			local Changed = false;
			local New = {};
			for _, Kp in Grad.Color.Keypoints do
				if ThemeColorEq(Kp.Value, Old) then
					New[#New + 1] = ColorKey(Kp.Time, Color);
					Changed = true;
				else
					New[#New + 1] = ColorKey(Kp.Time, Kp.Value);
				end;
			end;
			if Changed then Grad.Color = ColorSeq(New) end;
		end;

		Palette.Default[Key] = Color;
	end;

	function Library:CreateInstance(ClassName, Properties)
		local Inst = Instance.new(ClassName);
		for K, V in next, (Properties or {}) do
			Inst[K] = V;
		end;
		if self._Theme then self:ThemeRegister(Inst) end;
		return Inst;
	end;

-- Fonts
	function Library:RegisterFont(Name, Url, Weight, Style)
		local Folder = self.Directory .. "/Fonts";
		local TtfPath = Folder .. "/" .. Name .. ".ttf";
		local DescPath = Folder .. "/" .. Name .. ".font";

		if not isfile(TtfPath) then
			writefile(TtfPath, game:HttpGet(Url));
		end;
		if isfile(DescPath) then
			delfile(DescPath);
		end;

		writefile(DescPath, HttpService:JSONEncode({
			name = Name;
			faces = {
				{ name = "Regular", weight = 400, style = "normal", assetId = getcustomasset(TtfPath) };
			};
		}));

		return getcustomasset(DescPath);
	end;

	Library.Fonts = {
		Proggy = Font.fromEnum(Enum.Font.SourceSans);
	};
	Library.TitleFont = Library.Fonts.Proggy;
	do
		local function LoadFont(Name, Url, Weight)
			local Ok, Asset = pcall(function() return Library:RegisterFont(Name, Url, 400, "Normal") end);
			if Ok and typeof(Asset) == "string" and Asset ~= "" then
				return Font.new(Asset, Weight, Enum.FontStyle.Normal);
			end;
			return nil;
		end;
		local Body, Title;
		local Done = 0;
		task.spawn(function() Body = LoadFont("Verdana", "https://github.com/cascade-v/44/raw/refs/heads/main/verdana.ttf", Enum.FontWeight.Regular); Done = Done + 1 end);
		task.spawn(function() Title = LoadFont("VerdanaBold", "https://github.com/cascade-v/44/raw/refs/heads/main/verdana-bold.ttf", Enum.FontWeight.Bold); Done = Done + 1 end);
		while Done < 2 do task.wait() end;
		if Body then Library.Fonts.Proggy = Body end;
		if Title then Library.TitleFont = Title elseif Body then Library.TitleFont = Body end;
	end;

-- Outlines & Dragging
	function Library:ApplyDoubleOutline(Frame)
		self:CreateInstance("UIStroke", {
			Parent = Frame;
			Color = Palette.Default.Outline;
			Thickness = 1;
			LineJoinMode = Enum.LineJoinMode.Miter;
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
		});
		local Inner = self:CreateInstance("Frame", {
			Name = "InnerOutline";
			Parent = Frame;
			Position = UDim2.new(0, 1, 0, 1);
			Size = UDim2.new(1, -2, 1, -2);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
		});
		self:CreateInstance("UIStroke", {
			Parent = Inner;
			Color = Palette.Default.InnerOutline;
			Thickness = 1;
			LineJoinMode = Enum.LineJoinMode.Miter;
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
		});
		return Inner;
	end;

	function Library:Draggable(TargetFrame, DragHandle)
		local Handle = DragHandle or TargetFrame;
		local Dragging = false;
		local DragStart, StartPosition;

		self:Connection(Handle.InputBegan, function(Input)
			if
				Input.UserInputType ~= Enum.UserInputType.MouseButton1
				and Input.UserInputType ~= Enum.UserInputType.Touch
			then
				return
			end;
			if self._scrollbarDragging then
				return
			end;
			local Ap = TargetFrame.AnchorPoint;
			local Pos = TargetFrame.Position;
			if Ap.X ~= 0 or Ap.Y ~= 0 or Pos.X.Scale ~= 0 or Pos.Y.Scale ~= 0 then
				local AbsP = TargetFrame.AbsolutePosition;
				TargetFrame.AnchorPoint = Vector2.new(0, 0);
				TargetFrame.Position = UDim2.new(0, AbsP.X, 0, AbsP.Y);
			end;
			Dragging = true;
			DragStart = Input.Position;
			StartPosition = TargetFrame.Position;
		end);

		self:Connection(Handle.InputEnded, function(Input)
			if
				Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch
			then
				Dragging = false;
			end
		end);

		self:Connection(UserInputService.InputChanged, function(Input)
			if not Dragging or not DragStart or not StartPosition then
				return
			end;
			if
				Input.UserInputType ~= Enum.UserInputType.MouseMovement
				and Input.UserInputType ~= Enum.UserInputType.Touch
			then
				return
			end;
			local Delta = Input.Position - DragStart;
			local Vp = Camera.ViewportSize;
			local NewX = math.clamp(StartPosition.X.Offset + Delta.X, 0, Vp.X - TargetFrame.AbsoluteSize.X);
			local NewY = math.clamp(StartPosition.Y.Offset + Delta.Y, 0, Vp.Y - TargetFrame.AbsoluteSize.Y);
			TargetFrame.Position = UDim2.new(0, NewX, 0, NewY);
		end);
	end;

	function Library:Resizable(TargetFrame, Opts)
		Opts = typeof(Opts) == "table" and Opts or {};
		local GripPx = tonumber(Opts.GripPx) or 10;
		local MinX = tonumber(Opts.MinX) or TargetFrame.Size.X.Offset;
		local MinY = tonumber(Opts.MinY) or TargetFrame.Size.Y.Offset;

		local Grip = self:CreateInstance("TextButton", {
			Name = "ResizeGrip";
			Parent = TargetFrame;
			AnchorPoint = Vector2.new(1, 1);
			Position = UDim2.new(1, 0, 1, 0);
			Size = UDim2.new(0, GripPx, 0, GripPx);
			BackgroundTransparency = 1;
			AutoButtonColor = false;
			BorderSizePixel = 0;
			Text = "";
			ZIndex = 999;
		});

		local Resizing = false;
		local StartPos, StartSize;

		self:Connection(Grip.InputBegan, function(Input)
			if
				Input.UserInputType ~= Enum.UserInputType.MouseButton1
				and Input.UserInputType ~= Enum.UserInputType.Touch
			then
				return
			end;
			Resizing = true;
			StartPos = Input.Position;
			StartSize = TargetFrame.Size;
		end);

		self:Connection(Grip.InputEnded, function(Input)
			if
				Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch
			then
				Resizing = false;
			end
		end);

		self:Connection(UserInputService.InputChanged, function(Input)
			if not Resizing or not StartPos or not StartSize then
				return
			end;
			if
				Input.UserInputType ~= Enum.UserInputType.MouseMovement
				and Input.UserInputType ~= Enum.UserInputType.Touch
			then
				return
			end;
			local Vp = Camera.ViewportSize;
			local Dx = Input.Position.X - StartPos.X;
			local Dy = Input.Position.Y - StartPos.Y;
			TargetFrame.Size = UDim2.new(
				StartSize.X.Scale,
				math.clamp(StartSize.X.Offset + Dx, MinX, Vp.X),
				StartSize.Y.Scale,
				math.clamp(StartSize.Y.Offset + Dy, MinY, Vp.Y)
			);
		end);

		return Grip;
	end;

-- Shadows
	Library._Shadows = Library._Shadows or {};
	function Library:AttachShadow(Frame)
		local Glow = self:CreateInstance("ImageLabel", {
			Name = "Glow";
			Parent = Frame;
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			Image = "http://www.roblox.com/asset/?id=18245826428";
			ImageColor3 = Palette.Default.Shadow;
			ImageTransparency = 0.8;
			ScaleType = Enum.ScaleType.Slice;
			SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79));
			ZIndex = 2;
		});
		local function Sync()
			local Sz = Palette.Default.ShadowSize or 10;
			local Of = Palette.Default.ShadowOffset or 0;
			local Spread = 20;
			Glow.Position = UDim2.new(0, -Spread, 0, -Spread + Of);
			Glow.Size = UDim2.new(1, Spread * 2, 1, Spread * 2);
			Glow.ImageTransparency = math.clamp(1 - Sz / 40, 0, 1);
			Glow.ImageColor3 = Palette.Default.Shadow;
		end;
		Sync();
		table.insert(Library._Shadows, { Shadow = Glow; Sync = Sync; Frame = Frame; });
		Frame.AncestryChanged:Connect(function(_, parent)
			if not parent then
				Glow:Destroy();
				for I = #Library._Shadows, 1, -1 do
					if Library._Shadows[I].Shadow == Glow then table.remove(Library._Shadows, I); break end;
				end;
			end;
		end);
		return Glow;
	end;
	function Library:SyncAllShadows()
		for I = #Library._Shadows, 1, -1 do
			local Entry = Library._Shadows[I];
			if not Entry.Shadow.Parent or not Entry.Frame.Parent then
				table.remove(Library._Shadows, I);
			else
				Entry.Sync();
			end;
		end;
	end;

-- Fade
	function Library:CollectFade(Root)
		local List = {};
		for _, D in Root:GetDescendants() do
			if D:IsA("GuiObject") then
				List[#List + 1] = { D, "BackgroundTransparency", D.BackgroundTransparency };
				if D:IsA("TextLabel") or D:IsA("TextButton") or D:IsA("TextBox") then
					List[#List + 1] = { D, "TextTransparency", D.TextTransparency };
				end;
				if D:IsA("ImageLabel") or D:IsA("ImageButton") then
					List[#List + 1] = { D, "ImageTransparency", D.ImageTransparency };
				end;
				if D:IsA("ViewportFrame") then
					List[#List + 1] = { D, "ImageTransparency", D.ImageTransparency };
				end;
				if D:IsA("ScrollingFrame") then
					List[#List + 1] = { D, "ScrollBarImageTransparency", D.ScrollBarImageTransparency };
				end;
			elseif D:IsA("UIStroke") then
				List[#List + 1] = { D, "Transparency", D.Transparency };
			end;
		end;
		return List;
	end;

	function Library:FadeFrame(Frame, Show)
		if typeof(Frame) ~= "Instance" then return end;
		local Info = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
		Frame:SetAttribute("_FadeShow", Show == true);

		local Items = {};
		local function Add(Inst, Prop)
			local Key = "_fb_" .. Prop;
			local Base = Inst:GetAttribute(Key);
			if Base == nil then Base = Inst[Prop]; Inst:SetAttribute(Key, Base) end;
			Items[#Items + 1] = { Inst, Prop, Base };
		end;
		for _, D in Frame:GetDescendants() do
			if D:IsA("GuiObject") then
				Add(D, "BackgroundTransparency");
				if D:IsA("TextLabel") or D:IsA("TextButton") or D:IsA("TextBox") then
					Add(D, "TextTransparency");
				end;
				if D:IsA("ImageLabel") or D:IsA("ImageButton") then
					Add(D, "ImageTransparency");
				end;
				if D:IsA("ViewportFrame") then
					Add(D, "ImageTransparency");
				end;
				if D:IsA("ScrollingFrame") then
					Add(D, "ScrollBarImageTransparency");
				end;
			elseif D:IsA("UIStroke") then
				Add(D, "Transparency");
			end;
		end;

		if Show then
			(Frame :: any).Visible = true;
			for _, E in Items do E[1][E[2]] = 1 end;
			for _, E in Items do
				self:Tween(E[1], Info, { [E[2]] = E[3] }):Play();
			end;
		else
			local Lead;
			for _, E in Items do
				local Tw = self:Tween(E[1], Info, { [E[2]] = 1 });
				Lead = Lead or Tw;
				Tw:Play();
			end;
			local function Finish()
				if Frame:GetAttribute("_FadeShow") then return end;
				(Frame :: any).Visible = false;
				for _, E in Items do E[1][E[2]] = E[3] end;
			end;
			if Lead then
				Lead.Completed:Connect(Finish);
			else
				Finish();
			end;
		end;
	end;

	function Library:FadeResize(Frame, Show)
		if typeof(Frame) ~= "Instance" then return end;
		local F = Frame :: any;
		local Dur = 0.22;

		local SizeInfo = TweenInfo.new(Dur, Enum.EasingStyle.Quad, Show and Enum.EasingDirection.Out or Enum.EasingDirection.In);

		local FadeInfo = TweenInfo.new(Dur * 0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
		Frame:SetAttribute("_FadeShow", Show == true);

		local FullH = Frame:GetAttribute("_natH");
		if FullH == nil then FullH = F.Size.Y.Offset; Frame:SetAttribute("_natH", FullH) end;
		local Sx = F.Size.X;

		local Items = {};
		local function Add(Inst, Prop)
			local Key = "_fb_" .. Prop;
			local Base = Inst:GetAttribute(Key);
			if Base == nil then Base = Inst[Prop]; Inst:SetAttribute(Key, Base) end;
			Items[#Items + 1] = { Inst, Prop, Base };
		end;
		for _, D in Frame:GetDescendants() do
			if D:IsA("GuiObject") then
				Add(D, "BackgroundTransparency");
				if D:IsA("TextLabel") or D:IsA("TextButton") or D:IsA("TextBox") then
					Add(D, "TextTransparency");
				end;
				if D:IsA("ImageLabel") or D:IsA("ImageButton") then
					Add(D, "ImageTransparency");
				end;
				if D:IsA("ViewportFrame") then
					Add(D, "ImageTransparency");
				end;
			elseif D:IsA("UIStroke") then
				Add(D, "Transparency");
			end;
		end;

		if Show then
			F.Visible = true;
			F.Size = UDim2.new(Sx.Scale, Sx.Offset, 0, 0);
			for _, E in Items do E[1][E[2]] = 1 end;
			self:Tween(Frame, SizeInfo, { Size = UDim2.new(Sx.Scale, Sx.Offset, 0, FullH) }):Play();
			for _, E in Items do
				self:Tween(E[1], FadeInfo, { [E[2]] = E[3] }):Play();
			end;
		else
			for _, E in Items do
				self:Tween(E[1], FadeInfo, { [E[2]] = 1 }):Play();
			end;
			local Lead = self:Tween(Frame, SizeInfo, { Size = UDim2.new(Sx.Scale, Sx.Offset, 0, 0) });
			local function Finish()
				if Frame:GetAttribute("_FadeShow") then return end;
				F.Visible = false;
				F.Size = UDim2.new(Sx.Scale, Sx.Offset, 0, FullH);
				for _, E in Items do E[1][E[2]] = E[3] end;
			end;
			Lead.Completed:Connect(Finish);
			Lead:Play();
		end;
	end;

	function Library:FadeGui(Root, Show)
		if typeof(Root) ~= "Instance" then return end;
		local Gui = Root :: any;
		local Info = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
		Root:SetAttribute("_FadeShow", Show == true);

		local Items = {};
		local function Add(Inst, Prop)
			local Key = "_fb_" .. Prop;
			local Base = Inst:GetAttribute(Key);
			if Base == nil then Base = Inst[Prop]; Inst:SetAttribute(Key, Base) end;
			Items[#Items + 1] = { Inst, Prop, Base };
		end;
		for _, D in Root:GetDescendants() do
			if D:IsA("GuiObject") then
				Add(D, "BackgroundTransparency");
				if D:IsA("TextLabel") or D:IsA("TextButton") or D:IsA("TextBox") then
					Add(D, "TextTransparency");
				end;
				if D:IsA("ImageLabel") or D:IsA("ImageButton") then
					Add(D, "ImageTransparency");
				end;
				if D:IsA("ViewportFrame") then
					Add(D, "ImageTransparency");
				end;
				if D:IsA("ScrollingFrame") then
					Add(D, "ScrollBarImageTransparency");
				end;
			elseif D:IsA("UIStroke") then
				Add(D, "Transparency");
			end;
		end;

		if Show then
			Gui.Enabled = true;
			for _, E in Items do E[1][E[2]] = 1 end;
			for _, E in Items do
				self:Tween(E[1], Info, { [E[2]] = E[3] }):Play();
			end;
		else
			local Lead;
			for _, E in Items do
				local Tw = self:Tween(E[1], Info, { [E[2]] = 1 });
				Lead = Lead or Tw;
				Tw:Play();
			end;
			local function Finish()
				if Root:GetAttribute("_FadeShow") then return end;
				Gui.Enabled = false;
				for _, E in Items do E[1][E[2]] = E[3] end;
			end;
			if Lead then
				Lead.Completed:Connect(Finish);
			else
				Finish();
			end;
		end;
	end;

-- Tooltip
	function Library:Tooltip(Inst, Text, MultiLine)
		if not Inst or not Text or Text == "" then return end;

		local Gui = self._TooltipGui;
		if not Gui or not Gui.Parent then
			Gui = self:CreateInstance("ScreenGui", {
				Name = "a";
				Parent = (gethui and gethui()) or CoreGui;
				IgnoreGuiInset = true;
				ResetOnSpawn = false;
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
				DisplayOrder = 9999;
			});
			self._TooltipGui = Gui;
		end;

		local AutoMode = MultiLine and Enum.AutomaticSize.Y or Enum.AutomaticSize.XY;
		local WideScale = MultiLine and 1 or 0;

		local Outline = self:CreateInstance("CanvasGroup", {
			Name = "Tooltip";
			Parent = Gui;
			GroupTransparency = 1;
			Position = UDim2.new(0, 30, 0, 0);
			Size = UDim2.new(0, MultiLine and 200 or 0, 0, 0);
			AutomaticSize = AutoMode;
			BackgroundColor3 = Palette.Default.Outline;
			BorderSizePixel = 0;
			Visible = true;
			ZIndex = 300;
		});
		self:CreateInstance("UIPadding", {
			Parent = Outline; PaddingLeft = UDim.new(0, 1); PaddingRight = UDim.new(0, 1);
			PaddingTop = UDim.new(0, 1); PaddingBottom = UDim.new(0, 1);
		});
		local Inline = self:CreateInstance("Frame", {
			Parent = Outline;
			Size = UDim2.new(WideScale, 0, 0, 0);
			AutomaticSize = AutoMode;
			BackgroundColor3 = Palette.Default.InnerOutline;
			BorderSizePixel = 0;
		});
		self:CreateInstance("UIPadding", {
			Parent = Inline; PaddingLeft = UDim.new(0, 1); PaddingRight = UDim.new(0, 1);
			PaddingTop = UDim.new(0, 1); PaddingBottom = UDim.new(0, 1);
		});
		local Background = self:CreateInstance("Frame", {
			Parent = Inline;
			Size = UDim2.new(WideScale, 0, 0, 0);
			AutomaticSize = AutoMode;
			BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			BorderSizePixel = 0;
		});
		self:CreateInstance("UIGradient", {
			Parent = Background;
			Rotation = 90;
			Color = ColorSeq({
				ColorKey(0, Palette.Default.Top);
				ColorKey(1, Palette.Default.Bottom);
			});
		});
		self:CreateInstance("UIPadding", {
			Parent = Background; PaddingLeft = UDim.new(0, 6); PaddingRight = UDim.new(0, 7);
			PaddingTop = UDim.new(0, 1); PaddingBottom = UDim.new(0, 3);
		});
		local Lbl = self:CreateInstance("TextLabel", {
			Name = "Text";
			Parent = Background;
			Size = UDim2.new(WideScale, 0, 0, 0);
			AutomaticSize = AutoMode;
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			FontFace = Library.Fonts.Proggy;
			Text = tostring(Text);
			TextColor3 = Color3.fromRGB(255, 255, 255);
			TextSize = 12;
			TextXAlignment = Enum.TextXAlignment.Left;
			TextYAlignment = Enum.TextYAlignment.Center;
			RichText = true;
			TextWrapped = MultiLine == true;
		});
		self:CreateInstance("UIStroke", {
			Parent = Lbl;
			Color = Color3.fromRGB(0, 0, 0);
			Thickness = 1;
			LineJoinMode = Enum.LineJoinMode.Miter;
			ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
		});

		local Open = false;
		local FadeInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
		self:Connection(Inst.MouseEnter, function()
			Open = true;
			self:Tween(Outline, FadeInfo, { GroupTransparency = 0 }):Play();
		end);
		self:Connection(Inst.MouseLeave, function()
			Open = false;
			self:Tween(Outline, FadeInfo, { GroupTransparency = 1 }):Play();
		end);
		self:Connection(UserInputService.InputChanged, function(Input)
			if Open and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
				Outline.Position = UDim2.fromOffset(Input.Position.X + 5, Input.Position.Y + 80);
			end;
		end);
	end;

-- Window
	function Library:Window(Title, Size)
		Title = tostring(Title or "/odd.gg");
		local WindowSize = typeof(Size) == "UDim2" and Size or UDim2.fromOffset(640, 480);

		local SpawnX = 35;
		local SpawnY = 70;

		local Gui = self:CreateInstance("ScreenGui", {
			Name = "\0";
			Parent = gethui and gethui() or CoreGui;
			Enabled = true;
			DisplayOrder = 999;
			IgnoreGuiInset = true;
			ResetOnSpawn = false;
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
		});

		local Main = self:CreateInstance("Frame", {
			Name = "Main";
			Parent = Gui;
			Size = WindowSize;
			Position = UDim2.new(0, SpawnX, 0, SpawnY);
			BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			BorderSizePixel = 0;
		});

		self:AttachShadow(Main);

		self:CreateInstance("UIGradient", {
			Parent = Main;
			Rotation = 90;
			Color = ColorSeq({
				ColorKey(0, Palette.Default.Top);
				ColorKey(1, Palette.Default.Bottom);
			});
		});
		self:CreateInstance("UIStroke", {
			Parent = Main;
			Color = Palette.Default.Outline;
			Thickness = 1;
			LineJoinMode = Enum.LineJoinMode.Miter;
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
		});
		local MainInnerOutline = self:CreateInstance("Frame", {
			Name = "InnerOutline";
			Parent = Main;
			Position = UDim2.new(0, 1, 0, 1);
			Size = UDim2.new(1, -2, 1, -2);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
		});
		self:CreateInstance("UIStroke", {
			Parent = MainInnerOutline;
			Color = Palette.Default.InnerOutline;
			Thickness = 1;
			LineJoinMode = Enum.LineJoinMode.Miter;
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
		});

		local function EscChar(Ch)
			if Ch == "<" then return "&lt;" end;
			if Ch == ">" then return "&gt;" end;
			if Ch == "&" then return "&amp;" end;
			return Ch;
		end;
		local function ColorHex(C)
			return string.format("#%02X%02X%02X",
				math.floor(C.R * 255 + 0.5),
				math.floor(C.G * 255 + 0.5),
				math.floor(C.B * 255 + 0.5));
		end;
		local function SplitColorText(Str, ColorA, ColorB, _RightSize)

			local N = #Str;
			if N == 0 then return "" end;
			local eH, eS, eV = ColorA:ToHSV();
			local Split = 0.35;
			local Vstart = 0.78;
			local Out = "";
			for I = 1, N do
				local T = (N <= 1) and 0 or (I - 1) / (N - 1);
				local S, V;
				if T < Split then
					S = 0;
					V = Vstart + (eV - Vstart) * (T / Split);
				else
					S = eS * ((T - Split) / (1 - Split));
					V = eV;
				end;
				local C = Color3.fromHSV(eH, S, V);
				Out = Out .. string.format('<font color="%s">%s</font>', ColorHex(C), EscChar(Str:sub(I, I)));
			end;
			return Out;
		end;

		local TitleLbl = self:CreateInstance("TextLabel", {
			Name = "Title";
			Parent = Main;
			AnchorPoint = Vector2.new(0, 0);
			Position = UDim2.new(0, 10, 0, 8);
			Size = UDim2.new(1, -28, 0, 16);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			FontFace = Library.TitleFont;
			Text = SplitColorText(Title, Palette.Default.TitleBottom, Palette.Default.TitleTop, 12);
			RichText = true;
			TextColor3 = Color3.fromRGB(255, 255, 255);
			TextSize = 12;
			TextXAlignment = Enum.TextXAlignment.Left;
			TextYAlignment = Enum.TextYAlignment.Center;
		});
		self:CreateInstance("UIStroke", {
			Parent = TitleLbl;
			Color = Color3.fromRGB(0, 0, 0);
			Thickness = 1;
			ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
		});
		local TitleBoldShadow = self:CreateInstance("TextLabel", {
			Name = "TitleBold";
			Parent = Main;
			AnchorPoint = Vector2.new(0, 0);
			Position = UDim2.new(0, 9, 0, 8);
			Size = UDim2.new(1, -28, 0, 16);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			FontFace = Library.TitleFont;
			Text = SplitColorText(Title, Palette.Default.TitleBottom, Palette.Default.TitleTop, 12);
			RichText = true;
			TextColor3 = Color3.fromRGB(255, 255, 255);
			TextSize = 12;
			TextXAlignment = Enum.TextXAlignment.Left;
			TextYAlignment = Enum.TextYAlignment.Center;
			ZIndex = TitleLbl.ZIndex - 1;
		});

		local Content = self:CreateInstance("Frame", {
			Name = "Content";
			Parent = Main;
			Position = UDim2.new(0, 6, 0, 32);
			Size = UDim2.new(1, -12, 1, -38);
			BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			BorderSizePixel = 0;
			ClipsDescendants = true;
		});
		self:CreateInstance("UIGradient", {
			Parent = Content;
			Rotation = 90;
			Color = ColorSeq({
				ColorKey(0, Palette.Default.ContentTop);
				ColorKey(1, Palette.Default.ContentBottom);
			});
		});
		self:CreateInstance("UIStroke", {
			Parent = Content;
			Color = Palette.Default.Outline;
			Thickness = 1;
			LineJoinMode = Enum.LineJoinMode.Miter;
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
		});
		local ContentInnerOutline = self:CreateInstance("Frame", {
			Name = "InnerOutline";
			Parent = Content;
			Position = UDim2.new(0, 1, 0, 1);
			Size = UDim2.new(1, -2, 1, -2);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
		});
		self:CreateInstance("UIStroke", {
			Parent = ContentInnerOutline;
			Color = Palette.Default.InnerOutline;
			Thickness = 1;
			LineJoinMode = Enum.LineJoinMode.Miter;
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
		});

		local TabBar = self:CreateInstance("Frame", {
			Name = "TabBar";
			Parent = Content;
			Position = UDim2.new(0, 0, 0, 0);
			Size = UDim2.new(1, 0, 0, 26);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
		});
		self:CreateInstance("UIPadding", {
			Parent = TabBar;
			PaddingLeft = UDim.new(0, 2);
			PaddingRight = UDim.new(0, 1);
		});
		self:CreateInstance("UIListLayout", {
			Parent = TabBar;
			FillDirection = Enum.FillDirection.Horizontal;
			HorizontalAlignment = Enum.HorizontalAlignment.Left;
			VerticalAlignment = Enum.VerticalAlignment.Bottom;
			SortOrder = Enum.SortOrder.LayoutOrder;
			Padding = UDim.new(0, -1);
		});
		self:CreateInstance("Frame", {
			Name = "TabDividerOuter";
			Parent = Content;
			Position = UDim2.new(0, 1, 0, 26);
			Size = UDim2.new(1, -2, 0, 1);
			BackgroundColor3 = Palette.Default.Outline;
			BorderSizePixel = 0;
		});
		self:CreateInstance("Frame", {
			Name = "TabDividerInner";
			Parent = Content;
			Position = UDim2.new(0, 1, 0, 27);
			Size = UDim2.new(1, -2, 0, 1);
			BackgroundColor3 = Palette.Default.InnerOutline;
			BorderSizePixel = 0;
		});

		local BottomFade = self:CreateInstance("Frame", {
			Name = "BottomFade";
			Parent = Content;
			AnchorPoint = Vector2.new(0.5, 1);
			Position = UDim2.new(0.5, 0, 1, -8);
			Size = UDim2.new(1, -16, 0, 26);
			BackgroundColor3 = Palette.Default.ContentBg;
			BorderSizePixel = 0;
			ZIndex = 8;
		});
		self:CreateInstance("UIGradient", {
			Parent = BottomFade;
			Rotation = 90;
			Transparency = NumSeq({
				NumKey(0, 1);
				NumKey(1, 0);
			});
		});

		self:Draggable(Main, Main);
		self:Resizable(Main);
		Main.Active = true;

-- ======== BLUR SETUP (patched) ========
		local Blur = self:CreateInstance("BlurEffect", {
			Name = "OddMenuBlur";
			Parent = Lighting;
			Size = 0;
			Enabled = true;
		});
		self._WindowBlur = Blur;
		self._MenuBlurSize = self._MenuBlurSize or 18;
		function Library:SyncBlur()
			if not self._WindowBlur or not self._WindowBlur.Parent then return end;
			local Win = self.CurrentlyOpen;
			local Gui = Win and Win.Gui;
			local Visible = false;
			if Gui then
				local Intent = Gui:GetAttribute("_FadeShow");
				if Intent == nil then Visible = Gui.Enabled == true else Visible = Intent == true end;
			end
			local WantOn = (self._MenuBlurOn == true) and Visible;
			local Target = WantOn and (self._MenuBlurSize or 18) or 0;
			self._WindowBlur.Enabled = true;
			TweenService:Create(self._WindowBlur, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = Target }):Play();
		end;
-- ======== /BLUR SETUP ========

		local WindowObject = {
			Gui = Gui;
			Main = Main;
			Content = Content;
			TabBar = TabBar;
			Tabs = {};
			ActiveTab = nil;
			Title = Title;
			TitleLabel = TitleLbl;
			TitleBoldLabel = TitleBoldShadow;
		};
		Library._WindowSplitColorText = SplitColorText;

		local LibRef = self;

		function WindowObject:AddTab(Name)
			local TabName = tostring(Name or "Tab");
			local TabObj = {};

			local Btn = LibRef:CreateInstance("TextButton", {
				Name = "Tab_" .. TabName;
				Parent = TabBar;
				AutoButtonColor = false;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BorderSizePixel = 0;
				Size = UDim2.new(0, 0, 1, -2);
				AutomaticSize = Enum.AutomaticSize.X;
				Text = "";
				LayoutOrder = #self.Tabs + 1;
			});
			LibRef:CreateInstance("UIGradient", {
				Parent = Btn;
				Rotation = 90;
				Color = ColorSeq({
					ColorKey(0, Palette.Default.InnerOutline);
					ColorKey(1, Palette.Default.FooterBottom);
				});
			});
			LibRef:CreateInstance("UIStroke", {
				Parent = Btn;
				Color = Palette.Default.Outline;
				Thickness = 1;
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
			});

			local TabCover = LibRef:CreateInstance("Frame", {
				Name = "Cover";
				Parent = Btn;
				Size = UDim2.new(1, 0, 1, 0);
				BackgroundColor3 = Palette.Default.Bottom;
				BorderSizePixel = 0;
				ZIndex = 2;
			});
			local TabLbl = LibRef:CreateInstance("TextLabel", {
				Name = "Label";
				Parent = Btn;
				Position = UDim2.new(0, 0, 0, -1);
				Size = UDim2.new(0, 0, 1, 0);
				AutomaticSize = Enum.AutomaticSize.X;
				BackgroundTransparency = 1;
				BorderSizePixel = 0;
				FontFace = Library.Fonts.Proggy;
				Text = TabName;
				TextColor3 = Palette.Default.TabInactive;
				TextSize = 12;
				TextXAlignment = Enum.TextXAlignment.Center;
				TextYAlignment = Enum.TextYAlignment.Center;
				ZIndex = 3;
			});
			LibRef:CreateInstance("UIPadding", {
				Parent = TabLbl;
				PaddingLeft = UDim.new(0, 10);
				PaddingRight = UDim.new(0, 10);
			});
			LibRef:CreateInstance("UIStroke", {
				Parent = TabLbl;
				Color = Color3.fromRGB(0, 0, 0);
				Thickness = 1;
				ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
			});
			local TabFill = LibRef:CreateInstance("Frame", {
				Name = "Fill";
				Parent = Btn;
				AnchorPoint = Vector2.new(0, 0);
				Position = UDim2.new(0, 0, 0, 0);
				Size = UDim2.new(1, 0, 0, 1);
				BackgroundColor3 = Palette.Default.Accent;
				BackgroundTransparency = 1;
				BorderSizePixel = 0;
				ZIndex = 4;
			});

			local Page = LibRef:CreateInstance("Frame", {
				Name = "Page_" .. TabName;
				Parent = Content;
				Position = UDim2.new(0, 8, 0, 34);
				Size = UDim2.new(1, -16, 1, -44);
				BackgroundTransparency = 1;
				BorderSizePixel = 0;
				Visible = false;
				ClipsDescendants = true;
			});
			local PageLayout = LibRef:CreateInstance("UIListLayout", {
				Parent = Page;
				FillDirection = Enum.FillDirection.Vertical;
				HorizontalFlex = Enum.UIFlexAlignment.Fill;
				SortOrder = Enum.SortOrder.LayoutOrder;
				Padding = UDim.new(0, 8);
			});

			local Columns = {};
			local ColumnsRow;
			local TabHasList = false;
			local function FitListColumn(Col)
				local Layout = Col:FindFirstChildOfClass("UIListLayout");
				if not Layout then return end;
				Col.AutomaticCanvasSize = Enum.AutomaticSize.None;
				Col.ScrollingEnabled = false;
				Col.AutomaticSize = Enum.AutomaticSize.None;
				local function Fit()
					Col.Size = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 2);
				end;
				LibRef:Connection(Layout:GetPropertyChangedSignal("AbsoluteContentSize"), Fit);
				Fit();
			end;
			local function GetColumnsRow()
				if not ColumnsRow then
					ColumnsRow = LibRef:CreateInstance("Frame", {
						Name = "ColumnsRow";
						Parent = Page;
						Size = UDim2.new(1, 0, 0, 0);
						AutomaticSize = TabHasList and Enum.AutomaticSize.Y or Enum.AutomaticSize.None;
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						LayoutOrder = 1;
					});
					if not TabHasList then
						LibRef:CreateInstance("UIFlexItem", {
							Parent = ColumnsRow;
							FlexMode = Enum.UIFlexMode.Fill;
						});
					end;
					LibRef:CreateInstance("UIListLayout", {
						Parent = ColumnsRow;
						FillDirection = Enum.FillDirection.Horizontal;
						HorizontalFlex = Enum.UIFlexAlignment.Fill;
						SortOrder = Enum.SortOrder.LayoutOrder;
						Padding = UDim.new(0, 8);
					});
				end;
				return ColumnsRow;
			end;
			local function ReflowColumnsForList()
				TabHasList = true;
				if not ColumnsRow then return end;
				ColumnsRow.AutomaticSize = Enum.AutomaticSize.Y;
				ColumnsRow.Size = UDim2.new(1, 0, 0, 0);
				local Flex = ColumnsRow:FindFirstChildOfClass("UIFlexItem");
				if Flex then Flex:Destroy() end;
				for _, Col in ColumnsRow:GetChildren() do
					if Col:IsA("ScrollingFrame") then FitListColumn(Col) end;
				end;
			end;
			local function MakeColumn(Order)
				local Col = LibRef:CreateInstance("ScrollingFrame", {
					Name = "Column_" .. Order;
					Parent = GetColumnsRow();
					Size = TabHasList and UDim2.new(0, 0, 0, 0) or UDim2.new(0, 0, 1, 0);
					AutomaticSize = TabHasList and Enum.AutomaticSize.Y or Enum.AutomaticSize.None;
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					LayoutOrder = Order;
					CanvasSize = UDim2.new(0, 0, 0, 0);
					AutomaticCanvasSize = TabHasList and Enum.AutomaticSize.None or Enum.AutomaticSize.Y;
					ScrollingDirection = Enum.ScrollingDirection.Y;
					ScrollBarThickness = 0;
					ScrollBarImageTransparency = 1;
					ClipsDescendants = true;
				});
				LibRef:CreateInstance("UIListLayout", {
					Parent = Col;
					FillDirection = Enum.FillDirection.Vertical;
					SortOrder = Enum.SortOrder.LayoutOrder;
					Padding = UDim.new(0, 8);
				});
				LibRef:CreateInstance("UIPadding", {
					Parent = Col;
					PaddingLeft = UDim.new(0, 1);
					PaddingRight = UDim.new(0, 1);
					PaddingTop = UDim.new(0, 1);
					PaddingBottom = UDim.new(0, 1);
				});
				if TabHasList then FitListColumn(Col) end;
				return Col;
			end;
			local function GetColumn(Side)
				local Key = (Side == "Right" or Side == 2) and "Right" or "Left";
				if not Columns[Key] then
					Columns[Key] = MakeColumn(Key == "Left" and 1 or 2);
				end;
				return Columns[Key];
			end;

			TabObj.Name = TabName;
			TabObj.Button = Btn;
			TabObj.Page = Page;

			local SubTabBar, SubPagesHolder;
			local SubTabs = {};
			local ActiveSubTab = nil;

			local TabColorTween = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
			local SlideTween = TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
			local BasePagePos = Page.Position;
			local function SetActive(Active)
				TabObj.Active = Active;
				if Active then
					Page.Position = BasePagePos + UDim2.fromOffset(22, 0);
					LibRef:Tween(Page, SlideTween, { Position = BasePagePos }):Play();
				else
					LibRef:Tween(Page, SlideTween, { Position = BasePagePos - UDim2.fromOffset(22, 0) }):Play();
				end;
				TabCover:SetAttribute("_fb_BackgroundTransparency", Active and 1 or 0);
				TabFill:SetAttribute("_fb_BackgroundTransparency", Active and 0 or 1);
				LibRef:FadeFrame(Page, Active);
				LibRef:Tween(TabCover, TabColorTween, { BackgroundTransparency = Active and 1 or 0 }):Play();
				LibRef:Tween(TabFill, TabColorTween, { BackgroundTransparency = Active and 0 or 1 }):Play();
				LibRef:Tween(TabLbl, TabColorTween, { TextColor3 = Active and Color3.fromRGB(255, 255, 255) or Palette.Default.TabInactive }):Play();
			end;
			TabObj.SetActive = SetActive;
			SetActive(false);

			LibRef:Connection(Btn.MouseButton1Click, function()
				if WindowObject.ActiveTab == TabObj then return end;
				if WindowObject.ActiveTab then WindowObject.ActiveTab.SetActive(false) end;
				SetActive(true);
				WindowObject.ActiveTab = TabObj;
			end);

			function TabObj:AddSection(SectionName, Side, Opts)
				SectionName = tostring(SectionName or "Section");
				Opts = typeof(Opts) == "table" and Opts or {};

				local Bare = Opts.Bare == true;
				local SectionObj = {};

				local ColParent = Opts.Parent or GetColumn(Side);
				local Frame = LibRef:CreateInstance("Frame", {
					Name = "Section_" .. SectionName;
					Parent = ColParent;
					Size = UDim2.new(1, 0, 0, 0);
					AutomaticSize = Enum.AutomaticSize.Y;
					BackgroundColor3 = Color3.fromRGB(255, 255, 255);
					BackgroundTransparency = Bare and 1 or 0;
					BorderSizePixel = 0;
					LayoutOrder = Bare and 1 or #ColParent:GetChildren();
				});
				if not Bare then
					LibRef:CreateInstance("UIGradient", {
						Parent = Frame;
						Rotation = 90;
						Color = ColorSeq({
							ColorKey(0, Palette.Default.FooterBottom);
							ColorKey(1, Palette.Default.FooterTop);
						});
					});
					LibRef:ApplyDoubleOutline(Frame);

					local HeaderBox = LibRef:CreateInstance("Frame", {
						Name = "HeaderBox";
						Parent = Frame;
						Position = UDim2.new(0, 1, 0, 1);
						Size = UDim2.new(1, -2, 0, 24);
						BackgroundColor3 = Color3.fromRGB(255, 255, 255);
						BorderSizePixel = 0;
						ZIndex = 2;
					});
					LibRef:CreateInstance("UIGradient", {
						Parent = HeaderBox;
						Rotation = 90;
						Color = ColorSeq({
							ColorKey(0, Palette.Default.InnerOutline);
							ColorKey(1, Palette.Default.FooterBottom);
						});
					});

					LibRef:CreateInstance("TextLabel", {
						Name = "Title";
						Parent = HeaderBox;
						Position = UDim2.new(0, 8, 0, 0);
						Size = UDim2.new(1, -16, 1, 0);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						FontFace = Library.Fonts.Proggy;
						Text = SectionName;
						TextColor3 = Palette.Default.TabInactive;
						TextSize = 12;
						TextXAlignment = Enum.TextXAlignment.Left;
						TextYAlignment = Enum.TextYAlignment.Center;
					});
				end;

				local Body = LibRef:CreateInstance("Frame", {
					Name = "Body";
					Parent = Frame;
					Position = Bare and UDim2.new(0, 0, 0, 0) or UDim2.new(0, 10, 0, 30);
					Size = Bare and UDim2.new(1, 0, 0, 0) or UDim2.new(1, -20, 0, 0);
					AutomaticSize = Enum.AutomaticSize.Y;
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
				});
				LibRef:CreateInstance("UIListLayout", {
					Parent = Body;
					FillDirection = Enum.FillDirection.Vertical;
					SortOrder = Enum.SortOrder.LayoutOrder;
					Padding = UDim.new(0, 6);
				});
				LibRef:CreateInstance("UIPadding", {
					Parent = Body;
					PaddingBottom = UDim.new(0, 8);
				});

				SectionObj.Frame = Frame;
				SectionObj.Body = Body;

				function SectionObj:AddToggle(ToggleName, Default, Callback, Opts)
					Opts = typeof(Opts) == "table" and Opts or {};
					local TitleColor = Palette.Default.TabInactive;
					local WarnColor = nil;
					if Opts.danger == true then
						WarnColor = Color3.fromRGB(230, 128, 138);
					elseif Opts.risky == true then
						WarnColor = Color3.fromRGB(236, 210, 138);
					end;
					local Row = LibRef:CreateInstance("Frame", {
						Name = "Toggle_" .. ToggleName;
						Parent = Body;
						Size = UDim2.new(1, 0, 0, 18);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
					});

					local Box = LibRef:CreateInstance("Frame", {
						Name = "Box";
						Parent = Row;
						AnchorPoint = Vector2.new(0, 0.5);
						Position = UDim2.new(0, 0, 0.5, 0);
						Size = UDim2.new(0, 14, 0, 14);
						BackgroundColor3 = Color3.fromRGB(255, 255, 255);
						BorderSizePixel = 0;
					});
					LibRef:CreateInstance("UIGradient", {
						Parent = Box;
						Rotation = 90;
						Color = ColorSeq({
							ColorKey(0, Palette.Default.Top);
							ColorKey(1, Palette.Default.Bottom);
						});
					});
					LibRef:ApplyDoubleOutline(Box);

					local BoxFill = LibRef:CreateInstance("Frame", {
						Name = "Fill";
						Parent = Box;
						Position = UDim2.new(0, 1, 0, 1);
						Size = UDim2.new(1, -2, 1, -2);
						BackgroundColor3 = Palette.Default.Accent;
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						ZIndex = 2;
					});
					LibRef:CreateInstance("UIGradient", {
						Parent = BoxFill;
						Rotation = 90;
						Color = ColorSeq({
							ColorKey(0, Color3.fromRGB(255, 255, 255));
							ColorKey(1, Color3.fromRGB(214, 214, 214));
						});
					});

					local Hit = LibRef:CreateInstance("TextButton", {
						Name = "Hit";
						Parent = Row;
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						AutoButtonColor = false;
						Text = "";
						Size = UDim2.new(1, 0, 1, 0);
					});

					local Lbl = LibRef:CreateInstance("TextLabel", {
						Name = "Label";
						Parent = Row;
						AnchorPoint = Vector2.new(0, 0.5);
						Position = UDim2.new(0, 20, 0.5, -1);
						Size = UDim2.new(1, -40, 1, 0);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						FontFace = Library.Fonts.Proggy;
						Text = ToggleName;
						TextColor3 = TitleColor;
						TextSize = 12;
						TextXAlignment = Enum.TextXAlignment.Left;
						TextYAlignment = Enum.TextYAlignment.Center;
					});
					LibRef:CreateInstance("UIStroke", {
						Parent = Lbl;
						Color = Color3.fromRGB(0, 0, 0);
						Thickness = 1;
						ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
					});

					do
						local Markers = {};
						if WarnColor then
							Markers[#Markers + 1] = string.format('<font color="#%s">[!]</font>', WarnColor:ToHex());
						end;
						if Opts.Tooltip then
							Markers[#Markers + 1] = '<font color="#A9AAC6">[?]</font>';
						end;
						if #Markers > 0 then
							Lbl.RichText = true;
							Lbl.Text = ToggleName .. " " .. table.concat(Markers, " ");
						end;
					end;

					local CompHolder = LibRef:CreateInstance("Frame", {
						Name = "Components";
						Parent = Row;
						AnchorPoint = Vector2.new(1, 0.5);
						Position = UDim2.new(1, 0, 0.5, 0);
						Size = UDim2.new(0, 0, 0, 14);
						AutomaticSize = Enum.AutomaticSize.X;
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						ZIndex = 4;
					});
					LibRef:CreateInstance("UIListLayout", {
						Parent = CompHolder;
						FillDirection = Enum.FillDirection.Horizontal;
						HorizontalAlignment = Enum.HorizontalAlignment.Right;
						VerticalAlignment = Enum.VerticalAlignment.Center;
						SortOrder = Enum.SortOrder.LayoutOrder;
						Padding = UDim.new(0, 4);
					});
					local CompCount, CompWidth = 0, 0;
					local function ReserveComp(W)
						if CompCount > 0 then CompWidth = CompWidth + 4 end;
						CompWidth = CompWidth + W;
						CompCount = CompCount + 1;
						Lbl.Size = UDim2.new(1, -(26 + CompWidth), 1, 0);
					end;

					local State = Default == true;
					local CB = typeof(Callback) == "function" and Callback or function() end;
					local Listeners = {};

					local ToggleObj = {
						Row = Row;
						Box = Box;
						Fill = BoxFill;
						Label = Lbl;
						Dependents = {};
					};
					local FillTween = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

-- ======== TOGGLE SET (patched: keeps FadeFrame attribute in sync) ========
					function ToggleObj:Set(V, Instant)
						State = V == true;
						BoxFill:SetAttribute("_fb_BackgroundTransparency", State and 0 or 1);
						if Instant then
							BoxFill.BackgroundTransparency = State and 0 or 1;
							Lbl.TextColor3 = State and Color3.fromRGB(255, 255, 255) or TitleColor;
						else
							LibRef:Tween(BoxFill, FillTween, { BackgroundTransparency = State and 0 or 1 }):Play();
							LibRef:Tween(Lbl, FillTween, { TextColor3 = State and Color3.fromRGB(255, 255, 255) or TitleColor }):Play();
						end;
						CB(State);
						for _, Fn in Listeners do
							Fn(State);
						end;
					end;
-- ======== /TOGGLE SET ========

					function ToggleObj:Get() return State end;
					function ToggleObj:OnChanged(Fn)
						if typeof(Fn) ~= "function" then return self end;
						table.insert(Listeners, Fn);
						return self;
					end;
					function ToggleObj:DependsOn(Parent, Required)
						if typeof(Parent) ~= "table" or typeof(Parent.OnChanged) ~= "function" then
							return self;
						end;
						Required = Required ~= false;
						table.insert(Parent.Dependents, self);
						local First = true;
						local function Refresh()
							local Show = (Parent:Get() == Required);
							if First then First = false; Row.Visible = Show;
							else LibRef:FadeResize(Row, Show) end;
						end;
						Parent:OnChanged(Refresh);
						Refresh();
						return self;
					end;

					function ToggleObj:AddColorpicker(DefaultColor, Callback, AlphaOrOpts)
						local DefaultAlpha = 1;
						local PickerName = ToggleName;
						if typeof(AlphaOrOpts) == "number" then
							DefaultAlpha = AlphaOrOpts;
						elseif typeof(AlphaOrOpts) == "table" then
							DefaultAlpha = tonumber(AlphaOrOpts.Alpha) or 1;
							PickerName = tostring(AlphaOrOpts.Name or AlphaOrOpts.Text or ToggleName);
						end;
						local InitialColor = typeof(DefaultColor) == "Color3" and DefaultColor or Color3.fromRGB(255, 255, 255);

						local Swatch = LibRef:CreateInstance("TextButton", {
							Name = "ColorpickerSwatch";
							Parent = CompHolder;
							Size = UDim2.new(0, 24, 0, 14);
							AutoButtonColor = false;
							Text = "";
							BackgroundColor3 = Palette.Default.Outline;
							BorderSizePixel = 0;
							LayoutOrder = CompCount + 1;
							ZIndex = 4;
						});
						local SwInline = LibRef:CreateInstance("Frame", {
							Name = "Inline";
							Parent = Swatch;
							Position = UDim2.new(0, 1, 0, 1);
							Size = UDim2.new(1, -2, 1, -2);
							BackgroundColor3 = Palette.Default.InnerOutline;
							BorderSizePixel = 0;
						});
						local SwHandle = LibRef:CreateInstance("Frame", {
							Name = "Handle";
							Parent = SwInline;
							Position = UDim2.new(0, 1, 0, 1);
							Size = UDim2.new(1, -2, 1, -2);
							BackgroundColor3 = Color3.fromRGB(255, 255, 255);
							BorderSizePixel = 0;
						});
						LibRef:CreateInstance("ImageLabel", {
							Name = "Checkers";
							Parent = SwHandle;
							Size = UDim2.new(1, 0, 1, 0);
							BackgroundTransparency = 1;
							BorderSizePixel = 0;
							Image = "rbxassetid://18274452449";
							ScaleType = Enum.ScaleType.Tile;
							TileSize = UDim2.new(0, 6, 0, 6);
							ZIndex = 2;
						});
						local SwFill = LibRef:CreateInstance("Frame", {
							Name = "Fill";
							Parent = SwHandle;
							Size = UDim2.new(1, 0, 1, 0);
							BackgroundColor3 = InitialColor;
							BackgroundTransparency = 1 - DefaultAlpha;
							BorderSizePixel = 0;
							ZIndex = 3;
						});
						LibRef:CreateInstance("UIGradient", {
							Parent = SwFill;
							Rotation = 90;
							Color = ColorSeq({
								ColorKey(0, Color3.fromRGB(255, 255, 255));
								ColorKey(1, Color3.fromRGB(167, 167, 167));
							});
						});

						ReserveComp(24);

						local CpObj = SectionObj:AddColorpicker(PickerName, InitialColor, DefaultAlpha, Callback, {
							Swatch = Swatch;
							SwatchFill = SwFill;
						});
						ToggleObj.Colorpickers = ToggleObj.Colorpickers or {};
						ToggleObj.Colorpickers[#ToggleObj.Colorpickers + 1] = CpObj;
						ToggleObj.Colorpicker = CpObj;
						return ToggleObj;
					end;

function ToggleObj:AddKeybind(Default, Opts)
    Opts = typeof(Opts) == "table" and Opts or {};
    local OnBind = typeof(Opts.Callback) == "function" and Opts.Callback or function() end;

    local function ParseMode(s)
        s = string.lower(tostring(s or "Toggle"));
        if s == "hold" then return "Hold" end;
        if s == "always" then return "Always" end;
        return "Toggle";
    end;
    local Mode = ParseMode(Opts.Mode or "Toggle");

    local CurrentBind = nil;
    local Listening = false;

    local KbBtn = LibRef:CreateInstance("TextButton", {
        Name = "Keybind";
        Parent = CompHolder;
        Size = UDim2.new(0, 56, 0, 15);
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        AutoButtonColor = false;
        BorderSizePixel = 0;
        Text = "";
        AutoLocalize = false;
        LayoutOrder = CompCount + 1;
    });
    ReserveComp(56);
    LibRef:CreateInstance("UIGradient", {
        Parent = KbBtn;
        Rotation = 90;
        Color = ColorSeq({
            ColorKey(0, Palette.Default.Top);
            ColorKey(1, Palette.Default.Bottom);
        });
    });
    LibRef:ApplyDoubleOutline(KbBtn);
    local KbLbl = LibRef:CreateInstance("TextLabel", {
        Name = "Label";
        Parent = KbBtn;
        AnchorPoint = Vector2.new(0.5, 0.5);
        Position = UDim2.new(0.5, 0, 0.5, 0);
        BackgroundTransparency = 1;
        BorderSizePixel = 0;
        Size = UDim2.new(1, 0, 1, 0);
        FontFace = Library.Fonts.Proggy;
        Text = " ";
        TextColor3 = Color3.fromRGB(255, 255, 255);
        TextSize = 12;
        TextXAlignment = Enum.TextXAlignment.Center;
        TextYAlignment = Enum.TextYAlignment.Center;
        ZIndex = 4;
    });
    LibRef:CreateInstance("UIStroke", {
        Parent = KbLbl;
        Color = Color3.fromRGB(0, 0, 0);
        Thickness = 1;
        ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
    });

    local function BindToText(BindValue)
        if BindValue == nil then return " " end;
        local Name = Library.KeyNames[BindValue];
        if Name then return Name end;
        local Raw = tostring(BindValue);
        return (Raw:gsub("Enum.KeyCode.", "")):gsub("Enum.UserInputType.", "");
    end;
    local function InputToBind(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            return input.KeyCode
        elseif input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.MouseButton2
            or input.UserInputType == Enum.UserInputType.MouseButton3 then
            return input.UserInputType;
        end;
        return nil;
    end;
    local function MatchesBind(input)
        if CurrentBind == nil then return false end;
        if input.UserInputType == Enum.UserInputType.Keyboard then
            return input.KeyCode == CurrentBind;
        end;
        return input.UserInputType == CurrentBind;
    end;

    local KbId = "tog_" .. ToggleName .. "_" .. tostring({}):sub(8);
    local function SyncKeybindList()
        local List = Library.KeybindListState;
        if not List then return end;
        if CurrentBind == nil or Mode == "Always" then
            List:Unregister(KbId);
        else
            List:Register(KbId, ToggleName, CurrentBind, State, Mode);
        end;
    end;
    table.insert(Library._KeybindSyncs, SyncKeybindList);

    local function UpdateKbLabel()
        if Mode == "Always" then
            KbLbl.Text = "Always";
        else
            KbLbl.Text = BindToText(CurrentBind);
        end;
    end;

    local function SetBind(BindValue, FireCallback)
        CurrentBind = BindValue;
        UpdateKbLabel();
        SyncKeybindList();
        if FireCallback ~= false then
            OnBind(CurrentBind);
        end;
    end;

    local ModeMenu, ModeMenuItems = nil, nil;
    local SetMode, RefreshModeMenuColors, CloseModeMenu, OpenModeMenu;

    SetMode = function(m)
        Mode = ParseMode(m);
        if Mode == "Always" then
            ToggleObj:Set(true);
        end;
        UpdateKbLabel();
        SyncKeybindList();
        RefreshModeMenuColors();
    end;

    RefreshModeMenuColors = function()
        if not ModeMenuItems then return end
        for _, Entry in ModeMenuItems do
            local C;
            if Entry.Hovered then
                C = Color3.fromRGB(255, 255, 255);
            elseif Entry.Value == Mode then
                C = Palette.Default.TabActive;
            else
                C = Color3.fromRGB(200, 200, 200);
            end;
            Entry.Label.TextColor3 = C;
        end;
    end;

    CloseModeMenu = function()
        if ModeMenu then ModeMenu.Visible = false end;
    end;

    OpenModeMenu = function()
        if not ModeMenu then
            local MGui = KbBtn:FindFirstAncestorOfClass("ScreenGui");
            if not MGui then return end;
            ModeMenu = LibRef:CreateInstance("Frame", {
                Name = "KeybindModeMenu";
                Parent = MGui;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BorderSizePixel = 0;
                Visible = false;
                ClipsDescendants = true;
                ZIndex = 900;
            });
            LibRef:CreateInstance("UIGradient", {
                Parent = ModeMenu;
                Rotation = 90;
                Color = ColorSeq({
                    ColorKey(0, Palette.Default.FooterBottom);
                    ColorKey(1, Palette.Default.FooterTop);
                });
            });
            LibRef:ApplyDoubleOutline(ModeMenu);

            local MList = LibRef:CreateInstance("Frame", {
                Name = "List";
                Parent = ModeMenu;
                BackgroundTransparency = 1;
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 1, 0);
                ZIndex = 901;
            });
            LibRef:CreateInstance("UIPadding", {
                Parent = MList;
                PaddingTop = UDim.new(0, 4);
                PaddingBottom = UDim.new(0, 4);
            });
            LibRef:CreateInstance("UIListLayout", {
                Parent = MList;
                FillDirection = Enum.FillDirection.Vertical;
                SortOrder = Enum.SortOrder.LayoutOrder;
                Padding = UDim.new(0, 3);
            });

            ModeMenuItems = {};
            for I, M in { "Toggle", "Hold", "Always" } do
                local MRow = LibRef:CreateInstance("TextButton", {
                    Name = "Mode_" .. M;
                    Parent = MList;
                    Size = UDim2.new(1, 0, 0, 16);
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    AutoButtonColor = false;
                    Text = "";
                    LayoutOrder = I;
                    ZIndex = 902;
                });
                local MLbl = LibRef:CreateInstance("TextLabel", {
                    Parent = MRow;
                    Position = UDim2.new(0, 8, 0, 0);
                    Size = UDim2.new(1, -16, 1, 0);
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    FontFace = Library.Fonts.Proggy;
                    Text = M;
                    TextColor3 = Color3.fromRGB(200, 200, 200);
                    TextSize = 12;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    TextYAlignment = Enum.TextYAlignment.Center;
                    ZIndex = 903;
                });
                LibRef:CreateInstance("UIStroke", {
                    Parent = MLbl;
                    Color = Color3.fromRGB(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
                });
                local Entry = { Button = MRow, Label = MLbl, Value = M, Hovered = false };
                ModeMenuItems[#ModeMenuItems + 1] = Entry;

                LibRef:Connection(MRow.MouseEnter, function()
                    Entry.Hovered = true;
                    MLbl.TextColor3 = Color3.fromRGB(255, 255, 255);
                end);
                LibRef:Connection(MRow.MouseLeave, function()
                    Entry.Hovered = false;
                    RefreshModeMenuColors();
                end);
                LibRef:Connection(MRow.MouseButton1Click, function()
                    SetMode(Entry.Value);
                    CloseModeMenu();
                end);
            end;
        end;
        local Mp = KbBtn.AbsolutePosition;
        local Ms = KbBtn.AbsoluteSize;
        ModeMenu.Position = UDim2.new(0, Mp.X + Ms.X - 80, 0, Mp.Y + Ms.Y + 2);
        ModeMenu.Size = UDim2.new(0, 80, 0, 62);
        ModeMenu.Visible = true;
        RefreshModeMenuColors();
    end;

    LibRef:Connection(KbBtn.MouseButton2Click, function()
        if ModeMenu and ModeMenu.Visible then
            CloseModeMenu();
        else
            OpenModeMenu();
        end;
    end);

    LibRef:Connection(UserInputService.InputBegan, function(input)
        if not ModeMenu or not ModeMenu.Visible then return end;
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.MouseButton2
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return;
        end;
        local Mp = UserInputService:GetMouseLocation() - Vector2.new(0, GuiInset);
        local function Inside(F)
            if not F then return false end;
            local P, S = F.AbsolutePosition, F.AbsoluteSize;
            return Mp.X >= P.X and Mp.X <= P.X + S.X
                and Mp.Y >= P.Y and Mp.Y <= P.Y + S.Y;
        end;
        if not Inside(ModeMenu) and not Inside(KbBtn) then
            CloseModeMenu();
        end;
    end);

    local OrigSet = ToggleObj.Set;
    function ToggleObj:Set(V)
        OrigSet(self, V);
        local List = Library.KeybindListState;
        if List and CurrentBind ~= nil and Mode ~= "Always" and List.Entries[KbId] then
            List:Update(KbId, nil, nil, State);
        end;
    end;

    if Default ~= nil then SetBind(Default, false) end;

    LibRef:Connection(KbBtn.MouseButton1Click, function()
        if Listening then return end;
        Listening = true;
        KbLbl.Text = "...";
    end);

    LibRef:Connection(UserInputService.InputBegan, function(input, gpe)
        if Listening then
            if input.KeyCode == Enum.KeyCode.Escape then
                SetBind(nil);
                Listening = false;
                return
            end;
            local Bind = InputToBind(input);
            if Bind ~= nil then
                SetBind(Bind);
                Listening = false;
            end;
            return
        end;
        if gpe then return end;
        if not MatchesBind(input) then return end;
        if Mode == "Toggle" then
            ToggleObj:Set(not State)
        elseif Mode == "Hold" then
            ToggleObj:Set(true);
        end;
    end);

    LibRef:Connection(UserInputService.InputEnded, function(input, gpe)
        if gpe then return end;
        if Mode ~= "Hold" then return end;
        if MatchesBind(input) then ToggleObj:Set(false) end;
    end);

    if Mode == "Always" then
        ToggleObj:Set(true);
    end;
    UpdateKbLabel();

    ToggleObj.KeybindButton = KbBtn;
    function ToggleObj:GetBind() return CurrentBind end;
    function ToggleObj:SetBind(v) SetBind(v) end;
    function ToggleObj:GetMode() return Mode end;
    function ToggleObj:SetMode(v) SetMode(v) end;
    return ToggleObj;
end;

					BoxFill.BackgroundTransparency = State and 0 or 1;
					Lbl.TextColor3 = State and Color3.fromRGB(255, 255, 255) or TitleColor;

					LibRef:Connection(Hit.MouseButton1Click, function()
						ToggleObj:Set(not State);
					end);

					do
						local Flag = Opts.Flag or LibRef:AutoFlag("Toggle_" .. ToggleName);
						ToggleObj.Flag = Flag;
						LibRef:RegisterFlag(Flag, State, function(v) ToggleObj:Set(v == true) end);
						ToggleObj:OnChanged(function(v) LibRef.Flags[Flag] = v end);
					end;

					if Opts.Tooltip then LibRef:Tooltip(Row, Opts.Tooltip) end;

					return ToggleObj;
				end;

				function SectionObj:AddButton(BtnName, Callback, Opts)
					local Row = LibRef:CreateInstance("Frame", {
						Name = "ButtonRow";
						Parent = Body;
						Size = UDim2.new(1, 0, 0, 18);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
					});
					LibRef:CreateInstance("UIListLayout", {
						Parent = Row;
						FillDirection = Enum.FillDirection.Horizontal;
						HorizontalFlex = Enum.UIFlexAlignment.Fill;
						VerticalFlex = Enum.UIFlexAlignment.Fill;
						SortOrder = Enum.SortOrder.LayoutOrder;
						Padding = UDim.new(0, 4);
					});

					local ButtonObj = {};
					local Count = 0;

					local function BuildButton(Name, CBArg, O)
						Name = tostring(Name or "Button");
						local CB = typeof(CBArg) == "function" and CBArg or function() end;
						O = typeof(O) == "table" and O or {};
						local Confirm = O.Confirm == true;
						local Pending = false;
						local Caution = Color3.fromRGB(245, 200, 70);
						Count = Count + 1;

						local BtnFrame = LibRef:CreateInstance("Frame", {
							Name = "Btn_" .. Name;
							Parent = Row;
							Size = UDim2.new(1, 0, 1, 0);
							BackgroundColor3 = Color3.fromRGB(255, 255, 255);
							BorderSizePixel = 0;
							LayoutOrder = Count;
						});
						LibRef:CreateInstance("UIGradient", {
							Parent = BtnFrame;
							Rotation = 90;
							Color = ColorSeq({
								ColorKey(0, Palette.Default.Bottom);
								ColorKey(1, Palette.Default.Top);
							});
						});
						LibRef:ApplyDoubleOutline(BtnFrame);

						local Hit = LibRef:CreateInstance("TextButton", {
							Name = "Hit";
							Parent = BtnFrame;
							BackgroundTransparency = 1;
							BorderSizePixel = 0;
							AutoButtonColor = false;
							Text = "";
							Size = UDim2.new(1, 0, 1, 0);
							ZIndex = 5;
						});

						local Lbl = LibRef:CreateInstance("TextLabel", {
							Name = "Label";
							Parent = BtnFrame;
							Position = UDim2.new(0, 0, 0, -1);
							Size = UDim2.new(1, 0, 1, 0);
							BackgroundTransparency = 1;
							BorderSizePixel = 0;
							FontFace = Library.Fonts.Proggy;
							Text = Name;
							TextColor3 = Palette.Default.TabInactive;
							TextSize = 12;
							TextXAlignment = Enum.TextXAlignment.Center;
							TextYAlignment = Enum.TextYAlignment.Center;
							ZIndex = 3;
						});
						LibRef:CreateInstance("UIStroke", {
							Parent = Lbl;
							Color = Color3.fromRGB(0, 0, 0);
							Thickness = 1;
							ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
						});

						local FlashTween = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);
						local HoverTween = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
						local Hovering = false;
						LibRef:Connection(Hit.MouseEnter, function()
							Hovering = true;
							LibRef:Tween(Lbl, HoverTween, { TextColor3 = Color3.fromRGB(255, 255, 255) }):Play();
						end);
						LibRef:Connection(Hit.MouseLeave, function()
							Hovering = false;
							LibRef:Tween(Lbl, HoverTween, { TextColor3 = Pending and Caution or Palette.Default.TabInactive }):Play();
						end);
						LibRef:Connection(Hit.MouseButton1Click, function()
							if Confirm and not Pending then
								Pending = true;
								Lbl.Text = "Are you sure?";
								LibRef:Tween(Lbl, FlashTween, { TextColor3 = Hovering and Color3.fromRGB(255, 255, 255) or Caution }):Play();
								task.delay(2.5, function()
									if Pending then
										Pending = false;
										Lbl.Text = Name;
										LibRef:Tween(Lbl, FlashTween, { TextColor3 = Hovering and Color3.fromRGB(255, 255, 255) or Palette.Default.TabInactive }):Play();
									end;
								end);
								return;
							end;
							Pending = false;
							Lbl.Text = Name;
							Lbl.TextColor3 = Palette.Default.TabActive;
							LibRef:Tween(Lbl, FlashTween, { TextColor3 = Hovering and Color3.fromRGB(255, 255, 255) or Palette.Default.TabInactive }):Play();
							CB();
						end);

						if O.Tooltip then
							LibRef:Tooltip(BtnFrame, O.Tooltip);
						end;

						return BtnFrame, Lbl;
					end;

					local Frame, Label = BuildButton(BtnName, Callback, Opts);
					ButtonObj.Frame = Frame;
					ButtonObj.Label = Label;

					function ButtonObj:AddButton(Name, CBArg, O)
						BuildButton(Name, CBArg, O);
						return ButtonObj;
					end;

					return ButtonObj;
				end;

				function SectionObj:AddSlider(SliderName, Min, Max, Default, Callback)
					Min = tonumber(Min) or 0;
					Max = tonumber(Max) or 100;
					local Value = math.clamp(tonumber(Default) or Min, Min, Max);
					local CB = typeof(Callback) == "function" and Callback or function() end;
					local Step = (Max - Min) <= 10 and 0.1 or 1;

					local Container = LibRef:CreateInstance("Frame", {
						Name = "Slider_" .. SliderName;
						Parent = Body;
						Size = UDim2.new(1, 0, 0, 28);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
					});

					local NameLbl = LibRef:CreateInstance("TextLabel", {
						Name = "Label";
						Parent = Container;
						Position = UDim2.new(0, 0, 0, 0);
						Size = UDim2.new(1, 0, 0, 14);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						FontFace = Library.Fonts.Proggy;
						Text = SliderName;
						TextColor3 = Palette.Default.TabInactive;
						TextSize = 12;
						TextXAlignment = Enum.TextXAlignment.Left;
						TextYAlignment = Enum.TextYAlignment.Center;
					});
					LibRef:CreateInstance("UIStroke", {
						Parent = NameLbl;
						Color = Color3.fromRGB(0, 0, 0);
						Thickness = 1;
						ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
					});

					local Track = LibRef:CreateInstance("Frame", {
						Name = "Track";
						Parent = Container;
						Position = UDim2.new(0, 0, 0, 15);
						Size = UDim2.new(1, 0, 0, 14);
						BackgroundColor3 = Color3.fromRGB(255, 255, 255);
						BorderSizePixel = 0;
					});
					LibRef:CreateInstance("UIGradient", {
						Parent = Track;
						Rotation = 90;
						Color = ColorSeq({
							ColorKey(0, Palette.Default.Top);
							ColorKey(1, Palette.Default.Bottom);
						});
					});
					LibRef:ApplyDoubleOutline(Track);

					local Fill = LibRef:CreateInstance("Frame", {
						Name = "Fill";
						Parent = Track;
						Position = UDim2.new(0, 1, 0, 1);
						Size = UDim2.new(0, 0, 1, -2);
						BackgroundColor3 = Palette.Default.Accent;
						BorderSizePixel = 0;
						ZIndex = 3;
					});
					LibRef:CreateInstance("UIGradient", {
						Parent = Fill;
						Rotation = 90;
						Color = ColorSeq({
							ColorKey(0, Color3.fromRGB(255, 255, 255));
							ColorKey(1, Color3.fromRGB(214, 214, 214));
						});
					});

					local ValueLbl = LibRef:CreateInstance("TextLabel", {
						Name = "Value";
						Parent = Track;
						AnchorPoint = Vector2.new(0.5, 0.5);
						Position = UDim2.new(0.5, 0, 0.5, -1);
						Size = UDim2.new(1, 0, 1, 0);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						FontFace = Library.Fonts.Proggy;
						Text = tostring(Value);
						TextColor3 = Color3.fromRGB(255, 255, 255);
						TextSize = 12;
						TextXAlignment = Enum.TextXAlignment.Center;
						TextYAlignment = Enum.TextYAlignment.Center;
						ZIndex = 5;
					});
					LibRef:CreateInstance("UIStroke", {
						Parent = ValueLbl;
						Color = Color3.fromRGB(0, 0, 0);
						Thickness = 1;
						ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
					});

					local Hit = LibRef:CreateInstance("TextButton", {
						Name = "Hit";
						Parent = Track;
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						AutoButtonColor = false;
						Text = "";
						Size = UDim2.new(1, 0, 1, 0);
						ZIndex = 4;
					});

					local StepHolder = LibRef:CreateInstance("Frame", {
						Name = "Stepper";
						Parent = Container;
						AnchorPoint = Vector2.new(1, 0);
						Position = UDim2.new(1, 10, 0, 0);
						Size = UDim2.new(0, 40, 0, 14);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						ZIndex = 6;
					});
					LibRef:CreateInstance("UIListLayout", {
						Parent = StepHolder;
						FillDirection = Enum.FillDirection.Horizontal;
						HorizontalAlignment = Enum.HorizontalAlignment.Right;
						VerticalAlignment = Enum.VerticalAlignment.Center;
						SortOrder = Enum.SortOrder.LayoutOrder;
						Padding = UDim.new(0, 8);
					});
					local function MakeStep(Txt, Order)
						local B = LibRef:CreateInstance("TextButton", {
							Name = Txt == "+" and "Plus" or "Minus";
							Parent = StepHolder;
							BackgroundTransparency = 1;
							AutoButtonColor = false;
							BorderSizePixel = 0;
							AutomaticSize = Enum.AutomaticSize.X;
							Size = UDim2.new(0, 0, 1, 0);
							FontFace = Library.Fonts.Proggy;
							Text = Txt;
							TextColor3 = Color3.fromRGB(255, 255, 255);
							TextTransparency = 1;
							TextSize = 14;
							TextXAlignment = Enum.TextXAlignment.Center;
							TextYAlignment = Enum.TextYAlignment.Center;
							LayoutOrder = Order;
							ZIndex = 6;
						});
						local St = LibRef:CreateInstance("UIStroke", {
							Parent = B;
							Color = Color3.fromRGB(0, 0, 0);
							Thickness = 1;
							Transparency = 1;
							ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
						});
						return B, St;
					end;
					local MinusBtn, MinusStroke = MakeStep("-", 1);
					local PlusBtn, PlusStroke = MakeStep("+", 2);

					local FillTween = TweenInfo.new(0.12, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut);
					local function Render(Animate)
						local T = Max == Min and 0 or (Value - Min) / (Max - Min);
						local Goal = UDim2.new(T, T == 0 and 0 or -2, 1, -2);
						if Animate == false then Fill.Size = Goal else LibRef:Tween(Fill, FillTween, { Size = Goal }):Play() end;
						ValueLbl.Text = string.format("%.1f", Value);
					end;
					Render(false);

					local Dragging = false;
					local function UpdateFromX(Px)
						local AbsX = Track.AbsolutePosition.X;
						local AbsW = Track.AbsoluteSize.X;
						if AbsW <= 0 then return end;
						local T = math.clamp((Px - AbsX) / AbsW, 0, 1);
						Value = Min + T * (Max - Min);
						Render();
						CB(Value);
					end;

					LibRef:Connection(Hit.InputBegan, function(Input)
						if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
							Dragging = true;
							UpdateFromX(Input.Position.X);
						end
					end);
					LibRef:Connection(Hit.InputEnded, function(Input)
						if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
							Dragging = false;
						end
					end);
					LibRef:Connection(UserInputService.InputChanged, function(Input)
						if not Dragging then return end;
						if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
							UpdateFromX(Input.Position.X);
						end
					end);

					local SliderObj = { Container = Container, Track = Track, Fill = Fill, Label = NameLbl, ValueLabel = ValueLbl };
					function SliderObj:Get() return Value end;
					function SliderObj:Set(V)
						Value = math.clamp(tonumber(V) or Value, Min, Max);
						Render();
						CB(Value);
						if self.Flag then LibRef.Flags[self.Flag] = Value end;
					end;
					function SliderObj:DependsOn(Parent, Required)
						if typeof(Parent) ~= "table" or typeof(Parent.OnChanged) ~= "function" then
							return self;
						end;
						Required = Required ~= false;
						if typeof(Parent.Dependents) == "table" then
							table.insert(Parent.Dependents, self);
						end;
						local First = true;
						local function Refresh()
							local Show = (Parent:Get() == Required);
							if First then First = false; Container.Visible = Show;
							else LibRef:FadeResize(Container, Show) end;
						end;
						Parent:OnChanged(Refresh);
						Refresh();
						return self;
					end;

					do
						local Flag = LibRef:AutoFlag("Slider_" .. SliderName);
						SliderObj.Flag = Flag;
						LibRef:RegisterFlag(Flag, Value, function(v) SliderObj:Set(v) end);
					end;

					local StepTween = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
					local StepShown = false;
					local function SetStepper(On)
						StepShown = On;
						local Goal = On and 0 or 1;
						LibRef:Tween(StepHolder, StepTween, { Position = UDim2.new(1, On and 0 or 10, 0, 0) }):Play();
						LibRef:Tween(MinusBtn, StepTween, { TextTransparency = Goal }):Play();
						LibRef:Tween(PlusBtn, StepTween, { TextTransparency = Goal }):Play();
						LibRef:Tween(MinusStroke, StepTween, { Transparency = Goal }):Play();
						LibRef:Tween(PlusStroke, StepTween, { Transparency = Goal }):Play();
					end;
					LibRef:Connection(Container.MouseEnter, function() SetStepper(true) end);
					LibRef:Connection(Container.MouseLeave, function() SetStepper(false) end);
					LibRef:Connection(MinusBtn.MouseButton1Click, function()
						if StepShown then SliderObj:Set(Value - Step) end;
					end);
					LibRef:Connection(PlusBtn.MouseButton1Click, function()
						if StepShown then SliderObj:Set(Value + Step) end;
					end);

					return SliderObj;
				end;

				function SectionObj:AddColorpicker(Name, DefaultColor, DefaultAlpha, Callback, MountInline)
					local Color = typeof(DefaultColor) == "Color3" and DefaultColor or Color3.fromRGB(255, 255, 255);
					local Alpha = tonumber(DefaultAlpha) or 1;
					local CB = typeof(Callback) == "function" and Callback or function() end;
					local H, S, V = Color:ToHSV();
					local A = math.clamp(Alpha, 0, 1);

					local Swatch, SwatchFill;
					if typeof(MountInline) == "table" and MountInline.Swatch then
						Swatch = MountInline.Swatch;
						SwatchFill = MountInline.SwatchFill;
					else
						local Row = LibRef:CreateInstance("Frame", {
							Name = "Colorpicker_" .. Name;
							Parent = Body;
							Size = UDim2.new(1, 0, 0, 18);
							BackgroundTransparency = 1;
							BorderSizePixel = 0;
						});

						local Lbl = LibRef:CreateInstance("TextLabel", {
							Name = "Label";
							Parent = Row;
							AnchorPoint = Vector2.new(0, 0.5);
							Position = UDim2.new(0, 0, 0.5, 0);
							Size = UDim2.new(1, -32, 1, 0);
							BackgroundTransparency = 1;
							BorderSizePixel = 0;
							FontFace = Library.Fonts.Proggy;
							Text = Name;
							TextColor3 = Palette.Default.TabInactive;
							TextSize = 12;
							TextXAlignment = Enum.TextXAlignment.Left;
							TextYAlignment = Enum.TextYAlignment.Center;
						});
						LibRef:CreateInstance("UIStroke", {
							Parent = Lbl;
							Color = Color3.fromRGB(0, 0, 0);
							Thickness = 1;
							ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
						});

						Swatch = LibRef:CreateInstance("TextButton", {
							Name = "Swatch";
							Parent = Row;
							AnchorPoint = Vector2.new(1, 0.5);
							Position = UDim2.new(1, 0, 0.5, 0);
							Size = UDim2.new(0, 24, 0, 14);
							AutoButtonColor = false;
							Text = "";
							BackgroundColor3 = Palette.Default.Outline;
							BorderSizePixel = 0;
						});
						local SwatchInline = LibRef:CreateInstance("Frame", {
							Name = "Inline";
							Parent = Swatch;
							Position = UDim2.new(0, 1, 0, 1);
							Size = UDim2.new(1, -2, 1, -2);
							BackgroundColor3 = Palette.Default.InnerOutline;
							BorderSizePixel = 0;
						});
						local SwatchHandle = LibRef:CreateInstance("Frame", {
							Name = "Handle";
							Parent = SwatchInline;
							Position = UDim2.new(0, 1, 0, 1);
							Size = UDim2.new(1, -2, 1, -2);
							BackgroundColor3 = Color3.fromRGB(255, 255, 255);
							BorderSizePixel = 0;
						});
						LibRef:CreateInstance("ImageLabel", {
							Name = "Checkers";
							Parent = SwatchHandle;
							Size = UDim2.new(1, 0, 1, 0);
							BackgroundTransparency = 1;
							BorderSizePixel = 0;
							Image = "rbxassetid://18274452449";
							ScaleType = Enum.ScaleType.Tile;
							TileSize = UDim2.new(0, 6, 0, 6);
							ZIndex = 2;
						});
						SwatchFill = LibRef:CreateInstance("Frame", {
							Name = "Fill";
							Parent = SwatchHandle;
							Size = UDim2.new(1, 0, 1, 0);
							BackgroundColor3 = Color;
							BackgroundTransparency = 1 - Alpha;
							BorderSizePixel = 0;
							ZIndex = 3;
						});
						LibRef:CreateInstance("UIGradient", {
							Parent = SwatchFill;
							Rotation = 90;
							Color = ColorSeq({
								ColorKey(0, Color3.fromRGB(255, 255, 255));
								ColorKey(1, Color3.fromRGB(167, 167, 167));
							});
						});
					end;

					local PickerHolder = LibRef:CreateInstance("Frame", {
						Name = "Picker_" .. Name;
						Parent = Gui;
						Size = UDim2.new(0, 190, 0, 180);
						BackgroundColor3 = Palette.Default.ContentBg;
						BorderSizePixel = 0;
						Visible = false;
						ClipsDescendants = true;
						ZIndex = 50;
					});
					LibRef:CreateInstance("UIStroke", {
						Parent = PickerHolder;
						Color = Palette.Default.Outline;
						Thickness = 1;
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
					});
					local PickerInner = LibRef:CreateInstance("Frame", {
						Name = "InnerOutline";
						Parent = PickerHolder;
						Position = UDim2.new(0, 1, 0, 1);
						Size = UDim2.new(1, -2, 1, -2);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						ZIndex = 51;
					});
					LibRef:CreateInstance("UIStroke", {
						Parent = PickerInner;
						Color = Palette.Default.InnerOutline;
						Thickness = 1;
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
					});
					local PickerBody = LibRef:CreateInstance("Frame", {
						Name = "Body";
						Parent = PickerHolder;
						Size = UDim2.new(1, 0, 1, 0);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						ZIndex = 52;
					});
					LibRef:CreateInstance("UIPadding", {
						Parent = PickerBody;
						PaddingTop = UDim.new(0, 8);
						PaddingBottom = UDim.new(0, 8);
						PaddingLeft = UDim.new(0, 8);
						PaddingRight = UDim.new(0, 8);
					});

					local MainBg = LibRef:CreateInstance("Frame", {
						Name = "Main";
						Parent = PickerBody;
						Size = UDim2.new(1, 0, 1, 0);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						ZIndex = 53;
					});

					local SatValArea = LibRef:CreateInstance("Frame", {
						Name = "SatVal";
						Parent = MainBg;
						Size = UDim2.new(1, -30, 1, 0);
						BackgroundColor3 = Color3.fromRGB(255, 0, 0);
						BorderSizePixel = 0;
						ZIndex = 55;
					});
					LibRef:CreateInstance("UIStroke", {
						Parent = SatValArea;
						Color = Palette.Default.Outline;
						Thickness = 1;
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
					});
					local SatLayer = LibRef:CreateInstance("TextButton", {
						Name = "Sat";
						Parent = SatValArea;
						Size = UDim2.new(1, 0, 1, 0);
						BackgroundColor3 = Color3.fromRGB(255, 255, 255);
						BorderSizePixel = 0;
						AutoButtonColor = false;
						Text = "";
						ZIndex = 56;
					});
					LibRef:CreateInstance("UIGradient", {
						Parent = SatLayer;
						Rotation = 270;
						Transparency = NumSeq({
							NumKey(0, 0);
							NumKey(1, 1);
						});
						Color = ColorSeq({
							ColorKey(0, Color3.fromRGB(0, 0, 0));
							ColorKey(1, Color3.fromRGB(0, 0, 0));
						});
					});
					local ValLayer = LibRef:CreateInstance("TextButton", {
						Name = "Val";
						Parent = SatValArea;
						Size = UDim2.new(1, 0, 1, 0);
						BackgroundColor3 = Color3.fromRGB(255, 255, 255);
						BorderSizePixel = 0;
						AutoButtonColor = false;
						Text = "";
						ZIndex = 57;
					});
					LibRef:CreateInstance("UIGradient", {
						Parent = ValLayer;
						Transparency = NumSeq({
							NumKey(0, 0);
							NumKey(1, 1);
						});
					});
					local SatValMarker = LibRef:CreateInstance("Frame", {
						Name = "Marker";
						Parent = SatValArea;
						Size = UDim2.new(0, 2, 0, 2);
						BorderSizePixel = 1;
						BorderColor3 = Color3.fromRGB(0, 0, 0);
						BackgroundColor3 = Color3.fromRGB(255, 255, 255);
						ZIndex = 58;
					});

					local HueArea = LibRef:CreateInstance("TextButton", {
						Name = "Hue";
						Parent = MainBg;
						AnchorPoint = Vector2.new(1, 0);
						Position = UDim2.new(1, -14, 0, 0);
						Size = UDim2.new(0, 12, 1, 0);
						BackgroundColor3 = Color3.fromRGB(255, 255, 255);
						BorderSizePixel = 0;
						AutoButtonColor = false;
						Text = "";
						ZIndex = 55;
					});
					LibRef:CreateInstance("UIStroke", {
						Parent = HueArea;
						Color = Palette.Default.Outline;
						Thickness = 1;
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
					});
					LibRef:CreateInstance("UIGradient", {
						Parent = HueArea;
						Rotation = 270;
						Color = ColorSeq({
							ColorKey(0, Color3.fromRGB(255, 0, 0));
							ColorKey(0.17, Color3.fromRGB(255, 255, 0));
							ColorKey(0.33, Color3.fromRGB(0, 255, 0));
							ColorKey(0.5, Color3.fromRGB(0, 255, 255));
							ColorKey(0.67, Color3.fromRGB(0, 0, 255));
							ColorKey(0.83, Color3.fromRGB(255, 0, 255));
							ColorKey(1, Color3.fromRGB(255, 0, 0));
						});
					});
					local HueMarker = LibRef:CreateInstance("Frame", {
						Name = "Marker";
						Parent = HueArea;
						Size = UDim2.new(1, 0, 0, 2);
						BorderSizePixel = 1;
						BorderColor3 = Color3.fromRGB(0, 0, 0);
						BackgroundColor3 = Color3.fromRGB(255, 255, 255);
						ZIndex = 56;
					});

					local AlphaArea = LibRef:CreateInstance("TextButton", {
						Name = "Alpha";
						Parent = MainBg;
						AnchorPoint = Vector2.new(1, 0);
						Position = UDim2.new(1, 0, 0, 0);
						Size = UDim2.new(0, 12, 1, 0);
						BackgroundColor3 = Color;
						BorderSizePixel = 0;
						AutoButtonColor = false;
						Text = "";
						ZIndex = 55;
					});
					LibRef:CreateInstance("UIStroke", {
						Parent = AlphaArea;
						Color = Palette.Default.Outline;
						Thickness = 1;
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
					});
					local AlphaCheckers = LibRef:CreateInstance("ImageLabel", {
						Name = "Checkers";
						Parent = AlphaArea;
						Size = UDim2.new(1, 0, 1, 0);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						Image = "rbxassetid://18274452449";
						ScaleType = Enum.ScaleType.Tile;
						TileSize = UDim2.new(0, 6, 0, 6);
						ZIndex = 56;
					});
					LibRef:CreateInstance("UIGradient", {
						Parent = AlphaCheckers;
						Rotation = 270;
						Transparency = NumSeq({
							NumKey(0, 0);
							NumKey(1, 1);
						});
					});
					local AlphaMarker = LibRef:CreateInstance("Frame", {
						Name = "Marker";
						Parent = AlphaArea;
						Size = UDim2.new(1, 0, 0, 2);
						BackgroundColor3 = Color3.fromRGB(255, 255, 255);
						BorderSizePixel = 1;
						BorderColor3 = Color3.fromRGB(0, 0, 0);
						ZIndex = 57;
					});

					local CpObj = {};
					local CpFlag = nil;

					local function ApplyState()
						local C = Color3.fromHSV(H, S, V);
						Color = C;
						SwatchFill.BackgroundColor3 = C;
						SwatchFill.BackgroundTransparency = 1 - A;
						SwatchFill:SetAttribute("_fb_BackgroundTransparency", 1 - A);
						AlphaArea.BackgroundColor3 = C;
						SatValArea.BackgroundColor3 = Color3.fromHSV(H, 1, 1);

						local SOff = (S < 1) and 0 or -3;
						local VOff = ((1 - V) < 1) and 0 or -3;
						SatValMarker.Position = UDim2.new(S, SOff, 1 - V, VOff);

						local HOff = ((1 - H) < 1) and 0 or -2;
						HueMarker.Position = UDim2.new(0, 0, 1 - H, HOff);

						local AOff = ((1 - A) < 1) and 0 or -2;
						AlphaMarker.Position = UDim2.new(0, 0, 1 - A, AOff);

						CB(C, A);
					end;

					function CpObj:Get() return Color, A end;
					function CpObj:Set(NewColor, NewAlpha)
						if typeof(NewColor) == "Color3" then H, S, V = NewColor:ToHSV() end;
						if NewAlpha then A = math.clamp(NewAlpha, 0, 1) end;
						ApplyState();
						if CpFlag then LibRef.Flags[CpFlag] = { Type = "Colorpicker"; Hex = Color:ToHex(); Alpha = A }; end;
					end;

					ApplyState();

					local DraggingSat, DraggingHue, DraggingAlpha = false, false, false;
					local Open = false;
					local function PositionPicker()
						local AbsP = Swatch.AbsolutePosition;
						PickerHolder.Position = UDim2.new(0, AbsP.X - PickerHolder.AbsoluteSize.X + Swatch.AbsoluteSize.X, 0, AbsP.Y + Swatch.AbsoluteSize.Y + 69);
					end;
					local CpTween = TweenInfo.new(0.13, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
					local CpFadeItems = {};
					CpFadeItems[#CpFadeItems + 1] = { PickerHolder, "BackgroundTransparency", PickerHolder.BackgroundTransparency };
					for _, D in PickerHolder:GetDescendants() do
						if D:IsA("GuiObject") then
							CpFadeItems[#CpFadeItems + 1] = { D, "BackgroundTransparency", D.BackgroundTransparency };
							if D:IsA("TextLabel") or D:IsA("TextButton") or D:IsA("TextBox") then
								CpFadeItems[#CpFadeItems + 1] = { D, "TextTransparency", D.TextTransparency };
							end;
							if D:IsA("ImageLabel") or D:IsA("ImageButton") then
								CpFadeItems[#CpFadeItems + 1] = { D, "ImageTransparency", D.ImageTransparency };
							end;
						elseif D:IsA("UIStroke") then
							CpFadeItems[#CpFadeItems + 1] = { D, "Transparency", D.Transparency };
						end;
					end;
					local function SetCpFade(Shown, Animate)
						for _, E in CpFadeItems do
							local Goal = Shown and E[3] or 1;
							if Animate then
								LibRef:Tween(E[1], CpTween, { [E[2]] = Goal }):Play();
							else
								E[1][E[2]] = Goal;
							end;
						end;
					end;
					local function SetVisible(B)
						Open = B;
						if B then
							PositionPicker();
							PickerHolder.Size = UDim2.new(0, 190, 0, 0);
							SetCpFade(false, false);
							PickerHolder.Visible = true;
							LibRef:Tween(PickerHolder, CpTween, { Size = UDim2.new(0, 190, 0, 180) }):Play();
							SetCpFade(true, true);
						else
							local T = LibRef:Tween(PickerHolder, CpTween, { Size = UDim2.new(0, 190, 0, 0) });
							T.Completed:Connect(function()
								if not Open then PickerHolder.Visible = false end;
							end);
							T:Play();
							SetCpFade(false, true);
						end;
					end;

					local function HookDown(Inst, Setter)
						LibRef:Connection(Inst.InputBegan, function(Input)
							if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
								Setter(true);
							end;
						end);
					end;

					LibRef:Connection(Swatch.MouseButton1Click, function() SetVisible(not Open) end);
					HookDown(SatLayer, function(B) DraggingSat = B end);
					HookDown(ValLayer, function(B) DraggingSat = B end);
					HookDown(HueArea, function(B) DraggingHue = B end);
					HookDown(AlphaArea, function(B) DraggingAlpha = B end);

					LibRef:Connection(UserInputService.InputEnded, function(Input)
						if Input.UserInputType == Enum.UserInputType.MouseButton1 then
							local WasDragging = DraggingSat or DraggingHue or DraggingAlpha;
							DraggingSat = false;
							DraggingHue = false;
							DraggingAlpha = false;
							if WasDragging and CpFlag then
								LibRef.Flags[CpFlag] = { Type = "Colorpicker"; Hex = Color:ToHex(); Alpha = A };
							end;
						end
					end);

					LibRef:Connection(UserInputService.InputChanged, function(Input)
						if Input.UserInputType ~= Enum.UserInputType.MouseMovement then return end;
						if not (DraggingSat or DraggingHue or DraggingAlpha) then return end;
						local M = UserInputService:GetMouseLocation();
						local Mx, My = M.X, M.Y - GuiInset;
						if DraggingSat then
							local Ap = SatValArea.AbsolutePosition;
							local Sz = SatValArea.AbsoluteSize;
							S = Sz.X > 0 and math.clamp((Mx - Ap.X) / Sz.X, 0, 1) or 0;
							V = Sz.Y > 0 and 1 - math.clamp((My - Ap.Y) / Sz.Y, 0, 1) or 0
						elseif DraggingHue then
							local Ap = HueArea.AbsolutePosition;
							local Sz = HueArea.AbsoluteSize;
							H = Sz.Y > 0 and 1 - math.clamp((My - Ap.Y) / Sz.Y, 0, 1) or 0
						elseif DraggingAlpha then
							local Ap = AlphaArea.AbsolutePosition;
							local Sz = AlphaArea.AbsoluteSize;
							A = Sz.Y > 0 and 1 - math.clamp((My - Ap.Y) / Sz.Y, 0, 1) or 0;
						end;
						ApplyState();
					end);

					LibRef:Connection(UserInputService.InputBegan, function(Input)
						if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end;
						if not Open then return end;
						local M = UserInputService:GetMouseLocation();
						local Mx, My = M.X, M.Y - GuiInset;
						local function Inside(F)
							local Ap, Sz = F.AbsolutePosition, F.AbsoluteSize;
							return Mx >= Ap.X and Mx <= Ap.X + Sz.X and My >= Ap.Y and My <= Ap.Y + Sz.Y;
						end;
						if not Inside(PickerHolder) and not Inside(Swatch) then
							SetVisible(false);
						end;
					end);

					do
						local Flag = LibRef:AutoFlag("Color_" .. Name);
						CpObj.Flag = Flag;
						CpFlag = Flag;
						LibRef:RegisterFlag(Flag, { Type = "Colorpicker", Hex = Color:ToHex(), Alpha = A }, function(v)
							if typeof(v) == "table" and typeof(v.Hex) == "string" then
								local C = Color3.fromHex(v.Hex);
								CpObj:Set(C, tonumber(v.Alpha) or A);
							end;
						end);
					end;

					return CpObj;
				end;

				function SectionObj:AddDropdown(DDName, Options, Default, Callback, Opts)
					DDName = tostring(DDName or "Dropdown");
					Options = typeof(Options) == "table" and Options or {};
					local CB = typeof(Callback) == "function" and Callback or function() end;
					Opts = typeof(Opts) == "table" and Opts or {};
					local Multi = Opts.Multi == true;

					local function NormMulti(V)
						local T = {};
						if typeof(V) == "table" then
							for _, X in V do T[#T + 1] = tostring(X) end;
						elseif V ~= nil and V ~= "" then
							T[#T + 1] = tostring(V);
						end;
						return T;
					end;

					local Row = LibRef:CreateInstance("Frame", {
						Name = "Dropdown_" .. DDName;
						Parent = Body;
						Size = UDim2.new(1, 0, 0, 18);
						BackgroundColor3 = Color3.fromRGB(255, 255, 255);
						BorderSizePixel = 0;
					});
					LibRef:CreateInstance("UIGradient", {
						Parent = Row;
						Rotation = 90;
						Color = ColorSeq({
							ColorKey(0, Palette.Default.Bottom);
							ColorKey(1, Palette.Default.Top);
						});
					});
					LibRef:ApplyDoubleOutline(Row);

					local Hit = LibRef:CreateInstance("TextButton", {
						Name = "Hit";
						Parent = Row;
						BackgroundTransparency = 1;
						AutoButtonColor = false;
						Text = "";
						BorderSizePixel = 0;
						Size = UDim2.new(1, 0, 1, 0);
						ZIndex = 5;
					});
					local Lbl = LibRef:CreateInstance("TextLabel", {
						Name = "Label";
						Parent = Row;
						Position = UDim2.new(0, 8, 0, 0);
						Size = UDim2.new(1, -28, 1, 0);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						FontFace = Library.Fonts.Proggy;
						TextSize = 12;
						TextColor3 = Palette.Default.TabInactive;
						TextXAlignment = Enum.TextXAlignment.Left;
						TextYAlignment = Enum.TextYAlignment.Center;
						Text = tostring(Default or Options[1] or DDName);
					});
					LibRef:CreateInstance("UIStroke", {
						Parent = Lbl;
						Color = Color3.fromRGB(0, 0, 0);
						Thickness = 1;
						ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
					});
					local Sign = LibRef:CreateInstance("TextLabel", {
						Name = "Sign";
						Parent = Row;
						AnchorPoint = Vector2.new(1, 0.5);
						Position = UDim2.new(1, -8, 0.5, 0);
						Size = UDim2.new(0, 12, 1, 0);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						FontFace = Library.Fonts.Proggy;
						Text = "+";
						TextColor3 = Color3.fromRGB(255, 255, 255);
						TextSize = 12;
						TextXAlignment = Enum.TextXAlignment.Center;
						TextYAlignment = Enum.TextYAlignment.Center;
					});
					LibRef:CreateInstance("UIStroke", {
						Parent = Sign;
						Color = Color3.fromRGB(0, 0, 0);
						Thickness = 1;
						ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
					});

					local Selected;
					if Multi then
						Selected = NormMulti(Default);
					else
						Selected = tostring(Default or Options[1] or "");
					end;
					local IsOpen = false;
					local Buttons = {};
					local Popup, PopupList;

					local DropdownObj = { Row = Row };

					local function IsSelectedVal(Val)
						if Multi then return table.find(Selected, Val) ~= nil end;
						return Selected == Val;
					end;
					local function DisplayText()
						if Multi then
							if #Selected == 0 then return "None" end;
							return table.concat(Selected, ", ");
						end;
						return Selected;
					end;
					Lbl.Text = DisplayText();

					local OptTween = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
					local function RefreshButtonColors()
						for _, B in Buttons do
							local C;
							if B.Hovered then
								C = Color3.fromRGB(255, 255, 255);
							elseif IsSelectedVal(B.Value) then
								C = Palette.Default.TabActive;
							else
								C = Color3.fromRGB(200, 200, 200);
							end;
							LibRef:Tween(B.Label, OptTween, { TextColor3 = C }):Play();
						end;
					end;

					function DropdownObj:Get()
						if Multi then
							local T = {};
							for _, V in Selected do T[#T + 1] = V end;
							return T;
						end;
						return Selected;
					end;
					function DropdownObj:Set(v)
						if Multi then
							Selected = NormMulti(v);
						else
							Selected = tostring(v);
						end;
						Lbl.Text = DisplayText();
						RefreshButtonColors();
						CB(self:Get());
						if self.Flag then LibRef.Flags[self.Flag] = self:Get() end;
					end;
					function DropdownObj:Toggle(Val)
						if not Multi then self:Set(Val); return end;
						local Idx = table.find(Selected, Val);
						if Idx then table.remove(Selected, Idx) else Selected[#Selected + 1] = Val end;
						Lbl.Text = DisplayText();
						RefreshButtonColors();
						CB(self:Get());
						if self.Flag then LibRef.Flags[self.Flag] = self:Get() end;
					end;
					function DropdownObj:DependsOn(Parent, Required)
						if typeof(Parent) ~= "table" or typeof(Parent.OnChanged) ~= "function" then
							return self;
						end;
						Required = Required ~= false;
						if typeof(Parent.Dependents) == "table" then
							table.insert(Parent.Dependents, self);
						end;
						local First = true;
						local function Refresh()
							local Show = (Parent:Get() == Required);
							if First then First = false; Row.Visible = Show;
							else LibRef:FadeResize(Row, Show) end;
						end;
						Parent:OnChanged(Refresh);
						Refresh();
						return self;
					end;

					local DDTween = TweenInfo.new(0.13, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
					local FadeItems = {};
					local function BuildFade()
						table.clear(FadeItems);
						FadeItems[#FadeItems + 1] = { Popup, "BackgroundTransparency", Popup.BackgroundTransparency };
						for _, D in Popup:GetDescendants() do
							if D:IsA("GuiObject") then
								FadeItems[#FadeItems + 1] = { D, "BackgroundTransparency", D.BackgroundTransparency };
								if D:IsA("TextLabel") or D:IsA("TextButton") or D:IsA("TextBox") then
									FadeItems[#FadeItems + 1] = { D, "TextTransparency", D.TextTransparency };
								end;
								if D:IsA("ImageLabel") or D:IsA("ImageButton") then
									FadeItems[#FadeItems + 1] = { D, "ImageTransparency", D.ImageTransparency };
								end;
							elseif D:IsA("UIStroke") then
								FadeItems[#FadeItems + 1] = { D, "Transparency", D.Transparency };
							end;
						end;
					end;
					local function SetFade(Shown, Animate)
						for _, E in FadeItems do
							local Goal = Shown and E[3] or 1;
							if Animate then
								LibRef:Tween(E[1], DDTween, { [E[2]] = Goal }):Play();
							else
								E[1][E[2]] = Goal;
							end;
						end;
					end;
					local function PopupHeight()
						local N = #Options;
						return (N * 16) + (math.max(0, N - 1) * 3) + 8;
					end;
					local function PositionPopup()
						if not Popup then return end;
						local Rp, Rs = Row.AbsolutePosition, Row.AbsoluteSize;
						Popup.Position = UDim2.new(0, Rp.X, 0, Rp.Y + Rs.Y + 63);
						Popup.Size = UDim2.new(0, Rs.X, 0, IsOpen and PopupHeight() or 0);
					end;

					local function BuildPopup()
						local Gui = Row:FindFirstAncestorOfClass("ScreenGui");
						if not Gui then return end;

						Popup = LibRef:CreateInstance("Frame", {
							Name = "DropdownPopup_" .. DDName;
							Parent = Gui;
							BackgroundColor3 = Color3.fromRGB(255, 255, 255);
							BorderSizePixel = 0;
							Visible = false;
							ClipsDescendants = true;
							ZIndex = 500;
						});
						LibRef:CreateInstance("UIGradient", {
							Parent = Popup;
							Rotation = 90;
							Color = ColorSeq({
								ColorKey(0, Palette.Default.FooterBottom);
								ColorKey(1, Palette.Default.FooterTop);
							});
						});
						LibRef:ApplyDoubleOutline(Popup);

						PopupList = LibRef:CreateInstance("Frame", {
							Name = "List";
							Parent = Popup;
							BackgroundTransparency = 1;
							BorderSizePixel = 0;
							Size = UDim2.new(1, 0, 1, 0);
							ZIndex = 501;
						});
						LibRef:CreateInstance("UIPadding", {
							Parent = PopupList;
							PaddingTop = UDim.new(0, 4);
							PaddingBottom = UDim.new(0, 4);
						});
						LibRef:CreateInstance("UIListLayout", {
							Parent = PopupList;
							FillDirection = Enum.FillDirection.Vertical;
							SortOrder = Enum.SortOrder.LayoutOrder;
							Padding = UDim.new(0, 3);
						});

						for I, Opt in Options do
							local OptStr = tostring(Opt);
							local OptRow = LibRef:CreateInstance("TextButton", {
								Name = "Opt_" .. tostring(I);
								Parent = PopupList;
								Size = UDim2.new(1, 0, 0, 16);
								BackgroundTransparency = 1;
								BorderSizePixel = 0;
								AutoButtonColor = false;
								Text = "";
								LayoutOrder = I;
								ZIndex = 502;
							});
							local OL = LibRef:CreateInstance("TextLabel", {
								Name = "Label";
								Parent = OptRow;
								Position = UDim2.new(0, 8, 0, 0);
								Size = UDim2.new(1, -16, 1, 0);
								BackgroundTransparency = 1;
								BorderSizePixel = 0;
								FontFace = Library.Fonts.Proggy;
								Text = OptStr;
								TextColor3 = Color3.fromRGB(200, 200, 200);
								TextSize = 12;
								TextXAlignment = Enum.TextXAlignment.Left;
								TextYAlignment = Enum.TextYAlignment.Center;
								ZIndex = 503;
							});
							LibRef:CreateInstance("UIStroke", {
								Parent = OL;
								Color = Color3.fromRGB(0, 0, 0);
								Thickness = 1;
								ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
							});
							local Entry = { Button = OptRow, Label = OL, Value = OptStr, Hovered = false };
							table.insert(Buttons, Entry);

							LibRef:Connection(OptRow.MouseEnter, function()
								Entry.Hovered = true;
								LibRef:Tween(OL, OptTween, { TextColor3 = Color3.fromRGB(255, 255, 255) }):Play();
							end);
							LibRef:Connection(OptRow.MouseLeave, function()
								Entry.Hovered = false;
								LibRef:Tween(OL, OptTween, { TextColor3 = IsSelectedVal(Entry.Value)
									and Palette.Default.TabActive
									or Color3.fromRGB(200, 200, 200) }):Play();
							end);
							LibRef:Connection(OptRow.MouseButton1Click, function()
								if Multi then
									DropdownObj:Toggle(OptStr);
								else
									DropdownObj:Set(OptStr);
									DropdownObj:Close();
								end;
							end);
						end;

						RefreshButtonColors();
						BuildFade();
					end;

					function DropdownObj:Open()
						if IsOpen then return end;
						if not Popup then BuildPopup() end;
						if not Popup then return end;
						if LibRef.OpenDropdown and LibRef.OpenDropdown ~= self then
							LibRef.OpenDropdown:Close();
						end;
						IsOpen = true;
						Sign.Text = "-";
						local Rp, Rs = Row.AbsolutePosition, Row.AbsoluteSize;
						Popup.Position = UDim2.new(0, Rp.X, 0, Rp.Y + Rs.Y + 63);
						Popup.Size = UDim2.new(0, Rs.X, 0, 0);
						SetFade(false, false);
						Popup.Visible = true;
						LibRef:Tween(Popup, DDTween, { Size = UDim2.new(0, Rs.X, 0, PopupHeight()) }):Play();
						SetFade(true, true);
						LibRef.OpenDropdown = self;
					end;

					function DropdownObj:Close()
						if not IsOpen then return end;
						IsOpen = false;
						Sign.Text = "+";
						if Popup then
							local W = Popup.Size.X.Offset;
							local T = LibRef:Tween(Popup, DDTween, { Size = UDim2.new(0, W, 0, 0) });
							T.Completed:Connect(function()
								if not IsOpen then Popup.Visible = false end;
							end);
							T:Play();
							SetFade(false, true);
						end;
						if LibRef.OpenDropdown == self then
							LibRef.OpenDropdown = nil;
						end;
					end;

					LibRef:Connection(Hit.MouseButton1Click, function()
						if IsOpen then DropdownObj:Close() else DropdownObj:Open() end;
					end);

					LibRef:Connection(Row:GetPropertyChangedSignal("AbsolutePosition"), function()
						if IsOpen then PositionPopup() end;
					end);
					LibRef:Connection(Row:GetPropertyChangedSignal("AbsoluteSize"), function()
						if IsOpen then PositionPopup() end;
					end);

					LibRef:Connection(UserInputService.InputBegan, function(input)
						if not IsOpen then return end;
						if input.UserInputType ~= Enum.UserInputType.MouseButton1
							and input.UserInputType ~= Enum.UserInputType.Touch then
							return
						end;
						local Mp = UserInputService:GetMouseLocation() - Vector2.new(0, GuiInset);
						local function Inside(F)
							if not F then return false end;
							local P, S = F.AbsolutePosition, F.AbsoluteSize;
							return Mp.X >= P.X and Mp.X <= P.X + S.X
								and Mp.Y >= P.Y and Mp.Y <= P.Y + S.Y;
						end;
						if not Inside(Popup) and not Inside(Row) then
							DropdownObj:Close();
						end;
					end);

					do
						local Flag = LibRef:AutoFlag("Dropdown_" .. DDName);
						DropdownObj.Flag = Flag;
						LibRef:RegisterFlag(Flag, DropdownObj:Get(), function(v) DropdownObj:Set(v) end);
					end;

					return DropdownObj;
				end;

				function SectionObj:AddTextbox(TbName, Default, Placeholder, Callback)
					TbName = tostring(TbName or "Textbox");
					local CB = typeof(Callback) == "function" and Callback or function() end;

					local Row = LibRef:CreateInstance("Frame", {
						Name = "Textbox_" .. TbName;
						Parent = Body;
						Size = UDim2.new(1, 0, 0, 18);
						BackgroundColor3 = Color3.fromRGB(255, 255, 255);
						BorderSizePixel = 0;
						ClipsDescendants = true;
					});
					LibRef:CreateInstance("UIGradient", {
						Parent = Row;
						Rotation = 90;
						Color = ColorSeq({
							ColorKey(0, Palette.Default.Bottom);
							ColorKey(1, Palette.Default.Top);
						});
					});
					LibRef:ApplyDoubleOutline(Row);

					local Clip = LibRef:CreateInstance("Frame", {
						Name = "Clip";
						Parent = Row;
						Position = UDim2.new(0, 8, 0, 0);
						Size = UDim2.new(1, -16, 1, 0);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						ClipsDescendants = true;
						ZIndex = 4;
					});

					local Box = LibRef:CreateInstance("TextBox", {
						Name = "Input";
						Parent = Clip;
						Position = UDim2.new(0, 0, 0, -1);
						Size = UDim2.new(1, 0, 1, 0);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						ClearTextOnFocus = false;
						ClipsDescendants = true;
						FontFace = Library.Fonts.Proggy;
						Text = tostring(Default or "");
						PlaceholderText = tostring(Placeholder or TbName);
						PlaceholderColor3 = Palette.Default.TabInactive;
						TextColor3 = Color3.fromRGB(255, 255, 255);
						TextSize = 12;
						TextXAlignment = Enum.TextXAlignment.Left;
						TextYAlignment = Enum.TextYAlignment.Center;
						TextTruncate = Enum.TextTruncate.AtEnd;
						TextWrapped = false;
						ZIndex = 5;
					});
					LibRef:CreateInstance("UIStroke", {
						Parent = Box;
						Color = Color3.fromRGB(0, 0, 0);
						Thickness = 1;
						ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
					});

					local TbFlag = nil;
					local TbObj = { Row = Row, Box = Box };
					function TbObj:Get() return Box.Text end;
					function TbObj:Set(v)
						Box.Text = tostring(v or "");
						CB(Box.Text, false);
					end;

					LibRef:Connection(Box.FocusLost, function(EnterPressed)
						if TbFlag then LibRef.Flags[TbFlag] = Box.Text end;
						CB(Box.Text, EnterPressed);
					end);

					do
						local Flag = LibRef:AutoFlag("Textbox_" .. TbName);
						TbObj.Flag = Flag;
						TbFlag = Flag;
						LibRef:RegisterFlag(Flag, tostring(Default or ""), function(v) TbObj:Set(v) end);
					end;

					return TbObj;
				end;

				function SectionObj:AddLabel(Text, Opts)
					Text = tostring(Text or "");
					Opts = typeof(Opts) == "table" and Opts or {};
					local Lbl = LibRef:CreateInstance("TextLabel", {
						Name = "Label";
						Parent = Body;
						Size = UDim2.new(1, 0, 0, 14);
						AutomaticSize = Enum.AutomaticSize.Y;
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						FontFace = Library.Fonts.Proggy;
						Text = Text;
						TextColor3 = Palette.Default.TabInactive;
						TextSize = 12;
						RichText = true;
						TextWrapped = Opts.Wrap ~= false;
						TextXAlignment = Enum.TextXAlignment.Left;
						TextYAlignment = Enum.TextYAlignment.Top;
					});
					LibRef:CreateInstance("UIStroke", {
						Parent = Lbl;
						Color = Color3.fromRGB(0, 0, 0);
						Thickness = 1;
						ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
					});
					local LabelObj = { Label = Lbl };
					function LabelObj:Set(V) Lbl.Text = tostring(V or "") end;
					LabelObj.SetText = LabelObj.Set;
					return LabelObj;
				end;

				function SectionObj:AddParagraph(Title, Content)
					Title = tostring(Title or "Title");
					Content = tostring(Content or "");
					local Holder = LibRef:CreateInstance("Frame", {
						Name = "Paragraph";
						Parent = Body;
						Size = UDim2.new(1, 0, 0, 0);
						AutomaticSize = Enum.AutomaticSize.Y;
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
					});
					LibRef:CreateInstance("UIListLayout", {
						Parent = Holder;
						FillDirection = Enum.FillDirection.Vertical;
						SortOrder = Enum.SortOrder.LayoutOrder;
						Padding = UDim.new(0, 2);
					});
					local TitleLbl = LibRef:CreateInstance("TextLabel", {
						Name = "Title";
						Parent = Holder;
						Size = UDim2.new(1, 0, 0, 14);
						AutomaticSize = Enum.AutomaticSize.Y;
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						FontFace = Library.TitleFont;
						Text = Title;
						TextColor3 = Color3.fromRGB(255, 255, 255);
						TextSize = 12;
						RichText = true;
						TextWrapped = true;
						TextXAlignment = Enum.TextXAlignment.Left;
						TextYAlignment = Enum.TextYAlignment.Top;
						LayoutOrder = 1;
					});
					LibRef:CreateInstance("UIStroke", {
						Parent = TitleLbl;
						Color = Color3.fromRGB(0, 0, 0);
						Thickness = 1;
						ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
					});
					local BodyLbl = LibRef:CreateInstance("TextLabel", {
						Name = "Body";
						Parent = Holder;
						Size = UDim2.new(1, 0, 0, 0);
						AutomaticSize = Enum.AutomaticSize.Y;
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						FontFace = Library.Fonts.Proggy;
						Text = Content;
						TextColor3 = Palette.Default.TabInactive;
						TextSize = 12;
						RichText = true;
						TextWrapped = true;
						TextXAlignment = Enum.TextXAlignment.Left;
						TextYAlignment = Enum.TextYAlignment.Top;
						LayoutOrder = 2;
					});
					LibRef:CreateInstance("UIStroke", {
						Parent = BodyLbl;
						Color = Color3.fromRGB(0, 0, 0);
						Thickness = 1;
						ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
					});
					local ParaObj = { Frame = Holder, Title = TitleLbl, Body = BodyLbl };
					function ParaObj:SetTitle(V) TitleLbl.Text = tostring(V or "") end;
					function ParaObj:SetBody(V) BodyLbl.Text = tostring(V or "") end;
					return ParaObj;
				end;

				function SectionObj:AddList(ListName, Options, Opts)
					Options = typeof(Options) == "table" and Options or {};
					Opts = typeof(Opts) == "table" and Opts or {};
					local Multi = Opts.Multi == true;
					local Height = tonumber(Opts.Height) or 100;
					local CB = typeof(Opts.Callback) == "function" and Opts.Callback or function() end;
					local Labeled = ListName ~= nil and ListName ~= false;
					ListName = tostring(ListName or "List");
					local BoxY = Labeled and 16 or 0;

					local Container = LibRef:CreateInstance("Frame", {
						Name = "List_" .. ListName;
						Parent = Body;
						Size = UDim2.new(1, 0, 0, Height + BoxY);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
					});
					if Labeled then
						local NameLbl = LibRef:CreateInstance("TextLabel", {
							Name = "Label";
							Parent = Container;
							Position = UDim2.new(0, 0, 0, 0);
							Size = UDim2.new(1, 0, 0, 14);
							BackgroundTransparency = 1;
							BorderSizePixel = 0;
							FontFace = Library.Fonts.Proggy;
							Text = ListName;
							TextColor3 = Palette.Default.TabInactive;
							TextSize = 12;
							TextXAlignment = Enum.TextXAlignment.Left;
							TextYAlignment = Enum.TextYAlignment.Center;
						});
						LibRef:CreateInstance("UIStroke", {
							Parent = NameLbl;
							Color = Color3.fromRGB(0, 0, 0);
							Thickness = 1;
							ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
						});
					end;

					local Box = LibRef:CreateInstance("Frame", {
						Name = "Box";
						Parent = Container;
						Position = UDim2.new(0, 0, 0, BoxY);
						Size = UDim2.new(1, 0, 0, Height);
						BackgroundColor3 = Color3.fromRGB(255, 255, 255);
						BorderSizePixel = 0;
					});
					LibRef:CreateInstance("UIGradient", {
						Parent = Box;
						Rotation = 90;
						Color = ColorSeq({
							ColorKey(0, Palette.Default.Bottom);
							ColorKey(1, Palette.Default.Top);
						});
					});
					LibRef:ApplyDoubleOutline(Box);

					local Scroll = LibRef:CreateInstance("ScrollingFrame", {
						Name = "Scroll";
						Parent = Box;
						Position = UDim2.new(0, 3, 0, 3);
						Size = UDim2.new(1, -6, 1, -6);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						ScrollBarThickness = 2;
						ScrollBarImageColor3 = Palette.Default.Accent;
						CanvasSize = UDim2.new(0, 0, 0, 0);
						AutomaticCanvasSize = Enum.AutomaticSize.Y;
						ScrollingDirection = Enum.ScrollingDirection.Y;
						ZIndex = 3;
					});
					LibRef:CreateInstance("UIListLayout", {
						Parent = Scroll;
						FillDirection = Enum.FillDirection.Vertical;
						SortOrder = Enum.SortOrder.LayoutOrder;
						Padding = UDim.new(0, 2);
					});

					local Selected = Multi and {} or "";
					local OptionRows = {};
					local OptTween = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

					local function IsSel(Val)
						if Multi then return table.find(Selected, Val) ~= nil end;
						return Selected == Val;
					end;
					local function RefreshColors()
						for _, E in OptionRows do
							local C;
							if E.Hovered then
								C = Color3.fromRGB(255, 255, 255);
							elseif IsSel(E.Value) then
								C = Palette.Default.TabActive;
							else
								C = Color3.fromRGB(200, 200, 200);
							end;
							LibRef:Tween(E.Label, OptTween, { TextColor3 = C }):Play();
						end;
					end;

					local ListObj = { Frame = Container, Box = Box };
					function ListObj:Get()
						if Multi then
							local T = {};
							for _, V in Selected do T[#T + 1] = V end;
							return T;
						end;
						return Selected;
					end;
					function ListObj:Set(v)
						if Multi then
							Selected = {};
							if typeof(v) == "table" then
								for _, X in v do Selected[#Selected + 1] = tostring(X) end;
							elseif v ~= nil and v ~= "" then
								Selected[#Selected + 1] = tostring(v);
							end;
						else
							Selected = tostring(v);
						end;
						RefreshColors();
						CB(self:Get());
						if self.Flag then LibRef.Flags[self.Flag] = self:Get() end;
					end;
					function ListObj:Toggle(Val)
						if not Multi then self:Set(Val); return end;
						local Idx = table.find(Selected, Val);
						if Idx then table.remove(Selected, Idx) else Selected[#Selected + 1] = Val end;
						RefreshColors();
						CB(self:Get());
						if self.Flag then LibRef.Flags[self.Flag] = self:Get() end;
					end;

					local function AddOption(I, Opt)
						local OptStr = tostring(Opt);
						local OptRow = LibRef:CreateInstance("TextButton", {
							Name = "Opt_" .. tostring(I);
							Parent = Scroll;
							Size = UDim2.new(1, 0, 0, 16);
							BackgroundTransparency = 1;
							BorderSizePixel = 0;
							AutoButtonColor = false;
							Text = "";
							LayoutOrder = I;
							ZIndex = 4;
						});
						local OL = LibRef:CreateInstance("TextLabel", {
							Name = "Label";
							Parent = OptRow;
							Position = UDim2.new(0, 6, 0, 0);
							Size = UDim2.new(1, -12, 1, 0);
							BackgroundTransparency = 1;
							BorderSizePixel = 0;
							FontFace = Library.Fonts.Proggy;
							Text = OptStr;
							TextColor3 = Color3.fromRGB(200, 200, 200);
							TextSize = 12;
							TextXAlignment = Enum.TextXAlignment.Left;
							TextYAlignment = Enum.TextYAlignment.Center;
							ZIndex = 5;
						});
						LibRef:CreateInstance("UIStroke", {
							Parent = OL;
							Color = Color3.fromRGB(0, 0, 0);
							Thickness = 1;
							ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
						});
						local Entry = { Button = OptRow, Label = OL, Value = OptStr, Hovered = false };
						OptionRows[#OptionRows + 1] = Entry;

						LibRef:Connection(OptRow.MouseEnter, function()
							Entry.Hovered = true;
							LibRef:Tween(OL, OptTween, { TextColor3 = Color3.fromRGB(255, 255, 255) }):Play();
						end);
						LibRef:Connection(OptRow.MouseLeave, function()
							Entry.Hovered = false;
							LibRef:Tween(OL, OptTween, { TextColor3 = IsSel(Entry.Value)
								and Palette.Default.TabActive or Color3.fromRGB(200, 200, 200) }):Play();
						end);
						LibRef:Connection(OptRow.MouseButton1Click, function()
							ListObj:Toggle(OptStr);
						end);
					end;

					for I, Opt in Options do AddOption(I, Opt) end;

					function ListObj:Refresh(NewOptions)
						if typeof(NewOptions) == "table" then Options = NewOptions end;
						for _, E in OptionRows do E.Button:Destroy() end;
						table.clear(OptionRows);
						for I, Opt in Options do AddOption(I, Opt) end;
						RefreshColors();
					end;

					if Opts.Default ~= nil then
						ListObj:Set(Opts.Default);
					else
						RefreshColors();
					end;

					do
						local Flag = LibRef:AutoFlag("List_" .. ListName);
						ListObj.Flag = Flag;
						LibRef:RegisterFlag(Flag, ListObj:Get(), function(v) ListObj:Set(v) end);
					end;

					return ListObj;
				end;

				function SectionObj:AddPreview(Opts)
					Opts = typeof(Opts) == "table" and Opts or {};
					local Height = tonumber(Opts.Height) or 220;
					local Players = game:GetService("Players");

					local Container = LibRef:CreateInstance("Frame", {
						Name = "Preview";
						Parent = Body;
						Size = UDim2.new(1, 0, 0, Height);
						BackgroundColor3 = Color3.fromRGB(255, 255, 255);
						BorderSizePixel = 0;
						ClipsDescendants = true;
					});
					LibRef:CreateInstance("UIGradient", {
						Parent = Container;
						Rotation = 90;
						Color = ColorSeq({
							ColorKey(0, Palette.Default.Bottom);
							ColorKey(1, Palette.Default.Top);
						});
					});
					LibRef:ApplyDoubleOutline(Container);

					local Viewport = LibRef:CreateInstance("ViewportFrame", {
						Name = "Viewport";
						Parent = Container;
						Position = UDim2.new(0, 2, 0, 2);
						Size = UDim2.new(1, -4, 1, -4);
						BackgroundColor3 = Palette.Default.Bottom;
						BackgroundTransparency = 0;
						BorderSizePixel = 0;
						ZIndex = 2;
					});
					LibRef:CreateInstance("UIGradient", {
						Parent = Viewport;
						Rotation = 90;
						Color = ColorSeq({
							ColorKey(0, Color3.fromHex("2C2B3B"));
							ColorKey(1, Color3.fromHex("0D0C12"));
						});
					});

					local DragHit = LibRef:CreateInstance("TextButton", {
						Name = "DragHit";
						Parent = Container;
						Size = UDim2.new(1, 0, 1, 0);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						AutoButtonColor = false;
						Text = "";
						Active = true;
						ZIndex = 10;
					});

					local Model, Cam;
					local function ViewModel(Char)
						if not Char then return end;
						for _, C in Viewport:GetChildren() do C:Destroy() end;
						Model, Cam = nil, nil;
						Char.Archivable = true;
						local Clone = Char:Clone();
						if not Clone then return end;
						Clone.Parent = Viewport;
						Model = Clone;
						Cam = Instance.new("Camera");
						Cam.Parent = Viewport;
						Cam.FieldOfView = 60;
						Viewport.CurrentCamera = Cam;
					end;

					local RotX, RotY, Dist = 0, 0, 10;
					local Dragging, Hovering, LastPos = false, false, Vector2.new(0, 0);
					local ScrollHost = Container:FindFirstAncestorWhichIsA("ScrollingFrame");
					LibRef:Connection(DragHit.MouseEnter, function()
						Hovering = true;
						if ScrollHost then ScrollHost.ScrollingEnabled = false end;
					end);
					LibRef:Connection(DragHit.MouseLeave, function()
						Hovering = false;
						if ScrollHost then ScrollHost.ScrollingEnabled = true end;
					end);
					LibRef:Connection(DragHit.InputBegan, function(Input)
						if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
							Dragging = true; LastPos = Input.Position;
						end
					end);
					LibRef:Connection(DragHit.InputEnded, function(Input)
						if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
							Dragging = false;
						end
					end);
					LibRef:Connection(UserInputService.InputChanged, function(Input)
						if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
							local Delta = Input.Position - LastPos;
							LastPos = Input.Position;
							RotY = RotY - Delta.X * 0.01;
							RotX = math.clamp(RotX - Delta.Y * 0.01, -math.pi / 2 + 0.1, math.pi / 2 - 0.1);
						elseif (Hovering or Dragging) and Input.UserInputType == Enum.UserInputType.MouseWheel then
							Dist = math.clamp(Dist - Input.Position.Z * 1.5, 3, 30);
						end
					end);

					LibRef:Connection(RunService.RenderStepped, function()
						if not (Cam and Model) then return end;
						local Root = Model:FindFirstChild("HumanoidRootPart");
						if not Root then return end;
						if not Dragging then RotY = RotY + 0.01 end;
						local Center = Root.Position;
						local Rotation = CFrame.Angles(0, RotY, 0) * CFrame.Angles(RotX, 0, 0);
						local CamCF = CFrame.new(Center) * Rotation * CFrame.new(0, 0, Dist);
						Cam.CFrame = CFrame.lookAt(CamCF.Position, Center + Vector3.new(0, -1, 0));
					end);

					local Plr = Players.LocalPlayer;
					if Plr then
						if Plr.Character then ViewModel(Plr.Character) end;
						LibRef:Connection(Plr.CharacterAdded, function(Char)
							task.wait(0.2);
							ViewModel(Char);
						end);
					end;

					local PreviewObj = { Frame = Container, Viewport = Viewport };
						function PreviewObj:Set() end;
						function PreviewObj:Update() end;
						function PreviewObj:Refresh() if Plr and Plr.Character then ViewModel(Plr.Character) end end;
					return PreviewObj;
				end;

				return SectionObj;
			end;

			function TabObj:AddMultiSection(Names, Side, Opts)
				Opts = typeof(Opts) == "table" and Opts or {};
				Names = typeof(Names) == "table" and Names or { "1", "2", "3" };
				local ColParent = Opts.Parent or GetColumn(Side);

				local Outer = LibRef:CreateInstance("Frame", {
					Name = "MultiSection";
					Parent = ColParent;
					Size = UDim2.new(1, 0, 0, 0);
					AutomaticSize = Enum.AutomaticSize.Y;
					BackgroundColor3 = Color3.fromRGB(255, 255, 255);
					BorderSizePixel = 0;
					LayoutOrder = #ColParent:GetChildren();
				});
				LibRef:CreateInstance("UIGradient", {
					Parent = Outer;
					Rotation = 90;
					Color = ColorSeq({
						ColorKey(0, Palette.Default.FooterBottom);
						ColorKey(1, Palette.Default.FooterTop);
					});
				});
				LibRef:ApplyDoubleOutline(Outer);

				local TabRow = LibRef:CreateInstance("Frame", {
					Name = "Tabs";
					Parent = Outer;
					Position = UDim2.new(0, 1, 0, 1);
					Size = UDim2.new(1, -2, 0, 24);
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					ClipsDescendants = true;
					ZIndex = 2;
				});
				LibRef:CreateInstance("UIListLayout", {
					Parent = TabRow;
					FillDirection = Enum.FillDirection.Horizontal;
					HorizontalFlex = Enum.UIFlexAlignment.Fill;
					VerticalAlignment = Enum.VerticalAlignment.Bottom;
					SortOrder = Enum.SortOrder.LayoutOrder;
					Padding = UDim.new(0, -1);
				});
				LibRef:CreateInstance("Frame", {
					Name = "DividerOuter";
					Parent = Outer;
					Position = UDim2.new(0, 1, 0, 24);
					Size = UDim2.new(1, -2, 0, 1);
					BackgroundColor3 = Palette.Default.Outline;
					BorderSizePixel = 0;
					ZIndex = 2;
				});
				LibRef:CreateInstance("Frame", {
					Name = "DividerInner";
					Parent = Outer;
					Position = UDim2.new(0, 1, 0, 25);
					Size = UDim2.new(1, -2, 0, 1);
					BackgroundColor3 = Palette.Default.InnerOutline;
					BorderSizePixel = 0;
					ZIndex = 2;
				});

				local Bodies = LibRef:CreateInstance("Frame", {
					Name = "Bodies";
					Parent = Outer;
					Position = UDim2.new(0, 0, 0, 26);
					Size = UDim2.new(1, 0, 0, 0);
					AutomaticSize = Enum.AutomaticSize.Y;
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
				});

				local Sections = {};
				local ActiveMS = nil;
				local MsTween = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

				for I, RawName in Names do
					local SubName = tostring(RawName);

					local Btn = LibRef:CreateInstance("TextButton", {
						Name = "Tab_" .. SubName;
						Parent = TabRow;
						AutoButtonColor = false;
						BackgroundColor3 = Color3.fromRGB(255, 255, 255);
						BorderSizePixel = 0;
						Size = UDim2.new(0, 0, 1, 0);
						Text = "";
						LayoutOrder = I;
					});
					LibRef:CreateInstance("UIGradient", {
						Parent = Btn;
						Rotation = 90;
						Color = ColorSeq({
							ColorKey(0, Palette.Default.InnerOutline);
							ColorKey(1, Palette.Default.FooterBottom);
						});
					});
					LibRef:CreateInstance("UIStroke", {
						Parent = Btn;
						Color = Palette.Default.Outline;
						Thickness = 1;
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
					});
					local Cover = LibRef:CreateInstance("Frame", {
						Name = "Cover";
						Parent = Btn;
						Size = UDim2.new(1, 0, 1, 0);
						BackgroundColor3 = Palette.Default.Bottom;
						BorderSizePixel = 0;
						ZIndex = 2;
					});
					local Lbl = LibRef:CreateInstance("TextLabel", {
						Name = "Label";
						Parent = Btn;
						Position = UDim2.new(0, 0, 0, -1);
						Size = UDim2.new(1, 0, 1, 0);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						FontFace = Library.Fonts.Proggy;
						Text = SubName;
						TextColor3 = Palette.Default.TabInactive;
						TextSize = 12;
						TextXAlignment = Enum.TextXAlignment.Center;
						TextYAlignment = Enum.TextYAlignment.Center;
						ZIndex = 3;
					});
					LibRef:CreateInstance("UIStroke", {
						Parent = Lbl;
						Color = Color3.fromRGB(0, 0, 0);
						Thickness = 1;
						ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
					});
					local Fill = LibRef:CreateInstance("Frame", {
						Name = "Fill";
						Parent = Btn;
						Position = UDim2.new(0, 0, 0, 0);
						Size = UDim2.new(1, 0, 0, 1);
						BackgroundColor3 = Palette.Default.Accent;
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						ZIndex = 4;
					});

					local Sec = TabObj:AddSection(SubName, Side, { Bare = true, Parent = Bodies });
					Sec.Frame.Position = UDim2.new(0, 0, 0, 0);
					Sec.Frame.Size = UDim2.new(1, 0, 0, 0);
					LibRef:CreateInstance("UIPadding", {
						Parent = Sec.Frame;
						PaddingLeft = UDim.new(0, 10);
						PaddingRight = UDim.new(0, 10);
						PaddingTop = UDim.new(0, 6);
					});
					Sec.Frame.Visible = false;

					Sec.Button = Btn;
					function Sec.SetActive(A)
						Cover:SetAttribute("_fb_BackgroundTransparency", A and 1 or 0);
						Fill:SetAttribute("_fb_BackgroundTransparency", A and 0 or 1);
						LibRef:FadeFrame(Sec.Frame, A);
						LibRef:Tween(Cover, MsTween, { BackgroundTransparency = A and 1 or 0 }):Play();
						LibRef:Tween(Fill, MsTween, { BackgroundTransparency = A and 0 or 1 }):Play();
						LibRef:Tween(Lbl, MsTween, { TextColor3 = A and Color3.fromRGB(255, 255, 255) or Palette.Default.TabInactive }):Play();
					end;

					LibRef:Connection(Btn.MouseButton1Click, function()
						if ActiveMS == Sec then return end;
						if ActiveMS then ActiveMS.SetActive(false) end;
						Sec.SetActive(true);
						ActiveMS = Sec;
					end);

					Sections[#Sections + 1] = { Sec = Sec, Cover = Cover, Fill = Fill, Lbl = Lbl };
				end;

				if Sections[1] then
					local First = Sections[1];
					First.Sec.Frame.Visible = true;
					First.Cover.BackgroundTransparency = 1;
					First.Fill.BackgroundTransparency = 0;
					First.Lbl.TextColor3 = Color3.fromRGB(255, 255, 255);
					ActiveMS = First.Sec;
				end;

				local Result = {};
				for _, E in Sections do Result[#Result + 1] = E.Sec end;
				return table.unpack(Result);
			end;

			function TabObj:PlayerList(POpts)
				POpts = typeof(POpts) == "table" and POpts or {};
				ReflowColumnsForList();
				local Holder = LibRef:CreateInstance("Frame", {
					Name = "PlayerListHolder";
					Parent = Page;
					Size = UDim2.new(1, 0, 0, 0);
					AutomaticSize = Enum.AutomaticSize.Y;
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					LayoutOrder = 2;
				});
				LibRef:CreateInstance("UIPadding", {
					Parent = Holder;
					PaddingLeft = UDim.new(0, 1);
					PaddingRight = UDim.new(0, 1);
				});
				return LibRef:PlayerList({ Parent = Holder, Gui = Gui, Title = POpts.Title });
			end;

			function TabObj:AddSubTab(SubName)
				SubName = tostring(SubName or "Sub");
				if not SubTabBar then
					if PageLayout then PageLayout:Destroy(); PageLayout = nil end;
					Page.ClipsDescendants = false;
					SubTabBar = LibRef:CreateInstance("Frame", {
						Name = "SubTabBar";
						Parent = Page;
						Position = UDim2.new(0, -8, 0, -7);
						Size = UDim2.new(1, 16, 0, 26);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
					});
					LibRef:CreateInstance("UIPadding", {
						Parent = SubTabBar;
						PaddingLeft = UDim.new(0, 2);
						PaddingRight = UDim.new(0, 1);
					});
					LibRef:CreateInstance("UIListLayout", {
						Parent = SubTabBar;
						FillDirection = Enum.FillDirection.Horizontal;
						HorizontalAlignment = Enum.HorizontalAlignment.Left;
						VerticalAlignment = Enum.VerticalAlignment.Bottom;
						SortOrder = Enum.SortOrder.LayoutOrder;
						Padding = UDim.new(0, -1);
					});
					LibRef:CreateInstance("Frame", {
						Name = "SubDividerOuter";
						Parent = Page;
						Position = UDim2.new(0, -7, 0, 19);
						Size = UDim2.new(1, 14, 0, 1);
						BackgroundColor3 = Palette.Default.Outline;
						BorderSizePixel = 0;
					});
					LibRef:CreateInstance("Frame", {
						Name = "SubDivider";
						Parent = Page;
						Position = UDim2.new(0, -7, 0, 20);
						Size = UDim2.new(1, 14, 0, 1);
						BackgroundColor3 = Palette.Default.InnerOutline;
						BorderSizePixel = 0;
					});
					SubPagesHolder = LibRef:CreateInstance("Frame", {
						Name = "SubPages";
						Parent = Page;
						Position = UDim2.new(0, 0, 0, 27);
						Size = UDim2.new(1, 0, 1, -27);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
					});
				end;

				local SubObj = {};

				local SubBtn = LibRef:CreateInstance("TextButton", {
					Name = "SubTab_" .. SubName;
					Parent = SubTabBar;
					AutoButtonColor = false;
					BackgroundColor3 = Color3.fromRGB(255, 255, 255);
					BorderSizePixel = 0;
					AutomaticSize = Enum.AutomaticSize.X;
					Size = UDim2.new(0, 0, 1, -2);
					Text = "";
					LayoutOrder = #SubTabs + 1;
				});
				LibRef:CreateInstance("UIGradient", {
					Parent = SubBtn;
					Rotation = 90;
					Color = ColorSeq({
						ColorKey(0, Palette.Default.InnerOutline);
						ColorKey(1, Palette.Default.FooterBottom);
					});
				});
				LibRef:CreateInstance("UIStroke", {
					Parent = SubBtn;
					Color = Palette.Default.Outline;
					Thickness = 1;
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
				});
				local SubCover = LibRef:CreateInstance("Frame", {
					Name = "Cover";
					Parent = SubBtn;
					Size = UDim2.new(1, 0, 1, 0);
					BackgroundColor3 = Palette.Default.Bottom;
					BorderSizePixel = 0;
					ZIndex = 2;
				});
				local SubLbl = LibRef:CreateInstance("TextLabel", {
					Name = "Label";
					Parent = SubBtn;
					Position = UDim2.new(0, 0, 0, -1);
					AutomaticSize = Enum.AutomaticSize.X;
					Size = UDim2.new(0, 0, 1, 0);
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					FontFace = Library.Fonts.Proggy;
					Text = SubName;
					TextColor3 = Palette.Default.TabInactive;
					TextSize = 12;
					TextXAlignment = Enum.TextXAlignment.Center;
					TextYAlignment = Enum.TextYAlignment.Center;
					ZIndex = 3;
				});
				LibRef:CreateInstance("UIPadding", {
					Parent = SubLbl;
					PaddingLeft = UDim.new(0, 10);
					PaddingRight = UDim.new(0, 10);
				});
				LibRef:CreateInstance("UIStroke", {
					Parent = SubLbl;
					Color = Color3.fromRGB(0, 0, 0);
					Thickness = 1;
					ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
				});
				local SubFill = LibRef:CreateInstance("Frame", {
					Name = "Fill";
					Parent = SubBtn;
					AnchorPoint = Vector2.new(0, 0);
					Position = UDim2.new(0, 0, 0, 0);
					Size = UDim2.new(1, 0, 0, 1);
					BackgroundColor3 = Palette.Default.Accent;
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					ZIndex = 4;
				});

				local SubPage = LibRef:CreateInstance("Frame", {
					Name = "SubPage_" .. SubName;
					Parent = SubPagesHolder;
					Position = UDim2.new(0, 0, 0, 0);
					Size = UDim2.new(1, 0, 1, 0);
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					Visible = false;
					ClipsDescendants = true;
				});
				LibRef:CreateInstance("UIListLayout", {
					Parent = SubPage;
					FillDirection = Enum.FillDirection.Horizontal;
					HorizontalFlex = Enum.UIFlexAlignment.Fill;
					SortOrder = Enum.SortOrder.LayoutOrder;
					Padding = UDim.new(0, 8);
				});

				local SubColumns = {};
				local function SubMakeColumn(Order)
					local Col = LibRef:CreateInstance("ScrollingFrame", {
						Name = "Column_" .. Order;
						Parent = SubPage;
						Size = UDim2.new(0, 0, 1, 0);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						LayoutOrder = Order;
						CanvasSize = UDim2.new(0, 0, 0, 0);
						AutomaticCanvasSize = Enum.AutomaticSize.Y;
						ScrollingDirection = Enum.ScrollingDirection.Y;
						ScrollBarThickness = 0;
						ScrollBarImageTransparency = 1;
						ClipsDescendants = true;
					});
					LibRef:CreateInstance("UIListLayout", {
						Parent = Col;
						FillDirection = Enum.FillDirection.Vertical;
						SortOrder = Enum.SortOrder.LayoutOrder;
						Padding = UDim.new(0, 8);
					});
					LibRef:CreateInstance("UIPadding", {
						Parent = Col;
						PaddingLeft = UDim.new(0, 1);
						PaddingRight = UDim.new(0, 1);
						PaddingTop = UDim.new(0, 1);
						PaddingBottom = UDim.new(0, 1);
					});
					return Col;
				end;
				local function SubGetColumn(Side)
					local Key = (Side == "Right" or Side == 2) and "Right" or "Left";
					if not SubColumns[Key] then
						SubColumns[Key] = SubMakeColumn(Key == "Left" and 1 or 2);
					end;
					return SubColumns[Key];
				end;

				SubObj.Name = SubName;
				SubObj.Button = SubBtn;
				SubObj.Page = SubPage;
				SubObj.Active = false;

				local SubColorTween = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
				function SubObj.SetActive(Active)
					SubObj.Active = Active;
					SubCover:SetAttribute("_fb_BackgroundTransparency", Active and 1 or 0);
					SubFill:SetAttribute("_fb_BackgroundTransparency", Active and 0 or 1);
					LibRef:FadeFrame(SubPage, Active);
					LibRef:Tween(SubCover, SubColorTween, { BackgroundTransparency = Active and 1 or 0 }):Play();
					LibRef:Tween(SubFill, SubColorTween, { BackgroundTransparency = Active and 0 or 1 }):Play();
					LibRef:Tween(SubLbl, SubColorTween, { TextColor3 = Active and Color3.fromRGB(255, 255, 255) or Palette.Default.TabInactive }):Play();
				end;
				SubObj.SetActive(false);

				LibRef:Connection(SubBtn.MouseButton1Click, function()
					if ActiveSubTab == SubObj then return end;
					if ActiveSubTab then ActiveSubTab.SetActive(false) end;
					SubObj.SetActive(true);
					ActiveSubTab = SubObj;
				end);

				function SubObj:AddSection(SectionName, Side, Opts)
					Opts = typeof(Opts) == "table" and Opts or {};
					Opts.Parent = SubGetColumn(Side);
					return TabObj:AddSection(SectionName, Side, Opts);
				end;

				function SubObj:AddMultiSection(Names, Side, Opts)
					Opts = typeof(Opts) == "table" and Opts or {};
					Opts.Parent = SubGetColumn(Side);
					return TabObj:AddMultiSection(Names, Side, Opts);
				end;

				table.insert(SubTabs, SubObj);
				if not ActiveSubTab then
					SubObj.SetActive(true);
					ActiveSubTab = SubObj;
				end;
				return SubObj;
			end;

			table.insert(self.Tabs, TabObj);
			if not self.ActiveTab then
				SetActive(true);
				self.ActiveTab = TabObj;
			end;
			return TabObj;
		end;

		self.CurrentlyOpen = WindowObject;
		return WindowObject;
	end;

-- Watermark
	function Library:Watermark(Options)
		Options = typeof(Options) == "table" and Options or {};
		local Segments = Options.Segments or Options.segments;
		if typeof(Segments) ~= "table" then
			Segments = { tostring(Options.Title or "/odd.gg") };
		end;

		local Existing = self.WatermarkState;
		if typeof(Existing) == "table" and typeof(Existing.Gui) == "Instance" and Existing.Gui.Parent then
			Existing.Gui:Destroy();
		end;
		self.WatermarkState = nil;

		local Gui = self:CreateInstance("ScreenGui", {
			Name = "watermark";
			Parent = gethui and gethui() or CoreGui;
			Enabled = true;
			DisplayOrder = 1000;
			IgnoreGuiInset = true;
			ResetOnSpawn = false;
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
		});

		local Root = self:CreateInstance("CanvasGroup", {
			Name = "WatermarkRoot";
			Parent = Gui;
			AnchorPoint = Vector2.new(0, 0);
			Position = Options.Position or UDim2.new(0, 16, 0, 16);
			Size = UDim2.new(0, 0, 0, 0);
			AutomaticSize = Enum.AutomaticSize.XY;
			BackgroundColor3 = Palette.Default.Outline;
			BorderSizePixel = 0;
			Active = true;
		});
		self:CreateInstance("UIPadding", { Parent = Root; PaddingBottom = UDim.new(0, 2); });

		local Inline = self:CreateInstance("Frame", {
			Name = "Inline";
			Parent = Root;
			Position = UDim2.new(0, 1, 0, 1);
			Size = UDim2.new(1, -2, 1, 0);
			BackgroundColor3 = Palette.Default.InnerOutline;
			BorderSizePixel = 0;
		});
		self:CreateInstance("UIPadding", { Parent = Inline; PaddingBottom = UDim.new(0, 2); });

		local Background = self:CreateInstance("Frame", {
			Name = "Background";
			Parent = Inline;
			Position = UDim2.new(0, 1, 0, 1);
			Size = UDim2.new(1, -2, 1, 0);
			BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			BorderSizePixel = 0;
		});
		self:CreateInstance("UIGradient", {
			Parent = Background;
			Rotation = 90;
			Color = ColorSeq({
				ColorKey(0, Palette.Default.FooterTop);
				ColorKey(1, Palette.Default.FooterBottom);
			});
		});

		local Title = self:CreateInstance("TextLabel", {
			Name = "Title";
			Parent = Background;
			Position = UDim2.new(0, 4, 0, 4);
			Size = UDim2.new(0, 0, 0, 0);
			AutomaticSize = Enum.AutomaticSize.XY;
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			FontFace = Library.TitleFont;
			Text = "";
			RichText = true;
			TextColor3 = Palette.Default.Accent;
			TextSize = 12;
			TextXAlignment = Enum.TextXAlignment.Left;
			TextYAlignment = Enum.TextYAlignment.Center;
		});
		self:CreateInstance("UIStroke", {
			Parent = Title;
			Color = Color3.fromRGB(0, 0, 0);
			Thickness = 1;
			LineJoinMode = Enum.LineJoinMode.Miter;
			ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
		});
		self:CreateInstance("UIPadding", {
			Parent = Title;
			PaddingTop = UDim.new(0, 2);
			PaddingBottom = UDim.new(0, 3);
			PaddingRight = UDim.new(0, 7);
		});

		self:CreateInstance("Frame", {
			Name = "AccentBar";
			Parent = Root;
			Position = UDim2.new(0, 2, 0, 2);
			Size = UDim2.new(1, -4, 0, 1);
			BackgroundColor3 = Palette.Default.Accent;
			BorderSizePixel = 0;
		});

		self:Draggable(Root, Root);

		local OriginalSegments = {};
		for I, V in Segments do OriginalSegments[I] = tostring(V or "") end;

		local function CurrentPlayerName()
			local Plr = game:GetService("Players").LocalPlayer;
			return Plr and Plr.Name or "";
		end;
		local function MaskSegment(V, Anon)
			local Pn = CurrentPlayerName();
			if Anon and Pn ~= "" and V == Pn then return "hidden" end;
			return V;
		end;
		local function Render()
			local Anon = Library._Anonymous == true;
			local Parts = {};
			for _, V in OriginalSegments do
				Parts[#Parts + 1] = MaskSegment(V, Anon);
			end;
			local First = Parts[1] or "";
			if #Parts > 1 then
				local Rest = {};
				for I = 2, #Parts do Rest[#Rest + 1] = Parts[I] end;
				Title.Text = First .. string.format(' <font color="rgb(255, 255, 255)">| %s</font>', table.concat(Rest, " | "));
			else
				Title.Text = First;
			end;
		end;
		Render();

		local WatermarkObject = {
			Gui = Gui;
			Frame = Root;
			Title = Title;
			OriginalSegments = OriginalSegments;
		};

		function WatermarkObject:SetSegment(Index, Text)
			OriginalSegments[Index] = tostring(Text or "");
			Render();
		end;

		function WatermarkObject:SetSegments(NewSegments)
			if typeof(NewSegments) ~= "table" then return end;
			for I, V in NewSegments do
				OriginalSegments[I] = tostring(V or "");
			end;
			Render();
		end;

		function WatermarkObject:ApplyAnonymous(_)
			Render();
		end;

		function WatermarkObject:SetVisible(IsVisible)
			Gui.Enabled = IsVisible ~= false;
		end;

		function WatermarkObject:Destroy()
			if Gui and Gui.Parent then Gui:Destroy() end;
		end;

		self.WatermarkState = WatermarkObject;
		return WatermarkObject;
	end;

-- Notifications
	Library._Notifications = Library._Notifications or {};
	function Library:Lerp(A, B, T)
		return A + (B - A) * (T or 0.2);
	end;

	function Library:NotificationGui()
		local Gui = self._NotifyGui;
		if typeof(Gui) == "Instance" and Gui.Parent then return Gui end;
		Gui = self:CreateInstance("ScreenGui", {
			Name = "notifications";
			Parent = gethui and gethui() or CoreGui;
			Enabled = true;
			DisplayOrder = 1000;
			IgnoreGuiInset = true;
			ResetOnSpawn = false;
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
		});
		self._NotifyGui = Gui;
		if not self._NotifyLoop then
			self._NotifyLoop = true;
			self:Connection(RunService.Heartbeat, function() self:LerpNotifications() end);
		end;
		return Gui;
	end;

	function Library:LerpNotifications()
		local List = self._Notifications;
		if not List or #List == 0 then return end;
		local Now = tick();
		local YOffset = 0;
		local Alive = {};
		for _, Obj in List do
			local Inst = Obj.Outer :: any;
			if typeof(Inst) == "Instance" and Inst.Parent then
				Obj.Fade = self:Lerp(Obj.Fade, Obj.Status and 255 or 0, 0.1);
				if Now - Obj.Tick >= Obj.Lifetime then Obj.Status = false end;
				local Alpha = Obj.Fade / 255;
				local Width = Inst.AbsoluteSize.X;
				Inst.Position = UDim2.new(0, math.floor(30 - (Width - Width * Alpha)), 0, 80 + YOffset);
				Inst.GroupTransparency = 1 - Alpha;
				local Span = Obj.Lifetime > 0 and Obj.Lifetime or 0.001;
				local Progress = math.clamp((Now - Obj.Tick) / Span, 0, 1);
				Obj.Accent.Size = UDim2.new(0, math.floor(math.min(Width, Width) > 4 and (Width - 4) * Progress or 0), 0, 1);
				YOffset = YOffset + (Inst.AbsoluteSize.Y + 6) * Alpha;
				if (not Obj.Status) and Obj.Fade <= 1 then
					Inst:Destroy();
				else
					Alive[#Alive + 1] = Obj;
				end;
			end;
		end;
		self._Notifications = Alive;
	end;

	function Library:Notify(Options)
		if typeof(Options) ~= "table" then Options = { Text = tostring(Options) } end;
		local Text = tostring(Options.Text or Options.Title or Options.Name or "Notification");
		local Lifetime = tonumber(Options.Lifetime or Options.Time) or 5;

		local Gui = self:NotificationGui();

		local Outer = self:CreateInstance("CanvasGroup", {
			Name = "Notification";
			Parent = Gui;
			GroupTransparency = 1;
			Position = UDim2.new(0, 30, 0, 80);
			Size = UDim2.new(0, 0, 0, 0);
			AutomaticSize = Enum.AutomaticSize.XY;
			BackgroundColor3 = Palette.Default.Outline;
			BorderSizePixel = 0;
		});
		self:CreateInstance("UIPadding", { Parent = Outer; PaddingBottom = UDim.new(0, 2); });
		local Inline = self:CreateInstance("Frame", {
			Parent = Outer;
			Position = UDim2.new(0, 1, 0, 1);
			Size = UDim2.new(1, -2, 1, 0);
			BackgroundColor3 = Palette.Default.InnerOutline;
			BorderSizePixel = 0;
		});
		self:CreateInstance("UIPadding", { Parent = Inline; PaddingBottom = UDim.new(0, 2); });
		local Background = self:CreateInstance("Frame", {
			Parent = Inline;
			Position = UDim2.new(0, 1, 0, 1);
			Size = UDim2.new(1, -2, 1, 0);
			BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			BorderSizePixel = 0;
		});
		self:CreateInstance("UIGradient", {
			Parent = Background;
			Rotation = 90;
			Color = ColorSeq({
				ColorKey(0, Palette.Default.Top);
				ColorKey(1, Palette.Default.Bottom);
			});
		});
		local Title = self:CreateInstance("TextLabel", {
			Name = "Title";
			Parent = Background;
			Position = UDim2.new(0, 4, 0, 4);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			FontFace = Library.Fonts.Proggy;
			Text = Text;
			TextColor3 = Color3.fromRGB(255, 255, 255);
			TextSize = 12;
			RichText = true;
			TextXAlignment = Enum.TextXAlignment.Left;
			AutomaticSize = Enum.AutomaticSize.XY;
		});
		self:CreateInstance("UIStroke", {
			Parent = Title;
			Color = Color3.fromRGB(0, 0, 0);
			Thickness = 1;
			ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
		});
		self:CreateInstance("UIPadding", {
			Parent = Title;
			PaddingRight = UDim.new(0, 7);
			PaddingTop = UDim.new(0, 1);
			PaddingBottom = UDim.new(0, 3);
		});
		local Accent = self:CreateInstance("Frame", {
			Name = "AccentBar";
			Parent = Outer;
			Position = UDim2.new(0, 2, 1, -1);
			Size = UDim2.new(0, 0, 0, 1);
			BackgroundColor3 = Palette.Default.Accent;
			BorderSizePixel = 0;
		});

		local Cfg = {
			Outer = Outer;
			Accent = Accent;
			Title = Title;
			Status = true;
			Fade = 2;
			Tick = tick();
			Lifetime = Lifetime;
		};
		self._Notifications[#self._Notifications + 1] = Cfg;

		function Cfg.Close()
			Cfg.Status = false;
		end;
		return Cfg;
	end;

-- Keybind List
	function Library:KeybindList(Options)
		Options = typeof(Options) == "table" and Options or {};

		local Existing = self.KeybindListState;
		if typeof(Existing) == "table" and typeof(Existing.Gui) == "Instance" and Existing.Gui.Parent then
			Existing.Gui:Destroy();
		end;
		self.KeybindListState = nil;

		local Gui = self:CreateInstance("ScreenGui", {
			Name = "keybind_list";
			Parent = gethui and gethui() or CoreGui;
			Enabled = true;
			DisplayOrder = 1000;
			IgnoreGuiInset = true;
			ResetOnSpawn = false;
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
		});

		local RowH = 16;
		local RowPad = 2;
		local function HeightFor(N)
			if N == 0 then return 54 end;
			local RowsH = N * RowH + math.max(0, N - 1) * RowPad;
			return RowsH + 44;
		end;

-- ======== KEYBIND LIST ROOT (patched: left side default) ========
		local Root = self:CreateInstance("Frame", {
			Name = "KeybindRoot";
			Parent = Gui;
			Position = Options.Position or UDim2.new(0, 16, 0, 410);
			Size = UDim2.new(0, 200, 0, HeightFor(0));
			BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			BorderSizePixel = 0;
			Active = true;
		});
-- ======== /KEYBIND LIST ROOT ========
		self:CreateInstance("UIGradient", {
			Parent = Root;
			Rotation = 90;
			Color = ColorSeq({
				ColorKey(0, Palette.Default.Top);
				ColorKey(1, Palette.Default.Bottom);
			});
		});
		self:ApplyDoubleOutline(Root);
		self:AttachShadow(Root);

		local Header = self:CreateInstance("Frame", {
			Name = "Header";
			Parent = Root;
			Position = UDim2.new(0, 0, 0, 0);
			Size = UDim2.new(1, 0, 0, 22);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			ZIndex = 4;
		});
		local HeaderTitle = self:CreateInstance("TextLabel", {
			Name = "Title";
			Parent = Header;
			AnchorPoint = Vector2.new(0, 0.5);
			Position = UDim2.new(0, 8, 0.5, 0);
			Size = UDim2.new(1, -16, 0, 16);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			FontFace = Library.TitleFont;
			Text = "";
			RichText = true;
			TextColor3 = Color3.fromRGB(255, 255, 255);
			TextSize = 12;
			TextXAlignment = Enum.TextXAlignment.Left;
			TextYAlignment = Enum.TextYAlignment.Center;
			ZIndex = 5;
		});
		self:CreateInstance("UIStroke", {
			Parent = HeaderTitle;
			Color = Color3.fromRGB(0, 0, 0);
			Thickness = 1;
			ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
		});
		self:RegisterGradientTitle(HeaderTitle, tostring(Options.Title or "Keybinds"));
		self:Draggable(Root, Header);

		local Section = self:CreateInstance("Frame", {
			Name = "Section";
			Parent = Root;
			Position = UDim2.new(0, 6, 0, 24);
			Size = UDim2.new(1, -12, 1, -30);
			BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			BorderSizePixel = 0;
		});
		self:CreateInstance("UIGradient", {
			Parent = Section;
			Rotation = 90;
			Color = ColorSeq({
				ColorKey(0, Palette.Default.FooterBottom);
				ColorKey(1, Palette.Default.FooterTop);
			});
		});
		self:ApplyDoubleOutline(Section);
		self:CreateInstance("Frame", {
			Name = "AccentBar";
			Parent = Section;
			Position = UDim2.new(0, 1, 0, 2);
			Size = UDim2.new(1, -2, 0, 1);
			BackgroundColor3 = Palette.Default.Accent;
			BorderSizePixel = 0;
			ZIndex = 3;
		});

		local Rows = self:CreateInstance("Frame", {
			Name = "Rows";
			Parent = Section;
			Position = UDim2.new(0, 8, 0, 8);
			Size = UDim2.new(1, -16, 1, -14);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			ZIndex = 3;
		});
		self:CreateInstance("UIListLayout", {
			Parent = Rows;
			FillDirection = Enum.FillDirection.Vertical;
			SortOrder = Enum.SortOrder.LayoutOrder;
			Padding = UDim.new(0, RowPad);
		});

		local LibRef = self;
		local KbObj = {
			Gui = Gui;
			Frame = Root;
			Header = Header;
			Section = Section;
			Rows = Rows;
			HeaderTitle = HeaderTitle;
			Entries = {};
			OrderedIds = {};
		};

		local function KeyText(Key)
			if Key == nil then return " " end;
			local Name = Library.KeyNames[Key];
			if Name then return Name end;
			return (tostring(Key):gsub("Enum.KeyCode.", "")):gsub("Enum.UserInputType.", "");
		end;

		local RowTween = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
		KbObj.RowCache = {};
		function KbObj:Refresh()
			local Cache = self.RowCache;
			local Want, WantSet = {}, {};
			for _, Id in self.OrderedIds do
				local Entry = self.Entries[Id];
				if Entry and Entry.Active and Entry.Key ~= nil then
					Want[#Want + 1] = Id;
					WantSet[Id] = true;
				end;
			end;

			for Id, R in Cache do
				if not WantSet[Id] then
					Cache[Id] = nil;
					local Row = R.Row;
					Row.ClipsDescendants = true;
					LibRef:Tween(R.Name, RowTween, { TextTransparency = 1 }):Play();
					LibRef:Tween(R.NameStroke, RowTween, { Transparency = 1 }):Play();
					LibRef:Tween(R.KeyStroke, RowTween, { Transparency = 1 }):Play();
					LibRef:Tween(Row, RowTween, { Size = UDim2.new(1, 0, 0, 0) }):Play();
					local Tw = LibRef:Tween(R.Key, RowTween, { TextTransparency = 1 });
					Tw.Completed:Connect(function() if Row.Parent then Row:Destroy() end end);
					Tw:Play();
				end;
			end;

			for I, Id in Want do
				local Entry = self.Entries[Id];
				local Suffix = Entry.Mode and (" (" .. tostring(Entry.Mode) .. ")") or "";
				local R = Cache[Id];
				if not R then
					local Row = LibRef:CreateInstance("Frame", {
						Name = "Row_" .. Id;
						Parent = self.Rows;
						Size = UDim2.new(1, 0, 0, RowH);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						ZIndex = 4;
					});
					local NameLbl = LibRef:CreateInstance("TextLabel", {
						Name = "Name";
						Parent = Row;
						Size = UDim2.new(0.6, 0, 1, 0);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						FontFace = Library.Fonts.Proggy;
						Text = "";
						TextColor3 = Color3.fromRGB(255, 255, 255);
						TextTransparency = 1;
						TextSize = 12;
						TextXAlignment = Enum.TextXAlignment.Left;
						TextYAlignment = Enum.TextYAlignment.Center;
						ZIndex = 5;
					});
					local NameStroke = LibRef:CreateInstance("UIStroke", {
						Parent = NameLbl;
						Color = Color3.fromRGB(0, 0, 0);
						Thickness = 1;
						Transparency = 1;
						ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
					});
					local KeyLbl = LibRef:CreateInstance("TextLabel", {
						Name = "Key";
						Parent = Row;
						AnchorPoint = Vector2.new(1, 0);
						Position = UDim2.new(1, 0, 0, 0);
						Size = UDim2.new(0.4, 0, 1, 0);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						FontFace = Library.Fonts.Proggy;
						Text = "";
						TextColor3 = Palette.Default.TabInactive;
						TextTransparency = 1;
						TextSize = 12;
						TextXAlignment = Enum.TextXAlignment.Right;
						TextYAlignment = Enum.TextYAlignment.Center;
						ZIndex = 5;
					});
					local KeyStroke = LibRef:CreateInstance("UIStroke", {
						Parent = KeyLbl;
						Color = Color3.fromRGB(0, 0, 0);
						Thickness = 1;
						Transparency = 1;
						ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
					});
					R = { Row = Row, Name = NameLbl, Key = KeyLbl, NameStroke = NameStroke, KeyStroke = KeyStroke };
					Cache[Id] = R;
					LibRef:Tween(NameLbl, RowTween, { TextTransparency = 0 }):Play();
					LibRef:Tween(KeyLbl, RowTween, { TextTransparency = 0 }):Play();
					LibRef:Tween(NameStroke, RowTween, { Transparency = 0 }):Play();
					LibRef:Tween(KeyStroke, RowTween, { Transparency = 0 }):Play();
				end;
				R.Row.LayoutOrder = I;
				R.Name.Text = tostring(Entry.Name or "");
				R.Key.Text = KeyText(Entry.Key) .. Suffix;
				R.Key.TextColor3 = Palette.Default.TabInactive;
			end;

			LibRef:Tween(Root, RowTween, { Size = UDim2.new(0, 200, 0, HeightFor(#Want)) }):Play();
		end;
		KbObj:Refresh();

		function KbObj:Register(Id, Name, Key, Active, Mode)
			if not self.Entries[Id] then
				table.insert(self.OrderedIds, Id);
			end;
			self.Entries[Id] = {
				Name = Name or "keybind";
				Key = Key;
				Active = Active == true;
				Mode = Mode;
			};
			self:Refresh();
		end;

		function KbObj:Update(Id, Name, Key, Active, Mode)
			local Entry = self.Entries[Id];
			if not Entry then
				self:Register(Id, Name, Key, Active, Mode);
				return;
			end;
			if Name ~= nil then Entry.Name = Name end;
			if Key == false then
				Entry.Key = nil;
			elseif Key ~= nil then
				Entry.Key = Key;
			end;
			if Active ~= nil then Entry.Active = Active == true end;
			if Mode ~= nil then Entry.Mode = Mode end;
			self:Refresh();
		end;

		function KbObj:Unregister(Id)
			if not self.Entries[Id] then return end;
			self.Entries[Id] = nil;
			for I, EntryId in self.OrderedIds do
				if EntryId == Id then
					table.remove(self.OrderedIds, I);
					break;
				end;
			end;
			self:Refresh();
		end;

		function KbObj:SetVisible(IsVisible)
			Gui.Enabled = IsVisible ~= false;
		end;

		function KbObj:Destroy()
			if Gui and Gui.Parent then Gui:Destroy() end;
		end;

		self.KeybindListState = KbObj;
		for _, Sync in self._KeybindSyncs do Sync() end;
		return KbObj;
	end;

-- Config
	function Library:GetConfig()
		local Out = {};
		for K, V in self.Flags do
			if typeof(V) == "Color3" then
				Out[K] = { Type = "Color3"; Hex = V:ToHex() };
			elseif typeof(V) == "EnumItem" then
				Out[K] = { Type = "EnumItem"; Enum = tostring(V.EnumType); Name = V.Name };
			else
				Out[K] = V;
			end;
		end;
		return HttpService:JSONEncode(Out);
	end;

	function Library:LoadConfig(Json)
		local Data = HttpService:JSONDecode(Json);
		if typeof(Data) ~= "table" then return end;
		for K, V in Data do
			if typeof(V) == "table" and V.Type == "Color3" and typeof(V.Hex) == "string" then
				V = Color3.fromHex(V.Hex);
			elseif typeof(V) == "table" and V.Type == "EnumItem" then
				local Et = Enum[V.Enum];
				if Et then
					local Ok2, Item = pcall(function() return Et[V.Name] end);
					if Ok2 then V = Item end;
				end;
			end;
			self.Flags[K] = V;
			local Fn = self.ConfigFlags[K];
			if typeof(Fn) == "function" then Fn(V) end;
		end;
	end;

	function Library:ConfigPath(Name)
		local Safe = tostring(Name):gsub("[<>:\"/\\|%?%*]", "_");
		return self.Directory .. "/Configs/" .. Safe .. ".cfg";
	end;

	function Library:EnsureConfigsFolder()
		if typeof(makefolder) == "function" then
			makefolder(self.Directory);
			makefolder(self.Directory .. "/Configs");
		end;
	end;

	function Library:ListConfigs()
		local Out = {};
		if typeof(listfiles) == "function" then
			local Files = listfiles(self.Directory .. "/Configs");
			if typeof(Files) == "table" then
				for _, P in Files do
					local Name = tostring(P):match("([^/\\]+)%.cfg$");
					if Name then table.insert(Out, Name) end;
				end;
			end;
		end;
		table.sort(Out);
		return Out;
	end;

	function Library:Configs(Options)
		Options = typeof(Options) == "table" and Options or {};

		local Existing = self.ConfigsState;
		if typeof(Existing) == "table" and typeof(Existing.Gui) == "Instance" and Existing.Gui.Parent then
			Existing.Gui:Destroy();
		end;
		self.ConfigsState = nil;
		self:EnsureConfigsFolder();

		local Gui = self:CreateInstance("ScreenGui", {
			Name = "configs";
			Parent = gethui and gethui() or CoreGui;
			Enabled = true;
			DisplayOrder = 1000;
			IgnoreGuiInset = true;
			ResetOnSpawn = false;
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
		});

		local Frame = self:CreateInstance("Frame", {
			Name = "ConfigsRoot";
			Parent = Gui;
			Position = Options.Position or UDim2.new(0, 545, 0, 70);
			Size = UDim2.new(0, 240, 0, 330);
			BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			BorderSizePixel = 0;
			Active = true;
		});
		self:CreateInstance("UIGradient", {
			Parent = Frame;
			Rotation = 90;
			Color = ColorSeq({
				ColorKey(0, Palette.Default.Top);
				ColorKey(1, Palette.Default.Bottom);
			});
		});
		self:ApplyDoubleOutline(Frame);
		self:AttachShadow(Frame);

		local Header = self:CreateInstance("Frame", {
			Name = "Header";
			Parent = Frame;
			Position = UDim2.new(0, 0, 0, 0);
			Size = UDim2.new(1, 0, 0, 22);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			ZIndex = 4;
		});
		local HeaderTitle = self:CreateInstance("TextLabel", {
			Name = "Title";
			Parent = Header;
			AnchorPoint = Vector2.new(0, 0.5);
			Position = UDim2.new(0, 8, 0.5, 0);
			Size = UDim2.new(1, -16, 0, 16);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			FontFace = Library.TitleFont;
			Text = "";
			RichText = true;
			TextColor3 = Color3.fromRGB(255, 255, 255);
			TextSize = 12;
			TextXAlignment = Enum.TextXAlignment.Left;
			TextYAlignment = Enum.TextYAlignment.Center;
			ZIndex = 5;
		});
		self:CreateInstance("UIStroke", {
			Parent = HeaderTitle;
			Color = Color3.fromRGB(0, 0, 0);
			Thickness = 1;
			ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
		});
		self:RegisterGradientTitle(HeaderTitle, tostring(Options.Title or "Configs"));
		self:Draggable(Frame, Header);

		local Section = self:CreateInstance("Frame", {
			Name = "Section";
			Parent = Frame;
			Position = UDim2.new(0, 6, 0, 24);
			Size = UDim2.new(1, -12, 1, -30);
			BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			BorderSizePixel = 0;
		});
		self:CreateInstance("UIGradient", {
			Parent = Section;
			Rotation = 90;
			Color = ColorSeq({
				ColorKey(0, Palette.Default.FooterBottom);
				ColorKey(1, Palette.Default.FooterTop);
			});
		});
		self:ApplyDoubleOutline(Section);
		self:CreateInstance("Frame", {
			Name = "AccentBar";
			Parent = Section;
			Position = UDim2.new(0, 1, 0, 2);
			Size = UDim2.new(1, -2, 0, 1);
			BackgroundColor3 = Palette.Default.Accent;
			BorderSizePixel = 0;
			ZIndex = 3;
		});
		self:CreateInstance("TextLabel", {
			Name = "Title";
			Parent = Section;
			Position = UDim2.new(0, 10, 0, 6);
			Size = UDim2.new(1, -20, 0, 16);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			FontFace = Library.Fonts.Proggy;
			Text = "Configurations";
			TextColor3 = Palette.Default.TabInactive;
			TextSize = 12;
			TextXAlignment = Enum.TextXAlignment.Left;
			TextYAlignment = Enum.TextYAlignment.Center;
			ZIndex = 3;
		});

		local ListBg = self:CreateInstance("Frame", {
			Name = "ListBg";
			Parent = Section;
			Position = UDim2.new(0, 8, 0, 26);
			Size = UDim2.new(1, -16, 1, -96);
			BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			BorderSizePixel = 0;
		});
		self:CreateInstance("UIGradient", {
			Parent = ListBg;
			Rotation = 90;
			Color = ColorSeq({
				ColorKey(0, Palette.Default.Bottom);
				ColorKey(1, Palette.Default.Top);
			});
		});
		self:ApplyDoubleOutline(ListBg);

		local List = self:CreateInstance("ScrollingFrame", {
			Name = "List";
			Parent = ListBg;
			Position = UDim2.new(0, 4, 0, 4);
			Size = UDim2.new(1, -8, 1, -8);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			ScrollBarThickness = 2;
			ScrollBarImageColor3 = Palette.Default.Accent;
			CanvasSize = UDim2.new(0, 0, 0, 0);
			AutomaticCanvasSize = Enum.AutomaticSize.Y;
			ZIndex = 3;
		});
		self:CreateInstance("UIListLayout", {
			Parent = List;
			FillDirection = Enum.FillDirection.Vertical;
			SortOrder = Enum.SortOrder.LayoutOrder;
			Padding = UDim.new(0, 2);
		});

		local EmptyLbl = self:CreateInstance("TextLabel", {
			Name = "Empty";
			Parent = ListBg;
			AnchorPoint = Vector2.new(0.5, 0);
			Position = UDim2.new(0.5, 0, 0, 6);
			Size = UDim2.new(1, -8, 0, 16);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			FontFace = Library.Fonts.Proggy;
			Text = "<no configs>";
			TextColor3 = Palette.Default.TabInactive;
			TextSize = 12;
			TextXAlignment = Enum.TextXAlignment.Center;
			TextYAlignment = Enum.TextYAlignment.Center;
			ZIndex = 4;
		});
		self:CreateInstance("UIStroke", {
			Parent = EmptyLbl;
			Color = Color3.fromRGB(0, 0, 0);
			Thickness = 1;
			ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
		});

		local Selected;
		local LibRefC = self;

		local function MakeButton(Parent, Text, Pos, Size, Anchor)
			local Btn = LibRefC:CreateInstance("TextButton", {
				Parent = Parent;
				AnchorPoint = Anchor or Vector2.new(0, 0);
				Position = Pos;
				Size = Size;
				AutoButtonColor = false;
				Text = "";
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BorderSizePixel = 0;
			});
			LibRefC:CreateInstance("UIGradient", {
				Parent = Btn;
				Rotation = 90;
				Color = ColorSeq({
					ColorKey(0, Palette.Default.Top);
					ColorKey(1, Palette.Default.Bottom);
				});
			});
			LibRefC:ApplyDoubleOutline(Btn);
			local Lbl = LibRefC:CreateInstance("TextLabel", {
				Parent = Btn;
				AnchorPoint = Vector2.new(0.5, 0.5);
				Position = UDim2.new(0.5, 0, 0.5, 0);
				Size = UDim2.new(1, 0, 1, 0);
				BackgroundTransparency = 1;
				BorderSizePixel = 0;
				FontFace = Library.Fonts.Proggy;
				Text = Text;
				TextColor3 = Color3.fromRGB(255, 255, 255);
				TextSize = 12;
				TextXAlignment = Enum.TextXAlignment.Center;
				TextYAlignment = Enum.TextYAlignment.Center;
				ZIndex = 3;
			});
			LibRefC:CreateInstance("UIStroke", {
				Parent = Lbl;
				Color = Color3.fromRGB(0, 0, 0);
				Thickness = 1;
				ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
			});
			return Btn;
		end;

		local InputBox = self:CreateInstance("Frame", {
			Name = "InputBg";
			Parent = Section;
			AnchorPoint = Vector2.new(0, 1);
			Position = UDim2.new(0, 8, 1, -52);
			Size = UDim2.new(1, -16, 0, 18);
			BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			BorderSizePixel = 0;
		});
		self:CreateInstance("UIGradient", {
			Parent = InputBox;
			Rotation = 90;
			Color = ColorSeq({
				ColorKey(0, Palette.Default.Bottom);
				ColorKey(1, Palette.Default.Top);
			});
		});
		self:ApplyDoubleOutline(InputBox);
		local TextInput = self:CreateInstance("TextBox", {
			Name = "Input";
			Parent = InputBox;
			Position = UDim2.new(0, 6, 0, 0);
			Size = UDim2.new(1, -12, 1, 0);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			FontFace = Library.Fonts.Proggy;
			Text = "";
			PlaceholderText = "Config name...";
			PlaceholderColor3 = Palette.Default.TabInactive;
			TextColor3 = Color3.fromRGB(255, 255, 255);
			TextSize = 12;
			TextXAlignment = Enum.TextXAlignment.Left;
			TextYAlignment = Enum.TextYAlignment.Center;
			ClipsDescendants = true;
			ClearTextOnFocus = false;
			ZIndex = 3;
		});
		self:CreateInstance("UIStroke", {
			Parent = TextInput;
			Color = Color3.fromRGB(0, 0, 0);
			Thickness = 1;
			ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
		});

		local BotAnchor = Vector2.new(0, 1);
		local LoadBtn   = MakeButton(Section, "Load",   UDim2.new(0,   8, 1, -26), UDim2.new(0.5, -10, 0, 18), BotAnchor);
		local SaveBtn   = MakeButton(Section, "Save",   UDim2.new(0.5, 2, 1, -26), UDim2.new(0.5, -10, 0, 18), BotAnchor);
		local CreateBtn = MakeButton(Section, "Create", UDim2.new(0,   8, 1, -4),  UDim2.new(0.5, -10, 0, 18), BotAnchor);
		local RemoveBtn = MakeButton(Section, "Remove", UDim2.new(0.5, 2, 1, -4),  UDim2.new(0.5, -10, 0, 18), BotAnchor);

		local Items = {};
		local function Refresh()
			LibRefC:EnsureConfigsFolder();
			for _, It in Items do It:Destroy() end;
			table.clear(Items);
			local Names = LibRefC:ListConfigs();
			EmptyLbl.Visible = (#Names == 0);
			for I, Name in Names do
				local Row = LibRefC:CreateInstance("TextButton", {
					Parent = List;
					Size = UDim2.new(1, 0, 0, 16);
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					AutoButtonColor = false;
					Text = "";
					LayoutOrder = I;
					ZIndex = 3;
				});
				local Lbl = LibRefC:CreateInstance("TextLabel", {
					Parent = Row;
					Position = UDim2.new(0, 6, 0, 0);
					Size = UDim2.new(1, -12, 1, 0);
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					FontFace = Library.Fonts.Proggy;
					Text = Name;
					TextColor3 = (Name == Selected) and Palette.Default.TabActive or Color3.fromRGB(200, 200, 200);
					TextSize = 12;
					TextXAlignment = Enum.TextXAlignment.Center;
					TextYAlignment = Enum.TextYAlignment.Center;
					ZIndex = 4;
				});
				LibRefC:CreateInstance("UIStroke", {
					Parent = Lbl;
					Color = Color3.fromRGB(0, 0, 0);
					Thickness = 1;
					ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
				});
				LibRefC:Connection(Row.MouseEnter, function()
					if Selected ~= Name then Lbl.TextColor3 = Color3.fromRGB(255, 255, 255) end;
				end);
				LibRefC:Connection(Row.MouseLeave, function()
					Lbl.TextColor3 = (Name == Selected) and Palette.Default.TabActive or Color3.fromRGB(200, 200, 200);
				end);
				LibRefC:Connection(Row.MouseButton1Click, function()
					Selected = Name;
					TextInput.Text = Name;
					Refresh();
				end);
				table.insert(Items, Row);
			end;
		end;
		Refresh();

		LibRefC:Connection(CreateBtn.MouseButton1Click, function()
			local Name = TextInput.Text:gsub("^%s+", ""):gsub("%s+$", "");
			if Name == "" then return end;
			if typeof(writefile) ~= "function" then return end;
			local Path = LibRefC:ConfigPath(Name);
			if typeof(isfile) == "function" and isfile(Path) then return end;
			local Json = LibRefC:GetConfig();
			if typeof(Json) ~= "string" then Json = "{}" end;
			writefile(Path, Json);
			Selected = Name;
			Refresh();
		end);

		LibRefC:Connection(SaveBtn.MouseButton1Click, function()
			local Name = TextInput.Text:gsub("^%s+", ""):gsub("%s+$", "");
			if Name == "" then Name = Selected end;
			if not Name or Name == "" then return end;
			if typeof(writefile) ~= "function" then return end;
			local Path = LibRefC:ConfigPath(Name);
			local Json = LibRefC:GetConfig();
			if typeof(Json) ~= "string" then Json = "{}" end;
			writefile(Path, Json);
			Selected = Name;
			Refresh();
		end);

		LibRefC:Connection(LoadBtn.MouseButton1Click, function()
			local Name = TextInput.Text:gsub("^%s+", ""):gsub("%s+$", "");
			if Name == "" then Name = Selected end;
			if not Name or Name == "" then return end;
			if typeof(readfile) ~= "function" then return end;
			local Path = LibRefC:ConfigPath(Name);
			if typeof(isfile) == "function" and not isfile(Path) then return end;
			local Data = readfile(Path);
			if typeof(Data) == "string" then
			LibRefC:LoadConfig(Data);
				LibRefC.ActiveConfigName = Name;
			end;
		end);
		LibRefC:Connection(RemoveBtn.MouseButton1Click, function()
			local Name = TextInput.Text:gsub("^%s+", ""):gsub("%s+$", "");
			if Name == "" then Name = Selected end;
			if not Name or Name == "" then return end;
			if typeof(delfile) ~= "function" then return end;
			local Path = LibRefC:ConfigPath(Name);
			if typeof(isfile) == "function" and not isfile(Path) then return end;
			delfile(Path);
			if Selected == Name then Selected = nil; TextInput.Text = "" end;
			Refresh();
		end);

		local ConfigsObj = {
			Gui = Gui;
			Frame = Frame;
			Refresh = Refresh;
		};
		function ConfigsObj:SetVisible(IsVisible)
			Gui.Enabled = IsVisible ~= false;
		end;
		function ConfigsObj:Destroy()
			if Gui and Gui.Parent then Gui:Destroy() end;
		end;
		self.ConfigsState = ConfigsObj;
		return ConfigsObj;
	end;

-- Player List
	Library._PlayerTags = Library._PlayerTags or {};
	Library.PlayerTagColors = {
		None     = Color3.fromRGB(176, 175, 180);
		Enemy    = Color3.fromRGB(230, 128, 138);
		Friend   = Color3.fromRGB(150, 168, 226);
		Caution  = Color3.fromRGB(236, 210, 138);
	};

	function Library:PlayerList(Options)
		Options = typeof(Options) == "table" and Options or {};

		local Embedded = typeof(Options.Parent) == "Instance";

		local Existing = self.PlayerListState;
		if typeof(Existing) == "table" and not Existing._Embedded and typeof(Existing.Gui) == "Instance" and Existing.Gui.Parent then
			Existing.Gui:Destroy();
		end;
		self.PlayerListState = nil;

		local Players = game:GetService("Players");

		local Gui;
		if Embedded then
			Gui = Options.Gui or Options.Parent:FindFirstAncestorOfClass("ScreenGui");
		else
			Gui = self:CreateInstance("ScreenGui", {
				Name = "player_list";
				Parent = gethui and gethui() or CoreGui;
				Enabled = true;
				DisplayOrder = 1000;
				IgnoreGuiInset = true;
				ResetOnSpawn = false;
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
			});
		end;

		local Frame = self:CreateInstance("Frame", {
			Name = "PlayerListRoot";
			Parent = Embedded and Options.Parent or Gui;
			AnchorPoint = Vector2.new(0, 0);
			Position = Embedded and UDim2.new(0, 0, 0, 0) or (Options.Position or UDim2.new(0, 545, 0, 410));
			Size = Embedded and UDim2.new(1, 0, 0, 400) or UDim2.new(0, 480, 0, 400);
			BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			BackgroundTransparency = Embedded and 1 or 0;
			BorderSizePixel = 0;
			Active = true;
		});
		if not Embedded then
			self:CreateInstance("UIGradient", {
				Parent = Frame;
				Rotation = 90;
				Color = ColorSeq({
					ColorKey(0, Palette.Default.Top);
					ColorKey(1, Palette.Default.Bottom);
				});
			});
			self:ApplyDoubleOutline(Frame);
			self:AttachShadow(Frame);
		end;

		if not Embedded then
			local Header = self:CreateInstance("Frame", {
				Name = "Header";
				Parent = Frame;
				Position = UDim2.new(0, 0, 0, 0);
				Size = UDim2.new(1, 0, 0, 22);
				BackgroundTransparency = 1;
				BorderSizePixel = 0;
				ZIndex = 4;
			});
			local HeaderTitle = self:CreateInstance("TextLabel", {
				Name = "Title";
				Parent = Header;
				AnchorPoint = Vector2.new(0, 0.5);
				Position = UDim2.new(0, 8, 0.5, 0);
				Size = UDim2.new(1, -16, 0, 16);
				BackgroundTransparency = 1;
				BorderSizePixel = 0;
				FontFace = Library.TitleFont;
				Text = "";
				RichText = true;
				TextColor3 = Color3.fromRGB(255, 255, 255);
				TextSize = 12;
				TextXAlignment = Enum.TextXAlignment.Left;
				TextYAlignment = Enum.TextYAlignment.Center;
				ZIndex = 5;
			});
			self:CreateInstance("UIStroke", {
				Parent = HeaderTitle;
				Color = Color3.fromRGB(0, 0, 0);
				Thickness = 1;
				ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
			});
			self:RegisterGradientTitle(HeaderTitle, tostring(Options.Title or "Player List"));
			self:Draggable(Frame, Header);
		end;

		local Section = self:CreateInstance("Frame", {
			Name = "Section";
			Parent = Frame;
			Position = Embedded and UDim2.new(0, 0, 0, 0) or UDim2.new(0, 6, 0, 24);
			Size = Embedded and UDim2.new(1, 0, 1, 0) or UDim2.new(1, -12, 1, -30);
			BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			BorderSizePixel = 0;
		});
		self:CreateInstance("UIGradient", {
			Parent = Section;
			Rotation = 90;
			Color = ColorSeq({
				ColorKey(0, Palette.Default.FooterBottom);
				ColorKey(1, Palette.Default.FooterTop);
			});
		});
		self:ApplyDoubleOutline(Section);
		local PlHeader = self:CreateInstance("Frame", {
			Name = "HeaderBox";
			Parent = Section;
			Position = UDim2.new(0, 1, 0, 1);
			Size = UDim2.new(1, -2, 0, 24);
			BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			BorderSizePixel = 0;
			ZIndex = 2;
		});
		self:CreateInstance("UIGradient", {
			Parent = PlHeader;
			Rotation = 90;
			Color = ColorSeq({
				ColorKey(0, Palette.Default.InnerOutline);
				ColorKey(1, Palette.Default.FooterBottom);
			});
		});
		local PlTitle = self:CreateInstance("TextLabel", {
			Name = "Title";
			Parent = PlHeader;
			Position = UDim2.new(0, 8, 0, 0);
			Size = UDim2.new(1, -16, 1, 0);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			FontFace = Library.Fonts.Proggy;
			Text = "Players";
			TextColor3 = Palette.Default.TabInactive;
			TextSize = 12;
			TextXAlignment = Enum.TextXAlignment.Left;
			TextYAlignment = Enum.TextYAlignment.Center;
			ZIndex = 3;
		});
		self:CreateInstance("UIStroke", {
			Parent = PlTitle;
			Color = Color3.fromRGB(0, 0, 0);
			Thickness = 1;
			ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
		});

		local SearchBg = self:CreateInstance("Frame", {
			Name = "SearchBg";
			Parent = Section;
			Position = UDim2.new(0, 8, 0, 26);
			Size = UDim2.new(1, -16, 0, 16);
			BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			BorderSizePixel = 0;
		});
		self:CreateInstance("UIGradient", {
			Parent = SearchBg;
			Rotation = 90;
			Color = ColorSeq({
				ColorKey(0, Palette.Default.Bottom);
				ColorKey(1, Palette.Default.Top);
			});
		});
		self:ApplyDoubleOutline(SearchBg);
		local SearchInput = self:CreateInstance("TextBox", {
			Name = "Input";
			Parent = SearchBg;
			Position = UDim2.new(0, 6, 0, 0);
			Size = UDim2.new(1, -12, 1, 0);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			FontFace = Library.Fonts.Proggy;
			Text = "";
			PlaceholderText = "Search...";
			PlaceholderColor3 = Palette.Default.TabInactive;
			TextColor3 = Color3.fromRGB(255, 255, 255);
			TextSize = 12;
			TextXAlignment = Enum.TextXAlignment.Left;
			TextYAlignment = Enum.TextYAlignment.Center;
			ClipsDescendants = true;
			ClearTextOnFocus = false;
			ZIndex = 3;
		});
		self:CreateInstance("UIStroke", {
			Parent = SearchInput;
			Color = Color3.fromRGB(0, 0, 0);
			Thickness = 1;
			ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
		});

		local ListBg = self:CreateInstance("Frame", {
			Name = "ListBg";
			Parent = Section;
			Position = UDim2.new(0, 8, 0, 46);
			Size = UDim2.new(1, -16, 1, -176);
			BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			BorderSizePixel = 0;
		});
		self:CreateInstance("UIGradient", {
			Parent = ListBg;
			Rotation = 90;
			Color = ColorSeq({
				ColorKey(0, Palette.Default.Bottom);
				ColorKey(1, Palette.Default.Top);
			});
		});
		self:ApplyDoubleOutline(ListBg);
		local List = self:CreateInstance("ScrollingFrame", {
			Name = "List";
			Parent = ListBg;
			Position = UDim2.new(0, 4, 0, 4);
			Size = UDim2.new(1, -8, 1, -8);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			ScrollBarThickness = 2;
			ScrollBarImageColor3 = Palette.Default.Accent;
			CanvasSize = UDim2.new(0, 0, 0, 0);
			AutomaticCanvasSize = Enum.AutomaticSize.Y;
			ZIndex = 3;
		});
		self:CreateInstance("UIListLayout", {
			Parent = List;
			FillDirection = Enum.FillDirection.Vertical;
			SortOrder = Enum.SortOrder.LayoutOrder;
			Padding = UDim.new(0, 2);
		});

		local Bottom = self:CreateInstance("Frame", {
			Name = "Bottom";
			Parent = Section;
			AnchorPoint = Vector2.new(0, 1);
			Position = UDim2.new(0, 8, 1, -8);
			Size = UDim2.new(1, -16, 0, 116);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			Visible = false;
		});

		local Headshot = self:CreateInstance("ImageLabel", {
			Name = "Headshot";
			Parent = Bottom;
			Position = UDim2.new(0, 0, 0, 0);
			Size = UDim2.new(0, 116, 0, 116);
			BackgroundColor3 = Palette.Default.Bottom;
			BorderSizePixel = 0;
			ScaleType = Enum.ScaleType.Crop;
			Image = "";
		});
		self:ApplyDoubleOutline(Headshot);

		local function MakeBtn(Parent, Text, Pos, Size)
			local Btn = self:CreateInstance("TextButton", {
				Parent = Parent;
				Position = Pos;
				Size = Size;
				AutoButtonColor = false;
				Text = "";
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BorderSizePixel = 0;
			});
			self:CreateInstance("UIGradient", {
				Parent = Btn;
				Rotation = 90;
				Color = ColorSeq({
					ColorKey(0, Palette.Default.Top);
					ColorKey(1, Palette.Default.Bottom);
				});
			});
			self:ApplyDoubleOutline(Btn);
			local Lbl = self:CreateInstance("TextLabel", {
				Parent = Btn;
				AnchorPoint = Vector2.new(0.5, 0.5);
				Position = UDim2.new(0.5, 0, 0.5, 0);
				Size = UDim2.new(1, 0, 1, 0);
				BackgroundTransparency = 1;
				BorderSizePixel = 0;
				FontFace = Library.Fonts.Proggy;
				Text = Text;
				TextColor3 = Color3.fromRGB(255, 255, 255);
				TextSize = 12;
				TextXAlignment = Enum.TextXAlignment.Center;
				TextYAlignment = Enum.TextYAlignment.Center;
				ZIndex = 3;
			});
			self:CreateInstance("UIStroke", {
				Parent = Lbl;
				Color = Color3.fromRGB(0, 0, 0);
				Thickness = 1;
				ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
			});
			return Btn;
		end;

		local TpBtn = MakeBtn(Bottom, "Teleport", UDim2.new(0, 124, 0, 0),  UDim2.new(0, 130, 0, 56));
		local SpBtn = MakeBtn(Bottom, "Spectate", UDim2.new(0, 124, 0, 60), UDim2.new(0, 130, 0, 56));

		local SelectedNameLbl = self:CreateInstance("TextLabel", {
			Name = "SelectedName";
			Parent = Bottom;
			Position = UDim2.new(0, 268, 0, 0);
			Size = UDim2.new(1, -268, 0, 16);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			FontFace = Library.Fonts.Proggy;
			Text = "";
			TextColor3 = Color3.fromRGB(255, 255, 255);
			TextSize = 12;
			TextXAlignment = Enum.TextXAlignment.Left;
			TextYAlignment = Enum.TextYAlignment.Center;
		});
		self:CreateInstance("UIStroke", {
			Parent = SelectedNameLbl;
			Color = Color3.fromRGB(0, 0, 0);
			Thickness = 1;
			ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
		});

		local TagBox = self:CreateInstance("Frame", {
			Name = "TagBox";
			Parent = Bottom;
			Position = UDim2.new(0, 268, 0, 22);
			Size = UDim2.new(1, -268, 0, 18);
			BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			BorderSizePixel = 0;
		});
		self:CreateInstance("UIGradient", {
			Parent = TagBox;
			Rotation = 90;
			Color = ColorSeq({
				ColorKey(0, Palette.Default.Bottom);
				ColorKey(1, Palette.Default.Top);
			});
		});
		self:ApplyDoubleOutline(TagBox);
		local TagLbl = self:CreateInstance("TextLabel", {
			Parent = TagBox;
			Position = UDim2.new(0, 8, 0, 0);
			Size = UDim2.new(1, -28, 1, 0);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			FontFace = Library.Fonts.Proggy;
			Text = "None";
			TextColor3 = Palette.Default.TabInactive;
			TextSize = 12;
			TextXAlignment = Enum.TextXAlignment.Left;
			TextYAlignment = Enum.TextYAlignment.Center;
			ZIndex = 3;
		});
		self:CreateInstance("UIStroke", {
			Parent = TagLbl;
			Color = Color3.fromRGB(0, 0, 0);
			Thickness = 1;
			ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
		});
		local TagSign = self:CreateInstance("TextLabel", {
			Parent = TagBox;
			AnchorPoint = Vector2.new(1, 0.5);
			Position = UDim2.new(1, -8, 0.5, 0);
			Size = UDim2.new(0, 12, 1, 0);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			FontFace = Library.Fonts.Proggy;
			Text = "+";
			TextColor3 = Color3.fromRGB(255, 255, 255);
			TextSize = 12;
			TextXAlignment = Enum.TextXAlignment.Center;
			TextYAlignment = Enum.TextYAlignment.Center;
			ZIndex = 3;
		});
		self:CreateInstance("UIStroke", {
			Parent = TagSign;
			Color = Color3.fromRGB(0, 0, 0);
			Thickness = 1;
			ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
		});
		local TagTrig = self:CreateInstance("TextButton", {
			Parent = TagBox;
			BackgroundTransparency = 1;
			AutoButtonColor = false;
			Text = "";
			Size = UDim2.new(1, 0, 1, 0);
			ZIndex = 5;
		});

		local SelectedPlayer;
		local Rows = {};
		local RowColorCache = {};
		local LibRefP = self;
		local TagTween = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

		local function ColorForTag(Tag)
			local C = Library.PlayerTagColors[Tag];
			if C then return C end;
			return Color3.fromRGB(255, 255, 255);
		end;

		local ContentProvider = game:GetService("ContentProvider");
		local Preloaded = {};
		local function PreloadHeadshot(Plr)
			if not Plr or Preloaded[Plr.UserId] then return end;
			Preloaded[Plr.UserId] = true;
			local Url = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(Plr.UserId) .. "&w=150&h=150";
			task.spawn(function()
				pcall(function() ContentProvider:PreloadAsync({ Url }) end);
			end);
		end;
		local function RebuildHeadshot(Plr)
			if not Plr then Headshot.Image = ""; return end;
			local Url = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(Plr.UserId) .. "&w=150&h=150";
			Headshot.Image = Url;
		end;

		local function RefreshTagDisplay()
			if not SelectedPlayer or not SelectedPlayer.Parent then
				TagLbl.Text = "None";
				LibRefP:Tween(TagLbl, TagTween, { TextColor3 = Palette.Default.TabInactive }):Play();
				return;
			end;
			local Tag = Library._PlayerTags[SelectedPlayer.Name] or "None";
			TagLbl.Text = Tag;
			LibRefP:Tween(TagLbl, TagTween, { TextColor3 = (Tag == "None") and Palette.Default.TabInactive or ColorForTag(Tag) }):Play();
		end;

		local Refresh;
		local function DisplayName(Plr)
			if not Plr then return "" end;
			if Library._Anonymous and Plr == Players.LocalPlayer then return "hidden" end;
			return Plr.Name;
		end;
		local PanelTween = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
		local FrameFullH = Frame.Size.Y.Offset;
		local FrameSmallH = FrameFullH - 122;
		local function SetPanel(Shown, Animate)
			local Fh = Shown and FrameFullH or FrameSmallH;
			local Lo = Shown and -176 or -54;
			local FrameGoal = Embedded and UDim2.new(1, 0, 0, Fh) or UDim2.new(0, Frame.Size.X.Offset, 0, Fh);
			if Animate == false then
				Frame.Size = FrameGoal;
				ListBg.Size = UDim2.new(1, -16, 1, Lo);
			else
				LibRefP:Tween(Frame, PanelTween, { Size = FrameGoal }):Play();
				LibRefP:Tween(ListBg, PanelTween, { Size = UDim2.new(1, -16, 1, Lo) }):Play();
			end;
		end;

		local function SelectPlayer(Plr)
			local Was = SelectedPlayer;
			SelectedPlayer = Plr;
			if Plr then
				SelectedNameLbl.Text = DisplayName(Plr);
				RebuildHeadshot(Plr);
				RefreshTagDisplay();
				if not Was then LibRefP:FadeFrame(Bottom, true); SetPanel(true) end;
			else
				LibRefP:FadeFrame(Bottom, false);
				SetPanel(false);
			end;
			if Refresh then Refresh() end;
		end;

		function Refresh()
			for _, R in Rows do R:Destroy() end;
			table.clear(Rows);
			local Filter = string.lower(SearchInput.Text or "");
			local LocalPlr = Players.LocalPlayer;
			local PlayerList = Players:GetPlayers();
			table.sort(PlayerList, function(A, B) return A.Name:lower() < B.Name:lower() end);
			for I, Plr in PlayerList do
				if Filter == "" or string.find(string.lower(Plr.Name), Filter, 1, true) then
					local DispName = DisplayName(Plr);
					local Suffix = (Plr == LocalPlr) and " (Client)" or "";
					local Tag = Library._PlayerTags[Plr.Name] or "None";
					local Row = LibRefP:CreateInstance("TextButton", {
						Parent = List;
						Size = UDim2.new(1, 0, 0, 16);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						AutoButtonColor = false;
						Text = "";
						LayoutOrder = I;
						ZIndex = 3;
					});
					local IsSelected = SelectedPlayer == Plr;
					local TargetColor = (Tag ~= "None") and ColorForTag(Tag)
						or (IsSelected and Palette.Default.TabActive or Color3.fromRGB(220, 220, 220));
					local StartColor = RowColorCache[Plr.Name] or TargetColor;
					RowColorCache[Plr.Name] = TargetColor;
					local Lbl = LibRefP:CreateInstance("TextLabel", {
						Parent = Row;
						Position = UDim2.new(0, 6, 0, 0);
						Size = UDim2.new(1, -12, 1, 0);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						FontFace = Library.Fonts.Proggy;
						Text = DispName .. Suffix;
						TextColor3 = StartColor;
						TextSize = 12;
						TextXAlignment = Enum.TextXAlignment.Center;
						TextYAlignment = Enum.TextYAlignment.Center;
						ZIndex = 4;
					});
					LibRefP:CreateInstance("UIStroke", {
						Parent = Lbl;
						Color = Color3.fromRGB(0, 0, 0);
						Thickness = 1;
						ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
					});
					LibRefP:Tween(Lbl, TagTween, { TextColor3 = TargetColor }):Play();
					LibRefP:Connection(Row.MouseButton1Click, function()
						if SelectedPlayer == Plr then SelectPlayer(nil) else SelectPlayer(Plr) end;
					end);
					table.insert(Rows, Row);
				end;
			end;
		end;

		local TagOptions = { "None", "Enemy", "Friend", "Caution" };
		local TagPopup;
		local TagOptionRows = {};
		local TagOpen = false;

		local OpenTagDropdown, CloseTagDropdown;
		local TagFadeItems = {};
		local function BuildTagFade()
			table.clear(TagFadeItems);
			if not TagPopup then return end;
			TagFadeItems[#TagFadeItems + 1] = { TagPopup, "BackgroundTransparency", TagPopup.BackgroundTransparency };
			for _, D in TagPopup:GetDescendants() do
				if D:IsA("GuiObject") then
					TagFadeItems[#TagFadeItems + 1] = { D, "BackgroundTransparency", D.BackgroundTransparency };
					if D:IsA("TextLabel") or D:IsA("TextButton") or D:IsA("TextBox") then
						TagFadeItems[#TagFadeItems + 1] = { D, "TextTransparency", D.TextTransparency };
					end;
				elseif D:IsA("UIStroke") then
					TagFadeItems[#TagFadeItems + 1] = { D, "Transparency", D.Transparency };
				end;
			end;
		end;
		local function SetTagFade(Shown, Animate)
			for _, E in TagFadeItems do
				local Goal = Shown and E[3] or 1;
				if Animate then
					LibRefP:Tween(E[1], TagTween, { [E[2]] = Goal }):Play();
				else
					E[1][E[2]] = Goal;
				end;
			end;
		end;
		local function TagPopupHeight()
			return #TagOptions * 16 + math.max(0, #TagOptions - 1) * 3 + 8;
		end;
		local function PositionTagPopup()
			if not TagPopup then return end;
			local Tp, Ts = TagBox.AbsolutePosition, TagBox.AbsoluteSize;
			local Ph = TagPopupHeight();
			local Vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(0, 0);
			local OpenAbove = (Tp.Y + Ts.Y + 63 + Ph) > Vp.Y;
			if OpenAbove then
				TagPopup.Position = UDim2.new(0, Tp.X, 0, Tp.Y - Ph + 61);
			else
				TagPopup.Position = UDim2.new(0, Tp.X, 0, Tp.Y + Ts.Y + 63);
			end;
			TagPopup.Size = UDim2.new(0, Ts.X, 0, TagOpen and Ph or 0);
		end;

		local function RefreshTagOptionColors()
			local Cur = (SelectedPlayer and Library._PlayerTags[SelectedPlayer.Name]) or "None";
			for _, Entry in TagOptionRows do
				local C;
				if Entry.Hovered then
					C = Color3.fromRGB(255, 255, 255);
				else
					local IsSel = Entry.Value == Cur;
					if IsSel then
						C = (Entry.Value == "None") and Palette.Default.TabActive or ColorForTag(Entry.Value);
					else
						C = (Entry.Value == "None") and Color3.fromRGB(200, 200, 200) or ColorForTag(Entry.Value);
					end;
				end;
				LibRefP:Tween(Entry.Label, TagTween, { TextColor3 = C }):Play();
			end;
		end;

		local function BuildTagPopup()
			TagPopup = LibRefP:CreateInstance("Frame", {
				Name = "TagDropdownPopup";
				Parent = Gui;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BorderSizePixel = 0;
				Visible = false;
				ClipsDescendants = true;
				ZIndex = 500;
			});
			LibRefP:CreateInstance("UIGradient", {
				Parent = TagPopup;
				Rotation = 90;
				Color = ColorSeq({
					ColorKey(0, Palette.Default.FooterBottom);
					ColorKey(1, Palette.Default.FooterTop);
				});
			});
			LibRefP:ApplyDoubleOutline(TagPopup);

			local PopupList = LibRefP:CreateInstance("Frame", {
				Name = "List";
				Parent = TagPopup;
				BackgroundTransparency = 1;
				BorderSizePixel = 0;
				Size = UDim2.new(1, 0, 1, 0);
				ZIndex = 501;
			});
			LibRefP:CreateInstance("UIPadding", {
				Parent = PopupList;
				PaddingTop = UDim.new(0, 4);
				PaddingBottom = UDim.new(0, 4);
			});
			LibRefP:CreateInstance("UIListLayout", {
				Parent = PopupList;
				FillDirection = Enum.FillDirection.Vertical;
				SortOrder = Enum.SortOrder.LayoutOrder;
				Padding = UDim.new(0, 3);
			});

			for I, Opt in TagOptions do
				local OptRow = LibRefP:CreateInstance("TextButton", {
					Name = "Opt_" .. tostring(I);
					Parent = PopupList;
					Size = UDim2.new(1, 0, 0, 16);
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					AutoButtonColor = false;
					Text = "";
					LayoutOrder = I;
					ZIndex = 502;
				});
				local BaseColor = (Opt == "None") and Color3.fromRGB(200, 200, 200) or ColorForTag(Opt);
				local OL = LibRefP:CreateInstance("TextLabel", {
					Name = "Label";
					Parent = OptRow;
					Position = UDim2.new(0, 8, 0, 0);
					Size = UDim2.new(1, -16, 1, 0);
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					FontFace = Library.Fonts.Proggy;
					Text = Opt;
					TextColor3 = BaseColor;
					TextSize = 12;
					TextXAlignment = Enum.TextXAlignment.Left;
					TextYAlignment = Enum.TextYAlignment.Center;
					ZIndex = 503;
				});
				LibRefP:CreateInstance("UIStroke", {
					Parent = OL;
					Color = Color3.fromRGB(0, 0, 0);
					Thickness = 1;
					ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
				});
				local Entry = { Button = OptRow, Label = OL, Value = Opt, Hovered = false };
				table.insert(TagOptionRows, Entry);

				LibRefP:Connection(OptRow.MouseEnter, function()
					Entry.Hovered = true;
					RefreshTagOptionColors();
				end);
				LibRefP:Connection(OptRow.MouseLeave, function()
					Entry.Hovered = false;
					RefreshTagOptionColors();
				end);
				LibRefP:Connection(OptRow.MouseButton1Click, function()
					if SelectedPlayer then
						if Opt == "None" then
							Library._PlayerTags[SelectedPlayer.Name] = nil;
						else
							Library._PlayerTags[SelectedPlayer.Name] = Opt;
						end;
					end;
					CloseTagDropdown();
					RefreshTagDisplay();
					if Refresh then Refresh() end;
				end);
			end;
			BuildTagFade();
		end;

		OpenTagDropdown = function()
			if TagOpen then return end;
			if not SelectedPlayer then return end;
			if not TagPopup then BuildTagPopup() end;
			TagOpen = true;
			TagSign.Text = "-";
			PositionTagPopup();
			RefreshTagOptionColors();
			local Ph = TagPopupHeight();
			local W = TagPopup.Size.X.Offset;
			TagPopup.Size = UDim2.new(0, W, 0, 0);
			SetTagFade(false, false);
			TagPopup.Visible = true;
			LibRefP:Tween(TagPopup, TagTween, { Size = UDim2.new(0, W, 0, Ph) }):Play();
			SetTagFade(true, true);
		end;

		CloseTagDropdown = function()
			if not TagOpen then return end;
			TagOpen = false;
			TagSign.Text = "+";
			if TagPopup then
				local W = TagPopup.Size.X.Offset;
				local T = LibRefP:Tween(TagPopup, TagTween, { Size = UDim2.new(0, W, 0, 0) });
				T.Completed:Connect(function()
					if not TagOpen then TagPopup.Visible = false end;
				end);
				T:Play();
				SetTagFade(false, true);
			end;
		end;

		self:Connection(TagTrig.MouseButton1Click, function()
			if TagOpen then CloseTagDropdown() else OpenTagDropdown() end;
		end);
		self:Connection(TagBox:GetPropertyChangedSignal("AbsolutePosition"), function()
			if TagOpen then PositionTagPopup() end;
		end);
		self:Connection(UserInputService.InputBegan, function(input)
			if not TagOpen then return end;
			if input.UserInputType ~= Enum.UserInputType.MouseButton1
				and input.UserInputType ~= Enum.UserInputType.Touch then
				return;
			end;
			local Mp = UserInputService:GetMouseLocation() - Vector2.new(0, GuiInset);
			local function Inside(F)
				if not F then return false end;
				local P, S = F.AbsolutePosition, F.AbsoluteSize;
				return Mp.X >= P.X and Mp.X <= P.X + S.X
					and Mp.Y >= P.Y and Mp.Y <= P.Y + S.Y;
			end;
			if not Inside(TagPopup) and not Inside(TagBox) then
				CloseTagDropdown();
			end;
		end);

		self:Connection(TpBtn.MouseButton1Click, function()
			if not SelectedPlayer or SelectedPlayer == Players.LocalPlayer then return end;
			local Lp = Players.LocalPlayer;
			local Char = Lp and Lp.Character;
			local Hrp = Char and Char:FindFirstChild("HumanoidRootPart");
			local TC = SelectedPlayer.Character;
			local THrp = TC and TC:FindFirstChild("HumanoidRootPart");
			if Hrp and THrp then
				Hrp.CFrame = THrp.CFrame + Vector3.new(0, 0, 3);
			end;
		end);
		local Spectating;
		local SpLbl = SpBtn:FindFirstChildOfClass("TextLabel");
		local function StopSpectate()
			Spectating = nil;
			local Cam = workspace.CurrentCamera;
			local Lp = Players.LocalPlayer;
			local Hum = Lp and Lp.Character and Lp.Character:FindFirstChildOfClass("Humanoid");
			if Cam and Hum then Cam.CameraSubject = Hum end;
			if SpLbl then SpLbl.Text = "Spectate" end;
		end;
		self:Connection(SpBtn.MouseButton1Click, function()
			if Spectating then StopSpectate(); return end;
			if not SelectedPlayer then return end;
			if SelectedPlayer == Players.LocalPlayer then return end;
			local Cam = workspace.CurrentCamera;
			if not Cam then return end;
			local TC = SelectedPlayer.Character;
			local Hum = TC and TC:FindFirstChildOfClass("Humanoid");
			if Hum then
				Cam.CameraSubject = Hum;
				Spectating = SelectedPlayer;
				if SpLbl then SpLbl.Text = "Unspectate" end;
			end;
		end);

		self:Connection(SearchInput:GetPropertyChangedSignal("Text"), Refresh);
		self:Connection(Players.PlayerAdded, function(P) PreloadHeadshot(P); Refresh() end);
		self:Connection(Players.PlayerRemoving, function(P)
			if Spectating == P then StopSpectate() end;
			if SelectedPlayer == P then SelectPlayer(nil) end;
			task.defer(Refresh);
		end);

		for _, Plr in Players:GetPlayers() do PreloadHeadshot(Plr) end;
		Refresh();
		SetPanel(false, false);

		local PlayerListObj = {
			Gui = Gui;
			Frame = Frame;
			Refresh = Refresh;
			_Embedded = Embedded;
		};
		function PlayerListObj:SetVisible(IsVisible)
			if Embedded then
				Frame.Visible = IsVisible ~= false;
			else
				Gui.Enabled = IsVisible ~= false;
			end;
		end;
		function PlayerListObj:Destroy()
			if Embedded then
				if Frame and Frame.Parent then Frame:Destroy() end;
			elseif Gui and Gui.Parent then
				Gui:Destroy();
			end;
		end;
		self.PlayerListState = PlayerListObj;
		return PlayerListObj;
	end;

-- Appearance
	Library.AppearanceThemes = {
		{ Name = "Default",        Accent = Color3.fromHex("C6C7DD"),      Top = Color3.fromHex("16151C"),     Bottom = Color3.fromHex("131219"),     FooterTop = Color3.fromHex("16151C"),     FooterBottom = Color3.fromHex("131219"),    Outline = Color3.fromHex("0D0C12"),       InnerOutline = Color3.fromHex("212027"),   TabInactive = Color3.fromHex("B0AFB4")    };
		{ Name = "Dracula",        Accent = Color3.fromRGB(189, 147, 249), Top = Color3.fromRGB(40, 42, 54),   Bottom = Color3.fromRGB(33, 34, 44),   FooterTop = Color3.fromRGB(33, 34, 44),   FooterBottom = Color3.fromRGB(45, 47, 60),   ContentTop = Color3.fromRGB(50, 52, 66),   ContentBottom = Color3.fromRGB(33, 34, 44)   };
		{ Name = "Dark Cherry",    Accent = Color3.fromRGB(204, 51, 71),   Top = Color3.fromRGB(28, 10, 14),   Bottom = Color3.fromRGB(40, 16, 22),   FooterTop = Color3.fromRGB(28, 10, 14),   FooterBottom = Color3.fromRGB(48, 18, 26)   };
		{ Name = "Nord",           Accent = Color3.fromRGB(143, 188, 187), Top = Color3.fromRGB(36, 41, 52),   Bottom = Color3.fromRGB(46, 52, 64),   FooterTop = Color3.fromRGB(36, 41, 52),   FooterBottom = Color3.fromRGB(59, 66, 82),   ContentTop = Color3.fromRGB(67, 76, 94),   ContentBottom = Color3.fromRGB(46, 52, 64)   };
		{ Name = "Monokai",        Accent = Color3.fromRGB(166, 226, 46),  Top = Color3.fromRGB(30, 31, 26),   Bottom = Color3.fromRGB(39, 40, 34),   FooterTop = Color3.fromRGB(30, 31, 26),   FooterBottom = Color3.fromRGB(56, 56, 50),   ContentTop = Color3.fromRGB(56, 57, 50),   ContentBottom = Color3.fromRGB(39, 40, 34)   };
		{ Name = "Tokyo Night",    Accent = Color3.fromRGB(187, 154, 247), Top = Color3.fromRGB(20, 21, 32),   Bottom = Color3.fromRGB(26, 27, 38),   FooterTop = Color3.fromRGB(20, 21, 32),   FooterBottom = Color3.fromRGB(41, 46, 66),   ContentTop = Color3.fromRGB(36, 40, 59),   ContentBottom = Color3.fromRGB(26, 27, 38)   };
		{ Name = "Catppuccin",     Accent = Color3.fromRGB(203, 166, 247), Top = Color3.fromRGB(24, 24, 37),   Bottom = Color3.fromRGB(30, 30, 46),   FooterTop = Color3.fromRGB(24, 24, 37),   FooterBottom = Color3.fromRGB(49, 50, 68),   ContentTop = Color3.fromRGB(49, 50, 68),   ContentBottom = Color3.fromRGB(30, 30, 46)   };
		{ Name = "Solarized Dark", Accent = Color3.fromRGB(181, 137, 0),   Top = Color3.fromRGB(0, 30, 38),    Bottom = Color3.fromRGB(0, 43, 54),    FooterTop = Color3.fromRGB(0, 30, 38),    FooterBottom = Color3.fromRGB(13, 65, 78),   ContentTop = Color3.fromRGB(7, 54, 66),    ContentBottom = Color3.fromRGB(0, 43, 54)    };
		{ Name = "Gruvbox",        Accent = Color3.fromRGB(250, 189, 47),  Top = Color3.fromRGB(29, 32, 33),   Bottom = Color3.fromRGB(40, 40, 40),   FooterTop = Color3.fromRGB(29, 32, 33),   FooterBottom = Color3.fromRGB(80, 73, 69),   ContentTop = Color3.fromRGB(60, 56, 54),   ContentBottom = Color3.fromRGB(40, 40, 40)   };
		{ Name = "One Dark",       Accent = Color3.fromRGB(229, 192, 123), Top = Color3.fromRGB(33, 37, 43),   Bottom = Color3.fromRGB(40, 44, 52),   FooterTop = Color3.fromRGB(33, 37, 43),   FooterBottom = Color3.fromRGB(60, 65, 76),   ContentTop = Color3.fromRGB(50, 56, 66),   ContentBottom = Color3.fromRGB(40, 44, 52)   };
		{ Name = "Synthwave",      Accent = Color3.fromRGB(0, 229, 255),   Top = Color3.fromRGB(26, 13, 40),   Bottom = Color3.fromRGB(34, 17, 51),   FooterTop = Color3.fromRGB(26, 13, 40),   FooterBottom = Color3.fromRGB(58, 30, 90),   ContentTop = Color3.fromRGB(58, 30, 90),   ContentBottom = Color3.fromRGB(34, 17, 51)   };
	};

	local function AppDisplayName(self, Name)
		if self._Anonymous then return "hidden" end;
		return tostring(Name);
	end;

	function Library:AppApplyTheme(Theme)
		local Old = {
			Accent = Palette.Default.Accent;
			TitleBottom = Palette.Default.TitleBottom;
			TabActive = Palette.Default.TabActive;
			Top = Palette.Default.Top;
			Bottom = Palette.Default.Bottom;
			FooterTop = Palette.Default.FooterTop;
			FooterBottom = Palette.Default.FooterBottom;
			ContentBg = Palette.Default.ContentBg;
			ContentTop = Palette.Default.ContentTop;
			ContentBottom = Palette.Default.ContentBottom;
		};
		local NewContentBg = Theme.ContentBg or Theme.ContentTop or Theme.FooterBottom;
		local NewContentTop = Theme.ContentTop or Theme.FooterTop;
		local NewContentBottom = Theme.ContentBottom or Theme.FooterBottom;
		Palette.Default.Accent = Theme.Accent;
		Palette.Default.TitleBottom = Theme.Accent;
		Palette.Default.TabActive = Theme.Accent;
		Palette.Default.Top = Theme.Top;
		Palette.Default.Bottom = Theme.Bottom;
		Palette.Default.FooterTop = Theme.FooterTop;
		Palette.Default.FooterBottom = Theme.FooterBottom;
		Palette.Default.ContentBg = NewContentBg;
		Palette.Default.ContentTop = NewContentTop;
		Palette.Default.ContentBottom = NewContentBottom;

		local function ColorEq(A, B)
			if A == nil or B == nil then return false end;
			return math.abs(A.R - B.R) < 0.005
				and math.abs(A.G - B.G) < 0.005
				and math.abs(A.B - B.B) < 0.005;
		end;
		local function MatchPair(Grad, A1, B1)
			local Seq = Grad.Color;
			local Kp = Seq.Keypoints;
			if #Kp ~= 2 then return false end;
			return ColorEq(Kp[1].Value, A1) and ColorEq(Kp[2].Value, B1);
		end;
		local function ReplacePair(Grad, A2, B2)
			Grad.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, A2);
				ColorSequenceKeypoint.new(1, B2);
			});
		end;

		local Hui = (gethui and gethui()) or CoreGui;
		local function Walk(Inst)
			for _, c in Inst:GetChildren() do
				if (c:IsA("Frame") or c:IsA("ImageLabel")) and c.Name == "AccentBar" then
					c.BackgroundColor3 = Theme.Accent;
				elseif (c:IsA("Frame") or c:IsA("ImageLabel")) and ColorEq(c.BackgroundColor3, Old.Accent) then
					c.BackgroundColor3 = Theme.Accent;
				elseif (c:IsA("Frame") or c:IsA("ImageLabel")) and ColorEq(c.BackgroundColor3, Old.ContentBg) then
					c.BackgroundColor3 = NewContentBg;
				elseif (c:IsA("Frame") or c:IsA("ImageLabel")) and ColorEq(c.BackgroundColor3, Old.Bottom) then
					c.BackgroundColor3 = Theme.Bottom;
				elseif (c:IsA("Frame") or c:IsA("ImageLabel")) and ColorEq(c.BackgroundColor3, Old.Top) then
					c.BackgroundColor3 = Theme.Top;
				elseif c:IsA("TextButton") and ColorEq(c.TextColor3, Old.TabActive) then
					c.TextColor3 = Theme.Accent;
				elseif c:IsA("TextLabel") and ColorEq(c.TextColor3, Old.TitleBottom) then
					c.TextColor3 = Theme.Accent;
				elseif c:IsA("UIGradient") then
					if MatchPair(c, Old.Top, Old.Bottom) then
						ReplacePair(c, Theme.Top, Theme.Bottom);
					elseif MatchPair(c, Old.Bottom, Old.Top) then
						ReplacePair(c, Theme.Bottom, Theme.Top);
					elseif MatchPair(c, Old.FooterTop, Old.FooterBottom) then
						ReplacePair(c, Theme.FooterTop, Theme.FooterBottom);
					elseif MatchPair(c, Old.FooterBottom, Old.FooterTop) then
						ReplacePair(c, Theme.FooterBottom, Theme.FooterTop);
					elseif MatchPair(c, Old.ContentTop, Old.ContentBottom) then
						ReplacePair(c, NewContentTop, NewContentBottom);
					elseif MatchPair(c, Old.ContentBottom, Old.ContentTop) then
						ReplacePair(c, NewContentBottom, NewContentTop);
					end;
				end
				Walk(c);
			end;
		end;
		Walk(Hui);

		local function HexC(C)
			return string.format("#%02X%02X%02X",
				math.floor(C.R * 255 + 0.5),
				math.floor(C.G * 255 + 0.5),
				math.floor(C.B * 255 + 0.5));
		end;
		local Win = self.CurrentlyOpen;
		if Win then
			local AccentHex = HexC(Theme.Accent);
			if Win.TitleLabel and Library._WindowSplitColorText and Win.Title then
				local Txt = Library._WindowSplitColorText(Win.Title, Theme.Accent, Palette.Default.TitleTop, 14);
				Win.TitleLabel.Text = Txt;
				if Win.TitleBoldLabel then Win.TitleBoldLabel.Text = Txt end;
			end;
			if Win.WelcomeLabel and Win.WelcomeName then
				Win.WelcomeLabel.Text = "welcome back, <font color=\"" .. AccentHex .. "\">" .. AppDisplayName(self, Win.WelcomeName) .. "</font>";
			end;
			if Win.GameLabel then

				local Cur = Win.GameLabel.Text or "";
				local Inner = Cur:match(">(.-)</font>") or Cur:gsub("[%[%]%s]", "");
				Win.GameLabel.Text = "[ <font color=\"" .. AccentHex .. "\">" .. Inner .. "</font> ]";
			end;
		end;
		self:RefreshGradientTitles();
	end;

	local function AppColorEq(A, B)
		if A == nil or B == nil then return false end;
		return math.abs(A.R - B.R) < 0.005
			and math.abs(A.G - B.G) < 0.005
			and math.abs(A.B - B.B) < 0.005;
	end;
	local function AppHexC(C)
		return string.format("#%02X%02X%02X",
			math.floor(C.R * 255 + 0.5),
			math.floor(C.G * 255 + 0.5),
			math.floor(C.B * 255 + 0.5));
	end;
	local function AppRefreshRichText(self, AccentColor)
		local Win = self.CurrentlyOpen;
		if not Win or not Library._WindowSplitColorText then return end;
		local AHex = AppHexC(AccentColor);
		if Win.TitleLabel and Win.Title then
			local Txt = Library._WindowSplitColorText(Win.Title, AccentColor, Palette.Default.TitleTop, 14);
			Win.TitleLabel.Text = Txt;
			if Win.TitleBoldLabel then Win.TitleBoldLabel.Text = Txt end;
		end;
		if Win.WelcomeLabel and Win.WelcomeName then
			Win.WelcomeLabel.Text = "welcome back, <font color=\"" .. AHex .. "\">" .. AppDisplayName(self, Win.WelcomeName) .. "</font>";
		end;
		if Win.GameLabel then
			local Cur = Win.GameLabel.Text or "";
			local Inner = Cur:match(">(.-)</font>") or Cur:gsub("[%[%]%s]", "");
			Win.GameLabel.Text = "[ <font color=\"" .. AHex .. "\">" .. Inner .. "</font> ]";
		end;
	end;
	function Library:AppApplyAnonymous(On)
		self._Anonymous = (On == true);
		AppRefreshRichText(self, Palette.Default.Accent);
		if typeof(self.WatermarkState) == "table" and self.WatermarkState.ApplyAnonymous then
			self.WatermarkState:ApplyAnonymous(self._Anonymous);
		end;
		if typeof(self.PlayerListState) == "table" and self.PlayerListState.Refresh then
			self.PlayerListState.Refresh();
		end;
	end;

	function Library:AppApplyAccent(NewC)
		self:Refresh("Accent", NewC);
		self:Refresh("TabActive", NewC);
	end;

	function Library:AppApplyBackTop(NewC)
		self:Refresh("Top", NewC);
		self:Refresh("ContentTop", NewC);
		self:Refresh("FooterTop", NewC);
	end;

	function Library:AppApplyBackBottom(NewC)
		self:Refresh("Bottom", NewC);
		self:Refresh("ContentBottom", NewC);
		self:Refresh("ContentBg", NewC);
		self:Refresh("FooterBottom", NewC);
	end;

	function Library:AppApplyOutline(NewC)
		self:Refresh("Outline", NewC);
	end;

	function Library:AppApplyInnerOutline(NewC)
		self:Refresh("InnerOutline", NewC);
	end;

	function Library:AppApplyPreset(Theme)
		if typeof(Theme) ~= "table" then return end;
		if typeof(Theme.Accent) == "Color3" then
			self:AppApplyAccent(Theme.Accent);
			self:AppApplyTitleColor(Theme.Accent);
		end;
		if typeof(Theme.Top) == "Color3" then self:AppApplyBackTop(Theme.Top) end;
		if typeof(Theme.Bottom) == "Color3" then self:AppApplyBackBottom(Theme.Bottom) end;
		local OutlineC = Theme.Outline;
		if typeof(OutlineC) ~= "Color3" and typeof(Theme.Bottom) == "Color3" then
			OutlineC = Theme.Bottom:Lerp(Color3.new(0, 0, 0), 0.3);
		end;
		if typeof(OutlineC) == "Color3" then self:AppApplyOutline(OutlineC) end;
		local InnerC = Theme.InnerOutline;
		if typeof(InnerC) ~= "Color3" and typeof(Theme.Top) == "Color3" then
			InnerC = Theme.Top:Lerp(Color3.new(1, 1, 1), 0.08);
		end;
		if typeof(InnerC) == "Color3" then self:AppApplyInnerOutline(InnerC) end;
		if typeof(Theme.TabInactive) == "Color3" then self:Refresh("TabInactive", Theme.TabInactive) end;
	end;

	function Library:ApplyTheme(NameOrTheme)
		local Theme = NameOrTheme;
		if typeof(NameOrTheme) == "string" then
			Theme = nil;
			for _, T in self.AppearanceThemes do
				if T.Name == NameOrTheme then Theme = T; break end;
			end;
		end;
		if typeof(Theme) ~= "table" then return end;
		self:AppApplyPreset(Theme);
		self.ActiveTheme = Theme.Name;
	end;

	function Library:AppApplyShadow(NewC)
		Palette.Default.Shadow = NewC;
		self:SyncAllShadows();
	end;

	function Library:AppApplyShadowSize(N)
		Palette.Default.ShadowSize = N;
		self:SyncAllShadows();
	end;

	function Library:AppApplyShadowOffset(N)
		Palette.Default.ShadowOffset = N;
		self:SyncAllShadows();
	end;

	function Library:AppApplyTitleColor(NewC)
		local Old = Palette.Default.TitleBottom;
		Palette.Default.TitleBottom = NewC;
		local Hui = (gethui and gethui()) or CoreGui;
		local function Walk(Inst)
			for _, c in Inst:GetChildren() do
				if c:IsA("TextLabel") and AppColorEq(c.TextColor3, Old) then
					c.TextColor3 = NewC;
				elseif c:IsA("TextButton") and AppColorEq(c.TextColor3, Old) then
					c.TextColor3 = NewC;
				end;
				Walk(c);
			end;
		end;
		Walk(Hui);
		AppRefreshRichText(self, NewC);
		self:RefreshGradientTitles();
	end;

	function Library:Appearance(Options)
		Options = typeof(Options) == "table" and Options or {};

		local Existing = self.AppearanceState;
		if typeof(Existing) == "table" and typeof(Existing.Gui) == "Instance" and Existing.Gui.Parent then
			Existing.Gui:Destroy();
		end;
		self.AppearanceState = nil;

		local Gui = self:CreateInstance("ScreenGui", {
			Name = "appearance";
			Parent = gethui and gethui() or CoreGui;
			Enabled = true;
			DisplayOrder = 1000;
			IgnoreGuiInset = true;
			ResetOnSpawn = false;
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
		});

		local Frame = self:CreateInstance("Frame", {
			Name = "AppearanceRoot";
			Parent = Gui;
			Position = Options.Position or UDim2.new(0, 795, 0, 70);
			Size = UDim2.new(0, 240, 0, 330);
			BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			BorderSizePixel = 0;
			Active = true;
		});
		self:CreateInstance("UIGradient", {
			Parent = Frame;
			Rotation = 90;
			Color = ColorSeq({
				ColorKey(0, Palette.Default.Top);
				ColorKey(1, Palette.Default.Bottom);
			});
		});
		self:ApplyDoubleOutline(Frame);
		self:AttachShadow(Frame);

		local Header = self:CreateInstance("Frame", {
			Name = "Header";
			Parent = Frame;
			Position = UDim2.new(0, 0, 0, 0);
			Size = UDim2.new(1, 0, 0, 22);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			ZIndex = 4;
		});
		local HeaderTitle = self:CreateInstance("TextLabel", {
			Name = "Title";
			Parent = Header;
			AnchorPoint = Vector2.new(0, 0.5);
			Position = UDim2.new(0, 8, 0.5, 0);
			Size = UDim2.new(1, -16, 0, 16);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			FontFace = Library.TitleFont;
			Text = "";
			RichText = true;
			TextColor3 = Color3.fromRGB(255, 255, 255);
			TextSize = 12;
			TextXAlignment = Enum.TextXAlignment.Left;
			TextYAlignment = Enum.TextYAlignment.Center;
			ZIndex = 5;
		});
		self:CreateInstance("UIStroke", {
			Parent = HeaderTitle;
			Color = Color3.fromRGB(0, 0, 0);
			Thickness = 1;
			ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
		});
		self:RegisterGradientTitle(HeaderTitle, tostring(Options.Title or "Appearance"));

		local Section = self:CreateInstance("Frame", {
			Name = "Section";
			Parent = Frame;
			Position = UDim2.new(0, 6, 0, 24);
			Size = UDim2.new(1, -12, 1, -30);
			BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			BorderSizePixel = 0;
		});
		self:CreateInstance("UIGradient", {
			Parent = Section;
			Rotation = 90;
			Color = ColorSeq({
				ColorKey(0, Palette.Default.FooterBottom);
				ColorKey(1, Palette.Default.FooterTop);
			});
		});
		self:ApplyDoubleOutline(Section);
		self:CreateInstance("Frame", {
			Name = "AccentBar";
			Parent = Section;
			Position = UDim2.new(0, 1, 0, 2);
			Size = UDim2.new(1, -2, 0, 1);
			BackgroundColor3 = Palette.Default.Accent;
			BorderSizePixel = 0;
			ZIndex = 3;
		});
		self:CreateInstance("TextLabel", {
			Name = "SectionTitle";
			Parent = Section;
			Position = UDim2.new(0, 10, 0, 6);
			Size = UDim2.new(1, -20, 0, 16);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			FontFace = Library.Fonts.Proggy;
			Text = "Overlay & Theme";
			TextColor3 = Palette.Default.TabInactive;
			TextSize = 12;
			TextXAlignment = Enum.TextXAlignment.Left;
			TextYAlignment = Enum.TextYAlignment.Center;
			ZIndex = 3;
		});

		local Body = self:CreateInstance("Frame", {
			Name = "Body";
			Parent = Section;
			Position = UDim2.new(0, 10, 0, 26);
			Size = UDim2.new(1, -20, 1, -32);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
		});
		self:CreateInstance("UIListLayout", {
			Parent = Body;
			FillDirection = Enum.FillDirection.Vertical;
			SortOrder = Enum.SortOrder.LayoutOrder;
			Padding = UDim.new(0, 6);
		});

		local LibRefA = self;
		local State = {
			Accent = Palette.Default.Accent;
			Outline = Palette.Default.Outline;
			InnerOutline = Palette.Default.InnerOutline;
			TitleColor = Palette.Default.TitleBottom;
			TabActive = Palette.Default.TabActive;
			Shadow = Palette.Default.Shadow;
			ShadowSize = Palette.Default.ShadowSize or 28;
			ShadowOffset = Palette.Default.ShadowOffset or 0;
			MenuBlur = false;
			WatermarkOn = true;
			KeybindOn = true;
			Anonymous = false;
			Preset = "Dracula";
			MenuBind = Enum.KeyCode.Insert;
		};

		local function ShadowedLabel(Parent, Text, AnchorY)
			local L = LibRefA:CreateInstance("TextLabel", {
				Parent = Parent;
				BackgroundTransparency = 1;
				BorderSizePixel = 0;
				Size = UDim2.new(0, 130, 1, 0);
				Position = UDim2.new(0, 0, 0, 0);
				FontFace = Library.Fonts.Proggy;
				Text = Text;
				TextColor3 = Palette.Default.TabInactive;
				TextSize = 12;
				TextXAlignment = Enum.TextXAlignment.Left;
				TextYAlignment = AnchorY or Enum.TextYAlignment.Center;
			});
			LibRefA:CreateInstance("UIStroke", {
				Parent = L;
				Color = Color3.fromRGB(0, 0, 0);
				Thickness = 1;
				ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
			});
			return L;
		end;

		local function SliderRow(Title, Min, Max, Default, Suffix, OnChange)
			local Row = LibRefA:CreateInstance("Frame", {
				Parent = Body;
				Size = UDim2.new(1, 0, 0, 32);
				BackgroundTransparency = 1;
				BorderSizePixel = 0;
			});
			ShadowedLabel(Row, Title, Enum.TextYAlignment.Top).Size = UDim2.new(1, 0, 0, 14);
			local Track = LibRefA:CreateInstance("Frame", {
				Parent = Row;
				Position = UDim2.new(0, 0, 0, 16);
				Size = UDim2.new(1, 0, 0, 14);
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BorderSizePixel = 0;
			});
			LibRefA:CreateInstance("UIGradient", {
				Parent = Track;
				Rotation = 90;
				Color = ColorSeq({
					ColorKey(0, Palette.Default.Top);
					ColorKey(1, Palette.Default.Bottom);
				});
			});
			LibRefA:ApplyDoubleOutline(Track);
			local Fill = LibRefA:CreateInstance("Frame", {
				Parent = Track;
				Position = UDim2.new(0, 1, 0, 1);
				Size = UDim2.new((Default - Min) / (Max - Min), -2, 1, -2);
				BackgroundColor3 = Palette.Default.Accent;
				BorderSizePixel = 0;
				ZIndex = 3;
			});
			local ValueLbl = LibRefA:CreateInstance("TextLabel", {
				Parent = Track;
				AnchorPoint = Vector2.new(0.5, 0.5);
				Position = UDim2.new(0.5, 0, 0.5, -1);
				Size = UDim2.new(1, 0, 1, 0);
				BackgroundTransparency = 1;
				BorderSizePixel = 0;
				FontFace = Library.Fonts.Proggy;
				Text = string.format("%.1f", Default) .. (Suffix or "");
				TextColor3 = Color3.fromRGB(255, 255, 255);
				TextSize = 12;
				TextXAlignment = Enum.TextXAlignment.Center;
				TextYAlignment = Enum.TextYAlignment.Center;
				ZIndex = 5;
			});
			LibRefA:CreateInstance("UIStroke", {
				Parent = ValueLbl;
				Color = Color3.fromRGB(0, 0, 0);
				Thickness = 1;
				ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
			});
			local Hit = LibRefA:CreateInstance("TextButton", {
				Parent = Track;
				BackgroundTransparency = 1;
				AutoButtonColor = false;
				Text = "";
				Size = UDim2.new(1, 0, 1, 0);
				ZIndex = 4;
			});
			local SldTween = TweenInfo.new(0.12, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut);
			local Value = Default;
			local function Render(Animate)
				local T = (Max == Min) and 0 or (Value - Min) / (Max - Min);
				local Goal = UDim2.new(T, -2, 1, -2);
				if Animate == false then Fill.Size = Goal else LibRefA:Tween(Fill, SldTween, { Size = Goal }):Play() end;
				ValueLbl.Text = string.format("%.1f", Value) .. (Suffix or "");
				if OnChange then OnChange(Value) end;
			end;
			Render(false);
			local Dragging = false;
			local function Update(Px)
				local AbsX = Track.AbsolutePosition.X;
				local AbsW = Track.AbsoluteSize.X;
				if AbsW <= 0 then return end;
				local T = math.clamp((Px - AbsX) / AbsW, 0, 1);
				Value = Min + T * (Max - Min);
				Render();
			end;
			LibRefA:Connection(Hit.InputBegan, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					Dragging = true;
					Update(Input.Position.X);
				end
			end);
			LibRefA:Connection(Hit.InputEnded, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					Dragging = false;
				end
			end);
			LibRefA:Connection(UserInputService.InputChanged, function(Input)
				if not Dragging then return end;
				if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
					Update(Input.Position.X);
				end
			end);
			return { Set = function(_, v) Value = math.clamp(v, Min, Max); Render() end, Get = function() return Value end };
		end;

		local function ToggleRow(Title, Default, OnChange)
			local Row = LibRefA:CreateInstance("Frame", {
				Parent = Body;
				Size = UDim2.new(1, 0, 0, 18);
				BackgroundTransparency = 1;
				BorderSizePixel = 0;
			});
			local Box = LibRefA:CreateInstance("Frame", {
				Parent = Row;
				AnchorPoint = Vector2.new(0, 0.5);
				Position = UDim2.new(0, 0, 0.5, 0);
				Size = UDim2.new(0, 14, 0, 14);
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BorderSizePixel = 0;
			});
			LibRefA:CreateInstance("UIGradient", {
				Parent = Box;
				Rotation = 90;
				Color = ColorSeq({
					ColorKey(0, Palette.Default.Top);
					ColorKey(1, Palette.Default.Bottom);
				});
			});
			LibRefA:ApplyDoubleOutline(Box);
			local Fill = LibRefA:CreateInstance("Frame", {
				Parent = Box;
				Position = UDim2.new(0, 1, 0, 1);
				Size = UDim2.new(1, -2, 1, -2);
				BackgroundColor3 = Palette.Default.Accent;
				BackgroundTransparency = Default and 0 or 1;
				BorderSizePixel = 0;
				ZIndex = 2;
			});
			Fill:SetAttribute("_fb_BackgroundTransparency", Default and 0 or 1);
			local Lbl = LibRefA:CreateInstance("TextLabel", {
				Parent = Row;
				AnchorPoint = Vector2.new(0, 0.5);
				Position = UDim2.new(0, 20, 0.5, 0);
				Size = UDim2.new(1, -20, 1, 0);
				BackgroundTransparency = 1;
				BorderSizePixel = 0;
				FontFace = Library.Fonts.Proggy;
				Text = Title;
				TextColor3 = Palette.Default.TabInactive;
				TextSize = 12;
				TextXAlignment = Enum.TextXAlignment.Left;
				TextYAlignment = Enum.TextYAlignment.Center;
			});
			LibRefA:CreateInstance("UIStroke", {
				Parent = Lbl;
				Color = Color3.fromRGB(0, 0, 0);
				Thickness = 1;
				ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
			});
			local Hit = LibRefA:CreateInstance("TextButton", {
				Parent = Row;
				BackgroundTransparency = 1;
				AutoButtonColor = false;
				Text = "";
				Size = UDim2.new(1, 0, 1, 0);
				ZIndex = 5;
			});
			local TogTween = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
			local Val = Default == true;
			LibRefA:Connection(Hit.MouseButton1Click, function()
				Val = not Val;
				Fill:SetAttribute("_fb_BackgroundTransparency", Val and 0 or 1);
				LibRefA:Tween(Fill, TogTween, { BackgroundTransparency = Val and 0 or 1 }):Play();
				if OnChange then OnChange(Val) end;
			end);
			return { Set = function(_, v) v = v == true; if v == Val then return; end; Val = v; Fill:SetAttribute("_fb_BackgroundTransparency", Val and 0 or 1); LibRefA:Tween(Fill, TogTween, { BackgroundTransparency = Val and 0 or 1 }):Play(); if OnChange then OnChange(Val) end; end; Get = function() return Val; end; };
		end;

		local function MountCp(Swatch, Default, OnChange)
			Swatch.BackgroundColor3 = Default;
			local H, S, V = Default:ToHSV();
			local A = 1;
			local Open = false;
			local PickerHolder;
			local SatValArea, SatValMarker, HueArea, HueMarker, AlphaArea, AlphaMarker;

			local CpFadeItems = {};
			local CpTweenA = TweenInfo.new(0.13, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
			local ShowPicker;
			local function SetCpFadeA(Shown, Animate)
				for _, E in CpFadeItems do
					local Goal = Shown and E[3] or 1;
					if Animate then LibRefA:Tween(E[1], CpTweenA, { [E[2]] = Goal }):Play(); else E[1][E[2]] = Goal; end;
				end;
			end;
			local function CaptureCpFade()
				table.clear(CpFadeItems);
				if not PickerHolder then return end;
				CpFadeItems[#CpFadeItems + 1] = { PickerHolder, "BackgroundTransparency", PickerHolder.BackgroundTransparency };
				for _, D in PickerHolder:GetDescendants() do
					if D:IsA("GuiObject") then
						CpFadeItems[#CpFadeItems + 1] = { D, "BackgroundTransparency", D.BackgroundTransparency };
						if D:IsA("TextLabel") or D:IsA("TextButton") or D:IsA("TextBox") then
							CpFadeItems[#CpFadeItems + 1] = { D, "TextTransparency", D.TextTransparency };
						end
						if D:IsA("ImageLabel") or D:IsA("ImageButton") then
							CpFadeItems[#CpFadeItems + 1] = { D, "ImageTransparency", D.ImageTransparency };
						end;
					elseif D:IsA("UIStroke") then
						CpFadeItems[#CpFadeItems + 1] = { D, "Transparency", D.Transparency };
					end;
				end;
			end;

			local function ApplyState()
				local C = Color3.fromHSV(H, S, V);
				Swatch.BackgroundColor3 = C;
				if PickerHolder then
					SatValArea.BackgroundColor3 = Color3.fromHSV(H, 1, 1);
					AlphaArea.BackgroundColor3 = C;
					local SOff = (S < 1) and 0 or -3;
					local VOff = ((1 - V) < 1) and 0 or -3;
					SatValMarker.Position = UDim2.new(S, SOff, 1 - V, VOff);
					local HOff = ((1 - H) < 1) and 0 or -2;
					HueMarker.Position = UDim2.new(0, 0, 1 - H, HOff);
					local AOff = ((1 - A) < 1) and 0 or -2;
					AlphaMarker.Position = UDim2.new(0, 0, 1 - A, AOff);
				end;
				if OnChange then OnChange(C, A) end;
			end;

			local function Build()
				PickerHolder = LibRefA:CreateInstance("Frame", {
					Parent = Gui;
					Size = UDim2.new(0, 190, 0, 180);
					BackgroundColor3 = Palette.Default.ContentBg;
					BorderSizePixel = 0;
					Visible = false;
					ClipsDescendants = true;
					ZIndex = 80;
				});
				LibRefA:CreateInstance("UIStroke", { Parent = PickerHolder; Color = Palette.Default.Outline; Thickness = 1; ApplyStrokeMode = Enum.ApplyStrokeMode.Border; });
				local PickerInner = LibRefA:CreateInstance("Frame", { Parent = PickerHolder; Position = UDim2.new(0, 1, 0, 1); Size = UDim2.new(1, -2, 1, -2); BackgroundTransparency = 1; BorderSizePixel = 0; ZIndex = 81; });
				LibRefA:CreateInstance("UIStroke", { Parent = PickerInner; Color = Palette.Default.InnerOutline; Thickness = 1; ApplyStrokeMode = Enum.ApplyStrokeMode.Border; });
				local PickerBody = LibRefA:CreateInstance("Frame", { Parent = PickerHolder; Size = UDim2.new(1, 0, 1, 0); BackgroundTransparency = 1; BorderSizePixel = 0; ZIndex = 82; });
				LibRefA:CreateInstance("UIPadding", { Parent = PickerBody; PaddingTop = UDim.new(0, 8); PaddingBottom = UDim.new(0, 8); PaddingLeft = UDim.new(0, 8); PaddingRight = UDim.new(0, 8); });
				local MainBg = LibRefA:CreateInstance("Frame", { Parent = PickerBody; Size = UDim2.new(1, 0, 1, 0); BackgroundTransparency = 1; BorderSizePixel = 0; ZIndex = 83; });

				SatValArea = LibRefA:CreateInstance("Frame", {
					Parent = MainBg; Size = UDim2.new(1, -30, 1, 0);
					BackgroundColor3 = Color3.fromHSV(H, 1, 1); BorderSizePixel = 0; ZIndex = 85;
				});
				LibRefA:CreateInstance("UIStroke", { Parent = SatValArea; Color = Palette.Default.Outline; Thickness = 1; ApplyStrokeMode = Enum.ApplyStrokeMode.Border; });
				local SatLayer = LibRefA:CreateInstance("TextButton", { Parent = SatValArea; Size = UDim2.new(1, 0, 1, 0); BackgroundColor3 = Color3.fromRGB(255,255,255); BorderSizePixel = 0; AutoButtonColor = false; Text = ""; ZIndex = 86; });
				LibRefA:CreateInstance("UIGradient", {
					Parent = SatLayer; Rotation = 270;
					Transparency = NumSeq({ NumKey(0, 0); NumKey(1, 1); });
					Color = ColorSeq({ ColorKey(0, Color3.fromRGB(0,0,0)); ColorKey(1, Color3.fromRGB(0,0,0)); });
				});
				local ValLayer = LibRefA:CreateInstance("TextButton", { Parent = SatValArea; Size = UDim2.new(1, 0, 1, 0); BackgroundColor3 = Color3.fromRGB(255,255,255); BorderSizePixel = 0; AutoButtonColor = false; Text = ""; ZIndex = 87; });
				LibRefA:CreateInstance("UIGradient", {
					Parent = ValLayer;
					Transparency = NumSeq({ NumKey(0, 0); NumKey(1, 1); });
				});
				SatValMarker = LibRefA:CreateInstance("Frame", { Parent = SatValArea; Size = UDim2.new(0, 2, 0, 2); BorderSizePixel = 1; BorderColor3 = Color3.fromRGB(0,0,0); BackgroundColor3 = Color3.fromRGB(255,255,255); ZIndex = 88; });

				HueArea = LibRefA:CreateInstance("TextButton", {
					Parent = MainBg; AnchorPoint = Vector2.new(1, 0); Position = UDim2.new(1, -14, 0, 0);
					Size = UDim2.new(0, 12, 1, 0); BackgroundColor3 = Color3.fromRGB(255,255,255); BorderSizePixel = 0; AutoButtonColor = false; Text = ""; ZIndex = 85;
				});
				LibRefA:CreateInstance("UIStroke", { Parent = HueArea; Color = Palette.Default.Outline; Thickness = 1; ApplyStrokeMode = Enum.ApplyStrokeMode.Border; });
				LibRefA:CreateInstance("UIGradient", {
					Parent = HueArea; Rotation = 270;
					Color = ColorSeq({
						ColorKey(0, Color3.fromRGB(255, 0, 0));
						ColorKey(0.17, Color3.fromRGB(255, 255, 0));
						ColorKey(0.33, Color3.fromRGB(0, 255, 0));
						ColorKey(0.5, Color3.fromRGB(0, 255, 255));
						ColorKey(0.67, Color3.fromRGB(0, 0, 255));
						ColorKey(0.83, Color3.fromRGB(255, 0, 255));
						ColorKey(1, Color3.fromRGB(255, 0, 0));
					});
				});
				HueMarker = LibRefA:CreateInstance("Frame", { Parent = HueArea; Size = UDim2.new(1, 0, 0, 2); BorderSizePixel = 1; BorderColor3 = Color3.fromRGB(0,0,0); BackgroundColor3 = Color3.fromRGB(255,255,255); ZIndex = 86; });

				AlphaArea = LibRefA:CreateInstance("TextButton", {
					Parent = MainBg; AnchorPoint = Vector2.new(1, 0); Position = UDim2.new(1, 0, 0, 0);
					Size = UDim2.new(0, 12, 1, 0); BackgroundColor3 = Default; BorderSizePixel = 0; AutoButtonColor = false; Text = ""; ZIndex = 85;
				});
				LibRefA:CreateInstance("UIStroke", { Parent = AlphaArea; Color = Palette.Default.Outline; Thickness = 1; ApplyStrokeMode = Enum.ApplyStrokeMode.Border; });
				local AlphaCheckers = LibRefA:CreateInstance("ImageLabel", {
					Parent = AlphaArea; Size = UDim2.new(1, 0, 1, 0); BackgroundTransparency = 1; BorderSizePixel = 0;
					Image = "rbxassetid://18274452449"; ScaleType = Enum.ScaleType.Tile; TileSize = UDim2.new(0, 6, 0, 6); ZIndex = 86;
				});
				LibRefA:CreateInstance("UIGradient", {
					Parent = AlphaCheckers; Rotation = 270;
					Transparency = NumSeq({ NumKey(0, 0); NumKey(1, 1); });
				});
				AlphaMarker = LibRefA:CreateInstance("Frame", { Parent = AlphaArea; Size = UDim2.new(1, 0, 0, 2); BackgroundColor3 = Color3.fromRGB(255,255,255); BorderSizePixel = 1; BorderColor3 = Color3.fromRGB(0,0,0); ZIndex = 87; });

				local DragSat, DragHue, DragAlpha = false, false, false;
				local function HookDown(Inst, Setter)
					LibRefA:Connection(Inst.InputBegan, function(I)
						if I.UserInputType == Enum.UserInputType.MouseButton1 or I.UserInputType == Enum.UserInputType.Touch then
							Setter(true);
						end;
					end);
				end;
				HookDown(SatLayer, function(B) DragSat = B end);
				HookDown(ValLayer, function(B) DragSat = B end);
				HookDown(HueArea, function(B) DragHue = B end);
				HookDown(AlphaArea, function(B) DragAlpha = B end);

				LibRefA:Connection(UserInputService.InputEnded, function(I)
					if I.UserInputType == Enum.UserInputType.MouseButton1 then
						DragSat = false; DragHue = false; DragAlpha = false;
					end
				end);
				LibRefA:Connection(UserInputService.InputChanged, function(I)
					if I.UserInputType ~= Enum.UserInputType.MouseMovement then return end;
					if not (DragSat or DragHue or DragAlpha) then return end;
					local M = UserInputService:GetMouseLocation();
					local Mx, My = M.X, M.Y - GuiInset;
					if DragSat then
						local Ap, Sz = SatValArea.AbsolutePosition, SatValArea.AbsoluteSize;
						S = Sz.X > 0 and math.clamp((Mx - Ap.X) / Sz.X, 0, 1) or 0;
						V = Sz.Y > 0 and 1 - math.clamp((My - Ap.Y) / Sz.Y, 0, 1) or 0;
					elseif DragHue then
						local Ap, Sz = HueArea.AbsolutePosition, HueArea.AbsoluteSize;
						H = Sz.Y > 0 and 1 - math.clamp((My - Ap.Y) / Sz.Y, 0, 1) or 0;
					elseif DragAlpha then
						local Ap, Sz = AlphaArea.AbsolutePosition, AlphaArea.AbsoluteSize;
						A = Sz.Y > 0 and 1 - math.clamp((My - Ap.Y) / Sz.Y, 0, 1) or 0;
					end;
					ApplyState();
				end);
				LibRefA:Connection(UserInputService.InputBegan, function(I)
					if I.UserInputType ~= Enum.UserInputType.MouseButton1 then return end;
					if not Open then return end;
					local M = UserInputService:GetMouseLocation();
					local Mx, My = M.X, M.Y - GuiInset;
					local function Inside(F)
						local Ap, Sz = F.AbsolutePosition, F.AbsoluteSize;
						return Mx >= Ap.X and Mx <= Ap.X + Sz.X and My >= Ap.Y and My <= Ap.Y + Sz.Y;
					end;
					if not Inside(PickerHolder) and not Inside(Swatch) then
						ShowPicker(false);
					end;
				end);
				CaptureCpFade();
			end;

			ShowPicker = function(B)
				Open = B;
				if not PickerHolder then return end;
				if B then
					local Sp = Swatch.AbsolutePosition;
					PickerHolder.Position = UDim2.new(0, Sp.X + Swatch.AbsoluteSize.X - 190, 0, Sp.Y + Swatch.AbsoluteSize.Y + GuiInset + 4);
					PickerHolder.Size = UDim2.new(0, 190, 0, 0);
					SetCpFadeA(false, false);
					PickerHolder.Visible = true;
					LibRefA:Tween(PickerHolder, CpTweenA, { Size = UDim2.new(0, 190, 0, 180) }):Play();
					SetCpFadeA(true, true);
				else
					local T = LibRefA:Tween(PickerHolder, CpTweenA, { Size = UDim2.new(0, 190, 0, 0) });
					T.Completed:Connect(function()
						if not Open then PickerHolder.Visible = false end;
					end);
					T:Play();
					SetCpFadeA(false, true);
				end;
			end;

			LibRefA:Connection(Swatch.MouseButton1Click, function()
				if not PickerHolder then Build(); ApplyState() end;
				ShowPicker(not Open);
			end);

			return { Set = function(_, c) H, S, V = c:ToHSV(); ApplyState() end };
		end;

		local function MountDd(Trigger, Lbl, Options, Default, OnChange)
			Lbl.Text = Default;
			local Open = false;
			local Popup;
			local function BuildPopup()
				Popup = LibRefA:CreateInstance("Frame", {
					Parent = Gui;
					Size = UDim2.new(0, Trigger.AbsoluteSize.X, 0, #Options * 16 + 11);
					BackgroundColor3 = Color3.fromRGB(255, 255, 255);
					BorderSizePixel = 0;
					Visible = false;
					ZIndex = 999999;
				});
				LibRefA:CreateInstance("UIGradient", {
					Parent = Popup;
					Rotation = 90;
					Color = ColorSeq({
						ColorKey(0, Palette.Default.FooterBottom);
						ColorKey(1, Palette.Default.FooterTop);
					});
				});
				LibRefA:ApplyDoubleOutline(Popup);
				local List = LibRefA:CreateInstance("Frame", { Parent = Popup; Size = UDim2.new(1, 0, 1, 0); BackgroundTransparency = 1; BorderSizePixel = 0; ZIndex = 501; });
				LibRefA:CreateInstance("UIPadding", { Parent = List; PaddingTop = UDim.new(0, 4); PaddingBottom = UDim.new(0, 4); });
				LibRefA:CreateInstance("UIListLayout", { Parent = List; SortOrder = Enum.SortOrder.LayoutOrder; Padding = UDim.new(0, 3); });
				for I, Opt in Options do
					local Btn = LibRefA:CreateInstance("TextButton", {
						Parent = List;
						Size = UDim2.new(1, 0, 0, 16);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						AutoButtonColor = false;
						Text = "";
						ZIndex = 502;
						LayoutOrder = I;
					});
					local OL = LibRefA:CreateInstance("TextLabel", {
						Parent = Btn;
						Position = UDim2.new(0, 8, 0, 0);
						Size = UDim2.new(1, -16, 1, 0);
						BackgroundTransparency = 1;
						BorderSizePixel = 0;
						FontFace = Library.Fonts.Proggy;
						Text = Opt;
						TextColor3 = Color3.fromRGB(200, 200, 200);
						TextSize = 12;
						TextXAlignment = Enum.TextXAlignment.Left;
						TextYAlignment = Enum.TextYAlignment.Center;
						ZIndex = 503;
					});
					LibRefA:CreateInstance("UIStroke", { Parent = OL; Color = Color3.fromRGB(0,0,0); Thickness = 1; ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual; });
					LibRefA:Connection(Btn.MouseEnter, function() OL.TextColor3 = Color3.fromRGB(255,255,255) end);
					LibRefA:Connection(Btn.MouseLeave, function() OL.TextColor3 = (Opt == Lbl.Text) and Palette.Default.TabActive or Color3.fromRGB(200,200,200) end);
					LibRefA:Connection(Btn.MouseButton1Click, function()
						Lbl.Text = Opt;
						Open = false;
						Popup.Visible = false;
						if OnChange then OnChange(Opt) end;
					end);
				end;
				LibRefA:Connection(UserInputService.InputBegan, function(I)
					if not Open then return end;
					if I.UserInputType ~= Enum.UserInputType.MouseButton1 and I.UserInputType ~= Enum.UserInputType.Touch then return end;
					local M = UserInputService:GetMouseLocation();
					local Mx, My = M.X, M.Y - GuiInset;
					local function Inside(F)
						local A, Z = F.AbsolutePosition, F.AbsoluteSize;
						return Mx >= A.X and Mx <= A.X+Z.X and My >= A.Y and My <= A.Y+Z.Y;
					end;
					if not Inside(Popup) and not Inside(Trigger) then
						Open = false;
						Popup.Visible = false;
					end;
				end);
			end;
			LibRefA:Connection(Trigger.MouseButton1Click, function()
				if not Popup then BuildPopup() end;
				Open = not Open;
				if Open then
					local Tp, Ts = Trigger.AbsolutePosition, Trigger.AbsoluteSize;
					Popup.Position = UDim2.new(0, Tp.X, 0, Tp.Y + Ts.Y + GuiInset + 12);
					Popup.Size = UDim2.new(0, Ts.X, 0, #Options * 16 + math.max(0, #Options - 1) * 3 + 8);
				end;
				Popup.Visible = Open;
			end);
		end;

		local function ColorRow(Title, Default, OnChange)
			local Row = LibRefA:CreateInstance("Frame", { Parent = Body; Size = UDim2.new(1, 0, 0, 18); BackgroundTransparency = 1; BorderSizePixel = 0; });
			ShadowedLabel(Row, Title);
			local Sw = LibRefA:CreateInstance("TextButton", {
				Parent = Row;
				AnchorPoint = Vector2.new(1, 0.5);
				Position = UDim2.new(1, 0, 0.5, 0);
				Size = UDim2.new(0, 24, 0, 14);
				AutoButtonColor = false;
				Text = "";
				BackgroundColor3 = Default;
				BorderSizePixel = 0;
			});
			LibRefA:ApplyDoubleOutline(Sw);
			return MountCp(Sw, Default, OnChange), Sw;
		end;

		local AccentCp, AccentSw = ColorRow("Accent Color", State.Accent, function(c)
			State.Accent = c;
			LibRefA:AppApplyAccent(c);
			LibRefA.Flags["app_accent"] = c;
		end);
		local ShadowCp, ShadowSw = ColorRow("Shadow Color", State.Shadow, function(c)
			State.Shadow = c;
			LibRefA:AppApplyShadow(c);
			LibRefA.Flags["app_shadow"] = c;
		end);
		local ShadowSizeRow = SliderRow("Shadow Size", 0, 80, State.ShadowSize, "px", function(v)
			State.ShadowSize = v;
			LibRefA:AppApplyShadowSize(v);
			LibRefA.Flags["app_shadow_size"] = v;
		end);
		local ShadowOffRow = SliderRow("Shadow Offset", -40, 40, State.ShadowOffset, "px", function(v)
			State.ShadowOffset = v;
			LibRefA:AppApplyShadowOffset(v);
			LibRefA.Flags["app_shadow_offset"] = v;
		end);

		local MenuBlurRow = ToggleRow("Menu Blur", State.MenuBlur, function(v)
			State.MenuBlur = v;
			LibRefA._MenuBlurOn = v;
			if LibRefA.SyncBlur then LibRefA:SyncBlur() end;
			LibRefA.Flags["app_menu_blur"] = v;
		end);
		local WatermarkRow = ToggleRow("Watermark", State.WatermarkOn, function(v)
			State.WatermarkOn = v;
			if LibRefA.WatermarkState and LibRefA.WatermarkState.SetVisible then
				LibRefA.WatermarkState:SetVisible(v);
			end;
			LibRefA.Flags["app_watermark"] = v;
		end);
		local KeybindRow = ToggleRow("Keybind list", State.KeybindOn, function(v)
			State.KeybindOn = v;
			if LibRefA.KeybindListState and LibRefA.KeybindListState.SetVisible then
				LibRefA.KeybindListState:SetVisible(v);
			end;
			LibRefA.Flags["app_keybind"] = v;
		end);
		local AnonRow = ToggleRow("Anonymous mode", State.Anonymous, function(v)
			State.Anonymous = v;
			LibRefA:AppApplyAnonymous(v);
			LibRefA.Flags["app_anonymous"] = v;
		end);

		LibRefA:RegisterFlag("app_accent", State.Accent, function(v)
			if typeof(v) ~= "Color3" then return end;
			AccentSw.BackgroundColor3 = v;
			AccentCp:Set(v);
		end);
		LibRefA:RegisterFlag("app_shadow", State.Shadow, function(v)
			if typeof(v) ~= "Color3" then return end;
			ShadowSw.BackgroundColor3 = v;
			ShadowCp:Set(v);
		end);
		LibRefA:RegisterFlag("app_shadow_size", State.ShadowSize, function(v)
			v = tonumber(v);
			if not v then return end;
			ShadowSizeRow:Set(v);
		end);
		LibRefA:RegisterFlag("app_shadow_offset", State.ShadowOffset, function(v)
			v = tonumber(v);
			if not v then return end;
			ShadowOffRow:Set(v);
		end);
		LibRefA:RegisterFlag("app_menu_blur", State.MenuBlur, function(v) MenuBlurRow:Set(v == true); end);
		LibRefA:RegisterFlag("app_watermark", State.WatermarkOn, function(v) WatermarkRow:Set(v == true); end);
		LibRefA:RegisterFlag("app_keybind", State.KeybindOn, function(v) KeybindRow:Set(v == true); end);
		LibRefA:RegisterFlag("app_anonymous", State.Anonymous, function(v) AnonRow:Set(v == true); end);

		local Listening = false;
		local CurrentBind = State.MenuBind;
		local BindRow = LibRefA:CreateInstance("Frame", { Parent = Body; Size = UDim2.new(1, 0, 0, 18); BackgroundTransparency = 1; BorderSizePixel = 0; });
		ShadowedLabel(BindRow, "Menu Bind");
		local BindBtn = LibRefA:CreateInstance("TextButton", {
			Parent = BindRow;
			AnchorPoint = Vector2.new(1, 0.5);
			Position = UDim2.new(1, 0, 0.5, 0);
			Size = UDim2.new(0, 56, 0, 15);
			AutoButtonColor = false;
			Text = "";
			BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			BorderSizePixel = 0;
		});
		LibRefA:CreateInstance("UIGradient", {
			Parent = BindBtn;
			Rotation = 90;
			Color = ColorSeq({
				ColorKey(0, Palette.Default.Top);
				ColorKey(1, Palette.Default.Bottom);
			});
		});
		LibRefA:ApplyDoubleOutline(BindBtn);
		local BindLbl = LibRefA:CreateInstance("TextLabel", {
			Parent = BindBtn;
			AnchorPoint = Vector2.new(0.5, 0.5);
			Position = UDim2.new(0.5, 0, 0.5, 0);
			Size = UDim2.new(1, 0, 1, 0);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			FontFace = Library.Fonts.Proggy;
			Text = Library:KeyDisplayName(CurrentBind);
			TextColor3 = Color3.fromRGB(255, 255, 255);
			TextSize = 12;
			TextXAlignment = Enum.TextXAlignment.Center;
			TextYAlignment = Enum.TextYAlignment.Center;
			ZIndex = 3;
		});
		LibRefA:CreateInstance("UIStroke", { Parent = BindLbl; Color = Color3.fromRGB(0,0,0); Thickness = 1; ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual; });
		LibRefA:Connection(BindBtn.MouseButton1Click, function()
			if Listening then return end;
			Listening = true;
			BindLbl.Text = "...";
		end);
		LibRefA:Connection(UserInputService.InputBegan, function(input, gpe)
			if Listening then
				if input.KeyCode == Enum.KeyCode.Escape then
					CurrentBind = nil;
					BindLbl.Text = Library:KeyDisplayName(CurrentBind);
					Listening = false;
					return;
				end;
				if input.UserInputType == Enum.UserInputType.Keyboard then
					CurrentBind = input.KeyCode;
					BindLbl.Text = Library:KeyDisplayName(CurrentBind);
					State.MenuBind = CurrentBind;
					Listening = false;
				elseif input.UserInputType == Enum.UserInputType.MouseButton1
					or input.UserInputType == Enum.UserInputType.MouseButton2
					or input.UserInputType == Enum.UserInputType.MouseButton3 then
					CurrentBind = input.UserInputType;
					BindLbl.Text = Library:KeyDisplayName(CurrentBind);
					State.MenuBind = CurrentBind;
					Listening = false;
				end;
				return;
			end;
			if gpe then return end;
			if CurrentBind == nil then return end;
			local Match = false;
			if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == CurrentBind then Match = true end;
			if input.UserInputType == CurrentBind then Match = true end;
			if not Match then return end;

			local Vis;
			if LibRefA.CurrentlyOpen and LibRefA.CurrentlyOpen.Gui then
				Vis = not LibRefA.CurrentlyOpen.Gui.Enabled;
				LibRefA:FadeGui(LibRefA.CurrentlyOpen.Gui, Vis);
			end;
			if LibRefA.EspPreviewState and LibRefA.EspPreviewState.Gui then LibRefA:FadeGui(LibRefA.EspPreviewState.Gui, Vis) end;
			if LibRefA.AppearanceState and LibRefA.AppearanceState.Gui then LibRefA:FadeGui(LibRefA.AppearanceState.Gui, Vis) end;
			if LibRefA.ConfigsState and LibRefA.ConfigsState.Gui then LibRefA:FadeGui(LibRefA.ConfigsState.Gui, Vis) end;
			if LibRefA.PlayerListState and LibRefA.PlayerListState.Gui then LibRefA:FadeGui(LibRefA.PlayerListState.Gui, Vis) end;
			if LibRefA.SyncBlur then LibRefA:SyncBlur() end;
		end);

		self:Draggable(Frame, Header);

		local AppObj = {
			Gui = Gui;
			Frame = Frame;
			Header = Header;
			Section = Section;
			Body = Body;
			State = State;
		};

		function AppObj:SetVisible(IsVisible) Gui.Enabled = IsVisible ~= false end;
		function AppObj:Destroy() if Gui and Gui.Parent then Gui:Destroy() end end;

		self.AppearanceState = AppObj;
		return AppObj;
	end;

-- Unload
	function Library:Unload()
		for _, Conn in self.Connections do
			if Conn ~= nil then
				Conn:Disconnect();
			end;
		end;
		self.Connections = {};

		local Win = self.CurrentlyOpen;
		if typeof(Win) == "table" and typeof(Win.Gui) == "Instance" and Win.Gui.Parent then
			Win.Gui:Destroy();
		end;
		self.CurrentlyOpen = nil;

		if typeof(self.WatermarkState) == "table" then
			self.WatermarkState:Destroy();
		end;
		self.WatermarkState = nil;

		if typeof(self.KeybindListState) == "table" then
			self.KeybindListState:Destroy();
		end;
		self.KeybindListState = nil;

		if typeof(self.AppearanceState) == "table" then
			self.AppearanceState:Destroy();
		end;
		self.AppearanceState = nil;

		if typeof(self.ConfigsState) == "table" then
			self.ConfigsState:Destroy();
		end;
		self.ConfigsState = nil;

		if typeof(self.PlayerListState) == "table" then
			self.PlayerListState:Destroy();
		end;
		self.PlayerListState = nil;

		if typeof(self._WindowBlur) == "Instance" and self._WindowBlur.Parent then
			self._WindowBlur:Destroy();
		end;
		self._WindowBlur = nil;

		self.Flags = {};
		self.Toggles = {};
		self.Options = {};
	end;

return Library;
