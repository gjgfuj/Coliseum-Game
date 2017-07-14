require("util")
require("actions")
require("character")
gamestate = {}
gamestate.characters = {util.p(characters.player), util.p(characters.player)}
gamestate.targeting = nil
gamestate.log = {}
lmeta = {}
setmetatable(gamestate.log,lmeta)
function lmeta:__call(s)
    table.insert(gamestate.log, 1, {string=s, time=love.timer.getTime()})
    print(s)
end
function gamestate:addCharacter(c)
    table.insert(gamestate.characters,c)
end

button = {}
button.x = 0
button.y = 0
function button:getWidth()
    return love.graphics.getFont():getWidth(self.text)
end
function button:getHeight()
    return love.graphics.getFont():getHeight()
end
button.text = "Button"
button.description = ""
function button:action()
end
function button:draw()
    love.graphics.print(self.text, self.x, self.y)
    local x = love.mouse.getX()
    local y = love.mouse.getY()
    if x >= self.x and x <= self.x + self:getWidth() + 2 and y >= self.y and y <= self.y + self:getHeight() + 2 then
        love.graphics.print(self.description, 10,love.graphics.getHeight()-25)
    end
end
buttons = {}
function actionbutton(character, action, x,y)
    b = util.p(button)
    b.text = action.name
    b.description = action.description.." (Cost: "..tostring(action.cost)..")"
    b.x = x
    b.y = y
    function b:action()
        if character.controllable then
            if not gamestate.targeting and character.ap >= action.cost then
                character.currentaction = action
                if action.targeting then
                    gamestate.targeting = character
                end
            else
                gamestate.log(tostring(action.cost-character.ap).." too few AP to use this move.")
            end
        end
    end
    return b
end
function characterbutton(character,x,y)
    b = util.p(button)
    b.x = x
    b.y = y
    b.text = character.name
    b.description = character.description
    function b:action()
        if gamestate.targeting then
            gamestate.targeting.currenttarget = character
            gamestate.targeting = nil
        end
    end
    return b
end
function love.mousepressed(x,y,b)
    for k,button in ipairs(buttons) do
        if x >= button.x and x <= button.x + button:getWidth() + 2 and y >= button.y and y <= button.y + button:getHeight() + 2 then
            button:action()
        end 
    end
end
function beginTurn()
    buttons = {}
    local offset = 10
    for _,character in ipairs(gamestate.characters) do
        character.currentaction = nil
        character.currenttarget = nil
        local height = 50
        table.insert(buttons,characterbutton(character,offset,height))
        height = height + 100
        for k,action in pairs(character.actions) do
            table.insert(buttons, actionbutton(character, action,offset,height))
            height = height + 40
        end
        offset = offset + 200
    end
end
function processTurn()
    for _,character in ipairs(gamestate.characters) do
        if not character.currentaction or (character.currentaction.targeting and not character.currenttarget) then return false end
    end
    for _,character in ipairs(gamestate.characters) do
        character.currentaction:pre(character, character.currenttarget)
    end
    for _,character in ipairs(gamestate.characters) do
        character.currentaction:main(character, character.currenttarget)
        character.ap = character.ap - character.currentaction.cost
    end
    for _,character in ipairs(gamestate.characters) do
        character.currentaction:post(character, character.currenttarget)
    end
    beginTurn()
    return true
end

function love.load()
    love.window.setMode(1024,576)
    fontSmall = love.graphics.newFont(20)
    beginTurn()
end
function love.update()
    processTurn()
end
function filterConsole(a)
    local s = a.string
    local timer = a.time
    if love.timer.getTime() - timer > 10 then
        return ""
    else
        return s
    end
end
function love.draw()
    local offset = 10
    for k,character in ipairs(gamestate.characters) do
        local height = 50
        if gamestate.targeting == character then
            love.graphics.print("Targeting", offset, 0)
        elseif character.currentaction and (not character.currentaction.targeting or character.currenttarget) then
            love.graphics.print("Ready", offset, 0)
        else
            love.graphics.print("Deciding", offset, 0)
        end
        love.graphics.setFont(fontSmall)
        love.graphics.print(character.name, offset, height)
        height = height + 30
        love.graphics.print("HP: "..tostring(character.hp), offset, 80)
        height = height + 30
        love.graphics.print("AP: "..tostring(character.ap), offset, 110)
        offset = offset + 200
    end
    for k,button in ipairs(buttons) do
        button:draw()
    end
    love.graphics.printf(table.concat(util.map(filterConsole, gamestate.log), "\n"),love.graphics.getWidth()-200, 10,195)
end
