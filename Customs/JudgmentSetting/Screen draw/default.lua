local listData = {}
local profiles = W_PLAYER:List()
for k,v in pairs(profiles) do
    listData[#listData+1] = v.Name
end
if #listData <= 0 then
    listData[#listData+1] = W_CUSTOM:String('Text', 'NoProfile')
end

return Def.ActorFrame({
    InitCommand = function(self)
        self:Center()
    end,
    LoadActor('description')..{
        InitCommand = function(self)
            self:y(155)
        end,
    },

    LoadActor('list')..{
        InitCommand = function(self)
            self:xy(0, -45)
        end,
    },


    W_CUSTOM:Template('Header'),
	W_CUSTOM:Template('Helper', {
		Text = W_CUSTOM:String('Helper', 'Text'),
	}),
})