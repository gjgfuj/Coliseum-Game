actions = {}
local baseaction = {}
actions.baseaction = baseaction
baseaction.name = "Undefined"
baseaction.description = "Undefined"
baseaction.cost = 100000
baseaction.targeting = false
function baseaction:pre(char, other)
end
function baseaction:main(char, other)
end
function baseaction:post(char,other)
end
function baseaction:damageCallback(char,other,damage)
end
local wait = util.p(baseaction)
actions.wait = wait
wait.name = "Guard"
wait.description = "Replensh Lost HP"
wait.cost = 0
function wait:main(char)
    if char.hp <= 100 then
	   char.hp = char.hp + 14
	   end
end
local Nothing = util.p(baseaction)
actions.Nothing = Nothing
Nothing.name = "DoNothing"
Nothing.description = "Debug"
Nothing.cost = 0
local absorb = util.p(baseaction)
actions.absorb = absorb
absorb.name = "Absorb Damage"
absorb.description = "Absorbs damage completely."
absorb.cost = 10
function absorb:pre(char, target)
    self.predamage = char.hp
end
function absorb:post(char, target)
    char.hp = self.predamage
end

local attack = util.p(baseaction)
actions.attack = attack
attack.damage = 0
attack.atype = "attack"
attack.targeting = true
function attack:main(char, other)
    gamestate.log(char.name.." attacks "..other.name.." for "..tostring(self.damage).." damage.")
    other:takeDamage(char, self.damage)
end
local attack3 = util.p(attack)
actions.attack3 = attack3
attack3.name = "Quick Attack"
attack3.description = "Quickly attack the target"
attack3.cost = 2
attack3.damage = 5
local attack5 = util.p(attack)
actions.attack5 = attack5
attack5.name = "Basic Attack"
attack5.description = "Deals a base 5 damage to target."
attack5.cost = 4
attack5.damage = 8
local attack10 = util.p(attack)
actions.attack10 = attack10
attack10.name = "Broad Attack"
attack10.description = "(Only does Single target, but set up for numbers)"
attack10.damage = 3
attack10.cost = 10
local attack20 = util.p(attack)
actions.attack20 = attack20
attack20.name = "Charge Attack"
attack20.description = "(Doesn't work, set up for numbers)"
attack20.damage = 15
attack20.cost = 5

local healself = util.p(baseaction)
actions.healself = healself
healself.name = "Heal Self"
healself.description = "Heals self for a certain amount.\nThis should not be right."
healself.amount = 0
function healself:main(char)
    char.hp = char.hp + self.amount
    gamestate.log(char.name.." heals themself for "..tostring(self.amount).." HP.")
end
local healself5 = util.p(healself)
actions.healself5 = healself5
healself5.name = "Heal Self (5)"
healself5.description = "Heals self for 5HP"
healself5.amount = 5
healself5.cost = 7
local healself10 = util.p(healself)
actions.healself10 = healself10
healself10.name = "Heal Self (10)"
healself10.description = "Heals self for 10HP"
healself10.amount = 10
healself10.cost = 15
local healtarget = util.p(baseaction)
actions.healtarget = healtarget
healtarget.name = "Heal Target"
healtarget.description = "Heals target for a certain amount. \n This should not show up."
healtarget.amount = 0
healtarget.targeting = true
function healtarget:main(char, target)
    target.hp = target.hp + self.amount
end
local healtarget5 = util.p(healtarget)
actions.healtarget5 = healtarget5
healtarget5.name = "Heal Target (5)"
healtarget5.description = "Heals target for 5HP"
healtarget5.amount = 5
healtarget5.cost = 10
local healtarget10 = util.p(healtarget)
actions.healtarget10 = healtarget10
healtarget10.name = "Heal Target (10)"
healtarget10.description = "Heals target for 10HP"
healtarget10.amount = 10
healtarget10.cost = 20
