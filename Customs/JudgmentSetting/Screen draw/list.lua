local configList = W_CUSTOM:GV('configList', {})

local function ListActor(index, value)
    return Def.ActorFrame({
        InitCommand = function(self)
            self:y(-180 + index * 90 - 5)
        end,
        LoadFont('Common Small Normal')..{
            InitCommand = function(self)
                self:horizalign(left)
                self:diffusealpha(0.8)
                self:zoom(0.5)
                self:xy(-200, -10)
                self:settext(W_CUSTOM:String('ConfigTitle', value.Key))
            end,
        },
        LoadFont('Common Normal')..{
            InitCommand = function(self)
                self:zoom(1.0)
                self:xy(0, 20)
                self:strokecolor(Color('Outline'))
                self:settext(value.Value)
            end,
            UpdateValueMessageCommand = function(self, params)
                if index ~= params.Index then return end
                self:settext(params.Value)
            end,
        },
        Def.ActorFrame({
            InitCommand = function(self)
                self:visible(index == 1)
            end,
            ChangedCursorMessageCommand = function(self, params)
                self:visible(index == params.Index)
            end,
            LoadFont('Common Normal')..{
                Text = '&MenuLeft;',
                InitCommand = function(self)
                    self:zoom(0.75)
                    self:xy(-160, 20)
                    self:diffuse(Color('White'))
                    self:strokecolor(Color('Outline'))
                end,
            },
            LoadFont('Common Normal')..{
                Text = '&MenuRight;',
                InitCommand = function(self)
                    self:zoom(0.75)
                    self:xy(160, 20)
                    self:diffuse(Color('White'))
                    self:strokecolor(Color('Outline'))
                end,
            },
        }),
    })
end

local function ListAllActor()
    local actors = Def.ActorFrame({})
    for k,v in pairs(configList) do
        actors[#actors+1] = ListActor(k, v)
    end
    return actors
end

local actors = Def.ActorFrame({
    LoadActor(W:Object('boxshadow'), 'list', {
        Length = 30,
        Color = color('0, 0, 0, 0.25'),
        Center = color('0.01, 0.08, 0.1, 0.85'),
    })..{
        OnCommand = function(self)
            self:playcommand('UpdateBoxShadow', {
                Id = 'list',
                Width = 620,
                Height = 300,
            })
        end,
    },
    -- スクロールバー
    LoadActor(W:Object('scrollbar'), {
            Width  = 6,
            Height = 300,
            Count  = #configList + 1,
        })..{
        OnCommand = function(self)
            self:xy(310-3, 0)
        end,
        ChangedCursorMessageCommand = function(self, params)
            self:playcommand('ScrollMenu', {Cursor = params.Index})
        end,
    },
    Def.Quad({
        OnCommand=function(self)
            self:zoomto(SCREEN_WIDTH, 300)
            self:vertalign(bottom)
            self:y(-150)
            self:clearzbuffer(true)
            self:zwrite(true)
            self:blend('BlendMode_NoEffect')
        end,
    }),
    Def.Quad({
        OnCommand=function(self)
            self:zoomto(SCREEN_WIDTH, 300)
            self:vertalign(top)
            self:y(150)
            self:zwrite(true)
            self:blend('BlendMode_NoEffect')
        end,
    }),
    Def.ActorFrame({
        InitCommand = function(self)
            self:ztest(true)
            self:y(140 - 90/2)
        end,
        ChangedCursorMessageCommand = function(self, params)
            self:stoptweening()
            self:linear(0.2)
            self:y(140 - 90/2 - 90*(params.Index-1))
        end,
        Def.Quad({
            InitCommand = function(self)
                self:y(-180 + 90)
                self:zoomto(440, 70)
                self:fadeleft(1)
                self:faderight(1)
            end,
            ChangedCursorMessageCommand = function(self, params)
                self:y(-180 + params.Index * 90)
            end,
        }),
        LoadFont('Common Normal')..{
            Text = W_CUSTOM:String('ConfigTitle', 'Save'),
            InitCommand = function(self)
                self:y(-180 + (#configList+1) * 90)
                self:zoom(0.75)
                self:diffuse(Color('White'))
                self:strokecolor(Color('Outline'))
            end,
        },
        ListAllActor(),
    }),
    -- マスクのクリア
    Def.Quad({
        OnCommand = function(self)
            self:clearzbuffer(true)
            self:zoom(0)
        end,
    }),
})

return actors