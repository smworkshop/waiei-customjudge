local screen
local lock = 0.6
local actorSelf
local current = 1

local configList = {
    {Key = 'JudgmentMode', List = {'DDR', 'SuperNOVA', 'StepMania', 'Virtua'}, Default = 'SuperNOVA'},
}

for k,v in pairs(configList) do
    configList[k].Value = W_OPTION:ReadPref(v.Key, v.Default)
    configList[k].Select = 1
    for index, value in pairs(v.List) do
        if value == configList[k].Value then
            configList[k].Select = index
            break
        end
    end
end
W_CUSTOM:SV('configList', configList)

-- キー・マウス操作
local function CallbackInput(params)
    local function CheckButton(params, key)
        return (params.button and params.button == key)
            or (params.GameButton and params.GameButton == key)
    end

    if params.type == 'InputEventType_Release' then
        if CheckButton(params, 'Back') then
            actorSelf:playcommand('EndCustom')
        end
        if CheckButton(params, 'Start') then
            -- 保存の場合は保存処理、それ以外の場合は最下部へ
            if current < #configList+1 then
                current = #configList+1
                actorSelf:playcommand('Cursor')
            else
                actorSelf:playcommand('Save')
            end
        end
    end
    if params.type == 'InputEventType_FirstPress' or params.type == 'InputEventType_Repeat' then
        if CheckButton(params, 'Up') then
            if current > 1 then
                current = current-1
            else
                current = #configList+1
            end
            actorSelf:playcommand('Cursor')
        end
        if CheckButton(params, 'Down') then
            if current < #configList+1 then
                current = current+1
            else
                current = 1
            end
            actorSelf:playcommand('Cursor')
        end
        if CheckButton(params, 'Left') then
            if current > #configList then return end
            if configList[current].Select > 1 then
                configList[current].Select = configList[current].Select-1
            else
                configList[current].Select = #configList[current].List
            end
            configList[current].Value = configList[current].List[configList[current].Select]
            actorSelf:playcommand('Change')
        end
        if CheckButton(params, 'Right') then
            if current > #configList then return end
            if configList[current].Select < #configList[current].List then
                configList[current].Select = configList[current].Select+1
            else
                configList[current].Select = 1
            end
            configList[current].Value = configList[current].List[configList[current].Select]
            actorSelf:playcommand('Change')
        end
    end
end

return Def.ActorFrame({
    InitCommand = function(self)
        actorSelf = self
    end,
    OnCommand = function(self)
        MESSAGEMAN:Broadcast('ScrollMenu', {Cursor = current, Init = true})
        screen = SCREENMAN:GetTopScreen()
        screen:lockinput(lock)
        screen:AddInputCallback(CallbackInput)
        MESSAGEMAN:Broadcast('UpdateHelper', {Text = W_CUSTOM:String('Helper', 'Profile')})
    end,
    -- 項目を選択
    CursorCommand = function(self)
        self:playcommand('PlayCursorSound')
        MESSAGEMAN:Broadcast('ChangedCursor', {Index = current})
    end,
    -- 設定を変更
    ChangeCommand = function(self)
        self:playcommand('PlayCursorSound')
        MESSAGEMAN:Broadcast('UpdateValue', {Index = current, Value = configList[current].Value})
    end,
    -- 設定を保存
    SaveCommand = function(self)
        self:playcommand('PlayStartSound')
        local save = {}
        for _,v in pairs(configList) do
            W_OPTION:SavePref(v.Key, v.List[v.Select])
            save[#save+1] = v.Key..'/'..v.List[v.Select]
        end
        self:playcommand('EndCustom', {SE = false})
    end,
    W_CUSTOM:Template('Basic')
})