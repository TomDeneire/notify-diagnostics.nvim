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
M.insertNewLines = function(message, max_width)
    -- remove original newlines
    message = string.gsub(message, "\n", " ")
    message = string.gsub(message, "\r\n", " ")
    message = string.gsub(message, "\t", " ")
    if string.len(message) < max_width then
        return message
    end
    -- add new newlines
    local new_message = ""
    local line = ""
    local words = M.split(message, " ")
    local line_count = 1
    for i in pairs(words) do
        local max_length = max_width
        local next_word = words[i]
        local next_word_length = string.len(next_word)
        local line_length = string.len(line)
        local room_left = max_length - line_length
        if room_left > next_word_length then
            line = line .. " " .. next_word
        else
            if next_word_length > max_length then
                new_message = new_message .. "\n" .. line .. "\n" .. string.sub(next_word, 1, max_length)
                line = string.sub(next_word, max_length + 1, string.len(next_word))
                line_count = line_count + 1
            else
                new_message = new_message .. "\n" .. line
                line = next_word
                line_count = line_count + 1
            end
        end
    end
    new_message = new_message .. "\n" .. line
    -- remove superfluous whitespace
    new_message = string.gsub(new_message, "  ", " ")
    new_message = string.gsub(new_message, "\n ", "\n")
    new_message = string.gsub(new_message, "\n\n", "\n")
    if string.sub(new_message, 1, 1) == "\n" then
        new_message = string.sub(new_message, 2, string.len(new_message))
    end
    if string.sub(new_message, 1, 1) == " " then
        new_message = string.sub(new_message, 2, string.len(new_message))
    end
    -- capitalize message
    local first = string.sub(new_message, 1, 1)
    new_message = string.upper(first) .. string.sub(new_message, 2, string.len(new_message))
    return new_message
end

function Test()
    local max_width = 53
    local message =
    [[Cyclomatic complexity too high: 15 (threshold 15)]]
    print(M.insertNewLines(message, max_width))
end

Test()
return M
