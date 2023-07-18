function if_atk(word)
    local pattern = "%.a%(%d+%)$"
    local suffix = word:match(pattern)
    if suffix then
        local prefix = word:sub(1, -#suffix-1)
        local atk_val = suffix:sub(4, -2)
        return prefix .. "$atk(" .. atk_val .. ")"
    else
        return word
    end
end



local string = if_atk('likearev.a(3235)')
print(string)
