require("util")
require("actions")
characters = {}
character = {}
characters.base = character
character.name = "Base Character."
character.description = "Undefined."
--character.ap = 0
character.hp = 0
character.controllable = false
character.currentaction = nil
character.currenttarget = nil
character.actions = {}
character.winaction = actions.wait
function character:addAction(action)
    self.actions[action.name] = util.p(action)
end
function character:getActions()
    return self.actions
end
function character:victory(other)
    self:addAction(other.winaction)
end
function character:die(other)
    other:victory(self)
    for k,v in ipairs(gamestate.characters) do
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
player.hp = 10
--player.ap = 20
player.controllable = true
player.winaction = actions.absorb
player:addAction(actions.wait)
player:addAction(actions.attack3)
player:addAction(actions.attack5)
player:addAction(actions.attack10)
player:addAction(actions.attack20)
player:addAction(actions.healself5)
player:addAction(actions.healtarget5)
player:addAction(actions.healtarget10)
