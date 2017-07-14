util = {}
function util.map(f, t)
    local t2 = {}
    for k,v in pairs(t) do 
        t2[k] = f(v)
    end

    return t2
end
function util.p(t)
    local nt = {}
    if getmetatable(nt) == nil then setmetatable(nt,{}) end
    getmetatable(nt).__index = t
    return nt
end
