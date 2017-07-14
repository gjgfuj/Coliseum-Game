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
