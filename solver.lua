local word_so_far = "I?E?L"
local wrong_letters = "RTUPSFKBN"
--[[ All you have to do is change the two variables above. word_so_far should be the letters which you are certain
exist in the word in their respective place, with any non-alphabet character (such as ? or @) being used to represent
the letters you don't yet know. This script will generate those.
wrong_letters should be the letters you know AREN'T in the word. --]]
---------------------------------------------

word_so_far = word_so_far:upper() -- Just making sure
wrong_letters = wrong_letters:upper()
local usable_word = ""
local letters_left = 0
for not_found = 1, #word_so_far do
    local letter = word_so_far:byte(not_found)
    if (letter < 65 or letter > 90) then -- Letter that hasn't been found yet
        usable_word = (usable_word.."%s")
        letters_left = (letters_left + 1)
    else -- HAS been found
        usable_word = (usable_word..(word_so_far:sub(not_found, not_found)))
    end
end

local alphabet = {}
for ascii_code = 65, 90 do -- Uppercase ASCII letters
    local letter = string.char(ascii_code)
    if not wrong_letters:find(letter) then
        alphabet[#alphabet + 1] = letter
    end
end

local function format(to_format, arg) -- Essentially string.format but it lets you only format one part of a string
    if letters_left > 0 then -- Is this more optimized? I'm not quite sure..
      local args = {arg}
      for i = 2, (letters_left + 1) do
          args[i] = "%s"
      end
      return to_format:format(table.unpack(args))
  else
      return to_format:format(arg)
    end
end
local function loop(format_string, storage_table)
    letters_left = (letters_left - 1)
     for _, letter in ipairs(alphabet) do
        local new_string = format(format_string, letter)
        if letters_left > 0 then
            loop(new_string, storage_table)
            letters_left = (letters_left + 1)
        else
            storage_table[#storage_table + 1] = new_string -- The final result
        end
    end    
end


local function GenerateCombinations(word) -- Will return us an array filled with all possible string combinations
    local storage_table = {}
    loop(word, storage_table)
    letters_left = (letters_left + 1) -- Setting it back to the original value. Not really needed, but I'll leave it in
    return storage_table
end

local combinations = GenerateCombinations(usable_word)
for _, combination in ipairs(combinations) do
    print(combination)
end
print(string.format("Generated %i combinations.", #combinations))
