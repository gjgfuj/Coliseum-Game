require("util")
require("actions")
characters = {}
local character = {}
characters.base = character
character.name = "Base Character."
character.description = "Undefined."
setmetatable(character,{})
getmetatable(character).__subcopy = {"actions"}
--character.ap = 0
character.hp = 10
character.controllable = false
character.currentaction = nil
character.currenttarget = nil
character.actions = {}
character.winaction = actions.wait
function character:addAction(action)
    for k,v in ipairs(self.actions) do
        if v.name == action.name then return nil end
    end
    table.insert(self.actions,util.p(action))
    table.sort(self.actions, function(a, b) return a.cost < b.cost end)
end
function character:getActions()
    return self.actions
end
function character:victory(other)
    self:addAction(other.winaction)
end
function character:die(other)
    other:victory(self)
    if other == self then
        gamestate.log(self.name.." was killed.")
    else
        gamestate.log(self.name.." was killed by "..other.name)
    end
    for k,v in pairs(gamestate.characters) do
        if v == self then
            table.remove(gamestate.characters, k)
        end
    end
end
function character:takeDamage(other,d)
    self.hp = self.hp - d
    self.currentaction:damageCallback(self,other,d)
    if self.hp <= 0 then
        self:die(other)
    end
end
character:addAction(actions.wait)

local player = util.p(characters.base)
characters.player = player
player.name = "Player"
player.description = "You."
player.hp = 70
--player.ap = 20
player.controllable = true
player.winaction = actions.absorb
player:addAction(actions.wait)
player:addAction(actions.attack3)
player:addAction(actions.attack5)
player:addAction(actions.attack10)
player:addAction(actions.attack20)
player:addAction(actions.Nothing)
--player:addAction(actions.healself5)
--player:addAction(actions.healtarget5)
--player:addAction(actions.healtarget10)
