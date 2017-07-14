util = {}
function util.p(t)
    nt = {}
    if getmetatable(nt) == nil then setmetatable(nt,{}) end
    getmetatable(nt).__index = t
    return nt
end
