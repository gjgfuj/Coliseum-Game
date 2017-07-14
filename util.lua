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
    setmetatable(nt,{})
    if not getmetatable(t) then setmetatable(t, {}) end
    local mt = getmetatable(t)
    if mt.__subcopy then
        for _,v in pairs(mt.__subcopy) do
            nt[v] = {}
            for k,v2 in pairs(t[v]) do
                nt[v][k] = v2
            end
        end
    end
    getmetatable(nt).__index = t
    setmetatable(getmetatable(nt),{})
    getmetatable(getmetatable(nt)).__index = getmetatable(t)
    return nt
end
