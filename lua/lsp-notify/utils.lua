local M = {}

-- Split a string on a delimiter
M.split = function(mystring, delim)
    local result = {}
    local start = 1

    while (true) do
        local _, pos = string.find(mystring, delim, start, true)
        if pos == nil then
            local rest = string.sub(mystring, start, string.len(mystring))
            table.insert(result, rest)
            break
        else
            local matchlen = pos - string.len(delim)
            local part = string.sub(mystring, start, matchlen)
            start = pos + 1
            table.insert(result, part)
        end
    end

    return result
end

-- Get length of a table
M.table_length = function(mytable)
    local length = 0
    for _ in pairs(mytable) do
        length = length + 1
    end
    return length
end

-- Split up longer lines by inserting newlines
M.insertNewLines = function(message)
    message = string.gsub(message, "\n", " ")
    message = string.gsub(message, "\r\n", " ")
    message = string.gsub(message, "\t", " ")
    if string.len(message) < 50 then
        return message
    end
    local new_message = ""
    local line = ""
    local words = utils.split(message, " ")
    for i in pairs(words) do
        if string.len(line) > 50 then
            new_message = new_message .. line .. "\n"
            line = ""
        end
        line = line .. " " .. words[i]
    end
    new_message = new_message .. " " .. line
    new_message = string.gsub(new_message, "  ", " ")
    if string.sub(new_message, 1, 1) == " " then
        new_message = string.sub(new_message, 2, string.len(new_message))
    end
    local first = string.sub(new_message, 1, 1)
    new_message = string.upper(first) .. string.sub(new_message, 2, string.len(new_message))
    return new_message
end
return M
