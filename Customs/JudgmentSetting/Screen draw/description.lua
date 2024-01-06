local width = 620
local height = 70
local configList = W_CUSTOM:GV('configList', {})

return Def.ActorFrame({
    LoadActor(W:Object('boxshadow'), 'description', {
        Length = 30,
        Color = color('0, 0, 0, 0.25'),
        Center = color('0.01, 0.08, 0.1, 0.85'),
    })..{
        OnCommand = function(self)
            self:playcommand('UpdateBoxShadow', {
                Id = 'description',
                Width = width,
                Height = height,
            })
        end,
    },
	LoadFont('Common Small Normal')..{
        Name = 'Description',
		InitCommand = function(self)
            self:zoom(0.5)
			self:maxwidth((width-20)/0.5)
			self:wrapwidthpixels((width-20)/0.5)
            self:vertspacing(10)
			self:diffuse(Color('White'))
			self:strokecolor(Color('Outline'))
            self:playcommand('ChangedCursor', {Index = 1})
		end,
        ChangedCursorMessageCommand = function(self, params)
            self:finishtweening()
            self:diffusealpha(0)
            if params.Index > #configList then
                self:settext(W_CUSTOM:String('ConfigDescription', 'Save'))
            else
                self:settext(W_CUSTOM:String('ConfigDescription', configList[params.Index].Key))
            end
            self:linear(0.2)
            self:diffusealpha(1)
        end,
	},
})