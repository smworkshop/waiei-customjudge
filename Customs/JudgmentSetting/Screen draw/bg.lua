return Def.ActorFrame({
    LoadActor(W:Object('boxshadow'), 'title', {
        Length = 30,
        Color = color('0, 0, 0, 0.25'),
        Center = color('0.01, 0.08, 0.1, 0.85'),
    })..{
        OnCommand = function(self)
            self:xy(115, -95)
            self:playcommand('UpdateBoxShadow', {
                Id = 'title',
                Width = 390,
                Height = 50,
            })
        end,
    },

    LoadActor(W:Object('boxshadow'), 'body', {
        Length = 30,
        Color = color('0, 0, 0, 0.25'),
        Center = color('0.01, 0.08, 0.1, 0.85'),
    })..{
        OnCommand = function(self)
            self:xy(115, 60)
            self:playcommand('UpdateBoxShadow', {
                Id = 'body',
                Width = 390,
                Height = 240,
            })
        end,
    },
})