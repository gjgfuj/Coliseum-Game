require("util")
require("actions")
require("character")
require("button")
gamestate = {}
gamestate.characters = {util.p(characters.player), util.p(characters.player), util.p(characters.player), util.p(characters.player)}
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
function actionbutton(character, action, x,y)
    b = util.p(button)
    b.text = action.name
    b.description = action.description.." (Cost: "..tostring(action.cost)..")"
    b.x = x
    b.y = y
    function b:action()
        if character.controllable then
            if not gamestate.targeting then
                if character.hp > action.cost then
                    character.currentaction = action
                    if action.targeting then
                        gamestate.targeting = character
                    end
                else
                    gamestate.log(tostring(action.cost-character.hp+1).." too few HP to use this move.")
                end
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
function scrollbutton(t,positive,text,description,x,y)
    b = util.p(button)
    b.x = x
    b.y = y
    b.text = text
    b.description = description
    function b:action()
        if positive then
            table.insert(t,table.remove(t,1))
        else
            table.insert(t,1,table.remove(t))
        end
        setupButtons()
    end
    return b
end
function setupButtons()
    buttons = {}
    local offset = 20
    for k,character in ipairs(gamestate.characters) do
        if character.hp <= 0 then
            character:die(character)
        end
    end
    for k,character in ipairs(gamestate.characters) do
        character.currentaction = nil
        character.currenttarget = nil
        local height = 50
        table.insert(buttons,characterbutton(character,offset,height))
        height = height + 100
        for k,action in pairs(character.actions) do
            table.insert(buttons, actionbutton(character, action,offset,height))
            height = height + 40
        end
        table.insert(buttons, scrollbutton(character.actions, true, "\\/", "Move the list of actions down.",offset+170, 150))
        table.insert(buttons, scrollbutton(character.actions, false, "/\\", "Move the list of actions up.", offset+170, love.graphics.getHeight()-50))
        offset = offset + 200
    end
    table.insert(buttons, scrollbutton(gamestate.characters, true, "->", "Move the list of characters to the right.", love.graphics.getWidth()-230, 0))
    table.insert(buttons, scrollbutton(gamestate.characters, false, "<-", "Move the list of characters to the left.", 0, 0))
end
function beginTurn()
    setupButtons()
end
function processTurn()
    for k,character in ipairs(gamestate.characters) do
        if not character.currentaction or (character.currentaction.targeting and not character.currenttarget) then return false end
    end
    table.sort(gamestate.characters, function(a,b) return getmetatable(a).__ptid < getmetatable(b).__ptid end)
    for k,character in ipairs(gamestate.characters) do
        character.hp = character.hp - character.currentaction.cost
        character.currentaction:pre(character, character.currenttarget)
    end
    for _,character in ipairs(gamestate.characters) do
        character.currentaction:main(character, character.currenttarget)
    end
    for _,character in ipairs(gamestate.characters) do
        character.currentaction:post(character, character.currenttarget)
    end
    beginTurn()
    return true
end

function love.load()
    love.window.setMode(1024,576, {resizable=true})
    fontSmall = love.graphics.newFont(20)
    beginTurn()
end
function love.update()
    processTurn()
    for k,character in ipairs(gamestate.characters) do
        if character.hp <= 0 then
            character:die(character)
            setupButtons()
        end
    end
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
    local offset = 20
    for k,character in ipairs(gamestate.characters) do
        local height = 50
        if gamestate.targeting == character then
            love.graphics.print("Targeting", offset, 20)
        elseif character.currentaction and (not character.currentaction.targeting or character.currenttarget) then
            love.graphics.print("Ready", offset, 20)
        else
            love.graphics.print("Deciding", offset, 20)
        end
        love.graphics.setFont(fontSmall)
        love.graphics.print(character.name, offset, height)
        height = height + 30
        love.graphics.print("HP: "..tostring(character.hp), offset, 80)
        height = height + 30
        --love.graphics.print("AP: "..tostring(character.ap), offset, 110)
        offset = offset + 200
    end
    for k,button in ipairs(buttons) do
        button:draw()
    end
    love.graphics.printf(table.concat(util.map(filterConsole, gamestate.log), "\n"),love.graphics.getWidth()-200, 10,195)
end
